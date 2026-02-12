this.manhunters_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.manhunters_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_172.png[/img]{Ciągłe konflikty pomiędzy koczownikami, państwami-miastami i włóczęgami przyczyniają się do dobrych interesów: dezerterzy, przestępcy, jeńcy wojenni i zadłużeni, wszyscy oni uciekają po krainie, a wy z kajdanami w dłoniach ich gonicie.\n\nPomimo jałowych pustkowi, którymi władają, Południowe Królestwa są domem dla wielkich i zmieniających się populacji, przez co osobowości stały się zasobem wartym pozyskiwania. Ciągły przepływ ludzi jest tak naturalną rzeczą w ekonomii, jak każdy inny materiał.\n\nJeńcy wojenni stanowią trzon twojej jednostki, sponiewierani ludzie, którzy zmuszeni są do poddania się i walczenia dla innej armii: twojej własnej. Przestępcy i różnoraka hołota to łatwy łup z mniejszych wiosek, które nie mają jak zająć się swoimi pozbawionymi skrupułów mieszkańcami. No i są też zadłużeni... dusze skazane na ogień piekielny, które muszą zapracować sobie na łaskę Złotnika i znaleźć odkupienie poprzez krew, pot i łzy. Podczas gdy większość z nich musi pracować jako zwykli robotnicy, ty wolisz wcielać ich do swojej kompanii. Zadłużeni nie będą protestować, wszak nawet kapłani potwierdzają, że to leży w podniosłej woli Złotnika, by ci nieszczęśliwcy znaleźli skruchę w szeregach kompanii %companyname%.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Każdy może zasłużyć na zbawienie, odpracowując swój dług Złotnikowi.",
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
		this.m.Title = "Łowcy Głów";
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

