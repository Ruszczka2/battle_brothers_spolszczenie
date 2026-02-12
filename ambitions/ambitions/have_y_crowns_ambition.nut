this.have_y_crowns_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_y_crowns";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Jeśli jakaś bitwa lub dwie pójdą nie po naszej myśli, możemy skończyć z pustymi\nsakiewkami i brakach w wyposażeniu. Zbudujmy sobie rezerwę 10.000 koron.";
		this.m.UIText = "Posiadaj co najmniej 10.000 koron.";
		this.m.TooltipText = "Posiadaj co najmniej 10.000 koron jako rezerwę, aby móc przetrwać w przyszłości czasy, gdy losy źle się potoczą. Zarabiać możesz wykonując kontrakty, plądrując obozy i ruiny, albo0 handlując towarami.";
		this.m.SuccessText = "[img]gfx/ui/events/event_04.png[/img]Your increased store of coin and other valuables lets you sleep easier. The men do too, knowing that they won\'t have to chase you across the steppe when payroll is due. You\'ll no longer be at a disadvantage when it comes to contract negotiations, and you\'ll not end up short on men or equipment should a battle or two go against you.\n\nYour new reserve also begins to open doors for the %companyname%. Merchants, money lenders and nobles have one thing in common: they prefer to rub elbows with their own kind. Merely getting an audience can be a chore if they suspect you have empty pockets. But now that you\'ve proven yourself to be a man of resource, the company has become more attractive to wealthy individuals and decision makers.";
		this.m.SuccessButtonText = "Doskonale!";
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() > 9000)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 3)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.trader" && !this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getMoney() >= 10000)
		{
			return true;
		}

		return false;
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

