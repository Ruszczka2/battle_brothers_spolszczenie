this.oath_of_sacrifice_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.oath_of_sacrifice";
		this.m.Name = "Przysięga Poświęcenia";
		this.m.Icon = "ui/traits/trait_icon_87.png";
		this.m.Description = "Ta postać złożyła Przysięgę Poświęcenia i jest zobowiązana do zrezygnowania z dbania o siebie, aby kompania odniosła sukces. Takie zachowanie odbija się jednakże na stanie fizycznym.";
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
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Nie otrzymuje żołdu"
			},
			{
				id = 10,
				type = "hint",
				icon = "ui/icons/warning.png",
				text = "Rany się nie goją"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.DailyWageMult *= 0.0;
	}

});

