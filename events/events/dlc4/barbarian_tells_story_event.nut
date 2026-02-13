this.barbarian_tells_story_event <- this.inherit("scripts/events/event", {
	m = {
		Barbarian = null
	},
	function create()
	{
		this.m.ID = "event.barbarian_tells_story";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%barbarian% dzieli się przy ognisku opowieściami o północnych bohaterach i potworach. Trudno wiele powiedzieć o jego gadce, bo nie jest zbyt elokwentny, ale świetnie radzi sobie pantomimą i rysowaniem po ziemi. {Jedna historia wydaje się opowiadać o olbrzymim wojowniku, który pokonuje znacznie większego wojownika, a może nawet ogrna. Trudno powiedzieć, ale barbarzyńca robi fascynujący pokaz walki, który mężczyźni nagradzają oklaskami. | Jedna opowieść jest o dwojgu kochankach i, z wielkim użyciem rąk, przedstawia porywający pokaz tego, czym jest orać i być oranym. I, najwyraźniej, czym jest zdrada i cios w plecy. Nie jesteś pewien, kto kogo dźga, ani kiedy i w jakim sensie, ale historia trzyma ludzi w napięciu i kończy się brawami. | Jedna historia mówi o przyjaznym unholdzie. Ludzie sapną na samą myśl, ale barbarzyńca klepie się po nadgarstkach i macha palcem. Zakładasz, że to jego sposób, by powiedzieć, że wszystko jest prawdą, każde słowo lub pomruk. Pomysł przyjaznego potwora początkowo niepokoi ludzi, ale do końca opowieści klaszczą i kiwają głowami, jakby życzyli sobie, by to naprawdę była prawda.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Porywające.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Barbarian.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "Czuł się rozbawiony");

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
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.barbarian")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Barbarian = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"barbarian",
			this.m.Barbarian.getName()
		]);
	}

	function onClear()
	{
		this.m.Barbarian = null;
	}

});

