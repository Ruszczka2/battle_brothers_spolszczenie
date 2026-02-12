this.named_item_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.named_item";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Szanowana kompania jest rozpoznawana po swym ekwipunku. Powinniśmy wyruszyć\ni zdobyć prestiżową broń, tarczę, zbroję lub hełm, aby podnieść naszą sławę.";
		this.m.RewardTooltip = "Zyskasz dodatkowe 150 sławy za swe zwycięstwo.";
		this.m.UIText = "Posiadaj co najmniej 1 sławny przedmiot";
		this.m.TooltipText = "Posiadaj co najmniej 1 sławny przedmiot - broń, tarczę, zbroję lub hełm. Podążaj za plotkami w karczmach, aby dowiedzieć się, gdzie sławne przedmioty mogą się znajdować, kup je w wyspecjalizowanych pracowniach w dużych miastach i zamkach, lub wyrusz samodzielnie eksplorując świat i plądrując ruiny oraz obozy. Im dalej od cywilizacji, tym wyższa szansa na znalezienie rzadkich przedmiotów.";
		this.m.SuccessText = "[img]gfx/ui/events/event_28.png[/img]It was no easy task seeking out one of those rare items recognized as a talisman of fighting men, but the %nameditem% is truly remarkable. The men fairly glow with pride after acquiring it. Around the fire, some of the brothers even grow maudlin and teary-eyed when in their cups, pawing it like a favorite hound.%SPEECH_ON%Isn\'t it beautiful?%SPEECH_OFF%%randombrother% asks while admiring it in the glow of the campfire, quickly cut off by another of the men.%SPEECH_ON%Turn it this way so I can have a proper peek!%SPEECH_OFF%In the days that follow your men are parading the %nameditem% around like the trophy head of some fearsome beast. Usually in taverns or at festivals, and near other sources of mead and beer, the brothers make a habit of showing their prize off everywhere you go.";
		this.m.SuccessButtonText = "To się nam przysłuży.";
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 30)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 3)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)) && item.getID() != "armor.head.fangshire")
			{
				this.m.IsDone = true;
				return;
			}
		}

		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				this.m.IsDone = true;
				return;
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

			if (item != null && item != "-1" && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				this.m.IsDone = true;
				return;
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Head);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)) && item.getID() != "armor.head.fangshire")
			{
				this.m.IsDone = true;
				return;
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				this.m.IsDone = true;
				return;
			}

			for( local i = 0; i < bro.getItems().getUnlockedBagSlots(); i = i )
			{
				local item = bro.getItems().getItemAtBagSlot(i);

				if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
				{
					this.m.IsDone = true;
					return;
				}

				i = ++i;
			}
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)) && item.getID() != "armor.head.fangshire")
			{
				return true;
			}
		}

		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				return true;
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

			if (item != null && item != "-1" && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				return true;
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Head);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)) && item.getID() != "armor.head.fangshire")
			{
				return true;
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				return true;
			}
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		local nameditem;
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				nameditem = item;
				break;
			}
		}

		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				nameditem = item;
				break;
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

			if (item != null && item != "-1" && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				nameditem = item;
				break;
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Head);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				nameditem = item;
				break;
			}

			item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.Named) || item.isItemType(this.Const.Items.ItemType.Legendary)))
			{
				nameditem = item;
				break;
			}
		}

		_vars.push([
			"nameditem",
			nameditem != null ? nameditem.getName() : "Sławny Wielki Miecz"
		]);
	}

	function onReward()
	{
		this.World.Assets.addBusinessReputation(150);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/special.png",
			text = "Zdobywasz dodatkową sławę za posiadanie sławnego przedmiotu"
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

