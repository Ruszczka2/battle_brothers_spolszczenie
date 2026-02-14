this.witchhut_destroyed_event <- this.inherit("scripts/events/event", {
	m = {
		Replies = [],
		Results = [],
		Texts = []
	},
	function create()
	{
		this.m.ID = "event.location.witchhut_destroyed";
		this.m.Title = "Po bitwie";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Texts.resize(7);
		this.m.Texts[0] = "Kim jesteś?";
		this.m.Texts[1] = "Skąd wiesz, kim jestem?";
		this.m.Texts[2] = "Kim byli starożytni?";
		this.m.Texts[3] = "Czym jest Davkul?";
		this.m.Texts[4] = "Czy zielonoskórzy byli ludźmi?";
		this.m.Texts[5] = "Czemu nazwałaś mnie Fałszywym Królem?";
		this.m.Texts[6] = "O czym śnię?";
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Ostatnia z wiedźm zostaje zabita, a ty na wszelki wypadek każesz zmasakrować ich zwłoki. Uszy. Wargi. Nosy. Palce u stóp. Wszystko odcięte. Ich torby zostają opróżnione, a przedmioty rozgniecione na proszek i pokryte pyłem. Mięsiste kawałki lub zwierzęce części lądują na stosie i od razu idą z dymem. Gdy ogień rośnie, heksa z chaty zdaje się pojawiać znikąd i chwyta cię za ramię. Twoi ludzie dobywają mieczy, ale unosisz dłoń. Mówisz im, by dalej solili ziemię, że tak powiem, a wchodząc do chaty, oglądasz się i widzisz, jak kilku ludzi sika na żary ognia.\n\n Wewnątrz chaty siadasz tam, gdzie wcześniej. Na stole znajdujesz coś zawiniętego w chustkę, a wiedźma chwyta jej róg i toczy go między palcem a kciukiem. Podnosi wzrok, wysuwa brodę i obraca dłonie wnętrzem do góry.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B0",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Wiedźma uśmiecha się.%SPEECH_ON%Stara jędza w leśnej chacie. Reszta to pogłoski.%SPEECH_OFF%Patrzysz na nią dostatecznie długo, by zrozumieć, że dalsze drążenie tego pytania niewiele da.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[0] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B1",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Wpatruje się w zawinięty przedmiot.%SPEECH_ON%Nawet nie znam twojego imienia, najemniku, i nie mam najmniejszej chęci, by zacząć się tym przejmować. Nie chodzi o to, kim jesteś, lecz czym jesteś.%SPEECH_OFF%Obraca dłonie, jakby podążały za melodią.%SPEECH_ON%Krew starożytnych tkwi w tobie. Tkwi w nas wszystkich, ale w tobie szczególnie, cóż.%SPEECH_OFF%Jej nos marszczy się, gdy parska, a gdy wydycha powietrze, szaleńczo się uśmiecha.%SPEECH_ON%To wciąż tam jest. A jeśli ja to czuję, to cały świat to czuje.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[1] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B2",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Stuka w chustkę, a to, co jest pod nią, stuka w stół. Odpowiada.%SPEECH_ON%Starożytni byli ludźmi sprzed naszego czasu. Naprawdę, naprawdę sprzed naszego czasu. Wyobraź sobie królestwo, a teraz wyobraź sobie królestwo, które rządziło królestwami. Imperium, dokładnie tak. A teraz wyobraź sobie imperium, które rządziło imperiami. Taka niewyobrażalna moc zostawia światu wielką zemstę i spędzi swoje konające dni na niszczeniu tych, którzy je zniszczyli.%SPEECH_OFF%Pytasz, czy imperium jest martwe. Wiedźma uśmiecha się.%SPEECH_ON%Podejrzewam, że nie, ale naprawdę nie wiem.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[2] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B3",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Wzruszając ramionami i odchylając się, heksa prosi, byś powtórzył imię. \'Davkul.\' Kręci głową.%SPEECH_ON%Nie słyszałam nic o tym Davkulu. Domniemany bóg, mówisz? Cóż, do mnie nie przemówił.%SPEECH_OFF%Patrzysz na nią i próbujesz wydobyć z jej oczu ukrytą prawdę, ale wydaje się szczera w swojej odpowiedzi, więc zmieniasz temat.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[3] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B4",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Heksa rechocze.%SPEECH_ON%Chciałabym! Widziałeś, co orki mają między nogami? Nie miałabym nic przeciwko przejażdżce na tym, gdybym wiedziała, że nie rozerwie mnie na pół i nie zafarkuje jednego końca, nosząc drugi jak rękawicę!%SPEECH_OFF%Unosisz brew i kiwasz głową, jakbyś mówił \'oczywiście\'.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[4] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B5",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Po raz pierwszy na fasadzie wiedźmy pojawia się pęknięcie. Zaciska usta.%SPEECH_ON%Kiedy cię tak nazwałam?%SPEECH_OFF%Wskazujesz na drzwi, a potem na stół. Odpowiadasz.%SPEECH_ON%Wszedłem tutaj, a ty powiedziałaś, że będę szukał prawdy, że wiesz, o czym śni Fałszywy Król.%SPEECH_OFF%Heksa bezmyślnie stuka w chustkę. Unosi wzrok.%SPEECH_ON%W takim razie przyjmij moje przeprosiny, najemniku, niczego takiego nie pamiętam. Jestem tylko kruchą i starą kobietą, starszą, niż wyglądam, i nie mówię tego z przekąsem.%SPEECH_OFF%Naciskasz ją w tej sprawie, ale ona tylko coraz bardziej cię zbywa.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[5] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "Dream",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Heksa pochyla się. Kładzie dłonie na twojej twarzy i czujesz, jak skórzaste palce głęboko wciskają się w twoje policzki jak pół tuzina orzechów włoskich. Pocierają kąciki oczu i stukają w skronie. Przez cały czas się uśmiecha, po czym cofa ręce.%SPEECH_ON%Chodzisz do szlachty i bogatych, a oni płacą ci złoto, a w zamian ryzykujesz życiem i kończynami, mordujesz, zabijasz i rżniesz wszystko, co tylko możesz, i tak dzień po dniu zastanawiasz się, czy do tego tylko się nadajesz, a potem możni zamykają przed tobą drzwi i twoimi czynami, a ty słyszysz, jak w środku bawią się w najlepsze, muzyka gra, kobiety się śmieją, błazny żartują, festyny są huczne, a ty stoisz na zewnątrz z sakiewką złota i krwawym pokwitowaniem, i idziesz do karczmy, kupujesz sobie dziwkę i rzucasz monetę minstrelowi za pieśń, i możesz poczuć smak dobrego wina nawet w najtańszych piwnicach, ale nie ma ucieczki od tego okropnego uczucia z tyłu głowy, uczucia, że urodziłeś się w gorączce, a cała ta przemoc i śmierć nie jest środkiem do celu, lecz celem samym w sobie. To jest tym, czym jesteś, i tym, czym zawsze będziesz.%SPEECH_OFF%Przerywa. Wzdycha. Kontynuuje.%SPEECH_ON%Najemniku, moc kłamstwa dorównuje jedynie pragnieniu, by w nie wierzyć. Żyjesz potężnym kłamstwem, a taka moc nie odejdzie łatwo. Błagam cię, bądź tylko tym, co potrafisz zrozumieć.%SPEECH_OFF%Nie ty, nie twoje uzbrojenie ani sama obecność twojej kompanii wzbudziły w niej strach, lecz jedynie świt jakiegoś nieznanego olśnienia, gdy teraz do ciebie mówi.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Kim jestem?!",
					function getResult( _event )
					{
						return "WhoAmI";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "WhoAmI",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Wstajesz, krzycząc do kobiety o odpowiedzi. Ona policzkuje cię, a ty sztywniejesz i cofasz się o krok. Kropla krwi spływa po twoim policzku i łapiesz ją w mankiecie. Wiedźma chwyta chustkę i zrzuca ją, odsłaniając obsydianowe ostrze. Jest ostrzejsze niż pamiętasz, a wyrazisty skrawek ciebie biegnie wzdłuż krawędzi, jakbyś uchylił drzwi ku lustru. Heksa siada z powrotem i przesuwa broń po stole.%SPEECH_ON%Koniec pytań, najemniku. Tyle wiem, i tyle musisz wiedzieć. Zawarliśmy umowę i to jej koniec.%SPEECH_OFF%Biorąc sztylet, pytasz, co z nim zrobiła, ale ona odmawia odpowiedzi. Potem pytasz, czy są gdzieś inne takie jak ona. Uśmiecha się figlarnie.%SPEECH_ON%Oby nie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To koniec, więc się oddalę.",
					function getResult( _event )
					{
						return "Leave";
					}

				},
				{
					Text = "Spełniłaś swoje zadanie. Giń, wiedźmo!",
					function getResult( _event )
					{
						return "Kill";
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/weapons/legendary/obsidian_dagger");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Leave",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Żegnasz się z wiedźmą, a ona nie mówi już nic. Na zewnątrz ludzie pytają, co powiedziała, podczas gdy inni nawiązują do seksualnych wybryków. Wydaje ci się, że się uśmiechasz, ale naprawdę nie wiesz. Rozmowa zostawiła cię w mgle i z tej mgły opierasz się tylko na tym, co znasz: rozkazujesz kompanii wrócić na drogę.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Czas ruszać.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsWitchhutLeft", true);
			}

		});
		this.m.Screens.push({
			ID = "Kill",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Wiedźma splata palce i kiwa głową. Ty kiwasz w odpowiedzi. A potem chwytasz obsydianowy sztylet i wbijasz go w jej pierś. Krwawi jak każdy mężczyzna czy kobieta, których znasz. Kaszle i dławi się krwią jak każda żywa istota, którą znasz. I cofa się, z oczami szeroko otwartymi ze strachu, jak wielu, których znałeś wcześniej. Wyrywasz sztylet i kopiesz ją. Zaczyna wyć, a jej dłonie sięgają, ściągając pięściami łapacze snów i pajęczyny, a łokieć uderza w deskę z drewnianymi sztućcami i przybory rozsypują się po całej chacie z głuchym stukotem. Słabe palce zaciskają się na tępym nożu do masła, jej oczy przebijają twoje. Kaszle raz, drugi. Upuszcza nóż do masła, by uderzać pięścią w pierś, a strumień krwi bryzga na jej podbródek. Podnosi wzrok.%SPEECH_ON%Mieliśmy umowę, najemniku.%SPEECH_OFF%Chowasz sztylet i kiwasz głową.%SPEECH_ON%Ano, miałaś umowę z najemnikiem i dostałaś, czego chciałaś. Ja? Miałem umowę ze światem, żeby pozbyć się ciebie i twojego pomiotu w całości. Miła rozmowa i dobrego życia.%SPEECH_OFF%Bulgotając, głowa heksy opada na podłogę, a jej ciało wiotczeje. Gdy wychodzisz na zewnątrz, kompania pyta, co się stało. Każesz im spalić chatę i szykować się do drogi.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Czas ruszać.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsWitchhutKilled", true);
			}

		});
	}

	function addReplies( _to )
	{
		local n = 0;

		for( local i = 0; i < 6; i = ++i )
		{
			if (!this.m.Replies[i])
			{
				local result = this.m.Results[i];
				_to.push({
					Text = this.m.Texts[i],
					function getResult( _event )
					{
						return result;
					}

				});
				n = ++n;

				if (n >= 4)
				{
					break;
				}

				  // [034]  OP_CLOSE          0      4    0    0
			}
		}

		if (n == 0)
		{
			_to.push({
				Text = this.m.Texts[6],
				function getResult( _event )
				{
					return "Dream";
				}

			});
		}
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
		this.m.Replies = [];
		this.m.Replies.resize(6, false);
		this.m.Results = [];
		this.m.Results.resize(6, "");

		for( local i = 0; i < 6; i = ++i )
		{
			this.m.Results[i] = "B" + i;
		}
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

