this.kraken_cult_enter_event <- this.inherit("scripts/events/event", {
	m = {
		Replies = [],
		Results = [],
		Texts = [],
		Hides = 0,
		Dust = 0,
		IsPaid = false
	},
	function create()
	{
		this.m.ID = "event.location.kraken_cult_enter";
		this.m.Title = "Gdy się zbliżasz...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Texts.resize(4);
		this.m.Texts[0] = "A ty kim jesteś?";
		this.m.Texts[1] = "Więc co w ogóle wiesz?";
		this.m.Texts[2] = "Jesteś kompletną wariatką.";
		this.m.Texts[3] = "Więc jak mogę pomóc?";
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_120.png[/img]{Natykasz się na kobietę na bagnach, samotną, z plecakiem i sakwami z rulonami, które mogą być mapami, z sztyletem przy lewym biodrze oraz garnkami i patelniami po prawej. W pobliżu jest skopane ognisko i stos tomów wciśniętych do aksamitnego worka. Wszystko, czym jest i co ma, pokryte jest zielenią moczarów. Ona stoi i patrzy na ciebie, a ty na nią. To raczej niecodzienne, by kobieta samotnie była w bagnie. Uśmiecha się nieśmiało, z wahaniem.%SPEECH_ON%Witaj.%SPEECH_OFF%Z ręką na rękojeści miecza, lustrujesz okolicę w poszukiwaniu zasadzki. Pytasz, co tu robi, a ona mówi, że byś jej nie uwierzył. Widziałeś już dość, by uwierzyć nawet w skraj dowolnego szaleństwa, jakie mogłaby powiedzieć. Kobieta kiwa głową.%SPEECH_ON%No dobrze. Podejdź, to ci pokażę.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Rzućmy okiem.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Damy sobie radę.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsKrakenCultVisited", true);
				this.World.Flags.set("KrakenCultStage", 0);

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_120.png[/img]{Mówisz kompanii, by zachowała czujność na łajdaków ukrytych w bagnie, ale oni tylko się śmieją i mówią, że powinieneś był zajrzeć do burdelu, jeśli jesteś tak podniecony i w gorączce. Ignorując ich, ruszasz w stronę kobiety. Znajdujesz ją na kłodzie, z kapeluszem grzyba obracanym w dłoniach, i mówi dość szczerze.%SPEECH_ON%Szukam potwora i czy jest prawdziwy, czy zmyślony, dla mnie pozostaje potworem. Rozumiesz?%SPEECH_OFF%W pewnym sensie tak. Nie wszystkie potwory są prawdziwe, a taka bagienna baba może być szalona. Pytasz ją, co to za bestia. Zjada grzyba, po czym chwyta książkę i rzuca ją w twoją stronę. Kartka przytrzymana jest liściem, otwierasz na niej. Narysowano coś, co wygląda jak ośmiornica z mackami wielkości długich okrętów. Walczy z całą flotą i zdaje się nawet wygrywać. Kobieta pochyla się, jej zwiotczałe zielone dłonie zwisają jak kudzu między kolanami.%SPEECH_ON%Potwór, którego szukam, to kraken.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_120.png[/img]{Kobieta opiera się w tył. Zjada kolejnego grzyba, po czym wbija sztylet w robaka, który przebiegał po kłodzie. Bez najmniejszej przerwy zjada go z czubka ostrza i mówi, miażdżąc jego pancerzyk.%SPEECH_ON%Zwykle nie wdawałabym się w szczegóły i już machałabym tym sztyletem przy twoim fiucie, ale myślę, że chcesz pomóc. Widzę to w twoich oczach. Jesteś zabójcą, mordercą, lubieżnikiem, wielbicielem monet i szalonym skurczybykiem.%SPEECH_OFF%Połyka resztki owada i wypluwa pozostałości jak łupiny słonecznika. Kiwając głową, mówi:%SPEECH_ON%Jestem córką bogatego szlachcica, ale wyraźnie daleko mi do tamtego życia.%SPEECH_OFF%To prawda.}",
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
			Text = "[img]gfx/ui/events/event_120.png[/img]{Odwraca się do swoich tomów i wpatruje się w nie, jakby były nagrobkami.%SPEECH_ON%Mój ojciec posiada jedną z największych bibliotek w całym kraju. W jej salach odkryłam opowieści o tych właśnie bagnach. Opowieści autorów, którzy nieświadomie się powtarzali. Dziesięć lat temu. Sto. Tysiąc. Wciąż ta sama historia. Historia o ludziach przybywających tutaj i ludziach znikających. Nie szuka się rozwiązania, a odpowiedzi są niejasne. Bandyci. Choroby. Jeden uczony stwierdził po prostu, że ludzie doznali takiego zachwytu nad pięknem bagien, że postanowili tam zostać. Możesz w to uwierzyć? Piękno bagien?%SPEECH_OFF%Z uśmieszkiem mówisz, że właśnie na takie patrzysz. Śmieje się.%SPEECH_ON%Nie widziałam siebie od miesięcy, ale mówię poważnie, nieznajomy. Przeszukałam te okolice i nie znalazłam ani cholernej rzeczy.%SPEECH_OFF%Wskazuje palcem swoje księgi.%SPEECH_ON%Dwadzieścia zniknięć po nawet trzystu ludzi, opancerzonych, z końmi, jedni z karawanami, inni z chronioną szlachtą, a ja rozglądam się tutaj i nie widzę ani cholernej rzeczy.%SPEECH_OFF%Podejrzewasz, że gdybyś spieprzył i zdechł w bagnie, nikt by się tobą nie przejął, ale tyle historii jest trochę podejrzane.}}",
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
			Text = "[img]gfx/ui/events/event_120.png[/img]{Wzrusza ramionami.%SPEECH_ON%Może, ale przynajmniej nie zatrudniłam kompanii pełnej dupków.%SPEECH_OFF%Spoglądasz na %companyname%, gdzie z jednej strony obozu biją się na pięści, pośrodku ktoś wciska bagiennego węża do spodni śpiącego najemnika, a bliżej was kilku wskazuje na was oboje, łapie się za krocze i hupa w powietrze. Odwracasz się i mówisz, że nie są tacy źli. Wtedy najemnik krzyczy przez bagna.%SPEECH_ON%Powiedz jej o tym, jak wszyscy, kurwa, zginęli i zrobiliśmy cię kapitanem, bo nie było nikogo innego! Kobiety kochają bohaterstwo!%SPEECH_OFF%Uśmiechając się, powtarzasz.%SPEECH_ON%Szczerze, nie są najgorsi.%SPEECH_OFF%}",
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
			ID = "C",
			Text = "[img]gfx/ui/events/event_120.png[/img]{Kobieta grzebie w plecaku i wyciąga sygnet, jakiego nigdy wcześniej nie widziałeś. Przerzuca go do ciebie, jakby to była gówniana podróbka monety.%SPEECH_ON%Mam tego dużo więcej. No, nie tutaj dokładnie. Nie chciałabym, żeby wpadły ci do głowy pomysły rabunku i rzezi, wiesz. Ale zrób, o co proszę, a wysypię ci całą skrzynię takich na głowę.%SPEECH_OFF%Chowasz sygnet i pytasz, czego potrzebuje. Odpowiada.%SPEECH_ON%Tego jeszcze do końca nie wiem. Żeglarze mówią, że krakeny są naturalnymi wrogami wielorybów, ale cóż, w tej okolicy nie ma wielorybów, skoro jesteśmy na lądzie. Jest jednak coś podobnego. Unhold z bagien. Podejrzewam, że krakeny przez eony czasu przesunęły się w głąb lądu i żywiły się tym, co mogły, a jak kiedyś w morzach, tak i tutaj znalazły sobie wroga. Przynieś mi %hides% skór unholda, a być może zdołam wywabić bestię ze snu.%SPEECH_OFF%Ze snu? Gdzie, do diabła, miałaby w ogóle spać? Wzruszasz ramionami i uznajesz, że jeśli jest gotowa pozbyć się tak wspaniałej biżuterii, chętnie jej pomożesz.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Przyniosę ci skóry.",
					function getResult( _event )
					{
						this.World.Flags.set("KrakenCultStage", 1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}

				if (!_event.m.IsPaid)
				{
					_event.m.IsPaid = true;
					local item = this.new("scripts/items/loot/signet_ring_item");
					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_120.png[/img]{Przynosisz kobiecie skóry unholda, tylko po to, by zobaczyć, że pojawiło się więcej ludzi. Kilku mężczyzn i kobiet kręci się po okolicy, grzebie w bagnie, je grzyby. Pytają, czy jesteś tu, by pomóc znaleźć krakena. Surowo pytasz, czy oni też chcą zapłaty, bo na pewno, do cholery, nie zamierzasz dzielić się towarem. Kobieta woła do ciebie i podbiega. Przekręca głowę i wyciska bagnisty szlam z włosów, jakby to była brudna szmata.%SPEECH_ON%To są te, są!%SPEECH_OFF%Pstryka palcami i kilku pomocników zabiera skóry. Pytasz, kim do diabła są ci ludzie. Wzrusza ramionami.%SPEECH_ON%Po prostu zaczęli się pojawiać, chyba. Mówili, że gwiazdy chciały ich tutaj, a ja nie będę tego kwestionować. I nie, nie zamierzam płacić im tego, co byłam winna tobie. Oni po prostu cieszą się, że są tutaj, z dala od wszystkiego i wszystkich, z dala od wszystkiego na zawsze.%SPEECH_OFF%Unosisz brew.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Czyli umowa skończona?",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				local items = this.World.Assets.getStash().getItems();
				local num = 0;

				foreach( i, item in items )
				{
					if (item == null)
					{
						continue;
					}

					if (item.getID() == "misc.unhold_hide")
					{
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Tracisz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
						});
						items[i] = null;
						num = ++num;

						if (num >= _event.m.Hides)
						{
							break;
						}
					}
				}

				_event.m.IsPaid = false;
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_120.png[/img]{Gdy skóry zostały dostarczone, pytasz o to, co ci się należy. Przerzuca ci kolejny sygnet, jakbyś był żebrakiem, po czym macha, byś podszedł do jej ksiąg. Gdy podchodzisz, widzisz pomocników krojących skóry unholdów. Zdają się szyć z nich płaszcze. Kobieta mówi.%SPEECH_ON%Myślę, że jesteśmy bliżej przebudzenia. Pomocnicy powiedzieli, że widzieli gwiazdy, ale myślę, że to, co naprawdę widzieli, to świetliki. Czasem sama je widzę. Małe robaczki świecące w ciemności. Próbowałam kilka złapać, ale wciąż mi umykają.%SPEECH_OFF%Dobrze. Pytasz o zapłatę. Znowu. Odpowiada, otwierając stary tom i patrząc na rysunek marynarzy atakowanych przez krakena.%SPEECH_ON%Z tak wielką pomocą miałam więcej czasu, by zagłębić się w księgi, i w tym czasie zauważyłam coś. Co widzisz na tym obrazie? Przyjrzyj się uważnie.%SPEECH_OFF%Wpatrujesz się w niego, ale wzruszasz ramionami. Przeciąga palcem po szczegółach rysunku, jakby jej narracja wyrywała je na nowo.%SPEECH_ON%Światło księżyca. Ta bitwa rozegrała się w nocy. Co to tutaj, lecące nad walką? Mewy? Nie. To nietoperze. Co do diabłów robią nietoperze trzepoczące pośrodku oceanu? A tu jest ten człowiek, przy sterze statku, z długimi uszami i czarnym płaszczem. Ciekawa postać, prawda? A dalej, kilka stron niżej, zapis, cytuję: \'włóczęga, który wyrzucił nietoperze ze swego płaszcza, by zamaskować ucieczkę\'. Dość osobliwe, prawda? Myślę, że nazywano ich Nekrosawantami. Starożytnymi. I myślę, że to nie kraken ich zaatakował. Myślę, że to oni polowali na niego.%SPEECH_OFF%Wzdychając, pytasz, czego potrzebuje. Kobieta zamyka książkę z trzaskiem.%SPEECH_ON%To zależy, czy istnieją, bo własnymi oczami ich nie widziałam, ale w moich czasach widziałam szamanów i magów z ich dziwnym, błyszczącym popiołem. Może to sztuczka, a może nie. Przynieś mi %remains% kup popiołu tych nocnych ludzi, a jeszcze możemy mieć krakena.%SPEECH_OFF%Kobieta z podnieceniem upycha w usta kolejne grzyby. Przerywa, uśmiechając się czarnymi kapeluszami zamiast zębów.%SPEECH_ON%A wtedy dostaniesz swoje korony, oczywiście.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Od prochu do znalezienia prochu.",
					function getResult( _event )
					{
						this.World.Flags.set("KrakenCultStage", 2);
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}

				if (!_event.m.IsPaid)
				{
					_event.m.IsPaid = true;
					local item = this.new("scripts/items/loot/signet_ring_item");
					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_120.png[/img]{Po całym czasie spędzonym tutaj uznałeś to miejsce za coraz bardziej znajome bagno, ale mokradło nagle wydaje się obce i dziwne, jak wejście do starej sypialni, w której coś zostało przestawione.\n\nZnajdujesz kobietę stojącą w oddali, a za nią szyk jej pomocników. Wszyscy mają płaszcze ze skór unholdów. Kucają przed kulami zielonego światła, obejmując je dłońmi, a w każdym zielonkawym połysku widać skrawki uśmiechów, wargi syczące cicho w gasnącym szaleństwie. Księgi, tomy i papiery kobiety są porozrzucane dookoła. Zalega mgła, niosąc ze sobą okropny odór. Pytasz, gdzie są twoje pieniądze. Kobieta uśmiecha się, a jej oczy są zażółcone, usta wysuszone i spękane, a kawałki grzybów przylepione do policzków.%SPEECH_ON%Najemnik chce swoich koron! Tu nie ma nic poza ucieczką! Ucieczką od wszystkiego, wszędzie!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Co tu się dzieje?",
					function getResult( _event )
					{
						return "G";
					}

				},
				{
					Text = "Żądam zapłaty natychmiast.",
					function getResult( _event )
					{
						return "G";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_103.png[/img]{Patrzysz, jak jeden z pomocników nagle unosi się w powietrze, a w zielonym świetle widzisz śliską mackę ciągnącą go do tyłu, i zdaje się, jakby sama ziemia się otwierała, a tysiąc mokrych konarów i gałęzi trzaskało i kapało, a rzędy kłów sterczą, szczękając o siebie, jakby pchały się po kęs, i pomocnik zostaje wrzucony do paszczy, a dziąsła się skręcają, i zostaje rozebrany, odarty z ciała, pozbawiony kończyn i zniszczony. Kobieta przeżuwa kolejnego grzyba, a potem jej dłonie pieszczą zielone kule, i widzisz macki ślizgające się pod każdą z nich.%SPEECH_ON%Dołącz do nas, najemniku! Niech Bestia Bestii ucztuje!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Do szyku!",
					function getResult( _event )
					{
						this.World.State.getLastLocation().setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Events.showCombatDialog(true, true, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function addReplies( _to )
	{
		local n = 0;

		for( local i = 0; i < 3; i = ++i )
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
				  // [028]  OP_CLOSE          0      4    0    0
			}
		}

		if (n == 0)
		{
			_to.push({
				Text = $[stack offset 0].m.Texts[3],
				function getResult( _event )
				{
					return "C";
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
		this.m.Replies.resize(3, false);
		this.m.Results = [];
		this.m.Results.resize(3, "");

		for( local i = 0; i < 3; i = ++i )
		{
			this.m.Results[i] = "B" + i;
		}

		if (this.m.Hides == 0)
		{
			local stash = this.World.Assets.getStash().getItems();
			local hides = 0;

			foreach( item in stash )
			{
				if (item != null && item.getID() == "misc.unhold_hide")
				{
					hides = ++hides;
				}
			}

			this.m.Hides = hides + 3;
		}
		else if (this.m.Dust == 0)
		{
			local stash = this.World.Assets.getStash().getItems();
			local dust = 0;

			foreach( item in stash )
			{
				if (item != null && item.getID() == "misc.vampire_dust")
				{
					dust = ++dust;
				}
			}

			this.m.Dust = dust + 3;
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hides",
			this.m.Hides
		]);
		_vars.push([
			"remains",
			this.m.Dust
		]);
	}

	function onDetermineStartScreen()
	{
		if (!this.World.Flags.get("IsKrakenCultVisited"))
		{
			return "A";
		}
		else if (this.World.Flags.get("KrakenCultStage") == 0)
		{
			return "B";
		}
		else if (this.World.Flags.get("KrakenCultStage") == 1)
		{
			local stash = this.World.Assets.getStash().getItems();
			local hides = 0;

			foreach( item in stash )
			{
				if (item != null && item.getID() == "misc.unhold_hide")
				{
					hides = ++hides;
				}
			}

			if (hides >= this.m.Hides)
			{
				return "D";
			}
			else
			{
				return "C";
			}
		}
		else if (this.World.Flags.get("KrakenCultStage") == 2)
		{
			local stash = this.World.Assets.getStash().getItems();
			local dust = 0;

			foreach( item in stash )
			{
				if (item != null && item.getID() == "misc.vampire_dust")
				{
					dust = ++dust;
				}
			}

			if (dust >= this.m.Dust)
			{
				return "F";
			}
			else
			{
				return "E";
			}
		}
	}

	function onClear()
	{
	}

	function onSerialize( _out )
	{
		this.event.onSerialize(_out);
		_out.writeU8(this.m.Hides);
		_out.writeU8(this.m.Dust);
		_out.writeBool(this.m.IsPaid);
	}

	function onDeserialize( _in )
	{
		this.event.onDeserialize(_in);

		if (_in.getMetaData().getVersion() >= 43)
		{
			this.m.Hides = _in.readU8();
			this.m.Dust = _in.readU8();
			this.m.IsPaid = _in.readBool();
		}
	}

});

