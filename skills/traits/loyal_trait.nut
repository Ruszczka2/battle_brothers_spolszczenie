this.loyal_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.loyal";
		this.m.Name = "Lojalny";
		this.m.Icon = "ui/traits/trait_icon_39.png";
		this.m.Description = "Jestem z tobą! Ta postać jest lojalna do samego końca i istnieje znacznie mniejsze prawdopodobieństwo, że opuści kompanię, gdy skończą się korony lub zapasy żywności.";
		this.m.Titles = [
			"Lojalny",
			"Poplecznik",
			"Pies"
		];
		this.m.Excluded = [
			"trait.disloyal",
			"trait.craven",
			"trait.fainthearted",
			"trait.dastard"
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
			}
		];
	}

});

