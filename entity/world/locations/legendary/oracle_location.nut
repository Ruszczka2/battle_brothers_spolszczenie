this.oracle_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "Pozostałości światyni, która niegdyś była domem dla wyroczni w erze, która dawno już minęła. Mimo iż miejsce jest w ruinie, ludzie nadal ściagają tu i miewają wizje rzeczy, które się wydarzą.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.holy_site.oracle";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = true;
		this.m.IsAttackable = false;
		this.m.IsDestructible = false;
		this.m.VisibilityMult = 0.8;
		this.m.Resources = 0;
		this.m.OnEnter = "event.location.oracle_enter";
	}

	function onSpawned()
	{
		this.m.Name = "Wyrocznia";
		this.location.onSpawned();
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_holy_site_02");
		local banner = this.addSprite("banner");
		banner.setOffset(this.createVec(90, 80));
	}

});

