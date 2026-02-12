this.terrified_villagers_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.terrified_villagers";
		this.m.Name = "Przerażeni Wieśniacy";
		this.m.Description = "Tutejsi wieśniacy są przerażeni i nękani przez jakieś nieznane poczwary. Na ulicach można znaleźć mniej potencjalnych ochotników, a ludność niechętnie zadaje się z nieznajomymi.";
		this.m.Icon = "ui/settlement_status/settlement_effect_09.png";
		this.m.Rumors = [
			"Umarli wcale nie są umarli, czasami powracają, aby prześladować żywych! Nie wierzysz mi? Udaj się do %settlement% i sam zobacz!",
			"Wyglądasz na wprawnego wojownika! Słyszałem plotki, że w pobliżu %settlement% umarli powstali z grobów. Zapewne to bujdy, ale przestraszeni ludzie często dobrze płacą, by znów móc poczuć się bezpiecznie."
		];
	}

	function onUpdate( _modifiers )
	{
		_modifiers.BuyPriceMult *= 1.25;
		_modifiers.SellPriceMult *= 0.75;
		_modifiers.RecruitsMult *= 0.5;
	}

	function getAddedString( _s )
	{
		return "Wieśniacy w " + _s + " są przerażeni";
	}

	function getRemovedString( _s )
	{
		return "Wieśniacy w " + _s + " już nie są przerażeni";
	}

});

