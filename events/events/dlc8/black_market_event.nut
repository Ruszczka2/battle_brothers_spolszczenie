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
			Text = "[img]gfx/ui/events/event_01.png[/img]{Wozki z owocami w %townname% sa zaladowane wszelkimi pysznosciami, choc paskudnie drogimi. Zerkasz na jednego z wlascicieli, probujac wyczuc moment, gdy odwróci wzrok, by skorzystac z pieciopalcowej znizki. Wlasnie gdy masz zamiar cos podprowadzic, %anatomist% anatomista podbiega w pospiechu i, co wazniejsze, zwraca na siebie cala uwage. Odstawiasz drobna kradziez i pytasz, czego chce. Usmiecha sie.%SPEECH_ON%Znalezlismy czarny rynek %townname%.%SPEECH_OFF%Idziesz na miejsce i widzisz cherlawego mezczyzne opierajacego sie o krzeslo. Na stole przed nim lezy zestaw \'towarow\', o ile mozna je tak nazwac. Dla ciebie to sterta byle jakiego badziewia, ale dla anatomisty to niemal dar starych bogow. Ziewajac, chudzielec mowi, zebys wybral. %anatomist% pochyla sie, ocenia towar i wskazuje trzy rzeczy o watpliwej jakosci i niejasnym przeznaczeniu. Ostrzega, ze kompania powinna kupic tylko jeden.%SPEECH_ON%Jesli straz miejska znajdzie nas z zbyt wieloma, moga wziac nas za handlarzy, a handel takimi dobrami jest ciezkim przestepstwem.%SPEECH_OFF%Przygladasz sie opcjom.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wezmy to cos wygladajace na mozg za 100 koron.",
					function getResult( _event )
					{
						_event.m.Price = 100;
						return this.Math.rand(1, 100) <= 85 ? "Brain" : "Bunk";
					}

				},
				{
					Text = "Wezme to wielkie serce za... 550 koron, tak?",
					function getResult( _event )
					{
						_event.m.Price = 550;
						return this.Math.rand(1, 100) <= 95 ? "Heart" : "Bunk";
					}

				},
				{
					Text = "Zaplace 200 koron za to... cos w rodzaju gruczolu?",
					function getResult( _event )
					{
						_event.m.Price = 200;
						return this.Math.rand(1, 100) <= 90 ? "Gland" : "Bunk";
					}

				},
				{
					Text = "Nie stac nas na takie fanaberie.",
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
			Text = "[img]gfx/ui/events/event_14.png[/img]{Kupujesz cos, co wyglada jak bryla skondensowanych makaronow, gabczaste pasma szare z czarnymi kropkami na miekkiej strukturze. Dosc obrzydliwie, %anatomist% kladzie cala dlon na tej substancji i naciska. Gdy odrywa reke, slad pozostaje, mieso pęka, gdy odkleja sie i wraca na miejsce. Usmiecha sie.%SPEECH_ON%Sądze, ze mozemy wiele z tego wykorzystac w badaniach.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Obrzydliwe, ale niech bedzie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Zdobyl obiecujacy okaz do badan");

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
					text = _event.m.Anatomist.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Doswiadczenia"
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
			Text = "[img]gfx/ui/events/event_14.png[/img]{Do przewiezienia ogromnego organu potrzebna jest taczka. %anatomist% twierdzi, ze to serce Unholta i ze bedzie bardzo przydatne jako okaz do badan. Taczke opuszcza sie i obaj na nie patrzycie: ty, niewyksztalcony laik, widzisz cos obrzydliwego i odpychajacego, a anatomista, wyksztalcony laik, widzi cos obrzydliwego i fascynujacego. Niepokoi cie, ze cos tak ogromnego moze byc w sercu bestii. Serce czlowieka jest male, a jednak pompuje z ogniem i determinacja, by podporzadkowac sobie swiat. A to serce...\n\nNiepokojaco, %anatomist% zaciska piesc i uderza nia w jedna z komor serca. Widzisz, jak miesien sie porusza, jakby wciaz pompowal i pulsowal. Wyciaga reke i patrzy na brud: czarne tkanki i sluzowata warstwa plesni lub krwi, albo krwawej plesni.%SPEECH_ON%Nasze badania wiele zyskaja na tym okazie.%SPEECH_OFF%Patrzy na ciebie, jakby szukal potwierdzenia. Spogladasz na obciazona taczke i mowisz mu, ze jesli to jego okaz, to jego kregoslup peknie, gdy bedzie targal to cholerstwo.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pamietaj, zginaj nogi w kolanach.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Zdobyl obiecujacy okaz do badan");

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
					text = _event.m.Anatomist.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Doswiadczenia"
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
			Text = "[img]gfx/ui/events/event_14.png[/img]{Dla ciebie ten zakup wyglada jak popiolowe straczki groszku skrecane ze soba. Szare grudy wyginaja sie i splaszczaja na organie, a jego miesnie falują i wykrecaja sie jak marynarskie liny. Fale koncza sie na tlustej bulwie tkanki. %anatomist% wyjasnia.%SPEECH_ON%Wierzy sie, ze to organ, ktory daje wilkorowi tak wiele energii. Nawet jego ksztalt ma dzika strukture, jakby organ sam chcial odtwarzac swoj cel.%SPEECH_OFF%Nacina tkanke i odgarnia ja, ukazujac siec miesnych tuneli i kanalow, ktore koncza sie dziwacznym kompleksem komor. Nie wiadomo, do czego czlowiek moglby to wykorzystac, ale gdy %anatomist% zaczyna wkladac palce w otwory, szybko odchodzisz, ostrzegajac go tylko, by nie robil tego tak publicznie, bo wzbudzi w chlopach ochote na lincz.}",
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
				_event.m.Anatomist.improveMood(1.0, "Zdobyl obiecujacy okaz do badan");

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
					text = _event.m.Anatomist.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Doswiadczenia"
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
			Text = "[img]gfx/ui/events/event_14.png[/img]{Kiedy wracacie do kompanii, %anatomist% wydaje sie nieco rozczarowany zakupem. Probuje wydobyc z niego cos uzytecznego, cos, czego nikt dotad nie widzial, ale wyglada na to, ze jego przedsięwziecie konczy sie niczym. Narzeka, ze te czesci zna juz od dawna, ze juz o nich pisano i ze inni ludzie zaslyneli dzieki swoim odkryciom. Przegryzajac jedzenie, przytakujesz, gdy opowiada, i udajesz, ze cie to obchodzi, gdy patrzy na ciebie smutnymi oczami. Mowi.%SPEECH_ON%To substancja, ktora jedza orki, a czasem jest wycieta z samego orka. Wiemy o tym od lat. Myslalem, ze wyciagne z tego cos, czego jeszcze nie poznano, ale moja pewnosc siebie doprowadzila tylko do zmarnowania koron.%SPEECH_OFF%Nabierasz lyzke kaszy i wpychasz do ust. Wyjmujesz lyzke i wpatrujesz sie w swoje znieksztalcone odbicie. Kiwajac glowa, mowisz.%SPEECH_ON%To wszystko takie fascynujace. A probowales to zjesc?%SPEECH_OFF%Anatomista wpatruje sie w dziwne mieso. Przyznaje, ze nie sadzi, by ktokolwiek probowal, przynajmniej w celach naukowych. Patrzy na mieso jeszcze chwile. Mamrocze.%SPEECH_ON%To bylaby kwestia naukowa, prawda?%SPEECH_OFF%Bierzesz kolejny kęs i przytakujesz. %anatomist% wklada reke w dziwne mieso i wyciaga zebro ociekajace mokra tkanka. Zaczyna miec odruchy wymiotne, szybko wstaje i ucieka. Bierzesz dziwne zebro i rzucasz je ze stolu, a gdy tylko dotyka ziemi, z zaułka wyskakuje sfora dzikich psow i walczy miedzy soba, by je zjesc. Wskazujesz na psy i krzyczysz za anatomista.%SPEECH_ON%Hej, chyba wlasnie przeprowadzilem eksperyment!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Patrz, jak sie o to bija.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(0.5, "Obiecujacy okaz do badan okazal sie bezuzyteczny");

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

