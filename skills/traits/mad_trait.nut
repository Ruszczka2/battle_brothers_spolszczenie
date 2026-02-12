this.mad_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.mad";
		this.m.Name = "Szalony";
		this.m.Icon = "ui/traits/trait_icon_76.png";
		this.m.Description = "Ta postać zajrzała w otchłań, a otchłań nie czekając długo spojrzała na nią, co zaowocowało postradaniem zmysłów. Często mamrocze coś niezrozumiale, a jej zagadkowy umysł stał się niedostępny tak dla rówieśników, jak i wrogów.";
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
				text = "Ma losowo [color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] lub [color=" + this.Const.UI.Color.NegativeValue + "]-15[/color] do Stanowczości podczas każdego testu morale"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "Niewrażliwość na strach i zdolności kontroli umysłu"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] *= 1000.0;
	}

});

