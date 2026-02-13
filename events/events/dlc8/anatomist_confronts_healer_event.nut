this.anatomist_confronts_healer_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Monk = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_confronts_healer";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_20.png[/img]{Wchodzisz do %townname%, gdzie siwobrody, elokwentny starszy pomaga rodzinie z chorym dzieckiem. Dla ciebie to nic niezwykłego. Dla %anatomist% anatomisty jest to jednak wielka obraza. Tak szybko idzie w stronę starszego, że wkraczasz mu na drogę, czując, że cokolwiek zamierza zrobić, odbije się źle na całej %companyname%. %anatomist% prostuje się.%SPEECH_ON%Przepraszam, ten człowiek udziela złych porad medycznych. Trzeba go sprostować.%SPEECH_OFF%Mając na uwadze miejscowych, ostrzegasz go, że wtrącanie się w lokalne zwyczaje bywa nierozsądne, a starszy jest niemal na pewno ich grotem. Może też pełnić ważniejsze funkcje, jak choćby nadzorować miejscową milicję. Anatomista jednak uparcie dąży do celu i chce uzbroić swoją wiedzę, używając jej nawet wtedy, gdyby miała rozerwać lokalną politykę na strzępy.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "No to go sprostuj.",
					function getResult( _event )
					{
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
					Text = "Nie warto drażnić miejscowych.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "%monk%, przemów mu do rozsądku?",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_17.png[/img]{Myślisz nad tym chwilę i decydujesz się pozwolić anatomiscie zrobić, co chce. Odsuwasz się i obserwujesz, mając nadzieję, że to nie będzie wydarzenie, które splami imię %companyname% bardziej, niż ten szarlatan już się do tego zabiera. %anatomist% przysiada obok starca i przez chwilę patrzą na siebie, a kilku chłopów także się gapi. Anatomista przykuca i pyta starca, czy wie, że informacje, które przekazuje, są nieprawdziwe.\n\nKu zaskoczeniu, starzec jest otwarty na rozmowę, i obaj siedzą, dyskutując przez długi czas. Zamiast obrazić się na uwagi obcego, mieszkańcy są równie zafascynowani każdą wiedzą, jaką może mieć. Pojawiają się spory o drobiazgi, ale %anatomist% tak się rozgrzewa przyjęciem, że zbywa je machnięciem ręki, a nawet kłamie, mówiąc, że te kwestie wciąż nie zostały rozstrzygnięte medycznie. Gdy wszystko się kończy, anatomista przekazuje starcowi kilka notatek, a wioska w zamian obdarowuje go pękiem smakołyków i dóbr.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Poszło dobrze.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Udzielił porad medycznych życzliwej publiczności");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.addXP(100, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+100[/color] doświadczenia"
				});
				local food;
				local r = this.Math.rand(1, 3);

				if (r == 1)
				{
					food = this.new("scripts/items/supplies/cured_venison_item");
				}
				else if (r == 2)
				{
					food = this.new("scripts/items/supplies/pickled_mushrooms_item");
				}
				else if (r == 3)
				{
					food = this.new("scripts/items/supplies/roots_and_berries_item");
				}

				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Zyskujesz " + food.getName()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_141.png[/img]{Myślisz nad tym chwilę i decydujesz się pozwolić anatomiscie zrobić, co chce. Odsuwasz się i obserwujesz, mając nadzieję, że to nie będzie wydarzenie, które splami imię %companyname% bardziej, niż ci szarlatani już się do tego zabierają. %anatomist% przysiada obok starca i przez chwilę patrzą na siebie, a kilku chłopów także się gapi. Anatomista przykuca i pyta starca, czy zdaje sobie sprawę, że jest szarlatanem. Łapiesz się za głowę. Starzec wstaje i odpycha anatomistę.%SPEECH_ON%A ty co, do cholery, za jeden? Wędrowiec z kufrem wymyślnych słów, co?%SPEECH_OFF%Anatomista wyciąga dłonie i spokojnie tłumaczy, że jest inteligentnym, bardzo dobrze wykształconym człowiekiem z- zanim dokończy, chłop podchodzi i wali go, przewracając prosto w błoto. %companyname% wskakuje, by ratować anatomistę, i w szarpaninie pada jeszcze kilka ciosów, ale na szczęście na tym się kończy. Zabierasz %anatomist% z powrotem do szeregów i każesz wszystkim się uspokoić, zanim najemnicza strona %companyname% wyjdzie na jaw przed całym pospólstwem. Starszy kiwa głową i mówi, że nie chce wzywać milicji do takich spraw. Wygląda na to, że wszyscy ledwo uniknęli o wiele bardziej krwawej afery. %anatomist% patrzy tylko na krew lecącą z nosa i zastanawia się, czy ktoś mierzy czas, by sprawdzić, jak długo krzepnie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cholerny głupiec.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(1.0, "Odrzucono jego porady medyczne");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Anatomist.getName() + " cierpi z powodu lekkich ran"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 10)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " cierpi z powodu lekkich ran"
						});
					}
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_64.png[/img]{%anatomist% próbuje cię minąć, ale kładziesz mu dłoń na ramieniu i zatrzymujesz go na miejscu. Wyjaśniasz, że korygowanie miejscowych w ich zwyczajach i wierzeniach to niebezpieczny grunt, a jako najemnicy i tak budzicie nieufność i jesteście w złym świetle. Ostatnie, czego potrzebujesz, to iskry rzucane na suche drewno wiejskich tradycji. Anatomista protestuje, ale trwasz przy swoim. Jeśli chce chodzić i poprawiać wszystkich i wszystko, może wrócić do szkół lub uniwersytetów, z których przyszedł. W końcu %anatomist% odchodzi. Zerkasz na starszego wioski akurat wtedy, gdy odgryza głowę żabie i wlewa jej krew do misy na przyszłe wróżby.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ruszajmy w drogę.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(1.0, "Odebrano mu szansę poprawienia złych praktyk medycznych");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_40.png[/img]{Gdy %anatomist% próbuje cię minąć, %monk% mnich interweniuje. Staje przy anatomiscie i spokojnie wyjaśnia, że to, iż ktoś się myli, nie oznacza, że obcy powinien wkraczać i go poprawiać. Utrata twarzy w oczach publiczności nie kończy się na poprawionym człowieku, lecz zwraca światło osądu na tego, kto krytykuje. %anatomist% rozważa to przez chwilę.%SPEECH_ON%Mówisz mi, że błąd nie leży w złych poradach, lecz w tym, że cała społeczność jest tak nasiąknięta fałszem, iż wejście prawdy niczego nie naprawi, a tylko roznieci ogień, by bronić tego, w co błędnie wierzą?%SPEECH_OFF%Mnich zaciska usta i wzrusza ramionami.%SPEECH_ON%Tak.%SPEECH_OFF%Anatomista nie sprzecza się dalej i odchodzi, być może rozważając naukowy aspekt sprawy. Gdy znika, mnich kręci głową.%SPEECH_ON%Po prostu nie chcę, żeby zachowywał się jak dureń i wpędzał %companyname% w większe kłopoty, niż to potrzebne.%SPEECH_OFF%Przytakujesz i dziękujesz mnichowi, że ujął to lepiej, niż kiedykolwiek byś potrafił.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dzięki, %monk%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(0.5, "Nauczył się czegoś o obchodzeniu się z pospólstwem");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.addXP(50, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+50[/color] doświadczenia"
				});
				_event.m.Monk.improveMood(1.0, "Powstrzymał " + _event.m.Anatomist.getName() + " przed splamieniem reputacji kompanii");

				if (_event.m.Monk.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk.getMoodState()],
						text = _event.m.Monk.getName() + this.Const.MoodStateEvent[_event.m.Monk.getMoodState()]
					});
				}

				local resolveBoost = this.Math.rand(1, 2);
				_event.m.Monk.getBaseProperties().Bravery += resolveBoost;
				_event.m.Monk.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Monk.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolveBoost + "[/color] Odwagi"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Monk.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
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
		local monkCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.monk")
			{
				monkCandidates.push(bro);
			}
		}

		if (monkCandidates.len() > 0)
		{
			this.m.Monk = monkCandidates[this.Math.rand(0, monkCandidates.len() - 1)];
		}

		if (anatomistCandidates.len() > 0)
		{
			this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		}
		else
		{
			return;
		}

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
			"monk",
			this.m.Monk != null ? this.m.Monk.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Monk = null;
		this.m.Town = null;
	}

});

