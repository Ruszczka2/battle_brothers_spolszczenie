this.impatient_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.impatient";
		this.m.Name = "Niecierpliwy";
		this.m.Icon = "ui/traits/trait_icon_46.png";
		this.m.Description = "Ruszajmy już! Co się tak ociągacie? Ta postać chce, aby już się zaczęło.";
		this.m.Titles = [
			"Szybki",
			"Gorliwy",
			"Nerwowy"
		];
		this.m.Excluded = [
			"trait.hesitant",
			"trait.clubfooted",
			"trait.teamplayer"
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
				text = "Zawsze wykonuje ruch jako pierwszy w pierwszej rundzie bitwy"
			}
		];
	}

	function onUpdate( _properties )
	{
		if (this.getContainer().getActor().isPlacedOnMap() && this.Time.getRound() <= 1)
		{
			_properties.InitiativeForTurnOrderAdditional += 1000;
		}
	}

});

