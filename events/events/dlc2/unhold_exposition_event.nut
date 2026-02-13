this.unhold_exposition_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.unhold_exposition";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_126.png[/img]{Stary człowiek rysuje kredą po skale. Spogląda na kompanię, jakby przeszkadzała mu w sztuce, ale gdy obchodzisz go z boku, widzisz, że \'maluje\' coś na kształt olbrzymów górujących nad plemionami ludzi. Stukając kredą o skałę, przemawia jak nauczyciel.%SPEECH_ON%Założę się, że olbrzymy unholdy są tutaj znacznie dłużej niż jakikolwiek człowiek. Wiedzieliście, że jedne żyją w zimnie, inne w lasach, a jeszcze inne na bagnach? I żadne z nich nie przepada za sobą nawzajem. To w gruncie rzeczy człowiek w swoich najprostszych instynktach, destrukcyjny i złośliwy wobec własnego gatunku, a jednak większość ich wrogości skierowana jest przeciwko jednej rzeczy.%SPEECH_OFF%Starzec wskazuje na ciebie kredą i przechyla ją, by pył sypał się z końcówki.%SPEECH_ON%Obcym. Trzymaj się z dala od unholdów, wędrowcze.%SPEECH_OFF%Wygląda na trochę pomieszanego i nie ma nic wartościowego do ograbienia poza kolejną kredą, więc pospieszasz kompanię dalej. | Spotykasz małe dziecko rysujące w błocie na ścieżce. Gdy się zbliżasz, dostrzegasz, że tak naprawdę nie jest na ścieżce, lecz w dużym zagłębieniu, gdzie błoto zapadło się w kształt i rozmiar sarkofagu. Dziecko rysuje na wewnętrznych ścianach, głównie prymitywne kształty psów.%SPEECH_ON%Mój tata mówił, że to były \'unholdy\', unholdy szły tędy i tam, olbrzymy z opowieści, tylko że \'tak prawdziwe jak to, że mama odeszła do tego drania Birka, którego zabiję\', tę część mówi często. Birk ma to jak w banku. Tak mówi. Często. Myślę, że powinien pan trzymać się z dala od unholdów, proszę pana. Tata tak mówi, więc ja też tak mówię, i pan też powinien. A tak w ogóle, ma pan na imię Birk?%SPEECH_OFF%Kręcisz głową, żegnasz się i życzysz dziecku wszystkiego dobrego. Pod wieloma względami uważasz, że to była całkiem sensowna rada od dzieciaka. | Starszy mężczyzna o ciele wielkim jak głaz spogląda na ciebie z ganku gospodarstwa.%SPEECH_ON%Wiesz, raz widziałem unholda na własne oczy. Tak jest. Prawdziwy olbrzym, wielkości dziesięciu ludzi ustawionych jeden na drugim, jeśli nie większy. Szedł przez stepy, gonił konie i takie tam. Wysłali za nim milicję, a to cholerstwo ciskało nimi jak lalkami. Podniósł jednego i rzucił tak mocno, że myślałem, iż przeleci przez te cholerne góry. Wyglądasz na kogoś, kto lubi walkę, więc posłuchaj starego: trzymaj się z dala od unholdów.%SPEECH_OFF%Kiwasz głową i życzysz starcowi wszystkiego dobrego.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ktoś powinien nam zapłacić za radzenie sobie z nimi.",
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

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type != this.Const.World.TerrainType.Tundra)
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

