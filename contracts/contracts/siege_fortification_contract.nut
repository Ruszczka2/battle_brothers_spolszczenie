this.siege_fortification_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Allies = []
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

		this.m.Type = "contract.siege_fortification";
		this.m.Name = "Umocnienie Oblężenia";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.m.MakeAllSpawnsResetOrdersOnContractEnd = false;
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

		this.m.Flags.set("ObjectiveName", this.m.Origin.getName());
		this.m.Flags.set("RivalHouseID", this.m.Origin.getOwner().getID());
		this.m.Flags.set("RivalHouse", this.m.Origin.getOwner().getName());
		this.m.Flags.set("WaitUntil", 0.0);
		this.m.Name = "Oblężenie " + this.m.Origin.getName();
		this.m.Flags.set("CommanderName", this.Const.Strings.KnightNames[this.Math.rand(0, this.Const.Strings.KnightNames.len() - 1)]);
		this.m.Payment.Pool = 1550 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Udaj się do %objective% na %direction%",
					"Pomóż przy oblężeniu"
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
				this.Contract.m.Origin.getOwner().addPlayerRelation(-99.0, "Opowiedziałeś się po jednej ze stron w wojnie");
				local r = this.Math.rand(1, 100);

				if (r <= 50)
				{
					this.Flags.set("IsTakingAction", true);
					local r = this.Math.rand(1, 100);

					if (r <= 50)
					{
						this.Flags.set("IsAssaultTheGate", true);
					}
					else if (r <= 80)
					{
						this.Flags.set("IsBurnTheCastle", true);
					}
					else
					{
						this.Flags.set("IsPlayerDecision", true);
					}
				}
				else
				{
					this.Flags.set("IsMaintainingSiege", true);
					r = this.Math.rand(1, 100);

					if (r <= 25)
					{
						this.Flags.set("IsNighttimeEncounter", true);
					}
					else
					{
						this.Flags.set("IsReliefAttack", true);
						r = this.Math.rand(1, 100);

						if (r <= 40)
						{
							this.Flags.set("IsSurrender", true);
						}
						else
						{
							this.Flags.set("IsDefendersSallyForth", true);
						}
					}
				}

				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					if (!this.Flags.get("IsSecretPassage") && !this.Flags.get("IsSurrender"))
					{
						this.Flags.set("IsPrisoners", true);
					}
				}

				this.Contract.spawnSiege();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
					this.Contract.m.Origin.setLastSpawnTimeToNow();
				}
			}

			function update()
			{
				if (this.Contract.isPlayerNear(this.Contract.m.Origin, 300))
				{
					this.Contract.setScreen("TheSiege");
					this.World.Contracts.showActiveContract();

					foreach( a in this.Contract.m.Allies )
					{
						local ally = this.World.getEntityByID(a);

						if (ally != null)
						{
							ally.setAttackableByAI(true);
						}
					}
				}
			}

		});
		this.m.States.push({
			ID = "Running_Wait",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Utrzymaj oblężenie %objective%",
					"Przechwyć każdego, kto spróbuje się przekraść"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.m.Origin.getDistanceTo(this.World.State.getPlayer()) >= 800)
				{
					this.Contract.setScreen("TooFarAway");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Time.getVirtualTimeF() < this.Flags.get("WaitUntil"))
				{
					return;
				}

				this.Contract.m.Origin.getOwner().addPlayerRelation(-99.0, "Opowiedziałeś się po jednej ze stron w wojnie");

				foreach( i, a in this.Contract.m.Allies )
				{
					local ally = this.World.getEntityByID(a);

					if (ally == null || !ally.isAlive())
					{
						this.Contract.m.Allies.remove(i);
					}
				}

				if (this.Contract.isPlayerNear(this.Contract.m.Origin, 300))
				{
					if (this.Flags.get("IsReliefAttackForced"))
					{
						if (this.World.getTime().IsDaytime)
						{
							this.Contract.setScreen("ReliefAttack");
							this.World.Contracts.showActiveContract();
						}
					}
					else if (this.Flags.get("IsSurrenderForced"))
					{
						this.Contract.setScreen("Surrender");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsDefendersSallyForthForced"))
					{
						this.Contract.setScreen("DefendersSallyForth");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsTakingAction"))
					{
						if (this.World.getTime().IsDaytime)
						{
							if (this.Flags.get("IsPlayerDecision"))
							{
								this.Contract.setScreen("TakingAction");
								this.World.Contracts.showActiveContract();
							}
							else
							{
								this.Contract.setState("Running_TakingAction");
							}
						}
					}
					else if (this.Flags.get("IsMaintainingSiege"))
					{
						this.Contract.setScreen("MaintainSiege");
						this.World.Contracts.showActiveContract();
					}
				}
			}

		});
		this.m.States.push({
			ID = "Running_TakingAction",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Weź udział w szturmie na %objective%"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.m.Origin.getDistanceTo(this.World.State.getPlayer()) >= 800)
				{
					this.Contract.setScreen("TooFarAway");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Time.getVirtualTimeF() < this.Flags.get("WaitUntil"))
				{
					return;
				}

				if (this.Flags.get("IsLost"))
				{
					this.Contract.setScreen("Failure");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAssaultTheGate") && !this.TempFlags.get("AssaultTheGateShown"))
				{
					this.TempFlags.set("AssaultTheGateShown", true);
					this.Contract.setScreen("AssaultTheGate");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAssaultAftermath"))
				{
					this.Contract.setScreen("AssaultAftermath");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAssaultTheCourtyard") && !this.TempFlags.get("AssaultTheCourtyardShown"))
				{
					this.TempFlags.set("AssaultTheCourtyardShown", true);
					this.Contract.setScreen("AssaultTheCourtyard");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsBurnTheCastleAftermath"))
				{
					this.Contract.setScreen("BurnTheCastleAftermath");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsBurnTheCastle") && !this.TempFlags.get("BurnTheCastleShown"))
				{
					this.TempFlags.set("BurnTheCastleShown", true);
					this.Contract.setScreen("BurnTheCastle");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					foreach( i, a in this.Contract.m.Allies )
					{
						local ally = this.World.getEntityByID(a);

						if (ally == null || !ally.isAlive())
						{
							this.Contract.m.Allies.remove(i);
						}
					}

					if (this.Contract.m.Allies.len() == 0)
					{
						this.Contract.setScreen("Failure");
						this.World.Contracts.showActiveContract();
						return;
					}
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "AssaultTheGate")
				{
					this.Flags.set("IsAssaultTheGate", false);
					this.Flags.set("IsAssaultTheCourtyard", true);
				}
				else if (_combatID == "AssaultTheCourtyard")
				{
					this.Flags.set("IsAssaultTheCourtyard", false);
					this.Flags.set("IsAssaultAftermath", true);
				}
				else if (_combatID == "BurnTheCastle")
				{
					this.Flags.set("IsBurnTheCastle", false);
					this.Flags.set("IsBurnTheCastleAftermath", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "AssaultTheGates" || _combatID == "AssaultTheCourtyard" || _combatID == "BurnTheCastle")
				{
					this.Flags.set("IsLost", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_NighttimeEncounter",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Utrzymaj oblężenie %objective%",
					"Przechwyć każdego, kto spróbuje się przekraść"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.m.Origin.getDistanceTo(this.World.State.getPlayer()) >= 800)
				{
					this.Contract.setScreen("TooFarAway");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Time.getVirtualTimeF() < this.Flags.get("WaitUntil") || this.World.getTime().IsDaytime)
				{
					return;
				}

				if (this.Flags.get("IsNighttimeEncounterLost"))
				{
					this.Contract.setScreen("NighttimeEncounterFail");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsNighttimeEncounterAfermath"))
				{
					this.Contract.setScreen("NighttimeEncounterAftermath");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsNighttimeEncounter") && !this.TempFlags.get("NighttimeEncounterShown"))
				{
					if (!this.World.getTime().IsDaytime)
					{
						this.TempFlags.set("NighttimeEncounterShown", true);
						this.Contract.setScreen("NighttimeEncounter");
						this.World.Contracts.showActiveContract();
					}
				}
				else
				{
					foreach( i, a in this.Contract.m.Allies )
					{
						local ally = this.World.getEntityByID(a);

						if (ally == null || !ally.isAlive())
						{
							this.Contract.m.Allies.remove(i);
						}
					}

					if (this.Contract.m.Allies.len() == 0)
					{
						this.Contract.setScreen("Failure");
						this.World.Contracts.showActiveContract();
						return;
					}
				}
			}

			function onActorRetreated( _actor, _combatID )
			{
				if (!_actor.isPlayerControlled())
				{
					this.Flags.set("IsNighttimeEncounterLost", true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "NighttimeEncounter")
				{
					this.Flags.set("IsNighttimeEncounter", false);

					if (!this.Flags.get("IsNighttimeEncounterLost"))
					{
						this.Flags.set("IsNighttimeEncounterAfermath", true);
					}
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "NighttimeEncounter")
				{
					this.Flags.set("IsNighttimeEncounterLost", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_SecretPassage",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Przekradnij się do %objective%, nim noc się skończy",
					"Zabij dowódcę wrogów"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
					this.Contract.m.Origin.setOnCombatWithPlayerCallback(this.onSneakIn.bindenv(this));
					this.Contract.m.Origin.setAttackable(true);
				}
			}

			function end()
			{
				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.setOnCombatWithPlayerCallback(null);
					this.Contract.m.Origin.setAttackable(false);
				}
			}

			function update()
			{
				if (this.Flags.get("IsSecretPassageWin"))
				{
					this.Contract.setScreen("SecretPassageAftermath");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsSecretPassageLost"))
				{
					this.Contract.setScreen("SecretPassageFail");
					this.World.Contracts.showActiveContract();
				}
				else if (this.World.getTime().IsDaytime)
				{
					this.Contract.setScreen("FailedToReturn");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					foreach( i, a in this.Contract.m.Allies )
					{
						local ally = this.World.getEntityByID(a);

						if (ally == null || !ally.isAlive())
						{
							this.Contract.m.Allies.remove(i);
						}
					}

					if (this.Contract.m.Allies.len() == 0)
					{
						this.Contract.setScreen("Failure");
						this.World.Contracts.showActiveContract();
						return;
					}
				}
			}

			function onSneakIn( _dest, _isPlayerAttacking = true )
			{
				if (!this.TempFlags.get("IsSecretPassageShown"))
				{
					this.TempFlags.set("IsSecretPassageShown", true);
					this.Contract.setScreen("SecretPassage");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "SecretPassage";
					p.Music = this.Const.Music.NobleTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
					this.Contract.flattenTerrain(p);
					p.Entities = [];
					p.EnemyBanners = [
						this.Contract.m.Origin.getOwner().getBannerSmall()
					];
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.m.Origin.getOwner().getID());
					p.Entities.push({
						ID = this.Const.EntityType.Knight,
						Variant = 0,
						Row = 2,
						Script = "scripts/entity/tactical/humans/knight",
						Faction = this.Contract.m.Origin.getOwner().getID(),
						Callback = this.onEnemyCommanderPlaced
					});
					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
			}

			function onEnemyCommanderPlaced( _entity, _tag )
			{
				_entity.getFlags().set("IsFinalBoss", true);
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getFlags().get("IsFinalBoss") == true)
				{
					this.Flags.set("IsSecretPassageWin", true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "SecretPassage")
				{
					this.Flags.set("IsSecretPassageWin", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "SecretPassage" && !this.Flags.get("IsSecretPassageWin"))
				{
					this.Flags.set("IsSecretPassageFail", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_ReliefAttack",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Utrzymaj oblężenie %objective%",
					"Przechwyć każdego, kto spróbuje się przekraść"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.m.Origin.getDistanceTo(this.World.State.getPlayer()) >= 800)
				{
					this.Contract.setScreen("TooFarAway");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Flags.get("IsReliefAttackLost"))
				{
					this.Contract.setScreen("Failure");
					this.World.Contracts.showActiveContract();
					return;
				}

				local isAlive = false;

				foreach( id in this.Contract.m.UnitsSpawned )
				{
					local e = this.World.getEntityByID(id);

					if (e != null && e.isAlive() && e.getFaction() == this.Contract.m.Origin.getOwner().getID())
					{
						isAlive = true;

						if (e.getDistanceTo(this.Contract.m.Origin) <= 250)
						{
							this.onCombatWithPlayer(e, false);
							return;
						}
					}
				}

				if (this.Flags.get("IsReliefAttackWon") || !isAlive)
				{
					this.Contract.setScreen("ReliefAttackAftermath");
					this.World.Contracts.showActiveContract();
					return;
				}

				foreach( i, a in this.Contract.m.Allies )
				{
					local ally = this.World.getEntityByID(a);

					if (ally == null || !ally.isAlive())
					{
						this.Contract.m.Allies.remove(i);
					}
				}

				if (this.Contract.m.Allies.len() == 0)
				{
					this.Contract.setScreen("Failure");
					this.World.Contracts.showActiveContract();
					return;
				}
			}

			function onCombatWithPlayer( _dest, _isPlayerAttacking = true )
			{
				_dest.setPos(this.World.State.getPlayer().getPos());
				local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
				p.CombatID = "ReliefAttack";
				p.Music = this.Const.Music.NobleTracks;
				p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
				p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
				p.AllyBanners.push(this.World.FactionManager.getFaction(this.Contract.getFaction()).getBannerSmall());
				p.EnemyBanners.push(_dest.getBanner());
				this.Contract.flattenTerrain(p);
				local alliesIncluded = false;

				for( local i = 0; i < p.Entities.len(); i = i )
				{
					if (this.World.FactionManager.isAlliedWithPlayer(p.Entities[i].Faction))
					{
						alliesIncluded = true;
					}

					i = ++i;
				}

				if (!alliesIncluded && _dest.getDistanceTo(this.Contract.m.Origin) <= 400)
				{
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());

					foreach( id in this.Contract.m.UnitsSpawned )
					{
						local e = this.World.getEntityByID(id);

						if (e.isAlliedWithPlayer())
						{
							e.die();
							break;
						}
					}
				}

				this.World.Contracts.startScriptedCombat(p, false, true, true);
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "ReliefAttack")
				{
					this.Flags.set("IsReliefAttackWon", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "ReliefAttack")
				{
					this.Flags.set("IsReliefAttackLost", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_DefendersSallyForth",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Utrzymaj oblężenie %objective%",
					"Przechwyć każdego, kto spróbuje się przekraść"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.m.Origin.getDistanceTo(this.World.State.getPlayer()) >= 800)
				{
					this.Contract.setScreen("TooFarAway");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Flags.get("IsDefendersSallyForthLost"))
				{
					this.Contract.setScreen("DefendersPrevail");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsDefendersSallyForthWon"))
				{
					this.Contract.setScreen("DefendersAftermath");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.Contract.m.Origin.getOwner().addPlayerRelation(-99.0, "Opowiedziałeś się po jednej ze stron w wojnie");
					this.Contract.setScreen("DefendersSallyForth");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "DefendersSallyForth")
				{
					this.Flags.set("IsDefendersSallyForthWon", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "DefendersSallyForth")
				{
					this.Flags.set("IsDefendersSallyForthLost", true);
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

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = false;
				}

				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + 5.0);
			}

			function update()
			{
				if (this.Flags.get("IsPrisoners") && this.Time.getVirtualTimeF() <= this.Flags.get("WaitUntil"))
				{
					this.Contract.setScreen("Prisoners");
					this.World.Contracts.showActiveContract();
				}

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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% wita cię w swojej komnacie. Na biurku leży rozłożona mapa. Usiana jest wojskowymi drobiazgami, małymi drewnianymi emblematami, które mają przedstawiać armie poruszające się po świecie ogarniętym wojną. Szlachcic wskazuje jedno z nich.%SPEECH_ON%Potrzebuję, żebyś poszedł tutaj i porozmawiał z %commander%. Oblęża tamte umocnienia i potrzebuje twojej pomocy, by sfinalizować szturm. Zapłacę ci %reward% koron, co powinno w zupełności wystarczyć, prawda?%SPEECH_OFF% | Wchodzisz do sali wojennej %employer%a i zapada nagła cisza wśród tłumu generałów i dowódców pochylonych nad mapami bitew. %employer% macha na ciebie i prowadzi na bok. Wojskowi patrzą na ciebie wrogo, po czym powoli wracają do swoich rozmów strategicznych. %employer% wyjaśnia sytuację.%SPEECH_ON%Dowódca %commander% oblega umocnienia w %objective%. Potrzebuje kilku dodatkowych ludzi, by rozpocząć szturm, i tu wchodzisz ty. Idź tam, pomóż mu, a ja zapłacę ci więcej niż wystarczające %reward% koron. Uczciwie, prawda?%SPEECH_OFF% | Zanim wejdziesz do komnaty %employer%a, ten wyskakuje i chwyta cię za ramię. Prowadzi cię korytarzem do okna, mówiąc, gdy patrzy na dziedziniec.%SPEECH_ON%Moi generałowie nie muszą cię widzieć. Nie widzą honoru w twoim rzemiośle. Czasem przy zatrudnianiu najemników potrzebna jest odrobina politycznej ogłady.%SPEECH_OFF%Kręcisz głową i odpowiadasz krótko.%SPEECH_ON%Zabijamy tak samo jak oni.%SPEECH_OFF%Szlachcic kiwa głową.%SPEECH_ON%Oczywiście, najemniku, ale być może w przyszłości to ty będziesz zabijał nas. Moi generałowie nie śpią po nocach, jedni ze strachu, inni ze złości. Rozumiem realia świata, w którym żyjemy, więc śpię jak niemowlę, rozumiesz? Róbmy interesy. Potrzebuję, żebyś poszedł do %objective% i pomógł dowódcy %commander% w szturmie na te umocnienia. Za swoją pracę otrzymasz %reward% koron.%SPEECH_OFF% | %employer% spotyka się z tobą i prowadzi do ogrodu. Biorąc pod uwagę okoliczności, wydaje się dziwnie spokojny. Skubie winorośl pomidorów i zaczyna mówić.%SPEECH_ON%Wojna to piekielna rzecz. Ludzie umierają, bo wypowiedziałem kilka słów. Tak po prostu. Nie chcę nadużywać swojej władzy.%SPEECH_OFF%Zaczepiasz kciuki o pas i odpowiadasz.%SPEECH_ON%Dla dobra moich ludzi, mam nadzieję, że nie nadużyjesz.%SPEECH_OFF%%employer% kiwa głową i zrywa pomidora. Winorośl napina się i pęka. Bierze kęs, znów kiwa głową, jakby wolał życie ogrodnika.%SPEECH_ON%Mam dowódcę o imieniu %commander%, który obecnie oblega %objective%. Dopina plany szturmu. Wiem, że to słowo może cię straszyć, ale pracuje nad tym planem od dłuższego czasu. Potrzebuje już tylko kilku ludzi, by wszystko zadziałało bez zarzutu. Idź do niego, pomóż mu, a ja zapłacę ci %reward% koron.%SPEECH_OFF% | %employer% wita cię i prowadzi do jednej z map bitewnych. Wskazuje na %objective%.%SPEECH_ON%Dowódca %commander% oblega tamte umocnienia. Potrzebuję solidnych ludzi, by pomogli mu rozpocząć szturm. Idź tam, pomóż mu, a ja zapłacę ci %reward% koron. Brzmi dobrze, prawda?%SPEECH_OFF% | Gdy wchodzisz do komnaty %employer%a, widzisz gromadę dowódców stojących nad mapą. Małe żetony szlachty rozsiane są po papierze. Jeden z mężczyzn popycha drewnianego konia po byle jak narysowanych równinach. %employer% wita cię, ale jeden z jego generałów odciąga cię na bok i wyjaśnia, czego potrzebują: \n\nDowódca %commander% prowadzi oblężenie w %objective%. Obrońcy są bliscy załamania, ale obawia się, że nadciąga odsiecz. Chce przypuścić ostateczny szturm, zanim nadejdzie pomoc. Idź tam, pomóż dowódcy w tym, czego potrzebuje, a otrzymasz %reward% koron. | Stajesz przed drzwiami %employer%a i pytasz siebie: czy naprawdę potrzebujesz tego całego syfu w życiu? Nagle sługa wpada na ciebie z kufrem koron. Pyta, czy %employer% jest w środku, bo %reward% korony są gotowe do przekazania najemnikowi. Szybko wyprzedzasz sługę i wchodzisz do pokoju. %employer% wita cię ciepło. Wyjaśnia, że dowódca %commander% oblega %objective% i jest bliski przełomu. Potrzebuje jeszcze kilku ludzi, by przepchnąć sprawy przez próg. %employer% udaje, że się zastanawia, po czym dodaje.%SPEECH_ON%Będzie z tego %reward% koron.%SPEECH_OFF%Udajesz zaskoczenie tą kwotą. | Nie jesteś pewien, czy wojna idzie po myśli %employer%a, czy też jego generałowie zawsze wyglądają tak zestresowani. Wyglądają, jakby woleli nadziać się na własne miecze, niż spędzić kolejną chwilę nad mapą bitwy. %employer% siedzi w rogu komnaty obok ognia, a sługa trzyma dzban wina. Szlachcic macha na ciebie i zaczyna mówić.%SPEECH_ON%Nie przejmuj się marudami. Wojna idzie dobrze. Wszystko jest dobrze. Żeby to udowodnić, potrzebuję, byś poszedł do dowódcy %commander% w %objective%, bo jego oblężenie tych przeklętych umocnień ma się ku końcowi. Zwycięstwo jest blisko i wystarczy, że mi w tym pomożesz! Jak brzmi %reward% koron?%SPEECH_OFF% | Wchodzisz do komnaty %employer%a i widzisz szlachcica zapadniętego w wygodnym fotelu. Dwa duże psy drzemią u jego stóp, a na kolanach mruczy kot. Jest kompletnie odcięty, chrapie głośno, a z wyciągniętej dłoni zwisa kielich. Mężczyzna w stroju generała daje ci znak, byś podszedł.%SPEECH_ON%Nie zważaj na pana. Wojna ciąży mu na głowie. Słuchaj. Ja mam swoje rozkazy, ty masz swoje. Masz pójść do %objective% i pomóc dowódcy %commander% w oblężeniu tamtych umocnień. To wszystko.%SPEECH_OFF%Pytasz o zapłatę. Twarz generała kwaśnieje.%SPEECH_ON%Tak. Zapłata. Oczywiście. Miałem obiecać ci %reward% koron. Mam nadzieję, że to wystarczy za twoje... honorowe usługi.%SPEECH_OFF%Ostatnie słowa zdają się go boleć. Widać, że kazano mu być tak dyplomatycznym, jak to tylko możliwe. | Jeden z generałów %employer%a spotyka cię w korytarzu.%SPEECH_ON%Pan jest zajęty.%SPEECH_OFF%Wciska ci zwój w pierś. Rozwijasz go i czytasz. Z treści wynika, że dowódca %commander% oblega %objective% i potrzebuje pomocy. Bez wątpienia właśnie tam ma pojawić się %companyname%. Podnosisz wzrok na mężczyznę. Mruczy i mówi przez zaciśnięte zęby.%SPEECH_ON%Twoja zapłata to %reward% koron, czcigodny najemniku.%SPEECH_OFF%Te ostatnie słowa brzmią jak wyuczone. | Znajdujesz %employer%a, a on prowadzi cię do swoich prywatnych psiarni. Rzuca psom resztki, idąc i mówiąc.%SPEECH_ON%Wojna idzie świetnie. To po prostu najwspanialsze przedsięwzięcie, jakiego się podjąłem, i jestem w stanie czystej błogości.%SPEECH_OFF%Głaszcze jednego kundla za uchem, a pies liże mu palce.%SPEECH_ON%Ale nie wszystko jest tak, jak mogłoby być. Potrzebuję, żebyś poszedł do %objective% i pomógł dowódcy %commander%, który prowadzi tam oblężenie. Za pomoc będzie %reward% koron.%SPEECH_OFF%Sługa podbiega z żywą kurą. Szlachcic chwyta ją za nogi i rzuca do klatki szczekających psów. Drób miota się po morzu zębów, aż w końcu zostaje porwany. W kilka chwil rozszarpują go na strzępy. %employer% odwraca się do ciebie, strzepując pióro z ramienia.%SPEECH_ON%No to jak, mamy układ?%SPEECH_OFF% | %employer% wita cię w swojej komnacie, którą, jak widać, przerobiono na doraźną salę wojenną. Dowódcy stoją posłusznie nad mapą bitwy, przesuwając wojskowe żetony i kłócąc się o wyniki symulacji. %employer% prowadzi cię na bok. Obraca pierścienie na palcach, gdy mówi.%SPEECH_ON%Dowódca %commander% potrzebuje pomocy przy oblężeniu %objective%. Ptaki mówią mi, że jest blisko przełomu, ale potrzebuje ludzi takich jak ty, by naprawdę go dopiąć. Idź i pomóż mu, a po powrocie będzie tu na ciebie czekać %reward% koron.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "Ile koron, mówisz?",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{To nie jest tego warte. | Mamy inne zobowiązania. | Nie będę niszczył kompanii w jakimś oblężeniu.}",
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
			ID = "TheSiege",
			Title = "Przy oblężeniu...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Docierasz do obozu %commander%a i widzisz, że jego żołnierze są zaskakująco wyluzowani. Grają w kości na drewnianej planszy rozłożonej w błocie, żartują i śpiewają. Wszędzie powiewają sztandary, większość dawno straciła swoje jasne barwy. Kilku ludzi przywiązuje z powrotem drągi katapulty. Sam %commander% prowadzi cię do swojego namiotu dowodzenia. Daje ci napój, który smakuje jakby kąpał się w nim szczur. Wyjaśnia sytuację.%SPEECH_ON%Jak pewnie wiesz, jesteśmy tu od jakiegoś czasu i jesteśmy blisko przełomu. Potrzebuję cię pod ręką i w gotowości. Gdy nadejdzie czas ataku, wydam rozkaz rozpoczęcia szturmu.%SPEECH_OFF% | Obóz %commander%a zrujnował ziemię wokół %objective%. Codzienna obecność tylu ludzi zamieniła grunt w błoto. Kilku żołnierzy kręci szprychami lichiej, chwiejnej katapulty. Wrzucają do kosza robaczywą krowią głowę i luzują linę, aż ramię machiny rusza do przodu, wyrzucając wirującą, krwawiącą czarną głowę w stronę umocnień. Odbija się od krenelażu i zostawia obrzydliwą smugę na murach. Jeden z obrońców odkrzykuje.%SPEECH_ON%Ładny strzał, skurczybyki!%SPEECH_OFF%%commander% klepie cię po ramieniu. Uśmiecha się szeroko.%SPEECH_ON%Witaj na froncie, najemniku. Cieszymy się z ciebie i twoich ludzi. %objective% jest odcięte, ale obrońcy nie zamierzają się poddać, wciąż są zadziorni mimo głodu w brzuchach. Ale ten głód... osłabia ich. Gdy nadejdzie właściwy moment, rozpocznę szturm, potrzebuję tylko, byś był gotów.%SPEECH_OFF% | %commander% wita cię na froncie. Informuje, że obrońcy %objective% są zmęczeni, kończą im się zapasy i są bliscy załamania. Wobec tego przygotowuje ostateczny szturm i potrzebuje jedynie, by ludzie %companyname% byli gotowi, gdy nadejdzie czas. | Oblężenie %objective% wygląda bardziej jak inscenizacja w dużym teatrze niż wysiłek skupionej kampanii wojennej. Obie strony są w żałosnym stanie, obrzucają się obelgami ponad murami, a pomiędzy tym cicho przeklinają pecha, że utknęli w tym piekle. %commander% podchodzi do ciebie z iskrą wesołości w oczach.%SPEECH_ON%Ach, najemnicy. Pozwól, że wyjaśnię, co się dzieje. Odcięliśmy dostawy żywności do %objective%, a kilka nocy temu jeden z naszych agentów spalił ich spichlerz. Są głodni i wkrótce zaczną umierać. Ponieważ brakuje nam czasu, organizuję pełny szturm, by szybko zakończyć oblężenie. Bądź gotów, gdy nadejdzie czas.%SPEECH_OFF% | Podchodzisz do %objective% i widzisz umocnienia na tle horyzontu oraz %commander%a wpatrującego się przez skórzane lunety, marszczącego się gniewnie na to, co obserwuje. Podaje ci przyrząd i patrzysz.\n\nPierwsze, co widzisz, to kołyszący się tyłek mężczyzny, który klepie go obiema dłońmi. Żołnierz obok ma rozdziawione usta i zezowate oczy, szarpiąc się za krocze. Odkładasz lunetę, nie chcąc widzieć reszty. %commander% kręci głową.%SPEECH_ON%Odcięliśmy im żywność, więc wariują. Myślą, że są zabawni, ale wkrótce zobaczymy, kto się śmieje. Planuję szturm. Potrzebuję ciebie i ludzi %companyname% w gotowości, gdy przyjdzie rozkaz.%SPEECH_OFF% | %commander% wita cię na obrzeżach %objective%, gdzie zbudowano jego obóz oblężniczy. Rzędy namiotów wypełniają zmęczeni i zgryźliwi ludzie. Gotują gulasze w garnkach, których nikt nigdy nie mył, i wymieniają żarty, które nigdy nie były czyste. W oddali czujni obrońcy %objective% patrzą ponad krenelażami. Dowódca prowadzi cię do namiotu i wyjaśnia sytuację.%SPEECH_ON%%objective% nie ma już jedzenia i głoduje. Niestety nie mam czasu. Musimy szturmować to przeklęte miejsce szybko, i to cholernie szybko. Gdy nadejdzie czas, a nadejdzie, najemniku, musisz być gotów.%SPEECH_OFF% | Obrzeża %objective% zapełniły się namiotami. Jeden z ochroniarzy %commander%a prowadzi cię przez oblężnicze miasto. Zgryźliwi zawodowi żołnierze patrzą na ciebie z nieufnością. %commander% jednak wita cię radośnie w swoim namiocie. Gdy wchodzisz, widzisz człowieka wiszącego na rękach, stopy ma nad ziemią. Drugi mężczyzna czyści nóż w wiadrze czerwonej wody. %commander% wskazuje więźnia.%SPEECH_ON%Ach, najemniku. Ominęła cię zabawa.%SPEECH_OFF%Pytasz, co robił. Dowódca podchodzi do więźnia i chwyta go za podbródek, unosząc zmęczoną, wycieńczoną twarz.%SPEECH_ON%Zdobywałem odpowiedzi. %objective% zaraz upadnie, ale nie mam czasu siedzieć i czekać. Wkrótce zaatakuję umocnienia i wtedy potrzebuję ciebie i twoich ludzi w gotowości.%SPEECH_OFF% | Docierasz do obozu oblężniczego %commander%a i widzisz, jak żołnierze ładują siatkę głów do katapulty i wyrzucają ją ponad umocnienia %objective%. Sam dowódca staje obok, chłonąc widok z szerokim, zadowolonym uśmiechem.%SPEECH_ON%Wiesz, część tych głów była naszych, ale uznałem, że ci gnojki za murem nie poznają różnicy. Nie chodzi o to, czyja to głowa, tylko ile ich jest, rozumiesz? Chodź, najemniku.%SPEECH_OFF%Prowadzi cię do namiotu dowodzenia i rozkłada mapę.%SPEECH_ON%Obrońcy są zmęczeni, a świeże informacje mówią, że kończy im się jedzenie i zaczynają się bić o resztki. Nie mam czasu, by zrozumieli daremność swojej sytuacji, muszę im ją narzucić. Wkrótce rozpoczniemy szturm. Musisz być na miejscu, gdy padnie rozkaz.%SPEECH_OFF% | Gdy wchodzisz do obozu %commander%a, kilku jego żołnierzy pluje na jednego z twoich ludzi i wybucha bójka. Na szczęście sam dowódca uspokaja sytuację. Szybko prowadzi cię do namiotu i rozmawiacie, podczas gdy twoi ludzie czekają na zewnątrz.%SPEECH_ON%Muszę przeprosić za zachowanie moich ludzi. Nerwy są napięte do granic po tym, jak dzień po dniu stoicie i śpicie w błocie, podczas gdy wasi wrogowie śpią w łóżkach i obrzucają was obelgami zza murów.\n\nNa szczęście jeden z moich agentów spalił spichlerz i zapasy %objective%, więc fort jest bez żywności. Obrońcy głodują, ale obawiam się, że moi ludzie nie będą tu sterczeć długo. Martwi mnie też, że może nadejść odsiecz, by zdjąć oblężenie. To wszystko oznacza jedno... wydam rozkaz szturmu. Plany są w trakcie, potrzebuję tylko, byś był gotów, gdy przyjdzie rozkaz.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Będziemy gotowi.",
					function getResult()
					{
						this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(15, 30));
						this.Contract.setState("Running_Wait");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TakingAction",
			Title = "Przy oblężeniu...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%commander% wita cię na obrzeżach obozu oblężniczego. Ma ze sobą oddział konnych, a na twarzy wyjątkowo kwaśny wyraz. Szybko wyjaśnia sytuację.%SPEECH_ON%Najemniku, masz doskonałe wyczucie czasu. Moi zwiadowcy donoszą, że nadciąga odsiecz, by zdjąć oblężenie %objective%. Musimy albo zaatakować, albo spróbować spalić to przeklęte miejsce i wykurzyć ich w ten sposób. Niewiele zostanie do przejęcia, jeśli wybierzemy tę drogę.%SPEECH_OFF%Dziwnym trafem dowódca patrzy na ciebie, jakby szukał pomysłów. | %objective% zostało otoczone przez ludzi %commander%a, ale to oblegający wyglądają na bardziej spiętych niż obrońcy. Sam %commander% wciąga cię do namiotu. Uderza pięścią w stół, tłumacząc sytuację.%SPEECH_ON%Moi zwiadowcy wypatrzyli siły idące zdjąć oblężenie. Nie mamy dość ludzi, a tym bardziej energii, by ich odeprzeć. Możemy albo ruszyć do szturmu teraz, albo załadować katapulty ogniem i spalić to przeklęte miejsce do gołej ziemi. Obrońcy na pewno wyjdą, ale z ruin niewiele da się uratować.%SPEECH_OFF%Po czym, ku zaskoczeniu, dowódca podnosi wzrok i pyta.%SPEECH_ON%Co twoim zdaniem powinniśmy zrobić, najemniku?%SPEECH_OFF% | Gdy docierasz do namiotu %commander%a, on i jego porucznicy stoją nad mapą, a twoja obecność szybko kończy sprzeczkę. Dowódca wskazuje na ciebie.%SPEECH_ON%Najemniku! Dostaliśmy wieści, że nadciąga odsiecz, a my nie mamy ludzi, by ją odeprzeć. Albo szturmujemy %objective%, albo spalamy to piekło, wykurzamy obrońców ogniem i bierzemy to, co zostanie z ruin. Moi porucznicy są podzieleni. Co powiesz, żebyś miał decydujący głos?%SPEECH_OFF%Porucznicy burczą, ale dziwnie godzą się na to, by decyzję zostawić w rękach najemnika.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Przeprowadźmy pełny szturm na zamek.",
					function getResult()
					{
						this.Flags.set("IsAssaultTheGate", true);
						this.Contract.setState("Running_TakingAction");
						return "AssaultTheGate";
					}

				},
				{
					Text = "Ostrzelajmy zamek i wykurzmy ich.",
					function getResult()
					{
						this.Flags.set("IsBurnTheCastle", true);
						this.Contract.setState("Running_TakingAction");
						return "BurnTheCastle";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AssaultTheGate",
			Title = "Przy oblężeniu...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%commander% wydał rozkaz ataku.\n\n {%companyname% i oddział żołnierzy szlachcica mają szturmować bramę frontową. Ustawiasz ludzi pod daszkiem tarana, który bardziej przypomina wózek niż maszynę wojenną. Z rękami na drążkach pchasz taran naprzód. Dach grzechocze serią stuknięć, gdy strzały wbijają się w niego jedna po drugiej. Podnosisz wzrok i widzisz kilka grotów, które przebiły się na wylot. Gdy docieracie do bramy, każesz ludziom odciągnąć taran do tyłu, a potem na komendę puszczacie go.\n\nTaran, skrzypiąc ciężkim dębem, uderza w bramę. Pęka na środku i przez szczelinę widać obrońców %objective% czekających po drugiej stronie. Kolejny rozkaz, kolejne uderzenie. Tym razem taran przebija bramę, zrywając zawiasy i posyłając obie części w chmurę drzazg i metalu. Z bronią w dłoniach ty i twoi ludzie rzucacie się na drugą stronę. | Z oddziałem ludzi dowódcy %companyname% pcha taran w stronę bram %objective%. Kilku obrońców z góry rzuca drwiny.%SPEECH_ON%{To najpierw nie zabierzecie nas na kolację? | Hmm, ładny długi taran. Co, próbujesz coś nadrobić? | Dawajcie tu, wy paskudne skurwiele. | Módlcie się do starych bogów pod tym swoim małym dachem.}%SPEECH_OFF%Ich docinki milkną, gdy taran uderza w bramę i jednym zamachem ją rozbija. Twoi ludzie szybko wpadają przez wyłom. | Zabierasz kilku ludzi dowódcy i wraz z %companyname% pchasz taran w stronę bramy %objective%. Dach podskakuje i trzeszczy, niepokojąco bardziej przypominając szałas niż tarczę. Modlisz się, by wytrzymał. Strzały stukają nad wami, a inne rykoszetują z ostrymi zadrapaniami metalu po drewnie. Gdy zbliżacie się do bramy %objective%, strzały zamieniają się w kamienie, ciężko uderzając w zadaszenie machiny. %randombrother% spogląda na taran i śmieje się.%SPEECH_ON%Cholera jasna, panie.%SPEECH_OFF%Nagle przeraźliwy syk otacza wszystkich, jakbyście wpadli do gniazda żmij. Wszystko ciemnieje, gdy gorący olej spływa po bokach dachu. Strumień leci po plecach szlachcica, który krzyczy, pada naprzód i staje się wrzeszczącym golemem czarnej mazi. Spiesznie rozkazujesz rozpocząć taranowanie. Na szczęście wystarczy jedno uderzenie, by brama %objective% stanęła otworem. Ludzie szybko wpadają do środka, by walczyć z nielicznymi obrońcami.} | Pada rozkaz szturmu na %objective%. Szykujesz %companyname%. Twoi ludzie i żołnierze %commander%a pchają taran w stronę bramy umocnień. Strzały lecą przez niebo, migocząc w świetle, zanim zagwiżdżą nad falami nacierających. Ludzie padają bezgłośnie, inni osuwają się, trzymając rany.\n\nBrama frontowa szybko pęka, a twoi ludzie wlewają się przez wyłom na dziedziniec, gdzie czeka część obrońców %objective%. | %commander% wydaje rozkaz rozpoczęcia szturmu. Twoja kompania i jego armia ruszają na umocnienia, a grad pocisków oblężniczych przelatuje nad głowami jak ciemna nawałnica. Mury są tłuczone, a obrońcy kryją się, gdy łucznicy %commander%a nie odpuszczają. Udaje ci się przepchnąć taran do bramy i szybko ją rozbić. Gdy %companyname% wpada do środka, obrońcy %objective% ustawiają się na dziedzińcu, by was powitać. | Rozkaz szturmu na umocnienia %objective% przechodzi wzdłuż linii. Przygotowania tworzą apokaliptyczny obraz nieba zasnutego pociskami i strzałami. Ogień przelewa się ponad murami %objective%, a ty widzisz ludzi %commander%a ustawiających drabiny przy krenelażach i wdzierających się do środka. W tym czasie ty i twoi ludzie pchacie taran pod osłoną dachu, doprowadzacie go do bramy i szybko ją wyłamujecie. Gdy wpadacie do środka, obrońcy zapełniają dziedziniec i szykują się do walki. | %commander% wydaje rozkaz szturmu na umocnienia %objective%. Szturm wygląda tak: niebo ciemnieje od wymiany strzał, grzechoczących deszczy, które mijają się i rykoszetują od siebie. Pociski oblężnicze lecą jak zimne komety, by z hukiem wbić się w mury i wieże. Obrońcy walczą, by zrzucić drabiny z krenelaży. Atakujący wspinają się po drabinach: najwyższy niesie tarczę, ten pod nim dźga piką. Ty i %companyname% pchacie chybotliwy taran do bramy, w dużej mierze pozostawieni w spokoju dzięki osłonie całego tego chaosu.\n\nGdy brama pęka, ty i twoi ludzie wpadacie do środka akurat na czas, by zmierzyć się z grupą obrońców, którzy tam się zebrali. Dookoła, na murach, ludzie %commander%a desperacko walczą o kontrolę. | Niestety %commander% uznaje, że trzeba wziąć umocnienia %objective% frontalnie. Ty i %companyname% macie przepchnąć taran do bramy. Gdy pchasz machinę przez błoto, dostrzegasz człowieka z parującym kotłem czekającego tuż nad bramą. Rozglądasz się i widzisz żołnierzy niosących drabiny, którzy ruszają na mury. Szybko wspinają się i zaczynają walkę. Gdy znów patrzysz przed siebie, obrońcy z gorącym olejem już nie ma, ale z kotła wystają czyjeś nogi.\n\nNie ma problemu z wyważeniem bramy frontowej i wdarciem się do środka. Szybko natykasz się na zgromadzonych obrońców, podczas gdy na murach ludzie %commander%a wciąż walczą.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Na nich!",
					function getResult()
					{
						local tile = this.Contract.m.Origin.getTile();
						this.World.State.getPlayer().setPos(tile.Pos);
						this.World.getCamera().moveToPos(this.World.State.getPlayer().getPos());
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "AssaultTheGate";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Contract.flattenTerrain(p);
						p.Entities = [];
						p.AllyBanners = [];
						p.EnemyBanners = [
							this.Contract.m.Origin.getOwner().getBannerSmall()
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.m.Origin.getOwner().getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "BurnTheCastle",
			Title = "Przy oblężeniu...",
			Text = "[img]gfx/ui/events/event_68.png[/img]{Szereg łuczników wbija groty strzał w owinięte płótnem pęki i macza je w smole. Gdy trzymają strzały na zewnątrz, młody chłopak biegnie z pochodnią i podpala je wszystkie. Dowódca unosi dłoń, łucznicy podnoszą płonące bronie. Opuszcza dłoń, łucznicy wypuszczają cięciwy. Ogniste strzały lecą w niebo, trzaskają i syczą, po czym cichną i znikają z oczu. Spadają za umocnienia i przez chwilę nic się nie dzieje. Żołnierz krzyczy i wskazuje dym, który zaczyna się wznosić. Wkrótce pojawia się ogień, który liże niebo. Kilka minut później brama frontowa pęka, a osmaleni, zadymieni ludzie wypadają na zewnątrz jak golemy piekieł.\n\n%commander% unosi ramię ponownie, ale tym razem trzyma miecz.%SPEECH_ON%Szarża!%SPEECH_OFF% | Katapulty, balisty i łucznicy posyłają ogień ponad murami %objective%. Pociski gwiżdżą i syczą, a ich płaszcze ognia rozciągają się po niebie.\n\nUmocnienia szybko nabierają pomarańczowego blasku. Dym pęcznieje czarnymi kłębami, a języki ognia wspinają się za nim. Brama frontowa drży raz, drugi, po czym pęka. Osmaleni, kaszlący ludzie wypadają na zewnątrz, wspinając się po sobie w poszukiwaniu powietrza. %commander% dobywa miecza i wskazuje nim wroga.%SPEECH_ON%Bez jeńców!%SPEECH_OFF%Obrońcy %objective% zdają się to słyszeć, bo szybko ustawiają się w szyku. Przez chwilę zastanawiasz się, czy gdzieś wśród ich osmalonych sylwetek nie mieli kiedyś białej flagi. | Pada rozkaz, by podpalić %objective%. Patrzysz, jak obóz %commander%a rozświetla niebo piekielną burzą płonących pocisków i strzał. Ogień wkrótce unosi się zza murów i widzisz ludzi biegających w płomieniach. Gdy pożar zaczyna pożerać wnętrze %objective%, bramy otwierają się i grupa osmalonych, zdesperowanych mężczyzn wybiega na zewnątrz. Widząc ich, %commander% rozkazuje wszystkim szarżować. | %commander% rozkazuje podpalić %objective%. Katapulty i trebusze wypełnia się kamieniami owiniętymi w drewno i zanurzonymi w smole. Podpala się je i posyła w powietrze. Za nimi nadlatują wielkie salwy ognistych strzał, które wbijają się głęboko w wnętrze %objective%, skąd zaczyna unosić się dym. Wewnątrz umocnień narasta pożar i niedługo potem bramy pękają, a ludzie wybiegają na zewnątrz. %commander% dobywa miecza.%SPEECH_ON%Oto oni, ludzie. Skończmy z tym raz na zawsze!%SPEECH_OFF% | Łucznicy owijają strzały w płótno i maczają w smole. Dzieciaki biegają z wiadrami oleju i smarują pociski katapult. Gdy przygotowania są gotowe, %commander% wydaje rozkaz. Człowiek być może kiedyś czcił ogień, ale tu przerobiono go w wściekły terror, który gwiżdże po niebie, zasypując %objective% ogniem. Pociski oblężnicze kruszą wieże i przebijają dachy, podpalając całe miejsce. Obrońcy biegają z płonącymi strzałami wbitymi w ciała. Gdy pożar się nasila, brama frontowa otwiera się i golemy dymu oraz popiołu wylatują na zewnątrz, wspinając się po sobie, by uciec przed piekłem, które na nich spadło.\n\nWidząc to, %commander% dobywa broni.%SPEECH_ON%Na nich, ludzie, i żadnej litości!%SPEECH_OFF% | %commander% rozkazuje spuścić piekło na %objective%. Patrzysz, jak katapulty, trebusze i łucznicy wypełniają niebo lawiną płonących pocisków. Umocnienia szybko stają w płomieniach, które narastają w inferno. Zdesperowani ludzie otwierają bramy frontowe i wybiegają, kaszląc i desperacko wspinając się po sobie w poszukiwaniu powietrza. %commander% dobywa broni i śmieje się na ten widok.%SPEECH_ON%Oto oni, tam padną! Szarża!%SPEECH_OFF% | Patrzysz, jak inżynierowie oblężniczy ładują katapulty i trebusze krowimi padlinami i innymi tłustymi ochłapami. Dzieciaki z wiadrami smoły biegają wzdłuż linii, polewając każdy pocisk, zanim go podpalą. Chwilę później inżynierowie posyłają zwłoki w powietrze. Bulgoczą i kapią z nieba. Widzisz, jak jeden pocisk trafia w wieżę i eksploduje, zsyłając ogień na dziedziniec umocnień. Niewiele czasu mija, zanim to zwierzęce bombardowanie zamienia %objective% w płonące piekło.\n\nBrama frontowa pęka i tłum mężczyzn wypada na zewnątrz. Wspinają się po sobie, wyglądają jak ożywiony dym i popiół, ciemny krzew rozpościerający się przed bramą. %commander% dobywa broni.%SPEECH_ON%Na to czekaliśmy, ludzie. Dosyć czekania! Szarża!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Na nich!",
					function getResult()
					{
						local tile = this.Contract.m.Origin.getTile();
						this.World.State.getPlayer().setPos(tile.Pos);
						this.World.getCamera().moveToPos(this.World.State.getPlayer().getPos());
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "BurnTheCastle";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Contract.flattenTerrain(p);
						p.Entities = [];
						p.AllyBanners = [
							this.World.Assets.getBanner(),
							this.World.FactionManager.getFaction(this.Contract.getFaction()).getBannerSmall()
						];
						p.EnemyBanners = [
							this.Contract.m.Origin.getOwner().getBannerSmall()
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
						p.Entities.push({
							ID = this.Const.EntityType.Knight,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/humans/knight",
							Faction = this.Contract.getFaction(),
							Callback = this.Contract.onCommanderPlaced.bindenv(this.Contract),
							Tag = this.Contract
						});
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 200 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.m.Origin.getOwner().getID());
						p.Entities.push({
							ID = this.Const.EntityType.Knight,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/humans/knight",
							Faction = this.Contract.m.Origin.getOwner().getID(),
							Callback = null
						});
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
				foreach( id in this.Contract.m.UnitsSpawned )
				{
					local e = this.World.getEntityByID(id);

					if (e != null && e.isAlive())
					{
						e.die();
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "AssaultTheCourtyard",
			Title = "Pod %objective%...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Brama %objective% została zdobyta, ale to nie koniec. Trzeba utrzymać impet: szybko każesz ludziom ruszyć na dziedziniec. | Brama jest zdobyta, ale dziedziniec %objective% wciąż się trzyma. Każesz %companyname% nacierać dalej. | %companyname% zdobywa bramę, a ludzie %commander%a pędzą wzdłuż murów fortu, by czyścić wieże. Nie chcesz stracić impetu, więc szybko rozkazujesz kontynuować szturm na dziedziniec. | Gdy wpadasz na dziedziniec, ludzie %commander%a walczą nad tobą o kontrolę nad murami. | Ty i %companyname% wpadacie na dziedziniec %objective%. Nad wami słychać szczęk broni ludzi %commander%a walczących o mury. | Dziedziniec musi zostać zdobyty! Ty i %companyname% ruszacie na umocnienia gotowi do walki. Dookoła ciebie ludzie %commander%a walczą o kontrolę nad murami. | Gdy wpadasz na dziedziniec %objective%, martwi ludzie spadają z góry, zabici przez żołnierzy %commander%a w desperackiej walce o mury. | Ludzie %commander%a szturmują mury. Teraz ty musisz zrobić swoje i zabezpieczyć dziedziniec! | Podczas gdy ludzie %commander%a zabezpieczają mury, ty masz zabezpieczyć dziedziniec. Nie zawiedź!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Na nich!",
					function getResult()
					{
						local tile = this.Contract.m.Origin.getTile();
						this.World.State.getPlayer().setPos(tile.Pos);
						this.World.getCamera().moveToPos(this.World.State.getPlayer().getPos());
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "AssaultTheCourtyard";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Contract.flattenTerrain(p);
						p.Entities = [];
						p.AllyBanners = [];
						p.EnemyBanners = [
							this.Contract.m.Origin.getOwner().getBannerSmall()
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.m.Origin.getOwner().getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
				foreach( id in this.Contract.m.UnitsSpawned )
				{
					local e = this.World.getEntityByID(id);

					if (e != null && e.isAlive())
					{
						e.die();
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "AssaultAftermath",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Fort %objective% upadł. Patrzysz, jak ludzie %commander%a grzebią w ruinach, wyciągając ciała z zakamarków, w które spanikowani żywi wpełzli w ostatniej desperacji. Zwłoki są spalone, bezgłowe, bez kończyn, z trzewiami ciągnącymi się po ziemi, gdy je wloką, a nieliczni wyglądają, jakby po prostu umarli we śnie. Jeden z zawodowych żołnierzy wychyla się z krenelażu wieży, zrywa sztandar fortu i wznosi w jego miejsce znak %noblefamily%, co wywołuje gromkie okrzyki. | Zwłoki zasypują dziedziniec, przerzucone przez mury jak mokre ubrania, a część leży w kątach z wyrazem szoku na twarzach. W ruinach spalonej stajni widać zwęglone, drżące sylwetki, poskręcane i krzywe, a wśród zmarłych są konie, świnie, psy, a nawet potargane ptaki, które też wpadły w wir przemocy, jaka nawiedziła to miejsce z niepowstrzymaną siłą.\n\n%commander% obchodzi ocalałych ludzi i gratuluje im dobrej roboty. Jeden z żołnierzy wznosi sztandar %noblefamily% na jednej z wież. To marne miejsce ma nowych właścicieli. | Szturm się kończy, obrońcy %objective% zostali wyparci. Jeśli ktokolwiek przeżył to miejsce, zrobił to uciekając z niego. %commander% każe jednemu z ludzi wznieść znak %noblefamily% na jednej z wież i tak oto własność %objective% zmienia się niczym chorągiew leniwie łopocząca na wietrze. | Było to kosztowne, ale szturm dobiegł końca. %commander% przechodzi po trupach i rozkazuje natychmiast zacząć sprzątać. Jeden z jego ludzi wznosi sztandar %noblefamily%, by wszyscy widzieli, kto wygrał tę bitwę. | Wokół ciebie leżą ciała obrońców %objective%. Walczyli twardo, ale historia o tym nie wspomni. Ich imiona zostaną zapomniane, a ich istnienie okaże się daremne. Patrzysz, jak jeden z żołnierzy %commander%a rozwija sztandar na jednej z wież, więc przynajmniej tyle. | Wciąż trwają pojedyncze ogniska walki. Widzisz, jak ludzie %commander%a zrzucają obrońców z pobliskiej wieży, posyłając biedaków w krzyku na śmierć. Gdy wszyscy znikają, jeden z żołnierzy wznosi znak %noblefamily%. Sztandar łopocze głośno w nowej ciszy. | Uzdrowiciele wpadają do umocnień, by ratować ludzi %commander%a. Kilku obrońców %objective% też jest rannych, ale zostawia się ich samym sobie. Każdy krzyk o pomoc spotyka się z mieczem. Ocaleni szybko uczą się: żadnej rany, żadnego krzyku.\n\nSztandar %noblefamily% rozwinięto nad bramą frontową. | Ludzie %commander%a przeszukują resztki dziedzińca %objective%. Znajdują kobietę i zabierają ją do wieży. Młode dzieci biegną za nią, wolne i wyjące, a jednak nikt nie zwraca na to uwagi. Sam %commander% gratuluje ci dobrej roboty. Wskazuje na żołnierza rozwijającego sztandar %noblefamily% nad bramą frontową.%SPEECH_ON%Widzisz ten herb? To znaczy zwycięstwo.%SPEECH_OFF%Myślałeś, że sterty martwych wrogów są potężnym słownikiem zwycięstwa, ale machający kawałek płótna też wystarczy. | Dziedziniec jest usypany z ciał, a krew spływa po okalających murach. Ludzie %commander%a zbierają broń i dobijają każdego rannego wroga, którego znajdują. Ich własnych rannych opatrują słabi, starzy uzdrowiciele z workami ziół i moździerzem. Sztandar %noblefamily% rozwija się nad murami, by nikt nie miał wątpliwości, że %objective% ma nowych właścicieli. | Mieszkańców %objective% prowadzi się przez umocnienia, by zobaczyli martwych obrońców i całkowicie pokonane fortyfikacje. %commander% stoi nad nimi, kciuki zaczepione o pas, z butnym uśmiechem na twarzy. Gdy żołnierz rozwija sztandar %noblefamily%, wskazuje na niego.%SPEECH_ON%Widzisz? Teraz temu się kłaniacie. Jasne?%SPEECH_OFF% | Patrzysz, jak mieszkańcy są prowadzeni przez umocnienia %objective%. %commander% chce jasno pokazać, jak absolutne było jego zwycięstwo i że nie ma miejsca na dalszą walkę. Trudno go winić: porażka rodzi buntowniczy zapał w człowieku podbitym, a zapał ten bywa groźniejszy niż człowiek, który chwyta za miecz i tak jasno stawia sprawę, że wrogowie nie mają innego sposobu, by mu podziękować, niż natychmiast go uciąć. | %commander% ustawia mieszkańców %objective% w szeregu i prowadzi ich przez umocnienia. Mają zobaczyć klęskę swoich obrońców, krew wciąż świeżą i spływającą. W kolejce stoi piękna i smukła kobieta, a dowódca wyciąga ją z szeregu. Pyta, czy zna któregoś z zabitych. Wskazuje mężczyznę z roztrzaskaną twarzą. Rozpoznaje zwiędłą różę przypiętą do jego munduru - podarowała ją mężowi tamtego ranka. %commander% przeprasza za stratę i ostrożnie odprowadza ją z powrotem do szeregu. Zwraca się do tłumu z niemal ojcowską surowością.%SPEECH_ON%Zajmiemy się wami. Odbudujemy i nakarmimy was. Ale nie zapominajcie, %objective% należy do %noblefamily%. Dopóki się z tym zgadzamy, wszystko będzie dla was dobrze.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zwycięstwo!",
					function getResult()
					{
						this.Contract.changeObjectiveOwner();
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BurnTheCastleAftermath",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_68.png[/img]{Wykurzenie obrońców %objective% zadziałało jak marzenie. Ty i %commander% przechodzicie przez teraz bezbroną bramę, by zobaczyć, co zostało z tego miejsca. Niestety ogień spalił niemal wszystko do ziemi. Nieważne, jeden z zawodowych żołnierzy wznosi sztandar %noblefamily% na jednej z wież. Ledwie rozpoznajesz herb w chmurze wirującego popiołu i dymu. | Pole bitwy jest zasypane martwymi i umierającymi. Ludzie %commander%a przechodzą przez zwały ciał, co jakiś czas wbijając włócznie w ziemię, by uciszyć to, co jeszcze jęczało.\n\nTy i dowódca wchodzicie przez bramę %objective%. Ogień zamienił wszystkie drewniane budynki w osmalone szkielety. Po dziedzińcu leżą spalone zwierzęta gospodarskie. %commander% wzrusza ramionami i rozkazuje jednemu z ludzi wznieść sztandar %noblefamily% na jednej z wież, by wszyscy wiedzieli, kto wygrał tego dnia. | Bitwa dobiegła końca. Wykurzenie obrońców %objective% ogniem zapewne ocaliło wiele istnień, ale za bramą wszystko zostało oczyszczone płomieniami. Odbudowa do dawnej chwały, czymkolwiek była, zajmie czas. %commander% wydaje się zadowolony, gdy rozkazuje jednemu z ludzi wznieść sztandar %noblefamily% na jednej z wież. Jego barwne płótna trzepoczą ostro pośród wirujących odcieni popiołu i dymu. | %commander% stąpa po popiołach umocnień %objective%.%SPEECH_ON%Cóż, mamy to. To, co z tego zostało. Nie będę narzekał. Dobra robota, najemniku.%SPEECH_OFF% | Mieszkańcy %objective% wychodzą, by zobaczyć szczątki swoich umocnień. Kobiety przeszukują zwęglone ciała, szukając jakiegokolwiek znaku bliskich. Zamiast tego znajdują tylko zwęglone, żylaste szkielety, twarze stopione w ponure maski zatrzymujące ostatnie chwile. Jeden z ludzi %commander%a rozwija sztandar %noblefamily% nad bramą frontową, a dowódca szybko na niego wskazuje.%SPEECH_ON%Słuchać! Widzicie to? To jesteśmy my. Uszanujcie to, a wszystko wróci do normy! Zlekceważcie to, a przyniosę wam nową normę, jasne?%SPEECH_OFF%Tłum mieszkańców cicho kiwa głowami. %commander% uśmiecha się i jest to przerażająco szczere.%SPEECH_ON%Dobrze! A teraz, czy ktoś umie zrobić porządną jajecznicę?%SPEECH_OFF% | Ty i %commander% wchodzicie do umocnień %objective%, by zobaczyć finał walki o powietrze. Zwęglone sylwetki, czy to ludzi, czy zwierząt, leżą wspięte jedna na drugą. Dłoń jednego mężczyzny odciąga zwęglone szczątki innego, a uścisk ciągnie się jak lina zwęglonego mięsa. Zasłaniasz usta, by nie zwymiotować. %commander% rozkazuje wznieść sztandar %noblefamily% nad bramą frontową. Klepie cię po ramieniu.%SPEECH_ON%Hej, dobra robota, najemniku. Powinieneś wdychać ten smród. Szybciej się do niego przyzwyczaisz.%SPEECH_OFF% | Przechodzisz przez mury %objective% z szmatą na nosie. %commander% idzie obok z głową wysoko, z pyszałkowatością o własnym odórze. Wewnątrz %objective% znajdujesz ciała połączone przez stopione kości i mięso, wyszczerzone zęby błyszczą w szorstkich grymasach, rozbrzmiewając okropną ostatecznością śmierci w płomieniach. %commander% klepie cię po ramieniu.%SPEECH_ON%To było niezłe zwycięstwo, wiesz? Wracaj do %employer%a, chyba że chcesz pomóc w sprzątaniu.%SPEECH_OFF% | Ty i %commander% wchodzicie do %objective% z uniesionymi mieczami, ale nie ma z kim walczyć: pożoga pochłonęła wszystko, co żywe. Jeśli nie spłonęli na śmierć, znajdziesz ich oblepionych popiołem i dymem, którym się udusili. %commander% kopie trochę gruzu, przewracając zwęglone ciało.%SPEECH_ON%Do diabła, nie ma tu nic poza murami.%SPEECH_OFF%Patrzy na ciebie surowo.%SPEECH_ON%Ale mury to wszystko.%SPEECH_OFF%Kucasz i patrzysz na martwego człowieka.%SPEECH_ON%Myślisz, że on też tak uważał?%SPEECH_OFF%Dowódca wzrusza ramionami. Odwraca się i rozkazuje jednemu z ludzi rozwinąć sztandar %noblefamily% nad bramą frontową. | Stawiasz stopę w %objective% i od razu tego żałujesz. Wszędzie są ciała i nie da się rozpoznać ani jednego. Ogień uczernił wszystko, nawet samo błoto. %commander% próbuje obrócić trupa nogą. Odpryski ciała chrupią i rozłupują się, jakby stanął na cienkiej warstwie lodu. Mężczyzna marszczy nos.%SPEECH_ON%To już naprawdę nie wygląda dobrze, prawda?%SPEECH_OFF%Odwraca się i wydaje ostry gwizd, po czym wskazuje jednego ze swoich żołnierzy.%SPEECH_ON%Ty! Podnieś sztandar %noblefamily% nad bramami i wieżami!%SPEECH_OFF%Żołnierz salutuje i rusza do zadania. %commander% klepie cię po ramieniu i mówi, że %employer% będzie bardzo zadowolony z tych rezultatów. | Niewiele da się ocalić z umocnień %objective%: ogień pochłonął niemal wszystko. Ci, którzy zostali, spłonęli. Ci, którzy ruszyli do wież po bezpieczeństwo, udusili się. Twarze martwych mówią o obu historiach wprost - nie był to dobry sposób na śmierć. Ale %commander% wygląda na zadowolonego, każąc ludziom zacząć sprzątać i rozwijać sztandary %noblefamily%. | Przeszukujesz szczątki %objective%. Martwe ciała przyciągają wzrok, bo nigdy nie widziałeś tylu spalonych zwłok w jednym miejscu. Jedno z nich ściska małą postać, która po bliższym spojrzeniu okazuje się niemowlęciem. %commander% podchodzi i klepie cię po ramieniu.%SPEECH_ON%Ach, szkoda. Hej, dobra robota, najemniku. Nie roztrząsaj tego, jasne?%SPEECH_OFF%Kiwając głową, widzisz, jak dowódca uśmiecha się krótko, po czym rozkazuje ludziom rozwieszać sztandary %noblefamily%, gdzie tylko się da. Lepiej, by obcy wiedzieli, że ta spalona skorupa fortu ma nowych właścicieli. | Wewnątrz %objective% znajdujesz wszelaki zwęglony chaos. Martwe psy, które płonęły, ich łańcuchy tliły się długo przed tym, jak ogień je dosięgnął. Konie uwięzione w stajniach z czarnymi nogami sterczącymi w powietrzu. Świnie, które przebiły ogrodzenia i biegały na oślep, bez wątpienia w płomieniach przez cały czas. Słaby zapach boczku ledwie przebija się przez ohydny odór. Żadne z tych stworzeń nie miało szansy ucieczki.\n\nOtwierasz drzwi do magazynu i znajdujesz stertę obrońców, którzy udusili się na śmierć. %commander% staje za tobą i patrzy do środka.%SPEECH_ON%Biedacy. Wyglądają na młodych. Pewnie stajenni, giermkowie. Co za szkoda.%SPEECH_OFF%Dowódca pochyla się do środka i strąca słomę z bochenka. Obiera zewnętrzną warstwę, odsłaniając świeży miąższ.%SPEECH_ON%Hej, głodny?%SPEECH_OFF%Grzecznie odmawiasz.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zwycięstwo!",
					function getResult()
					{
						this.Contract.changeObjectiveOwner();
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Origin.spawnFireAndSmoke();

				foreach( a in this.Contract.m.Origin.getActiveAttachedLocations() )
				{
					a.spawnFireAndSmoke();
					a.setActive(false);
				}
			}

		});
		this.m.Screens.push({
			ID = "MaintainSiege",
			Title = "Przy oblężeniu...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%commander% wraca z wieściami, że obrońcy mogą słabnąć. Ma nadzieję uniknąć krwawego szturmu i po prostu przeczekać ich. Masz pozostać w obozie oblężniczym do odwołania. | Jeden z poruczników %commander%a informuje, że dowódca zamierza poczekać nieco dłużej, licząc, że obrońcy się poddadzą zamiast przedłużać walkę. %companyname% ma pozostawać w gotowości do odwołania. | Docierają wieści, że oblężenie zostanie utrzymane jeszcze przez jakiś czas. Masz czekać do odwołania.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Kompania będzie gotowa.",
					function getResult()
					{
						if (this.Flags.get("IsNighttimeEncounter"))
						{
							this.Contract.setState("Running_NighttimeEncounter");
						}
						else if (this.Flags.get("IsReliefAttack"))
						{
							this.Flags.set("IsReliefAttackForced", true);
							this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(15, 30));
							this.Contract.setState("Running_Wait");
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "NighttimeEncounter",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_33.png[/img]{%commander% rozkazuje tobie i ludziom wyruszyć na patrol. W trakcie obchodów zauważasz kilku obrońców %objective% wymykających się z koryta strumienia przy jednym z murów fortu. Przeciskają się jakimś tajnym przejściem. Myśląc szybko, każesz ludziom na nich ruszyć, licząc, że zajmiecie przejście, zanim was zauważą. Upewnij się, że żaden z tych drani nie zdoła wrócić przez tajne przejście! | Gdy czekacie, jak potoczy się oblężenie, %commander% przychodzi i rozkazuje tobie oraz %companyname% rozpocząć patrole zewnętrznych umocnień %objective%.\n\nI oto, gdy kręcisz się po okolicy, widzisz kilku obrońców %objective% przemykających przez właz. Kucasz i obserwujesz ich uważnie. Gdy właz się zamyka, widzisz, że jego wierzch został przykryty mchem i trawą, by zamaskować położenie. Jeśli teraz odejdziesz, by powiedzieć %commander%owi, istnieje spora szansa, że któryś z ludzi cię zobaczy i zniszczy przejście. Postanawiasz wykorzystać chwilę i rozkazujesz atak. %companyname% musi dopilnować, by żaden obrońca nie uciekł! | Gdy oblężenie zwalnia, postanawiasz wykazać się inicjatywą i pytasz, czy ty i %companyname% możecie wyruszyć na patrole. Trochę marszu utrzyma ludzi w świeżości i w gotowości. Albo będą się pałętać po obozie i wdawać w bójki z zawodowymi żołnierzami. %commander% się zgadza.\n\nNie mija kilka minut patrolu, gdy dostrzegasz kilku obrońców %objective% wyciągających się po skarpie byle jakiej fosy. Wpływają do niej przez ściekowy właz blisko murów. %randombrother% kręci głową.%SPEECH_ON%No niech mnie diabli.%SPEECH_OFF%Mówisz mu, by był cicho. Jeśli obrońcy dowiedzą się, że ich tajne przejście zostało odkryte, na pewno je zamkną. Czekasz, aż wszyscy wyjdą na otwartą przestrzeń, po czym rozkazujesz atak. Żaden z obrońców nie może uciec! | Rozkazano patrol i wybierasz %companyname% do zadania. Twoi ludzie burczą i narzekają, ale takie zajęcia dobrze trzymają żołnierzy w świeżości i czujności.\n\nNatknięcie się na grupę obrońców %objective% wymykających się tajnym przejściem to też niezły sposób na ożywienie! Po kilku minutach marszu znajdujesz dokładnie to. Patrzysz, jak obrońcy się zbierają, i gdy mają już wymknąć się na bezdroża, rozkazujesz atak. Żaden z nich nie może uciec! | W miarę jak oblężenie trwa, %commander% rozkazuje tobie i ludziom rozpocząć patrole umocnień wokół %objective%. W połowie obchodu twoi ludzie natykają się na kilku obrońców wymykających się tajnym przejściem, zasyfioną kratą tam, gdzie fosa sięga do piersi. Zajęcie tego przejścia byłoby ogromną przewagą taktyczną w nadchodzących dniach. Szybko rozkazujesz atak - i aby żaden z obrońców nie zdołał uciec!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Dorwać ich!",
					function getResult()
					{
						local tile = this.Contract.m.Origin.getTile();
						this.World.State.getPlayer().setPos(tile.Pos);
						this.World.getCamera().moveToPos(this.World.State.getPlayer().getPos());
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "NighttimeEncounter";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Contract.flattenTerrain(p);
						p.Entities = [];
						p.EnemyBanners = [
							this.Contract.m.Origin.getOwner().getBannerSmall()
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.m.Origin.getOwner().getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "NighttimeEncounterFail",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_33.png[/img]{A niech to wszystko. Kilku obrońców zdołało przemknąć z powrotem przez przejście i już słychać, jak je zamurowują. | Nie byłeś dość szybki, by zatrzymać wszystkich obrońców i kilku uciekło. Wślizgnęli się z powrotem do %objective% i zamknęli przejście za sobą. | Celem było zabić tych, którzy się wymykali, i zabezpieczyć przejście. Zamiast tego kilku uciekło do %objective% i zamknęli przejście za sobą.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "A niech to!",
					function getResult()
					{
						this.Flags.set("IsNighttimeEncounterLost", false);
						this.Flags.set("IsNighttimeEncounter", false);
						this.Flags.set("IsReliefAttack", true);
						this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(15, 30));
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "NighttimeEncounterAftermath",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Udało ci się zabić wszystkich obrońców i zabezpieczyć przejście. Gdy meldujesz to %commander%owi, każe ci przekraść się przez tajną bramę i zamordować głównego dowódcę %objective%. Masz kilka godzin na przygotowania, ale czas nagli i musisz uderzyć, zanim minie noc. | Zabijając wszystkich obrońców, zabezpieczasz przejście. Wracasz do %commander%a i wyjaśniasz sytuację. Kiwają głową, po czym zwraca się do ciebie.%SPEECH_ON%Chcę, żebyś przekradł się tajnym przejściem, wszedł do umocnień i zabił ich przywódcę.%SPEECH_OFF%W porównaniu do frontalnego szturmu, ta nocna akcja jest zaskakująco rozsądną propozycją. | Tajne przejście jest zabezpieczone, a wiadomość dotarła do %commander%a. Dowódca śmieje się, kręcąc głową.%SPEECH_ON%Szukaliśmy czegoś takiego od dawna, a ty wychodzisz na pierwszy patrol i już znajdujesz klucze do %objective%.%SPEECH_OFF%Mówi, że chce, abyś ty i %companyname% przekradli się przez przejście i zamordowali dowództwo. Gdy to się stanie, obrońcy zostaną złamani i %objective% można będzie łatwo przejąć. To albo frontalny szturm, na który nie masz ochoty. Masz kilka godzin na przygotowanie, ale misję trzeba wykonać przed końcem nocy. | Jeden z obrońców krzyczy o pomoc.%SPEECH_ON%Odkryli ughhh-%SPEECH_OFF%%randombrother% szybko przykłada mu szmatę do ust i podcina gardło. Rozglądasz się po murach %objective%, ale wygląda na to, że nikt nie usłyszał krzyku.\n\nWracając do obozu oblężniczego, przechwytuje cię %commander%. Szuka dobrych wieści, a ty chętnie je dostarczasz. Dowódca tupie nogą.%SPEECH_ON%Na bogów, to najlepsza wiadomość od tygodni! Dobrze, to świetne, ale musimy działać szybko. Chcę, żebyś ty i twoi ludzie przeszli tym przejściem i zamordowali dowództwo %objective%. Musimy to zrobić jak najszybciej, najdalej za kilka godzin, jasne?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Przygotujemy się i przekradniemy.",
					function getResult()
					{
						this.Flags.set("IsSecretPassage", true);
						this.Contract.setState("Running_SecretPassage");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "FailedToReturn",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Nie zdołałeś zabić przywódcy obrońców i przy ich dowódcy wciąż u steru %commander% musiał odwołać oblężenie. Choć nie była to w pełni twoja wina, można się spodziewać, że %employer% uzna inaczej. | Tajne przejście zostało zamknięte! Z dowódcą obrońców wciąż przy życiu szturm umocnień będzie zbyt kosztowny. %commander% odwołał oblężenie, a część winy spadła na ciebie. | Cóż, zbyt długo zwlekałeś z użyciem tajnego przejścia. Obrońcy pewnie uznali, że nie warto go zostawiać otwartego, i zasypali je kamieniami. Z dowódcą obrońców wciąż u steru, atak na umocnienia będzie bardzo kosztowny dla armii %commander%a. Odwołał oblężenie. %employer% nie będzie zadowolony.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Niech to!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Wandered off during the siege of " + this.Flags.get("ObjectiveName"));
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SecretPassage",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Ty i %companyname% po cichu przeciskacie się przez przejście. Ściany tunelu kapią gównem i szczynami, a woda, przez którą brniecie, nie jest lepsza. %randombrother% trochę narzeka, ale każesz mu się zamknąć.\n\nWychodząc po drugiej stronie, wylewacie się na dziedziniec. Kompania skrada się wzdłuż linii krzaków, po czym kładzie się płasko, gdy obserwujesz teren.\n\nKilku obrońców kręci się po okolicy. Wzdychają, jęczą i narzekają. Głód burczy im w brzuchach, a przekleństwa ślizgają się po językach. Wkrótce widać dowódcę z oddziałem jego najlepszych strażników. Przechodzi przez dziedziniec na inspekcję. Lepszej okazji nie będzie, więc rozkazujesz atak! | Ty i %companyname% otwieracie tajne przejście. Natrafiacie na młodego stajennego, który wychodzi z listą zapotrzebowania wypisaną na zwoju. Błaga o życie, ale nie możesz teraz ryzykować. %randombrother% podcina mu gardło i topi go w brudzie, który wypływa z tunelu przejścia. Idziesz dalej i wylewasz się na dziedziniec. Ty i ludzie skradają się wzdłuż krzaków i przez chwilę obserwujecie.\n\nGdy czekasz, mężczyzna w stroju dowódcy schodzi po kilku schodach z oddziałem strażników za plecami. Wątpisz, by nadarzyła się lepsza okazja, i rozkazujesz atak! | Tajne przejście jest ciemne i mętne, a woda w tunelach pełna gówna i szczyn. Podciągasz spodnie i ruszasz do środka. Pochodnie zdradziłyby was, więc idziesz po omacku, dotykając ścian. Nie wiesz, po jakich okropnościach przesuwają się twoje palce i masz nadzieję, że nigdy się nie dowiesz. W końcu w oddali migocze słabe światło i wymykasz się z przejścia na dziedziniec.\n\nDowódca %objective% ocenia swoje oddziały, ale zatrzymuje się, odwraca i patrzy na ciebie oraz %companyname% robiących wielkie, śmierdzące wejście. Jego oczy się rozszerzają i wskazuje na was jedną dłonią, a drugą sięga po broń.%SPEECH_ON%Zabójcy!%SPEECH_OFF%Każesz %companyname% zaatakować! | Tajne przejście prowadzi zaskakująco krótko na drugą stronę murów %objective%. Po drugiej stronie tuneli stoi strażnik. Widzi wasze sylwetki w ciemności. Pyta.%SPEECH_ON%Mam nadzieję na wszystkich cholernych starych bogów, że przynieśliście to, o co prosiliśmy. Pamiętaj, prosiłem o jajka i...%SPEECH_OFF%Przez chwilę widzi twarz %randombrother%a wyłaniającą się z cienia i uświadamia sobie, że nie stoi przed nim żaden chłopak na posyłki. Strażnik cofa się, ale zanim zdoła krzyknąć, twój najemnik wbija mu ostrze w pierś i obaj wpadają w krzaki. Gdy przeszkoda znika, cicho wkradasz się do %objective% i znajdujesz dowódcę ćwiczącego na dziedzińcu.\n\nNie mając lepszej okazji, rozkazujesz %companyname% do ataku!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Na nich!",
					function getResult()
					{
						this.Contract.getActiveState().onSneakIn(null, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SecretPassageAftermath",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Dowódca %objective% padł, a jego ludzie szybko składają broń. Jeden z poruczników podnosi ręce i mówi pospiesznie.%SPEECH_ON%Nie chcemy ciągnąć tej przegranej sprawy. Jedyny, któremu na tym zależało, leży martwy. Poddajemy się.%SPEECH_OFF%%employer% będzie bardzo zadowolony z takiego obrotu spraw. | Po bitwie znajdujesz konającego dowódcę obrony %objective%. Pluje krwią, gdy przechodzisz obok.%SPEECH_ON%Nigdy się nie poddamy. Rób, co chcesz, nędzny najemniku.%SPEECH_OFF%Przebijasz mu oczodół mieczem. Jeden z jego poruczników upuszcza broń i podnosi ręce.%SPEECH_ON%Hej, tylko jemu zależało na obronie tego miejsca. Wszystko jest wasze. Tylko pozwólcie nam żyć!%SPEECH_OFF%Rozkazujesz %randombrother%owi dać %commander%owi sygnał o zdobyciu umocnień. | Dowódca %objective% nie żyje, a jego ludzie natychmiast poddają się jednomyślnie. Wyjaśniają, że tylko dowódca chciał dalej trzymać pozycję. Najwyraźniej zabiegał o uwagę wśród rodów szlacheckich i uważał, że bohaterska obrona zapewni mu miejsce przy stole możnych. Cóż, teraz leży martwy w błocie. Mówisz %randombrother%owi, by nadał sygnał, że %objective% się poddało. Jeden z obrońców prosi o litość.%SPEECH_ON%Na pewno pozwolicie nam żyć, tak?%SPEECH_OFF%Czyścisz ostrze i wzruszasz ramionami.%SPEECH_ON%To nie ode mnie zależy. Mój dobroczyńca i armia, którą dowodzi, zaraz przejdą przez tę bramę. Jakie ma zamiary, tego nie wiem. Chcesz litości, podnieś broń, a moi ludzie ci ją dadzą.%SPEECH_OFF%Obrońca marszczy brwi i kiwa głową.%SPEECH_ON%W takim razie zaryzykuję z nim.%SPEECH_OFF% | Dowódca %objective% leży martwy w błocie. Ocalałe oddziały trzymają ręce w górze. Rozkazujesz ludziom skuć obrońców, a sam dajesz sygnał, rozwijając swój znak wzdłuż boku wieży. Obóz oblężniczy %commander%a odpowiada dźwiękiem rogu. Bitwa dobiegła końca. %employer% bez wątpienia będzie bardzo zadowolony. | Bitwa dobiegła końca, a przywódca %objective% leży martwy w błocie. Po wyrwaniu im serca i ducha obrońcy natychmiast się poddają. Rozkazujesz %companyname% zebrać ich w kupę i zacząć skuwać. %randombrother% idzie dać %commander%owi sygnał, że fort został zdobyty. %employer% bez wątpienia będzie zadowolony, gdy wrócisz.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Udało się!",
					function getResult()
					{
						this.Contract.changeObjectiveOwner();
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SecretPassageFail",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Niestety nie zdołałeś zająć pozycji do zabójstwa dowódcy i musiałeś się wycofać. Obrońcy %objective% szydzą, gdy ty i ludzie wracacie tunelami. Gdy wychodzisz na zewnątrz, słyszysz, jak przejście jest zamykane. Wygląda na to, że trzeba będzie obrać trudniejszą drogę do zdobycia %objective%. | Walka nie potoczyła się tak, jak chciałeś. Ty i %companyname% zostaliście zepchnięci do przejścia i wykonujecie odwrót. Gdy wychodzisz na zewnątrz, słyszysz kamienie i huk, gdy obrońcy wszystko zamurowują. Zrobiłeś, co mogłeś, ale wygląda na to, że zdobycie %objective% nie będzie takie łatwe, jak się spodziewałeś. | Trzeba im to oddać, obrońcy spisali się świetnie. Zmęczeni i niedożywieni walczyli jak osaczone psy. Gdy wycofujesz się poza mury %objective%, słyszysz wyraźny odgłos zamurowywanego przejścia.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "A niech to!",
					function getResult()
					{
						this.Flags.set("IsSecretPassage", false);
						this.Flags.set("IsReliefAttackForced", true);
						this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(15, 30));
						this.Contract.setState("Running_Wait");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ReliefAttack",
			Title = "Przy oblężeniu...",
			Text = "[img]gfx/ui/events/event_90.png[/img]{Zwiadowcy %commander%a wracają z wiadomością, że nadciąga odsiecz, by przerwać oblężenie %objective%. Dowódca kiwa głową i rozkazuje ludziom przygotować się do bitwy. Ty robisz to samo. | Gdy czekacie, wraca kilku zwiadowców i wchodzi do namiotu %commander%a. Idziesz za nimi i widzisz dowódcę, jak kiwa głową i zbiera swoje rzeczy. Spogląda na ciebie i wyjaśnia.%SPEECH_ON%Nadciąga odsiecz. Spróbują przerwać oblężenie. Przygotuj ludzi.%SPEECH_OFF% | {Patrzysz, jak %randombrother% siłuje się na rękę z jednym z zawodowych żołnierzy. Zakładają się o bezgłową kurę. Zwycięzca dostaje pełny brzuch, przegrany bolące ramię. | Jeden z żołnierzy oblegających i %randombrother% mają zacząć konkurs w wpatrywanie się. Kto pierwszy mrugnie, przegrywa. Kto wygra, dostaje kurę. | Znajdujesz %randombrother%a ciskającego wielkimi kamieniami obok palika w błocie. Żołnierz z armii oblegającej robi to samo. Najwyraźniej rywalizują o kurę i zostało im ostatnie rzucenie, zwycięzca bierze wszystko.} Zanim zaczną, zwiadowca wpada do obozu i mówi, że nadciąga armia, by odblokować %objective%. %commander% rozkazuje ludziom przygotować się. Powtarzasz to %companyname%. | Zwiadowcy %commander%a wrócili z wiadomością, że nadciąga armia, by odblokować %objective%. Każesz %companyname% przygotować się na dużą bitwę. | Wielka bitwa wisi na horyzoncie: zwiadowcy %commander%a wrócili z wieścią, że nadciąga odsiecz, by przerwać oblężenie. Przygotujcie się!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Przygotować się do bitwy!",
					function getResult()
					{
						this.Contract.spawnReliefForces();
						this.Contract.setState("Running_ReliefAttack");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ReliefAttackAftermath",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_86.png[/img]{Odsiecz została rozbita i zepchnięta z pola bitwy. Obrońcy %objective% bez wątpienia widzieli całą bitwę i ich morale ucierpiało. To chyba tylko kwestia czasu, aż się poddadzą! | Hurra! Z odsieczą uporano się błyskawicznie. %commander% dziękuje ci za pomoc. Przykłada skórzaną lunetę do oczu, spogląda na mury %objective% i uśmiecha się.%SPEECH_ON%Och, to pobita banda. Widzieli wszystko. Nigdy w życiu nie widziałem tak beznadziejnego zbiorowiska ludzi.%SPEECH_OFF%Klepie cię po ramieniu z szerokim uśmiechem.%SPEECH_ON%Najemniku, myślę, że to oblężenie jest prawie skończone!%SPEECH_OFF% | Udało ci się odeprzeć odsiecz! To była pewnie ostatnia nadzieja %objective% i ich kapitulacji można spodziewać się lada dzień. | %commander% dziękuje ci za pomoc w rozbiciu odsieczy. Uważa, że %objective% najpewniej podda się w każdej chwili. | Oglądanie, jak jedyna nadzieja świata zostaje zniszczona, raczej nie podnosi morale. Obrońcy %objective% widzieli masakrę odsieczy i bez wątpienia są teraz u progu kapitulacji. | Cóż, wielka ostatnia nadzieja %objective% została całkowicie rozgromiona. Ty i %commander% naradzacie się i zgadzacie: obrońcy są gotowi do kapitulacji. To tylko kwestia czasu.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nie mogą czekać wiecznie.",
					function getResult()
					{
						this.Flags.set("IsReliefAttackForced", false);

						if (this.Flags.get("IsSurrender"))
						{
							this.Flags.set("IsSurrenderForced", true);
						}
						else if (this.Flags.get("IsDefendersSallyForth"))
						{
							this.Flags.set("IsDefendersSallyForthForced", true);
						}

						this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(10, 20));
						this.Contract.setState("Running_Wait");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Surrender",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_31.png[/img]%objective% kapituluje!\n\n{Przechodzisz przez otwarte bramy i widzisz obrońców porozrzucanych wszędzie. Głodni mężczyźni zwijają się z bólu, inni opierają się o mury, spękane wargi pękają, gdy błagają o wodę. Żadne zwierzę nie żyje. Wszystkie dawno zostały zarżnięte. Czarne ptaki patrzą z murów, jakby dołączały do podboju i tylko czekały na okazję do grabieży. %commander% klepie cię po ramieniu i dziękuje za pomoc. | Brama frontowa zgrzyta i otwiera się, a ty wchodzisz jak zwycięzca. Jednak widok w środku rozwiewa wszelkie wyobrażenia o honorze w pokonaniu tych biedaków. Martwi obrońcy zostali ułożeni w rogu. Kilku mężczyzn ukrzyżowano za kanibalizm, ale nawet ci straceni noszą ślady bycia zjedzonymi. Z jednej strony dziedzińca stoi spalony spichlerz. Część mężczyzn siedzi z czarnymi ustami, najwyraźniej próbując przełknąć zwęglone resztki ziarna. Każde zwierzę zostało zarżnięte i ogryzione do kości.\n\n%commander% śmieje się na ten widok i każe swoim ludziom zacząć skuwać więźniów. Odwraca się do ciebie.%SPEECH_ON%Dzięki, najemniku. Możesz wracać do %employer%a.%SPEECH_OFF% | Wewnątrz fortu obrońcy stoją w szeregu. Dwóch żołnierzy %commander%a idzie wzdłuż nich, jeden niesie łańcuchy, drugi zakuwa nimi ludzi. Widzisz zwłoki przebite na szczycie stajni, wiatrowskaz przebił mu pierś i niesie jego serce jak krwawy koniec rytuału. %commander% podchodzi, śmiejąc się.%SPEECH_ON%To był ich porucznik. {Mówili, że odmówił kapitulacji i sam rzucił się z wieży. | Podobno odmówił kapitulacji, więc jego ludzie zrzucili go z wieży.}%SPEECH_OFF%Ciekawe. Cóż, %employer% będzie bardzo zadowolony, że znów cię widzi. | Poza murami ludzie %commander%a zabierają broń obrońców i wrzucają ją na wielką stertę. Sami obrońcy są stłoczeni w rogu, z rękami skutymi za plecami, głowy spuszczone, oczy wlepione w błoto. Kilku strażników pilnuje ich, od czasu do czasu kopiąc, plując lub nawet grożąc zabiciem. Wszystko dla zabawy.\n\n%commander% podchodzi i klepie cię po plecach.%SPEECH_ON%Dobra robota, najemniku. Twoja pomoc była bardzo cenna. Wracaj do %employer%a. Tu już skończyłeś.%SPEECH_OFF% | Przechodząc przez bramę, widzisz obrońców błagających o litość. Ich porucznik leży martwy w błocie, wciąż cieknie z dziesiątek ran kłutych. Jeden z nich tłumaczy.%SPEECH_ON%Chcieliśmy się poddać już dawno, ale on nam nie pozwolił! Musisz zrozumieć! Nie chcemy już tej wojny.%SPEECH_OFF%%commander% podchodzi obok i kiwa głową.%SPEECH_ON%Twoja robota jest skończona, najemniku. Idź do %employer%a.%SPEECH_OFF%Pytasz, co zrobi z więźniami. Wzrusza ramionami.%SPEECH_ON%Nie wiem. Najpierw zjem. Może napiszę list do bliskich. Staram się nie być pochopny w takich sprawach.%SPEECH_OFF%Cóż, uczciwie. | Ty i %commander% przechodzicie przez otwarte bramy. W środku kilku ocalałych obrońców klęczy, błagając o jedzenie na kolanach. Ledwie mogą unieść ciała, tak cierpią ich brzuchy.%SPEECH_ON%Proszę! Pomocy...%SPEECH_OFF%%commander% stawia but na jednym z nich i przewraca go.%SPEECH_ON%Czy wyglądamy na pomoc?%SPEECH_OFF%Dowódca odwraca się do ciebie.%SPEECH_ON%Dobra robota, najemniku. Wracaj do %employer. Tu już skończyłeś.%SPEECH_OFF% | Przez bramę widzisz obrońców zbieranych i spychanych w róg. %commander% pyta, który z nich jest przywódcą. Grupa jednogłośnie wskazuje na drugi koniec dziedzińca. Martwy mężczyzna wisi z jednej z wież, blady na twarzy, z fioletowymi dłońmi i sinym nosem. Jeden z więźniów wyjaśnia.%SPEECH_ON%Gdybyśmy tego nie zrobili, wciąż stałbyś tam na zewnątrz, a my dalej głodowalibyśmy w środku.%SPEECH_OFF%%commander% kiwa głową.%SPEECH_ON%Dobrze. Nie ukarzę was za to. Najemniku! Wracaj do %employer%a. Tu już skończyłeś.%SPEECH_OFF% | Przechodząc przez bramę, widzisz dowódcę fortu wymachującego długim mieczem, gdy kilku ludzi %commander%a osacza go włóczniami. Jednym zgodnym ruchem przebijają go jak dzikie zwierzę. Unieruchomiony drzewcami, poddaje się i opada do przodu, zarzucając ręce na drewno, jakby leniwie opierał się o płot.%SPEECH_ON%Dobra, chyba mnie macie, sukinsyny.%SPEECH_OFF%Odwraca się do swoich ludzi, którzy, jak się zdaje, byli tymi, którzy naprawdę otworzyli bramy.%SPEECH_ON%Zobaczymy się wszyscy w następnym życiu.%SPEECH_OFF%Krew wypływa mu z ust, ciało drga raz i to wszystko. Żołnierze wyciągają włócznie, a przywódca pada prosto w błoto. %commander% staje nad nim i zwraca się do ciebie.%SPEECH_ON%Dobrze, najemniku. Wracaj do %employer%a.%SPEECH_OFF% | Wnętrze fortu to miejsce grozy. Mężczyźni leżą porozrzucani, trzymając się za brzuchy, niektórzy już martwi, inni życzący sobie śmierci. Dowódca tego miejsca wisi z wieży, z rodowym sztandarem owiniętym wokół szyi, jakby miał mu nadać odrobinę godności w śmierci. Kości zwierząt pokrywają dziedziniec, a dookoła są kałuże gówna, szczyn i wymiocin. %commander% podchodzi do ciebie i kiwa głową.%SPEECH_ON%Wygląda jak trzeba. Szkoda, że nie poddali się wcześniej.%SPEECH_OFF%Sugerujesz, że to pewnie martwy porucznik, zwisający na własnym herbie, opierał się kapitulacji. Dowódca znów kiwa głową.%SPEECH_ON%Tak. Myślał, że to honorowe. Kiedyś pewnie zrobiłbym to samo, ale po tym, co widzę, nie jestem już pewien, czy miał rację.%SPEECH_OFF% | Przechodząc przez bramę, widzisz obrońców stłoczonych przed miejscem kultu. Niewielu ich zostało i nikt się nie modli. Martwi zostali złożeni w rogu, a widać ślady kanibalizmu. Nie ma żadnych zwierząt. Stajnia roi się od much tak bardzo, że aż ryczy ich frenetyczne bzyczenie. Chlew został całkiem zdeptany. Jeden z więźniów podnosi wzrok.%SPEECH_ON%Zjedliśmy wszystko, co mogliśmy. Rozumiesz? Zjedliśmy. Wszystko. Co mogliśmy.%SPEECH_OFF%%commander% podchodzi do twojego boku.%SPEECH_ON%Nie przejmuj się nimi, najemniku. Wracaj do %employer%a. Na pewno będzie na ciebie czekał.%SPEECH_OFF% | Ty i %commander% przechodzicie przez bramy frontowe. Obrońcy w środku są bardziej szkieletem niż ciałem i tak też się poruszają. Jeden czepia się twojego ramienia.%SPEECH_ON%Jedzenie! Jedzenie!%SPEECH_OFF%Jego oddech niesie okropny smród głodu. Rzucasz go na ziemię, a on krzyczy i zaczyna upychać sobie usta błotem. %commander% staje obok, gryząc posmarowany masłem kawałek chleba.%SPEECH_ON%Te dranie wyglądają żałośnie, co?%SPEECH_OFF%Okruchy sypią się z jego ust, a więźniowie patrzą na nie, jakby były złotem. Dowódca klepie cię po ramieniu.%SPEECH_ON%Wracaj do %employer%a, będzie bardzo zadowolony z tych świetnych wieści.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "%objective% upadło!",
					function getResult()
					{
						this.Contract.changeObjectiveOwner();
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				foreach( id in this.Contract.m.UnitsSpawned )
				{
					local e = this.World.getEntityByID(id);

					if (e != null && e.isAlive())
					{
						e.die();
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "DefendersSallyForth",
			Title = "Przy oblężeniu...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Głośny zgrzyt przebija się przez zgiełk obozu oblężniczego. Patrzysz i widzisz, jak bramy %objective% się otwierają, a grupa mężczyzn wybiega. %commander% wyskakuje ze swojego namiotu, rzuca okiem i zaczyna wrzeszczeć na ludzi.%SPEECH_ON%Wypad! Wypad! Nadchodzą, chłopcy, nadchodzą! Przygotować się! Wybijcie tych szczurzych sukinsynów do ostatniego, słyszycie?%SPEECH_OFF%Obóz ryczy z podniecenia. Szybko zbierasz %companyname% i przygotowujesz się do bitwy. | Obrońcy %objective% wychodzą do wypadu! Rozkazujesz ludziom się przygotować i ruszyć z %commander%em do walki. | Nie będzie żadnej kapitulacji! Obrońcy %objective% wychodzą do wypadu. Wyglądają na biednych i głodnych, ale najwyraźniej wolą zginąć tu, niż się poddać. %commander% każe swoim ludziom się przygotować, a ty robisz to samo z %companyname%. | Bramy %objective% się otwierają! Na początku to wszystko, po czym nadchodzi stłumiony ryk, a mała grupa obrońców zaczyna maszerować. Podnoszą ręce do okrzyków i śpiewają rodowy okrzyk bojowy. Oni przynoszą hałas, ty przyniesiesz przemoc. Do boju! | Zgrzyt zardzewiałych zawiasów rozbrzmiewa nad obozem oblężniczym. Spoglądasz na %objective% i widzisz, jak bramy powoli się otwierają. Wychodzi grupa mężczyzn, niosąc sztandary i broń. Wyglądają, jakby już przegrali jedną bitwę, chwiejnie idą na głodnych brzuchach. %commander% kręci głową.%SPEECH_ON%Ci głupcy. Czemu po prostu się nie poddadzą?%SPEECH_OFF%Wzruszasz ramionami i zwracasz się do %companyname%.%SPEECH_ON%Jeśli chcą umrzeć, niech tak będzie. Do broni, ludzie!%SPEECH_OFF% | %randombrother% podchodzi do ciebie i wskazuje bramy %objective%.%SPEECH_ON%Patrz, panie.%SPEECH_OFF%Patrzysz, jak bramy powoli się otwierają. Wychodzi oddział ludzi. Nie niosą białej flagi, tylko herby swoich rodów. Biegniesz do %commander%a i informujesz go, że obrońcy wychodzą do wypadu. Kiwa głową.%SPEECH_ON%Wiedziałem, że to twarda banda, ale to już żałosne. Żaden człowiek nie powinien ginąć tak bezsensownie.%SPEECH_OFF%Prawie mówisz, że gdyby to była prawda, nikt nie robiłby tu całego tego gówna, ale trzymasz język za zębami i idziesz przygotować ludzi %companyname% do walki.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zakończmy to!",
					function getResult()
					{
						local tile = this.Contract.m.Origin.getTile();
						this.World.State.getPlayer().setPos(tile.Pos);
						this.World.getCamera().moveToPos(this.World.State.getPlayer().getPos());
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "DefendersSallyForth";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Contract.flattenTerrain(p);
						p.Entities = [];
						p.AllyBanners = [
							this.World.Assets.getBanner(),
							this.World.FactionManager.getFaction(this.Contract.getFaction()).getBannerSmall()
						];
						p.EnemyBanners = [
							this.Contract.m.Origin.getOwner().getBannerSmall()
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 90 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
						p.Entities.push({
							ID = this.Const.EntityType.Knight,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/humans/knight",
							Faction = this.Contract.getFaction(),
							Callback = this.Contract.onCommanderPlaced.bindenv(this.Contract)
						});
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 200 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.m.Origin.getOwner().getID());
						p.Entities.push({
							ID = this.Const.EntityType.Knight,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/humans/knight",
							Faction = this.Contract.m.Origin.getOwner().getID(),
							Callback = null
						});
						this.Contract.setState("Running_DefendersSallyForth");
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
				foreach( id in this.Contract.m.UnitsSpawned )
				{
					local e = this.World.getEntityByID(id);

					if (e != null && e.isAlive())
					{
						e.die();
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "DefendersPrevail",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_22.png[/img]Co niewiarygodne, zmęczeni obrońcy %objective% wygrali! Wycofujesz się, a oblężenie upada.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Oblężenie zakończyło się klęską.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Zawiodłeś w oblężeniu " + this.Flags.get("ObjectiveName"));
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "DefendersAftermath",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Obrońcy %objective% zostali unicestwieni, a umocnienia pozostały szeroko otwarte. Ty i %commander% przechodzicie przez otwarte bramy, widząc wszędzie trupy, śmieci i zarżnięte zwierzęta, krwawe znaki desperacji. Dowódca kiwa głową i klepie cię po ramieniu.%SPEECH_ON%Dobra robota, najemniku. Wracaj do %employer%a i przekaż mu wieści.%SPEECH_OFF% | Bitwa skończona, obrońcy %objective% całkowicie pokonani, a ich fort pozostawiony do wzięcia. %commander% dziękuje za służbę, po czym zwalnia usługi %companyname%. Powinieneś iść do bardzo szczęśliwego %employer%a. | Obrońcy %objective% podjęli zawzięty wysiłek, ale jeśli chcieli zagrać taką kartą, powinni byli zrobić to tygodnie temu, gdy ich siły odpowiadały ich heroizmowi. Teraz to bez znaczenia. Głodny martwy wygląda niemal tak samo jak najedzony martwy, a z czasem wszyscy wyglądają tak samo.\n\n%commander% przychodzi i mówi, że usługi %companyname% nie są już potrzebne. Zgadzasz się i powinieneś wrócić do %employer%a po zapłatę. | Wypad, gdy jesteś głodny i przygnieciony kiepskim dowodzeniem, nigdy nie jest najlepszym pomysłem. Nie jesteś pewien, czy %commander% darowałby obrońcom %objective%, gdyby się poddali. Tak czy inaczej, wszyscy leżą teraz martwi w błocie, a świat, w którym mogli się poddać, dawno przeminął. Zbierasz ludzi %companyname% i rozkazujesz przygotować się do marszu powrotnego do %employer%a. Wypłata będzie tego dnia bardzo słodka. | Gdy obrońcy %objective% zniknęli z drogi, ty i %commander% wchodzicie do umocnień. Jest powód, dla którego ludzie byli tak zdesperowani: warunki są absolutnie opłakane. Martwi ludzie zostali obrabowani i złożeni w rogu. Na rożnie leżą ugotowane resztki czegoś, co mogło być świnią, ale trudno to stwierdzić, bo zjedli absolutnie każdą część zwierzęcia. Z jednej z wież zwisa powieszony człowiek. Przybili mu do piersi deskę z napisem \"kanibal\", być może napisaną jego własną krwią.\n\n%commander% śmieje się.%SPEECH_ON%Wygląda tu na niezłą imprezę, co? Zapamiętaj tę scenę, gdy następnym razem jakiś butny porucznik z kijem w tyłku powie ci, żeby po prostu wytrwać.%SPEECH_OFF% | %companyname% i armia %commander%a szybko pokonują obrońców %objective% wychodzących do wypadu. Gdy umocnienia są wolne, ludzie %commander%a szybko je zajmują. Sam dowódca każe ci iść do %employer%a po zapłatę. | Obrońcy %objective% zginęli na polu bitwy, ale jeśli już, to było to pole łaski. Za murami ich fortu nie zostało prawie nic wartościowego, a w szczególności całkowity brak jedzenia. Jakby świat istniejący za murami nigdy nie znał pojęcia żywności, tak dokładnie obrońcy wszystko wyczyścili. Jesteś pewien, że samo wspomnienie jedzenia było tu zbrodnią, bo nawet męczące słowo o smaku byłoby jak chłosta na burczącym brzuchu. %commander% staje obok i śmieje się.%SPEECH_ON%Myślałem, że wiem, co to głód, ale zawsze miałem na to odpowiedź, rozumiesz? Nigdy nie głodowałem bez nadziei na ratunek. Co za straszna rzecz. Ale z drugiej strony, oni to naprawili, prawda?%SPEECH_OFF%Kiwając głową, słyszysz jego czarny humor.%SPEECH_ON%Dobra robota, najemniku. Dopilnuj, by %employer% dobrze ci zapłacił.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "%objective% upadło!",
					function getResult()
					{
						this.Contract.changeObjectiveOwner();
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Prisoners",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Kilku twoich ludzi zdołało pojmać część obrońców %objective%. Stoją stłoczeni, otoczeni bronią twoich najemników. Niektórzy trzęsą się w butach. Jeden nawet ich nie ma. Inny ma plamy na spodniach. %randombrother% pyta, co z nimi zrobić. | %randombrother% melduje, że pojmano kilku obrońców %objective%. Idziesz zobaczyć grupę ludzi stłoczonych razem, obejmujących się w ciasnym kręgu, ale z głowami spuszczonymi w dół. Jeden woła.%SPEECH_ON%Proszę, nie zabijajcie nas! Robiliśmy tylko to, co nam kazano, tak jak wy!%SPEECH_OFF% | Twoi ludzie pojmali kilku obrońców %objective%. Zgromadzono ich, rozebrano do spodni i kazano położyć się twarzą w błocie. %randombrother% pyta, co z nimi zrobić.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wypuśćcie ich. %rivalhouse% może to odebrać jako oznakę dobrej woli.",
					function getResult()
					{
						return "PrisonersLetGo";
					}

				},
				{
					Text = "Mogą być coś warci. Pojmać ich i niech %commander% się nimi zajmie.",
					function getResult()
					{
						return "PrisonersSold";
					}

				},
				{
					Text = "Lepiej zabić ich już teraz, niż zmierzyć się z nimi znów w bitwie w nadchodzących dniach.",
					function getResult()
					{
						return "PrisonersKilled";
					}

				}
			],
			function start()
			{
				this.Flags.set("IsPrisoners", false);
			}

		});
		this.m.Screens.push({
			ID = "PrisonersLetGo",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Więźniowie nie są przydatni ani tobie, ani nikomu innemu. Wypuszczasz ich, mając nadzieję, że nie pożałujesz tej decyzji. | Wypuszczasz więźniów. Płaczą, dziękując ci, ale ty tylko liczysz, że to nie był błąd. | Puszczasz więźniów wolno. Dziękują ci osobiście, po czym znikają, miejmy nadzieję, na zawsze.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wystarczy zabijania jak na jeden dzień.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(2);
						this.World.FactionManager.getFaction(this.Flags.get("RivalHouseID")).addPlayerRelation(5.0, "Let some of their men go free after battle");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "PrisonersKilled",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Kiwasz głową do %randombrother%a.%SPEECH_ON%Zabić ich wszystkich.%SPEECH_OFF%Więźniowie podnoszą się, ale nie ma ucieczki przed zamknięciem ich świata. Zostają zarżnięci po kolei. | Nie ma pożytku z tych ludzi w kajdanach, a jest całkiem prawdopodobne, że wrócą kiedyś jako wolni, by znów z tobą walczyć. Rozkazujesz ich egzekucję, a rozkaz zostaje wykonany wśród błagań i poderżniętych gardeł. | W takich wojnach nie ma jedzenia, by trzymać tylu więźniów, i nie są ci do niczego potrzebni, dopóki jesteś głęboko na wrogim terytorium. Jeśli ich wypuścisz, bardzo możliwe, że kiedyś znów podniosą na ciebie miecze.\n\nMając to na uwadze, rozkazujesz ich egzekucję. Słowa protestu szybko milkną, ginąc w charkocie podrzynanych, ciętych i rąbanych gardeł.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Przejdźmy do ważniejszych rzeczy...",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-2);

						if (this.World.FactionManager.isCivilWar())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnPartyDestroyed);
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "PrisonersSold",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Prowadzisz więźniów do %commander%a. Mężczyźni ustawiają się w szeregu, a dowódca chodzi wzdłuż nich.%SPEECH_ON%Ten. Ten. On. I on. Resztę zabić.%SPEECH_OFF%Kilku szczęśliwców, przypadkiem największych i wyglądających na najbardziej przydatnych, zostaje wyciągniętych do przodu. Resztę zabija się natychmiast, przebijając ich piersi włóczniami. %commander% wręcza ci trochę koron.%SPEECH_ON%Dzięki, że ich złapałeś. Pójdą do ciężkiej pracy.%SPEECH_OFF% | Więźniowie trafiają do %commander%a. Każe ich skuć i skierować do ciężkich robót. Dowódca płaci ci przyzwoitą sumę za łup.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Przejdźmy do ważniejszych rzeczy...",
					function getResult()
					{
						this.World.Assets.addMoney(250);
						this.World.Assets.addMoralReputation(-1);
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]250[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Meldujesz %employer%owi, że %objective% zostało zdobyte i jest pod kontrolą. Mężczyzna chowa uśmiech za dłonią, zachowując sporą dozę opanowania, jakby szlachcie nie wypadało okazywać pospolitej ekscytacji. Po prostu kiwa głową, jakby się tego spodziewał.%SPEECH_ON%Dobrze. Dobrze. Oczywiście.%SPEECH_OFF%Mężczyzna pstryka palcami, a sługa wręcza ci sakiewkę %reward_completion% koron. | Wejście do komnaty %employer%a ucisza tłum dowódców, poruczników i samego szlachcica. Prostuje się.%SPEECH_ON%Moje ptaszki już doniosły o zdobyciu %objective%. Twoja zapłata jest na zewnątrz.%SPEECH_OFF%Przywódcy ledwie dziękują, ale %reward_completion% koron to i tak więcej niż wystarczające podziękowanie. | %employer% wita cię w swojej sali wojennej. Grupa dowódców stoi nad mapą na stole. Widzisz, jak przesuwają jeden z żetonów nad %objective%. %employer% uśmiecha się.%SPEECH_ON%Ci ludzie może i tego nie okazują, ale jesteśmy bardzo zadowoleni z twojej pracy. Opowieści moich szpiegów upewniły mnie, że nie był to zły inwestycyjny wybór.%SPEECH_OFF%Szlachcic osobiście wręcza ci sakiewkę %reward_completion% koron. | Komnata %employer%a to ul pracowitości. Dowódcy biegają tam i z powrotem, kłócąc się niezależnie od tego, po której stronie pokoju są i jak daleko od siebie, podczas gdy słudzy lawirują, by zapewnić im jedzenie. Wojna nie jest czasem na marnowanie energii na takie bzdury jak podnoszenie własnego płaszcza czy gotowanie posiłków. Dziwisz się, że nie ma sług karmiących ich między sporami.\n\nJednak %employer% stoi z boku. Przerzuca książkę, jakby był w wesołym ogrodzie. Podnosi wzrok. Spogląda na generałów, potem na ciebie.%SPEECH_ON%Dobra robota. Twoja zapłata.%SPEECH_OFF%Skrzynia zostaje powoli przesunięta w twoją stronę. W środku spoczywa %reward_completion% koron. | Sługa zatrzymuje cię, gdy próbujesz wejść do komnaty %employer%a. Wyjaśnia.%SPEECH_ON%Mam się z tobą spotkać tutaj z tą sakiewką %reward_completion% koron.%SPEECH_OFF%Zabierasz sakiewkę i kiwasz głową. | Próbujesz wejść do komnaty %employer%a, ale strażnik cię zatrzymuje.%SPEECH_ON%Tylko dla szlachty.%SPEECH_OFF%Odsuwasz halabardę z twarzy i mówisz, że masz interes do %employer%a. Strażnik opuszcza halabardę.%SPEECH_ON%Tylko dla szlachty.%SPEECH_OFF%Gdy już masz zacząć kłótnię, z komnaty wychodzi sługa z dużą sakiewką. Widzi znak %companyname% i wręcza ci sakiewkę.%SPEECH_ON%Twoje %reward_completion% korony. Obawiam się, że mój pan i jego dowódcy są zajęci.%SPEECH_OFF%I tak po prostu sługa znika. Strażnik spogląda na ciebie z góry.%SPEECH_ON%Tylko dla szlachty.%SPEECH_OFF% | Nagrodą za pomoc w zdobyciu %objective% jest %reward_completion% koron i drzwi zatrzaśnięte przed nosem. %employer% jest zbyt zajęty kłótniami z dowódcami, by ci bardziej pogratulować. | Jeden z dowódców %employer%a spotyka cię w przedsionku. Towarzyszy mu sługa z dużą sakiewką. Dowódca mówi.%SPEECH_ON%Ach, %companyname%. Masz niewiele honoru w swoim fachu, najemniku. Powinieneś być prawdziwym mężczyzną i walczyć z noblami. W tym, co robimy, jest wielki honor. Czemu nie dołączysz?%SPEECH_OFF%Duża sakiewka %reward_completion% koron trafia w twoje dłonie. Uśmiechasz się do dowódcy, a złote odbicie obramowuje twoje zęby.%SPEECH_ON%Tak, czemu nie?%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "%objective% upadło.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Wziąłeś udział w oblężeniu " + this.Flags.get("ObjectiveName"));
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
		this.m.Screens.push({
			ID = "Failure",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_22.png[/img]Cóż za katastrofa. Bitwa została przegrana, a ty wycofujesz się, by ocalić resztki ludzi. %objective% nie upadnie w najbliższym czasie.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Szlag niech trafi to przeklęte miejsce!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Zawiodłeś w oblężeniu " + this.Flags.get("ObjectiveName"));
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TooFarAway",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_36.png[/img]{Koncepcja upływu czasu najwyraźniej ci umknęła. Mimo twojej nieobecności oblężenie próbowało trwać dalej, ale ostatecznie upadło bez oczekiwanej pomocy %companyname%. Nie wracaj do %employer%a. | Zatrudniono cię, by pomóc w oblężeniu, a nie je porzucić. Bez %companyname% u boku żołnierze najpewniej będą musieli wycofać się z pola. | Za bardzo oddaliłeś się od oblężenia! Bez twojej pomocy napastnicy musieli się wycofać, a %objective% uniknęło podboju %employer%a. Skoro właśnie to miałeś pomóc osiągnąć, najlepiej będzie, jeśli nie wrócisz do szlachcica.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Racja, oblężenie...",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function spawnReliefForces()
	{
		local tile;
		local originTile = this.m.Origin.getTile();

		while (true)
		{
			local x = this.Math.rand(originTile.SquareCoords.X - 8, originTile.SquareCoords.X + 8);
			local y = this.Math.rand(originTile.SquareCoords.Y - 8, originTile.SquareCoords.Y + 8);

			if (!this.World.isValidTileSquare(x, y))
			{
				continue;
			}

			tile = this.World.getTileSquare(x, y);

			if (tile.getDistanceTo(originTile) <= 4)
			{
				continue;
			}

			if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Mountains)
			{
				continue;
			}

			break;
		}

		local enemyFaction = this.m.Origin.getOwner();
		local party = enemyFaction.spawnEntity(tile, "Armia " + this.m.Origin.getOwner().getName(), true, this.Const.World.Spawn.Noble, 200 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + enemyFaction.getBannerString());
		party.getSprite("banner").setBrush(enemyFaction.getBannerSmall());
		party.setDescription("Profesjonalni żołdacy na usługach miejscowych lordów.");
		party.setFootprintType(this.Const.World.FootprintsType.Nobles);
		party.getLoot().Money = this.Math.rand(50, 200);
		party.getLoot().ArmorParts = this.Math.rand(0, 25);
		party.getLoot().Medicine = this.Math.rand(0, 5);
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

		party.setAttackableByAI(false);
		this.m.UnitsSpawned.push(party.getID());
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(originTile);
		c.addOrder(move);
		local wait = this.new("scripts/ai/world/orders/wait_order");
		wait.setTime(10.0);
		c.addOrder(wait);
	}

	function spawnSupplyCaravan()
	{
		local tile;
		local originTile = this.m.Origin.getTile();

		while (true)
		{
			local x = this.Math.rand(originTile.SquareCoords.X - 7, originTile.SquareCoords.X + 7);
			local y = this.Math.rand(originTile.SquareCoords.Y - 7, originTile.SquareCoords.Y + 7);

			if (!this.World.isValidTileSquare(x, y))
			{
				continue;
			}

			tile = this.World.getTileSquare(x, y);

			if (tile.getDistanceTo(originTile) <= 4)
			{
				continue;
			}

			if (!tile.HasRoad)
			{
				continue;
			}

			break;
		}

		local enemyFaction = this.m.Origin.getOwner();
		local party = enemyFaction.spawnEntity(tile, "Karawana Zaopatrzeniowa", false, this.Const.World.Spawn.NobleCaravan, this.Math.rand(100, 150), this.getMinibossModifier());
		party.getSprite("base").Visible = false;
		party.setMirrored(true);
		party.setDescription("Karawana ze zbrojną eskortą, transportująca pomiędzy osadami żywność, zapasy i wyposażenie.");
		party.addToInventory("supplies/ground_grains_item");
		party.addToInventory("supplies/ground_grains_item");
		party.addToInventory("supplies/ground_grains_item");
		party.addToInventory("supplies/ground_grains_item");
		party.getLoot().Money = this.Math.rand(0, 100);
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(originTile);
		move.setRoadsOnly(true);
		c.addOrder(move);
		local despawn = this.new("scripts/ai/world/orders/despawn_order");
		c.addOrder(despawn);
	}

	function spawnSiege()
	{
		this.m.SituationID = this.m.Origin.addSituation(this.new("scripts/entity/world/settlements/situations/besieged_situation"));

		foreach( a in this.m.Origin.getActiveAttachedLocations() )
		{
			if (this.Math.rand(1, 100) <= 50)
			{
				a.spawnFireAndSmoke();
				a.setActive(false);
			}
		}

		local f = this.World.FactionManager.getFaction(this.getFaction());
		local castles = [];

		foreach( s in f.getSettlements() )
		{
			if (s.isMilitary())
			{
				castles.push(s);
			}
		}

		if (castles.len() == 0)
		{
			castles = clone f.getSettlements();
		}

		local originTile = this.m.Origin.getTile();
		local lastTile;

		for( local i = 0; i < 2; i = i )
		{
			local tile;

			while (true)
			{
				local x = this.Math.rand(originTile.SquareCoords.X - 1, originTile.SquareCoords.X + 1);
				local y = this.Math.rand(originTile.SquareCoords.Y - 1, originTile.SquareCoords.Y + 1);

				if (!this.World.isValidTileSquare(x, y))
				{
					continue;
				}

				tile = this.World.getTileSquare(x, y);

				if (tile.getDistanceTo(originTile) == 0)
				{
					continue;
				}

				if (tile.Type == this.Const.World.TerrainType.Ocean)
				{
					continue;
				}

				if (i == 0 && !tile.HasRoad && !this.m.Origin.isIsolatedFromRoads())
				{
					continue;
				}

				if (lastTile != null && tile.ID == lastTile.ID)
				{
					continue;
				}

				break;
			}

			lastTile = tile;
			local party = f.spawnEntity(tile, "Kompania " + castles[this.Math.rand(0, castles.len() - 1)].getName(), true, this.Const.World.Spawn.Noble, castles[this.Math.rand(0, castles.len() - 1)].getResources(), this.getMinibossModifier());
			party.setDescription("Zawodowi żołdacy na usługach miejscowych lordów.");
			party.setVisibilityMult(2.5);

			if (i == 0)
			{
				party.getSprite("body").setBrush("figure_siege_01");
				party.getSprite("base").Visible = false;
			}
			else
			{
				party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
			}

			party.setAttackableByAI(false);
			this.m.UnitsSpawned.push(party.getID());
			this.m.Allies.push(party.getID());
			party.getLoot().Money = this.Math.rand(50, 200);
			party.getLoot().ArmorParts = this.Math.rand(0, 25);
			party.getLoot().Medicine = this.Math.rand(0, 5);
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
			c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
			c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
			local wait = this.new("scripts/ai/world/orders/wait_order");
			wait.setTime(9000.0);
			c.addOrder(wait);
			i = ++i;
		}
	}

	function changeObjectiveOwner()
	{
		if (this.m.Origin.getFactionOfType(this.Const.FactionType.Settlement) != null)
		{
			this.m.Origin.getOwner().removeAlly(this.m.Origin.getFactionOfType(this.Const.FactionType.Settlement).getID());
		}

		this.m.Origin.removeFaction(this.m.Origin.getOwner().getID());
		this.World.FactionManager.getFaction(this.getFaction()).addSettlement(this.m.Origin.get());

		if (this.m.Origin.getFactionOfType(this.Const.FactionType.Settlement) != null)
		{
			this.World.FactionManager.getFaction(this.getFaction()).addAlly(this.m.Origin.getFactionOfType(this.Const.FactionType.Settlement).getID());
		}

		if (this.m.SituationID != 0)
		{
			this.m.Origin.removeSituationByInstance(this.m.SituationID);
			this.m.SituationID = 0;
		}

		this.m.Origin.addSituation(this.new("scripts/entity/world/settlements/situations/conquered_situation"), 3);
	}

	function flattenTerrain( _p )
	{
		if (_p.TerrainTemplate == "tactical.hills_steppe")
		{
			_p.TerrainTemplate = "tactical.steppe";
		}
		else if (_p.TerrainTemplate == "tactical.hills_tundra")
		{
			_p.TerrainTemplate = "tactical.tundra";
		}
		else if (_p.TerrainTemplate == "tactical.hills_snow" || _p.TerrainTemplate == "forest_snow")
		{
			_p.TerrainTemplate = "tactical.snow";
		}
		else if (_p.TerrainTemplate == "tactical.hills" || _p.TerrainTemplate == "tactical.mountain")
		{
			_p.TerrainTemplate = "tactical.plains";
		}
		else if (_p.TerrainTemplate == "tactical.hills" || _p.TerrainTemplate == "tactical.mountain")
		{
			_p.TerrainTemplate = "tactical.plains";
		}
		else if (_p.TerrainTemplate == "tactical.forest_leaves" || _p.TerrainTemplate == "tactical.forest" || _p.TerrainTemplate == "tactical.autumn")
		{
			_p.TerrainTemplate = "tactical.plains";
		}
		else if (_p.TerrainTemplate == "tactical.swamp")
		{
			_p.TerrainTemplate = "tactical.plains";
		}
	}

	function onCommanderPlaced( _entity, _tag )
	{
		_entity.setName(this.m.Flags.get("CommanderName"));
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective",
			this.m.Flags.get("ObjectiveName")
		]);
		_vars.push([
			"noblefamily",
			this.World.FactionManager.getFaction(this.getFaction()).getName()
		]);
		_vars.push([
			"rivalhouse",
			this.m.Flags.get("RivalHouse")
		]);
		_vars.push([
			"commander",
			this.m.Flags.get("CommanderName")
		]);
		_vars.push([
			"direction",
			this.m.Origin == null || this.m.Origin.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Origin.getTile())]
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			foreach( id in this.m.UnitsSpawned )
			{
				local e = this.World.getEntityByID(id);

				if (e != null && e.isAlive())
				{
					local c = e.getController();
					c.clearOrders();

					if (e.isAlliedWithPlayer())
					{
						local wait = this.new("scripts/ai/world/orders/wait_order");
						wait.setTime(60.0);
						c.addOrder(wait);
					}
				}
			}

			if (this.m.Origin != null && !this.m.Origin.isNull())
			{
				this.m.Origin.getSprite("selection").Visible = false;
				this.m.Origin.setOnCombatWithPlayerCallback(null);
				this.m.Origin.setAttackable(false);
			}

			if (this.m.Home != null && !this.m.Home.isNull())
			{
				this.m.Home.getSprite("selection").Visible = false;
			}
		}

		if (this.m.Origin != null && !this.m.Origin.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Origin.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(2);
			}
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return false;
		}

		if (this.m.Origin == null || this.m.Origin.isNull() || this.m.Origin.getFaction() == this.getFaction())
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		this.contract.onSerialize(_out);
		_out.writeU8(this.m.Allies.len());

		foreach( ally in this.m.Allies )
		{
			_out.writeU32(ally);
		}
	}

	function onDeserialize( _in )
	{
		this.contract.onDeserialize(_in);
		local numAllies = _in.readU8();

		for( local i = 0; i < numAllies; i = i )
		{
			this.m.Allies.push(_in.readU32());
			i = ++i;
		}
	}

});

