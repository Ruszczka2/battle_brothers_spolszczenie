this.bloodthirsty_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.bloodthirsty";
		this.m.Name = "Krwiożerczy";
		this.m.Icon = "ui/traits/trait_icon_42.png";
		this.m.Description = "Ta postać jest skłonna do nadmiernej przemocy i okrucieństwa wobec swych wrogów. Nie wystarczy, że przeciwnik poległ, jego głowa ma sterczeć na palu!";
		this.m.Titles = [
			"Rzeźnik",
			"Oszalały",
			"Okrutny"
		];
		this.m.Excluded = [
			"trait.weasel",
			"trait.fainthearted",
			"trait.hesistant",
			"trait.craven",
			"trait.insecure",
			"trait.paranoid",
			"trait.fear_beasts",
			"trait.fear_undead",
			"trait.fear_greenskins",
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
				text = "Wszystkie zabójstwa są śmiertelne i wyjątkowo brutalne (o ile broń na to pozwala)"
			}
		];
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		_properties.FatalityChanceMult = 1000.0;
	}

});

