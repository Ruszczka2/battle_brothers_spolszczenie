this.spices_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.spices";
		this.m.Name = "Przyprawy";
		this.m.Description = "Różnorakie aromatyczne i rzadkie przyprawy, pochodzące z południowych królestw. Na północy są niezwykle pożądanym towarem.";
		this.m.Icon = "trade/inventory_trade_10.png";
		this.m.Culture = this.Const.World.Culture.Southern;
		this.m.ProducingBuildings = [
			"attached_location.plantation"
		];
		this.m.Value = 320;
	}

});

