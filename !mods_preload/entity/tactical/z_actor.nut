::mods_hookClass("entity/tactical/actor", function ( o )
{
	while (!("getTooltip" in o))
	{
		o = o[o.SuperName];
	}

	o.getTooltip = function ( _targetedWithSkill = null )
	{
		if (!this.isPlacedOnMap() || !this.isAlive() || this.isDying())
		{
			return [];
		}

		if (!this.isDiscovered())
		{
			local tooltip = [
				{
					id = 1,
					type = "title",
					text = "Ukryty Przeciwnik"
				}
			];
			return tooltip;
		}

		local tooltip = [
			{
				id = 1,
				type = "title",
				text = this.getName(),
				icon = this.getLevelImagePath()
			}
		];

		if (this.isHiddenToPlayer())
		{
			tooltip.push({
				id = 3,
				type = "headerText",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Obecnie nie w zasięgu wzroku[/color]"
			});
		}
		else
		{
			if (_targetedWithSkill != null && this.isKindOf(_targetedWithSkill, "skill"))
			{
				local tile = this.getTile();

				if (tile.IsVisibleForEntity && _targetedWithSkill.isUsableOn(tile))
				{
					local hitchance = _targetedWithSkill.getHitchance(this);
					tooltip.push({
						id = 3,
						type = "headerText",
						icon = "ui/icons/hitchance.png",
						children = _targetedWithSkill.getHitFactors(tile),
						text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + hitchance + "%[/color] szansy na trafienie"
					});
				}
			}

			if (this.m.IsActingEachTurn)
			{
				local turnsToGo = this.Tactical.TurnSequenceBar.getTurnsUntilActive(this.getID());

				if (this.Tactical.TurnSequenceBar.getActiveEntity() == this)
				{
					tooltip.push({
						id = 4,
						type = "text",
						icon = "ui/icons/initiative.png",
						text = "Właśnie wykonuje ruch!"
					});
				}
				else if (this.m.IsTurnDone || turnsToGo == null)
				{
					tooltip.push({
						id = 4,
						type = "text",
						icon = "ui/icons/initiative.png",
						text = "Tura zakończona"
					});
				}
				else
				{
					tooltip.push({
						id = 4,
						type = "text",
						icon = "ui/icons/initiative.png",
						text = "Wykonuje ruch za " + turnsToGo + (turnsToGo > 1 ? (turnsToGo > 4 ? " tur" : " tury") : " turę")
					});
				}
			}

			tooltip.push({
				id = 5,
				type = "progressbar",
				icon = "ui/icons/armor_head.png",
				value = this.getArmor(this.Const.BodyPart.Head),
				valueMax = this.getArmorMax(this.Const.BodyPart.Head),
				text = this.Const.ArmorStateName[this.getArmorState(this.Const.BodyPart.Head)],
				style = "armor-head-slim"
			});
			tooltip.push({
				id = 6,
				type = "progressbar",
				icon = "ui/icons/armor_body.png",
				value = this.getArmor(this.Const.BodyPart.Body),
				valueMax = this.getArmorMax(this.Const.BodyPart.Body),
				text = this.Const.ArmorStateName[this.getArmorState(this.Const.BodyPart.Body)],
				style = "armor-body-slim"
			});
			tooltip.push({
				id = 7,
				type = "progressbar",
				icon = "ui/icons/health.png",
				value = this.getHitpoints() >= 0 ? this.getHitpoints() : 0,
				valueMax = this.getHitpointsMax(),
				text = this.Const.HitpointsStateName[this.getHitpointsState()],
				style = "hitpoints-slim"
			});
			tooltip.push({
				id = 8,
				type = "progressbar",
				icon = "ui/icons/morale.png",
				value = this.getMoraleState(),
				valueMax = this.Const.MoraleState.COUNT - 1,
				text = this.Const.MoraleStateName[this.getMoraleState()],
				style = "morale-slim"
			});
			tooltip.push({
				id = 9,
				type = "progressbar",
				icon = "ui/icons/fatigue.png",
				value = this.getFatigue(),
				valueMax = this.getFatigueMax(),
				text = this.Const.FatigueStateName[this.getFatigueState()],
				style = "fatigue-slim"
			});
			local result = [];
			local statusEffects = this.getSkills().query(this.Const.SkillType.StatusEffect | this.Const.SkillType.TemporaryInjury, false, true);

			foreach( i, statusEffect in statusEffects )
			{
				tooltip.push({
					id = 100 + i,
					type = "text",
					icon = statusEffect.getIcon(),
					text = statusEffect.getName()
				});
			}
		}

		return tooltip;
	};
	o.onDamageReceived = function ( _attacker, _skill, _hitInfo )
	{
		if (!this.isAlive() || !this.isPlacedOnMap())
		{
			return 0;
		}

		if (_hitInfo.DamageRegular == 0 && _hitInfo.DamageArmor == 0)
		{
			return 0;
		}

		if (typeof _attacker == "instance")
		{
			_attacker = _attacker.get();
		}

		if (_attacker != null && _attacker.isAlive() && _attacker.isPlayerControlled() && !this.isPlayerControlled())
		{
			this.setDiscovered(true);
			this.getTile().addVisibilityForFaction(this.Const.Faction.Player);
			this.getTile().addVisibilityForCurrentEntity();
		}

		if (this.m.CurrentProperties.IsImmuneToCriticals || this.m.CurrentProperties.IsImmuneToHeadshots)
		{
			_hitInfo.BodyDamageMult = 1.0;
		}

		local p = this.m.Skills.buildPropertiesForBeingHit(_attacker, _skill, _hitInfo);
		this.m.Items.onBeforeDamageReceived(_attacker, _skill, _hitInfo, p);
		local dmgMult = p.DamageReceivedTotalMult;

		if (_skill != null)
		{
			dmgMult = dmgMult * (_skill.isRanged() ? p.DamageReceivedRangedMult : p.DamageReceivedMeleeMult);
		}

		_hitInfo.DamageRegular -= p.DamageRegularReduction;
		_hitInfo.DamageArmor -= p.DamageArmorReduction;
		_hitInfo.DamageRegular *= p.DamageReceivedRegularMult * dmgMult;
		_hitInfo.DamageArmor *= p.DamageReceivedArmorMult * dmgMult;
		local armor = 0;
		local armorDamage = 0;

		if (_hitInfo.DamageDirect < 1.0)
		{
			armor = p.Armor[_hitInfo.BodyPart] * p.ArmorMult[_hitInfo.BodyPart];
			armorDamage = this.Math.min(armor, _hitInfo.DamageArmor);
			armor = armor - armorDamage;
			_hitInfo.DamageInflictedArmor = this.Math.max(0, armorDamage);
		}

		_hitInfo.DamageFatigue *= p.FatigueEffectMult;
		this.m.Fatigue = this.Math.min(this.getFatigueMax(), this.Math.round(this.m.Fatigue + _hitInfo.DamageFatigue * p.FatigueReceivedPerHitMult * this.m.CurrentProperties.FatigueLossOnAnyAttackMult));
		local damage = 0;
		damage = damage + this.Math.maxf(0.0, _hitInfo.DamageRegular * _hitInfo.DamageDirect * p.DamageReceivedDirectMult - armor * this.Const.Combat.ArmorDirectDamageMitigationMult);

		if (armor <= 0 || _hitInfo.DamageDirect >= 1.0)
		{
			damage = damage + this.Math.max(0, _hitInfo.DamageRegular * this.Math.maxf(0.0, 1.0 - _hitInfo.DamageDirect * p.DamageReceivedDirectMult) - armorDamage);
		}

		damage = damage * _hitInfo.BodyDamageMult;
		damage = this.Math.max(0, this.Math.max(this.Math.round(damage), this.Math.min(this.Math.round(_hitInfo.DamageMinimum), this.Math.round(_hitInfo.DamageMinimum * p.DamageReceivedTotalMult))));
		_hitInfo.DamageInflictedHitpoints = damage;
		this.m.Skills.onDamageReceived(_attacker, _hitInfo.DamageInflictedHitpoints, _hitInfo.DamageInflictedArmor);

		if (armorDamage > 0 && !this.isHiddenToPlayer() && _hitInfo.IsPlayingArmorSound)
		{
			local armorHitSound = this.m.Items.getAppearance().ImpactSound[_hitInfo.BodyPart];

			if (armorHitSound.len() > 0)
			{
				this.Sound.play(armorHitSound[this.Math.rand(0, armorHitSound.len() - 1)], this.Const.Sound.Volume.ActorArmorHit, this.getPos());
			}

			if (damage < this.Const.Combat.PlayPainSoundMinDamage)
			{
				this.playSound(this.Const.Sound.ActorEvent.NoDamageReceived, this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.NoDamageReceived] * this.m.SoundVolumeOverall);
			}
		}

		if (damage > 0)
		{
			if (!this.m.IsAbleToDie && damage >= this.m.Hitpoints)
			{
				this.m.Hitpoints = 1;
			}
			else
			{
				this.m.Hitpoints = this.Math.round(this.m.Hitpoints - damage);
			}
		}

		if (this.m.Hitpoints <= 0)
		{
			local lorekeeperPotionEffect = this.m.Skills.getSkillByID("effects.lorekeeper_potion");

			if (lorekeeperPotionEffect != null && (!lorekeeperPotionEffect.isSpent() || lorekeeperPotionEffect.getLastFrameUsed() == this.Time.getFrame()))
			{
				this.getSkills().removeByType(this.Const.SkillType.DamageOverTime);
				this.m.Hitpoints = this.getHitpointsMax();
				lorekeeperPotionEffect.setSpent(true);
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + " odradza się dzięki mocy Strażnika Wiedzy!");
			}
			else
			{
				local nineLivesSkill = this.m.Skills.getSkillByID("perk.nine_lives");

				if (nineLivesSkill != null && (!nineLivesSkill.isSpent() || nineLivesSkill.getLastFrameUsed() == this.Time.getFrame()))
				{
					this.getSkills().removeByType(this.Const.SkillType.DamageOverTime);
					this.m.Hitpoints = this.Math.rand(11, 15);
					nineLivesSkill.setSpent(true);
					this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + " ma dziewięć żywotów!");
				}
			}
		}

		local fatalityType = this.Const.FatalityType.None;

		if (this.m.Hitpoints <= 0)
		{
			this.m.IsDying = true;

			if (_skill != null)
			{
				if (_skill.getChanceDecapitate() >= 100 || _hitInfo.BodyPart == this.Const.BodyPart.Head && this.Math.rand(1, 100) <= _skill.getChanceDecapitate() * _hitInfo.FatalityChanceMult)
				{
					fatalityType = this.Const.FatalityType.Decapitated;
				}
				else if (_skill.getChanceSmash() >= 100 || _hitInfo.BodyPart == this.Const.BodyPart.Head && this.Math.rand(1, 100) <= _skill.getChanceSmash() * _hitInfo.FatalityChanceMult)
				{
					fatalityType = this.Const.FatalityType.Smashed;
				}
				else if (_skill.getChanceDisembowel() >= 100 || _hitInfo.BodyPart == this.Const.BodyPart.Body && this.Math.rand(1, 100) <= _skill.getChanceDisembowel() * _hitInfo.FatalityChanceMult)
				{
					fatalityType = this.Const.FatalityType.Disemboweled;
				}
			}
		}

		if (_hitInfo.DamageDirect < 1.0)
		{
			local overflowDamage = _hitInfo.DamageArmor;

			if (this.m.BaseProperties.Armor[_hitInfo.BodyPart] != 0)
			{
				overflowDamage = overflowDamage - this.m.BaseProperties.Armor[_hitInfo.BodyPart] * this.m.BaseProperties.ArmorMult[_hitInfo.BodyPart];
				local newArmor = this.m.BaseProperties.Armor[_hitInfo.BodyPart] * p.ArmorMult[_hitInfo.BodyPart] - _hitInfo.DamageArmor;
				newArmor = newArmor / p.ArmorMult[_hitInfo.BodyPart];
				this.m.BaseProperties.Armor[_hitInfo.BodyPart] = this.Math.max(0, newArmor);
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + " obrywa w pancerz na [b]" + this.Math.floor(_hitInfo.DamageArmor) + "[/b] obrażeń");
			}

			if (overflowDamage > 0)
			{
				this.m.Items.onDamageReceived(overflowDamage, fatalityType, _hitInfo.BodyPart == this.Const.BodyPart.Body ? this.Const.ItemSlot.Body : this.Const.ItemSlot.Head, _attacker);
			}
		}

		if (this.getFaction() == this.Const.Faction.Player && _attacker != null && _attacker.isAlive())
		{
			this.Tactical.getCamera().quake(_attacker, this, 5.0, 0.16, 0.3);
		}

		if (damage <= 0 && armorDamage >= 0)
		{
			if ((this.m.IsFlashingOnHit || this.getCurrentProperties().IsStunned || this.getCurrentProperties().IsRooted) && !this.isHiddenToPlayer() && _attacker != null && _attacker.isAlive())
			{
				local layers = this.m.ShakeLayers[_hitInfo.BodyPart];
				local recoverMult = 1.0;
				this.Tactical.getShaker().cancel(this);
				this.Tactical.getShaker().shake(this, _attacker.getTile(), this.m.IsShakingOnHit ? 2 : 3, this.Const.Combat.ShakeEffectArmorHitColor, this.Const.Combat.ShakeEffectArmorHitHighlight, this.Const.Combat.ShakeEffectArmorHitFactor, this.Const.Combat.ShakeEffectArmorSaturation, layers, recoverMult);
			}

			this.m.Skills.update();
			this.setDirty(true);
			return 0;
		}

		if (damage >= this.Const.Combat.SpawnBloodMinDamage)
		{
			this.spawnBloodDecals(this.getTile());
		}

		if (this.m.Hitpoints <= 0)
		{
			this.spawnBloodDecals(this.getTile());
			this.kill(_attacker, _skill, fatalityType);
		}
		else
		{
			if (damage >= this.Const.Combat.SpawnBloodEffectMinDamage)
			{
				local mult = this.Math.maxf(0.75, this.Math.minf(2.0, damage / this.getHitpointsMax() * 3.0));
				this.spawnBloodEffect(this.getTile(), mult);
			}

			if (this.Tactical.State.getStrategicProperties() != null && this.Tactical.State.getStrategicProperties().IsArenaMode && _attacker != null && _attacker.getID() != this.getID())
			{
				local mult = damage / this.getHitpointsMax();

				if (mult >= 0.75)
				{
					this.Sound.play(this.Const.Sound.ArenaBigHit[this.Math.rand(0, this.Const.Sound.ArenaBigHit.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
				}
				else if (mult >= 0.25 || this.Math.rand(1, 100) <= 20)
				{
					this.Sound.play(this.Const.Sound.ArenaHit[this.Math.rand(0, this.Const.Sound.ArenaHit.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
				}
			}

			if (this.m.CurrentProperties.IsAffectedByInjuries && this.m.IsAbleToDie && damage >= this.Const.Combat.InjuryMinDamage && this.m.CurrentProperties.ThresholdToReceiveInjuryMult != 0 && _hitInfo.InjuryThresholdMult != 0 && _hitInfo.Injuries != null)
			{
				local potentialInjuries = [];
				local bonus = _hitInfo.BodyPart == this.Const.BodyPart.Head ? 1.25 : 1.0;

				foreach( inj in _hitInfo.Injuries )
				{
					if (inj.Threshold * _hitInfo.InjuryThresholdMult * this.Const.Combat.InjuryThresholdMult * this.m.CurrentProperties.ThresholdToReceiveInjuryMult * bonus <= damage / (this.getHitpointsMax() * 1.0))
					{
						if (!this.m.Skills.hasSkill(inj.ID) && this.m.ExcludedInjuries.find(inj.ID) == null)
						{
							potentialInjuries.push(inj.Script);
						}
					}
				}

				local appliedInjury = false;

				while (potentialInjuries.len() != 0)
				{
					local r = this.Math.rand(0, potentialInjuries.len() - 1);
					local injury = this.new("scripts/skills/" + potentialInjuries[r]);

					if (injury.isValid(this))
					{
						this.m.Skills.add(injury);

						if (this.isPlayerControlled() && this.isKindOf(this, "player"))
						{
							this.worsenMood(this.Const.MoodChange.Injury, "Otrzymał ranę");

							if (("State" in this.World) && this.World.State != null && this.World.Ambitions.hasActiveAmbition() && this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_sacrifice")
							{
								this.World.Statistics.getFlags().increment("OathtakersInjuriesSuffered");
							}
						}

						if (this.isPlayerControlled() || !this.isHiddenToPlayer())
						{
							this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + " dostaje w " + this.Const.Strings.BodyPartName[_hitInfo.BodyPart] + " otrzymując [b]" + this.Math.floor(damage) + "[/b] obrażeń i ranę: " + injury.getNameOnly() + "!");
						}

						appliedInjury = true;
						break;
					}
					else
					{
						potentialInjuries.remove(r);
					}
				}

				if (!appliedInjury)
				{
					if (damage > 0 && !this.isHiddenToPlayer())
					{
						this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + " dostaje w " + this.Const.Strings.BodyPartName[_hitInfo.BodyPart] + " otrzymując [b]" + this.Math.floor(damage) + "[/b] obrażeń");
					}
				}
			}
			else if (damage > 0 && !this.isHiddenToPlayer())
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + " dostaje w " + this.Const.Strings.BodyPartName[_hitInfo.BodyPart] + " otrzymując [b]" + this.Math.floor(damage) + "[/b] obrażeń");
			}

			if (this.m.MoraleState != this.Const.MoraleState.Ignore && damage >= this.Const.Morale.OnHitMinDamage && this.getCurrentProperties().IsAffectedByLosingHitpoints)
			{
				if (!this.isPlayerControlled() || !this.m.Skills.hasSkill("effects.berserker_mushrooms"))
				{
					this.checkMorale(-1, this.Const.Morale.OnHitBaseDifficulty * (1.0 - this.getHitpoints() / this.getHitpointsMax()) - (_attacker != null && _attacker.getID() != this.getID() ? _attacker.getCurrentProperties().ThreatOnHit : 0), this.Const.MoraleCheckType.Default, "", true);
				}
			}

			this.m.Skills.onAfterDamageReceived();

			if (damage >= this.Const.Combat.PlayPainSoundMinDamage && this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived].len() > 0)
			{
				local volume = 1.0;

				if (damage < this.Const.Combat.PlayPainVolumeMaxDamage)
				{
					volume = damage / this.Const.Combat.PlayPainVolumeMaxDamage;
				}

				this.playSound(this.Const.Sound.ActorEvent.DamageReceived, this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.DamageReceived] * this.m.SoundVolumeOverall * volume, this.m.SoundPitch);
			}

			this.m.Skills.update();
			this.onUpdateInjuryLayer();

			if ((this.m.IsFlashingOnHit || this.getCurrentProperties().IsStunned || this.getCurrentProperties().IsRooted) && !this.isHiddenToPlayer() && _attacker != null && _attacker.isAlive())
			{
				local layers = this.m.ShakeLayers[_hitInfo.BodyPart];
				local recoverMult = this.Math.minf(1.5, this.Math.maxf(1.0, damage * 2.0 / this.getHitpointsMax()));
				this.Tactical.getShaker().cancel(this);
				this.Tactical.getShaker().shake(this, _attacker.getTile(), this.m.IsShakingOnHit ? 2 : 3, this.Const.Combat.ShakeEffectHitpointsHitColor, this.Const.Combat.ShakeEffectHitpointsHitHighlight, this.Const.Combat.ShakeEffectHitpointsHitFactor, this.Const.Combat.ShakeEffectHitpointsSaturation, layers, recoverMult);
			}

			this.setDirty(true);
		}

		return damage;
	};
	o.onDiscovered = function ()
	{
		if (!this.isPlayerControlled())
		{
			if (this.getFaction() != this.Const.Faction.Player && this.getFaction() != this.Const.Faction.PlayerAnimals)
			{
				if (this.Const.Movement.AnnounceDiscoveredEntities)
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this) + " jest w zasięgu wzroku!");
				}
			}

			this.setDirty(true);
		}
	};
	o.checkMorale = function ( _change, _difficulty, _type = this.Const.MoraleCheckType.Default, _showIconBeforeMoraleIcon = "", _noNewLine = false )
	{
		if (!this.isAlive() || this.isDying())
		{
			return false;
		}

		if (this.m.MoraleState == this.Const.MoraleState.Ignore)
		{
			return false;
		}

		if (_change > 0 && this.m.MoraleState == this.Const.MoraleState.Confident)
		{
			return false;
		}

		if (_change < 0 && this.m.MoraleState == this.Const.MoraleState.Fleeing)
		{
			return false;
		}

		if (_change > 0 && this.m.MoraleState >= this.m.MaxMoraleState)
		{
			return false;
		}

		if (_change == 1 && this.m.MoraleState == this.Const.MoraleState.Fleeing)
		{
			return false;
		}

		local myTile = this.getTile();

		if (this.isPlayerControlled() && _change > 0 && (myTile.SquareCoords.X == 0 || myTile.SquareCoords.Y == 0 || myTile.SquareCoords.X == 31 || myTile.SquareCoords.Y == 31))
		{
			return false;
		}

		_difficulty = _difficulty * this.getCurrentProperties().MoraleEffectMult;
		local bravery = (this.getBravery() + this.getCurrentProperties().MoraleCheckBravery[_type]) * this.getCurrentProperties().MoraleCheckBraveryMult[_type];

		if (bravery > 500)
		{
			if (_change != 0)
			{
				return false;
			}
			else
			{
				return true;
			}
		}

		local numOpponentsAdjacent = 0;
		local numAlliesAdjacent = 0;
		local threatBonus = 0;

		for( local i = 0; i != 6; i = i )
		{
			if (!myTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = myTile.getNextTile(i);

				if (tile.IsOccupiedByActor && tile.getEntity().getMoraleState() != this.Const.MoraleState.Fleeing)
				{
					if (tile.getEntity().isAlliedWith(this))
					{
						numAlliesAdjacent = ++numAlliesAdjacent;
						numAlliesAdjacent = numAlliesAdjacent;
					}
					else
					{
						numOpponentsAdjacent = ++numOpponentsAdjacent;
						numOpponentsAdjacent = numOpponentsAdjacent;
						threatBonus = threatBonus + tile.getEntity().getCurrentProperties().Threat;
					}
				}
			}

			i = ++i;
		}

		if (_change > 0)
		{
			if (this.Math.rand(1, 100) > this.Math.minf(95, bravery + _difficulty - numOpponentsAdjacent * this.Const.Morale.OpponentsAdjacentMult - threatBonus))
			{
				if (this.Math.rand(1, 100) > this.m.CurrentProperties.RerollMoraleChance || this.Math.rand(1, 100) > this.Math.minf(95, bravery + _difficulty - numOpponentsAdjacent * this.Const.Morale.OpponentsAdjacentMult - threatBonus))
				{
					return false;
				}
			}
		}
		else if (_change < 0)
		{
			if (this.Math.rand(1, 100) <= this.Math.minf(95, bravery + _difficulty - numOpponentsAdjacent * this.Const.Morale.OpponentsAdjacentMult + numAlliesAdjacent * this.Const.Morale.AlliesAdjacentMult - threatBonus))
			{
				return false;
			}

			if (this.Math.rand(1, 100) <= this.m.CurrentProperties.RerollMoraleChance && this.Math.rand(1, 100) <= this.Math.minf(95, bravery + _difficulty - numOpponentsAdjacent * this.Const.Morale.OpponentsAdjacentMult + numAlliesAdjacent * this.Const.Morale.AlliesAdjacentMult - threatBonus))
			{
				return false;
			}
		}
		else if (this.Math.rand(1, 100) <= this.Math.minf(95, bravery + _difficulty - numOpponentsAdjacent * this.Const.Morale.OpponentsAdjacentMult + numAlliesAdjacent * this.Const.Morale.AlliesAdjacentMult - threatBonus))
		{
			return true;
		}
		else if (this.Math.rand(1, 100) <= this.m.CurrentProperties.RerollMoraleChance && this.Math.rand(1, 100) <= this.Math.minf(95, bravery + _difficulty - numOpponentsAdjacent * this.Const.Morale.OpponentsAdjacentMult + numAlliesAdjacent * this.Const.Morale.AlliesAdjacentMult - threatBonus))
		{
			return true;
		}
		else
		{
			return false;
		}

		local oldMoraleState = this.m.MoraleState;
		this.m.MoraleState = this.Math.min(this.Const.MoraleState.Confident, this.Math.max(0, this.m.MoraleState + _change));
		this.m.FleeingRounds = 0;

		if (this.m.MoraleState == this.Const.MoraleState.Confident && oldMoraleState != this.Const.MoraleState.Confident && ("State" in this.World) && this.World.State != null && this.World.Ambitions.hasActiveAmbition() && this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_camaraderie")
		{
			this.World.Statistics.getFlags().increment("OathtakersBrosConfident");
		}

		if (oldMoraleState == this.Const.MoraleState.Fleeing && this.m.IsActingEachTurn)
		{
			this.setZoneOfControl(this.getTile(), this.hasZoneOfControl());

			if (this.isPlayerControlled() || !this.isHiddenToPlayer())
			{
				if (_noNewLine)
				{
					this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + " pokrzepił");
				}
				else
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this) + " pokrzepił");
				}
			}
		}
		else if (this.m.MoraleState == this.Const.MoraleState.Fleeing)
		{
			this.setZoneOfControl(this.getTile(), this.hasZoneOfControl());
			this.m.Skills.removeByID("effects.shieldwall");
			this.m.Skills.removeByID("effects.spearwall");
			this.m.Skills.removeByID("effects.riposte");
			this.m.Skills.removeByID("effects.return_favor");
			this.m.Skills.removeByID("effects.indomitable");
		}

		local morale = this.getSprite("morale");

		if (this.Const.MoraleStateBrush[this.m.MoraleState].len() != 0)
		{
			if (this.m.MoraleState == this.Const.MoraleState.Confident)
			{
				morale.setBrush(this.m.ConfidentMoraleBrush);
			}
			else
			{
				morale.setBrush(this.Const.MoraleStateBrush[this.m.MoraleState]);
			}

			morale.Visible = true;
		}
		else
		{
			morale.Visible = false;
		}

		if (this.isPlayerControlled() || !this.isHiddenToPlayer())
		{
			if (_noNewLine)
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + this.Const.MoraleStateEvent[this.m.MoraleState]);
			}
			else
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this) + this.Const.MoraleStateEvent[this.m.MoraleState]);
			}

			if (_showIconBeforeMoraleIcon != "")
			{
				this.Tactical.spawnIconEffect(_showIconBeforeMoraleIcon, this.getTile(), this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
			}

			if (_change > 0)
			{
				this.Tactical.spawnIconEffect(this.Const.Morale.MoraleUpIcon, this.getTile(), this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
			}
			else
			{
				this.Tactical.spawnIconEffect(this.Const.Morale.MoraleDownIcon, this.getTile(), this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
			}
		}

		this.m.Skills.update();
		this.setDirty(true);

		if (this.m.MoraleState == this.Const.MoraleState.Fleeing && this.Tactical.TurnSequenceBar.getActiveEntity() != this)
		{
			this.Tactical.TurnSequenceBar.pushEntityBack(this.getID());
		}

		if (this.m.MoraleState == this.Const.MoraleState.Fleeing)
		{
			local actors = this.Tactical.Entities.getInstancesOfFaction(this.getFaction());

			if (actors != null)
			{
				foreach( a in actors )
				{
					if (a.getID() != this.getID())
					{
						a.onOtherActorFleeing(this);
					}
				}
			}
		}

		return true;
	};
	o.kill = function ( _killer = null, _skill = null, _fatalityType = this.Const.FatalityType.None, _silent = false )
	{
		if (!this.isAlive())
		{
			return;
		}

		if (_killer != null && !_killer.isAlive())
		{
			_killer = null;
		}

		if (this.m.IsMiniboss && !this.Tactical.State.isScenarioMode() && _killer != null && _killer.isPlayerControlled())
		{
			this.updateAchievement("GiveMeThat", 1, 1);

			if (!this.Tactical.State.isScenarioMode() && this.World.Retinue.hasFollower("follower.bounty_hunter"))
			{
				this.World.Retinue.getFollower("follower.bounty_hunter").onChampionKilled(this);
			}
		}

		if (!this.Tactical.State.isScenarioMode() && _killer != null && _killer.isPlayerControlled() && _skill != null && _skill.getID() == "actives.deathblow")
		{
			this.updateAchievement("Assassin", 1, 1);
		}

		this.m.IsDying = true;
		local isReallyDead = this.isReallyKilled(_fatalityType);

		if (!isReallyDead)
		{
			_fatalityType = this.Const.FatalityType.Unconscious;
			this.logDebug(this.getName() + " traci przytomność.");
		}
		else
		{
			this.logDebug(this.getName() + " ginie.");
		}

		if (!_silent)
		{
			this.playSound(this.Const.Sound.ActorEvent.Death, this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.Death] * this.m.SoundVolumeOverall, this.m.SoundPitch);
		}

		local myTile = this.isPlacedOnMap() ? this.getTile() : null;
		local tile = this.findTileToSpawnCorpse(_killer);
		this.m.Skills.onDeath(_fatalityType);
		this.onDeath(_killer, _skill, tile, _fatalityType);

		if (!this.Tactical.State.isFleeing() && _killer != null)
		{
			_killer.onActorKilled(this, tile, _skill);
		}

		if (_killer != null && !_killer.isHiddenToPlayer() && !this.isHiddenToPlayer())
		{
			if (isReallyDead)
			{
				if (_killer.getID() != this.getID())
				{
					this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_killer) + " zabija: " + this.Const.UI.getColorizedEntityName(this));
				}
				else
				{
					this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + " ginie");
				}
			}
			else if (_killer.getID() != this.getID())
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_killer) + " powala: " + this.Const.UI.getColorizedEntityName(this));
			}
			else
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + " zostaje powalony");
			}
		}

		if (!this.Tactical.State.isFleeing() && myTile != null)
		{
			local actors = this.Tactical.Entities.getAllInstances();

			foreach( i in actors )
			{
				foreach( a in i )
				{
					if (a.getID() != this.getID())
					{
						a.onOtherActorDeath(_killer, this, _skill);
					}
				}
			}
		}

		if (!this.isHiddenToPlayer())
		{
			if (tile != null)
			{
				if (_fatalityType == this.Const.FatalityType.Decapitated)
				{
					this.spawnDecapitateSplatters(tile, 1.0 * this.m.DecapitateBloodAmount);
				}
				else if (_fatalityType == this.Const.FatalityType.Smashed && (this.getFlags().has("human") || this.getFlags().has("zombie_minion")))
				{
					this.spawnSmashSplatters(tile, 1.0);
				}
				else
				{
					this.spawnBloodSplatters(tile, this.Const.Combat.BloodSplattersAtDeathMult * this.m.DeathBloodAmount);

					if (!this.getTile().isSameTileAs(tile))
					{
						this.spawnBloodSplatters(this.getTile(), this.Const.Combat.BloodSplattersAtOriginalPosMult);
					}
				}
			}
			else if (myTile != null)
			{
				this.spawnBloodSplatters(this.getTile(), this.Const.Combat.BloodSplattersAtDeathMult * this.m.DeathBloodAmount);
			}
		}

		if (tile != null)
		{
			this.spawnBloodPool(tile, this.Math.rand(this.Const.Combat.BloodPoolsAtDeathMin, this.Const.Combat.BloodPoolsAtDeathMax));
		}

		this.m.IsTurnDone = true;
		this.m.IsAlive = false;

		if (this.m.WorldTroop != null && ("Party" in this.m.WorldTroop) && this.m.WorldTroop.Party != null && !this.m.WorldTroop.Party.isNull())
		{
			this.m.WorldTroop.Party.removeTroop(this.m.WorldTroop);
		}

		if (!this.Tactical.State.isScenarioMode())
		{
			this.World.Contracts.onActorKilled(this, _killer, this.Tactical.State.getStrategicProperties().CombatID);
			this.World.Events.onActorKilled(this, _killer, this.Tactical.State.getStrategicProperties().CombatID);
			this.World.Assets.getOrigin().onActorKilled(this, _killer, this.Tactical.State.getStrategicProperties().CombatID);

			if (this.Tactical.State.getStrategicProperties() != null && this.Tactical.State.getStrategicProperties().IsArenaMode)
			{
				if (_killer == null || _killer.getID() == this.getID())
				{
					this.Sound.play(this.Const.Sound.ArenaFlee[this.Math.rand(0, this.Const.Sound.ArenaFlee.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
				}
				else
				{
					this.Sound.play(this.Const.Sound.ArenaKill[this.Math.rand(0, this.Const.Sound.ArenaKill.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
				}
			}
		}

		if (this.isPlayerControlled())
		{
			if (isReallyDead)
			{
				if (this.isGuest())
				{
					this.World.getGuestRoster().remove(this);
				}
				else
				{
					this.World.getPlayerRoster().remove(this);
				}
			}

			if (this.Tactical.Entities.getHostilesNum() != 0)
			{
				this.Tactical.Entities.setLastCombatResult(this.Const.Tactical.CombatResult.PlayerDestroyed);
			}
			else
			{
				this.Tactical.Entities.setLastCombatResult(this.Const.Tactical.CombatResult.EnemyDestroyed);
			}
		}
		else
		{
			if (!this.Tactical.State.isAutoRetreat())
			{
				this.Tactical.Entities.setLastCombatResult(this.Const.Tactical.CombatResult.EnemyDestroyed);
			}

			if (_killer != null && _killer.isPlayerControlled() && !this.Tactical.State.isScenarioMode() && this.World.FactionManager.getFaction(this.getFaction()) != null && !this.World.FactionManager.getFaction(this.getFaction()).isTemporaryEnemy())
			{
				this.World.FactionManager.getFaction(this.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationUnitKilled);
			}
		}

		if (isReallyDead)
		{
			if (!this.Tactical.State.isScenarioMode() && this.isPlayerControlled() && !this.isGuest())
			{
				local roster = this.World.getPlayerRoster().getAll();

				foreach( bro in roster )
				{
					if (bro.isAlive() && !bro.isDying() && bro.getCurrentProperties().IsAffectedByDyingAllies)
					{
						if (this.World.Assets.getOrigin().getID() != "scenario.manhunters" || this.getBackground().getID() != "background.slave" || bro.getBackground().getID() == "background.slave")
						{
							bro.worsenMood(this.Const.MoodChange.BrotherDied, this.getName() + " zginął w bitwie");
						}
					}
				}
			}

			this.die();
		}
		else
		{
			this.removeFromMap();
		}

		if (this.m.Items != null)
		{
			this.m.Items.onActorDied(tile);

			if (isReallyDead)
			{
				this.m.Items.setActor(null);
			}
		}

		if (!this.Tactical.State.isScenarioMode() && _killer != null && _killer.getFaction() == this.Const.Faction.PlayerAnimals && _skill != null && _skill.getID() == "actives.wardog_bite")
		{
			this.updateAchievement("WhoLetTheDogsOut", 1, 1);
		}

		this.onAfterDeath(myTile);
	};
	o.retreat = function ()
	{
		if (!this.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this) + " ucieka z bitwy");
		}

		this.m.IsTurnDone = true;
		this.m.IsAlive = false;

		if (this.m.WorldTroop != null && ("Party" in this.m.WorldTroop) && this.m.WorldTroop.Party != null)
		{
			this.m.WorldTroop.Party.removeTroop(this.m.WorldTroop);
		}

		if (!this.Tactical.State.isScenarioMode())
		{
			this.World.Contracts.onActorRetreated(this, this.Tactical.State.getStrategicProperties().CombatID);
			this.World.Events.onActorRetreated(this, this.Tactical.State.getStrategicProperties().CombatID);
		}

		if (this.isPlayerControlled())
		{
			this.Tactical.Entities.setLastCombatResult(this.Const.Tactical.CombatResult.PlayerRetreated);
		}
		else
		{
			this.Tactical.Entities.setLastCombatResult(this.Const.Tactical.CombatResult.EnemyRetreated);
		}

		this.die();
	};
});

