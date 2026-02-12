this.archery_contest_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.archery_contest";
		this.m.Name = "Turniej Łuczniczy";
		this.m.Description = "Turniej łucznictwa przyciągnął do osady każdego, kto jest biegły w posługiwaniu się łukiem. Być może to dobra okazja, by poszukać odpowiednich rekrutów.";
		this.m.Icon = "ui/settlement_status/settlement_effect_31.png";
		this.m.Rumors = [
			"Jeśli jesteś zdolnym łucznikiem, powinieneś wybrać się na wielki turniej do %settlement% i wypuścić trochę strzał!",
			"WIesz, sam niegdyś byłem jednym z najlepszych łuczników jak ziemia szeroka, przysięgam! Znaczy, do czasu, aż ten cholerny osioł nadepnął mi na dłoń. gdyby nie to, już w tej chwili byłbym w %settlement% na turnieju...",
			"Każdy uzdolniony w posługiwaniu się łukiem zmierza ostatnio do %settlement% na jakiś turniej. Zapewne większość z nich to kłusownicy i inne szumowiny."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 3;
	}

	function getAddedString( _s )
	{
		return "W " + _s + " odbywa się turniej łuczniczy";
	}

	function getRemovedString( _s )
	{
		return "W " + _s + " zakończył się turniej łuczniczy";
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

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("hunter_background");
		_draftList.push("hunter_background");
		_draftList.push("hunter_background");
		_draftList.push("hunter_background");
		_draftList.push("hunter_background");
		_draftList.push("hunter_background");
		_draftList.push("hunter_background");
		_draftList.push("hunter_background");
		_draftList.push("hunter_background");
		_draftList.push("hunter_background");
		_draftList.push("hunter_background");
		_draftList.push("poacher_background");
		_draftList.push("poacher_background");
		_draftList.push("poacher_background");
		_draftList.push("poacher_background");
		_draftList.push("poacher_background");
		_draftList.push("poacher_background");
		_draftList.push("poacher_background");
		_draftList.push("poacher_background");
		_draftList.push("poacher_background");
		_draftList.push("poacher_background");
		_draftList.push("poacher_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("sellsword_background");
		_draftList.push("sellsword_background");
		_draftList.push("sellsword_background");

		if (this.Const.DLC.Unhold)
		{
			_draftList.push("beast_hunter_background");
			_draftList.push("beast_hunter_background");
			_draftList.push("beast_hunter_background");
			_draftList.push("beast_hunter_background");
			_draftList.push("beast_hunter_background");
			_draftList.push("beast_hunter_background");
			_draftList.push("beast_hunter_background");
		}
	}

});

