this.copper_ingots_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.copper_ingots";
		this.m.Name = "Sztabki Miedzi";
		this.m.Description = "Miedź przetopiona w poręczne sztabki, aby ułatwić transport. Kupcy są gotowi za nie sporo zapłacić.";
		this.m.Icon = "trade/inventory_trade_07.png";
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.ProducingBuildings = [
			"attached_location.surface_copper_vein"
		];
		this.m.Value = 220;
	}


	function getBuyPriceMult()

	{

		return this.World.State.getCurrentTown().getModifiers().BuildingPriceMult;

	}

	function getSellPriceMult()

	{

		return this.World.State.getCurrentTown().getModifiers().BuildingPriceMult;

	}
});

