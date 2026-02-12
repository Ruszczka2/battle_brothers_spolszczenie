this.deathwish_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.deathwish";
		this.m.Name = "Życzenie Śmierci";
		this.m.Icon = "ui/traits/trait_icon_13.png";
		this.m.Description = "Jeszcze nie umarłem! Ta postać nie przejmuje się odniesionymi ranami i będzie walczyć pomimo ich.";
		this.m.Titles = [
			"Szalony",
			"Dziwny",
			"Nieustraszony"
		];
		this.m.Excluded = [
			"trait.weasel",
			"trait.hesitant",
			"trait.dastard",
			"trait.fainthearted",
			"trait.craven",
			"trait.survivor"
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
				icon = "ui/icons/morale.png",
				text = "Brak testów na morale po utraceniu punktów zdrowia"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.IsAffectedByLosingHitpoints = false;
	}

});

