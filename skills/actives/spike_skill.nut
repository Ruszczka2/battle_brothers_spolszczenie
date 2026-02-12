this.spike_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.spike_skill";
		this.m.Name = "Iglica";
		this.m.Description = "";
		this.m.KilledString = "Przeszyty";
		this.m.Icon = "skills/active_230.png";
		this.m.IconDisabled = "skills/active_230.png";
		this.m.Overlay = "active_230";
		this.m.SoundOnUse = [
			"sounds/enemies/big_golem_windup_01.wav",
			"sounds/enemies/big_golem_windup_02.wav",
			"sounds/enemies/big_golem_windup_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/spike_attack_single_01.wav",
			"sounds/enemies/spike_attack_single_02.wav",
			"sounds/enemies/spike_attack_single_03.wav",
			"sounds/enemies/spike_attack_single_04.wav"
		];
		this.m.SoundOnHitDelay = 0;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsAOE = true;
		this.m.IsTargetingActor = false;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.2;
		this.m.ActionPointCost = 12;
		this.m.FatigueCost = 30;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 25;
		this.m.ChanceSmash = 25;
	}

	function isUsable()
	{
		return this.skill.isUsable();
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin += 80;
			_properties.DamageRegularMax += 90;
			_properties.DamageArmorMult *= 0.9;
			_properties.HitChance[this.Const.BodyPart.Head] += 5;
		}
	}

	function onUse( _user, _targetTile )
	{
		local user = this.m.Container.getActor();
		this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], 1.0, _targetTile.Pos);
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(user) + " przeszywa przestrzeń przed sobą");
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSplit);
		local ret = this.attackEntity(_user, _targetTile.getEntity());

		if (!_user.isAlive() || _user.isDying())
		{
			return ret;
		}

		local ownTile = _user.getTile();
		local dir = ownTile.getDirectionTo(_targetTile);

		if (_targetTile.hasNextTile(dir))
		{
			local forwardTile = _targetTile.getNextTile(dir);

			if (forwardTile.IsOccupiedByActor && forwardTile.getEntity().isAttackable() && this.Math.abs(forwardTile.Level - ownTile.Level) <= 1)
			{
				ret = this.attackEntity(_user, forwardTile.getEntity()) || ret;
			}

			if (!_user.isAlive() || _user.isDying())
			{
				return ret;
			}

			if (forwardTile.hasNextTile(dir))
			{
				local furtherForwardTile = forwardTile.getNextTile(dir);

				if (furtherForwardTile.IsOccupiedByActor && furtherForwardTile.getEntity().isAttackable() && this.Math.abs(furtherForwardTile.Level - ownTile.Level) <= 1)
				{
					ret = this.attackEntity(_user, furtherForwardTile.getEntity()) || ret;
				}

				if (!_user.isAlive() || _user.isDying())
				{
					return ret;
				}
			}
		}

		return true;
	}

});

