this.huge_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.huge";
		this.m.Name = "Wielki";
		this.m.Icon = "ui/traits/trait_icon_61.png";
		this.m.Description = "Jako że ta postać jest szczególnie rosła i tęga, jej ciosy bywają wyjątkowo bolesne. Jest też jednak większym i łatwiejszym celem.";
		this.m.Titles = [
			"Góra",
			"Wół",
			"Niedźwiedź",
			"Olbrzym",
			"Wieża",
			"Byk"
		];
		this.m.Excluded = [
			"trait.tiny",
			"trait.quick",
			"trait.fragile"
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
				id = 12,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] do obrażeń zadawanych w zwarciu"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] do Obrony w zwarciu"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] do Obrony dystansowej"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.MeleeDamageMult *= 1.1;
		_properties.MeleeDefense -= 5;
		_properties.RangedDefense -= 5;
	}

});

