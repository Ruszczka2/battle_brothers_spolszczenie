this.good_food_variety_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.good_food_variety";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_61.png[/img]{Patrzysz, jak ludzie wcinają posiłki tak kolorowe, jak ich osobowości. Zaopatrzenie kompanii w tak różnorodne jedzenie poprawiło im nastroje równie skutecznie co zwycięstwo! | Gorący posiłek to coś, czego potrzebuje każdy człowiek, ale gorący posiłek z dodatkami i daniami? To już zupełnie inna sprawa! Zakupy różnorodnego jedzenia sprawiają, że ludzie radośnie jedzą i czują się dobrze. | Jedzenie tak różnorodne, jak u każdego szlachcica - albo prawie. Tym właśnie zaopatrzyłeś kompanię, a ludzie są ogromnie wdzięczni, gdy jedzą.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Smacznego.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.spartan"))
					{
						continue;
					}
					else if (bro.getSkills().hasSkill("trait.gluttonous") || bro.getSkills().hasSkill("trait.fat"))
					{
						bro.improveMood(2.0, "Very much appreciated the food variety");
					}
					else
					{
						bro.improveMood(1.0, "Appreciated the food variety");
					}

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local hasBros = false;

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.spartan"))
			{
				continue;
			}

			hasBros = true;
			break;
		}

		if (!hasBros)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local food = [];

		foreach( item in stash )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Food))
			{
				if (food.find(item.getID()) == null)
				{
					food.push(item.getID());
				}
			}
		}

		if (food.len() < 4)
		{
			return;
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

