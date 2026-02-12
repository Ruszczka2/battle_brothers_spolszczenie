this.town_tavern_dialog_module <- this.inherit("scripts/ui/screens/ui_module", {
	m = {
		Tavern = null
	},
	function setTavern( _t )
	{
		this.m.Tavern = _t;
	}

	function create()
	{
		this.m.ID = "TavernDialogModule";
		this.ui_module.create();
	}

	function destroy()
	{
		this.ui_module.destroy();
	}

	function clear()
	{
		this.m.Tavern = null;
	}

	function onLeaveButtonPressed()
	{
		this.m.Parent.onModuleClosed();
	}

	function onQueryRumor()
	{
		local data = {
			Rumor = this.m.Tavern.getRumor(true),
			DrinkPrice = this.m.Tavern.getDrinkPrice(),
			RumorPrice = this.m.Tavern.getRumorPrice(),
			Assets = this.m.Parent.queryAssetsInformation()
		};
		return data;
	}

	function onDrink()
	{
		local data = {
			Drink = this.m.Tavern.getDrinkResult(),
			DrinkPrice = this.m.Tavern.getDrinkPrice(),
			RumorPrice = this.m.Tavern.getRumorPrice(),
			Assets = this.m.Parent.queryAssetsInformation()
		};
		return data;
	}

	function queryData()
	{
		return {
			Title = "Karczma",
			SubTitle = "Duza gospoda, wypełniona miejscowymi oraz przyjezdnymi z różnych ziem",
			Rumor = this.m.Tavern.getRumor(false),
			RumorPrice = this.m.Tavern.getRumorPrice(),
			Drink = null,
			DrinkPrice = this.m.Tavern.getDrinkPrice(),
			LeftInfo = "Postaw kolejkę gościom karczmy, aby chętniej podzielili się wieściami i plotkami ([img]gfx/ui/tooltips/money.png[/img]" + this.Math.round(20 * this.m.Tavern.getSettlement().getBuyPriceMult()) + ").",
			RightInfo = "Postaw kolejkę swoim ludziom, aby podnieść ich na duchu ([img]gfx/ui/tooltips/money.png[/img]" + this.Math.round(this.World.getPlayerRoster().getSize() * 5 * this.m.Tavern.getSettlement().getBuyPriceMult()) + ").",
			Assets = this.m.Parent.queryAssetsInformation()
		};
	}

});

