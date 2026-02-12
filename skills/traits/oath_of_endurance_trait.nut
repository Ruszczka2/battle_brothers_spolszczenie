this.oath_of_endurance_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.oath_of_endurance";
		this.m.Name = "Przysięga Wytrzymałości";
		this.m.Icon = "ui/traits/trait_icon_84.png";
		this.m.Description = "Ta postać złożyła Przysięgę Wytrzymałości i jest zobowiązana wytrwać w walce dłużej, niż wszyscy z wrogów.";
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
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+3[/color] odnowy Zmęczenia na turę"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.FatigueRecoveryRate += 3;
	}

});

