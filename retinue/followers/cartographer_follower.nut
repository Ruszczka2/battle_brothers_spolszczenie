this.cartographer_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.cartographer";
		this.m.Name = "Kartograf";
		this.m.Description = "Kartograf to człek kultury i wiedzy, choć zdaje sobie też sprawę, że podróżowanie z kompanią uzbrojonych po zęby najemników to jeden z najbezpieczniejszych sposobów, aby zobaczyć świat i odkrywać miejsca, które dotąd nieliczni mieli szansę odwiedzić.";
		this.m.Image = "ui/campfire/cartographer_01";
		this.m.Cost = 2500;
		this.m.Effects = [
			"Płaci od 100 do 400 koron za każdą lokację, którą samodzielnie odkryjesz. Im dalej od cywilizacji, tym wyższa zapłata. Za legendarne lokacje zapłata jest podwójna."
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = "Odkryj legendarną lokację"
			}
		];
	}

	function onUpdate()
	{
	}

	function onEvaluate()
	{
		if (this.World.Flags.getAsInt("LegendaryLocationsDiscovered") >= 1)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

	function onLocationDiscovered( _location )
	{
		local settlements = this.World.EntityManager.getSettlements();
		local dist = 9999;

		foreach( s in settlements )
		{
			local d = s.getTile().getDistanceTo(_location.getTile());

			if (d < dist)
			{
				dist = d;
			}
		}

		local reward = this.Math.min(400, this.Math.max(100, 10 * dist));

		if (_location.isLocationType(this.Const.World.LocationType.Unique))
		{
			reward = reward * 2;
		}

		this.World.Assets.addMoney(reward);
	}

});

