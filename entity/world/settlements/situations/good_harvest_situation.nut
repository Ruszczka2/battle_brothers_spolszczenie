this.good_harvest_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.good_harvest";
		this.m.Name = "Udane Żniwa";
		this.m.Description = "Warunki dla upraw były idealne. Żywności jest teraz pełno i można ją kupić po niższych cenach.";
		this.m.Icon = "ui/settlement_status/settlement_effect_17.png";
		this.m.Rumors = [
			"Udaj się do %settlement%, jeśli potrzebujesz zrobić zapasy żywności. Ci cholerni szczęściarze mieli nad wyraz udane żniwa w tym roku.",
			"Przybyłem tu z %settlement%, by sprzedać naszą nadprodukcję. Bogowie się do nas uśmiechnęli i obdarowali nas najlepszymi żniwami od wielu lat!",
			"Właśnie się dowiedziałem, że w %settlement% spichlerze i spiżarnie są przepełnione, wszystko dzięki udanym żniwom. "
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 7;
	}

	function getAddedString( _s )
	{
		return _s + " miało udane żniwa";
	}

	function getRemovedString( _s )
	{
		return "W " + _s + " skończył się efekt udanych żniw";
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

