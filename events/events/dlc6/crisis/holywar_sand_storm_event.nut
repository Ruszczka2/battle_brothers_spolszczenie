this.holywar_sand_storm_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.holywar_sand_storm";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_161.png[/img]{Napotykasz oddział mężczyzn w połowie zasypanych piaskiem. Ludzie północy schwytani przez nocną burzę piaskową. Ci, którzy żyją, wiją się z bólu. Niektórych mięso zostało zerwane z kości, innych już skubią skorpiony i sępy. Wygląda na to, że niektórzy odebrali sobie życie. Żadnej z tych dusz nie da się uratować, trzymają się już tylko końca.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zabij ich z godnością.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Zostaw ich piaskowi.",
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
			Text = "[img]gfx/ui/events/event_161.png[/img]{Dobywając miecza, pytasz mężczyzn, czy przyjmą godność szybkiej śmierci od twojej stali. Są zbyt spragnieni i wygłodzeni, by mówić, ale kilku kiwa głową. Jeden umiera, zanim zdąży odpowiedzieć. Podchodzisz do każdego, kucasz, życzysz im dobrze i wpychasz miecz. Skóra pęka pod ostrzem, a umierający na chwilę ożywają od przeszywającego bólu, po czym zostają uwolnieni z tego świata. W kompanii są różne opinie na ten temat.\n\nKażesz najemnikom zebrać, co tylko się da, choć większość wyposażenia została zniszczona przez furię pustyni.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Lepiej, żeby już dłużej nie cierpieli.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local amount = this.Math.rand(10, 20);
				this.World.Assets.addArmorParts(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_supplies.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] narzędzi i zapasów."
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
					{
						continue;
					}

					if (bro.getEthnicity() == 0 && this.Math.rand(1, 100) <= 66)
					{
						bro.improveMood(1.0, "Poparł twoją decyzję o zakończeniu cierpienia pobratymców z północy");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getEthnicity() == 1 && this.Math.rand(1, 100) <= 66)
					{
						bro.worsenMood(0.75, "Nie podobało mu się, że zakończyłeś cierpienie północnych najeźdźców");

						if (bro.getMoodState() > this.Const.MoodState.Neutral)
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

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_161.png[/img]{Każesz najemnikom zdjąć z umierających wszystko, co może się przydać. Krzyżowcy potrafią tylko mamrotać i jęczeć, gdy zdzierają z nich broń i zbroję. Ich nagie ciała zostają na palącym piasku, a gdy odchodzisz z resztkami użytecznego sprzętu, zwierzęta pustyni już podchodzą, by się pożywić. Mieszane uczucia towarzyszą %companyname% w tej sprawie, ale ostatecznie zarówno sprzeciw, jak i poparcie milkną.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Gilder ich osądził.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				local amount = this.Math.rand(10, 20);
				this.World.Assets.addArmorParts(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_supplies.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] narzędzi i zapasów."
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
					{
						continue;
					}

					if (bro.getEthnicity() == 0 && this.Math.rand(1, 100) <= 66)
					{
						bro.worsenMood(1.0, "Nie podobało mu się, że zostawiłeś pobratymców z północy na powolną śmierć");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getEthnicity() == 1 && this.Math.rand(1, 100) <= 66)
					{
						bro.improveMood(0.75, "Poparł twoją decyzję, by zostawić północnych najeźdźców osądzonych przez Gildera");

						if (bro.getMoodState() > this.Const.MoodState.Neutral)
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

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.FactionManager.isHolyWar())
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 7)
			{
				return;
			}
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

