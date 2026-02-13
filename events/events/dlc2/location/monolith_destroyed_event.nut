this.monolith_destroyed_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.monolith_destroyed";
		this.m.Title = "Po bitwie";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_101.png[/img]{%SPEECH_START%To rozczarowujące.%SPEECH_OFF%%randombrother% mówi, patrząc na zabite trupy. Prycha i pluje.%SPEECH_ON%Tylko że rozczarowujące to nie jest właściwe słowo. Leżą tak, kości i płaszcze, jakbyśmy walczyli z szafą. Bez mięsa, bez krwi. To niesatysfakcjonujące. A świadomość tego, uznanie tego za prawdę, cóż, to mnie niepokoi.%SPEECH_OFF%Nie masz na to nic do powiedzenia poza tym, że jest w tym ziarno prawdy. Gdyby nie wykwity ich żądzy, skąd ten zapał do przemocy? Inny najemnik woła cię, przerywając wszelką poważną zadumę.%SPEECH_ON%Panie, proszę spojrzeć.%SPEECH_OFF%Podchodzisz i widzisz czaszkę leżącą na naramiennikach jak jajko w piersi hojnie obdarzonego południowca. Reszta ciała jest roztrzaskana i, jak sądzisz, rozwiana z wiatrem. To, co zostało, to zbytkowna płyta pancerza. Pokryta jest glifami i zdobieniami, wróżbami i historycznymi opowieściami, a także obszyta czerwonymi frędzlami i grzebieniami z szorstkich włosów. Dotykasz metalu i w tej samej chwili czaszka obok rozsypuje się w proch i rozwiewa. Najemnik, widząc to, wzrusza ramionami z zakłopotaniem.%SPEECH_ON%Jeśli masz magiczne moce, nikomu nie powiem.%SPEECH_OFF%Dajesz najemnikowi kuksańca w ramię i każesz mu załadować zbroję do ekwipunku na późniejszy przydział.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Powinienem przyjrzeć się temu pancerzowi.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_101.png[/img]{Gdy ludzie pakują się do drogi, słyszysz za sobą głos.%SPEECH_ON%...nigdy nie miałeś...%SPEECH_OFF%Odwracasz się, a świat ciemnieje w spowitym tunelu, twoi ludzie i ich głosy nikną w mroku, aż zostaje tylko starszy mężczyzna i światło na końcu tej czerni, chwiejny migot i drżenie ciała próbującego je utrzymać. Podchodzisz powoli, zyskując orientację co do mówiącego. To przenikliwy starzec, zgięty w pasie i jeszcze raz w plecach, a jego ramiona są cieńsze niż rękojeść miecza. Odwracasz się, by zobaczyć, że świat mroku podążył za tobą do przodu, za tobą nic poza czernią. Gdy znów spoglądasz w przód, mężczyzna nagle stoi tuż przed tobą. Wygląda tak znajomo, jak ktoś, kogo widziałeś w przeszłości, a jednak zapomniałeś, może ktoś z dzieciństwa, umierający wuj widziany podczas twojej czwartej zimy i jego ostatniej. Trzyma świecznik, a wosk zwisa z jego kostek i spływa po nadgarstku.%SPEECH_ON%Nigdy nie miałeś być... nigdy... nigdy... nigdy nie miałeś być, ty, którego nazywają Fałszywym Królem.%SPEECH_OFF%Budzisz się na ziemi. Najemnicy patrzą na ciebie z troską.%SPEECH_ON%Eee, wszystko w porządku, kapitanie?%SPEECH_OFF%Wstając, mówisz im, że po prostu uciąłeś sobie krótką drzemkę. Spoglądasz na Czarny Monolit i widzisz siebie w odbiciu obelisku, tylko twoje odbicie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wszystko w porządku.",
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

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
	}

});

