this.arena_pit_fighter_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.pit_fighter";
		this.m.Name = "Nowicjusz Areny";
		this.m.Icon = "ui/traits/trait_icon_73.png";
		this.m.Description = "Ta postać dopiero co postawiła pierwsze kroki w brutalnej profesji arenowych walk i udało się jej nie zginąć.";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
	}

	function getTooltip()
	{
		local matches = this.getContainer().getActor().getFlags().getAsInt("ArenaFights");
		local won = this.getContainer().getActor().getFlags().getAsInt("ArenaFightsWon");
		local text;

		if (matches == 1)
		{
			text = " Jak na razie, ta postać wzięła udział w jednej rozgrywce";

			if (won == 1)
			{
				text = text + " i ją wygrała.";
			}
			else
			{
				text = text + ", ale ją przegrała.";
			}
		}
		else
		{
			if (won == matches)
			{
				won = "wszystkie";
			}

			text = " Jak na razie, ta postać wzięła udział w " + matches + " rozgrywkach i wygrała " + won + " z nich.";
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
				text = this.getDescription() + text
			}
		];
	}

});

