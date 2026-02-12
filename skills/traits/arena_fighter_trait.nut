this.arena_fighter_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.arena_fighter";
		this.m.Name = "Wojownik Areny";
		this.m.Icon = "ui/traits/trait_icon_74.png";
		this.m.Description = "Dźwięk wielkiego tłumu wykrzykującego twoje imię może być uzależniający. Tej postaci zaczynają się podobać zabójcze walki na arenie i likwidowanie swoich przeciwników w taki sposób, który najbardziej raduje gawiedź.";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
	}

	function getTooltip()
	{
		local matches = this.getContainer().getActor().getFlags().getAsInt("ArenaFights");
		local won = this.getContainer().getActor().getFlags().getAsInt("ArenaFightsWon");

		if (won == matches)
		{
			won = "wszystkie";
		}

		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription() + " Jak na razie, ta postać wzięła udział w " + matches + " rozgrywkach i wygrała " + won + " z nich."
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] do Stanowczości"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += 5;
	}

});

