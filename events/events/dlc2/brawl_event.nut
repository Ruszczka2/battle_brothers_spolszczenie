this.brawl_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.brawl";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_06.png[/img]{Wychodzisz się odlać i jesteś w pół strumienia, gdy za tobą wybucha gwar walki. Przerywasz, poprawiasz spodnie i wracasz do obozu. Tam znajdujesz całą kompanię walczącą nie z żadnym wrogiem, lecz ze sobą. Najemnicy wspinają się po sprzętach, ognisku i po sobie nawzajem, by wyprowadzać ciosy pięściami, machać łokciami, przewracać się lub powalać innych na ziemię. Każdy, kto upada, dostaje kopniaki w tyłek, dosłownie, aż ktoś inny odciągnie kopiących, wtedy ten, co upadł, zrywa się i rzuca z powrotem do bójki. Stara zadymka cichnie, gdy ludzie powoli uświadamiają sobie, że tu jesteś, i ustawiają się w szeregu, jakby szybka reorganizacja miała rozwiązać ich ordynarne zachowanie.\n\n Kręcąc głową, pytasz, co to wywołało. Ludzie wzruszają ramionami. Nikt nie pamięta. Robisz apel, żeby upewnić się, że nikt nie zginął. Potem każesz im wszystkim uścisnąć dłonie, pilnując ich przy tym. Nie ma złej krwi do wyczucia. Wygląda na to, że to była tylko zabawna bijatyka, nic więcej.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nic nie przebije dobrej bójki, co?",
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
					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(0.5, "Miał dobrą bójkę");

						if (bro.getMoodState() > this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " doznaje lekkich ran"
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 10)
		{
			return;
		}

		this.m.Score = 5;
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

