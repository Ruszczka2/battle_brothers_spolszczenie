this.craven_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.craven";
		this.m.Name = "Tchórz";
		this.m.Icon = "ui/traits/trait_icon_40.png";
		this.m.Description = "Ratuj się kto może! Ta postać to tchórz i ucieknie, gdy tylko szala bitwy przechyli się na korzyść wroga.";
		this.m.Titles = [
			"Tchórz",
			"Lękliwy",
			"Zdrajca",
			"Tchórzliwy"
		];
		this.m.Excluded = [
			"trait.fearless",
			"trait.brave",
			"trait.determined",
			"trait.fainthearted",
			"trait.deathwish",
			"trait.cocky",
			"trait.bloodthirsty",
			"trait.hate_greenskins",
			"trait.hate_undead",
			"trait.hate_beasts"
		];
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] do Stanowczości"
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
		_properties.Bravery += -10;
		_properties.IsContentWithBeingInReserve = true;
	}

});

