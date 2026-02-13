this.oracle_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.oracle_enter";
		this.m.Title = "Gdy się zbliżasz...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_152.png[/img]{Wejście do przedsionka starożytnej Wyroczni jest jak wkroczenie do cudzego snu. Mężczyźni i kobiety bezwładnie krążą wokół jej filarów, nieśmiałe skrobanie butów o kamień ledwie wypełnia powietrze, a niezależnie od pory dnia lub nocy architektoniczna krzywizna rzuca blady, posępny cień na jej dziwne sale, jakby była skazana na wieczność pod samym księżycem.\n\nLudzie wszystkich religii przybywają do Wyroczni z wspólnym poczuciem czci. Nikt nie wie, jakie kapłańskie istoty niegdyś tu mieszkały ani jakie barwy duchowne nosiły. Mimo tych tajemnic wielu wierzy, że śpiąc wewnątrz Wyroczni można zyskać wizje własnej przyszłości. To godna podziwu wiara, choć wydaje ci się ironiczne, że tych eterycznych znaczeń trzeba szukać, używając rąk i nóg wiernych, by tam dotrzeć. Na razie do krawędzi Wyroczni przylgnęło zubożałe, stłoczone miasto namiotów. To żałosny koniec dla tych, którzy tak bardzo unieśli się nadzieją, że stali się uchodźcami od rzeczywistości.}",
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

