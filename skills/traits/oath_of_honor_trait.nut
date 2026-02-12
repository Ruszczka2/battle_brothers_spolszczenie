this.oath_of_honor_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.oath_of_honor";
		this.m.Name = "Przysięga Honoru";
		this.m.Icon = "ui/traits/trait_icon_82.png";
		this.m.Description = "Ta postać złożyła Przysięgę Honoru i jest zobowiązana do osiągania zwycięstwa tylko poprzez bezpośrednią walkę.";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
		this.m.Excluded = [];
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
				text = "Rozpoczyna walkę z wysokim morale, jeśli nastój na to pozwala"
			},
			{
				id = 11,
				type = "hint",
				icon = "ui/icons/warning.png",
				text = "Nie może używać broni dystansowej i narzędzi"
			}
		];
	}

	function onCombatStarted()
	{
		local actor = this.getContainer().getActor();

		if (actor.getMoodState() >= this.Const.MoodState.Neutral && actor.getMoraleState() < this.Const.MoraleState.Confident)
		{
			actor.setMoraleState(this.Const.MoraleState.Confident);
		}
	}

});

