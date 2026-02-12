this.cut_arm_injury <- this.inherit("scripts/skills/injury/injury", {
	m = {},
	function create()
	{
		this.injury.create();
		this.m.ID = "injury.cut_arm";
		this.m.Name = "Rozcięta Dłoń";
		this.m.Description = "Głęboka rana cięta na ręce sprawia, że ciężko jej używać.";
		this.m.Type = this.m.Type | this.Const.SkillType.TemporaryInjury;
		this.m.DropIcon = "injury_icon_07";
		this.m.Icon = "ui/injury/injury_icon_07.png";
		this.m.IconMini = "injury_icon_07_mini";
		this.m.HealingTimeMin = 2;
		this.m.HealingTimeMax = 4;
		this.m.IsShownOnArm = true;
		this.m.InfectionChance = 1.0;
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
				id = 7,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] do Ataku w zwarciu"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] do Ataku dystansowego"
			}
		];
		this.addTooltipHint(ret);
		return ret;
	}

	function onUpdate( _properties )
	{
		this.injury.onUpdate(_properties);

		if (!_properties.IsAffectedByInjuries || this.m.IsFresh && !_properties.IsAffectedByFreshInjuries)
		{
			return;
		}

		_properties.MeleeSkillMult *= 0.85;
		_properties.RangedSkillMult *= 0.85;
	}

});

