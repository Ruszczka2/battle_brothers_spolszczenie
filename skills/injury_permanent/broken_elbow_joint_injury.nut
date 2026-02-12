this.broken_elbow_joint_injury <- this.inherit("scripts/skills/injury_permanent/permanent_injury", {
	m = {},
	function create()
	{
		this.permanent_injury.create();
		this.m.ID = "injury.broken_elbow_joint";
		this.m.Name = "Uszkodzony Staw Łokciowy";
		this.m.Description = "Złamany łokieć, który nigdy w pełni się nie wyleczył, utrudnia ruchy ręką i znacznie obniża skuteczność w walce.";
		this.m.Icon = "ui/injury/injury_permanent_icon_08.png";
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color] do Ataku w zwarciu"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color] do Ataku dystansowego"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30%[/color] do Obrony w zwarciu"
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Nigdy nie przeszkadza mu bycie w rezerwie"
			}
		];
		this.addTooltipHint(ret);
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.MeleeSkillMult *= 0.8;
		_properties.RangedSkillMult *= 0.8;
		_properties.MeleeDefenseMult *= 0.7;
		_properties.IsContentWithBeingInReserve = true;
	}

	function onApplyAppearance()
	{
	}

});

