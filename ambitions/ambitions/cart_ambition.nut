this.cart_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.cart";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Ledwie jesteśmy w stanie dźwigać ten ekwipunek i łupy wojenny.\nZaoszczędźmy 7.500 koron, by kupić wózek i ulżyć naszym plecom!";
		this.m.RewardTooltip = "Odblokujesz dodatkowe 27 slotów w ekwipunku.";
		this.m.UIText = "Posiadaj co najmniej 7.500 koron";
		this.m.TooltipText = "Zbierz sumę 7.500 lub więcej koron, aby zakupić wózek dla dodatkowej przestrzeni w ekwipunku. Zarabiać możesz wykonując kontrakty, plądrując obozy i ruiny, albo0 handlując towarami.";
		this.m.SuccessText = "[img]gfx/ui/events/event_158.png[/img]Aby zebrać wystarczają ilość koron, by zapłacić kołodziejowi za jego pracę, wypruwacie sobie flaki, nieraz dosłownie. Teraz, jako dumny właściciel nowego wozu, możesz taszczyć za sobą więcej sprzętu oraz łupów wojennych, czy to srebrnych ozdób, złotych koron, czy na wpół rozdartych i zawszawionych przeszywanic, zdjętych z przypadkowych bandytów.\n\nPo przebyciu kilku pierwszych mil z nową parą kół zauważasz, że %randombrother% gdzieś się zapodział. Rozejrzawszy się, w końcu dostrzegasz go ukrytego za workami zboża na wozie, spokojnie pochrapującego. Kubeł zimnej wody na łeb i bucior w tyłek szybko stawiają lenia z powrotem na nogi i chwilę później już raźno maszeruje obok pozostałych. Musisz się jednak upewnić, by ludzie wiedzieli, gdzie jest ich miejsce.%SPEECH_ON%Nie będę tego tolerował! Na tym wozie będziecie się mogli przejechać tylko wówczas, gdy ktoś głowę oddzieli wam od ramion! Bądźcie uważni i miejcie broń w pogotowiu, gdy przemierzamy te ziemie!%SPEECH_OFF%Ludzie narzekają i ruszają w dalszą drogę.";
		this.m.SuccessButtonText = "W drogę!";
	}

	function onUpdateScore()
	{
		if (this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 2)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		this.m.Score = 3 + this.Math.rand(0, 5);

		if (this.World.getTime().Days >= 25)
		{
			this.m.Score += 1;
		}

		if (this.World.getTime().Days >= 35)
		{
			this.m.Score += 1;
		}

		if (this.World.getTime().Days >= 45)
		{
			this.m.Score += 1;
		}
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getMoney() >= 7500)
		{
			return true;
		}

		return false;
	}

	function onReward()
	{
		local item;
		local stash = this.World.Assets.getStash();
		this.World.Assets.addMoney(-5000);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/asset_money.png",
			text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]5.000[/color] koron"
		});
		this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() + 27);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/special.png",
			text = "Zdobywasz dodatkowe 27 slotów ekwipunku"
		});
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});

