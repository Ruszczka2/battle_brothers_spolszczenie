this.peat_bricks_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.peat_bricks";
		this.m.Name = "Kostki Torfowe";
		this.m.Description = "Kostki utworzone z osuszonego torfu, używane głównie jako paliwo. Kupcy są gotowi za nie sporo zapłacić.";
		this.m.Icon = "trade/inventory_trade_08.png";
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.ProducingBuildings = [
			"attached_location.peat_pit"
		];
		this.m.Value = 100;
	}

});

