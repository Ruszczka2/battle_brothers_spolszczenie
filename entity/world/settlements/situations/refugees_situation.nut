this.refugees_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.refugees";
		this.m.Name = "Uchodźcy";
		this.m.Description = "Przez toczącą się wojnę do osady nieustannie napływają nowi uchodźcy. Obciąża to miejscową ekonomię, ale oznacza też tanich ochotników dla każdego, kto zechce zaoferować im pracę.";
		this.m.Icon = "ui/settlement_status/settlement_effect_01.png";
		this.m.Rumors = [
			"Z samego ranka wyruszam do %settlement%. Krążą wieści, że duża grupa uchodźców właśnie tam dotarła, a ja potrzebuję pomocników na moim gospodarstwie.",
			"Z tego co słyszałem, %settlement% zostało obecnie zalane przez uchodźców. A ja twierdzę, że Ci tchórze powinni byli zostać i walczyć o własny dom!",
			"Żebracy, uciemiężeni, zbiegowie... wszyscy oni dokądś muszą się udać. Duża ich grupa właśnie dotarła do %settlement%, z tego co słyszałem."
		];
	}

	function getAddedString( _s )
	{
		return _s + " ma problem z uchodźcami";
	}

	function getRemovedString( _s )
	{
		return _s + " już nie ma problemu z uchodźcami";
	}

	function onAdded( _settlement )
	{
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.RarityMult *= 0.9;
		_modifiers.FoodRarityMult *= 0.75;
		_modifiers.FoodPriceMult *= 1.25;
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
		_draftList.push("refugee_background");
	}

});

