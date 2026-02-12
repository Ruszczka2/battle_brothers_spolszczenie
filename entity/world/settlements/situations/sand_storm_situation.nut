this.sand_storm_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.sand_storm";
		this.m.Name = "Burza Piaskowa";
		this.m.Description = "Wyjące burze piaskowe nawiedziły okolicę i uniemożliwiają kupcom bezpieczne dotarcie do miasta, a także jego opuszczenie. Towary stają się rzadkością, a ceny rosną.";
		this.m.Icon = "ui/settlement_status/settlement_effect_38.png";
		this.m.Rumors = [
			"Właśnie wróciłem z %settlement%, ledwie mi się udało! Burze piaskowe ogarnęły całe miasto!",
			"Znowu to samo, %settlement% zostało ogarnięte przez straszliwe burze piaskowe."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 3;
	}

	function getAddedString( _s )
	{
		return _s + " nawiedziła burza piaskowa";
	}

	function getRemovedString( _s )
	{
		return "W " + _s + " skończyła się burza piaskowa";
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.BuyPriceMult *= 1.2;
		_modifiers.SellPriceMult *= 1.1;
		_modifiers.RarityMult *= 0.75;
	}

});

