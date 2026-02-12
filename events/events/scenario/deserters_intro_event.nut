this.deserters_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.deserters_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Długie marsze w starych trzewikach. Śnieg? Walcz. Deszcz? Walcz. Nacierająca szarża ciężkiej konnicy? Chwytaj za włócznię. Walcz. Walcz. Wiecznie walcz. Ale nawet prostych rzeczy brakowało. Poproś o onuce, a powiedzą ci, żebyś ukradł je wieśniakom. Poproś o lepsze jadło, a twoją porcję podadzą ci na ziemi.\n\n Żywot żołnierza ci nie przeszkadza. Nie przeszkadza ci też zabijanie oraz widmo śmierci. To pogarda ze strony szlachty oraz brak odpowiedzialności ze strony poruczników, którzy \'śmiało\' rzucają cię rzeź, podkopują wszelkie chęci. To i nuda. Niekończąca się, dzień po dniu, nuda pustki.\n\n To dość ironiczne, że ty oraz trójka pozostałych dezerterów opuściliście obóz wojenny właśnie dzisiaj. Podano wyśmienity posiłek żołnierzom. Mówili, że to w ramach świętowania zwycięstwa. Twój talerz był wypełniony po brzegi. To porcje należące do ludzi, którzy tego dnia polegli. A ty to zjadłeś. Ze smakiem. A potem chwyciłeś za swoje tobołki, wyszedłeś na wieczorną wartę i po prostu wymknąłeś się. Za obmyślenie planu ucieczki, trzech innych dezerterów wybrało cię na swego przywódcę.\n\n Ruszycie własną ścieżką, ścieżką najemnika, gdzie odpowiednia płaca przynajmniej nieco wynagrodzi znój i ból. Najpierw jednak musicie jakoś przedostać się do innych krain, bo jeśli zbyt długo tu zabawicie, bez wątpienia skończycie na stryczku.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Będziemy kowalami własnego losu.",
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
		this.m.Title = "Dezerterzy";
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

