this.full_nets_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.full_nets";
		this.m.Name = "Pełne Sieci";
		this.m.Description = "Wody aż roją się od ławic ryb. Świeżej ryby jest pod dostatkiem, więc tanio można ją kupić.";
		this.m.Icon = "ui/settlement_status/settlement_effect_19.png";
		this.m.Rumors = [
			"O tej porze roku bardzo duże ławice ryb przepływają obok %settlement%. Wystarczy tylko, że tamtejsi rybacy rzucą jakąś sieć do wody, a wyciągną więcej ryb, niż kiedykolwiek byliby w stanie zjeść! Przeklęci farciarze!",
			"Jutro ruszam do %settlement% i zapełnię swe wozy rybami. Plotka głosi, że tamtejszym rybakom wspaniale się powodzi!",
			"Zajmujesz się handlem? Słyszałem, że w %settlement% rybacy wyławiają sieci przepełnione rybami."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 3;
	}

	function getAddedString( _s )
	{
		return "W " + _s + " mają sieci pełne ryb";
	}

	function getRemovedString( _s )
	{
		return "W " + _s + " już nie mają sieci pełnych ryb";
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

