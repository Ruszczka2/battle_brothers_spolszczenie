this.tiny_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.tiny";
		this.m.Name = "Mały";
		this.m.Icon = "ui/traits/trait_icon_02.png";
		this.m.Description = "Będąc bardzo niskiego wzrostu, ta postać już przyzwyczaiła się, że potrafi przemykać między wrogami.";
		this.m.Titles = [
			"Karzeł",
			"Paluszek",
			"Krótki"
		];
		this.m.Excluded = [
			"trait.huge",
			"trait.strong",
			"trait.tough",
			"trait.brute",
			"trait.iron_jaw"
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
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] do Obrony dystansowej"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] do obrażeń zadawanych w zwarciu"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.MeleeDamageMult *= 0.85;
		_properties.MeleeDefense += 5;
		_properties.RangedDefense += 5;
	}

});

