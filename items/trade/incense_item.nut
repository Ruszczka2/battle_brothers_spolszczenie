this.incense_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.incense";
		this.m.Name = "Kadzidło";
		this.m.Description = "Te wysuszone kawałki żywicy tworzą gęsty dym, charakteryzujący się tajemniczym i egzotycznym zapachem. Osiąga dobre ceny, zwłaszcza na północy.";
		this.m.Icon = "trade/inventory_trade_12.png";
		this.m.Culture = this.Const.World.Culture.Southern;
		this.m.ProducingBuildings = [
			"attached_location.incense_dryer"
		];
		this.m.Value = 380;
	}

	function getSellPriceMult()
	{
		return this.World.State.getCurrentTown().getModifiers().IncensePriceMult;
	}

	function getBuyPriceMult()
	{
		return this.World.State.getCurrentTown().getModifiers().IncensePriceMult;
	}

});

