this.safe_roads_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.safe_roads";
		this.m.Name = "Bezpieczne Trakty";
		this.m.Description = "Trakty i gościńce prowadzące do osady są ostatnio w miarę bezpieczne, co pozwala na korzystny handel i rozwój osady.";
		this.m.Icon = "ui/settlement_status/settlement_effect_06.png";
		this.m.Rumors = [
			"Wygląda na to, że bandyci z okolic %settlement% mają się z pyszna przy tych wszystkich patrolach, które strzegą gościńców.",
			"Dopiero co wróciłem z %settlement% zeszłej nocy. Żadnego zbója na szlakach, dzięki bogom.",
			"Od lat mówię kuzynowi, by przestał rabować ludzi na gościńcach. To się mogło tylko źle skończyć. I rację miałem, bo tak właśnie się skończyło. Dostał za swoje pod %settlement%. Tam aż roi się od milicji."
		];
		this.m.IsStacking = false;
	}

	function getAddedString( _s )
	{
		return _s + " ma teraz bezpieczne trakty";
	}

	function getRemovedString( _s )
	{
		return _s + " już nie ma bezpiecznych traktów";
	}

	function onAdded( _settlement )
	{
		_settlement.removeSituationByID("situation.ambushed_trade_routes");
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.PriceMult *= 1.1;
		_modifiers.RarityMult *= 1.1;
	}

});

