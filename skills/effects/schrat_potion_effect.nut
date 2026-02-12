this.schrat_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.schrat_potion";
		this.m.Name = "Elastyczne Więzadła";
		this.m.Icon = "skills/status_effect_146.png";
		this.m.IconMini = "status_effect_146_mini";
		this.m.Overlay = "status_effect_146";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Nogi tej postaci zmutowały i reagują gwałtowniej oraz potężniej na siły zewnętrzne. W praktyce mogą skuteczniej utrzymać równowagę i niwelować prawie każdą próbę odepchnięcia, pochwycenia lub wykorzenienia.";
	}

	function getTooltip()
	{
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
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Niewrażliwość na odrzucenie oraz pochwycenie"
			},
			{
				id = 12,
				type = "hint",
				icon = "ui/tooltips/warning.png",
				text = "Dalsze mutacje spowodują dłuższy okres trwania choroby"
			}
		];
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.IsImmuneToKnockBackAndGrab = true;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isSchratPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isSchratPotionAcquired", false);
	}

});

