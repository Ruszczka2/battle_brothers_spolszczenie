this.survivor_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.survivor";
		this.m.Name = "Ocalały";
		this.m.Icon = "ui/traits/trait_icon_43.png";
		this.m.Description = "Dlaczego nie pozostaniesz martwy? Ta postać wie jak unikać śmierci i przeżyje większość swych rówieśników.";
		this.m.Titles = [
			"Ocalały",
			"Szczęściarz",
			"Błogosławiony"
		];
		this.m.Excluded = [
			"trait.bleeder",
			"trait.pessimist",
			"trait.deathwish",
			"trait.ailing"
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
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Ma [color=" + this.Const.UI.Color.PositiveValue + "]90%[/color] szansy na przeżycie, jeśli polegnie w bitwie, a ostatni cios nie był śmiercionośny"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.SurviveWithInjuryChanceMult *= 2.72;
	}

});

