this.goblin_city_destroyed_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.goblin_city_destroyed";
		this.m.Title = "Po bitwie";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_119.png[/img]{Gdy straż przednia goblinów zostaje pokonana, maszerujesz na miasto, by je złupić. Małe gobliny są zabijane i skalpowane lub ścinane. Kolejne pędzą wokół ciebie jak mrówki, każde niesie coś nad głową, jak ludzkie czaszki lub skarby, jeden szaleńczo biega z masztem i płonącym sztandarem, a inny tańczy z odciętą głową wilka. Twoi ludzie wywracają chaty i szopy, kopią chuderlaków, a wszystko, co jeszcze oddycha, zostaje dobite.\n\n Starożytna twierdza, którą gobliny uczyniły sercem miasta, przyciąga wzrok grabieżcy. Wchodzisz do środka i znajdujesz ślepego goblina czołgającego się z wieńcem ludzkich kości udowych na szyi. Zielonoskóry skwierczy i skrzeczy w twoją stronę, bez wątpienia wyczuwając twoją obecność, choć bolesny grymas na jego twarzy oznacza, że czuje też zagładę swojego ludu. Rozpruwasz goblina i zostawiasz go na kamiennej posadzce, by wykrwawił się na śmierć. Twoi najemnicy pędzą dalej, wpadają do sali narad pełnej starszyzny i wyrzynają ich w morderczym szale, od którego latają kończyny, rozpryskują się palce, a krew bryzga po ścianach i stołach.\n\n Wychodzisz na dziedziniec. Tutaj znajdujesz stos martwych ludzi, niektórych okaleczonych, innych zwęglonych, jednego wypchanego pochodnią, jakby jego klatka piersiowa była paleniskiem. Za zwłokami dostrzegasz zagrody wilczych jeźdźców. Każesz spalić klatki z wilkami i wrzucić ich treserów w ogień, by zginęli razem z nimi. Jeden z wilków wyrywa się i pędzi głębiej w miasto z płomienną peleryną zamiast futra. Biega od chaty do chaty, ujadając i wyjąć w rozpaczliwej nadziei. Patrzysz, jak płomienie szybko trawią strzechy i słomiane szopy. Zanim ty sam zostaniesz pochłonięty przez ogniste piekło, każesz ludziom się wycofać i oglądasz, jak całe miejsce płonie do gołej ziemi. Gdy z dzikusami już się rozprawiono, spisujesz łupy.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Kto to jest?",
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
			Text = "[img]gfx/ui/events/event_119.png[/img]{Gdy liczysz łupy, pojawia się nieznajomy, który ułożył całą strategię rzezi goblinów. Nie widać nawet koloru jego skóry, tak jest oblepiony goblińskimi wnętrznościami i krwią. W dłoni trzyma kilka skalpów i worek, z którego wystają uszy i nosy, a z dołu kapie krew. Kiwa głową.%SPEECH_ON%Wszystko dobrze, wędrowcze, wszystko dobrze. Spisaliśmy się.%SPEECH_OFF%Pytasz, czy to on podpalił miasto. Kiwa głową.%SPEECH_ON%Goblini ustawiają tylną straż w labiryntach murów i kopalń. Zaryglowałem ich ucieczki, by zamknąć ludność między dwoma murami, zamknąłem wyjście, zamknąłem wejście i podpaliłem wszystko. Zginęli szybko. Widzę, że i wam się powiodło. Możesz zatrzymać łupy. Nie mam z nich pożytku.%SPEECH_OFF%Odwraca się i odchodzi. Wołasz do niego, do tego osobliwego wojownika, pytając, ile by chciał za dołączenie do kompanii. Tym razem się odwraca.%SPEECH_ON%Heh, heh, haha, hahaha! Wędrowcze! Ten żart, ach. Komedia. Zachwycające. Naprawdę. Ale moja praca nie ustanie, dopóki każdy goblin nie zostanie zniszczony.%SPEECH_OFF%Słusznie, cel człowieka jest jego własny. Ale ciekawość cię zżera. Pytasz, ile takich miast jeszcze jest.%SPEECH_ON%Dwadzieścia trzy, och, przepraszam, pytałeś, ile jest ich łącznie? Dwadzieścia trzy zniszczyłem, ale wciąż istnieją, ach, dwa, trzy, hmm. Strzelam cztery tysiące. Dobrych podróży, wędrowcze.%SPEECH_OFF%Tym razem odchodzi na dobre. Spoglądasz na %companyname%. Rzadko się zgadzają: żałują, że to usłyszeli.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tak mało, co?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsGoblinCityDestroyed", true);
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

