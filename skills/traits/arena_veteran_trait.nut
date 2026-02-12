this.arena_veteran_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.arena_veteran";
		this.m.Name = "Weteran Areny";
		this.m.Icon = "ui/traits/trait_icon_75.png";
		this.m.Description = "Jako weteran areny z wieloma bliznami, ta postać wie jak sprawić, aby widownia wiwatowała podczas krwawego spektaklu. Im mniejsze szanse na zwycięstwo, tym lepsza zabawa!";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
	}

	function getTooltip()
	{
		local matches = this.getContainer().getActor().getFlags().getAsInt("ArenaFights");
		local won = this.getContainer().getActor().getFlags().getAsInt("ArenaFightsWon");

		if (won == matches)
		{
			won = "wszystkie";
		}

		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription() + " Jak na razie, ta postać wzięła udział w " + matches + " rozgrywkach i wygrała " + won + " z nich."
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] do Stanowczości"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Ma [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] szansy na przeżycie, jeśli polegnie w bitwie, a ostatni cios nie był śmiercionośny"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += 10;
		_properties.SurviveWithInjuryChanceMult *= 1.51;
	}

});

