this.dead_bodies_in_forest_event <- this.inherit("scripts/events/event", {
	m = {
		Hunter = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.dead_bodies_in_forest";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_02.png[/img] {Maszerując przez las, %randombrother% woła do kompanii. Zerkasz i widzisz, że wskazuje gdzieś za linię krzaków. Gdy do niego podchodzisz, widzisz to, co on: trzy ciała zwisające z drzewa. Ich sine twarze i szare stopy kołyszą się i obracają, wiatr czasem zmuszając je do ponurego spojrzenia na siebie nawzajem. %randombrother% zauważa, że na szyjach mają drewniane tabliczki: znaki ich zbrodni. Na jednej: \'Złodziej\'. Na drugiej: \'Dziwka\'. Na ostatniej: \'Zdrajca\'. Widząc dość, każesz ludziom ruszać dalej. | Las nie daje wytchnienia, nie ma żadnej drogi ani bocznej ścieżki, którą mógłbyś iść. Jest gęsty i nieustępliwy, jakby wcale cię tu nie chciał. Wkrótce odkrywasz, że nie chciał też kogoś innego: znajdujesz zwłoki związane w krzewie głogu, nogi wykręcone, ramiona zgięte, wszystko dość pokracznie dopasowane do rzekomego celu. Usta są rozwarte, oczy zwężone w jakimś końcowym grymasie frustracji. %randombrother% dogania cię, ogląda ciało od góry do dołu i kiwa głową.%SPEECH_ON%Ciało czyste jak łza, poza robotą kolców, rzecz jasna. Powiedziałbym, że ten człowiek był tak zagubiony, że żadne zwierzę go nie znalazło. Po prostu umarł, nieprzydatny nikomu i niczemu.%SPEECH_OFF%Wskazujesz na mrówkę bezmyślnie kręcącą się po zębach zmarłego. Brat śmieje się i kręci głową.%SPEECH_ON%Na pewno ona też nie jest zagubiona?%SPEECH_OFF% | Patrzysz w górę na korony drzew, obserwując pod jakim kątem wpadają promienie światła. Gdy się orientujesz, %randombrother% podchodzi, wyraźnie wstrząśnięty.%SPEECH_ON%Panie, powinieneś to zobaczyć.%SPEECH_OFF%Kiwasz głową i każesz mu prowadzić. Prowadzi cię na polanę, choć niewiele w niej jasnego.\n\nNogi. Nogi wszędzie. Niektóre ucięte przy kostce, inne przy udzie, i wszędzie pomiędzy. Nie mają miejsca, nie mają porządku. Leżą, czasem pojedynczo, a czasem splątane w kłębach, niektóre wbite pionowo na kijach jak chodzące żarty, a kilka wygląda, jakby ktoś wrzucił je na drzewa, gdzie bezwładnie zwisają na gałęziach albo do góry nogami. Jedna wisi na rożnie, łydka zwęglona na czarno, jakby ktoś uciekł, zostawiając ją nad dawno wygasłym ogniem.\n\nBrat, który znalazł ten obrzydliwy widok, staje obok ciebie.%SPEECH_ON%Żadnych ciał, panie. Tylko... nogi.%SPEECH_OFF%Odwracasz się do najemnika, ale on tylko wzrusza ramionami.%SPEECH_ON%Nie znaleźliśmy ani jednego ciała, panie. To znaczy, górnej połowy. Myślisz, że to coś znaczy? Kto by to zrobił? Odciąć komuś nogi, a potem zabrać resztę?%SPEECH_OFF%Kręcisz głową z niedowierzaniem. Widząc dość i nie mając odpowiedzi na takie pytania, szybko odprowadzasz resztę ludzi z polany i wracacie do marszu. | Zatrzymujesz się przy korycie strumienia, by się obmyć i napić, ale zanim weźmiesz pierwszy łyk, %randombrother% chwyta cię za ramię. Wskazuje w górę rzeki. Ciało kobiety leży twarzą w wodzie, a jej długie włosy żywo wiją się w nurcie. Dziękujesz najemnikowi, że uchronił cię przed chorobą, jaką zmarli przynoszą światu. | Korona drzew jest gęsta i poskręcana. Jakiekolwiek światło z góry ledwo się przebija, a sploty cieni otulają maszerujących ludzi. Ale dalej przed sobą widzisz słup światła wnikający w las. Naturalnie, ktoś inny zobaczył go pierwszy. I było to ostatnie, co zobaczył.\n\nW tym promieniu światła siedzi chłopiec, oparty plecami o drzewo. Jego głowa opada, a dłonie są odwrócone do góry i otwarte. Na jego dłoniach ciemnieją fioletowe plamy. %randombrother% podchodzi i od razu kręci głową.%SPEECH_ON%Trujące jagody. Cholerny dzieciak nie miał szans.%SPEECH_OFF%Odwracasz się do brata broni i pytasz, czy chłopiec mógł odejść spokojnie. Mężczyzna znów kręci głową.%SPEECH_ON%Nie.%SPEECH_OFF% | Martwe ciało. A właściwie coś, co powinno być ciałem. Klatka piersiowa jest otwarta, a wnętrzności rozłożone we wszystkie strony, szare, obwisłe i miękkie. Nie potrafisz stwierdzić, czy to był mężczyzna czy kobieta, tylko że musiał to być dorosły, rozcięty na znacznie mniejsze kawałki. Jakie stworzenie mogło dokonać tego dzieła, nie wiesz, choć %randombrother% sugeruje, że może to sprawka bardzo zdeterminowanego człowieka. | Znajdujesz ciało kobiety oparte plecami o drzewo. W jej piersi tkwi nóż, a rana jest tak szybko śmiertelna, że wygląda, jakby zmarła w trakcie jakiegoś ruchu. Nad nią z gałęzi zwisa druga kobieta. Jej ubrania są czerwone. Głowa ciała opada do przodu, jakby miała patrzeć na swoją zbrodnię, a lina, na której wisi, jęczy przy przytłumionym wietrze. | Natrafiasz na miejsce bitwy. Ludzie, zbroje, broń - nic z tego nie nadaje się do użytku. Martwi padli od jakiejś skrajnej brutalności, o której nie chcesz się dowiedzieć. Ślady stóp w ziemi sugerują, że przeszło tędy coś dużego, pozostawiając za sobą ruinę i nieszczęście oraz żadnej ochoty z twojej strony, by iść w tamtym kierunku. | Maszerując dalej, znajdujesz martwego mężczyznę z kilkoma złamanymi strzałami w plecach. Jeszcze więcej ran po wyjętych pociskach, które zabójca zdołał odzyskać w jednym kawałku. Mężczyzna miał przy sobie list miłosny, skierowany do kobiety, która - jak się okazuje - była już czyjąś. Ach, romans.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Spoczywaj w pokoju.",
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
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest)
		{
			return;
		}

		local myTile = this.World.State.getPlayer().getTile();

		foreach( s in this.World.EntityManager.getSettlements() )
		{
			if (s.getTile().getDistanceTo(myTile) <= 6)
			{
				return;
			}
		}

		this.m.Score = 10;
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

