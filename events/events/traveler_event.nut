this.traveler_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.traveler";
		this.m.Title = "Przy drodze...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Zauważasz w oddali wędrowca, kołyszącego się naprzód, zgarbionego i nucącego niczym bezskrzydły gargulec. Jego laska podryguje i stuka przed nim, a nawet z daleka słyszysz chrzęst i stuk kamieni. Rozkazujesz ludziom wstrzymać się i czekać, pozwalając nieznajomemu podejść.\n\nGdy w końcu się zbliża, spogląda w górę. Najpierw widzisz tylko jego nos, resztę skrywa płaszcz. Węszy ostrożnie niczym ślepy kret, który natrafił na osobliwą przeszkodę. Gdy już masz zapytać, czy wszystko w porządku, odrzuca płaszcz i odsłania się. To zmęczona postać. Utyka. Bezsenne dni wyżłobiły zmarszczki wokół oczu. Zaczerwienione policzki rozciągają się w uśmiechu. Pyta, czy mógłby przez jakiś czas zostać z twoją kompanią. | Wędrowiec wita twoją kompanię z pobocza. Mówi, że zmierza do %randomtown%, ale nie pogardziłby odpoczynkiem. Następne pytanie jest oczywiste: czy mógłby spędzić noc z waszą kompanią. | Wędrowiec prowadzący wózek z dobytkiem kieruje się w waszą stronę. Pozwalasz mu podejść, unosisz dłoń, by ostrzec, że ma nie iść dalej. Oświadcza, że jest tylko prostym włóczęgą i chce dotrzeć do %randomtown%. Najpierw pokazuje, że jest całkiem nieuzbrojony, a potem pyta, czy może spędzić noc z waszą kompanią. | Gwizdzący mężczyzna człapie drogą, wesoły pies sapie u jego boku z językiem na wierzchu. Widząc wasz oddział, wbija laskę w ziemię i opiera na niej dłonie. Zamieniacie kilka słów o pogodzie, zwłaszcza o tym, że w nadciągających chmurach siedzi deszcz. Pyta, czy mógłby przeczekać deszcz w towarzystwie najemników. Dziwna prośba, rzadko kierowana do ludzi, którzy zarabiają krwią. | Mężczyzna idzie drogą z łopatą kołyszącą się na jednym ramieniu i workiem ziemi w drugiej dłoni. Gdy pytasz, co robi, mówi, że właśnie pochował brata i wraca do %randomtown%. Worek zawiera trochę ziemi z miejsca, gdzie spoczął jego krewny. Godne. Mężczyzna wygląda na zmęczonego, tak jak zmęczony bywa ktoś, kto pochował rodzeństwo. Być może czując twój współczujący wzrok, pyta, czy mógłby przez jakiś czas zostać z twoją kompanią. | Dostrzegasz dziwnego mężczyznę kuśtykającego drogą. Ubrany jest w długi płaszcz, a na jednym ramieniu ma przewieszony tłumok. Jego oczy wpatrują się w ziemię, aż dochodzą do twoich stóp, wtedy w końcu podnosi wzrok. Widząc twoją kompanię, jest zaskakująco spokojny. Właściwie wydaje się zadowolony z waszej obecności i pyta, czy mógłby spędzić noc z najemnikami, zanim ruszy dalej do %randomtown%. | Mężczyzna z widłami przechodzi przez pole, gdzie plony zawiodły. Jego stopy szurają po martwej ziemi, a ty widzisz kępki popiołu unoszące się z wiatrem. Gdy dociera do drogi, zatrzymujesz go i pytasz, skąd idzie. To parobek dzienny, który tylko próbuje wrócić do domu. Cała praca w okolicy wyschła, dosłownie. Oblizując spękane usta, zastanawia się, czy mógłby spędzić noc z waszą kompanią. Wygląda, jakby rzeczywiście potrzebował odpoczynku. | Mężczyzna niosący wiadro narzędzi krzyżuje drogę z twoją kompanią. Drogi nie sprzyjają temu, by jeden człowiek stawał przeciw kompanii najemników, a ten nieznajomy właściwie ocenia sytuację, odkładając towar i unosząc ręce.\n\nMówisz mu, żeby się uspokoił, i pytasz, dokąd idzie. Wyjaśnia, że jest murarzem z %randomtown%, ale jego praca tam się skończyła. Wraca do rodziny mieszkającej na gospodarstwie oddalonym o dobry dzień drogi stąd. Wyglądając na spragnionego i zmęczonego, pyta, czy mógłby spędzić noc z waszą kompanią, by nabrać sił przed dalszą drogą. | Na horyzoncie pojawia się postać, rozmyta i migocząca w gorącym powietrzu. Wygląda na to, że się zatrzymała, bez wątpienia również was dostrzegła. Bez większego strachu ruszasz z ludźmi dalej i wkrótce spotykasz mężczyznę niosącego kilka toreb z różnymi rzeczami. Siedzi na ziemi i nie zamierza wstawać, gdy się zbliżasz. Wyjaśnia, że od dni jest w drodze i potrzebuje porządnego nocnego odpoczynku. Naturalnie pyta, czy może spędzić tę noc w towarzystwie twoich ludzi. | Napotykasz mężczyznę słabego i zmęczonego. Wyjaśnia, że szukał zaginionego psa, ale już prawie się poddał. Zanim wróci do domu, zastanawia się głośno, czy nocny odpoczynek w waszym towarzystwie mógłby dodać mu sił, by poszukać kundla jeszcze jeden dzień. | Przy drodze znajduje się mężczyzna śledzony przez sępy. Nie jest ranny ani skaleczony, tylko wyczerpany. Pyta z ochrypłym głosem, czy mógłby spędzić noc w towarzystwie twoich ludzi.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Dołącz do nas przy ognisku tej nocy.",
					function getResult( _event )
					{
						this.World.Assets.removeRandomFood(3);
						local n = this.Math.rand(1, 18);

						switch(n)
						{
						case 1:
							return "B1";

						case 2:
							return "C1";

						case 3:
							return "D1";

						case 4:
							return "E1";

						case 5:
							return "F1";

						case 6:
							return "G1";

						case 7:
							return "H1";

						case 8:
							return "I1";

						case 9:
							return "J1";

						case 10:
							return "K1";

						case 11:
							return "L1";

						case 12:
							return "M1";

						case 13:
							return "N1";

						case 14:
							return "O1";

						case 15:
							return "P1";

						case 16:
							return "Q1";

						case 17:
							return "R1";

						case 18:
							return "S1";
						}
					}

				},
				{
					Text = "Nie, trzymaj się z daleka.",
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
			ID = "B1",
			Text = "[img]gfx/ui/events/event_26.png[/img]Siedzicie przy ognisku. Wiele się mówi o tym i owym, ale wędrowiec wypowiada słowa, które zostają w twojej głowie na długo po jego odejściu.%SPEECH_ON%Człowiek jest skazany na wojnę w dniu narodzin. To matka jest z nim w tej pierwszej bitwie i do matki woła w ostatniej. Gdyby zło, które widzimy w innych, potrafiliśmy zobaczyć w sobie, wezwanie mieczy mogłoby padać na głuche uszy. Jakże smutne, że ludzie tak niechętnie zaglądają w głąb siebie, i jakże smutne, że gdy rozbrzmiewa wezwanie mieczy, nasze uszy słyszą lepiej niż kiedykolwiek.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To było moje wezwanie, na które odpowiedziałem, wędrowcze.",
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
			ID = "C1",
			Text = "[img]gfx/ui/events/event_26.png[/img]Siedzicie przy ognisku. Wiele się mówi o tym i owym, ale wędrowiec wypowiada słowa, które zostają w twojej głowie na długo po jego odejściu.%SPEECH_ON%Kilka miesięcy temu znalazłem się blisko szczytu góry. Najwyżej, gdzie byłem! Wędrowałem tam w towarzystwie wyprawy. Jakiś mądrzejszy ode mnie uznał, że warto, żeby mógł wycelować wielkie okulary w niebo. Tak czy inaczej, spojrzałem w dół na ziemię i zobaczyłem, co z nią zrobiono. Miasta, miasteczka i drogi, małe kretowiska z szorstkiej łaty. Wozy przemykające jak mrówki, sprzedające to, co dało się wyłupić z tego człowieka, z tego zwierzęcia czy z tej ziemi. Dziury w lasach, gdzie kiedyś rosły drzewa.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Człowiek z pewnością odcisnął piętno.",
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
			ID = "D1",
			Text = "[img]gfx/ui/events/event_26.png[/img]Siedzicie przy ognisku. Wiele się mówi o tym i owym, ale wędrowiec wypowiada słowa, które zostają w twojej głowie na długo po jego odejściu.%SPEECH_ON%Dziękuję za rybę, panowie, ale muszę odmówić. Już tłumaczę. Niedawno kopałem dół dla krewnego, bo zmarł, a ludzie, którzy odchodzą, zwykle potrzebują dziury w ziemi. To był daleki kuzyn, ale bliski. Mieszkał obok, prawdę mówiąc. Zmarł na chorobę, nie wiadomo jaką, ale tylko on zachorował, więc chyba reszta ma się dobrze. Był cały zielony, kiedy odchodził. Wiecie, co to mogło być?%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nie wiem.",
					function getResult( _event )
					{
						return "D2";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D2",
			Text = "[img]gfx/ui/events/event_26.png[/img]%SPEECH_ON%Nie? Cholera. No dobrze, wykopałem mu grób, bo sam by tego nie zrobił. Kopię, kopię, aż trafiam na wielki głaz. Kilof uderzył mocno, złamał się na pół i zrobił z ostrza kredę. Powiedziałem: końska bzdura, zaszedłem za daleko, żeby teraz przestać, więc zejdź mi z drogi, kamieniu! Ale ten kamień miał w sobie kości. Nie na nim, w nim. Dziwnie wyglądały, ale kości to kości. Śmierć z perspektywy obcego jest zaskakująco znajoma.\n\nTak czy inaczej, czaszka jakby na mnie patrzyła, osądzała mnie, mówiąc: \'co ty tu właściwie robisz?\' Wyszedłem więc z dołu i pobiegłem do domu, szczątki kuzyna przewieszone przez ramiona, jakbym je ukradł. Byłem przejęty. Nie mogłem spać. Czułem, jakbym leżał na setkach takich gości, niektórzy tak starzy, że przybrali kształt skał. Martwi ludzie. Na całej głębokości. Nic poza martwymi, na całej głębokości, mówię! I nie wiedziałem, co robić, i chyba wciąż mnie to dręczy, jeśli nie widać.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Trochę, tak.",
					function getResult( _event )
					{
						return "D3";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D3",
			Text = "[img]gfx/ui/events/event_26.png[/img]%SPEECH_ON%Potem postanowiłem, że nie pochowam kuzyna. Zamiast tego spaliłem jego szczątki i wrzuciłem dymiący stos do stawu. Powiedziałem sobie: \'kuzynie, nie zostaniesz skałą\'.\n\nAle niedawno znalazłem te kości wyrzucone na brzeg, a w żebrach utknęła ryba o dużym brzuchu. Zamknęła się tam, bo był dobry pokarm, jak mniemam. Podniosłem tę rybę i trzymałem ją, i chyba też mojego kuzyna, w dłoni. Była wiotka. Wytrzeszczona, jak ryby bez swoich wodnych powiek. Ale wtedy przebiegł pies i mi ją wyrwał. Połknął ją szybko, bo znał naturę swojego występku, tak myślę. Właśnie tam trafił kawałek mojego kuzyna. Uniknął ziemi przez głodne skały, by zostać zjedzonym przez giermka ryby, która z kolei podała się pobożnemu psu, wyobraź sobie. I oto wiesz, czemu już nie jem ryb.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Hm. Ciekawa opowieść.",
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
			ID = "E1",
			Text = "[img]gfx/ui/events/event_26.png[/img]Siedzicie przy ognisku. Wiele się mówi o tym i owym, ale wędrowiec wypowiada słowa, które zostają w twojej głowie na długo po jego odejściu.%SPEECH_ON%Brałem udział w kampaniach wschodnich. Prowadziłem wozy z zaopatrzeniem, wioząc niezliczone ilości zbroi, broni, koni, jedzenia, co tylko chcesz. Do diabła, to było jakieś dziesięć lat temu, zdaje się. To był ostatni raz, gdy ludzie naprawdę stali razem, i chyba ostatni raz, gdy zielonoskórzy uczynili to samo. Nic dziwnego, że gdy te siły się spotkały, roztrzaskały się o siebie nawzajem. Teraz żyjemy w czasach chaosu, plotek, przesądów i pustych rozmów między obcymi.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Obyś znalazł spokój na drogach, wędrowcze.",
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
			ID = "F1",
			Text = "[img]gfx/ui/events/event_26.png[/img]Siedzicie przy ognisku. Wiele się mówi o tym i owym, ale wędrowiec wypowiada słowa, które zostają w twojej głowie na długo po jego odejściu.%SPEECH_ON%Dziesięć lat temu walczyłem w Bitwie Wielu Imion. Ork przeciw człowiekowi. Koniec wojny, która odcisnęła imię na całej epoce. Jechałem w kawalerii, jeśli chcesz wiedzieć. Południowe skrzydło w błocie i bagnach, a tak, oba są kiepskie do jazdy, ale nasz dowódca nie chciał o tym słyszeć. Ork przebił halabardą konia dowódcy, a potem samego dowódcę. Wprowadzenie koni w to bagno... okropny pomysł. Słyszałem, że północne skrzydło poszło lepiej, ale to bez znaczenia. Żadna ze stron nie wygrała tej przeklętej bitwy.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Obyś znalazł spokój na drogach, wędrowcze.",
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
			ID = "G1",
			Text = "[img]gfx/ui/events/event_26.png[/img]Siedzicie przy ognisku. Wiele się mówi o tym i owym, ale wędrowiec wypowiada słowa, które zostają w twojej głowie na długo po jego odejściu.%SPEECH_ON%Widziałeś kiedyś, jak zielonoskóry odrąbuje koniowi głowę? Niezły widok. Ale widziałem też, jak koń wybija orkowi zęby i rozdepcze go w błocie szaleńczymi kopytami. Zapominamy, myślę, że konie bardziej lubią wojnę niż my. Przerażające, ciekawskie zwierzęta, owszem, ale gwałtowne. Mówią, że pozostawione same sobie często zabijają się nawzajem, zabijają dzieci innych i dzieci ich dzieci. To przeklęta rzecz, że kobiety kochają nas obu.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Obyś znalazł spokój na drogach, wędrowcze.",
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
			ID = "H1",
			Text = "[img]gfx/ui/events/event_26.png[/img]Siedzicie przy ognisku. Wiele się mówi o tym i owym, ale wędrowiec wypowiada słowa, które zostają w twojej głowie na długo po jego odejściu.%SPEECH_ON%Ach, Bitwa Wielu Imion. Tak, brałem udział. Straż przednia. Na czele. Nie, nie chcę o tym mówić.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Obyś znalazł spokój na drogach, wędrowcze.",
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
			ID = "I1",
			Text = "[img]gfx/ui/events/event_26.png[/img]Siedzicie przy ognisku. Wiele się mówi o tym i owym, ale wędrowiec wypowiada słowa, które zostają w twojej głowie na długo po jego odejściu.%SPEECH_ON%Bitwa Wielu Imion? Kto w niej nie brał udziału? Pół świata maszerowało wtedy, przysięgam. Stałem w piechocie. Dokładniej, byłem piechurem u lorda. Dobrze go chroniłem, aż orki wypuściły berserkerów. Potem każdy próbował ocalić siebie, co okazało się trudnym zadaniem. Kiedyś kłamałem, jak z tego wyszedłem. Teraz już nie. Prawda jest taka, że mojego pana łańcuch zmiażdżył w twarz, a jego wierzchowiec przewrócił się i upadł na mnie, a biedne serce zwierzęcia zatrzymało się ze strachu.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "I co się stało potem?",
					function getResult( _event )
					{
						return "I2";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "I2",
			Text = "[img]gfx/ui/events/event_26.png[/img]Wędrowiec milknie, wpatrując się w ognisko. Szturcha jego brzeg patykiem.%SPEECH_ON%To było ostatnie, co pamiętam z walki. Potem obudziłem się, a deszcz sięgał mi do nosa. Prawie mnie utopił, kiedy drzemałem. Wyślizgnąłem się spod konia i doczołgałem się nie wiadomo gdzie. Orki i ludzie leżeli wszędzie, martwi, umierający, tonący. Mnóstwo krzyków. Nie umiałem powiedzieć, skąd dochodzą. Pamiętam błoto. Pamiętam, jak mnie trzymało. Dziewka, silna jak wół, wyrwała mnie z niego. Wrzuciła mnie na wóz i ostatnie, co widziałem, to pole bitwy i... przepraszam. Muszę przestać. Dziękuję, że przenocowaliście mnie.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Obyś znalazł spokój na drogach, wędrowcze.",
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
			ID = "J1",
			Text = "[img]gfx/ui/events/event_26.png[/img]Siedzicie przy ognisku. Wiele się mówi o tym i owym, ale wędrowiec wypowiada słowa, które zostają w twojej głowie na długo po jego odejściu.%SPEECH_ON%Prowadziłem kompanię w Bitwie Wielu Imion. To była słuszna sprawa. Człowiek przeciw orkowi! Och, jaki to był widok. Połowa moich ludzi zginęła na tych polach, ale ich ofiara ocaliła całą krainę! Wspominam tamte czasy z rozrzewnieniem. Który człowiek by nie wspominał?%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Szlachetna opowieść, nieznajomy.",
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
			ID = "K1",
			Text = "[img]gfx/ui/events/event_26.png[/img]Siedzicie przy ognisku. Wiele się mówi o tym i owym, ale wędrowiec wypowiada słowa, które zostają w twojej głowie na długo po jego odejściu.%SPEECH_ON%W %randomtown% sądzili ojca. Zamordował dwóch braci, bo przewrócili mu wóz. A potem najwyraźniej zasmakowało mu to i zamordował kolejnych. W sumie odebrał życie co najmniej siedmiu osobom. Oczywiście go powiesili. Ale spotkałem niedawno jego syna i ten powiedział mi, że powieszenie to była zwykła pomyłka urzędnicza. Jego ojciec był prawym człowiekiem, wcale nie samolubnym, a ludzie, których zabił, zasłużyli. Co ciekawsze, ten młodzieniec jest teraz burmistrzem! A ja pamiętam, że ów mężczyzna po prostu zarżnął siedem osób. Ot tak! Ale ostatnim razem, gdy byłem w mieście, przenieśli jego długoszyjne kości na porządny cmentarz i niech mnie diabli, jeśli nie widziałem kwiatów na nagrobku. Nie wiem, co o tym myśleć.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ludzie próbują widzieć w sobie to, co najlepsze.",
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
			ID = "L1",
			Text = "[img]gfx/ui/events/event_26.png[/img]Siedzicie przy ognisku. Wiele się mówi o tym i owym, ale wędrowiec wypowiada słowa, które zostają w twojej głowie na długo po jego odejściu.%SPEECH_ON%Nie jesteście jedyną kompanią najemników w tych stronach. Jestem pewien, że o tym wiesz, i nie chcę brzmieć groźnie, ale pragnę coś powiedzieć.\n\nKilka tygodni temu dwie, a może trzy kompanie ludzi, takie jak wasza, spotkały się na rozstajach i najwyraźniej droga nie była dość szeroka dla wszystkich, więc walczyli. Jeśli ktoś przeżył, nie wystarczyło ich, by zabrać tych, którzy nie przeżyli. Lubię waszych ludzi. To dobrzy ludzie. Ale proszę, uważajcie tam. Zabijanie najeźdźców, bandytów i bogowie wiedzą kogo jeszcze nie będzie jedyną rzeczą, którą będziecie robić. Zabijasz na rynku konkurentów, najemniku.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Będziemy mieć oczy szeroko otwarte.",
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
			ID = "M1",
			Text = "[img]gfx/ui/events/event_26.png[/img]Siedzicie przy ognisku. Wiele się mówi o tym i owym, ale wędrowiec wypowiada słowa, które zostają w twojej głowie na długo po jego odejściu.%SPEECH_ON%Chłopak ukradł mi ostatnio obiad, a potem nic nie robił, tylko stał i jadł mi go na oczach. Powiedziałem: \'oddaj obiad, łobuzie\', ale on powiedział nie. Sięgnąłem po niego, ale jego chude nogi okazały się bardziej kocie niż kurze. Powiedziałem, no, zapytałem, czemu musiał go jeść na moich oczach. To była tortura, rozumiesz. Odrzekł: \'bo jestem głodny\'. Powiedziałem mu: \'ja też jestem głodny, więc oddaj\'. Oczywiście znów powiedział nie. Więc naturalnie, gdy się odwrócił, przywaliłem mu kamieniem, trochę mu zwolniłem, i odzyskałem obiad.\n\n Ale potem pojawił się pachołek burmistrza i mówi, żebym tego nie robił. Zapytałem, czemu, a on na to: \'bo to syn burmistrza\'. Kara była żadna, ale ostrzegli mnie, żebym nie robił tego ponownie. Powiedziałem mu, rzekłem: \'powiedzcie chłopakowi, żeby nie kradł\'. A oni na to, że tak zrobili i że ja bardziej skłonny jestem słuchać rozkazów niż on, i tak to już było. Pieprzone miasteczka, przysięgam, te miejsca są bardziej bydlę niż wzgórze.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zemsta, najsłodsza z przypraw.",
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
			ID = "N1",
			Text = "[img]gfx/ui/events/event_26.png[/img]Siedzicie przy ognisku. Wiele się mówi o tym i owym, ale wędrowiec wypowiada słowa, które zostają w twojej głowie na długo po jego odejściu.%SPEECH_ON%Śmierć była dziwna na polu bitwy Wielu Imion. Orki nie zabijają jak ludzie, robią to szybko. Zostawiają niewielką przerwę między teraz a potem. Dobrze przyjrzałem się ich dziełu po wszystkim. Ludzie porozrzucani w kawałkach. Całe części, nogi, ramiona, ciała rozcięte w najbardziej nienaturalnych szwach. Natychmiastowa śmierć. Zamach, głowa znika! A ciało się zwija i sztywnieje. Większość martwych wyglądała właśnie tak, jakby po prostu się przestraszyli i zastygli w zawstydzeniu. Większość w ogóle nie wyglądała jak ludzie. Człowiek powinien wyglądać jakby spał, kiedy umiera, wiesz?%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Tak.",
					function getResult( _event )
					{
						return "N2";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "N2",
			Text = "[img]gfx/ui/events/event_26.png[/img]Kontynuuje.%SPEECH_ON%Kilku dostało uprzejmość powolnej śmierci, chwilę, by się przygotować, ułożyć wygodnie i odnaleźć spokój, zwinąć się w kłębek i opuścić to miejsce w podobnym kształcie, w jakim przyszli. Ale powiem ci, jeden człowiek, rozerwany w pasie, zdołał się trzymać. Znalazłem go osobiście. Kazałem mu zamknąć oczy, bo myślałem, że jeśli zaśnie, może śmierć się obudzi. Ale nie zasnął. Po prostu oddychał i mówił. Mówił o kurczaku, którego miał jako chłopiec, i jak się złościł, gdy ojciec go zarżnął. Mówił o dziewczynie, potem o żonie i o matce. Właściwie mówił o dwóch matkach.%SPEECH_OFF%Mężczyzna milknie, wpatrując się w ognisko. Spogląda na ciebie.%SPEECH_ON%Nie wiedziałem, że pół człowieka może żyć tak długo.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Obyś znalazł spokój w podróży, nieznajomy.",
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
			ID = "O1",
			Text = "[img]gfx/ui/events/event_26.png[/img]Siedzicie przy ognisku. Wiele się mówi o tym i owym, ale wędrowiec wypowiada słowa, które zostają w twojej głowie na długo po jego odejściu.%SPEECH_ON%Widziałem, jak kilka miesięcy temu piorun zabił człowieka. %randomname% mu było. Miał usta jak tartak, drewniany zgryz od policzka do policzka. Mówiliśmy, że ma termity zamiast zębów! Tak czy inaczej, znalazłem go z płonącą głową, szczerzącą do mnie gorący ogień, a jego ciało było zwinięte w pasy czerni i purpury. Ziemia wokół była zwęglona, dym krążył, a małe ognie trzaskały. A jednak wciąż żył. Pobiegłem po pomoc, gdy usłyszałem za sobą okropny dźwięk. Przeklęty piorun uderzył w niego znowu! Porażony przez bogów na wskroś.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Niech spoczywa w pokoju.",
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
			ID = "P1",
			Text = "[img]gfx/ui/events/event_26.png[/img]Siedzicie przy ognisku. Wędrowiec opowiada o plotkach.%SPEECH_ON%W %randomtown% powiesili jakąś kobietę. Nie widziałem, jak spadła, ale widziałem, jak się kołysała. Mówili, że roztrzaskała komuś głowę, gdy spał. Co za baba.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Interesujące.",
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
			ID = "Q1",
			Text = "[img]gfx/ui/events/event_26.png[/img]Siedzicie przy ognisku. Wędrowiec mówi o zbrodni i jej karze.%SPEECH_ON%W %randomtown% powiesili chłopaka za zabicie kupca. Powiedzieli, że rzucił w niego kamieniem, żeby zrzucić go z wozu. Potem podbiegł, by go okraść, ale kamień go nie znokautował, więc kupiec dobył sztyletu, chłopak dobył swojego, i chyba chłopak był tym, który został na nogach, gdy wszystko się skończyło, a teraz po prostu wisi. Mówią, że na egzekucji kopał długo i mocno, nie przestawał kopać nawet po śmierci. Może jego zimne stopy szukały ciepła.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Interesujące.",
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
			ID = "R1",
			Text = "[img]gfx/ui/events/event_26.png[/img]Siedzicie przy ognisku. Wiele się mówi o tym i owym, ale wędrowiec staje się nerwowy, więc pytasz, co mu leży na sercu.%SPEECH_ON%Słyszałem plotki, że cmentarze są puste. W %randomtown% powiesili człowieka za grabienie grobów, ale i tak wciąż znajdowali puste mogiły. Nie jestem przesądny, ale z tego, co słyszę, umarli wychodzą z ziemi.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To tylko pogłoski. Nie masz się czego bać.",
					function getResult( _event )
					{
						return "R2";
					}

				},
				{
					Text = "To, co słyszałeś, jest prawdą.",
					function getResult( _event )
					{
						return "R3";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "R2",
			Text = "[img]gfx/ui/events/event_26.png[/img]%SPEECH_ON%Uff. Tak, pewnie masz rację. Umarli chodzący po ziemi? Ha! Zostawię takie pomysły dzieciakom.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "W istocie.",
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
			ID = "R3",
			Text = "[img]gfx/ui/events/event_26.png[/img]%SPEECH_ON%Niech starzy bogowie mają litość, bo jeśli moja przeklęta teściowa chodzi po ziemi, to na pewno nie będzie miała jej dla mnie.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Przerażająca perspektywa.",
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
			ID = "S1",
			Text = "[img]gfx/ui/events/event_26.png[/img]Siedzicie przy ognisku. Raczej nieszczęśliwie wyglądający mężczyzna wpatruje się w ogień, gdy mówi.%SPEECH_ON%Słyszałem, że bogaci mają takie rzeczy, dzięki którym mogą zobaczyć, jak wyglądają. Lustra! Tak, tak to się nazywa. Chciałbym mieć jedno. Nigdy nie widziałem swojej twarzy... no, w ogóle. Może trochę, gdy wpatrywałem się w staw, pewnie.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Niektóre rzeczy lepiej pozostawić niewidzianymi.",
					function getResult( _event )
					{
						return "S2";
					}

				},
				{
					Text = "Mamy tu lustro.",
					function getResult( _event )
					{
						return "S3";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "S2",
			Text = "[img]gfx/ui/events/event_26.png[/img]Mężczyzna marszczy brwi.%SPEECH_ON%No tak, dzięki, najemniku, od razu lepiej. Pieprzony cham.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nie ma za co.",
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
			ID = "S3",
			Text = "[img]gfx/ui/events/event_26.png[/img]Mężczyzna wpatruje się w lustro, jakby oglądał własną śmierć. Pociera brodę i obraca głowę, desperacko szukając takiego kąta, który nie rozczaruje.%SPEECH_ON%Niech mnie diabli, jeśli moja matka nie jest największą kłamczuchą, jaka chodziła po ziemi. Spójrz na ten paskudny ryj!%SPEECH_OFF%Oddaje lustro i nie potrafi powstrzymać śmiechu z własnego nieszczęsnego oblicza.%SPEECH_ON%Cóż, przynajmniej już nie muszę się zastanawiać, czemu kobiety przede mną uciekają.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nie ma za co.",
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
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Wildmen && currentTile.SquareCoords.Y > this.World.getMapSize().Y * 0.7)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y < this.World.getMapSize().Y * 0.2)
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

