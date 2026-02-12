this.knock_over_skill <- this.inherit("scripts/skills/skill", {
	m = {
		StunChance = 75,
		IsFromLute = false
	},
	function setStunChance( _c )
	{
		this.m.StunChance = _c;
	}

	function create()
	{
		this.m.ID = "actives.knock_over";
		this.m.Name = "Przewróć";
		this.m.Description = "Mocny cios, którego zamiarem jest ogłuszyć lub obezwładnić na jedną turę każdego, kto będzie miał na tyle pecha, i tym ciosem oberwie. Ogłuszone cele nie są w stanie utrzymać swojej Ściany Tarcz, Ściany Włóczni, ani innych podobnych umiejętności defensywnych.";
		this.m.Icon = "skills/active_206.png";
		this.m.IconDisabled = "skills/active_206_sw.png";
		this.m.Overlay = "active_206";
		this.m.SoundOnUse = [
			"sounds/combat/dlc6/knock_over_01.wav",
			"sounds/combat/dlc6/knock_over_02.wav",
			"sounds/combat/dlc6/knock_over_03.wav",
			"sounds/combat/dlc6/knock_over_04.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/dlc6/knock_over_hit_01.wav",
			"sounds/combat/dlc6/knock_over_hit_02.wav",
			"sounds/combat/dlc6/knock_over_hit_03.wav",
			"sounds/combat/dlc6/knock_over_hit_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsTooCloseShown = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.4;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 30;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 50;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Ma zasięg [color=" + this.Const.UI.Color.PositiveValue + "]2" + "[/color] pól"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Zadaje [color=" + this.Const.UI.Color.DamageValue + "]" + this.Const.Combat.FatigueReceivedPerHit * 2 + "[/color] dodatkowego zmęczenia"
		});

		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInMaces)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Ma [color=" + this.Const.UI.Color.PositiveValue + "]100%[/color] szansy na ogłuszenie celu"
			});
		}
		else
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Ma [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.StunChance + "%[/color] szansy na ogłuszenie celu"
			});
		}

		if (!this.getContainer().getActor().getCurrentProperties().IsSpecializedInMaces)
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

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInMaces ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectBash);
		local success = this.attackEntity(_user, target);

		if (!_user.isAlive() || _user.isDying())
		{
			return success;
		}

		if (success && target.isAlive())
		{
			if ((_user.getCurrentProperties().IsSpecializedInMaces || this.Math.rand(1, 100) <= this.m.StunChance) && !target.getCurrentProperties().IsImmuneToStun && !target.getSkills().hasSkill("effects.stunned"))
			{
				local stun = this.new("scripts/skills/effects/stunned_effect");
				target.getSkills().add(stun);

				if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
				{
					this.Tactical.EventLog.log(stun.getLogEntryOnAdded(this.Const.UI.getColorizedEntityName(_user), this.Const.UI.getColorizedEntityName(target)));
				}
			}
		}

		return success;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageTotalMult *= 0.5;
			_properties.FatigueDealtPerHitMult += 2.0;

			if (_targetEntity != null && !this.getContainer().getActor().getCurrentProperties().IsSpecializedInMaces && this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile()) == 1)
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

