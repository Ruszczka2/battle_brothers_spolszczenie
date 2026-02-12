this.cultist_procession_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.cultist_procession";
		this.m.Name = "Procesja Kultystów";
		this.m.Description = "Przez miasto przemierza pochód kultystów; ciągły strumień ludzi pojawiających się znikąd nieprzerwanie ciągnie się wzdłuż głównych uliczek. Ubrani w szaty o stonowanych kolorach, dzwonią dzwonkami i intonują monotonnie imię Davkula.";
		this.m.Icon = "ui/settlement_status/settlement_effect_37.png";
		this.m.Rumors = [
			"Właśnie widziałem w %settlement% najbardziej wstrząsającą procesję! Zamaskowane postacie chłoszczące się po plecach, aż całe pokryją się krwią...",
			"%settlement% roi się od tych dziwnych kultystów, zapewne coś się święci! Moim zdaniem ktoś powinien wysłać za nimi łowców czarownic!",
			"Przyszedł czas przebudzenia! Śpiąca bestia niebawem wstanie ze swej wiekowej drzemki! Udaj się do %settlement%, a moi bracia w wierze powiedzą ci to samo! Davkul nadejdzie!"
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 2;
	}

	function getAddedString( _s )
	{
		return "W " + _s + " odbywa się procesja kultystów";
	}

	function getRemovedString( _s )
	{
		return "W " + _s + " zakończyła się procesja kultystów";
	}

	function onAdded( _settlement )
	{
		_settlement.resetRoster(true);
	}

	function onRemoved( _settlement )
	{
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
	}

});

