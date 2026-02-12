::mods_hookDescendants("skills/skill", function ( o )
{
	while (!("getDefaultTooltip" in o))
	{
		o = o[o.SuperName];
	}

	o.m.KilledString = "Zabity";
	o.getDefaultTooltip = function ()
	{
		local p = this.m.Container.buildPropertiesForUse(this, null);
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			}
		];
		local damage_regular_min = this.Math.floor(p.DamageRegularMin * p.DamageRegularMult * p.DamageTotalMult * (this.m.IsRanged ? p.RangedDamageMult : p.MeleeDamageMult) * p.DamageTooltipMinMult);
		local damage_regular_max = this.Math.floor(p.DamageRegularMax * p.DamageRegularMult * p.DamageTotalMult * (this.m.IsRanged ? p.RangedDamageMult : p.MeleeDamageMult) * p.DamageTooltipMaxMult);
		local damage_direct_min = this.Math.floor(damage_regular_min * this.Math.minf(1.0, p.DamageDirectMult * (this.m.DirectDamageMult + p.DamageDirectAdd)));
		local damage_direct_max = this.Math.floor(damage_regular_max * this.Math.minf(1.0, p.DamageDirectMult * (this.m.DirectDamageMult + p.DamageDirectAdd)));
		local damage_armor_min = this.Math.floor(p.DamageRegularMin * p.DamageArmorMult * p.DamageTotalMult * (this.m.IsRanged ? p.RangedDamageMult : p.MeleeDamageMult) * p.DamageTooltipMinMult);
		local damage_armor_max = this.Math.floor(p.DamageRegularMax * p.DamageArmorMult * p.DamageTotalMult * (this.m.IsRanged ? p.RangedDamageMult : p.MeleeDamageMult) * p.DamageTooltipMaxMult);

		if (this.m.DirectDamageMult == 1.0)
		{
			ret.push({
				id = 4,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "Zadaje [color=" + this.Const.UI.Color.DamageValue + "]" + damage_direct_min + "[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_direct_max + "[/color] obrażeń, które ignorują pancerz"
			});
		}
		else if (this.m.DirectDamageMult > 0.0)
		{
			ret.push({
				id = 4,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "Zadaje [color=" + this.Const.UI.Color.DamageValue + "]" + damage_regular_min + "[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_regular_max + "[/color] obrażeń zdrowia, z czego [color=" + this.Const.UI.Color.DamageValue + "]0[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_direct_max + "[/color] może zignorować pancerz"
			});
		}
		else
		{
			ret.push({
				id = 4,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "Zadaje [color=" + this.Const.UI.Color.DamageValue + "]" + damage_regular_min + "[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_regular_max + " obrażeń zdrowia[/color]"
			});
		}

		if (damage_armor_max > 0)
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/icons/armor_damage.png",
				text = "Zadaje [color=" + this.Const.UI.Color.DamageValue + "]" + damage_armor_min + "[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_armor_max + "[/color] obrażeń pancerzowi"
			});
		}

		return ret;
	};

	while (!("getCostString" in o))
	{
		o = o[o.SuperName];
	}

	o.getCostString = function ()
	{
		return "[i]Wymaga " + (this.isAffordableBasedOnAPPreview() ? "[b][color=" + this.Const.UI.Color.PositiveValue + "]" + this.getActionPointCost() : "[b][color=" + this.Const.UI.Color.NegativeValue + "]" + this.getActionPointCost()) + " PA[/color][/b], aby użyć i generuje " + (this.isAffordableBasedOnFatiguePreview() ? "[b][color=" + this.Const.UI.Color.PositiveValue + "]" + this.getFatigueCost() : "[b][color=" + this.Const.UI.Color.NegativeValue + "]" + this.getFatigueCost()) + " Zmęczenia[/color][/b][/i]\n";
	};

	while (!("getHitFactors" in o))
	{
		o = o[o.SuperName];
	}

	o.getHitFactors = function ( _targetTile )
	{
		local ret = [];
		local user = this.m.Container.getActor();
		local myTile = user.getTile();
		local targetEntity = _targetTile.IsOccupiedByActor ? _targetTile.getEntity() : null;

		if (this.m.HitChanceBonus > 0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = this.getName()
			});
		}

		if (!this.m.IsRanged && targetEntity != null && targetEntity.getSurroundedCount() != 0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "Otoczony"
			});
		}

		if (_targetTile.Level < this.m.Container.getActor().getTile().Level)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "Przewaga wysokości"
			});
		}

		if (_targetTile.IsBadTerrain)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "Cel na kiepskim terenie"
			});
		}

		if (this.m.IsAttack)
		{
			local fast_adaption = this.m.Container.getSkillByID("perk.fast_adaption");

			if (fast_adaption != null && fast_adaption.isBonusActive())
			{
				ret.push({
					icon = "ui/tooltips/positive.png",
					text = "Szybka Adaptacja"
				});
			}
		}

		if (this.m.IsTooCloseShown && this.m.HitChanceBonus < 0)
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Zbyt blisko"
			});
		}
		else if (this.m.HitChanceBonus < 0)
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = this.getName()
			});
		}

		if (_targetTile.Level > myTile.Level)
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Przewaga wysokości"
			});
		}

		if (myTile.IsBadTerrain)
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Na kiepskim terenie"
			});
		}

		if (this.m.IsShieldRelevant)
		{
			if (_targetTile.IsOccupiedByActor && targetEntity.isArmedWithShield())
			{
				ret.push({
					icon = "ui/tooltips/negative.png",
					text = "Dzierży tarczę"
				});
			}
		}

		if (_targetTile.IsOccupiedByActor && myTile.getDistanceTo(_targetTile) <= 1 && targetEntity.getSkills().hasSkill("effects.riposte"))
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Riposta"
			});
		}

		if (this.m.IsRanged && myTile.getDistanceTo(_targetTile) > 1)
		{
			if (_targetTile.IsOccupiedByActor)
			{
				ret.push({
					icon = "ui/tooltips/negative.png",
					text = "Odległość wynosi " + _targetTile.getDistanceTo(user.getTile())
				});
			}

			if (this.m.IsUsingHitchance)
			{
				local blockedTiles = this.Const.Tactical.Common.getBlockedTiles(myTile, _targetTile, user.getFaction(), true);

				if (blockedTiles.len() != 0)
				{
					ret.push({
						icon = "ui/tooltips/negative.png",
						text = "Zablokowana linia strzału"
					});
				}
			}
		}

		if (this.m.IsAttack && _targetTile.IsOccupiedByActor && (targetEntity.getFlags().has("skeleton") || targetEntity.getSkills().hasSkill("racial.golem")))
		{
			if (this.m.IsRanged)
			{
				ret.push({
					icon = "ui/tooltips/negative.png",
					text = "Odporność przeciwko broni dystansowej"
				});
			}
			else if (this.m.ID == "actives.puncture" || this.m.ID == "actives.thrust" || this.m.ID == "actives.stab" || this.m.ID == "actives.deathblow" || this.m.ID == "actives.impale" || this.m.ID == "actives.rupture" || this.m.ID == "actives.prong" || this.m.ID == "actives.lunge")
			{
				ret.push({
					icon = "ui/tooltips/negative.png",
					text = "Odporność przeciwko atakom kłutym"
				});
			}
		}

		if (_targetTile.IsOccupiedByActor && targetEntity.getCurrentProperties().IsImmuneToStun && (this.m.ID == "actives.knock_out" || this.m.ID == "actives.knock_over" || this.m.ID == "actives.strike_down"))
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Niewrażliwość na ogłuszenie"
			});
		}

		if (_targetTile.IsOccupiedByActor && targetEntity.getCurrentProperties().IsImmuneToRoot && this.m.ID == "actives.throw_net")
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Niewrażliwość na ukorzenienie"
			});
		}

		if (_targetTile.IsOccupiedByActor && (targetEntity.getCurrentProperties().IsImmuneToDisarm || targetEntity.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) == null) && this.m.ID == "actives.disarm")
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Niewrażliwość na rozbrojenie"
			});
		}

		if (_targetTile.IsOccupiedByActor && targetEntity.getCurrentProperties().IsImmuneToKnockBackAndGrab && (this.m.ID == "actives.knock_back" || this.m.ID == "actives.hook" || this.m.ID == "actives.repel"))
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Niewrażliwość na odrzucenie w tył i przyciągnięcie"
			});
		}

		if (this.m.IsRanged && user.getCurrentProperties().IsAffectedByNight && user.getSkills().hasSkill("special.night"))
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Noc"
			});
		}

		return ret;
	};

	while (!("attackEntity" in o))
	{
		o = o[o.SuperName];
	}

	o.attackEntity = function ( _user, _targetEntity, _allowDiversion = true )
	{
		if (_targetEntity != null && !_targetEntity.isAlive())
		{
			return false;
		}

		local properties = this.m.Container.buildPropertiesForUse(this, _targetEntity);
		local userTile = _user.getTile();
		local astray = false;

		if (_allowDiversion && this.m.IsRanged && userTile.getDistanceTo(_targetEntity.getTile()) > 1)
		{
			local blockedTiles = this.Const.Tactical.Common.getBlockedTiles(userTile, _targetEntity.getTile(), _user.getFaction());

			if (blockedTiles.len() != 0 && this.Math.rand(1, 100) <= this.Math.ceil(this.Const.Combat.RangedAttackBlockedChance * properties.RangedAttackBlockedChanceMult * 100))
			{
				_allowDiversion = false;
				astray = true;
				_targetEntity = blockedTiles[this.Math.rand(0, blockedTiles.len() - 1)].getEntity();
			}
		}

		if (!_targetEntity.isAttackable())
		{
			if (this.m.IsShowingProjectile && this.m.ProjectileType != 0)
			{
				local flip = !this.m.IsProjectileRotated && _targetEntity.getPos().X > _user.getPos().X;

				if (_user.getTile().getDistanceTo(_targetEntity.getTile()) >= this.Const.Combat.SpawnProjectileMinDist)
				{
					this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), _targetEntity.getTile(), 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
				}
			}

			return false;
		}

		local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);
		local defense = _targetEntity.getDefense(_user, this, defenderProperties);
		local levelDifference = _targetEntity.getTile().Level - _user.getTile().Level;
		local distanceToTarget = _user.getTile().getDistanceTo(_targetEntity.getTile());
		local toHit = 0;
		local skill = this.m.IsRanged ? properties.RangedSkill * properties.RangedSkillMult : properties.MeleeSkill * properties.MeleeSkillMult;
		toHit = toHit + skill;
		toHit = toHit - defense;

		if (this.m.IsRanged)
		{
			toHit = toHit + (distanceToTarget - this.m.MinRange) * properties.HitChanceAdditionalWithEachTile * properties.HitChanceWithEachTileMult;
		}

		if (levelDifference < 0)
		{
			toHit = toHit + this.Const.Combat.LevelDifferenceToHitBonus;
		}
		else
		{
			toHit = toHit + this.Const.Combat.LevelDifferenceToHitMalus * levelDifference;
		}

		local shieldBonus = 0;
		local shield = _targetEntity.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

		if (shield != null && shield.isItemType(this.Const.Items.ItemType.Shield))
		{
			shieldBonus = (this.m.IsRanged ? shield.getRangedDefense() : shield.getMeleeDefense()) * (_targetEntity.getCurrentProperties().IsSpecializedInShields ? 1.25 : 1.0);

			if (_targetEntity.getSkills().hasSkill("effects.shieldwall"))
			{
				shieldBonus = shieldBonus * 2;
			}
		}

		toHit = toHit * properties.TotalAttackToHitMult;
		toHit = toHit + this.Math.max(0, 100 - toHit) * (1.0 - defenderProperties.TotalDefenseToHitMult);

		if (this.m.IsRanged && !_allowDiversion && this.m.IsShowingProjectile)
		{
			toHit = toHit - 15;
			properties.DamageTotalMult *= 0.75;
		}

		if (defense > -100 && skill > -100)
		{
			toHit = this.Math.max(5, this.Math.min(95, toHit));
		}

		_targetEntity.onAttacked(_user);

		if (this.m.IsDoingAttackMove && !_user.isHiddenToPlayer() && !_targetEntity.isHiddenToPlayer())
		{
			this.Tactical.getShaker().cancel(_user);

			if (this.m.IsDoingForwardMove)
			{
				this.Tactical.getShaker().shake(_user, _targetEntity.getTile(), 5);
			}
			else
			{
				local otherDir = _targetEntity.getTile().getDirectionTo(_user.getTile());

				if (_user.getTile().hasNextTile(otherDir))
				{
					this.Tactical.getShaker().shake(_user, _user.getTile().getNextTile(otherDir), 6);
				}
			}
		}

		if (!_targetEntity.isAbleToDie() && _targetEntity.getHitpoints() == 1)
		{
			toHit = 0;
		}

		if (!this.isUsingHitchance())
		{
			toHit = 100;
		}

		local r = this.Math.rand(1, 100);

		if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == 0)
		{
			if (_user.isPlayerControlled())
			{
				r = this.Math.max(1, r - 5);
			}
			else if (_targetEntity.isPlayerControlled())
			{
				r = this.Math.min(100, r + 5);
			}
		}

		local isHit = r <= toHit;

		if (!_user.isHiddenToPlayer() && !_targetEntity.isHiddenToPlayer())
		{
			local rolled = r;
			this.Tactical.EventLog.log_newline();

			if (astray)
			{
				if (this.isUsingHitchance())
				{
					if (isHit)
					{
						this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " używa um. " + this.getName() + ", a spudłowany strzał przypadkowo trafia: " + this.Const.UI.getColorizedEntityName(_targetEntity) + " (Szansa: " + this.Math.min(95, this.Math.max(5, toHit)) + ", Rzut: " + rolled + ")");
					}
					else
					{
						this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " używa um. " + this.getName() + ", a spudłowany strzał chybia: " + this.Const.UI.getColorizedEntityName(_targetEntity) + " (Szansa: " + this.Math.min(95, this.Math.max(5, toHit)) + ", Rzut: " + rolled + ")");
					}
				}
				else
				{
					this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " używa um. " + this.getName() + ", a spudłowany strzał przypadkowo trafia: " + this.Const.UI.getColorizedEntityName(_targetEntity));
				}
			}
			else if (this.isUsingHitchance())
			{
				if (isHit)
				{
					this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " używa um. " + this.getName() + " i trafia: " + this.Const.UI.getColorizedEntityName(_targetEntity) + " (Szansa: " + this.Math.min(95, this.Math.max(5, toHit)) + ", Rzut: " + rolled + ")");
				}
				else
				{
					this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " używa um. " + this.getName() + " i chybia: " + this.Const.UI.getColorizedEntityName(_targetEntity) + " (Szansa: " + this.Math.min(95, this.Math.max(5, toHit)) + ", Rzut: " + rolled + ")");
				}
			}
			else
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " używa um. " + this.getName() + " i trafia: " + this.Const.UI.getColorizedEntityName(_targetEntity));
			}
		}

		if (isHit && this.Math.rand(1, 100) <= _targetEntity.getCurrentProperties().RerollDefenseChance)
		{
			r = this.Math.rand(1, 100);
			isHit = r <= toHit;
		}

		if (isHit)
		{
			this.getContainer().setBusy(true);
			local info = {
				Skill = this,
				Container = this.getContainer(),
				User = _user,
				TargetEntity = _targetEntity,
				Properties = properties,
				DistanceToTarget = distanceToTarget
			};

			if (this.m.IsShowingProjectile && this.m.ProjectileType != 0 && _user.getTile().getDistanceTo(_targetEntity.getTile()) >= this.Const.Combat.SpawnProjectileMinDist && (!_user.isHiddenToPlayer() || !_targetEntity.isHiddenToPlayer()))
			{
				local flip = !this.m.IsProjectileRotated && _targetEntity.getPos().X > _user.getPos().X;
				local time = this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), _targetEntity.getTile(), 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
				this.Time.scheduleEvent(this.TimeUnit.Virtual, time, this.onScheduledTargetHit, info);

				if (this.m.SoundOnHit.len() != 0)
				{
					this.Time.scheduleEvent(this.TimeUnit.Virtual, time + this.m.SoundOnHitDelay, this.onPlayHitSound.bindenv(this), {
						Sound = this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)],
						Pos = _targetEntity.getPos()
					});
				}
			}
			else
			{
				if (this.m.SoundOnHit.len() != 0)
				{
					this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, _targetEntity.getPos());
				}

				if (this.Tactical.State.getStrategicProperties() != null && this.Tactical.State.getStrategicProperties().IsArenaMode && toHit <= 15)
				{
					this.Sound.play(this.Const.Sound.ArenaShock[this.Math.rand(0, this.Const.Sound.ArenaShock.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
				}

				this.onScheduledTargetHit(info);
			}

			return true;
		}
		else
		{
			local distanceToTarget = _user.getTile().getDistanceTo(_targetEntity.getTile());
			_targetEntity.onMissed(_user, this, this.m.IsShieldRelevant && shield != null && r <= toHit + shieldBonus * 2);
			this.m.Container.onTargetMissed(this, _targetEntity);
			local prohibitDiversion = false;

			if (_allowDiversion && this.m.IsRanged && !_user.isPlayerControlled() && this.Math.rand(1, 100) <= 25 && distanceToTarget > 2)
			{
				local targetTile = _targetEntity.getTile();

				for( local i = 0; i < this.Const.Direction.COUNT; i = i )
				{
					if (!targetTile.hasNextTile(i))
					{
					}
					else
					{
						local tile = targetTile.getNextTile(i);

						if (tile.IsEmpty)
						{
						}
						else if (tile.IsOccupiedByActor && tile.getEntity().isAlliedWith(_user))
						{
							prohibitDiversion = true;
							break;
						}
					}

					i = ++i;
				}
			}

			if (_allowDiversion && this.m.IsRanged && !(this.m.IsShieldRelevant && shield != null && r <= toHit + shieldBonus * 2) && !prohibitDiversion && distanceToTarget > 2)
			{
				this.divertAttack(_user, _targetEntity);
			}
			else if (this.m.IsShieldRelevant && shield != null && r <= toHit + shieldBonus * 2)
			{
				local info = {
					Skill = this,
					User = _user,
					TargetEntity = _targetEntity,
					Shield = shield
				};

				if (this.m.IsShowingProjectile && this.m.ProjectileType != 0)
				{
					local divertTile = _targetEntity.getTile();
					local flip = !this.m.IsProjectileRotated && _targetEntity.getPos().X > _user.getPos().X;
					local time = 0;

					if (_user.getTile().getDistanceTo(divertTile) >= this.Const.Combat.SpawnProjectileMinDist)
					{
						time = this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), divertTile, 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
					}

					this.Time.scheduleEvent(this.TimeUnit.Virtual, time, this.onShieldHit, info);
				}
				else
				{
					this.onShieldHit(info);
				}
			}
			else
			{
				if (this.m.SoundOnMiss.len() != 0)
				{
					this.Sound.play(this.m.SoundOnMiss[this.Math.rand(0, this.m.SoundOnMiss.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, _targetEntity.getPos());
				}

				if (this.m.IsShowingProjectile && this.m.ProjectileType != 0)
				{
					local divertTile = _targetEntity.getTile();
					local flip = !this.m.IsProjectileRotated && _targetEntity.getPos().X > _user.getPos().X;

					if (_user.getTile().getDistanceTo(divertTile) >= this.Const.Combat.SpawnProjectileMinDist)
					{
						this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), divertTile, 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
					}
				}

				if (this.Tactical.State.getStrategicProperties() != null && this.Tactical.State.getStrategicProperties().IsArenaMode)
				{
					if (toHit >= 90 || _targetEntity.getHitpointsPct() <= 0.1)
					{
						this.Sound.play(this.Const.Sound.ArenaMiss[this.Math.rand(0, this.Const.Sound.ArenaBigMiss.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
					}
					else if (this.Math.rand(1, 100) <= 20)
					{
						this.Sound.play(this.Const.Sound.ArenaMiss[this.Math.rand(0, this.Const.Sound.ArenaMiss.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
					}
				}
			}

			return false;
		}
	};

	while (!("onShieldHit" in o))
	{
		o = o[o.SuperName];
	}

	o.onShieldHit = function ( _info )
	{
		local shield = _info.Shield;
		local user = _info.User;
		local targetEntity = _info.TargetEntity;

		if (_info.Skill.m.SoundOnHitShield.len() != 0)
		{
			this.Sound.play(_info.Skill.m.SoundOnHitShield[this.Math.rand(0, _info.Skill.m.SoundOnHitShield.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, user.getPos());
		}

		shield.applyShieldDamage(this.Const.Combat.BasicShieldDamage, _info.Skill.m.SoundOnHitShield.len() == 0);

		if (shield.getCondition() == 0)
		{
			if (!user.isHiddenToPlayer())
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(user) + " niszczy tarczę, którą dzierży " + this.Const.UI.getColorizedEntityName(targetEntity));
			}
		}
		else
		{
			if (!user.isHiddenToPlayer())
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(user) + " zadaje 1 pkt. obrażeń tarczy, którą dzierży " + this.Const.UI.getColorizedEntityName(targetEntity));
			}

			if (!this.Tactical.getNavigator().isTravelling(targetEntity))
			{
				this.Tactical.getShaker().shake(targetEntity, user.getTile(), 2, this.Const.Combat.ShakeEffectSplitShieldColor, this.Const.Combat.ShakeEffectSplitShieldHighlight, this.Const.Combat.ShakeEffectSplitShieldFactor, 1.0, [
					"shield_icon"
				], 1.0);
			}
		}

		_info.TargetEntity.getItems().onShieldHit(_info.User, this);
	};
});

