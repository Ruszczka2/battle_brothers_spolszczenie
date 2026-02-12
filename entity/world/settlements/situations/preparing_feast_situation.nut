this.preparing_feast_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.preparing_feast";
		this.m.Name = "Przygotowania do Uczty";
		this.m.Description = "Szlachta szykuje się na ucztę. Piekarnie i kuchnie skupują żywność w ilościach hurtowych.";
		this.m.Icon = "ui/settlement_status/settlement_effect_29.png";
		this.m.Rumors = [
			"Ci och-jakże-szlachetni wysoko urodzeni przygotowują się do uczty w %settlement%, podczas gdy my, prosty lud, dławimy się starym ziarnem...",
			"Mój wuj jest sługą na dworze w %settlement% i powiedział, że przygotowują dużą ucztę. Nie ma jednak sensu się tam wybierać, jeśli nie jesteś zaproszony."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 3;
	}

	function getAddedString( _s )
	{
		return _s + " przygotowuje się do uczty";
	}

	function getRemovedString( _s )
	{
		return _s + " już nie przygotowuje się do uczty";
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.FoodRarityMult *= 0.25;
		_modifiers.FoodPriceMult *= 2.0;
	}

});

