this.defend_holy_site_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Target = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.defend_holy_site";
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
		this.m.Payment.Pool = 1250 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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

		local cityStates = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);
		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		this.m.Flags.set("DestinationIndex", targetIndex);
		this.m.Flags.set("EnemyID", cityStates[this.Math.rand(0, cityStates.len() - 1)].getID());
		this.m.Flags.set("MapSeed", this.Time.getRealTime());
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Udaj się do %holysiteG% i obroń miejsce przed poganami z południa"
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

				if (r <= 25)
				{
					this.Flags.set("IsQuartermaster", true);
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

				local cityStates = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);

				foreach( c in cityStates )
				{
					c.addPlayerRelation(-99.0, "Opowiedziałeś się po jednej ze stron w wojnie");
				}

				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);

				if (this.Contract.getDifficultyMult() >= 0.95)
				{
					local cityState = cityStates[this.Math.rand(0, cityStates.len() - 1)];
					local party = cityState.spawnEntity(this.Contract.m.Destination.getTile(), "PuՄk z " + cityState.getNameOnly(), true, this.Const.World.Spawn.Southern, this.Math.rand(100, 150) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + cityState.getBannerString());
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
				if (this.Flags.get("IsQuartermaster") && this.Contract.isPlayerAt(this.Contract.m.Home) && this.World.Assets.getStash().getNumberOfEmptySlots() >= 3)
				{
					this.Contract.setScreen("Quartermaster");
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
					"Obroń %holysiteD% przed poganami z południa",
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
					p.Music = this.Const.Music.OrientalCityStateTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.Entities = [];
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
					p.EnemyBanners = [
						this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
					];

					if (this.Flags.get("IsLocalsRecruited"))
					{
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.PeasantsArmed, 10, this.Contract.getFaction());
						p.AllyBanners.push("banner_noble_11");
					}

					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
				else if (this.Flags.get("IsSallyForth"))
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "DefendHolySite";
					p.Music = this.Const.Music.OrientalCityStateTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.Entities = [];
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, (this.Flags.get("IsEnemyReinforcements") ? 130 : 100) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
					p.EnemyBanners = [
						this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
					];

					if (this.Flags.get("IsLocalsRecruited"))
					{
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.PeasantsArmed, 50, this.Contract.getFaction());
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
						p.MapSeed = this.Flags.getAsInt("MapSeed");
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Flags.get("IsPalisadeBuilt") ? this.Const.Tactical.FortificationType.WallsAndPalisade : this.Const.Tactical.FortificationType.Walls;
						p.LocationTemplate.CutDownTrees = true;
						p.LocationTemplate.ShiftX = -2;
						p.Music = this.Const.Music.OrientalCityStateTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];

						if (this.Flags.get("IsAlliedReinforcements"))
						{
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
							p.AllyBanners.push(this.World.FactionManager.getFaction(this.Contract.getFaction()).getPartyBanner());
						}

						if (this.Flags.get("IsLocalsRecruited"))
						{
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.PeasantsArmed, 50, this.Contract.getFaction());
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%SPEECH_START%Pustynne gnojki.%SPEECH_OFF%To pierwsze, co słyszysz po wejściu do komnaty %employer%a. Z niechęcią macha, byś wszedł.%SPEECH_ON%Wojna z Południem trwa, ale postanowili złamać niepisane zasady: ruszają na %holysite%, a ja nie mam środków, by je ochronić. Nie będę się rozwodził nad znaczeniem tych ziem, ale jeśli to przepuszczę, lud na pewno urwie mi jaja. A że lubię swoje klejnoty, kładę na stół %reward% koron, byś tam poszedł i obronił %holysite%.%SPEECH_OFF% | Zastajesz %employer%a próbującego przekrzyczeć tłum chłopów. Wygląda na to, że dotarła wieść o zbliżających się do %holysite% żołnierzach południa.%SPEECH_ON%Mamy niepisane zasady, że te święte ziemie są... są... są święte!%SPEECH_OFF%Widząc cię, szlachcic przeciska się przez tłum, przedstawiając cię jako dzielnych wojowników, których wezwał tydzień temu. Gdy podchodzi bliżej, ścisza głos do szeptu.%SPEECH_ON%Ci idioci nie muszą wiedzieć, że jesteście najemnikami. Słuchaj, południowcy wsadzili mi kij głęboko w tyłek. Dzikusy naprawdę ruszają na %holysite% i potrzebuję, żebyś tam poszedł i ich powstrzymał. %reward% koron powinno wystarczyć za to zadanie, co?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Kompania %companyname% może ci w tym pomóc. | Oby obrona przed armiami południa była dobrze płatna. | Zaciekawiłeś mnie, mów dalej.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{To nie jest tego warte. | Jesteśmy potrzebni gdzie indziej. | Nie będę ryzykował całej kompanii przeciwko południowym machinom wojennym.}",
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
				for( local i = 0; i < 2; i = i )
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

				local amount = this.Math.rand(10, 30);
				this.World.Assets.addArmorParts(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_supplies.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] Narzędzi i Zapasów."
				});
			}

		});
		this.m.Screens.push({
			ID = "Preparation4",
			Title = "%holysite%",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Ci nieliczni wierni, którzy wciąż kręcą się wokół %holysite%, muszą być najbardziej żarliwi i fanatyczni. Ponieważ reprezentujesz północ, każesz ludziom wybrać kilku najtwardszych wyznawców starych bogów i prosisz, by walczyli za swoich bogów. To wygodne narzędzie rekrutacji, jeśli kiedykolwiek istniało, i szybko się uzbrajają, przechodząc najkrótsze z możliwych szkolenie. Możesz tylko mieć nadzieję, że będą przydatni w nadchodzącej bitwie.}",
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
			Text = "[img]gfx/ui/events/event_164.png[/img]{Południowcy pojawiają się na horyzoncie. Wyznawcy Pozłacanego - trafne określenie, bo ich zbroje lśnią nawet z daleka. %randombrother% spluwa i zerka na nich.%SPEECH_ON%Wyglądają zbyt szykownie jak na bandę trupów. Zastanawiałeś się kiedyś, czy gdybyśmy przebrali się za dżinny i wyjechali z pewnością małych diabłów, południowcy po prostu by odeszli?%SPEECH_OFF%Uśmiechając się, dobywasz miecza i rozkazujesz ludziom do walki.}",
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
			ID = "Quartermaster",
			Title = "W %townname%",
			Text = "[img]gfx/ui/events/event_158.png[/img]{Opuszczając %townname%, podchodzi do ciebie mężczyzna niosący sztandar %employerfaction% na końcu wozu. Oznajmia, że jest kwatermistrzem twojego pracodawcy i ma kilka zapasów do przekazania.%SPEECH_ON%Mam kilka psów bojowych, sieci i włócznie do rzucania. Powiedziano mi, że możesz wziąć jedno albo drugie, ale nie wszystko, bo w okolicy jest wielu walczących ludzi w potrzebie.%SPEECH_OFF%}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "Weźmiemy psy.",
					function getResult()
					{
						for( local i = 0; i < 3; i = i )
						{
							local item = this.new("scripts/items/accessory/wardog_item");
							this.World.Assets.getStash().add(item);
							i = ++i;
						}

						return 0;
					}

				},
				{
					Text = "Weźmiemy sieci.",
					function getResult()
					{
						for( local i = 0; i < 4; i = i )
						{
							local item = this.new("scripts/items/tools/throwing_net");
							this.World.Assets.getStash().add(item);
							i = ++i;
						}

						return 0;
					}

				},
				{
					Text = "Weźmiemy włócznie do rzucania.",
					function getResult()
					{
						if (this.Const.DLC.Wildmen)
						{
							for( local i = 0; i < 4; i = i )
							{
								local item = this.new("scripts/items/weapons/throwing_spear");
								this.World.Assets.getStash().add(item);
								i = ++i;
							}
						}
						else
						{
							for( local i = 0; i < 4; i = i )
							{
								local item = this.new("scripts/items/weapons/javelin");
								this.World.Assets.getStash().add(item);
								i = ++i;
							}
						}

						return 0;
					}

				},
				{
					Text = "Mamy wszystko, co nam trzeba. Zachowajcie to dla innych.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Flags.set("IsQuartermaster", false);
				this.Banner = this.World.FactionManager.getFaction(this.Contract.getFaction()).getUIBanner();
			}

		});
		this.m.Screens.push({
			ID = "SallyForth1",
			Title = "%holysite%",
			Text = "[img]gfx/ui/events/event_164.png[/img]{Południowcy się pojawiają, ale nie w pełnej sile i nie są to wyłącznie zwiadowcy. Wygląda na to, że niewiele dbali o spójność i rozciągnęli się podczas podejścia. Gdybyś teraz wypadł i zaatakował, pewnie zaskoczyłbyś ich z opuszczonymi gaciami.}",
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
			Text = "[img]gfx/ui/events/event_50.png[/img]{%SPEECH_START%Dobra decyzja.%SPEECH_OFF%Słowa %randombrother% potwierdzają twój rozkaz. Ruszając w szybkim tempie, %companyname% wychodzi, by dopaść południowców, zanim zbiorą pełne siły. Przechodzicie przez pole i nim się obejrzysz, jesteście na nich. Wciąż rozładowują sprzęt i wyposażenie, a na sam wasz widok kilku obozowych pachołków zrywa się do ucieczki. Reszta żołnierzy śpieszy się po broń.\n\nSądząc po jego piskliwym głosie, jedyny dowódca w okolicy nie jest przeszkolony do takich sytuacji - przy każdym wrzasku rozkazów głos mu się łamie, gdy próbuje uformować choćby pozory szyku. Nie tracąc czasu, ruszasz do boju!}",
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
			Text = "[img]gfx/ui/events/event_90.png[/img]{Dobijasz ostatnich żołnierzy, a na ich twarzach wciąż tkwi grymas zaskoczenia.%SPEECH_ON%Kapitanie, reszta nadciąga.%SPEECH_OFF%%randombrother% mówi, wracając po szybkim spojrzeniu na horyzont. Kiwasz głową i każesz ludziom się przygotować. Tym razem południowcy nadciągają w dobrym szyku, choć na chwilę ich formacja chwieje się na widok ciebie i trupa, którymi usłane są twoje stopy. Ich sztandar wznosi się ku niebu, a południowcy odżywają, ruszając z gniewem i energią. Po powietrzu niesie się okrzyk: \'Za Pozłacanego!\'. Wskazujesz mieczem naprzód.%SPEECH_ON%Choćby byli godni podziwu w swej wierze, żaden bóg ich tu nie znajdzie - czeka tylko %companyname%, a my mamy do ofiarowania jedną modlitwę.%SPEECH_OFF%Ludzie ryczą, gdy bitwa pędzi ku nim.}",
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
			Text = "[img]gfx/ui/events/event_164.png[/img]{%SPEECH_START%Dobra decyzja.%SPEECH_OFF%Słowa %randombrother% potwierdzają twój rozkaz. Ruszając w szybkim tempie, %companyname% wychodzi, by dopaść południowców, zanim zbiorą pełne siły. Przechodzicie przez pole i nim się obejrzysz, jesteście na nich. Wciąż rozładowują sprzęt i wyposażenie, a na sam wasz widok kilku obozowych pachołków zrywa się do ucieczki. Reszta żołnierzy śpieszy się po broń. Gdy wydaje się, że masz przewagę, z boku nadciąga kolejny oddział.%SPEECH_ON%Pozłacany uśmiecha się tylko do tych, którzy zasługują na Jego blask, Koroniarzu!%SPEECH_OFF%Krzyczy szyderczo południowy dowódca. Gdy umocnienia są za daleko, a wróg za blisko, zostaje tylko jedno wyjście. Podnosisz miecz i szykujesz ludzi do szarży.}",
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
			Text = "[img]gfx/ui/events/event_78.png[/img]{Gdy oczekujesz południowców, nadciąga oddział północnych. Ich porucznik unosi hełm.%SPEECH_ON%Kiedy kazali mi przyjść tu wspierać najemników, powiedziałem, że mogą sobie ten rozkaz wysrać. Ale wiesz, co mnie przekonało? To, że chodzi o %companyname%. Macie reputację, a ja mam ludzi do oddania na tę bitwę.%SPEECH_OFF%Sądząc po ich wyposażeniu, najlepiej użyć ich jako zasłony, by może odciągnąć część nadciągającego wroga. Albo po prostu włączyć ich do kompanii, wzmacniając szeregi tam, gdzie już jesteś najsilniejszy.}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "Ty i twoi ludzie musicie oflankować ich strzelców, poruczniku.",
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
			Text = "[img]gfx/ui/events/event_78.png[/img]{Wyciągasz lunetę i lustrujesz pole bitwy. Północny oddział szarżuje na wroga w szyku klina, po czym rozdziela się na skrzydłach, uciekając w przeciwnych kierunkach. Wygląda to na samobójczą szarżę, ale ku twojemu zaskoczeniu wykonują smakowity odwrót, któremu południowcy nie potrafią się oprzeć. Widzisz, jak wyznawcy Pozłacanego odrywają wzrok od blasku, przerzedzając własne szeregi, by ścigać pozorowany odwrót.%SPEECH_ON%Zadziałało jak w zegarku, kapitanie.%SPEECH_OFF%%randombrother% mówi.}",
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
			Text = "[img]gfx/ui/events/event_78.png[/img]{Wolisz, by żołnierze zostali z tobą. Porucznik kiwa głową.%SPEECH_ON%Tak jest, kapitanie, eee, jak się pan nazywa?%SPEECH_OFF%Ignorując go, mówisz %randombrother%owi, by rozlokował północny oddział w umocnieniach.%SPEECH_ON%Upewnij się, że dobrze je poznają, ale nie za dobrze.%SPEECH_OFF%Najemnik pochyla się i szepcze.%SPEECH_ON%A jeśli to szpiedzy, to nie chcemy zdradzić zbyt wiele szczegółów, co kapitanie?%SPEECH_OFF%Pochylasz się i szepczesz w odpowiedzi.%SPEECH_ON%Nie. Postaw ich tam, gdzie jesteśmy najsłabsi. Może wszyscy zeżrą gówno na pierwszej linii, a potem będziemy mieli ich dobytek.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_168.png[/img]{Ostatni południowy żołnierz podnosi na ciebie wzrok.%SPEECH_ON%Na blask Pozłacanego, jestem gotów.%SPEECH_OFF%Dobywasz miecza.%SPEECH_ON%A na cóż ten blask, skoro ja jestem tu, a ty tam?%SPEECH_OFF%Zanim zdąży odpowiedzieć, wbijasz mu ostrze w szyję. Każesz najemnikom ograbić pole i przygotować powrót do %employer%. | Znajdujesz ostatniego z południowych żołnierzy, opartego o skałę, z ramieniem przerzuconym przez jej wierzch, jakby była kompanem od kielicha. Spluwa krwią i kiwa głową.%SPEECH_ON%Może moja ścieżka nie była tak pozłacana, jak sądziłem.%SPEECH_OFF%Odwzajemniając skinienie, mówisz mu, że niebawem sam zapyta o to Pozłacanego.%SPEECH_ON%A ja zapytam Go o ciebie.%SPEECH_OFF%Odpowiada. Zatrzymujesz się na moment przy tym komentarzu, po czym przebijasz go mieczem. Resztę szczątków trzeba będzie ograbić. %employer% powinien być zadowolony. | Bitwa dobiegła końca, a pole zasłane jest trupami. Stoisz nad ostatnim oddychającym południowcem. Wpatruje się ponad twoim ramieniem w niebo. Gdy pytasz, czy myśli, że jego \'Pozłacany\' patrzy, mężczyzna się uśmiecha.%SPEECH_ON%Patrzy na nas obu.%SPEECH_OFF%Kiwasz głową i kończysz jego życie. Ostre gwizdnięcie przyciąga uwagę %companyname%. Twoje rozkazy są proste: zrabować to, co warte, i przygotować powrót do %employer%.}",
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
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Południowcy wznoszą swoje sztandary nad %holysite%.%SPEECH_ON%No to chyba po wszystkim.%SPEECH_OFF%Mówi %randombrother%. Jeśli przez \'po wszystkim\' rozumiesz, że nie ma powodu, by widzieć się z %employer% w sprawie końca kontraktu, to tak - to właśnie to.}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{%SPEECH_START%Zakładam, że te południowe gnojki zapiszczały, kiedy położyliście kres ich pieprzeniu się z tym wszystkim.%SPEECH_OFF%%employer% wgryza się w pół piersi z kurczaka, zanim zdążysz odpowiedzieć. I tak dalej gada, choć ma pełne usta, o ile jego zawartość nie wyleciała jeszcze i nie rozmazała się po stole.%SPEECH_ON%Wiesz, wątpiłbym w starych bogów, ale teraz, po tym wszystkim, widzę, że ich drogi są prawdziwe, a ich boskość najsprawiedliwsza.%SPEECH_OFF%Połyka resztę i z hukiem odkłada kurczaka na talerz.%SPEECH_ON%Zapłaćcie najemnikowi jego pieniądze.%SPEECH_OFF% | Zastajesz %employer%a w towarzystwie kilku mnichów, ich przeora i kobiet, które nie wyglądają na czyjekolwiek żony. Szlachcic uśmiecha się od ucha do ucha.%SPEECH_ON%Wieści o waszych czynach dotarły do nas parę dni temu. Starzy bogowie wznoszą kielichy za twoich ludzi, najemniku. Jestem pewien, że zgotowaliście tym południowcom wszystkie piekła, na które zasługują i w których bez wątpienia mieszkają. Twoja zapłata, jak obiecałem.%SPEECH_OFF%Kilka z kobiet podchodzi do ciebie, ale szybko są cofane.%SPEECH_ON%Damy, damy, proszę, zachowujcie się. Najemniku.%SPEECH_OFF%%employer% wskazuje na skrzynię z %reward% koronami. | Zastajesz %employer%a w przyoracie. Modli się samotnie przy ołtarzu, a gdy kończy, odzywa się bez odwracania.%SPEECH_ON%Wierzę, że starzy bogowie przemówili do mnie ostatniej nocy. Powiedzieli, że wracasz z dobrymi wieściami i oto jesteś. Ponieważ jesteśmy sami, powiem ci coś. Ci \'Pozłacani\', jeżdżący po tamtej pustyni, to uczciwy sort. Myślę, że niezależnie od tego, w jakich budynkach się modlą, modlą się w nich teraz. Wcale nie zachwiałeś ich wiarą i pewnego dnia znów tam będziemy.%SPEECH_OFF%Szlachcic wstaje i odwraca się.%SPEECH_ON%Porażka hartuje wiernych. Ja przyjąłem swoje razy, a teraz oni przyjęli swoje. Gdy odbierzesz złoto za tę robotę, pomódl się, by to był ostatni raz.%SPEECH_OFF%Nie zamierzasz tego robić, ale nie wypada mówić prawdy przed otwartym sercem. %reward% koron jednakże brzmi bardzo właściwie w sakiewce kompanii.}",
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
		local f = this.World.FactionManager.getFaction(this.getFaction());
		local candidates = [];

		foreach( s in f.getSettlements() )
		{
			this.logInfo("name: " + s.getName());

			if (s.isMilitary())
			{
				candidates.push(s);
			}
		}

		local party = f.spawnEntity(tiles[0].Tile, "Kompania " + candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly(), true, this.Const.World.Spawn.Noble, this.Math.rand(100, 150) * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
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
			for( local y = o.Y - 4; y <= o.Y - 3; y = y )
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
			candidates.push(s);
		}

		local party = f.spawnEntity(tiles[0].Tile, "PuՄk " + candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly(), true, this.Const.World.Spawn.Southern, (this.m.Flags.get("IsEnemyLuredAway") ? 130 : 160) * this.getScaledDifficultyMult(), this.getMinibossModifier());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
		party.setDescription("Poborowi żołnierze, lojalni swemu państwu-miastu.");
		party.setAttackableByAI(false);
		party.setAlwaysAttackPlayer(true);
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

