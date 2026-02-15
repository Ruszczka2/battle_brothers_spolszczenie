this.escort_caravan_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Caravan = null,
		NobleHouseID = 0,
		NobleSettlement = null,
		IsEscortUpdated = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.escort_caravan";
		this.m.Name = "Eskorta Karawany";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local nobleHouses = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);

		foreach( i, h in nobleHouses )
		{
			if (h.getSettlements().len() == 0)
			{
				continue;
			}

			if (this.m.Home.getOwner() != null && this.m.Home.getOwner().getID() == h.getID())
			{
				nobleHouses.remove(i);
				break;
			}
		}

		if (nobleHouses.len() != 0)
		{
			this.m.NobleHouseID = nobleHouses[this.Math.rand(0, nobleHouses.len() - 1)].getID();
		}

		local name = this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)] + " von " + this.World.FactionManager.getFaction(this.m.NobleHouseID).getNameOnly();
		this.m.Flags.set("NobleName", name);
		local settlements = this.World.EntityManager.getSettlements();
		local bestDist = 9000;
		local best;

		foreach( s in settlements )
		{
			if (!s.isDiscovered() || !s.isMilitary())
			{
				continue;
			}

			if (s.getID() == this.m.Destination.getID())
			{
				continue;
			}

			if (s.getOwner() != null && s.getOwner().getID() == this.m.NobleHouseID)
			{
				local d = this.getDistanceOnRoads(s.getTile(), this.m.Home.getTile());

				if (d < bestDist)
				{
					bestDist = d;
					best = s;
				}
			}
		}

		if (best != null)
		{
			this.m.NobleSettlement = this.WeakTableRef(best);
			this.m.Flags.set("NobleSettlement", best.getID());
		}

		this.contract.start();
	}

	function setup()
	{
		local settlements = this.World.EntityManager.getSettlements();
		local candidates = [];

		foreach( s in settlements )
		{
			if (s.getID() == this.m.Origin.getID())
			{
				continue;
			}

			if (!s.isAlliedWith(this.getFaction()))
			{
				continue;
			}

			if (this.m.Origin.isIsolated() || s.isIsolated() || !this.m.Origin.isConnectedToByRoads(s) || this.m.Origin.isCoastal() && s.isCoastal())
			{
				continue;
			}

			local d = this.m.Origin.getTile().getDistanceTo(s.getTile());

			if (d <= 12 || d > 100)
			{
				continue;
			}

			local distance = this.getDistanceOnRoads(this.m.Origin.getTile(), s.getTile());
			local days = this.getDaysRequiredToTravel(distance, this.Const.World.MovementSettings.Speed * 0.6, true);

			if (days > 7 || distance < 15)
			{
				continue;
			}

			if (this.World.getTime().Days <= 10 && days > 4)
			{
				continue;
			}

			if (this.World.getTime().Days <= 5 && days > 2)
			{
				continue;
			}

			candidates.push(s);
		}

		if (candidates.len() == 0)
		{
			this.m.IsValid = false;
			return;
		}

		this.m.Destination = this.WeakTableRef(candidates[this.Math.rand(0, candidates.len() - 1)]);
		local distance = this.getDistanceOnRoads(this.m.Origin.getTile(), this.m.Destination.getTile());
		local days = this.getDaysRequiredToTravel(distance, this.Const.World.MovementSettings.Speed * 0.6, true);

		if (days >= 5)
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}
		else if (days >= 2)
		{
			this.m.DifficultyMult = this.Math.rand(95, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(70, 85) * 0.01;
		}

		this.m.Payment.Pool = this.Math.max(150, distance * 7.0 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult());
		local r = this.Math.rand(1, 3);

		if (r == 1)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else if (r == 2)
		{
			this.m.Payment.Count = 0.25;
			this.m.Payment.Completion = 0.75;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		local maximumHeads = [
			15,
			20,
			25,
			30
		];
		this.m.Payment.MaxCount = maximumHeads[this.Math.rand(0, maximumHeads.len() - 1)];
		this.m.Flags.set("HeadsCollected", 0);
		this.m.Flags.set("Distance", distance);
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Eskortuj karawanę do %objective% około %days% drogi na %direction%",
					"Karawana zapewnia prowiant dla twych ludzi na czas drogi"
				];
				local isSouthern = this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState;

				if (!isSouthern && this.Math.rand(1, 100) <= this.Const.Contracts.Settings.IntroChance)
				{
					this.Contract.setScreen("Intro");
				}
				else if (isSouthern)
				{
					this.Contract.setScreen("TaskSouthern");
				}
				else
				{
					this.Contract.setScreen("Task");
				}
			}

			function end()
			{
				local isSouthern = this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState;
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 5)
				{
					if (this.World.Assets.getBusinessReputation() > 700 && !isSouthern)
					{
						this.Flags.set("IsStolenGoods", true);
						this.Flags.set("IsEnoughCombat", true);

						if (this.Contract.m.Home.getOwner() != null)
						{
							this.Contract.m.NobleHouseID = this.Contract.m.Home.getOwner().getID();
						}
						else if (this.Contract.m.Destination.getOwner() != null)
						{
							this.Contract.m.NobleHouseID = this.Contract.m.Destination.getOwner().getID();
						}
						else
						{
							local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
							this.Contract.m.NobleHouseID = nobles[this.Math.rand(0, nobles.len() - 1)].getID();
						}
					}
				}
				else if (r <= 10)
				{
					if (this.World.Assets.getBusinessReputation() > 1000 && this.Contract.getDifficultyMult() >= 0.95)
					{
						this.Flags.set("IsVampires", true);
						this.Flags.set("IsEnoughCombat", true);
					}
				}
				else if (r <= 15)
				{
					this.Flags.set("IsValuableCargo", true);
				}
				else if (r <= 20)
				{
					if (this.Contract.m.NobleHouseID != 0 && this.Flags.has("NobleName") && this.Flags.has("NobleSettlement") && !isSouthern)
					{
						this.Flags.set("IsPrisoner", true);
					}
				}
				else if (this.Contract.getDifficultyMult() < 0.95 || this.World.Assets.getBusinessReputation() <= 500 || this.Contract.getDifficultyMult() <= 1.1 && this.Math.rand(1, 100) <= 20)
				{
					this.Flags.set("IsEnoughCombat", true);
				}

				this.Contract.spawnCaravan();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
				this.World.State.setCampingAllowed(false);
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

				if (this.Contract.m.Payment.Count != 0)
				{
					if (this.Contract.m.BulletpointsObjectives.len() >= 2)
					{
						this.Contract.m.BulletpointsObjectives.remove(1);
					}

					this.Contract.m.BulletpointsObjectives.push("Otrzymasz zapłatę za głowę każdego ubitego przez ciebie bandyty (%killcount%/%maxcount%)");
				}

				this.World.State.setEscortedEntity(this.Contract.m.Caravan);
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
				else if (this.Contract.isPlayerAt(this.Contract.m.Destination))
				{
					if (this.Flags.get("IsCaravanHalfDestroyed"))
					{
						this.Contract.setScreen("Success2");
					}
					else
					{
						this.Contract.setScreen("Success1");
					}

					this.World.Contracts.showActiveContract();
				}
				else if (!this.Flags.get("IsEnoughCombat"))
				{
					if (this.Contract.spawnEnemies())
					{
						this.Flags.set("IsEnoughCombat", true);
					}
				}
				else
				{
					local parties = this.World.getAllEntitiesAtPos(this.World.State.getPlayer().getPos(), 400.0);
					local numParties = 0;

					foreach( party in parties )
					{
						numParties = ++numParties;
						numParties = numParties;
					}

					if (numParties > 2)
					{
						return;
					}

					if (this.Flags.get("IsStolenGoods") && this.World.State.getPlayer().getTile().HasRoad)
					{
						if (!this.TempFlags.get("IsStolenGoodsDialogTriggered") && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 1)
						{
							this.TempFlags.set("IsStolenGoodsDialogTriggered", true);
							this.Contract.setScreen("StolenGoods1");
							this.World.Contracts.showActiveContract();
						}
					}
					else if (this.Flags.get("IsVampires") && !this.World.getTime().IsDaytime)
					{
						if (!this.TempFlags.get("IsVampiresDialogTriggered") && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 2)
						{
							this.TempFlags.set("IsVampiresDialogTriggered", true);
							this.Contract.setScreen("Vampires1");
							this.World.Contracts.showActiveContract();
						}
					}
					else if (this.Flags.get("IsValuableCargo"))
					{
						if (!this.TempFlags.get("IsValuableCargoDialogTriggered") && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 1)
						{
							this.TempFlags.set("IsValuableCargoDialogTriggered", true);
							this.Contract.setScreen("ValuableCargo1");
							this.World.Contracts.showActiveContract();
						}
					}
					else if (this.Flags.get("IsPrisoner"))
					{
						if (!this.TempFlags.get("IsPrisonerDialogTriggered") && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 1)
						{
							this.TempFlags.set("IsPrisonerDialogTriggered", true);
							this.Contract.setScreen("Prisoner1");
							this.World.Contracts.showActiveContract();
						}
					}
				}
			}

			function onCombatVictory( _combatID )
			{
				this.Flags.set("IsEnoughCombat", true);

				if (_combatID == "StolenGoods")
				{
					this.Flags.set("IsStolenGoods", false);
					this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).addPlayerRelation(this.Const.World.Assets.RelationAttacked, "Zabiłeś trochę ich ludzi");
				}
				else if (_combatID == "Vampires")
				{
					this.Flags.set("IsVampires", false);
				}

				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("IsEnoughCombat", true);
				this.Flags.set("IsFleeing", true);
				this.Flags.set("IsStolenGoods", false);
				this.Flags.set("IsVampires", false);

				if (_combatID == "StolenGoods")
				{
					this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).addPlayerRelation(this.Const.World.Assets.RelationAttacked, "Zaatakowałeś ich ludzi");
				}

				if (this.Contract.m.Caravan != null && !this.Contract.m.Caravan.isNull())
				{
					this.Contract.m.Caravan.die();
					this.Contract.m.Caravan = null;
				}

				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getType() == this.Const.EntityType.CaravanDonkey && _actor.getWorldTroop() != null && _actor.getWorldTroop().Party.getID() == this.Contract.m.Caravan.getID())
				{
					this.Flags.set("IsCaravanHalfDestroyed", true);
				}
				else
				{
					this.Contract.addKillCount(_actor, _killer);
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

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}

				this.Contract.clearSpawnedUnits();
			}

		});
		this.m.States.push({
			ID = "Running_Prisoner",
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.NobleSettlement != null && !this.Contract.m.NobleSettlement.isNull())
				{
					this.Contract.m.NobleSettlement.getSprite("selection").Visible = true;
				}

				this.Contract.m.BulletpointsObjectives = [
					"Odprowadź szlachcica zwanego %noble% bezpiecznie do %noblesettlement% na %nobledirection%"
				];
				this.Contract.m.BulletpointsPayment = [];
				this.Contract.m.BulletpointsPayment.push("Otrzymasz nagrodę na miejscu");
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.NobleSettlement))
				{
					if (this.Flags.get("IsPrisonerLying"))
					{
						this.Contract.setScreen("Prisoner4");
					}
					else
					{
						this.Contract.setScreen("Prisoner3");
					}

					this.World.Contracts.showActiveContract();
				}
			}

		});
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationPerHeadAtDestination);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "Negocjacje",
			Text = "[img]gfx/ui/events/event_98.png[/img]{Gabinet %employer%a oświetla ciepły ogień. Oferuje ci miejsce i kielich wina, oba przyjmujesz.%SPEECH_ON%Najemniku, wiesz, jak niebezpieczne są ostatnio drogi?%SPEECH_OFF%Na bogów, to naprawdę dobre wino. Kiwasz głową i próbujesz ukryć zdziwienie. %employer% uśmiecha się krótko i ciągnie dalej.%SPEECH_ON%Dobrze, więc zrozumiesz zadanie. Potrzebuję eskorty karawany do %objective%, jakieś %days% stąd. Proste, prawda? Masz czas? Jeśli tak, porozmawiajmy.%SPEECH_OFF% | Zastajesz %employer%a nad mapami na biurku. Przesuwa palcem do krawędzi jednej mapy i ciągnie go na drugą.%SPEECH_ON%Potrzebuję eskorty karawany do %objective%, %days% %direction% stąd. Będzie niebezpiecznie? Oczywiście. Dlatego przychodzę do ciebie, najemniku. Jesteś zainteresowany?%SPEECH_OFF% | %employer% krzyżuje ramiona i zaciska usta.%SPEECH_ON%Zwykle nie prosiłbym najemników o ochronę karawany, ale moja stała załoga jest trochę niezdolna - choroby, pijaństwo, swawola... rozumiesz. Najważniejsze, że mam ważny ładunek do %objective%, jakieś %days% na %direction%, i potrzebuję kogoś, kto go dopilnuje. Jesteś zainteresowany?%SPEECH_OFF% | %employer% patrzy przez okno, obserwując grupę mężczyzn ładujących towar na kilka wozów. Mówi, nie spoglądając na ciebie.%SPEECH_ON%Mam ważną dostawę do %objective%, mniej więcej %days% %direction% stąd. Niestety konkurent przebił mnie w wynajęciu lokalnej grupy strażników karawan. Teraz potrzebuję twoich usług. Porozmawiajmy o liczbach, jeśli jesteś zainteresowany.%SPEECH_OFF% | %employer% zdejmuje skrzynię z półki i stawia ją na biurku. Gdy ją otwiera, wysypuje się garść papierów, prawie uciekając. Wyciąga jeden i rozkłada. Z jednej strony jest kontrakt, z drugiej mały szkic mapy.%SPEECH_ON%To proste, najemniku. Zlecono mi dostarczenie... konkretnego ładunku do %objective%. Mam towar, ale nie mam strażników. Jeśli interesuje cię rola eskorty na jakiś czas, może %days% albo tyle, daj znać i dogadamy liczby.%SPEECH_OFF% | Patrzysz przez okno %employer%a i obserwujesz, jak ludzie ładują kilka wozów towarem. %employer% dołącza do ciebie z dwoma kielichami wina. Bierzesz jeden i wypijasz go jednym haustem. Mężczyzna patrzy na ciebie.%SPEECH_ON%To nie było tanie. Powinieneś się nim delektować.%SPEECH_OFF%Wzruszasz ramionami.%SPEECH_ON%Wybacz. Mogę dostać następny, żeby zrobić to dobrze?%SPEECH_OFF%%employer% odwraca się i podchodzi do biurka.%SPEECH_ON%Potrzebuję eskorty karawany do %objective%. To około %days% na %direction% stąd. Proste, prawda? Jest w tym sporo koron, jeśli jesteś zainteresowany.%SPEECH_OFF% | %employer% przegląda swoje księgi, wertując, jak się wydaje, sporo liczb.%SPEECH_ON%Mam transport pewnych towarów do %objective% i wyrusza wkrótce. Potrzebuję kilku solidnych mieczników, by upewnić się, że dotrze bezpiecznie. Powinno zająć wam około %days% podróży. Podejmiesz się?%SPEECH_OFF% | %employer% przechodzi do sedna.%SPEECH_ON%Mam transport... cóż, to cię nie dotyczy. Jedzie do %objective% i, jak wielu, martwię się o bandytów na drodze. Potrzebuję, byś pilnował karawany, aż bezpiecznie dotrze w około %days%. Brzmi jak coś, co cię interesuje?%SPEECH_OFF% | %employer% spogląda przez okno.%SPEECH_ON%Obaj wiemy, że bandyci i bogowie wiedzą co jeszcze terroryzują te okolice, a wszyscy lubią się kręcić po traktach. Po szczególnie złej wyprawie moi dawni strażnicy stracili serce do tej roboty. Teraz potrzebuję kogoś innego, by pilnował mojego transportu. Następny wyrusza do %objective% na %direction%, może %days% stąd. Brzmi jak miejsce, za które chciałbyś dostać zapłatę?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Porozmawiajmy o pieniądzach. | O ilu konkretnie koronach tu mówimy? | Jaka jest płaca?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Nie jestem zainteresowany. | Nie takiego rodzaju pracy szukamy.}",
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
			ID = "TaskSouthern",
			Title = "Negocjacje",
			Text = "[img]gfx/ui/events/event_98.png[/img]{Pośród wież i wolier, dzwony i ptaki odbijają się echem w powietrzu niczym roztrzęsione akordy uwięzionego miasta. Pod tym hałasem, w przytłumionych marmurowych salach pałacu, zastajesz %employer%a wydającego rozkaz zabicia sługi. Wina jest ci nieznana, ale Wezyra to w najmniejszym stopniu nie obchodzi, gdy podchodzi do ciebie z uśmiechem i czystymi dłońmi.%SPEECH_ON%Kilku radnych wysyła towary do %objective%, dobre %days% na %direction%. Te dobra muszą dotrzeć w stanie zdatnym dla oczekujących kupców. Wierzę, że Koroniarz taki jak ty potrafi się tym zająć, prawda?%SPEECH_OFF% | Znajdujesz kilku radnych i starszych %employer%a, tutejszego Wezyra. Podchodzą do ciebie z dokumentem opatrzonym jego pieczęcią.%SPEECH_ON%Wkrótce wyruszymy do %objective% z karawaną towarów. Straż miejska odmawia pomocy w obronie naszych dóbr, jednak wciąż lśnimy pod okiem Gildera, a nasze kieszenie pełne są blasku. Zapłacimy ci, Koroniarzu, byś pomógł nam dotrzeć do celu przez najbliższe %days%.%SPEECH_OFF% | Chłopiec służący trzyma w jednej ręce smycz niewolników, a w drugiej notę. Podaje tę drugą, która zawiera instrukcję spotkania z grupą kupców. Ogłaszają, że podróżują do %objective%, około %days% na %direction%, z rozkazu Gildera i Wezyra, i potrzebują ochrony. Za to twoje usługi będą hojnie opłacone. | Plac kupiecki tętni interesami i, jak widać, masz być ich częścią. Kilku \"najlepszych\" kramarzy Wezyra chce poprowadzić karawanę towarów do %objective%, dobre %days% drogi. Jeden wyjaśnia krótko.%SPEECH_ON%Jeśli Gilder miałby odwrócić wzrok, błagam, by tak zwani \"żołnierze\" tego miasta znaleźli świat cienia. Ty, Koroniarzu, sądzę, że pomożesz nam tam, gdzie inni nie pomogą? Za monetę, oczywiście.%SPEECH_OFF% | Patrzysz, jak niewolnicy pakują towary i ładują je na serię wozów. Właściciele karawany dostrzegają cię i podchodzą, spychając swoich robotników lub bijąc ich bez wyraźnego powodu, poza nieznaną przyjemnością, jaką im to sprawia. Jeden promienieje radością na twój widok. Wyciąga rękę, ale ty jej nie ściskasz.%SPEECH_ON%Ach, Koroniarzu, prawda, że ta dłoń splamiła się ciałem dłużnika, ale nie bądź taki nieśmiały. Wszyscy lśnimy pod okiem Gildera, prawda? Mamy dla ciebie zadanie, ważne zważywszy na rządy naszego suzerena %employer%a. Karawana zmierza do %objective%, dobre %days% drogi, i wymaga porządnej ochrony, by dotrzeć w dobrym stanie. Czy to zadanie odpowiada twoim zainteresowaniom monetą?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Porozmawiajmy o pieniądzach. | O ilu konkretnie koronach tu mówimy? | Jaka jest płaca?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Nie jestem zainteresowany. | Nie takiego rodzaju pracy szukamy.}",
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
			ID = "StolenGoods1",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Na drodze pojawia się grupa ludzi pod sztandarem %noblehouse%. Ich konie stoją z boku, a wodze leżą na ziemi. Wygląda na to, że czekali na ciebie. Jeden z nich wychodzi do przodu, z rękami na biodrach.%SPEECH_ON%Przewozicie skradzione dobra, przyjaciele. Skradzione dobra, które należą do %noblehouse%. Oddajcie je natychmiast albo ponieście konsekwencje.%SPEECH_OFF%Hmm, powinieneś był wiedzieć, że %employer% wiezie coś szemranego. | Kilku mężczyzn wychodzi na drogę. Niosą sztandar %noblehouse%, co zapewne nie jest dobrym znakiem tego, co nadchodzi. Ich porucznik staje przed wami.%SPEECH_ON%Pozdrowienia! Niestety przewozicie skradzione dobra należące do %noblehouse%. Odsuńcie się od karawany, zawróćcie i wróćcie, skąd przyszliście. Zróbcie to, a przeżyjecie. Zostańcie, a dziś tu umrzecie.%SPEECH_OFF% | Cóż, wygląda na to, że %employer% nie był z tobą do końca szczery: grupa chorążych %noblehouse% pyta, co robisz, przewożąc dobra, które im skradziono. Ich porucznik krzyczy do was.%SPEECH_ON%Jeśli chcecie dożyć jutra, oddajcie towar i wracajcie, skąd przyszliście. Rozumiem, że po prostu wykonujecie swoją pracę. Jednak wasza praca nie polega na nieposłuszeństwie wobec mnie. Zróbcie to, a obiecuję, że wszyscy dziś tu zginiecie.%SPEECH_OFF% | Mężczyzna wychodzi na drogę i nie wygląda na to, by miał się ruszyć. Jeden z woźniców karawany szarpie wodze i w tej samej chwili do samotnika dołącza duża grupa uzbrojonych ludzi. Niosą znak %noblehouse%.%SPEECH_ON%A więc to tutaj trafiły dobra %noblehouse%. Przewozicie towary należące do naszego rodu. Jeśli chcecie żyć, oddajcie je wszystkie. Jeśli chcecie umrzeć, to po prostu nie róbcie tego, o co proszę, i zobaczcie, co się stanie.%SPEECH_OFF%%randombrother% podchodzi do ciebie i szepcze.%SPEECH_ON%Nie powinniśmy byli ufać temu szczurze %employer%owi.%SPEECH_OFF% | Naprawdę powinieneś mocniej naciskać, by dowiedzieć się, co przewozisz. Na drodze zaczepia cię grupa ludzi, żądając, byś oddał karawanę i wrócił, skąd przyszedłeś. Gdy pytasz, kto dokładnie stawia takie żądania, odpowiadają, że są z %noblehouse% i że każdy towar, który przewozisz, został skradziony tydzień temu. Ich porucznik jasno stawia warunki pokojowego przejścia.%SPEECH_ON%Odejdźcie, a będziecie żyć. Nie mam nic do was, tylko do waszego zwierzchnika. Jeśli jednak przeszkodzicie w odzyskaniu własności, zginiecie. Nie umierajcie za dobra, które nie należą do was. Nie warto.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Banner = "",
			Options = [
				{
					Text = "Nie sądzę. Będziemy ich bronić, jeśli zajdzie potrzeba.",
					function getResult()
					{
						return "StolenGoods2";
					}

				},
				{
					Text = "Zbyt mało nam płacą, byśmy robili sobie wrogów z kogoś takiego, jak %noblehouse%. Zabierzcie je.",
					function getResult()
					{
						return "StolenGoods3";
					}

				}
			],
			function start()
			{
				this.Banner = this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).getUIBannerSmall();

				if (this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).getPlayerRelation() >= 80)
				{
					this.Options.push({
						Text = "Waszym lordom nie spodoba się, że ich sojusznicy, %companyname%, są przez was tak traktowani.",
						function getResult()
						{
							return "StolenGoods4";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "StolenGoods2",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Kiwasz głową.%SPEECH_ON%To wszystko brzmi dobrze, ale niestety płacą nam za ochronę tych dóbr, a nie za ustalanie, do kogo należą.%SPEECH_OFF%Porucznik także kiwa głową, niemal ze zrozumieniem.%SPEECH_ON%Dobrze więc.%SPEECH_OFF%Dobywa miecza. Ty także. Mężczyzna unosi dłoń, gotów wydać rozkaz.%SPEECH_ON%Szkoda, że tak się to skończy. Szarża!%SPEECH_OFF% | Dobywasz miecza.%SPEECH_ON%Nie jestem tu, by mediować między rodami. Jestem tu, by ochronić tę karawanę do %objective%. Jeśli chcesz to utrudnić, to tak, dziś ktoś tu zginie.%SPEECH_OFF% | Wskazujesz dłonią linię wozów.%SPEECH_ON%%employer% nakazał mi pilnować jego towaru aż do celu. I dokładnie to zamierzam zrobić.%SPEECH_OFF%Patrząc na porucznika, powoli wysuwasz miecz. On robi to samo, kiwając głową.%SPEECH_ON%Szkoda, że musi do tego dojść.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Banner = "",
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos(), true);
						p.CombatID = "StolenGoods";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.IsAutoAssigningBases = false;
						p.TemporaryEnemies = [
							this.Contract.m.NobleHouseID
						];
						p.EnemyBanners = [
							this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).getPartyBanner()
						];

						foreach( e in p.Entities )
						{
							if (e.Faction == this.Contract.getFaction())
							{
								e.Faction = this.Const.Faction.PlayerAnimals;
							}
						}

						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.m.NobleHouseID);
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
				this.Banner = this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "StolenGoods3",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{%employer%owi się to nie spodoba, ale jeśli przewoził skradzione dobra, powinien był ci o tym powiedzieć. Skinieniem dłoni każesz ludziom odsunąć się. Chorążowie natychmiast zbiegają się do karawany, rozładowując towary, podczas gdy bezradni parobcy i kupcy przyglądają się temu. | Nie zamierzasz toczyć ciężkiej walki o dobra, które obchodzą cię niewiele. Odsuwasz się, zapraszając chorążych, by zabrali to, co do nich należy. %randombrother% mówi, że %employer% nie będzie z tego zadowolony. Kiwasz głową.%SPEECH_ON%Cóż, to jego problem.%SPEECH_OFF% | Nie jesteś od przewożenia skradzionych dóbr ani zabijania chorążych, którzy nie mają do ciebie pretensji. Mimo protestów kilku kupców odsuwasz się, pozwalając karawanie i towarom wrócić do prawowitych właścicieli. Jeden z kupców potrząsa pięścią, dając ci do zrozumienia, że %employer% będzie bardzo niezadowolony, słysząc, że nie dotrzymałeś kontraktu.}",
			Image = "",
			List = [],
			Banner = "",
			Options = [
				{
					Text = "A to pech.",
					function getResult()
					{
						this.Flags.set("IsStolenGoods", false);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Nie zdołałeś ochronić karawany");
						this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).addPlayerRelation(this.Const.World.Assets.RelationNobleContractPoor, "Współpracowałeś z ich żołnierzami");
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.updateAchievement("NeverTrustAMercenary", 1, 1);
				this.Banner = this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "StolenGoods4",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Mówisz ludziom, że jesteś w dobrych stosunkach z ich %noblehouse% i nie zamierzasz ich psuć. Jeden z napastników waha się.%SPEECH_ON%Cholera, może kłamać, ale jeśli nie... nie warto ryzykować. Spadajmy stąd.%SPEECH_OFF% | Kilkoma oschłymi słowami mówisz, że jesteś dobrze zaznajomiony z rodziną %noblehouse%, wymieniając kilka nazwisk z linii rodu. Mężczyźni chowają miecze, nie chcąc bardziej mieszać w tej sytuacji. Lepiej dmuchać na zimne. | Dajesz znać, że masz dobre stosunki z rodziną %noblehouse%. Proszą o dowód, więc wymieniasz wszystkie szlacheckie nazwiska, jakie pamiętasz, i trochę szczegółów o skłonnościach niektórych z nich. To wystarcza - napastnicy opuszczają broń i zostawiają was w spokoju.}",
			Image = "",
			List = [],
			Banner = "",
			Options = [
				{
					Text = "Ruszamy dalej!",
					function getResult()
					{
						this.Flags.set("IsStolenGoods", false);
						return 0;
					}

				}
			],
			function start()
			{
				this.Banner = this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "ValuableCargo1",
			Title = "Podczas obozowania...",
			Text = "[img]gfx/ui/events/event_55.png[/img]{Gdy karawana odpoczywa, %randombrother% bierze cię pod ramię i potajemnie prowadzi na tył jednego z wozów. Rozgląda się, czy nikt nie patrzy, i podnosi wieko skrzyni. W środku turlają się klejnoty, ostro połyskując w skąpym świetle. Zamyka wieko.%SPEECH_ON%Co robimy? To kupa forsy, panie.%SPEECH_OFF% | Gdy karawana zatrzymuje się, by naprawić koło, oś pęka i wóz przewraca się na bok. Skrzynia wypada na ziemię, a wieko odskakuje. Bierzesz młotek, by ją zamknąć, gdy zauważasz, że z pudła wysypało się kilka klejnotów. %randombrother% też to widzi i kładzie dłoń na broni.%SPEECH_ON%To, eee, wyjątkowo głośny ładunek, panie. Mamy trzymać to w tajemnicy czy...?%SPEECH_OFF% | Przywódca karawany zaczyna krzyczeć. Widzisz, jak goni i szybko obala mężczyznę próbującego uciec. Obaj kręcą się po ziemi, a z wiru kończyn wylatuje brązowy worek. Ląduje u twoich stóp, a z rozwiązanego otworu wysypują się klejnoty. %randombrother% schyla się i podnosi kilka. Prostuje się, druga dłoń spoczywa na broni. Patrzy na ciebie.%SPEECH_ON%Jest tu dość, wiesz, żeby się opłaciło...%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wracaj do swojej roboty, zanim każę cię wychłostać. Mamy kontrakt do wypełnienia.",
					function getResult()
					{
						this.Flags.set("IsValuableCargo", false);
						return 0;
					}

				},
				{
					Text = "W końcu szczęście się do nas uśmiechnęło. Zabierzemy klejnoty dla siebie!",
					function getResult()
					{
						return "ValuableCargo2";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ValuableCargo2",
			Title = "Podczas obozowania...",
			Text = "[img]gfx/ui/events/event_50.png[/img]{Podchodzi strażnik karawany.%SPEECH_ON%Hej, panowie, wracamy na trakt, tak?%SPEECH_OFF%Kiwasz głową do swojego najemnika. On odpowiada, po czym szybko odwraca się i wbija sztylet w brodę strażnika. Reszta kompanii, rozumiejąc, co się dzieje, dobywa broni i rzuca się na strażników. Nie mają szans i gdy rzeź się kończy, jesteś nowym właścicielem naprawdę pięknych klejnotów. | Moc klejnotów cię obezwładnia! Szybkim skinieniem i okrzykiem rozkazujesz %companyname% zabić wszystkich strażników. To szybki proces, bo ufali, że im pomożesz, a kilku pada, wciąż zastanawiając się, czemu tak brutalnie ich zdradzono. | Te klejnoty są warte więcej, niż mógłby ci zapłacić jakikolwiek kontrakt. Krzyczysz ile sił, rozkazując %companyname% zabić każdego strażnika w zasięgu wzroku. Twoi ludzie są szybcy i bez wahania, strażnicy powolni i zdezorientowani. Mija tylko chwila, a klejnoty są twoje. %employer% nie będzie szczęśliwy, ale do diabła z nim, masz teraz klejnoty.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Powinny być warte nieco koron.",
					function getResult()
					{
						this.Flags.set("IsValuableCargo", false);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationBetrayal, "Wyrżnąłeś karawanę, którą miałeś ochraniać");
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.Assets.addMoralReputation(-10);
						this.Contract.m.Caravan.die();
						this.Contract.m.Caravan = null;
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				local n = this.Math.min(this.Math.max(1, this.World.Assets.getBusinessReputation() / 1000), 3) + 1;

				for( local i = 0; i != n; i = i )
				{
					local gems = this.new("scripts/items/trade/uncut_gems_item");
					this.World.Assets.getStash().add(gems);
					this.List.push({
						id = 10,
						icon = "ui/items/" + gems.getIcon(),
						text = "Zdobywasz " + gems.getName()
					});
					i = ++i;
				}
			}

		});
		this.m.Screens.push({
			ID = "Prisoner1",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Idąc obok karawany, widzisz kilku strażników spluwających do klatki. W środku siedzi mężczyzna w łachmanach, z ubłoconymi stopami. Dostrzega cię wśród nienawiści i błaga.%SPEECH_ON%Proszę, najemniku! Nazywam się %noble% z %noblehouse%. Zabij tych ludzi, a zostaniesz sowicie wynagrodzony!%SPEECH_OFF%Jeden ze strażników śmieje się.%SPEECH_ON%Nie wierz w jego kłamstwa, najemniku.%SPEECH_OFF% | Przechodzisz obok wozu, gdy nagle coś chwyta cię za ramię. Odwracasz się z mieczem w dłoni, a chwytająca dłoń cofa się w mrok wozu. Ostrożnie podnosisz płachtę i widzisz tam zakutego mężczyznę. Jego głos jest okropny, jakby pierwsze słowa powinny błagać o wodę.%SPEECH_ON%Nie zważaj na te łachmany, najemniku, bo jestem %noble% z %noblehouse%. Zabij wszystkich tych strażników, uwolnij mnie i dopilnuj, bym wrócił do domu. Za to dopilnuję, byś został należycie wynagrodzony.%SPEECH_OFF%Strażnik przerywa mu, a więzień cofa się w głąb wozu. Strażnik śmieje się.%SPEECH_ON%Czy ten mały skurczybyk znów szerzy kłamstwa? Chodź, najemniku, mamy jeszcze drogę przed sobą.%SPEECH_OFF% | Słyszysz odgłosy torsji dobiegające z jednego z wozów. Podchodzisz i widzisz człowieka w łachmanach, zwiniętego, a nad nim stoi uśmiechnięty strażnik.%SPEECH_ON%Powiedz do mnie takim tonem jeszcze raz, a będziesz srał zębami. Zrozumiano, więźniu?%SPEECH_OFF%Leżący mężczyzna kiwa głową i cofa się. Widzi cię, po czym słabo kiwa głową.%SPEECH_ON%Najemniku, jestem %noble% z %noblehouse%. Na pewno słyszałeś moje imię. Jeśli zabijesz tego marnego drania i wszystkich jego podobnych, dopilnuję, byś został bardzo hojnie wynagrodzony.%SPEECH_OFF%Strażnik uśmiecha się nerwowo.%SPEECH_ON%Nie wierz ani słowa temu człowiekowi, najemniku!%SPEECH_OFF% | %SPEECH_ON%Najemniku! Czy mogę zamienić słowo?%SPEECH_OFF%Odwracasz się i, ku zaskoczeniu, widzisz człowieka z tyłu jednego z wozów. Jest skuty łańcuchami.%SPEECH_ON%Niech będzie ci wiadomo, że jestem %noble% z %noblehouse%. Oczywiście mam kłopoty, ale to cię nie powstrzyma, prawda? Zabij tych strażników i odprowadź mnie do rodziny. Myślę, że zapłacą znacznie więcej niż dostaniesz za pilnowanie tego zasranego karawanu.%SPEECH_OFF%Podchodzi jeden ze strażników, śmiejąc się.%SPEECH_ON%Ej, ten szkodnik znów bredzi kłamstwa? Nie przejmuj się jego mamrotaniem, najemniku. Chodź, wracajmy do roboty.%SPEECH_OFF% | Słyszysz wyraźny dźwięk łańcuchów, to rozwijające się trzaski ogniw, to metaliczne pobrzękiwanie, które każe myśleć, że mogłyby tak łatwo zostać uwolnione. Zamiast tego bardzo nie-wolny człowiek błaga cię.%SPEECH_ON%Wreszcie mogę zamienić z tobą słowo. Najemniku, wiem, że możesz mi nie wierzyć, ale jestem %noble% z %noblehouse%. Nie wiem, czemu ci ludzie mnie uprowadzili, ale to nie ma znaczenia. Liczy się to, że staniesz na wysokości swojej nazwy, zwłaszcza tej części \"sprzedaj\". Jeśli zabijesz tych strażników i odprowadzisz mnie do domu, dopilnuję, byś został hojnie wynagrodzony!%SPEECH_OFF%Podchodzi strażnik.%SPEECH_ON%Ciszej, ty bękarcie! Nie zwracaj na niego uwagi, najemniku. Mamy robotę do zrobienia, chodź.%SPEECH_OFF% | Gdy karawana robi krótką przerwę, zauważasz mężczyznę odpoczywającego z nogą zwisającą z platformy wozu. Tyle że jego stopy nie są wolne - są skute łańcuchami, a ręce wcale nie lepiej. Widzi cię.%SPEECH_ON%Rozpoznajesz mnie? Jestem %noble% z %noblehouse%, więźniem o pewnej wartości, jak zapewne sugeruje moje imię. Ale jako wolny człowiek jestem wart jeszcze więcej. Zabij tych strażników, zabierz mnie do domu, a nie będziesz mógł chodzić od tylu koron w kieszeniach!%SPEECH_OFF%Strażnik podchodzi i uderza go po goleniach pochwą miecza.%SPEECH_ON%Cisza, ty! Chodź, najemniku, zaraz ruszamy. I nie zwracaj uwagi na tego bękarta, co? Ma dla ciebie same kłamstwa.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nie marnuj tchu. W rzyci mam to, kim jesteś.",
					function getResult()
					{
						this.Flags.set("IsPrisoner", false);
						return 0;
					}

				},
				{
					Text = "Oby to było tego warte. Będę cię trzymał za słowo, gdy już cię uwolnię.",
					function getResult()
					{
						this.updateAchievement("NeverTrustAMercenary", 1, 1);
						return "Prisoner2";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Prisoner2",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Spluwasz i odchrząkujesz, po czym szybko dobywasz miecza i powalasz strażnika karawany. %randombrother% to widzi i natychmiast rozkazuje reszcie %companyname% zrobić to samo. Przez chwilę panuje chaotyczna rzeź, strażnicy nie wiedzą, co się dzieje, gdy twoi ludzie ich atakują.\n\n Uwalniając więźnia, słyszysz jego serdeczne podziękowania, po czym każe ci prowadzić.%SPEECH_ON%Gdy dotrzemy do %noblesettlement% i zobaczą moją żywą, uśmiechniętą twarz, zasypią cię koronami!%SPEECH_OFF% | Dobywasz miecza i przecinasz strażnika przez twarz. Obraca się, a ty wbijasz ostrze w jego czaszkę, mózg pieni się między ukośnymi odłamkami kości jak pęknięte suflet. %randombrother% to widzi i wzywa resztę kompanii do walki. Szybko rozprawiają się z resztą strażników. Gdy uwalniasz %noble%a, wskazuje drogę.%SPEECH_ON%Do %noblesettlement%, gdzie moja rodzina nagrodzi was tak, że nie uwierzycie!%SPEECH_OFF% | Gdy strażnik karawany odwraca się, sięgasz po sztylet i wbijasz go pod pachę, prosto w serce. Tłumi coś w gardle i pada na ziemię. Nadchodzi drugi strażnik, widzi to i od razu dostaje twoim mieczem w brzuch. Jego krzyki nie są już stłumione. Wkrótce zaczyna się walka, choć jest zupełnie jednostronna, bo %companyname% szybko rozprawia się ze strażnikami.\n\n Gdy wszystko się kończy, %noble% zostaje uwolniony. Pocierając fioletowe nadgarstki, wskazuje ci %noblesettlement%.%SPEECH_ON%Naprzód, odprowadź mnie do rodziny, żebym mógł napełnić twoje kieszenie za tę niesamowitą odwagę!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Już widzę, jak moje kieszenie wypełniają się koronami!",
					function getResult()
					{
						this.Flags.set("IsPrisoner", false);
						this.Flags.set("IsPrisonerLying", this.Math.rand(1, 100) <= 33);
						this.Contract.setState("Running_Prisoner");
						this.World.State.setCampingAllowed(true);
						this.World.State.getPlayer().setVisible(true);
						this.World.Assets.setUseProvisions(true);

						if (!this.World.State.isPaused())
						{
							this.World.setSpeedMult(1.0);
						}

						this.World.State.m.LastWorldSpeedMult = 1.0;
						this.Contract.m.Caravan.die();
						this.Contract.m.Caravan = null;
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationAttacked, "Wyrżnąłeś karawanę, którą miałeś ochraniać");
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.Assets.addMoralReputation(-5);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Prisoner3",
			Title = "W %noblesettlement%",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Docierasz do %noblesettlement%. Dobrze opancerzony strażnik dostrzega %noble%a i krzyczy rozkaz, który szybko rozchodzi się po mieście. Wkrótce nadjeżdża kilka koni, jeźdźcy zeskakują z siodeł. Wygląda na to, że mężczyzna jednak nie kłamał. %noblehouse% nagradza cię dokładnie tak, jak obiecał więzień. | Zanim w ogóle wejdziesz do %noblesettlement%, kilku jeźdźców wyjeżdża ci naprzeciw. Za nimi powiewają królewskie płótna. Niedaleko widać też spory oddział ciężkozbrojnych strażników. Nie trzeba wiele domysłów, bo szybko witają więźnia z powrotem w swoich szeregach. Jeden z nich wraca z zamieszania powitania, by wręczyć ci nagrodę. Niewiele mają do powiedzenia do niskiego urodzenia, które dopilnowało, by wysokiemu urodzeniu głowa została na karku. No cóż. | Więzień nie kłamał, ale dostajesz szybkie przypomnienie o swoim miejscu w społeczeństwie: bardzo dobrze uzbrojony strażnik wręcza ci nagrodę. Choć uratowałeś członka ich rodu, wygląda na to, że %noblehouse% nie ma ochoty rozmawiać z tobą bezpośrednio. Tak bywa.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Przynajmniej mamy sowitą zapłatę.",
					function getResult()
					{
						this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).addPlayerRelation(this.Const.World.Assets.RelationFavor, "Uwolniłeś uwięzionego członka rodu");
						this.World.Assets.addMoney(3000);
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
					text = "Otrzymujesz w nagrodę [color=" + this.Const.UI.Color.PositiveValue + "]3000[/color] koron"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/relations.png",
					text = "Twoje relacje z: " + this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).getName() + " się polepszyły"
				});
			}

		});
		this.m.Screens.push({
			ID = "Prisoner4",
			Title = "W %noblesettlement%",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Gdy zbliżasz się do %noblesettlement%, %noble% znika za krzakami.%SPEECH_ON%Wybaczcie, szanowni, muszę się wysrać.%SPEECH_OFF%Kiwasz głową i czekasz. I czekasz. I czekasz. Uświadamiając sobie swój błąd, podbiegasz za krzak i widzisz, że człowiek zniknął, a na twoich butach jest gówno. | %noble% prosi, byś się zatrzymał. Zbiega do koryta strumienia.%SPEECH_ON%Chwila, panowie. Pozwólcie mi się ogarnąć, żeby rodzina nie musiała oglądać mnie w takim stanie!%SPEECH_OFF%Ma sens. Zostawiasz go, ale gdy wracasz, już go nie ma. Błotniste ślady prowadzą pod górę, podążasz za nimi. Po drugiej stronie widzisz pole rolników i gęsty łan, przez który każdy kłamca mógłby się łatwo wymknąć. %randombrother% staje obok ciebie.%SPEECH_ON%Cholera.%SPEECH_OFF%Cholera istotnie. | Kilku chłopów stoi przy drodze do %noblesettlement%. Strzygą się nawzajem, co przyciąga uwagę %noble%a.%SPEECH_ON%Wybaczcie, panowie, muszę się oczyścić. Nie chcę, by stara widziała mnie w takim stanie, rozumiecie.%SPEECH_OFF%Kiwasz głową i liczysz zapasy, by zabić czas. Gdy wracasz do chłopów, pytasz, gdzie zniknął szlachcic. Jeden patrzy na ciebie.%SPEECH_ON%Nie widziałem żadnego szlachcica.%SPEECH_OFF%Wyjaśniasz, że był ubrany w łachmany, po czym szybko go opisujesz. Wzruszają ramionami.%SPEECH_ON%Widziałem, jak ten łajdak pobiegł na pola tam, potem wsiadł na konia i pojechał dalej i dalej. Myśleliśmy, że ma coś z głową, bo cały czas się śmiał.%SPEECH_OFF%Ogarnia cię złość. | Prowadzisz %noble%a do %noblesettlement%. Gdy wchodzisz do miasta, niemal się trzęsie.%SPEECH_ON%Ach, po prostu się denerwuję.%SPEECH_OFF%Żaden ze strażników go nie rozpoznaje, ale łatwo to zrozumieć, biorąc pod uwagę jego strój. Podchodzisz do bardzo dobrze opancerzonego mężczyzny i prosisz, by sprowadził kogoś z rodziny szlacheckiej. Pochyla się w twoją stronę, ledwo opuszczając swoją postawę strażnika.%SPEECH_ON%A dla kogo mam zwrócić ich uwagę?%SPEECH_OFF%Odwracasz się i wskazujesz.%SPEECH_ON%No cóż, to... ten... eee...%SPEECH_OFF%%noble%a nigdzie nie widać. Rozglądasz się. %randombrother% zajmuje się jakąś dziewką, a reszta kompanii kręci się bez celu. Tłum mieszkańców przemieszcza się tam i z powrotem, szara masa, w której kłamca mógł tak łatwo zniknąć. Zaciskasz pięści. Strażnik odpycha cię.%SPEECH_ON%Jeśli nie masz tu interesów, proszę opuścić teren, inaczej usuniemy cię siłą.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "A niech to!",
					function getResult()
					{
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Vampires1",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Gdy karawana zatrzymuje się na odpoczynek, słyszysz dziwny dźwięk, jakby ktoś gryzł jabłko i zasysał sok. Obchodząc wóz, widzisz bladą postać pochyloną nad martwym strażnikiem karawany, a kły tej istoty tkwią głęboko w jego szyi. Widzisz, jak skóra unosi się przy ugryzieniu, a zakrwawiona istota uśmiecha się, pijąc.\n\n Dobywasz miecza i krzyczysz do najemników.%SPEECH_ON%Plugastwa! Do broni, ludzie!%SPEECH_OFF% | Wieko skrzyni drga. Patrzysz na nie, wymieniając spojrzenie ze strażnikiem karawany.%SPEECH_ON%Wozicie psy?%SPEECH_OFF%Nagle wieko eksploduje, odłamki rozpryskują się pod naporem wielkiej, gniewnej siły. Jęcząc, z pudełka unosi się istota, z ramionami skrzyżowanymi na piersi. Twarz blada, skóra napięta i wyraźnie zimna. To...\n\n Strażnik karawany ucieka, krzycząc.%SPEECH_ON%Ładunek się uwolnił! Ładunek się uwolnił!%SPEECH_OFF%Ładunek? Kto odważyłby się nazwać takie okropności \"ładunkiem\"? | Widzisz, jak jeden ze strażników karawany wyciąga kota ze skrzyni. Zwierzę miauczy, zwisa na łapach, kopiąc w powietrzu, po czym wściekle próbuje podrapać to, co je trzyma. Zainteresowany, pytasz, co robi. Wzrusza ramionami, podnosi wieko skrzyni i wrzuca kota do środka.%SPEECH_ON%Karmienie.%SPEECH_OFF%Kot wrzeszczy, jego kocie skargi są tak ostre jak walka, ale wkrótce zapada cisza. W chwili, gdy strażnik odwraca się od skrzyni, wieko z trzaskiem otwiera się, a blada istota unosi się, niemal bezcieleśnie, i obejmuje go ramionami. Wbija kły w jego szyję. Szyja strażnika świeci purpurą, po czym szybko blednie, a żyły na czole wychodzą, jakby próbowały pomóc krwi uciec przed pożarciem.\n\n Cofasz się, dobywasz miecza i alarmujesz ludzi o tej nowej grozie. | Podczas odpoczynku młody strażnik karawany prawie się do ciebie podkrada.%SPEECH_ON%Hej, najemniku, chcesz coś zobaczyć?%SPEECH_OFF%Masz czas, a czas cię nudzi, więc tak, oczywiście. Prowadzi cię do jednego z wozów i unosi wieko skrzyni. W środku leży blada postać z ramionami skrzyżowanymi na piersi, twarz bezbarwna i napięta w jakimś sennym spokoju. Odruchowo odskakujesz, bo to nie jest zwykły trup. Strażnik się śmieje.%SPEECH_ON%Co, boisz się trochę zmarłych?%SPEECH_OFF%I wtedy ramię istoty wystrzeliwuje, chwyta chłopaka i wciąga go do skrzyni. Nie zawracasz sobie głowy ratowaniem idioty, tylko biegniesz zebrać braci do walki, a w tym czasie wokół ciebie otwierają się kolejne skrzynie. | Odpoczywając przy drodze, słyszysz przeraźliwy krzyk gdzieś wzdłuż linii wozów. Dobywasz miecza i pędzisz w stronę hałasu. Strażnik karawany kuleje obok, trzymając się za szyję. Oczy ma szeroko otwarte, usta zastygłe w niemym krzyku.%SPEECH_ON%Uciekli! Uciekli!%SPEECH_OFF%Obok ciebie przebiega inny strażnik, nawet nie zatrzymując się, by pomóc tamtemu. Spoglądasz przed siebie i widzisz grupę bladych postaci skaczących z jednego strażnika na drugiego, otulających ofiary czarnymi płaszczami, by zamienić je w makabryczną śmierć. Zanim dotrą do ciebie, zawracasz i ostrzegasz kompanię o tym strasznym zagrożeniu. | Gdy kolumna wozów robi przerwę, obchodzisz wozy, upewniając się, że wszystko jest w porządku. Ostatni wóz jednak przechylił się w błoto, a zwierzę pociągowe leży martwe w błocie. W pobliżu są dwaj martwi strażnicy. Są całkowicie biali, a jednocześnie wyglądają jak świeże zwłoki. Podnosisz wzrok i widzisz krwawe bestie przyczajone na wozie, z ludźmi zwisającymi z ich pysków!\n\n%randombrother% podchodzi od tyłu, z bronią w dłoni, i odpycha cię.%SPEECH_ON%Alarmujmy ludzi, panie!%SPEECH_OFF%To najlepszy pomysł w tej chwili. Krzyczysz na całe gardło, wzywając resztę ludzi do walki. | Gdy idziesz się odlać, przeraźliwy krzyk zatrzymuje cię w pół kroku. Ubierasz się i pędzisz do źródła zamieszania. Widzisz strażnika karawany, który upada do przodu, jego nogi plączą się, zanim runie twarzą w ziemię. Za nim blada istota wyciera krew z ust. A na wozach otwierają się skrzynie, z których wyłaniają się bladoniebieskie kształty z żądzą krwi w oczach.\n\n Widziałeś dość i biegniesz ostrzec ludzi.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Bronić karawany!",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos(), true);
						p.CombatID = "Vampires";
						p.Music = this.Const.Music.UndeadTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Vampires, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
						this.World.Contracts.startScriptedCombat(p, false, false, false);
						return 0;
					}

				},
				{
					Text = "Ratuj się kto może! Uciekać! Uciekać!",
					function getResult()
					{
						this.Contract.m.Caravan.die();
						this.Contract.m.Caravan = null;
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Nie zdołałeś ochronić karawany");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "W %objective%",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Docierając do %objective%, przywódca karawany odwraca się do ciebie z dużą sakiewką w dłoni.%SPEECH_ON%Dzięki, że nas tu doprowadziłeś, najemniku.%SPEECH_OFF%Bierzesz ją i przekazujesz %randombrother%owi do przeliczenia. Kiwając głową, kończy liczenie. Przywódca karawany uśmiecha się.%SPEECH_ON%Dzięki też za to, że nas nie zdradziłeś i, no wiesz, nie wyrżnąłeś nas wszystkich.%SPEECH_OFF%Najemnicy bywają dziękowani w najdziwniejszy sposób. | Po dotarciu do %objective% wozy karawany są natychmiast rozładowywane, a towary trafiają do pobliskiego magazynu. Gdy wszystko zostaje przeniesione, przywódca grupy wręcza ci sakiewkę koron i dziękuje za bezpieczne przeprowadzenie. | %objective% wita cię gromadą parobków szukających pracy. Przywódca karawany rozdaje korony tu i tam, brudne dłonie chwytają za wozy, by rozładować ładunek. Gdy kończy z tłumem, zwraca się do ciebie. Trzyma w ręku sakiewkę.%SPEECH_ON%A to dla ciebie, najemniku.%SPEECH_OFF%Zabierasz ją. Kilku parobków obserwuje wymianę pieniędzy jak koty zwisającą mysz. | Dotarłeś, dostarczając karawanę tak, jak obiecałeś %employer%owi. Przywódca karawany dziękuje ci wypłatą koron. Widać, że jest wdzięczny, że żyje, i krótko opowiada o tym, jak ledwo uszedł z zasadzki bandytów. Kiwasz głową, jakby obchodziło cię choć trochę, co go spotkało. | Kolumna wozów wjeżdża do %objective%, każdy wóz toczy i podskakuje na wysokich kołach po grudach zaschniętego błota. Ludzie z karawany rozładowują towar, odganiając kilku żebraków. Przywódca wręcza ci sakiewkę i na tym kończy. Jest zbyt zajęty, by powiedzieć ci coś więcej. Cisza jest mile widziana. | Docierając do %objective%, przywódca karawany zagaduje cię, jakbyście mieli coś wspólnego. Opowiada o młodości, kiedy był żwawym chłopakiem, który mógłby zrobić to czy tamto. Podobno ominęło go wiele walk. Jaka szkoda. Znudzony jego gadaniem, prosisz go o zapłatę, by móc się wynieść z tego parszywego miejsca.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "W pełni zasłużona zapłata.",
					function getResult()
					{
						local money = this.Contract.m.Payment.getOnCompletion() + this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected");
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(money);

						if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState)
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Zgodnie z obietnicą ochroniłeś karawanę");
						}
						else if (this.Flags.get("IsStolenGoods"))
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess * 2.0, "Ochroniłeś karawanę ze skradzionym towarem");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Zgodnie z obietnicą ochroniłeś karawanę");
						}

						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local money = this.Contract.m.Payment.getOnCompletion() + this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected");
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] koron"
				});
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/well_supplied_situation"), 3, this.Contract.m.Destination, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "W %objective%",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Zastanawiasz się, czy miejsce takie jak %objective% jest warte utraty życia. Dotarliście, ale nie każdy wóz przetrwał. Przywódca kolumny podchodzi z nieco lżejszą, niż się spodziewałeś, sakiewką w dłoni.%SPEECH_ON%Zapłaciłbym ci więcej, najemniku, bo wiem, że w tym świecie perfekcja nie jest łatwa, ale %employer% nalegał, bym odliczył... no cóż, nasze straty. Rozumiesz, prawda?%SPEECH_OFF%Wygląda na przestraszonego, że możesz się na nim zemścić, ale po prostu bierzesz pieniądze i odchodzisz. Interes to interes. | Docierając do %objective%, przywódca karawany odwraca się do ciebie z sakiewką w dłoni.%SPEECH_ON%Jest lżejsza, niż się spodziewałeś.%SPEECH_OFF%Jest. Kontynuuje.%SPEECH_ON%Nie każdy wóz dotarł.%SPEECH_OFF%Nie.%SPEECH_ON%Jestem tylko posłańcem %employer%a. Proszę, nie zabijaj mnie.%SPEECH_OFF%Nie zabijesz. Chociaż... nie. | Po dotarciu do %objective% przywódca kolumny nakazuje ludziom rozładowywać towary. Brakuje kilku ludzi i kilku wozów. Podchodząc do ciebie z zapłatą, wyjaśnia sytuację.%SPEECH_ON%%employer% kazał mi zapłacić według tego, co dotarło. Niestety, straciliśmy część...%SPEECH_OFF%Kiwasz głową i bierzesz nagrodę. Umowa to umowa. | Przywódca kolumny wygląda, jakby miał się rozpłakać, gdy docieracie do %objective%. Mówi, że stracił tam kilku dobrych ludzi, a utracone wozy będą ich kosztować w przyszłości. Ciebie to nie obchodzi, ale okazujesz mu wsparcie pojedynczym skinieniem.%SPEECH_ON%Chyba powinienem i tak podziękować, najemniku. W końcu nie wszyscy zginęli. Niestety... mogę zapłacić tylko tyle. %employer% zażądał, by straty obciążyły twoją kieszeń.%SPEECH_OFF%Kiwając głową, bierzesz zapłatę, na którą zasłużyłeś.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "To nie poszło zbyt dobrze...",
					function getResult()
					{
						local money = this.Contract.m.Payment.getOnCompletion() + this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected");
						money = this.Math.floor(money / 2);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(money);

						if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState)
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractPoor, "Ochroniłeś karawanę, choć niezbyt dobrze");
						}
						else if (this.Flags.get("IsStolenGoods"))
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor * 2.0, "Ochroniłeś karawanę ze skradzionym towarem, choć niezbyt dobrze");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor, "Ochroniłeś karawanę, choć niezbyt dobrze");
						}

						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local money = this.Contract.m.Payment.getOnCompletion() + this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected");
				money = this.Math.floor(money / 2);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "Po bitwie",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Wyruszyłeś w drogę w towarzystwie ludzi karawany i kilku kupców, którzy ci ufali. Teraz ich ciała leżą rozrzucone po ziemi, z wyciągniętymi ramionami, a po ich palcach tańczą muchy. Słońce zamieni twoją porażkę w cuchnącą zgniliznę. Czas ruszać dalej. | Wozy leżą przewrócone. Mężczyźni i kończyny są porozrzucane. Z ruin unosi się jęk, ale zaraz cichnie, bo to jęk umierającego. Nad trawą migoczą ciemne cienie, nad tobą krąży rosnące stado sępów. Lepiej pozwolić im ucztować, bo nic tu już nie zrobisz. | Kupiec, który cię wynajął, leży martwy u twoich stóp. Nie leży twarzą do ziemi, bo tej części już nie ma. Krew tryska po ziemi, a ty nie możesz przestać wpatrywać się w obraz swojej porażki. Jeden z twoich ludzi dostrzega drgnięcie, ale ty wiesz lepiej. Niczego nie da się zrobić. Reszta karawany jest w jeszcze gorszym stanie. Nie ma sensu tu zostawać. | Bitwa cichnie, ale widzisz kupca opartego o przewrócony wóz. Z szeroko otwartymi oczami rozpaczliwie trzyma się za rozciętą szyję. Strumienie krwi tryskają między jego palcami i zanim da się coś zrobić, mężczyzna osuwa się na ziemię. Próbujesz go ratować, ale jest już za późno. Szkliste oczy patrzą na ciebie. %randombrother%, jeden z twoich ludzi, zamyka mu powieki, po czym wstaje, by przeszukać resztki karawany. | Potykasz się wśród resztek wozów. Nietrudno dostrzec: głowa kupca została zmiażdżona jakąś skrzynią, być może tą samą, za którą szukał schronienia w ferworze walki. Niestety, nikt z karawany nie jest w lepszym stanie. Bitwa była brutalna, nawet jak na twoje standardy, a powstała rzeź sprawia, że kilku twoich braci ma odruchy wymiotne. Jeśli przyjdą koszmary, niech przyjdą. Nie zasługujesz na nic więcej po tej porażce.}",
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

						if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState)
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Nie zdołałeś ochronić karawany");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Nie zdołałeś ochronić karawany");
						}

						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function addKillCount( _actor, _killer )
	{
		if (_killer != null && _killer.getFaction() != this.Const.Faction.Player && _killer.getFaction() != this.Const.Faction.PlayerAnimals)
		{
			return;
		}

		if (this.m.Flags.get("HeadsCollected") >= this.m.Payment.MaxCount)
		{
			return;
		}

		if (_actor.getXPValue() == 0)
		{
			return;
		}

		if (_actor.getType() == this.Const.EntityType.GoblinWolfrider || _actor.getType() == this.Const.EntityType.Wardog || _actor.getType() == this.Const.EntityType.Warhound || _actor.getType() == this.Const.EntityType.SpiderEggs || this.isKindOf(_actor, "lindwurm_tail"))
		{
			return;
		}

		if (!_actor.isAlliedWithPlayer() && !_actor.isResurrected())
		{
			this.m.Flags.set("HeadsCollected", this.m.Flags.get("HeadsCollected") + 1);
		}
	}

	function spawnCaravan()
	{
		local faction = this.World.FactionManager.getFaction(this.getFaction());
		local party;

		if (faction.hasTrait(this.Const.FactionTrait.OrientalCityState))
		{
			party = faction.spawnEntity(this.m.Home.getTile(), "Karawana Kupiecka", false, this.Const.World.Spawn.CaravanSouthernEscort, this.m.Home.getResources() * this.Math.rand(10, 25) * 0.01, this.getMinibossModifier());
		}
		else
		{
			party = faction.spawnEntity(this.m.Home.getTile(), "Karawana Kupiecka", false, this.Const.World.Spawn.CaravanEscort, this.m.Home.getResources() * 0.4, this.getMinibossModifier());
		}

		party.getSprite("banner").Visible = false;
		party.getSprite("base").Visible = false;
		party.setMirrored(true);
		party.setDescription("Karawana kupiecka z " + this.m.Home.getName() + ", która transportuje wszelkiego rodzaju towary między osadami.");
		party.setMovementSpeed(this.Const.World.MovementSettings.Speed * 0.6);
		party.setLeaveFootprints(false);

		if (this.m.Home.getProduce().len() != 0)
		{
			for( local j = 0; j != 3; j = j )
			{
				party.addToInventory(this.m.Home.getProduce()[this.Math.rand(0, this.m.Home.getProduce().len() - 1)]);
				j = ++j;
			}
		}

		party.getLoot().Money = this.Math.rand(0, 100);
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(this.m.Destination.getTile());
		move.setRoadsOnly(true);
		local unload = this.new("scripts/ai/world/orders/unload_order");
		local despawn = this.new("scripts/ai/world/orders/despawn_order");
		local wait = this.new("scripts/ai/world/orders/wait_order");
		wait.setTime(4.0);
		c.addOrder(move);
		c.addOrder(unload);
		c.addOrder(wait);
		c.addOrder(despawn);
		this.m.Caravan = this.WeakTableRef(party);
	}

	function spawnEnemies()
	{
		local tries = 0;
		local myTile = this.m.Destination.getTile();
		local tile;

		while (tries++ == 0)
		{
			local tile = this.getTileToSpawnLocation(myTile, 7, 11);

			if (tile.getDistanceTo(this.World.State.getPlayer().getTile()) <= 6)
			{
				continue;
			}

			local nearest_bandits = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getNearestSettlement(tile);
			local nearest_goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(tile);
			local nearest_orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(tile);
			local nearest_barbarians = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians) != null ? this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getNearestSettlement(tile) : null;
			local nearest_nomads = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits) != null ? this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getNearestSettlement(tile) : null;

			if (nearest_bandits == null && nearest_goblins == null && nearest_orcs == null && nearest_barbarians == null && nearest_nomads == null)
			{
				this.logInfo("no enemy base found");
				return false;
			}

			local bandits_dist = nearest_bandits != null ? nearest_bandits.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local goblins_dist = nearest_goblins != null ? nearest_bandits.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local orcs_dist = nearest_orcs != null ? nearest_bandits.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local barbarians_dist = nearest_barbarians != null ? nearest_barbarians.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local nomads_dist = nearest_nomads != null ? nearest_nomads.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local party;
			local origin;

			if (bandits_dist <= goblins_dist && bandits_dist <= orcs_dist && bandits_dist <= barbarians_dist && bandits_dist <= nomads_dist)
			{
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).spawnEntity(tile, "Bandyci", false, this.Const.World.Spawn.BanditRaiders, this.Math.rand(80, 100) * this.getDifficultyMult() * this.getScaledDifficultyMult());
				party.setDescription("Grupa zatwardziałych bandytów, żerująca na słabszych.");
				party.setFootprintType(this.Const.World.FootprintsType.Brigands);
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

				origin = nearest_bandits;
			}
			else if (goblins_dist <= bandits_dist && goblins_dist <= orcs_dist && goblins_dist <= barbarians_dist && goblins_dist <= nomads_dist)
			{
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).spawnEntity(tile, "Gobliny NajeЄdЄcy", false, this.Const.World.Spawn.GoblinRaiders, this.Math.rand(80, 100) * this.getDifficultyMult() * this.getScaledDifficultyMult());
				party.setDescription("Banda złośliwych goblinów, małych, acz przebiegłych i których nigdy nie można lekceważyć.");
				party.setFootprintType(this.Const.World.FootprintsType.Goblins);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 2);
				party.getLoot().Ammo = this.Math.rand(0, 30);
				local r = this.Math.rand(1, 4);

				if (r == 1)
				{
					party.addToInventory("supplies/strange_meat_item");
				}
				else if (r == 2)
				{
					party.addToInventory("supplies/roots_and_berries_item");
				}
				else if (r == 3)
				{
					party.addToInventory("supplies/pickled_mushrooms_item");
				}

				origin = nearest_goblins;
			}
			else if (barbarians_dist <= goblins_dist && barbarians_dist <= bandits_dist && barbarians_dist <= orcs_dist && barbarians_dist <= nomads_dist)
			{
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).spawnEntity(tile, "Barbarzyńcy", false, this.Const.World.Spawn.Barbarians, this.Math.rand(80, 100) * this.getDifficultyMult() * this.getScaledDifficultyMult());
				party.setDescription("Oddział wojenny barbarzyńskich współplemieńców.");
				party.setFootprintType(this.Const.World.FootprintsType.Barbarians);
				party.getLoot().Money = this.Math.rand(0, 50);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 5);
				party.getLoot().Ammo = this.Math.rand(0, 30);

				if (this.Math.rand(1, 100) <= 50)
				{
					party.addToInventory("loot/bone_figurines_item");
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					party.addToInventory("loot/bead_necklace_item");
				}

				local r = this.Math.rand(2, 5);

				if (r == 2)
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

				origin = nearest_barbarians;
			}
			else if (nomads_dist <= barbarians_dist && nomads_dist <= goblins_dist && nomads_dist <= bandits_dist && nomads_dist <= orcs_dist)
			{
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).spawnEntity(tile, "Koczownicy", false, this.Const.World.Spawn.NomadRaiders, this.Math.rand(80, 100) * this.getDifficultyMult() * this.getScaledDifficultyMult());
				party.setDescription("Banda pustynnych rabusiów polujących na każdego, kto próbuje przekroczyć morze piasku.");
				party.setFootprintType(this.Const.World.FootprintsType.Nomads);
				party.getLoot().Money = this.Math.rand(50, 200);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 2);
				party.getLoot().Ammo = this.Math.rand(0, 20);
				local r = this.Math.rand(1, 4);

				if (r == 1)
				{
					party.addToInventory("supplies/bread_item");
				}
				else if (r == 2)
				{
					party.addToInventory("supplies/dates_item");
				}
				else if (r == 3)
				{
					party.addToInventory("supplies/rice_item");
				}
				else if (r == 4)
				{
					party.addToInventory("supplies/dried_lamb_item");
				}

				origin = nearest_nomads;
			}
			else
			{
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).spawnEntity(tile, "Orkowie Maruderzy", false, this.Const.World.Spawn.OrcRaiders, this.Math.rand(80, 100) * this.getDifficultyMult() * this.getScaledDifficultyMult());
				party.setDescription("Banda złowrogich orków, zielonoskórych i górujących nad każdym człowiekiem.");
				party.setFootprintType(this.Const.World.FootprintsType.Orcs);
				party.getLoot().ArmorParts = this.Math.rand(0, 25);
				party.getLoot().Ammo = this.Math.rand(0, 10);
				party.addToInventory("supplies/strange_meat_item");
				origin = nearest_orcs;
			}

			party.getSprite("banner").setBrush(origin.getBanner());
			party.setAttackableByAI(false);
			party.setAlwaysAttackPlayer(true);
			local c = party.getController();
			local intercept = this.new("scripts/ai/world/orders/intercept_order");
			intercept.setTarget(this.World.State.getPlayer());
			c.addOrder(intercept);
			this.m.UnitsSpawned.push(party.getID());
			return true;
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		local days = this.getDaysRequiredToTravel(this.m.Flags.get("Distance"), this.Const.World.MovementSettings.Speed * 0.6, true);
		_vars.push([
			"objective",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.m.Destination.getName()
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Destination.getTile())]
		]);
		_vars.push([
			"noblehouse",
			this.World.FactionManager.getFaction(this.m.NobleHouseID).getName()
		]);
		_vars.push([
			"noble",
			this.m.Flags.get("NobleName")
		]);
		_vars.push([
			"noblesettlement",
			this.m.NobleSettlement == null || this.m.NobleSettlement.isNull() ? "" : this.m.NobleSettlement.getName()
		]);
		_vars.push([
			"nobledirection",
			this.m.NobleSettlement == null || this.m.NobleSettlement.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.NobleSettlement.getTile())]
		]);
		_vars.push([
			"killcount",
			this.m.Flags.get("HeadsCollected")
		]);
		_vars.push([
			"days",
			days <= 1 ? "dzień" : days + " dni"
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

			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
			}

			if (this.m.NobleSettlement != null && !this.m.NobleSettlement.isNull())
			{
				this.m.NobleSettlement.getSprite("selection").Visible = false;
			}
		}
	}

	function onIsValid()
	{
		if (this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive() || !this.m.Destination.isAlliedWith(this.getFaction()))
		{
			return false;
		}

		return true;
	}

	function onIsTileUsed( _tile )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull() && _tile.ID == this.m.Destination.getTile().ID)
		{
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

		if (this.m.Caravan != null && !this.m.Caravan.isNull())
		{
			_out.writeU32(this.m.Caravan.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		_out.writeU32(this.m.NobleHouseID);
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		local caravan = _in.readU32();

		if (caravan != 0)
		{
			this.m.Caravan = this.WeakTableRef(this.World.getEntityByID(caravan));
		}

		this.m.NobleHouseID = _in.readU32();

		if (!this.m.Flags.has("Distance"))
		{
			this.m.Flags.set("Distance", 0);
		}

		if (!this.m.Flags.has("HeadsCollected"))
		{
			this.m.Flags.set("HeadsCollected", 0);
		}

		this.contract.onDeserialize(_in);

		if (this.m.Flags.has("NobleSettlement"))
		{
			local e = this.World.getEntityByID(this.m.Flags.get("NobleSettlement"));

			if (e != null)
			{
				this.m.NobleSettlement = this.WeakTableRef(e);
			}
		}
	}

});

