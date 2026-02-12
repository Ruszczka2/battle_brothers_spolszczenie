this.hesitant_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.hesitant";
		this.m.Name = "Niezdecydowany";
		this.m.Icon = "ui/traits/trait_icon_25.png";
		this.m.Description = "Umm... cóż... może. Ta postać często waha się przed podjęciem jakiejkolwiek akcji.";
		this.m.Titles = [
			"Powolny"
		];
		this.m.Excluded = [
			"trait.fearless",
			"trait.brave",
			"trait.deathwish",
			"trait.cocky",
			"trait.quick",
			"trait.brute",
			"trait.bloodthirsty",
			"trait.impatient"
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
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] do Inicjatywy"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Initiative += -10;
	}

});

