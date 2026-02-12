this.dogfighting_event <- this.inherit("scripts/events/event", {
	m = {
		Doghandler = null,
		Wardog = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.dogfighting";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%townImage%%doghandler% prosi, byś zgłosił %wardog% do lokalnego kręgu walk psów. Brzmi to jak okropny pomysł, ale mężczyzna wyjaśnia, że na walkach psów można zarobić sporo pieniędzy. Od ciebie potrzebny jest tylko wkład w wysokości dwustu koron.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze, ale idę z tobą.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Nie ma mowy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%townImage%Zabierasz sakiewkę koron i podążasz za %doghandler% w głąb coraz ciemniejszych ulic. Wkrótce niewiele widać. Mokry bruk, lizany bielą smug księżyca, leniwie prowadzi cię w głębiny miasta, których nie chcą widzieć ci, którzy wolą dzień. Nagle rozbłyska pochodnia, a unosząca się w ciemności, odcięta twarz mężczyzny odzywa się do ciebie.%SPEECH_ON%Ten pies na walki?%SPEECH_OFF%%doghandler% kiwa głową. Nieznajomy przechyla pochodnię do przodu.%SPEECH_ON%Dobrze. Tędy, panowie. Uważajcie na krok. Wszystkie siki spływają w dół.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zróbmy to.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Zmieniłem zdanie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "%townImage%Podążając za pochodnią w ciemnościach, docierasz do budynku z przesuwną bramą. Nieznajomy wystukuje na drzwiach wzór, a te otwierają się, jakby posłuszne ostatniemu stuknięciu. Wprowadza was do środka, a z boku obserwują was drwiące twarze. Natychmiast słyszysz niepokojący zgiełk warczenia i szczekania. Właśnie po to tu jesteś, prawda?\n\n Schody prowadzą do dołów, gdzie tłum kłębi się wokół prowizorycznej areny z ziemi i chwiejących się słupków. Akcji jeszcze nie widać, ale z boku leży sterta martwych psów, a obok nich siedzą ich zabójcy, oczy dzikie, zakrwawione pyski otwarte w przerażonym dyszeniu. Gdy na arenie zderzają się dwa psy, spoglądasz na %doghandler%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Czas wyłożyć stawkę i zobaczyć, co potrafi nasz kundel.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "To jest złe. Wynośmy się stąd.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_47.png[/img]Po opłaceniu wpisowego w wysokości dwustu koron, ty i %doghandler% wprowadzacie %wardog% na arenę.\n\nJego oczy biegają na wszystkie strony, a gdy jego bark opiera się o twoją nogawkę, czujesz przyspieszone bicie serca. Naprzeciw stoi wasza konkurencja: obleśny przewodnik psów i ogromna bestia, bardziej wilk niż pies. Kundlowi brakuje dolnej wargi, odsłaniając poszarpany rząd zębów, które zostały wyszczerbione tak, by były jeszcze groźniejsze. Strupy i rany pokrywają jego krzywe ciało, ale muskularna sylwetka jest wyraźna, a %doghandler% szepcze, że będzie brzydko.\n\n %wardog% popiskuje i szarżuje do przodu, kundel z wojną we krwi, a ty, wyciągniętą dłonią, wypuszczasz ogara dokładnie wtedy, gdy robi to twój przeciwnik.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bierz go, chłopcze!",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 33)
						{
							return "E";
						}
						else if (r <= 66)
						{
							return "F";
						}
						else
						{
							return "G";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
				this.World.Assets.addMoney(-200);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]200[/color] Koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_47.png[/img]Dwa psy pędzą ku sobie i w mgnieniu oka pokrywają małą arenę. Zderzają się, ich surowe ciała wirują od siebie, po czym znów stają na łapach i rzucają się do kolejnego starcia. Pies przeciwnika nurkuje pod %wardog%, po czym wznosi się i zaciska na spodzie szyi twojego psa.\n\n%doghandler% zakrywa twarz dłońmi, a jego oczy patrzą spomiędzy palców. Widzisz, jak %wardog% jest miotany na boki. Krew tryska mu z nosa, gdy skowyczy. Słychać drapanie bezradnych, nożycujących łap, gdy pies próbuje się odpychać po ziemi. Publiczność szydzi i śmieje się.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie mogę interweniować.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "H" : "I";
					}

				},
				{
					Text = "To musi się skończyć!",
					function getResult( _event )
					{
						return "J";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_47.png[/img]Dwa psy pędzą przez arenę. %wardog% idzie wysoko, a przeciwnik nisko. Z przerażeniem patrzysz, jak kundel rywala wyskakuje ze swojej niskiej pozycji i zaciska szczęki pod szyją %wardog%. Toczą się po arenie, a w brutalnym impetcie gardło %wardog% zostaje wyrwane na czysto. Krew tryska tak gwałtownie, że publiczność odskakuje do tyłu. Zwycięski kundel wraca do właściciela i rzuca mu pod nogi strzęp mięsa i mięśni.\n\n%wardog% potyka się na ziemi. Dławi się powietrzem, jego gardło drży, świszczy i bulgocze. %doghandler% przeskakuje przez płot i klęka przy kundlu. Próbuje zatamować ranę, ale to na nic. Pies patrzy na ciebie, gdy umiera.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cholera!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
				_event.m.Wardog.getContainer().unequip(_event.m.Wardog);
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Wardog.getIcon(),
					text = _event.m.Wardog.getName() + " ginie."
				});
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_47.png[/img]Dwa psy przez chwilę warczą, po czym ruszają do szarży. Zderzają się i jednocześnie zaciskają na swoich szyjach, wirując po arenie jak jakiś futrzany, brutalny bąk.\n\n%wardog% wciska przeciwnika w słupek ogrodzenia. Patrzysz, jak twój pies wbija szczęki w pysk rywala, przebijając mu zęby przez oko jednym kłapnięciem i wyrywając kawał języka drugim. Pokonany kundel zostaje dosłownie rozszarpany, a gdy pada, twój pies dopełnia egzekucji rozdarciem gardła.\n\nTwój przeciwnik krzyczy i próbuje przeskoczyć ogrodzenie, ale publiczność go odciąga. %doghandler% klepie cię po plecach.%SPEECH_ON%Łatwa kasa, co?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wygląda na to, że kompania ma też najgorsze i najgroźniejsze psy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
				this.World.Assets.addMoney(500);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Otrzymujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]500[/color] Koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_47.png[/img]Decydujesz się nie interweniować, pozwalając, by walka %wardog% i jego możliwa śmierć potoczyły się swoim torem. Wybór szybko zostaje nagrodzony: widzisz, jak twój pies opiera tylne łapy o jeden ze słupków ogrodzenia i jednym kopnięciem wsuwa się pod przeciwnika, by w obrzydliwym pokazie instynktu przetrwania wyrwać mu zwisające jądra. Biedny, wykastrowany kundel, wrzeszcząc, obraca się tylko po to, by włożyć szyję prosto w szczęki %wardog%. Walka kończy się szybko i niemal litościwie.\n\n Idziesz odebrać nagrodę, a %doghandler% przytula już merdającego ogonem %wardog%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobry pies.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
				this.World.Assets.addMoney(500);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Otrzymujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]500[/color] Koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_47.png[/img]Nie interweniujesz i musisz nawet powstrzymać %doghandler%, gdy mężczyzna próbuje przeskoczyć ogrodzenie. We dwóch możecie tylko patrzeć z przerażeniem, jak wściekły kundel odrywa kawałek po kawałku twarz %wardog% swoimi szczękami. Wkrótce twój pies osuwa się na ziemię, wystawiając szyję. Następuje krwawe rozdarcie i %wardog% bardzo szybko staje się martwym psem. Zrozpaczony %doghandler% może tylko osunąć się na ziemię i zakryć twarz.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cholera!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
				_event.m.Wardog.getContainer().unequip(_event.m.Wardog);
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Wardog.getIcon(),
					text = _event.m.Wardog.getName() + " ginie."
				});
			}

		});
		this.m.Screens.push({
			ID = "J",
			Text = "[img]gfx/ui/events/event_20.png[/img]Rzucasz swój kupon w błoto.%SPEECH_ON%Pierdolę to.%SPEECH_OFF%Jednym skokiem przeskakujesz ogrodzenie i wpadasz na arenę. %doghandler% jest tuż za tobą. Dwa psy wciąż walczą, ale szybkie kopnięcie rozdziela je. Prowadzący psy szybko chwyta %wardog% i wyciąga go z niebezpieczeństwa. Tłum gwiżdże, a butelki i kufle zaczynają fruwać. Mężczyzna dmucha w gwizdek, uciszając wszystkich. Wchodzi na arenę.%SPEECH_ON%Ci ludzie zapłacili, żeby zobaczyć krew. Jeśli im jej nie dacie, to lepiej znajdźcie inny sposób zapłaty. Co powiecie na dwieście koron? Albo po prostu położycie tego psa z powrotem.%SPEECH_OFF%Tłum chrupie knykciami i wyciąga noże, łańcuchy oraz inne prymitywne bronie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bierzcie te cholerne korony. Wychodzimy z naszym psem.",
					function getResult( _event )
					{
						return "K";
					}

				},
				{
					Text = "Walka będzie trwała.",
					function getResult( _event )
					{
						return "L";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "K",
			Text = "[img]gfx/ui/events/event_20.png[/img]Wyciągasz %demand% koron i podajesz je. Tłum gwiżdże, ale szef znów dmucha w gwizdek.%SPEECH_ON%Zamknąć się, do cholery! Zapłacił, więc on i jego głupi pies wychodzą.%SPEECH_OFF%Tłum cichnie. Zaczynasz wychodzić, a %doghandler% idzie za tobą z nieprzytomnym %wardog% zwisającym bezwładnie na jego ramionach. Kilku bywalców syczy i spluwa, ale to wszystko, co robią, i to ci w zupełności wystarcza.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wracajmy do obozu...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
				this.World.Assets.addMoney(-200);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]200[/color] Koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "L",
			Text = "[img]gfx/ui/events/event_20.png[/img]Rozkazujesz %doghandler% dobić psa. Jego oczy się rozszerzają.%SPEECH_ON%Nie możesz mówić poważnie.%SPEECH_OFF%Kiwasz głową, że możesz. %wardog% ledwo przytomny, sapie między przestraszoną czujnością a otępiałą nieświadomością. Gdy %doghandler% waha się ponownie, chwytasz psa i odciągasz go. Kiwasz głową do tłumu, a potem do przeciwnika, który wypuszcza swojego morderczego ogara po raz drugi. Zmęczone, wilgotne oczy %wardog% patrzą na ciebie, mrugają, po czym zamykają się. Kładziesz psa, a ogar przeciwnika rzuca się na niego z bestialską furią. Starasz się nie słuchać przerażającej śmierci rozgrywającej się u twoich stóp.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wracajmy do obozu...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
				_event.m.Wardog.getContainer().unequip(_event.m.Wardog);
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Wardog.getIcon(),
					text = _event.m.Wardog.getName() + " ginie."
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() < 250)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Doghandler = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Wardog = this.m.Doghandler.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
		this.m.Town = town;
		this.m.Score = candidates.len() * 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"doghandler",
			this.m.Doghandler.getNameOnly()
		]);
		_vars.push([
			"wardog",
			this.m.Wardog.getName()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
		_vars.push([
			"demand",
			"200"
		]);
	}

	function onClear()
	{
		this.m.Doghandler = null;
		this.m.Wardog = null;
		this.m.Town = null;
	}

});

