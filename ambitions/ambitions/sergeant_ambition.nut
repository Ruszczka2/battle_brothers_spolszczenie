this.sergeant_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.sergeant";
		this.m.Duration = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Walczymy dobrze, jednak trza nam lepszej organizacji, gdyby rzeczy tragicznie\nsię potoczyły. Mianuję sierżanta, aby pokrzepiał was na polu bitwy.";
		this.m.RewardTooltip = "Otrzymasz unikalny przedmiot, który daje noszącemu premię do stanowczości.";
		this.m.UIText = "Miej jednego człowieka z talentem \'Pokrzepienie Towarzyszy\'";
		this.m.TooltipText = "Miej co najmniej jednego człowieka z talentem \'Pokrzepienie Towarzyszy\'. Musisz też mieć miejsce w ekwipunku na nowy przedmiot.";
		this.m.SuccessText = "[img]gfx/ui/events/event_64.png[/img]You were unsure at first about assigning %sergeantbrother% to this important task, for he was as committed to revelry and carousing as any other man. But %sergeantbrother% takes to his duties with a zeal that is at first admirable, and later worrying.\n\nScoffing at dawn as the rising hour of the cowardly and infirm, %sergeantbrother% decides that everyone must start the day much earlier. He runs the men through the usual sparring routines and checks their equipment for splits and wear, but to such light work he adds strict rules about setting up and breaking camp, formation drills, lessons on flanking, forced marches with stones in their packs, and a detailed punishment regime for anyone who dares fall behind.\n\nWords such as \'back-breaking\', \'cruel\', \'flint-hearted\' and \'merciless\', as well as dozens of saltier epithets, ring in the air whenever %sergeantbrother% is safely out of earshot, though never when he is sleeping. For the brothers have learned that %sergeantbrotherfull% never truly sleeps.";
		this.m.SuccessButtonText = "To nam bardzo pomoże w nadchodzących dniach.";
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 15)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.battle_standard").isDone())
		{
			return;
		}

		this.m.Score = 3 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return false;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("perk.rally_the_troops"))
			{
				return true;
			}
		}

		return false;
	}

	function onReward()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local highestBravery = 0;
		local bestSergeant;

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("perk.rally_the_troops"))
			{
				if (bro.getCurrentProperties().getBravery() > highestBravery)
				{
					bestSergeant = bro;
					highestBravery = bro.getCurrentProperties().getBravery();
				}
			}
		}

		if (bestSergeant != null && bestSergeant.getTitle() == "")
		{
			bestSergeant.setTitle("Sierżant");
			this.m.SuccessList.push({
				id = 90,
				icon = "ui/icons/special.png",
				text = bestSergeant.getNameOnly() + " jest teraz znany jako " + bestSergeant.getName()
			});
		}

		local item = this.new("scripts/items/accessory/sergeant_badge_item");
		this.World.Assets.getStash().add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "Zdobywasz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local highestBravery = 0;
		local bestSergeant;

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("perk.rally_the_troops") && bro.getCurrentProperties().getBravery() > highestBravery)
			{
				bestSergeant = bro;
				highestBravery = bro.getCurrentProperties().getBravery();
			}
		}

		_vars.push([
			"sergeantbrother",
			bestSergeant.getNameOnly()
		]);
		_vars.push([
			"sergeantbrotherfull",
			bestSergeant.getName()
		]);
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

