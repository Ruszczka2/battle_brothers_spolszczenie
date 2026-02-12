this.disappearing_villagers_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.disappearing_villagers";
		this.m.Name = "Znikający Wieśniacy";
		this.m.Description = "Wieśniacy zaczynają znikać z tego miasta, co mocno niepokoi wszystkich. Na ulicach znaleźć można mniej rekrutów, a mieszkańcy niechętnie robią interesy z nieznajomymi.";
		this.m.Icon = "ui/settlement_status/settlement_effect_11.png";
		this.m.Rumors = [
			"Właśnie odwołałem swoją wizytę w %settlement% po tym, jak usłyszałem, że ostatnio sporo ludzi tam zaginęło. Jak na razie trzymanie się z dala od kłopotów dobrze mi służy!",
			"Mój sąsiad, %randomname%, udał się do %settlement% jakiś tydzień temu. Od tamtej pory słuch o nim zaginął. Mam tylko nadzieję, że nic mu się nie stało, bo wiesz, sporo się mówi o grasujących bandytach i potworach...",
			"Siły zła są na tym świecie liczne. Kryją się w lasach, w górach, a także w cieniach i czasem ludzie po prostu znikają bez śladu. Coś takiego dzieje się właśnie w %settlement%."
		];
	}

	function getAddedString( _s )
	{
		return "W " + _s + " zaczęli znikać wieśniacy";
	}

	function getRemovedString( _s )
	{
		return "W " + _s + " już nie znikają wieśniacy";
	}

	function onUpdate( _modifiers )
	{
		_modifiers.BuyPriceMult *= 1.25;
		_modifiers.SellPriceMult *= 0.75;
		_modifiers.RecruitsMult *= 0.5;
	}

});

