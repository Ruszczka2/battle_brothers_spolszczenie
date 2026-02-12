this.abducted_children_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.abducted_children";
		this.m.Name = "Porwane Dzieci";
		this.m.Description = "Dzieci ostatnimi czasy znikają z tej osady. Na ulicach panuje nieufność i strach, które powoli zatruwają społeczność.";
		this.m.Icon = "ui/settlement_status/settlement_effect_34.png";
		this.m.Rumors = [
			"Plotka głosi, że dzieci w %settlement% znikają bez śladu ze swych łóżeczek. Wyobraź sobie przerażenie rodziców...",
			"Moja babka opowiedziała mi kiedyś historię o wiedźmach porywających dzieci dla ich niewinnej krwi. A teraz w %settlement% dzieciaki znikają dokładnie tak, jak w tych opowieściach .",
			"Nigdy, przenigdy nie dobijaj targu z wiedźmami! Mój krewny w %settlement% zrobił to lata temu, a teraz jego dzieciak zaginął."
		];
	}

	function getAddedString( _s )
	{
		return "W " + _s + " znikają dzieci";
	}

	function getRemovedString( _s )
	{
		return "W " + _s + " już nie znikają dzieci";
	}

	function onAdded( _settlement )
	{
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.BuyPriceMult *= 1.25;
		_modifiers.SellPriceMult *= 0.75;
		_modifiers.RecruitsMult *= 0.5;
	}

});

