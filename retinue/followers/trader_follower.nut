this.trader_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.trader";
		this.m.Name = "Kupiec";
		this.m.Description = "Południowi kupcy znani są ze swych umiejętności targowania. Na twoje szczęście udało ci się przekonać jednego z tych mistrzów licytacji, aby dołączył do twojej kompanii. I to za tak okazyjną cenę!";
		this.m.Image = "ui/campfire/trader_01";
		this.m.Cost = 3500;
		this.m.Effects = [
			"Zwiększa ilość towarów handlowych na sprzedaż o 1 na każdą lokację, która je produkuje (np. sól w pobliżu kopalni soli), pozwalając ci handlować większymi ilościami"
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = ""
			}
		];
	}

	function onUpdate()
	{
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "Sprzedaj " + this.Math.min(25, this.World.Statistics.getFlags().getAsInt("TradeGoodsSold")) + "/25 towarów handlowych";

		if (this.World.Statistics.getFlags().getAsInt("TradeGoodsSold") >= 25)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

