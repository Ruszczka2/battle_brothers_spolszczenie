this.goblin_city_reminder_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.goblin_city_reminder";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_119.png[/img]{Skoro tak wielu goblinów zostało wyeliminowanych, wieści o ich śmierci i zagładzie najpewniej dotrą do miasta zielonoskórych. Jeśli ten gobliński ekspert jest tak uczony, jak się wydaje, gobliny zareagują przesadnie i wyślą armie, pozostawiając bramy w dużej mierze bez obrony. Być może nadszedł czas, by wrócić do goblińskiego miasta i sprawdzić, czy wnioski nieznajomego się potwierdzą.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Powinniśmy wrócić.",
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
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.Flags.get("IsGoblinCityDestroyed"))
		{
			return;
		}

		if (this.World.Flags.get("IsGoblinCityOutposts") && this.World.Flags.get("GoblinCityCount") >= 5 || this.World.Flags.get("IsGoblinCityScouts") && this.World.Flags.get("GoblinCityCount") >= 10)
		{
			this.m.Score = 500;
		}
		else
		{
			return;
		}
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

