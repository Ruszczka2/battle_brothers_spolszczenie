this.traveler_north_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.traveler_north";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Natrafiasz na mężczyznę siedzącego przy przeręblu. Ma obok wędkę i, mimo warunków, wita cię serdecznie.%SPEECH_ON%Masz ochotę pogadać, wędrowcze? Nie wyglądasz na tutejszego.%SPEECH_OFF% | Mężczyzna w niedźwiedzim futrze wycina przerębel. Spogląda na ciebie, gdy obrzeże jego wycinki opada i wpycha je do wody.%SPEECH_ON%Chodź, wędrowcze, odpocznij obok mnie chwilę. Jestem niegroźny.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Dołącz do nas przy ognisku tej nocy.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Nie, trzymaj się z dala.",
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
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_26.png[/img]{Pytasz mężczyznę, czy Północ widziała jakieś niszczycielskie wojny. Wzrusza ramionami.%SPEECH_ON%Ano, mamy swoje spory. Ten i tamten. Ale sto lat temu zebrano wspólnotę wojowników, by pokonać hordę nieumarłych. Och, widzę po twoich oczach, że o tym nie słyszałeś. Pewnie gdyby ich nie powstrzymano, chodzące trupy zalałyby południe i wszystkich by was pozabijały. Proszę bardzo. Założę się, że nie uczą tego w waszych eleganckich południowych księgach.%SPEECH_OFF% | Mężczyzna prycha i kiwa głową w stronę wędki.%SPEECH_ON%Mówią, że tam na dole są wielkie ryby. Nieszkodliwe, ale dość duże, by pobudzić wyobraźnię. Nie mogę powiedzieć, że widziałem je na własne oczy, ale był czas, gdy duży cień przeszedł pod moimi stopami, przeszedł tam przez wodę, i przesuwał się, przesuwał, jakby wiecznie. A potem zniknął.%SPEECH_OFF%Pytasz, skąd wie, że to nieszkodliwe stworzenie. Wzrusza ramionami.%SPEECH_ON%Bo nic nie zrobiło poza pójściem stamtąd tam i dalej.%SPEECH_OFF% | Mężczyzna sprawdza wędkę, po czym kuca na piętach. Kiwając głową, wskazuje lód.%SPEECH_ON%Stare białe niedźwiedzie potrafią przekraczać te przestrzenie. Trzeba mieć je na oku. Trochę ognia je odstraszy, albo po prostu wyrzucisz ryby i dasz nogę. Znałem człowieka, którego zjadł biały niedźwiedź. Mówili, że jadł go od nóg w górę, mając w nosie jego krzyki i wrzaski. Prędzej poderżnąłbym sobie gardło, niż pozwolił, by jedno z tych bestii mnie dopadło.%SPEECH_OFF% | Dość przyjazny gość, mężczyzna spoczywa obok wędek i mówi o naturze swojego ludu.%SPEECH_ON%Byłem wystarczająco blisko południa, by wiedzieć, że uważacie nas za dzikusów. W porządku, ale to coś więcej niż to, a może mniej. Mamy mniej. Dużo mniej. I jakoś sobie z tym radzimy.%SPEECH_OFF%Zauważasz, że północni ludzie często zapuszczają się na południe tylko po to, by gwałcić i grabić. Mężczyzna wzrusza ramionami.%SPEECH_ON%A wy wysyłacie wyprawy na północ, by obdarzyć nas południową sprawiedliwością. Wygląda na uczciwy układ. Nikt nic nie robi, jeśli nad nim nie wisi odwet, wyraźny jak dzień. Jesteśmy na równi.%SPEECH_OFF% | Gdy siedzisz obok mężczyzny, łapie rybę i wyciąga ją na lód. Chwyta ją w futrzanej rękawicy i rozbija jej głowę, by przestała się miotać. Mówi, gdy ją patroszy i soli.%SPEECH_ON%Niektórzy z północy wymyślili, jak oswoić tych olbrzymów, uholdów, jak ich chyba nazywacie. Nie pytaj mnie jak. Kiedykolwiek słyszałem o jakimś olbrzymie, szedł gdzieś i tylko zabijał wszystkich na swojej drodze i pożerał całe stada.%SPEECH_OFF% | Mężczyzna prycha i sprawdza wędki, wzdychając, gdy nie ma brania.%SPEECH_ON%Kilka lat temu poszedłem na południe. Zostałem tam też parę lat. Dlatego tak dobrze znam waszą mowę. Kiedy byłem na dole, spróbowałem tego, co nazywacie warzywami. Obrzydliwe rzeczy, naprawdę, a południe się zastanawia, jak my tam, na pustkowiach, rośniemy tak wielcy i silni? Powiem ci, nie potrafimy uprawiać żadnych pieprzonych warzyw. Jemy tylko to, co musi umrzeć, a nic z bijącym sercem nie chce łatwo umierać.%SPEECH_OFF% | Przyjazny północny rybak opowiada ci historie o tym, jak plemiona przychodzą i odchodzą.%SPEECH_ON%Powiem tyle: rządzą u nas tylko silni, ale silny człowiek jest wart tyle, co jego zdrowie i kondycja. Gdy się starzeje, traci jedno i drugie. Gdy się starzeje, więc przegrywa. I tak nowy silny człowiek dochodzi do władzy, a wraz z nim pękają dzieje i sukcesy plemienia. Po części zazdroszczę południowcom poczucia większego celu i umiejętności ukrywania władzy, odkładania jej na wyciągnięcie ręki, tak by inni musieli zrobić coś więcej niż tylko wymach mieczem, by ją zdobyć. Mówię ci to szczerze i tylko tutaj, tak daleko od moich rodaków, jak to możliwe. Nigdy nie usłyszysz, żebym mówił o tym przy zwykłym ognisku, rozumiesz?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Potrzebujemy kolejnego piwa.",
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
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.SquareCoords.Y < this.World.getMapSize().Y * 0.8)
		{
			return;
		}

		this.m.Score = 15;
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

