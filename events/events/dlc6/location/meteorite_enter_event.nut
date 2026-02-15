this.meteorite_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.meteorite_enter";
		this.m.Title = "Gdy się zbliżasz...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_154.png[/img]{Kataklizmy, jakie świat zna, pochodzą z samej ziemi. Wulkany, powodzie, trzęsienia ziemi, zarazy - tego boją się wszyscy ludzie. Niespodziewane zjawiska, które potrafią w mgnieniu oka rozbić największe królestwa i zedrzeć królewskie barwy z najpotężniejszych władców.\n\nWielka kaldera przed tobą jest więc surowym przypomnieniem, że nie tylko jesteś mały, ale możesz nawet nie wiedzieć, jak bardzo: nawet najprostszy umysł widzi, że ogromna skała w centrum krateru spadła z góry. Być może z bardzo wielkiej wysokości. Północniacy wierzą, że to koda wielkiej wojny starych bogów. To dosłowna góra uzbrojona przez bóstwa, rzucona niczym kamień z katapulty, która po upadku zadała tak apokaliptyczne zniszczenia, że okropności ustały i wszelki niebiański konflikt wygasł. Południowcy widzą w tym \"ognistą łzę\" Gildera. Spoglądając na świat bez ludzi, Bóg popadł w głęboki smutek i zapłakał nad ziemią. Na początku obawiał się, że zniszczył wszystko, co było poniżej, lecz zamiast tego ujrzał, jak Człowiek wyłania się z ognia i zbroi się w popiołach. I wtedy poznał, że Człowiek, żyjący w każdym zakątku ziemi, jest Jego wybrańcem, i Człowiek poznał Jego.\n\nCokolwiek to jest, krater przyciąga wyznawców i wierzących ze wszystkich stron. Panuje tu przyjazne porozumienie, że nikt nie będzie sobie nawzajem przeszkadzać, choć w czasach świętej wojny to niewypowiedziane porozumienie bywa łamane.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Los w końcu znów nas tu przywiedzie.",
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

