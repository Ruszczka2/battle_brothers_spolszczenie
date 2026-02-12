this.hunting_season_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.hunting_season";
		this.m.Name = "Sezon Łowiecki";
		this.m.Description = "W lasach roi się od jeleni i rozpoczął się sezon łowiecki. Dziczyzna i futra są więc łatwo dostępne.";
		this.m.Icon = "ui/settlement_status/settlement_effect_36.png";
		this.m.Rumors = [
			"Lubisz dziczyznę, najemniku? A twoi ludzie? Ponoć w %settlement% rozpoczął się sezon łowiecki. Tak tylko mówię.",
			"To ta pora roku, na którą wszyscy myśliwi niecierpliwie czekają. Sezon łowiecki właśnie się rozpoczął w okolicach %settlement%!",
			"Polowanie poza sezonem łowieckim to dobry sposób, jeśli chcesz, aby odcięto ci oba łapska! Nieważne jednak, bo lada chwila sezon rozpocznie się w lasach pod %settlement%."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 5;
	}

	function getAddedString( _s )
	{
		return "W " + _s + " rozpoczął się sezon łowiecki";
	}

	function getRemovedString( _s )
	{
		return "W " + _s + " zakończył się sezon łowiecki";
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.FoodRarityMult *= 2.0;
		_modifiers.FoodPriceMult *= 0.5;
	}

});

