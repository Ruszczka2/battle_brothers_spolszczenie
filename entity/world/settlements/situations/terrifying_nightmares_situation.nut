this.terrifying_nightmares_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.terrifying_nightmares";
		this.m.Name = "Przerażające Koszmary";
		this.m.Description = "Ludność tej osady jest dręczona przez koszmary. Wielu woli przez całą noc nie spać, tak na wszelki wypadek.";
		this.m.Icon = "ui/settlement_status/settlement_effect_25.png";
		this.m.Rumors = [
			"Ostatnio podróżowałem przez %settlement%. Coś tam z nimi jest nie w porządku. Blade twarze, podkrążone oczy i chwiejny krok. Zupełnie jakby od tygodnia nie spali!",
			"Właśnie dostałem list od mojej ciotki z %settlement%, która twierdzi, że całe miasto jest dręczone przez okropne koszmary. Sam nie wiem, ona zawsze mocno dramatyzuje.",
			"Najlepszy przepis na porządny sen to ciężka praca i pinta piwa! A skoro o tym mowa, to ktoś powinien powiedzieć to ludziom w %settlement%; z tego co słyszałem, to całe miasto ma problemy ze snem."
		];
	}

	function getAddedString( _s )
	{
		return "Ludność w " + _s + " ma przerażające koszmary";
	}

	function getRemovedString( _s )
	{
		return "Ludność w " + _s + " już nie ma przerażających koszmarów";
	}

	function onUpdate( _modifiers )
	{
		_modifiers.RecruitsMult *= 0.75;
	}

});

