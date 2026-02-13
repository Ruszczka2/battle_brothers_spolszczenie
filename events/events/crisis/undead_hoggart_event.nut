this.undead_hoggart_event <- this.inherit("scripts/events/event", {
	m = {
		Witchhunter = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.crisis.undead_hoggart";
		this.m.Title = "Wzdłuż drogi...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_76.png[/img]Maszerując w mglistym, gorącym deszczu, dostrzegasz postać stojącą pośrodku ścieżki. Trzyma pochodnię oplecioną metalem, bez wątpienia ogień człowieka, który chce być widziany. Gdy się zbliżasz, odkłada pochodnię, oświetlając dziwnie znajomą twarz, choć nie potrafisz wskazać skąd. Każesz mu się przedstawić.%SPEECH_ON%Jesteście najemnikami, hm?%SPEECH_OFF%Mówisz mu, że to nie imię. Odchrząkuje, a delikatny pomarańczowy blask jego twarzy przebija się przez mrok burzy.%SPEECH_ON%Nazywam się Barnabas. Jesteście najemnikami czy nie?%SPEECH_OFF%Ostrożnie przechodzisz przez ścieżkę i podchodzisz do mężczyzny. Odsuwa pochodnię na bok.%SPEECH_ON%Tak, tak myślałem. Mój brat, potrzebuję kogoś... to znaczy, nie mogę...%SPEECH_OFF%Kiwasz głową i mówisz za niego.%SPEECH_ON%Wyszedł z grobu i teraz chcesz, żeby ktoś się nim zajął.%SPEECH_OFF%Mężczyzna kiwa głową, macha pochodnią w stronę miejsca, gdzie w oddali pali się nikłe światło.%SPEECH_ON%Jest tam. Zapłacę wam %reward% koron, skoro jesteście najemnikami i w ogóle.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze, prowadź.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "To nie nasz problem.",
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
			Text = "[img]gfx/ui/events/event_76.png[/img]Mówisz mężczyźnie, by prowadził, zabierając ze sobą %chosenbrother% i zostawiając innego najemnika na czele podczas waszej nieobecności. Barnabas prowadzi cię w dół zbocza do ogrodzenia posesji z dość dużym kamiennym domem. Poza oknami migocze światło świec. Barnabas wpatruje się przed siebie.%SPEECH_ON%Nikogo tam nie ma. Jest tylko Hoggart.%SPEECH_OFF%To imię... twarz Barnabasa... Chwytasz mężczyznę i wciskasz go w płot, żądając, by powiedział, czy jest bratem bandyty. Barnabas szybko kiwa głową.%SPEECH_ON%Tak, jestem! A co z tego?%SPEECH_OFF%Mówisz mu, że Hoggart niemal wytępił %companyname% i że w odwecie zabiłeś go na dobre. Barnabas unosi dłonie.%SPEECH_ON%Jeśli tak było, to tak było. Hoggart robił tylko to, co musiał, by utrzymać majątek w rodzinie. Po śmierci ojca wpadliśmy w długi - długi, których nie mogliśmy spłacić.%SPEECH_OFF%Wyciągasz sztylet i przykładasz go do gardła mężczyzny. Kręci głową.%SPEECH_ON%Nie jestem tu, by zrobić zasadzkę albo was okraść. Dom został sprzedany. Nie jest już w rodzinie. Ale Hoggart... on wrócił i nie chce odejść.%SPEECH_OFF%Spoglądasz przez ramię Barnabasa. Przed domem stoi ciemna postać, której sylwetkę oświetla blask z okien.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze. Rzućmy okiem.",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Zakończę to tutaj.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "To już nie nasz problem.",
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
			Text = "[img]gfx/ui/events/event_76.png[/img]Więzów krwi nie zrywa się łatwo. Cokolwiek mówi Barnabas, jest prawdopodobne, że pewnego dnia przyjdzie po kompanię, któregoś dnia, gdy będzie zimno i cicho, a ognia zemsty nie da się tak łatwo ugasić.\n\n Mówisz mężczyźnie, by prowadził, i w chwili gdy się odwraca, dźgasz go tuż pod pachą, przebijając serce. Nie mówi nic. Po prostu pada na kolana, zwrócony ku plecom brata i domowi, w którym dorastał. Siedzi tam, zgięty i umierający, deszcz uderza o pochodnię, aż ta syczy i gaśnie. %chosenbrother% spluwa.%SPEECH_ON%Dobra decyzja, panie.%SPEECH_OFF%Przeszukuje ciało i znajduje lśniący sztylet. Może to narzędzie zabójcy, a może ostatnia pamiątka po martwym rodzie. Tak czy inaczej, zabierasz go i wracasz do %companyname%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I po sprawie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				local item = this.new("scripts/items/weapons/named/named_dagger");
				item.m.Name = "Barnabas\' Dagger";
				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_76.png[/img]To nie twój problem i nigdy nie powinien nim być. Hoggart nie żyje i to wszystko, co musisz lub chcesz wiedzieć o nim i jego rodzie. Zostawiasz Barnabasa na deszczu i wracasz do %companyname%, by planować następną wyprawę.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mamy dość problemów z nieumarłymi.",
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
			ID = "E",
			Text = "[img]gfx/ui/events/event_76.png[/img]Wbrew lepszemu osądowi podchodzisz sprawdzić, czy to naprawdę Hoggart. Gdy maszerujesz w jego stronę, warczy i spogląda przez ramię. To istotnie Hoggart, ale poza warczeniem niewiele robi, po czym znów wpatruje się w dom. Dobywasz miecza i podchodzisz ostrożnie. Z bliska widzisz, że głowa mężczyzny została przyszyta do cudzego ciała, być może rycerskiego, sądząc po pancerzu, który nosi.\n\n Dość jednak zwlekania. Cofasz miecz i opuszczasz go na Hoggarta, by zadać ostateczny cios - ale blada, niebieska dłoń wyskakuje, zatrzymując ostrze, jakbyś uderzył w kamienną płytę. Powoli obraca się widmowa twarz, niezależna od Hoggarta, i patrzy na ciebie. Zawyła, po czym znika z powrotem w użyczonym ciele martwego.\n\n Barnabas stoi obok ciebie.%SPEECH_ON%Gdybym mógł to zrobić tak łatwo, zrobiłbym to sam.%SPEECH_OFF%Wygląda na to, że działa tu potężna, złośliwa siła. Musisz znaleźć inne rozwiązanie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Musimy spalić dom.",
					function getResult( _event )
					{
						return "F";
					}

				},
				{
					Text = "%chosenbrother%, odciągnij widmo!",
					function getResult( _event )
					{
						return "G";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Witchhunter != null)
				{
					this.Options.push({
						Text = "Sprowadźmy %witchhunter%. Złe duchy to jego specjalność.",
						function getResult( _event )
						{
							return "H";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_76.png[/img]Hoggart wyciąga dłoń w stronę swojego domu, próbując chwycić go z daleka. Jego warczenie przechodzi w ciche jęki. Zniekształcony, wysuszony język toczy kilka słów.%SPEECH_ON%Nasz... nasz... zawsze...%SPEECH_OFF%Spoglądasz na dom, potem na %chosenbrother%. Kiwając głową, przyznaje, że dom trzeba oczyścić. Zabierasz się do podpalenia wnętrza, wrzucając pochodnie przez okna i podpalając strzechę. Nawet w deszczu łapie ogień. Hoggart warczy, jego ciało rzuca się do przodu, ramiona wyciągnięte, dłonie sięgają jak najdalej. Widmo wyłania się z jego barków, jego przezroczyste ręce chwytają Hoggarta za głowę i próbują go powstrzymać. Martwy mężczyzna warczy i próbuje biec naprzód, głowa rozdziera szwy. Krzyczy.%SPEECH_ON%NASZ! TAK BARDZO SIĘ STARAŁEM!%SPEECH_OFF%Szwy puszczają, a ciało koziołkuje do tyłu, głowa rozrywa się i wpada w błoto. Niebieskie widmo, wyrwane z szyi, krzyczy i wzbija się w nocne niebo, ledwie migocząc na tle deszczu, aż znika.\n\n Barnabas idzie i siada obok Hoggarta, oczy martwego mężczyzny patrzą tępo na inferno pożerające dom ich dzieciństwa. %chosenbrother% zabiera zbroję z ciała, na którym spoczywała głowa Hoggarta. Próbujesz porozmawiać z Barnabasem, ale on odmawia. Rozumiejąc, nie naciskasz i odchodzisz, pozostawiając za sobą miejsce, a ognie wciąż nieustępliwie walczą z deszczem, gdy odchodzisz.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "No to po wszystkim.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/armor/named/black_leather_armor");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_76.png[/img]Szepczesz %chosenbrother%, by zaatakował Hoggarta, ale tylko po to, by odciągnąć widmo zamieszkujące jego ciało. Najemnik kiwa głową i natychmiast zabiera się do pracy, dobywa broni i szarżuje. Jak można się spodziewać, niebieskie ramię wyskakuje, krzyżując swój niezawodny, choć przezroczysty kształt z bronią %chosenbrother%. Spogląda na zwarcie i krzyczy.%SPEECH_ON%Teraz!%SPEECH_OFF%Skaczesz do przodu i zamachujesz się mieczem. Widmo obraca się, krzycząc, ale jest już za późno. Ostrze przechodzi przez szyję Hoggarta, odcinając głowę szybkim cięciem, a czaszka stacza się po piersi do błota, podczas gdy ciało miota się do tyłu. Wypchnięte na świat samodzielnie, widmo wrzeszczy i wiruje na niebie, znajdując tylko chaos w nowo zdobytej wolności. %chosenbrother% spogląda na napierśnik, który był na ciele Hoggarta, i kręci głową. Cholerstwo pękło.\n\n Nagle przez podwórze nadchodzi grupa mężczyzn, trzymając pochodnie i miecze. Prowadzi ich szczególnie wystawny jegomość.%SPEECH_ON%To ty, Barnabasie? Myślałem, że powiedziałem ci, żebyś nigdy więcej nie postawił stopy na mojej ziemi!%SPEECH_OFF%Wyjaśniasz im, co się stało. Mężczyzna, najwyraźniej nabywca ziemi, kiwa głową, mówiąc, że przyprowadził ze sobą kleryka, by rozwiązać sprawę, ale skoro już to zrobiłeś, płaci ci solidną sumę koron. Gdy odwracasz się z powrotem, Barnabas i głowa Hoggarta zniknęli.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To był szybki kontrakt.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(300);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]300[/color] Koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_76.png[/img]%chosenbrother% mówi, że %witchhunter% pewnie wie, co tu zrobić. Zgadzasz się i biegniesz po łowcę czarownic. Po powrocie ocenia sytuację i sięga po grubą księgę ukrytą w kieszeni. Kiwając głową, mamrocze do siebie, czytając. W końcu pstryka palcami.%SPEECH_ON%To jest Gespenst von Zwei, nawiedzenie dwóch dusz. W tym przypadku Hoggarta i mężczyzny, którego ciało nosi teraz jego głowę. Jedna bezwzględnie wypędzona dusza jest prosta, ale dwie połączone tworzą złośliwą i gniewną siłę. Jeśli po prostu zniszczymy ciało albo głowę, dusze zwiążą się ze sobą i będą nawiedzać te ziemie na zawsze. Niektóre nawet błądzą w niebo. Niestety, zamiast znaleźć niebiosa, znajdują piekło niekończącego się zamętu i wściekłości, która z niego płynie. Wierzę, że dusza Hoggarta, albo to, co wiąże go z tym światem, jest silniejsze niż dusza drugiego człowieka. Zmaganie, jakie miał w życiu, było zbyt wielkie, by zakończyć się po prostu ostatnim oddechem, i dlatego stoi przy swoim starym domu.%SPEECH_OFF%Przerywasz łowcy czarownic i zadajesz najważniejsze pytanie...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jak go powstrzymać?",
					function getResult( _event )
					{
						return "I";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Witchhunter.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_76.png[/img]%witchhunter% wymusza uśmiech.%SPEECH_ON%Przeproś go.%SPEECH_OFF%Niepewny, czy dobrze go usłyszałeś, powtarzasz jego słowa, a łowca czarownic kiwa głową.%SPEECH_ON%Tak, przeproś. I to szczerze. Wielu ludzi jest tak pełnych nienawiści albo tak pełnych pragnień, że każda porażka kontekstualizuje się jako energia poza śmiertelną powłoką. To ty zabiłeś tego człowieka. To ty wywróciłeś życie, które nie znosiło nawet najdrobniejszej pauzy, a tym bardziej ostatecznej klęski, jaką jest śmierć. To ty możesz teraz zakończyć jego walkę. Wierzę, że przeprosiny to uczynią.%SPEECH_OFF%Barnabas podchodzi i znów wyjaśnia, że Hoggart działał tylko po to, by utrzymać posiadłość w rodzinie. Wszystko, co robił, robił dla rodziny. Nie był zły ani okrutny, robił tylko to, co uważał za słuszne. %witchhunter% wyrzuca rękę, jakby mówił: 'widzisz'.%SPEECH_ON%No i masz. Kapitanie, posłuchaj. Jakikolwiek spór był między wami, jest skończony. To coś innego. Nikt nie zasługuje na taki los. Przeproś go z serca, a zakończysz jego cierpienie raz na zawsze.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze. No to spróbujmy",
					function getResult( _event )
					{
						return "J";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Witchhunter.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "J",
			Text = "[img]gfx/ui/events/event_76.png[/img]Robisz krok w stronę Hoggarta. Warczy i przez chwilę mierzy cię wzrokiem, po czym znów wpatruje się w dom. Kolejny ostrożny krok i stajesz przed nim. Jego oszklone, wyschnięte oczy wpatrują się w ciebie, ale tym razem nie odwraca wzroku. Mówisz.%SPEECH_ON%Hoggart...%SPEECH_OFF%Nieumarły odchyla się, jego oczy zwężają się z niedowierzaniem, dłoń dotyka piersi. Jego głos zdaje się rozwijać, napięty z głębin pożyczonego ciała.%SPEECH_ON%Ho...ggart... Ja... próbowałem...%SPEECH_OFF%Kiwasz głową, wtykając kciuki za pas.%SPEECH_ON%Wiem, że próbowałeś. To znaczy, nie wiedziałem, że w ogóle próbowałeś, ale teraz wiem. Słuchaj, twój brat powiedział mi wszystko. Gdybym wiedział, nie wziąłbym tego kontraktu. Ty nie...%SPEECH_OFF%Spoglądasz na %witchhunter%, który kiwa głową. Kontynuujesz.%SPEECH_ON%Hoggart, nie zasłużyłeś na śmierć. Nie taką. Gdybym był na twoim miejscu, robiłbym to samo. Ale nie byłem na twoim miejscu. Nie mogłem zrozumieć, kim jesteś i co robisz. Robiłem tylko to, za co mi płacono. Nie mogę cofnąć tego, co się stało, mogę tylko powiedzieć... przepraszam. Nie zasługujesz na ten ból i jest mi przykro.%SPEECH_OFF%Oszklone, opadające oczy Hoggarta patrzą na ciebie jeszcze chwilę, po czym jego ciało chwieje się i pada do przodu. Wyłaniają się dwa duchy, jeden skręca i pędzi przez zabłocony teren, zraszając kamienie łzami swojego niebieskiego widma, gdy pędzi prosto ku horyzontowi. Drugi duch pozostaje, teraz świecąc delikatnym złotem, i po prostu unosi się w stronę domu. Barnabas idzie za nim, a ty za Barnabasem. Razem obchodzicie róg i kierujecie się na tył posesji, gdzie duch Hoggarta zatrzymuje się.%SPEECH_ON%Wszystko, co zrobiłem, dla tego. Już nie moje. Twoje.%SPEECH_OFF%Duch znika, gdy Barnabas wyciąga do niego rękę, a lśniący pył odpływa spod jego dotyku. Zauważasz, że ziemia jest tu rozkopana, a skrzynia zapada się w deszczowej wodzie. Wyciągasz ją i otwierasz, znajdując ogromny miecz z ozdobami rodowego imienia Hoggarta. Barnabas wygląda na równie zszokowanego jak ty.%SPEECH_ON%Rodowa pamiątka. Mówił, że nigdy jej nie sprzeda, by ratować posiadłość, uważał, że jedno bez drugiego nie ma sensu. Kiedy powiedziałem mu, że trzeba to zrobić, zabrał ją do miasta, a potem wrócił i powiedział, że przegrał ją w hazardzie... Nigdy więcej z nim nie rozmawiałem. Ostatnie, co mu powiedziałem, to że jest nic nie wartym włóczęgą i najgorszym bratem, jakiego można mieć. Teraz znam prawdę. Przyniosłeś mnie i mojemu bratu spokój, najemniku, i to jedyny spokój, jaki chcę pamiętać. Proszę, jak mówił mój brat, weź rodową pamiątkę.%SPEECH_OFF%Bierzesz miecz i życzysz Barnabasowi wszystkiego dobrego. Ostatni raz widzisz go, jak siedzi w błocie, zgarbiony, chwiejąc się i płacząc wśród deszczu, aż nie ma już człowieka, tylko ciepły dom i burza dudniąca złotym piorunem.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Spoczywaj w pokoju, Hoggart.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(1);
				this.Characters.push(_event.m.Witchhunter.getImagePath());
				local item = this.new("scripts/items/weapons/named/named_greatsword");
				item.m.Name = "Hoggart\'s Heirloom";
				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isUndeadScourge())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		if (!this.World.Flags.get("IsHoggartDead") == true)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_witchhunter = [];
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.witchhunter")
			{
				candidates_witchhunter.push(bro);
			}
			else
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		if (candidates_witchhunter.len() != 0)
		{
			this.m.Witchhunter = candidates_witchhunter[this.Math.rand(0, candidates_witchhunter.len() - 1)];
		}

		this.m.Other = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"chosenbrother",
			this.m.Other.getName()
		]);
		_vars.push([
			"witchhunter",
			this.m.Witchhunter != null ? this.m.Witchhunter.getName() : ""
		]);
		_vars.push([
			"reward",
			"300"
		]);
	}

	function onClear()
	{
		this.m.Witchhunter = null;
		this.m.Other = null;
	}

});

