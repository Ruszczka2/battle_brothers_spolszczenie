this.lone_wolf_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.lone_wolf_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_137.png[/img]{Przechadzasz się po trybunach areny do walki na kopie. Spleśniałe owoce i warzywa walają się po podłodze. Zaschnięta krew zdobi ławy. A powietrze wypełnia cisza. Gdy siadasz, drewno jakby zajęczało jednogłośnie, skonsternowane wizytą rzadkiego gościa.\n\nW dłoni masz notatkę. \'Szukam śmiałych ludzi, znajomość miecza preferowana, ale każdy będzie mile widziany.\' To stara wiadomość, już dawno nieaktualna. Co jednak przykuło twój wzrok to kwota oferowana za pracę: więcej koron niźli zdołałbyś zarobić za pięć turniejów.\n\n Jeśli tak się na tym zarabia, to do diabła z pojedynkami i turniejami. Jednak nie dla ciebie jest służenie pod czyjąś komendą. Z tym wszystkim, co udało ci się zarobić przez lata, mógłbyś założyć swoją własną kompanię najemników.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I to właśnie zrobię.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "Samotny Wilk";
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

