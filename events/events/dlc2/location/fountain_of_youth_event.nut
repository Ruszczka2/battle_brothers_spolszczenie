this.fountain_of_youth_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.fountain_of_youth";
		this.m.Title = "Gdy się zbliżasz...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_114.png[/img]{Stoisz na skraju leśnej polany, a widok w środku zapiera dech.\n\n Z ziemi wyrasta pień ludzkiego ciała, niczym smukłe drzewo, nagi i kolczasty, z gęsią skórką zamiast kory, rosnący w górę, aż jest dwukrotnie wyższy od ciebie. Nie ma gałęzi. Nie ma dłoni. Zamiast tego jest wiązka ludzkich głów tam, gdzie powinna być korona drzewa. Od lewej do prawej są dziecięce i pięknie obecne, niejednoznacznie płciowe, zniekształcone twory czasu, gdzie cienie, które same tworzą, zmieniają ich twarze z dziwnie znajomych na osobliwie naiwne, gdy patrzą dookoła, jakby nie wiedziały, jak się tu znalazły, i jakby były gotowe zapytać o to ciebie. Przypomina ci to topielca, na którego kiedyś trafiłeś, twarz wykręconą pod bieżącą wodą rzeki, ciało cierpiące nieustannym domysłem, co je tam umieściło.\n\n Szepty przesiewają się z drzew. Przesuwają się po ziemi, jakby mówiły je owady, i wspinają się po twoich ramionach, aż drapią cię po samych uszach. Proszą, byś został.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zobaczmy, co to jest.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Musimy się stąd wynosić. Szybko.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

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
			Text = "[img]gfx/ui/events/event_114.png[/img]{Gdy wchodzisz na polanę, to dziwaczne stworzenie prostuje się, kołysząc głowami na boki jak paw szykujący pokaz. Przemawiają do ciebie.%SPEECH_ON%Starszy. Tak. Tu. Tak. On. My. Znamy. Go. Znaliśmy.%SPEECH_OFF%Twarze wypaczają się i przebarwiają, jakby słowa, które opuszczają ich usta, zostawiały skazę. Powoli formują się na nowo, by znów mówić, groteskowy wachlarz akcentuje się po jednej głowie naraz.%SPEECH_ON%Pij. Mało. Ulecz. Wszystko. Pij. Wszystko. Stań. Się. Jednym.%SPEECH_OFF%Patrzysz w dół i widzisz ziemny nawis wyginający się nad kałużą wielkości talerza. Z nawisu kapie ledwy strużka wody, a skąd ona pochodzi, nie wiadomo. Spoglądasz w górę i widzisz twarze patrzące w dół, ich wyrazy przechodzą od udręki przez radość, zaskoczenie, strach po dezorientację.%SPEECH_ON%Znajomy. Zawsze. Znajomy. Pij. Mało. Tak. Nie. Pij. Wszystko.%SPEECH_OFF%Patrząc znów w dół, wyciągasz bukłak i wyciągasz korek.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wypiję tylko trochę.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Wypiję wszystko!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_114.png[/img]{Kucasz pod groteskowym drzewem. Głowy kołyszą się w dół, a cień przychodzi wraz z nimi, jakby ktoś nakładał pokrywę na kosz. Gdy spoglądasz w górę, wpatrują się z odległości stopy, falując i nieustannie się poruszając. Jednak jedna, na samym końcu, jest zupełnie nieruchoma. Jej twarz utknęła w grymasie starego człowieka, z pomarszczonym czołem, napiętymi policzkami, starczymi liniami wciąż wyrytymi, jakby wściekłość składała się sama w sobie jak doskonale wykuty miecz. Otacza ją bańka ciemności, półcień pulsuje, jakby głowa spoglądała z zupełnie innego świata.\n\n Z pewnym chwytem bierzesz bukłak i wylewasz jego zawartość. Pusty, wsuwasz go pod kapiący nawis i słuchasz, jak każda kropla uderza o dno. Twarze pochylają się coraz bliżej, otaczając cię w stożku chaosu. Gdy się zbliżają, słyszysz rozdarcie ich rzeczywistości, gdy wchodzą w formę i z niej wypadają. Bukłak drży w twojej dłoni, jakbyś musiał go trzymać przeciw naporowi wodospadu. Wyrywasz go spod nawisu i gdy wywracasz się do tyłu, uświadamiasz sobie, że głowy dawno już stanęły pionowo. Przewracasz się, z trudem wstajesz i wybiegasz z polany. Gdy spoglądasz wstecz, stworzenia już nie ma. Nie ma nic. Żadnego drzewa. Żadnej fontanny. Bukłak jednak pozostaje.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Lepiej trzymać to w bezpiecznym miejscu.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().die();
						}

						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.getStash().makeEmptySlots(1);
				local item;
				item = this.new("scripts/items/special/fountain_of_youth_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_114.png[/img]{Odrzucasz bukłak i wkładasz usta do kałuży, pijąc. Świat pod powierzchnią kałuży jest pusty i cichy. Wargi się poruszają, gardło łyka, ale nie ma tu nic do picia. Krzyczysz. Nie ma nic. Nawet uczucia. Tylko pojęcie strachu, swędzenie bez możliwości podrapania. Gdy opierasz dłonie o ziemię, by się wydostać, odkrywasz, że nie możesz opuścić kałuży.\n\n Blade twarze migoczą w pustce. Są jak te z drzewa, dramatycznie nieruchome, boleśnie wyłonione z przeszłości, teraźniejszości i przyszłości, i tu nadchodzą, gromadząc się w liczbie, bulgocząc i napierając, zamieniając to czarne piekło w spienioną biel. Gdy się zbliżają, uświadamiasz sobie, że patrzyłeś źle. Pojedynczo są tylko twarzami bez obecności. Wzięte razem, jako wielka biała płachta nadchodząca, uświadamiasz sobie, że tworzą jedną wielką twarz: twoją. I ona się śmieje.\n\n Krzycząc, w końcu wypadniesz z kałuży. %randombrother% trzyma cię pod ramieniem i patrzy na ciebie z troską.%SPEECH_ON%Panie, wszystko w porządku? Przysypiałeś, a potem głowa wślizgnęła ci się do tej wody.%SPEECH_OFF%Spoglądasz w górę, spodziewając się zobaczyć groteskowe drzewo i jego straszne twarze. Nie ma go, i bez względu na to, ile razy i w ilu miejscach szukasz, już nigdy się nie pojawia.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ja... nie... rozumiem.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().die();
						}

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

