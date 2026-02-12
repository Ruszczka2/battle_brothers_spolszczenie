this.lost_at_sea_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.lost_at_sea";
		this.m.Name = "Zaginieni na Morzu";
		this.m.Description = "Łódź z rybakami zaginęła na morzu podczas sztormu. Zarówno świeża ryba, jak i chętni rekruci są obecnie rzadkim widokiem.";
		this.m.Icon = "ui/settlement_status/settlement_effect_18.png";
		this.m.Rumors = [
			"Nie powrócili z połowów... na samą myśl o tych zaginionych biedakach z %settlement% przechodzą mnie dreszcze.",
			"Przeklęte dziewki z %settlement%, tylko jęczą i jęczą. Byłem tam, coby sprzedać im trochę świń, ale one tylko jęczą, a żadnego chłopa nie widać. Jakaś łódź zaginęła na morzu, czy coś. Wróciłem z powrotem, żadnej świni żem nie sprzedał.",
			"Żeglarstwo zawsze było niebezpiecznym zawodem. Dlatego odwróciłem się od wody. I to w dobrym czasie, przyznam, bo to mogłem być ja na tej łajbie, która zaginęła przy %settlement%."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 4;
	}

	function getAddedString( _s )
	{
		return _s + " cierpi z powodu zaginionych na morzu";
	}

	function getRemovedString( _s )
	{
		return _s + " już nie cierpi z powodu zaginionych na morzu";
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.FoodRarityMult *= 0.5;
		_modifiers.FoodPriceMult *= 2.0;
		_modifiers.RecruitsMult *= 0.5;
	}

});

