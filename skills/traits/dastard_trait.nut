this.dastard_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.dastard";
		this.m.Name = "Nikczemny";
		this.m.Icon = "ui/traits/trait_icon_38.png";
		this.m.Description = "Ta postać weźmie nogi za pas przy pierwszej możliwej okazji. Lepiej mieć na nią oko!";
		this.m.Titles = [
			"Mięczak",
			"Tchórz",
			"Strachajło"
		];
		this.m.Excluded = [
			"trait.determined",
			"trait.brave",
			"trait.deathwish",
			"trait.bloodthirsty",
			"trait.fearless",
			"trait.cocky",
			"trait.optimist",
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
				icon = "ui/icons/morale.png",
				text = "Rozpocznie bitwę z zachwianym morale"
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
		_properties.IsContentWithBeingInReserve = true;
	}

	function onCombatStarted()
	{
		local actor = this.getContainer().getActor();

		if (actor.getMoodState() >= this.Const.MoodState.Disgruntled && actor.getMoraleState() > this.Const.MoraleState.Wavering)
		{
			actor.setMoraleState(this.Const.MoraleState.Wavering);
		}
	}

});

