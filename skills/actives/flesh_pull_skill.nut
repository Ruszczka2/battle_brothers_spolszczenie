this.flesh_pull_skill <- this.inherit("scripts/skills/skill", {
	m = {
		DestinationTile = null,
		PullRange = 2
	},
	function create()
	{
		this.m.ID = "actives.flesh_pull";
		this.m.Name = "Przyciągnięcie Ciała";
		this.m.Description = "";
		this.m.Icon = "skills/active_235.png";
		this.m.Overlay = "active_235";
		this.m.SoundOnUse = [
			"sounds/enemies/faultfinder_pull_01.wav",
			"sounds/enemies/faultfinder_pull_02.wav"
		];
		this.m.Delay = 1000;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsUsingHitchance = false;
		this.m.IsTargetingCorpses = true;
		this.m.IsTargetingDangerTiles = true;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 99;
		this.m.MaxLevelDifference = 4;
	}

	function setDestinationTile( _t )
	{
		this.m.DestinationTile = _t;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
	}

	function getPulledToTiles( _userTile, _targetTile )
	{
		local tiles = [];
		local corpses = this.Tactical.Entities.getCorpses();
		local golems = [];

		foreach( corpse in corpses )
		{
			if (corpse.IsCorpseSpawned)
			{
				if (corpse.IsEmpty && corpse.getDistanceTo(_targetTile) <= this.m.PullRange)
				{
					tiles.push(corpse);
				}

				for( local i = 0; i != 6; i = i )
				{
					if (!corpse.hasNextTile(i))
					{
					}
					else
					{
						local tile = corpse.getNextTile(i);

						if (tile.IsEmpty && tile.getDistanceTo(_targetTile) <= this.m.PullRange)
						{
							tiles.push(tile);
						}
					}

					i = ++i;
				}
			}
		}

		foreach( entity in this.Tactical.Entities.getAllInstancesAsArray() )
		{
			if (this.isKindOf(entity, "lesser_flesh_golem") || this.isKindOf(entity, "greater_flesh_golem"))
			{
				golems.push(entity);
			}
		}

		foreach( golem in golems )
		{
			local golemTile = golem.getTile();

			if (golemTile.getDistanceTo(_targetTile) <= this.m.PullRange + 1)
			{
				for( local i = 0; i != 6; i = i )
				{
					if (!golemTile.hasNextTile(i))
					{
					}
					else
					{
						local tile = golemTile.getNextTile(i);

						if (tile.IsEmpty && tile.getDistanceTo(_targetTile) <= this.m.PullRange)
						{
							tiles.push(tile);
						}
					}

					i = ++i;
				}
			}
		}

		return tiles;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (_targetTile.getEntity().getCurrentProperties().IsRooted || _targetTile.getEntity().getCurrentProperties().IsImmuneToKnockBackAndGrab)
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();

		if (this.m.DestinationTile == null)
		{
			return false;
		}

		if (target.getCurrentProperties().IsRooted || target.getCurrentProperties().IsImmuneToKnockBackAndGrab)
		{
			return false;
		}

		if (!_user.isHiddenToPlayer() && this.m.DestinationTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log("Pojawiają się cieliste macki i przyciągają: " + this.Const.UI.getColorizedEntityName(_targetTile.getEntity()) + "!");
		}

		if (!_user.isHiddenToPlayer() || !target.isHiddenToPlayer())
		{
			local scaleBackup = target.getSprite("status_rooted").Scale;
			local rooted_front = target.getSprite("status_rooted");
			rooted_front.Scale = 1.0;
			rooted_front.setBrush("golem_ensnare_front");
			rooted_front.Visible = true;
			rooted_front.Alpha = 0;
			rooted_front.fadeIn(50);
			local rooted_back = target.getSprite("status_rooted_back");
			rooted_back.Scale = 1.0;
			rooted_back.setBrush("golem_ensnare_back");
			rooted_back.Visible = true;
			rooted_back.Alpha = 0;
			rooted_back.fadeIn(50);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 900, this.onDone, {
				Target = target,
				ScaleBackup = scaleBackup,
				Skill = this
			});
		}

		local skills = _targetTile.getEntity().getSkills();
		skills.removeByID("effects.shieldwall");
		skills.removeByID("effects.spearwall");
		skills.removeByID("effects.riposte");
		target.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
		local damage = this.Math.max(0, this.Math.abs(this.m.DestinationTile.Level - _targetTile.Level) - 1) * this.Const.Combat.FallingDamage;

		if (damage == 0)
		{
			this.Tactical.getNavigator().teleport(_targetTile.getEntity(), this.m.DestinationTile, null, null, true);
		}
		else
		{
			local tag = {
				Attacker = _user,
				Skill = this,
				HitInfo = clone this.Const.Tactical.HitInfo
			};
			tag.HitInfo.DamageRegular = damage;
			tag.HitInfo.DamageFatigue = this.Const.Combat.FatigueReceivedPerHit;
			tag.HitInfo.DamageDirect = 1.0;
			tag.HitInfo.BodyPart = this.Const.BodyPart.Body;
			this.Tactical.getNavigator().teleport(_targetTile.getEntity(), this.m.DestinationTile, this.onPulledDown, tag, true);
		}

		local stagger = this.new("scripts/skills/effects/staggered_effect");
		target.getSkills().add(stagger);

		if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(stagger.getLogEntryOnAdded(this.Const.UI.getColorizedEntityName(_user), this.Const.UI.getColorizedEntityName(target)));
		}

		return true;
	}

	function onPulledDown( _entity, _tag )
	{
		_entity.onDamageReceived(_tag.Attacker, _tag.Skill, _tag.HitInfo);
	}

	function onDone( _data )
	{
		local rooted_front = _data.Target.getSprite("status_rooted");
		rooted_front.fadeOutAndHide(50);
		rooted_front.Scale = _data.ScaleBackup;
		local rooted_back = _data.Target.getSprite("status_rooted_back");
		rooted_back.fadeOutAndHide(50);
		rooted_back.Scale = _data.ScaleBackup;
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 100, _data.Skill.onAfterDone, _data);
	}

	function onAfterDone( _data )
	{
		_data.Target.setDirty(true);
	}

});

