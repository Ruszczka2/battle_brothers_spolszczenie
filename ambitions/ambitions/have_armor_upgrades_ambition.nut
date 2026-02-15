this.have_armor_upgrades_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_armor_upgrades";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Nudne zbroje są niegodne prawdziwego najemnika.\nOzdobimy nasz sprzęt trofeami z naszych wyczynów!";
		this.m.UIText = "Posiadaj co najmniej 6 pancerzy z dodatkami";
		this.m.TooltipText = "Posiadaj co najmniej 6 pancerzy z dodatkami. Kup te dodatki, złup, lub zamów u taksydermisty, a następnie połącz je ze zbrojami twoich ludzi.";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]Gdy obejmowałeś dowództwo, kompania była zbieraniną ludzi kurczowo trzymających się życia, doraźną zlepioną bandą najemników spajaną jedynie uporem i pogardą dla zdrowego rozsądku. Teraz patrzysz, jak ludzie krążą niczym postrzępione upiory z dzikich bezdroży, w zbrojach ozdobionych ohydnymi skalpami, skórami i kośćmi, pokrętną rekonstrukcją podboju, tak wyeksponowaną, by każdy wiedział, że %companyname% nie da się zmierzyć żadną ziemską miarą, czy to potwora, czy człowieka.";
		this.m.SuccessButtonText = "To się nam przysłuży.";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().Days <= 20)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local upgrades = 0;
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Armor) && item.getUpgrade() != null)
			{
				upgrades = ++upgrades;
				upgrades = upgrades;
			}
		}

		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body);

			if (item != null && item.isItemType(this.Const.Items.ItemType.Armor) && item.getUpgrade() != null)
			{
				upgrades = ++upgrades;
				upgrades = upgrades;
			}
		}

		if (upgrades > 6)
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local upgrades = 0;
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Armor) && item.getUpgrade() != null)
			{
				upgrades = ++upgrades;
				upgrades = upgrades;
			}
		}

		if (upgrades >= 6)
		{
			return true;
		}

		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body);

			if (item != null && item.isItemType(this.Const.Items.ItemType.Armor) && item.getUpgrade() != null)
			{
				upgrades = ++upgrades;
				upgrades = upgrades;
			}
		}

		return upgrades >= 6;
	}

	function onPrepareVariables( _vars )
	{
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

