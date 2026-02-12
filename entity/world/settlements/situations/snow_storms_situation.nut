this.snow_storms_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.snow_storms";
		this.m.Name = "Burze Śnieżne";
		this.m.Description = "Burze śnieżne bardziej lub mniej odizolowały tę osadę od handlu. Ponieważ niewiele nowych towarów tu dociera, wybór jest mniejszy, a ceny wyższe.";
		this.m.Icon = "ui/settlement_status/settlement_effect_20.png";
		this.m.Rumors = [
			"Kiepska pogoda nawiedziła okolice %settlement%, panują tam ponoć okropne zamiecie."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 3;
	}

	function getAddedString( _s )
	{
		return _s + " nawiedziły burze śnieżne";
	}

	function getRemovedString( _s )
	{
		return "W " + _s + " już nie ma burzy śnieżnych";
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

