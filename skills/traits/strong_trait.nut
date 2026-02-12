this.strong_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.strong";
		this.m.Name = "Silny";
		this.m.Icon = "ui/traits/trait_icon_15.png";
		this.m.Description = "Dobrze odżywiony i wypolerowany na glanc.";
		this.m.Titles = [
			"Silny",
			"Byk",
			"Wół",
			"Niedźwiedź",
			"Wielki"
		];
		this.m.Excluded = [
			"trait.tiny",
			"trait.fragile",
			"trait.fat",
			"trait.ailing"
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
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] maksymalnego zmęczenia"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Stamina += 10;
	}

});

