this.merchant_of_jugs_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.merchant_of_jugs";
		this.m.Title = "Wzdłuż drogi...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_171.png[/img]{A lone merchant approaches with a wagon pulled by a camel. Large jugs rattle against one another in the bed of his cart, with ropes of dried moss hanging between the lids of each one. He rears up on the camel and swings his legs to one side of the animal\'s withers, tapping his own boot with a jockey switch.%SPEECH_ON%Hello there, travelers, I pray that your road to the coin has been gilded well. Mine has, though I\'m afraid we have seemingly crossed paths at a time when my peculiar shines rank in rare number. I\'ve but a few goods left, all of the drinking sort. 50 crowns per jug. Interested?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll take all the jugs for 150 crowns.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "For 50 crowns, we\'ll just take one.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "We\'re good.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_171.png[/img]{Wymieniasz się za wszystko, co ma, a kupiec chętnie się zgadza. Gdy odchodzi, jego wielbłądy są odciążone i zdają się mieć sprężysty krok po tak długim dźwiganiu. Napój w dzbanach to mieszanka wody i innych dodatków, które zapewniają dobry, długotrwały smak. Orzeźwiający trunek w skądinąd piekielnych pustkowiach.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dalej.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-150);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]150[/color] koron"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				for( local i = 0; i < 3; i = ++i )
				{
					if (brothers.len() == 0)
					{
						break;
					}

					local bro = brothers[this.Math.rand(0, brothers.len() - 1)];

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(1.0, "Wypił bardzo orzeźwiający napój");

						if (bro.getMoodState() > this.Const.MoodState.Neutral)
						{
							this.List.push({
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
			Text = "[img]gfx/ui/events/event_171.png[/img]{Kupiec przytakuje i wymieniacie korony za jeden z dzbanów. Mimo że to tylko jeden dzban, napój zapewni orzeźwiający odpoczynek od piekielnego żaru pustyni.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jak orzeźwiające!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-50);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]50[/color] koron"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				if (brothers.len() > 0)
				{
					local bro = brothers[this.Math.rand(0, brothers.len() - 1)];

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(1.0, "Wypił bardzo orzeźwiający napój");

						if (bro.getMoodState() > this.Const.MoodState.Neutral)
						{
							this.List.push({
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

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert && currentTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.Assets.getMoney() < 150)
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

});

