this.defeat_goblin_location_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		Defeated = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_goblin_location";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Tylko najśmielsi stawiają czoła goblinom w licznych grupach. Spalimy kilka\nich cuchnących obozów, a wieść o tym szybko się rozniesie!";
		this.m.RewardTooltip = "Otrzymasz unikalny przedmiot, który daje noszącemu niewrażliwość na ukorzenienie.";
		this.m.UIText = "Zniszcz lokacje kontrolowane przez gobliny";
		this.m.TooltipText = "Zniszcz cztery lokacje kontrolowane przez gobliny, aby dowieść męstwa kompanii, czy to w ramach kontraktu, czy poprzez wyruszenie w świat samopas. Musisz też mieć miejsce w ekwipunku na nowy przedmiot.";
		this.m.SuccessText = "[img]gfx/ui/events/event_83.png[/img]Ludzie są rozproszeni po polu bitwy, wciąż ciężko oddychają po trudnej walce. Gdy lustrujesz teren, %randombrother% i %randombrother2% przeszukują go w poszukiwaniu kosztowności.%SPEECH_ON%Idziemy naprzód, oni się cofają. Wycofujemy się, oni nękają nas. Salwa strzał i kryją się. Ściana tarcz zostaje przebita zatrutymi ostrzami, a przy szarży rozbiegają się jak robactwo. Te przeklęte rzeczy, które w ciebie ciskają, będą mi się śnić po nocach.%SPEECH_OFF%%randombrother2% szturcha martwego goblina bronią i, upewniwszy się, że na pewno nie żyje, klęka, by przyjrzeć się jego dobytkowi.%SPEECH_ON%Ale im bardziej gorzka walka, tym słodsze zwycięstwo.%SPEECH_OFF%Wstaje i spotyka spojrzenie %randombrother%.%SPEECH_ON%Im bardziej gorzka walka, tym bardziej czuję, że żyję. No chodź.%SPEECH_OFF%Powoli ruszają, by dołączyć do reszty ludzi, zatrzymując się tu i tam, by wypatrzyć rzeczy warte jedną czy dwie korony, gdy kompania dotrze do miasta.";
		this.m.SuccessButtonText = "Zwycięstwo!";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.m.Defeated + "/4)";
	}

	function onLocationDestroyed( _location )
	{
		if (this.World.FactionManager.getFaction(_location.getFaction()).getType() == this.Const.FactionType.Goblins)
		{
			++this.m.Defeated;
			this.World.Ambitions.updateUI();
		}
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 20)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		this.m.Score = 2 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return false;
		}

		if (this.m.Defeated >= 4)
		{
			return true;
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"recently_destroyed",
			this.World.Statistics.getFlags().get("LastLocationDestroyedName")
		]);
	}

	function onReward()
	{
		local item;
		local stash = this.World.Assets.getStash();
		item = this.new("scripts/items/accessory/goblin_trophy_item");
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "Zdobywasz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
	}

	function onClear()
	{
		this.m.Defeated = 0;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU8(this.m.Defeated);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.Defeated = _in.readU8();
	}

});

