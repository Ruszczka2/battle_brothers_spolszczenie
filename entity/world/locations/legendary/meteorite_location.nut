this.meteorite_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "Wielki krater w ziemi, utworzony przez skałę, która spadła z nieba. Wokół niego utworzono dawno temu mauzoleum i do dnia dzisiejszego ludzie z wszystkich zakątków świata ściągają tu na pielgrzymki.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.holy_site.meteorite";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = true;
		this.m.IsAttackable = false;
		this.m.IsDestructible = false;
		this.m.VisibilityMult = 0.8;
		this.m.Resources = 0;
		this.m.OnEnter = "event.location.meteorite_enter";
	}

	function onSpawned()
	{
		this.m.Name = "Upadła Gwiazda";
		this.location.onSpawned();
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_holy_site_01");
		local banner = this.addSprite("banner");
		banner.setOffset(this.createVec(-60, 50));
	}

});

