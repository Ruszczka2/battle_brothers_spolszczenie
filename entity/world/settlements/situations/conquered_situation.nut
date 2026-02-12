this.conquered_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.conquered";
		this.m.Name = "Podbita";
		this.m.Description = "Ta osada zostało niedawna podbita. Wielu poległo, a ocalali musieli pogodzić się z tym, że zdobywcy zgarnęli swe łupy wojenne. Znaczna część osady nadal jest uszkodzona, a nastroje są ponure.";
		this.m.Icon = "ui/settlement_status/settlement_effect_02.png";
		this.m.Rumors = [
			"%settlement% zostało ostatnio przejęte, a przynajmniej tak słyszałem. Ja zawsze mawiam, \'Nowi lordowie - to samo gówno\'...",
			"Podbijanie nowych ziem to rozrywka szlachty. Słyszałem, że właśnie zdobyto %settlement%.",
			"Och, witaj najemniku! Byłeś przy oblężeniu %settlement%? Cóż, moje, kurwa, gratulacje. Ilu własnoręcznie ubiłeś? Ileś dziewek zgwałcił? "
		];
		this.m.IsStacking = false;
	}

	function getAddedString( _s )
	{
		return _s + " zostało podbite";
	}

	function getRemovedString( _s )
	{
		return _s + " już nie cierpi z powodu podbicia";
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.SellPriceMult *= 0.9;
		_modifiers.BuyPriceMult *= 1.1;
		_modifiers.RarityMult *= 0.6;
		_modifiers.FoodRarityMult *= 0.9;
	}

});

