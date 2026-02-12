this.old_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.old";
		this.m.Name = "Stary";
		this.m.Icon = "skills/status_effect_60.png";
		this.m.Description = "Starość w końcu dosięgła tę postać.";
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
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] do Stanowczości"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/health.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] do Zdrowia"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] maksymalnego zmęczenia"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] do Inicjatywy"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-1[/color] do Wzroku"
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Nigdy nie przeszkadza mu bycie w rezerwie"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += 10;
		_properties.Hitpoints -= 10;
		_properties.Stamina -= 10;
		_properties.Vision -= 1;
		_properties.IsContentWithBeingInReserve = true;
	}

});

