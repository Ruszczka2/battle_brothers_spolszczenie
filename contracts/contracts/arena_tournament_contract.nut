this.arena_tournament_contract <- this.inherit("scripts/contracts/contract", {
	m = {},
	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = 1.3;
		this.m.Type = "contract.arena_tournament";
		this.m.Name = "Turniej na Arenie";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 1.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local items = [];
		items.extend(this.Const.Items.NamedWeapons);
		items.extend(this.Const.Items.NamedHelmets);
		items.extend(this.Const.Items.NamedArmors);
		local item = this.new("scripts/items/" + items[this.Math.rand(0, items.len() - 1)]);
		this.m.Flags.set("PrizeName", item.createRandomName());
		this.m.Flags.set("PrizeScript", item.ClassNameHash);

		if (item.isItemType(this.Const.Items.ItemType.Weapon))
		{
			this.m.Flags.set("PrizeType", "weapon");
		}
		else if (item.isItemType(this.Const.Items.ItemType.Shield))
		{
			this.m.Flags.set("PrizeType", "shield");
		}
		else if (item.isItemType(this.Const.Items.ItemType.Armor))
		{
			this.m.Flags.set("PrizeType", "armor");
		}
		else if (item.isItemType(this.Const.Items.ItemType.Helmet))
		{
			this.m.Flags.set("PrizeType", "helmet");
		}

		this.m.Flags.set("Round", 1);
		this.m.Flags.set("RewardApplied", 0);
		this.m.Flags.set("Opponents1", this.getOpponents(1).I);
		this.m.Flags.set("Opponents2", this.getOpponents(2).I);
		this.m.Flags.set("Opponents3", this.getOpponents(3).I);
		this.contract.start();
	}

	function getOpponents( _round, _index = -1 )
	{
		local twists = [];

		if (_round >= 2)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Swordmaster);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, _d - this.Const.World.Spawn.Troops.Swordmaster.Cost); i = i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Mercenary);
						i = ++i;
					}
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 50 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Swordmaster, true);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, _d - this.Const.World.Spawn.Troops.Swordmaster.Cost * 2); i = i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Mercenary);
						i = ++i;
					}
				}

			});
		}

		if (_round >= 2)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.HedgeKnight);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, _d - this.Const.World.Spawn.Troops.HedgeKnight.Cost); i = i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Mercenary);
						i = ++i;
					}
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 50 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.HedgeKnight, true);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, _d - this.Const.World.Spawn.Troops.HedgeKnight.Cost * 2); i = i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Mercenary);
						i = ++i;
					}
				}

			});
		}

		if (_round == 3)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.HedgeKnight);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Swordmaster);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.BanditRaider, _d - this.Const.World.Spawn.Troops.HedgeKnight.Cost - this.Const.World.Spawn.Troops.Swordmaster.Cost); i = i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.BanditRaider);
						i = ++i;
					}
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 150 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.HedgeKnight, true);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Swordmaster, true);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.MasterArcher, true);
				}

			});
		}

		if (_round == 3)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Swordmaster);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, _d - this.Const.World.Spawn.Troops.DesertDevil.Cost - this.Const.World.Spawn.Troops.Swordmaster.Cost); i = i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.NomadOutlaw);
						i = ++i;
					}
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 150 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil, true);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Swordmaster, true);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, _d - this.Const.World.Spawn.Troops.DesertDevil.Cost * 2 - this.Const.World.Spawn.Troops.Swordmaster.Cost * 2); i = i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.NomadOutlaw);
						i = ++i;
					}
				}

			});
		}

		if (_round >= 2)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, _d - this.Const.World.Spawn.Troops.DesertDevil.Cost); i = i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.NomadOutlaw);
						i = ++i;
					}
				}

			});
		}

		if (_round == 3)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Executioner);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _d - this.Const.World.Spawn.Troops.Executioner.Cost); i = i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
						i = ++i;
					}
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 50 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Executioner, true);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _d - this.Const.World.Spawn.Troops.Executioner.Cost * 2); i = i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
						i = ++i;
					}
				}

			});
		}

		if (_round == 3)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Executioner);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _d - this.Const.World.Spawn.Troops.DesertDevil.Cost - this.Const.World.Spawn.Troops.Executioner.Cost); i = i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
						i = ++i;
					}
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 150 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil, true);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Executioner, true);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _d - this.Const.World.Spawn.Troops.DesertDevil.Cost * 2 - this.Const.World.Spawn.Troops.Executioner.Cost * 2); i = i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
						i = ++i;
					}
				}

			});
		}

		if (_round == 3)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertStalker);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Executioner);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, _d - this.Const.World.Spawn.Troops.DesertDevil.Cost - this.Const.World.Spawn.Troops.Executioner.Cost - this.Const.World.Spawn.Troops.DesertStalker.Cost); i = i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.NomadOutlaw);
						i = ++i;
					}
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 150 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil, true);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertStalker, true);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Executioner, true);
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 50 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator, true);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _d - this.Const.World.Spawn.Troops.Gladiator.Cost * 2); i = i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
						i = ++i;
					}
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 150 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator, true);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator, true);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _d - this.Const.World.Spawn.Troops.Gladiator.Cost * 4); i = i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
						i = ++i;
					}
				}

			});
		}

		if (_round == 2)
		{
			twists.push({
				R = 10,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, _d); i = i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Mercenary);
						i = ++i;
					}
				}

			});
		}

		if (_round == 3 && this.Const.DLC.Unhold)
		{
			twists.push({
				R = 10,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Unhold, _d); i = i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Unhold);
						i = ++i;
					}
				}

			});
		}

		if (_round == 3 && this.Const.DLC.Lindwurm)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < this.Math.min(3, _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Lindwurm, _d)); i = i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Lindwurm);
						i = ++i;
					}
				}

			});
		}

		if (_round == 2)
		{
			twists.push({
				R = 10,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.SandGolemMEDIUM, _d); i = i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.SandGolemMEDIUM);
						i = ++i;
					}
				}

			});
		}

		if (_round == 2)
		{
			twists.push({
				R = 10,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _d); i = i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
						i = ++i;
					}
				}

			});
		}

		if (_round == 1 && this.Const.DLC.Unhold)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Spider, _d); i = i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Spider);
						i = ++i;
					}
				}

			});
		}

		if (_round <= 2)
		{
			twists.push({
				R = 10,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, _d); i = i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.NomadOutlaw);
						i = ++i;
					}
				}

			});
		}

		if (_round == 1)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Serpent, _d); i = i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Serpent);
						i = ++i;
					}
				}

			});
		}

		if (_round == 1)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.HyenaHIGH, _d); i = i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.HyenaHIGH);
						i = ++i;
					}
				}

			});
		}

		if (_index >= 0)
		{
			return {
				I = _index,
				F = twists[_index].F
			};
		}
		else
		{
			local maxR = 0;

			foreach( t in twists )
			{
				maxR = maxR + t.R;
			}

			local r = this.Math.rand(1, maxR);

			foreach( i, t in twists )
			{
				if (r <= t.R)
				{
					return {
						I = i,
						F = t.F
					};
				}
				else
				{
					r = r - t.R;
				}
			}
		}
	}

	function startTournamentRound()
	{
		local p = this.Const.Tactical.CombatInfo.getClone();
		p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
		p.CombatID = "Arena";
		p.TerrainTemplate = "tactical.arena";
		p.LocationTemplate.Template[0] = "tactical.arena_floor";
		p.Music = this.Const.Music.ArenaTracks;
		p.Ambience[0] = this.Const.SoundAmbience.ArenaBack;
		p.Ambience[1] = this.Const.SoundAmbience.ArenaFront;
		p.AmbienceMinDelay[0] = 0;
		p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
		p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Arena;
		p.IsUsingSetPlayers = true;
		p.IsFleeingProhibited = true;
		p.IsLootingProhibited = true;
		p.IsWithoutAmbience = true;
		p.IsFogOfWarVisible = false;
		p.IsArenaMode = true;
		p.IsAutoAssigningBases = false;
		local bros = this.getBros();

		for( local i = 0; i < bros.len() && i < 5; i = i )
		{
			p.Players.push(bros[i]);
			i = ++i;
		}

		p.Entities = [];
		local baseDifficulty = 45 + 10 * this.m.Flags.get("Round");
		baseDifficulty = baseDifficulty * this.getScaledDifficultyMult();
		local opponents = this.getOpponents(this.m.Flags.get("Round"), this.m.Flags.get("Opponents" + this.m.Flags.get("Round")));
		opponents.F(this, baseDifficulty, p.Entities);

		for( local i = 0; i < p.Entities.len(); i = i )
		{
			p.Entities[i].Faction <- this.getFaction();
			i = ++i;
		}

		this.World.Contracts.startScriptedCombat(p, false, false, false);
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Wyekwipuj do pięciu swoich ludzi w obroże areny",
					"Jeszcze raz wejdź na arenę, by rozpocząć pierwszą rundę",
					"Każda runda będzie toczyć się do śmierci, bez możliwości ucieczki i ograbienia poległych",
					"Po każdej rundzie możesz zrezygnować lub natychmiastowo rozpocząć kolejną rundę"
				];
				this.Contract.m.BulletpointsPayment = [
					"Otrzymasz %prizetype% o nazwie %prizename% za wygranie wszystkich trzech rund"
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.Flags.set("Day", this.World.getTime().Days);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Flags.get("Round") > 1 && this.Contract.getBros() == 0)
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsFailure"))
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.World.getTime().Days > this.Flags.get("Day") + 1)
				{
					this.Contract.setScreen("Failure2");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("Round") > 1)
				{
					this.Contract.setScreen("Won" + this.Flags.get("Round"));
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Arena")
				{
					this.Flags.increment("Round");
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Arena")
				{
					this.Flags.set("IsFailure", true);
				}
			}

		});
	}

	function createScreens()
	{
		this.m.Screens.push({
			ID = "Task",
			Title = "Na Arenie",
			Text = "",
			Image = "",
			List = [],
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Zdobędziemy główną nagrodę!}",
					function getResult()
					{
						return "Overview";
					}

				},
				{
					Text = "{Nie jesteśmy na to gotowi.}",
					function getResult()
					{
						this.Contract.getHome().removeSituationByID("situation.arena_tournament");
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.State.getTownScreen().getMainDialogModule().reload();
						return 0;
					}

				}
			],
			function start()
			{
				this.Text = "[img]gfx/ui/events/event_155.png[/img]Dziesiątki ludzi kłębią się przy wejściu na arenę. Jedni stoją stoicko, nie chcąc zdradzać swych możliwości. Inni przechwalają się i pysznią z rozmachem, albo szczerze pewni swoich umiejętności, albo licząc, że brawura ukryje braki w ich grze.\n\n";
				this.Text += "Mistrz areny, zwykle najbardziej obojętny człowiek, jakiego poznałeś w ciekawym fachu, dziś jest wyjątkowo ożywiony. Podaje ci zwój w jednej dłoni, a drugą unosi trzy palce.%SPEECH_ON%Trzy rundy! Trzy rundy, jedna po drugiej i każda trudniejsza od poprzedniej. Wygraj wszystkie trzy tymi samymi pięcioma ludźmi, a dostaniesz główną nagrodę: słynny %prizetype% o nazwie %prizename%! Toż to turniej! Wchodzisz czy nie?%SPEECH_OFF%";
				this.Text += "Mistrz areny ciągnie dalej.%SPEECH_ON%Gdy będziecie gotowi, niech ludzie, którzy będą walczyć, założą obroże areny, które wam damy.%SPEECH_OFF%";
			}

		});
		this.m.Screens.push({
			ID = "Overview",
			Title = "Podgląd",
			Text = "Ta walka na arenie odbędzie się na następujących zasadach. Zgadzasz się na te warunki?",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Dołączamy do turnieju!",
					function getResult()
					{
						for( local i = 0; i < 5; i = i )
						{
							this.World.Assets.getStash().add(this.new("scripts/items/accessory/special/arena_collar_item"));
							i = ++i;
						}

						this.Contract.setState("Running");
						return 0;
					}

				},
				{
					Text = "Muszę to przemyśleć.",
					function getResult()
					{
						return 0;
					}

				}
			],
			ShowObjectives = true,
			ShowPayment = true,
			function start()
			{
				this.Contract.m.IsNegotiated = true;
			}

		});
		this.m.Screens.push({
			ID = "Start",
			Title = "Na Arenie",
			Text = "[img]gfx/ui/events/event_155.png[/img]{Gdy czekasz na swoją kolej, żądza krwi tłumu pełznie w mroku, z góry opadają płaty kurzu, a tupot stóp grzmi jak burza. Szepczą w oczekiwaniu i ryczą przy zabijaniu. Cisza między walkami trwa zaledwie chwilę i zostaje rozdarta, gdy zardzewiała krata idzie w górę, łańcuchy zgrzytają, a tłum znowu wrze. Wychodzicie na światło i hałas uderza w serce tak mocno, że mógłby poderwać martwego... | Tłum na arenie stoi bark w bark, większość bełkocze po pijanemu. Krzyczą i wrzeszczą, ich języki mieszają lokalne i obce, choć do żądzy krwi nie potrzeba wielu słów ponad ich obłąkane twarze i zaciśnięte pięści. Teraz ludzie %companyname% nasycą tych szaleńców... | Sprzątacze krzątają się po arenie. Wloką ciała, zbierają to, co warto zebrać, i od czasu do czasu rzucają trofeum w tłum, wywołując wśród widzów mobowe odgrywanie walk. %companyname% jest teraz częścią tego widowiska. | Arena czeka, tłum płonie, a kolej %companyname% na zdobycie chwały nadeszła! | Tłum grzmi, gdy ludzie %companyname% wkraczają do krwawego dołu. Mimo bezmyślnej żądzy krwi nie możesz powstrzymać dumy, wiedząc, że to twoja kompania ma dać pokaz. | Krata unosi się. Nie słychać nic poza brzękiem łańcuchów, skrzypieniem bloczków i chrząkaniem niewolników przy pracy. Gdy ludzie %companyname% wychodzą z wnętrzności areny, słyszą chrzęst piasku pod stopami, aż stają w samym środku dołu. Z góry stadionu rozdziera się dziwny krzyk, w jakimś obcym języku, lecz słowa rozbrzmiewają tylko raz, zanim tłum wybucha wiwatami i rykiem. To czas, by twoi ludzie udowodnili swoją wartość przed czujnym okiem pospólstwa. | Sprawy %companyname% rzadko dzieją się na oczach tych, którzy wolą trzymać się z dala od takiej przemocy. Ale na arenie pospólstwo zachłannie czeka na śmierć i cierpienie, warczy z żądzy krwi, gdy wasi ludzie wchodzą na piaski, i ryczy, gdy najemnicy dobywają broni i szykują się do walki. | Arena jest jak lej po wrzodzie, jej dach został wyrwany przez bogów, odsłaniając próżność, żądzę krwi i dzikość człowieka. A to człowiek tam, krzyczący i wyjący; gdy krew pryska, myją nią twarze i szczerzą się do siebie, jakby to był żart. Walczą o trofea i rozkoszują się cudzym bólem. I przed tymi ludźmi %companyname% będzie walczyć, i dla nich będzie zabawiać, i zabawiać dobrze. | Tłum areny to mieszanina klas, bogatych i biednych, bo tylko Wizyrzy odgradzają się w lożach ponad wszystkimi. Na chwilę zjednoczone, ludy %townname% łaskawie przyszły, by oglądać, jak ludzie i potwory mordują się nawzajem. Z przyjemnością %companyname% dokłada swoje trzy grosze. | Chłopcy siedzą na barkach ojców, młode dziewczęta rzucają gladiatorom kwiaty, kobiety wachlują się, mężczyźni zastanawiają się, czy sami by potrafili. Oto ludzie areny - a reszta jest pijana w sztok i wrzeszczy bzdury. Masz nadzieję, że %companyname% zdoła zapewnić tej szalonej zgrai choć godzinę lub dwie rozrywki. | Tłum ryczy, gdy ludzie %companyname% wchodzą na piaski. Głupiec pomyliłby ekscytację z życzliwością, bo ledwie kończy się aplauz, lecą puste kufle po piwie i zgniłe pomidory, a także ogólne chichoty widzów. Zastanawiasz się, czy ludzie %companyname% naprawdę najlepiej się tu przydadzą, ale potem myślisz o złocie i chwale do zdobycia, i o tym, że na koniec dnia te kundelki na trybunach wrócą do swoich gównianych żyć, a ty wrócisz do swojego gównianego życia, tylko kieszeń będzie odrobinę cięższa.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wygrajmy tę nagrodę!",
					function getResult()
					{
						this.Contract.startTournamentRound();
						return 0;
					}

				},
				{
					Text = "Nie ma mowy. Nie chcę umierać!",
					function getResult()
					{
						this.Contract.getHome().removeSituationByID("situation.arena_tournament");
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.State.getTownScreen().getMainDialogModule().reload();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnArenaCancel);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Won2",
			Title = "Na Arenie",
			Text = "[img]gfx/ui/events/event_147.png[/img]{Pierwsza z trzech bitew dobiegła końca. Musisz uważnie ocenić swoich ludzi i to, czy zdołają przejść do kolejnej rundy, która będzie tylko trudniejsza od poprzedniej. Tak jak nie znajdziesz dumy w grobie, tak i w rezygnacji nie ma wstydu. Wciąż dostaniesz trochę monet, ale stracisz szansę na główną nagrodę.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Następną rundę też wygramy!",
					function getResult()
					{
						this.Contract.startTournamentRound();
						return 0;
					}

				},
				{
					Text = "Czas, abyśmy wypisali się z turnieju.",
					function getResult()
					{
						return "DropOut";
					}

				}
			],
			function start()
			{
				if (this.Flags.getAsInt("RewardsApplied") < 2)
				{
					this.Flags.set("RewardsApplied", 2);
					this.World.Statistics.getFlags().increment("ArenaFightsWon", 1);

					if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 10)
					{
						this.updateAchievement("Gladiator", 1, 1);
					}

					this.Contract.updateTraits(this.List);
				}

				this.Contract.m.BulletpointsObjectives = [
					"Następna runda rozpocznie się automatycznie",
					"Każda runda będzie toczyć się do śmierci, bez możliwości ucieczki i ograbienia poległych",
					"Po każdej rundzie możesz zrezygnować lub natychmiastowo rozpocząć kolejną rundę"
				];
			}

		});
		this.m.Screens.push({
			ID = "Won3",
			Title = "Na Arenie",
			Text = "[img]gfx/ui/events/event_147.png[/img]Przedostatnia walka wygrana, a przed tobą wybór: zrezygnować teraz czy podjąć ostateczny bój o główną nagrodę.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do ostatniej rundy!",
					function getResult()
					{
						this.Contract.startTournamentRound();
						return 0;
					}

				},
				{
					Text = "Czas, abyśmy wypisali się z turnieju.",
					function getResult()
					{
						return "DropOut";
					}

				}
			],
			function start()
			{
				if (this.Flags.getAsInt("RewardsApplied") < 3)
				{
					this.Flags.set("RewardsApplied", 3);
					this.World.Statistics.getFlags().increment("ArenaFightsWon", 1);

					if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 10)
					{
						this.updateAchievement("Gladiator", 1, 1);
					}

					this.Contract.updateTraits(this.List);
				}
			}

		});
		this.m.Screens.push({
			ID = "Won4",
			Title = "Na Arenie",
			Text = "[img]gfx/ui/events/event_147.png[/img]Walka dobiegła końca, a tępe dudnienie w uszach to ryk tłumu, który w eksplozji świętującej ekstazy przytłacza wszystkie zmysły. Jesteś tylko awatarem ludu, totemem, przez który mogą zastępczo elektryzować własną próżność i pusty heroizm. Oprócz uwielbienia tłumu otrzymujesz główną nagrodę: %prizename%!",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Zwycięstwo!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess * 2);
						this.Contract.getHome().removeSituationByID("situation.arena_tournament");
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Flags.set("RewardsApplied", 4);
				this.World.Statistics.getFlags().increment("ArenaFightsWon", 1);

				if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 10)
				{
					this.updateAchievement("Gladiator", 1, 1);
				}

				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new(this.IO.scriptFilenameByHash(this.Flags.get("PrizeScript")));
				item.setName(this.Flags.get("PrizeName"));
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 12,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + item.getName()
				});
				this.Contract.updateTraits(this.List);
			}

		});
		this.m.Screens.push({
			ID = "DropOut",
			Title = "Na Arenie",
			Text = "[img]gfx/ui/events/event_147.png[/img]{Decydujesz się opuścić turniej i zachować ludzi, by walczyli innego dnia. Nie słychać buczenia ani syków, bo wszystko dzieje się w brzuchu areny. To co najwyżej sprawa urzędowa, niewielka wymiana odszkodowania i wypuszczają was w drogę. Nikt nie robi wyrzutów, zwłaszcza nie inni gladiatorzy, którzy lepiej niż ktokolwiek rozumieją sens tej decyzji. A tłum? Oni chcą tylko krwi, nawet nie zauważą, których ciał już nie ma.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Może następnym razem.",
					function getResult()
					{
						this.Contract.getHome().removeSituationByID("situation.arena_tournament");
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				local money = (this.Flags.get("Round") - 1) * 1000;
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "Na Arenie",
			Text = "[img]gfx/ui/events/event_147.png[/img]{Ludzie %companyname% zostali pokonani, martwi albo, co gorsza, straszliwie poharatani. Przynajmniej tłumy są zadowolone. Na piaskach każde widowisko, nawet to kończące się śmiercią, jest dobrym widowiskiem.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Katastrofa!",
					function getResult()
					{
						local roster = this.World.getPlayerRoster().getAll();

						foreach( bro in roster )
						{
							local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

							if (item != null && item.getID() == "accessory.arena_collar")
							{
								bro.getFlags().increment("ArenaFights", 1);
							}
						}

						this.Contract.getHome().removeSituationByID("situation.arena_tournament");
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "Na Arenie",
			Text = "{[img]gfx/ui/events/event_155.png[/img]Czas waszej walki na arenie nadszedł i minął, ale się nie pojawiliście. Być może wydarzyło się coś ważniejszego, albo po prostu chowaliście się jak tchórze. Tak czy inaczej, wasza reputacja na tym ucierpi.",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Ale...",
					function getResult()
					{
						this.Contract.getHome().removeSituationByID("situation.arena_tournament");
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Collars",
			Title = "Na Arenie",
			Text = "{[img]gfx/ui/events/event_155.png[/img]Nadszedł czas waszej walki na arenie, ale żaden z waszych ludzi nie ma obroży areny, więc nie wpuszczono was do środka.\n\nZdecyduj, kto ma walczyć, zakładając im otrzymane obroże areny, a pojedynek rozpocznie się, gdy ponownie wejdziesz na arenę.",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Och, racja!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
	}

	function getBros()
	{
		local ret = [];
		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && item.getID() == "accessory.arena_collar")
			{
				ret.push(bro);
			}
		}

		return ret;
	}

	function updateTraits( _list )
	{
		local roster = this.World.getPlayerRoster().getAll();
		local n = 0;

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && item.getID() == "accessory.arena_collar")
			{
				local skill;
				bro.getFlags().increment("ArenaFightsWon", 1);
				bro.getFlags().increment("ArenaFights", 1);

				if (bro.getFlags().getAsInt("ArenaFightsWon") == 1)
				{
					skill = this.new("scripts/skills/traits/arena_pit_fighter_trait");
					bro.getSkills().add(skill);
					_list.push({
						id = 10,
						icon = skill.getIcon(),
						text = bro.getName() + " to teraz " + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
					});
				}
				else if (bro.getFlags().getAsInt("ArenaFightsWon") == 5)
				{
					bro.getSkills().removeByID("trait.pit_fighter");
					skill = this.new("scripts/skills/traits/arena_fighter_trait");
					bro.getSkills().add(skill);
					_list.push({
						id = 10,
						icon = skill.getIcon(),
						text = bro.getName() + " to teraz " + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
					});
				}
				else if (bro.getFlags().getAsInt("ArenaFightsWon") == 12)
				{
					bro.getSkills().removeByID("trait.arena_fighter");
					skill = this.new("scripts/skills/traits/arena_veteran_trait");
					bro.getSkills().add(skill);
					_list.push({
						id = 10,
						icon = skill.getIcon(),
						text = bro.getName() + " to teraz " + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
					});
				}

				n = ++n;
				n = n;
			}

			if (n >= 5)
			{
				break;
			}
		}
	}

	function getAmountToSpawn( _type, _resources, _min = 1, _max = 24 )
	{
		return this.Math.min(_max, this.Math.max(_min, _resources / _type.Cost));
	}

	function addToCombat( _list, _entityType, _champion = false )
	{
		local c = clone _entityType;

		if (c.Variant != 0 && _champion)
		{
			c.Variant = 1;
		}
		else
		{
			c.Variant = 0;
		}

		if (c.Variant != 0 && "NameList" in _entityType)
		{
			c.Name <- this.Const.World.Common.generateName(_entityType.NameList) + (_entityType.TitleList != null ? " " + _entityType.TitleList[this.Math.rand(0, _entityType.TitleList.len() - 1)] : "");
		}

		_list.push(c);
	}

	function getScaledDifficultyMult()
	{
		local p = this.World.State.getPlayer().getStrength();
		p = p / this.World.getPlayerRoster().getSize();
		p = p * 12;
		local s = this.Math.maxf(0.75, 1.0 * this.Math.pow(0.01 * p, 0.95) + this.Math.minf(0.5, this.World.getTime().Days * 0.005));
		local d = this.Math.minf(5.0, s);
		return d * this.Const.Difficulty.EnemyMult[this.World.Assets.getCombatDifficulty()];
	}

	function setScreenForArena()
	{
		if (!this.m.IsActive)
		{
			return;
		}

		if (this.getBros().len() == 0)
		{
			this.setScreen("Collars");
		}
		else if (this.World.getTime().Days > this.m.Flags.get("Day") + 1)
		{
			this.setScreen("Failure2");
		}
		else
		{
			this.setScreen("Start");
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"prizename",
			this.m.Flags.get("PrizeName")
		]);
		_vars.push([
			"prizetype",
			this.m.Flags.get("PrizeType")
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.m.Home.getSprite("selection").Visible = false;
			this.m.Home.getBuilding("building.arena").refreshCooldown();
			local roster = this.World.getPlayerRoster().getAll();

			foreach( bro in roster )
			{
				local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

				if (item != null && item.getID() == "accessory.arena_collar")
				{
					bro.getItems().unequip(item);
				}
			}

			local items = this.World.Assets.getStash().getItems();

			foreach( i, item in items )
			{
				if (item != null && item.getID() == "accessory.arena_collar")
				{
					items[i] = null;
				}
			}
		}

		this.m.Home.removeSituationByID("situation.arena_tournament");
	}

	function isValid()
	{
		return this.Const.DLC.Desert;
	}

	function onSerialize( _out )
	{
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.contract.onDeserialize(_in);
	}

});

