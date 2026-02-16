this.black_market_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Price = 0,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.black_market";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_01.png[/img]{Wózki z owocami w %townname% są załadowane wszelkimi pysznościami, choć paskudnie drogimi. Zerkasz na jednego z właścicieli, próbując wyczuć moment, gdy odwróci wzrok, by skorzystać z pięciopalcowej zniżki. Właśnie gdy masz zamiar coś podprowadzić, %anatomist% anatomista podbiega w pośpiechu i, co ważniejsze, zwraca na siebie całą uwagę. Odstawiasz drobną kradzież i pytasz, czego chce. Uśmiecha się.%SPEECH_ON%Znaleźliśmy czarny rynek %townname%.%SPEECH_OFF%Idziesz na miejsce i widzisz cherlawego mężczyznę opierającego się o krzesło. Na stole przed nim leży zestaw \'towarów\', o ile można je tak nazwać. Dla ciebie to sterta byle jakiego badziewia, ale dla anatomisty to niemal dar starych bogów. Ziewając, chudzielec mówi, żebyś wybrał. %anatomist% pochyla się, ocenia towar i wskazuje trzy rzeczy o wątpliwej jakości i niejasnym przeznaczeniu. Ostrzega, że kompania powinna kupić tylko jeden.%SPEECH_ON%Jeśli straż miejska znajdzie nas z zbyt wieloma, mogą wziąć nas za handlarzy, a handel takimi dobrami jest ciężkim przestępstwem.%SPEECH_OFF%Przyglądasz się opcjom.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Weźmy to coś wyglądające na mózg za 100 koron.",
					function getResult( _event )
					{
						_event.m.Price = 100;
						return this.Math.rand(1, 100) <= 85 ? "Brain" : "Bunk";
					}

				},
				{
					Text = "Wezmę to wielkie serce za... 550 koron, tak?",
					function getResult( _event )
					{
						_event.m.Price = 550;
						return this.Math.rand(1, 100) <= 95 ? "Heart" : "Bunk";
					}

				},
				{
					Text = "Zapłacę 200 koron za to... coś w rodzaju gruczołu?",
					function getResult( _event )
					{
						_event.m.Price = 200;
						return this.Math.rand(1, 100) <= 90 ? "Gland" : "Bunk";
					}

				},
				{
					Text = "Nie stać nas na takie fanaberie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Brain",
			Text = "[img]gfx/ui/events/event_14.png[/img]{Kupujesz coś, co wygląda jak bryła skondensowanych makaronów, gąbczaste pasma szare z czarnymi kropkami na miękkiej strukturze. Dość obrzydliwie, %anatomist% kładzie całą dłoń na tej substancji i naciska. Gdy odrywa rękę, ślad pozostaje, mięso pęka, gdy odkleja się i wraca na miejsce. Uśmiecha się.%SPEECH_ON%Sądzę, że możemy wiele z tego wykorzystać w badaniach.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Obrzydliwe, ale niech będzie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Zdobył obiecujący okaz do badań");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.addXP(200, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Doświadczenia"
				});
				this.World.Assets.addMoney(-_event.m.Price);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Price + "[/color] Koron"
				});
				local part = this.new("scripts/items/misc/ghoul_brain_item");
				this.World.Assets.getStash().add(part);
				this.List.push({
					id = 10,
					icon = "ui/items/" + part.getIcon(),
					text = "Zyskujesz " + part.getName()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Heart",
			Text = "[img]gfx/ui/events/event_14.png[/img]{Do przewiezienia ogromnego organu potrzebna jest taczka. %anatomist% twierdzi, że to serce Unholta i że będzie bardzo przydatne jako okaz do badań. Taczkę opuszcza się i obaj na nie patrzycie: ty, niewykształcony laik, widzisz coś obrzydliwego i odpychającego, a anatomista, wykształcony laik, widzi coś obrzydliwego i fascynującego. Niepokoi cię, że coś tak ogromnego może być w sercu bestii. Serce człowieka jest małe, a jednak pompuje z ogniem i determinacją, by podporządkować sobie świat. A to serce...\n\nNiepokojąco, %anatomist% zaciska pięść i uderza nią w jedną z komór serca. Widzisz, jak mięsień się porusza, jakby wciąż pompował i pulsował. Wyciąga rękę i patrzy na brud: czarne tkanki i śluzowata warstwa pleśni lub krwi, albo krwawej pleśni.%SPEECH_ON%Nasze badania wiele zyskają na tym okazie.%SPEECH_OFF%Patrzy na ciebie, jakby szukał potwierdzenia. Spoglądasz na obciążoną taczkę i mówisz mu, że jeśli to jego okaz, to jego kręgosłup pęknie, gdy będzie targał to cholerstwo.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pamiętaj, zginaj nogi w kolanach.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Zdobył obiecujący okaz do badań");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.addXP(200, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Doświadczenia"
				});
				this.World.Assets.addMoney(-_event.m.Price);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Price + "[/color] Koron"
				});
				local part = this.new("scripts/items/misc/unhold_heart_item");
				this.World.Assets.getStash().add(part);
				this.List.push({
					id = 10,
					icon = "ui/items/" + part.getIcon(),
					text = "Zyskujesz " + part.getName()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Gland",
			Text = "[img]gfx/ui/events/event_14.png[/img]{Dla ciebie ten zakup wygląda jak popiołowe strączki groszku skręcane ze sobą. Szare grudy wyginają się i spłaszczają na organie, a jego mięśnie falują i wykręcają się jak marynarskie liny. Fale kończą się na tłustej bulwie tkanki. %anatomist% wyjaśnia.%SPEECH_ON%Wierzy się, że to organ, który daje wilkorowi tak wiele energii. Nawet jego kształt ma dziką strukturę, jakby organ sam chciał odtwarzać swój cel.%SPEECH_OFF%Nacina tkankę i odgarnia ją, ukazując sieć mięsnych tuneli i kanałów, które kończą się dziwacznym kompleksem komór. Nie wiadomo, do czego człowiek mógłby to wykorzystać, ale gdy %anatomist% zaczyna wkładać palce w otwory, szybko odchodzisz, ostrzegając go tylko, by nie robił tego tak publicznie, bo wzbudzi w chłopach ochotę na lincz.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I obetnij paznokcie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Zdobył obiecujący okaz do badań");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.addXP(200, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Doświadczenia"
				});
				this.World.Assets.addMoney(-_event.m.Price);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Price + "[/color] Koron"
				});
				local part = this.new("scripts/items/misc/adrenaline_gland_item");
				this.World.Assets.getStash().add(part);
				this.List.push({
					id = 10,
					icon = "ui/items/" + part.getIcon(),
					text = "Zyskujesz " + part.getName()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Bunk",
			Text = "[img]gfx/ui/events/event_14.png[/img]{Kiedy wracacie do kompanii, %anatomist% wydaje się nieco rozczarowany zakupem. Próbuje wydobyć z niego coś użytecznego, coś, czego nikt dotąd nie widział, ale wygląda na to, że jego przedsięwzięcie kończy się niczym. Narzeka, że te części zna już od dawna, że już o nich pisano i że inni ludzie zasłynęli dzięki swoim odkryciom. Przegryzając jedzenie, przytakujesz, gdy opowiada, i udajesz, że cię to obchodzi, gdy patrzy na ciebie smutnymi oczami. Mówi.%SPEECH_ON%To substancja, którą jedzą orki, a czasem jest wycięta z samego orka. Wiemy o tym od lat. Myślałem, że wyciągnę z tego coś, czego jeszcze nie poznano, ale moja pewność siebie doprowadziła tylko do zmarnowania koron.%SPEECH_OFF%Nabierasz łyżkę kaszy i wpychasz do ust. Wyjmujesz łyżkę i wpatrujesz się w swoje zniekształcone odbicie. Kiwając głową, mówisz.%SPEECH_ON%To wszystko takie fascynujące. A próbowałeś to zjeść?%SPEECH_OFF%Anatomista wpatruje się w dziwne mięso. Przyznaje, że nie sądzi, by ktokolwiek próbował, przynajmniej w celach naukowych. Patrzy na mięso jeszcze chwilę. Mamrocze.%SPEECH_ON%To byłaby kwestia naukowa, prawda?%SPEECH_OFF%Bierzesz kolejny kęs i przytakujesz. %anatomist% wkłada rękę w dziwne mięso i wyciąga żebro ociekające mokrą tkanką. Zaczyna mieć odruchy wymiotne, szybko wstaje i ucieka. Bierzesz dziwne żebro i rzucasz je ze stołu, a gdy tylko dotyka ziemi, z zaułka wyskakuje sfora dzikich psów i walczy między sobą, by je zjeść. Wskazujesz na psy i krzyczysz za anatomistą.%SPEECH_ON%Hej, chyba właśnie przeprowadziłem eksperyment!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Patrz, jak się o to biją.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(0.5, "Obiecujący okaz do badań okazał się bezużyteczny");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.World.Assets.addMoney(-_event.m.Price);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Price + "[/color] Koron"
				});
				local food = this.new("scripts/items/supplies/strange_meat_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Zyskujesz " + food.getName()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins || !this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		if (this.World.Assets.getMoney() < 650)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary())
			{
				continue;
			}

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
		local anatomistCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
		}

		if (anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Price = 0;
		this.m.Town = null;
	}

});

