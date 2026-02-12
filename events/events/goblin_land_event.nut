this.goblin_land_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.goblin_land";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 16.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Znajdujesz martwego goblina. Ale to nie zwykły goblin - to starszy. Widać oznaki śmierci ze starości. Wokół leżą też ceremonialne drobiazgi. Ten goblin nie trafił tu przypadkiem: umarł i otrzymał należyty pochówek. To oznacza tylko jedno: jesteś na terytorium tych przeklętych zielonoskórych. | Natrafiasz na martwego psa na zboczu. Język mu zwisa, oczy prawie wyskakują z czaszki. W jego sierści tkwi kilka strzałek. %randombrother% wyciąga jedną i przygląda się woskowanym grotom.%SPEECH_ON%Goblini jad.%SPEECH_OFF%Pytasz, czemu pies. Mężczyzna wzrusza ramionami.%SPEECH_ON%Przestraszony pies to dobra tarcza do ćwiczeń, jak sądzę.%SPEECH_OFF% | Wianek z dziwnych i przebarwionych kwiatów, chwastów i gałęzi. Wśród nich dziesiątki dużych chrząszczy grzechoczą, gdy ich pancerze stukają o siebie. Wygląda na to, że żerują na soku lub innej osobliwości sączącej się z tej roślinnej kompozycji. %randombrother% głośno się zastanawia.%SPEECH_ON%Chyba już coś takiego widziałem. To jakiś znak.%SPEECH_OFF%Spoglądasz na niego.%SPEECH_ON%Mamy wypatrywać znudzonych panien?%SPEECH_OFF%Mężczyzna kręci głową.%SPEECH_ON%Nie. To dzieło goblinów. Jesteśmy na ich ziemi.%SPEECH_OFF% | Maszerując przez te tereny, natrafiasz na martwego orka. Wygląda niemal na nietkniętego, jakbyś znalazł go śpiącego. Ale gdy przyglądasz się bliżej, dostrzegasz niemal tuzin małych strzałek tkwiących w jego boku. Natychmiast rozglądasz się po okolicy, po czym zwracasz się do swoich ludzi.%SPEECH_ON%Stąpajcie ostrożnie, jesteśmy na terytorium goblinów.%SPEECH_OFF% | Znajdujesz kilka kamieni ułożonych w krąg. Pośrodku tej osobliwości leży ludzka czaszka z odciętą górą. W czaszce znajdują się coś, co wygląda na kości do gry i kości kurczaków. Takie szamanistyczne znaki nie biorą się znikąd - jesteś na ziemiach goblinów. | Natrafiasz na martwego jelenia uwięzionego w przerażającej pułapce. Miałaby wszystkie cechy zwykłej pułapki - takiej, która zabija kolcami - gdyby nie oczywiste zatrute groty, w które była wyposażona. Jad wyjątkowy dla jednego tylko plemienia: goblinów. Od teraz lepiej stąpać ostrożnie. | Tli się ogień. Kije i kamienie ułożone tu i ówdzie. Jedna stojąca zbrojownia z dmuchawkami. Zakrzywione ostrza. I jeden martwy wilczy szczeniak z obrożą na szyi. Po obejrzeniu tych dowodów szybko informujesz ludzi o sytuacji.%SPEECH_ON%To terytorium goblinów, ludzie, i patrząc na to, nie są daleko.%SPEECH_OFF% | Miot martwych wilczych szczeniąt. Ich matka leży obok, z rozprutym brzuchem i obrożą na szyi. Od miejsca ciągnie się ślad krwi, a w trawie widać drobne ślady stóp.%SPEECH_ON%Goblini znów zdobyli swoje wierzchowce.%SPEECH_OFF%%randombrother% stoi obok ciebie. Wskazuje na szczenięta.%SPEECH_ON%Mówią, że gobliny lubią dzikie. Szukają najświeższych miotów i biorą tylko najsilniejsze.%SPEECH_OFF%Wszystko, co słyszysz, to fakt, że jesteście na terytorium goblinów. Radzisz ludziom bacznie obserwować otoczenie, by te przebiegłe gnidy nie zaskoczyły was znienacka.} ",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Miejcie się na baczności.",
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
		local myTile = this.World.State.getPlayer().getTile();
		local settlements = this.World.EntityManager.getSettlements();

		foreach( s in settlements )
		{
			if (s.getTile().getDistanceTo(myTile) <= 10)
			{
				return;
			}
		}

		local goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getSettlements();
		local num = 0;

		foreach( s in goblins )
		{
			if (s.getTile().getDistanceTo(myTile) <= 8)
			{
				num = ++num;
			}
		}

		if (num == 0)
		{
			return;
		}

		this.m.Score = 20 * num;
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

