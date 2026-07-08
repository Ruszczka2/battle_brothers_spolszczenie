this.disbanded_troops_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.disbanded_troops";
		this.m.Name = "Zwolnieni Żołdacy";
		this.m.Description = "Jako że zażegnano miejscowy konflikt, wielu poborowych oraz ich rynsztunek nie są już potrzebne. To dobry czas na tanie zakupy lub zwerbowanie nowych, doświadczonych ludzi.";
		this.m.Icon = "ui/settlement_status/settlement_effect_30.png";
		this.m.Rumors = [
			"Stacjonujące armie są kosztowne, przyjacielu. Słyszałem, ze cały pułk został rozwiązany w %settlement%. Z pewnością nadal kręci się tam paru doświadczonych żołnierzy, desperacko szukając zarobku.",
			"Gdy byłem młody to służyłem jako żołnierz. I przyznam, lubiłem to. Nawet maszerowanie. Jednak gdy moja jednostka została rozwiązana, nie wiedziałem co do cholery ze sobą począć. Teraz rozwiązują armię w %settlement%, z tego co słyszałem.",
			"Martwię się o moją siostrzenicę; cała jednostka żołnierzy została rozwiązana w %settlement%, a ona mieszka nieopodal. Kiepsko będzie, jeśli te bydlaki nie znajdą szybko jakiegoś innego zajęcia!"
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 4;
	}

	function getAddedString( _s )
	{
		return "W " + _s + " zwolniono żołdaków";
	}

	function getRemovedString( _s )
	{
		return "W " + _s + " już nie ma zwolnionych żołdaków";
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.PriceMult *= 0.9;
		_modifiers.RecruitsMult *= 1.25;
	}

	function onUpdateShopList( _id, _list )
	{
		if (_id == "building.marketplace")
		{
			_list.push({
				R = 55,
				P = 1.0,
				S = "helmets/greatsword_hat"
			});
			_list.push({
				R = 75,
				P = 1.0,
				S = "helmets/greatsword_faction_helm"
			});
		}
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("deserter_background");
		_draftList.push("deserter_background");
		_draftList.push("deserter_background");
		_draftList.push("deserter_background");
		_draftList.push("deserter_background");
		_draftList.push("deserter_background");
		_draftList.push("militia_background");
		_draftList.push("militia_background");
		_draftList.push("militia_background");
		_draftList.push("militia_background");
		_draftList.push("militia_background");
		_draftList.push("militia_background");
		_draftList.push("militia_background");
		_draftList.push("militia_background");
		_draftList.push("militia_background");
		_draftList.push("militia_background");
		_draftList.push("sellsword_background");
		_draftList.push("sellsword_background");
		_draftList.push("sellsword_background");
		_draftList.push("retired_soldier_background");
		_draftList.push("retired_soldier_background");
		_draftList.push("retired_soldier_background");
		_draftList.push("retired_soldier_background");
		_draftList.push("retired_soldier_background");
		_draftList.push("retired_soldier_background");
		_draftList.push("retired_soldier_background");
		_draftList.push("retired_soldier_background");
		_draftList.push("squire_background");
		_draftList.push("squire_background");
		_draftList.push("squire_background");
		_draftList.push("squire_background");
		_draftList.push("hedge_knight_background");
		_draftList.push("hedge_knight_background");
		_draftList.push("hedge_knight_background");
	}

});

