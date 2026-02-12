this.brain_damage_injury <- this.inherit("scripts/skills/injury_permanent/permanent_injury", {
	m = {},
	function create()
	{
		this.permanent_injury.create();
		this.m.ID = "injury.brain_damage";
		this.m.Name = "Uszkodzenie Mózgu";
		this.m.Description = "Mocny cios w głowę czymś wstrząsnął i niezbyt poprawił zdolności kognitywne tej postaci. Plusy są takie, że teraz postać może już być po prostu zbyt głupia, aby zdać sobie sprawę z tego, kiedy należałoby brać nogi za pas.";
		this.m.Icon = "ui/injury/injury_permanent_icon_12.png";
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
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color] do Stanowczości"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] do zdobywanego doświadczenia"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] do Inicjatywy"
			}
		];
		this.addTooltipHint(ret);
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.BraveryMult *= 1.15;
		_properties.XPGainMult *= 0.75;
		_properties.InitiativeMult *= 0.75;
	}

	function onApplyAppearance()
	{
		local sprite = this.getContainer().getActor().getSprite("permanent_injury_1");
		sprite.setBrush("permanent_injury_01");
		sprite.Visible = true;
	}

});

