this.trade_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		AmountToBuy = 25,
		AmountToSell = 25
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.trade";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Sporo koron można zarobić na handlu między miastami.\nZdobądźmy bogactwa!";
		this.m.UIText = "Kup i sprzedaj towary handlowe";
		this.m.TooltipText = "Kup i sprzedaj 25 sztuk towarów handlowych, takich jak futra, sól czy przyprawy. Kupowanie w małych wioskach, które dany towar produkują, i sprzedawanie ładunku w dużych miastach zapewni ci największą ilość monet. Niektóre towary handlowe są ekskluzywne w określonych regionach, takich jak południowe pustynie, a sprzedawanie ich w innych częściach świata może dodatkowo zwiększyć twój zysk.";
		this.m.SuccessText = "[img]gfx/ui/events/event_55.png[/img]Ta myśl naciskała cię od samego początku i jest to myśl, która umyka wielu kapitanom najemników. Tak prosta, że być może właśnie ta prostota ukrywa ją przed ego wojownika z mieczem. Skoro %companyname% i tak wędruje od miasta do miasta, szukając roboty dla najemników, to już jedną nogą stoi w całkiem innym fachu: handlu. Szybko to pojąłeś, rozumiejąc, że towary niosą inny rodzaj waluty niż ten widoczny na pierwszy rzut oka, wartość ukrytą przed wzrokiem i ukrytą w falach czasu i samego miejsca. Teraz wieczorami męczysz się z liczeniem koron. Po raz pierwszy to dobry problem.";
		this.m.SuccessButtonText = "To jest podstawa.";
	}

	function getUIText()
	{
		local bought = 25 - (this.m.AmountToBuy - this.World.Statistics.getFlags().getAsInt("TradeGoodsBought"));
		local sold = 25 - (this.m.AmountToSell - this.World.Statistics.getFlags().getAsInt("TradeGoodsSold"));
		local d = this.Math.min(25, this.Math.min(bought, sold));
		return this.m.UIText + " (" + d + "/25)";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 1 && this.World.Assets.getOrigin().getID() != "scenario.trader")
		{
			return;
		}

		this.m.AmountToBuy = this.World.Statistics.getFlags().getAsInt("TradeGoodsBought") + 25;
		this.m.AmountToSell = this.World.Statistics.getFlags().getAsInt("TradeGoodsSold") + 25;
		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("TradeGoodsBought") >= this.m.AmountToBuy && this.World.Statistics.getFlags().getAsInt("TradeGoodsSold") >= this.m.AmountToSell)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU32(this.m.AmountToBuy);
		_out.writeU32(this.m.AmountToSell);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);

		if (_in.getMetaData().getVersion() >= 63)
		{
			this.m.AmountToBuy = _in.readU32();
			this.m.AmountToSell = _in.readU32();
		}
	}

});

