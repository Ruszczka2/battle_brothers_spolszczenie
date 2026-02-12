this.silk_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.silk";
		this.m.Name = "Jedwab";
		this.m.Description = "Te gładkie kawałki jedwabnego materiału są nieczęsto spotykane. Tylko najwyższa szlachta i najbogatsi mieszczanie mogą sobie pozwolić na uszycie z nich odzieży, a sam materiał osiąga bardzo wysokie ceny zwłaszcza na północy.";
		this.m.Icon = "trade/inventory_trade_11.png";
		this.m.Culture = this.Const.World.Culture.Southern;
		this.m.ProducingBuildings = [
			"attached_location.silk_farm"
		];
		this.m.Value = 460;
	}

});

