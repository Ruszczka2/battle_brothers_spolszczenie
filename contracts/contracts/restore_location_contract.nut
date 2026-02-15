this.restore_location_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Caravan = null,
		Location = null,
		IsEscortUpdated = false
	},
	function setLocation( _l )
	{
		this.m.Location = this.WeakTableRef(_l);
	}

	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = this.Math.rand(70, 90) * 0.01;
		this.m.Type = "contract.restore_location";
		this.m.Name = "Próba Odbudowy";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 300 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Zabezpiecz zniszczoną lokację (%location%) w pobliżu %townname%"
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

				if (r <= 15)
				{
					this.Flags.set("IsEmpty", true);
				}
				else if (r <= 30)
				{
					this.Flags.set("IsRefugees", true);
				}
				else if (r <= 60)
				{
					this.Flags.set("IsSpiders", true);
				}
				else
				{
					this.Flags.set("IsBandits", true);
				}

				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Zabezpiecz zniszczoną lokację (%location%) w pobliżu %townname%"
				];
				this.Contract.m.Location.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Location))
				{
					if (this.Flags.get("IsVictory"))
					{
						this.Contract.setScreen("Victory");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("ReturnForEscort");
					}
					else if (this.Flags.get("IsFleeing"))
					{
						this.Contract.setScreen("Failure2");
						this.World.Contracts.showActiveContract();
						return;
					}
					else if (this.Flags.get("IsEmpty"))
					{
						this.Contract.setScreen("Empty");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsRefugees"))
					{
						this.Contract.setScreen("Refugees1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsSpiders"))
					{
						this.Contract.setScreen("Spiders");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsBandits"))
					{
						this.Contract.setScreen("Bandits");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "RestoreLocationContract")
				{
					this.Flags.set("IsVictory", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "RestoreLocationContract")
				{
					this.Flags.set("IsFleeing", true);
				}
			}

		});
		this.m.States.push({
			ID = "ReturnForEscort",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Wróć do %townname%"
				];
				this.Contract.m.Location.getSprite("selection").Visible = false;
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
		this.m.States.push({
			ID = "Escort",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Odeskortuj robotników do: %location% w pobliżu %townname%"
				];
				this.Contract.m.Location.getSprite("selection").Visible = true;
				this.Contract.m.Home.getSprite("selection").Visible = false;
			}

			function update()
			{
				if (this.Contract.m.Caravan == null || this.Contract.m.Caravan.isNull() || !this.Contract.m.Caravan.isAlive() || this.Contract.m.Caravan.getTroops().len() == 0)
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (!this.Contract.m.IsEscortUpdated)
				{
					this.World.State.setEscortedEntity(this.Contract.m.Caravan);
					this.Contract.m.IsEscortUpdated = true;
				}

				this.World.State.setCampingAllowed(false);
				this.World.State.getPlayer().setPos(this.Contract.m.Caravan.getPos());
				this.World.State.getPlayer().setVisible(false);
				this.World.Assets.setUseProvisions(false);
				this.World.getCamera().moveTo(this.World.State.getPlayer());

				if (!this.World.State.isPaused())
				{
					this.World.setSpeedMult(this.Const.World.SpeedSettings.EscortMult);
				}

				this.World.State.m.LastWorldSpeedMult = this.Const.World.SpeedSettings.EscortMult;

				if (this.Flags.get("IsFleeing"))
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
					return;
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Location))
				{
					this.Contract.setScreen("RebuildingLocation");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("IsFleeing", true);

				if (this.Contract.m.Caravan != null && !this.Contract.m.Caravan.isNull())
				{
					this.Contract.m.Caravan.die();
					this.Contract.m.Caravan = null;
				}
			}

			function end()
			{
				this.World.State.setCampingAllowed(true);
				this.World.State.setEscortedEntity(null);
				this.World.State.getPlayer().setVisible(true);
				this.World.Assets.setUseProvisions(true);

				if (!this.World.State.isPaused())
				{
					this.World.setSpeedMult(1.0);
				}

				this.World.State.m.LastWorldSpeedMult = 1.0;
				this.Contract.clearSpawnedUnits();
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Wróć do %townname%"
				];
				this.Contract.m.Location.getSprite("selection").Visible = false;
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success2");
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% częstuje chlebem i piwem, a sam chętnie korzysta. Po krótkiej pogawędce o tym, jak podoba ci się %townname%, przechodzi do rzeczy.%SPEECH_ON%Ten region bywał zamożny, ale wiele naszych dóbr zostało splądrowanych, spalonych lub przejętych przez zbójów. Musimy, byś udał się do %location% poza %townname% i oczyścił je z lokatorów, tak abyśmy mogli bezpiecznie wysłać tam materiały i nasi rzemieślnicy odbudowali to, co kiedyś mieliśmy.%SPEECH_OFF%Nachyla się nad stołem i patrzy na ciebie stanowczo.%SPEECH_ON%Czy jesteś gotów nam w tym pomóc?%SPEECH_OFF% | %employer% odgryza kęs jabłka i rzuca resztę w twoją stronę. Łapiesz ją i patrzysz na mężczyznę, nie do końca wiedząc, co z tym zrobić. Gdy nic nie mówi, odgryzasz kęs i odrzucasz mu, dziękując.%SPEECH_ON%Nie ma problemu, najemniku. Dzień całkiem przyzwoity, choć oczywiście czegoś od ciebie potrzebuję. %location% pod %townname% jest, jak sądzę, siedliskiem zbójów. Wystarczy, że pójdziesz tam i ich przegonisz, abym mógł przywrócić temu miejscu dawny, bezpieczny blask. Pasuje ci to do twoich... interesów?%SPEECH_OFF% | %employer% wzdycha, gdy pozwala, by zwój wysunął mu się z palców, jakby wieści były zbyt ciężkie.%SPEECH_ON%Nie dostajemy dość koron z %townname% i wierzę, że to dlatego, że zbóje mogli przejąć %location%. To nie jest całkiem potwierdzone... powinienem lepiej śledzić wieści o moich ludziach, ale wiesz, jak jest.%SPEECH_OFF%Wzruszasz ramionami.%SPEECH_ON%W każdym razie chcę, żebyś tam poszedł, znalazł problem, a potem wrócił do mnie po dalsze instrukcje. Brzmi dość prosto, prawda?%SPEECH_OFF% | Pochylając się w fotelu, %employer% wskazuje mapę rozłożoną na biurku.%SPEECH_ON%%location% pod %townname% zostało zniszczone przez zbójów. Teraz, najemniku, potrzebuję twoich usług, by odzyskać teren i pomóc mi przywrócić mu dawną świetność, albo cokolwiek tam dziś opowiadam chłopom. Jesteś zainteresowany?%SPEECH_OFF% | %employer% wzdycha, a jego oddech ulatuje w jedną stronę, podczas gdy ciało osuwa się w fotel w drugą.%SPEECH_ON%Jako dzieciak odwiedzałem %location%. To było takie zamożne miejsce, a teraz leży w ruinie przez jakichś włóczęgów. Oczywiście nie rozmawiam z tobą tylko z sentymentu. Potrzebuję, byś tam poszedł i odzyskał to miejsce! Zabij tych zbójów, a potem natychmiast do mnie wróć. Interesuje cię to proste zadanie?%SPEECH_OFF% | %employer% zarzuca nogi na biurko, przewracając pusty kielich.%SPEECH_ON%Chłopi znów dają mi się we znaki. Mówią, że %location% pod %townname% zostało zniszczone. Zwykle nie biorę słów głupców za pewnik, ale kilku moich rajców zdaje się to potwierdzać. Więc teraz muszę coś z tym zrobić.%SPEECH_OFF%Wskazuje na ciebie palcem, uśmiechając się przy tym.%SPEECH_ON%I tu wchodzisz ty. Idź do %location%, zabij tych niesfornych włóczęgów, a potem wróć do mnie. Jak ci to brzmi?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Brzmi jak łatwa robota. | Porozmawiajmy o koronach.}",
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
			ID = "Empty",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Po dotarciu do %location% rozsyłasz ludzi i powoli wkradasz się na teren. Sam wchodzisz, ostrożnie kierując się ku budynkom, których okna gwiżdżą od porywów wiatru. Po sprawdzeniu okazuje się, że nie ma tu nikogo. Nawet śladów, że ktoś dopiero co wyszedł. Zbierasz ludzi i wracasz, by poinformować %employer%. | %location% jest zaskakująco puste. Kręcisz się po jednym z domów, podnosisz zakurzone kubki i przewracasz słomiane posłania, ale nie znajdujesz ani owada, ani człowieka. Miejsce jest całkowicie opuszczone. Wracasz przekazać %employer% wieści. | Na skraju %location% kiwa się straszak, a jego drewniane pobrzękiwanie to jedyny oznak życia. Jeśli ktoś tu mieszkał, odszedł dawno temu. Budynki stoją puste. Wydrążone. Po samym wyglądzie widać, że nikogo w środku nie ma. Nawet starzy bogowie mogliby zniszczyć to miejsce i nikt by nie wiedział ani się nie przejął. Smutne. Lepiej przekazać %employer% tę 'dobrą' wieść. | %location% jest opuszczone, tak jak się spodziewałeś, ale nie ma tu ani jednego zbója czy włóczęgi. Nie możesz ich winić, że nie chcieli tego miejsca: choć stoi kilka budynków, wszystko tu budzi niepokój. Stare, kruche... nawiedzone? Jakby kryło niewyobrażalne zbrodnie. Może robotnicy %employer% wszystko zburzą i zaczną od nowa. | W %location% nie ma ani jednego zbója. Połowa budynków jest zniszczona, druga połowa stoi pusta i opuszczona. Kilku robotników %employer% pewnie doprowadziłoby to miejsce do ładu, więc najlepiej wróć i go poinformuj. | Znajdujesz chorągiewkę wiatrową utkwioną w błocie i padlinę krowy obok. Zagroda dla świń porosła świeżą zieloną trawą. Jeden z budynków został obmalowany pnączami. Krzyże na cmentarzu są przekrzywione, niektóre leżą na ziemi. Znajdujesz łopatę i dół obok. Woda wypełniła nieużywany grób, a niebieskie ptaki się w nim kąpią. Zastanawiasz się, czy nie lepiej zostawić to miejsce takim, jakie jest, ale to nie twoja sprawa. Wracasz poinformować %employer% o sytuacji. | Wchodzisz do %location% i rozsyłasz ludzi, by przeszukali budynki. Nie chcąc zostawić śledztwa tylko najemnikom, wchodzisz do pobliskiego domu. Drzwi odchodzą z odłupującym się drewnem, a niemal od razu stopa roztrzaskuje stertę garnków i patelni pozostawionych na klepisku. Brnąc dalej, dostrzegasz w rogu kilka martwych myszy, ich szkielety zastygłe w biegu, a obok leży martwy kot. W krokwiach jest ptasie gniazdo. Pożółkłe jaja wyglądają spod skorupek, ale nie widziałeś ani nie słyszałeś żadnego ptaka.\n\n%randombrother% wchodzi przez drzwi i mówi, że nic nie znaleziono. Jeśli zbóje tu byli, odeszli dawno temu. Każesz najemnikowi zebrać ludzi, bo czas zameldować %employer% o ustaleniach.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nie tego się spodziewałem.",
					function getResult()
					{
						this.Contract.setState("ReturnForEscort");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Bandits",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Każesz ludziom rozproszyć się po %location%. Skradasz się z mieczem w dłoni. Gdy skręcasz za róg, widzisz mężczyznę kucającego nad latryną. Na twój widok trzęsą mu się kolana. Gdy sięga po broń, przebijasz go na wylot, szybko strącając ciało z ostrza i ostrzegając ludzi o zbójach, którzy zaczynają wychodzić z pobliskich budynków. | %location% jest ciche, ale nie dość. Tu i tam słychać trzeszczenie drewna, brzęk przesuwanych łańcuchów. Ludzie są na miejscu. Dobywasz miecza i każesz ludziom szykować się do walki. Ledwie to robisz, zbój wyważa drzwi budynku i wybiega, a za nim wysypuje się gromada równie krzykliwych typów. | Zbóje! Dokładnie tak, jak się spodziewałeś. Nie dość, że są w %location%, to jeszcze zupełnie nie przejmują się tym, jak są na widoku. Gdy twoi ludzie zbliżają się do miejsca, zbóje leniwie zbierają broń, jakby już mieli do czynienia z takimi jak wy. | %location% jest całkiem puste - poza dużą bandą zbójów w środku, kucających wokół ognia i pieczonej świni. Spoglądają na ciebie, na świnię, potem znów na ciebie. Jeden wyciąga mięsny widelec z ognia.%SPEECH_ON%Do licha, panie, my tylko chcemy zjeść.%SPEECH_OFF%Dobywasz miecza i kiwasz głową.%SPEECH_ON%Ja też.%SPEECH_OFF% | Tuż przed %location% spotykasz zbója. Niesie ciało chłopa, co jest dość dowodem, by zabić jego i wszystkich jego kumpli. Rozkazujesz ludziom atakować. | Zbóje rozbiegają się od ogniska, gdy zbliżasz się do %location%. O dziwo, zbroją się i wychodzą bronić świeżo zdobytego 'terytorium'.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.BanditTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "RestoreLocationContract";
						p.TerrainTemplate = "tactical.plains";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.Template[0] = "tactical.human_camp";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.None;
						p.LocationTemplate.CutDownTrees = true;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.BanditScouts, 90 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Spiders",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_110.png[/img]{Białe, bezwładnie skręcające się na wietrze nici z siedzib %location% wyglądają jak dym, ale budynki są nienaruszone. Gdy zbliżasz się do domostw, w mroku okien rozbłyskują pary czerwonych oczu. Pajęczaki wybiegają, ich kolczaste nogi grzechoczą o deski i drapią faliste dachy, a masa czarnych ciał wypada z ram okien niczym płatki tlącego się mniszka. | Zastajesz %location% opuszczone, ale jedwabista, biała powłoka pokrywa każdy kąt, a jej strzępy bezwładnie wiją się na wietrze. %randombrother% dotyka końca jednej z nici, ta rozciąga się wraz z jego ramieniem i musi się uwolnić, przecinając ją. Patrząc przed siebie, widzisz, jak pajęczaki pędzą ku wam, ich kolczaste nogi tną powietrze z przerażającą prędkością, a szczęki kłapią z głodu.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.BeastsTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "RestoreLocationContract";
						p.TerrainTemplate = "tactical.plains";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Spiders, 90 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Refugees1",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_59.png[/img]{%location% jest pełne ludzi, owszem, ale to nie zbóje. Uchodźcy zalegają to miejsce jak ruchome śmieci szukające odpoczynku. Obmierzli mężczyźni, kobiety, a nawet dzieci kręcą się potulnie, zbyt słabi, by zwracać uwagę na stojącą przed nimi kompanię. %randombrother% podchodzi i pyta, co należy zrobić.\n\n Jeśli pozwolisz im zostać, %employer% nie będzie zadowolony i pewnie nie zobaczysz zapłaty. Z drugiej strony... spójrz tylko na ten nędzny tłum. Zasługują na odpoczynek od tego, co ich tu sprowadziło. | Odsuwasz lunetę od oka i kręcisz głową. %location% jest pełne - a może zarażone - uchodźcami. Lepsze niż zbóje, ale wciąż problem. %employer% nie będzie zadowolony, to pewne. Z drugiej strony ci ludzie... obdarte szmaty... bardziej kości niż mięso... zmęczeni... nie zasługują na to, by znowu wyrzucić ich na drogę, prawda? | %randombrother% odwraca się i spluwa. Opiera pięści na biodrach i kręci głową.%SPEECH_ON%Cholera.%SPEECH_OFF%Przed tobą i resztą kompanii stoi barwna grupa uchodźców. Dwudziestu, może trzydziestu. Głównie mężczyźni. Reszta grupy, kobiety i dzieci, pewnie ukrywają się w okolicy. Zmęczony tłum wygląda na zbyt wyczerpany, by w ogóle z wami rozmawiać. Wymieniają tylko spojrzenia i od czasu do czasu posłuszne wzruszenie ramion.\n\n Jeden z braci odzywa się z twojej strony.%SPEECH_ON%Musimy ich wykopać, jeśli chcemy pieniędzy od %employer%...%SPEECH_OFF%Ale wtedy inny brat odzywa się z drugiej strony...%SPEECH_ON%Tak, ale spójrz na tych ludzi. Naprawdę możemy ich wygnać? Niech zostaną, mówię.%SPEECH_OFF% | Uchodźcy zajęli %location%, zapewne ocaleni z jakiejś wojny. Przeszukali teren pod kątem zasobów i wyglądają na zadomowionych. Wiesz, że %employer% nie będzie zadowolony z ich obecności - nie wyglądają na miejscowych. %randombrother% podchodzi i wskazuje na obdartych, zmęczonych obcych.%SPEECH_ON%Mogę wziąć kilku ludzi i ich przegonić, panie. Będzie łatwo.%SPEECH_OFF% | Nie ma w zasięgu wzroku żadnego zbója. Zamiast tego znajdujesz dużą grupę uchodźców, która zajęła %location%. Zmęczone dusze dobrze się tu zadomowiły: gotują strawę w kilku kociołkach nad trzaskającymi ogniskami i wydają się całkiem zadowolone ze swojego nowego 'domu'. Ale %employer% nie będzie zadowolony z ich obecności. Wcale. Nie chcesz w to wierzyć, ale zimna prawda jest taka, że jeśli chcesz dostać zapłatę, ci ludzie muszą odejść.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wyrzucić stąd tych ludzi.",
					function getResult()
					{
						return "Refugees2";
					}

				},
				{
					Text = "Ci ludzie nie mają dokąd iść. Po prostu... zostawcie ich.",
					function getResult()
					{
						return "Refugees3";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Refugees2",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_59.png[/img]{Każesz ludziom wypędzić uchodźców. Nie stawiają większego oporu - głównie jęczą o okrucieństwie świata. Ty jednak myślisz tylko o tym, ile za to dostaniesz. | %randombrother% i kilku najemników dostaje rozkaz, by ich wyrzucić. Na szczęście bez rozlewu krwi, ale każdy uchodźca, który przechodzi przed twoim wzrokiem, patrzy na ciebie z ponurym smutkiem. Wzruszasz ramionami. | Uchodźcy zostają wyrzuceni. Jeden z nich wygląda, jakby chciał coś powiedzieć, ale zamyka usta. Jakby mówił to już wcześniej i pamiętał, że wtedy nic to nie dało, tak samo jak teraz. Cieszysz się ciszą. | Każesz %randombrother% rozdać uchodźcom trochę żywności. Takiej, która i tak była bliska zepsucia: kawałki chleba twarde jak cegły i stary gulasz, który śmierdzi śmiercią po podniesieniu pokrywy. Uchodźcy biorą wszystko, jakbyś dał im cały świat. Nie dziękują. Po prostu kiwają głowami, wzruszają ramionami i odchodzą.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Won stąd, hołoto!",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-2);
						this.Contract.setState("ReturnForEscort");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Refugees3",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_59.png[/img]{Zostawiasz uchodźców na miejscu. W zasadzie nie ma sensu wracać do %employer%, bo wcale się z tego nie ucieszy. | Mężczyźni, kobiety i dzieci wyglądają, jakby mieli dość przepędzania. Postanawiasz ich zostawić. | Ci ludzie mają dość tego świata. Nie sądzisz, by przetrwali kolejną wyprawę na dzicz, więc zostawiasz ich tam, gdzie się osiedlili. | Ci zniszczeni i umęczeni ludzie nie zasługują na wyrzucenie stąd. Postanawiasz zostawić ich w spokoju. Wkrótce uczynią to miejsce zdatnym do życia, choć %employer% nie będzie zadowolony, że nie ma tu jego własnych ludzi. | %employer% chce, by osiedlili się tu jego ludzie, ale ty uważasz, że ci przybyli pierwsi. A poza tym nie wyglądają, by mogli jeszcze dłużej przeżyć, gdyby wyrzucić ich na dzicz.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Poszukamy pracy gdzie indziej...",
					function getResult()
					{
						this.World.Assets.addMoralReputation(2);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Nie zdołałeś zabezpieczyć ruin lokacji " + this.Contract.m.Location.getRealName());
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Bitwa zakończona, a %location% zabezpieczone. Czas wrócić do %employer%. | Rozglądasz się po pobojowisku i kiwasz głową, ciesząc się, że wciąż masz ją na karku. Czas wracać do %employer%. | Walka była ciężka, ale zbierasz ludzi i szykujesz powrót do %employer%. | Po bitwie oceniasz miejsce i przygotowujesz raport. %employer% będzie chciał wiedzieć wszystko, co tu zaszło.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To mamy załatwione.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "RebuildingLocation",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Wracasz do %location% i obserwujesz, jak robotnicy rozchodzą się po budynkach. Zabierają się do pracy, układają deski, stawiają belki wsporcze, a jedna grupa kopie studnię. Wygląda na to, że możesz wrócić do %employer%. | Budowniczowie dziękują, że doprowadziłeś ich do %location% bezpiecznie. Potem rozchodzą się i zabierają do pracy, chwytając za narzędzia, które mają pod ręką. Za tobą rozbrzmiewa stukot młotów i pisk pił, gdy odchodzisz, by wrócić do %employer%. | Większość budowniczych wchodzi do %location% i zaczyna przygotowania do odbudowy. Majster dziękuje, że doprowadziłeś ich bezpiecznie, bo zna niebezpieczeństwa świata. Dziękuje też, że nie zdradziłeś ich na wczesny grób. Przyjmujesz tę wdzięczność z uśmieszkiem, po czym ruszasz w drogę powrotną do %employer%. | Cóż, robotnicy są tu bezpieczni. Zawracasz, by wrócić do %employer% po należną zapłatę. | To była długa droga, tam i z powrotem, i znów tam, ale wygląda na to, że %location% staje znów na nogi. Upewniwszy się, że robotnicy są bezpieczni, ruszasz z powrotem do %employer% po zapłatę.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Czas na zapłatę.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_98.png[/img]{%employer% zerka na ciebie, gdy wchodzisz.%SPEECH_ON%I jak, czysto?%SPEECH_OFF%Kiwasz głową. %employer% wstaje i wydaje instrukcje: masz poprowadzić grupę budowniczych z powrotem do %location%, aby mogli je odbudować. | %employer% słucha raportu i kiwa głową.%SPEECH_ON%Mam grupę ludzi, którzy wracają do %location%, żeby je odbudować. Potrzebuję, żebyś ich eskortował. Jasne? Dobrze.%SPEECH_OFF% | Zwijając zwoje, %employer% wydaje kolejne polecenie.%SPEECH_ON%Mam grupę ludzi, którzy wracają tam, by odbudować to miejsce. W grę wchodzą spore korony, więc musisz dopilnować, by dotarli tam w jednym kawałku. A potem wróć po zapłatę.%SPEECH_OFF% | %employer% opiera się po wysłuchaniu raportu. Siorbie kielich wina.%SPEECH_ON%Wieści?%SPEECH_OFF%Mówisz, że teren został oczyszczony. Mężczyzna dopija resztę jednym haustem i odkłada kielich.%SPEECH_ON%Dobrze... dobrze. Teraz zabierz moich robotników z powrotem i pomóż w odbudowie. Gdy skończą, wróć po zapłatę.%SPEECH_OFF% | %employer% opiera się, gdy wchodzisz.%SPEECH_ON%Wnioskuję po twoim powrocie, że %location% zostało oczyszczone, tak?%SPEECH_OFF%Potwierdzasz, co chce usłyszeć. Wygląda na zadowolonego, choć twoja praca jeszcze się nie skończyła: %employer% chce, byś zaprowadził grupę robotników z powrotem i pomógł w odbudowie oraz zasiedleniu. Gdy dotrą bezpiecznie, wróć po zapłatę.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "To nie powinno długo potrwać.",
					function getResult()
					{
						this.Contract.spawnCaravan();
						this.Contract.setState("Escort");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer% wita twój powrót sakiewką ciężką od koron. Machnięciem ręki odprawia cię, ledwie dziękując za robotę. Ale do diabła z nim i z formalnościami. Worek koron to wystarczające podziękowanie. | Wchodzisz do posiadłości %employer% i on macha, byś podszedł. Jeden z jego ludzi podaje ci dużą sakiewkę z koronami. Patrzysz na mężczyznę.%SPEECH_ON%Skąd wiedziałeś, że dotarli?%SPEECH_OFF%%employer% uśmiecha się nieśmiało.%SPEECH_ON%Mam wiele oczu i uszu w tych stronach. Nawet ptaki do mnie mówią...%SPEECH_OFF%To wyjaśnienie ci wystarcza. | Wracając do %employer%, wyjaśniasz, że %location% jest już w trakcie odbudowy. Dziękuje ci.%SPEECH_ON%No proszę, najemnik, który dotrzymuje słowa i wykonuje robotę. Rzadkość. Oto twoja zapłata.%SPEECH_OFF%Jeden z jego ludzi podaje ci jutowy worek ciężki i twardy od koron. %employer% podnosi dłoń.%SPEECH_ON%Do zobaczenia, najemniku.%SPEECH_OFF% | %employer% jest w gabinecie, gdy wracasz. Pokazuje ci zwój i pyta, czy wiesz, co to jest. Wzruszasz ramionami.%SPEECH_ON%Nie jestem uczony. Przynajmniej jeśli chodzi o pisane słowo.%SPEECH_OFF%%employer% wzrusza ramionami w odpowiedzi.%SPEECH_ON%Szkoda. Ale jesteś człowiekiem dotrzymującym słowa. Wywiązałeś się z obietnic i, uwierz mi, to rzadkość. Twoja zapłata jest w rogu.%SPEECH_OFF%Zapłata jest dokładnie tam, gdzie mówi. Nie tracisz czasu na ceremonie, bierzesz ją i odchodzisz. | %employer% odchyla się, wyraźnie zadowolony z siebie.%SPEECH_ON%Wiem, jak wybierać. Najemników, rzecz jasna. Większość moich towarzyszy najmuje takich jak ty, ale wszystko się sypie, bo nie potrafią odróżnić dobrego człowieka od merdania ogonem martwego psa. Ale ty... wiedziałem, że dotrzymujesz słowa, gdy tylko cię zobaczyłem. Twoja zapłata, najemniku...%SPEECH_OFF%Uderza sakiewką z koronami o biurko.%SPEECH_ON%Wszystko się zgadza, ale rozumiem, jeśli chcesz to policzyć.%SPEECH_OFF%Liczysz - i wszystko się zgadza.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Łatwy zarobek.",
					function getResult()
					{
						this.Contract.m.Location.setActive(true);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Pomogłeś odbudować: " + this.Contract.m.Location.getRealName());
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
			Title = "Po bitwie",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Wyprawa budownicza została zniszczona i jakiekolwiek nadzieja na odbudowę lokacji %location% została utracona. Przynajmniej na jakiś czas.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "A niech to szlag!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Nie zdołałeś ochronić wyprawy budowniczej");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "Po Bitwie",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Twoim ludziom nie udało się zabezpieczyć lokacji %location%, więc nie możesz się spodziewać zapłaty.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "A niech to!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Nie zdołałeś zabezpieczyć: " + this.Contract.m.Location.getName());
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function spawnCaravan()
	{
		local faction = this.World.FactionManager.getFaction(this.getFaction());
		local party = faction.spawnEntity(this.m.Home.getTile(), "Karawana Pracownicza", false, this.Const.World.Spawn.CaravanEscort, this.m.Home.getResources() * 0.4, this.getMinibossModifier());
		party.getSprite("banner").Visible = false;
		party.getSprite("base").Visible = false;
		party.setMirrored(true);
		party.setDescription("Karawana pracowników i materiałów budowlanych z " + this.m.Home.getName() + ".");
		party.setFootprintType(this.Const.World.FootprintsType.Caravan);
		party.setMovementSpeed(this.Const.World.MovementSettings.Speed * 0.5);
		party.setLeaveFootprints(false);
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(this.m.Location.getTile());
		move.setRoadsOnly(false);
		local despawn = this.new("scripts/ai/world/orders/despawn_order");
		c.addOrder(move);
		c.addOrder(despawn);
		this.m.Caravan = this.WeakTableRef(party);
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"location",
			this.m.Location.getRealName()
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.World.State.setCampingAllowed(true);
			this.World.State.setEscortedEntity(null);
			this.World.State.getPlayer().setVisible(true);
			this.World.Assets.setUseProvisions(true);

			if (!this.World.State.isPaused())
			{
				this.World.setSpeedMult(1.0);
			}

			this.World.State.m.LastWorldSpeedMult = 1.0;

			if (this.m.Location != null && !this.m.Location.isNull())
			{
				this.m.Location.getSprite("selection").Visible = false;
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (this.m.Location == null || this.m.Location.isActive() || !this.m.Location.isUsable())
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Caravan != null && !this.m.Caravan.isNull())
		{
			_out.writeU32(this.m.Caravan.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.Location != null && !this.m.Location.isNull())
		{
			_out.writeU32(this.m.Location.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local caravan = _in.readU32();

		if (caravan != 0)
		{
			this.m.Caravan = this.WeakTableRef(this.World.getEntityByID(caravan));
		}

		local location = _in.readU32();

		if (location != 0)
		{
			this.m.Location = this.WeakTableRef(this.World.getEntityByID(location));
		}

		this.contract.onDeserialize(_in);
	}

});

