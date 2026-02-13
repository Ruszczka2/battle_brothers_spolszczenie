this.holywar_occupied_north_event <- this.inherit("scripts/events/event", {
	m = {
		News = null
	},
	function create()
	{
		this.m.ID = "event.crisis.holywar_occupied_north";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_%image%.png[/img]{Wieści rozchodzą się szybko, podsycane religijnym zapałem: %holysite% zostało zdobyte przez północnych krzyżowców! | Krzyżowcy z północy zdobyli %holysite%. Nie jesteś pewien, czy oznacza to, że wojna wkrótce się skończy. Byłoby szkoda, bo całe to zamieszanie stworzyło takie możliwości. | %holysite% upadło pod sztandarem północnych krzyżowców! Choć stare bogi z pewnością się radują, wyznawcy Gildera zapewne zechcą je odbić. To może stworzyć okazje dla %companyname%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ognie religijnego zamętu płoną jasno.",
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

		if (this.World.Statistics.hasNews("crisis_holywar_holysite_north"))
		{
			this.m.Score = 2000;
		}
	}

	function onPrepare()
	{
		this.m.News = this.World.Statistics.popNews("crisis_holywar_holysite_north");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"holysite",
			this.m.News.get("Holysite")
		]);
		_vars.push([
			"image",
			this.m.News.get("Image")
		]);
	}

	function onClear()
	{
		this.m.News = null;
	}

});

