this.decisive_battle_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Warcamp = null,
		WarcampTile = null,
		Dude = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		local r = this.Math.rand(1, 100);

		if (r <= 70)
		{
			this.m.DifficultyMult = this.Math.rand(95, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}

		this.m.Type = "contract.decisive_battle";
		this.m.Name = "Wielka Bitwa";
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

		if (this.m.WarcampTile == null)
		{
			local settlements = this.World.EntityManager.getSettlements();
			local lowest_distance = 99999;
			local best_settlement;
			local myTile = this.m.Home.getTile();

			foreach( s in settlements )
			{
				if (this.World.FactionManager.isAllied(this.getFaction(), s.getFaction()))
				{
					continue;
				}

				local d = s.getTile().getDistanceTo(myTile);

				if (d < lowest_distance)
				{
					lowest_distance = d;
					best_settlement = s;
				}
			}

			this.m.WarcampTile = myTile.getTileBetweenThisAnd(best_settlement.getTile());
			this.m.Flags.set("EnemyNobleHouse", best_settlement.getOwner().getID());
		}

		this.m.Flags.set("CommanderName", this.Const.Strings.KnightNames[this.Math.rand(0, this.Const.Strings.KnightNames.len() - 1)]);
		this.m.Payment.Pool = 1600 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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

		this.m.Flags.set("RequisitionCost", this.beautifyNumber(this.m.Payment.Pool * 0.25));
		this.m.Flags.set("Bribe", this.beautifyNumber(this.m.Payment.Pool * 0.35));
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Udaj się do obozu wojennego i zamelduj osobie zwanej %commander%",
					"Pomóż armii w bitwie, w której wrogiem jest %feudfamily%"
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
				this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).addPlayerRelation(-99.0, "Opowiedziałeś się po jednej ze stron w wojnie");

				if (this.Contract.m.WarcampTile == null)
				{
					local settlements = this.World.EntityManager.getSettlements();
					local lowest_distance = 99999;
					local best_settlement;
					local myTile = this.Contract.m.Home.getTile();

					foreach( s in settlements )
					{
						if (this.World.FactionManager.isAllied(this.Contract.getFaction(), s.getFaction()))
						{
							continue;
						}

						local d = s.getTile().getDistanceTo(myTile);

						if (d < lowest_distance)
						{
							lowest_distance = d;
							best_settlement = s;
						}
					}

					this.Contract.m.WarcampTile = myTile.getTileBetweenThisAnd(best_settlement.getTile());
				}

				local tile = this.Contract.getTileToSpawnLocation(this.Contract.m.WarcampTile, 1, 12, [
					this.Const.World.TerrainType.Shore,
					this.Const.World.TerrainType.Ocean,
					this.Const.World.TerrainType.Mountains,
					this.Const.World.TerrainType.Forest,
					this.Const.World.TerrainType.LeaveForest,
					this.Const.World.TerrainType.SnowyForest,
					this.Const.World.TerrainType.AutumnForest,
					this.Const.World.TerrainType.Swamp
				], false, false, true);
				tile.clear();
				this.Contract.m.WarcampTile = tile;
				this.Contract.m.Warcamp = this.WeakTableRef(this.World.spawnLocation("scripts/entity/world/locations/noble_camp_location", tile.Coords));
				this.Contract.m.Warcamp.onSpawned();
				this.Contract.m.Warcamp.getSprite("banner").setBrush(this.World.FactionManager.getFaction(this.Contract.getFaction()).getBannerSmall());
				this.Contract.m.Warcamp.setFaction(this.Contract.getFaction());
				this.Contract.m.Warcamp.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Warcamp.getTile().Pos, 500.0);
				local r = this.Math.rand(1, 100);

				if (r <= 40)
				{
					this.Flags.set("IsScoutsSighted", true);
				}
				else
				{
					this.Flags.set("IsRequisitionSupplies", true);
					r = this.Math.rand(1, 100);

					if (r <= 33)
					{
						this.Flags.set("IsAmbush", true);
					}
					else if (r <= 66)
					{
						this.Flags.set("IsUnrulyFarmers", true);
					}
					else
					{
						this.Flags.set("IsCooperativeFarmers", true);
					}
				}

				r = this.Math.rand(1, 100);

				if (r <= 40)
				{
					if (this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getSettlements().len() >= 2)
					{
						this.Flags.set("IsInterceptSupplies", true);
						local myTile = this.Contract.m.Warcamp.getTile();
						local settlements = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getSettlements();
						local lowest_distance = 99999;
						local highest_distance = 0;
						local best_start;
						local best_dest;

						foreach( s in settlements )
						{
							if (s.isIsolated())
							{
								continue;
							}

							local d = s.getTile().getDistanceTo(myTile);

							if (d < lowest_distance)
							{
								lowest_distance = d;
								best_dest = s;
							}

							if (d > highest_distance)
							{
								highest_distance = d;
								best_start = s;
							}
						}

						this.Flags.set("InterceptSuppliesStart", best_start.getID());
						this.Flags.set("InterceptSuppliesDest", best_dest.getID());
					}
				}
				else if (r <= 80)
				{
					this.Flags.set("IsDeserters", true);
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Udaj się do obozu wojennego i zamelduj osobie zwanej %commander%"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Warcamp) && !this.Flags.get("IsWarcampDay1Shown"))
				{
					this.Flags.set("IsWarcampDay1Shown", true);
					this.Contract.setScreen("WarcampDay1");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Running_WaitForNextDay",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Zaczekaj w obozie, aż zostaniesz wezwany"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Warcamp))
				{
					if (this.World.getTime().Days > this.Flags.get("LastDay"))
					{
						if (this.Flags.get("NextDay") == 2)
						{
							this.Contract.setScreen("WarcampDay2");
						}
						else
						{
							this.Contract.setScreen("WarcampDay3");
						}

						this.World.Contracts.showActiveContract();
					}
				}
			}

		});
		this.m.States.push({
			ID = "Running_Scouts",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Przechwyć wrogich zwiadowców ostatnio widzianych na %direction% od obozu",
					"Nie pozwól nikomu ujść z życiem"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onCombatWithScouts.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsScoutsFailed"))
					{
						this.Contract.setScreen("ScoutsEscaped");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("ScoutsCaught");
						this.World.Contracts.showActiveContract();
					}
				}
				else if (this.Flags.get("IsScoutsRetreat"))
				{
					this.Flags.set("IsScoutsRetreat", false);
					this.Contract.m.Destination.die();
					this.Contract.m.Destination = null;
					this.Contract.setScreen("ScoutsEscaped");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatWithScouts( _dest, _isPlayerAttacking = true )
			{
				local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
				properties.CombatID = "Scouts";
				properties.Music = this.Const.Music.NobleTracks;
				properties.EnemyBanners = [
					this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getBannerSmall()
				];
				this.World.Contracts.startScriptedCombat(properties, _isPlayerAttacking, true, true);
			}

			function onActorRetreated( _actor, _combatID )
			{
				if (_combatID == "Scouts")
				{
					this.Flags.set("IsScoutsFailed", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Scouts")
				{
					this.Flags.set("IsScoutsRetreat", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_ReturnAfterScouts",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Wróć do obozu wojennego"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Warcamp) && !this.Flags.get("IsReportAfterScoutsShown"))
				{
					this.Flags.set("IsReportAfterScoutsShown", true);
					this.Contract.setScreen("WarcampDay1End");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Running_Requisition",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Zarekwiruj zapasy w %objective% na %direction% od obozu"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Destination) && !this.TempFlags.get("IsReportAfterRequisitionShown"))
				{
					this.TempFlags.set("IsReportAfterRequisitionShown", true);
					this.Contract.setScreen("RequisitionSupplies2");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsRequisitionRetreat") && !this.Flags.get("IsRequisitionCombatDone"))
				{
					this.Flags.set("IsRequisitionCombatDone", true);
					this.Contract.setScreen("BeatenByFarmers");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsRequisitionVictory") && !this.Flags.get("IsRequisitionCombatDone"))
				{
					this.Flags.set("IsRequisitionCombatDone", true);
					this.Contract.setScreen("PoorFarmers");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Ambush" || _combatID == "TakeItByForce")
				{
					this.Flags.set("IsRequisitionRetreat", true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Ambush" || _combatID == "TakeItByForce")
				{
					this.Flags.set("IsRequisitionVictory", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_ReturnAfterRequisition",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Wróć do obozu wojennego"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = true;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Warcamp))
				{
					if (this.Flags.get("IsInterceptSupplies") || this.Flags.get("IsDeserters"))
					{
						this.Contract.setScreen("WarcampDay1End");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("WarcampDay2End");
						this.World.Contracts.showActiveContract();
					}
				}
			}

		});
		this.m.States.push({
			ID = "Running_InterceptSupplies",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Przechwyć zapasy zmierzające z %supply_start% do %supply_dest%"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setVisibleInFogOfWar(true);
				}
			}

			function update()
			{
				if (this.Flags.get("IsInterceptSuppliesSuccess"))
				{
					this.Contract.setScreen("SuppliesIntercepted");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.m.Destination == null || this.Contract.m.Destination != null && this.Contract.m.Destination.isNull())
				{
					this.Flags.set("IsInterceptSuppliesFailure", true);
					this.Contract.setScreen("SuppliesReachedEnemy");
					this.World.Contracts.showActiveContract();
				}
			}

			function onPartyDestroyed( _party )
			{
				if (_party.getFlags().has("ContractSupplies"))
				{
					this.Flags.set("IsInterceptSuppliesSuccess", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_ReturnAfterIntercept",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Wróć do obozu wojennego"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = true;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Warcamp))
				{
					this.Contract.setScreen("WarcampDay2End");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Running_Deserters",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Podążaj za śladami i dogoń dezerterów",
					"Przekonaj ich do powrotu lub zabij ich"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Flags.get("IsDesertersFailed"))
				{
					if (this.Contract.m.Destination != null)
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
					}

					this.Contract.setState("Running_ReturnAfterIntercept");
				}
				else if (this.Contract.m.Destination == null || this.Contract.m.Destination != null && this.Contract.m.Destination.isNull())
				{
					this.Contract.setScreen("DesertersAftermath");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerNear(this.Contract.m.Destination, this.Const.World.CombatSettings.CombatPlayerDistance / 2) && !this.TempFlags.get("IsDeserterApproachShown"))
				{
					this.TempFlags.set("IsDeserterApproachShown", true);
					this.Contract.setScreen("Deserters2");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Deserters")
				{
					this.Flags.set("IsDesertersFailed", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_FinalBattle",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Wygraj bitwę, w której przeciwnikiem jest %noblehouse%"
				];
			}

			function update()
			{
				if (this.Flags.get("IsFinalBattleLost") && !this.Flags.get("IsFinalBattleLostShown"))
				{
					this.Flags.set("IsFinalBattleLostShown", true);
					this.Contract.m.Warcamp.die();
					this.Contract.m.Warcamp = null;
					this.Contract.setScreen("BattleLost");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsFinalBattleWon") && !this.Flags.get("IsFinalBattleWonShown"))
				{
					this.Flags.set("IsFinalBattleWonShown", true);
					this.Contract.m.Warcamp.die();
					this.Contract.m.Warcamp = null;
					this.Contract.setScreen("BattleWon");
					this.World.Contracts.showActiveContract();
				}
				else if (!this.TempFlags.get("IsFinalBattleStarted"))
				{
					this.TempFlags.set("IsFinalBattleStarted", true);
					local tile = this.Contract.getTileToSpawnLocation(this.Contract.m.Warcamp.getTile(), 3, 12, [
						this.Const.World.TerrainType.Shore,
						this.Const.World.TerrainType.Ocean,
						this.Const.World.TerrainType.Mountains,
						this.Const.World.TerrainType.Forest,
						this.Const.World.TerrainType.LeaveForest,
						this.Const.World.TerrainType.SnowyForest,
						this.Const.World.TerrainType.AutumnForest,
						this.Const.World.TerrainType.Swamp,
						this.Const.World.TerrainType.Hills
					], false);
					this.World.State.getPlayer().setPos(tile.Pos);
					this.World.getCamera().moveToPos(this.World.State.getPlayer().getPos());
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "FinalBattle";
					p.Music = this.Const.Music.NobleTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.Entities = [];
					p.AllyBanners = [
						this.World.Assets.getBanner(),
						this.World.FactionManager.getFaction(this.Contract.getFaction()).getBannerSmall()
					];
					p.EnemyBanners = [
						this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getBannerSmall()
					];
					local allyStrength = 90;

					if (this.Flags.get("IsRequisitionFailure"))
					{
						allyStrength = allyStrength - 20;
					}

					if (this.Flags.get("IsDesertersFailed"))
					{
						allyStrength = allyStrength - 20;
					}

					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, allyStrength * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
					p.Entities.push({
						ID = this.Const.EntityType.Knight,
						Variant = 0,
						Row = 2,
						Script = "scripts/entity/tactical/humans/knight",
						Faction = this.Contract.getFaction(),
						Callback = this.Contract.onCommanderPlaced.bindenv(this.Contract)
					});
					local enemyStrength = 150;

					if (this.Flags.get("IsScoutsFailed"))
					{
						enemyStrength = enemyStrength + 25;
					}

					if (this.Flags.get("IsInterceptSuppliesFailure"))
					{
						enemyStrength = enemyStrength + 25;
					}

					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, enemyStrength * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyNobleHouse"));
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 60 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyNobleHouse"));
					p.Entities.push({
						ID = this.Const.EntityType.Knight,
						Variant = this.Const.DLC.Wildmen && this.Contract.getDifficultyMult() >= 1.15 ? 1 : 0,
						Name = this.Const.Strings.KnightNames[this.Math.rand(0, this.Const.Strings.KnightNames.len() - 1)],
						Row = 2,
						Script = "scripts/entity/tactical/humans/knight",
						Faction = this.Flags.get("EnemyNobleHouse"),
						Callback = null
					});
					this.Contract.setState("Running_FinalBattle");
					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "FinalBattle")
				{
					this.Flags.set("IsFinalBattleLost", true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "FinalBattle")
				{
					this.Flags.set("IsFinalBattleWon", true);
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Wróć do " + this.Contract.m.Home.getName() + " aby odebrać swoją zapłatę"
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% wita cię w środku. Ma na sobie zbroję, choć jego dowódcy zdają się odradzać mu udział w walce. Mimo to wita cię serdecznie i szybko wyjaśnia, czego od ciebie potrzebuje.%SPEECH_ON%Jesteśmy bliscy zakończenia tej głupiej wojny. Moje największe siły formują się na %direction% stąd. Potrzebuję, byś tam poszedł i spotkał się z %commander%em. On wyjaśni, jak cię wykorzysta. Jeśli pomożesz nam przechylić szalę, zostaniesz hojnie opłacony, najemniku.%SPEECH_OFF% | Wchodzisz do komnaty %employer%a i widzisz, jak karmi psy sztandarem %feudfamily%. Kundele rozszarpują go z wyuczonym okrucieństwem. %employer% spogląda na ciebie.%SPEECH_ON%Ach, najemniku. Dobrze, że wreszcie jesteś. Musisz udać się do %commander%a, na %direction% stąd. Wkraczamy w finałowe etapy tej przeklętej wojny i wierzę, że ludzie tacy jak ty mogą przyspieszyć jej koniec. Nie powiem ci, czego się spodziewać, poza tym, że takie wojny zwykle kończą się spektakularnie. Twoja zapłata też będzie spektakularna.%SPEECH_OFF% | Wchodzisz do komnaty %employer%a i znajdujesz go wśród generałów. Patrzą na mapę, na której ścierają się liczne żetony przeciwników. Szlachcic spogląda na ciebie.%SPEECH_ON%Ach, najemniku. Musisz iść tutaj.%SPEECH_OFF%Kładzie na mapie patyk.%SPEECH_ON%I spotkać się z %commander%em. Przygotowujemy się, by raz na zawsze zakończyć tę wojnę, a twoja pomoc będzie kluczowa.%SPEECH_OFF%Kiwasz głową, ale zwlekasz. Mężczyzna unosi brwi, potem palec.%SPEECH_ON%Tak, twoja pomoc będzie opłacona! Nie miej co do tego wątpliwości.%SPEECH_OFF% | Nie możesz wejść do komnaty %employer%a. Zamiast tego jeden z jego dowódców spotyka cię na zewnątrz z mapą i kontraktem. Wyjaśnia, że nadchodzi wielka bitwa i twoja pomoc jest potrzebna. Jeśli się zgodzisz, udasz się do %commander%a na %direction% stąd i tam zaczekasz na dalsze rozkazy. | Strażnik przed komnatą %employer%a powstrzymuje cię przed wejściem. Wpatruje się w znak %companyname% i zwraca się do ciebie bezpośrednio.%SPEECH_ON%Mam ci to przekazać.%SPEECH_OFF%Uderza cię zwojem w pierś. Instrukcje mówią, że nadchodzi bitwa kończąca wojnę i, jeśli zechcesz pomóc, masz stawić się u %commander%a w obozie po dalsze rozkazy. Pytasz, czy masz targować się ze strażnikiem czy z %employer%em. Strażnik przełyka ślinę, a po policzku spływa mu kropla potu.%SPEECH_ON%Jeśli musisz się targować, to ze mną.%SPEECH_OFF% | %employer% wita cię i wyprowadza do swojego psiego mistrza. Psy siedzą posłusznie, gdy przechodzi wzdłuż ich linii. Gładzi je po głowach pewnym, władczym gestem.%SPEECH_ON%%commander% prowadzi moich ludzi na %direction% stąd i doniósł mi, że na horyzoncie może majaczyć wielka bitwa.%SPEECH_OFF%Szlachcic zatrzymuje się i odwraca do ciebie.%SPEECH_ON%Uważa, że to może zakończyć wojnę z %feudfamily%. Chcę więc, żebyś tam poszedł i pomógł, byle zakończyć ten paskudny konflikt.%SPEECH_OFF% | Spotykasz się z %employer%em w sali pełnej generałów. Jego dowódcy spoglądają na ciebie podejrzliwie, ale zaprasza cię na bok, by porozmawiać w cztery oczy.%SPEECH_ON%Nie zwracaj na nich uwagi. Szybko: mam armię dowodzoną przez %commander%a, zaledwie %direction% stąd. Potrzebuję, byś się z nim spotkał po dalsze rozkazy. Moi dowódcy sądzą, że finałowa bitwa jest blisko, a potrzebujemy wszelkiej pomocy. Jeśli ta walka rzeczywiście zakończy wojnę, zostaniesz odpowiednio wynagrodzony.%SPEECH_OFF% | Strażnik wpuszcza cię do komnaty %employer%a, gdzie zastajesz go pośród kłócących się generałów. Przekrzykują się, przewracają znaczniki na mapie i robią bałagan w szyku planowania bitwy. %employer% wstaje i podchodzi do ciebie.%SPEECH_ON%Nie zwracaj uwagi na hałas. Ludzie są napięci, bo bardzo możliwe, że stoimy u progu zakończenia tej przeklętej wojny z %feudfamily%. %commander% i większość mojej armii odpoczywają na %direction% stąd. Wezwał tyle posiłków, ile zdoła, w tym najemników. Jeśli pójdziesz tam i pomożesz zakończyć to gówno, które nazywamy wojną, zostaniesz hojnie wynagrodzony, najemniku.%SPEECH_OFF% | %employer% wyprowadza cię na zewnątrz do świńskich zagród. Tam świnie przeżuwają zwłoki. W pobliżu kilka kóz ogryza sztandar %feudfamily%. %employer% odwraca się do ciebie z uśmiechem.%SPEECH_ON%Szpieg, rozumiesz, jak to działa. Tak czy inaczej, %commander% doniósł mi, że uważa, iż finałowa bitwa z %feudfamily% jest blisko. Poprosił o wszelką możliwą pomoc i zamierzam ją wysłać. Jeśli tam pójdziesz, spotkasz się z nim i zrobisz to, o co prosi, zostaniesz sowicie wynagrodzony.%SPEECH_OFF% | Spotykasz jednego ze strażników %employer%a, który prowadzi cię do niego osobiście. Zaszył się w małym pokoju, w czymś na kształt schowka z dala od zgiełku świata. Świeca migocze, gdy przewraca kartki książki. Mówi, nie podnosząc wzroku.%SPEECH_ON%Witaj, najemniku. Mój dowódca polowy, %commander%, przysłał mi ptaszka, że armie %feudfamily% mogą się łączyć. Wierzy, że mamy szansę zakończyć tę wojnę raz na zawsze.%SPEECH_OFF%Szlachcic zwilża kciuk i powoli przewraca stronę. Kontynuuje.%SPEECH_ON%Chcę, byś do niego dołączył. Oczywiście zapłata będzie adekwatna do tego, co masz do zaoferowania, a podejrzewam, że sporo.%SPEECH_OFF% | Jeden ze strażników %employer%a prowadzi cię na szczyt wieży, gdzie zastajesz samego szlachcica. Spogląda na ciebie.%SPEECH_ON%Ładny widok, co?%SPEECH_OFF%Rozglądasz się. Ziemia sięga daleko, a ludzie stają się małymi punkcikami biegnącymi po niej. Pod wieżą turkocze wózek ciągnięty przez osła, wjeżdżając do %townname% za interesami. Wzruszasz ramionami. %employer% kiwa głową.%SPEECH_ON%Sądziłem, że lubisz takie widoki, ale człowiek interesu raczej nie miewa takich myśli, gdy sprawy są naglące. A, drogi najemniku, sprawy są naglące. Jeden z moich dowódców doniósł, że armie %feudfamily% zbierają się razem. Uważa, że możemy zakończyć z nimi tę wojnę w jednej wielkiej, finałowej bitwie. Rozumiesz?%SPEECH_OFF%Kiwasz głową. On kontynuuje.%SPEECH_ON%Jeśli wszystko pójdzie zgodnie z planem, zostaniesz opłacony odpowiednio do zasług. Nie wiem, czy kiedykolwiek pomogłeś zakończyć wojnę, najemniku, ale wielu ludzi zapłaciłoby królewską okupą za takie usługi.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "Wielka bitwa, powiadasz?",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Nie poddam kompanii pod rozkazy innej osoby. | Muszę odmówić. | Jesteśmy potrzebni gdzie indziej.}",
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
			ID = "WarcampDay1",
			Title = "W obozie...",
			Text = "[img]gfx/ui/events/event_96.png[/img]{Przybywasz do obozu, bardziej przypominającego miasto namiotów, i znajdujesz %commander%a. Wita cię w swoim namiocie, który sam przypomina mapowe miasto, gdy rozważa, gdzie jest jego armia i gdzie może być armia %feudfamily%.%SPEECH_ON%Witaj, najemniku. Przybyłeś w samą porę.%SPEECH_OFF% | Obóz wojenny %commander%a pełen jest znudzonych ludzi. Mieszają gulasze albo grają w karty. Najciekawszą atrakcją jest walka chrząszcza z robakiem, bitwa, która nie interesuje specjalnie żadnej ze stron. Sam %commander% wita cię i prowadzi do swojego namiotu, ozdobionego mapami i innymi narzędziami planowania. | Wchodzisz do namiotu %commander%a i widzisz mało entuzjastyczną grupę ludzi. Jeden woła.%SPEECH_ON%Nie jesteście dziewkami, o które prosiliśmy.%SPEECH_OFF%Żołnierze się śmieją. %randombrother% odszczekuje.%SPEECH_ON%Wasze matki najpierw zajęły się nami.%SPEECH_OFF%Jak można się spodziewać, wszyscy zaczynają sięgać po broń. Sam %commander% interweniuje, by nie doszło do krwawej jatki. Zabiera cię do swojego namiotu.%SPEECH_ON%Dobrze, że jesteś, choć twoi ludzie mogliby być mniej uciążliwi, jeśli mamy wygrać tę cholerną wojnę.%SPEECH_OFF% | Wchodzisz do obozu %commander%a i widzisz, że ludzie biorą udział w wyścigu chrząszczy. Kibicują im, a te, w połowie toru z siana, zwracają się przeciw sobie i zaczynają walczyć. Okrzyki żołnierzy stają się coraz głośniejsze. %commander% odnajduje cię w tłumie i prowadzi do namiotu.%SPEECH_ON%Cieszę się, że jesteś, najemniku. Mam dla ciebie zadanie od razu.%SPEECH_OFF% | Przybywając do obozu wojennego %commander%a, widzisz ludzi kibicujących prawie nagiej kobiecie jadącej na ośle. Kobieta i osioł znikają w namiocie, który szybko pęcznieje od mężczyzn. %randombrother% pyta, czy może iść. Mówisz, że sam też idziesz, więc oczywiście tak. W tej chwili %commander% chwyta cię i prowadzi do swojego namiotu dowodzenia.%SPEECH_ON%Zaufaj mi, nie chcesz tego widzieć.%SPEECH_OFF%Nie ufasz mu. | Obóz wojenny %commander%a zamienił ziemię w błoto. Wycięli wszystkie okoliczne drzewa i postawili w ich miejsce małe, lichutkie szałasy, które przechylają się tam, gdzie błoto ustępuje. Namioty ciągną się po horyzont. Ogniska jarzą się po drodze jak gwiazdy na białym niebie.\n\n Spotykasz %commander%a w jego namiocie pełnym map i poruczników czekających na rozkazy. | Obóz wojenny jest pełen stukotu i brzęku. Kowale naprawiają sprzęt, kucharze gotują obrzydliwe breje, a żołnierze wbijają pale pod namioty. Spotykasz się z %commander%em w jego namiocie. Oderwany od tego metalicznego hałasu, słyszysz za to kłótnie jego poruczników. Kręci głową.%SPEECH_ON%Gdy zbliża się wielka bitwa, ludzie się denerwują. Nie zwracaj uwagi na ich sprzeczki.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Co mamy zrobić?",
					function getResult()
					{
						if (this.Flags.get("IsScoutsSighted"))
						{
							return "ScoutsSighted";
						}
						else
						{
							return "RequisitionSupplies1";
						}
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WarcampDay1End",
			Title = "W obozie...",
			Text = "[img]gfx/ui/events/event_96.png[/img]{Wracasz do obozu wojennego i każesz ludziom odpocząć. Kto wie, co czeka was jutro. | Cóż, rozkazy %commander%a zostały wykonane, ale jutro na pewno będzie więcej. Odpocznij, póki możesz! | Obóz wojenny jest taki sam jak wtedy, gdy go opuszczałeś. Nie wiesz, czy to dobrze, czy źle. Jutro przyniesie kolejne gówno do ogarnięcia, więc każesz %companyname% odpocząć.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Odpoczywajcie, wkrótce po nas poślą.",
					function getResult()
					{
						this.Flags.set("LastDay", this.World.getTime().Days);
						this.Flags.set("NextDay", 2);
						this.Contract.setState("Running_WaitForNextDay");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ScoutsSighted",
			Title = "W obozie...",
			Text = "[img]gfx/ui/events/event_54.png[/img]%commander% wyjaśnia sytuację.%SPEECH_ON%{Nasi zwiadowcy namierzyli ich zwiadowców. Niestety nie uzbroiłem swoich ludzi do walki, więc proszą o pomoc. Wróg jest na %direction% stąd. Zabij ich wszystkich, a %feudfamily% pozostanie w ciemności co do ruchów naszej armii. | Kilku moich tropicieli namierzyło zwiadowców %feudfamily% na %direction% stąd. Kręcą się, szukając głównej armii, ale jej nie znajdą, bo ty pójdziesz tam i wybijesz ich wszystkich. Jasne? | Zwiadowcy %feudfamily% zostali zauważeni na %direction% stąd. Musisz iść i zabić ich wszystkich, zanim nas znajdą albo przekażą to, czego dowiedzieli się w ostatnich dniach. | Na wojnie informacja jest bogiem. A ja ostatnio zdobyłem informację, że zwiadowcy %feudfamily% krążą na %direction% stąd. Jeśli dowiemy się czegoś o nich i zniszczymy to, czego dowiedzieli się o nas, uzyskamy sporą przewagę w nadchodzących walkach.}%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Kompania wyruszy niezwłocznie.",
					function getResult()
					{
						this.Contract.setState("Running_Scouts");
						return 0;
					}

				}
			],
			function start()
			{
				local playerTile = this.Contract.m.Warcamp.getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 8);
				local party = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).spawnEntity(tile, "Zwiadowcy", false, this.Const.World.Spawn.Noble, 60 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.getSprite("banner").setBrush(this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getBannerSmall());
				party.setDescription("Profesjonalni żołdacy na usługach miejscowych lordów.");
				party.setFootprintType(this.Const.World.FootprintsType.Nobles);
				this.Contract.m.UnitsSpawned.push(party);
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

				this.Contract.m.Destination = this.WeakTableRef(party);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Warcamp);
				roam.setMinRange(4);
				roam.setMaxRange(9);
				roam.setAllTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
				roam.setTerrain(this.Const.World.TerrainType.Shore, false);
				roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
				c.addOrder(roam);
			}

		});
		this.m.Screens.push({
			ID = "ScoutsEscaped",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Niestety jeden lub więcej zwiadowców zdołało ujść z bitwy. Wszystkie informacje, które zebrali, są teraz w rękach %feudfamily%. | Do diabła! Części zwiadowców udało się uciec i bez wątpienia wrócą do %feudfamily%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "A niech to!",
					function getResult()
					{
						this.Contract.setState("Running_ReturnAfterScouts");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ScoutsCaught",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Wszyscy zwiadowcy zostali zabici. Wszelkie informacje, które mieli, umarły razem z nimi. To będzie wielka korzyść w nadchodzącej bitwie. | Zwiadowcy nie żyją, a wszystko, czego się dowiedzieli, zginęło wraz z nimi.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zwycięstwo!",
					function getResult()
					{
						this.Contract.setState("Running_ReturnAfterScouts");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "RequisitionSupplies1",
			Title = "W obozie...",
			Text = "[img]gfx/ui/events/event_96.png[/img]{%commander% wzdycha i zaczyna mówić.%SPEECH_ON%Nie chcę marnować twoich talentów, najemniku, ale potrzebuję kogoś, kto wyjdzie i zarekwirowałby zapasy żywności dla armii. Kończą nam się zapasy i potrzebujemy wszelkiej pomocy.%SPEECH_OFF%Hej, skoro i tak masz za to płacone, nie jest to zniewaga. | %commander% wpycha wysuszony liść za wargę i krzyżuje ramiona.%SPEECH_ON%Do diabła, wiem, że jesteś tu, by walczyć. Wiem, że jesteś tu, by zabijać ludzi i dostawać za to dobrą zapłatę. Ale teraz moja armia musi jeść, a żeby jeść, potrzebuję kogoś, kto pójdzie i zdobędzie jedzenie.%SPEECH_OFF%Podchodzi do jednej z map i wskazuje ją palcem.%SPEECH_ON%Musisz odwiedzić tych rolników i załadować ich żywność. Będą się ciebie spodziewać, więc nie powinno być problemów. Potraktuj to jako łatwy dzień przed bitwą, co?%SPEECH_OFF% | %commander% wskazuje zwój rozłożony na jednej z map. Widać na nim liczby, a im niżej na stronie, tym bardziej się kurczą.%SPEECH_ON%Kończą nam się zapasy żywności. Zwykle rekwirujemy zapasy, odwiedzając rolników na %direction% stąd. Musisz tam pójść i zebrać więcej. Będą się ciebie spodziewać, więc nie powinno być problemów.%SPEECH_OFF% | Spoglądasz na talerz z suchym bochenkiem chleba. Na sąsiednim talerzu leży mięso, w połowie zjedzone, resztę pożerają muchy. W kącie merda ogonem dobrze odkarmiony pies. %commander% podchodzi do jednej z map.%SPEECH_ON%Zapasy żywności mamy na wyczerpaniu. Jeśli moi ludzie będą głodni, nie będą walczyć, a jeśli nie będą walczyć, przegramy!%SPEECH_OFF%Kiwasz głową. Rachunek się zgadza. On kontynuuje.%SPEECH_ON%Od jakiegoś czasu bierzemy żywność od rolników na %direction% stąd. Musisz tam pójść i zrobić to samo. Jeden z moich strażników sporządzi listę rzeczy do zabrania. Rolnicy nie będą się opierać. Wiedzą, co się dzieje, gdy to robią.%SPEECH_OFF% | Widzisz w kącie namiotu pilnego mężczyznę. Przeciąga wysuszonym piórem po zwoju, kręcąc przy tym głową. Nagle wstaje i podaje kartę %commander%owi. Dowódca kiwa kilka razy, po czym spogląda na ciebie.%SPEECH_ON%To może wydawać się poniżej niektórych najemników, ale potrzebuję, by %companyname% odwiedziła farmy na %direction% stąd i \"zarekwirowała\" ich żywność. To nie pierwszy raz, gdy nasza armia składa takie żądania tym rolnikom. Ostatnim razem próbowali się opierać, ale cóż, nauczka została odrobiona. Mój skryba zapisze wszystko, czego potrzebujemy. Potraktuj to jak dzień zakupów na targu.%SPEECH_OFF%Dowódca uśmiecha się krzywo.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Kompania wyruszy w ciągu godziny.",
					function getResult()
					{
						this.Contract.setState("Running_Requisition");
						return 0;
					}

				}
			],
			function start()
			{
				local settlements = this.World.EntityManager.getSettlements();
				local lowest_distance = 99999;
				local best_location;
				local myTile = this.Contract.m.Warcamp.getTile();

				foreach( s in settlements )
				{
					foreach( l in s.getAttachedLocations() )
					{
						if (l.getTypeID() == "attached_location.wheat_fields" || l.getTypeID() == "attached_location.pig_farm")
						{
							local d = myTile.getDistanceTo(l.getTile());

							if (d < lowest_distance)
							{
								lowest_distance = d;
								best_location = l;
							}
						}
					}
				}

				best_location.setActive(true);
				this.Contract.m.Destination = this.WeakTableRef(best_location);
			}

		});
		this.m.Screens.push({
			ID = "RequisitionSupplies2",
			Title = "Na gospodarstwie...",
			Text = "[img]gfx/ui/events/event_72.png[/img]{Zabudowania gospodarstw są coraz bliżej. Przed tobą rozciąga się morze upraw, pola falują jak fale, gdy wieje wiatr. %randombrother% przeciąga dłonią przez łan pszenicy. %randombrother2% uderza go w ramię.%SPEECH_ON%Chcesz przywieźć do domu bąkowate? Wyciągnij stamtąd łapę.%SPEECH_OFF%Najemnik pociera ramię, po czym oddaje.%SPEECH_ON%Spadaj. Moja ręka idzie, gdzie chce, zapytaj matkę.%SPEECH_OFF%Ciosy szybko stają się głośniejsze, a sielanka pryska. | Zabudowania gospodarstw widać w oddali. Pola falują na ostrym wietrze, szeleszcząc jak spokojne fale morza. Parobcy koszą pola kosami, a gromada pomocników przerzuca zbiory widłami. Osły zamykają pochód, ciągnąc wozy po wyboistym terenie. | Gospodarstwa rozciągają się pośród wzgórz, a ziemia jest zbyt dobra, by pozwolić geografii stanąć na przeszkodzie. Każde pole jest pełne plonów, a między nimi krążą parobcy, kosy i widły błyszczą, gdy unoszą się i opadają. W oddali widzisz właścicieli gospodarstw stojących razem. Wyglądają na wściekłych, ale rzadko kto pozostaje zły w obliczu %companyname%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zabierzmy to, po co przyszliśmy.",
					function getResult()
					{
						if (this.Flags.get("IsAmbush"))
						{
							return "Ambush";
						}
						else if (this.Flags.get("IsUnrulyFarmers"))
						{
							return "UnrulyFarmers";
						}
						else
						{
							return "CooperativeFarmers";
						}
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Ambush",
			Title = "Na gospodarstwie...",
			Text = "[img]gfx/ui/events/event_10.png[/img]{Gdy zbliżasz się do rolników, z boków rozlega się krzyk i wyskakuje grupa dobrze uzbrojonych ludzi. To zasadzka! | Gdy podchodzisz do zabudowań, wozy pełne żywności zaczynają toczyć się wstecz. Gdy odsuwają się, odsłaniają oddział dobrze uzbrojonych ludzi. Rolnicy szybko znikają. %randombrother% dobywa broni.%SPEECH_ON%To zasadzka!%SPEECH_OFF% | Podchodzisz do wozów z żywnością. Rolnicy odstępują, a %randombrother% podchodzi i zrywa płachtę z jednego z wozów. W środku nie ma nic. Nagle strzała uderza w bok wozu z drewnianym trzaskiem. Rolnicy kucają i uciekają, a z boków napływają dobrze uzbrojeni ludzie. To zasadzka!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Ambush";
						p.Music = this.Const.Music.CivilianTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						local n = 0;

						do
						{
							n = this.Math.rand(1, this.Const.PlayerBanners.len());
						}
						while (n == this.World.Assets.getBannerID());

						p.Entities = [];
						p.EnemyBanners = [
							this.Const.PlayerBanners[n - 1],
							"banner_noble_11"
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Const.Faction.Enemy);
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.PeasantsArmed, 40 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Const.Faction.Enemy);
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "UnrulyFarmers",
			Title = "Na gospodarstwie...",
			Text = "[img]gfx/ui/events/event_43.png[/img]Podchodzisz do rolników, ale ci stawiają opór. Ich przywódca krzyżuje ramiona i kręci głową.%SPEECH_ON%{Słuchaj. Moi ludzie już załadowali wozy. Mogę pójść na kompromis, wiesz? Mamy rodziny do wykarmienia i długi do spłacenia jak każdy. Co powiesz na %cost% koron, a przepuścimy to wszystko do %commander%a. | Jesteście najemnikami, prawda? To rozumiecie potrzebę złota lepiej niż większość. Jesteśmy prostymi rolnikami, nie zmiennikami pieniędzy. Prosimy tylko o niewielką rekompensatę za naszą pracę. Dacie nam %cost% koron, a my damy wam jedzenie. Wciąż będziemy na minusie, ale uważam, że to uczciwe. | Przychodzicie tu w tych swoich krzykliwych ubraniach i myślicie, że nas zastraszycie. %commander% i tak wziął już zbyt wiele, mówię, i czas, by zapłacił za jedzenie jak każdy! Oto układ: sprzedam wam żywność za %cost% koron. Uważam, że to zupełnie uczciwe za to, co oferujemy.}%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zapominasz gdzie twoje miejsce, rolniku. Mamy wziąć to siłą?",
					function getResult()
					{
						return "TakeItByForce";
					}

				},
				{
					Text = "Rozumiem. Otrzymasz swoje %cost% koron, a my - zapasy.",
					function getResult()
					{
						return "PayCompensation";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BeatenByFarmers",
			Title = "Na gospodarstwie...",
			Text = "[img]gfx/ui/events/event_22.png[/img]Zasadzka jest zbyt silna! Zabierasz tych, którzy jeszcze stoją, i wycofujesz się. Ludzie %commander%a będą musieli jeszcze bardziej racjonować zapasy, a wieść o porażce %companyname% bez wątpienia się rozniesie.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "A niech to!",
					function getResult()
					{
						this.Flags.set("IsRequisitionFailure", true);
						this.Contract.setState("Running_ReturnAfterRequisition");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "PoorFarmers",
			Title = "Na gospodarstwie...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Rolnicy i ich najęte miecze padają. Jeden z parobków, kopiąc do tyłu z flakami na wierzchu, błaga o litość, gdy zbliżasz się, by go dobić. Kręcisz głową.%SPEECH_ON%Jesteś już ugotowany, dzieciaku. To właśnie jest litość.%SPEECH_OFF%Ostrze gładko przesuwa się przez jego gardło. Bulgoce, ale to koniec bardzo szybko. Rozkazujesz ludziom zebrać zapasy i przygotować powrót do %commander%a. | Rolnicy i ich zasadzka zostali wybici co do jednego. Rozkazujesz ludziom zebrać zapasy. %commander% i jego ludzie na pewno ucieszą się z twojego powrotu. | Na części jedzenia jest krew, ale trochę wody to zmyje. Ludzie %commander%a docenią twoją robotę. | %randombrother% podnosi rolnika, który udawał martwego, i podcina mu gardło. Mężczyzna bulgocze i wyrywa się z uścisku najemnika. Pędzi do jednego z wozów, tryskając krwią na jedzenie. Wołasz.%SPEECH_ON%Do diabła, zdejmijcie go stamtąd!%SPEECH_OFF%Rolnik szybko zostaje dobity, ale ten transport bez wątpienia jest zrujnowany. Kręcisz głową.%SPEECH_ON%Przykryjcie to płachtą. Może nikt nie zauważy.%SPEECH_OFF% | Zdobycie żywności wymagało trochę więcej pracy, niż zakładałeś, ale teraz wszystko jest w twoich rękach. Oddajesz ziemię biednemu parobkowi z workami wełny zamiast butów.%SPEECH_ON%Nie zapomnij, co spotkało twojego pana, bo to samo może spotkać i ciebie, jasne?%SPEECH_OFF%Chłopak szybko kiwa głową. Rozkazujesz %companyname% przygotować się do powrotu do %commander%a.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Głupcy.",
					function getResult()
					{
						this.Flags.set("RequisitionSuccess", true);
						this.Contract.setState("Running_ReturnAfterRequisition");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CooperativeFarmers",
			Title = "Na gospodarstwie...",
			Text = "[img]gfx/ui/events/event_55.png[/img]{Rolnicy witają cię serdecznie.%SPEECH_ON%Daj zgadnąć, %commander% was przysłał?%SPEECH_OFF%Kiwasz głową. Rolnik spluwa i kiwa w odpowiedzi.%SPEECH_ON%No dobra. Nie będzie tu kłopotów. Ludzie, pomóżcie im w drogę.%SPEECH_OFF%Parobcy wychodzą, by pomóc twoim ludziom zebrać zapasy i przygotować drogę powrotną do %commander%a. | Spotykasz przywódcę rolników. Uściska twoją dłoń.%SPEECH_ON%Ptak %commander%a powiedział mi, że przysłał najemników, ale wasza kompania wygląda na poziom wyżej niż jakakolwiek, jaką widziałem. Moi chłopcy pomogą wam załadować wozy, żebyście mogli ruszać.%SPEECH_OFF% | Rolnicy zaczynają ładować wozy, gdy podchodzisz. Ich przywódca robi krok do przodu.%SPEECH_ON%Nie cieszę się z tego, ale bardziej wolę być tutaj, na polach, niż siedzieć w obozie wojennym i czekać, aż zginę w wojnie, na której mi nie zależy. Moi ludzie pomogą wam załadować wozy, żebyście mogli ruszać. Jak zobaczysz %commander%a, powiedz o mnie dobre słowo, dobrze? Chciałbym dalej uprawiać ziemię.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "%noblehouse% z pewnością to doceni.",
					function getResult()
					{
						this.Flags.set("RequisitionSuccess", true);
						this.Contract.setState("Running_ReturnAfterRequisition");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TakeItByForce",
			Title = "Na gospodarstwie...",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Dobywasz miecza. Rolnicy cofają się, a w ich szeregach rozlega się szczęk chwytanych wideł. Ich przywódca spluwa i ociera usta rękawem.%SPEECH_ON%No, chcesz to wziąć siłą? To weźmiemy się za to.%SPEECH_OFF% | Kręcisz głową.%SPEECH_ON%Nie ma mowy. Oddajcie zapasy albo poczujecie nasz gniew.%SPEECH_OFF%Rolnik macha widłami na boki. Jego ludzie powoli chwytają za broń. Kiwają głowami.%SPEECH_ON%Jesteśmy rolnikami, dupku. Gniew wybrał nas dawno temu.%SPEECH_OFF% | Nie przyszedłeś tu, by robić interesy.%SPEECH_ON%Nie będzie żadnej rekompensaty. %commander% przysłał nas tu, by...%SPEECH_OFF%Rolnik śmieje się i przerywa.%SPEECH_ON%Dowódca przysłał psy na smyczy. Dobra, piesku, zobaczymy, czy twoi ludzie mają więcej szczeku niż gryzienia.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Załatwmy to szybko.",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "TakeItByForce";
						p.Music = this.Const.Music.CivilianTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.Entities = [];
						p.EnemyBanners = [
							"banner_noble_11"
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Peasants, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Const.Faction.Enemy);
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "PayCompensation",
			Title = "Na gospodarstwie...",
			Text = "[img]gfx/ui/events/event_55.png[/img]{Nie widzisz powodu, by przelewać krew biednych rolników, którzy tylko próbują żyć. Podając korony, ostrzegasz rolnika, by uważał, próbując takich układów.%SPEECH_ON%Nie każdy jest na tyle łaskawy, by z tobą się targować.%SPEECH_OFF%Rolnik odwraca głowę, odsłaniając długą bliznę biegnącą od skóry głowy po ramię.%SPEECH_ON%Dobrze to wiem. Dzięki za rozwagę, najemniku.%SPEECH_OFF% | Zabijasz rolników tylko wtedy, gdy ktoś ci za to zapłaci. %commander% tego nie zrobił. Zgadzasz się na warunki rolników. Ich przywódca ściska twoją dłoń.%SPEECH_ON%Dziękuję, najemniku. Rzadko spotyka się człowieka, który gotów jest ustąpić. Brałem cię za brutala, ale wyraźnie jesteś człowiekiem dużej rozwagi.%SPEECH_OFF% | Nie przybyłeś aż tutaj, by zarzynać biednych rolników. Zgadzasz się na warunki. Dziękuje ci za to, że nie przyszedłeś tu, by zarzynać biednych rolników. %randombrother% jednak cicho zauważa, że nie przyszedł tu po to, by... Głośno każesz mu zamknąć usta i zacząć ładować wozy.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Pośpieszmy się i wracajmy do obozu.",
					function getResult()
					{
						this.Flags.set("RequisitionSuccess", true);
						this.Contract.setState("Running_ReturnAfterRequisition");
						return 0;
					}

				}
			],
			function start()
			{
				this.World.Assets.addMoney(-this.Flags.get("RequisitionCost"));
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + this.Flags.get("RequisitionCost") + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "WarcampDay2",
			Title = "W obozie...",
			Text = "[img]gfx/ui/events/event_96.png[/img]{Poranne słońce wdziera się do namiotu, puszczając promień prosto przez twoje oczy, by dobitnie przypomnieć, że czeka cię nowy dzień. | Wstajesz i zakładasz buty, strząsając z nich pająki, które uznały je za miejsce nocnego odpoczynku. | Przed namiotem kogut głośno oznajmia wszystkim, jakim to jest paskudnym zwierzęciem. Niechętnie wstajesz. | Budzisz się na kolejny dzień. Świetnie. | Spałeś jak trup i budzisz się jak trup. Światło wpadające do namiotu jest zbyt oślepiające, by wrócić do snu, a płachty są za daleko, by je zasunąć. Do diabła z tym, wstaniesz. | Poranek. Ta nieunikniona pora, gdy tysiąc żalów przybywa w świetlistej poświacie nowego dnia.}\n\n Przed twoim namiotem stoi chłopak ze zwojem. Rozwija go i z trudem próbuje czytać.%SPEECH_ON%{Pa... pana do-do-dowódca za... zażądał... ee, lepiej niech pan sam do niego pójdzie. | %commander% ch-chce pana widzieć, on... on mówi, czekaj, że konie robią? Co? Słuchaj, nie umiem czytać. Po prostu idź do dowódcy. | Panie, tu na papierze jest, że pan... ee, powinien... eee, pójść do dowódcy. Jest tam więcej, ale bylibyśmy tu cały dzień, gdybym miał to kończyć. | No więc, ja tak naprawdę nie umiem czytać, ale chyba dowódca chce pana widzieć. | Zobaczmy, ta litera... znam tę literę... to litera "I", a reszta zdania to w zasadzie jedno wielkie: nie umiem czytać ani słowa z tego gówna. Słuchaj, po prostu idź do dowódcy. Chyba tego chce.}%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Czas odwiedzić dowódcę...",
					function getResult()
					{
						if (this.Flags.get("IsInterceptSupplies"))
						{
							return "InterceptSupplies";
						}
						else
						{
							return "Deserters1";
						}
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "InterceptSupplies",
			Title = "W obozie...",
			Text = "[img]gfx/ui/events/event_96.png[/img]Spotykasz się z %commander%em w jego namiocie. Wygląda na podekscytowanego. U jego boku stoi sprytny, skryty mężczyzna. Dowódca mówi pospiesznie.%SPEECH_ON%{Mój mały ptaszek doniósł, że transport wyposażenia zmierza do armii %feudfamily%. Jeśli go przechwycimy i zniszczymy, nie będą prawie wcale gotowi do walki! | Witaj, najemniku. Moi szpiedzy mówią, że %feudfamily% ma bardzo potrzebny transport sprzętu zmierzający do ich obozu. Musisz iść i go zniszczyć. | Czy szpiedzy nie są najlepsi? Spójrz na tego człowieczka. Mówi mi, panie, że %feudfamily% ma dużą dostawę towarów. Broń, zbroje, żywność i tak dalej. Cóż, mam idealnego człowieka, by to wykorzystać: ciebie! Idź i znajdź ten transport, a potem obróć go wniwecz. | Bitwy często wygrywa się, zanim w ogóle do nich dojdzie, wiesz? Mój szpieg mówi, że %feudfamily% ma transport broni i zbroi. Jeśli go zniszczysz, ich armia będzie znacznie gorzej przygotowana do walki na otwartym polu. | Wiesz, że kiedyś wygrałem bitwę, nie dobywając nawet miecza? Przechwyciłem transport, przez co wróg był zupełnie nieprzygotowany do walki, więc się poddał. Mój mały szpieg mówi, że %feudfamily% ma podobny transport wyposażenia. Nie sądzę, by to zakończyło wojnę, ale jeśli go zniszczysz, będzie to ogromna korzyść. | Wiesz, że armia bez wyposażenia to prawie żadna armia? Armii %feudfamily% brakuje zapasów. Właściwie nie atakują, bo czekają na dostawę broni i zbroi! A mój szpieg namierzył ten transport. Chcę, żebyś poszedł i go zniszczył. | Mam bardzo dobre wieści, najemniku. %feudfamily% czeka na dostawę broni i zbroi - i wiemy dokładnie, skąd nadchodzi. Potrzebuję tylko, byś zrobił oczywiste: zniszczył ten transport i osłabił wroga, zanim zorientuje się, co go uderzyło.}%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Kompania wyruszy niezwłocznie.",
					function getResult()
					{
						this.Contract.setState("Running_InterceptSupplies");
						return 0;
					}

				}
			],
			function start()
			{
				local startTile = this.World.getEntityByID(this.Flags.get("InterceptSuppliesStart")).getTile();
				local destTile = this.World.getEntityByID(this.Flags.get("InterceptSuppliesDest")).getTile();
				local enemyFaction = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse"));
				local party = enemyFaction.spawnEntity(startTile, "Karawana Zaopatrzeniowa", false, this.Const.World.Spawn.NobleCaravan, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.getSprite("base").Visible = false;
				party.getSprite("banner").setBrush(this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getBannerSmall());
				party.setMirrored(true);
				party.setVisibleInFogOfWar(true);
				party.setImportant(true);
				party.setDiscovered(true);
				party.setDescription("Karawana ze zbrojną eskortą, transportująca między osadami żywność, zapasy i wyposażenie.");
				party.setFootprintType(this.Const.World.FootprintsType.Caravan);
				party.getFlags().set("IsCaravan", true);
				party.setAttackableByAI(false);
				party.getFlags().add("ContractSupplies");
				this.Contract.m.Destination = this.WeakTableRef(party);
				this.Contract.m.UnitsSpawned.push(party);
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

				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local move = this.new("scripts/ai/world/orders/move_order");
				move.setDestination(destTile);
				move.setRoadsOnly(true);
				local despawn = this.new("scripts/ai/world/orders/despawn_order");
				c.addOrder(move);
				c.addOrder(despawn);
			}

		});
		this.m.Screens.push({
			ID = "SuppliesReachedEnemy",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_55.png[/img]{Nie udało ci się zniszczyć karawany. Oczywiście wszystkie jej dobra dotarły do armii %feudfamily%, co uczyni nadchodzące walki o wiele trudniejszymi. | Karawana nie została zniszczona. Możesz być pewien, że armia %feudfamily% będzie niemal w pełni sił przed wielką bitwą. | No to pięknie. Karawana nie została zniszczona. Teraz armia %feudfamily% będzie bardzo dobrze przygotowana do nadchodzącej bitwy.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Powinniśmy wrócić do obozu...",
					function getResult()
					{
						this.Contract.setState("Running_ReturnAfterIntercept");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SuppliesIntercepted",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Miałeś nadzieję, że zrabujesz z karawany, co się da, ale strażnicy podpalili wszystko, zanim można było to ukraść. Niefortunne, ale najważniejsze, że armia %feudfamily% nie dostała tego wyposażenia. | Zniszczyłeś znaczną część karawany, a resztę spalili strażnicy, by nie dopuścić, aby sprzęt wpadł w ręce wroga. %commander% będzie bardzo zadowolony z tych rezultatów. | Było ciężko, ale udało ci się wybić strażników karawany. Niestety oddział zastosował taktykę spalonej ziemi i spalił każdy wóz, zanim można go było przejąć. Wiedzieli, że nie mogą dopuścić, by sprzęt wpadł w ręce wroga. Mimo wszystko %commander% będzie bardzo zadowolony. | Strażnicy karawany postawili niezły opór, ale %companyname% wybija ich co do jednego. A przynajmniej tak ci się wydaje: podczas walki jeden ze strażników zdołał uciec i zastosować spaloną ziemię. Każdy wóz stanął w płomieniach. Oczywiście, jeśli %feudfamily% nie mogło dostać wyposażenia, to nikt nie mógł. Irytujące, ale sprytne. Tak czy inaczej, %commander% i jego ludzie docenią te wieści. | Karawana została zniszczona. Miałeś nadzieję przejąć wozy i zabrać sprzęt dla siebie, ale jeden ze strażników zdołał spalić je wszystkie, zapewne po to, by sprzęt nie trafił w ręce wroga. Tak czy inaczej, armia %feudfamily% z pewnością została osłabiona.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "O jeden problem mniej w nadchodzącej bitwie.",
					function getResult()
					{
						this.Contract.setState("Running_ReturnAfterIntercept");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Deserters1",
			Title = "W obozie...",
			Text = "[img]gfx/ui/events/event_96.png[/img]{Wchodzisz do namiotu %commander%a akurat na czas, by zobaczyć, jak świeca przelatuje obok twojej twarzy. Jej knot syczy w błocie, a chwilę później wylatuje stół, przewracając się wielokrotnie i rozrzucając mapy. Czerwony ze złości %commander% stoi pośród zniszczeń, z rękami na biodrach, ciężko oddychając, aż się opanowuje. Wyjaśnia.%SPEECH_ON%Dezerterzy! Zdezerterowali! W przeddzień najważniejszej bitwy mojego życia nie potrafię utrzymać przy sobie tych cholernych ludzi. Ta armia nie może się rozsypać. Musisz ich znaleźć i przyprowadzić z powrotem. Jeśli odmówią, cóż, zabij ich wszystkich. Jeden ze strażników powiedział, że widział ich, jak uciekali na %direction% stąd. Teraz ruszaj!%SPEECH_OFF% | Gdy masz wejść do namiotu %commander%a, ktoś wylatuje z niego. %commander% wypada za nim i wbija go w błoto. Chwyta go za kołnierz i podnosi jak szmacianą lalkę.%SPEECH_ON%Dokąd poszli? Przysięgam na starych bogów, że będziesz błagał o śmierć, jeśli nie odpowiesz szczerze!%SPEECH_OFF%Mężczyzna krzyczy i wskazuje.%SPEECH_ON%%direction%! Tam uciekli, przysięgam!%SPEECH_OFF%%commander% puszcza go, a strażnicy szybko odciągają. Dowódca prostuje się i przeczesuje włosy dłonią.%SPEECH_ON%Najemniku, kilku moich ludzi uznało, że lepiej zdezerterować. Znajdź ich. Przyprowadź z powrotem. Jasne?%SPEECH_OFF%Kiwając głową, pytasz, co jeśli odmówią. Dowódca wzrusza ramionami.%SPEECH_ON%Wyrżnij ich, oczywiście.%SPEECH_OFF% | Wchodzisz do namiotu %commander%a i widzisz, jak odsuwa się od siedzącego mężczyzny. Dowódca trzyma obcęgi, a między szczękami tkwi biały ząb. Zauważasz, że siedzący mężczyzna jest nieprzytomny, głowa mu opada, a krew kapie z ust. %commander% rzuca obcęgi na stół i przeczesuje zaczerwienioną dłonią włosy.%SPEECH_ON%Kilku moich ludzi zdezerterowało. Nie mogę ryzykować rozpadu armii, nie teraz, gdy bitwa jest tak blisko. Mój mały przyjaciel, póki jeszcze mówił, powiedział mi, że jego towarzysze uciekli na %direction% stąd. Idź, najemniku, i przyprowadź dezerterów z powrotem.%SPEECH_OFF%Zanim wyruszysz, pytasz, co zrobić, jeśli odmówią powrotu. Dowódca patrzy na ciebie spode łba.%SPEECH_ON%A jak myślisz? Zabij ich wszystkich!%SPEECH_OFF% | Zastajesz %commander%a zamyślonego nad mapami. Jego kostki bieleją na blacie, nogi stołu jęczą i chwieją się. Spogląda w górę. Jego oczy błyskają gwałtowną złością.%SPEECH_ON%Kilku moich ludzi uznało, że zdezerteruje. Strażnicy mówią, że widzieli ich, jak biegli na %direction% stąd. Idź i przyprowadź ich z powrotem.%SPEECH_OFF%Pytasz, czy chce ich żywych. Kiwając głową, odpowiada.%SPEECH_ON%Chcę ich żywych i zdrowych, żebym mógł lepiej przypomnieć im, co znaczy porzucić moją armię. Oczywiście, jeśli absolutnie odmówią, chcę ich martwych. To też dobra nauczka, by nie porzucać armii, zgadzasz się?%SPEECH_OFF% | %commander% przywiązał jednego z poruczników do słupa namiotu. Trzyma długi kij i uderza go w klatkę piersiową i nogi. Mężczyzna krzyczy, obraca się tylko po to, by dostać w plecy. Gdy porucznik znów się obraca, jego fioletowa twarz wciąga powietrze aż do omdlenia.\n\n %commander% rzuca kij i zaczyna wyciągać drzazgi z palców.%SPEECH_ON%Dobrze, że przyszedłeś, najemniku. Kilku moich ludzi zdezerterowało i musisz ich znaleźć. Przyprowadź ich żywych, a jeśli odmówią, zabij. Ten mój przyjaciel powiedział, że uciekli na %direction% stąd. Dla jego dobra mam nadzieję, że mówi prawdę.%SPEECH_OFF%Ty też masz taką nadzieję.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Kompania wyruszy w ciągu godziny.",
					function getResult()
					{
						this.Contract.setState("Running_Deserters");
						return 0;
					}

				}
			],
			function start()
			{
				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10, [
					this.Const.World.TerrainType.Shore,
					this.Const.World.TerrainType.Mountains
				]);
				local party = this.World.FactionManager.getFaction(this.Contract.getFaction()).spawnEntity(tile, "Dezerterzy", false, this.Const.World.Spawn.Noble, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.getSprite("banner").setBrush("banner_deserters");
				party.setFootprintType(this.Const.World.FootprintsType.Nobles);
				party.setAttackableByAI(false);
				party.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				party.setFootprintSizeOverride(0.75);
				this.Const.World.Common.addFootprintsFromTo(playerTile, party.getTile(), this.Const.GenericFootprints, this.Const.World.FootprintsType.Nobles, 0.75);
				this.Contract.m.Destination = this.WeakTableRef(party);
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

				local c = party.getController();
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(9000.0);
				c.addOrder(wait);
			}

		});
		this.m.Screens.push({
			ID = "Deserters2",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Natrafiasz na dezerterów siedzących przy tlącym się ognisku, jeden z nich rozpaczliwie zasypuje żar pyłem. Zatrzymuje się, gdy cię widzi. Reszta dezerterów podąża jego wzrokiem i zrywa się na nogi.%SPEECH_ON%Nie wracamy. Możesz powiedzieć %commander%owi, że niech się piekli.%SPEECH_OFF% | Dezerterzy kłócą się między sobą, gdy wpadasz na ich małą imprezę uciekinierów. Jeden z mężczyzn odskakuje.%SPEECH_ON%%commander% cię przysłał, prawda? No to powiedz mu, że niech się piekli.%SPEECH_OFF%Inny mężczyzna zaciska pięść.%SPEECH_ON%Tak, nie wracamy!%SPEECH_OFF%To bez wątpienia niepokorna banda. | %randombrother% wskazuje grupę mężczyzn stojących przy drogowskazie. Kłócą się tak głośno, że nie słyszą twojego podejścia. Wydajesz ostry gwizd, który jednocześnie ich ucisza i obraca. Jeden cofa się.%SPEECH_ON%Ten szczurzy dowódca wysłał za nami najemników?%SPEECH_OFF%Kiwasz głową i wyjaśniasz, że powinni z tobą wrócić. Inny dezerter kręci głową.%SPEECH_ON%Wrócić? A może wy sobie stąd pójdziecie? Nie wracamy, więc powiedz dowódcy właśnie to.%SPEECH_OFF% | Zastajesz dezerterów dzielących się jedzeniem z wełnianego worka. Przerywają na twój widok, a jeden próbuje połknąć jedzenie w całości. Dusi się. Reszta nie rusza się. Duszący się miota się po pomoc, twarz robi mu się purpurowa. Nogi miotają się nad workiem, kopiąc jedzenie wszędzie. Kiwasz głową.%SPEECH_ON%Pomóżcie mu.%SPEECH_OFF%Dezerterzy szybko biegną do duszącego się i wybijają jedzenie z jego gardła. Łapie oddech. Zaczynasz tłumaczyć, o co prosił %commander%, ale jeden z dezerterów przerywa.%SPEECH_ON%Nie. Nie wracamy. Ta wojna to strata czasu i nie chcemy w tym udziału.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Tym chcecie być? Tchórzami, którzy nie obronią własnych ziem?",
					function getResult()
					{
						return this.Math.rand(1, 100) <= 50 ? "DesertersAcceptMotivation" : "DesertersRefuseMotivation";
					}

				},
				{
					Text = "Wasz wybór jest prosty. Walczyć dla waszego lorda, albo umrzeć tutaj.",
					function getResult()
					{
						return this.Math.rand(1, 100) <= 50 ? "DesertersAcceptThreats" : "DesertersRefuseThreats";
					}

				},
				{
					Text = "Wszyscy wiemy o co tu chodzi. Oto %bribe% koron, jeśli wrócicie.",
					function getResult()
					{
						return "DesertersAcceptBribe";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "DesertersAcceptBribe",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Wyjmujesz sakiewkę i wsypujesz do niej %bribe% koron.%SPEECH_ON%Zapłacę wam osobiście, byście wrócili ze mną do obozu. %commander% jest na was wściekły, to jasne, ale potrzebuje każdego człowieka, jakiego może dostać. Jeśli będziecie walczyć po jego stronie w nadchodzącej bitwie, nie wątpię, że wybaczy wam ten mały błąd.%SPEECH_OFF% | Oferujesz dezerterom %bribe% koron. Mężczyźni spoglądają na siebie, po czym odpowiadają.%SPEECH_ON%A co nam po pieniądzach, kiedy dowódca powiesi nas wszystkich?%SPEECH_OFF%Kiwasz głową i odpowiadasz.%SPEECH_ON%Dobre pytanie, ale %commander% nie jest głupcem. Potrzebuje wszystkich ludzi, jakich zdoła zebrać na nadchodzącą bitwę. Udowodnijcie się w tej walce, a ta wasza żałosna impreza litości zostanie zapomniana.%SPEECH_OFF%}{Dezerterzy rozważają opcje i w końcu zgadzają się wrócić z tobą. | Dezerterzy zbierają się i dochodzą do porozumienia. Gdy się rozchodzą, ich przywódca robi krok naprzód.%SPEECH_ON%Pomimo pewnych zastrzeżeń zgadzamy się wrócić z tobą do obozu. Mam nadzieję, że tego nie pożałuję.%SPEECH_OFF% | Po krótkiej naradzie dezerterzy poddają sprawę pod głosowanie. Nie jest jednomyślne, ale dochodzą do porozumienia: wrócą z tobą do %commander%a. | Dezerterzy kłócą się, co robić dalej. Nieuchronnie kończy się to głosowaniem. Przewidywalnie głosy rozkładają się po równo. Uzgadniają rzut monetą: orzeł - wracają do obozu, reszka - odchodzą. Ich przywódca rzuca monetą, a wszyscy obserwują, jak się obraca i połyskuje. Moneta spada orłem. Każdy z nich wzdycha na ten widok, jakby los i fortuna zdjęły z ich barków ogromną odpowiedzialność.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To powino nam pomóc w nadchodzącej bitwie.",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						this.Contract.setState("Running_ReturnAfterIntercept");
						return 0;
					}

				}
			],
			function start()
			{
				this.World.Assets.addMoney(-this.Flags.get("Bribe"));
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + this.Flags.get("Bribe") + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "DesertersAcceptThreats",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_88.png[/img]{%bigdog% robi krok naprzód, z łatwością obracając broń za ramię. Kiwając głową, mówi.%SPEECH_ON%Boi się %commander%a. Rozumiem. Znasz go, znasz jego temperament i wiesz, do czego jest zdolny. Pytanie brzmi...%SPEECH_OFF%Najemnik uśmiecha się chytrze, a uśmiech odbija się w połysku ostrza.%SPEECH_ON%A czy znasz mnie?%SPEECH_OFF% | Dezerterzy wyglądają, jakby mieli zaraz odejść, gdy %bigdog% głośno gwiżdże.%SPEECH_ON%Hej, wy gnoje, mój dowódca wydał wam rozkaz.%SPEECH_OFF%Jeden z dezerterów prycha.%SPEECH_ON%Tak? To nie nasz cholerny dowódca, więc możesz ten rozkaz wsadzić sobie w dupę.%SPEECH_OFF%%bigdog% dobywa ogromnego ostrza i wbija je w ziemię. Składa dłonie na głowicy.%SPEECH_ON%Boi się %commander%a i to w porządku. Ale jeśli będziesz dalej zachowywać się jak mały gnojek, przyjacielu, to zobaczymy, którego dowódcy naprawdę powinieneś się bać.%SPEECH_OFF% | Dezerterzy odwracają się, by odejść. %bigdog% wyjmuje wielkie ostrze i uderza nim o zbroję. Powoli dezerterzy odwracają się z powrotem. %bigdog% się uśmiecha.%SPEECH_ON%Któryś z was kiedyś narobił w gacie?%SPEECH_OFF%Jeden z dezerterów kręci głową.%SPEECH_ON%E-ej, stary, przestań pierdolić.%SPEECH_OFF%%bigdog% chwyta ostrze i wskazuje czubkiem na dezertera.%SPEECH_ON%Chcesz, żebym się zamknął? Mów do mnie jeszcze takim tonem, a niedługo nikt tu nie będzie mówił.%SPEECH_OFF%}{Dezerterzy rozważają opcje i w końcu zgadzają się wrócić z tobą. | Dezerterzy zbierają się i dochodzą do porozumienia. Gdy się rozchodzą, ich przywódca robi krok naprzód.%SPEECH_ON%Pomimo pewnych zastrzeżeń zgadzamy się wrócić z tobą do obozu. Mam nadzieję, że tego nie pożałuję.%SPEECH_OFF% | Po krótkiej naradzie dezerterzy poddają sprawę pod głosowanie. Nie jest jednomyślne, ale dochodzą do porozumienia: wrócą z tobą do %commander%a. | Dezerterzy kłócą się, co robić dalej. Nieuchronnie kończy się to głosowaniem. Przewidywalnie głosy rozkładają się po równo. Uzgadniają rzut monetą: orzeł - wracają do obozu, reszka - odchodzą. Ich przywódca rzuca monetą, a wszyscy obserwują, jak się obraca i połyskuje. Moneta spada orłem. Każdy z nich wzdycha na ten widok, jakby los i fortuna zdjęły z ich barków ogromną odpowiedzialność.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Słuszna decyzja.",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						this.Contract.m.Dude = null;
						this.Contract.setState("Running_ReturnAfterIntercept");
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local candidates = [];

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.player"))
					{
						continue;
					}

					if (bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.brute") || bro.getBackground().getID() == "background.raider" || bro.getBackground().getID() == "background.sellsword" || bro.getBackground().getID() == "background.hedge_knight" || bro.getBackground().getID() == "background.brawler")
					{
						candidates.push(bro);
					}
				}

				if (candidates.len() == 0)
				{
					candidates = brothers;
				}

				this.Contract.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "DesertersAcceptMotivation",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Gdy dezerterzy odchodzą, %motivator% robi krok naprzód i odchrząkuje.%SPEECH_ON%No i tak to ma wyglądać, co? Wykręcicie się z obowiązków jak banda flaków? Wiem, co czujecie. Wiem, że nie widzicie sensu tej wojny ani ryzykowania życia dla nadętego szlachcica, który nie ma pojęcia, przez co przechodzicie. To uczciwe. Ale obudzicie się kiedyś za wiele lat, bujając wnuka na kolanie, a on zapyta was o czasy wojny. I będziecie musieli okłamać tego małego chłopca.%SPEECH_OFF% | %motivator% przykłada palce do ust i gwiżdże ostro. Dezerterzy odwracają się, gdy zaczyna mówić.%SPEECH_ON%No i co, tak ma być? Zamierzasz celowo obarczyć się tym brzemieniem? A co powiesz swoim maluchom, gdy nadejdzie czas, hm? Że byłeś żałosnym dezerterem, który zostawił towarzyszy na śmierć? I nie łudź się, twoja nieobecność spowoduje śmierć tych, którzy nie powinni umrzeć. Twojego braku nie da się zlekceważyć!%SPEECH_OFF% | %motivator% woła do dezerterów.%SPEECH_ON%Dobra, więc odchodzicie. Rzucacie sztandar i kończycie kampanię. A co się stanie, gdy %feudfamily% wygra, co?%SPEECH_OFF%Jeden z dezerterów wzrusza ramionami.%SPEECH_ON%Nie znają mnie. Wrócę do rodziny i na farmę.%SPEECH_OFF%Śmiejąc się, %motivator% kręci głową.%SPEECH_ON%Tak? A co zrobisz, gdy ci obcy przyjdą na twoje włości? Gdy zobaczą twoją żonę? Gdy zobaczą twoje dzieci? O co, dokładnie, toczy się ta wojna? Nie będzie domu, do którego wrócisz, głupcze!%SPEECH_OFF%}{Dezerterzy rozważają opcje i w końcu zgadzają się wrócić z tobą. | Dezerterzy zbierają się i dochodzą do porozumienia. Gdy się rozchodzą, ich przywódca robi krok naprzód.%SPEECH_ON%Pomimo pewnych zastrzeżeń zgadzamy się wrócić z tobą do obozu. Mam nadzieję, że tego nie pożałuję.%SPEECH_OFF% | Po krótkiej naradzie dezerterzy poddają sprawę pod głosowanie. Nie jest jednomyślne, ale dochodzą do porozumienia: wrócą z tobą do %commander%a. | Dezerterzy kłócą się, co robić dalej. Nieuchronnie kończy się to głosowaniem. Przewidywalnie głosy rozkładają się po równo. Uzgadniają rzut monetą: orzeł - wracają do obozu, reszka - odchodzą. Ich przywódca rzuca monetą, a wszyscy obserwują, jak się obraca i połyskuje. Moneta spada orłem. Każdy z nich wzdycha na ten widok, jakby los i fortuna zdjęły z ich barków ogromną odpowiedzialność.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Słuszna decyzja.",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						this.Contract.m.Dude = null;
						this.Contract.setState("Running_ReturnAfterIntercept");
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local highest_bravery = 0;
				local best;

				foreach( bro in brothers )
				{
					if (bro.getCurrentProperties().getBravery() > highest_bravery)
					{
						best = bro;
					}
				}

				this.Contract.m.Dude = best;
				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "DesertersRefuseThreats",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_88.png[/img]{%bigdog% robi krok naprzód, z łatwością obracając broń za ramię. Kiwając głową, mówi.%SPEECH_ON%Boi się %commander%a. Rozumiem. Znasz go, znasz jego temperament i wiesz, do czego jest zdolny. Pytanie brzmi...%SPEECH_OFF%Najemnik uśmiecha się chytrze, a uśmiech odbija się w połysku ostrza.%SPEECH_ON%A czy znasz mnie?%SPEECH_OFF% | Dezerterzy wyglądają, jakby mieli zaraz odejść, gdy %bigdog% głośno gwiżdże.%SPEECH_ON%Hej, wy gnoje, mój dowódca wydał wam rozkaz.%SPEECH_OFF%Jeden z dezerterów prycha.%SPEECH_ON%Tak? To nie nasz cholerny dowódca, więc możesz ten rozkaz wsadzić sobie w dupę.%SPEECH_OFF%%bigdog% dobywa ogromnego ostrza i wbija je w ziemię. Składa dłonie na głowicy.%SPEECH_ON%Boi się %commander%a i to w porządku. Ale jeśli będziesz dalej zachowywać się jak mały gnojek, przyjacielu, to zobaczymy, którego dowódcy naprawdę powinieneś się bać.%SPEECH_OFF% | Dezerterzy odwracają się, by odejść. %bigdog% wyjmuje wielkie ostrze i uderza nim o zbroję. Powoli dezerterzy odwracają się z powrotem. %bigdog% się uśmiecha.%SPEECH_ON%Któryś z was kiedyś narobił w gacie?%SPEECH_OFF%Jeden z dezerterów kręci głową.%SPEECH_ON%E-ej, stary, przestań pierdolić.%SPEECH_OFF%%bigdog% chwyta ostrze i wskazuje czubkiem na dezertera.%SPEECH_ON%Chcesz, żebym się zamknął? Mów do mnie jeszcze takim tonem, a niedługo nikt tu nie będzie mówił.%SPEECH_OFF%}{Dezerterzy nie potrafią się zdecydować i głosują. Opcja dalszej ucieczki ma większość. Ich przywódca informuje cię o demokratycznym wyniku i żegna się. %commander% nie będzie zadowolony, ale dobywasz miecza i mówisz ludziom, że jest tylko jedna droga. Przywódca obraca się, dobywa ostrza i kiwa głową.%SPEECH_ON%Dobra, domyśliłem się, że nie przyszedłeś tu tylko po to, by usłyszeć nasze pożegnania. Do broni, ludzie.%SPEECH_OFF% | %commander% będzie wściekły, ale dezerterzy odmawiają powrotu. Nie widzą powodu, by wracać do walki. Życzysz ich przywódcy powodzenia. Dziękuje ci, ale szybko milknie, gdy dobywasz broni, a reszta %companyname% robi to samo. Przywódca wzdycha.%SPEECH_ON%Tak, myślałem, że tak to się skończy.%SPEECH_OFF%Kiwasz głową.%SPEECH_ON%Nic osobistego. Nie obchodzi mnie, co zrobicie, ale tu chodzi o interes i musimy go dokończyć.%SPEECH_OFF% | Dezerterzy nie potrafią podjąć decyzji, więc zdają się na los: ich przywódca wyciąga monetę i rzuca w powietrze. Orzeł - wracają do obozu, reszka - dalej uciekają. Wypada reszka. Dezerterzy zbiorowo wzdychają z ulgą. Przywódca klepie cię po ramieniu.%SPEECH_ON%Los zadecydował o naszych losach.%SPEECH_OFF%Kiwasz głową i dobywasz miecza, a reszta kompanii robi to samo.%SPEECH_ON%Pamiętaj o tym, gdy będziemy was wszystkich zabijać.%SPEECH_OFF%Przywódca słabo się uśmiecha, dobywając ostrza.%SPEECH_ON%W porządku. Wolelibyśmy umrzeć u progu wolności niż wrócić do tej mordęgi.%SPEECH_OFF% | Przywódca grzecznie odmawia powrotu.%SPEECH_ON%Nie wybraliśmy tej drogi lekko, najemniku. Nie wracamy.%SPEECH_OFF%Rozkazujesz %companyname% dobyć broni. Przywódca dezerterów wzdycha, ale kiwa ze zrozumieniem.%SPEECH_ON%Chyba tak to już jest. Rozmawialiśmy o tym i jesteśmy gotowi umrzeć tutaj, idąc, gdzie chcemy, niż ginąć tam na rozkaz jakiegoś psa. To teraz cały nasz świat.%SPEECH_OFF%Wzruszasz ramionami i odpowiadasz.%SPEECH_ON%Dla nas to tylko interes.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Miejmy to już za sobą...",
					function getResult()
					{
						this.Contract.m.Dude = null;
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos(), true);
						p.CombatID = "Deserters";
						p.Music = this.Const.Music.CivilianTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.TemporaryEnemies = [
							this.Contract.getFaction()
						];
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							"banner_deserters"
						];
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local candidates = [];

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.player"))
					{
						continue;
					}

					if (bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.brute") || bro.getBackground().getID() == "background.raider" || bro.getBackground().getID() == "background.sellsword" || bro.getBackground().getID() == "background.hedge_knight" || bro.getBackground().getID() == "background.brawler")
					{
						candidates.push(bro);
					}
				}

				if (candidates.len() == 0)
				{
					candidates = brothers;
				}

				this.Contract.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "DesertersRefuseMotivation",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Gdy dezerterzy odchodzą, %motivator% robi krok naprzód i odchrząkuje.%SPEECH_ON%No i tak to ma wyglądać, co? Wykręcicie się z obowiązków jak banda flaków? Wiem, co czujecie. Wiem, że nie widzicie sensu tej wojny ani ryzykowania życia dla nadętego szlachcica, który nie ma pojęcia, przez co przechodzicie. To uczciwe. Ale obudzicie się kiedyś za wiele lat, bujając wnuka na kolanie, a on zapyta was o czasy wojny. I będziecie musieli okłamać tego małego chłopca.%SPEECH_OFF% | %motivator% przykłada palce do ust i gwiżdże ostro. Dezerterzy odwracają się, gdy zaczyna mówić.%SPEECH_ON%No i co, tak ma być? Zamierzasz celowo obarczyć się tym brzemieniem? A co powiesz swoim maluchom, gdy nadejdzie czas, hm? Że byłeś żałosnym dezerterem, który zostawił towarzyszy na śmierć? I nie łudź się, twoja nieobecność spowoduje śmierć tych, którzy nie powinni umrzeć. Twojego braku nie da się zlekceważyć!%SPEECH_OFF% | %motivator% woła do dezerterów.%SPEECH_ON%Dobra, więc odchodzicie. Rzucacie sztandar i kończycie kampanię. A co się stanie, gdy %feudfamily% wygra, co?%SPEECH_OFF%Jeden z dezerterów wzrusza ramionami.%SPEECH_ON%Nie znają mnie. Wrócę do rodziny i na farmę.%SPEECH_OFF%Śmiejąc się, %motivator% kręci głową.%SPEECH_ON%Tak? A co zrobisz, gdy ci obcy przyjdą na twoje włości? Gdy zobaczą twoją żonę? Gdy zobaczą twoje dzieci? O co, dokładnie, toczy się ta wojna? Nie będzie domu, do którego wrócisz, głupcze!%SPEECH_OFF%}{Dezerterzy nie potrafią się zdecydować i głosują. Opcja dalszej ucieczki ma większość. Ich przywódca informuje cię o demokratycznym wyniku i żegna się. %commander% nie będzie zadowolony, ale dobywasz miecza i mówisz ludziom, że jest tylko jedna droga. Przywódca obraca się, dobywa ostrza i kiwa głową.%SPEECH_ON%Dobra, domyśliłem się, że nie przyszedłeś tu tylko po to, by usłyszeć nasze pożegnania. Do broni, ludzie.%SPEECH_OFF% | %commander% będzie wściekły, ale dezerterzy odmawiają powrotu. Nie widzą powodu, by wracać do walki. Życzysz ich przywódcy powodzenia. Dziękuje ci, ale szybko milknie, gdy dobywasz broni, a reszta %companyname% robi to samo. Przywódca wzdycha.%SPEECH_ON%Tak, myślałem, że tak to się skończy.%SPEECH_OFF%Kiwasz głową.%SPEECH_ON%Nic osobistego. Nie obchodzi mnie, co zrobicie, ale tu chodzi o interes i musimy go dokończyć.%SPEECH_OFF% | Dezerterzy nie potrafią podjąć decyzji, więc zdają się na los: ich przywódca wyciąga monetę i rzuca w powietrze. Orzeł - wracają do obozu, reszka - dalej uciekają. Wypada reszka. Dezerterzy zbiorowo wzdychają z ulgą. Przywódca klepie cię po ramieniu.%SPEECH_ON%Los zadecydował o naszych losach.%SPEECH_OFF%Kiwasz głową i dobywasz miecza, a reszta kompanii robi to samo.%SPEECH_ON%Pamiętaj o tym, gdy będziemy was wszystkich zabijać.%SPEECH_OFF%Przywódca słabo się uśmiecha, dobywając ostrza.%SPEECH_ON%W porządku. Wolelibyśmy umrzeć u progu wolności niż wrócić do tej mordęgi.%SPEECH_OFF% | Przywódca grzecznie odmawia powrotu.%SPEECH_ON%Nie wybraliśmy tej drogi lekko, najemniku. Nie wracamy.%SPEECH_OFF%Rozkazujesz %companyname% dobyć broni. Przywódca dezerterów wzdycha, ale kiwa ze zrozumieniem.%SPEECH_ON%Chyba tak to już jest. Rozmawialiśmy o tym i jesteśmy gotowi umrzeć tutaj, idąc, gdzie chcemy, niż ginąć tam na rozkaz jakiegoś psa. To teraz cały nasz świat.%SPEECH_OFF%Wzruszasz ramionami i odpowiadasz.%SPEECH_ON%Dla nas to tylko interes.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Miejmy to już za sobą...",
					function getResult()
					{
						this.Contract.m.Dude = null;
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos(), true);
						p.CombatID = "Deserters";
						p.Music = this.Const.Music.CivilianTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.TemporaryEnemies = [
							this.Contract.getFaction()
						];
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							"banner_deserters"
						];
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local highest_bravery = 0;
				local best;

				foreach( bro in brothers )
				{
					if (bro.getCurrentProperties().getBravery() > highest_bravery)
					{
						best = bro;
					}
				}

				this.Contract.m.Dude = best;
				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "DesertersAftermath",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{%randombrother% czyści ostrze o tabard jednego z trupów.%SPEECH_ON%Szkoda, że skończyli tak. Mogli żyć. Mieli wybór.%SPEECH_OFF%Wzruszasz ramionami i odpowiadasz.%SPEECH_ON%Ze wszystkich stron mieli śmierć. Po prostu wybrali nas na katów.%SPEECH_OFF% | Dezerterzy leżą martwi wokół ciebie. Jeden pełznie po ziemi, starając się oddalić od armii %commander%a. Kucasz obok niego z sztyletem w dłoni, by dokończyć sprawę. Śmieje się z ciebie.%SPEECH_ON%Nie trzeba brudzić sztyletu, najemniku. Daj mi tylko czas. Tylko to m-mi zostało, au.%SPEECH_OFF%Strużka krwi spływa mu po brodzie. Oczy mu się zwężają, patrzy prosto przed siebie i powoli osuwa się na ziemię. Wstajesz i każesz kompanii przygotować się do drogi. | Ostatni dezerter opiera się o głaz, ręce zwisają mu bezwładnie po bokach, dłonie są odwrócone jak u żebraka. Krew spływa mu po klatce i nogach, gromadząc się na ziemi. Wpatruje się w nią.%SPEECH_ON%W porządku, dzięki za troskę, najemniku.%SPEECH_OFF%Mówisz mu, że nic nie powiedziałeś. Spogląda na ciebie z autentycznym zdziwieniem.%SPEECH_ON%Nie powiedziałeś? No to cóż.%SPEECH_OFF%Chwilę później osuwa się na bok, twarz zastyga w martwym grymasie. | Niektórzy ludzie upodobali sobie groteskę skazanego życia. Gdy odbierze im się wszelki wybór i wolność, cóż innego można zrobić, jak nie śmiać się w twarz okrutnemu losowi? Każdy dezerter umierał z wyrazem absolutnego opanowania na twarzy. | Ostatni żywy dezerter wpatruje się w niebo. Macha dłonią w powietrzu.%SPEECH_ON%Cholera, chciałbym tylko zobaczyć jednego.%SPEECH_OFF%Pytasz, co chce zobaczyć. Śmieje się, serdeczny chichot szybko przerywa fala bólu.%SPEECH_ON%Ptaka. O, tam jest. Taki duży, taki piękny.%SPEECH_OFF%Wskazuje palcem i patrzysz w górę. Nad wami krąży sęp. Kiedy znów spoglądasz w dół, mężczyzna już nie żyje.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To było niefortunne, acz konieczne.",
					function getResult()
					{
						this.Contract.setState("Running_ReturnAfterIntercept");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WarcampDay2End",
			Title = "W obozie...",
			Text = "[img]gfx/ui/events/event_96.png[/img]{%commander% informuje cię, że jutro jest wielki dzień. Wracasz do namiotu na zasłużony odpoczynek. | Wracasz do %commander%a i przekazujesz mu wieści. Jest wyraźnie stłumiony, myślami pochłonięty tym, co nadchodzi jutro: wielką, rozstrzygającą bitwą. Dzień dobiega końca, więc postanawiasz się położyć i czekać na świt. | Składasz raport %commander%owi, ale ledwo reaguje. Żyje praktycznie nad swoimi mapami.%SPEECH_ON%Do zobaczenia jutro, najemniku. Dobrze wypocznij, bo będzie ci to potrzebne.%SPEECH_OFF% | %commander% wita cię w swoim namiocie, ale zdaje się ignorować twoje raporty. Zamiast tego skupia się na mapach i prowadzi z porucznikami dyskusje o jutrzejszych planach. Postanawiasz położyć się i porządnie wypocząć. | %commander% kiwa głową na twoje raporty, ale poza tym nie zwraca na ciebie większej uwagi. Na stole leży masa map, a jego wzrok skupia się właśnie na nich. Rozumiesz: jutro wielka bitwa i ma lepsze rzeczy do przemyślenia. Postanawiasz położyć się na noc.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Dobrze wypocznijcie tej nocy, bo jutro czeka nas bitwa!",
					function getResult()
					{
						this.Flags.set("LastDay", this.World.getTime().Days);
						this.Flags.set("NextDay", 3);
						this.Contract.setState("Running_WaitForNextDay");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WarcampDay3",
			Title = "W obozie...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{%commander% przechadza się przed zebranymi żołnierzami. Niektórzy stoją znużeni, nieprzespawszy nocy. Inni wciąż drżą z nerwów. Dowódca woła do nich.%SPEECH_ON%Boicie się? Strach was bierze? W porządku. Martwiłbym się, gdyby tak nie było.%SPEECH_OFF%Rozsiane śmiechy poprawiają nastrój. Kontynuuje.%SPEECH_ON%Ale teraz proszę was, byście nie bali się o własną skórę, tylko o życie waszych rodaków, waszych rodzin! To dla nich walczymy tego dnia! O siebie zatroszczymy się jutro, dziś będziemy mężczyznami!%SPEECH_OFF%Śmiech przechodzi w ryk wiwatów. | %commander% zgromadził ludzi przed sobą. Piechota, łucznicy, rezerwy, wszyscy stoją w ostrym wietrze. Dowódca mierzy ich wzrokiem.%SPEECH_ON%Wiem, o czym myślicie: "Co ja robię, walcząc dla tego nędznika? Skoro jest taki szlachetny, gdzie jego rumak?"%SPEECH_OFF%Żołnierze śmieją się, napięcie opada. %commander% kontynuuje.%SPEECH_ON%Cóż, brzydal czy nie, nic nie lubię bardziej niż dobrej walki. I tam właśnie będę, ludzie. Będę z wami, walcząc, aż nie będę mógł, walcząc do samego końca, bo to właśnie robi wojownik!%SPEECH_OFF%Żołnierze unoszą ręce i wiwatują. Dowódca odwraca się z podniesionym mieczem.%SPEECH_ON%Za mną, a pokażemy %feudfamily%, co znaczy być mężczyzną!%SPEECH_OFF% | Zbieranina armii %commander%a zjednoczyła się na wielką bitwę. Przechadzając się wzdłuż linii, dowódca zaczyna przemowę.%SPEECH_ON%Widzę, że wielu z was wygląda na niewyspanych. Co, nerwy? Ja też! Nie zmrużyłem oka.%SPEECH_OFF%To rozluźnia część ludzi. Dobrze wiedzieć, że nie jest się samemu, ciałem ani duchem. Kontynuuje.%SPEECH_ON%Ale dziś jestem obudzony, dla tej walki. Nie opuściłbym jej za żadne skarby. Więc przetrzyjcie oczy, ludzie, bo dziś pokażemy tym skurczybykom z %feudfamily%, że powinni byli zostać w łóżkach!%SPEECH_OFF% | %commander% przemawia do szykujących się ludzi. Ty nie słuchasz ani słowa. Zamiast tego przygotowujesz swoich ludzi do nadchodzącej walki. | Patrzysz, jak %commander% podchodzi do swoich ludzi i sypie inspirującymi hasłami. Wiele z nich słyszałeś już wcześniej. Czy te słowa pochodzą z jakiegoś starego zwoju? Z mowy motywacyjnej, której energia przechodzi z pokolenia na pokolenie? %randombrother% podchodzi do ciebie, chichocząc.%SPEECH_ON%Wiem, że dowódca mówi puste hasła, a jednak mam ochotę zrobić parę pompek.%SPEECH_OFF%Śmiejąc się, każesz mu ustawić się w szyku razem z resztą kompanii. Odpowiada uszczypliwie.%SPEECH_ON%Będzie przemowa?%SPEECH_OFF%Popychasz go, gdy odchodzi śmiejąc się. | %commander% chodzi wzdłuż linii. Zatrzymuje się przy chłopaku, który trzęsie się tak mocno, że jego zbroja grzechocze.%SPEECH_ON%Przypominasz mi mnie samego, chłopcze. Myślisz, że nie byłem na twoim miejscu? Heh, wyluzuj, bo kiedyś możesz być tam, gdzie ja.%SPEECH_OFF%Chłopak spogląda w górę z nowym błyskiem w oku. Prostuje się i kiwa zdecydowanie. Dowódca podnosi głos, nakazując przygotowania do bitwy życia. | %commander% krąży wśród ludzi, krzycząc, że ta bitwa jest najważniejszym wydarzeniem, jakie kiedykolwiek przeżyją. Nie jesteś tego pewien, ale wiesz, że dla wielu będzie to ostatnie doświadczenie w życiu. Okrucieństwa wojny nie są najlepszą motywacją, więc trzymasz język za zębami. | Zaciskasz buty, gdy %commander% szykuje ludzi wielką, pompatyczną przemową o doniosłości wojny między rodami. Jest bardzo przekonująca. Musi być, jeśli ludzie, którzy nie mają nic do zyskania, mają za nią umierać. | %commander% staje przed swoimi ludźmi. Ubrany w okazałe szaty bojowe, góruje nad nimi jak perła pośród piasku. Wyjaśnia, że muszą wygrać bitwę, bo przegrana może oznaczać przegraną całej wojny. Mówi wszystko, byle tylko przekonać ludzi, myślisz. Ty z pewnością nie oddałbyś życia za delikatną szlachtę tylko dlatego, że jakiś żądny honoru dowódca wywróżył to z duchów polityki. Z drugiej strony, to właśnie dlatego jesteś najemnikiem. | Wojna to piekielna rzecz. Jak sprzedać ją człowiekowi? %commander% robi, co może, rozprawiając na rozmaite tematy. Najpierw mówi, że to honorowy obowiązek. Potem, że jest tu wielu żołnierzy, co zwiększa szanse, że zginie ktoś inny zamiast ciebie. Siła w liczbach! Na koniec twierdzi, że przegranie tej bitwy może oznaczać utratę żon, dzieci i kraju. Ten argument działa najlepiej, bo żołnierze ryczą z gniewu i energii. Wśród wiwatującego tłumu łatwo dostrzec cyników i rozpustników. | %commander% przemawia do ludzi głębokim, silnym głosem.%SPEECH_ON%Och, widzę, że niektórzy z was aż kipią z radości. Nie możecie doczekać się, by wyrżnąć ludzi %feudfamily%, co? Znam to uczucie.%SPEECH_OFF%Kilka nerwowych śmiechów. Dowódca kontynuuje.%SPEECH_ON%Pamiętajcie o swoich rodzinach, ludzie, bo to na nas dziś liczą!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Naprzód, bracia, mamy bitwę do wygrania!",
					function getResult()
					{
						this.Contract.setState("Running_FinalBattle");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BattleLost",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_86.png[/img]{Wszędzie leżą martwe ciała. Sylwetka %commander%a na stosie trupów, jego zbroja połyskuje, lśniąca powłoka na ruinie z mięsa. %employer% bez wątpienia będzie zasmucony przegraną bitwą, ale nic więcej nie da się zrobić. | Bitwa przegrana! Ludzie %commander%a zostali wybici, zostało tylko kilku ocalałych, a sam dowódca poległ. Sępy już krążą nad głową, a ludzie %feudfamily% metodycznie przeszukują sterty ciał, by dobić każdego, kto udaje martwego. Szybko zbierasz resztki %companyname% do odwrotu. %employer% bez wątpienia będzie przerażony tym wynikiem, ale teraz nic już nie da się zrobić.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nie każdą bitwę da się wygrać...",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Przegrałeś ważną bitwę");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BattleWon",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_87.png[/img]{Zwyciężyłeś! Cóż, ty i ludzie %commander%a. Bitwa została wygrana, i to jest najważniejsze. Przechodzisz przez sterty ciał, szykując się do powrotu do swojego pracodawcy. | Trupy ułożone piętrowo. Sępy wyjadają kąski ze stosów. Ranni błagają o pomoc. Dla obcego oka nie widać tu zwycięzcy. %commander% jednak podchodzi z szerokim uśmiechem.%SPEECH_ON%{Dobra robota, najemniku! Wracaj do swojego pracodawcy i powiedz mu, co tu się stało. | A więc to ty, najemniku. Nie byłem pewien, czy dotrzesz. Wracaj do pracodawcy i powiedz mu, co się stało.}%SPEECH_OFF% | Ranny mężczyzna błaga u twoich stóp. Nie wiesz, czy to jeden z %commander%a, czy wróg. Nagle ostrze włóczni wylatuje i przebija go przez głowę, zostawiając go z wykrzywionym spojrzeniem. Spoglądasz, by zobaczyć zabójcę, który opiera dłonie o włócznię z zadowoleniem na twarzy. Wskazuje palcem.%SPEECH_ON%Ty jesteś tym najemnikiem, prawda? %commander% kazał mi powiedzieć, żebyś wrócił do pracodawcy. Zgadza się?%SPEECH_OFF%Kiwasz głową. Z kup trupów dobiega jęk. Mężczyzna podnosi włócznię, chwytając ją w drugą dłoń.%SPEECH_ON%Cóż, do roboty!%SPEECH_OFF% | Po bitwie zastajesz %commander%a ryczącego i zrywającego z siebie zbroję i przeszywanicę. Pokazuje rany, napinając mięśnie, by otwierały się jak świeżo rozcięte owoce. Żąda, by jego ludzie zrobili to samo, obracając każdego, by zobaczyć ich plecy.%SPEECH_ON%Widzicie, dobrzy wojownicy jak my noszą rany tu, tu i tu...%SPEECH_OFF%Wskazuje każde miejsce na przodzie ciała, po czym wskazuje plecy.%SPEECH_ON%Ale tu nikt nie nosi ran. Bo umieramy, idąc naprzód, ani kroku wstecz! Prawda?%SPEECH_OFF%Ludzie wiwatują, choć niektórzy chwieją się na nogach, krew sączy im się z ran. Ignorujesz teatr i zbierasz ludzi z %companyname%. Twój pracodawca na pewno ucieszy się z wieści i to jedyne, co cię naprawdę obchodzi. | %commander% wita cię po bitwie. Jest skąpany we krwi, jakby odciął komuś głowę i wykąpał się w bryzgającej fontannie. Gdy się uśmiecha, błyszczą białe zęby.%SPEECH_ON%To właśnie nazywam walką.%SPEECH_OFF%Pytasz, czy powiedziałby to samo, gdyby przegrał. Śmieje się.%SPEECH_ON%Och, cynik? Nie, nie zamierzałem tu przegrać, a gdybym przegrał, nie zamierzałem żyć, by oglądać własną porażkę.%SPEECH_OFF%Kiwasz głową i odpowiadasz.%SPEECH_ON%Rzadki jest człowiek, który może oglądać swoją największą porażkę. Dobrze walczyło się z tobą, dowódco, ale muszę wracać do pracodawcy.%SPEECH_OFF%Dowódca kiwa głową i woła, by ktoś przyniósł mu ręcznik. | Zastajesz %commander%a kucającego nad rannym wrogiem. Przesuwa sztylet po klatce piersiowej biedaka, tam i z powrotem, skrobiąc pancerz. Dowódca spogląda na ciebie.%SPEECH_ON%Co sądzisz, najemniku? Mam go oszczędzić?%SPEECH_OFF%Więzień wpatruje się w ciebie, wysuwa głowę, mruga mocno. Zakładasz, że to "tak". Wzruszasz ramionami.%SPEECH_ON%To nie moja decyzja. Dobrze walczyło się z tobą, ale muszę wracać do pracodawcy.%SPEECH_OFF%%commander% kiwa głową.%SPEECH_ON%Do zobaczenia zatem.%SPEECH_OFF%Gdy odchodzisz, dowódca wciąż kuli się obok więźnia, a ostrze dźwięczy tam i z powrotem, tam i z powrotem. | Zastajesz %commander%a wbijającego sztylet w bok klatki piersiowej rannego. Ranny szarpie się z bólu, ale po chwili wiotczeje. Strumień krwi wypływa po wyjęciu ostrza, gdy dowódca wyciera je o nogawkę.%SPEECH_ON%Prosto w serce, szybko i łatwo. Czego więcej może chcieć człowiek?%SPEECH_OFF%Kiwasz głową i mówisz dowódcy, że wracasz do pracodawcy po zapłatę. | Patrzysz, jak %commander% i oddział żołnierzy krążą po polu bitwy, dobijając każdego rannego wroga, którego znajdą. %randombrother% pyta, czy mamy zameldować się dowódcy. Kręcisz głową.%SPEECH_ON%Nie. Meldujemy się pracodawcy. Do diabła z tym miejscem, idziemy po zapłatę.%SPEECH_OFF% | Pole bitwy jest usłane zmarłymi i tymi, którzy życzyliby sobie być martwi. Ludzie %commander%a zbierają rannych i dobijają wrogów, których znajdują. Sam dowódca klepie cię po ramieniu, a kropla krwi pryska ci na policzek.%SPEECH_ON%Dobra robota, najemniku. Nie byłem pewien, czy twoi ludzie dotrzymają swojej części umowy, ale zrobiliście to, i to jak. Twój pracodawca powinien być bardzo zadowolony, jak sądzę.%SPEECH_OFF% | Zbierasz ludzi z %companyname%. %commander% podchodzi, wycierając miecz szmatą, z krwi spływają gęste strużki.%SPEECH_ON%Tak szybko odchodzicie?%SPEECH_OFF%Kiwasz głową.%SPEECH_ON%To pracodawca nam płaci, więc do niego idziemy.%SPEECH_OFF%Dowódca chowa broń i kiwa głową.%SPEECH_ON%Ma sens. Dobrze się z tobą walczyło, najemniku. Szkoda, że nie mogłem mieć was w mojej kompanii. Chyba musicie dalej gonić za monetą, co?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zwycięstwo!",
					function getResult()
					{
						local faction = this.World.FactionManager.getFaction(this.Contract.getFaction());
						local settlements = faction.getSettlements();
						local origin = settlements[this.Math.rand(0, settlements.len() - 1)];
						local party = faction.spawnEntity(this.World.State.getPlayer().getTile(), "Kompania " + origin.getName(), true, this.Const.World.Spawn.Noble, 150);
						party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + faction.getBannerString());
						party.setDescription("Profesjonalni żołdacy na usługach miejscowych lordów.");
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Zastajesz %employer%a pijanego jak bela. Patrzy na ciebie znad krawędzi kubka i mówi do jego wnętrza, zanim pije.%SPEECH_ON%A niech to, wróciłeś.%SPEECH_OFF%Kubek opada, gdy przełyka. Szybko zdajesz raport z sukcesu. Mężczyzna uśmiecha się, choć jest tak pijany, że wygląda na zdezorientowanego.%SPEECH_ON%A więc dokonane. Zwycięstwo jest moje. Tego chciałem. Mam nadzieję, że nie zginęło zbyt wielu, robiąc to, czego chciałem.%SPEECH_OFF%Wybuja śmiechem. Jeden ze strażników podaje ci sakiewkę i wyprowadza z pokoju. | %employer% wita cię z sakiewką koron.%SPEECH_ON%{Zwycięstwo jest nasze. Dziękuję, najemniku. | Świetna robota, najemniku. Zwycięstwo należy do nas i w części tobie je zawdzięczamy. Twoje %reward_completion% koron jest tutaj. | Ile to było, %reward_completion% koron? Niewielka cena za pokonanie tej armii i przybliżenie nas o krok do zakończenia wojny. | Moi mali ptaszkowie mówili, że spisałeś się świetnie, najemniku. Mówią też, że armia %feudfamily% jest w odwrocie. Czego więcej mógłbym chcieć? Twoje %reward_completion% koron, jak obiecano.}%SPEECH_OFF% | Zastajesz %employer%a szczekającego rozkazy do dowódców. Widząc cię, szybko wskazuje na ciebie.%SPEECH_ON%Widzicie tego człowieka? To człowiek, który doprowadza sprawy do końca. Straże! Dajcie mu %reward_completion% koron. Gdybym tylko mógł wam, nędzne psy, płacić za połowę tego, co zrobił on!%SPEECH_OFF% | %employer% opowiada dowcipy grupie kobiet w ogrodzie. Wpadasz do ich grupy, cały we krwi i błocie. Kobiety sapną i cofają się. %employer% śmieje się.%SPEECH_ON%Ach, najemnik wraca! Ale z ciebie amant, najemniku. Chciałbym oddać ci jedną z tych pięknych kobiet, ale obawiam się, że ich ojcowie urwaliby ci jaja, gdybyś je choć musnął.%SPEECH_OFF%Jedna z dam przesuwa dłoń po biuście.%SPEECH_ON%Może mnie dotknąć, jeśli chce.%SPEECH_OFF%%employer% śmieje się znowu.%SPEECH_ON%Ojej, czy już nie narobiłaś dość kłopotów mężczyznom? Idźcie, panie, i powiedzcie jednemu z moich strażników, by przyniósł sakiewkę %reward_completion% koron.%SPEECH_OFF% | Zastajesz %employer%a próbującego nauczyć kota podawania łapy.%SPEECH_ON%Spójrz na tego małego łobuza. Nawet nie chce na mnie spojrzeć! A gdy go karmię, zachowuje się, jakby mu się to należało. Mógłbym kopnąć tego małego skurczybyka przez to cholerne okno, gdybym chciał.%SPEECH_OFF%Odpowiadasz.%SPEECH_ON%Wylądowałby na łapach.%SPEECH_OFF%Szlachcic kiwa głową.%SPEECH_ON%To w tym wszystkim najdziwniejsze.%SPEECH_OFF%%employer% podnosi wytrzymałego kota i wyrzuca go przez okno. Klaszcze w dłonie, po czym podaje ci sakiewkę %reward_completion% koron.%SPEECH_ON%Wybacz, jeśli wydaję się zajęty. Dobrze się spisałeś. Armia %feudfamily% jest w odwrocie i nie mógłbym dziś chcieć więcej.%SPEECH_OFF% | Zastajesz %employer%a podczas improwizowanego sądu nad jednym z dowódców. Nie wiesz, o co chodzi, ale dowódca trzyma brodę wysoko i jest butny. Gdy wszystko się kończy, zostaje poturbowany i wyprowadzony na zewnątrz. %employer% przywołuje cię gestem.%SPEECH_ON%{Dziękuję, najemniku. Zwycięstwo jest nasze i nie jestem pewien, czy byłoby możliwe bez twojej pomocy. Oczywiście twoja nagroda, %reward_completion% koron, jak uzgodniono. | Ten człowiek odmówił moich rozkazów, bywa. Ty jednak spisałeś się wzorowo! Twoje %reward_completion% koron, jak uzgodniono. | Ten człowiek nie chciał dla mnie walczyć. Powiedział, że nie podniesie miecza na przyrodniego brata, który walczy po stronie wroga. Co za bzdura. Dobrze się spisałeś, najemniku. Twoje %reward_completion% koron, jak obiecano.}%SPEECH_OFF% | Wracasz do %employer%a, który stoi pośród szeregu dowódców.%SPEECH_ON%{Dziękuję, najemniku. Zwycięstwo należy teraz do nas. Twoje %reward_completion% koron, jak uzgodniono. | Wojna trwa, ale koniec może być bliski dzięki tobie. Z wrogą armią w pełnym odwrocie jesteśmy o krok bliżej, by raz na zawsze zakończyć to cholerstwo. Twoje %reward_completion% koron to zasłużona zapłata, najemniku.}%SPEECH_OFF% | Jeden ze strażników %employer%a powstrzymuje cię przed zbliżeniem się. Niesie sakiewkę %reward_completion% koron, którą szybko ci przekazuje.%SPEECH_ON%Mój pan mówi, że dobrze spisałeś się w bitwie.%SPEECH_OFF%Strażnik rozgląda się niezręcznie.%SPEECH_ON%To... to wszystko, co miałem powiedzieć.%SPEECH_OFF% | %employer% wita cię w sali wojennej, z której usunął dowódców.%SPEECH_ON%Dobrze cię widzieć, najemniku. Jak zapewne wiesz, armia %feudfamily% jest już w odwrocie. Kto wie, czy zdołalibyśmy to bez ciebie. %reward_completion% koron tylko dla ciebie, jak uzgodniono.%SPEECH_OFF% | %employer% karmi wysokiego, głupawo wyglądającego ptaka. Nigdy nie widziałeś ptaka takich rozmiarów, więc trzymasz dystans. Rozbawiony szlachcic mówi, pozwalając mu jeść z dłoni.%SPEECH_ON%Nie ma się czego bać, najemniku. Na wypadek, gdybyś nie wiedział, mam już wieści o twoich czynach. Armia %feudfamily% jest w odwrocie, więc jesteśmy coraz bliżej zakończenia tej przeklętej wojny. Tamten strażnik, trzymający sakiewkę, ma twoje %reward_completion% koron.%SPEECH_OFF%Ptak trzepocze skrzydłami i skrzeczy, gdy odchodzisz. | Zastajesz %employer%a nad sztucznym stawem. Delikatnie wyławia żaby. Śliskie stworzenia wyślizgują się i uciekają.%SPEECH_ON%Zwycięstwo należy do nas. Powiedziałbym, że to robota dobrze wykonana, najemniku. Dałem ci wielką szansę i naprawdę... wskoczyłeś w nią.%SPEECH_OFF%Najpewniej skrzywiłeś się widocznie, bo szlachcic szybko wstaje, wycierając ręce o spodnie.%SPEECH_ON%Do diabła, to nie było takie złe, prawda? Tamten strażnik ma twoją wypłatę %reward_completion% koron.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Wygrałeś ważną bitwę");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isCivilWar())
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

	function onCommanderPlaced( _entity, _tag )
	{
		_entity.setName(this.m.Flags.get("CommanderName"));
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noblehouse",
			this.World.FactionManager.getFaction(this.getFaction()).getName()
		]);
		_vars.push([
			"feudfamily",
			this.World.FactionManager.getFaction(this.m.Flags.get("EnemyNobleHouse")).getName()
		]);
		_vars.push([
			"commander",
			this.m.Flags.get("CommanderName")
		]);
		_vars.push([
			"objective",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.m.Destination.getName()
		]);
		_vars.push([
			"cost",
			this.m.Flags.get("RequisitionCost")
		]);
		_vars.push([
			"bribe",
			this.m.Flags.get("Bribe")
		]);

		if (this.m.Flags.get("IsInterceptSupplies"))
		{
			_vars.push([
				"supply_start",
				this.World.getEntityByID(this.m.Flags.get("InterceptSuppliesStart")).getName()
			]);
			_vars.push([
				"supply_dest",
				this.World.getEntityByID(this.m.Flags.get("InterceptSuppliesDest")).getName()
			]);
		}

		if (this.m.Dude != null)
		{
			_vars.push([
				"bigdog",
				this.m.Dude.getName()
			]);
			_vars.push([
				"motivator",
				this.m.Dude.getName()
			]);
		}

		if (this.m.Destination == null)
		{
			_vars.push([
				"direction",
				this.m.WarcampTile == null ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.WarcampTile)]
			]);
		}
		else
		{
			_vars.push([
				"direction",
				this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Destination.getTile())]
			]);
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
			}

			if (this.m.Warcamp != null && !this.m.Warcamp.isNull())
			{
				this.m.Warcamp.die();
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return false;
		}

		return true;
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

		if (this.m.Warcamp != null && !this.m.Warcamp.isNull())
		{
			_out.writeU32(this.m.Warcamp.getID());
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

		local warcamp = _in.readU32();

		if (warcamp != 0)
		{
			this.m.Warcamp = this.WeakTableRef(this.World.getEntityByID(warcamp));
		}

		this.contract.onDeserialize(_in);
	}

});

