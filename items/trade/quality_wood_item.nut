this.quality_wood_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.quality_wood";
		this.m.Name = "Solidne Drewno";
		this.m.Description = "Wysokiej jakości sezonowane drewno, bez dziur po sękach i innych wad. Kupcy są gotowi za nie sporo zapłacić.";
		this.m.Icon = "trade/inventory_trade_01.png";
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.ProducingBuildings = [
			"attached_location.lumber_camp"
		];
		this.m.Value = 180;
	}

	function getSellPriceMult()
	{
		return this.World.State.getCurrentTown().getModifiers().BuildingPriceMult;
	}

	function getBuyPriceMult()
	{
		return this.World.State.getCurrentTown().getModifiers().BuildingPriceMult;
	}

});

