this.orc_land_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.orc_land";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 16.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Kopiec z niezwykłą czaszką na szczycie. Być może pomnik wielkiego orczego wojownika. Nieważne, co znaczy to dla zielonoskórych, dla ciebie sprawa jest prosta: jesteście teraz na ich terytorium. | Natrafiacie na drewniany totem z wyciętymi krzywiznami. %randombrother% uważa, że to ślady nocnego nieba, może tej czy innej konstelacji.\n\n%randombrother2% pluje i mówi, że to znaczy tylko tyle, iż jesteście na orczym terytorium i lepiej zwracać na to większą uwagę niż na to, co robią światła na niebie. | Znajdujesz kości w trawie. Krzywizna żeber jest obleśna - stanowczo za duża jak na człowieka. Zastanawiasz się, czy to nie osioł, ale odkrycie ogromnej, dziwnie ludzkiej czaszki potwierdza podejrzenia: weszliście na teren orków. | Ludzkie głowy na palach. Ich ciała - bez kończyn - zbite w sterty. Zostali pocięci i okaleczeni. Jedynym śladem człowieczeństwa są strzępy ubrań ledwie trzymające się zniszczonego ciała.\n\n%randombrother% podchodzi, kiwając głową.%SPEECH_ON%Wdepnęliśmy w gówno. To terytorium orków.%SPEECH_OFF% | Natrafiasz na ciało mężczyzny, ale bez głowy. Ta zniknęła. Jego genitalia też. I stopy oraz dłonie. Z tego, co zostało, sterczą oszczepy - ktoś albo coś zamienił resztki w ohydny cel treningowy.\n\n Przyglądając się broniom, %randombrother% kiwa głową i odwraca się do ciebie.%SPEECH_ON%Orki, panie. Jesteśmy teraz na ich ziemiach i, eee, ewidentnie nie lubią intruzów.%SPEECH_OFF% | Znajdujesz roztrzaskaną czaszkę przybitą do drzewa ogromną siekierą. Została głównie klatka piersiowa, bo reszta dawno się rozpadła. Na pniu drzewa wyryto długie, zakrzywione wzory.%SPEECH_ON%To terytorium zielonoskórych.%SPEECH_OFF%%randombrother% mówi, gdy podchodzi do ciebie. Dotyka rękojeści siekiery, jej ciężar prawie dorównuje solidności drzewa, w które jest wbita.%SPEECH_ON%Wygląda na orcze terytorium...%SPEECH_OFF% | Trafiasz na stos kamieni starannie ułożonych na niewielkim pagórku. Oglądając je, znajdujesz białe rzeźbienia na skałach. Każde opowiada inną historię - o wielkich bydlakach wędrujących i wyrządzających niepokojąco dużo przemocy mniejszym, chudszym patyczkom. %randombrother% śmieje się z rysunków.%SPEECH_ON%To orcza sztuka - o ile tak w ogóle można to nazwać. W razie gdybyś się zastanawiał, my jesteśmy tymi małymi ludzikami na obrazkach.%SPEECH_OFF% | Na wzgórzu trzepocze skórzana płachta zawieszona na kijach. Widać ślady opuszczonego obozu - tlące się ognisko, ulotne ślady stóp, kilka dziwnych odpadków. %randombrother% wskazuje na to wszystko.%SPEECH_ON%Ich zapach wciąż się tego trzyma. Zapach... orków.%SPEECH_OFF%%randombrother2% odchrząkuje i pluje.%SPEECH_ON%Masz dobry nos do gówna, panie.%SPEECH_OFF%%randombrother% kiwa głową.%SPEECH_ON%To nie bzdura. Jesteśmy na orczym terytorium, ludzie.%SPEECH_OFF% | %randombrother% podchodzi do stosu ludzkich czaszek, na który natrafiliście. Analizuje śmiertelne rany - głównie fakt, że ich ciał nigdzie nie widać, dekapitacja to coś, co trudno przeżyć. Wstaje i kiwa głową.%SPEECH_ON%Orcza sztuka, chłopaki. Studiujcie ją uważnie, żebyście nie dołączyli do galerii.%SPEECH_OFF%Ty też kiwasz głową i każesz ludziom uważać na niebezpieczeństwa przed nami. | Dzicz ma swój nastrój, cywilizacja ma swój - a to, co macie tutaj, nie pasuje do żadnego. Masz dziwne wrażenie, jakbyście właśnie wtargnęli na cudze terytorium. Ohydny stos trupów pozbawionych resztek człowieczeństwa tylko pomaga to rozróżnić i rozstrzyga prosty fakt: weszliście na orcze ziemie.}",
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
		if (this.World.getPlayerRoster().getSize() < 2)
		{
			return;
		}

		local myTile = this.World.State.getPlayer().getTile();
		local settlements = this.World.EntityManager.getSettlements();

		foreach( s in settlements )
		{
			if (s.getTile().getDistanceTo(myTile) <= 10)
			{
				return;
			}
		}

		local orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getSettlements();
		local num = 0;

		foreach( s in orcs )
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

