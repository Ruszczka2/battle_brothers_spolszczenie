this.injured_knee_cap_injury <- this.inherit("scripts/skills/injury/injury", {
	m = {},
	function create()
	{
		this.injury.create();
		this.m.ID = "injury.injured_knee_cap";
		this.m.Name = "Obita Rzepka Kolana";
		this.m.Description = "Delikatna rzepka kolana została uszkodzona, powodując ból przy każdym ruchu i ograniczając mobilność tej postaci.";
		this.m.Type = this.m.Type | this.Const.SkillType.TemporaryInjury;
		this.m.DropIcon = "injury_icon_40";
		this.m.Icon = "ui/injury/injury_icon_40.png";
		this.m.IconMini = "injury_icon_40_mini";
		this.m.HealingTimeMin = 5;
		this.m.HealingTimeMax = 8;
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
				icon = "ui/icons/action_points.png",
				text = "Zwiększa koszt ruchu Punktów Akcji o [color=" + this.Const.UI.Color.NegativeValue + "]2[/color] na każde pole"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-40%[/color] do Inicjatywy"
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

		_properties.MovementAPCostAdditional += 2;
		_properties.InitiativeMult *= 0.6;
	}

});

