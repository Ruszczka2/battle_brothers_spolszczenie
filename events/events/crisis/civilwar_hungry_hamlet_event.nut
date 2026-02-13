this.civilwar_hungry_hamlet_event <- this.inherit("scripts/events/event", {
	m = {
		NobleHouse = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_hungry_hamlet";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_79.png[/img]{Podczas podróży natrafiasz na małą osadę, z której, jak się wydaje, cała ludność stoi na zewnątrz. Ich przywódca wychodzi naprzód, wyciągając ręce w błagalnym geście, choć ledwo ma siłę je utrzymać.%SPEECH_ON%Proszę, pomożecie nam? Jesteśmy bez jedzenia już prawie tydzień. Zeszliśmy do jedzenia ziemi! Musisz zrozumieć, nie mamy nic! Wojna nas wszystkich spustoszyła.%SPEECH_OFF% | Przy twojej drodze pojawia się mała osada, niewiele więcej niż przelotny błysk, gdyby nie duża grupa wieśniaków stojących na zewnątrz, jakby na ciebie czekali. Ich przywódca występuje.%SPEECH_ON%Najemniku, wiem, że pewnie nie do ciebie powinno się z tym zwracać, ale czy masz coś do jedzenia? Wojna zniszczyła nasze uprawy, a żołnierze, którzy włóczą się po tych ziemiach, zabrali wszystko, co zostało! Proszę, pomóż nam!%SPEECH_OFF% | Droga prowadzi cię do małej osady. Wieśniacy kucają przed chatami, głowy mają między kolanami, są chudzi i poszarzali. Dzieci są z nimi, kruche i żylaste, a jednak z blaskiem młodości w oczach. Przywódca wioski podchodzi do ciebie osobiście.%SPEECH_ON%Panie... najemniku? Tak, najemniku. Proszę, od tygodnia nie mamy jedzenia. Przetrwaliśmy dzięki naszym zwierzętom, owadom... nawet ziemi. Czy masz coś, by nam pomóc?%SPEECH_OFF% | Gdy twoi ludzie odpoczywają przy drodze, podchodzą do ciebie mieszkańcy pobliskiej osady. Chwieją się naprzód, chude nogi kołyszą ich z boku na bok. Przywódca grupy podnosi i opuszcza dłoń, jakby błogosławił twoją obecność.%SPEECH_ON%Och, najemniku, błagamy, masz coś do jedzenia? Nie mieliśmy ani kęsa od dwóch dni! A to, co jedliśmy, lepiej nawet nie mówić na głos! Wojna między rodami zrujnowała to miejsce, ale może możesz pomóc?%SPEECH_OFF%}",
			Characters = [],
			Options = [
				{
					Text = "Dobrze, dajmy tym biednym ludziom trochę jedzenia.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(3);
						local r = this.Math.rand(1, 3);

						if (r == 1)
						{
							return "B";
						}
						else if (r == 2)
						{
							return "C";
						}
						else if (r == 3)
						{
							return "D";
						}
					}

				},
				{
					Text = "Radźcie sobie sami, chłopi.",
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
			Text = "[img]gfx/ui/events/event_79.png[/img]{Wbrew typowemu rozsądkowi najemnika decydujesz się dać biednym wieśniakom trochę jedzenia. %randombrother% ma rozdzielić tyle, ile może, choć oczywiście nie za dużo. Ludzie są dozgonnie wdzięczni, oblepiają najemnika jakby miał zaraz wyszeptać wielką i niezapomnianą prawdę. Przywódca miasteczka mówi, że rozniesie wieść o twojej dobroci. Nie masz pewności, czy sława altruizmu jest dobra dla najemników... | Zaskakując wieśniaków, każesz %randombrother% rozdać trochę jedzenia. Nie za dużo, tylko tyle, by ci ludzie mogli zjeść. I oczywiście, nie oddawaj niczego zbyt dobrego!\n\n Przywódca osady podchodzi do ciebie, ściska dłonie i klepie po ramionach.%SPEECH_ON%Nie masz pojęcia, co to dla nas znaczy! Wszyscy usłyszą o dobru w...%SPEECH_OFF%Spogląda na ciebie, potem na wasz sztandar. Kiwasz głową.%SPEECH_ON%%companyname%.%SPEECH_OFF%Mężczyzna śmieje się.%SPEECH_ON%Oczywiście! Wszyscy usłyszą o %companyname%!%SPEECH_OFF%}",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Oby w nadchodzących dniach wiodło im się lepiej.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.distributeFood(this.List);
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
				this.List.insert(0, {
					id = 10,
					icon = "ui/icons/special.png",
					text = "Kompania zyskała renomę"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_79.png[/img]{Dobroć bierze górę: każesz %randombrother% zacząć rozdawać jedzenie. Wykonuje rozkaz, ale gdy tylko zaczyna je wydawać, tłum niemal wpada w szał, wyrywając je sobie z rąk. Puste brzuchy szybko rozpalają gniew. Najemnik próbuje utrzymać porządek, ale cokolwiek powie, tylko utwierdza głodnych, że to jego wina. Przemoc eskaluje, ironicznie rozrzucając całe jedzenie w błocie. Twoi bracia muszą dobyć mieczy i ostatecznie kilku chłopów leży martwych, a ocalali patrzą na ciała z kanibalistycznym błyskiem w oczach.\n\n Szybko rozkazujesz %companyname% ruszać dalej, zanim zrobi się jeszcze gorzej. | Z jakiegoś powodu, być może by lepiej spać w nocy, każesz %randombrother% rozdawać paczki z jedzeniem. Dopiero zaczyna, gdy jeden z wieśniaków porywa worek jedzenia. Inny chłop rozbija mu głowę i zabiera worek dla siebie. Szybko wybucha totalna bijatyka i twoi najemnicy muszą dobyć broni, by chronić resztę zapasów. Po bójce kilku wieśniaków leży martwych, a twoi bracia są nieco poturbowani. Nie widząc sensu zostawania, każesz kompanii wrócić na drogę. Przywódca, który prosił o pomoc, stoi gdzieś w oddali, wpatrzony w horyzont, podczas gdy gorzki wiatr owija jego cienkie portki wokół piszczeli.}",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Szybko poszło na złe.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.distributeFood(this.List);
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_79.png[/img]Cóż. Ten świat jest okropny, więc jeśli możesz choć trochę złagodzić jego ohydę, czemu nie? Każesz %randombrother% zacząć rozdawać jedzenie, ale nie za dużo i niczego, za czym byś tęsknił. Gdy zajmuje się tym, pojawia się kilku żołnierzy machających sztandarem %noblehouse%. Przeczesują głodny tłum, zabierając jedzenie i dobywając mieczy, gdy ktoś stawia opór. Ich rzekomy przywódca odzywa się.%SPEECH_ON%To jedzenie jest potrzebne na rzecz ramienia %noblehouse%. Nie opierajcie się jego przejęciu.%SPEECH_OFF%Wyjaśniasz mężczyźnie, że to w istocie twoje jedzenie i dopiero co je rozdaliście.%SPEECH_ON%Jeśli to twoje jedzenie, to czemu jest w ich rękach? No dalej, ludzie, bierzcie, ile się da! I nie próbuj niczego, najemniku, bo będzie przemoc.%SPEECH_OFF%%randombrother% spogląda na ciebie, jakby pytał, co mamy robić?",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "To nasze jedzenie i my decydujemy, co z nim zrobić!",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "E";
						}
						else
						{
							return "F";
						}
					}

				},
				{
					Text = "To nasze jedzenie, ale to nie nasza wojna.",
					function getResult( _event )
					{
						return "G";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.distributeFood(this.List);
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_79.png[/img]Porucznik odwraca się do swoich ludzi, kierując ich złodziejstwem. Dobywasz miecza i kulejąc podchodzisz, ból w boku wciąż ci dokucza, ale nie potrzeba wiele, by podejść do człowieka. Szybkim ruchem przykładasz mu ostrze do szyi i wołasz do reszty jego ludzi.%SPEECH_ON%Naprawdę chcecie przemocy?%SPEECH_OFF%Z uniesionymi rękami porucznik piszczy.%SPEECH_ON%Czekajcie, chwila. Chyba, eee, popełniliśmy błąd. To nie ta wioska, panowie.%SPEECH_OFF%Nacinasz go mieczem, po czym puszczasz. Chłopi cieszą się, gdy jedzenie do nich wraca. Bez wątpienia szlachta usłyszy o twoich \"dobrych\" uczynkach, ale usłyszy też pospólstwo.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Czasem dobrze jest być głupim.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "You threatened some of their men");
				this.World.Assets.addMoralReputation(3);
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess * 2);
				this.List.insert(0, {
					id = 10,
					icon = "ui/icons/special.png",
					text = "Kompania zyskała renomę"
				});
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_79.png[/img]Chwytasz porucznika za ramię i przyciągasz go blisko. Łapie cię za ramię i odpycha, jednocześnie sięgając po miecz. Wyskakujesz mu na bok, blokujesz dobycie i wyciągasz sztylet, wbijając go w szyję. Jego żołnierze przeciskają się przez tłum, ale twoi najemnicy ich ścinają, a chłopi dobijają z brutalnością, jaką potrafi stworzyć tylko głód. Porucznik powoli osuwa się z twojego uścisku. Patrzysz w dół na jego ciemniejące oczy.%SPEECH_ON%Tak, będzie przemoc.%SPEECH_OFF%Chłopi wiwatują, choć zalecasz im pochować ciała albo, lepiej, zniknąć stąd. Bez wątpienia jakaś armia zacznie się zastanawiać, gdzie zniknęli ci ludzie.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "My też powinniśmy ruszać.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationOffense, "You killed some of their men");
				this.World.Assets.addMoralReputation(1);
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess * 2);
				this.List.insert(0, {
					id = 10,
					icon = "ui/icons/special.png",
					text = "Kompania zyskała renomę"
				});
				local brothers = this.World.getPlayerRoster().getAll();
				local bro = brothers[this.Math.rand(0, brothers.len() - 1)];
				local injury = bro.addInjury(this.Const.Injury.Accident1);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = bro.getName() + " cierpi na " + injury.getNameOnly()
				});
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_79.png[/img]Mówisz swoim ludziom, by się wycofali. Pospólstwo jęczy, gdy jedzenie znów jest im odbierane. To straszliwy krzyk i wielu cię przeklina, mówiąc, że woleliby, abyś wcale się nie pojawił, niż żeby byli tak dręczeni. | Dawać jedzenie to jedno, sprzeczać się z żołnierzami to drugie. Informujesz żołnierzy, że nie będzie walki i mogą kontynuować. Pospólstwo krzyczy, błagając, byś to powstrzymał. Niektórzy są zbyt słabi, by powiedzieć cokolwiek, bo ten nagły zwrot wydarzeń był większym ciosem niż długie tygodnie głodu.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Przykro mi...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.World.Assets.addBusinessReputation(-this.Const.World.Assets.ReputationOnContractSuccess);
				this.List.insert(0, {
					id = 10,
					icon = "ui/icons/special.png",
					text = "Kompania traci renomę"
				});
			}

		});
	}

	function distributeFood( _list )
	{
		local food = this.World.Assets.getFoodItems();

		for( local i = 0; i < 2; i = ++i )
		{
			local idx = this.Math.rand(0, food.len() - 1);
			local item = food[idx];
			_list.push({
				id = 10,
				icon = "ui/items/" + item.getIcon(),
				text = "Tracisz " + item.getName()
			});
			this.World.Assets.getStash().remove(item);
			food.remove(idx);
		}

		this.World.Assets.updateFood();
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
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

		local food = this.World.Assets.getFoodItems();

		if (food.len() < 3)
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local bestDistance = 9000;
		local bestTown;

		foreach( t in towns )
		{
			if (t.isSouthern())
			{
				continue;
			}

			local d = playerTile.getDistanceTo(t.getTile());

			if (d <= bestDistance)
			{
				bestDistance = d;
				bestTown = t;
				break;
			}
		}

		if (bestTown == null)
		{
			return;
		}

		this.m.NobleHouse = bestTown.getOwner();
		this.m.Score = 10;
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
	}

	function onClear()
	{
		this.m.NobleHouse = null;
	}

});

