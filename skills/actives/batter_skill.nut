this.batter_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.batter";
		this.m.Name = "Walnij";
		this.m.Description = "Uderzenie, które może pokryć odległość dwóch pól. Jego efekty można odczuć nawet przez zbroję.";
		this.m.KilledString = "Zatłuczony na śmierć";
		this.m.Icon = "skills/active_136.png";
		this.m.IconDisabled = "skills/active_136_sw.png";
		this.m.Overlay = "active_136";
		this.m.SoundOnUse = [
			"sounds/combat/hammer_strike_01.wav",
			"sounds/combat/hammer_strike_02.wav",
			"sounds/combat/hammer_strike_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/hammer_strike_hit_01.wav",
			"sounds/combat/hammer_strike_hit_02.wav",
			"sounds/combat/hammer_strike_hit_03.wav"
		];
		this.m.SoundVolume = 1.1;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsTooCloseShown = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.5;
		this.m.HitChanceBonus = 0;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 50;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Zawsze zadaje co najmniej [color=" + this.Const.UI.Color.DamageValue + "]" + 10 + "[/color] obrażeń zdrowia, bez względu na pancerz"
		});
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Ma zasięg [color=" + this.Const.UI.Color.PositiveValue + "]2" + "[/color] pól"
		});

		if (!this.getContainer().getActor().getCurrentProperties().IsSpecializedInHammers)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Ma [color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] szansy na trafienie celów bezpośrednio sąsiadujących, ponieważ broń jest zbyt nieporęczna"
			});
		}

		return ret;
	}

	function getExpectedDamage( _target )
	{
		local ret = this.skill.getExpectedDamage(_target);
		ret.HitpointDamage = this.Math.max(10, ret.HitpointDamage);
		ret.TotalDamage = this.Math.max(10, ret.TotalDamage);
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInHammers ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectBash);
		local target = _targetTile.getEntity();
		return this.attackEntity(_user, target);
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageMinimum = this.Math.max(_properties.DamageMinimum, 10);

			if (_targetEntity != null && !this.getContainer().getActor().getCurrentProperties().IsSpecializedInHammers && this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile()) == 1)
			{
				_properties.MeleeSkill += -15;
				this.m.HitChanceBonus = -15;
			}
			else
			{
				this.m.HitChanceBonus = 0;
			}
		}
	}

});

