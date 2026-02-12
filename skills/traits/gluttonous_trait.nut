this.gluttonous_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.gluttonous";
		this.m.Name = "Żarłoczny";
		this.m.Icon = "ui/traits/trait_icon_07.png";
		this.m.Description = "Smaczne, zjedzmy jeszcze trochę! Lepiej zabierz dodatkowy prowiant, gdy podróżujesz z tą postacią i możesz się spodziewać, że szybko cię ona opuści, gdy całkiem skończą ci się zapasy żywności.";
		this.m.Titles = [
			"Wieprz"
		];
		this.m.Excluded = [
			"trait.athletic",
			"trait.iron_lungs",
			"trait.spartan",
			"trait.fragile"
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

	function addTitle()
	{
		this.character_trait.addTitle();
	}

	function onUpdate( _properties )
	{
		_properties.DailyFood += 1.0;
	}

});

