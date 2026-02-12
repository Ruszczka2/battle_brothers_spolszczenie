this.bleeder_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.bleeder";
		this.m.Name = "Hemofilik";
		this.m.Icon = "ui/traits/trait_icon_16.png";
		this.m.Description = "Ta postać jest podatna na krwawienie i krwawi dłużej, niż większość ludzi.";
		this.m.Excluded = [
			"trait.tough",
			"trait.iron_jaw",
			"trait.survivor"
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
				icon = "ui/icons/special.png",
				text = "Będzie otrzymywać obrażenia od krwawienia przez [color=" + this.Const.UI.Color.NegativeValue + "]1[/color] dodatkową turę"
			}
		];
	}

});

