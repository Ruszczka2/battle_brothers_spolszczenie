this.well_supplied_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.well_supplied";
		this.m.Name = "Dobrze Zaopatrzona";
		this.m.Description = "Ta osada została ostatnio zaopatrzona w świeże towary i wiele z nich można teraz kupić za odpowiednią cenę.";
		this.m.Icon = "ui/settlement_status/settlement_effect_03.png";
		this.m.Rumors = [
			"Handel z %settlement% kwitnie, przyjacielu! Bezpieczne szlaki, pełne zapasy, miejmy nadzieję, że tak pozostanie...",
			"Mój kuzyn w %settlement% ciągle się przechwala, jak im tam dobrze. Stragany pełne towarów i takie tam. Nie jak w tej zapadłej dziurze tutaj."
		];
		this.m.IsStacking = false;
	}

	function getAddedString( _s )
	{
		return _s + " jest teraz dobrze zaopatrzone";
	}

	function getRemovedString( _s )
	{
		return _s + " już nie jest dobrze zaopatrzone";
	}

	function onAdded( _settlement )
	{
		_settlement.removeSituationByID("situation.ambushed_trade_routes");
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.PriceMult *= 0.9;
		_modifiers.RarityMult *= 1.15;
	}

});

