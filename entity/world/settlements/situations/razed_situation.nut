this.razed_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.razed";
		this.m.Name = "Spalona";
		this.m.Description = "Ta osada została spalona. Wielu z jej mieszkańców leży martwych w kałużach krwi, a wszelkie kosztowności zostały zrabowane.";
		this.m.Icon = "ui/settlement_status/settlement_effect_10.png";
		this.m.Rumors = [
			"Słupy dymu widać z wielu mil. W miejscu, gdzie dawniej była osada %settlement%, została kupa płonących gruzów.",
			"Fale uchodźców nadciągają z %settlement%. Ci nieszczęśnicy twierdzą, że większość osady została doszczętnie spalona! Czy to możliwe?",
			"%settlement% przestało istnieć, został jeno tlący się, zwęglony szkielet... Jak do tego doszło?"
		];
		this.m.IsStacking = false;
	}

	function getAddedString( _s )
	{
		return _s + " zostało spalone";
	}

	function getRemovedString( _s )
	{
		return _s + " odbudowało się po spaleniu";
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster(false);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.SellPriceMult *= 0.5;
		_modifiers.BuyPriceMult *= 2.0;
		_modifiers.FoodPriceMult *= 2.0;
		_modifiers.RecruitsMult *= 0.25;
		_modifiers.RarityMult *= 0.25;
	}

});

