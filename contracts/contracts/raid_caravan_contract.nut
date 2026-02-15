this.raid_caravan_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		LastCombatTime = 0.0
	},
	function setEnemyNobleHouse( _h )
	{
		this.m.Flags.set("EnemyNobleHouse", _h.getID());
	}

	function create()
	{
		this.contract.create();
		this.m.Type = "contract.raid_caravan";
		this.m.Name = "Napad na Karawanę";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 800 * this.getPaymentMult() * this.getDifficultyMult() * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		local myTile = this.World.State.getPlayer().getTile();
		local enemyFaction = this.World.FactionManager.getFaction(this.m.Flags.get("EnemyNobleHouse"));
		local settlements = enemyFaction.getSettlements();
		local lowest_distance = 99999;
		local highest_distance = 0;
		local best_start;
		local best_dest;

		foreach( s in settlements )
		{
			if (s.isIsolated())
			{
				continue;
			}

			local d = s.getTile().getDistanceTo(myTile);

			if (d < lowest_distance)
			{
				lowest_distance = d;
				best_dest = s;
			}

			if (d > highest_distance)
			{
				highest_distance = d;
				best_start = s;
			}
		}

		this.m.Flags.set("InterceptStart", best_start.getID());
		this.m.Flags.set("InterceptDest", best_dest.getID());
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Napadnij na karawanę zmierzającą z %start% do %dest%",
					"Wróć do %townname%"
				];

				if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.IntroChance)
				{
					this.Contract.setScreen("Intro");
				}
				else
				{
					this.Contract.setScreen("Task");
				}
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);
				this.Flags.set("Survivors", 0);

				if (r <= 10)
				{
					this.Flags.set("IsBribe", true);
					this.Flags.set("Bribe1", this.Contract.beautifyNumber(this.Contract.m.Payment.Pool * (this.Math.rand(70, 150) * 0.01)));
					this.Flags.set("Bribe2", this.Contract.beautifyNumber(this.Contract.m.Payment.Pool * (this.Math.rand(70, 150) * 0.01)));
				}
				else if (r <= 15)
				{
					if (this.Contract.getDifficultyMult() >= 1.0)
					{
						this.Flags.set("IsSwordmaster", true);
					}
				}
				else if (r <= 20)
				{
					if (this.Contract.getDifficultyMult() >= 1.0)
					{
						this.Flags.set("IsUndeadSurprise", true);
					}
				}
				else if (r <= 25)
				{
					this.Flags.set("IsWomenAndChildren", true);
				}
				else if (r <= 35)
				{
					this.Flags.set("IsCompromisingPapers", true);
				}

				local enemyFaction = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse"));
				local best_start = this.World.getEntityByID(this.Flags.get("InterceptStart"));
				local best_dest = this.World.getEntityByID(this.Flags.get("InterceptDest"));
				local party = enemyFaction.spawnEntity(best_start.getTile(), "Karawana", false, this.Const.World.Spawn.NobleCaravan, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.getSprite("base").Visible = false;
				party.getSprite("banner").setBrush(enemyFaction.getBannerSmall());
				party.setMirrored(true);
				party.setVisibleInFogOfWar(true);
				party.setImportant(true);
				party.setDiscovered(true);
				party.setDescription("Karawana ze zbrojną eskortą, transportująca coś wartego ochrony pomiędzy osadami.");
				party.setFootprintType(this.Const.World.FootprintsType.Caravan);
				party.getFlags().set("IsCaravan", true);
				party.setAttackableByAI(false);
				party.getFlags().add("ContractCaravan");
				this.Contract.m.Target = this.WeakTableRef(party);
				this.Contract.m.UnitsSpawned.push(party);
				party.getLoot().Money = this.Math.rand(50, 100);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 2);
				party.getLoot().Ammo = this.Math.rand(0, 20);
				local r = this.Math.rand(1, 6);

				if (r == 1)
				{
					party.addToInventory("supplies/bread_item");
				}
				else if (r == 2)
				{
					party.addToInventory("supplies/roots_and_berries_item");
				}
				else if (r == 3)
				{
					party.addToInventory("supplies/dried_fruits_item");
				}
				else if (r == 4)
				{
					party.addToInventory("supplies/ground_grains_item");
				}
				else if (r == 5)
				{
					party.addToInventory("supplies/pickled_mushrooms_item");
				}

				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local move = this.new("scripts/ai/world/orders/move_order");
				move.setDestination(best_dest.getTile());
				move.setRoadsOnly(true);
				local despawn = this.new("scripts/ai/world/orders/despawn_order");
				c.addOrder(move);
				c.addOrder(despawn);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
					this.Contract.m.Target.setVisibleInFogOfWar(true);
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull())
				{
					if (this.Flags.get("IsWomenAndChildren"))
					{
						this.Contract.setScreen("WomenAndChildren1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsCompromisingPapers"))
					{
						this.Contract.setScreen("CompromisingPapers1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setState("Return");
					}
				}
				else if (this.Contract.isEntityAt(this.Contract.m.Target, this.World.getEntityByID(this.Flags.get("InterceptDest"))))
				{
					this.Contract.setScreen("Failure3");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Target))
				{
					this.onTargetAttacked(this.Contract.m.Target, false);
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);

					if (this.Flags.get("IsBribe"))
					{
						this.Contract.setScreen("Bribe1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsSwordmaster"))
					{
						this.Contract.setScreen("Swordmaster");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsUndeadSurprise"))
					{
						this.Contract.setScreen("UndeadSurprise");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.onTargetAttacked(_dest, true);
					}
				}
				else if (this.Time.getVirtualTimeF() >= this.Contract.m.LastCombatTime + 5.0)
				{
					local enemyFaction = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse"));
					enemyFaction.setIsTemporaryEnemy(true);
					this.Contract.m.LastCombatTime = this.Time.getVirtualTimeF();
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
				}
			}

			function onActorRetreated( _actor, _combatID )
			{
				if (!_actor.isNonCombatant() && _actor.getFaction() == this.Flags.get("EnemyNobleHouse") && this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("Survivors", this.Flags.get("Survivors") + 1);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Contract.m.LastCombatTime = this.Time.getVirtualTimeF();
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Wróć do %townname%"
				];
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("IsCompromisingPapers"))
					{
						if (this.Flags.get("IsExtorting"))
						{
							this.Contract.setScreen("CompromisingPapers2");
							this.World.Contracts.showActiveContract();
						}
						else
						{
							this.Contract.setScreen("CompromisingPapers3");
							this.World.Contracts.showActiveContract();
						}
					}
					else if (this.Flags.get("Survivors") == 0)
					{
						this.Contract.setScreen("Success1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Math.rand(1, 100) > this.Flags.get("Survivors") * 15)
					{
						this.Contract.setScreen("Failure1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("Failure2");
						this.World.Contracts.showActiveContract();
					}
				}
			}

		});
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationDefault);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "Negocjacje",
			Text = "[img]gfx/ui/events/event_45.png[/img]{Siadasz, gdy %employer% rozkłada przed tobą mapę. Przeciąga palcem po jednej z niedbale narysowanych dróg.%SPEECH_ON%Tą trasą jedzie karawana. Potrzebuję, by została napadnięta, ale czekaj!%SPEECH_OFF%Unosi palec.%SPEECH_ON%Ma to wyglądać na robotę zbójów. Nikt nie może się dowiedzieć, że zniszczenie nastąpiło z mojego rozkazu, rozumiesz?%SPEECH_OFF% | %employer% wyjaśnia, że potrzebuje zniszczyć karawanę. Pytasz, dlaczego szlachcic ma takie zadanie, ale jest skąpy w szczegóły. Jego główne żądanie jest proste: zniszcz karawanę i zabij wszystkich. Ma to wyglądać na robotę {zbójów | wandali | włóczęgów | zielonoskórych}, inaczej szlachcic mógłby zostać obciążony winą.%SPEECH_ON%Zrozumiałeś tę ostatnią część, najemniku? Oczywiście, że tak. Jesteś bystrym gościem, prawda?%SPEECH_OFF% | Siadasz, a %employer% bierze z półki wielką księgę i otwiera ją przed tobą. Jej szerokość obejmuje cały stół, a strony są wypełnione bardzo szczegółowymi mapami. Szlachcic wskazuje linię na jednej z nich.%SPEECH_ON%To trasa karawany, którą muszę zniszczyć. Nie zadawaj więcej pytań, po prostu ma zniknąć. Jedyne, o co proszę, to by wyglądało na robotę zbójów, zgoda? Nie może wyjść na jaw, że to ja wydałem rozkaz. Dasz radę?%SPEECH_OFF% | %employer% wita cię uściskiem dłoni, ale gdy próbujesz ją odzyskać, trzyma mocno.%SPEECH_ON%To, co zaraz powiem, nie może opuścić tego pokoju, rozumiesz?%SPEECH_OFF%Kiwasz głową i od razu odzyskujesz dłoń.%SPEECH_ON%Dobrze. Potrzebuję, żeby karawana została zniszczona, ale... nikt nie może się dowiedzieć, że to wy, najemnicy, to zrobiliście. Jeśli się dowiedzą, łatwo połączą to ze mną. Ma to wyglądać na robotę zbójów. Nikt nie może przeżyć, jasne?%SPEECH_OFF%Wzruszasz ramionami, jakby to było 'proste'.%SPEECH_ON%Dobrze, to się dogadaliśmy?%SPEECH_OFF% | Siadasz w gabinecie %employer%, a za tobą wchodzi nieznajomy i szepcze mu do ucha. Po chwili znika. %employer% wstaje i nalewa sobie kielich wina. Tobie nie proponuje.%SPEECH_ON%Potrzebuję, by karawana została zniszczona, ale musi to zostać zrobione dyskretnie. Nie może wyjść na jaw, że ja, %employer%, kazałem to zrobić. Nie, to robota zbójów, tych drani... rozumiesz? Jeśli tak, to pogadajmy o pieniądzach.%SPEECH_OFF% | Gdy siadasz, %employer% pyta, jak dobrze znasz robotę zbójów. Odpowiadasz, że ich życie nie różni się od twojego, tylko że jesteś mądrzejszy i masz ucho ludzi, którzy płacą lepiej niż rabowanie chłopów. %employer% kiwa głową.%SPEECH_ON%Dobrze, bo potrzebuję, żebyś udawał zbója przez jeden dzień i zniszczył karawanę. Nikt nie może przeżyć. Nikt nie może wiedzieć, że zrobił to najemnik. Rozumiesz? Jeśli tak, pogadajmy o liczbach.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Ile to jest dla ciebie warte? | Porozmawiajmy o zapłacie.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{To nie brzmi jak robota dla nas. | Nie sądzę.}",
					function getResult()
					{
						this.World.Contracts.removeContract(this.Contract);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Bribe1",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_41.png[/img]{Gdy zbliżacie się do karawany, jeden ze strażników dostrzega was i wszyscy dobywają broni. Mężczyzna, krzycząc i biegnąc z uniesionymi rękami, prosi, by wszyscy opuścili broń. W dłoni trzyma sakiewkę ciężką od %bribe% koron i mówi, że możecie ją wziąć, jeśli po prostu pozwolicie im odejść. Głośno zastanawiasz się, czemu miałbyś brać łapówkę, skoro mógłbyś ich wszystkich zabić i i tak ją wziąć. Mężczyzna wzrusza ramionami.%SPEECH_ON%Cóż, oszczędziłoby to kłopotu z zabijaniem nas, bo nie poddamy się bez walki. Weź i odejdź, najemniku.%SPEECH_OFF% | Gdy twoi ludzie podchodzą do karawany, jeden ze strażników dostrzega was i dmie w róg, alarmując resztę. Wkrótce cały uzbrojony oddział stoi przed tobą gotowy do walki. Przywódca taboru przechodzi przez ich linię z uniesionymi rękami.%SPEECH_ON%Opuścić broń, ludzie! Najemniku, mam dla ciebie propozycję. Weź tę sakiewkę z %bribe% koron i odejdź, a nikt nie musi tu ginąć.%SPEECH_OFF%Otwierasz usta, by odpowiedzieć, ale mężczyzna unosi palec i mówi dalej.%SPEECH_ON%Hej, pomyśl rozsądnie. Nie masz już na nas przewagi, a tych ludzi zatrudniłem, by chronili wozy, nie bez powodu - to zabójcy, tacy jak ty.%SPEECH_OFF% | Gdy twoi ludzie podchodzą, zniszczenie karawany wydaje się przesądzone. Niestety widzisz, jak jeden z najemników potyka się, ślizga stopą po toczącym się konarze i stacza się w dół niewielkiego zbocza. Zamieszanie jest dość głośne, by zaalarmować cały tabor, i widzisz, jak uzbrojeni strażnicy wypływają naprzeciw. Ich porucznik biegnie między dwoma oddziałami z rękami w górze.%SPEECH_ON%Zaczekajcie. Zaczekajcie. Zanim zaczniemy to mordowanie i rzeź, zamieńmy kilka słów, dobrze? Mam tu %bribe% koron.%SPEECH_OFF%Mężczyzna unosi sakiewkę i macha nią w twoją stronę.%SPEECH_ON%Weź to, odejdź, i wszyscy pójdziemy w swoją stronę. Nie trzeba, by ludzie stali sobie na drodze, prawda? Powiedziałbym, że to bardzo dobra oferta, najemniku, bo nie masz już po swojej stronie skradania - teraz będzie człowiek na człowieka. To jak?%SPEECH_OFF% | Ledwie sądzisz, że twoi ludzie zaraz rozpoczną szturm na karawanę, strażnik pilnujący wozów dostrzega ich. Pędzi do dzwonu alarmowego, uderzając w niego głośno, gdy %randombrother% roztrzaskuje mu czaszkę. Niestety wielu kompanów strażnika wypada z bronią w rękach. Ich dowódca jest przy nich, wstrzymując rozkaz natarcia.%SPEECH_ON%Hej, ludzie! Jeszcze nie. Porozmawiajmy, może, o mniej... brutalnym zakończeniu tego spotkania.%SPEECH_OFF%Spogląda na wgniecioną głowę strażnika.%SPEECH_ON%Dla reszty z nas, rzecz jasna. Mam tu w ręku %bribe% koron. Są twoje, zasadzko, skrytobójco, jakkolwiek się nazywasz, jeśli po prostu je weźmiesz i odejdziesz. I radzę, byś tak zrobił - nie masz już nad nami przewagi, a za tych ludzi zapłaciłem niemało, by strzegli moich towarów, rozumiesz?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{Niech tak będzie. Oddaj korony. | Uczciwa oferta, przyjmiemy ją.}",
					function getResult()
					{
						return "Bribe2";
					}

				},
				{
					Text = "To nic osobistego, ale ta karawana spłonie. A wy razem z nią.",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Bribe2",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_41.png[/img]{Kiedy zaczynasz odchodzić, przywódca karawany łapie cię za ramię.%SPEECH_ON%Hej, ciekawi mnie pewna rzecz, a założę się, że masz coś, co zaspokoi tę ciekawość.%SPEECH_OFF%Z wściekłością wyszarpujesz ramię z jego uścisku. Przeprasza, lecz szybko przechodzi do pytania.%SPEECH_ON%Chciałbym wiedzieć, kto cię przysłał. Jak brzmi dodatkowe %bribe2% koron za takie informacje?%SPEECH_OFF% | Przywódca karawany zatrzymuje cię, zanim zdołasz odejść.%SPEECH_ON%Zastanawiam się nad czymś, najemniku, i wiem, że znasz odpowiedź: kto cię przysłał?%SPEECH_OFF%Rozglądasz się. On się śmieje i klepie cię po ramieniu.%SPEECH_ON%Oczywiście nie wezmę odpowiedzi za darmo. Jak brzmi dodatkowe %bribe2% koron w tej sakiewce? Za kilka słów, które składają się na to, co zwą nazwiskiem. Więc jak, podasz mi to imię, najemniku?%SPEECH_OFF% | Przywódca woła cię, nim zdołasz odejść. Ma skrzyżowane ramiona, a stopą bezmyślnie kopie kamyki.%SPEECH_ON%Wiesz, nie mogę cię tak po prostu puścić. Jest pewna dość istotna informacja, którą chciałbym poznać i jestem gotów dorzucić %bribe2% koron do tej sakiewki, by się jej dowiedzieć.%SPEECH_OFF%Rozglądasz się, upewniając się, że to nie zasadzka. Potem odwracasz się do niego i kiwasz głową.%SPEECH_ON%Chcesz wiedzieć, kto mnie przysłał.%SPEECH_OFF%Przywódca szczerzy zęby i splata dłonie.%SPEECH_ON%Chłopcze, szybko się uczysz! Tak, właśnie!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{Zatem oddaj korony. | W porządku, choć to teraz nie robi już różnicy. | Dobra umowa stała się teraz jeszcze słodsza.}",
					function getResult()
					{
						return "Bribe3";
					}

				},
				{
					Text = "Nie zdradzę w ten sposób naszej reputacji, odchodzimy.",
					function getResult()
					{
						return "Bribe4";
					}

				}
			],
			function start()
			{
				this.World.Assets.addMoney(this.Flags.get("Bribe1"));
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail * 2);
				this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("Bribe1") + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "Bribe3",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_41.png[/img]{Bierzesz dodatkowe korony, chowasz je i podajesz przywódcy nazwisko: %employer%. Przetacza je na języku jak zatruty orzech.%SPEECH_ON%%employer%. %employer%! Phi, to nazwisko. %employer%, jakby... cóż, nie będę cię zanudzał, bo aż mnie nosi, by zejść z językiem do rynsztoka. Dziękuję, najemniku, i żegnam.%SPEECH_OFF%Kiwasz głową i odchodzisz. | Chowając dodatkowe korony, mówisz przywódcy słowo dnia: %employer%. Mężczyzna śmieje się na jego dźwięk i wielokrotnie kiwa głową, jakby od dawna się tego spodziewał.%SPEECH_ON%Dobra robota, najemniku. Co za dzień, prawda? Najpierw przychodzisz, by przebić mnie mieczem, a kilka minut później rozstajemy się w tak dobrych stosunkach. Naprawdę jesteś człowiekiem interesu. Szkoda, że tę zdolność umieściłeś za ostrzem, a nie za piórem. Żegnaj i niech cię los prowadzi.%SPEECH_OFF% | {Za grosz, to za talara. | Za cal, to za milę.} Przyjmujesz ofertę i wygadasz wszystko o poczynaniach %employer%. Przywódca karawany kiwa poważnie głową.%SPEECH_ON%Wiesz, my, ludzie interesu, nie dzierżymy broni jak ty, ale uwierz mi, u nas też jest bezwzględnie. Powodzenia, najemniku.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zapłata bez konieczności zabijania. Mógłbym się do tego przyzwyczaić.",
					function getResult()
					{
						this.World.Contracts.removeContract(this.Contract);
						return 0;
					}

				}
			],
			function start()
			{
				this.World.Assets.addMoney(this.Flags.get("Bribe2"));
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail * 2);
				this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().set("Betrayed", true);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("Bribe2") + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "Bribe4",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_41.png[/img]{Mówisz mu, żeby się odczepił. I tak miał już dość szczęścia. Mężczyzna kiwa głową, zgadzając się, choć zwężone spojrzenie mówi wszystko o twojej odmowie. | Kręcisz głową.%SPEECH_ON%Puszczę was, ale nie mogę posunąć się tak daleko. Wciąż potrzebuję zlecenia od %employer%, rozumiesz?%SPEECH_OFF%Mężczyzna kiwa głową.%SPEECH_ON%Mądra decyzja, choć oczywiście zła dla mnie. Tak, rozumiem, najemniku. Niech starzy bogowie towarzyszą ci w podróży. Obyśmy spotkali się znowu, lecz w lepszych okolicznościach!%SPEECH_OFF% | Zdrada %employer% to pewnie kiepski pomysł i mówisz mu to wprost. Kiwając głową, rozumie.%SPEECH_ON%No cóż, dobrze. Nie mogę cię winić, że trzymasz te karty przy sobie, ale do diabła, wolałbym, byś je jednak odkrył. Powodzenia, najemniku.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wyruszamy!",
					function getResult()
					{
						this.World.Contracts.removeContract(this.Contract);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Swordmaster",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_35.png[/img]{Gdy szykujecie się do ataku na karawanę, %randombrother% podchodzi i wskazuje jednego z ludzi w taborze.%SPEECH_ON%Wiesz, kto to?%SPEECH_OFF%Kiwasz głową, że nie.%SPEECH_ON%To %swordmaster%.%SPEECH_OFF%Mrużysz oczy, by lepiej go widzieć, i widzisz tylko zwyczajnego człowieka. Najemnik wyjaśnia, że to słynny mistrz miecza, który zabił niezliczoną liczbę ludzi. Prycha i spluwa.%SPEECH_ON%Nadal chcesz atakować?%SPEECH_OFF% | Przez szkło wypatrujesz karawanę i dostrzegasz znajomą twarz: %swordmaster%. Człowieka, którego widziałeś kilka lat temu na turnieju rycerskim w %randomtown%. Jeśli dobrze pamiętasz, wygrał z ręką związaną za plecami. Każdy, kto spotkał go pieszo, ginął szybko, gdy prezentował mistrzostwo miecza. Ten facet jest bardzo groźny i należy podejść do niego ostrożnie. | Zwiadując tabor, dostrzegasz twarz, którą już widziałeś. %randombrother% dołącza do ciebie, skubiąc nożem paznokcie.%SPEECH_ON%To %swordmaster%, mistrz miecza. W tym roku zabił dwudziestu ludzi.%SPEECH_OFF%Za tobą rozlega się okrzyk.%SPEECH_ON%Słyszałem o pięćdziesięciu! Może sześćdziesięciu. Czterdziestu pięciu, jeśli mamy być realistami...%SPEECH_OFF%Hmm, wygląda na to, że w straży tej karawany jest wyjątkowo niebezpieczny przeciwnik...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						this.Const.World.Common.addTroop(this.Contract.m.Target, {
							Type = this.Const.World.Spawn.Troops.Swordmaster
						}, true, this.Contract.getDifficultyMult() >= 1.1 ? 5 : 0);
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "UndeadSurprise",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_29.png[/img]{Wydajesz rozkaz szturmu i twoi ludzie pędzą przez trawę. Strażnicy karawany już biegną ku wam, ale wyglądają na przestraszonych. Za nimi podąża tłum jaskrawych stworów. Można śmiało powiedzieć, że to będzie najdziwniejsze spotkanie... | Gdy %companyname% pędzi ku karawanie z dobytymi broniami, kilku ludzi zwalnia, by wskazać, że z drugiej strony nadciąga jeszcze większa grupa. Gdy spoglądasz uważniej, dostrzegasz hordę nieumarłych, która zbiega się dokładnie w to miejsce! | Cóż, wygląda na to, że nie będzie tak łatwo, jak sądziłeś: gdy twoi ludzie rozpoczynają atak na karawanę, %randombrother% dostrzega od drugiej strony hordę upiornych nieumarłych! Nieumarli czy wkrótce umarli, bez znaczenia. Jesteś tu, by zrobić to, za co zapłacił %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						local enemyFaction = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse"));
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos(), true);
						p.CombatID = "UndeadSurprise";
						p.Music = this.Const.Music.UndeadTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.TemporaryEnemies = [
							this.Flags.get("EnemyNobleHouse")
						];
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							enemyFaction.getBannerSmall(),
							this.Const.ZombieBanners[0]
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Necromancer, 100 * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WomenAndChildren1",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Gdy twoi ludzie dobijają rannych, %randombrother% przyprowadza do ciebie szereg kobiet i dzieci. Unosisz miecz i pytasz, co to ma znaczyć.%SPEECH_ON%Wygląda na to, że zabrali ze sobą rodziny. Co mamy z nimi zrobić?%SPEECH_OFF%Jeśli ich wypuścisz, jest spora szansa, że rozniosą wieść o twojej obecności. Jeśli ich zabijesz... cóż, to koszt, który ciąży na umyśle... | Po zwycięstwie twoi ludzie rozchodzą się, by zebrać łupy i upewnić się, że każdy strażnik karawany jest martwy. Niestety nie wszyscy, których spotykasz, są martwi - i nie wszyscy to dorośli mężczyźni. Tłum kobiet i dzieci wynurza się z rumowiska walki, zbliżając się powoli z całą kruchością rannego psa. Niektórzy są we krwi, inni zostali osłonięci od walki. %randombrother% pyta, co z nimi zrobić.%SPEECH_ON%Pewnie powinniśmy ich puścić, bo... popatrz na nich. Ale... mogą coś powiedzieć. Wiesz, kobiety i ich wielkie języki.%SPEECH_OFF%Najemnik śmieje się nerwowo. Jedna z kobiet chwyta się za pierś.%SPEECH_ON%Nikomu nie powiemy, przysięgamy!%SPEECH_OFF% | Gdy walka ustaje, natykasz się na grupę kobiet i dzieci w ruinach karawany. Zbliżają się, jakby rozumiały, że gdyby tylko zaczęły uciekać, miałbyś powód, by je gonić. Jedna z kobiet, tuląc niemowlę do piersi, błaga.%SPEECH_ON%Proszę, wyrządziliście już tyle krzywdy i bólu. Nasi ojcowie, mężowie, bracia, już ich wszystkich zabiliście. Czy to nie dość? Pozwólcie nam odejść.%SPEECH_OFF%%randombrother% spluwa.%SPEECH_ON%Te dzieciaki widziały, co zrobiliśmy. Będą to pamiętać, jak dorosną. A te kobiety? Opowiedzą wszystkim. Tak już jest.%SPEECH_OFF%Spogląda na ciebie, gestem wskazując na do połowy uniesione ostrze.%SPEECH_ON%Co mamy zrobić, panie?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zapłacono nam, by nikt nie uszedł z życiem, więc tak też uczynimy.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-5);
						return "WomenAndChildren2";
					}

				},
				{
					Text = "Do diabła z tym - pozwólcie im odejść.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(2);
						this.Flags.set("Survivors", this.Flags.get("Survivors") + 3);
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WomenAndChildren2",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Kiwasz głową do %randombrother%. Ten podchodzi z bronią w dłoni i szybkim cięciem odcina kobiecie głowę. Z jej szyi tryska gejzer krwi, a dzieci są tak oślepione krwią, że nie widzą reszty ostrzy. Krzyki stopniowo cichną, gdy twoi bracia tną przerażony tłum, zamieniając ich liczbę w rozproszone skomlenia. Ludzie sprawdzają robotę, aż ofiary milkną, a cisza staje się lepka. | Szybkim ruchem dłoni wydajesz rozkaz. %randombrother% nie potrzebuje chwili, by wbić ostrze w twarz dziecka, przybijając je do łona matki, po czym tnie w górę, odbierając jej życie. Reszta ludzi rozchodzi się, część niechętnie, inni z niemal nabożną skrupulatnością.\n\n Gdy powietrze wypełniają przeraźliwe krzyki, masz wrażenie, że niektórzy najemnicy tną i sieką tylko po to, by zagłuszyć hałas w głowach. Przemoc pochłania wszystko, orgia szaleństwa, o której nie wiesz, czy jest szczytem czy dnem ludzkich czynów, bo w tym wydarzeniu ginie wszelki sens, a słów do jego opisania jeszcze nie ma w twojej mowie ani w żadnej, czy to przodków, czy poza ledwie tlącym się rozumieniem tego, co widzi twoje oko. To po prostu się dzieje. | Niestety nikt nie może przeżyć. Wydajesz rozkaz, a najemnicy biorą się do roboty. Kobieta podchodzi, jakby źle cię usłyszała, i pyta o drogę do najbliższego miasta. %randombrother% odpowiada, rozbijając jej głowę kamieniem. Przerażone dzieci rozpierzchają się zygzakiem, przypominając ci polowania na króliki z dawnych lat. Najszybsi najemnicy ruszają w pogoń, podczas gdy reszta zostaje, by szybko rozprawić się z rodzicami. To naprawdę makabryczny widok.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Cóż, niezbyt piękna robota, ale za to nam płacą.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CompromisingPapers1",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Gdy karawana płonie, twoi ludzie przeszukują zgliszcza. %randombrother% podchodzi do ciebie z papierami w dłoni.%SPEECH_ON%To może pana zainteresować.%SPEECH_OFF%Rozwijasz jeden z nich i czytasz. Wygląda na to, że %employer% miał bardzo, bardzo ukryty powód, by zaatakować ten tabor. Byłoby szkoda, gdyby ktoś poznał te szczegóły... | Wozy wciąż płoną, a ty trafiasz na drewnianą skrzynię i kopniakiem ją otwierasz. Zwoje wyskakują, rozwijają się i rozlatują na wietrze. Łapiesz jeden i czytasz. To raport o dochodach - lub ich braku - w posiadłościach %employer%. Wygląda na to, że miał ujawnić jego finansową kruchość. Gdybyś chciał, mógłbyś to wykorzystać przeciwko niemu... | W ruinach karawany znajdujesz skrytkę z papierami. Jeden ze zwojów ujawnia coś o %employer%, co najpewniej wiedział, że jedzie z wozami. To musi być powód, dla którego kazał ci zaatakować tabor... a można by to także użyć przeciwko niemu. Raczej nie spodziewał się, że trafi to w twoje ręce. W końcu jesteś tylko głupim najemnikiem...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Spalić ich razem z resztą.",
					function getResult()
					{
						this.Flags.set("IsCompromisingPapers", false);
						this.Contract.setState("Return");
						return 0;
					}

				},
				{
					Text = "Oddamy ich zleceniodawcy jako dowód lojalności.",
					function getResult()
					{
						this.Flags.set("IsCompromisingPapers", true);
						this.Contract.setState("Return");
						return 0;
					}

				},
				{
					Text = "Nasz pracodawca będzie nam musiał za nie dodatkowo zapłacić.",
					function getResult()
					{
						this.Flags.set("IsCompromisingPapers", true);
						this.Flags.set("IsExtorting", true);
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CompromisingPapers2",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_63.png[/img]{Wracasz do %employer% i unosisz papiery. Niemal natychmiast rozpoznaje pieczęć na jednym ze zwojów.%SPEECH_ON%Co... co to jest?%SPEECH_OFF%Opuszczasz papiery i już masz wyjaśnić, gdy mężczyzna rzuca się, próbując je wyrwać. Nie trafia, bo cofasz rękę. Prostuje się, jakby odzyskiwał panowanie.%SPEECH_ON%Dobrze, najemniku. Widzę, do czego to zmierza. Ile jeszcze chcesz?%SPEECH_OFF%Za zamkniętymi drzwiami dobijacie targu. | %employer% wita twój powrót, odwracając się z dwoma kubkami wina w dłoniach, ale jego uśmiech szybko gaśnie.%SPEECH_ON%Co masz w ręku? Skąd to wziąłeś?%SPEECH_OFF%Wpychasz jeden z obciążających papierów i kiwasz głową.%SPEECH_ON%Myślę, że doskonale wiesz, skąd. I myślę, że wiesz, dokąd to zmierza. Teraz... porozmawiajmy o interesach, tak?%SPEECH_OFF%Mężczyzna wypija jeden kubek, potem drugi.%SPEECH_ON%Tak. Dobrze. Zamknij drzwi, dobrze?%SPEECH_OFF% | Wchodzisz do pokoju %employer% i rzucasz obciążające papiery na jego biurko. Patrzy na nie, po czym się śmieje.%SPEECH_ON%Jaki błąd!%SPEECH_OFF%Gniecie papiery i wciska je pod stół. Śmiejesz się i wyciągasz kolejny zestaw zwojów.%SPEECH_ON%Za kogo mnie masz?%SPEECH_OFF%Mężczyzna szybko wyciąga schowane notatki i gapi się na nie. Uświadamia sobie, że włożyłeś tylko jedną stronę, a reszta to puste kartki. Szczerząc zęby, przedstawiasz warunki.%SPEECH_ON%Skoro wiem, jak są dla ciebie ważne, porozmawiajmy o interesach, by WSZYSTKIE mogły do ciebie wrócić, dobrze?%SPEECH_OFF%Mężczyzna siada ponuro i kiwa głową. Wyciąga osobistą sakiewkę z koronami i kładzie ją na biurku, po czym wskazuje wejście.%SPEECH_ON%Proszę, zamknij drzwi.%SPEECH_OFF% | Gdy wracasz, %employer% od razu zauważa pieczęć na papierach, które przyniosłeś. W pokoju ma kilku strażników, ale szybko ich wyprasza, każąc im gonić króliki z ogrodów. Zamykając drzwi, odwraca się do ciebie.%SPEECH_ON%Widzę, że mnie przyłapano.%SPEECH_OFF%Kiwasz głową. Mężczyzna oblizuje wargi i kiwa głową w odpowiedzi.%SPEECH_ON%Dobrze. Nic z tych papierów nie może opuścić tego pokoju. Ile chcesz?%SPEECH_OFF%Siadasz na krawędzi stołu, kładziesz papiery obok siebie i splatasz dłonie. Z uśmiechem odpowiadasz.%SPEECH_ON%Wszystko jest warte tyle, ile kupujący chce za to zapłacić, czyż nie, panie?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Wreszcie dobra zapłata.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail * 2, "Wymuszone pieniądze");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() * 2 + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "CompromisingPapers3",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_63.png[/img]{Wracasz do %employer%, a on odwraca się do ciebie, wyraźnie wściekły.%SPEECH_ON%Wiesz, że ludzie mówią o tym, co zrobiłeś, prawda?%SPEECH_OFF%Uśmiechasz się i unosisz kompromitujące papiery.%SPEECH_ON%Wolisz, by mówili o tym?%SPEECH_OFF%Mężczyzna prawie wzdycha, po czym opada na krzesło.%SPEECH_ON%Dobrze, szantażujesz mnie?%SPEECH_OFF%Kładziesz papiery na jego stole i machasz ręką.%SPEECH_ON%Myślałem o tym, ale nie chcę gryźć ręki, która karmi, tylko dlatego, że tym razem trzyma coś smakowitego.%SPEECH_OFF% | %employer% wzywa cię do pokoju.%SPEECH_ON%Chłopi gadają o tobie. Ludzie z karawany uciekli i, skoro jeszcze oddychają, uznali za stosowne opowiedzieć o tym, co przeżyli.%SPEECH_OFF%Kiwasz głową.%SPEECH_ON%To całkiem zrozumiałe.%SPEECH_OFF%Mężczyzna warczy i wskazuje palcem, ale ty unosisz kompromitujące papiery. Zastyga w napiętej ciszy.%SPEECH_ON%Ja... rozumiem... Chcesz więcej pieniędzy?%SPEECH_OFF%Rzucasz mu papiery.%SPEECH_ON%Nie. Ty zapominasz o jednej mojej wadzie, a ja zapominam o jednej twojej. Uczciwie, prawda?%SPEECH_OFF%Mężczyzna pospiesznie chowa papiery do płaszcza i kiwa głową. | Zastajesz %employer% przy ogrodzie. Kilku strażników stoi w oddali i wyobrażasz sobie, że jeden z kręcących się chłopów to przebrany strażnik.%SPEECH_ON%Najemniku! Dobrze cię widzieć, z wyjątkiem jednej rzeczy.%SPEECH_OFF%Woła cię bliżej i ścisza głos.%SPEECH_ON%Puściłeś kilku ludzi z tej karawany. Nie pamiętam, by to było częścią umowy.%SPEECH_OFF%Unosisz kompromitujące papiery.%SPEECH_ON%Tego też nie było w umowie.%SPEECH_OFF%%employer% odchyla się, po czym opanowuje, by jego strażnicy niczego nie podejrzewali.%SPEECH_ON%Dobrze, ja biorę te papiery, a zapominam o całej historii z tym, że ktoś przeżył, zgoda?%SPEECH_OFF%Podajesz mu papiery.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Zapłata w pełni zasłużona.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Dostarczyłeś kompromitujące dokumenty");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Wracasz do %employer% z wieścią o sukcesie. Wita cię serdecznie - z sakiewką ciężką od koron.%SPEECH_ON%Dobra robota, najemniku. Czy, eee, widziałeś tam coś jeszcze?%SPEECH_OFF%To dziwne pytanie, ale go nie drążysz. Mówisz, że wszystko poszło dokładnie tak, jak wskazują rezultaty. Mężczyzna kiwa głową i szybko dziękuje, po czym wraca do pracy. | %employer% stoi przy oknie, gdy wracasz. Pije kielich wina, miesza je w czarze i w ustach.%SPEECH_ON%Moje małe ptaszki mówią, że karawana została zniszczona. Czy śpiewają prawdę?%SPEECH_OFF%Kiwasz głową i potwierdzasz. Podaje ci skrzynię z koronami, dziękuje za służbę i wraca do okna. Zanim wyjdziesz, dostrzegasz z boku jego krzywy uśmiech. | %employer% głaszcze psa, gdy wracasz. Jego dłoń drży na sierści.%SPEECH_ON%Rozumiem, że tabor został zniszczony?%SPEECH_OFF%Opowiadasz szczegóły. Kiwając głową, zatrzymuje dłoń.%SPEECH_ON%Czy przypadkiem... znalazłeś coś interesującego?%SPEECH_OFF%Myślisz, ale nie przychodzi ci do głowy nic niezwykłego. Mężczyzna uśmiecha się i wraca do głaskania psa.%SPEECH_ON%Dziękuję za usługi, najemniku.%SPEECH_OFF% | %employer% pisze, gdy wchodzisz do jego pokoju. Upuszcza pióro i szybko wstaje.%SPEECH_ON%A więc zniszczona? Karawana, to znaczy.%SPEECH_OFF%Składasz raport z twoich usług. Śmieje się i klaszcze w dłonie.%SPEECH_ON%Znakomicie! Znakomicie, najemniku! Nie masz pojęcia, co twoja praca dziś dla mnie zrobiła. Oczywiście zapłata, jak obiecano...%SPEECH_OFF%Podaje sakiewkę z %reward_completion% koron. Wszystko się zgadza, ale zastanawiasz się, czemu mężczyzna jest tak rozradowany czymś tak pozornie zwyczajnym... czy coś przeoczyłeś? | %employer% rozmawia z radą, gdy wracasz. Odprawia ich. To dziwny widok - patrzeć, jak potężne postacie ustępują miejsca obdartemu najemnikowi. Stajesz odrobinę wyżej, gdy zdajesz relację ze zniszczenia karawany.%SPEECH_ON%Dziękuję, najemniku. Takiej wieści oczekiwałem. I twoja zapłata, rzecz jasna...%SPEECH_OFF%Wciąga na biurko drewnianą skrzynię i przesuwa ją w twoją stronę. Jest na tyle ciężka, że zostawia ślad.%SPEECH_ON%%reward_completion% koron, jak ustaliliśmy.%SPEECH_OFF%Zastanawiasz się, czemu szlachcic odprawia radę, by rozmawiać z najemnikiem, ale nie drążysz sprawy.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "W pełni zasłużona zapłata.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Zniszczyłeś karawanę");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{Wracasz i zastajesz %employer% przy biurku, złożone dłonie przed sobą, kciuki niemal wciśnięte w czoło. Gdy zaczyna mówić, ręce opadają.%SPEECH_ON%Pozwoliłeś... im żyć...%SPEECH_OFF%Unosisz palec i tłumaczysz: nie wszyscy przeżyli.%SPEECH_ON%Na nieskończoną moc starych bogów, po co ja cię w ogóle nająłem?%SPEECH_OFF%Zamyśla się, potem wzrusza ramionami.%SPEECH_ON%Dobrze, dam ci połowę tego, na co się umawialiśmy. W końcu tabor zniszczyłeś, trzeba ci to przyznać.%SPEECH_OFF% | %employer% wita twój powrót z nogami na biurku, spod ubłoconych butów kapie błoto.%SPEECH_ON%No dobrze, najemniku, wyjaśnij mi, po co cię wynająłem?%SPEECH_OFF%Rozkłada ręce, jakby mówił: no proszę. Mówisz, że miałeś zniszczyć karawanę i nie zostawić świadków. Mężczyzna unosi palec.%SPEECH_ON%Powtórz tę ostatnią część.%SPEECH_OFF%Powtarzasz. Mężczyzna uśmiecha się, zadowolony z siebie, ale uśmiech kwaśnieje na wieść o twojej porażce.%SPEECH_ON%Dobrze, nie zrobiłeś tego, o co prosiłem. W porządku. Zrobiłeś... część, przypuszczam. Karawana jest zniszczona...%SPEECH_OFF%Wzrusza ramionami i rzuca ci sakiewkę. To połowa tego, co ci się należało. Lepsze to niż nic. | %employer% rozmawia z gwardzistami, gdy wracasz. Odprawia ich, choć jeden kręci się tuż za drzwiami, niemal zaglądając do środka. Wysuwasz jedno z krzeseł %employer%, ale każe ci stać.%SPEECH_ON%To będzie krótko. Nie zrobiłeś wszystkiego, o co prosiłem, najemniku. Ludzie mówią, mówią o tobie. Jak mają mówić, skoro kazałem ci zabić wszystkich świadków? Dziwne, prawda? Podejrzewam, że dlatego, że ich nie zabiłeś, czyli nie zrobiłeś tego, o co prosiłem.%SPEECH_OFF%Zaciera dwa knykcie o czoło.%SPEECH_ON%Dobrze, tak to zrobimy. Dam ci połowę tego, na co się umawialiśmy. Połowę tobie za zniszczenie karawany, połowę mnie, bo muszę zapłacić za tuszowanie sprawy. Mam nadzieję, że ci to pasuje.%SPEECH_OFF%Strażnik spogląda złowrogo. Kiwasz głową i bierzesz zapłatę. | %employer% macha, byś wszedł. Stoi ze skrybą, który wygląda, jakby miał zaraz spisać historię. Zleceniodawca krzyżuje ramiona.%SPEECH_ON%Ludzie mówią o tym, co zrobiłeś...%SPEECH_OFF%Wskazuje na skrybę, który zaskakująco nie zaczyna pisać.%SPEECH_ON%Musiałem zapłacić, by zamknąć usta, rozumiesz? To oznacza, że dostaniesz tylko połowę tego, co ustaliliśmy.%SPEECH_OFF%Starszy skryba szczerzy zęby. Zauważasz pierścień na jego palcu, wygląda na świeżo wykuty. %employer% prawie się krzywi, ale skryba nie pisze, więc uznajesz to za dobry znak. Bierzesz zapłatę i odchodzisz. | Grupa uśmiechniętych mężczyzn wychodzi z pokoju %employer%, gdy przychodzisz. Prosi, byś zamknął drzwi, po czym od razu przechodzi do rzeczy.%SPEECH_ON%Rozpoznajesz te twarze? To ludzie, którzy dowiedzieli się, co zrobiłeś. Wiesz, ile koron kosztowało mnie zamknięcie ich ust? Wiesz, skąd te korony się wzięły?%SPEECH_OFF%Wzruszasz ramionami. Mężczyzna mówi dalej.%SPEECH_ON%Z twojej zapłaty, oczywiście. Dostaniesz tylko połowę. Rozumiesz, czemu?%SPEECH_OFF%Kiwasz głową. Interes to interes. Gdy odwracasz się, by odejść, %employer% zatrzymuje cię.%SPEECH_ON%I nie waż się myśleć o zabiciu któregoś z tych ludzi, żeby odzyskać drugą połowę zapłaty, najemniku!%SPEECH_OFF%Cholera.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Mogło być gorzej...",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Nie zdołałeś zniszczyć karawany bez świadków");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() / 2 + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{Wracasz i zastajesz %employer% przy biurku, łokcie na krawędzi, przedramiona napięte, kciuki niemal wciśnięte w czoło. Gdy zaczyna mówić, ręce opadają.%SPEECH_ON%Pozwoliłeś... im żyć...%SPEECH_OFF%Unosisz palec i tłumaczysz: nie wszyscy przeżyli.%SPEECH_ON%Na nieskończoną moc starych bogów, po co ja cię w ogóle nająłem?%SPEECH_OFF%Zawiesza głos, po czym wybucha złością.%SPEECH_ON%Co mnie to obchodzi? Tyle ich puściłeś, że cała ta przeklęta wioska o tym gada. Wynoś się, zanim każę strażnikom cię wyprowadzić.%SPEECH_OFF% | Podeszwy butów %employer% witają twój powrót, gdy trzyma nogi na biurku. Zauważasz krew na jego butach.%SPEECH_ON%No więc, najemniku, wyjaśnij mi, po co cię wynająłem?%SPEECH_OFF%Rozkłada rękę, jakby mówił: no dalej. Mówisz, że miałeś zniszczyć karawanę i nie zostawić świadków. Mężczyzna unosi palec.%SPEECH_ON%Powtórz tę ostatnią część.%SPEECH_OFF%Powtarzasz. Mężczyzna uśmiecha się, zadowolony z siebie.%SPEECH_ON%Dobrze, nie zrobiłeś tego, o co prosiłem. Więc co tu robisz? Mam wezwać straż, czy wyjdziesz sam? Bo my już nie mamy ze sobą interesów.%SPEECH_OFF% | %employer% rozmawia z gwardzistami, gdy wracasz. Odprawia kilku, ale największemu każe zostać. Patrzy na ciebie, gdy wchodzisz.\n\nWysuwasz jedno z krzeseł %employer%, ale każe ci stać.%SPEECH_ON%To będzie krótko. Nie zrobiłeś wszystkiego, o co prosiłem, najemniku. Ludzie mówią, mówią o tobie. Jak mają mówić, skoro kazałem ci zabić wszystkich świadków? Dziwne, prawda? O ile pamiętam, martwy świadek w ogóle nie mówi, więc wnioskuję, że ci świadkowie żyją. A to nie było to, za co ci płaciłem. Więc zanim każę temu strażnikowi dobyć miecza i przebić cię nim na wylot, lepiej się odwróć i wynoś z mojego pola widzenia.%SPEECH_OFF% | Grupa uśmiechniętych mężczyzn wychodzi z pokoju %employer%, gdy przychodzisz. Prosi, byś zamknął drzwi, ale najpierw wchodzi strażnik. Wymienia z %employer% skinienie i spojrzenie, po czym zamykasz drzwi. Zleceniodawca mówi wprost.%SPEECH_ON%Rozpoznajesz tych ludzi, którzy właśnie stąd wyszli? To ci, którzy dowiedzieli się, co zrobiłeś. Wiesz, ile koron kosztowało mnie zamknięcie ich ust? Wiesz, skąd te korony się wzięły?%SPEECH_OFF%Wzruszasz ramionami. Mężczyzna mówi dalej.%SPEECH_ON%Z twojej zapłaty, oczywiście. Żeby pozamykać im gęby, musiałem zapłacić krocie.%SPEECH_OFF%Kiwasz głową. Interes to interes i w tym wypadku nie dostaniesz nic. Gdy odwracasz się, by odejść, %employer% zatrzymuje cię.%SPEECH_ON%I nie waż się myśleć o zabiciu któregoś z tych ludzi, żeby odzyskać zapłatę, najemniku!%SPEECH_OFF%Cholera.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Szlag niech trafi ten kontrakt!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Nie zdołałeś zniszczyć karawany bez świadków");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Failure3",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_75.png[/img]{Czekając na karawanę, spotykasz dwoje podróżnych idących od strony, z której powinien nadjechać konwój. Opowiadają szczegółowo o wozie, który bez wątpienia jest tym, na który miałeś polować. Nie ma sensu wracać do %employer%. | Wieści z drogi mówią, że karawana, na którą miałeś polować, wymknęła się i dotarła do celu. Kompania nie powinna fatygować się do %employer%.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Szlag niech trafi ten kontrakt!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Nie zdołałeś zniszczyć karawany");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"bribe",
			this.m.Flags.get("Bribe1")
		]);
		_vars.push([
			"bribe2",
			this.m.Flags.get("Bribe2")
		]);
		_vars.push([
			"start",
			this.World.getEntityByID(this.m.Flags.get("InterceptStart")).getName()
		]);
		_vars.push([
			"dest",
			this.World.getEntityByID(this.m.Flags.get("InterceptDest")).getName()
		]);
		_vars.push([
			"swordmaster",
			this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (this.World.FactionManager.isGreaterEvil())
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Target != null && !this.m.Target.isNull())
		{
			_out.writeU32(this.m.Target.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});

