this.oath_of_fortification_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.oath_of_fortification";
		this.m.Name = "Przysięga Obwarowania";
		this.m.Icon = "ui/traits/trait_icon_86.png";
		this.m.Description = "Ta postać złożyła Przysięgę Obwarowania i jest zobowiązana do ufania swej tarczy ponad wszystko inne.";
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
				text = "Umiejętności tarczy generują o [color=" + this.Const.UI.Color.NegativeValue + "]25%[/color] mniej Zmęczenia."
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Umiejętność \'Sciany Tarcz\' daje dodatkowe [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] do Obrony w zwarciu oraz [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] do Obrony dystansowej."
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Umiejętność \'Odepchnij\' ma dodatkowe [color=" + this.Const.UI.Color.PositiveValue + "]100%[/color] szansy, aby wytrącić trafiony cel z równowagi."
			},
			{
				id = 14,
				type = "hint",
				icon = "ui/icons/warning.png",
				text = "Skupia się na obronie i nie może się ruszyć podczas pierwszej rundy walki."
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.IsProficientWithShieldSkills = true;
	}

});

