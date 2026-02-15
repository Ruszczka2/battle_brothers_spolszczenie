this.defeat_undead_location_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		Defeated = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_undead_location";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Chodzące trupy to straszne przekleństwo ludzkości.\nSpalmy kilka ich mateczników i zyskajmy szacunek wszystkich dobrych ludzi!";
		this.m.RewardTooltip = "Otrzymasz unikalny przedmiot, który podwaja stanowczość noszącego podczas obrony przed efektami strachu i kontroli umysłu.";
		this.m.UIText = "Zniszcz lokacje osaczone przez nieumarłych";
		this.m.TooltipText = "Zniszcz cztery lokacje osaczone przez nieumarłych, aby dowieść męstwa kompanii, czy to wykonując kontrakty, czy poprzez wyruszenie w świat samopas. Musisz też mieć miejsce w ekwipunku na nowy przedmiot.";
		this.m.SuccessText = "[img]gfx/ui/events/event_46.png[/img]Dzięki %companyname% człapiące potworności z %recently_destroyed% już nigdy nie zagrożą niewinnym ludziom. Mężczyźni jednak będą potrzebować kilku dni i nieprzyzwoitych ilości alkoholu, by przetrawić okropności, z którymi się zmierzyli.%SPEECH_ON%Jak coś tak plugawnego może pokazać się w świetle dnia?%SPEECH_OFF%pyta %randombrother%, wpatrując się bezmyślnie w dal.%SPEECH_ON%Rozpadło się prosto w stertę zgniłych kości i pyłu. Nic tego nie trzymało, poza klątwą.%SPEECH_OFF%Jeszcze mroczniejsze lęki rodzą się w %fearful_brother%.%SPEECH_ON%Mówili mi w %randomtown%, że każdy dobry człowiek zabity przez te potwory jest skazany na powrót z grobu i nigdy nie zasiądzie u bogów.%SPEECH_OFF%Niektórzy głośno temu zaprzeczają, nie dlatego, że wiedzą lepiej, lecz dlatego, że nie chcą, by to była prawda. Wydajesz rozkaz, by przytłumić ogień, zanim ktoś zacznie opowiadać kolejne historie o duchach. Ludziom tej nocy może być trudno zasnąć, ale morale wzrośnie wraz ze świtem.";
		this.m.SuccessButtonText = "Znowu odnieśliśmy zwycięstwo!";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.m.Defeated + "/4)";
	}

	function onLocationDestroyed( _location )
	{
		if (this.World.FactionManager.getFaction(_location.getFaction()).getType() == this.Const.FactionType.Undead || this.World.FactionManager.getFaction(_location.getFaction()).getType() == this.Const.FactionType.Zombies)
		{
			++this.m.Defeated;
			this.World.Ambitions.updateUI();
		}
	}

	function onUpdateScore()
	{
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
		item = this.new("scripts/items/accessory/undead_trophy_item");
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

