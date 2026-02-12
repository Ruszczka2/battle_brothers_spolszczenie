this.sure_footing_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.sure_footing";
		this.m.Name = "Pewna Podstawa";
		this.m.Icon = "ui/traits/trait_icon_05.png";
		this.m.Description = "Ta postać pewnie stoi na nogach i ciężko wybić ją z równowagi oraz zadać celny cios.";
		this.m.Excluded = [
			"trait.clumsy",
			"trait.insecure"
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
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] do Obrony w zwarciu"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.MeleeDefense += 5;
	}

});

