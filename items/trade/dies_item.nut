this.dies_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.dies";
		this.m.Name = "Barwniki";
		this.m.Description = "Cenne barwniki wytwarzane z różnorakich roślin i minerałów. Kupcy są gotowi za nie sporo zapłacić.";
		this.m.Icon = "trade/inventory_trade_02.png";
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.ProducingBuildings = [
			"attached_location.dye_maker"
		];
		this.m.Value = 400;
	}

});

