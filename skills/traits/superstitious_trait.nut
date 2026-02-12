this.superstitious_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.superstitious";
		this.m.Name = "Przesądny";
		this.m.Icon = "ui/traits/trait_icon_26.png";
		this.m.Description = "To jest przeklęte! Ta postać jest wielce przesądna i przez to bardziej podatna na zdolności, które bezpośrednio atakują jej Stanowczość.";
		this.m.Excluded = [
			"trait.fearless",
			"trait.brave"
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] od Stanowczości podczas testów morale na strach, panikę lub kontrolę umysłu"
			}
		];
	}

});

