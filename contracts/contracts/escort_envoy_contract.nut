this.escort_envoy_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.escort_envoy";
		this.m.Name = "Eskorta Emisariusza";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		if (this.m.Home == null)
		{
			this.setHome(this.World.State.getCurrentTown());
		}

		local settlements = this.World.EntityManager.getSettlements();
		local candidates = [];

		foreach( s in settlements )
		{
			if (s.getID() == this.m.Home.getID())
			{
				continue;
			}

			if (!s.isDiscovered() || s.isMilitary())
			{
				continue;
			}

			if (s.getOwner() == null || s.getOwner().getID() == this.getFaction())
			{
				continue;
			}

			if (s.isIsolated() || !this.m.Home.isConnectedTo(s) || this.m.Home.isCoastal() && s.isCoastal())
			{
				continue;
			}

			candidates.push(s);
		}

		this.m.Destination = this.WeakTableRef(candidates[this.Math.rand(0, candidates.len() - 1)]);
		local distance = this.getDistanceOnRoads(this.m.Home.getTile(), this.m.Destination.getTile());
		this.m.Payment.Pool = this.Math.max(250, distance * 7.0 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult());

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		local titles = [
			"Poseł",
			"Emisariusz"
		];
		this.m.Flags.set("EnvoyName", this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
		this.m.Flags.set("EnvoyTitle", titles[this.Math.rand(0, titles.len() - 1)]);
		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		this.m.Flags.set("Bribe", this.beautifyNumber(this.m.Payment.Pool * this.Math.rand(75, 150) * 0.01));
		this.m.Flags.set("EnemyName", this.m.Destination.getOwner().getName());
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Eskortuj emisariusza zwanego %envoy% do " + this.Contract.m.Destination.getName() + " na %direction%"
				];

				if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.IntroChance)
				{
					this.Contract.setScreen("Intro");
				}
				else
				{
					this.Contract.setScreen("Task");
				}
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					if (this.Contract.getDifficultyMult() >= 1.0)
					{
						this.Flags.set("IsShadyDeal", true);
					}
				}

				local envoy = this.World.getGuestRoster().create("scripts/entity/tactical/humans/envoy");
				envoy.setName(this.Flags.get("EnvoyName"));
				envoy.setTitle(this.Flags.get("EnvoyTitle"));
				envoy.setFaction(1);
				this.Flags.set("EnvoyID", envoy.getID());
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.Destination.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.World.getGuestRoster().getSize() == 0)
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Destination))
				{
					this.Contract.setScreen("Arrival");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsShadyDeal"))
				{
					if (!this.Flags.get("IsShadyDealAnnounced"))
					{
						this.Flags.set("IsShadyDealAnnounced", true);
						this.Contract.setScreen("ShadyCharacter1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.World.State.getPlayer().getTile().HasRoad && this.Math.rand(1, 1000) <= 1)
					{
						local enemiesNearby = false;
						local parties = this.World.getAllEntitiesAtPos(this.World.State.getPlayer().getPos(), 400.0);

						foreach( party in parties )
						{
							if (!party.isAlliedWithPlayer)
							{
								enemiesNearby = true;
								break;
							}
						}

						if (!enemiesNearby && this.Contract.getDistanceToNearestSettlement() >= 6)
						{
							this.Contract.setScreen("ShadyCharacter2");
							this.World.Contracts.showActiveContract();
						}
					}
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getID() == this.Flags.get("EnvoyID"))
				{
					this.World.getGuestRoster().clear();
				}
			}

		});
		this.m.States.push({
			ID = "Waiting",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Zaczekaj w okolicy " + this.Contract.m.Destination.getName() + ", aż %envoy% %envoy_title% skończy swoje sprawy"
				];
				this.Contract.m.Destination.getSprite("selection").Visible = true;
			}

			function update()
			{
				this.World.State.setUseGuests(false);

				if (this.Contract.isPlayerAt(this.Contract.m.Destination) && this.Time.getVirtualTimeF() >= this.Flags.get("WaitUntil"))
				{
					this.Contract.setScreen("Departure");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Eskortuj: %envoy% %envoy_title% z powrotem do " + this.Contract.m.Home.getName()
				];
				this.Contract.m.Destination.getSprite("selection").Visible = false;
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				this.World.State.setUseGuests(true);

				if (this.World.getGuestRoster().getSize() == 0)
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getID() == this.Flags.get("EnvoyID"))
				{
					this.World.getGuestRoster().clear();
				}
			}

		});
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationDefault);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "Negocjacje",
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer% ma obok siebie mężczyznę. Ledwo widzisz jego twarz, a gdy przechylasz głowę, by lepiej mu się przyjrzeć, on robi to samo, by ci tego nie ułatwić.%SPEECH_ON%Proszę, najemniku. To %envoy%. Nie musisz go widzieć. Potrzebuję, byś zaprowadził go do %objective%. Idzie tam przekonać ich, że nasza sprawa jest warta dołączenia. Oczywiście %enemynoblehouse% nie będzie z tego zadowolone, więc dyskrecja jest tu istotna.%SPEECH_OFF%Kiwając głową, rozumiesz zawiłości polityki między rodami.%SPEECH_ON%Dobrze, najemniku. No więc, jesteś zainteresowany?%SPEECH_OFF% | Mężczyzna, jakby wychodząc z cieni komnaty %employer%a, podchodzi do ciebie z wyciągniętą dłonią. Ściskasz ją, a on się przedstawia.%SPEECH_ON%Jestem %envoy% na służbie u %employer%a. My...%SPEECH_OFF%%employer% wtrąca się.%SPEECH_ON%Potrzebuję, byś eskortował tego człowieka do %objective%. To oczywiście terytorium %enemynoblehouse%, więc potrzebna jest pewna dyskrecja. I tu wchodzisz ty. Masz dopilnować, by tam dotarł. Potem go odprowadzisz i dostaniesz zapłatę. Pasuje to do twojego fachu i doświadczenia?%SPEECH_OFF% | %employer% uderza zwojem w twoją pierś.%SPEECH_ON%Za moimi drzwiami stoi człowiek, emisariusz. Nazywa się %envoy% i ma udać się do %objective%, by przekonać ich do przyłączenia się do nas.%SPEECH_OFF%Biorąc zwój, pytasz o oczywisty problem: to lenno %enemynoblehouse%. %employer% kiwa głową.%SPEECH_ON%Tak. Dlatego tu jesteś ty, a nie moi chorążowie. Nie ma potrzeby wywoływać wojny, prawda? Potrzebuję tylko, byś zaprowadził %envoy%a na miejsce i przyprowadził go z powrotem. Jeśli jesteś zainteresowany, pogadajmy o liczbach, potem przekażesz zwój emisariuszowi i ruszysz w drogę.%SPEECH_OFF% | Patrząc na mapę, %employer% pyta, czy interesujesz się polityką. Wzruszasz ramionami, a on kiwa głową.%SPEECH_ON%Tak myślałem. Cóż, niestety mam dla ciebie coś politycznego. Musisz eskortować emisariusza imieniem %envoy%. Jedzie do %objective% żeby... no, załatwić sprawy polityczne, przekonać ludzi do przyłączenia się do nas, nic, co spędzałoby sen z powiek. Oczywiście to nie nasze terytorium, dlatego zatrudniam bezimiennego człowieka, takiego jak ty. Bez urazy.%SPEECH_OFF%Machasz ręką. %employer% kontynuuje.%SPEECH_ON%Jeśli jesteś zainteresowany, po prostu zaprowadź go tam i przyprowadź z powrotem. Brzmi prosto, prawda? Nawet nie musisz nic mówić!%SPEECH_OFF% | %employer% studiuje mapę, zwłaszcza kolory pokazujące jego granice w porównaniu do %enemynoblehouse%. Uderza pięścią w ich stronę terytoriów.%SPEECH_ON%Dobrze, najemniku. Potrzebuję kilku twardych ludzi, by chronili %envoy%a, mojego emisariusza. Jedzie do %objective%, które, jeśli znasz politykę, nie jest pod moją kontrolą.%SPEECH_OFF%Kiwając głową, dajesz szlachcicowi znać, że rozumiesz konsekwencje jego prośby.%SPEECH_ON%Doprowadzasz go tam, on prowadzi rozmowy, potem przyprowadzasz go z powrotem. Dla ciebie jesteś po prostu bezsztandarowym wyrobnikiem idącym za nim, rozumiesz? Jeśli jesteś zainteresowany, porozmawiajmy o zapłacie, dobrze?%SPEECH_OFF% | %employer% rzuca na stół zniszczony skrawek papieru, wyraźnie zwój złych wieści.%SPEECH_ON%Moje córki wychodzą za mąż, ale nie mam dość opodatkowanych ziem, by zapewnić im uroczystości, na jakie zasługują.%SPEECH_OFF%Nie obchodzi cię to i sugerujesz, by przeszedł do sedna.%SPEECH_ON%Dobrze, dobrze. Odkładając brednie na bok, potrzebuję, byś eskortował mojego emisariusza, %envoy%a, do %objective%. Zamierza przekonać ich, by przeszli pod nasz sztandar. To małe miejsce leży na terytorium %enemynoblehouse% i można założyć, że nie będą zadowoleni, że kręcimy się po ich ziemiach. Dlatego właśnie zatrudniam ciebie, bezimiennego najemnika, byś opiekował się moim emisariuszem.%SPEECH_OFF%Mężczyzna splata dłonie na kolanach.%SPEECH_ON%Czy ten mały gambit cię interesuje? Wystarczy, że zaprowadzisz go tam i z powrotem. Łatwy zarobek, łatwy!%SPEECH_OFF% | Czytając zwój, %employer% zaczyna się śmiać, po czym nie może przestać się uśmiechać.%SPEECH_ON%Dobre wieści, najemniku! Ludzie %enemynoblehouse% nie są już zadowoleni z ich rządów!%SPEECH_OFF%Unosisz brew i przytakujesz ironicznie. Przysuwając krzesło do biurka i przeglądając mapę rozłożoną na blacie, mężczyzna kontynuuje.%SPEECH_ON%Lepsze wieści są takie, że mam emisariusza o imieniu %envoy%, który dziś jedzie do %objective%, by trochę... porozmawiać. Oczywiście drogi pełne są szemranych złodziei, a lordowie %enemynoblehouse% są jeszcze bardziej szemrani, więc ten człowiek potrzebuje ochrony! Tu wchodzisz ty. Masz go tylko zaprowadzić tam i z powrotem.%SPEECH_OFF% | %employer% ma obok siebie mężczyznę. Ściska twoją dłoń i przedstawia się jako %envoy%, swego rodzaju emisariusz. Pytasz o znaczenie tej osoby, a %employer% szybko wyjaśnia.%SPEECH_ON%Jedzie do %objective% - lenna %enemynoblehouse%, jeśli nie wiesz. Być może uda nam się przekonać ludzi, by przeszli pod nasze panowanie. Skoro znasz tego człowieka i jego misję, na pewno rozumiesz, dlaczego jesteś tu ty, a nie jeden z moich chorążych.\n\nPotrzebuję, byś doprowadził go do %objective%, a gdy skończy to, co musi, przyprowadził go z powrotem. Potem dostaniesz zapłatę. Wchodzisz w to?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Porozmawiajmy o pieniądzach. | Ile to dla ciebie jest warte? | Ile wyniesie zapłata?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Będziesz musiał poszukać ochrony gdzie indziej. | Nie takiego rodzaju pracy szukamy.}",
					function getResult()
					{
						this.World.Contracts.removeContract(this.Contract);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Arrival",
			Title = "W %objective%",
			Text = "[img]gfx/ui/events/event_20.png[/img]{Dotarłeś do %objective%. %envoy% %envoy_title% wchodzi do budynku, cicho zamykając za sobą drzwi. Opierasz but o ścianę i czekasz na jego powrót. Kilku chłopów przychodzi i odchodzi. Ptaki ćwierkają. Dawno nie zwracałeś uwagi na ich śpiew.\n\nTo może chwilę potrwać. Może warto wykorzystać ten czas, by uzupełnić zapasy na drogę powrotną? | Emisariusz wchodzi do budynku rady w %objective%. Doprowadziłeś go bezpiecznie, teraz czas, by zrobił resztę. Przez moment słuchasz rozmów, opierając się o jedno z okien i chłonąc je. Mężczyzna ma bystry język i zjednuje ludzi dla swojej sprawy lepiej, niż ty i garść mieczy kiedykolwiek byście mogli. Emisariusz widzi cię przez okno i dyskretnie daje znak, byś odszedł. Umknąłeś i czekasz, aż skończy. | Kilku dobrze ubranych mężczyzn wita was w %objective%. Pytają %envoy%a %envoy_title%, czy jesteś z nim. Kiwając głową, szepcze coś radnym. Oni odpowiadają skinieniem i wkrótce wszyscy znikają w miejscowej gospodzie. Czekasz na zewnątrz. Może warto wykorzystać czas, by uzupełnić zapasy na drogę powrotną? | Podejrzenia %employer%a, że %objective% może opowiedzieć się po jego stronie, wyglądają na słuszne: ludzie już tłoczą się na ulicach w wielkim tłumie. Przed dużym budynkiem stoi rząd strażników i odpycha ludzi odwróconymi włóczniami. Jeden z bogatych mężczyzn wychyla się z okna, próbując słowami uspokoić tłum, lecz ich uszy są zbyt pełne gniewu. %envoy% z łatwością przeciska się przez tłum i spotyka kilku radnych w płaszczach. Wchodzą do pobliskiego budynku, a ty czekasz na zewnątrz. | %objective% wygląda raczej ponuro - chłopi na ulicach, albo wściekli na coś, albo leniwi bez powodu. Żadne z tego nie jest dobrym znakiem zdrowej wspólnoty. %envoy% %envoy_title% wchodzi do miejscowej gospody, gdzie grupa skulonych mężczyzn ostrożnie go wita. Daje ci znak, byś odszedł, więc stoisz na zewnątrz i czekasz, aż skończy.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "{Oby to nie trwało zbyt długo. | Będziemy w okolicy.}",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.World.getGuestRoster().get(0).getImagePath());
				this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(20, 60) * 1.0);
				this.Contract.setState("Waiting");
			}

		});
		this.m.Screens.push({
			ID = "Departure",
			Title = "W %objective%",
			Text = "[img]gfx/ui/events/event_20.png[/img]{Mija trochę czasu, zanim emisariusz wraca. Pytasz, czy miał jakieś problemy, a on odpowiada, że nie. Czas wracać do %employer%a. | Drzwi się otwierają i emisariusz wychodzi. Mówi ci, byś poprowadził drogę do domu. | Wkrótce emisariusz wraca. Mówi, że skończył swoje sprawy i musi wracać do %employer%a. | %envoy% wraca do ciebie w pośpiechu. Mówi, że muszą wrócić do %employer%a tak szybko, jak to możliwe. | Gdy emisariusz wraca, mówi, że rozmowa była dobra i że musisz jak najszybciej odprowadzić go do %employer%a.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "{Nareszcie, ruszajmy! | Co tak długo?}",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.World.getGuestRoster().get(0).getImagePath());
				this.Contract.setState("Return");
			}

		});
		this.m.Screens.push({
			ID = "ShadyCharacter1",
			Title = "W %townname%",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Gdy tylko opuszczasz miasto, podchodzi do ciebie mężczyzna w płaszczu i zagaduje. Trzyma twarz w cieniu kaptura; widzisz tylko od czasu do czasu jego zęby i czubek spiczastego podbródka.%SPEECH_ON%Gdy nadejdzie czas, odwrócisz wzrok, najemniku?%SPEECH_OFF%Zanim zdążysz odpowiedzieć, już go nie ma. | Przygotowując się do wyjazdu z miasta, wpada na ciebie mężczyzna. Nie przeprasza, zamiast tego spogląda spod długiego, czarnego płaszcza.%SPEECH_ON%Przyjdzie czas, gdy będziesz musiał podjąć decyzję. Zostać i walczyć, albo odejść i dożyć następnego dnia. Złoto pójdzie z tobą drugą drogą, łopata zakopie cię pierwszą...%SPEECH_OFF%Wyciągasz rękę, by schwytać mężczyznę, ale on po prostu cofa się, wchłonięty przez tłum prostych ludzi, którzy akurat przechodzili. | Gdy szykujesz się do opuszczenia %townname%, mężczyzna w ciemnym płaszczu podchodzi do twojego boku. Nie patrzy na ciebie, tylko mówi.%SPEECH_ON%Mój dobroczyńca się ciebie spodziewał. %employer% mądrze cię zatrudnił. Jednak masz wybór i gdy nadejdzie czas... którą ścieżką pójdziesz?%SPEECH_OFF%Mówisz mężczyźnie, by swoje omeny zachował dla siebie. | Mężczyzna w czerni zastępuje ci drogę, gdy wychodzisz od %employer%a. Zerka przez twoje ramię, po czym szepcze.%SPEECH_ON%%employer% dobrze ci płaci, ale ja znam kogoś, kto zapłaci jeszcze lepiej. Odwróć wzrok, gdy nadejdzie czas...%SPEECH_OFF%Nieznajomy cofa się i znika za drzwiami. Gdy je otwierasz, by ruszyć w pościg, jego już nie ma. Stoi tam tylko pomocnik kuchenny, wyglądający, jakby {nic nie widział | nic nie widziała}. | Z zadaniem od %employer%a w ręku szykujesz się do wyruszenia. Gdy przygotowujesz zapasy, podchodzi nieznajomy w płaszczu. Mówi, jakby miał żwir w gardle.%SPEECH_ON%Wiele ptaków cię obserwuje, najemniku. Stawiaj kolejne kroki ostrożnie. Wciąż masz szansę się z tego wycofać. Gdy nadejdzie czas, prosimy tylko, byś się odsunął.%SPEECH_OFF%Dobierasz miecz, by zagrozić mężczyźnie, lecz ten umyka, a jego trzepoczący płaszcz wtapia się w tłum chłopów, którzy wyglądają na zaniepokojonych twoim nagłym uzbrojeniem.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "{To może być ciekawe... | Wygląda na to, że szykują się kłopoty.}",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "ShadyCharacter2",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{W drodze grupa uzbrojonych mężczyzn wyłania się znikąd i zastępuje ci drogę. Wśród nich jest podejrzana postać, którą widziałeś wcześniej. Oświadczają, że zamierzają zabrać emisariusza. W zamian dostaniesz dużą sumę pieniędzy - %bribe% koron.\n\nW przeciwnym razie będą musieli wziąć go siłą... | Właśnie zaczynasz się wkręcać - słuchasz paplaniny emisariusza, ignorujesz ją, marzysz, by po prostu poszedł w las i nie wrócił - gdy nagle zaskakuje cię grupa uzbrojonych mężczyzn. Wśród nich stoi nieznajomy, którego spotkałeś wcześniej. Oświadczają, że emisariusza trzeba wydać. W zamian dostaniesz %bribe% koron. Jeśli odmówisz, użyją bardziej gwałtownych metod.\n\nGdy rozważasz opcje, emisariusz po raz pierwszy milczy całkowicie. | Maszerując traktem, napotykasz grupę uzbrojonych mężczyzn, którzy cię zatrzymują. Rozpoznajesz wśród nich nieznajomego z wcześniej. Każą ci wydać emisariusza, wskazując na bardzo dużą sakiewkę koron, rzekomo %bribe% koron. Jednocześnie wskazują na broń, sugerując, że są gotowi użyć innych środków, jeśli odmówisz.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Po co się wykrwawiać dla koron, skoro ktoś ci je ot tak wręcza? Umowa stoi.",
					function getResult()
					{
						return "ShadyCharacter3";
					}

				},
				{
					Text = "Jeśli go chcecie, chodźcie po niego.",
					function getResult()
					{
						return "ShadyCharacter4";
					}

				}
			],
			function start()
			{
				this.Characters.push(this.World.getGuestRoster().get(0).getImagePath());
				this.Flags.set("IsShadyDeal", false);
			}

		});
		this.m.Screens.push({
			ID = "ShadyCharacter3",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Gdy rozważasz to wszystko, emisariusz podchodzi do ciebie i szepcze.%SPEECH_ON%Nie pozwolisz im mnie zabrać, prawda? %employer% dobrze ci płaci za zapewnienie mi bezpieczeństwa.%SPEECH_OFF%Kiwasz głową, kładąc dłoń na ramieniu mężczyzny, i odszepczesz.%SPEECH_ON%Masz rację. Płaci. Ale oni płacą więcej.%SPEECH_OFF%Po tych słowach popychasz go do przodu. Protestuje, lecz kończy na ostrzu miecza. Krew pryska na ziemię, a gdy ostrze zostaje wyciągnięte, podąża za nim sterta wnętrzności. Tajemniczy nieznajomy wręcza ci sakiewkę obiecanych koron.%SPEECH_ON%Dziękuję za interesy, najemniku.%SPEECH_OFF% | Patrzysz na emisariusza, potem na tajemniczych ludzi, kiwając w ich stronę. Emisariusz chwyta cię za koszulę, błagając.%SPEECH_ON%Nie, nie możesz! Obiecałeś %employer%owi, że będę bezpieczny!%SPEECH_OFF%Oddajesz im mężczyznę. W jednej chwili podcinają mu gardło, pada na kolana, palce zaciskają się na ranie, gdy krew tryska. Zabójcy kopią go, a emisariusz powoli nieruchomieje, gdy grupa mężczyzn wyśmiewa go w drodze na tamten świat. Sakiewka ląduje w twoich dłoniach, a ten, który ją podał, klepie cię po ramieniu.%SPEECH_ON%Dzięki za współpracę, najemniku. Naprawdę zasługujesz na swój tytuł.%SPEECH_OFF% | Spoglądasz na emisariusza i kręcisz głową.%SPEECH_ON%Jestem najemnikiem, a moja cena jest, jaka jest.%SPEECH_OFF%Emisariusz krzyczy, ale mężczyzna podchodzi z małą kuszą i strzela bełtem między jego oczy, drzewce przebija tył głowy, oblepione strzępami mózgu. Tajemniczy mężczyzna rzuca ci sakiewkę koron.%SPEECH_ON%Czym to było dla wszystkich stron, żalem czy łaską?%SPEECH_OFF%Liczysz korony i odpowiadasz.%SPEECH_ON%Było jednym i drugim, dopóki tamten człowiek nie dodał nieco stolarki do czaszki emisariusza. Teraz to już tylko łaska.%SPEECH_OFF%Tajemniczy mężczyzna krzywo się uśmiecha.%SPEECH_ON%Szkoda. Osobiście lubię różnorodność opinii. Dodaje dramatyzmu, jak to mówią.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "{Łatwy zarobek. | I każdy jest zadowolony.}",
					function getResult()
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().set("Betrayed", true);
						this.World.Assets.addMoney(this.Flags.get("Bribe"));
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Nie zdołałeś ochronić emisariusza");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.updateAchievement("NeverTrustAMercenary", 1, 1);
				this.Characters.push(this.World.getGuestRoster().get(0).getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("Bribe") + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "ShadyCharacter4",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_50.png[/img]{Jedną ręką odpychasz emisariusza za siebie, drugą dobywasz miecza. Tajemniczy mężczyzna kiwa głową i powoli znika za własną linią bojową.%SPEECH_ON%Szkoda, ale mój interes musi zostać doprowadzony do końca. Jestem pewien, że rozumiesz.%SPEECH_OFF% | Tajemniczy mężczyzna wyciąga ramię, palce dłoni zwijają się, jakby chciał odciągnąć emisariusza od ciebie. Zamiast tego odpychasz go za swoją linię. Nieznajomy natychmiast kiwa głową.%SPEECH_ON%Zrozumiałe. Ale nie do przyjęcia. Obaj mamy swoich dobroczyńców, najemniku. Ty musisz być wierny swojemu, a ja swojemu. Niech najlepszy z nas pozostanie na nogach, by nagrodzić tych, którzy zaufali naszym rękom.%SPEECH_OFF% | Emisariusz błaga cię, ale każesz mu zamilknąć, zanim odwrócisz się do bandy zabójców.%SPEECH_ON%Emisariusz wyjdzie stąd żywy.%SPEECH_OFF%Kiwając głową, tajemniczy nieznajomy po prostu znika za swoją linią bojową.%SPEECH_ON%Rozumiem. Interes to interes, a teraz trzeba go doprowadzić do końca.%SPEECH_OFF%Jego ludzie ruszają do przodu, dobywając mieczy.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Mercs";
						p.Entities = [];
						p.Parties = [];
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.World.getGuestRoster().get(0).getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Wracasz do %employer%a, a emisariusz jest u twego boku.%SPEECH_ON%Ach, najemniku, widzę, że zrobiłeś, o co prosiłem. A ty, emisariuszu...?%SPEECH_OFF%%envoy% pochyla się i szepcze do ucha szlachcicowi. Ten odchyla się, kiwając głową.%SPEECH_ON%Dobrze, dobrze. Porozmawiajmy... A ty, najemniku, twoja zapłata czeka na zewnątrz. Wystarczy, że poprosisz jednego ze strażników.%SPEECH_OFF%Obaj mężczyźni odwracają się i odchodzą. Wychodzisz do holu, gdzie tęgi człowiek wręcza ci sakiewkę %reward_completion% koron. | Wracając do %employer%a, emisariusz opuszcza twój bok i szybko - oraz cicho - przekazuje mu wieści. %employer% kiwa głową, nie zdradzając nic z treści, po czym pstryka na pobliskiego strażnika. Uzbrojony mężczyzna podchodzi i wręcza ci sakiewkę. Gdy ją bierzesz i podnosisz wzrok, szlachcic i emisariusz już zniknęli. | Po bezpiecznym przeprowadzeniu %envoy%a emisariusz dziękuje ci za usługi. %employer% nie jest tak przyjazny, ignoruje cię, by rozmawiać z tajemniczym emisariuszem. Gdy stoisz i czekasz na zapłatę, strażnik podkrada się i wciska ci w ramiona drewnianą skrzynię.%SPEECH_ON%To %reward_completion% koron. Możesz je policzyć, jeśli chcesz.%SPEECH_OFF% | Niewiele dowiadujesz się o tym, co chytry emisariusz %employer%a robił w tamtym miasteczku. Emisariusz i zleceniodawca witają się i od razu zaczynają rozmawiać, skuleni blisko i mówiąc półgłosem. Gdy podchodzisz zapytać o zapłatę, strażnik cię zatrzymuje i wciska w ramiona sakiewkę. Jest w niej %reward_completion% koron, jak obiecano. Nie interesując się polityką, nie zostajesz długo, by zobaczyć, co knują ci dwaj mężczyźni. | %employer% wita cię z otwartymi ramionami.%SPEECH_ON%Ach, utrzymałeś %envoy%a przy życiu!%SPEECH_OFF%Przytula emisariusza, a tobie ściska tylko dłoń, wkładając w nią sakiewkę z koronami.%SPEECH_ON%Wiedziałem, że mogę ci zaufać, najemniku. A teraz, proszę...%SPEECH_OFF%Wskazuje w stronę drzwi. Odchodzisz, zostawiając obu mężczyzn na rozmowę.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Zapłata w pełni zasłużona.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Bezpiecznie odeskortowałeś emisariusza");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "Po bitwie",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Emisariusz nie przeżył. %employer% potrafi przyjąć straty tu i tam, ale z tego nie będzie zadowolony. Postaraj się go więcej nie zawodzić. | Niestety, %envoy% %envoy_title% leży martwy u twoich stóp. Co za okropny los dla człowieka, któremu obiecano bezpieczeństwo! Cóż. W przyszłości lepiej nie zawodzić %employer%a raz za razem. | No proszę: emisariusz nie żyje. Twoim jedynym zadaniem było utrzymać go przy życiu. Teraz już tego nie robi. Nie musisz rozmawiać z %employer%em, by wiedzieć, że nie będzie z tego zadowolony. | Obiecałeś utrzymać emisariusza z dala od krzywdy. Trudno o większą krzywdę niż śmierć, więc wygląda na to, że w tej robocie spektakularnie zawiodłeś. | Strzeż emisariusza. Po prostu utrzymaj go przy życiu. Emisariusz musi przeżyć. Hej, jestem emisariuszem, jestem zbyt ważny, by umrzeć!\n\nTe słowa musiały paść na głuche uszy, bo emisariusz faktycznie nie żyje. | Trudno utrzymać człowieka przy życiu, gdy cały świat chce jego śmierci. Niestety, %envoy% %envoy_title% nie dotarł do celu. %employer% raczej nie będzie zadowolony z tej straconej duszy.}",
			Image = "",
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "A niech to!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Nie zdołałeś ochronić emisariusza");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective",
			this.m.Flags.get("DestinationName")
		]);
		_vars.push([
			"bribe",
			this.m.Flags.get("Bribe")
		]);
		_vars.push([
			"envoy",
			this.m.Flags.get("EnvoyName")
		]);
		_vars.push([
			"envoy_title",
			this.m.Flags.get("EnvoyTitle")
		]);
		_vars.push([
			"enemynoblehouse",
			this.m.Flags.get("EnemyName")
		]);
		_vars.push([
			"direction",
			this.m.Destination != null && !this.m.Destination.isNull() ? this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Destination.getTile())] : ""
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.m.Destination.getSprite("selection").Visible = false;
			this.m.Home.getSprite("selection").Visible = false;
			this.World.State.setUseGuests(true);
			this.World.getGuestRoster().clear();
		}
	}

	function onIsValid()
	{
		if (this.World.FactionManager.isCivilWar())
		{
			return false;
		}

		if (this.m.IsStarted)
		{
			if (this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive())
			{
				return false;
			}

			return true;
		}
		else
		{
			local settlements = this.World.EntityManager.getSettlements();
			local hasPotentialDestination = false;

			foreach( s in settlements )
			{
				if (!s.isDiscovered() || s.isMilitary() || s.isIsolated())
				{
					continue;
				}

				if (s.getOwner() == null || s.getOwner().getID() == this.getFaction())
				{
					continue;
				}

				hasPotentialDestination = true;
				break;
			}

			if (!hasPotentialDestination)
			{
				return false;
			}

			return true;
		}
	}

	function onIsTileUsed( _tile )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull() && _tile.ID == this.m.Destination.getTile().ID)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull())
		{
			_out.writeU32(this.m.Destination.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local dest = _in.readU32();

		if (dest != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(dest));
		}

		this.contract.onDeserialize(_in);
	}

});

