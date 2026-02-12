this.brawler_vs_brawler_event <- this.inherit("scripts/events/event", {
	m = {
		Brawler1 = null,
		Brawler2 = null
	},
	function create()
	{
		this.m.ID = "event.brawler_vs_brawler";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]Gdy siedzisz z ludźmi przy ognisku, rozmowa po drugiej stronie płomieni robi się nieco głośniejsza. %brawler% zabijaka wstaje i ze szczerym śmiechem wskazuje na własną pierś.%SPEECH_ON%Ty? Myślisz, że dasz mi radę?%SPEECH_OFF%Drugi zabijaka, %brawler2%, podrywa się na nogi.%SPEECH_ON%Tobie? Wpakowałbym cię pod ziemię, ty cholerny miękkopięściu!%SPEECH_OFF%Najmniejsza sugestia, że pięści %brawler% nie są zrobione z kruszących szczęki cegieł, rozpoczyna brutalną bijatykę. Zabijaki chwytają się nawzajem i wymachują wolnymi rękami, zadając półkoliste podcięcia. Każdy cios ląduje z trzaskającą furią. Żaden człowiek nie powinien znieść tylu obrażeń i stać na nogach, ale właśnie widzisz dwóch gości, którzy to robią. Każesz kompanii rozdzielić bójkę.\n\n%brawler% ściska jedno nozdrze i wypuszcza krew z drugiego. Wzrusza ramionami.%SPEECH_ON%Tylko mała sprzeczka, panie.%SPEECH_OFF%Wskakując barkiem z powrotem na miejsce, %brawler2% kiwa głową.%SPEECH_ON%Ano, bez szkody, bez urazy.%SPEECH_OFF%Patrzysz, jak obaj mężczyźni ściskają sobie dłonie i klepią się po ramionach, każdy gratulując drugiemu, jak potworne były jego ciosy.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To jeden ze sposobów na zgranie się.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler1.getImagePath());
				this.Characters.push(_event.m.Brawler2.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury1 = _event.m.Brawler1.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury1.getIcon(),
						text = _event.m.Brawler1.getName() + " doznaje " + injury1.getNameOnly()
					});
				}
				else
				{
					_event.m.Brawler1.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Brawler1.getName() + " doznaje lekkich ran"
					});
				}

				_event.m.Brawler1.improveMood(2.0, "Zacieśnił więź z " + _event.m.Brawler2.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Brawler1.getMoodState()],
					text = _event.m.Brawler1.getName() + this.Const.MoodStateEvent[_event.m.Brawler1.getMoodState()]
				});

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury2 = _event.m.Brawler2.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury2.getIcon(),
						text = _event.m.Brawler2.getName() + " doznaje " + injury2.getNameOnly()
					});
				}
				else
				{
					_event.m.Brawler2.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Brawler2.getName() + " doznaje lekkich ran"
					});
				}

				_event.m.Brawler2.improveMood(2.0, "Zacieśnił więź z " + _event.m.Brawler1.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Brawler2.getMoodState()],
					text = _event.m.Brawler2.getName() + this.Const.MoodStateEvent[_event.m.Brawler2.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.brawler")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		local idx = this.Math.rand(0, candidates.len() - 1);
		this.m.Brawler1 = candidates[idx];
		candidates.remove(idx);
		idx = this.Math.rand(0, candidates.len() - 1);
		this.m.Brawler2 = candidates[idx];
		this.m.Score = candidates.len() * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"brawler",
			this.m.Brawler1.getNameOnly()
		]);
		_vars.push([
			"brawler2",
			this.m.Brawler2.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Brawler1 = null;
		this.m.Brawler2 = null;
	}

});

