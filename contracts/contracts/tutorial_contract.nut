this.tutorial_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Location = null,
		BigCity = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.tutorial";
		this.m.Name = "%companyname%";
		this.m.TimeOut = this.Time.getVirtualTimeF() + 9000.0;
	}

	function start()
	{
		local settlements = this.World.EntityManager.getSettlements();
		local best_dist = 9000;
		local best_start;
		local best_big;

		foreach( s in settlements )
		{
			if (s.isMilitary() || s.getSize() > 1 || s.isIsolatedFromRoads())
			{
				continue;
			}

			local bestDist = 9000;
			local best;

			foreach( b in settlements )
			{
				if (s.getID() == b.getID())
				{
					continue;
				}

				if (b.getSize() <= 1 || b.isIsolatedFromRoads())
				{
					continue;
				}

				local d = s.getTile().getDistanceTo(b.getTile());

				if (d < bestDist)
				{
					bestDist = d;
					best = b;
				}
			}

			if (best != null && bestDist < best_dist)
			{
				best_dist = bestDist;
				best_start = s;
				best_big = best;
			}
		}

		this.setHome(best_start);
		this.setOrigin(best_start);
		this.m.Home.setVisited(true);
		this.m.Home.setDiscovered(true);
		this.World.uncoverFogOfWar(this.m.Home.getTile().Pos, 500.0);
		this.m.Faction = best_start.getFactions()[0];
		this.m.EmployerID = this.World.FactionManager.getFaction(this.m.Faction).getRandomCharacter().getID();
		this.m.BigCity = this.WeakTableRef(best_big);
		local tile = this.getTileToSpawnLocation(this.m.Home.getTile(), 5, 8, [
			this.Const.World.TerrainType.Swamp,
			this.Const.World.TerrainType.Forest,
			this.Const.World.TerrainType.LeaveForest,
			this.Const.World.TerrainType.SnowyForest,
			this.Const.World.TerrainType.Shore,
			this.Const.World.TerrainType.Ocean,
			this.Const.World.TerrainType.Mountains
		]);
		this.World.State.getPlayer().setPos(tile.Pos);
		this.World.getCamera().jumpTo(this.World.State.getPlayer());
		this.m.Flags.set("BossName", "Hoggart Łasica");
		this.m.Flags.set("LocationName", "Kryjówka Hoggarta");
		this.setState("StartingBattle");
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "StartingBattle",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Zabij Hoggarta Łasicę"
				];
				this.World.State.m.IsAutosaving = false;
			}

			function update()
			{
				if (!this.Flags.get("IsTutorialBattleDone"))
				{
					if (!this.Flags.get("IsIntroShown"))
					{
						this.Flags.set("IsIntroShown", true);
						this.Sound.play("sounds/intro_battle.wav");
						this.Contract.setScreen("Intro");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.CivilianTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "Tutorial1";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Custom;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Custom;
						p.PlayerDeploymentCallback = this.onPlayerDeployment.bindenv(this);
						p.EnemyDeploymentCallback = this.onAIDeployment.bindenv(this);
						p.IsFleeingProhibited = true;
						p.IsAutoAssigningBases = false;
						this.World.Contracts.startScriptedCombat(p, false, false, false);
					}
				}
				else
				{
					this.Contract.setScreen("IntroAftermath");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Tutorial1")
				{
					this.Flags.set("IsTutorialBattleDone", true);
					local brothers = this.World.getPlayerRoster().getAll();
					brothers[0].setIsAbleToDie(true);
					brothers[1].setIsAbleToDie(true);
					brothers[2].setIsAbleToDie(true);
					this.World.State.m.IsAutosaving = true;
				}
			}

			function onPlayerDeployment()
			{
				for( local x = 0; x != 32; x = x )
				{
					for( local y = 0; y != 32; y = y )
					{
						local tile = this.Tactical.getTileSquare(x, y);
						tile.Level = 0;

						if (x > 11 && x < 22 && y > 12 && y < 21)
						{
							tile.removeObject();

							if (tile.IsHidingEntity)
							{
								tile.clear();
								tile.IsHidingEntity = false;
							}
						}

						y = ++y;
					}

					x = ++x;
				}

				this.Tactical.fillVisibility(this.Const.Faction.Player, true);
				local brothers = this.World.getPlayerRoster().getAll();
				this.Tactical.addEntityToMap(brothers[0], 13, 15 - 13 / 2);
				brothers[0].setIsAbleToDie(false);
				this.Tactical.addEntityToMap(brothers[1], 13, 16 - 13 / 2);
				brothers[1].setIsAbleToDie(false);
				this.Tactical.addEntityToMap(brothers[2], 12, 18 - 12 / 2);
				brothers[2].setIsAbleToDie(false);
				this.Tactical.CameraDirector.addJumpToTileEvent(0, this.Tactical.getTile(6, 17 - 6 / 2), 0, null, null, 0, 0);
				this.Tactical.CameraDirector.addMoveSlowlyToTileEvent(0, this.Tactical.getTile(18, 17 - 18 / 2), 0, null, null, 0, 1000);
				this.Contract.spawnBlood(11, 12);
				this.Contract.spawnBlood(13, 15);
				this.Contract.spawnBlood(14, 17);
				this.Contract.spawnBlood(15, 16);
				this.Contract.spawnBlood(17, 14);
				this.Contract.spawnBlood(15, 15);
				this.Contract.spawnBlood(18, 16);
				this.Contract.spawnBlood(12, 14);
				this.Contract.spawnBlood(13, 16);
				this.Contract.spawnBlood(12, 15);
				this.Contract.spawnBlood(16, 18);
				this.Contract.spawnBlood(15, 17);
				this.Contract.spawnArrow(13, 13);
				this.Contract.spawnArrow(14, 17);
				this.Contract.spawnArrow(17, 15);
				this.Contract.spawnCorpse(12, 13);
				this.Contract.spawnCorpse(16, 14);
				this.Contract.spawnCorpse(17, 16);
				this.Contract.spawnCorpse(15, 14);
				this.Contract.spawnCorpse(14, 18);
			}

			function onAIDeployment()
			{
				local e;
				this.Const.Movement.AnnounceDiscoveredEntities = false;
				e = this.Tactical.spawnEntity("scripts/entity/tactical/humans/bounty_hunter", 16, 16 - 16 / 2);
				e.setFaction(this.Const.Faction.PlayerAnimals);
				e.setName("Jednooki");
				e.getSprite("socket").setBrush("bust_base_player");
				e.assignRandomEquipment();
				e.getSkills().removeByID("perk.overwhelm");
				e.getSkills().removeByID("perk.nimble");
				e.getItems().getItemAtSlot(this.Const.ItemSlot.Body).setArmor(0);

				if (e.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					e.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				if (e.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					e.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				e.getBaseProperties().Hitpoints = 5;
				e.getBaseProperties().MeleeSkill = -200;
				e.getBaseProperties().RangedSkill = 0;
				e.getBaseProperties().MeleeDefense = -200;
				e.getBaseProperties().Initiative = 200;
				e.getSkills().update();
				e.setHitpoints(5);
				e = this.Tactical.spawnEntity("scripts/entity/tactical/humans/bounty_hunter", 15, 18 - 15 / 2);
				e.setFaction(this.Const.Faction.PlayerAnimals);
				e.setName("Kapitan Bernhard");
				e.getSprite("socket").setBrush("bust_base_player");
				e.getSkills().removeByID("perk.overwhelm");
				e.getSkills().removeByID("perk.nimble");
				local armor = this.new("scripts/items/armor/mail_hauberk");
				armor.setVariant(32);
				armor.setArmor(0);
				e.getItems().equip(armor);
				e.getItems().equip(this.new("scripts/items/weapons/arming_sword"));
				e.getBaseProperties().Hitpoints = 9;
				e.getBaseProperties().MeleeSkill = -200;
				e.getBaseProperties().RangedSkill = 0;
				e.getBaseProperties().MeleeDefense = -200;
				e.getBaseProperties().DamageTotalMult = 0.1;
				e.getBaseProperties().Initiative = 250;
				e.getSkills().update();
				e.setHitpoints(5);
				e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/bandit_thug", 18, 17 - 18 / 2);
				e.setFaction(this.Const.Faction.Enemy);
				e.getAIAgent().getProperties().OverallDefensivenessMult = 0.0;
				e.getAIAgent().getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 0.0;
				e.assignRandomEquipment();
				e.getBaseProperties().Initiative = 300;
				e.getSkills().update();
				e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/bandit_thug", 17, 18 - 17 / 2);
				e.setFaction(this.Const.Faction.Enemy);
				e.getAIAgent().getProperties().OverallDefensivenessMult = 0.0;
				e.getAIAgent().getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 0.0;
				e.assignRandomEquipment();
				e.getBaseProperties().Initiative = 200;
				e.getSkills().update();
				e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/bandit_raider_low", 19, 17 - 19 / 2);
				e.setFaction(this.Const.Faction.Enemy);
				e.setName(this.Flags.get("BossName"));
				e.getAIAgent().getProperties().OverallDefensivenessMult = 0.0;
				e.getAIAgent().addBehavior(this.new("scripts/ai/tactical/behaviors/ai_retreat_always"));
				local items = e.getItems();
				items.equip(this.new("scripts/items/armor/patched_mail_shirt"));
				items.equip(this.new("scripts/items/weapons/hunting_bow"));
				this.Flags.set("BossHead", e.getSprite("head").getBrush().Name);
				this.Flags.set("BossBeard", e.getSprite("beard").HasBrush ? e.getSprite("beard").getBrush().Name : "");
				this.Flags.set("BossBeardTop", e.getSprite("beard_top").HasBrush ? e.getSprite("beard_top").getBrush().Name : "");
				this.Flags.set("BossHair", e.getSprite("hair").HasBrush ? e.getSprite("hair").getBrush().Name : "");
				e.getBaseProperties().Hitpoints = 300;
				e.getSkills().update();
				e.setHitpoints(180);
				e.setMoraleState(this.Const.MoraleState.Wavering);
				this.Const.Movement.AnnounceDiscoveredEntities = true;
			}

		});
		this.m.States.push({
			ID = "ReturnAfterIntro",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.Contract.m.BulletpointsObjectives = [
					"Wróć do " + this.Contract.m.Home.getName() + " po zapłatę"
				];
				this.World.State.getPlayer().setAttackable(false);
				this.World.State.m.IsAutosaving = true;
			}

			function update()
			{
				if (this.World.getTime().Days > 2)
				{
					this.World.State.getPlayer().setAttackable(true);
				}

				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("PaymentAfterIntro1", false);
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Recruit",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = false;
				this.Contract.m.BigCity.getSprite("selection").Visible = true;
				this.Contract.m.BulletpointsObjectives = [
					"Udaj się do %bigcity% na %citydirection% od %townname%"
				];

				if (this.World.getPlayerRoster().getSize() < 6)
				{
					if (this.Math.max(1, 6 - this.World.getPlayerRoster().getSize()) > 1)
					{
						this.Contract.m.BulletpointsObjectives.push("Zwerbuj co najmniej " + this.Math.max(1, 6 - this.World.getPlayerRoster().getSize()) + " ludzi");
					}
					else
					{
						this.Contract.m.BulletpointsObjectives.push("Zwerbuj jeszcze co najmniej jedną osobę");
					}
				}

				this.Contract.m.BulletpointsObjectives.push("Kup broń i pancerz dla swoich ludzi");
				this.World.State.getPlayer().setAttackable(false);
				this.Contract.m.BigCity.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.BigCity.getTile().Pos, 500.0);
			}

			function update()
			{
				if (this.World.getTime().Days > 4)
				{
					this.World.State.getPlayer().setAttackable(true);
				}

				if (this.World.getPlayerRoster().getSize() >= 6 && this.Flags.get("IsMarketplaceTipShown"))
				{
					this.Contract.setState("ReturnAfterRecruiting");
				}
				else if (this.World.getPlayerRoster().getSize() >= 6 && this.Contract.m.BulletpointsObjectives.len() == 3)
				{
					this.start();
					this.World.Contracts.updateActiveContract();
				}
				else if (!this.Flags.get("IsMarketplaceTipShown") && this.World.State.getPlayer().getDistanceTo(this.Contract.m.BigCity.get()) <= 600)
				{
					this.Flags.set("IsMarketplaceTipShown", true);
					this.Contract.setScreen("MarketplaceTip");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "ReturnAfterRecruiting",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.Contract.m.BigCity.getSprite("selection").Visible = false;
				this.Contract.m.BulletpointsObjectives = [
					"Wróć do %townname%, gdzie czeka na ciebie %employer%"
				];
				this.World.State.getPlayer().setAttackable(false);
			}

			function update()
			{
				if (this.World.getTime().Days > 6)
				{
					this.World.State.getPlayer().setAttackable(true);
				}

				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					local tile = this.Contract.getTileToSpawnLocation(this.World.State.getPlayer().getTile(), 6, 10, [
						this.Const.World.TerrainType.Swamp,
						this.Const.World.TerrainType.Forest,
						this.Const.World.TerrainType.LeaveForest,
						this.Const.World.TerrainType.SnowyForest,
						this.Const.World.TerrainType.Shore,
						this.Const.World.TerrainType.Ocean,
						this.Const.World.TerrainType.Mountains
					], false);
					tile.clear();
					this.Contract.m.Location = this.WeakTableRef(this.World.spawnLocation("scripts/entity/world/locations/bandit_hideout_location", tile.Coords));
					this.Contract.m.Location.setResources(0);
					this.Contract.m.Location.setBanner("banner_deserters");
					this.Contract.m.Location.getSprite("location_banner").Visible = false;
					this.Contract.m.Location.setName(this.Flags.get("LocationName"));
					this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).addSettlement(this.Contract.m.Location.get(), false);
					this.Contract.m.Location.setDiscovered(true);
					this.World.uncoverFogOfWar(this.Contract.m.Location.getTile().Pos, 400.0);
					this.Contract.m.Location.clearTroops();
					this.Const.World.Common.addTroop(this.Contract.m.Location, {
						Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW
					}, false);
					this.Const.World.Common.addTroop(this.Contract.m.Location, {
						Type = this.Const.World.Spawn.Troops.BanditThug
					}, false);
					this.Const.World.Common.addTroop(this.Contract.m.Location, {
						Type = this.Const.World.Spawn.Troops.BanditThug
					}, false);

					if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
					{
						this.Const.World.Common.addTroop(this.Contract.m.Location, {
							Type = this.Const.World.Spawn.Troops.BanditThug
						}, false);
					}

					if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
					{
						this.Const.World.Common.addTroop(this.Contract.m.Location, {
							Type = this.Const.World.Spawn.Troops.BanditThug
						}, false);
					}

					this.Contract.m.Location.updateStrength();
					this.Contract.setScreen("Briefing");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Finale",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = false;

				if (this.Contract.m.Location != null && !this.Contract.m.Location.isNull())
				{
					this.Contract.m.Location.getSprite("selection").Visible = true;
				}

				if (this.Contract.m.BigCity != null && !this.Contract.m.BigCity.isNull())
				{
					this.Contract.m.BigCity.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Location != null && !this.Contract.m.Location.isNull())
				{
					this.Contract.m.Location.setOnCombatWithPlayerCallback(this.onLocationAttacked.bindenv(this));
				}

				this.Contract.m.BulletpointsObjectives = [
					"Udaj się do kryjówki Hoggarta na %direction% od %townname%",
					"Zabij Hoggarta Łasicę"
				];
				this.Contract.m.BulletpointsPayment = [
					"Odbierz 400 koron za wykonanie zadania"
				];
				this.World.State.getPlayer().setAttackable(false);
			}

			function update()
			{
				if (this.World.getTime().Days > 8)
				{
					this.World.State.getPlayer().setAttackable(true);
				}

				if (this.Flags.has("IsHoggartDead") || this.Contract.m.Location == null || this.Contract.m.Location.isNull() || !this.Contract.m.Location.isAlive())
				{
					if (this.Contract.m.Location != null && !this.Contract.m.Location.isNull())
					{
						this.Contract.m.Location.die();
						this.Contract.m.Location = null;
					}

					this.Contract.setScreen("AfterFinale");
					this.World.Contracts.showActiveContract();
				}
			}

			function onLocationAttacked( _dest, _isPlayerAttacking = true )
			{
				local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
				properties.Music = this.Const.Music.BanditTracks;
				properties.BeforeDeploymentCallback = this.onDeployment.bindenv(this);
				this.World.Contracts.startScriptedCombat(properties, true, true, true);
			}

			function onDeployment()
			{
				this.Tactical.getTileSquare(21, 17).removeObject();
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/bandit_raider_low", 21, 17 - 21 / 2);
				e.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
				e.setName(this.Flags.get("BossName"));
				e.m.IsGeneratingKillName = false;
				e.getAIAgent().getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 0.0;
				e.getFlags().add("IsFinalBoss", true);
				local items = e.getItems();
				items.equip(this.new("scripts/items/armor/patched_mail_shirt"));
				items.equip(this.new("scripts/items/weapons/falchion"));
				local shield = this.new("scripts/items/shields/wooden_shield");
				shield.setVariant(4);
				items.equip(shield);
				e.getSprite("head").setBrush(this.Flags.get("BossHead"));
				e.getSprite("beard").setBrush(this.Flags.get("BossBeard"));
				e.getSprite("beard_top").setBrush(this.Flags.get("BossBeardTop"));
				e.getSprite("hair").setBrush(this.Flags.get("BossHair"));
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getFlags().get("IsFinalBoss") == true)
				{
					this.Flags.set("IsHoggartDead", true);
					this.updateAchievement("TrialByFire", 1, 1);
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.Contract.m.BigCity.getSprite("selection").Visible = false;
				this.Contract.m.BulletpointsObjectives = [
					"Wróć do %townname%. %employer% wręczy ci zapłatę"
				];
				this.World.State.getPlayer().setAttackable(false);
			}

			function update()
			{
				if (this.World.getTime().Days > 10)
				{
					this.World.State.getPlayer().setAttackable(true);
				}

				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success");
					this.World.Contracts.showActiveContract();
				}
				else if (!this.Flags.get("IsCampingTipShown") && this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() >= 10.0)
				{
					this.Flags.set("IsCampingTipShown", true);
					this.Contract.setScreen("CampingTip");
					this.World.Contracts.showActiveContract();
				}
			}

		});
	}

	function createScreens()
	{
		this.m.Screens.push({
			ID = "Intro",
			Title = "Ostatnia Bitwa",
			Text = "[img]gfx/ui/events/event_21.png[/img]Wszystko szlag trafił. Dwa dni temu kompania została najęta, aby wyśledzić Hoggarta Łasicę i jego bandę najeźdźców, ale to oni znaleźli was pierwsi. Zasadzka. Czyiś żart o koniach został momentalnie ucięty przez strzałę przeszywającą gardło. Strzały wylatywały zewsząd i znikąd. Ludzie zaczęli wrzeszczeć i wyć, głośno umierając.\n\nGdy grad strzał opadł, chwyciłeś za broń, tak jak i pozostali, tylko po to, by chwilę potem paść na kolana. Strzała przebiła ci bok. Krzyczysz z bólu. Kątem oka widzisz, jak ludzie szarżują bez ciebie, by stawić opór, śmiały ostatni bastion, gdy stal uderza o stal.\n\nDostrzegasz swojego kapitana, wasze oczy na chwilę się spotykają i widzisz jego ostatnie skinienie, zanim napastnicy podrzynają mu gardło. Teraz to ty dowodzisz tą garstką ludzi, która została. Drżąc z bólu opierasz się na mieczu i zbierając w sobie resztki sił powoli znów wstajesz na nogi...",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do samego końca!",
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
			ID = "IntroAftermath",
			Title = "Pokłosie",
			Text = "[img]gfx/ui/events/event_22.png[/img]Żyjecie. Wygraliście.\n\nAdrenalina ustępuje i przy jej braku znów padasz na ziemię. Zaciskając zęby, chwytasz promień strzały. Twoja pierś się unosi, ból zamiast oddechu, wszystko się rozmywa.\n\nKompania została rozbita, wycięta niemal do nogi. A ten łajdak Hoggart znów pokazał, że zasługuje na swój przydomek, czmychając niczym zwykły tchórz.%SPEECH_ON%Co teraz, kapitanie?%SPEECH_OFF%Mówi głos za tobą. To %bro2%, który siedzi przy tobie, trzymając zakrwawiony topór u swych nóg. Odwracasz się do niego, by odpowiedzieć, lecz zanim ci się udaje, on mówi dalej.%SPEECH_ON%Bernhard poległ. Poderżnęli mu gardło. Był dobrym człowiekiem i cholernie dobrym przywódcą, ale wystarczył tylko ten jeden błąd. Zatem teraz to ty dowodzisz, czyż nie?%SPEECH_OFF%%bro3% dołącza do was, nadal ciężko dysząc. Później zjawia się %bro1%.%SPEECH_ON%Zostawmy ceremonie i namaszczenia na inny dzień. Zróbmy naszym porządny pochówek i wracajmy do %townname%, by odebrać zapłatę. Ludzie Łasicy przecież zostali ubici. Poza tym, kapitanie, musimy zająć się twoją raną, bo i ciebie stracimy. Nie chcesz chyba dopuścić do tego, by to %bro3% dowodził kompanią, prawda?%SPEECH_OFF%",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niech tak będzie.",
					function getResult()
					{
						this.Contract.setState("ReturnAfterIntro");
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.World.getPlayerRoster().getAll()[1].getImagePath());
				this.Characters.push(this.World.getPlayerRoster().getAll()[0].getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "PaymentAfterIntro1",
			Title = "Wróć do %townname%",
			Text = "[img]gfx/ui/events/event_79.png[/img]Ależ to musiał być przykry widok dla gapiów, gdy dotarliście do %townname%. Czterech zakrwawionych i pobitych najemników, których opuściło szczęście. Człowiek, który kilka dni temu wynajął kompanię, %employer%, bez wątpienia spodziewał się waszego powrotu w nieco bardziej chlubnym stylu.\n\nMimo wszystko wita was w swym domu, proponując chleb i wino, podczas gdy jego sługa popędził po uzdrowiciela. Pada niewiele słów, nie licząc okazjonalnych chrząknięć, czy syków, podczas gdy podstarzały mężczyzna trzęsącymi się dłoniami opatruje twoje rany. Igła przekłuwa twoją skórę, pierwszy z wielu szwów, które cię czekają. Zaciskasz zęby tak mocno, aż jeden z nich pęka. %employer% siedzi obok ciebie i pyta, czy zajęliście się Hoggartem. Kręcisz głową.%SPEECH_ON%Zabiliśmy jego ludzi, ale Łasica ostatecznie się wywinął spod naszych ostrzy.%SPEECH_OFF%Uzdrowiciel wymachuje rozżarzonym pogrzebaczem, sugerując, że chce go przyłożyć do twojej rany. Kiwasz głową, zezwalając. Przez krótką chwilę istnieje tylko to. Nie jesteś człowiekiem, ale szczyptą ognia, ciałem z płomienia, golemem z bólu. %employer% podaje ci kielich wina.%SPEECH_ON%Dobrze się spisałeś, najemniku. Zbójcy zostali usunięci, szkoda jednak, że Hoggart nadal żyje.%SPEECH_OFF%",
			Characters = [],
			ShowEmployer = true,
			List = [],
			Options = [
				{
					Text = "Spodziewamy się za to zapłaty.",
					function getResult()
					{
						return "PaymentAfterIntro2";
					}

				}
			],
			function start()
			{
				this.World.Assets.addMoney(400);
				this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Zabił ludzi Hoggarta");
			}

		});
		this.m.Screens.push({
			ID = "PaymentAfterIntro2",
			Title = "Wróć do %townname%",
			Text = "[img]gfx/ui/events/event_79.png[/img]%employer% łapie dech.%SPEECH_ON%Cóż, naturalnie! 400 koron, jak się umawialiśmy.%SPEECH_OFF%Wskazuje na sługę, który szybko podchodzi z twoją zapłatą w dłoni.%SPEECH_ON%Zastanawiam się... czy mogę skorzystać z waszych usług jeszcze raz? Bardzo chciałbym zakończyć tę kłopotliwą sprawę z Hoggartem raz zawsze. Oczywiście znów bym wam zapłacił. Kolejne 400 koron, powiedzmy?%SPEECH_OFF%%bro2% drwi i odwraca się, by jeszcze napić się wina, ale %bro1% wstaje, by przemówić.%SPEECH_ON%Tak, kompania jest w ruinie, ale ją odbudujemy! Gdyby nie %companyname%, %bro2% po prostu przepiłby wszystkie swoje korony i skończył żebrząc na ulicach, a %bro3%, na bogów wszyscy wiemy, że zacząłby się tak uganiać za babami, aż któraś w końcu upiekłaby ten jego zmurszały łeb. Ta kompania jest nam potrzebna, %companyname% to wszystko, co mamy! Co powiesz, kapitanie?%SPEECH_OFF%%bro2% beka i wznosi swój puchar w twoim kierunku. %bro3% przeciera nos i przytakuje.%SPEECH_ON%Zabijemy tego Hoggarta, lub nie, twoja decyzja, kapitanie.%SPEECH_OFF%",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Tak, mamy z Hoggartem nieskończone porachunki.",
					function getResult()
					{
						return "PaymentAfterIntro3";
					}

				},
				{
					Text = "Nie, poszukamy szczęścia gdzie indziej.",
					function getResult()
					{
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Tactical.getEntityByID(this.Contract.m.EmployerID).getImagePath());
				this.Characters.push(this.World.getPlayerRoster().getAll()[0].getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "PaymentAfterIntro3",
			Title = "Powrót do %townname%",
			Text = "[img]gfx/ui/events/event_79.png[/img]%employer% klaszcze w dłonie z zadowolenia.%SPEECH_ON%Doskonale! Moje małe ptaszki potrzebują nieco czasu, aby dowiedzieć się, gdzie Hoggart się teraz ukrywa. Sugeruję wam w międzyczasie zaopatrzyć się w niezbędne zapasy, abyście byli gotowi zakończyć to wszystko, kiedy nadejdzie właściwy czas. Zobaczymy się znów najdalej za kilka dni!%SPEECH_OFF%Gdy opuszczasz dom zleceniodawcy i stajesz na przedmieściach %townname%, %bro1% chce z tobą porozmawiać.%SPEECH_ON%Potrzebujemy więcej ludzi, kapitanie. Wiem, że wygłosiłem tam płomienną przemowę, ale samą brawurą gówno zdziałamy. Potrzebujemy więcej żywego mięsa w szeregach. Znajdźmy ze trzech porządnych ludzi, kupmy im przyzwoitą broń i odziejmy w najlepszy pancerz, na jaki nas stać.%SPEECH_OFF%Przerywa, by się rozejrzeć.%SPEECH_ON%Założę się, że w tym zapchlonym miasteczku jest jakiś zdesperowany wieśniak lub dwóch, którzy chcieliby rozpocząć nowe życie. Możemy też udać się do %bigcity% na %citydirection%. Miastowi nie zawsze są tacy hardzi, jak te kmioty ze wsi, ale tam mamy większą szansę znaleźć ludzi z doświadczeniem w walce, bo tacy często zatrzymują się w większych osadach na odpoczynek.%SPEECH_OFF%",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tak właśnie zrobimy.",
					function getResult()
					{
						this.Contract.setState("Recruit");
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Tactical.getEntityByID(this.Contract.m.EmployerID).getImagePath());
				this.Characters.push(this.World.getPlayerRoster().getAll()[0].getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "MarketplaceTip",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_77.png[/img]Gdy sylwetka %bigcity% pojawia się na horyzoncie, %bro3% chce zamienić z tobą słowo.%SPEECH_ON%Nigdy wcześniej nie byłem w %bigcity%, bywałem jednak w miastach bardzo podobnych. Tego typu miasta są doskonałe, gdy chcesz sprzedać różne rzeczy, bo te wszystkie nadęte kutasy uwielbiają, gdy ich towary dostarczy im się pod nos. Przy takiej ilości kupców łatwo też znaleźć to, czego potrzebujesz. Wypatruj okazji i nie daj się orżnąć tym handlującym rzezimieszkom.%SPEECH_OFF%%bro2% uważa za stosowne, by dorzucić swoją opinię na temat tego, co powinniście zrobić.%SPEECH_ON%Jeśli jest tam porządna karczma, to do niej powinniśmy się udać najpierw. Nic tak nie pokrzepia nieszczęśnika, co pinta dobrego piwa. Bogowie nam świadkami, żeśmy sobie na to zasłużyli!%SPEECH_OFF%%bro3% kręci głową.%SPEECH_ON%Mówisz to za każdym razem, gdy odwiedzamy jakieś miasto! Mówisz to nawet wtedy, gry już jesteś schlany!%SPEECH_OFF%",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Będę o tym pamiętał.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				if (this.World.getPlayerRoster().getSize() >= 3)
				{
					this.Characters.push(this.World.getPlayerRoster().getAll()[2].getImagePath());
					this.Characters.push(this.World.getPlayerRoster().getAll()[1].getImagePath());
				}
			}

		});
		this.m.Screens.push({
			ID = "Briefing",
			Title = "Niezałatwione sprawy",
			Text = "[img]gfx/ui/events/event_79.png[/img]%employer% kroczy w tę i we w tę, gdy go odnajdujesz. Uzdrowiciel, który niemal nie ukatrupił cię pogrzebaczem, stoi obok. Wydłubuje kawałki zaschniętej krwi spod swoich paznokci. %employer% klaszcze w dłonie.%SPEECH_ON%Wreszcie jesteście. Mam dobre wieści! Dopadliśmy jednego z byłych ludzi Hoggarta! Mój ten tutaj dobry przyjaciel odbył z nim miłą pogawędkę i teraz wiem, gdzie Hoggart liże swoje rany.%SPEECH_OFF%Uzdrowiciel odchrząkuje, rozcapierzając swe place, niczym panienka, chcąca je pomalować. Przemawia, jakby identyfikował chorobę, którą zaraz ma usunąć.%SPEECH_ON%Bandyta zwany Hoggart ukrywa się w małej chatce %terrain% na %direction% stąd. Na podstawie mojej grzecznej dyskusji z jednym z jego ludzi, Hoggart ma świadomość, że kompania %companyname% próbuje się odbudować i zebrała więcej ludzi, odkąd ostatnio się spotkaliście.%SPEECH_OFF%Przytakując, %employer% odprawia cię gestem.%SPEECH_ON%Powodzenia, najemniku.%SPEECH_OFF%",
			ShowEmployer = true,
			List = [],
			Options = [
				{
					Text = "Wrócimy z jego głową!",
					function getResult()
					{
						this.Contract.setState("Finale");
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "AfterFinale",
			Title = "Po bitwie",
			Text = "[img]gfx/ui/events/event_87.png[/img]Hoggart leży martwy w kałuży własnej krwi, skurczony w groteskowej i panicznej pozie. Nie udało mu się czmychnąć tym razem. Stawiasz nogę na jego zwłokach i patrzysz na swych ludzi.%SPEECH_ON%Za kompanię. Za wszystkich tych, którzy polegli.%SPEECH_OFF%%bro3% spluwa na twarz truposza.%SPEECH_ON%Zabierzmy łeb tej szelmy z powrotem do %townname%%SPEECH_OFF%",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Czas odebrać zapłatę.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				if (this.World.getPlayerRoster().getSize() >= 3)
				{
					this.Characters.push(this.World.getPlayerRoster().getAll()[2].getImagePath());
				}
			}

		});
		this.m.Screens.push({
			ID = "CampingTip",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_75.png[/img]%bro3% dołącza do ciebie.%SPEECH_ON%Masz chwilę, szefie?%SPEECH_OFF%Kiwasz mu, by powiedział, co mu chodzi po głowie.%SPEECH_ON%Przez bitwę część naszego sprzętu trochę się zużyła, a niektórzy ludzie też nieco oberwali. Możemy naprawić sprzęt i połatać ludzi podczas marszu, ale pójdzie to znacznie szybciej, gdy się zatrzymamy. Oczywiście, gdy rozbijemy obóz musimy uważać na zasadzki. Ognisko w tych stronach jest widoczne z dość daleka.%SPEECH_OFF%",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Będę o tym pamiętał.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				if (this.World.getPlayerRoster().getSize() >= 3)
				{
					this.Characters.push(this.World.getPlayerRoster().getAll()[2].getImagePath());
				}
			}

		});
		this.m.Screens.push({
			ID = "Success",
			Title = "Powrót do %townname%",
			Text = "[img]gfx/ui/events/event_24.png[/img]Kompania wraca do %townname% jako zwycięzcy, trzymając głowy uniesione znacznie wyżej, niż poprzednim razem. %companyname% to już nie ta kompania, co dawniej, choć nadal trzeba się z nią liczyć, o czym przekonał się Hoggart w swych ostatnich chwilach życia.\n\nNiesiesz jego głowę w worku, który opróżniasz u stóp swego zleceniodawcy. %employer% odskakuje w tył, ale uzdrowiciel szybko podnosi głowę, przygląda się jej i przytakuje. %employer% podchodzi do zakrwawionej twarzy bandyty ostrożnie bada ją wzrokiem.%SPEECH_ON%Tak, Tak... to zaiste jego parszywa morda. Słudzy! Zapłacić temu człowiekowi!%SPEECH_OFF%Z monetami w dłoni, zwracasz się do swych ludzi podniesionym głosem.%SPEECH_ON%Tak długo, jak w naszych żyłach krążyć będzie krew, tak długo, jak będziemy w stanie dzierżyć miecz i tarczę, tak długo będzie trwać nasza kompania. W całym królestwie dowiedzą się co to %companyname%!%SPEECH_OFF%Ludzie wiwatują. %bro1% kładzie ci dłoń na ramieniu.%SPEECH_ON%Dobrze się spisałeś, kapitanie. Nieważne dokąd nas poprowadzisz, ludzie podążą za tobą w bitwę jak bracia.%SPEECH_OFF%",
			ShowEmployer = true,
			Image = "",
			List = [],
			Options = [
				{
					Text = "Jak bracia!",
					function getResult()
					{
						this.World.Flags.set("IsHoggartDead", true);
						this.Music.setTrackList(this.Const.Music.WorldmapTracks, this.Const.Music.CrossFadeTime, true);
						this.World.Assets.addMoney(400);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Zabił Hoggarta na dobre");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Music.setTrackList(this.Const.Music.VictoryTracks, this.Const.Music.CrossFadeTime);
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.companion")
					{
						bro.improveMood(1.0, "Pomścił kompanię");
					}
					else
					{
						bro.improveMood(0.25, "Nabrał przekonania do twych zdolności przywódczych");
					}
				}

				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]400[/color] koron"
				});
			}

		});
	}

	function spawnCorpse( _x, _y )
	{
		local tile = this.Tactical.getTileSquare(_x, _y);
		local armors = [
			"bust_body_10_dead",
			"bust_body_13_dead",
			"bust_body_14_dead",
			"bust_body_15_dead",
			"bust_body_19_dead",
			"bust_body_20_dead",
			"bust_body_22_dead",
			"bust_body_23_dead",
			"bust_body_24_dead",
			"bust_body_26_dead"
		];
		local armorSprite = armors[this.Math.rand(0, armors.len() - 1)];
		local flip = this.Math.rand(0, 1) == 1;
		local decal = tile.spawnDetail(armorSprite, this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
		decal.Scale = 0.9;
		decal.setBrightness(0.9);
		decal = tile.spawnDetail("bust_naked_body_01_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
		decal.Scale = 0.9;
		decal.setBrightness(0.9);

		if (this.Math.rand(1, 100) <= 25)
		{
			decal = tile.spawnDetail("bust_body_guts_0" + this.Math.rand(1, 3), this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
			decal.Scale = 0.9;
		}
		else if (this.Math.rand(1, 100) <= 25)
		{
			decal = tile.spawnDetail("bust_head_smashed_01", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
			decal.Scale = 0.9;
		}
		else
		{
			decal = tile.spawnDetail(armorSprite + "_arrows", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
			decal.Scale = 0.9;
		}

		local color = this.Const.HairColors.All[this.Math.rand(0, this.Const.HairColors.All.len() - 1)];
		local hairSprite = "hair_" + color + "_" + this.Const.Hair.AllMale[this.Math.rand(0, this.Const.Hair.AllMale.len() - 1)];
		local beardSprite = "beard_" + color + "_" + this.Const.Beards.All[this.Math.rand(0, this.Const.Beards.All.len() - 1)];
		local headSprite = this.Const.Faces.AllMale[this.Math.rand(0, this.Const.Faces.AllMale.len() - 1)];
		local decal = tile.spawnDetail(headSprite + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
		decal.Scale = 0.9;
		decal.setBrightness(0.9);

		if (this.Math.rand(1, 100) <= 50)
		{
			local decal = tile.spawnDetail(beardSprite + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
			decal.Scale = 0.9;
			decal.setBrightness(0.9);
		}

		if (this.Math.rand(1, 100) <= 90)
		{
			local decal = tile.spawnDetail(hairSprite + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
			decal.Scale = 0.9;
			decal.setBrightness(0.9);
		}

		local pools = this.Math.rand(this.Const.Combat.BloodPoolsAtDeathMin, this.Const.Combat.BloodPoolsAtDeathMax);

		for( local i = 0; i < pools; i = i )
		{
			this.Tactical.spawnPoolEffect(this.Const.BloodPoolDecals[this.Const.BloodType.Red][this.Math.rand(0, this.Const.BloodPoolDecals[this.Const.BloodType.Red].len() - 1)], tile, this.Const.BloodPoolTerrainAlpha[tile.Type], 1.0, this.Const.Tactical.DetailFlag.Corpse);
			i = ++i;
		}

		local corpse = clone this.Const.Corpse;
		corpse.CorpseName = "Ktoś";
		tile.Properties.set("Corpse", corpse);
	}

	function spawnBlood( _x, _y )
	{
		local tile = this.Tactical.getTileSquare(_x, _y);
		tile.spawnDetail(this.Const.BloodDecals[this.Const.BloodType.Red][this.Math.rand(0, this.Const.BloodDecals[this.Const.BloodType.Red].len() - 1)]);
	}

	function spawnArrow( _x, _y )
	{
		local tile = this.Tactical.getTileSquare(_x, _y);
		tile.spawnDetail(this.Const.ProjectileDecals[this.Const.ProjectileType.Arrow][this.Math.rand(0, this.Const.ProjectileDecals[this.Const.ProjectileType.Arrow].len() - 1)], 0, true);
	}

	function onPrepareVariables( _vars )
	{
		local bros = this.World.getPlayerRoster().getAll();
		_vars.push([
			"location",
			this.m.Flags.get("LocationName")
		]);
		_vars.push([
			"bigcity",
			this.m.BigCity.getName()
		]);
		_vars.push([
			"boss",
			this.m.Flags.get("BossName")
		]);
		_vars.push([
			"direction",
			this.m.Location != null && !this.m.Location.isNull() ? this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Location.getTile())] : ""
		]);
		_vars.push([
			"citydirection",
			this.m.BigCity != null && !this.m.BigCity.isNull() ? this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.BigCity.getTile())] : ""
		]);
		_vars.push([
			"terrain",
			this.m.Location != null && !this.m.Location.isNull() ? this.Const.Strings.Terrain[this.m.Location.getTile().Type] : ""
		]);
		_vars.push([
			"bro1",
			bros[0].getName()
		]);
		_vars.push([
			"bro2",
			bros.len() >= 2 ? bros[1].getName() : bros[0].getName()
		]);
		_vars.push([
			"bro3",
			bros.len() >= 3 ? bros[2].getName() : bros[0].getName()
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Location != null && !this.m.Location.isNull())
			{
				this.m.Location.getSprite("selection").Visible = false;
			}

			if (this.m.BigCity != null && !this.m.BigCity.isNull())
			{
				this.m.BigCity.getSprite("selection").Visible = false;
			}

			this.m.Home.getSprite("selection").Visible = false;
			this.World.Ambitions.setDelay(12);
		}

		this.World.State.getPlayer().setAttackable(true);
		this.World.State.m.IsAutosaving = true;
	}

	function onIsValid()
	{
		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Location != null && !this.m.Location.isNull())
		{
			_out.writeU32(this.m.Location.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.BigCity != null && !this.m.BigCity.isNull())
		{
			_out.writeU32(this.m.BigCity.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local location = _in.readU32();

		if (location != 0)
		{
			this.m.Location = this.WeakTableRef(this.World.getEntityByID(location));
		}

		local bigCity = _in.readU32();

		if (bigCity != 0)
		{
			this.m.BigCity = this.WeakTableRef(this.World.getEntityByID(bigCity));
		}

		this.contract.onDeserialize(_in);
	}

});

