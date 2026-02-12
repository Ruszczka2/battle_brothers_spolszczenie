this.maimed_foot_injury <- this.inherit("scripts/skills/injury_permanent/permanent_injury", {
	m = {},
	function create()
	{
		this.permanent_injury.create();
		this.m.ID = "injury.maimed_foot";
		this.m.Name = "Okulawienie";
		this.m.Description = "Kontuzja stopy, która nigdy w pełni się nie wyleczyła, przez co trudno wygrać jakikolwiek konkurs taneczny czy po prostu szybko się poruszać.";
		this.m.Icon = "ui/injury/injury_permanent_icon_06.png";
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
				text = "Zwiększa koszt ruchu Punktów Akcji o [color=" + this.Const.UI.Color.NegativeValue + "]1[/color] na każde pole"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color] do Inicjatywy"
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
		_properties.MovementAPCostAdditional += 1;
		_properties.InitiativeMult *= 0.8;
		_properties.IsContentWithBeingInReserve = true;
	}

	function onApplyAppearance()
	{
	}

});

