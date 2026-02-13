this.civilwar_conscription_event <- this.inherit("scripts/events/event", {
	m = {
		NobleHouse = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_conscription";
		this.m.Title = "W %town%";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Żołnierze %noblehouse% próbują wcielić miejscowych. Chłopi, co zrozumiałe, nie chcą mieć nic wspólnego z wojną i odmawiają dobrowolnego pójścia. Porucznik chorążych, wyraźnie zbyt nieliczny na taką sytuację, prosi cię o pomoc. | Natrafiasz na tłum chłopów, którzy przekrzykują kilku żołnierzy %noblehouse%. Oświadczają, że nie wezmą udziału w wojnach między rodami.%SPEECH_ON%Co nam dali panowie!%SPEECH_OFF%pyta jeden, a wielu mu przyklaskuje. Porucznik odgryza się.%SPEECH_ON%Obdarzył was swoją ziemią, byście wy i wasze rodziny mogli prosperować!%SPEECH_OFF%Stary człowiek spluwa.%SPEECH_ON%To nie była ziemia tego starego kutasa. Nie była niczyja, dopóki ten gnojek nie powiedział, że jest inaczej. A dlaczego? Bo nabrał jakichś opancerzonych gburów, że ma rację?%SPEECH_OFF%Tłum wiwatuje coraz głośniej.%SPEECH_ON%Już zabraliście nam wielu, więc spadajcie! Skoro ich życia nie rozwiązały waszych szlacheckich swarów, to co ma dać zabranie ostatnich z nas?%SPEECH_OFF%Porucznik zwraca się do ciebie i prosi o pomoc, jakbyś miał szczególne zdolności przekonywania ludzi do umierania za sprawy, które ich nie obchodzą. | Gęsty tłum chłopów tarasuje drogę prowadzącą przez %town%. Gdy podchodzisz bliżej, widzisz grupę chorążych z %noblehouse%, którzy próbują wcielić pospólstwo i wyraźnie nie jest to walka, w której ludzie chcą brać udział. Nie mając dość ludzi, by samemu opanować sytuację, porucznik żołnierzy zwraca się do ciebie.%SPEECH_ON%Ach, najemniku. Czy mógłbyś łaskawie sprawić, by ci nędznicy poszli z nami? Szlachta usłyszy o twoim czynie...%SPEECH_OFF% | Wydaje się, że każdy mieszkaniec stoi na drodze, która wije się przez %town%. Przepychasz się przez tłum i docierasz do małej grupy zdezorientowanych i przerażonych żołnierzy %noblehouse%. Ich porucznik ma uniesione dłonie, a z jednej zwisa zwój.%SPEECH_ON%To nie moje rozkazy, ale zamierzam je wykonać!%SPEECH_OFF%Chłop spluwa.%SPEECH_ON%Tak, zanieś je do grobu!%SPEECH_OFF%Widząc cię, porucznik błaga o pomoc.%SPEECH_ON%Najemniku! Potrzebujemy żołnierzy do wielkiej wojny między rodami... Ci... głupcy nie wykonują rozkazów. Rozkazu panów! Pomóż nam, a osobiście dopilnuję, by szlachta usłyszała o twojej robocie tutaj.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Dobrze. Czas odpracować swoje, chłopi!",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-1);

						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				},
				{
					Text = "To nie ich wojna, poruczniku.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);

						if (this.Math.rand(1, 100) <= 50)
						{
							return "D";
						}
						else
						{
							return "E";
						}
					}

				},
				{
					Text = "To w ogóle nie nasza wojna.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_43.png[/img]{To nie jest twoja wojna i ma z tobą niewiele wspólnego, ale czujesz, że dobra wola u szlachty zaprocentuje w przyszłości. Mając to na uwadze, rozkazujesz swoim ludziom zacząć spędzać chłopów, rozdzielając młodych od starych i słabych od silnych. Widząc, że twoi ludzie wyglądają, jakby bez wahania mogli rąbać pospólstwo, chłopi potulnie wykonują rozkazy. Porucznik wybiera kilku z tej \"partii\" i pędzi ich na drogę. Dziękuje ci za pracę i mówi, że szlachta usłyszy o %companyname%. | Dobywszy miecza, każesz chłopom ustawić się od najsilniejszych do najsłabszych. Spoglądasz na porucznika.%SPEECH_ON%Kobiety?%SPEECH_OFF%Kręci głową. Zwracasz się do tłumu.%SPEECH_ON%Tylko mężczyźni! Od najsilniejszych do najsłabszych. Ruszać się.%SPEECH_OFF%Przy rozproszonych pomrukach i bezsilnym płaczu pospólstwo wykonuje rozkaz. Porucznik informuje cię, że szlachta usłyszy o twoich czynach.}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Cieszę się, że mogłem pomóc.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Helped conscript some peasants");
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationMinorOffense, "Helped conscript their populace");
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_60.png[/img]{To nie twoja wojna, ale nie masz wątpliwości, że zyskanie przychylności szlachty pomoże ci w przyszłości. Każesz swoim ludziom zacząć rozdzielać tłum, wyciągając najsilniejszych od najsłabszych. Ale chłopi nie współpracują - kamień śwista obok twojej twarzy. %randombrother% rusza w tłum i przebija napastnika na wylot. Kilku wieśniaków kontruje, wyciągając widły i pochodnie. Reszta %companyname% dobywa broni i po kilku szybkich zabójstwach tłum się uspokaja. Rozglądasz się za porucznikiem, ale jego i jego ludzi nigdzie nie widać. | Dobywszy miecza, każesz wiosce ustawić się w kolejce, od najsilniejszych do najsłabszych. Zamiast tego stary człowiek podjudza ich źle wyczutymi hasłami przeciwko wojnie. %randombrother% podchodzi do durnia i ucisza go ciosem prosto w błoto. Niestety tylko bardziej wkurza to tłum i wybucha wielka bijatyka. Twoi najemnicy są bezlitośni, ścinając każdego, kto ośmieli się stanąć przeciw kompanii. Gdy wszystko się kończy, w błocie leżą martwi i konający, doglądani przez kobiety o zdezorientowanych i zasmuconych twarzach, a porucznik i jego żołnierze zniknęli bez śladu.}",
			Banner = "",
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
				this.World.Assets.addMoralReputation(-2);
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationAttacked, "Cut down their populace");
				local brothers = this.World.getPlayerRoster().getAll();
				local candidates = [];

				foreach( bro in brothers )
				{
					if (!bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
					{
						candidates.push(bro);
					}
				}

				local numInjured = this.Math.min(candidates.len(), this.Math.rand(1, 3));

				for( local i = 0; i < numInjured; i = ++i )
				{
					local idx = this.Math.rand(0, candidates.len() - 1);
					local bro = candidates[idx];
					candidates.remove(idx);

					if (this.Math.rand(1, 100) <= 50)
					{
						local injury = bro.addInjury(this.Const.Injury.Brawl);
						this.List.push({
							id = 10,
							icon = injury.getIcon(),
							text = bro.getName() + " cierpi na " + injury.getNameOnly()
						});
					}
					else
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " odnosi lekkie rany"
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Zwracasz się do porucznika.%SPEECH_ON%To nie nasza wojna, a jeśli nie potrafisz znaleźć kilku dobrych ludzi do walki, to może i nie twoja. Wracaj do domu.%SPEECH_OFF%Porucznik poprawia zbroję i prostuje się.%SPEECH_ON%Z tobą czy bez ciebie, pójdą z nami.%SPEECH_OFF%Gdy kończy, kamień uderza go w głowę i pozbawia przytomności. Dwóch żołnierzy rzuca się na pomoc i zaczyna go odciągać. Jeden pluje w twoją stronę.%SPEECH_ON%Nie myśl, że o tym zapomnimy.%SPEECH_OFF%Kiwasz głową w stronę porucznika.%SPEECH_ON%Tak, lepiej zapamiętaj, bo on na pewno nie.%SPEECH_OFF% | Porucznik krzyżuje ramiona, jakby mówił \"no?\". Kręcisz głową.%SPEECH_ON%Znajdź kogoś innego do pacyfikowania chłopów. Jeśli sam nie potrafisz tego zrobić, może wasza strona nie jest dość silna, by wygrać?%SPEECH_OFF%Parska i podchodzi bliżej, niemal stykając się z tobą piersią. Kilku chłopów podchodzi ze wszystkich stron, nagle uzbrojonych w widły i kosy. Porucznik zerka na twoje niespodziewane wsparcie, potem znów na ciebie. Ustępuje.%SPEECH_ON%Dobrze, niech będzie. Szlachta usłyszy o twoich przewinach, najemniku.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Idź się wypchaj.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationMinorOffense, "Prevented their men from conscripting peasants");
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationFavor, "Saved their populace from being conscripted");
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Mówisz porucznikowi, że nie chcesz mieć nic wspólnego z jego wyjątkowo nieudaną kampanią werbunkową. Kiwając głową, dobywa miecza, a jego ludzie robią to samo.%SPEECH_ON%Dobrze, skoro nie weźmiemy tych gburów za rękę, weźmiemy ich za kark. Każdy, kto odmawia posłuchu wezwaniu panów, zginie tu dziś.%SPEECH_OFF%Tłum cofa się, słychać szelest nędznych ubrań i nieśmiałe pomruki. %randombrother% spogląda na ciebie.%SPEECH_ON%Panie, mamy coś zrobić? Ten paw tam pewnie przez dumę doprowadzi do śmierci wielu ludzi.%SPEECH_OFF% | Porucznik stuka butem.%SPEECH_ON%No i co, pomożesz czy nie?%SPEECH_OFF%Patrzysz na tłum boso i łachmaniarsko ubranych, choć kilku silnych mężczyzn stoi wśród słabych, jak drzewa przy lichym płocie. Odwracasz się do porucznika i kręcisz głową na nie. Wzrusza ramionami.%SPEECH_ON%Dobra, ludzie. Na pewno nie wrócimy bez nich. Wrócimy z ich głowami, jeśli trzeba!%SPEECH_OFF%Mężczyzna dobywa miecza, a żołnierze idą za jego przykładem. Tłum cofa się jak chmura much spędzona z powietrza. %randombrother% podchodzi do ciebie.%SPEECH_ON%Mamy coś zrobić? Ci idioci są w mniejszości, ale na pewno doprowadzą do śmierci wielu ludzi, gdy będą szli na swoje idiotyczne zguby.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Nie wtrącamy się.",
					function getResult( _event )
					{
						return "F";
					}

				},
				{
					Text = "Pomagamy chorążym!",
					function getResult( _event )
					{
						return "G";
					}

				},
				{
					Text = "Pomagamy chłopom!",
					function getResult( _event )
					{
						return "H";
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
			Text = "[img]gfx/ui/events/event_02.png[/img]Wojna szlachty nie była twoją wojną. Spędzanie chłopów też nie było twoją wojną. I powstrzymywanie żołnierzy przed rzezią pospólstwa również nie jest twoją wojną. Każesz braciom odsunąć się na bok.\n\n Zgodnie z przewidywaniami żołnierze wpadają w tłum, wymachując mieczami i okładając buławami. Kilku dzielnych wieśniaków pada, nie mając czym zatrzymać natarcia, lecz sama liczebność chłopów szybko przytłacza porucznika i jego ludzi. Kilkoro dzieci przewraca komin chaty, a deszcz kamieni miażdży żołnierza w błocie. Gdy reszta żołnierzy zawiesza broń, rolnik podbiega i przebija jednego widłami, unosząc go w górę jak snopek siana. Porucznik załamuje się i ucieka, ale potyka się o parę kobiet, które spadają na niego z nożami do strzyżenia.\n\n Gdy wszystko się kończy, wielu wieśniaków i każdy żołnierz leży martwy. Zwycięsko, mieszkańcy miasta wciągają chorążych do lasu i wieszają ich ciała dla dalszego znieważenia. Najemnicy dziękują ci, że nie wplątałeś się niepotrzebnie.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "No dobrze. Ruszajmy.",
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
			ID = "G",
			Text = "[img]gfx/ui/events/event_94.png[/img]Trzeba tu dokonać wyboru - stanąć po stronie bezsilnego pospólstwa albo iść z brutalnymi ambasadorami tych, którzy dzierżą władzę jak puchar pijanej dziewki. Spośród tych dwóch opcji uznajesz, że druga może lepiej służyć w przyszłości. Rozkazujesz %companyname% stanąć po stronie żołnierzy. To szybka bitwa, kończąca się ucieczką chłopów przez pola i błaganiem kobiet, by nie dobijano rannych. Ich próśb nikt nie słucha.\n\n Czyszcząc klingę, porucznik dziękuje ci za uratowanie jego i jego ludzi.%SPEECH_ON%To nie była najmądrzejsza decyzja, jaką mogłem podjąć, ale z jakiegoś powodu wiedziałem, że wkroczysz z pomocą. Dawno nie miałem tak dobrego dnia mordowania. Dzięki, najemniku. Szlachta usłyszy o twoich czynach tutaj.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Cieszę się, że mogłem pomóc.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Helped their men conscript some peasants");
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationAttacked, "Cut down their populace");
				local brothers = this.World.getPlayerRoster().getAll();
				local candidates = [];

				foreach( bro in brothers )
				{
					if (!bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
					{
						candidates.push(bro);
					}
				}

				local numInjured = this.Math.min(candidates.len(), this.Math.rand(1, 3));

				for( local i = 0; i < numInjured; i = ++i )
				{
					local idx = this.Math.rand(0, candidates.len() - 1);
					local bro = candidates[idx];
					candidates.remove(idx);

					if (this.Math.rand(1, 100) <= 50)
					{
						local injury = bro.addInjury(this.Const.Injury.Brawl);
						this.List.push({
							id = 10,
							icon = injury.getIcon(),
							text = bro.getName() + " cierpi na " + injury.getNameOnly()
						});
					}
					else
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " odnosi lekkie rany"
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_87.png[/img]Ach, bezsilne pospólstwo stające przeciwko butowi niemoralnej szlachty. Stajesz po stronie biedniejszego z dwóch dupków. Gdy tylko żołnierze ścierają się z chłopami, rozkazujesz %companyname% uderzyć od tyłu na chorążych i posprzątać. Każdy żołnierz zostaje szybko dźgnięty w plecy. Z porucznikiem rozprawiasz się sam, tnąc go sztyletem przez szyję. Odwraca się, ściskając śmiertelną ranę, jakby dało się naprawić nienaprawialne. Widząc cię, jego oczy rozszerzają się ze zdumienia, jakby nigdy nie spodziewał się zdrady ze strony najemnika. Wykrztusza strumień krwi, po czym osuwa się na kolana i przewraca do tyłu w błoto.\n\n Starszy mężczyzna powoli podchodzi, gdy czyścisz klingę. Dziękuje ci za ocalenie wioski, choćby i małej, i obiecuje rozgłosić twoją - jak to ujął - \"świętą\" reputację.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Czy dobrze zrobiliśmy?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationAttacked, "Killed some of their men");
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationFavor, "Saved their populace from being conscripted");
				this.World.Assets.addMoralReputation(4);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local bestDistance = 9000;
		local bestTown;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() > 1)
			{
				continue;
			}

			local d = playerTile.getDistanceTo(t.getTile());

			if (d < bestDistance)
			{
				bestDistance = d;
				bestTown = t;
			}
		}

		if (bestTown == null || bestDistance > 3)
		{
			return;
		}

		this.m.NobleHouse = bestTown.getOwner();
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
			"town",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.NobleHouse = null;
		this.m.Town = null;
	}

});

