this.furs_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.furs";
		this.m.Name = "Futra";
		this.m.Description = "Ciepłe futra pozyskane z dzikich zwierząt. Kupcy są gotowi za nie sporo zapłacić, zwłaszcza na południu.";
		this.m.Icon = "trade/inventory_trade_05.png";
		this.m.Culture = this.Const.World.Culture.Northern;
		this.m.ProducingBuildings = [
			"attached_location.trapper"
		];
		this.m.Value = 300;
	}

});

