this.ceremonial_season_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.ceremonial_seasonn";
		this.m.Name = "Okres Obrządków";
		this.m.Description = "W okresie obrządków świątynie wykorzystują znaczne ilości kadzidła. Popyt i ceny na kadzidło są niewiarygodnie wysokie.";
		this.m.Icon = "ui/settlement_status/settlement_effect_44.png";
		this.m.Rumors = [
			"O tej porze roku świątynie w %settlement% dymią jak płonąca chałupa! Ciekawe skąd biorą tyle kadzidła...",
			"Jeśli jesteś bogobojny, to możesz zechcieć udać się do %settlement%, aby spalić nieco kadzidła i zmówić kilka modlitw."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 3;
	}

	function getAddedString( _s )
	{
		return "W " + _s + " rozpoczął się okres obrządków";
	}

	function getRemovedString( _s )
	{
		return "W " + _s + " zakończył się okres obrządków";
	}

	function onAdded( _settlement )
	{
	}

	function onUpdate( _modifiers )
	{
		_modifiers.IncensePriceMult *= 1.5;
	}

});

