this.mustering_troops_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.mustering_troops";
		this.m.Name = "Zbieranie Wojsk";
		this.m.Description = "Padł rozkaz, by zebrać jednostki na służbę w tej osadzie. Sprzętu i rekrutów jest więc niewielu, choć można zarobić nieco koron na sprzedaży broni i pancerzy.";
		this.m.Icon = "ui/settlement_status/settlement_effect_35.png";
		this.m.Rumors = [
			"Kolejny przeklęty szlachcic wciela młodzieńców do pułku w %settlement%. Ach, czemu ja ci o tym w ogóle mówię, najemniku? Jesteś nie lepszy!",
			"Gdybym był kupcem z wozem pełnym broni i pancerzy, wiedziałbym, gdzie to wszystko sprzedać - zbierają wojska pod %settlement% i z pewnością dobrze zapłacą. Niestety ani nie jestem kupcem, ani też nie mam broni.",
			"Jestem tu tylko przejazdem. Ledwo zwiałem przed poborem w %settlement%. Chcieli mnie zmusić, bym walczył dla jakiegoś lorda, ale nie, dzięki, poszukam swego szczęścia gdzieś dalej na południu."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 4;
	}

	function getAddedString( _s )
	{
		return "W " + _s + " zbierają się wojska";
	}

	function getRemovedString( _s )
	{
		return "W " + _s + " zakończono zbieranie wojsk";
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster(false);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.PriceMult *= 1.25;
		_modifiers.RecruitsMult *= 0.5;
		_modifiers.RarityMult *= 0.5;
	}

});

