this.bread_and_games_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.bread_and_games";
		this.m.Name = "Chleb i Igrzyska";
		this.m.Description = "Rada miasta rozkazała, że czas na jedzenie, picie i zabawy, aby utrzymać zadowolenie ludu. Jadło i napitki są łatwo dostępne, do miasta ściągają gladiatorzy, a na walkach na arenie można zarobić więcej, niż zwykle.";
		this.m.Icon = "ui/settlement_status/settlement_effect_39.png";
		this.m.Rumors = [
			"Chwała mądrej radzie %settlement%! Nadszedł czas jedzenia, picia i igrzysk!",
			"Byłeś kiedyś na tych sławnych igrzyskach na południu? Udaj się do %settlement% i na własne oczy zobacz glorię tamtejszych uroczystości!",
			"Cały rok harówki i na po co to wszystko? Powiem ci: dla jedzenia, picia i igrzysk! Wyruszę do %settlement%, by dołączyć do zabawy. Ty też powinieneś to zrobić."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 3;
	}

	function getAddedString( _s )
	{
		return "W " + _s + " nastał czas chleba i igrzysk";
	}

	function getRemovedString( _s )
	{
		return "W " + _s + " skończył się czas chleba i igrzysk";
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.FoodRarityMult *= 1.5;
		_modifiers.FoodPriceMult *= 0.9;
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
	}

});

