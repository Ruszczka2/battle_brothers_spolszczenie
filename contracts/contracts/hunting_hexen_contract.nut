this.hunting_hexen_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_hexen";
		this.m.Name = "Pakt z Wiedźmami";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 900 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.m.Flags.set("ProtecteeName", this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Zostań w %townname% i chroń syna pierworodnego zleceniodawcy"
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

				if (r <= 20)
				{
					this.Flags.set("IsSpiderQueen", true);
				}
				else if (r <= 40)
				{
					this.Flags.set("IsCurse", true);
				}
				else if (r <= 50)
				{
					this.Flags.set("IsEnchantedVillager", true);
				}
				else if (r <= 55)
				{
					this.Flags.set("IsSinisterDeal", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				this.Flags.set("Delay", this.Math.rand(10, 30) * 1.0);
				local envoy = this.World.getGuestRoster().create("scripts/entity/tactical/humans/firstborn");
				envoy.setName(this.Flags.get("ProtecteeName"));
				envoy.setTitle("");
				envoy.setFaction(1);
				this.Flags.set("ProtecteeID", envoy.getID());
				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Home != null && !this.Contract.m.Home.isNull())
				{
					this.Contract.m.Home.getSprite("selection").Visible = true;
				}

				this.World.State.setUseGuests(true);
			}

			function update()
			{
				if (!this.Contract.isPlayerNear(this.Contract.getHome(), 600))
				{
					this.Flags.set("IsFail2", true);
				}

				if (this.Flags.has("IsFail1") || this.World.getGuestRoster().getSize() == 0)
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.has("IsFail2"))
				{
					this.Contract.setScreen("Failure2");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.has("IsVictory"))
				{
					if (this.Flags.get("IsCurse"))
					{
						local bros = this.World.getPlayerRoster().getAll();
						local candidates = [];

						foreach( bro in bros )
						{
							if (bro.getSkills().hasSkill("trait.superstitious"))
							{
								candidates.push(bro);
							}
						}

						if (candidates.len() == 0)
						{
							this.Contract.setScreen("Success");
						}
						else
						{
							this.Contract.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
							this.Contract.setScreen("Curse");
						}
					}
					else if (this.Flags.get("IsEnchantedVillager"))
					{
						this.Contract.setScreen("EnchantedVillager");
					}
					else
					{
						this.Contract.setScreen("Success");
					}

					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("StartTime") + this.Flags.get("Delay") <= this.Time.getVirtualTimeF())
				{
					if (this.Flags.get("IsSpiderQueen"))
					{
						this.Contract.setScreen("SpiderQueen");
					}
					else if (this.Flags.get("IsSinisterDeal") && this.World.Assets.getStash().hasEmptySlot())
					{
						this.Contract.setScreen("SinisterDeal");
					}
					else
					{
						this.Contract.setScreen("Encounter");
					}

					this.World.Contracts.showActiveContract();
				}
				else if (!this.Flags.get("IsBanterShown") && this.Math.rand(1, 1000) <= 1 && this.Flags.get("StartTime") + 6.0 <= this.Time.getVirtualTimeF())
				{
					this.Flags.set("IsBanterShown", true);
					this.Contract.setScreen("Banter");
					this.World.Contracts.showActiveContract();
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getID() == this.Flags.get("ProtecteeID"))
				{
					this.Flags.set("IsFail1", true);
					this.World.getGuestRoster().clear();
				}
			}

			function onActorRetreated( _actor, _combatID )
			{
				if (_actor.getID() == this.Flags.get("ProtecteeID"))
				{
					this.Flags.set("IsFail1", true);
					this.World.getGuestRoster().clear();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Hexen")
				{
					this.Flags.set("IsVictory", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Hexen")
				{
					this.Flags.set("IsFail2", true);
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
			Text = "[img]gfx/ui/events/event_79.png[/img]{Zastajesz %employer%a z łopatką zawieszoną na szyi, choć zwyczajne thaumaturgiczne ozdoby zastąpiono czosnkiem i cebulą. Ma łzy w oczach.%SPEECH_ON%Och, najemniku, jakże się cieszę, że cię widzę! Proszę, usiądź.%SPEECH_OFF%Przeciskając się pod girlandami z ziół, siadasz przed nim. Oczy zaczynają piec i łzawić. Mężczyzna kontynuuje.%SPEECH_ON%Słuchaj, to sprawi, że zabrzmię jak największy cholerny głupiec, jakiego spotkałeś, ale posłuchaj. Wiele lat temu mój pierworodny, %protectee%, przyszedł na świat okryty chorobą. Zdesperowany, szukałem pomocy u wiedźm...%SPEECH_OFF%Podnosisz rękę. Pytasz, czy zawarł pakt i czy przyszły po należność. Mężczyzna przytakuje.%SPEECH_ON%Tak. Osiemnaście lat obiecały i dziś mija jego osiemnasty rok na ziemi. To nie jest proste zadanie, najemniku. Te kobiety są niebezpieczne ponad wszelki rozsądek stali i zakładam, że będą jeszcze bardziej piekielne, gdy dowiedzą się, że odmawiam zapłaty. Jesteś pewien, że chcesz pomóc mi chronić moje dziecko?%SPEECH_OFF%Ocierając oczy, rozważasz opcje... | Zastajesz %employer%a w kącie jego pokoju. Wykręca się, by wyglądać przez okno niczym świstak z nory. Gdy cień na niego pada, podskakuje i chwyta się za pierś. Jego mrugnięcie tchórzostwa nie jest jednak powodem do śmiechu, i zwraca się do ciebie poważnie.%SPEECH_ON%Wiedźmy przeklęły moją rodzinę! No, mój ród. A dokładniej mojego pierworodnego, %protectee%. Wiele księżyców temu miałem problem z... no wiesz, z żoną. Poprosiłem wiedźmy o pomoc i uwarzyły coś odpowiedniego do sypialni. Oczywiście, wiedźmy jakie są, teraz wróciły i chcą zabrać mojego pierworodnego!%SPEECH_OFF%Dziwi cię, że mogły mu to zrobić, i wyrażasz współczucie. %employer% warknie na ciebie.%SPEECH_ON%To nie są żarty! Potrzebuję ochrony dla mojego pierworodnego, jesteś gotów pomóc uratować %protectee% czy nie?%SPEECH_OFF% | Zastajesz %employer%a, który gorączkowo przerzuca księgi. Wygląda to tak, jakby już je studiował, a teraz gorączkowo szukał przeoczonej wskazówki. Nic nie znajduje i w gniewie zrzuca tomy ze stołu. Widząc cię, ociera czoło i wyjaśnia.%SPEECH_ON%Szukałem odpowiedzi wszędzie, ale wygląda na to, że muszę sięgnąć po stal. Twoją stal, najemniku. Powiem ci wprost. Wiele lat temu zawarłem układ z wiedźmami, by ochronić mojego pierworodnego, %protectee%, przed piekielną gorączką. Dziecko przeżyło, ale teraz te okropne kobiety wracają i żądają mojego dziecka jako zapłaty.%SPEECH_OFF%Przytakujesz. To niemal równie podłe jak sztuczki lichwiarzy. Mężczyzna kontynuuje, wskazując palcem w biurko.%SPEECH_ON%Potrzebuję cię tutaj, najemniku. Potrzebuję miecza, by chronić %protectee% przez noc i zabić te przeklęte jędze, by mój ród przetrwał ten koszmar. Czy jesteś gotów pomóc?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Musisz nam słono zapłacić za walkę z takim wrogiem. | Przekonaj mnie sakiewką pełną koron, że warto ponieść ryzyko. | Spodziewam się bardzo wysokiej zapłaty za walkę z takim wrogiem.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Powinieneś był raczej uszanować pakt. | To nie będzie warte ryzyka. | Raczej nie chcę mieszać kompanii w utarczki z takim wrogiem.}",
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
			ID = "Banter",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_79.png[/img]{%randombrother% podchodzi do ciebie. Dłubie w uchu małym palcem.%SPEECH_ON%Hej, kapitanie. Widziałeś już którąś z tych ponętnych bab?%SPEECH_OFF%Słysząc to, %randombrother2% podchodzi bliżej. Pochyla się.%SPEECH_ON%Hej, jak słyszałem, te wiedźmy są naprawdę ładne, ale tak cię biorą. Zwodzą urokami, a potem zjadają twoją duszę.%SPEECH_OFF%Śmiejąc się, %randombrother% wyciera wosk o strój %randombrother2%a.%SPEECH_ON%Będą musiały jechać do %randomtown% po moją duszę, bo inna kobieta mnie uprzedziła.%SPEECH_OFF% | Przeglądasz ekwipunek, gdy %randombrother% podchodzi. Wysłałeś go na zwiad i ma raport.%SPEECH_ON%Panie, na razie nic nie widziano, ale rozmawiałem z miejscowymi. Mówią, że wiedźmy zawierają pakty ze zwykłymi ludźmi, a potem lata później odbierają należność, zwykle z wielkim procentem. Podobno potrafią omamić cię, żebyś widział w nich rozwiązłe kokietki. Mogą zaciągnąć cię do łóżka prosto do grobu! Powiedziałem, że brzmi to jak cykadzie bzdury.%SPEECH_OFF%Przytakujesz i pytasz, co do diabła to cykada. Śmieje się.%SPEECH_ON%Serio? To taki rodzaj orzecha, panie.%SPEECH_OFF% | Bracia zabijają czas, żartując o kobietach i wiedźmach oraz o tym, czy jest między nimi jakaś istotna różnica. %randombrother% wyciąga rękę.%SPEECH_ON%A teraz poważnie, słyszałem opowieści o tych jędzach. Potrafią rzucić urok, żebyś widział rzeczy. Każą ci podpisywać krwawe pakty, a jeśli nie zapłacisz, wytną ci rzepki i użyją do wróżenia. Cholera, kiedy byłem dzieckiem, mój sąsiad zrobił z jedną układ i zniknął. Później widziałem tajemniczą kobietę, która używała świeżej czaszki jako latarni!%SPEECH_OFF%%randombrother2% przytakuje uważnie.%SPEECH_ON%Niesamowite, ale czy ktokolwiek wie, co robi wiedźma?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zachowajcie czujność, chłopcy.",
					function getResult()
					{
						if (this.Flags.get("StartTime") + this.Flags.get("Delay") - 3.0 <= this.Time.getVirtualTimeF())
						{
							this.Flags.set("Delay", this.Flags.get("Delay") + 5.0);
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SpiderQueen",
			Title = "W pobliżu %townname%",
			Text = "[img]gfx/ui/events/event_106.png[/img]{Samotna kobieta przecina ci drogę i podchodzi w przerwie między drzewami. Kroczy z kołysaniem, uda wysuwają się spod jedwabnej sukni. Jej skóra jest nieskazitelna, a szmaragdowe oczy spoglądają spomiędzy rudych kosmyków z lubieżnością, jakiej nie widziałeś od chłopięcych lat. Wiesz, że to wiedźma, bo taka doskonałość nie może istnieć na tym świecie, a w tych stronach to jak malować się na własny pogrzeb. Co też uczyniła. Dobijasz miecz i każesz jej przyjąć los z honorem. Skóra wiedźmy marszczy się, przybierając prawdziwą, ohydną postać, a ona chichocze z rozkoszą.%SPEECH_ON%Ach, przez chwilę miałam cię, ale ptak mięknie, a pycha wraca. Masz tak rozkoszny zapach, mieczniku. Dopilnuję, by zachowali cię tylko dla mnie.%SPEECH_OFF%Zanim zdążysz zapytać, co ma na myśli, dwa drzewa między którymi stoi rozkwitają wyciągając pajęcze nogi. Z zarośli wyłaniają się wielkie czarne bulwy i zeskakują na ziemię, siecioknechty kłapią żuwaczkami z głodem imago. Dłonie wiedźmy unoszą się, a palce tańczą jak u lalkarza, który dowodzi chmurami.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Hexen";
						p.Entities = [];
						p.Music = this.Const.Music.CivilianTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.Entities.push({
							ID = this.Const.EntityType.Spider,
							Variant = 0,
							Row = 1,
							Script = "scripts/entity/tactical/enemies/spider_bodyguard",
							Faction = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID(),
							Callback = null
						});
						p.Entities.push({
							ID = this.Const.EntityType.Spider,
							Variant = 0,
							Row = 1,
							Script = "scripts/entity/tactical/enemies/spider_bodyguard",
							Faction = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID(),
							Callback = null
						});
						p.Entities.push({
							ID = this.Const.EntityType.Hexe,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/enemies/hexe",
							Faction = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID(),
							function Callback( _e, _t )
							{
								_e.m.Name = "Pajęcza Królowa";
							}

						});
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Spiders, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SinisterDeal",
			Title = "W pobliżu %townname%",
			Text = "[img]gfx/ui/events/event_106.png[/img]{%randombrother% gwiżdże i uchyla czapki przed pięknymi kobietami, które pojawiły się jakby znikąd, by omdlewać przed kompanią. Powstrzymujesz najemnika i robisz krok do przodu, ale zanim zdążysz się odezwać, jedna z kobiet unosi dłonie i podchodzi do ciebie.%SPEECH_ON%Pozwól, że pokażę ci moje prawdziwe oblicze, mieczniku.%SPEECH_OFF%Jej ramiona opadają wzdłuż ciała i tam szarzeją oraz marszczą się jak mokra skóra migdała. Niegdyś jasne i jedwabiste włosy wypadają w długich, wiotkich pasmach, aż odsłania się jej groteszkowa czaszka, a ostatnie cebulki trzymają kłębki komarów i wszy niczym ostatnich wyznawców na umierającym świecie. Kłania się, twarz uniesiona ku tobie, z żółtym uśmiechem przeciętym przez nią jak bruzda.%SPEECH_ON%Mamy wielką moc, mieczniku, sam to widzisz. Proponuję układ.%SPEECH_OFF%W każdej dłoni pojawia się maleńka fiolka, w jednej kropla zielonego płynu, w drugiej niebieskiego. Uśmiecha się i obraca je w palcach, mówiąc.%SPEECH_ON%Napój dla ciała albo dla ducha. Mężczyźni zabijaliby za każdy z nich. Oferuję ci jeden w zamian za życie pierworodnego. Jaką wartość ma potomstwo obcego? Masz na koncie wiele rzezi, prawda? Odstąp, mieczniku, i pozwól nam go zabrać. Albo stań nam na drodze, naraź życie swoich ludzi i własne za jakiegoś smarkacza, który wkrótce nie będzie pamiętał twojej twarzy. Wybór należy do ciebie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nigdy nie oddam wam chłopaka, jędze. Do broni!",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Hexen";
						p.Entities = [];
						p.Music = this.Const.Music.CivilianTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.HexenAndNoSpiders, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				},
				{
					Text = "Pragnę napoju dla ciała.",
					function getResult()
					{
						return "SinisterDealBodily";
					}

				},
				{
					Text = "Pragnę napoju dla duszy.",
					function getResult()
					{
						return "SinisterDealSpiritual";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SinisterDealBodily",
			Title = "W pobliżu %townname%",
			Text = "[img]gfx/ui/events/event_106.png[/img]{Wiedźma się uśmiecha.%SPEECH_ON%Człowiek jest niczym bez sprawnego ciała, które prowadzi go przez świat. Proszę, mieczniku. Nie zmarnuj tego.%SPEECH_OFF%Rzuca ci fiolkę. Wirując w powietrzu, mruga zielonkawym spektrum nad ziemią, a każdy błysk słabego światła wywołuje z nieobsianego błota drobny kwiat. Łapiesz szkło. Wibruje w dłoni, a ból kości powoli ustępuje, jakby twoja pięść przez cały czas była zdrętwiała, tylko o tym nie wiedziałeś. Gdy podnosisz wzrok po wyjaśnienie, wiedźmy już zniknęły. Został jedynie samotny krzyk, dobiegający z wielkiej odległości, której nie sposób określić. Bez wątpienia to koniec pierworodnego %employer%a.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zbyt dobra oferta, by ją odrzucić.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 2, "Zdradziłeś pracodawcę (" + this.Contract.getEmployer().getName() + ") i dobiłeś targu z wiedźmami");
						this.World.Contracts.finishActiveContract(true);
						return;
					}

				}
			],
			function start()
			{
				local item = this.new("scripts/items/special/bodily_reward_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "SinisterDealSpiritual",
			Title = "W pobliżu %townname%",
			Text = "[img]gfx/ui/events/event_106.png[/img]{Machnięciem dłoni i szarpnięciem nadgarstka wiedźma wsuwa zieloną fiolkę do rękawa. Pozostałą niebieską wyciąga do ciebie.%SPEECH_ON%Mądry z ciebie człowiek, mieczniku.%SPEECH_OFF%Chrząka szorstko, jej gruby nos kurczy się do rozmiarów larwy, po czym bezwładnie opada.%SPEECH_ON%Wyczuwam w twojej krwi bystrych mężów, mieczniku. Niemal chciałabym mieć tę krew dla siebie.%SPEECH_OFF%Jej oczy wpatrują się w ciebie jak kot w pozbawionego kończyn świerszcza, który wciąż śmie się poruszać. Ale wtedy wraca jej uśmiech, więcej dziąseł niż zębów, więcej czerni niż różu.%SPEECH_ON%Cóż, układ to układ. Proszę bardzo.%SPEECH_OFF%Rzuca fiolkę w powietrze i gdy ją łapiesz oraz odwracasz się, wiedźmy już zniknęły. Słyszysz cichy krzyk potwornych męczarni, który wydaje się jednocześnie bliski i daleki, i nie masz wątpliwości, że to koniec pierworodnego %employer%a.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zbyt dobra oferta, by ją odrzucić.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 2, "Zdradziłeś pracodawcę (" + this.Contract.getEmployer().getName() + ") i dobiłeś targu z wiedźmami");
						this.World.Contracts.finishActiveContract(true);
						return;
					}

				}
			],
			function start()
			{
				local item = this.new("scripts/items/special/spiritual_reward_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Encounter",
			Title = "W pobliżu %townname%",
			Text = "[img]gfx/ui/events/event_106.png[/img]{%randombrother% gwiżdże i woła.%SPEECH_ON%Mamy gości. Miłych... pięknych gości...%SPEECH_OFF%Zbliża się rozwiązła kobieta. Przechadza się po ziemi z łatwością, jednym palcem bawi się uchem, drugim ściska kamień zwisający nad obfitym biustem. Klepiesz najemnika po ramieniu.%SPEECH_ON%To nie zwykła dama.%SPEECH_OFF%Ledwie słowa schodzą ci z ust, a jej obfite, młodzieńcze rysy marszczą się w szary wzór, a bujne włosy więdną na czubku głowy i zostaje tylko jędza, szczerząca się złowieszczo. Do broni! Strzeżcie %protectee%a! | Dostrzegasz kobietę zbliżającą się do drużyny. Jest ubrana w jaskrawą czerwień, a naszyjnik kołysze się nad i między jej obfitym biustem. To niezły widok, ale ona jest bez skazy, a coś takiego nie istnieje na tym świecie.\n\nDobijasz miecz. Kobieta widzi stal i spogląda na ciebie przebiegle. Kępki włosów opadają z jej głowy, a reszta kurczy się w szare strzępy. Skóra zapada się w blade doliny, a paznokcie rosną tak długie, że się zawijają. Wskazuje cię palcem i krzyczy, że nikt nie powstrzyma spełnienia paktu, który zawarła. Wołasz do kompanii, by %protectee% trzymano z dala od niebezpieczeństwa. | Dostrzegasz kobietę zbliżającą się do kompanii. Najemnicy są oczarowani jej urodą, ale ty wiesz lepiej. Dobijasz miecz i uderzasz nim tak głośno, że ściągasz na siebie gniew tej rzekomej damy. Syczy, a wargi odskakują w uśmiechu niemal od ucha do ucha. Jej skóra napina się, aż pęka i szarzeje. Śmieje się i śmieje, gdy włosy wypadają. Wiedźma wskazuje na ciebie palcem.%SPEECH_ON%Ach, wyczuwam twoje pochodzenie, mieczniku, ale bez znaczenia skąd jesteś. Pakt musi zostać spłacony krwią pierworodnego, a każdy, kto stanie nam na drodze, krwawić będzie podobnie!%SPEECH_OFF%Kompania ustawia szyk, a ty każesz %protectee%owi trzymać głowę nisko.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Hexen";
						p.Entities = [];
						p.Music = this.Const.Music.BeastsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.HexenAndNoSpiders, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Curse",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_124.png[/img]{Gdy ruszasz w drogę powrotną do %employer%a, widzisz, jak %superstitious% stoi nad wiedźmą. Dostrzegasz, że wargi tej przeklętej wciąż się poruszają, więc podbiegasz. Pluje klątwami, które uciszasz piętą buta. Z poszarpanych dziąseł trzepoczą zęby, gdy się śmieje. Dobijasz miecz i wbijasz go między jej oczy, kładąc kres na zawsze. %superstitious% aż się trzęsie.%SPEECH_ON%Ona wiedziała o mnie wszystko! Wiedziała wszystko, kapitanie! Wiedziała wszystko! Wiedziała, kiedy umrę i jak!%SPEECH_OFF%Mówisz mu, by zignorował każde słowo wiedźmy. Przytakuje i wraca do kompanii, ale jego twarz wykrzywia się od przepowiedni, których nie da się nie usłyszeć.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie rozmyślaj o tym.",
					function getResult()
					{
						return "Success";
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
				local effect = this.new("scripts/skills/effects_world/afraid_effect");
				this.Contract.m.Dude.getSkills().add(effect);
				this.List.push({
					id = 10,
					icon = effect.getIcon(),
					text = this.Contract.m.Dude.getName() + " się boi"
				});
				this.Contract.m.Dude.worsenMood(1.5, "Został przeklęty przez wiedźmę");

				if (this.Contract.m.Dude.getMoodState() <= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[this.Contract.m.Dude.getMoodState()],
						text = this.Contract.m.Dude.getName() + this.Const.MoodStateEvent[this.Contract.m.Dude.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "EnchantedVillager",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_124.png[/img]{Gdy ludzie dochodzą do siebie po bitwie, młody chłop przebiega przez pole, krzycząc i wiwatując. Odwracasz się i widzisz, jak upada przed wiedźmą i unosi jej upiorne, skórzaste ciało, ściskając je w ramionach i kołysząc się w przód i w tył. Widząc cię, rzuca przekleństwa.%SPEECH_ON%Czemu to zrobiliście, co? Przeklęte dranie, wszyscy co do jednego! Poślubiłem ją dwa tygodnie temu, a teraz muszę ją pochować. Mówię: zabierzcie mnie z nią! Zróbcie, co najgorsze, wy dzikusy! Ten świat pogrzebie nas oboje, moja miłości!%SPEECH_OFF%Unosisz brew. Ten człowiek musiał być zaczarowany przed twoim przybyciem, zapewne jako pachołek wiedźm. Cokolwiek myślisz, kilku ludzi jest zaniepokojonych widokiem żałobnego chłopca. Jednak jeden twardszy najemnik z kpiącym uśmieszkiem i dłonią na broni pyta, czy nie spełnić prośby dzieciaka. Kręcisz głową i każesz ludziom wrócić do szyku.} ",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Biedak.",
					function getResult()
					{
						return "Success";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_124.png[/img]{Gdy bitwa dobiega końca, %randombrother% podchodzi do ciebie. Mówi, że %protectee% zginął podczas walki. Mówi, że nie ma gałek ocznych ani języka, a jego twarz wygląda jak dwie mokre szmaty złożone na sobie. Nie ma sensu wracać teraz do %employer%a. | Spoglądasz na zwłoki %protectee%a. Gałki oczne zostały wyrwane i zwisają na policzkach jak mokre podroby. Jego twarz jest rozciągnięta w uśmiech, choć to, co ją tak ułożyło, nie mogło być ani trochę śmieszne. %randombrother% pyta, czy kompania powinna wracać do %employer%a, a ty kręcisz głową. | Znajdujesz pierworodnego %employer%a, zgniecionego na ziemi. Każdy staw został wydrążony lub wycięty, choć kiedy i jak to się stało, nie masz pojęcia. %randombrother% próbuje ruszyć ciało, ale to skręca się i grzechocze jak marionetka bez sznurków. Najemnik krzywi się i rzuca zwłoki z powrotem na ziemię, gdzie zwijają się w kosz własnej klatki piersiowej, a głowa, jajowata, spoczywa w gnieździe. Nie ma sensu wracać teraz do %employer%a.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zaraza, zaraza, zaraza!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Nie ochroniłeś syna pierworodnego zleceniodawcy (" + this.Contract.getEmployer().getName() + ")");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_16.png[/img]{%employer% płacił ci za ochronę %protectee%a. Trudno chronić pierworodnego, gdy opuszczasz %townname% i porzucasz go wiedźmom. Nie zawracaj sobie głowy powrotem po zapłatę. | Miałeś zadanie strzec %protectee%a w %townname%, czy zapomniałeś? Nie zawracaj sobie głowy powrotem, pierworodny bez wątpienia już nie żyje albo, co gorsza, został zabrany przez wiedźmy do jakiegoś niecnego celu.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Och, zaraza.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Nie ochroniłeś syna pierworodnego zleceniodawcy (" + this.Contract.getEmployer().getName() + ")");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_79.png[/img]{%employer% obejmuje %protectee%a, przyciskając pierworodnego mocno do siebie. Patrzy na ciebie.%SPEECH_ON%To już, wszystkie wiedźmy nie żyją?%SPEECH_OFF%Przytakujesz. Mieszczanin także przytakuje.%SPEECH_ON%Dziękuję! Dziękuję, najemniku!%SPEECH_OFF%Wskazuje ci skrzynię w rogu pokoju. Jest pełna twojej zapłaty. | Odprowadzasz %protectee%a do %employer%a. Mieszczanin i pierworodny obejmują się niczym dwa osobne sny o tym samym zdarzeniu, które powoli łączą się mimo nawoływań rzeczywistości. W końcu ściskają się i zatrzymują, by spojrzeć na siebie i upewnić się, że to prawda. Mówisz %employer%owi, że wszystkie wiedźmy nie żyją, ale powinien zachować tę historię dla siebie. Przytakuje.%SPEECH_ON%Duchy żywią się pychą, tyle wiem, i zabiorę tę opowieść do grobu. Dziękuję ci za to, co dziś zrobiłeś, mieczniku. Dziękuję ci tak, że nie zdołasz tego pojąć. Mam tylko jeden sposób, by wyrazić wdzięczność.%SPEECH_OFF%Przynosi ci sakiewkę złota. Widok wypchanego monetami worka wywołuje na twojej twarzy ciepły uśmiech. | %protectee% biegnie od twojego boku w ramiona %employer%a. Mieszczanin spogląda ponad ramieniem pierworodnego.%SPEECH_ON%To już, jesteśmy wolni od klątwy?%SPEECH_OFF%Wzruszasz ramionami i odpowiadasz.%SPEECH_ON%Jesteście wolni od wiedźm.%SPEECH_OFF%Mieszczanin zaciska usta i przytakuje.%SPEECH_ON%Cóż, to mi wystarczy. Twoja zapłata jest tam, w sakiewce, tyle, ile obiecano.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Koniec końców wszystko się udało.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Ochroniłeś syna pierworodnego zleceniodawcy (" + this.Contract.getEmployer().getName() + ")");
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
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"superstitious",
			this.m.Dude != null ? this.m.Dude.getName() : ""
		]);
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Target.getTile())]
		]);
		_vars.push([
			"protectee",
			this.m.Flags.get("ProtecteeName")
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/abducted_children_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.m.Home.getSprite("selection").Visible = false;
			this.World.State.setUseGuests(true);
			this.World.getGuestRoster().clear();
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

