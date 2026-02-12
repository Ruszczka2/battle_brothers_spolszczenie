this.seasonal_fair_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.seasonal_fair";
		this.m.Name = "Jarmark";
		this.m.Description = "Kupcy z różnych okolic przybywają tu na jarmark. Ludzie ściągają z okolicznych wiosek i jest to świetny czas, aby sprzedać swoje własne towary lub przegrzebać się przez liczne dostępne oferty.";
		this.m.Icon = "ui/settlement_status/settlement_effect_28.png";
		this.m.Rumors = [
			"Pytasz co się w okolicy dzieje? Cóż, w %settlement% odbywa się jarmark. Kupcy z wszystkich stron ściągają tam, by sprzedać swoje towary.",
			"Sam jestem raczej samotnikiem. Takie wielkie jarmarki, jak ten w %settlement%, jakoś do mnie nie przemawiają...."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 3;
	}

	function getAddedString( _s )
	{
		return "W " + _s + " odbywa się jarmark";
	}

	function getRemovedString( _s )
	{
		return "W " + _s + " zakończył się jarmark";
	}

	function onAdded( _settlement )
	{
		_settlement.removeSituationByID("situation.ambushed_trade_routes");
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.PriceMult *= 1.25;
		_modifiers.RarityMult *= 1.25;
		_modifiers.FoodRarityMult *= 1.25;
		_modifiers.MedicalRarityMult *= 1.25;
		_modifiers.RecruitsMult *= 1.25;
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
	}

});

