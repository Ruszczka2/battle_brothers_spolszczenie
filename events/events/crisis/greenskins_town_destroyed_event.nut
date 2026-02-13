this.greenskins_town_destroyed_event <- this.inherit("scripts/events/event", {
	m = {
		News = null
	},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_town_destroyed";
		this.m.Title = "Wzdłuż drogi...";
		this.m.Cooldown = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_94.png[/img]{Ponure wieści na drodze. Uchodźcy i kupcy donoszą, że %city% zostało zniszczone przez zielonoskórych! Jeśli tak dalej pójdzie, nie będzie już ziemi, którą można by nazwać domem, gdy to wszystko się skończy. | Spotykasz szlacheckiego posłańca, który poi konia obok ścieżki. Mówi, że zielonoskórni unicestwili ludzkie armie wokół %city% i zniszczyli samo miasto! | Spotykasz kartografa i kupca z pustym wozem. Przerysowują mapę i jest w tym coś osobliwego: mapownik wymazuje z papieru %city%. Gdy pytasz dlaczego, unosi brew.%SPEECH_ON%Och, nie słyszałeś? %city% zostało zniszczone. Zielonoskórni przełamali obronę i zabili każdego, kogo dopadli.%SPEECH_OFF% | Spotykasz na ścieżce kupca. Jego wóz jest opróżniony, brakuje kilku zwierząt pociągowych. Na twarzy i ubraniu ma krew. Pytasz go o jego historię. Prostuje się.%SPEECH_ON%Moja historia? Nie, to nie moja historia. Jechałem do %city%, tylko po to, by zastać je opanowane przez zielonoskórych. Ledwo uszedłem z życiem. Miasto przepadło. Jeśli tam zmierzałeś, to nie fatyguj się. Nie ma go. Zniknęło całkowicie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Czy przegrywamy tę wojnę?",
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
	}

	function onUpdateScore()
	{
		if (!this.World.State.getPlayer().getTile().HasRoad)
		{
			return;
		}

		if (this.World.Statistics.hasNews("crisis_greenskins_town_destroyed"))
		{
			this.m.Score = 2000;
		}
	}

	function onPrepare()
	{
		this.m.News = this.World.Statistics.popNews("crisis_greenskins_town_destroyed");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"city",
			this.m.News.get("City")
		]);
	}

	function onClear()
	{
		this.m.News = null;
	}

});

