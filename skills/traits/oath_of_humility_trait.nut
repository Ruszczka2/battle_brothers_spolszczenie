this.oath_of_humility_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.oath_of_humility";
		this.m.Name = "Przysięga Pokory";
		this.m.Icon = "ui/traits/trait_icon_81.png";
		this.m.Description = "Ta postać złożyła Przysięgę Pokory i jest zobowiązana do samorefleksji i samodoskonalenia.";
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
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] do zdobywanego doświadczenia"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.XPGainMult *= 1.1;
	}

});

