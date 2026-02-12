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
		this.m.SuccessText = "[img]gfx/ui/events/event_158.png[/img]A wise man once told you that a wagon loses value the second it leaves the lot. The axiom dwells in the back of your head as you hand over 10,000 crowns for the wagon. But then you step up into the boxseat and jack your boot against the toeboard and feel right at home. You turn and take a look into the bed. There the wagonmaker installed a series of side-turned gates with iron spikes situated to hang trophies, pelts, and other goods. There is also a cage to hold a dog or a dog of a man if need be. A wooden toolbox with a heavy slaplatch carries all the means necessary to repair weapons and armor. Spare axles and wheels are held undercarriage.\n\nNodding, you turn back around and gander at the workhorse. The draught animal is a squat creature with muscled legs and an indifferent demeanor. It mindlessly crops the grass at its feet until you take up the jerkline and jockey it forward. The wagon trundles and tips and sags with nothing to suggest it was made to do anything you\'ve beckoned it to do. And yet there it goes.\n\n %randombrother% walks by swigging a wine bottle. When he asks how\'s the ride you steal his bottle and smash it across the wagon\'s side and yell out \'rawhide!\'";
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

