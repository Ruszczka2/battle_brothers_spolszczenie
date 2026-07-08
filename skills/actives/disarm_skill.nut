this.disarm_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.disarm";
		this.m.Name = "Rozbrój";
		this.m.Description = "Użyj bata na znaczącą odległość, aby tymczasowo rozbroić przeciwnika przy trafieniu. Rozbrojona postać nie może używać żadnych umiejętności związanych z bronią, ale może swobodnie się poruszać i wykorzystywać inne umiejętności. Nieuzbrojone cele nie mogą zostać rozbrojone.";
		this.m.Icon = "skills/active_170.png";
		this.m.IconDisabled = "skills/active_170_sw.png";
		this.m.Overlay = "active_170";
		this.m.SoundOnUse = [
			"sounds/combat/whip_01.wav",
			"sounds/combat/whip_02.wav",
			"sounds/combat/whip_03.wav"
		];
		this.m.SoundOnHit = [];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.0;
		this.m.HitChanceBonus = 0;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 30;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Ma zasięg [color=" + this.Const.UI.Color.PositiveValue + "]3" + "[/color] pól"
		});

		if (this.getHitChanceModifier() != 0)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Ma [color=" + this.Const.UI.Color.NegativeValue + "]" + this.getHitChanceModifier() + "%[/color] szansy na trafienie"
			});
		}

		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Ma [color=" + this.Const.UI.Color.PositiveValue + "]100%[/color] szansy na rozbrojenie po trafieniu"
		});
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInCleavers ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local success = this.attackEntity(_user, target);

		if (success)
		{
			if (!target.getCurrentProperties().IsStunned && !target.getCurrentProperties().IsImmuneToDisarm)
			{
				local disarm = this.new("scripts/skills/effects/disarmed_effect");
				target.getSkills().add(disarm);

				if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
				{
					this.Tactical.EventLog.log(disarm.getLogEntryOnAdded(this.Const.UI.getColorizedEntityName(_user), this.Const.UI.getColorizedEntityName(target)));
				}
			}
		}

		return success;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )

	{

		if (_skill == this)

		{

			_properties.MeleeSkill += this.getHitChanceModifier();

			this.m.HitChanceBonus += this.getHitChanceModifier();

			_properties.DamageTotalMult = 0.0;

			_properties.HitChanceMult[this.Const.BodyPart.Head] = 0.0;

		}

	}


	function getHitChanceModifier()

	{

		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInCleavers)

		{

			return -10;

		}

		else

		{

			return -20;

		}

	}
});

