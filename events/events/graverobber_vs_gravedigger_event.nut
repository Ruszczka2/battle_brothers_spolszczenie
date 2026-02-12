this.graverobber_vs_gravedigger_event <- this.inherit("scripts/events/event", {
	m = {
		Graverobber = null,
		Gravedigger = null
	},
	function create()
	{
		this.m.ID = "event.graverobber_vs_gravedigger";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_28.png[/img]Po pochowaniu zmarłego towarzysza %gravedigger% wbija łopatę w ziemię i chwyta %graverobber% za tunikę, odpychając go do tyłu i unosząc w powietrze. Zanim padnie choćby jedno słowo czy groźba, zwisający mężczyzna kopie napastnika w krocze. Obaj padają na ziemię i natychmiast zaczynają turlać się w błocie. W brei są nie do odróżnienia, ale ich napad wściekłości słychać wyraźnie.\n\nGrabarz wspina się na rabusia grobów i zaczyna wciskać błoto w jego twarz.%SPEECH_ON%Co ci mówiłem, co? Co mówiłem o kradzieży od tych, którzy nie widzą twoich brudnych łap, co?%SPEECH_OFF%Z ładnym zwrotem, sugerującym, że to nie jego pierwszy raz w błotnym zapasach, grabarz zrzuca napastnika i wspina się na niego. Chwyta wielkie kępy trawy i brudu i wciska je w twarz grabarza. Dziwnie, rabusiów grobów uznaje, że to dobry moment na obronę swojej sprawy.%SPEECH_ON%To tylko jego buty! To tylko jego rękawice! Umarli nie muszą chodzić ani nic podnosić, niech będą moje, mówię!%SPEECH_OFF% Wygląda na to, że grabarz i rabusiów grobów różnią się w kwestii tego, co idzie do ziemi i co z niej nie powinno wrócić. Pozwalasz im przepracować swoje spory - niewielka z tego szkoda, a poza tym to niezła rozrywka dla reszty kompanii.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tylko nie wpadnijcie do grobu.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				this.Characters.push(_event.m.Gravedigger.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
				}
				else
				{
					_event.m.Graverobber.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Graverobber.getName() + " doznaje lekkich ran"
					});
				}

				_event.m.Graverobber.worsenMood(0.5, "Got in a brawl with " + _event.m.Gravedigger.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Graverobber.getMoodState()],
					text = _event.m.Graverobber.getName() + this.Const.MoodStateEvent[_event.m.Graverobber.getMoodState()]
				});

				if (this.Math.rand(1, 100) <= 50)
				{
				}
				else
				{
					_event.m.Gravedigger.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Gravedigger.getName() + " doznaje lekkich ran"
					});
				}

				_event.m.Gravedigger.worsenMood(0.5, "Got in a brawl with " + _event.m.Graverobber.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Gravedigger.getMoodState()],
					text = _event.m.Gravedigger.getName() + this.Const.MoodStateEvent[_event.m.Gravedigger.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		local fallen = this.World.Statistics.getFallen();

		if (fallen.len() < 1 || fallen[0].Time != this.World.getTime().Days)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_graverobber = [];
		local candidates_gravedigger = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.graverobber")
			{
				candidates_graverobber.push(bro);
			}
			else if (bro.getBackground().getID() == "background.gravedigger")
			{
				candidates_gravedigger.push(bro);
			}
		}

		if (candidates_graverobber.len() == 0 || candidates_gravedigger.len() == 0)
		{
			return;
		}

		this.m.Graverobber = candidates_graverobber[this.Math.rand(0, candidates_graverobber.len() - 1)];
		this.m.Gravedigger = candidates_gravedigger[this.Math.rand(0, candidates_gravedigger.len() - 1)];
		this.m.Score = 50;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"graverobber",
			this.m.Graverobber.getName()
		]);
		_vars.push([
			"gravedigger",
			this.m.Gravedigger.getName()
		]);
	}

	function onClear()
	{
		this.m.Graverobber = null;
		this.m.Gravedigger = null;
	}

});

