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
						party = cityState.spawnEntity(tile, "PuՄk z " + cityState.getNameOnly(), true, this.Const.World.Spawn.Southern, this.Math.rand(70, 90) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
						this.Contract.addUnitsToEntity(party, this.Const.World.Spawn.Assassins, this.Math.rand(30, 40) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						party.getFlags().set("IsAssassins", true);
					}
					else if (i == 0 && this.Flags.get("IsSlavers"))
					{
						party = cityState.spawnEntity(tile, "ʄowcy Niewolnik\x0480w", true, this.Const.World.Spawn.Southern, this.Math.rand(60, 80) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
						this.Contract.addUnitsToEntity(party, this.Const.World.Spawn.NorthernSlaves, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						party.getFlags().set("IsSlavers", true);
					}
					else
					{
						party = cityState.spawnEntity(tile, "PuՄk z " + cityState.getNameOnly(), true, this.Const.World.Spawn.Southern, this.Math.rand(100, 130) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{Pokoj %employer%a jest ciemny i cichy. Bylby czarny i niemy, gdyby nie migotanie kilku swiec i cwierkanie ptakow. Stojac w cieniu, szlachcic przemawia.%SPEECH_ON%Poludniowe sukinsyny wysylaja na polnoc oddzialy rabusiów. To uciazliwa sprawa, wiesz, gdy kilku opalonych kundli kreci sie w okolicy, rabuje, pladruje, zabija i gwalci. Chca, zebym wycofal glowne sily na tyl, ale nie pozwolę na to. Dlatego tu jestes, najemniku. Potrzebuje, bys wytropil tych sabotażystów i wybil wszystkich. Czeka na ciebie %reward% koron, jesli podejmiesz sie zadania.%SPEECH_OFF% | Zastajesz %employer%a rozmawiajacego z porucznikami. Ma dwa stosy zetonow, jeden znacznie wyzszy od drugiego. Bierze z wyzszego i kladzie na mniejszy.%SPEECH_ON%A gdybym przydzielil tyle?%SPEECH_OFF%Porucznicy kreca glowami.%SPEECH_ON%To wlasnie tego chca poludniowcy. Jesli sciagniemy ludzi z linii frontu, na pewno to zauwaza i wykorzystaja jako moment ataku.%SPEECH_OFF%Wszyscy nagle spogladaja na ciebie. %employer% usmiecha sie szeroko.%SPEECH_ON%Aha, wyglada na to, ze naszym zbawca jest nie kto inny jak najemnik! Cóż, smialo powiem, ze najemnik moze to zalatwic. Ty, kapitanie, potrzebuje wojownikow, ktorzy zostana w okolicach %townname% i obronia je przed poludniowymi sabotażystami i najezdzcami. Czeka na ciebie %reward% koron za pomyslne wykonanie zadania!%SPEECH_OFF%Porucznicy armii wygladaja na niechetnych, by skladac taka oferte najemnikowi, ale wyczuwasz, ze czasy sa ciezkie. | Kieruja cie do biblioteki %employer%a, gdzie zastajesz go nad zwojami. Podnosi jeden z nich.%SPEECH_ON%W czasach takich jak te, jak myslisz, o czym czytam?%SPEECH_OFF%Zgadujesz, ze o sprawach wojskowych. Mezczyzna kreci glowa.%SPEECH_ON%O rolnictwie. Widzisz, obecnie jestem w stanie wojny. Ale wojny nie wygrywa sie tylko ludzmi, lecz takze lancuchami dostaw, logistyka, zywnoscia. To wszystko zapewnia zaplecze. Poludniowe kundelki rozumieja to tak samo jak my i wyslaly najezdzcow oraz infiltratorow, by zniszczyc zaplecze. By mnie rozproszyc, by rozproszyc moich zolnierzy. Potrzebuje, bys wytropil tych drani i chronil nasze domy, sklepy, farmy. Za pomyslne wykonanie oferuje %reward% koron.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_156.png[/img]{Poludniowcy wygladaja, jakby byli w trakcie przeprowadzki: polowicznie ubrani w swoje stroje i w polnocne odzienie, a do tego obciazeni skrzyniami z lupem. Jeden z nich figlarnie kreci sie w polnocnej sukni slubnej. Wygladaloby to jak przyjazna wizyta, gdyby nie to, ze wszyscy sa pokryci krwia i popiolem. Do boju! | Trafiasz na oddzial poludniowych najezdzcow zmierzajacy na polnoc. Sadzac po krwi na nich, juz utorowali sobie droge przez zagrody na odludziu. Do boju!}",
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
			Text = "[img]gfx/ui/events/event_87.png[/img]{Znajdujesz ostatniego zywego poludniowca, chwytasz go za wlosy i unosisz tak, by wszyscy go widzieli. Chlopi i rolnicy patrza, jak tniesz od gardla po kark, az cialo osuwa sie, a w rekach trzymasz jego glowe. Tlum wiwatuje.%SPEECH_ON%Nasz wybawca!%SPEECH_OFF%Bez watpienia %employer% ucieszy sie, slyszac o twojej robocie. | Poludniowcy zostali wybici, a tych, ktorzy przezyli rany, dopadaja miejscowi. To tortura, pelna zdzierania skory, obcinania przyrodzen i ogolnej krwawej kreatywnosci. Ale nie masz litosci dla obcych. Z kolei zaplata czekajaca u %employer%a budzi w tobie pewne zainteresowanie. | Gdy ostatni z poludniowcow trafił do grobu, wiesz, ze %employer% z radoscia zaplaci ci to, na co zaslugujesz. Odchodzac, widzisz kilku miejscowych okaleczajacych zwloki najezdzcow, jak nakazuje tradycja w tej i wszystkich innych czesciach swiata. | Przerazliwy krzyk zdradza, jak bardzo ostatni napastnik utracil panowanie nad soba, zanim zostaje dobity ostrzem. Jego towarzyszy miejscowi wlacza po ziemi, a zwloki tna na kawalki lub podpalaja. Patrzysz chwile, lecz w koncu ruszasz dalej, wiedzac, ze %employer% bedzie czekal. | Najwieksze szczescie maja martwi, bo ciezko ranni nie otrzymuja litosci. Miejscowi i osadnicy wchodza na pole bitwy, by upomniec sie o swoje ofiary, niektorzy nawet placa za to koronami, a wybrani najezdzcy sa potem bezczeszczeni, okaleczani i torturowani. Nie widzisz zadnych natychmiastowych egzekucji, a w jednym przypadku zdaje sie, ze uzdrowiciel jest obecny tylko po to, by przedluzyc cierpienie. To niecodzienny widok, ale jeszcze lepszy bedzie ten, gdy %employer% wrzuci spora nagrode do twojej sakiewki.}",
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
			Text = "[img]gfx/ui/events/event_94.png[/img]{Wrog zniknal, ale jego robota zostala dokonczona. Dym unosi sie nad budynkami spalonymi do fundamentow, a ci, ktorych nie zabrano jako zadluzonych na sprzedaz na poludnie, leza martwi na ulicach.\n\nNie ma sensu wracac do zleceniodawcy, bo masz marne szanse na zaplate za porazke. Najlepiej szukac nowej pracy gdzie indziej.}",
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
			Text = "[img]gfx/ui/events/event_165.png[/img]{Znajdujesz na drodze martwego rolnika z zakrzywionym sztyletem w plecach. Nikt nie zostawia tak dobrego sztyletu, a tak jak podejrzewasz, mordercy wciaz tu sa: grupa poludniowych zabojcow. Poruszaja sie jak cienie, a ich naostrzone stalowe ostrza blyszcza przy kazdym ruchu. Do boju! | Kobieta podbiega do ciebie w pospiechu, jej strzepiona suknia powiewa, rece machaja, oczy ma szeroko otwarte, a bialka czerwienieja jak muszle na krwawym brzegu. Zanim zdazy cos powiedziec, charczy i pada na ziemie. W tyle jej glowy tkwi sztylet, a dalej za nia stoi mezczyzna w czerni z kompania zabojcow!}",
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
			Text = "[img]gfx/ui/events/event_53.png[/img]{Poludniowy oddzial wyglada jak zbiorowisko ludzi z calego swiata. Dopiero z bliska widzisz, ze to dlatego, iz sa to lowcy niewolnikow! Mieszanina panow i niewolnikow rusza na %companyname%, rozchwiana formacja zlozona z wyszkolonych i niewyszkolonych. Widzisz wsrod nich polnocne twarze, ale niestety sa zlamani i prędzej podniosa bron przeciw kompanii, niz zawalcza o wolnosc. | Natrafiasz na poludniowcow, ale to wcale nie najezdzcy - to lowcy niewolnikow! Wioza wozy kobiet i dzieci, a gdy ich odkrywasz, lowcy pospiesznie zaczynaja scinac glowy wszystkim niedawno zniewolonym mezczyznom, ktorzy stanowia zagrozenie, podczas gdy reszta grupy szarzuje na %companyname%. W powietrzu czuc rzez, a ty uderzasz na oddzial bez wahania!}",
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
			Text = "[img]gfx/ui/events/event_79.png[/img]{Dobijasz ostatniego z poludniowych najezdzcow. Gdy kazesz kompanii zbierac to, co cenne, kilku mieszkancow wychodzi z wlasnymi darami.%SPEECH_ON%Myslelismy, ze to koniec swiata, a jednak jestescie, nasi rycerze.%SPEECH_OFF%Choc nie jestes rycerzem, nie wzdragasz sie przed przyjeciem rycerskiej pochwaly i rycerskiej nagrody: mieszkancy daja ci podarki! | Po rozprawieniu sie z najezdzcami powoli otacza cie grupa mieszkancow. Wygladaja na wyczerpanych i przestraszonych, a jednak niosa kosze z towarami. Oferuja je jako nagrode za ocalenie. Zdaja sie brac cie za zolnierzy %employer%a, ale nawet nie zamierzasz ujawniac, ze jestes najemnikiem. Przyjmujesz dary, uchylasz kapelusza i mowisz, ze to po prostu twoja robota, bo tak wlasnie jest.}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% wpuszcza cie, ale jego powitanie nie jest tak radosne, jakbys sie spodziewal. Ton ma w sobie cos z ojcowskiego rozczarowania.%SPEECH_ON%Dopadles kilku poludniowych zbójów. Nie swietnie, ale i nie tragicznie. Zaplace ci za kazdy powstrzymany oddzial, ale wolalbym, zebys spisal sie lepiej.%SPEECH_OFF%Masz ochote przeprosic, ale wiesz, ze kazda oznaka slabosci moze skonczyc sie zaniżeniem zaplaty, wiec zachowujesz to dla siebie. Wyplaca %reward% zgodnie z tym, co wypracowales. | %employer% ma przy sobie kilku straznikow, gdy wchodzisz, choc wsrod tlumu brakuje niektorych twarzy. Mezczyzna mowi powaznie.%SPEECH_ON%Zrobiles, co mogłeś, najemniku. Nie bylo prawdopodobne, bys zlapal wszystkich najezdzcow. Teraz to rozumiem. Oczywiscie oferuje ci odrobine rozsądnej wyrozumialosci. Byc moze zatrudnilem nie tego czlowieka, ale dzis tego nie osadzę. Zbyt wiele trzeba odbudowac. Masz tu %reward%, zgodnie z umowa za kazdy zniszczony oddzial najezdzcow.%SPEECH_OFF% | Wchodzisz do pokoju %employer%a i znajdujesz swoja nagrode w wysokosci %reward% koron, juz odliczona i polozona na stole. Wskazuje ja nonszalanckim ruchem reki.%SPEECH_ON%Najezdzcy przyszli, kilku ich powstrzymales, reszta pladrowala, rabowala i mordowala. A wiec. Wez swoja zaplate w wysokosci %reward% koron, najemniku. Odpowiada ona jakosci twojej pracy, wiec nie dziw sie, jesli w stosie koron zabraknie kilku sztuk.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{Zastajesz %employer%a nie w sali wojennej, lecz w bocznym gabinecie, gdzie kreci sie kilka kobiet. Zdejmuja pajeczyny z katow, ukladaja zwoje na polkach albo scieraja kurz z mebli. I wszystkie sa nagie, rzecz jasna. Mezczyzna rozklada ramiona.%SPEECH_ON%Uznalem, ze nalezy swietowac, bo %townname% zostalo ocalone, ocalone przez takich jak ty, najemniku!%SPEECH_OFF%Jest pijany, a kobiety delikatnie ustepuja mu miejsca, gdy zatacza sie po pokoju.%SPEECH_ON%No... no -hic- zapewniam cie, ze nie pozyczylem od ciebie %reward% koron. Wszystko jest -hic- tak jak obiecano. Chlopstwo jest zadowolone i ja tez. Bardzo zadowolone.%SPEECH_OFF%Sciska jedna z kobiet, a ta reaguje zywo jak wyplowialy dywan. Chwytasz sakiewke i wychodzisz, a kilka dziewczyn wymyka sie z toba drzwiami, gdy %employer% zapada w mamroczacy stupor. | Zastajesz %employer%a poza sala wojenna, w bibliotece, w ktorej byc moze jest wiecej polek niz ksiazek. Mimo to wydaje sie z siebie dumny.%SPEECH_ON%Twoja robota byla wspaniala, najemniku. Absolutnie wspaniala. Owszem, byly straty, ale ogolnie wszystko jest tam, gdzie powinno, a te poludniowe sukinsyny uciekly. Z twoja pomoca nasze linie frontu nie musialy slabnac, by pilnowac domostw. Oto twoje %reward% koron, jak obiecano.%SPEECH_OFF%Gdy mezczyzna odsuwa sie na bok, widzisz, ze na polce stoi swiezo wybielona czaszka. Wskazuje ja z dzieciecym urokiem.%SPEECH_ON%To jedna z ich czaszek. Zamierzam z niej pic wino albo do niej sikac. Jeszcze nie zdecydowalem.%SPEECH_OFF% | %employer% siedzi przy biurku z piramida trzech czaszek. Dlon spoczywa na nich, jakby glaskal psia glowe. Zauwazasz, ze wciaz widac paski miesa i nawet wlosy, a proces bielenia najpewniej byl pospieszny. Mezczyzna mowi radosnie.%SPEECH_ON%Dzieki tobie moi zolnierze moga pozostac na froncie, najemniku. Rozprawienie sie z tymi najezdzcami nie tylko uratowalo tu zycie wielu ludzi, ale tez moglo zapobiec upadkowi pierwszego klocka w szeregu wielu. Bez twojej pomocy ojcowie, bracia i synowie na froncie musieliby wrocic, by opiekowac sie rodzinami, a ta cala wojna poszlaby sie w diably.%SPEECH_OFF%Wolna reka przesuwa w twoja strone sakiewke.%SPEECH_ON%Twoje %reward% koron. Dobrze zarobiona waga monety, powiedzialbym.%SPEECH_OFF%Usmiecha sie ponuro i kiwa glowa w strone czaszek.%SPEECH_ON%Mysle, ze one by sie z tym zgodzily, choc musze przyznac, ze w tej sprawie bede przemawial w ich imieniu.%SPEECH_OFF%}",
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

