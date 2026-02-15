this.defend_holy_site_southern_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Target = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.defend_holy_site_southern";
		this.m.Name = "Obrona Świętego Miejsca";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		if (this.m.Home == null)
		{
			this.setHome(this.World.State.getCurrentTown());
		}

		local sites = [
			"location.holy_site.oracle",
			"location.holy_site.meteorite",
			"location.holy_site.vulcano"
		];
		local locations = this.World.EntityManager.getLocations();
		local target;
		local targetIndex = 0;
		local closestDist = 9000;
		local myTile = this.m.Home.getTile();

		foreach( v in locations )
		{
			foreach( i, s in sites )
			{
				if (v.getTypeID() == s && v.getFaction() != 0 && this.World.FactionManager.isAllied(this.getFaction(), v.getFaction()))
				{
					local d = myTile.getDistanceTo(v.getTile());

					if (d < closestDist)
					{
						target = v;
						targetIndex = i;
						closestDist = d;
					}
				}
			}
		}

		this.m.Destination = this.WeakTableRef(target);
		this.m.Destination.setVisited(true);
		this.m.Payment.Pool = 1200 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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

		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local houses = [];

		foreach( n in nobles )
		{
			if (n.getFlags().get("IsHolyWarParticipant"))
			{
				houses.push(n);
			}
		}

		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		this.m.Flags.set("DestinationIndex", targetIndex);
		this.m.Flags.set("EnemyID", houses[this.Math.rand(0, houses.len() - 1)].getID());
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Udaj się do %holysiteG% i obroń miejsce przed poganami z północy"
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 25)
				{
					this.Flags.set("IsAlchemist", true);
				}

				local r = this.Math.rand(1, 100);

				if (r <= 30)
				{
					this.Flags.set("IsSallyForth", true);
				}
				else if (r <= 60)
				{
					this.Flags.set("IsAlliedSoldiers", true);
				}

				local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
				local houses = [];

				foreach( n in nobles )
				{
					if (n.getFlags().get("IsHolyWarParticipant"))
					{
						n.addPlayerRelation(-99.0, "Opowiedziałeś się po jednej ze stron w wojnie");
						houses.push(n);
					}
				}

				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);

				if (this.Contract.getDifficultyMult() >= 0.95)
				{
					local f = houses[this.Math.rand(0, houses.len() - 1)];
					local candidates = [];

					foreach( s in f.getSettlements() )
					{
						if (s.isMilitary())
						{
							candidates.push(s);
						}
					}

					local party = f.spawnEntity(this.Contract.m.Destination.getTile(), "Kompania " + candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly(), true, this.Const.World.Spawn.Noble, this.Math.rand(100, 150) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
					party.setDescription("Profesjonalni żołdacy na usługach miejscowych lordów.");
					party.getLoot().Money = this.Math.rand(50, 200);
					party.getLoot().ArmorParts = this.Math.rand(0, 25);
					party.getLoot().Medicine = this.Math.rand(0, 3);
					party.getLoot().Ammo = this.Math.rand(0, 30);
					local r = this.Math.rand(1, 4);

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

					local c = party.getController();
					local roam = this.new("scripts/ai/world/orders/roam_order");
					roam.setAllTerrainAvailable();
					roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
					roam.setTerrain(this.Const.World.TerrainType.Shore, false);
					roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
					roam.setPivot(this.Contract.m.Destination);
					roam.setMinRange(4);
					roam.setMaxRange(8);
					roam.setTime(300.0);
				}

				local entities = this.World.getAllEntitiesAtPos(this.Contract.m.Destination.getPos(), 1.0);

				foreach( e in entities )
				{
					if (e.isParty())
					{
						e.getController().clearOrders();
					}
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
				}
			}

			function update()
			{
				if (this.Flags.get("IsAlchemist") && this.Contract.isPlayerAt(this.Contract.m.Home) && this.World.Assets.getStash().getNumberOfEmptySlots() >= 2)
				{
					this.Contract.setScreen("Alchemist1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Destination))
				{
					this.Contract.setScreen("Approaching" + this.Flags.get("DestinationIndex"));
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Running_Defend",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Obroń %holysiteD% przed bezbożnikami z północy",
					"Zniszcz lub przegoń wrogie pułki w pobliżu",
					"Nie oddalaj się zbytnio"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
				}

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Flags.get("IsFailure") || !this.Contract.isPlayerNear(this.Contract.m.Destination, 700) || !this.World.FactionManager.isAllied(this.Contract.getFaction(), this.Contract.m.Destination.getFaction()))
				{
					this.Contract.setScreen("Failure");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsSallyForthNextWave"))
				{
					this.Contract.setScreen("SallyForth3");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsVictory"))
				{
					if (!this.Contract.isEnemyPartyNear(this.Contract.m.Destination, 400.0))
					{
						this.Contract.setScreen("Victory");
						this.World.Contracts.showActiveContract();
					}
				}
				else if (!this.Flags.get("IsTargetDiscovered") && this.Contract.m.Target != null && !this.Contract.m.Target.isNull() && this.Contract.m.Target.isDiscovered())
				{
					this.Flags.set("IsTargetDiscovered", true);
					this.Contract.setScreen("TheEnemyAttacks");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsArrived") && this.Flags.get("AttackTime") > 0 && this.Time.getVirtualTimeF() >= this.Flags.get("AttackTime"))
				{
					if (this.Flags.get("IsSallyForth"))
					{
						this.Contract.setScreen("SallyForth1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsAlliedSoldiers"))
					{
						this.Contract.setScreen("AlliedSoldiers1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Flags.set("AttackTime", 0.0);
						local party = this.Contract.spawnEnemy();
						party.setOnCombatWithPlayerCallback(this.Contract.getActiveState().onDestinationAttacked.bindenv(this));
						this.Contract.m.Target = this.WeakTableRef(party);
					}
				}
			}

			function onDestinationAttacked( _dest, _isPlayerInitiated = false )
			{
				if (this.Flags.get("IsSallyForthNextWave"))
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "DefendHolySite";
					p.Music = this.Const.Music.NobleTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.Entities = [];
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
					p.EnemyBanners = [
						this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
					];

					if (this.Flags.get("IsLocalsRecruited"))
					{
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.PeasantsSouthern, 10, this.Contract.getFaction());
						p.AllyBanners.push("banner_noble_11");
					}

					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
				else if (this.Flags.get("IsSallyForth"))
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "DefendHolySite";
					p.Music = this.Const.Music.NobleTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.Entities = [];
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, (this.Flags.get("IsEnemyReinforcements") ? 130 : 100) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
					p.EnemyBanners = [
						this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
					];

					if (this.Flags.get("IsLocalsRecruited"))
					{
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.PeasantsSouthern, 50, this.Contract.getFaction());
						p.AllyBanners.push("banner_noble_11");
					}

					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
					p.LocationTemplate.OwnedByFaction = this.Const.Faction.Player;
					p.CombatID = "DefendHolySite";

					if (this.Contract.isPlayerAt(this.Contract.m.Destination))
					{
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Flags.get("IsPalisadeBuilt") ? this.Const.Tactical.FortificationType.WallsAndPalisade : this.Const.Tactical.FortificationType.Walls;
						p.LocationTemplate.CutDownTrees = true;
						p.LocationTemplate.ShiftX = -4;
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];

						if (this.Flags.get("IsAlliedReinforcements"))
						{
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
							p.AllyBanners.push(this.World.FactionManager.getFaction(this.Contract.getFaction()).getPartyBanner());
						}

						if (this.Flags.get("IsLocalsRecruited"))
						{
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.PeasantsSouthern, 50, this.Contract.getFaction());
							p.AllyBanners.push("banner_noble_11");
						}
					}

					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "DefendHolySite")
				{
					if (this.Flags.get("IsSallyForthNextWave"))
					{
						this.Flags.set("IsSallyForthNextWave", false);
						this.Flags.set("IsSallyForth", false);
						this.Flags.set("IsVictory", true);
					}
					else if (this.Flags.get("IsSallyForth"))
					{
						this.Flags.set("IsSallyForthNextWave", true);
					}
					else
					{
						this.Flags.set("IsVictory", true);
					}
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "DefendHolySite")
				{
					this.Flags.set("IsFailure", true);
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
			Text = "{[img]gfx/ui/events/event_163.png[/img]%employer%a nigdzie nie widać. Zamiast niego podchodzi mężczyzna w szatach duchownego z porucznikiem generałem u boku. Oznajmiają, że oddział północnych żołnierzy zbliża się do %holysite%, by przejąć je w całości dla Północy. Ponieważ żołnierze miasta-państwa są gdzie indziej, muszą liczyć na ciebie, byś pospieszył na miejsce i je obronił. Ich apodyktyczny sposób mówienia połączony z nutą niepokoju bez wątpienia zwiastuje wypłatę pogłębiającą sakiewkę. | [img]gfx/ui/events/event_162.png[/img]Wpychają cię do komnaty %employer%a, a Wezyr kiwa na ciebie i klaszcze.%SPEECH_ON%Wreszcie jest tu mały Koroniarz, gotów zrobić wielkie rzeczy dla nas wszystkich. Chodź, spójrz na tę mapę. Widzisz, gdzie są moi ludzie? I widzisz, gdzie jest %holysite%? A tutaj, te północne szczury... Są blisko świętych ziem, a moi ludzie daleko. Ty jednak jesteś tutaj, bardzo blisko, prawda? Za %reward% koron chcę, żebyś udał się do %holysite% i je obronił.%SPEECH_OFF%Wezyr patrzy na ciebie ciepłym uśmiechem, jakby to nie było pytanie, lecz prośba tak obciążona złotem, że równie dobrze mogła być rozkazem.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Kompania %companyname% może ci w tym pomóc. | Oby obrona przed armiami północy była dobrze płatna. | Zaciekawiłeś mnie, mów dalej.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{To nie jest tego warte. | Jesteśmy potrzebni gdzie indziej. | Nie będę ryzykował całej kompanii przeciwko armiom z północy.}",
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
			ID = "Approaching1",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Wielka kaldera opustoszała z wiernych i ciekawskich. Nawet najmniejsza zapowiedź wojny rozproszyła wyznawców, którzy wrócili do schronień swoich przyoratów. W końcu w nadchodzących godzinach będzie zwycięzca i przegrany. Pewien poziom żarliwości może skłonić tych pierwszych do nadmiernego upajania się słusznością...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Rozbijemy tu obóz.",
					function getResult()
					{
						return "Preparation1";
					}

				}
			],
			function start()
			{
				this.Flags.set("IsArrived", true);
			}

		});
		this.m.Screens.push({
			ID = "Approaching0",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Wyrocznia nie jest taka, jak ją pamiętasz: wielu wiernych odeszło, a bębny wojny stanęły u progu starożytnej świątyni. Zresztą to bez znaczenia. Nie szukasz tu wizji ani snów do rozwikłania, jedynie koszmarów dla wrogów.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Rozbijemy tu obóz.",
					function getResult()
					{
						return "Preparation1";
					}

				}
			],
			function start()
			{
				this.Flags.set("IsArrived", true);
			}

		});
		this.m.Screens.push({
			ID = "Approaching2",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Ironią losu, zrównane z ziemią miasto u podnóża nadkruszonej góry wreszcie wydaje się niepokojąco opuszczone. Nieliczni wierni pozostali, reszta odeszła długo przed tym, jak religijny konflikt dotarł do ich namiotowych osiedli i duchowych rubieży.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Rozbijemy tu obóz.",
					function getResult()
					{
						return "Preparation1";
					}

				}
			],
			function start()
			{
				this.Flags.set("IsArrived", true);
			}

		});
		this.m.Screens.push({
			ID = "Preparation1",
			Title = "%holysite%",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Uważasz, że udało ci się przygotować skromną obronę z pozycji, jakie oferuje %holysite%. Z tym, co zostało czasu, jest jeszcze przynajmniej jedno poważne zadanie, które możesz zlecić %companyname%. Pytanie tylko, co najlepiej jej pasuje.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zbudować palisady, aby umocnić mury!",
					function getResult()
					{
						return "Preparation2";
					}

				},
				{
					Text = "Przeszukać teren, może jest tu coś, co nam się przyda!",
					function getResult()
					{
						return "Preparation3";
					}

				},
				{
					Text = "Zwerbować niektórych wierzących, aby pomogli nam w obronie!",
					function getResult()
					{
						return "Preparation4";
					}

				}
			],
			function start()
			{
				this.Contract.setState("Running_Defend");
			}

		});
		this.m.Screens.push({
			ID = "Preparation2",
			Title = "%holysite%",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Plądrując samo święte miejsce, o czym nikomu nie powiesz, i przeszukując porzucone dobra wiernych, udaje ci się zebrać dość drewna, by wzmocnić fragment murów osłaniających róg %holysite%. To, twoim zdaniem, najlepsze miejsce do natarcia, więc właśnie je będziesz bronić najzacieklej.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "A teraz czekamy.",
					function getResult()
					{
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return 0;
					}

				}
			],
			function start()
			{
				this.Flags.set("IsPalisadeBuilt", true);
			}

		});
		this.m.Screens.push({
			ID = "Preparation3",
			Title = "%holysite%",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Rozkazujesz ludziom przeszukać okolicę w poszukiwaniu zapasów bitewnych. Różne przedmioty zostają zebrane i ułożone w stosy. Gdy całe %holysite% zostaje przeszukane, ty i twoi ludzie spędzacie kilka minut, wybierając to, co będzie najbardziej przydatne...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "A teraz czekamy.",
					function getResult()
					{
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return 0;
					}

				}
			],
			function start()
			{
				for( local i = 0; i < 3; i = i )
				{
					local r = this.Math.rand(1, 12);
					local item;

					switch(r)
					{
					case 1:
						item = this.new("scripts/items/weapons/oriental/saif");
						break;

					case 2:
						item = this.new("scripts/items/tools/throwing_net");
						break;

					case 3:
						item = this.new("scripts/items/weapons/oriental/polemace");
						break;

					case 4:
						item = this.new("scripts/items/weapons/ancient/broken_ancient_sword");
						break;

					case 5:
						item = this.new("scripts/items/armor/ancient/ancient_mail");
						break;

					case 6:
						item = this.new("scripts/items/supplies/ammo_item");
						break;

					case 7:
						item = this.new("scripts/items/supplies/armor_parts_item");
						break;

					case 8:
						item = this.new("scripts/items/shields/ancient/tower_shield");
						break;

					case 9:
						item = this.new("scripts/items/loot/ancient_gold_coins_item");
						break;

					case 10:
						item = this.new("scripts/items/loot/silver_bowl_item");
						break;

					case 11:
						item = this.new("scripts/items/weapons/wooden_stick");
						break;

					case 12:
						item = this.new("scripts/items/helmets/oriental/spiked_skull_cap_with_mail");
						break;
					}

					if (item.getConditionMax() > 1)
					{
						item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 50) * 0.01));
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
			ID = "Preparation4",
			Title = "%holysite%",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Ci nieliczni wierni, którzy wciąż kręcą się wokół %holysite%, muszą być najbardziej żarliwi i fanatyczni. Ponieważ reprezentujesz południe, każesz ludziom wybrać kilku wyznawców Pozłacanego i prosisz, by walczyli za swojego Boga. To wygodne narzędzie rekrutacji, jeśli kiedykolwiek istniało, i szybko się uzbrajają, przechodząc najkrótsze z możliwych szkolenie. Możesz tylko mieć nadzieję, że będą przydatni w nadchodzącej bitwie.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "A teraz czekamy.",
					function getResult()
					{
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return 0;
					}

				}
			],
			function start()
			{
				this.Flags.set("IsLocalsRecruited", true);
			}

		});
		this.m.Screens.push({
			ID = "TheEnemyAttacks",
			Title = "%holysite%",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Północna armia jest na miejscu. A przynajmniej to, co z niej zostało. Ciężkie pancerze i broń sprawiły, że długa podróż przerzedziła ich szeregi, ale nadal wyglądają na poważne wyzwanie. Spoglądasz na %randombrother%, który wzrusza ramionami.%SPEECH_ON%{Poza widokami to tylko kolejna bitwa, co nie? | Wiem, że wszyscy będą gadać o tej i tamtej religijnej bzdurze, ale szczerze mówiąc to dla mnie po prostu kolejna walka. I kocham to.}%SPEECH_OFF%Kiwając głową, dobywasz miecza i rozkazujesz ludziom się przygotować.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Formować szyk!",
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
			ID = "Alchemist1",
			Title = "W %townname%",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Przy bramach %townname% podchodzi do ciebie mężczyzna. Sądząc po jaskrawo barwnych bandolierach i filakteriach na piersi, to alchemik. Oznajmia, że przysłał go Wezyr.%SPEECH_ON%Brakuje mi nieco materiałów, ale mam dość, by przygotować ładunki bardzo określonego rodzaju, oczywiście wedle twojego wyboru.%SPEECH_OFF%Opisuje swoje rozwiązania: ogniste garnuszki, oślepiające garnuszki lub dymne garnuszki.}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "Weźmiemy ogniste garnuszki.",
					function getResult()
					{
						this.Flags.set("IsFirepot", true);
						return "Alchemist2";
					}

				},
				{
					Text = "Weźmiemy oślepiające garnuszki.",
					function getResult()
					{
						this.Flags.set("IsFlashpot", true);
						return "Alchemist2";
					}

				},
				{
					Text = "Weźmiemy dymne garnuszki.",
					function getResult()
					{
						this.Flags.set("IsSmokepot", true);
						return "Alchemist2";
					}

				},
				{
					Text = "Mamy wszystko, czego nam potrzeba.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Flags.set("IsAlchemist", false);
				this.Banner = this.World.FactionManager.getFaction(this.Contract.getFaction()).getUIBanner();
			}

		});
		this.m.Screens.push({
			ID = "Alchemist2",
			Title = "W %townname%",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Alchemik pracuje szybko, wsypując całą stertę sproszkowanych składników do misy, a potem ugniatając drobiny materiałów, których nawet nie rozpoznajesz. Trwa to zaskakująco krótko i nie wiesz, czy to dlatego, że jest tak utalentowany, czy to wszystko to farsa. Tak czy inaczej, wręcza ci garnuszki, jak obiecał.%SPEECH_ON%Niech Pozłacany oświetla twoją ścieżkę, a twoje miecze przywrócą pokój w %holysite%.%SPEECH_OFF%}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "To się przyda.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Banner = this.World.FactionManager.getFaction(this.Contract.getFaction()).getUIBanner();

				for( local i = 0; i < 2; i = i )
				{
					local item;

					if (this.Flags.get("IsFirepot"))
					{
						item = this.new("scripts/items/tools/fire_bomb_item");
					}
					else if (this.Flags.get("IsFlashpot"))
					{
						item = this.new("scripts/items/tools/daze_bomb_item");
					}
					else if (this.Flags.get("IsSmokepot"))
					{
						item = this.new("scripts/items/tools/smoke_bomb_item");
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
			ID = "SallyForth1",
			Title = "%holysite%",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Północni się pojawiają, ale nie w pełnej sile i nie są to wyłącznie zwiadowcy. Wygląda na to, że niewiele dbali o spójność i rozciągnęli się podczas podejścia. Gdybyś teraz wypadł i zaatakował, pewnie zaskoczyłbyś ich z opuszczonymi gaciami.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Musimy wykorzystać tę okazję. Przygotować ludzi do wyprowadzenia ataku!",
					function getResult()
					{
						return this.Math.rand(1, 100) <= 50 ? "SallyForth2" : "SallyForth4";
					}

				},
				{
					Text = "Mamy tu pozycję obronną. Zostać na miejscach.",
					function getResult()
					{
						return "SallyForth5";
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "SallyForth2",
			Title = "%holysite%",
			Text = "[img]gfx/ui/events/event_156.png[/img]{%SPEECH_START%Dobra decyzja.%SPEECH_OFF%Słowa %randombrother% potwierdzają twój rozkaz. Ruszając w szybkim tempie, %companyname% wychodzi, by dopaść północnych, zanim zbiorą pełne siły. Przechodzicie przez pole i nim się obejrzysz, jesteście na nich. Wciąż rozładowują sprzęt i wyposażenie, a na sam wasz widok kilku obozowych pachołków zrywa się do ucieczki. Reszta żołnierzy śpieszy się po broń. Sądząc po jego piskliwym głosie, jedyny dowódca w okolicy nie jest przeszkolony do takich sytuacji - przy każdym wrzasku rozkazów głos mu się łamie, gdy próbuje uformować choćby pozory szyku. Nie tracąc czasu, ruszasz do boju!}",
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
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "SallyForth3",
			Title = "%holysite%",
			Text = "[img]gfx/ui/events/event_90.png[/img]{Dobijasz ostatnich żołnierzy, a na ich twarzach wciąż tkwi grymas zaskoczenia.%SPEECH_ON%Kapitanie, reszta nadciąga.%SPEECH_OFF%%randombrother% mówi, wracając po szybkim spojrzeniu na horyzont. Kiwasz głową i każesz ludziom się przygotować. Tym razem północni nadciągają w dobrym szyku, choć na chwilę ich formacja chwieje się na widok ciebie i trupa, którymi usłane są twoje stopy. Ich sztandar wznosi się ku niebu, a północni odżywają, ruszając z gniewem i energią. Spoglądasz na %randombrother% i strzepujesz z jego ramienia kawałek wnętrzności. Gdy na ciebie patrzy, po prostu się uśmiechasz.%SPEECH_ON%Zabawa już tu jest, wypadałoby ładnie wyglądać.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do mnie! Do mnie! Przygotować się!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "SallyForth4",
			Title = "%holysite%",
			Text = "[img]gfx/ui/events/event_78.png[/img]{%SPEECH_START%Dobra decyzja.%SPEECH_OFF%Słowa %randombrother% potwierdzają twój rozkaz. Ruszając w szybkim tempie, %companyname% wychodzi, by dopaść północnych, zanim zbiorą pełne siły. Przechodzicie przez pole i nim się obejrzysz, jesteście na nich. Wciąż rozładowują sprzęt i wyposażenie, a na sam wasz widok kilku obozowych pachołków zrywa się do ucieczki. Reszta żołnierzy śpieszy się po broń. Gdy wydaje się, że masz przewagę, z boku nadciąga kolejny oddział.%SPEECH_ON%Do jasnej cholery, to prawie cała ich zgraja.%SPEECH_OFF%%randombrother% mówi. Umocnienia są za daleko, a wróg za blisko. Zostało tylko jedno wyjście. Podnosisz miecz i szykujesz ludzi do szarży.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wywalczymy sobie drogę z tej opresji!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
				this.Flags.set("IsEnemyReinforcements", true);
			}

		});
		this.m.Screens.push({
			ID = "SallyForth5",
			Title = "%holysite%",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Uznajesz, że najlepiej obsadzić umocnienia. To może zmarnować okazję, ale jest to po części najbezpieczniejsza z dostępnych opcji.%SPEECH_ON%Trzeba było wyjść. Coś tu przegapiliśmy, kapitanie.%SPEECH_OFF%Zerkasz i widzisz, jak %randombrother% wzrusza ramionami. Mówisz mu, by pilnował języka, bo sam coś straci.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wszyscy, przygotować się. Wkrótce uderzą z całą siłą.",
					function getResult()
					{
						this.Flags.set("IsSallyForth", false);
						this.Flags.set("AttackTime", 1.0);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "AlliedSoldiers1",
			Title = "%holysite%",
			Text = "[img]gfx/ui/events/event_164.png[/img]{Gdy oczekujesz północnych, mały oddział południowych żołnierzy omal cię nie zaskakuje. Na szczęście wciąż stoją po twojej stronie i oferują pomoc.%SPEECH_ON%Pozłacany powiedział nam, że tu będziesz i choć jesteś Koroniarzem, podporządkujemy się twoim rozkazom w obronie tego miejsca ku Jego chwale.%SPEECH_OFF%Sądząc po ich wyposażeniu, najlepiej użyć ich jako zasłony, by może odciągnąć część nadciągającego wroga. Albo po prostu włączyć ich na razie do %companyname%, wzmacniając szeregi tam, gdzie już jesteś najsilniejszy.}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "Ty i twoi ludzie musicie oflankować ich kuszników, poruczniku.",
					function getResult()
					{
						this.Flags.set("IsEnemyLuredAway", true);
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return "AlliedSoldiers2";
					}

				},
				{
					Text = "Ty i twoi ludzie musicie odciągnąć część ich piechoty, poruczniku.",
					function getResult()
					{
						this.Flags.set("IsEnemyLuredAway", true);
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return "AlliedSoldiers2";
					}

				},
				{
					Text = "Ty i twoi ludzie musicie walczyć u naszego boku, poruczniku.",
					function getResult()
					{
						this.Flags.set("IsAlliedReinforcements", true);
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return "AlliedSoldiers3";
					}

				}
			],
			function start()
			{
				this.Banner = this.World.FactionManager.getFaction(this.Contract.getFaction()).getUIBanner();
				this.Flags.set("IsAlliedSoldiers", false);
			}

		});
		this.m.Screens.push({
			ID = "AlliedSoldiers2",
			Title = "%holysite%",
			Text = "[img]gfx/ui/events/event_164.png[/img]{Wyciągasz lunetę i lustrujesz pole bitwy. Południowi żołnierze rozchodzą się jak mrówki i wdają w potyczkę z północnymi. Ku twojemu zaskoczeniu, pozorowany odwrót działa. Z uśmiechem obserwujesz, jak północny oddział rozdziela się i rusza w pościg, osłabiając przy tym swoje szeregi.}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "Świetnie.",
					function getResult()
					{
						this.Flags.set("IsAlliedSoldiers", false);
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return 0;
					}

				}
			],
			function start()
			{
				this.Banner = this.World.FactionManager.getFaction(this.Contract.getFaction()).getUIBanner();
			}

		});
		this.m.Screens.push({
			ID = "AlliedSoldiers3",
			Title = "%holysite%",
			Text = "[img]gfx/ui/events/event_164.png[/img]{Wolisz, by żołnierze zostali z tobą. Porucznik kiwa głową.%SPEECH_ON%Pozłacany zaufał nam, byśmy ci pomogli, i czy w to wierzysz, czy nie, On ufa także tobie.%SPEECH_OFF%Dobrze. Jasne. Mówisz im, gdzie mają stanąć, a oni wykonują to z irytująco religijną uległością, trajkocząc o złocie, świetle i podobnych rzeczach.}",
			Image = "",
			List = [],
			Banner = "",
			Options = [
				{
					Text = "Teraz znów czekamy.",
					function getResult()
					{
						this.Flags.set("IsAlliedSoldiers", false);
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return 0;
					}

				}
			],
			function start()
			{
				this.Banner = this.World.FactionManager.getFaction(this.Contract.getFaction()).getUIBanner();
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_87.png[/img]{Ostatni żyjący północny leży na ziemi, z raną w piersi, a krew barwi grunt. W jego oczach widać długie spojrzenie, oddycha spokojnie i jakby godził się z końcem. Dobijasz miecz, ale on wyciąga dłoń. Nie po litość, tylko o chwilę.%SPEECH_ON%Nie trzeba. Już to widzę. Przechodzi. I przechodzi. Nie wiem, czemu tak mi zależało.%SPEECH_OFF%Opada bezwładnie, dłoń napina się i zsuwa z piersi. %randombrother% szturcha zwłoki, potem je ograbia. Chowasz miecz i każesz ludziom przygotować się do powrotu do Wezyra. | Twoi ludzie dobijają ostatnich ocalałych. W większości chodzi o szybkie przebicie zwłok jednym czy dwoma pchnięciami. Niektóre ciała wciąż podrygują, ale wiesz, że już ich nie ma. Nie wiesz, czemu nadal się ruszają, jakby człowiek, którym kiedyś byli, zostawił strach za sobą. Inne nie reagują wcale. Jeden żołnierz, który próbował się ukryć, krzyczy, ale szybko zostaje uciszony. Gdy pole zasłane jest pokonanymi, każesz %companyname% łupić, co się da, i przygotować się do powrotu do Wezyra. | Ostatni północny wcisnął się między klin dwóch skał, ręce rozpostarte na boki niczym pająk cofający się do swojej kryjówki.%SPEECH_ON%Starzy bogowie nie okażą wam litości.%SPEECH_OFF%Z góry na moment pada cień, po czym skała, która go rzuciła, spada i miażdży mu głowę. Osuwa się na ziemię, ciało szarpie, usta bulgoczą. %randombrother% spogląda z wierzchołka dwóch skał.%SPEECH_ON%To już ostatni z nich. Trzeba zabrać ich sprzęt i wracać do tego, eee, gościa z pompą, wezy... wezy... wicehrabiego?%SPEECH_OFF%Wezyr. Ale prawie.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Zwycięstwo!",
					function getResult()
					{
						this.Contract.spawnAlly();
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
			ID = "Failure",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Cóż, %holysite% należy teraz do północnych. A że cenisz swoją głowę i wolisz, by została na karku, nie widzisz sensu wracać do Wezyra przynajmniej przez jakiś czas.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Katastrofa!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Nie zdołałeś obronić świętego miejsca");
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
			ID = "Success",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% przebywa w małym przyoracie, daleko od swego pałacu. To nietypowe miejsce, by go spotkać, a u jego stóp stoi jedynie niewielki tłum zubożałych wyznawców, słuchających jego mowy. Wezyr spogląda na ciebie, po czym w trakcie przemowy kiwa głową do kogoś innego. Chwilę później podchodzi brodaty mężczyzna z dwoma mieczami. Mierzy cię wzrokiem, po czym odsuwa się, odsłaniając dwóch służących niosących skrzynię.%SPEECH_ON%Wezyr pragnie ci podziękować, Koroniarzu. I niech twoja droga na zawsze będzie pozłacana.%SPEECH_OFF%Oczywiście odprowadzają cię na zewnątrz w chwili, gdy tylko pieniądze przechodzą z rąk do rąk. Wezyr nie skinął nawet głową ani nie machnął, gdy drzwi zamknęły się za tobą. | Prowadzą cię długim korytarzem do pustego pomieszczenia. Przez chwilę zastanawiasz się, czy nie mają zamiaru cię tu zdradzić. Zdrady rzadko zdarzają się w miejscach, gdzie nie chcą bałaganu. Gdy wpatrujesz się w czystą kamienną posadzkę, z przeciwnej strony wchodzi %employer%. Stoi kilka kroków dalej, a jego głos odbija się echem w sali.%SPEECH_ON%Mówi się, że walczyliście dzielnie, a północni okazali się w bitwie jazgotliwymi psami. Wyobrażam sobie, że to drugie jest nieprawdą mającą poprawić mi humor. Ale jestem myślicielem i realistą. Zakładam, że uznałeś determinację wroga za niemałą, tak jak oni uznaliby naszą. Otrzymasz uzgodnioną zapłatę, Koroniarzu.%SPEECH_OFF%Nagle za Wezyrem wchodzi grupa mężczyzn i znów zastanawiasz się, czy nie mają innych zamiarów. Ku twojej uldze niosą sakiewki z monetami. Gdy spoglądasz w stronę drzwi, %employer% już zniknął, a chwilę później znikają też jego słudzy. | %employer% wita cię w komnacie, w której jest on i kilku wybranych dostojników religijnych. Każdy z tych skromnych przeorów podchodzi i krótko się kłania. Wezyr nie czyni tego samego, ale pstryka palcami, a jego słudzy dźwigają wielką skrzynię koron. W końcu duchowni zwracają się do Wezyra i w podobnej procesji kłaniają się przed nim. Całują też jego stopy i pierścień, czego nie przewidziano dla ciebie. %employer% przemawia.%SPEECH_ON%Moja droga zawsze była pozłacana, Koroniarzu. To Pozłacany obdarzył mnie wiedzą, że ty, skromny najemnik, którego wielu by przeoczyło, powinieneś być tym, którego wynajmę, by oszczędzić %holysite%. Jestem błogosławiony. Naprawdę.%SPEECH_OFF%Zabierasz złoto i odchodzisz, a ostatnie, co widzisz, to odziani w szaty mężczyźni wracający po dokładkę.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Obroniłeś święte miejsce");
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

	function spawnAlly()
	{
		local o = this.m.Destination.getTile().SquareCoords;
		local tiles = [];

		for( local x = o.X - 4; x < o.X + 4; x = x )
		{
			for( local y = o.Y - 6; y <= o.Y - 3; y = y )
			{
				if (!this.World.isValidTileSquare(x, y))
				{
				}
				else
				{
					local tile = this.World.getTileSquare(x, y);

					if (tile.Type == this.Const.World.TerrainType.Ocean)
					{
					}
					else
					{
						local s = this.Math.rand(0, 3);

						if (tile.Type == this.Const.World.TerrainType.Mountains)
						{
							s = s - 10;
						}

						if (tile.HasRoad)
						{
							s = s + 10;
						}

						tiles.push({
							Tile = tile,
							Score = s
						});
					}
				}

				y = ++y;
			}

			x = ++x;
		}

		if (tiles.len() == 0)
		{
			tiles.push({
				Tile = this.m.Destination.getTile(),
				Score = 0
			});
		}

		tiles.sort(function ( _a, _b )
		{
			if (_a.Score > _b.Score)
			{
				return -1;
			}
			else if (_a.Score < _b.Score)
			{
				return 1;
			}

			return 0;
		});
		local f = this.World.FactionManager.getFaction(this.getFaction());
		local candidates = [];

		foreach( s in f.getSettlements() )
		{
			candidates.push(s);
		}

		local party = f.spawnEntity(tiles[0].Tile, "PuՄk z " + candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly(), true, this.Const.World.Spawn.Southern, this.Math.rand(100, 150) * this.getScaledDifficultyMult(), this.getMinibossModifier());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
		party.setDescription("Poborowi żołnierze, lojalni swemu państwu-miastu.");
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
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(this.m.Destination.getTile());
		c.addOrder(move);
		local guard = this.new("scripts/ai/world/orders/guard_order");
		guard.setTarget(this.m.Destination.getTile());
		guard.setTime(240.0);
		c.addOrder(guard);
		return party;
	}

	function spawnEnemy()
	{
		local cityState = this.World.FactionManager.getFaction(this.getFaction());
		local o = this.m.Destination.getTile().SquareCoords;
		local tiles = [];

		for( local x = o.X - 4; x < o.X + 4; x = x )
		{
			for( local y = o.Y + 4; y <= o.Y + 6; y = y )
			{
				if (!this.World.isValidTileSquare(x, y))
				{
				}
				else
				{
					local tile = this.World.getTileSquare(x, y);

					if (tile.Type == this.Const.World.TerrainType.Ocean)
					{
					}
					else
					{
						local s = this.Math.rand(0, 3);

						if (tile.Type == this.Const.World.TerrainType.Mountains)
						{
							s = s - 10;
						}

						if (tile.HasRoad)
						{
							s = s + 10;
						}

						tiles.push({
							Tile = tile,
							Score = s
						});
					}
				}

				y = ++y;
			}

			x = ++x;
		}

		if (tiles.len() == 0)
		{
			tiles.push({
				Tile = this.m.Destination.getTile(),
				Score = 0
			});
		}

		tiles.sort(function ( _a, _b )
		{
			if (_a.Score > _b.Score)
			{
				return -1;
			}
			else if (_a.Score < _b.Score)
			{
				return 1;
			}

			return 0;
		});
		local f = this.World.FactionManager.getFaction(this.m.Flags.get("EnemyID"));
		local candidates = [];

		foreach( s in f.getSettlements() )
		{
			if (s.isMilitary())
			{
				candidates.push(s);
			}
		}

		local party = f.spawnEntity(tiles[0].Tile, "Kompania " + candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly(), true, this.Const.World.Spawn.Noble, (this.m.Flags.get("IsEnemyLuredAway") ? 130 : 160) * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
		party.setDescription("Profesjonalni żołdacy na usługach miejscowych lordów.");
		party.setAttackableByAI(false);
		party.setAlwaysAttackPlayer(true);
		party.getLoot().Money = this.Math.rand(50, 200);
		party.getLoot().ArmorParts = this.Math.rand(0, 25);
		party.getLoot().Medicine = this.Math.rand(0, 3);
		party.getLoot().Ammo = this.Math.rand(0, 30);
		local r = this.Math.rand(1, 4);

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

		local c = party.getController();
		local attack = this.new("scripts/ai/world/orders/attack_zone_order");
		attack.setTargetTile(this.m.Destination.getTile());
		c.addOrder(attack);
		local occupy = this.new("scripts/ai/world/orders/occupy_order");
		occupy.setTarget(this.m.Destination);
		occupy.setTime(10.0);
		occupy.setSafetyOverride(true);
		c.addOrder(occupy);
		local guard = this.new("scripts/ai/world/orders/guard_order");
		guard.setTarget(this.m.Destination.getTile());
		guard.setTime(999.0);
		c.addOrder(guard);
		return party;
	}

	function onPrepareVariables( _vars )
	{
		local illustrations = [
			"event_152",
			"event_154",
			"event_151"
		];
		_vars.push([
			"illustration",
			illustrations[this.m.Flags.get("DestinationIndex")]
		]);
		_vars.push([
			"holysite",
			this.m.Flags.get("DestinationName")
		]);
		_vars.push([
			"employerfaction",
			this.World.FactionManager.getFaction(this.m.Faction).getName()
		]);
		_vars.push([
			"holysiteG",
			this.m.Flags.get("DestinationName") == "Wyrocznia" ? "Wyroczni" : this.m.Flags.get("DestinationName") == "Upadła Gwiazda" ? "Upadłej Gwiazdy" : "Starożytnego Miasta"
		]);
		_vars.push([
			"holysiteD",
			this.m.Flags.get("DestinationName") == "Wyrocznia" ? "Wyrocznię" : this.m.Flags.get("DestinationName") == "Upadła Gwiazda" ? "Upadłą Gwiazdę" : "Starożytne Miasto"
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

			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.setOnCombatWithPlayerCallback(null);
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

		local sites = [
			"location.holy_site.oracle",
			"location.holy_site.meteorite",
			"location.holy_site.vulcano"
		];
		local locations = this.World.EntityManager.getLocations();

		foreach( v in locations )
		{
			foreach( i, s in sites )
			{
				if (v.getTypeID() == s && v.getFaction() != 0 && this.World.FactionManager.isAllied(this.getFaction(), v.getFaction()))
				{
					return true;
				}
			}
		}

		return false;
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
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});

