this.vulcano_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "Niegdyś było to kwitnące miasto, teraz zostały jedynie ruiny pokryte pyłem. Upadła metropolia o wielu nazwach stała się obiektem kulturowej i religijnej dumy zarówno dla północy, jak i południa.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.holy_site.vulcano";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = true;
		this.m.IsAttackable = false;
		this.m.IsDestructible = false;
		this.m.VisibilityMult = 0.8;
		this.m.Resources = 0;
		this.m.OnEnter = "event.location.vulcano_enter";
	}

	function onSpawned()
	{
		this.m.Name = "Starożytne Miasto";
		this.location.onSpawned();
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_holy_site_03");
		local banner = this.addSprite("banner");
		banner.setOffset(this.createVec(-20, 60));
	}

});

