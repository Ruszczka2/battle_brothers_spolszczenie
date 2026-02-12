this.mine_cavein_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.mine_cavein";
		this.m.Name = "Tąpnięcie w Kopalni";
		this.m.Description = "Wydarzył się tragiczny wypadek i nastąpiło tąpnięcie w jednej z kopalń. Produkcja została wstrzymana do czasu naprawienia szkód, a górnicy zostali bez środków na wyżywienie swych rodzin.";
		this.m.Icon = "ui/settlement_status/settlement_effect_24.png";
		this.m.Rumors = [
			"Nigdy bym nie poszedł pracować pod ziemią, nie jestem śmierdzącym kretem! To pieprzona śmiertelna pułapka! Niedawno kopalnia zapadła się w %settlement%, nawet nie chcę wiedzieć ilu ludzi tego dnia zginęło...",
			"Dostawa rudy i minerałów z kopalni w %settlement% miała przyjść dzisiaj, ale jeszcze nie dotarła. Coś musiało się tam stać.",
			"Słyszałem, że doszło do tąpnięcia w jednej z kopalń w %settlement%. Wyobraź sobie bycie żywcem pogrzebanym głęboko pod skałami i ziemią..."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 5;
	}

	function getAddedString( _s )
	{
		return "W " + _s + " doszło do tąpnięcia w kopalni";
	}

	function getRemovedString( _s )
	{
		return _s + " już nie cierpi z powodu tąpnięcia w kopalni";
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.RecruitsMult *= 1.25;
	}

	function onUpdateShop( _stash )
	{
		do
		{
		}
		while (_stash.removeByID("misc.uncut_gems") != null);

		do
		{
		}
		while (_stash.removeByID("misc.copper_ingots") != null);
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
	}

});

