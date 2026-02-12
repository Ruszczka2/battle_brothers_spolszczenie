this.night_owl_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.night_owl";
		this.m.Name = "Nocna Sowa";
		this.m.Icon = "ui/traits/trait_icon_57.png";
		this.m.Description = "Niektórzy lepiej dostosowują się do słabych warunków świetlnych, a ta postać jest w tym wyjątkowo dobra.";
		this.m.Titles = [
			"Nocna Sowa",
			"Sokole Oko"
		];
		this.m.Excluded = [
			"trait.short_sighted",
			"trait.night_blind"
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
				icon = "ui/icons/vision.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+1[/color] do Wzroku w nocy"
			}
		];
	}

	function onUpdate( _properties )
	{
		if (this.getContainer().hasSkill("special.night"))
		{
			_properties.Vision += 1;
		}
	}

});

