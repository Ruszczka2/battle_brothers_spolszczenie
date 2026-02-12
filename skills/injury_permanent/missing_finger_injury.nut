this.missing_finger_injury <- this.inherit("scripts/skills/injury_permanent/permanent_injury", {
	m = {},
	function create()
	{
		this.permanent_injury.create();
		this.m.ID = "injury.missing_finger";
		this.m.Name = "Brak Palca";
		this.m.Description = "Brakujący palec sprawia, że trudniej tej postaci pewnie chwycić broń lub tarczę, choć robi też za dobrą historię przy kuflu piwa.";
		this.m.Icon = "ui/injury/injury_permanent_icon_02.png";
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5%[/color] do Ataku w zwarciu"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5%[/color] do Ataku dystansowego"
			}
		];
		this.addTooltipHint(ret);
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.MeleeSkillMult *= 0.95;
		_properties.RangedSkillMult *= 0.95;
	}

	function onApplyAppearance()
	{
	}

});

