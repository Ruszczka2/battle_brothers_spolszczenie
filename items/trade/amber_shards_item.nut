this.amber_shards_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.amber_shards";
		this.m.Name = "Odłamki Bursztynu";
		this.m.Description = "Odłamki bursztynu wykorzystuje się głównie przy produkcji naszyjników i pierścieni. Kupcy są gotowi za nie sporo zapłacić.";
		this.m.Icon = "trade/inventory_trade_04.png";
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.ProducingBuildings = [
			"attached_location.amber_collector"
		];
		this.m.Value = 260;
	}

});

