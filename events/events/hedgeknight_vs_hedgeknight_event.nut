this.hedgeknight_vs_hedgeknight_event <- this.inherit("scripts/events/event", {
	m = {
		HedgeKnight1 = null,
		HedgeKnight2 = null,
		NonHedgeKnight = null,
		Monk = null
	},
	function create()
	{
		this.m.ID = "event.hedgeknight_vs_hedgeknight";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%nonhedgeknight% wpada do twojego namiotu, niemal wyrywając jeden z kołków i zwalając całość. Pot spływa mu z twarzy na twoje mapy. Patrzysz na niego spojrzeniem, które domaga się sensownego wyjaśnienia. Wyjaśnia, że rycerze z żywopłotu %hedgeknight1% i %hedgeknight2% wdali się w bójkę. Oboje chwycili broń i wyglądają, jakby mieli się nawzajem pozabijać. Dwóch największych ludzi w kompanii walczących ze sobą to raczej nie najlepsze dla zdrowia... no, wszystkich. Szybko ruszasz na miejsce.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zaprowadź mnie do nich.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.NonHedgeKnight.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_35.png[/img]Zastajesz %hedgeknight1% z wielkim mieczem w dłoni, a %hedgeknight2% kręci ogromnym toporem jak dziecko kijem. Większość ludzi się odsunęła. %nonhedgeknight% wyjaśnia, że obaj {mają niedokończone sprawy z turnieju rycerskiego | spotkali się kiedyś na polu bitwy po przeciwnych stronach i teraz chcą dokończyć dawno rozpoczęty pojedynek | chcą rozstrzygnąć spór między sobą według starej tradycji śmiertelnego pojedynku}. Inny brat podchodzi, błagając, by rycerze odłożyli różnice na bok, ale %hedgeknight2% odrzuca go na bok. Golemy siły i grozy, którymi są, być może rozsądnie jest zakończyć tę konfrontację?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niech wygra najsilniejszy.",
					function getResult( _event )
					{
						return _event.m.Monk == null ? "C1" : "C2";
					}

				},
				{
					Text = "Słuchajcie mnie, zachowajcie siły na pole bitwy!",
					function getResult( _event )
					{
						return _event.m.Monk == null ? "C3" : "C4";
					}

				},
				{
					Text = "Po tysiąc koron dla każdego, żebyście natychmiast przerwali to szaleństwo!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C1",
			Text = "[img]gfx/ui/events/event_35.png[/img]%nonhedgeknight% woła do ciebie, prosząc, byś przerwał walkę. Dwaj rycerze spoglądają, a ich ogromne piersi unoszą się ciężko oddechem. Machasz ręką zbywająco. Rycerze kiwają głowami i szarżują na siebie. Zderzenie jest głośne, metal pęka, kości trzaskają. Przy każdej próbie zabicia słychać pomruki, tak donośne stają się wymachy bronią. Miecz zahacza o drzewce ogromnego topora, a ostrza pękają o siebie. Rycerze wymieniają okrutne spojrzenia nad skrzyżowaniem, po czym szybko rozbrajają się i dobywają sztyletów, dźgając się nawzajem, gdy padają na ziemię. Żaden z nich nie wydaje się przejęty ranami. Porzucają liche sztylety i przechodzą na własne pięści, bijąc się tak mocno, że widzisz zęby rozsypujące się wśród rozbryzgów krwi.\n\nPonownie kompania spogląda na ciebie po wskazówki, bo staje się oczywiste, że ci ludzie chcą walczyć do końca.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To wymyka się spod kontroli. Wszyscy, zatrzymajcie ich!",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Zobaczmy, kto jest najsilniejszy w walce.",
					function getResult( _event )
					{
						return this.Math.rand(1, _event.m.HedgeKnight1.getLevel() + _event.m.HedgeKnight2.getLevel()) <= _event.m.HedgeKnight1.getLevel() ? "F" : "G";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				_event.m.HedgeKnight1.addLightInjury();
				_event.m.HedgeKnight2.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight1.getName() + " doznaje lekkich ran"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight2.getName() + " doznaje lekkich ran"
				});
			}

		});
		this.m.Screens.push({
			ID = "C3",
			Text = "[img]gfx/ui/events/event_35.png[/img]Dwaj rycerze stoją, patrząc tylko na siebie i nie zważając na twoje słowa, a każdy oddech unosi ich potężne piersi. Po krótkiej chwili ruszają na siebie. Zderzenie jest głośne, metal pęka, kości trzaskają. Przy każdej próbie zabicia słychać pomruki, tak donośne stają się wymachy bronią. Miecz zahacza o drzewce ogromnego topora, a ostrza pękają o siebie. Rycerze wymieniają okrutne spojrzenia nad skrzyżowaniem, po czym szybko rozbrajają się i dobywają sztyletów, dźgając się nawzajem, gdy padają na ziemię. Żaden z nich nie wydaje się przejęty ranami. Porzucają liche sztylety i przechodzą na własne pięści, bijąc się tak mocno, że widzisz zęby rozsypujące się wśród rozbryzgów krwi.\n\nKompania spogląda na ciebie po wskazówki, bo staje się oczywiste, że ci ludzie chcą walczyć do końca.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To wymyka się spod kontroli. Wszyscy, zatrzymajcie ich!",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Zobaczmy, kto jest najsilniejszy w walce.",
					function getResult( _event )
					{
						return this.Math.rand(1, _event.m.HedgeKnight1.getLevel() + _event.m.HedgeKnight2.getLevel()) <= _event.m.HedgeKnight1.getLevel() ? "F" : "G";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				_event.m.HedgeKnight1.addLightInjury();
				_event.m.HedgeKnight2.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight1.getName() + " doznaje lekkich ran"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight2.getName() + " doznaje lekkich ran"
				});
			}

		});
		this.m.Screens.push({
			ID = "C2",
			Text = "[img]gfx/ui/events/event_35.png[/img]%nonhedgeknight% woła do ciebie, prosząc, byś przerwał walkę. Dwaj rycerze spoglądają, a ich ogromne piersi unoszą się ciężko oddechem. Machasz ręką zbywająco. Rycerze kiwają głowami i szarżują na siebie. Zderzenie jest głośne, metal pęka, kości trzaskają. Przy każdej próbie zabicia słychać pomruki, tak donośne stają się wymachy bronią. Miecz zahacza o drzewce ogromnego topora, a ostrza pękają o siebie. Rycerze wymieniają okrutne spojrzenia nad skrzyżowaniem, po czym szybko rozbrajają się i dobywają sztyletów, dźgając się nawzajem, gdy padają na ziemię. Żaden z nich nie wydaje się przejęty ranami. Porzucają liche sztylety i przechodzą na własne pięści, bijąc się tak mocno, że widzisz zęby rozsypujące się wśród rozbryzgów krwi.\n\nPonownie kompania spogląda na ciebie po wskazówki, bo staje się oczywiste, że ci ludzie chcą walczyć do końca.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To wymyka się spod kontroli. Wszyscy, zatrzymajcie ich!",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Zobaczmy, kto jest najsilniejszy w walce.",
					function getResult( _event )
					{
						return this.Math.rand(1, _event.m.HedgeKnight1.getLevel() + _event.m.HedgeKnight2.getLevel()) <= _event.m.HedgeKnight1.getLevel() ? "F" : "G";
					}

				},
				{
					Text = "%monk%, mnichu! Czy potrafisz znaleźć pokojowe rozwiązanie?",
					function getResult( _event )
					{
						return "H";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				_event.m.HedgeKnight1.addLightInjury();
				_event.m.HedgeKnight2.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight1.getName() + " doznaje lekkich ran"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight2.getName() + " doznaje lekkich ran"
				});
			}

		});
		this.m.Screens.push({
			ID = "C4",
			Text = "[img]gfx/ui/events/event_35.png[/img]Dwaj rycerze stoją, patrząc tylko na siebie i nie zważając na twoje słowa, a każdy oddech unosi ich potężne piersi. Po krótkiej chwili ruszają na siebie. Zderzenie jest głośne, metal pęka, kości trzaskają. Przy każdej próbie zabicia słychać pomruki, tak donośne stają się wymachy bronią. Miecz zahacza o drzewce ogromnego topora, a ostrza pękają o siebie. Rycerze wymieniają okrutne spojrzenia nad skrzyżowaniem, po czym szybko rozbrajają się i dobywają sztyletów, dźgając się nawzajem, gdy padają na ziemię. Żaden z nich nie wydaje się przejęty ranami. Porzucają liche sztylety i przechodzą na własne pięści, bijąc się tak mocno, że widzisz zęby rozsypujące się wśród rozbryzgów krwi.\n\nKompania spogląda na ciebie po wskazówki, bo staje się oczywiste, że ci ludzie chcą walczyć do końca.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To wymyka się spod kontroli. Wszyscy, zatrzymajcie ich!",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Zobaczmy, kto jest najsilniejszy w walce.",
					function getResult( _event )
					{
						return this.Math.rand(1, _event.m.HedgeKnight1.getLevel() + _event.m.HedgeKnight2.getLevel()) <= _event.m.HedgeKnight1.getLevel() ? "F" : "G";
					}

				},
				{
					Text = "%monk%, mnichu, czy potrafisz znaleźć pokojowe rozwiązanie?",
					function getResult( _event )
					{
						return "H";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				_event.m.HedgeKnight1.addLightInjury();
				_event.m.HedgeKnight2.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight1.getName() + " doznaje lekkich ran"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight2.getName() + " doznaje lekkich ran"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_04.png[/img]Wyciągasz sakiewkę ciężką od monet. Dwaj rycerze spoglądają, a dźwięk brzęczącego złota trudno przeoczyć.%SPEECH_ON%Po tysiąc koron dla każdego, tak?%SPEECH_OFF%Mężczyźni wymieniają spojrzenia. Wzruszają ramionami. Kiwasz głową.%SPEECH_ON%Dobrze, ale to się więcej nie powtórzy, rozumiecie?%SPEECH_OFF%Oni też kiwają głowami, podchodząc i przyjmując korony z bezwstydną łatwością. Niektórzy bracia są nieco poirytowani, że ci ludzie dostali darmowe pieniądze właściwie za to, że nie walczyli. Rycerze niechętnie godzą się ze sobą, bardziej zajęci liczeniem pieniędzy niż zabijaniem się nawzajem. Masz tylko nadzieję, że dostali po równo, inaczej świętowanie może wrócić.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niech to potrwa.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				this.World.Assets.addMoney(-2000);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]2000[/color] Koron"
					}
				];
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.HedgeKnight1.getID() || bro.getID() == _event.m.HedgeKnight2.getID())
					{
						continue;
					}

					if (bro.getSkills().hasSkill("trait.greedy"))
					{
						bro.worsenMood(2.0, "Angry about you bribing men to stop their fight");
					}
					else if (this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(1.0, "Concerned about you bribing men to stop their fight");
					}

					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[bro.getMoodState()],
						text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_35.png[/img]Widząc dość, rozkazujesz ludziom interweniować. Wahają się, ale szybko przypominasz im o ich obowiązkach kontraktowych. Ludzie chwytają wielkie płachty skóry i koce, garnki i patelnie, a kilku niesie wiadra. Ich strategia jest rozsądna: wiadra lądują na głowach rycerzy, oślepiając ich na tyle długo, by zarzucić na nich resztę. Jak człowiek zapaśnik z bykiem, ludzie szarpią się z rycerzami, czasem wylatując w powietrze, a jeden brat dostaje kopniaka w twarz, zyskując czarny, bezzębny uśmiech za swoje trudy. Inny zostaje połknięty przez masę koców, zgniatany między warczącymi rycerzami jak bezkształtna kula wściekłości.\n\nW końcu obaj mężczyźni się uspokajają i walka dobiega końca. Niechętnie zawierają pokój, byś nie kazał reszcie ludzi chwycić prawdziwej broni i zakończyć bójkę. Reszta kompanii podnosi się, jakby przez obóz właśnie przeszło wielkie tornado. Zliczasz obrażenia i zaczynasz rozdzielać pomoc.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wreszcie po wszystkim.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.HedgeKnight1.getID() || bro.getID() == _event.m.HedgeKnight2.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 60)
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 75)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " doznaje lekkich ran"
						});
					}
					else
					{
						local injury = bro.addInjury(this.Const.Injury.Brawl);
						this.List.push({
							id = 10,
							icon = injury.getIcon(),
							text = bro.getName() + " doznaje " + injury.getNameOnly()
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_35.png[/img]Siadasz na pniu i oglądasz dalszy ciąg walki. Mężczyźni turlają się po ziemi, okładając się pięściami w twarz takimi, które zabiłyby konia. W końcu %hedgeknight1% siada okrakiem na ramionach %hedgeknight2%. Widząc pobliski kamień, %hedgeknight1% chwyta go i rozbija o czaszkę przeciwnika. Kawałek ciała zostaje zdarty, odsłaniając pod spodem czerwień i biel. Kamień opada ponownie. Czaszka pęka, a odłamki kości rozrywają się w kawałki. %hedgeknight2% wiotczeje, pokazując już tylko resztki woli walki. %hedgeknight1% wbija pięść w czaszkę i wyrywa jej zawartość w jednym wielkim strumieniu purpury. Na ten widok robi ci się niedobrze, a kilku ludzi odwraca się i wymiotuje.\n\n%hedgeknight1% wstaje i rzuca trofeum w wysoką trawę. Ociera czoło i mówi tylko jedno słowo.%SPEECH_ON%Skończone.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Przynajmniej śmierć w walce dla %hedgeknight2%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				local dead = _event.m.HedgeKnight2;
				local fallen = {
					Name = dead.getName(),
					Time = this.World.getTime().Days,
					TimeWithCompany = this.Math.max(1, dead.getDaysWithCompany()),
					Kills = dead.getLifetimeStats().Kills,
					Battles = dead.getLifetimeStats().Battles,
					KilledBy = "Killed in a duel by " + _event.m.HedgeKnight1.getName(),
					Expendable = false
				};
				this.World.Statistics.addFallen(fallen);
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.HedgeKnight2.getName() + " zginął"
				});
				_event.m.HedgeKnight2.getItems().transferToStash(this.World.Assets.getStash());
				_event.m.HedgeKnight2.getSkills().onDeath(this.Const.FatalityType.None);
				this.World.getPlayerRoster().remove(_event.m.HedgeKnight2);
				local injury = _event.m.HedgeKnight1.addInjury(this.Const.Injury.Brawl);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.HedgeKnight1.getName() + " doznaje " + injury.getNameOnly()
				});

				if (this.Math.rand(1, 2) == 1)
				{
					local v = this.Math.rand(1, 2);
					_event.m.HedgeKnight1.getBaseProperties().MeleeSkill += v;
					this.List.push({
						id = 16,
						icon = "ui/icons/melee_skill.png",
						text = _event.m.HedgeKnight1.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + v + "[/color] Umiejętności Walki Wręcz"
					});
				}
				else
				{
					local v = this.Math.rand(1, 2);
					_event.m.HedgeKnight1.getBaseProperties().MeleeDefense += v;
					this.List.push({
						id = 16,
						icon = "ui/icons/melee_defense.png",
						text = _event.m.HedgeKnight1.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + v + "[/color] Obrony Wręcz"
					});
				}

				_event.m.HedgeKnight1.getSkills().update();
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_35.png[/img]Chcesz usiąść na pobliskim pniu, ale odskakujesz, gdy dwaj rycerze wpadają prosto na ciebie. Głowa %hedgeknight1% z impetem uderza w to, co miało być twoim siedzeniem. Szybko się odwraca, by stanąć naprzeciw napastnika. Napotyka jedynie but %hedgeknight2%, a zderzenie skóry i skóry buta rozlega się obrzydliwym klapnięciem. Teraz, dławiąc się własnymi zębami, %hedgeknight1% pyta, czy to wszystko, na co stać %hedgeknight2%. W odpowiedzi %hedgeknight2% kopie go w głowę raz za razem, a każde uniesienie buta ukazuje %hedgeknight1% w coraz gorszym stanie: od zakrwawionej czerwieni po koszmarny skręt mięsa i powiek, spłaszczony nos i uśmiech grozy, gdzie jego zęby albo zniknęły, albo wiszą na nabrzmiałych krwią dziąsłach jak gwoździe na obdartej ze skóry dłoni.\n\nW końcu czaszka zostaje zmiażdżona, a seria pękających blaszek kości brzmi jak coś spadającego przez gałęzie zimowego drzewa. Odwracasz wzrok w odrazie, ale niektórzy bracia nie potrafią, jeden wymiotuje. Zerkając, by zobaczyć, jakie są szkody, widzisz, że pięta %hedgeknight2% jest w połowie gardła, a czubek buta mieli mózg drugiego człowieka. Przeklina, próbując wydostać to, co zadało śmiertelny cios.\n\nOcalały rycerz musi pociągnąć za udo, by wyciągnąć stopę z czaszki. Odwraca się, ciągnąc stopę po trawie, i podnosi piętę jak dziecko wracające po całym dniu zabawy, uważnie sprawdzając, by nie wnieść żadnego bałaganu. Odrywa bryłę mózgu i odrzuca ją jakby właśnie obierał kukurydzę. Pocierając brzuch, pyta, czy ktoś jest głodny, po czym bierze talerz kaszy i wraca do swojego namiotu.\n\nPóźniej w nocy, po tym jak szybko stłumiłeś spisek, by usunąć go dla bezpieczeństwa kompanii, znajdujesz %hedgeknight2% śpiącego jak niemowlę.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Przynajmniej śmierć w walce dla %hedgeknight1%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				local dead = _event.m.HedgeKnight1;
				local fallen = {
					Name = dead.getName(),
					Time = this.World.getTime().Days,
					TimeWithCompany = this.Math.max(1, dead.getDaysWithCompany()),
					Kills = dead.getLifetimeStats().Kills,
					Battles = dead.getLifetimeStats().Battles,
					KilledBy = "Killed in a duel by " + _event.m.HedgeKnight2.getName(),
					Expendable = false
				};
				this.World.Statistics.addFallen(fallen);
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.HedgeKnight1.getName() + " zginął"
				});
				_event.m.HedgeKnight1.getItems().transferToStash(this.World.Assets.getStash());
				_event.m.HedgeKnight1.getSkills().onDeath(this.Const.FatalityType.None);
				this.World.getPlayerRoster().remove(_event.m.HedgeKnight1);
				local injury = _event.m.HedgeKnight2.addInjury(this.Const.Injury.Brawl);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.HedgeKnight2.getName() + " doznaje " + injury.getNameOnly()
				});

				if (this.Math.rand(1, 2) == 1)
				{
					local v = this.Math.rand(1, 2);
					_event.m.HedgeKnight2.getBaseProperties().MeleeSkill += v;
					this.List.push({
						id = 16,
						icon = "ui/icons/melee_skill.png",
						text = _event.m.HedgeKnight2.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + v + "[/color] Umiejętności Walki Wręcz"
					});
				}
				else
				{
					local v = this.Math.rand(1, 2);
					_event.m.HedgeKnight2.getBaseProperties().MeleeDefense += v;
					this.List.push({
						id = 16,
						icon = "ui/icons/melee_defense.png",
						text = _event.m.HedgeKnight2.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + v + "[/color] Obrony Wręcz"
					});
				}

				_event.m.HedgeKnight2.getSkills().update();
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_05.png[/img]Mnich kiwa głową, wychodzi naprzód i spokojnie przechodzi między dwoma mężczyznami. Ręce ma uniesione, palce zataczają kręgi, naśladując kształty dawnych rytów religijnych. Mówi o bogach i o tym, jak osądzają ludzi za to, kim są i co robią. Mówi, że niektórzy bogowie mogliby uznać tę walkę za korzystną, ale większość nie. Przede wszystkim jednak mnich mówi, że jeśli naprawdę chcą walczyć, to po śmierci jest na to dość miejsca. Jeśli jednak pozabijają się nawzajem, przegrany otrzyma wielki prestiż w zaświatach, a zwycięzca nie, bo ta przemoc nie służy niczemu poza dumą zwycięzcy. Zaskakująco, ta osobliwość zasad religijnych uspokaja mężczyzn. Mnich zaprasza ich do dalszej rozmowy i tak też robią, cała trójka odchodzi, gestykulując i wybuchając gromkim śmiechem. Reszta kompanii po prostu cieszy się, że nikt nie zginął.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dzięki bogom.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());

				if (!_event.m.Monk.getFlags().has("resolve_via_hedgeknight"))
				{
					_event.m.Monk.getFlags().add("resolve_via_hedgeknight");
					_event.m.Monk.getBaseProperties().Bravery += 2;
					_event.m.Monk.getSkills().update();
					this.List = [
						{
							id = 16,
							icon = "ui/icons/bravery.png",
							text = _event.m.Monk.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Determinacji"
						}
					];
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() < 2000)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 4)
		{
			return;
		}

		local candidates = [];
		local candidates_other = [];
		local candidates_monk = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.hedge_knight")
			{
				candidates.push(bro);
			}
			else
			{
				candidates_other.push(bro);

				if (bro.getBackground().getID() == "background.monk")
				{
					candidates_monk.push(bro);
				}
			}
		}

		if (candidates.len() < 2 || candidates_other.len() == 0 && candidates.len() <= 2)
		{
			return;
		}

		local r = this.Math.rand(0, candidates.len() - 1);
		this.m.HedgeKnight1 = candidates[r];
		candidates.remove(r);
		r = this.Math.rand(0, candidates.len() - 1);
		this.m.HedgeKnight2 = candidates[r];
		candidates.remove(r);

		if (candidates_other.len() > 0)
		{
			this.m.NonHedgeKnight = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		}
		else
		{
			this.m.NonHedgeKnight = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		if (candidates_monk.len() != 0)
		{
			this.m.Monk = candidates_monk[this.Math.rand(0, candidates_monk.len() - 1)];
		}

		this.m.Score = (2 + candidates.len()) * 6;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hedgeknight1",
			this.m.HedgeKnight1.getName()
		]);
		_vars.push([
			"hedgeknight2",
			this.m.HedgeKnight2.getName()
		]);
		_vars.push([
			"nonhedgeknight",
			this.m.NonHedgeKnight.getName()
		]);
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getName() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.HedgeKnight1 = null;
		this.m.HedgeKnight2 = null;
		this.m.NonHedgeKnight = null;
		this.m.Monk = null;
	}

});

