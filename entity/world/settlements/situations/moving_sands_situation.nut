this.moving_sands_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.moving_sands";
		this.m.Name = "Ruchome Piaski";
		this.m.Description = "Tereny wokół miasta są nawiedzane przez chmary węży, niektóre bardzo liczne. Ucierpiał handel, a towary stały się rzadsze i bardziej kosztowne.";
		this.m.Icon = "ui/settlement_status/settlement_effect_42.png";
		this.m.Rumors = [
			"Mówi się, że kupcy w drodze do %settlement% są połykani w całości przez ruchome piaski. Ale kto wierzy w takie brednie?",
			"Boisz się węży? Wiele z nich widziano ostatnio w okolicach %settlement%, niektóre długości mojej ręki, inne długości całego wozu kupieckiego!"
		];
	}

	function getAddedString( _s )
	{
		return "W " + _s + " zauważono ruchome piaski";
	}

	function getRemovedString( _s )
	{
		return "W " + _s + " już nie ma ruchomych piasków";
	}

	function onAdded( _settlement )
	{
		_settlement.removeSituationByID("situation.safe_roads");
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.SellPriceMult *= 1.1;
		_modifiers.RarityMult *= 0.85;
	}

});

