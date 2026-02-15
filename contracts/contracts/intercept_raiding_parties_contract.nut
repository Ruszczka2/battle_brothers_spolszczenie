this.intercept_raiding_parties_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Objectives = [],
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.intercept_raiding_parties";
		this.m.Name = "Przechwycenie Oddziałów Najeźdźców";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
		this.m.MakeAllSpawnsResetOrdersOnContractEnd = false;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		local f = this.World.FactionManager.getFaction(this.getFaction());
		local towns = [];

		foreach( s in f.getSettlements() )
		{
			if (s.isIsolated() || s.isCoastal() || s.isMilitary() || !s.isDiscovered())
			{
				continue;
			}

			if (s.getActiveAttachedLocations().len() < 2)
			{
				continue;
			}

			if (this.World.getTileSquare(s.getTile().SquareCoords.X, s.getTile().SquareCoords.Y - 12).Type == this.Const.World.TerrainType.Ocean)
			{
				continue;
			}

			towns.push(s);
		}

		towns.sort(function ( _a, _b )
		{
			if (_a.getTile().SquareCoords.Y < _b.getTile().SquareCoords.Y)
			{
				return -1;
			}
			else if (_a.getTile().SquareCoords.Y > _b.getTile().SquareCoords.Y)
			{
				return 1;
			}

			return 0;
		});
		this.m.Destination = this.WeakTableRef(towns[this.Math.rand(0, this.Math.min(1, towns.len() - 1))]);
		this.m.Payment.Pool = 1300 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 2);

		if (r == 1)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else if (r == 2)
		{
			this.m.Payment.Completion = 1.0;
		}

		this.m.Flags.set("LastLocationDestroyed", "");
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Przechwyć wszystkie południowe oddziały najeźdźców w pobliżu %objective%",
					"Nie pozwól im spalić żadnej lokacji"
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

				if (r <= 10)
				{
					this.Flags.set("IsAssassins", true);
				}
				else if (r <= 50)
				{
					this.Flags.set("IsSlavers", true);
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					this.Flags.set("IsThankfulVillagers", true);
				}

				local cityStates = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);

				foreach( c in cityStates )
				{
					c.addPlayerRelation(-99.0, "Opowiedziałeś się po jednej ze stron w wojnie");
				}

				this.Contract.m.Destination.setLastSpawnTimeToNow();
				local locations = [];

				foreach( a in this.Contract.m.Destination.getActiveAttachedLocations() )
				{
					if (a.isUsable() && a.isActive())
					{
						locations.push(a);
					}
				}

				local cityState = cityStates[this.Math.rand(0, cityStates.len() - 1)];

				for( local i = 0; i < 2; i = i )
				{
					local r = this.Math.rand(0, locations.len() - 1);
					this.Contract.m.Objectives.push(locations[r].getID());
					i = ++i;
				}

				local g = this.Contract.getDifficultyMult() > 1.1 ? 3 : 2;

				for( local i = 0; i < g; i = i )
				{
					local tile = this.Contract.getTileToSpawnLocation(this.World.getTileSquare(this.Contract.m.Destination.getTile().SquareCoords.X, this.Contract.m.Destination.getTile().SquareCoords.Y - 12), 0, 10);
					local party;

					if (i == 0 && this.Flags.get("IsAssassins"))
					{
						party = cityState.spawnEntity(tile, "Pułk z " + cityState.getNameOnly(), true, this.Const.World.Spawn.Southern, this.Math.rand(70, 90) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
						this.Contract.addUnitsToEntity(party, this.Const.World.Spawn.Assassins, this.Math.rand(30, 40) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						party.getFlags().set("IsAssassins", true);
					}
					else if (i == 0 && this.Flags.get("IsSlavers"))
					{
						party = cityState.spawnEntity(tile, "Łowcy Niewolników", true, this.Const.World.Spawn.Southern, this.Math.rand(60, 80) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
						this.Contract.addUnitsToEntity(party, this.Const.World.Spawn.NorthernSlaves, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						party.getFlags().set("IsSlavers", true);
					}
					else
					{
						party = cityState.spawnEntity(tile, "Pułk z " + cityState.getNameOnly(), true, this.Const.World.Spawn.Southern, this.Math.rand(100, 130) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
						party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + cityState.getBannerString());

						if (this.Math.rand(1, 100) <= 33)
						{
							this.Contract.addUnitsToEntity(party, this.Const.World.Spawn.NorthernSlaves, this.Math.rand(10, 30));
						}
					}

					party.setDescription("Poborowi żołnierze, lojalni swemu państwu-miastu.");
					party.setAttackableByAI(false);
					party.getLoot().Money = this.Math.rand(50, 200);
					party.getLoot().ArmorParts = this.Math.rand(0, 25);
					party.getLoot().Medicine = this.Math.rand(0, 3);
					party.getLoot().Ammo = this.Math.rand(0, 30);
					local r = this.Math.rand(1, 4);

					if (r <= 2)
					{
						party.addToInventory("supplies/rice_item");
					}
					else if (r == 3)
					{
						party.addToInventory("supplies/dates_item");
					}
					else if (r == 4)
					{
						party.addToInventory("supplies/dried_lamb_item");
					}

					local c = party.getController();
					c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
					c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
					local wait = this.new("scripts/ai/world/orders/wait_order");
					wait.setTime(80.0 + i * 12.0);
					c.addOrder(wait);

					for( local j = 0; j < 2; j = j )
					{
						local raid = this.new("scripts/ai/world/orders/raid_order");
						raid.setTargetTile(j == 0 ? locations[0].getTile() : locations[1].getTile());
						raid.setTime(60.0);
						c.addOrder(raid);
						j = ++j;
					}

					this.Contract.m.UnitsSpawned.push(party.getID());
					i = ++i;
				}

				this.Flags.set("ObjectivesAlive", 2);
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
				}

				foreach( i, id in this.Contract.m.UnitsSpawned )
				{
					local p = this.World.getEntityByID(id);

					if (p != null && p.isAlive())
					{
						p.getSprite("selection").Visible = true;
						p.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
					}
				}
			}

			function update()
			{
				local alive = 0;

				foreach( i, id in this.Contract.m.Objectives )
				{
					local p = this.World.getEntityByID(id);

					if (p != null && p.isAlive())
					{
						if (p.isActive())
						{
							alive = ++alive;
							alive = alive;
						}
						else
						{
							this.Flags.set("LastLocationDestroyed", p.getRealName());
						}
					}
				}

				if (alive < this.Flags.get("ObjectivesAlive"))
				{
					this.Flags.set("ObjectivesAlive", alive);
					this.Contract.setScreen("LocationDestroyed");
					this.World.Contracts.showActiveContract();
				}
				else if (alive == 0 || this.Contract.m.UnitsSpawned.len() == 0)
				{
					if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() < 4.0 && alive > 0)
					{
						if (this.Flags.get("IsThankfulVillagers") && this.Contract.isPlayerNear(this.Contract.m.Destination, 500))
						{
							this.Contract.setScreen("ThankfulVillagers");
						}
						else
						{
							this.Contract.setScreen("PartiesDefeated");
						}
					}
					else
					{
						this.Contract.setScreen("Lost");
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					foreach( i, id in this.Contract.m.UnitsSpawned )
					{
						local p = this.World.getEntityByID(id);

						if (p == null || !p.isAlive())
						{
							this.Contract.m.UnitsSpawned.remove(i);
							break;
						}
					}
				}
			}

			function onDestinationAttacked( _dest, _isPlayerInitiated )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerInitiated;

				if (!this.Flags.get("IsEngagementDialogShown"))
				{
					this.Flags.set("IsEngagementDialogShown", true);

					if (_dest.getFlags().has("IsAssassins"))
					{
						this.Contract.setScreen("Assassins");
					}
					else if (_dest.getFlags().has("IsSlavers"))
					{
						this.Contract.setScreen("Slavers");
					}
					else
					{
						this.Contract.setScreen("InterceptParty");
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerInitiated, true, true);
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

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					local alive = 0;

					foreach( id in this.Contract.m.Objectives )
					{
						local p = this.World.getEntityByID(id);

						if (p != null && p.isAlive() && p.isActive())
						{
							alive = ++alive;
							alive = alive;
						}
					}

					if (alive == 0)
					{
						this.Contract.setScreen("Lost");
					}
					else if (alive == 1)
					{
						this.Contract.setScreen("Success1");
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{Pokój %employer%a jest ciemny i cichy. Byłby czarny i niemy, gdyby nie migotanie kilku świec i ćwierkanie ptaków. Stojąc w cieniu, szlachcic przemawia.%SPEECH_ON%Południowe sukinsyny wysyłają na północ oddziały rabusiów. To uciążliwa sprawa, wiesz, gdy kilku opalonych kundli kręci się w okolicy, rabuje, plądruje, zabija i gwałci. Chcą, żebym wycofał główne siły na tył, ale nie pozwolę na to. Dlatego tu jesteś, najemniku. Potrzebuję, byś wytropił tych sabotażystów i wybił wszystkich. Czeka na ciebie %reward% koron, jeśli podejmiesz się zadania.%SPEECH_OFF% | Zastajesz %employer%a rozmawiającego z porucznikami. Ma dwa stosy żetonów, jeden znacznie wyższy od drugiego. Bierze z wyższego i kładzie na mniejszy.%SPEECH_ON%A gdybym przydzielił tyle?%SPEECH_OFF%Porucznicy kręcą głowami.%SPEECH_ON%To właśnie tego chcą południowcy. Jeśli ściągniemy ludzi z linii frontu, na pewno to zauważą i wykorzystają jako moment ataku.%SPEECH_OFF%Wszyscy nagle spoglądają na ciebie. %employer% uśmiecha się szeroko.%SPEECH_ON%Aha, wygląda na to, że naszym zbawcą jest nie kto inny jak najemnik! Cóż, śmiało powiem, że najemnik może to załatwić. Ty, kapitanie, potrzebuję wojowników, którzy zostaną w okolicach %townname% i obronią je przed południowymi sabotażystami i najeźdźcami. Czeka na ciebie %reward% koron za pomyślne wykonanie zadania!%SPEECH_OFF%Porucznicy armii wyglądają na niechętnych, by składać taką ofertę najemnikowi, ale wyczuwasz, że czasy są ciężkie. | Kierują cię do biblioteki %employer%a, gdzie zastajesz go nad zwojami. Podnosi jeden z nich.%SPEECH_ON%W czasach takich jak te, jak myślisz, o czym czytam?%SPEECH_OFF%Zgadujesz, że o sprawach wojskowych. Mężczyzna kręci głową.%SPEECH_ON%O rolnictwie. Widzisz, obecnie jestem w stanie wojny. Ale wojny nie wygrywa się tylko ludźmi, lecz także łańcuchami dostaw, logistyką, żywnością. To wszystko zapewnia zaplecze. Południowe kundelki rozumieją to tak samo jak my i wysłały najeźdźców oraz infiltratorów, by zniszczyć zaplecze. By mnie rozproszyć, by rozproszyć moich żołnierzy. Potrzebuję, byś wytropił tych drani i chronił nasze domy, sklepy, farmy. Za pomyślne wykonanie oferuję %reward% koron.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{To może być odpowiednia robota dla nas. | Odeprzeć najeźdźców z południa? Ta kompania odpowie na twoje wezwanie! | W porządku. Porozmawiajmy o zapłacie.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{To nie jest tego warte. | Jesteśmy potrzebni gdzie indziej. | To zajęłoby nam zbyt dużo czasu.}",
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
			ID = "LocationDestroyed",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_30.png[/img]{Dym wznosi się w oddali. Krzyki pod chmurami oraz płochliwe sylwetki w ogniu, które są ich źródłem. To %location% w %objective% i bez wątpienia to miejsce zostało zniszczone.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Musimy to powstrzymać, zanim będzie za późno.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "InterceptParty",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_156.png[/img]{Południowcy wyglądają, jakby byli w trakcie przeprowadzki: połowicznie ubrani w swoje stroje i w północne odzienie, a do tego obciążeni skrzyniami z łupem. Jeden z nich figlarnie kręci się w północnej sukni ślubnej. Wyglądałoby to jak przyjazna wizyta, gdyby nie to, że wszyscy są pokryci krwią i popiołem. Do boju! | Trafiasz na oddział południowych najeźdźców zmierzający na północ. Sądząc po krwi na nich, już utorowali sobie drogę przez zagrody na odludziu. Do boju!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Przygotować się do starcia.",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "PartiesDefeated",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_87.png[/img]{Znajdujesz ostatniego żywego południowca, chwytasz go za włosy i unosisz tak, by wszyscy go widzieli. Chłopi i rolnicy patrzą, jak tniesz od gardła po kark, aż ciało osuwa się, a w rękach trzymasz jego głowę. Tłum wiwatuje.%SPEECH_ON%Nasz wybawca!%SPEECH_OFF%Bez wątpienia %employer% ucieszy się, słysząc o twojej robocie. | Południowcy zostali wybici, a tych, którzy przeżyli rany, dopadają miejscowi. To tortura, pełna zdzierania skóry, obcinania przyrodzeń i ogólnej krwawej kreatywności. Ale nie masz litości dla obcych. Z kolei zapłata czekająca u %employer%a budzi w tobie pewne zainteresowanie. | Gdy ostatni z południowców trafił do grobu, wiesz, że %employer% z radością zapłaci ci to, na co zasługujesz. Odchodząc, widzisz kilku miejscowych okaleczających zwłoki najeźdźców, jak nakazuje tradycja w tej i wszystkich innych częściach świata. | Przeraźliwy krzyk zdradza, jak bardzo ostatni napastnik utracił panowanie nad sobą, zanim zostaje dobity ostrzem. Jego towarzyszy miejscowi włóczą po ziemi, a zwłoki tną na kawałki lub podpalają. Patrzysz chwilę, lecz w końcu ruszasz dalej, wiedząc, że %employer% będzie czekał. | Największe szczęście mają martwi, bo ciężko ranni nie otrzymują litości. Miejscowi i osadnicy wchodzą na pole bitwy, by upomnieć się o swoje ofiary, niektórzy nawet płacą za to koronami, a wybrani najeźdźcy są potem bezczeszczeni, okaleczani i torturowani. Nie widzisz żadnych natychmiastowych egzekucji, a w jednym przypadku zdaje się, że uzdrowiciel jest obecny tylko po to, by przedłużyć cierpienie. To niecodzienny widok, ale jeszcze lepszy będzie ten, gdy %employer% wrzuci sporą nagrodę do twojej sakiewki.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Przygotować ludzi do wymarszu.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Lost",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_94.png[/img]{Wróg zniknął, ale jego robota została dokończona. Dym unosi się nad budynkami spalonymi do fundamentów, a ci, których nie zabrano jako zadłużonych na sprzedaż na południe, leżą martwi na ulicach.\n\nNie ma sensu wracać do zleceniodawcy, bo masz marne szanse na zapłatę za porażkę. Najlepiej szukać nowej pracy gdzie indziej.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zawiedliśmy.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Nie zdołałeś obronić " + this.Contract.m.Destination.getName() + " przed południowymi najeźdźcami");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Assassins",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_165.png[/img]{Znajdujesz na drodze martwego rolnika z zakrzywionym sztyletem w plecach. Nikt nie zostawia tak dobrego sztyletu, a tak jak podejrzewasz, mordercy wciąż tu są: grupa południowych zabójców. Poruszają się jak cienie, a ich naostrzone stalowe ostrza błyszczą przy każdym ruchu. Do boju! | Kobieta podbiega do ciebie w pośpiechu, jej strzępiona suknia powiewa, ręce machają, oczy ma szeroko otwarte, a białka czerwienieją jak muszle na krwawym brzegu. Zanim zdąży coś powiedzieć, charczy i pada na ziemię. W tyle jej głowy tkwi sztylet, a dalej za nią stoi mężczyzna w czerni z kompanią zabójców!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Slavers",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Południowy oddział wygląda jak zbiorowisko ludzi z całego świata. Dopiero z bliska widzisz, że to dlatego, iż są to łowcy niewolników! Mieszanina panów i niewolników rusza na %companyname%, rozchwiana formacja złożona z wyszkolonych i niewyszkolonych. Widzisz wśród nich północne twarze, ale niestety są złamani i prędzej podniosą broń przeciw kompanii, niż zawalczą o wolność. | Natrafiasz na południowców, ale to wcale nie najeźdźcy - to łowcy niewolników! Wiozą wozy kobiet i dzieci, a gdy ich odkrywasz, łowcy pospiesznie zaczynają ścinać głowy wszystkim niedawno zniewolonym mężczyznom, którzy stanowią zagrożenie, podczas gdy reszta grupy szarżuje na %companyname%. W powietrzu czuć rzeź, a ty uderzasz na oddział bez wahania!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "ThankfulVillagers",
			Title = "W %objective%",
			Text = "[img]gfx/ui/events/event_79.png[/img]{Dobijasz ostatniego z południowych najeźdźców. Gdy każesz kompanii zbierać to, co cenne, kilku mieszkańców wychodzi z własnymi darami.%SPEECH_ON%Myśleliśmy, że to koniec świata, a jednak jesteście, nasi rycerze.%SPEECH_OFF%Choć nie jesteś rycerzem, nie wzdragasz się przed przyjęciem rycerskiej pochwały i rycerskiej nagrody: mieszkańcy dają ci podarki! | Po rozprawieniu się z najeźdźcami powoli otacza cię grupa mieszkańców. Wyglądają na wyczerpanych i przestraszonych, a jednak niosą kosze z towarami. Oferują je jako nagrodę za ocalenie. Zdają się brać cię za żołnierzy %employer%a, ale nawet nie zamierzasz ujawniać, że jesteś najemnikiem. Przyjmujesz dary, uchylasz kapelusza i mówisz, że to po prostu twoja robota, bo tak właśnie jest.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Miło jest być docenionym.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				local p = this.Contract.m.Destination.getProduce();

				for( local i = 0; i < 2; i = i )
				{
					local item = this.new("scripts/items/" + p[this.Math.rand(0, p.len() - 1)]);
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
			ID = "Success1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% wpuszcza cię, ale jego powitanie nie jest tak radosne, jakbyś się spodziewał. Ton ma w sobie coś z ojcowskiego rozczarowania.%SPEECH_ON%Dopadłeś kilku południowych zbójów. Nie świetnie, ale i nie tragicznie. Zapłacę ci za każdy powstrzymany oddział, ale wolałbym, żebyś spisał się lepiej.%SPEECH_OFF%Masz ochotę przeprosić, ale wiesz, że każda oznaka słabości może skończyć się zaniżeniem zapłaty, więc zachowujesz to dla siebie. Wypłaca %reward% zgodnie z tym, co wypracowałeś. | %employer% ma przy sobie kilku strażników, gdy wchodzisz, choć wśród tłumu brakuje niektórych twarzy. Mężczyzna mówi poważnie.%SPEECH_ON%Zrobiłeś, co mogłeś, najemniku. Nie było prawdopodobne, byś złapał wszystkich najeźdźców. Teraz to rozumiem. Oczywiście oferuję ci odrobinę rozsądnej wyrozumiałości. Być może zatrudniłem nie tego człowieka, ale dziś tego nie osądzę. Zbyt wiele trzeba odbudować. Masz tu %reward%, zgodnie z umową za każdy zniszczony oddział najeźdźców.%SPEECH_OFF% | Wchodzisz do pokoju %employer%a i znajdujesz swoją nagrodę w wysokości %reward% koron, już odliczoną i położoną na stole. Wskazuje ją nonszalanckim ruchem ręki.%SPEECH_ON%Najeźdźcy przyszli, kilku ich powstrzymałeś, reszta plądrowała, rabowała i mordowała. A więc. Weź swoją zapłatę w wysokości %reward% koron, najemniku. Odpowiada ona jakości twojej pracy, więc nie dziw się, jeśli w stosie koron zabraknie kilku sztuk.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "W pełni zasłużona zapłata.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractPoor);
						this.World.Assets.addMoney(this.Math.round(this.Contract.m.Payment.getOnCompletion() / 2));
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractPoor, "Obroniłeś " + this.Contract.m.Destination.getName() + " przed południowymi najeźdźcami");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isHolyWar())
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
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Zastajesz %employer%a nie w sali wojennej, lecz w bocznym gabinecie, gdzie kręci się kilka kobiet. Zdejmują pajęczyny z kątów, układają zwoje na półkach albo ścierają kurz z mebli. I wszystkie są nagie, rzecz jasna. Mężczyzna rozkłada ramiona.%SPEECH_ON%Uznałem, że należy świętować, bo %townname% zostało ocalone, ocalone przez takich jak ty, najemniku!%SPEECH_OFF%Jest pijany, a kobiety delikatnie ustępują mu miejsca, gdy zatacza się po pokoju.%SPEECH_ON%No... no -hic- zapewniam cię, że nie pożyczyłem od ciebie %reward% koron. Wszystko jest -hic- tak jak obiecano. Chłopstwo jest zadowolone i ja też. Bardzo zadowolone.%SPEECH_OFF%Ściska jedną z kobiet, a ta reaguje żywo jak wypłowiały dywan. Chwytasz sakiewkę i wychodzisz, a kilka dziewczyn wymyka się z tobą drzwiami, gdy %employer% zapada w mamroczący stupor. | Zastajesz %employer%a poza salą wojenną, w bibliotece, w której być może jest więcej półek niż książek. Mimo to wydaje się z siebie dumny.%SPEECH_ON%Twoja robota była wspaniała, najemniku. Absolutnie wspaniała. Owszem, były straty, ale ogólnie wszystko jest tam, gdzie powinno, a te południowe sukinsyny uciekły. Z twoją pomocą nasze linie frontu nie musiały słabnąć, by pilnować domostw. Oto twoje %reward% koron, jak obiecano.%SPEECH_OFF%Gdy mężczyzna odsuwa się na bok, widzisz, że na półce stoi świeżo wybielona czaszka. Wskazuje ją z dziecięcym urokiem.%SPEECH_ON%To jedna z ich czaszek. Zamierzam z niej pić wino albo do niej sikać. Jeszcze nie zdecydowałem.%SPEECH_OFF% | %employer% siedzi przy biurku z piramidą trzech czaszek. Dłoń spoczywa na nich, jakby głaskał psią głowę. Zauważasz, że wciąż widać paski mięsa i nawet włosy, a proces bielenia najpewniej był pospieszny. Mężczyzna mówi radośnie.%SPEECH_ON%Dzięki tobie moi żołnierze mogą pozostać na froncie, najemniku. Rozprawienie się z tymi najeźdźcami nie tylko uratowało tu życie wielu ludzi, ale też mogło zapobiec upadkowi pierwszego klocka w szeregu wielu. Bez twojej pomocy ojcowie, bracia i synowie na froncie musieliby wrócić, by opiekować się rodzinami, a ta cała wojna poszłaby się w diabły.%SPEECH_OFF%Wolną ręką przesuwa w twoją stronę sakiewkę.%SPEECH_ON%Twoje %reward% koron. Dobrze zarobiona waga monety, powiedziałbym.%SPEECH_OFF%Uśmiecha się ponuro i kiwa głową w stronę czaszek.%SPEECH_ON%Myślę, że one by się z tym zgodziły, choć muszę przyznać, że w tej sprawie będę przemawiał w ich imieniu.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Obroniłeś " + this.Contract.m.Destination.getName() + " przed południowymi najeźdźcami");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isHolyWar())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCriticalContract);
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
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective",
			this.m.Destination.getName()
		]);
		_vars.push([
			"location",
			this.m.Flags.get("LastLocationDestroyed")
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
			}

			foreach( id in this.m.UnitsSpawned )
			{
				local p = this.World.getEntityByID(id);

				if (p != null && p.isAlive())
				{
					p.getSprite("selection").Visible = false;
					p.setOnCombatWithPlayerCallback(null);
				}
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isHolyWar())
		{
			return false;
		}

		local f = this.World.FactionManager.getFaction(this.getFaction());

		foreach( s in f.getSettlements() )
		{
			if (s.isIsolated() || s.isCoastal() || s.isMilitary() || !s.isDiscovered())
			{
				continue;
			}

			if (s.getActiveAttachedLocations().len() < 2)
			{
				continue;
			}

			if (this.World.getTileSquare(s.getTile().SquareCoords.X, s.getTile().SquareCoords.Y - 12).Type == this.Const.World.TerrainType.Ocean)
			{
				continue;
			}

			return true;
		}

		return false;
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

		_out.writeU8(this.m.Objectives.len());

		for( local i = 0; i < this.m.Objectives.len(); i = i )
		{
			_out.writeU32(this.m.Objectives[i]);
			i = ++i;
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

		local numObjectives = _in.readU8();

		for( local i = 0; i < numObjectives; i = i )
		{
			this.m.Objectives.push(_in.readU32());
			i = ++i;
		}

		this.contract.onDeserialize(_in);
	}

});

