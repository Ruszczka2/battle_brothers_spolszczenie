this.cultist_prophet_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.cultist_prophet";
		this.m.Name = "Prorok Davkula";
		this.m.Icon = "ui/traits/trait_icon_69.png";
		this.m.Description = "Ta postać jest prorokiem Davkula, ucieleśnieniem jego woli i ziemskim głosem, wypowiadającym jego prawdę. Inni czciciele słuchają każdego jej słowa i czują się zobowiązani, by przejść samych siebie i pokonać swe fizyczne słabości, aby wypełnić jej wolę.";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
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
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] do Obrony w zwarciu"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] do Obrony dystansowej"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/health.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] do Zdrowia"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+2[/color] odnowy Zmęczenia na turę"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] do Stanowczości"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/morale.png",
				text = "Brak testów na morale po śmierci sojusznika"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/morale.png",
				text = "Brak testów na morale po utraceniu punktów zdrowia"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Niewrażliwość na efekty świeżych kontuzji i ran na czas obecnej bitwy"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.MeleeDefense += 5;
		_properties.RangedDefense += 5;
		_properties.Hitpoints += 20;
		_properties.FatigueRecoveryRate += 2;
		_properties.Bravery += 10;
		_properties.IsAffectedByDyingAllies = false;
		_properties.IsAffectedByLosingHitpoints = false;
		_properties.IsAffectedByFreshInjuries = false;
	}

});

