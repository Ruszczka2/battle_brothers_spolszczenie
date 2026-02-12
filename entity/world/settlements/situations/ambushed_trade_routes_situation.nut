this.ambushed_trade_routes_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.ambushed_trade_routes";
		this.m.Name = "Napadnięte Szlaki Handlowe";
		this.m.Description = "Drogi prowadzące do tej osady ostatnimi czasy nie są bezpieczne, a wiele karawan zostało napadniętych i splądrowanych. Przez brak możliwości prowadzenia skutecznego handlu, wybór towarów jest niewielki, a ceny wysokie.";
		this.m.Icon = "ui/settlement_status/settlement_effect_12.png";
		this.m.Rumors = [
			"Zbójcy i bandyci są dla nas, wędrownych kupców, istną plagą! Mój stary przyjaciel został napadnięty, ograbiony i pobity tuż za bramami %settlement%!",
			"Jeśli masz ze sobą jakieś kosztowności, trzymaj się z dala od %settlement%. To miejsce jest nękane przez rzezimieszków, bandytów i zbójów!",
			"Strażnicy robią, co mogą, ale ci zbójcy po prostu przenoszą się do kolejnego miasta i napadają kupców na szlakach. Ponoć teraz czają się w pobliżu %settlement%!"
		];
	}

	function getAddedString( _s )
	{
		return "Szlaki handlowe do " + _s + " są pełne bandytów";
	}

	function getRemovedString( _s )
	{
		return "Szlaki handlowe do " + _s + " już nie są napadane";
	}

	function onAdded( _settlement )
	{
		_settlement.removeSituationByID("situation.safe_roads");
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.BuyPriceMult *= 1.2;
		_modifiers.SellPriceMult *= 1.1;
		_modifiers.RarityMult *= 0.75;
	}

});

