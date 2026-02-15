this.drive_away_nomads_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		Reward = 0
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.drive_away_nomads";
		this.m.Name = "Przepędzenie Koczowników";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local banditcamp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getNearestSettlement(this.m.Home.getTile());
		this.m.Destination = this.WeakTableRef(banditcamp);
		this.m.Flags.set("DestinationName", banditcamp.getName());
		this.m.Payment.Pool = 600 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Przepędź koczowników z miejsca zwanego " + this.Flags.get("DestinationName") + " na %direction% od %origin%"
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				this.Contract.m.Destination.clearTroops();
				this.Contract.m.Destination.setLastSpawnTimeToNow();

				if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.NomadDefenders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.m.Destination.setDiscovered(true);
				this.Contract.m.Destination.resetDefenderSpawnDay();
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					if (this.Contract.getDifficultyMult() >= 0.95 && this.World.Assets.getBusinessReputation() > 700)
					{
						this.Flags.set("IsSandGolems", true);
					}
				}
				else if (r <= 25)
				{
					if (this.Contract.getDifficultyMult() >= 0.95 && this.World.Assets.getBusinessReputation() > 300)
					{
						this.Flags.set("IsTreasure", true);
						this.Contract.m.Destination.clearTroops();
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.NomadDefenders, 150 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					}
				}
				else if (r <= 35)
				{
					if (this.World.Assets.getBusinessReputation() > 800)
					{
						this.Flags.set("IsAssassins", true);
					}
				}
				else if (r <= 45)
				{
					if (this.World.getTime().Days >= 3)
					{
						this.Flags.set("IsNecromancer", true);
						this.Contract.m.Destination.clearTroops();
						local zombies = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies);
						this.World.FactionManager.getFaction(this.Contract.m.Destination.getFaction()).removeSettlement(this.Contract.m.Destination);
						this.Contract.m.Destination.setFaction(zombies.getID());
						zombies.addSettlement(this.Contract.m.Destination.get(), false);
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.NecromancerSouthern, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					}
				}
				else if (r <= 50)
				{
					this.Flags.set("IsFriendlyNomads", true);
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

					if (this.Flags.get("IsNecromancer"))
					{
						this.Contract.m.Destination.m.IsShowingDefenders = false;
					}
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsTreasure"))
					{
						this.Flags.set("IsTreasure", false);
						this.Contract.setScreen("Treasure2");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setState("Return");
					}
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (this.Flags.get("IsSandGolems"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("SandGolems");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.OrientalBanditTracks;
						properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
						local e = this.Math.max(1, 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult() / this.Const.World.Spawn.Troops.SandGolem.Cost);

						for( local i = 0; i < e; i = i )
						{
							properties.Entities.push({
								ID = this.Const.EntityType.SandGolem,
								Variant = 0,
								Row = -1,
								Script = "scripts/entity/tactical/enemies/sand_golem",
								Faction = this.Const.Faction.Enemy
							});
							i = ++i;
						}

						this.World.Contracts.startScriptedCombat(properties, true, true, true);
					}
				}
				else if (this.Flags.get("IsTreasure") && !this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Contract.setScreen("Treasure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsNecromancer") && !this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Contract.setScreen("Necromancer");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAssassins"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Assassins");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.OrientalBanditTracks;
						properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
						local e = this.Math.max(1, 30 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult() / this.Const.World.Spawn.Troops.Assassin.Cost);

						for( local i = 0; i < e; i = i )
						{
							properties.Entities.push({
								ID = this.Const.EntityType.Assassin,
								Variant = 0,
								Row = 2,
								Script = "scripts/entity/tactical/humans/assassin",
								Faction = this.Contract.m.Destination.getFaction()
							});
							i = ++i;
						}

						this.World.Contracts.startScriptedCombat(properties, true, true, true);
					}
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
					this.Contract.setScreen("Success1");
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
			Text = "[img]gfx/ui/events/event_163.png[/img]{Nie ma trąb, konfetti ani okrzyków, ale i tak czuć pewien poziom pompy, gdy wchodzisz do komnaty %employer%a. Jest tak ozdobiona złotem i srebrem, misterną biżuterią wykonaną przez prawdziwych rzemieślników i haremem najpiękniejszych kobiet, że nie sposób nie poczuć chęci spełnienia każdej prośby, choćby po to, by mieć szansę dołączyć do tych codziennych uczt. %employer% siedzi na stercie poduszek.%SPEECH_ON%Ach, Koroniarzu. Spodziewałem się ciebie. Proszę, nie podchodź bliżej, spłoszysz moje atrakcje. Mam dla ciebie proste zadanie. Koczownicy plądrują moje karawany, przez co w skarbcach mam mniej monet. Zapewne wiesz, jak to jest być czegoś pozbawionym, prawda? Ach, wyglądasz tak tępo. Tak pusto. Tak, cóż, zajęty tym, co robisz. Potrzebuję, by tych koczowników zabito, i jestem gotów zapłacić %reward% koron za wykonanie. Czy ten język trafia do tego, co masz między uszami?%SPEECH_OFF% | %employer% częściowo siedzi na tronie z jedwabnych poduszek, a częściowo na ciałach haremu pięknych kobiet. Unosi rękę.%SPEECH_ON%Jeśli podejdziesz dalej, Koroniarzu, będziesz większy w oczach, ale mniejszy w znaczeniu, rozumiesz? Mądry człowiek zna swoje miejsce. Mam proste zadanie dla twojej ręki z mieczem. Koczownicy za %townname% oddali się kradzieży i rozbójnictwu. Za hojną zapłatę chcę, byś unicestwił tych ludzi, którzy uprzykrzają mi życie.%SPEECH_OFF% | Zastajesz %employer%a karmiącego ptaka w klatce. Ptak jest mozaiką barw, których nie jesteś pewien, czy kiedykolwiek wcześniej widziałeś. Wyczuwając twoją obecność, albo może ją wąchając, %employer% odwraca się z cieniem obrzydzenia.%SPEECH_ON%Straszysz mojego ptaka, Koroniarzu, więc będę krótki dla jego dobra. Koczownicy krążą po obrzeżach moich ziem i potrzebuję, by ich zniszczono. Jestem pewien, że człowiek twojej, eee, pozycji, zechce podjąć się tak prostego, łatwego zadania?%SPEECH_OFF% | Wchodzisz do komnaty %employer%a. Zajada się owocami, a jego dolna połowa jest zatopiona w morzu ciał, haremie opiekunek, które głośno pracują. Stoisz bezczynnie zbyt długo, otwierasz usta, ale mężczyzna unosi rękę. Wskazuje na jednego ze sług i pstryka palcami. Sługa przemyka po marmurowej posadzce w sandałach o jedwabnych podeszwach. Podaje ci kartkę. Widnieje na niej:%SPEECH_ON%Dla zainteresowanych Koroniarzy: koczownicy zakłócają spokój wokół %townname%. Należy się z nimi rozprawić niezwłocznie za nagrodę %reward% koron. Niezainteresowani mają natychmiast odejść.%SPEECH_OFF%Sługa patrzy na ciebie, czekając na odpowiedź. | %employer% wzdycha, gdy wchodzisz do jego komnaty.%SPEECH_ON%Ach, Koroniarz, prawie zapomniałem, że prosiłem wasz sort, by przyszedł i zepsuł mi dzień.%SPEECH_OFF%Patrzysz na Wezyra, który jest zbyt ociężały, by wydostać się z morza poduszek i haremu kobiet, które mają za zadanie je każdą z osobna napuszyć.%SPEECH_ON%Cóż, przypuszczam, że zbrudzę godzinę, byleby sprawę załatwić. Koczownicy pustoszą moje karawany, jak to mają w zwyczaju, a przez to moje rynki są pozbawione pewnych dóbr, których pragnę. Oferuję %reward% koron za odnalezienie i zniszczenie tych piaszczystych robaków.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Porozmawiajmy nieco więcej o zapłacie. | Mogę sprawić, że ten problem zniknie.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Nie jestem zainteresowany. | Mamy ważniejsze sprawy do załatwienia. | Życzę wam powodzenia, ale nie weźmiemy w tym udziału.}",
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
			ID = "Treasure1",
			Title = "Przed atakiem...",
			Text = "[img]gfx/ui/events/event_54.png[/img]{Koczownicy są zaskakująco nieruchomi i zaskakująco liczni, ale wygląda na to, że jest ku temu powód: znajdujesz mieszkańców pustyni skupionych wokół dziury w ziemi. Zbudowali wokół niej bloczki i gorączkowo pracują, by wyciągnąć to, co znaleźli na pustyni. Sądząc po uśmiechu człowieka nadzorującego pracę, bez wątpienia jest to skarbiec.\n\nMożesz zaatakować teraz i stawić czoła większemu oporowi, albo poczekać, aż skończą i odejdą z tym, co wykopią.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Atakujemy teraz!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				},
				{
					Text = "Poczekamy, aż skończą i obóz będzie nieco słabiej chroniony.",
					function getResult()
					{
						return "Treasure1A";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Treasure1A",
			Title = "Przed atakiem...",
			Text = "[img]gfx/ui/events/event_54.png[/img]{Czekasz, aż koczownicy wyciągną skarb. Jak można się było spodziewać, jest to skrzynia. Gdy ją otwierają, na ich twarzach pojawia się cień satysfakcji. I, jak również można się było spodziewać, koczownicy rozdzielają się, a oddział ich najsilniejszych ludzi odchodzi ze skarbem, zapewne by sprzedać go gdzieś dalej. Obóz koczowników jest teraz słabszy i znacznie bardziej podatny na atak...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Przygotować się do ataku!",
					function getResult()
					{
						this.Flags.set("IsTreasure", false);
						this.Contract.m.Destination.clearTroops();
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.NomadDefenders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Treasure2",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_168.png[/img]{Gdy koczownicy są martwi, naturalnie idziesz sprawdzić, co do diabła wykopywali z ziemi. Stajesz nad bloczkiem, który zbudowali, i zaglądasz do dziury. Widać skrzynię z już przywiązanymi linami. Dziękujesz martwym koczownikom za wykonaną robotę, po czym bez trudu wyciągasz skrzynię na powierzchnię. Otwierasz ją i znajdujesz...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Skarb!",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				local e = 2;

				for( local i = 0; i < e; i = i )
				{
					local item;
					local r = this.Math.rand(1, 4);

					switch(r)
					{
					case 1:
						item = this.new("scripts/items/loot/ancient_gold_coins_item");
						break;

					case 2:
						item = this.new("scripts/items/loot/silverware_item");
						break;

					case 3:
						item = this.new("scripts/items/loot/jade_broche_item");
						break;

					case 4:
						item = this.new("scripts/items/loot/white_pearls_item");
						break;
					}

					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Zdobywasz " + item.getName()
					});
					i = ++i;
				}
			}

		});
		this.m.Screens.push({
			ID = "SandGolems",
			Title = "Przed atakiem...",
			Text = "[img]gfx/ui/events/event_160.png[/img]{Gdy szykujesz się do ataku, mężczyzna nagle wyłania się z piasku. Przerażony, odskakuje i krzyczy, staczając się po wydmie w stronę obozu koczowników. Ruszasz za nim z bronią w dłoni, gotów zabijać. W skaczącym kącie oka widzisz, jak koczownicy wspinają się po sobie i przewracają namioty, by dostać się do broni. Gdy spoglądasz z powrotem na zwiadowcę, nagle znika w piasku, a ramię przytwierdzone do wydmy wysuwa się z ziemi i wyrasta przed tobą, z którego opada kurz, piasek i ziemia.\n\nLedwo pojmujesz, co widzisz, ale wszyscy koczownicy krzyczą to samo: 'Ifrit! Ifrit! Ifrit!' A ten bez twarzy, pozornie niekończący się 'Ifrit' nie będzie miał żadnych sojuszy w nadchodzącej walce. | Szarżujesz w dół wydm na koczowników. Zaskoczeni wydają rozkazy i biegną po broń. Gdy zbliżasz się do obozu, fala piasku uderza w jego skraj i kilku koczowników leci w powietrze. Sekundę później z chmury pyłu wylatuje głaz i całkowicie miażdży koczownika. Ogromna, ziemna bestia ryczy i stąpa do przodu. 'Ifrit! Ifrit!' krzyczą koczownicy, a ty zakładasz, że ten 'Ifrit' nie stanie po niczyjej stronie.}",
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
			ID = "Assassins",
			Title = "Przed atakiem...",
			Text = "[img]gfx/ui/events/event_165.png[/img]{Szarżujesz na obóz akurat w chwili, gdy z jednego z namiotów wychodzi mężczyzna w czarnych ubraniach. Ściska dłoń przywódcy koczowników, co pewnie nie jest dobrym znakiem. Obaj zatrzymują się w pół uścisku i patrzą na twoją szarżę, co zapewne jest równie złym rezultatem. Przywódca koczowników wydaje okrzyk, żądając, by jego zabójcy zasłużyli na zapłatę. Czarny morderca kiwa głową i dobywa ostrza, a z namiotu wylewa się oddział innych zabójców, by dołączyć do koczowników w walce!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Na nich!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Necromancer",
			Title = "Przed atakiem...",
			Text = "[img]gfx/ui/events/event_161.png[/img]{Podarte namioty. Rozplecione kosze. Ubrania toczące się po piasku. A pośrodku tego wszystkiego siedzi mężczyzna w czarnym płaszczu, a jego upiorna twarz wygląda z cienia kaptura.%SPEECH_ON%Jesteście i spóźnieni, i na czas.%SPEECH_OFF%Mówi i podnosi się. Plandeki szeleszczą, kosze się przechylają, a ubrania odsuwają na bok, a ziemia drga życiem. Nagle piasek osuwa się w szerokie kanały i wrodzy koczownicy wynurzają się z ziemi, wyłażąc na powierzchnię, jedni wyskakują, jakby mieli ożyć na świeżym powietrzu, inni prostują się od pięt po czubki głów, ciała mając sztywne jak maszty. Poruszają się niepokojąco, sztywno i przechylając się, a człowiek w czerni uśmiecha się zza ich chwiejnej formacji. To nie zwykły łotr, lecz nekromanta!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Sługa zatrzymuje cię przed spotkaniem z %employer%em. Podaje ci zwój i sakiewkę. Mimo że już przekazał ci papier, splata ręce za plecami i spogląda w sufit, recytując.%SPEECH_ON%Koroniarz otrzymuje %reward_completion% koron zgodnie z wcześniejszymi ustaleniami. Po odebraniu nagrody zostaje natychmiast odesłany z posiadłości.%SPEECH_OFF%Sługa spogląda na ciebie i kiwa głową.%SPEECH_ON%Odejdź.%SPEECH_OFF%Mówi. | Próbujesz wejść do komnaty %employer%a, ale duży, poznaczony bliznami strażnik opuszcza drzewce broni drzewcowej w poprzek wejścia.%SPEECH_ON%Brak wizyt.%SPEECH_OFF%Mówisz, że masz sprawy z Wezyrem. Strażnik kręci głową. Sługa podchodzi zza twoich pleców, wkłada ci sakiewkę w ramiona i znika równie szybko. Strażnik odkłada broń na bok.%SPEECH_ON%Twoje błahostki z Wezyrem zakończyły się, gdy po raz pierwszy opuściłeś jego oblicze. Nie wolno ci dalej psuć mu nastroju. Wynoś się. Teraz. Zanim zepsujesz mój.%SPEECH_OFF% | Gdy zbliżasz się do komnaty %employer%a, kobieta klaszcze z drugiego końca holu. Odwracasz się i jest już zdecydowanie za blisko. Na jej ramionach siedzą cztery ptaki, kołyszące się z każdym krokiem.%SPEECH_ON%Koroniarzu.%SPEECH_OFF%Wyciąga sakiewkę i podaje ją tobie.%SPEECH_ON%%employer% nie musi wąchać cię ponownie, tak daleko w jego domu to aż nadto. Policz, jeśli chcesz nas obrazić, odejdź, jeśli chcesz nas ucieszyć.%SPEECH_OFF%Odwraca się na pięcie i odchodzi, a jej nieziemska szata faluje na boki. Jeden z ptaków obraca się na jej ramieniu i skrzeczy na ciebie.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Cóż, dostaliśmy zapłatę.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Zniszczyłeś obozowisko koczowników");
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
			"totalenemy",
			this.m.Destination != null && !this.m.Destination.isNull() ? this.beautifyNumber(this.m.Destination.getTroops().len()) : 0
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Destination.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0 && this.World.getTime().Days > 3 && this.Math.rand(1, 100) <= 50)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/ambushed_trade_routes_situation"));
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

				if (this.m.Flags.get("IsNecromancer"))
				{
					local nomads = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits);
					this.World.FactionManager.getFaction(this.m.Destination.getFaction()).removeSettlement(this.m.Destination);
					this.m.Destination.setFaction(nomads.getID());
					nomads.addSettlement(this.m.Destination.get(), false);
				}
			}

			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Home != null && !this.m.Home.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Home.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(4);
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

