this.greenskins_investigation_event <- this.inherit("scripts/events/event", {
	m = {
		Noble = null,
		NobleHouse = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_investigation";
		this.m.Title = "W %town%...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_31.png[/img]Gdy uzupełniasz zapasy i dajesz ludziom odpocząć, pan zamku, %nobleman%, wzywa cię. Mówi, że w zamku błąka się goblin i chce, byś go wytropił.%SPEECH_ON%Zapytałbym moich ludzi, ale nie znaleźliby własnych dup, nawet gdyby zjedli sobie oczy i wysrali je na wierzch.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Przeszukamy spiżarnię.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "B1";
						}
						else
						{
							return "B2";
						}
					}

				},
				{
					Text = "Przeszukamy korytarze.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "E1";
						}
						else
						{
							return "E2";
						}
					}

				},
				{
					Text = "Przeszukamy zbrojownię.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "H1";
						}
						else
						{
							return "H2";
						}
					}

				},
				{
					Text = "Nie mamy czasu na przysługi.",
					function getResult( _event )
					{
						_event.m.NobleHouse.addPlayerRelation(-5.0, "Denied " + _event.m.Noble.getName() + " a favor");
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Noble.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B1",
			Text = "[img]gfx/ui/events/event_31.png[/img]Przeszukujesz spiżarnię, otwierając drzwi do półek pełnych żywności: od serów, przez solone mięsa, po warzywa wiszące na hakach. Wiklinowe gąsiory kuszą, ale gdy wyciągasz rękę po łyk, w polu widzenia przemyka kształt. Odwracasz się z ostrzem w dłoni i przebijasz goblina w chwili, gdy rzuca się na ciebie z rozbitą butelką. Ginie natychmiast i robi niezły bałagan na podłodze, niszcząc parę worków mąki. Po zabiciu zielonoskórego spokojnie wleczesz go do %nobleman%. Szlachcic opiera dłonie na biodrach.%SPEECH_ON%Bardzo imponujące, najemniku, ale musiałeś ciągnąć go aż tutaj? Moi służący będą szorować podłogę tygodniami!%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "To było łatwe.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Noble.getImagePath());
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Did a favor for " + _event.m.Noble.getName());
				local food = this.new("scripts/items/supplies/wine_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Zyskujesz Wino"
				});
			}

		});
		this.m.Screens.push({
			ID = "B2",
			Text = "[img]gfx/ui/events/event_31.png[/img]Schodzisz do spiżarni i otwierasz drzwi. W środku znajdujesz półki pełne jedzenia i towarów. W kącie akurat stoi też mężczyzna i kobieta, którzy ostro się bzyknęli. Zawyli jak dwa szczeniaki i zakryli się, mężczyzna używając mokrego worka mąki, a kobieta ustawiając się sprytnie za półką z melonami. Mężczyzna odchrząkuje.%SPEECH_ON%Proszę, panie, nie mów %nobleman%.%SPEECH_OFF%Nie miałeś pojęcia, że to żona szlachcica, ale teraz dobrze o tym wiedzieć. Mężczyzna proponuje układ.%SPEECH_ON%Słuchaj, jestem tylko stajennym. Nie mogę ci dać złota ani nic takiego, ale sławny kopijnik zatrzymuje się tu na tydzień i mogę ci zwędzić jego tarczę. To piękna rzecz i pokochasz ją, obiecuję. Proszę tylko, żebyś nie mówił panu!%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Twój pan się o tym dowie.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Twój sekret jest u mnie bezpieczny.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_31.png[/img]To wydaje się tak dobrym momentem, jak każdy inny, by zbudować stałe relacje z %townname%, a najlepszym sposobem na to jest całkowite zniszczenie relacji, na którą się natknąłeś. Wracasz do komnaty %nobleman% i zdajesz raport. Jego twarz czerwienieje, a knykcie stają się kredowobiałe.%SPEECH_ON%Tak myślałem. Tak myślałem. Do cholery, tak myślałem! Ale stajenny? Nie pozwolę, by mnie tak znieważono!%SPEECH_OFF%Pstryka palcami na strażników.%SPEECH_ON%Przynieście mi szczypce i palenisko kowalskie. Zabierzcie moją 'żonę' do wieży. Zajmę się nią później. A tobie, najemniku, dziękuję za przekazanie mi tej wieści. Co do goblina, został znaleziony i się nim zajęto. Nie musisz się tym więcej przejmować.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Prawdziwie dzika blokada uciech.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Noble.getImagePath());
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Did a favor for " + _event.m.Noble.getName());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_31.png[/img]Postanawiasz nie mówić szlachcicowi o tym, co wyprawia jego żona. Para gołąbków ubiera się i szybko ucieka ze spiżarni, a stajenny zatrzymuje się, by powiedzieć, że tarcza będzie gotowa, gdy będziesz opuszczał zamek. Tymczasem zgłaszasz się do pana, który powstrzymuje cię gestem.%SPEECH_ON%Ach, nie musisz się już tym martwić, najemniku. Goblin został znaleziony w stajniach. Jeden z koni kopnął go na wylot przez stodołę! Będę musiał nagrodzić stajennego za wojownicze umiejętności jego rumaków!%SPEECH_OFF%Hmm, oczywiście.\n\n Gdy opuszczasz zamek, stajenny czeka z podejrzanie tarczowatym workiem w dłoniach.%SPEECH_ON%Proszę, weź to. Pośpiesz się. I jeszcze raz dzięki, najemniku.%SPEECH_OFF%Mówisz mu, że od teraz najlepiej, by trzymał to w spodniach. Kręci głową.%SPEECH_ON%Nie. Warto. Do zobaczenia, najemniku.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Niektórzy mężczyźni nigdy się nie uczą.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.World.Assets.addMoralReputation(-1);
				local item = this.new("scripts/items/shields/faction_heater_shield");
				item.setFaction(_event.m.NobleHouse.getBanner());
				item.setVariant(2);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "E1",
			Text = "[img]gfx/ui/events/event_31.png[/img]Przeszukujesz korytarze, by sprawdzić, czy mały zielony szkrab kręci się w pobliżu. Idąc korytarzem, słyszysz krzyk dwóch kobiet z pobliskiego pokoju. Dobywasz miecza i wpadasz do środka. Skryba i skarbnik stoją na biurku, a mały goblin podskakuje, próbując dźgnąć ich w kostki. Wchodzisz spokojnie i przebijasz zielonoskórego przez pierś, unosząc go jak nabitego na rożen wiewióra. Mężczyźni uspokajają się i dziękują za pomoc. Kiwasz głową.%SPEECH_ON%Kiedy tylko zechcecie, panie.%SPEECH_OFF%Odchrząkują i uśmiechają się nerwowo. Wracasz do %nobleman% po zapłatę.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "To było łatwe.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Noble.getImagePath());
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Did a favor for " + _event.m.Noble.getName());
				this.World.Assets.addMoney(100);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Zarabiasz [color=" + this.Const.UI.Color.PositiveEventValue + "]100[/color] Koron"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "E2",
			Text = "[img]gfx/ui/events/event_31.png[/img]Uznajesz, że korytarze są równie dobrym miejscem na rozpoczęcie poszukiwań. Po kilku zakrętach słyszysz niepokojący hałas dochodzący ze skarbca. Dobywasz ostrza, podchodzisz do drzwi i napierasz na nie barkiem, celując bronią we wszystko, co może stać po drugiej stronie. Zamiast goblina znajdujesz młodego i starszego mężczyznę, którzy podskakują ze strachu, każdy ze spuścionymi spodniami, a na biurku stoi beczułka z rozchlapaną maślanką, o którą się opierali. W pokoju śmierdzi... okropnie.\n\n Ubierając się, młodszy mówi, że jest skarbnikiem, a starszy informuje, że jest skrybą. Skarbnik szybko oferuje ci sporą sumę, byś milczał o tych delikatnych sprawach. Śmiejesz się.%SPEECH_ON%Nie dam się na to nabrać. Jeśli wezmę te monety, pobiegniesz do pana i powiesz mu, że je ukradłem, prawda? Jaki lepszy sposób na ochronę siebie niż dopilnowanie mojej egzekucji?%SPEECH_OFF%Skarbnik się cofa, a skryba robi krok naprzód. To starszy mężczyzna, który pachnie dupą i woskiem świec.%SPEECH_ON%W moim skarbcu mam wiele rzeczy, które należą do mnie, nie do mojego pana. Te przedmioty mogą cię bardzo zainteresować. Eliksiry, napitki, dobra, z których wojownik taki jak ty mógłby skorzystać. I... i dorzucę psa bojowego! Lokalny psiarz jest mi winien przysługę, a teraz to równie dobry czas, by się o nią upomnieć!%SPEECH_OFF%Skryba śmieje się nerwowo, gdy rozważasz pomysł. Gdybyś ich wydał, nie wiadomo, co by się stało. Sodomici ci nie przeszkadzają, ale w całym królestwie są panowie, którzy uważają takie praktyki za odrażające. Jeśli %nobleman% jest takim człowiekiem, możesz zyskać przychylność, 'wykorzeniając' tych mężczyzn.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Pan zamku zdecyduje o waszym losie.",
					function getResult( _event )
					{
						return "F";
					}

				},
				{
					Text = "Twój sekret jest u mnie bezpieczny.",
					function getResult( _event )
					{
						return "G";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_31.png[/img]Zamykasz drzwi składziku i spieszysz do %nobleman%. Wyjaśniasz mu, co widziałeś. Gdy kończysz, oznajmia, że goblin został znaleziony tonący w strumieniu ścieków i wybawiono go od męki.%SPEECH_ON%Co do sodomitów, tak, i co z tego? Rozejrzałeś się? Fort to bezsensowne miejsce dla męskich żądz. Wszędzie dyndające fiuty i nigdzie, by je włożyć. Czy mi się to podoba? Nie, oczywiście, że nie. Absolutnie obrzydliwe, doprawdy. Ale gdybym karał każdy taki przypadek, zostałbym z bandą strachów na wróble i zwierząt gospodarskich, a co do tych drugich nie mam nawet pewności.%SPEECH_OFF%Machnięciem ręki odprawia cię.%SPEECH_ON%Goblinem się zajęto, najemniku, niewiele mam już ci do powiedzenia. Jednak jeśli możesz, poinformuj służbę, że pokój, w którym ich znalazłeś, wymaga sprzątania. Nie mam ochoty przeglądać podatków w smrodzie gówna.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Och.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Noble.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_31.png[/img]Postanawiasz zachować ich sekret, licząc na to, że skryba da ci to, co obiecał. Starzec kiwa głową, gdy odchodzisz.%SPEECH_ON%Znajdę cię na dziedzińcu, najemniku, ze wszystkim, co ci się należy. Twoje milczenie w tej sprawie bardzo doceniam.%SPEECH_OFF%Gdy wracasz do %nobleman%, wyjaśnia, że goblin został znaleziony i się nim zajęto. Ponieważ nie byłeś za to odpowiedzialny, odsyła cię bez zapłaty.\n\n Na zewnątrz skryba faktycznie cię spotyka. W jednej ręce ma smycz, w drugiej worek. Podaje ci oba.%SPEECH_ON%Jeszcze raz dziękuję, najemniku.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Powinienem poznać więcej sekretów.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				local item;
				item = this.new("scripts/items/accessory/poison_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				item = this.new("scripts/items/accessory/antidote_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				item = this.new("scripts/items/accessory/berserker_mushrooms_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				item = this.new("scripts/items/accessory/wardog_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "H1",
			Text = "[img]gfx/ui/events/event_31.png[/img]Gdybyś był goblinem w zamku pełnym ludzi, którzy chcą cię zabić, dokąd byś poszedł? Wcielając się w umysł szkraba, dochodzisz do wniosku, że zbrojownia to równie dobre miejsce, by rozpocząć poszukiwania. Kiedy tam docierasz, rzeczywiście widzisz ucznia stojącego na zewnątrz i próbującego przytrzymać drzwi zamknięte. Krzyczy, że goblin jest w środku i już zabił kowala. Dobywając ostrza, każesz uczniowi odsunąć się.\n\n Gdy tylko to robi, drzwi wybuchają, a goblin, wyglądający jak strach na wróble zbudowany z połamanych wiader, chwiejnie wychodzi, opancerzony od stóp do głów, z tarczą i włócznią niezgrabnie ustawionymi z przodu. Ignorując absurd tego widoku, przebijasz się przez cały ten złom i przebijasz czaszkę bestii, natychmiast ją zabijając. Gdy wyciągasz miecz, cały pancerz i broń opadają, jakbyś właśnie zabił zjawę, która je podtrzymywała.\n\n Uczeń szybko ściska ci dłoń, po czym pada na kolana, płacząc po stracie kowala. Nie ma czasu na łzy, zabierasz głowę goblina i wracasz do %nobleman% po zapłatę.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "To było łatwe.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Noble.getImagePath());
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Did a favor for " + _event.m.Noble.getName());
				this.World.Assets.addMoney(100);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Zarabiasz [color=" + this.Const.UI.Color.PositiveEventValue + "]100[/color] Koron"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "H2",
			Text = "[img]gfx/ui/events/event_31.png[/img]Cóż, gdybyś był małym karzełkiem w wrogiej twierdzy, pierwszym miejscem, do którego byś poszedł, byłaby zbrojownia. Kiedy tam docierasz, nie znajdujesz żadnego goblina, lecz chłopaka wyciągającego sztylet z mężczyzny leżącego twarzą do ziemi. Morderca upuszcza broń i unosi ręce.%SPEECH_ON%Nie miałem wyboru! Żadnego!%SPEECH_OFF%Pytasz chłopaka, kim on jest i kim jest martwy mężczyzna. Szybko wyjaśnia.%SPEECH_ON%Jestem uczniem, a to... był kowal. I to musiało się stać. Musiało! Nie masz pojęcia, jakie okropności ten człowiek mi robił! Za każdym razem, gdy się pomyliłem, karał mnie jakbym był kretynem, który zabił króla! Widzisz to?%SPEECH_OFF%Odgarnia włosy, odsłaniając wypukłe blizny po oparzeniach. Odsuwając włosy, unosi dłoń z groteskowym małym palcem zgiętym pod kątem prostym oraz drugą dłoń bez małego palca. Zaczyna zdejmować but, ale go zatrzymujesz, rozumiejąc aluzję. Uczeń splata dłonie, a mały palec wystaje jak u wyniosłego możnowładcy popijającego wino.%SPEECH_ON%Szukasz goblina, prawda? Po prostu powiedz im, że to goblin to zrobił! Ja... słuchaj, nie jestem wielkim płatnerzem, ale potrafię kuć miecze jak nikt inny i wykupię dla ciebie absolutnie najlepsze, na jakie mnie stać. Zachowaj tylko ten sekret między nami, o to proszę.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Taka zbrodnia nie może ujść bezkarnie!",
					function getResult( _event )
					{
						return "I";
					}

				},
				{
					Text = "Twój sekret jest u mnie bezpieczny.",
					function getResult( _event )
					{
						return "J";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_31.png[/img]Zamykasz drzwi i je ryglujesz, upewniając się, że morderca nie zdoła uciec. Gdy uczeń krzyczy i wali w drzwi, wracasz do szlachcica.\n\n %nobleman% słucha twojej relacji i kiwa głową.%SPEECH_ON%Mhm, tak. Kowal nie był pierwszym, który zginął z ręki tego chłopaka - mieliśmy tu serię morderstw, ale nigdy nie mogliśmy znaleźć sprawcy. Wielu podejrzewało jego z powodu tego, jak tłukł sobie dłonie młotami i przypalał twarz pochodnią. Stajenny nawet widział, jak odciął fiuta szczurze. To był niespokojny człowiek, ale teraz dałeś nam ostateczny dowód jego czynów. Dobra robota, najemniku! Goblin, którego szukałeś, już został zlikwidowany, ale to... to jest o wiele lepsze niż polowanie na jakiegoś zielonoskórego. Uznaj swoją zapłatę za podwojoną!%SPEECH_OFF%Szlachcic pstryka palcami do skryby i zaczyna wydawać rozkazy, najwyraźniej wystawiając wyrok śmierci. Opisuje logistykę z niewiarygodną dokładnością: konie, liny, ostrza, szczypce, rozżarzone ognie, litanię okropności, by znudzeni żołnierze mieli rozrywkę przez wiele godzin.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Bardzo dobrze.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Noble.getImagePath());
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Did a favor for " + _event.m.Noble.getName());
				this.World.Assets.addMoney(200);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Zarabiasz [color=" + this.Const.UI.Color.PositiveEventValue + "]200[/color] Koron"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "J",
			Text = "[img]gfx/ui/events/event_31.png[/img]Zamykasz drzwi i je ryglujesz, upewniając się, że morderca nie zdoła uciec. Gdy uczeń krzyczy i wali w drzwi, wracasz do szlachcica.\n\n %nobleman% słucha twojej relacji i kiwa głową.%SPEECH_ON%Mhm, tak. Kowal nie był pierwszym, który zginął z ręki tego chłopaka - mieliśmy tu serię morderstw, ale nigdy nie mogliśmy znaleźć sprawcy. Wielu podejrzewało jego z powodu tego, jak tłukł sobie dłonie młotami i przypalał twarz pochodnią. Stajenny nawet widział, jak odciął fiuta szczurze. To był niespokojny człowiek, ale teraz dałeś nam ostateczny dowód jego czynów. Dobra robota, najemniku! Goblin, którego szukałeś, już został zlikwidowany, ale to... to jest o wiele lepsze niż polowanie na jakiegoś zielonoskórego. Uznaj swoją zapłatę za podwojoną!%SPEECH_OFF%Szlachcic pstryka palcami do skryby i zaczyna wydawać rozkazy, najwyraźniej wystawiając wyrok śmierci. Opisuje logistykę z niewiarygodną dokładnością: konie, liny, ostrza, szczypce, rozżarzone ognie, litanię okropności, by znudzeni żołnierze mieli rozrywkę przez wiele godzin.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Bardzo dobrze.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				local item = this.new("scripts/items/weapons/arming_sword");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isGreenskinInvasion())
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local bestTown;

		foreach( t in towns )
		{
			if (!t.isAlliedWithPlayer())
			{
				continue;
			}

			if (!t.isMilitary() || t.isSouthern() || t.getSize() < 2)
			{
				continue;
			}

			local d = playerTile.getDistanceTo(t.getTile());

			if (d <= 4)
			{
				bestTown = t;
				break;
			}
		}

		if (bestTown == null)
		{
			return;
		}

		this.m.NobleHouse = bestTown.getOwner();
		this.m.Noble = this.m.NobleHouse.getRandomCharacter();
		this.m.Town = bestTown;
		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noblehouse",
			this.m.NobleHouse.getName()
		]);
		_vars.push([
			"nobleman",
			this.m.Noble.getName()
		]);
		_vars.push([
			"town",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.NobleHouse = null;
		this.m.Noble = null;
		this.m.Town = null;
	}

});

