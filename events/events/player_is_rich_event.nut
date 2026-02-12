this.player_is_rich_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.player_is_rich_event";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_04.png[/img]Z czasem zgromadziłeś sporo pieniędzy. Choć trzymasz kasę wojenną pod kluczem, nie możesz nie zauważyć, że kilku braci przez czas spędzony w kompanii stało się nieco chciwszych. Słyszysz teraz plotki, że ludzie domagają się wyższego żołdu.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aye, to najwyższy czas, byście wszyscy dostali podwyżkę.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Wszyscy podpisaliście umowę i dostajecie żołd zgodnie z nią.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_04.png[/img]Uprzedzając wszelkie bunty i prośby o podwyżkę, ogłaszasz, że cała kompania dostaje podwyżkę. Trzy korony dziennie dla każdego. Okazuje się, że ludzie bardzo to lubią i wiwatują na twoją cześć!",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zasłużyliście na to, chłopcy!",
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
					if (bro.getSkills().hasSkill("trait.player") || bro.getFlags().get("IsPlayerCharacter") || bro.getBackground().getID() == "background.slave")
					{
						continue;
					}

					bro.getBaseProperties().DailyWage += 4;
					bro.improveMood(2.0, "Dostał podwyżkę żołdu");

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
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]Zanim ktokolwiek wpadnie na pomysł, stajesz przed całą kompanią i ogłaszasz, że nie będzie żadnych podwyżek. W twoim przekonaniu każdy obecny podpisał kontrakt. Szansa na większy żołd przychodzi tylko wraz z doświadczeniem, a to zdobywa się tylko, robiąc to, co najemnicy potrafią najlepiej: zabijać.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tak to działa w %companyname%.",
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
					if (bro.getSkills().hasSkill("trait.player") || bro.getFlags().get("IsPlayerCharacter") || bro.getBackground().getID() == "background.slave")
					{
						continue;
					}

					if (bro.getSkills().hasSkill("trait.greedy"))
					{
						bro.worsenMood(2.0, "Odmówiono mu podwyżki żołdu");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (!bro.getBackground().isExcluded("trait.greedy"))
					{
						if (this.Math.rand(1, 100) <= 20)
						{
							local trait = this.new("scripts/skills/traits/greedy_trait");
							bro.getSkills().add(trait);
							this.List.push({
								id = 10,
								icon = trait.getIcon(),
								text = bro.getName() + " staje się chciwy"
							});
						}
						else
						{
							bro.worsenMood(1.0, "Odmówiono mu podwyżki żołdu");

							if (bro.getMoodState() < this.Const.MoodState.Neutral)
							{
								this.List.push({
									id = 10,
									icon = this.Const.MoodStateIcon[bro.getMoodState()],
									text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
								});
							}
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() <= 30000)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() < 5)
		{
			return;
		}

		if (this.World.Retinue.hasFollower("follower.paymaster"))
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local numBros = 0;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() != "background.slave")
			{
				numBros = ++numBros;
			}
		}

		if (numBros < 2)
		{
			return;
		}

		this.m.Score = (this.World.Assets.getMoney() - 30000) * 0.0005;
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

