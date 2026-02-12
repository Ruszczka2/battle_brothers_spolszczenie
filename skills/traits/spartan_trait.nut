this.spartan_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.spartan";
		this.m.Name = "Asceta";
		this.m.Icon = "ui/traits/trait_icon_08.png";
		this.m.Description = "Komu potrzeba coś więcej niż owsianka i woda? Ta postać nie odczuwa przyjemności z jedzenia i będzie zużywać mniej prowiantu, jak i nie opuści cię tak szybko, gdy całkowicie skończą się zapasy żywności.";
		this.m.Excluded = [
			"trait.fat",
			"trait.gluttonous"
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
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.DailyFood -= 1.0;
	}

});

