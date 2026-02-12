this.collectors_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.collectors";
		this.m.Name = "Kolekcjonerzy";
		this.m.Description = "Do osady dotarło kilku kolekcjonerów, szukających egzotycznych niezwykłości. Można nieźle zarobić sprzedając trofea po bestiach i tym podobne kurioza.";
		this.m.Icon = "ui/settlement_status/settlement_effect_46.png";
		this.m.Rumors = [
			"Jesteście łowcami potworów? Podobno jakieś dziwne postacie nawiedziły %settlement% i skupują każde egzotyczne trofeum z potworów, jakie uda im się znaleźć.",
			"Widzisz ten psi kieł? Ruszam do %settlement% i tam go sprzedam. Słyszałem, że dobrze tam płacą za części zwierząt.",
			"Wygląda na to, że wszelkiego rodzaju zabójcy bestii i zbieracze trucheł pędzą do %settlement%. Ponoć chodzi o jakieś sprzedawanie trofeów z bestii. Jak dla mnie, to brzmi to jak czary."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 3;
	}

	function getAddedString( _s )
	{
		return "Do " + _s + " zawitali " + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return this.m.Name + " opuścili " + _s;
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.BeastPartsPriceMult *= 2.0;
		_modifiers.RecruitsMult *= 1.25;
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");

		if (this.Const.DLC.Unhold)
		{
			_draftList.push("beast_hunter_background");
			_draftList.push("beast_hunter_background");
			_draftList.push("beast_hunter_background");
			_draftList.push("beast_hunter_background");
			_draftList.push("beast_hunter_background");
		}

		if (this.Const.DLC.Paladins)
		{
			_draftList.push("anatomist_background");
			_draftList.push("anatomist_background");
			_draftList.push("anatomist_background");
			_draftList.push("anatomist_background");
			_draftList.push("anatomist_background");
		}
	}

});

