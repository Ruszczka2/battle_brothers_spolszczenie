this.warehouse_burned_down_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.warehouse_burned_down";
		this.m.Name = "Spalony Magazyn";
		this.m.Description = "Niedawny pożar w magazynie poczynił znaczne szkody. To, co ocalało przed ogniem, jest teraz sprzedawane po zawyżonych cenach.";
		this.m.Icon = "ui/settlement_status/settlement_effect_21.png";
		this.m.Rumors = [
			"Widziałeś dym na horyzoncie ostatniej nocy? Mówią, że to ten wielki magazyn w %settlement% doszczętnie spłonął.",
			"Słyszałem, że złapali podpalacza, który podłożył ogień w magazynie w %settlement%. Migiem powiesili go na drzewie, jednak z odbudowaniem magazynu nie pójdzie im tak szybko."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 5;
	}

	function getAddedString( _s )
	{
		return "W " + _s + " spłonął magazyn";
	}

	function getRemovedString( _s )
	{
		return _s + " już nie cierpi z powodu spalonego magazynu";
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.BuyPriceMult *= 1.25;
		_modifiers.SellPriceMult *= 1.05;
		_modifiers.RarityMult *= 0.5;
	}

});

