this.holywar_ill_southerners_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.holywar_ill_southerners";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Natrafiasz na zagrodę i masz zamiar ją ominąć, gdy nagle drzwi się otwierają i wypada z nich mężczyzna, nogami przecinając ganek, aż pada plackiem na podwórzu. Dobywasz miecza i go badajesz. Gdy go odwracasz, widzisz zieloną i purpurową twarz, usta pokryte wymiocinami i zaschniętą krwią oraz włosy wypadające z głowy. Zostawiasz ciało i wchodzisz do zagrody, gdzie znajdujesz więcej takich jak on. To wszyscy południowcy i wygląda na to, że dopadła ich jakaś północna choroba, z którą nie mieli wcześniej do czynienia. Sądząc po zaniedbanym stanie ich sprzętu, siedzą tu już od dłuższego czasu.\n\n Jeden z południowców wyciąga do ciebie zniszczoną rękę.%SPEECH_ON%Proszę, poślij nas do Gildera. Światło tego świata już zgasło.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zakończmy to z godnością",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Niech muchy ucztują na waszym zgniłym ciele.",
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
			Text = "[img]gfx/ui/events/event_71.png[/img]{Południowców zabija się z godnością, albo przynajmniej z taką godnością, na jaką pozwala miecz. Oczywiście zabijasz ich z dystansu, nie odważając się dotknąć ich chorych ciał. Gdy każdy zostaje uśmiercony, rozglądasz się po zagrodzie. Na szczęście, zapewne dlatego, że materiał obcierał im skórę do krwi, chorzy odłożyli część wyposażenia na bok. Każesz braciom dokładnie je wyczyścić i zabierasz je ze sobą na drogę. Przy wyjściu słychać pomruki, że ci ludzie może zasługiwali na gorszy los, ale inni są całkiem zadowoleni z miłosiernego zakończenia.}",
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

					if (bro.getEthnicity() == 1 && this.Math.rand(1, 100) <= 66)
					{
						bro.improveMood(1.0, "Poparł twoją decyzję o zakończeniu cierpienia braci Gildera");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getEthnicity() == 0 && this.Math.rand(1, 100) <= 66)
					{
						bro.worsenMood(0.75, "Nie podobało mu się, że zakończyłeś cierpienie południowych najeźdźców");

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
			Text = "[img]gfx/ui/events/event_71.png[/img]{Część wyposażenia południowców została zdjęta i odłożona w pomieszczeniu. Każesz najemnikom zabrać je i wyszorować do czysta. Idąc do drzwi frontowych, zapalasz pochodnię i mówisz, że Gilder wkrótce ukaże im swe prawdziwe oblicze. Żołnierze błagają o litość, wijąca się masa sylwetek pełznie ku tobie, jęcząc ze słabości i strachu. Zamykasz drzwi i podpalasz dach, a potem wrzucasz pochodnię przez okno.\n\nDobrze nauczyłeś swoich ludzi, by nie brać takich decyzji do siebie, ale podejrzewasz, że niektórzy w %companyname% nie będą zadowoleni.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie mają prawa najeżdżać północy.",
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

					if (bro.getEthnicity() == 1 && this.Math.rand(1, 100) <= 66)
					{
						bro.worsenMood(1.0, "Nie podobało mu się, że zostawiłeś braci Gildera na powolną śmierć");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getEthnicity() == 0 && this.Math.rand(1, 100) <= 66)
					{
						bro.improveMood(0.75, "Poparł twoją decyzję, by zostawić południowych najeźdźców na śmierć");

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

		if (currentTile.Type == this.Const.World.TerrainType.Desert || currentTile.Type == this.Const.World.TerrainType.Steppe || currentTile.TacticalType == this.Const.World.TerrainTacticalType.DesertHills)
		{
			return;
		}

		if (currentTile.SquareCoords.Y < this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local closest = 9000;

		foreach( t in towns )
		{
			local d = t.getTile().getDistanceTo(currentTile);

			if (d < closest)
			{
				closest = d;
			}
		}

		if (closest < 7 || closest > 20)
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

