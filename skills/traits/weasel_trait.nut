this.weasel_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.weasel";
		this.m.Name = "Łasica";
		this.m.Icon = "ui/traits/trait_icon_60.png";
		this.m.Description = "Ta postać zwinna niczym łasica. Niestety jest w stanie wykorzystywać tę zdolność tylko wtedy, gdy ucieka ratując własną skórę.";
		this.m.Titles = [
			"Tchórz",
			"Łasica",
			"Cykor",
			"Węgorz"
		];
		this.m.Excluded = [
			"trait.clubfooted",
			"trait.clumsy",
			"trait.determined",
			"trait.bloodthirsty",
			"trait.deathwish",
			"trait.brave",
			"trait.fearless",
			"trait.cocky",
			"trait.optimist",
			"trait.hate_greenskins",
			"trait.hate_undead",
			"trait.hate_beasts"
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+25[/color] do Obrony w zwarciu podczas ucieczki"
			}
		];
	}

	function onBeingAttacked( _attacker, _skill, _properties )
	{
		if (("State" in this.Tactical) && this.Tactical.State != null && this.Tactical.State.isScenarioMode())
		{
			return;
		}

		if (this.getContainer().getActor().isPlacedOnMap() && this.Tactical.State.isAutoRetreat() && this.Tactical.TurnSequenceBar.getActiveEntity() != null && this.Tactical.TurnSequenceBar.getActiveEntity().getID() == this.getContainer().getActor().getID())
		{
			_properties.MeleeDefense += 25;
		}
	}

});

