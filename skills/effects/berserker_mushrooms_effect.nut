this.berserker_mushrooms_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.berserker_mushrooms";
		this.m.Name = "SZAŁ!!!";
		this.m.Icon = "skills/status_effect_67.png";
		this.m.IconMini = "status_effect_67_mini";
		this.m.SoundOnUse = [
			"sounds/combat/rage_01.wav",
			"sounds/combat/rage_02.wav"
		];
		this.m.Type = this.Const.SkillType.StatusEffect | this.Const.SkillType.DrugEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "ZABIĆ!!! Ta postać wpadła w wywołany grzybkami szaleńczy trans i chce tylko zmiażdżyć i zniszczyć wszystko na swej drodze, nie dbając zbytnio o własne bezpieczeństwo. MIAŻDŻYĆ!!! NISZCZYĆ!!!";
	}

	function getTooltip()
	{
		return [
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
				id = 10,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+25%[/color] do zadawanych obrażeń w zwarciu"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15[/color] do Obrony w zwarciu"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15[/color] do Obrony dystansowej"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/morale.png",
				text = "Brak testów na morale po utraceniu punktów zdrowia"
			},
			{
				id = 7,
				type = "hint",
				icon = "ui/icons/action_points.png",
				text = "Minie po jeszcze 1 bitwie"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.MeleeDefense -= 15;
		_properties.RangedDefense -= 15;
		_properties.IsAffectedByLosingHitpoints = false;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill.isAttack() && !_skill.isRanged())
		{
			_properties.DamageTotalMult *= 1.25;
		}
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Actor, this.getContainer().getActor().getPos(), this.Math.rand(100, 115) * 0.01 * this.getContainer().getActor().getSoundPitch());
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Actor, this.getContainer().getActor().getPos(), this.Math.rand(100, 115) * 0.01 * this.getContainer().getActor().getSoundPitch());
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
	}

});

