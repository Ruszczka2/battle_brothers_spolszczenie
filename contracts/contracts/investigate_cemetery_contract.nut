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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% nerwowo chodzi w te i z powrotem, co chwile zatrzymujac sie, by zwrocic sie do ciebie.%SPEECH_ON%Ludzie sa wstrzasnieci! Groby na cmentarzu znaleziono otwarte i spladrowane. Jakis prostak twierdzi, ze to umarli wstaja z grobow - zabobonna bzdura. To ewidentnie robota grabarzy, ktorzy mieli czelnosc przyjsc do %townname% i nekac nas swoja chciwoscia!%SPEECH_OFF%Uderza piescia w stol z wscieklosci.%SPEECH_ON%Idz na cmentarz i zakoncz ten problem raz na zawsze!%SPEECH_OFF% | %employer% opada na krzeslo, smiejac sie pod nosem.%SPEECH_ON%Nie panikuj, najemniku, ale powiadaja, ze grasuje duch! Tak, tak, miejscowi chlopi truja mi poranki opowiesciami o duchach i goblinach. Twierdza, ze te domniemane stworzenia wywracaja cmentarz do gory nogami, rabujac groby, by powiekszyc swoja armie, czy jakies takie bzdury. To oczywiscie robota ludzi z lopatami, ktorzy kradna z grobow bizuterie. Widzialem to juz nie raz.%SPEECH_OFF%Spoglada na swoje dlonie i krotko chichocze.%SPEECH_ON%Tak czy inaczej, nie moge tego zignorowac, bo chlopi nie dadza mi spokoju. Wiec, zeby ich uspokoic, jest...es ty. Potrzebuje, zebys poszedl na cmentarz i przegonil wszelkich rozrabiakow. Jak to zrobisz, to juz twoja sprawa, ale sugeruje dobry kawalek stali, jesli wiesz, co mam na mysli...%SPEECH_OFF% | %employer% ma na biurku mape cmentarza. Polowa kwadratow jest zamalowana tuszem.%SPEECH_ON%Kazdy kwadrat, ktory widzisz, zostal spladrowany. Co noc przychodza, i co noc nie potrafie ich zlapac. Jestem u kresu sil, wiec postanowilem skonczyc z tym raz na zawsze. Chce, zebys poszedl na ten cmentarz i zabil kazdego glupca, ktory rozkopuje groby. Zrozumiano?%SPEECH_OFF% | %employer% stoi przy oknie, wygladajac na zewnatrz i popijajac miod. Zdaje sie, ze nie skupia sie na niczym konkretnym i mowi, jakby zupelnie go to nie obchodzilo.%SPEECH_ON%Grabarze rabują cmentarz. Znowu. Nie prosze cie o wiele, najemniku, tylko o to, bys tam poszedl i zakonczyl to glupie przedstawienie. Idz na cmentarz i zabij kazdego grabarza, ktorego zobaczysz. Jasne? Dobrze.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_69.png[/img]{Chrupanie. Mlaszczenie. Dzwiek kogos - lub czegos - kto delektuje sie posilkiem. Przechodzac przez cmentarz, trafiasz na polane pelna nachzehrerow. Kula sie nad szczatkami, ktore wygladaja na grabarzy, ktorych szukales. Odrazajace potwory powoli odwracaja sie ku tobie, a ich czerwone oczy rozszerzaja sie na widok swiezego miesa. | Nagrobki przewracaja sie, gdy grupa nachzehrerow wspina sie na nie. Wyglada na to, ze urzadzily sobie uczte, a kilku wciaz ogryza jakies ramie czy noge, zapewne konczyny twoich domniemanych grabarzy. | Slyszysz przenikliwy krzyk i szybko skrecasz za rog mauzoleum, widzac nachzehrera wgryzajacego sie w kark mezczyzny. Bestia, z krwia tak pelna pyska, ze wylewa sie z nozdrzy, tylko rzuca na ciebie spojrzenie. Mniejsze nachzehrery otaczaja go, wysuwajac sie do przodu, by dopilnowac, ze ich kolejny posilek nie ucieknie...}",
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
			Text = "[img]gfx/ui/events/event_57.png[/img]{Grabarze sa na miejscu, tak jak obiecano. Zlapales ich w trakcie kopania, a twoi bracia przeskakuja przez nagrobki z uniesiona bronia. | Wchodzac na cmentarz, znajdujesz grabarzy dokladnie tam, gdzie %employer% sadzil, ze beda. Oni widza ciebie tak samo, jak ty ich. Twoi ludzie rozchodza sie z bronia, by odciac droge ucieczki. | Idac miedzy nagrobkami, slyszysz kilka glosow za mauzoleum. Gdy skrecasz za rog, widzisz grupe ludzi stojacych nad oproznionym grobem. Przed nimi lezy otwarta trumna, a kilku wyciaga z niej bizuterie. Rozkazujesz ludziom szarzowac. | %employer% mial racje: byli tu grabarze. Widzisz przewrocone groby i rozkopane mogily. Slady w blocie prowadza cie do kopaczy, ktorzy szperaja przy kolejnej robocie.%SPEECH_ON%Nie chce wam przeszkadzac, chlopaki, ale %employer% placi niezle, zebyscie zostali w ziemi.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_57.png[/img]{Cmentarz spowija mgla - albo gesta miasma bijaca od zmarlych. Chwila... to sa umarli! Do broni! | Spogladasz na nagrobek z kopcem ziemi rozgrzebanej u podstawy. Plamy blota prowadza dalej niczym okruchy. Nie ma lopat... nie ma ludzi... Podazajac tropem, natrafiasz na horde nieumarlych, jeczacych i stekajacych... teraz wpatrujacych sie w ciebie nienasyconym glodem... | Mezczyzna stoi gleboko miedzy rzędami nagrobkow. Chwieje sie, jakby mial zaraz zemdlec. %randombrother% podchodzi i kreci glowa.%SPEECH_ON%To nie czlowiek, panie. To nieumarly.%SPEECH_OFF%Gdy tylko konczy mowic, postac w oddali powoli sie odwraca i w swietle okazuje sie, ze brakuje jej polowy twarzy. | Odkrywasz, ze wiele grobow jest oproznionych. Nie tylko oproznionych, lecz rozkopanych od dolu. To nie robota grabarzy...}",
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
			Text = "[img]gfx/ui/events/event_57.png[/img]{Wchodzisz na cmentarz i znajdujesz grabarzy tam, gdzie %employer% podejrzewal: po kolana w cudzej wiecznosci. Dobijajac miecz, kazesz im odlozyc bizuterie, ktora probuja ukrasc. Jeden z nich wstaje, podnosi rece i zaczyna sie tlumaczyc.%SPEECH_ON%Zanim nas zabijesz, moge cos powiedziec? Mamy mape... wiem, brzmi jak klamstwo, ale posluchaj... Mamy mape, ktora prowadzi do ogromnych skarbow. Puscisz nas, a oddam ci ja. Zabijesz nas i... nigdy jej nie zobaczysz. Co powiesz?%SPEECH_OFF% | Dokladnie jak podejrzewal %employer%, grabarze krecą sie pośród nagrobkow. Zatrzymujesz ich w polowie kopania i pytasz, czy maja jakies ostatnie slowa, zanim dolacza do swoich ofiar w blocie. Jeden z nich blaga o litosc, twierdzac, ze ma mape skarbów i odda ja w zamian za zycie calej grupy. | Natrafiasz na kilku mezczyzn probujacych wywalic drzwi mauzoleum. Uderzenie miecza o but zwraca ich uwage.%SPEECH_ON%Dobry wieczor, panowie. %employer% mnie przyslal.%SPEECH_OFF%Jeden z nich upuszcza narzedzia.%SPEECH_ON%Zaczekaj chwile! Mamy mape... tak, mape! Jesli nas oszczedzisz, dam ci ja! Ale tylko wtedy, jesli nas oszczedzisz! Jesli nie... nigdy jej nie zobaczysz, rozumiesz?%SPEECH_OFF% | Zaskakujesz grabarzy, dobywajac miecza, gdy wbijaja lopaty w ziemie. Jeden z nich, wyczuwajac, ze zaraz dolaczy do grobu, w ktorym stoi juz jedna noga, zaczyna z tobą targ. Okazuje sie, ze maja mape do tajemniczego skarbu. Wystarczy ich puscic, a oddadza ci mape. Jesli ich zabijesz, to 'mapa' tez zniknie i nigdy nie zobaczysz ani jej, ani skarbow, do ktorych prowadzi.}",
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
			Text = "[img]gfx/ui/events/event_57.png[/img]{Moze %employer% po prostu probowal zabic ludzi dla skarbu? To... ma sens, prawda? Postanawiasz puscic tych ludzi wolno w zamian za mape, ktora pokazuje droge do %treasure_location% %treasure_direction% stad. | %employer% nic nie wspominal o tym, ze ci ludzie maja mape... moze chcial to ukryc? Kto wie. Pokusa skarbu jest jednak zbyt silna i decydujesz sie ich puscic w zamian za informacje. Ich mapa ujawnia %treasure_location%. Lezy %treasure_direction% od miejsca, w ktorym stoisz. | Gdy byles dzieckiem, ciagle jezdziles na poszukiwania skarbow. To... dziwnie ekscytujace. Nie wiesz czemu, ale pokusa powrotu do tej przygody sprawia, ze puszczasz ich wolno. W zamian pokazują ci mape, ktora ujawnia %treasure_location%, miejsce ukrytego skarbu... kto wie jakiego. Wiesz tylko, ze lezy %treasure_direction% od miejsca, w ktorym stoisz.}",
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
			Text = "[img]gfx/ui/events/event_56.png[/img]{Po wybiciu wszystkich nieumarlych znajdujesz kawalek materialu, ktory w twojej dloni swieci na fioletowo. Nie wiesz, czym jest, ale jakos chcesz go zatrzymac. %randombrother% uwaza to za glupie, ale to nie on dowodzi. | Po bitwie %randombrother% znajduje glowice lopaty z wypalonym symbolem. Zastanawia sie, czy %employer%, twoj zleceniodawca, nie wie czegos na ten temat. Zgadzasz sie i zabierasz kawalek metalu, by sprawdzic, czy miejscowy potrafi go rozpoznac. | Gdy potwory padly, chowasz miecz i przeszukujesz pobojowisko. Znajdujesz dziwny talizman z pior kruka i skory krowy. Chowasz go, liczac, ze %employer%, twoj zleceniodawca, bedzie cos o nim wiedzial.}",
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
			Text = "[img]gfx/ui/events/event_63.png[/img]{Wracajac do %employer% szybko wyjasniasz, ze nie bylo grabarzy, tylko grupa nieumarlych. Wyglada na wstrzasnietego, ale gdy pokazujesz znaleziony artefakt, zaciska usta i powaznie kiwa glowa.%SPEECH_ON%To... to z %necromancer_location%. Myslelismy, ze mozemy to miejsce zignorowac, ale chyba sie mylilem. Idz tam, najemniku, i zakoncz terror tej upiornej siedziby raz na zawsze!%SPEECH_OFF%Mezczyzna tonuje teatralnosc.%SPEECH_ON%Ach, i jestem gotow zaplacic ci dodatkowe %reward_completion% koron oprocz %reward_completion% koron za pierwotna robote, oczywiscie.%SPEECH_OFF% | Zastajesz %employer%a w gabinecie, powaznie siorbiacego z kielicha.%SPEECH_ON%Slyszalem juz wieci. Umarli chodza, oh, straszne nawet to wypowiedziec!%SPEECH_OFF%Kiwasz glowa i pokazujesz artefakt znaleziony na cmentarzu.%SPEECH_ON%Wiesz cos o tym?%SPEECH_OFF%Mezczyzna zerka na niego, jakby od razu wiedzial, ze go masz.%SPEECH_ON%Tak, to nalezy do %necromancer_location%. Myslelismy, ze mozemy zignorowac zlo z tamtego miejsca, ale... no coz. Moze tam pojdziesz? Moze zniszczysz %necromancer_location% i uwolnisz nas od tego koszmaru? Oto twoja pierwotna zaplata, jak uzgodnilismy, ale jesli pomożesz nam z %necromancer_location%, dostaniesz dodatkowe %reward_completion% koron. Brzmi dobrze?%SPEECH_OFF% | Wchodzisz do pokoju %employer%a i z hukiem kladziesz artefakt na jego biurku. Odsuwa go dlonia.%SPEECH_ON%Skad to masz?%SPEECH_OFF%Wskazujac palcem, naciskasz na mezczyzne.%SPEECH_ON%Wiedzials o nieumarlych na cmentarzu?%SPEECH_OFF%Speszenie odwraca wzrok, po czym kiwa glowa.%SPEECH_ON%Tak... wiedzialem. Oni i ten artefakt pochodza z %necromancer_location%. Mieszka tam jakis mroczny czarownik i od dluzszego czasu sprawia nam te... problemy. Prosze, mozesz tam pojsc i go zniszczyc? Oto zaplata za pierwotny kontrakt, ale zostaniesz sowicie wynagrodzony za pozbycie sie tego przekletego... kogos. Powiedzmy... kolejne %reward_completion% koron?%SPEECH_OFF% | Wyjasniasz %employer%owi, ze na cmentarzu nie bylo grabarzy ani zadnych ludzi. Zanim zdazy cos powiedziec, pokazujesz artefakt, trzymajac go w swietle. Mezczyzna szybko sie cofa.%SPEECH_ON%Odloz to!%SPEECH_OFF%Jego krzyk, niczym ognisty glos, zapala artefakt i ten spala sie bezbolesnie z twoich palcow, zostawiajac tylko wirujacy popiol. %employer% chowa twarz w dloniach.%SPEECH_ON%To z %necromancer_location%. Mieszka tam... nekromanta, pajak, ktory pociaga za sznurki, by martwi wstawali. Prosze, najemniku, idz tam i go zniszcz. Beda za to sowite laski...%SPEECH_OFF%Przerywa, wyciagajac sakiewke z koronami.%SPEECH_ON%To za to, na co sie pierwotnie zgodzilismy. Ale jesli zabijesz tego okropnego czlowieka w %necromancer_location%, po powrocie bedzie czekac na ciebie kolejne %reward_completion% koron.%SPEECH_OFF% | Przedstawiasz artefakt znaleziony na cmentarzu. %employer% wzdycha na sam jego widok, ale zaraz przybiera ponury wyraz twarzy.%SPEECH_ON%Powiem ci szczerze, najemniku. Niedaleko stad, w %necromancer_location%, mieszka nekromanta.%SPEECH_OFF%Wyciaga sakiewke z koronami i podaje ci ja.%SPEECH_ON%To za pierwotna robote. Jednak, jesli pojdziesz i zabijesz tego zlego czlowieka, oferuje kolejne %reward_completion% koron, wszystko, co zdołamy zebrac.%SPEECH_OFF%Opiera sie i patrzy z wielka nadzieja, ze przyjmiesz nowe warunki.}",
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
			Text = "[img]gfx/ui/events/event_57.png[/img]{To miejsce jest tak makabryczne, jak sobie wyobrazales, apogeum rozkladu i plugastwa. Jeszcze nie zauwazyles nekromanty, wiec lepiej posuwac sie bardzo ostroznie... | %necromancer_location% jest dokladnie tam, gdzie mowil %employer%. Znajdujesz sciezke z kosci prowadzaca dalej. Niektore z nich wciaz maja resztki miesa, byc moze nieudane nekromanckie twory, ktore nie przeszly od smierci do nieumarlych. Ignorujac okropnosci, zaczynasz planowac atak... | Miejsce takie jak %necromancer_location% jest tak zarosniete wysoka trawa, chwastami i sczernialymi drzewami, ze nie potrzebowaloby nawet tablicy 'wstep wzbroniony'. A jednak ja ma. To koszmar z kosci, potworny znak poskladany z ludzi i zwierzat, spogladajacy z krzyza, by odstraszac smialkow. Slimaki pelzaja przez oczodoly, a po konczynach pulsuja szlaki mrowek.\n\n %randombrother% podchodzi, wyraznie niespokojny tym widokiem, i pyta, jak chcesz zaatakowac. | Najpierw znajdujesz gryzonia z rozlozonymi konczynami, kazda mala lapa przybita szpilka do deski. Potem jest pies, z glowa kota. Przysiegalbys, ze to paskudztwo drgnelo, ale moze tylko ci sie wydaje. A potem... ludzie. Brak ci slow, by opisac, co sie z nimi stalo, ale to wieza okrucienstwa i apogeum zbrodni.\n\n%randombrother% staje obok ciebie.%SPEECH_ON%Skonczmy z tym szalencem.%SPEECH_OFF%Tak, skonczmy. Pytanie brzmi: jak zaatakowac najpierw?}",
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
			Text = "[img]gfx/ui/events/event_56.png[/img]{%necromancer_location% zostalo oczyszczone. Prawie czujesz sie swiety, ale potem pamietasz, ze zrobiles to dla zaplaty, a nie z jakiegos szlachetnego powodu. I tak przeciez nie wolisz tych drugich. | Nekromanta nie zyje, a w dloni trzymasz jego glowe. Teraz czas powiedziec temu glupcowi, %employer%owi, by zaplacil ci to, co sie nalezy. | To nie byla latwa walka, ale %necromancer_location% zostalo zniszczone. Nekromanta padl i jak kazdy czlowiek upadl w stos wlasnego miesa i kosci. Dziwne, ze jego sztuczki potrafily wskrzeszac zmarlych, ale nie dzialaly, gdy sam byl martwy. Dziwne, ale i szczesliwe. Zabierasz jego glowe, tak na wszelki wypadek. | Zabils nekromante, ale obawiajac sie, ze jego sztuczki moga dzialac nawet po smierci, odcinasz mu glowe i wkladasz do worka. %employer%, twoj zleceniodawca, bedzie zadowolony, widzac ja. | Po bitwie przykladasz miecz do szyi nekromanty i odcinasz mu glowe. Schodzi zadziwiajaco latwo, jakby sama chciala znalezc sie w twoich rekach. Tak czy inaczej, %employer%, twoj zleceniodawca, bedzie chcial to zobaczyc jako dowod twoich czynow.}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% usmiecha sie chytrze, gdy wracasz.%SPEECH_ON%Paskudna robota, prawda? Slyszalem juz wieci - tu rozchodza sie szybko. Szkoda, ze musielismy to zrobic w taki sposob, ale kto wie, ile bys zadał za walke z tymi... istotami.\n\nHej... i tak dostajesz zaplate.%SPEECH_OFF%Wskazuje na drewniana skrzynie w rogu.%SPEECH_ON%%reward_completion% koron jest w srodku, jak uzgodnilismy.%SPEECH_OFF% | %employer% slucha twojego raportu, po czym powoli odchyla sie na krzesle.%SPEECH_ON%Krazylo sporo plotek o tych... rzeczach. O chodzacych zmarlych?%SPEECH_OFF%Patrzy na biurko, po czym gniewnie spoglada na ciebie.%SPEECH_ON%Bzdury! Nie uwierze w to. Dostaniesz %reward_completion% koron, jak uzgodnilismy. Nie wycisniesz ze mnie nic wiecej tymi... tymi klamstwami!%SPEECH_OFF%Naprawde powinienes byl przyniesc jedna lub dwie glowy, ale z drugiej strony martwa glowa wyglada niemal tak samo jak nieumarla... | %employer% wysluchuje twojego raportu o nieumarlych i wzrusza ramionami.%SPEECH_ON%Co za szkoda.%SPEECH_OFF%Nonszalancko popija z kielicha i macha reka w strone rogu pokoju.%SPEECH_ON%Twoja zaplata jest w tej skrzyni. %randomname% cie odprowadzi.%SPEECH_OFF% | %employer% splata rece i opuszcza je na kolana.%SPEECH_ON%Slyszalem o tych... rzeczach. O tych szurajacych potwornosciach. To nie dobra wiadomosc, ze dotarly do %townname%, ale jesli maja byc gdziekolwiek, to cmentarz jest najlepszy! Lepszy niz rynek, prawda?%SPEECH_OFF%Nerwowo sie smieje.%SPEECH_ON%%randomname% stoi za drzwiami z twoja zaplata. Dziekuje, najemniku.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% wita cie w swoim pokoju.%SPEECH_ON%Zabiles ich wszystkich? Jest bezpiecznie?%SPEECH_OFF%Wzruszasz ramionami.%SPEECH_ON%Nikt nie bedzie rozkopywal grobow przez dlugi czas.%SPEECH_OFF% | Zastajesz %employer%a wygodnie usadowionego w krzesle, z plomieniem swiecy przy postrzepionym zwoju. Mowi, nie podnoszac wzroku.%SPEECH_ON%Moj problem, zalatwiles go?%SPEECH_OFF%Kiwasz glowa.%SPEECH_ON%Nie stalbym tu, gdybym tego nie zrobil.%SPEECH_OFF%%employer% wskazuje reka rog biurka.%SPEECH_ON%Twoja zaplata. %reward_completion% koron, jak uzgodnilismy.%SPEECH_OFF% | %employer% rozmawia z kilkoma ludzmi, gdy wracasz do jego pokoju. Rozsuwa ich i pyta o zadanie. Mowisz, ze znów bezpiecznie mozna grzebac bliskich z %townname%. %employer% sie usmiecha.%SPEECH_ON%Dobrze. Dobrze. Twoja zaplata.%SPEECH_OFF%Pstryka palcami i jeden z ludzi podchodzi, podajac sakiewke. Jest w niej %reward_completion% koron, jak obiecano.}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{Wracasz do %employer%a z glowa nekromanty. Jest niewiarygodnie lekka jak na ludzka glowe.%SPEECH_ON%To ta paskudna kreatura, ktora wyrywala nasze groby wraz z nieumarlymi?%SPEECH_OFF%Kiwasz glowa i kladziesz glowe na stole. Twarz sapie, a %employer% odskakuje.%SPEECH_ON%On wciaz zyje!%SPEECH_OFF%Wzruszasz ramionami i wbijasz sztylet w czaszke. Oczy nekromanty przewracaja sie ku jelcowi, zeby szczekaja jakby sie smial, potem oczy cofaja sie do oczodolow, a z ust wydostaje sie cienka smuga czerwonego dymu i to koniec. %employer%, drzac, siada i wskazuje sakiewke w rogu. To twoja zaplata i jest dosc ciezka. | %employer% siedzi, gdy wchodzisz do gabinetu, ale natychmiast wstaje i cofa sie na widok glowy nekromanty zwisajacej z twojej dloni.%SPEECH_ON%T-to on? Tak? To on? To juz koniec?%SPEECH_OFF%Kiwasz glowa i rzucasz glowe na jego biurko. Obraca sie twarza do dolu, chwiejac sie na zaciesnionych policzkach martwego usmiechu. %employer% odsuwa ja ksiazka.%SPEECH_ON%Dobrze. Swietnie! Jak obiecano, twoja zaplata...%SPEECH_OFF%Wskazuje rog, gdzie lezy {drewniane pudlo | duza sakiewka}. Zabierasz je, liczysz i wychodzisz. | %employer% podnosi wzrok znad ksiazki.%SPEECH_ON%Na bogow, czy to glowa nekromanty w twojej rece?%SPEECH_OFF%Kiwasz glowa i rzucasz ja na podloge. Kot schodzi ze swojej polki i zaczyna ja szturchac. %employer% wstaje, zdejmuje kilka ksiazek z polki i ujawnia duze pudlo. Bierze je i podaje ci.%SPEECH_ON%Zachowalem to na specjalne okazje i chyba ta jest jedna z nich.%SPEECH_OFF%Myslisz, ze to bedzie jakis przedmiot, moze amulet czy cos tajemniczego, ale w srodku jest tylko solidna kupa koron. | Wracajac do %employer%a, trzymasz glowe nekromanty w dloni, a mezczyzna szybko gestem prosi, bys mu ja oddal. Nie masz z tym problemu...\n\n%employer% unosi ja oburacz i bada, jakby trzymal chore niemowle. Po chwili odklada glowe w zacisku odlaczonej czesci trojzeba.%SPEECH_ON%Mysle, ze wyglada tu dobrze. Tez tak uwazasz, prawda?%SPEECH_OFF%Mezczyzna przyklada kciuk do bladej brody nekromanty. Oczyszczasz gardlo i pytasz o zaplate, na co %employer% wzywa jednego ze straznikow. Przynosza ci sakiewke, z ktorej odliczasz %reward_completion% koron. Zadowolony zostawiasz %employer%a z... czymkolwiek sie tam zajmuje.}",
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
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer% stoi przy oknie, gdy wchodzisz.%SPEECH_ON%Ptaki spiewaly dzis dosc gniewnie. Jakby nic, co mowia, nie bylo warte powiedzenia. Wydalo mi sie to ciekawe. Tobie tez?%SPEECH_OFF%Nagle odwraca sie do ciebie.%SPEECH_ON%Hmm, najemniku? Nie? Moje male ptaszki powiedzialy mi, ze grabarze opuscili miasto. Zywi. Wolni, by isc dokad chca, wolni, by wracac kiedy chca. Dziwne, bo zwykle martwi nie sa wolni do niczego. W co mialem ich zamienic?%SPEECH_OFF%Wahasz sie. Mezczyzna odpowiada za ciebie.%SPEECH_ON%Mialem ich uczynic martwymi. Teraz nimi nie sa. Teraz nie dostajesz zaplaty. Ot, proste. A teraz? Teraz wynosisz sie z mojego domu.%SPEECH_OFF% | %employer% smieje sie, gdy wchodzisz do jego pokoju.%SPEECH_ON%Szczerze, dziwi mnie, ze wrociles. Powinno mnie to obrazic, ze sadziles, iz nie bede wiedzial lepiej. Grabarzy widziano na drodze. Tych grabarzy, ktorych kazalem ci zabic. Pamietasz? Pamietasz, jak kazalem ich zabic? Na pewno. Na pewno pamietasz tez, ze za to wlasnie placilem. Wiec... brak martwych grabarzy...%SPEECH_OFF%Uderza piescia w biurko.%SPEECH_ON%Nie ma zaplaty! Wynocha z mojego domu!%SPEECH_OFF% | Zastajesz %employer%a na krzesle, obracajacego pusty kielich w rekach.%SPEECH_ON%Nie czesto trafiam na kogos, kto probuje mnie oszukac. To miales zrobic, wracajac tutaj, prawda? Wiem, ze grabarze nie sa martwi, najemniku. Nie jestem glupi. Zniknij mi z oczu, zanim moi ludzie cie zaszlachtuja.%SPEECH_OFF% | %employer% czyta ksiazke, gdy wchodzisz do jego pokoju.%SPEECH_ON%Masz dziesiec sekund, by sie obrocic i wyjsc. Dziesiec. Dziewiec. Osiem...%SPEECH_OFF%Rozumiesz, ze wie, iz grabarze nie zostali unieszkodliwieni.%SPEECH_ON%...cztery... trzy...%SPEECH_OFF%Odwracasz sie i pospiesznie wychodzisz z pokoju.}",
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
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer% zaciska usta.%SPEECH_ON%Postawiles mnie w dziwnej sytuacji, najemniku. Mowisz, ze grabarze zostali zalatwieni, a jednak... nie mam dowodu. Zwykle martwi zostawiaja sporo dowodow. Szczegolnie ci, ktorzy zgineli przed czasem.%SPEECH_OFF%Wzrusza ramionami.%SPEECH_ON%Zaplace ci polowe. Wezmiesz to i odejdziesz. Nastepnym razem przynies dowod. Jesli klamiesz... sam to ustale.%SPEECH_OFF% | Wracasz i zastajesz %employer%a dogladajacego ogrodu.%SPEECH_ON%Czasem sieje jedno warzywo, a wyrasta zupelnie inne. Jak to sie dzieje? Czy oszukalem samego siebie? Czy ty probujesz oszukac mnie? Mowisz, ze grabarze nie zyja, ale moi ludzie przeszukali cmentarz i nie znaleźli zadnego dowodu. Nie znaleźli tez samych grabarzy, i prosze...%SPEECH_OFF%Unosi dlon.%SPEECH_ON%Nie probuj mi wmawiac, ze zrobiles z ich cialami to czy tamto. Wiec tak to zrobimy, najemniku. Zaplace ci polowe i bede tu siedzial, zastanawiajac sie, czy mnie oklamales. Brzmi dobrze? Dobrze.%SPEECH_OFF% | %employer% usmiecha sie, gdy mowisz mu, ze problem zostal rozwiazany.%SPEECH_ON%To dobra wiadomosc. Niestety moi ludzie przeszukali cmentarz i nie znaleźli zadnych dowodow na martwych grabarzy. Ciekawy obrot spraw, ale nie bede cie tu trzymal, gdy ustalam, co dokladnie sie tam stalo. Wiec... zaplace ci polowe. Nastepnym razem przynies mi dowod. Albo... nie klam. Nie wiem, co u ciebie zachodzi.%SPEECH_OFF%}",
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

