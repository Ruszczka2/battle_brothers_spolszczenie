this.sickness_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.sickness";
		this.m.Name = "Zaraza";
		this.m.Description = "Wielu ludzi z tej osady zachorowało. Dostępnych jest mniej ochotników, a żywności i medykamentów zaczyna brakować.";
		this.m.Icon = "ui/settlement_status/settlement_effect_23.png";
		this.m.Rumors = [
			"Nie zbliżaj się do %settlement%! Jakaś zaraza uderzyła w to biedne miasto i mieszkańcy padają tam jak muchy...",
			"Jacyś ludzie przybyli tu z %settlement%, lecz musieliśmy ich zawrócić spod bram. Wszyscy wiedzą, że jakaś okrutna zaraza rozprzestrzenia się w tamtym przeklętym mieście.",
			"Podoba ci się mój zielny naszyjnik? Chroni mnie przed nawet najbardziej zaraźliwymi chorobami. Sam też sobie taki lepiej spraw, jeśli zamierzasz ruszyć w kierunku %settlement%."
		];
		this.m.IsStacking = false;
	}

	function getAddedString( _s )
	{
		return "W " + _s + " panuje zaraza";
	}

	function getRemovedString( _s )
	{
		return "W " + _s + " już nie panuje zaraza";
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.FoodPriceMult *= 2.0;
		_modifiers.MedicalPriceMult *= 3.0;
		_modifiers.RecruitsMult *= 0.25;
	}

});

