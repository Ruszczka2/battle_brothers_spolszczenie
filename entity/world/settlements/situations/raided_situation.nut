this.raided_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.raided";
		this.m.Name = "Splądrowana";
		this.m.Description = "Ta osada została niedawno napadnięta! Niektóre budynki ucierpiały, zrabowano cenne towary i zapasy, a część ludzi straciła życie.";
		this.m.Icon = "ui/settlement_status/settlement_effect_08.png";
		this.m.Rumors = [
			"Jesteś jednym z tych najeźdźców? Bo wyglądasz i cuchniesz jak jeden z nich! To twoi ludzie splądrowali %settlement%? Wynoś się, nie chcemy tu takich, jak ty!",
			"Docierają tu ludzie z %settlement%, mówiąc, że osada została napadnięta i doszczętnie splądrowana. Żal mi tych biedaków, ale cóż możemy począć? Sami niewiele mamy. To ich lord powinien ich chronić!",
			"Żyjemy w niebezpiecznych czasach, najemniku. Właśnie doszły mnie wieści, że osada %settlement% została najechana i splądrowana nie dalej, jak dwie noce temu."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 4;
	}

	function getAddedString( _s )
	{
		return _s + " zostało splądrowane";
	}

	function getRemovedString( _s )
	{
		return _s + " odbudowało się po splądrowaniu";
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.RecruitsMult *= 0.5;
		_modifiers.RarityMult *= 0.5;
	}

});

