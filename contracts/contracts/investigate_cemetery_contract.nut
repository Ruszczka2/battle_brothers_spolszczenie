this.investigate_cemetery_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		TreasureLocation = null,
		SituationID = 0
	},
	function setDestination( _d )
	{
		this.m.Destination = this.WeakTableRef(_d);
	}

	function create()
	{
		this.contract.create();
		this.m.Type = "contract.investigate_cemetery";
		this.m.Name = "Zabezpieczenie Cmentarzyska";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		if (this.m.Destination == null || this.m.Destination.isNull())
		{
			local myTile = this.World.State.getPlayer().getTile();
			local undead = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getSettlements();
			local lowestDistance = 9999;
			local best;

			foreach( b in undead )
			{
				local d = myTile.getDistanceTo(b.getTile());

				if (d < lowestDistance && (b.getTypeID() == "location.undead_graveyard" || b.getTypeID() == "location.undead_crypt"))
				{
					lowestDistance = d;
					best = b;
				}
			}

			this.m.Destination = this.WeakTableRef(best);
		}

		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		this.m.Payment.Pool = 550 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Zabezpiecz miejsce zwane " + this.Flags.get("DestinationName")
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
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				this.Contract.m.Destination.clearTroops();
				this.Contract.m.Destination.setLastSpawnTimeToNow();

				if (this.Contract.getDifficultyMult() < 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.m.Destination.setLootScaleBasedOnResources(100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 60 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				local r = this.Math.rand(1, 100);

				if (r <= 10 && this.World.Assets.getBusinessReputation() > 500)
				{
					this.Flags.set("IsMysteriousMap", true);
					this.logInfo("map");
					local bandits = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits);
					this.World.FactionManager.getFaction(this.Contract.m.Destination.getFaction()).removeSettlement(this.Contract.m.Destination);
					this.Contract.m.Destination.setFaction(bandits.getID());
					bandits.addSettlement(this.Contract.m.Destination.get(), false);
					this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.BanditRaiders, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				}
				else if (r <= 40)
				{
					this.logInfo("ghouls");
					this.Flags.set("IsGhouls", true);
					this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.Ghouls, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				}
				else if (r <= 70)
				{
					this.Flags.set("IsGraverobbers", true);
					this.logInfo("graverobbers");
					local bandits = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits);
					this.World.FactionManager.getFaction(this.Contract.m.Destination.getFaction()).removeSettlement(this.Contract.m.Destination);
					this.Contract.m.Destination.setFaction(bandits.getID());
					bandits.addSettlement(this.Contract.m.Destination.get(), false);
					this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.BanditRaiders, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				}
				else
				{
					this.logInfo("undead");
					this.Flags.set("IsUndead", true);
					this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.Zombies, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsUndead") && this.World.Assets.getBusinessReputation() > 500 && this.Math.rand(1, 100) <= 25 * this.Contract.m.DifficultyMult)
					{
						this.Flags.set("IsNecromancer", true);
						this.Contract.setScreen("Necromancer0");
						this.World.Contracts.showActiveContract();
					}

					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (!this.Flags.get("IsAttackDialogShown"))
				{
					this.Flags.set("IsAttackDialogShown", true);

					if (this.Flags.get("IsGhouls"))
					{
						this.Contract.setScreen("AttackGhouls");
					}
					else if (this.Flags.get("IsGraverobbers"))
					{
						this.Contract.setScreen("AttackGraverobbers");
					}
					else if (this.Flags.get("IsUndead"))
					{
						this.Contract.setScreen("AttackUndead");
					}
					else if (this.Flags.get("IsMysteriousMap"))
					{
						this.Contract.setScreen("MysteriousMap1");
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog();
				}
			}

		});
		this.m.States.push({
			ID = "Running_Necromancer",
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}

				this.Contract.m.BulletpointsObjectives = [
					"Zniszcz: " + this.Flags.get("DestinationName")
				];
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					this.Contract.setScreen("Necromancer3");
					this.World.Contracts.showActiveContract();
					this.Flags.set("IsNecromancerDead", true);
					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (!this.Flags.get("IsAttackDialogShown"))
				{
					this.Flags.set("IsAttackDialogShown", true);
					this.Contract.setScreen("Necromancer2");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog();
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Wróć do " + this.Contract.m.Home.getName()
				];
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("IsNecromancer"))
					{
						if (this.Flags.get("IsNecromancerDead"))
						{
							this.Contract.setScreen("Success3");
						}
						else
						{
							this.Contract.setScreen("Necromancer1");
						}
					}
					else if (this.Flags.get("IsUndead"))
					{
						this.Contract.setScreen("Success1");
					}
					else if (this.Flags.get("IsMysteriousMapAccepted"))
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							this.Contract.setScreen("Failure1");
						}
						else
						{
							this.Contract.setScreen("Failure2");
						}
					}
					else
					{
						this.Contract.setScreen("Success2");
					}

					this.World.Contracts.showActiveContract();
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% nerwowo chodzi w tę i z powrotem, co chwilę zatrzymując się, by zwrócić się do ciebie.%SPEECH_ON%Ludzie są wstrząśnięci! Groby na cmentarzu znaleziono otwarte i splądrowane. Jakiś prostak twierdzi, że to umarli wstają z grobów - zabobonna bzdura. To ewidentnie robota grabarzy, którzy mieli czelność przyjść do %townname% i nękać nas swoją chciwością!%SPEECH_OFF%Uderza pięścią w stół z wściekłości.%SPEECH_ON%Idź na cmentarz i zakończ ten problem raz na zawsze!%SPEECH_OFF% | %employer% opada na krzesło, śmiejąc się pod nosem.%SPEECH_ON%Nie panikuj, najemniku, ale powiadają, że grasuje duch! Tak, tak, miejscowi chłopi trują mi poranki opowieściami o duchach i goblinach. Twierdzą, że te domniemane stworzenia wywracają cmentarz do góry nogami, rabując groby, by powiększyć swoją armię, czy jakieś takie bzdury. To oczywiście robota ludzi z łopatami, którzy kradną z grobów biżuterię. Widziałem to już nie raz.%SPEECH_OFF%Spogląda na swoje dłonie i krótko chichocze.%SPEECH_ON%Tak czy inaczej, nie mogę tego zignorować, bo chłopi nie dadzą mi spokoju. Więc, żeby ich uspokoić, jesteś ty. Potrzebuję, żebyś poszedł na cmentarz i przegonił wszelkich rozrabiaków. Jak to zrobisz, to już twoja sprawa, ale sugeruję dobry kawałek stali, jeśli wiesz, co mam na myśli...%SPEECH_OFF% | %employer% ma na biurku mapę cmentarza. Połowa kwadratów jest zamalowana tuszem.%SPEECH_ON%Każdy kwadrat, który widzisz, został splądrowany. Co noc przychodzą, i co noc nie potrafię ich złapać. Jestem u kresu sił, więc postanowiłem skończyć z tym raz na zawsze. Chcę, żebyś poszedł na ten cmentarz i zabił każdego głupca, który rozkopuje groby. Zrozumiano?%SPEECH_OFF% | %employer% stoi przy oknie, wyglądając na zewnątrz i popijając miód. Zdaje się, że nie skupia się na niczym konkretnym i mówi, jakby zupełnie go to nie obchodziło.%SPEECH_ON%Grabarze rabują cmentarz. Znowu. Nie proszę cię o wiele, najemniku, tylko o to, byś tam poszedł i zakończył to głupie przedstawienie. Idź na cmentarz i zabij każdego grabarza, którego zobaczysz. Jasne? Dobrze.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "Porozmawiajmy o pieniądzach.",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "Nie jestem zainteresowany.",
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
			ID = "AttackGhouls",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_69.png[/img]{Chrupanie. Mlaszczenie. Dźwięk kogoś - lub czegoś - kto delektuje się posiłkiem. Przechodząc przez cmentarz, trafiasz na polanę pełną nachzehrerów. Kulą się nad szczątkami, które wyglądają na grabarzy, których szukałeś. Odrażające potwory powoli odwracają się ku tobie, a ich czerwone oczy rozszerzają się na widok świeżego mięsa. | Nagrobki przewracają się, gdy grupa nachzehrerów wspina się na nie. Wygląda na to, że urządziły sobie ucztę, a kilku wciąż ogryza jakieś ramię czy nogę, zapewne kończyny twoich domniemanych grabarzy. | Słyszysz przenikliwy krzyk i szybko skręcasz za róg mauzoleum, widząc nachzehrera wgryzającego się w kark mężczyzny. Bestia, z krwią tak pełną pyska, że wylewa się z nozdrzy, tylko rzuca na ciebie spojrzenie. Mniejsze nachzehrery otaczają go, wysuwając się do przodu, by dopilnować, że ich kolejny posiłek nie ucieknie...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AttackGraverobbers",
			Title = "Zbliżając się...",
			Text = "[img]gfx/ui/events/event_57.png[/img]{Grabarze są na miejscu, tak jak obiecano. Złapałeś ich w trakcie kopania, a twoi bracia przeskakują przez nagrobki z uniesioną bronią. | Wchodząc na cmentarz, znajdujesz grabarzy dokładnie tam, gdzie %employer% sądził, że będą. Oni widzą ciebie tak samo, jak ty ich. Twoi ludzie rozchodzą się z bronią, by odciąć drogę ucieczki. | Idąc między nagrobkami, słyszysz kilka głosów za mauzoleum. Gdy skręcasz za róg, widzisz grupę ludzi stojących nad opróżnionym grobem. Przed nimi leży otwarta trumna, a kilku wyciąga z niej biżuterię. Rozkazujesz ludziom szarżować. | %employer% miał rację: byli tu grabarze. Widzisz przewrócone groby i rozkopane mogiły. Ślady w błocie prowadzą cię do kopaczy, którzy szperają przy kolejnej robocie.%SPEECH_ON%Nie chcę wam przeszkadzać, chłopaki, ale %employer% płaci nieźle, żebyście zostali w ziemi.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AttackUndead",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_57.png[/img]{Cmentarz spowija mgła - albo gęsta miasma bijąca od zmarłych. Chwila... to są umarli! Do broni! | Spoglądasz na nagrobek z kopcem ziemi rozgrzebanej u podstawy. Plamy błota prowadzą dalej niczym okruchy. Nie ma łopat... nie ma ludzi... Podążając tropem, natrafiasz na hordę nieumarłych, jęczących i stękających... teraz wpatrujących się w ciebie nienasyconym głodem... | Mężczyzna stoi głęboko między rzędami nagrobków. Chwieje się, jakby miał zaraz zemdleć. %randombrother% podchodzi i kręci głową.%SPEECH_ON%To nie człowiek, panie. To nieumarły.%SPEECH_OFF%Gdy tylko kończy mówić, postać w oddali powoli się odwraca i w świetle okazuje się, że brakuje jej połowy twarzy. | Odkrywasz, że wiele grobów jest opróżnionych. Nie tylko opróżnionych, lecz rozkopanych od dołu. To nie robota grabarzy...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "MysteriousMap1",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_57.png[/img]{Wchodzisz na cmentarz i znajdujesz grabarzy tam, gdzie %employer% podejrzewał: po kolana w cudzej wieczności. Dobijając miecz, każesz im odłożyć biżuterię, którą próbują ukraść. Jeden z nich wstaje, podnosi ręce i zaczyna się tłumaczyć.%SPEECH_ON%Zanim nas zabijesz, mogę coś powiedzieć? Mamy mapę... wiem, brzmi jak kłamstwo, ale posłuchaj... Mamy mapę, która prowadzi do ogromnych skarbów. Puścisz nas, a oddam ci ją. Zabijesz nas i... nigdy jej nie zobaczysz. Co powiesz?%SPEECH_OFF% | Dokładnie jak podejrzewał %employer%, grabarze kręcą się pośród nagrobków. Zatrzymujesz ich w połowie kopania i pytasz, czy mają jakieś ostatnie słowa, zanim dołączą do swoich ofiar w błocie. Jeden z nich błaga o litość, twierdząc, że ma mapę skarbów i odda ją w zamian za życie całej grupy. | Natrafiasz na kilku mężczyzn próbujących wywalić drzwi mauzoleum. Uderzenie miecza o but zwraca ich uwagę.%SPEECH_ON%Dobry wieczór, panowie. %employer% mnie przysłał.%SPEECH_OFF%Jeden z nich upuszcza narzędzia.%SPEECH_ON%Zaczekaj chwilę! Mamy mapę... tak, mapę! Jeśli nas oszczędzisz, dam ci ją! Ale tylko wtedy, jeśli nas oszczędzisz! Jeśli nie... nigdy jej nie zobaczysz, rozumiesz?%SPEECH_OFF% | Zaskakujesz grabarzy, dobywając miecza, gdy wbijają łopaty w ziemię. Jeden z nich, wyczuwając, że zaraz dołączy do grobu, w którym stoi już jedna noga, zaczyna z tobą targ. Okazuje się, że mają mapę do tajemniczego skarbu. Wystarczy ich puścić, a oddadzą ci mapę. Jeśli ich zabijesz, to 'mapa' też zniknie i nigdy nie zobaczysz ani jej, ani skarbów, do których prowadzi.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zabić ich wszystkich!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				},
				{
					Text = "W porządku, oddaj mapę i możecie odejść żywi.",
					function getResult()
					{
						this.updateAchievement("NeverTrustAMercenary", 1, 1);
						local tile = this.Contract.getTileToSpawnLocation(this.World.State.getPlayer().getTile(), 8, 18, [
							this.Const.World.TerrainType.Shore,
							this.Const.World.TerrainType.Ocean,
							this.Const.World.TerrainType.Mountains
						], false);
						tile.clear();
						this.Contract.m.TreasureLocation = this.WeakTableRef(this.World.spawnLocation("scripts/entity/world/locations/undead_ruins_location", tile.Coords));
						this.Contract.m.TreasureLocation.onSpawned();
						this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).addSettlement(this.Contract.m.TreasureLocation.get(), false);
						this.Contract.m.TreasureLocation.addToInventory("loot/silverware_item");
						this.Contract.m.TreasureLocation.addToInventory("loot/silver_bowl_item");
						return "MysteriousMap2";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "MysteriousMap2",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_57.png[/img]{Może %employer% po prostu próbował zabić ludzi dla skarbu? To... ma sens, prawda? Postanawiasz puścić tych ludzi wolno w zamian za mapę, która pokazuje drogę do %treasure_location% %treasure_direction% stąd. | %employer% nic nie wspominał o tym, że ci ludzie mają mapę... może chciał to ukryć? Kto wie. Pokusa skarbu jest jednak zbyt silna i decydujesz się ich puścić w zamian za informacje. Ich mapa ujawnia %treasure_location%. Leży %treasure_direction% od miejsca, w którym stoisz. | Gdy byłeś dzieckiem, ciągle jeździłeś na poszukiwania skarbów. To... dziwnie ekscytujące. Nie wiesz czemu, ale pokusa powrotu do tej przygody sprawia, że puszczasz ich wolno. W zamian pokazują ci mapę, która ujawnia %treasure_location%, miejsce ukrytego skarbu... kto wie jakiego. Wiesz tylko, że leży %treasure_direction% od miejsca, w którym stoisz.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Oby było warto.",
					function getResult()
					{
						this.World.uncoverFogOfWar(this.Contract.m.TreasureLocation.getTile().Pos, 700.0);
						this.Contract.m.TreasureLocation.setDiscovered(true);
						this.World.getCamera().moveTo(this.Contract.m.TreasureLocation.get());
						this.Contract.m.Destination.fadeOutAndDie();
						this.Contract.m.Destination = null;
						this.Flags.set("IsMysteriousMapAccepted", true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Necromancer0",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_56.png[/img]{Po wybiciu wszystkich nieumarłych znajdujesz kawałek materiału, który w twojej dłoni świeci na fioletowo. Nie wiesz, czym jest, ale jakoś chcesz go zatrzymać. %randombrother% uważa to za głupie, ale to nie on dowodzi. | Po bitwie %randombrother% znajduje głowicę łopaty z wypalonym symbolem. Zastanawia się, czy %employer%, twój zleceniodawca, nie wie czegoś na ten temat. Zgadzasz się i zabierasz kawałek metalu, by sprawdzić, czy miejscowy potrafi go rozpoznać. | Gdy potwory padły, chowasz miecz i przeszukujesz pobojowisko. Znajdujesz dziwny talizman z piór kruka i skóry krowy. Chowasz go, licząc, że %employer%, twój zleceniodawca, będzie coś o nim wiedział.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Czas odebrać naszą zapłatę.",
					function getResult()
					{
						this.Flags.set("DestinationName", this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.NecromancerLair));
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Necromancer1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_63.png[/img]{Wracając do %employer% szybko wyjaśniasz, że nie było grabarzy, tylko grupa nieumarłych. Wygląda na wstrząśniętego, ale gdy pokazujesz znaleziony artefakt, zaciska usta i poważnie kiwa głową.%SPEECH_ON%To... to z %necromancer_location%. Myśleliśmy, że możemy to miejsce zignorować, ale chyba się myliłem. Idź tam, najemniku, i zakończ terror tej upiornej siedziby raz na zawsze!%SPEECH_OFF%Mężczyzna tonuje teatralność.%SPEECH_ON%Ach, i jestem gotów zapłacić ci dodatkowe %reward_completion% koron oprócz %reward_completion% koron za pierwotną robotę, oczywiście.%SPEECH_OFF% | Zastajesz %employer%a w gabinecie, poważnie siorbiącego z kielicha.%SPEECH_ON%Słyszałem już wieści. Umarli chodzą, oh, straszne nawet to wypowiedzieć!%SPEECH_OFF%Kiwasz głową i pokazujesz artefakt znaleziony na cmentarzu.%SPEECH_ON%Wiesz coś o tym?%SPEECH_OFF%Mężczyzna zerka na niego, jakby od razu wiedział, że go masz.%SPEECH_ON%Tak, to należy do %necromancer_location%. Myśleliśmy, że możemy zignorować zło z tamtego miejsca, ale... no cóż. Może tam pójdziesz? Może zniszczysz %necromancer_location% i uwolnisz nas od tego koszmaru? Oto twoja pierwotna zapłata, jak uzgodniliśmy, ale jeśli pomożesz nam z %necromancer_location%, dostaniesz dodatkowe %reward_completion% koron. Brzmi dobrze?%SPEECH_OFF% | Wchodzisz do pokoju %employer%a i z hukiem kładziesz artefakt na jego biurku. Odsuwa go dłonią.%SPEECH_ON%Skąd to masz?%SPEECH_OFF%Wskazując palcem, naciskasz na mężczyznę.%SPEECH_ON%Wiedziałeś o nieumarłych na cmentarzu?%SPEECH_OFF%Speszenie odwraca wzrok, po czym kiwa głową.%SPEECH_ON%Tak... wiedziałem. Oni i ten artefakt pochodzą z %necromancer_location%. Mieszka tam jakiś mroczny czarownik i od dłuższego czasu sprawia nam te... problemy. Proszę, możesz tam pójść i go zniszczyć? Oto zapłata za pierwotny kontrakt, ale zostaniesz sowicie wynagrodzony za pozbycie się tego przeklętego... kogoś. Powiedzmy... kolejne %reward_completion% koron?%SPEECH_OFF% | Wyjaśniasz %employer%owi, że na cmentarzu nie było grabarzy ani żadnych ludzi. Zanim zdąży coś powiedzieć, pokazujesz artefakt, trzymając go w świetle. Mężczyzna szybko się cofa.%SPEECH_ON%Odłóż to!%SPEECH_OFF%Jego krzyk, niczym ognisty głos, zapala artefakt i ten spala się bezboleśnie z twoich palców, zostawiając tylko wirujący popiół. %employer% chowa twarz w dłoniach.%SPEECH_ON%To z %necromancer_location%. Mieszka tam... nekromanta, pająk, który pociąga za sznurki, by martwi wstawali. Proszę, najemniku, idź tam i go zniszcz. Będą za to sowite łaski...%SPEECH_OFF%Przerywa, wyciągając sakiewkę z koronami.%SPEECH_ON%To za to, na co się pierwotnie zgodziliśmy. Ale jeśli zabijesz tego okropnego człowieka w %necromancer_location%, po powrocie będzie czekać na ciebie kolejne %reward_completion% koron.%SPEECH_OFF% | Przedstawiasz artefakt znaleziony na cmentarzu. %employer% wzdycha na sam jego widok, ale zaraz przybiera ponury wyraz twarzy.%SPEECH_ON%Powiem ci szczerze, najemniku. Niedaleko stąd, w %necromancer_location%, mieszka nekromanta.%SPEECH_OFF%Wyciąga sakiewkę z koronami i podaje ci ją.%SPEECH_ON%To za pierwotną robotę. Jednak, jeśli pójdziesz i zabijesz tego złego człowieka, oferuję kolejne %reward_completion% koron, wszystko, co zdołamy zebrać.%SPEECH_OFF%Opiera się i patrzy z wielką nadzieją, że przyjmiesz nowe warunki.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "W porządku, zapolujemy na tego Nekromantę.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Zabezpieczyłeś cmentarzysko");
						local tile = this.Contract.getTileToSpawnLocation(this.World.State.getPlayer().getTile(), 8, 15, [
							this.Const.World.TerrainType.Shore,
							this.Const.World.TerrainType.Ocean,
							this.Const.World.TerrainType.Mountains
						], false);
						tile.clear();
						this.Contract.m.Destination = this.WeakTableRef(this.World.spawnLocation("scripts/entity/world/locations/undead_necromancers_lair_location", tile.Coords));
						this.Contract.m.Destination.onSpawned();
						this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).addSettlement(this.Contract.m.Destination.get(), false);
						this.Contract.m.Destination.setName(this.Flags.get("DestinationName"));
						this.Contract.m.Destination.setDiscovered(true);
						this.Contract.m.Destination.clearTroops();
						this.Contract.m.Destination.setLootScaleBasedOnResources(115 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.Necromancer, 115 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());

						if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
						{
							this.Contract.m.Destination.getLoot().clear();
						}

						this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
						this.Contract.m.Home.getSprite("selection").Visible = false;
						this.Flags.set("IsAttackDialogShown", false);
						this.Contract.setState("Running_Necromancer");
						return 0;
					}

				},
				{
					Text = "Nie, kompania wystarczająco dużo już zrobiła.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Zabezpieczyłeś cmentarzysko");
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
			ID = "Necromancer2",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_57.png[/img]{To miejsce jest tak makabryczne, jak sobie wyobrażałeś, apogeum rozkładu i plugastwa. Jeszcze nie zauważyłeś nekromanty, więc lepiej posuwać się bardzo ostrożnie... | %necromancer_location% jest dokładnie tam, gdzie mówił %employer%. Znajdujesz ścieżkę z kości prowadzącą dalej. Niektóre z nich wciąż mają resztki mięsa, być może nieudane nekromanckie twory, które nie przeszły od śmierci do nieumarłych. Ignorując okropności, zaczynasz planować atak... | Miejsce takie jak %necromancer_location% jest tak zarośnięte wysoką trawą, chwastami i sczerniałymi drzewami, że nie potrzebowałoby nawet tablicy 'wstęp wzbroniony'. A jednak ją ma. To koszmar z kości, potworny znak poskładany z ludzi i zwierząt, spoglądający z krzyża, by odstraszać śmiałków. Ślimaki pełzają przez oczodoły, a po kończynach pulsują szlaki mrówek.\n\n %randombrother% podchodzi, wyraźnie niespokojny tym widokiem, i pyta, jak chcesz zaatakować. | Najpierw znajdujesz gryzonia z rozłożonymi kończynami, każda mała łapa przybita szpilką do deski. Potem jest pies, z głową kota. Przysiągłbyś, że to paskudztwo drgnęło, ale może tylko ci się wydaje. A potem... ludzie. Brak ci słów, by opisać, co się z nimi stało, ale to wieża okrucieństwa i apogeum zbrodni.\n\n%randombrother% staje obok ciebie.%SPEECH_ON%Skończmy z tym szaleńcem.%SPEECH_OFF%Tak, skończmy. Pytanie brzmi: jak zaatakować najpierw?}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Przygotować się do ataku.",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Necromancer3",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_56.png[/img]{%necromancer_location% zostało oczyszczone. Prawie czujesz się święty, ale potem pamiętasz, że zrobiłeś to dla zapłaty, a nie z jakiegoś szlachetnego powodu. I tak przecież nie wolisz tych drugich. | Nekromanta nie żyje, a w dłoni trzymasz jego głowę. Teraz czas powiedzieć temu głupcowi, %employer%owi, by zapłacił ci to, co się należy. | To nie była łatwa walka, ale %necromancer_location% zostało zniszczone. Nekromanta padł i jak każdy człowiek upadł w stos własnego mięsa i kości. Dziwne, że jego sztuczki potrafiły wskrzeszać zmarłych, ale nie działały, gdy sam był martwy. Dziwne, ale i szczęśliwe. Zabierasz jego głowę, tak na wszelki wypadek. | Zabiłeś nekromantę, ale obawiając się, że jego sztuczki mogą działać nawet po śmierci, odcinasz mu głowę i wkładasz do worka. %employer%, twój zleceniodawca, będzie zadowolony, widząc ją. | Po bitwie przykładasz miecz do szyi nekromanty i odcinasz mu głowę. Schodzi zadziwiająco łatwo, jakby sama chciała znaleźć się w twoich rękach. Tak czy inaczej, %employer%, twój zleceniodawca, będzie chciał to zobaczyć jako dowód twoich czynów.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Czas odebrać zapłatę za jego głowę.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% uśmiecha się chytrze, gdy wracasz.%SPEECH_ON%Paskudna robota, prawda? Słyszałem już wieści - tu rozchodzą się szybko. Szkoda, że musieliśmy to zrobić w taki sposób, ale kto wie, ile byś żądał za walkę z tymi... istotami.\n\nHej... i tak dostajesz zapłatę.%SPEECH_OFF%Wskazuje na drewnianą skrzynię w rogu.%SPEECH_ON%%reward_completion% koron jest w środku, jak uzgodniliśmy.%SPEECH_OFF% | %employer% słucha twojego raportu, po czym powoli odchyla się na krześle.%SPEECH_ON%Krążyło sporo plotek o tych... rzeczach. O chodzących zmarłych?%SPEECH_OFF%Patrzy na biurko, po czym gniewnie spogląda na ciebie.%SPEECH_ON%Bzdury! Nie uwierzę w to. Dostaniesz %reward_completion% koron, jak uzgodniliśmy. Nie wyciśniesz ze mnie nic więcej tymi... tymi kłamstwami!%SPEECH_OFF%Naprawdę powinieneś był przynieść jedną lub dwie głowy, ale z drugiej strony martwa głowa wygląda niemal tak samo jak nieumarła... | %employer% wysłuchuje twojego raportu o nieumarłych i wzrusza ramionami.%SPEECH_ON%Co za szkoda.%SPEECH_OFF%Nonszalancko popija z kielicha i macha ręką w stronę rogu pokoju.%SPEECH_ON%Twoja zapłata jest w tej skrzyni. %randomname% cię odprowadzi.%SPEECH_OFF% | %employer% splata ręce i opuszcza je na kolana.%SPEECH_ON%Słyszałem o tych... rzeczach. O tych szurających potwornościach. To niedobra wiadomość, że dotarły do %townname%, ale jeśli mają być gdziekolwiek, to cmentarz jest najlepszy! Lepszy niż rynek, prawda?%SPEECH_OFF%Nerwowo się śmieje.%SPEECH_ON%%randomname% stoi za drzwiami z twoją zapłatą. Dziękuję, najemniku.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Zabezpieczyłeś cmentarzysko");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
						}

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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% wita cię w swoim pokoju.%SPEECH_ON%Zabiłeś ich wszystkich? Jest bezpiecznie?%SPEECH_OFF%Wzruszasz ramionami.%SPEECH_ON%Nikt nie będzie rozkopywał grobów przez długi czas.%SPEECH_OFF% | Zastajesz %employer%a wygodnie usadowionego w krześle, z płomieniem świecy przy postrzępionym zwoju. Mówi, nie podnosząc wzroku.%SPEECH_ON%Mój problem, załatwiłeś go?%SPEECH_OFF%Kiwasz głową.%SPEECH_ON%Nie stałbym tu, gdybym tego nie zrobił.%SPEECH_OFF%%employer% wskazuje ręką róg biurka.%SPEECH_ON%Twoja zapłata. %reward_completion% koron, jak uzgodniliśmy.%SPEECH_OFF% | %employer% rozmawia z kilkoma ludźmi, gdy wracasz do jego pokoju. Rozsuwa ich i pyta o zadanie. Mówisz, że znów bezpiecznie można grzebać bliskich z %townname%. %employer% się uśmiecha.%SPEECH_ON%Dobrze. Dobrze. Twoja zapłata.%SPEECH_OFF%Pstryka palcami i jeden z ludzi podchodzi, podając sakiewkę. Jest w niej %reward_completion% koron, jak obiecano.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "W pełni zasłużona zapłata.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Zabezpieczyłeś cmentarzysko");
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success3",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Wracasz do %employer%a z głową nekromanty. Jest niewiarygodnie lekka jak na ludzką głowę.%SPEECH_ON%To ta paskudna kreatura, która wyrywała nasze groby wraz z nieumarłymi?%SPEECH_OFF%Kiwasz głową i kładziesz głowę na stole. Twarz sapie, a %employer% odskakuje.%SPEECH_ON%On wciąż żyje!%SPEECH_OFF%Wzruszasz ramionami i wbijasz sztylet w czaszkę. Oczy nekromanty przewracają się ku jelcowi, zęby szczękają jakby się śmiał, potem oczy cofają się do oczodołów, a z ust wydostaje się cienka smuga czerwonego dymu i to koniec. %employer%, drżąc, siada i wskazuje sakiewkę w rogu. To twoja zapłata i jest dość ciężka. | %employer% siedzi, gdy wchodzisz do gabinetu, ale natychmiast wstaje i cofa się na widok głowy nekromanty zwisającej z twojej dłoni.%SPEECH_ON%T-to on? Tak? To on? To już koniec?%SPEECH_OFF%Kiwasz głową i rzucasz głowę na jego biurko. Obraca się twarzą do dołu, chwiejąc się na zaciśnionych policzkach martwego uśmiechu. %employer% odsuwa ją książką.%SPEECH_ON%Dobrze. Świetnie! Jak obiecano, twoja zapłata...%SPEECH_OFF%Wskazuje róg, gdzie leży {drewniane pudło | duża sakiewka}. Zabierasz je, liczysz i wychodzisz. | %employer% podnosi wzrok znad książki.%SPEECH_ON%Na bogów, czy to głowa nekromanty w twojej ręce?%SPEECH_OFF%Kiwasz głową i rzucasz ją na podłogę. Kot schodzi ze swojej półki i zaczyna ją szturchać. %employer% wstaje, zdejmuje kilka książek z półki i ujawnia duże pudło. Bierze je i podaje ci.%SPEECH_ON%Zachowałem to na specjalne okazje i chyba ta jest jedną z nich.%SPEECH_OFF%Myślisz, że to będzie jakiś przedmiot, może amulet czy coś tajemniczego, ale w środku jest tylko solidna kupa koron. | Wracając do %employer%a, trzymasz głowę nekromanty w dłoni, a mężczyzna szybko gestem prosi, byś mu ją oddał. Nie masz z tym problemu...\n\n%employer% unosi ją oburącz i bada, jakby trzymał chore niemowlę. Po chwili odkłada głowę w zacisku odłączonej części trójzęba.%SPEECH_ON%Myślę, że wygląda tu dobrze. Też tak uważasz, prawda?%SPEECH_OFF%Mężczyzna przykłada kciuk do bladej brody nekromanty. Oczyszczasz gardło i pytasz o zapłatę, na co %employer% wzywa jednego ze strażników. Przynoszą ci sakiewkę, z której odliczasz %reward_completion% koron. Zadowolony zostawiasz %employer%a z... czymkolwiek się tam zajmuje.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "W pełni zasłużona zapłata.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor, "Zabezpieczyłeś cmentarzysko");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
						}

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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer% stoi przy oknie, gdy wchodzisz.%SPEECH_ON%Ptaki śpiewały dziś dość gniewnie. Jakby nic, co mówią, nie było warte powiedzenia. Wydało mi się to ciekawe. Tobie też?%SPEECH_OFF%Nagle odwraca się do ciebie.%SPEECH_ON%Hmm, najemniku? Nie? Moje małe ptaszki powiedziały mi, że grabarze opuścili miasto. Żywi. Wolni, by iść dokąd chcą, wolni, by wracać kiedy chcą. Dziwne, bo zwykle martwi nie są wolni do niczego. W co miałem ich zamienić?%SPEECH_OFF%Wahasz się. Mężczyzna odpowiada za ciebie.%SPEECH_ON%Miałem ich uczynić martwymi. Teraz nimi nie są. Teraz nie dostajesz zapłaty. Ot, proste. A teraz? Teraz wynosisz się z mojego domu.%SPEECH_OFF% | %employer% śmieje się, gdy wchodzisz do jego pokoju.%SPEECH_ON%Szczerze, dziwi mnie, że wróciłeś. Powinno mnie to obrazić, że sądziłeś, iż nie będę wiedział lepiej. Grabarzy widziano na drodze. Tych grabarzy, których kazałem ci zabić. Pamiętasz? Pamiętasz, jak kazałem ich zabić? Na pewno. Na pewno pamiętasz też, że za to właśnie płaciłem. Więc... brak martwych grabarzy...%SPEECH_OFF%Uderza pięścią w biurko.%SPEECH_ON%Nie ma zapłaty! Wynocha z mojego domu!%SPEECH_OFF% | Zastajesz %employer%a na krześle, obracającego pusty kielich w rękach.%SPEECH_ON%Nie często trafiam na kogoś, kto próbuje mnie oszukać. To miałeś zrobić, wracając tutaj, prawda? Wiem, że grabarze nie są martwi, najemniku. Nie jestem głupi. Zniknij mi z oczu, zanim moi ludzie cię zaszlachtują.%SPEECH_OFF% | %employer% czyta książkę, gdy wchodzisz do jego pokoju.%SPEECH_ON%Masz dziesięć sekund, by się obrócić i wyjść. Dziesięć. Dziewięć. Osiem...%SPEECH_OFF%Rozumiesz, że wie, iż grabarze nie zostali unieszkodliwieni.%SPEECH_ON%...cztery... trzy...%SPEECH_OFF%Odwracasz się i pospiesznie wychodzisz z pokoju.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "A niech to!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Assets.addMoralReputation(-1);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationAttacked);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer% zaciska usta.%SPEECH_ON%Postawiłeś mnie w dziwnej sytuacji, najemniku. Mówisz, że grabarze zostali załatwieni, a jednak... nie mam dowodu. Zwykle martwi zostawiają sporo dowodów. Szczególnie ci, którzy zginęli przed czasem.%SPEECH_OFF%Wzrusza ramionami.%SPEECH_ON%Zapłacę ci połowę. Weźmiesz to i odejdziesz. Następnym razem przynieś dowód. Jeśli kłamiesz... sam to ustalę.%SPEECH_OFF% | Wracasz i zastajesz %employer%a doglądającego ogrodu.%SPEECH_ON%Czasem sieję jedno warzywo, a wyrasta zupełnie inne. Jak to się dzieje? Czy oszukałem samego siebie? Czy ty próbujesz oszukać mnie? Mówisz, że grabarze nie żyją, ale moi ludzie przeszukali cmentarz i nie znaleźli żadnego dowodu. Nie znaleźli też samych grabarzy, i proszę...%SPEECH_OFF%Unosi dłoń.%SPEECH_ON%Nie próbuj mi wmawiać, że zrobiłeś z ich ciałami to czy tamto. Więc tak to zrobimy, najemniku. Zapłacę ci połowę i będę tu siedział, zastanawiając się, czy mnie okłamałeś. Brzmi dobrze? Dobrze.%SPEECH_OFF% | %employer% uśmiecha się, gdy mówisz mu, że problem został rozwiązany.%SPEECH_ON%To dobra wiadomość. Niestety moi ludzie przeszukali cmentarz i nie znaleźli żadnych dowodów na martwych grabarzy. Ciekawy obrót spraw, ale nie będę cię tu trzymał, gdy ustalam, co dokładnie się tam stało. Więc... zapłacę ci połowę. Następnym razem przynieś mi dowód. Albo... nie kłam. Nie wiem, co u ciebie zachodzi.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Hrm.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractPoor);
						this.World.Assets.addMoralReputation(-1);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail);
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
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"treasure_location",
			this.m.TreasureLocation == null || this.m.TreasureLocation.isNull() ? "" : this.m.TreasureLocation.getName()
		]);
		_vars.push([
			"treasure_direction",
			this.m.TreasureLocation == null || this.m.TreasureLocation.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.TreasureLocation.getTile())]
		]);
		_vars.push([
			"necromancer_location",
			this.m.Flags.get("DestinationName")
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/terrified_villagers_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnCombatWithPlayerCallback(null);
				local zombies = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies);
				this.World.FactionManager.getFaction(this.m.Destination.getFaction()).removeSettlement(this.m.Destination);
				this.m.Destination.setFaction(zombies.getID());
				zombies.addSettlement(this.m.Destination.get(), false);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Home != null && !this.m.Home.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Home.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(3);
			}
		}
	}

	function onIsValid()
	{
		if (this.m.IsStarted)
		{
			if (this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive())
			{
				return false;
			}

			return true;
		}
		else
		{
			if (this.m.Destination == null || this.m.Destination.isNull())
			{
				return false;
			}

			return true;
		}
	}

	function onSerialize( _out )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull())
		{
			_out.writeU32(this.m.Destination.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		this.contract.onDeserialize(_in);
	}

});

