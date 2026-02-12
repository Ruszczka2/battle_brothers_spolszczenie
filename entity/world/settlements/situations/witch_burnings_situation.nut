this.witch_burnings_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.witch_burnings";
		this.m.Name = "Palenie Czarownic";
		this.m.Description = "Jako iście płomienny spektakl, palenie czarownic przyciąga gapiów, zaś gapie przyciągają kramy z jedzeniem. A do tego w mieście roi się od łowców czarownic...";
		this.m.Icon = "ui/settlement_status/settlement_effect_32.png";
		this.m.Rumors = [
			"Zjawili się tu wczoraj łowcy czarownic. Nie znaleźli tego, czego szukali i ruszyli do %settlement%.",
			"Z tego co słyszałem, to znaleziono wiedźmę w %settlement% i pójdą z nią na stos. Tak sobie myślę, może powinienem donieść na tę starą zołzę, która wykiwała mnie ostatnio na targu. Bez wątpienia jest wiedźmą!"
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 3;
	}

	function getAddedString( _s )
	{
		return "W " + _s + " ma miejsce palenie czarownic";
	}

	function getRemovedString( _s )
	{
		return "W " + _s + " zakończyło się palenie czarownic";
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster(true);
	}

	function onRemoved( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.FoodRarityMult *= 1.35;
		_modifiers.FoodPriceMult *= 1.15;
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
	}

});

