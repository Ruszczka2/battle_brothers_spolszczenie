this.broken_knee_injury <- this.inherit("scripts/skills/injury_permanent/permanent_injury", {
	m = {},
	function create()
	{
		this.permanent_injury.create();
		this.m.ID = "injury.broken_knee";
		this.m.Name = "Uszkodzone Kolano";
		this.m.Description = "Ta postać dostała czymś (zapewne strzałą) w kolano i rana nigdy się w pełni nie zagoiła. Szarżowanie i robienie uników może być bolesne oraz pozbawione gracji.";
		this.m.Icon = "ui/injury/injury_permanent_icon_11.png";
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
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-40%[/color] do Obrony w zwarciu"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-40%[/color] do Obrony dystansowej"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-40%[/color] do Inicjatywy"
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
		_properties.MeleeDefenseMult *= 0.6;
		_properties.RangedDefenseMult *= 0.6;
		_properties.InitiativeMult *= 0.6;
		_properties.IsContentWithBeingInReserve = true;
	}

	function onApplyAppearance()
	{
	}

});

