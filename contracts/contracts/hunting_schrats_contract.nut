this.hunting_schrats_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_schrats";
		this.m.Name = "Nawiedzone Lasy";
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

		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Zapoluj to, co zabija ludzi w lasach w pobliżu " + this.Contract.m.Home.getName()
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
					this.Flags.set("IsDirewolves", true);
				}
				else if (r <= 25)
				{
					this.Flags.set("IsGlade", true);
				}
				else if (r <= 30)
				{
					this.Flags.set("IsWoodcutter", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = i )
				{
					if (i == this.Const.World.TerrainType.Forest || i == this.Const.World.TerrainType.LeaveForest || i == this.Const.World.TerrainType.AutumnForest)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}

					i = ++i;
				}

				local playerTile = this.World.State.getPlayer().getTile();
				local mapSize = this.World.getMapSize();
				local x = this.Math.max(3, playerTile.SquareCoords.X - 11);
				local x_max = this.Math.min(mapSize.X - 3, playerTile.SquareCoords.X + 11);
				local y = this.Math.max(3, playerTile.SquareCoords.Y - 11);
				local y_max = this.Math.min(mapSize.Y - 3, playerTile.SquareCoords.Y + 11);
				local numWoods = 0;

				while (x <= x_max)
				{
					while (y <= y_max)
					{
						local tile = this.World.getTileSquare(x, y);

						if (tile.Type == this.Const.World.TerrainType.Forest || tile.Type == this.Const.World.TerrainType.LeaveForest || tile.Type == this.Const.World.TerrainType.AutumnForest)
						{
							numWoods = ++numWoods;
							numWoods = numWoods;
						}

						y = ++y;
						y = y;
					}

					x = ++x;
					x = x;
				}

				local tile = this.Contract.getTileToSpawnLocation(playerTile, numWoods >= 12 ? 6 : 3, 11, disallowedTerrain);
				local party;
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Schraty", false, this.Const.World.Spawn.Schrats, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.setDescription("Stwory z kory i drewna, kryjące się za drzewami i włóczące się powoli, z konarami przekopującymi się przez ziemię.");
				party.setFootprintType(this.Const.World.FootprintsType.Schrats);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);

				for( local i = 0; i < 2; i = i )
				{
					local nearTile = this.Contract.getTileToSpawnLocation(playerTile, 4, 7, disallowedTerrain);

					if (nearTile != null)
					{
						this.Const.World.Common.addFootprintsFromTo(nearTile, party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Schrats, 0.75);
					}

					i = ++i;
				}

				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Home);
				roam.setMinRange(5);
				roam.setMaxRange(10);
				roam.setNoTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Forest, true);
				roam.setTerrain(this.Const.World.TerrainType.SnowyForest, true);
				roam.setTerrain(this.Const.World.TerrainType.LeaveForest, true);
				roam.setTerrain(this.Const.World.TerrainType.AutumnForest, true);
				c.addOrder(roam);
				this.Contract.m.Home.setLastSpawnTimeToNow();
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
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					this.Contract.setScreen("Victory");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsBanterShown") && this.Contract.m.Target.isHiddenToPlayer() && this.Math.rand(1, 1000) <= 1 && this.Flags.get("StartTime") + 10.0 <= this.Time.getVirtualTimeF())
				{
					local tileType = this.World.State.getPlayer().getTile().Type;

					if (tileType == this.Const.World.TerrainType.Forest || tileType == this.Const.World.TerrainType.LeaveForest || tileType == this.Const.World.TerrainType.AutumnForest)
					{
						this.Flags.set("IsBanterShown", true);
						this.Contract.setScreen("Banter");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (!this.Flags.get("IsEncounterShown"))
				{
					this.Flags.set("IsEncounterShown", true);

					if (this.Flags.get("IsDirewolves"))
					{
						this.Contract.setScreen("Direwolves");
					}
					else
					{
						this.Contract.setScreen("Encounter");
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
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
					this.Contract.setScreen("Success");
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
			Text = "[img]gfx/ui/events/event_62.png[/img]{Znajdujesz miejską tablicę oblepioną notkami napisanymi na byle skrawkach, a nawet na liściach, przybitymi najbardziej zardzewiałymi gwoździami. %employer% podchodzi do ciebie.%SPEECH_ON%Czekaliśmy na człowieka takiego jak ty, najemniku. Ludzie znikają w lasach, a ja nie mam sposobu, by ich odzyskać. Słyszałem opowieści o drzewach, które chodzą i zabijają drwali rąbiących ich pnie, ale kto wie, czy to prawda. Potrzebuję twojej kompanii, by weszła do lasu i sprawdziła, co powoduje tę rzeź. Jesteś zainteresowany?%SPEECH_OFF% | %employer% obraca w palcach kawałek kory jak żeton hazardzisty. Wzdycha i rzuca go na stół.%SPEECH_ON%Słyszę opowieści o drwalach i handlarzach znikających w lesie. Niektórzy mówią, że drzewa ożyły, by się zemścić, ale mnie to brzmi jak brednie. Tak czy inaczej, przygotowano sumę monet, by \'rozwiązać\' ten problem, i jestem gotów ją wypłacić. Co powiesz, najemniku, interesuje cię znalezienie potworów nękających to miasto?%SPEECH_OFF% | Na biurku %employer% leży sterta trocin, a jego wzrok wpatruje się w kopczyk. Machając ci, byś podszedł, nie odrywa od niego oczu i mówi dalej.%SPEECH_ON%Miejscowi drwale meldują, że ludzie znikają w lesie. Mówią, że to drzewa, jakieś potwory z drewna i korzeni. Część mnie uważa, że ukrywają morderstwo i nie chcą się przyznać, ale może te straszne historie są prawdziwe. Tak czy inaczej, mam monety, by to zakończyć, a ty jesteś człowiekiem od tej roboty, co nie?%SPEECH_OFF% | Wchodząc do komnaty %employer%, twoja stopa zahacza o klocek porąbanego drewna. Klocek przewraca się i opada płaskim bokiem, a na ciebie spogląda okrągły pień z korą. Burmistrz klaszcze w dłonie.%SPEECH_ON%A więc się nie ruszył! Ach, pewnie się zastanawiasz, o co mi chodzi. Masz.%SPEECH_OFF%Rzuca ci rysunek czegoś, co wygląda jak drzewo z ramionami. Kontynuuje.%SPEECH_ON%Mam wieści z dróg, że drzewa ożyły. Mam nawet zaufanego przyjaciela, drwala, który z kamienną twarzą powiedział, że jakiś duchowy stwór w drzewach porwał drewno i korzenie i władał nimi jak bronią. Cokolwiek tam jest, potrzebuję grupy zabójców, by to wytropić. Ty i twoja kompania podejmiecie się zadania?%SPEECH_OFF% | %employer% siedzi na pniu drzewa otoczony chłopami. Po kilku minutach rozkłada ręce.%SPEECH_ON%Widzicie! Nic tu nie ma! To drzewo! Drzewo, widzicie?%SPEECH_OFF%Chłopi nie są przekonani i mówią o potworach w lesie ukształtowanych jak same drzewa. Wzdychając, %employer% wyciąga do ciebie rękę.%SPEECH_ON%Dobrze, wynajmiemy najemników. To wszystkim pasuje? A co ty powiesz, najemniku? Mamy monety do zapłaty i mordercze drzewa do upolowania. Brzmi dobrze?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Pewnie, żeśmy zainteresowani. | Porozmawiajmy o zapłacie. | Porozmawiajmy o koronach. | To będzie cię kosztować. | Dzika pogoń poprzez lasy, co? Piszę się na to. | Nasza kompania jest w stanie pomóc, za odpowiednią cenę.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{To nie brzmi jak robota dla nas. | Nie poprowadzę ludzi na dziką pogoń pośród lasów. | Nie sądzę. | Nie ma mowy. Moi ludzie wolą znanych wrogów z krwi i kości.}",
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
			Text = "[img]gfx/ui/events/event_25.png[/img]{Kompania jest coraz bardziej spięta, jak to bywa w lesie podczas polowania na mordercze drzewa. Każde trzaśnięcie gałęzi sprawia, że ludzie dobywają mieczy, a jeden z nich krzyknął, gdy opadły liść wpadł mu za kołnierz. Wróg zdobywa przewagę, nie robiąc nic! | Las niepokoi ludzi. Mówisz im, by się ogarnęli, bo wróg i tak gdzieś tu jest, a nie warto bać się tego, co pewne. To ciebie mają się bać, %companyname%, a te przeklęte mordercze drzewa będą żałować, że nie są zwykłymi drwalami, kiedy z nimi skończycie! | %randombrother% zarzuca broń na ramiona i człapie dalej, teatralnie wymachując rękami. Ocenia leśne poszycie.%SPEECH_ON%Hej, szefie, a może byśmy rozwalili jedno z tych drzew i uznali sprawę za załatwioną! Rzucimy im stertę porąbanego drewna i ściółki, i nikt nie pozna różnicy, kiedy wszystko będzie powiedziane i zrobione. A jak będą pytać, powiedz, że kora miała niezły zgryz!%SPEECH_OFF%Ludzie się śmieją, a ty mówisz najemnikowi, że rozważysz jego pomysł.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Patrzcie, gdzie stawiacie nogi.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Encounter",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_107.png[/img]{Gdy stoicie i rozglądacie się, %randombrother% woła, że coś się porusza w oddali. Gdy stajesz obok, wskazuje palcem w poszycie i dobywa miecza. Wielkie drzewo maszeruje w waszą stronę, kołysząc się z boku na bok jak starzec znający korytarze biblioteki. Dobywasz miecza i rozkazujesz ludziom zająć szyk. | %randombrother% siedzi na powalonym drzewie, gdy nagle zrywa się z krzykiem i sięga po broń. Spoglądasz i widzisz, jak samo drzewo unosi się w powietrze, z brył ziemi spadają kępy, a za nim pozostaje wielki, mokry dół, jakby leżało tam od eonów. Opiera się o zdrowszych braci jak pijak o ramię przyjaciela. Powoli obraca się, a z głębi pnia błyszczy para zielonych oczu, ostre gałęzie wirują wraz z nim, rozpostarte szeroko, a ich cienie spadają na kompanię niczym pajęczyna. Dobywasz miecza i rozkazujesz ludziom zająć szyk.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do ataku!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Direwolves",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_118.png[/img]{Dostrzegasz w oddali pary zielonych oczu. Z pewnością to same schraty, więc rozkazujesz ludziom po cichu podejść.\n\nWchodząc na wzgórze, widzisz, że pień jednego drzewa otoczony jest przez wilkory. Kucają pod nim jak rycerze przysięgający wierność. Wasze przybycie nie uszło uwadze, bo schrat pochyla się do przodu z pradawnym, zawodzącym pomrukiem. Stwory u jego korzeni warczą i odwracają się jak na rozkaz. Nie wiesz, co o tym myśleć, ale %companyname% i tak ich wszystkich złamie.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do ataku!",
					function getResult()
					{
						this.Contract.addUnitsToEntity(this.Contract.m.Target, this.Const.World.Spawn.Direwolves, 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_121.png[/img]{Schraty zostały ubite, a ich drzewne szczątki wyglądają teraz niemal jak zwykłe drzewa. Wyrywasz trofea i dowody na powrót do %employer%. | Patrzysz na powalone drzewo, a potem na powalonego schratta. Pomiędzy nimi widzisz prawie żadną różnicę, co każe ci zastanowić się nad wszystkimi rzekomo martwymi drzewami, które całe życie przeskakiwałeś. Nie skłonny do roztrząsania, rozkazujesz kompanii zabrać trofea jako dowód bitwy i szykujesz powrót do %employer%. | Schraty padły, każdy oparty o leśne poszycie jak awanturnicy odpoczywający między rundami. Podchodzisz pod korzenie jednego z nich, by mu się przyjrzeć, ale teraz nie różni się od innych drzew. Rozkazujesz kompanii zabrać trofea, by pokazać je %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Załatwione.",
					function getResult()
					{
						if (this.Flags.get("IsGlade") && this.World.Assets.getStash().hasEmptySlot())
						{
							return "Glade";
						}
						else if (this.Flags.get("IsWoodcutter") && this.World.Assets.getStash().hasEmptySlot())
						{
							return "DeadWoodcutter";
						}
						else
						{
							return 0;
						}
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Glade",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_121.png[/img]{Gdy opuszczacie pobojowisko, %randombrother% zauważa, że okolica wygląda nader dorodnie. Odwracasz się i widzisz, że ma rację: piękny zagajnik był siedliskiem schratów, zapewne nie bez powodu. A skoro schraty wybrały go na dom, drewno musi być znakomite. Rozkazujesz ludziom skorzystać z tej jakościowej polany i ściąć tyle drzew, ile pozwoli czas i siły. Zebrane drewno jest rzeczywiście znakomite.\n\nZaczyna padać, gdy opuszczacie improwizowany tartak.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wracamy do %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				local item = this.new("scripts/items/trade/quality_wood_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + item.getName()
				});
				item = this.new("scripts/items/trade/quality_wood_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "DeadWoodcutter",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_121.png[/img]{Gdy już odchodzisz, w oczy rzuca ci się błysk. Odwracasz się i podchodzisz do pnia jednego ze schratów. Siekiera tkwi w drewnie. Mech dawno porósł trzonek, a jednak metal narzędzia jest bez skazy, ani śladu rdzy. Zeskrobujesz mech i odkrywasz drewniane palce wciąż zaciśnięte w pełnym chwycie. Śledząc je, widzisz, że nadgarstek przechodzi w żyłę drewna. Prowadzi ona do drewnianej twarzy z wykrzywioną paszczą, jakby twarzy z brązowego wosku stopionego samym czasem. Obramowanie hełmu oplata twarz, a poniżej wyrasta napierśnik jak zbiornik u łowcy jeleni.\n\nKręcisz głową i wydobywasz siekierę, wyłamując ją i strącając drewniane palce z trzonka. Zniekształcona twarz beznamiętnie obserwuje twoją kradzież, jej spojrzenie zachowane w samej zagładzie, od której dzielą je eony. Nie roztrząsasz tego widoku i wracasz do kompanii z siekierą.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wracamy do %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				local item;
				local r = this.Math.rand(1, 4);

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/woodcutters_axe");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/hand_axe");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/fighting_axe");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/greataxe");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Success",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_62.png[/img]{Zastajesz %employer% strugającego z drewna zabawkę. Zdmuchuje wióry z biurka i strzepuje trociny z palców. Ustawia zabawkę na nogach, ukształtowaną jak rycerz, który zjadł za dużo słodyczy, ale ta natychmiast się przewraca. Wzdychając, zwraca się do ciebie po pomoc. Wciągasz głowę schratta do izby i pozwalasz jej kołysać się po podłodze, aż oprze się na jednym z rogów. Burmistrz kiwa głową.%SPEECH_ON%Całkiem nieźle, najemniku.%SPEECH_OFF%Przynosi twoją obiecaną zapłatę. | %employer% jest w szoku na twój powrót i na szczątki schratta, które przyniosłeś pod jego drzwi. Patrzy na nie, wciąż niedowierzając ich pochodzeniu. Jak kot bawiący się obciętymi skrzydłami owada, rozgrzebuje stertę stopą.%SPEECH_ON%Nie sądziłem, że to przyniesiesz, ale niech mnie, jeśli nie znalazłeś i nie zabiłeś tych przeklętych drzew. Cóż, przyniosę twoją zapłatę.%SPEECH_OFF%Przynosi obiecane monety. | Zastajesz %employer% strugającego rylcem poręcz drewnianego krzesła. Podnosi wzrok, gdy pokazujesz szczątki schratta. Wstaje i bierze kawałek, siadając na krześle, by mu się przyjrzeć, ale krzesło rozpada się pod jego tyłkiem, deski z łoskotem uderzają o ziemię, jakby od początku jego celem było wzniecić kakofonię. %employer% w gniewie rzuca narzędziami.%SPEECH_ON%Na bogów, ja... no, lepiej żebym nie robił z siebie dzikusa i im nie groził. Chyba to właśnie doprowadziło mnie do tego stanu.%SPEECH_OFF%Kiwasz głową, mówiąc, że nie warto gniewać starych bogów. Dodajesz też, że nie warto zostawiać najemnika bez zapłaty. Burmistrz zrywa się i biegnie po sakiewkę z monetami.%SPEECH_ON%Oczywiście, najemniku! Nie musisz mnie pouczać w takich sprawach!%SPEECH_OFF% | Zastajesz %employer% pod kępą drzew. Trzyma dłonie na brzuchu i wpatruje się w niebo. Na jego twarzy pojawia się uśmiech, wskazuje na chmurę, jakby ktoś miał to zobaczyć, ale jest sam i nic nie mówi. Rzucasz mu pod stopy kawałek schratta i pytasz o zapłatę. Odwraca sakiewkę, której dotąd nie było widać.%SPEECH_ON%Kilku drwali widziało, jak z nimi walczyłeś, i opowiedzieli mi wszystko. Nie sądziłem, że schraty są całkiem prawdziwe. Mordercze drzewa brzmią jak przesąd dla dzieci, ale widzę, że wciąż mam czego się nauczyć. Dobra robota, najemniku.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Udane polowanie.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Oczyściłeś okolicę z żyjących drzew");
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
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Target.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/disappearing_villagers_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.setAttackableByAI(true);
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
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

