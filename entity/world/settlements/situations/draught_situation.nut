this.draught_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.draught";
		this.m.Name = "Susza";
		this.m.Description = "Przez niespodziewaną falę upałów uschło wiele miejscowych upraw. Na targu mniej jest żywności, a ceny są wyższe.";
		this.m.Icon = "ui/settlement_status/settlement_effect_16.png";
		this.m.Rumors = [
			"Straszliwa susza nawiedziła %settlement%, z tego co słyszałem. Tamtejsi ludzie zawsze mieli ciężko, ale tym razem ponoć sytuacja jest tragiczna.",
			"Jeśli jesteś równie zuchwały, na jakiego wyglądasz, to możesz szybko zarobić sprzedając jedzenie w %settlement%. Ludzie tam głodują z powodu strasznej suszy, więc zapłacą każdą kwotę, by mieć co do gęby włożyć.",
			"Och, synu, dawniej byłem zaklinaczem deszczu w %settlement%, ale ci głupcy mnie przegnali! Co prawda trzeba przyznać, że wioska cierpi z powodu suszy, ale czyż to nie jest dodatkowy powód, by na mnie polegać? Głupcy, mówię!"
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 7;
	}

	function getAddedString( _s )
	{
		return "W " + _s + " zapanowała susza";
	}

	function getRemovedString( _s )
	{
		return "W " + _s + " skończyła się susza";
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.FoodRarityMult *= 0.5;
		_modifiers.FoodPriceMult *= 2.0;
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
	}

});

