this.defeat_orc_location_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		Defeated = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_orc_location";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Pokonanie orków w bitwie i spalenie kilku ich obozów sprawiłoby,\nże ludzie doceniliby umiejętności bojowe kompanii. Tak też zróbmy!";
		this.m.RewardTooltip = "Otrzymasz unikalny przedmiot, który daje noszącemu niewrażliwość na ogłuszenie.";
		this.m.UIText = "Zniszcz lokacje kontrolowane przez orków";
		this.m.TooltipText = "Zniszcz cztery lokacje kontrolowane przez orków, aby dowieść męstwa kompanii, czy to w ramach kontraktu, czy poprzez wyruszenie w świat samopas. Musisz też mieć miejsce w ekwipunku na nowy przedmiot.";
		this.m.SuccessText = "[img]gfx/ui/events/event_81.png[/img]Z %recently_destroyed% wciąż unoszącym się dymem, z pobliskiego zagajnika wychodzi grupa ludzi, którzy z daleka obserwowali bitwę. Podchodzi do ciebie stara kobieta.%SPEECH_ON%Ci zielonoskórzy potwornicy wypędzili nas z gospodarstwa pod %nearesttown%, ale dzięki wam, dzielni ludzie, znów będziemy prosperować. To dla was.%SPEECH_OFF%Podaje ci worek jabłek. To niewielka nagroda, ale podobne słowa będą się powtarzać, gdy wieść o zniszczeniu orków rozejdzie się szeroko. %highestexperience_brother% parska śmiechem i wgryza się w soczyste jabłko.%SPEECH_ON%Na orki, te wielkie są zbyt powolne, a młode zbyt głupie. Strategia za każdym razem pokonuje brutalną siłę. Te wielkie zielone bestie liczą na strach, by zrobił robotę za nie. Trzymaj się twardo, a można je pobić jak każdego innego!%SPEECH_OFF%Chłopi zachwycają się przemową, dzielnością i siłą %highestexperience_brother%, klaszczą, zasypują go komplementami i klepią po plecach. Choć to słuszne słowa, to nie ta publiczność powinna je wcielać w życie. Kładziesz dłoń na ramieniu %highestexperience_brother%, jakbyś mówił, by spuścił z tonu, zanim któryś z chłopów uzna się za bohatera, gdy następnym razem zobaczy zielonoskórego.";
		this.m.SuccessButtonText = "Powiedzcie wszystkim, że to nasza kompania tutaj zwyciężyła! Wiwat %companyname%!";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.m.Defeated + "/4)";
	}

	function onLocationDestroyed( _location )
	{
		if (this.World.FactionManager.getFaction(_location.getFaction()).getType() == this.Const.FactionType.Orcs)
		{
			++this.m.Defeated;
			this.World.Ambitions.updateUI();
		}
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 25)
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
		local brothers = this.World.getPlayerRoster().getAll();
		local fearful = [];
		local lowborn = [];

		if (brothers.len() > 1)
		{
			for( local i = 0; i < brothers.len(); i = i )
			{
				if (brothers[i].getSkills().hasSkill("trait.player"))
				{
					brothers.remove(i);
					break;
				}

				i = ++i;
			}
		}

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.superstitious"))
			{
				fearful.push(bro);
			}
			else if (bro.getBackground().isLowborn())
			{
				lowborn.push(bro);
			}
		}

		local fear;

		if (fearful.len() != 0)
		{
			fear = fearful[this.Math.rand(0, fearful.len() - 1)];
		}
		else if (lowborn.len() != 0)
		{
			fear = lowborn[this.Math.rand(0, lowborn.len() - 1)];
		}
		else
		{
			fear = brothers[this.Math.rand(0, brothers.len() - 1)];
		}

		_vars.push([
			"fearful_brother",
			fear.getName()
		]);
		_vars.push([
			"recently_destroyed",
			this.World.Statistics.getFlags().get("LastLocationDestroyedName")
		]);
	}

	function onReward()
	{
		local item;
		local stash = this.World.Assets.getStash();
		item = this.new("scripts/items/accessory/orc_trophy_item");
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "Zdobywasz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
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

