this.waterwheel_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "Mały młyn wodny z kamiennym domem u boku. Wygląda tak, jakby ktoś tu mieszkał.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.waterwheel";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = true;
		this.m.IsShowingBanner = false;
		this.m.VisibilityMult = 0.9;
		this.m.Resources = 500;
		this.m.OnEnter = "event.location.waterwheel_enter";
	}

	function onSpawned()
	{
		this.m.Name = "Młyn Wodny";
		this.location.onSpawned();
		this.Const.World.Common.addTroop(this, {
			Type = this.Const.World.Spawn.Troops.ZombieBoss
		}, false);

		for( local i = 0; i < 2; i = i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.ZombieKnightBodyguard
			}, false);
			i = ++i;
		}

		for( local i = 0; i < 9; i = i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.ZombieBetrayer
			}, false);
			i = ++i;
		}
	}

	function onDiscovered()
	{
		this.location.onDiscovered();
		this.World.Flags.increment("LegendaryLocationsDiscovered", 1);

		if (this.World.Flags.get("LegendaryLocationsDiscovered") >= 10)
		{
			this.updateAchievement("FamedExplorer", 1, 1);
		}
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_water_mill");
	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);
	}


	function onDropLootForPlayer( _lootTable )

	{

		this.location.onDropLootForPlayer(_lootTable);

		local treasure = [

			"helmets/ghost_knight_helmet"

		];

		this.dropTreasure(1, treasure, _lootTable);

	}
});

