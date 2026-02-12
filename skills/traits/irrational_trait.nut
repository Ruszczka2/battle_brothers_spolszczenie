this.irrational_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.irrational";
		this.m.Name = "Irracjonalny";
		this.m.Icon = "ui/traits/trait_icon_28.png";
		this.m.Description = "Szklanka jest teraz w połowie pusta, lecz dosłownie przed chwilą była w połowie pełna.";
		this.m.Excluded = [
			"trait.pessimist",
			"trait.optimist",
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
				icon = "ui/icons/bravery.png",
				text = "Otrzymuje losowo [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] lub [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] do Stanowczości przy każdej próbie morale"
			}
		];
	}

});

