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
		this.m.SuccessText = "[img]gfx/ui/events/event_64.png[/img]Początkowo nie byłeś pewien, czy powierzyć %sergeantbrother% to ważne zadanie, bo kochał hulanki i pijatyki jak każdy inny. Ale %sergeantbrother% podchodzi do obowiązków z zapałem, który zrazu budzi podziw, a później niepokoi.\n\nSzydząc z poranka jako pory tchórzy i cherlawych, %sergeantbrother% decyduje, że wszyscy muszą zaczynać dzień o wiele wcześniej. Prowadzi ludzi przez zwykłe ćwiczenia w parze i sprawdza sprzęt pod kątem pęknięć i zużycia, ale do tej lekkiej pracy dokłada surowe zasady rozbijania i zwijania obozu, ćwiczenia z ustawień, lekcje oskrzydlania, forsowne marsze z kamieniami w plecakach i szczegółowy reżim kar dla każdego, kto ośmieli się zostać w tyle.\n\nSłowa takie jak wyniszczający, okrutny, kamienne serce i bezlitosny, a do tego dziesiątki ostrzejszych epitetów, unoszą się w powietrzu, ilekroć %sergeantbrother% jest bezpiecznie poza zasięgiem słuchu, ale nigdy, gdy śpi. Bracia nauczyli się, że %sergeantbrotherfull% tak naprawdę nigdy nie zasypia.";
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

