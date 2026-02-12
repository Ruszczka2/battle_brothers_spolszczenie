this.uncut_gems_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.uncut_gems";
		this.m.Name = "Nieoszlifowane Klejnoty";
		this.m.Description = "Nieoberżnięte kamienie szlachetne, tylko czekające na to, by je oszlifować i wypolerować. Kupcy są gotowi za nie sporo zapłacić.";
		this.m.Icon = "trade/inventory_trade_06.png";
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.ProducingBuildings = [
			"attached_location.gem_mine"
		];
		this.m.Value = 520;
	}

});

