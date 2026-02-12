this.short_on_food_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.short_on_food";
		this.m.Name = "Niedobór Żywności";
		this.m.Description = "Przez ostatnie wydarzenia w osadzie zaczyna brakować pożywienia. Ludzie głodują, o żywność bardzo ciężko, a jej ceny stale rosną.";
		this.m.Icon = "ui/settlement_status/settlement_effect_04.png";
		this.m.Rumors = [
			"Podobno mężczyźni i kobiety w %settlement% głodują, a w osadzie brakuje żywności. Chyba już nie będę narzekał na moją spleśniałą zupę zbożową!",
			"Jakiś rolnik z %settlement% dotarł tu dziś rano. Opowiadał o zabitym bydle, spalonych polach i pustych spiżarniach. Sam wyglądał jak chodzący szkielet!"
		];
		this.m.IsStacking = false;
	}

	function getAddedString( _s )
	{
		return _s + " ma teraz niedobór żywności";
	}

	function getRemovedString( _s )
	{
		return _s + " nie ma już niedoboru żywności";
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.FoodRarityMult *= 0.5;
		_modifiers.FoodPriceMult *= 3.0;
	}

});

