this.wagon_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.wagon";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Wózek do wożenia naszych rzeczy jest w porządku, ale to za mało.\nZaoszczędźmy 15.000 koron i kupmy prawdziwy wóz!";
		this.m.RewardTooltip = "Odblokujesz dodatkowe 27 slotów w swoim ekwipunku.";
		this.m.UIText = "Posiadaj co najmniej 15.000 koron";
		this.m.TooltipText = "Zbierz sumę co najmniej 15.000 koron, by zakupić wóz w celu zwiększenia pojemności ekwipunku. Zarabiać możesz wykonując kontrakty, plądrując obozy i ruiny, albo0 handlując towarami.";
		this.m.SuccessText = "[img]gfx/ui/events/event_158.png[/img]Kiedyś mądry człowiek powiedział ci, że wóz traci na wartości w tej samej chwili, gdy opuszcza plac. Ta maksyma tkwi z tyłu głowy, gdy oddajesz 10.000 koron za wóz. Ale potem wspinasz się na koziejce, opierasz but o deskę i czujesz się jak u siebie. Odwracasz się i spoglądasz na skrzynię. Tam woznica zamontował rząd bocznych krat z żelaznymi kolcami, na których można wieszać trofea, skóry i inne dobra. Jest też klatka na psa, albo na psa w ludzkiej skórze, gdyby zaszła potrzeba. Drewniana skrzynka z ciężką zasuwą skrywa wszystko, co potrzebne do naprawy broni i zbroi. Zapasowe osie i koła zamocowano pod spodem.\n\nKiwając głową, odwracasz się i przyglądasz koniowi roboczemu. Zwierzę pociągowe to krępka istota o umięśnionych nogach i obojętnym spojrzeniu. Bezmyślnie skubie trawę u stóp, aż chwytasz lejce i kierujesz je naprzód. Wóz turkocze, przechyla się i ugina, jakby nic nie wskazywało, że został stworzony do tego, o co go prosisz. A jednak jedzie.\n\n%randombrother% przechodzi, pociągając z butelki wina. Gdy pyta, jak się jedzie, zabierasz mu butelkę, rozbijasz ją o bok wozu i krzyczysz: rawhide!";
		this.m.SuccessButtonText = "Wreszcie.";
	}

	function onUpdateScore()
	{
		if (this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 4)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.cart").isDone())
		{
			return;
		}

		this.m.Score = 2 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getMoney() >= 15000)
		{
			return true;
		}

		return false;
	}

	function onReward()
	{
		local item;
		local stash = this.World.Assets.getStash();
		this.World.Assets.addMoney(-10000);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/asset_money.png",
			text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]10.000[/color] koron"
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

