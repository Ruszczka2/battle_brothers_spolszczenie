this.player_character_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.player";
		this.m.Name = "Postać Gracza";
		this.m.Icon = "ui/traits/trait_icon_63.png";
		this.m.Description = "To jest twoja postać, innymi słowy, ty sam. Jeżeli zginie, twoja przygoda się kończy. Nie możesz jej zwolnić i nigdy nie zdezerteruje.";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
		this.m.Type = this.m.Type;
		this.m.Titles = [];
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
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] do Stanowczości"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += 10;
	}

});

