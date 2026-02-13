this.civilwar_treasurer_event <- this.inherit("scripts/events/event", {
	m = {
		NobleHouse = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_treasurer";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_72.png[/img]Maszerując przez ziemie, natrafiasz na rolnika zaczepianego przez zamożnie wyglądającego mężczyznę. Na twój widok rolnik szybko woła.%SPEECH_ON%Panie, pomóż mi! Ten skarbnik chce zabrać moje plony!%SPEECH_OFF%Skarbnik kiwa głową, jakby nie działo się nic złego.%SPEECH_ON%To prawda. Zostałem wysłany przez %noblehouse% i jestem tutaj, by zebrać zapasy żywności dla armii. To nasza ziemia, a więc i nasze plony.%SPEECH_OFF%Ucisk wojny staje się coraz gorszy... %randombrother% pyta, co chcesz zrobić.",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Zostawcie tego rolnika w spokoju!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "To nie nasza sprawa.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Z drogi, obaj. To jedzenie jest teraz nasze!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_72.png[/img]Choć moralność ma niewielkie znaczenie w grze wojny, nie możesz nie myśleć, że ten biedny rolnik niczemu nie zawinił. Chwytasz skarbnika za koszulę i przyciskasz do ściany zagrody. Jego oczy rozszerzają się, jakbyś właśnie przebił jakąś zasłonę nietykalności.%SPEECH_ON%Co ty, do diabła, wyprawiasz?%SPEECH_OFF%Rozluźniasz uścisk, bo choć ten człowiek może nie jest nietykalny, jego nazwisko ma za sobą takich, którzy są.%SPEECH_ON%Powiedz swoim ludziom, że ten rolnik nie miał nic do zaoferowania. Plony były w tym sezonie marne, jasne?%SPEECH_OFF%Kładziesz dłoń na rękojeści miecza. Mężczyzna zerka na nią, po czym szybko kiwa głową.%SPEECH_ON%Dobrze, rozumiem.%SPEECH_OFF%Rolnik dziękuje ci z całego serca, a także z odrobiną swoich zapasów, nagradzając cię kilkoma workami zboża za pomoc.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Dziś zrobiliśmy coś dobrego.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "You threatened one of their treasurers");
				this.World.Assets.addMoralReputation(1);
				local food = this.new("scripts/items/supplies/ground_grains_item");
				this.World.Assets.getStash().add(food);
				this.World.Assets.updateFood();
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Zyskujesz " + food.getName()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.farmhand" && this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(0.25, "You helped a farmer in peril");

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
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_72.png[/img]Choć żal ci rolnika, uczucia niewiele znaczą, gdy między rodami toczy się wielka wojna. Wybierasz, by się nie wtrącać. Gdy robotnicy skarbnika niosą worki zboża na wóz, podchodzi, by porozmawiać.%SPEECH_ON%Powiem szlachcie o twojej, cóż, szlachetnej decyzji. Mogłeś wywołać zamieszanie, ale tego nie zrobiłeś. Dziękuję, najemniku. Ludzie naszej armii potrzebowali tego jedzenia bardziej, niż możesz wiedzieć.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "No cóż.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "You respected the authority of one of their treasurers");
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_72.png[/img]Początkowo wyglądało na to, że są tu tylko dwie opcje, ale jako najemnik wolny od więzów szlachty, odpowiedzialności i, cóż, wszelkich społecznych kajdan, wybierasz trzecią drogę: zabierasz jedzenie dla siebie i swoich ludzi. Zarówno skarbnik, jak i rolnik protestują, ale twoi ludzie dobywają ostrzy, co jest szybkim sposobem uciszenia wszelkiej debaty.\n\n W sumie nie ma tu zbyt wiele do zabrania, a ściągasz na siebie gniew pospólstwa i szlachty za całe zamieszanie.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Najpierw musimy dbać o siebie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "You threatened one of their treasurers");
				this.World.Assets.addMoralReputation(-2);
				local maxfood = this.Math.rand(2, 3);

				for( local i = 0; i < maxfood; i = ++i )
				{
					local food = this.new("scripts/items/supplies/ground_grains_item");
					this.World.Assets.getStash().add(food);
					this.World.Assets.updateFood();
					this.List.push({
						id = 10,
						icon = "ui/items/" + food.getIcon(),
						text = "Zyskujesz " + food.getName()
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local bestDistance = 9000;
		local bestTown;

		foreach( t in towns )
		{
			if (t.isSouthern())
			{
				continue;
			}

			local d = playerTile.getDistanceTo(t.getTile());

			if (d <= bestDistance)
			{
				bestDistance = d;
				bestTown = t;
				break;
			}
		}

		if (bestTown == null)
		{
			return;
		}

		this.m.NobleHouse = bestTown.getOwner();
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noblehouse",
			this.m.NobleHouse.getName()
		]);
	}

	function onClear()
	{
		this.m.NobleHouse = null;
	}

});

