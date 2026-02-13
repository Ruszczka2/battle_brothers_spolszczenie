this.holywar_occupied_south_event <- this.inherit("scripts/events/event", {
	m = {
		News = null
	},
	function create()
	{
		this.m.ID = "event.crisis.holywar_occupied_south";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_%image%.png[/img]{Nadchodzą wieści, że Gilded zdobyli %holysite%. Co zamierzają z tym zrobić, kto wie. Może postawią złocony płot, by trzymać północnych z dala? Najbardziej martwi cię, że walki mogą dobiegać końca, a z nimi całe to słodkie religijne miody, z których %companyname% korzystała. | Blask Gildera musi być teraz jaśniejszy niż kiedykolwiek: %holysite% wpadło pod kontrolę południowców. Być może Gilded poproszą %companyname% o pomoc w obronie, a może stare bogi będą potrzebowały odrobiny właściwej odwagi, by je odbić. Tak czy inaczej, %companyname% wciąż jest w doskonałej pozycji, by tuczyć sakiewkę.}",
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

		if (this.World.Statistics.hasNews("crisis_holywar_holysite_south"))
		{
			this.m.Score = 2000;
		}
	}

	function onPrepare()
	{
		this.m.News = this.World.Statistics.popNews("crisis_holywar_holysite_south");
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

