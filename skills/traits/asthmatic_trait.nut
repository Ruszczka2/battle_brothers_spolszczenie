this.asthmatic_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.asthmatic";
		this.m.Name = "Astmatyk";
		this.m.Icon = "ui/traits/trait_icon_22.png";
		this.m.Description = "Tej postaci ciężko złapać oddech i jest podatna na ataki kaszlu, przez co dłużej dochodzi do siebie po wysiłku.";
		this.m.Titles = [];
		this.m.Excluded = [
			"trait.athletic",
			"trait.iron_lungs"
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
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-3[/color] odnowy Zmęczenia na turę"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.FatigueRecoveryRate += -3;
	}

});

