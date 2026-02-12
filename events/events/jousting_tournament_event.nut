this.jousting_tournament_event <- this.inherit("scripts/events/event", {
	m = {
		Jouster = null,
		Opponent = "",
		Bet = 0
	},
	function create()
	{
		this.m.ID = "event.jousting_tournament";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%jouster% podchodzi do ciebie z kartką w ręku. Rzuca ją na stół i mówi, że chce wystartować. Podnosisz zwój i rozwijasz go, widząc ogłoszenie, że pobliskie miasto organizuje turniej rycerski. Mężczyzna krzyżuje ramiona, czekając na twoją odpowiedź.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze, możesz wziąć w tym udział.",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Nie, mamy ważniejsze sprawy.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_96.png[/img]Zgadzasz się, by %jouster% wziął udział w turnieju i, chcąc zobaczyć to na własne oczy, idziesz z nim.\n\nTurniej rycerski iskrzy energią, gdy się do niego zbliżasz. Giermkowie biegają w tę i z powrotem, niosąc całe naręcza zbroi i broni, a niektórzy wolno kroczą z ogromnymi kopiami przerzuconymi przez ramiona. Inni czyszczą niezwykle dostojnie wyglądające konie, z których wiele nosi napierśniki zdobione herbami. W oddali słychać krótkie galopy, ciężkie kopyta uderzające o ziemię, po czym rozlega się trzask drewna o metal i wybuchają okrzyki.\n\nGdy rozglądasz się po festynie, podchodzi do ciebie szlachcic i zatrzymuje cię. Ważąc sakiewkę w jednej dłoni i kręcąc źdźbłem słomy w kąciku ust drugą, pyta, czy chcesz się założyć. Pytasz o co. Kiwa głową, wskazując na %jouster%, który po drugiej stronie miejsca zbiórki zapisuje się do turnieju. Wygląda na to, że ma zmierzyć się z własnym jeźdźcem szlachcica, człowiekiem o imieniu %opponent%.%SPEECH_ON%Odrobina gry psychologicznej nigdy nie zaszkodziła, co? Jak ci brzmi %bet% koron? Zwycięzca bierze wszystko, oczywiście.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zakład stoi!",
					function getResult( _event )
					{
						_event.m.Bet = 500;
						return "P";
					}

				},
				{
					Text = "Nie gram w hazard.",
					function getResult( _event )
					{
						return "P";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "P",
			Text = "[img]gfx/ui/events/event_96.png[/img]Siadasz pośród pospólstwa i szlachty. Jedynie miejscowy pan ma wyraźne oddzielenie od tłumu, siedząc na podwyższonym rzędzie wraz ze swoimi synami, córkami oraz różnym możnowładztwem z całej krainy.\n\n%jouster% jest następny, a giermek pomaga wyprowadzić jego konia na jeden z torów. Po przeciwnej stronie pola %opponent% wjeżdża na plac, jego koń jest czarny, a zbroja jaskrawo purpurowa ze złotymi obszyciami i frędzlami tu i tam. Zarówno on, jak i %jouster% chwytają kopie i opuszczają przyłbice.\n\nKrzykacz wywołuje ich imiona z loży, po czym duchowny mówi kilka słów o tym, że zostało to zarządzone przez bogów i że gdyby ktokolwiek dziś zginął, zasiądzie pośród największych mężów w następnym świecie i będzie wspominany razem z nimi w tym. Po tych słowach obaj kopijnicy opuszczają kopie i ruszają do szarży, zanim krzykacz czy kapłan zdążą w ogóle usiąść.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ekscytujące!",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 30 + 5 * _event.m.Jouster.getLevel())
						{
							return "Win";
						}
						else
						{
							return "Lose";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Win",
			Text = "[img]gfx/ui/events/event_96.png[/img]Nie będąc nigdy na takim wydarzeniu, nie potrafisz nie wstrzymać oddechu, gdy dwaj jeźdźcy pędzą ku sobie po torach. Konie są majestatyczne, ich nogi pracują w rytmie, kopyta rozrywają wielkie grudy ziemi, a zbroje lśnią słonecznymi refleksami na tłumie, gdy biegną, zostawiając za sobą strumienie rozentuzjazmowanych widzów, krzyczących dzieci, pijaków rozlewających uniesione kufle oraz młode księżniczki ściskające suknie i spragnionych odwagi książąt klaszczących w dłonie, a ty sam, nawet nie wiedząc kiedy, stoisz i krzyczysz.\n\n%opponent% usiłuje utrzymać cel, jego kopia podskakuje, a jej grot chwieje się w poszukiwaniu prawdziwego celu.\n\nNie trafia.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ooo!",
					function getResult( _event )
					{
						if (_event.m.Bet > 0)
						{
							return "WinBet";
						}
						else
						{
							return "WinNobet";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "WinNobet",
			Text = "[img]gfx/ui/events/event_96.png[/img]Kopia %jouster% roztrzaskuje się na piersi przeciwnika, wybuchając jak fontanna trocin i drzazg, przez którą pędzi koń bez jeźdźca, bo kopijnik został odrzucony do tyłu ponad tylny łęk i całkiem wypchnięty z siodła, lądując twarzą w ziemi bez ruchu i tchu. Z tłumu wyrywa się ryk, odkorkowana nawałnica, do której szybko dołączasz, zalewając uszy ogłuszającą kakofonią, porwany w czas i miejsce, których nie zapomnisz.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Hura!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
				_event.m.Jouster.improveMood(2.0, "Wygrał turniej rycerski");

				if (_event.m.Jouster.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Jouster.getMoodState()],
						text = _event.m.Jouster.getName() + this.Const.MoodStateEvent[_event.m.Jouster.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "WinBet",
			Text = "[img]gfx/ui/events/event_96.png[/img]Kopia %jouster% roztrzaskuje się na piersi przeciwnika, wybuchając jak fontanna trocin i drzazg, przez którą pędzi koń bez jeźdźca, bo kopijnik został odrzucony do tyłu ponad tylny łęk i całkiem wypchnięty z siodła, lądując twarzą w ziemi bez ruchu i tchu. Z tłumu wyrywa się ryk, odkorkowana nawałnica, do której szybko dołączasz, zalewając uszy ogłuszającą kakofonią, porwany w czas i miejsce, których nie zapomnisz.\n\nWciąż świętując, podchodzi do ciebie szlachcic, z którym się założyłeś, i wkłada ci do ręki sakiewkę. Chcesz powiedzieć kilka słów, ale zanim zdążysz, odwraca się gniewnie i odchodzi.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Hura!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
				this.World.Assets.addMoney(_event.m.Bet);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Wygrywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + _event.m.Bet + "[/color] koron"
				});
				_event.m.Jouster.improveMood(2.0, "Wygrał turniej rycerski");

				if (_event.m.Jouster.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Jouster.getMoodState()],
						text = _event.m.Jouster.getName() + this.Const.MoodStateEvent[_event.m.Jouster.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Lose",
			Text = "[img]gfx/ui/events/event_96.png[/img]Nie będąc nigdy na takim wydarzeniu, nie potrafisz nie wstrzymać oddechu, gdy dwaj jeźdźcy pędzą ku sobie po torach. Konie są majestatyczne, ich nogi pracują w rytmie, kopyta rozrywają wielkie grudy ziemi, a zbroje lśnią słonecznymi refleksami na tłumie, gdy biegną, zostawiając za sobą strumienie rozentuzjazmowanych widzów, krzyczących dzieci, pijaków rozlewających uniesione kufle oraz młode księżniczki ściskające suknie i spragnionych odwagi książąt klaszczących w dłonie, a ty sam, nawet nie wiedząc kiedy, stoisz i krzyczysz.\n\n%jouster% usiłuje utrzymać cel, jego kopia podskakuje, a jej grot chwieje się w poszukiwaniu prawdziwego celu.\n\nNie trafia.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ooo...",
					function getResult( _event )
					{
						if (_event.m.Bet > 0)
						{
							return "LoseBet";
						}
						else
						{
							return "LoseNobet";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "LoseNobet",
			Text = "[img]gfx/ui/events/event_96.png[/img]Kopia %opponent% eksploduje, gdy trafia prosto w pierś %jouster%. Mężczyzna wygina się do tyłu w siodle, a w jego śladzie wiruje chmura drzazg i sproszkowanego drewna. Desperacko sięga po wodze. Gdy je chwyta, myślisz, że doszedł do siebie, ale wędzidło pęka i wodze wysuwają się z rąk. %jouster% spada do tyłu, przetacza się przez zad konia i ląduje na nogach. Stoi, owszem, ale przegrał.\n\nTłum wybucha oklaskami, gorąco bijąc brawa zarówno zwycięzcy, jak i przegranemu. Kręcąc bolącym ramieniem, %jouster% schodzi z pola. Spotykasz go przy miejscu zbiórki. Mówi, że coś było nie tak z jego kopią, a ty wspominasz, że poluzowało się wędzidło jego konia. W tej chwili obok przechodzi zwycięzca, za nim orszak wielbiących go kobiet, a giermek prowadzi dość nadętego konia. Ku twojemu zaskoczeniu %opponent% i %jouster% ściskają sobie dłonie i składają gratulacje po dobrze stoczonym pojedynku.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Trudno.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
				local injury = _event.m.Jouster.addInjury(this.Const.Injury.Jousting);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Jouster.getName() + " doznaje " + injury.getNameOnly()
				});
			}

		});
		this.m.Screens.push({
			ID = "LoseBet",
			Text = "[img]gfx/ui/events/event_96.png[/img]Kopia %opponent% eksploduje, gdy trafia prosto w pierś %jouster%. Mężczyzna wygina się do tyłu w siodle, a w jego śladzie wiruje chmura drzazg i sproszkowanego drewna. Desperacko sięga po wodze. Gdy je chwyta, myślisz, że doszedł do siebie, ale wędzidło pęka i wodze wysuwają się z rąk. %jouster% spada do tyłu, przetacza się przez zad konia i ląduje na nogach. Stoi, owszem, ale przegrał.\n\nTłum wybucha oklaskami, gorąco bijąc brawa zarówno zwycięzcy, jak i przegranemu. Kręcąc bolącym ramieniem, %jouster% schodzi z pola. Spotykasz go przy miejscu zbiórki. Mówi, że coś było nie tak z jego kopią, a ty wspominasz, że poluzowało się wędzidło jego konia. W tej chwili obok przechodzi zwycięzca, za nim orszak wielbiących go kobiet, a giermek prowadzi dość nadętego konia. Ku twojemu zaskoczeniu %opponent% i %jouster% ściskają sobie dłonie i składają gratulacje po dobrze stoczonym pojedynku.\n\nSzlachcic, z którym się założyłeś, nie jest fanem sportowej postawy. Podchodzi do ciebie, pocierając ręce pod tandetnym uśmieszkiem. Niechętnie płacisz mu to, co mu się należy.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Trudno.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
				this.World.Assets.addMoney(-_event.m.Bet);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Bet + "[/color] koron"
				});
				local injury = _event.m.Jouster.addInjury(this.Const.Injury.Jousting);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Jouster.getName() + " doznaje " + injury.getNameOnly()
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_64.png[/img]Odmowa dla %jouster% nie przechodzi gładko. Długo mówi o tym, ile mógłby zarobić na turnieju i jak odbierasz mu te korony. Wszystko to bardzo interesujące narzekania, aż w końcu odwraca się do ciebie i żąda %compensation% koron, rekompensaty za rzekomo utracone zarobki.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze, zrekompensuję ci to.",
					function getResult( _event )
					{
						return "H";
					}

				},
				{
					Text = "Jesteś teraz najemnikiem, nie kopijnikiem. Przywyknij.",
					function getResult( _event )
					{
						return "I";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_64.png[/img]Wstajesz i klepiesz %jouster% po ramieniu.%SPEECH_ON%Nie mam wątpliwości, że człowiek o twoich umiejętnościach i waleczności przeszedłby przez turniej jak burza. Ale potrzebuję kogoś takiego jak ty tutaj, w obozie. Nie musisz udowadniać utraconych zarobków, po prostu ci je zrekompensuję.%SPEECH_OFF%Dość dyplomatyczne słowa uspokajają mężczyznę. Kiwając głową, przez chwilę wygląda tak, jakby przyjęcie zapłaty było niehonorowe. Nie chcąc, by najemnik wystawiał jego zdecydowanie na próbę albo wyglądał jak głupiec czy człowiek bez honoru, każesz mu to wziąć.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Możesz iść.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
				this.World.Assets.addMoney(-500);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]500[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_64.png[/img]Chwytasz plakat turniejowy i przykładzasz go do świecy. Gdy płomienie pożerają papier, ustalasz kilka zasad dla %jouster%.%SPEECH_ON%Zatrudniłem cię jako najemnika, nie jakiegoś miękkiego kopijnika. Jeśli chcesz jeździć po turniejach i walczyć, możesz oddać cały sprzęt i podstawowy żołd. W przeciwnym razie wynoś się z mojego namiotu.%SPEECH_OFF%Nie przyjmuje tego najlepiej, ale ostatecznie najemnik wychodzi tylko z twojego namiotu, a nie z całej kompanii.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wracaj do pracy!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
				_event.m.Jouster.worsenMood(2.0, "Odmówiono mu udziału w turnieju rycerskim");

				if (_event.m.Jouster.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Jouster.getMoodState()],
						text = _event.m.Jouster.getName() + this.Const.MoodStateEvent[_event.m.Jouster.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() < 500)
		{
			return;
		}

		if (this.World.FactionManager.isGreaterEvil())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 1)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getLevel() < 4)
			{
				continue;
			}

			if ((bro.getBackground().getID() == "background.adventurous_noble" || bro.getBackground().getID() == "background.disowned_noble" || bro.getBackground().getID() == "background.regent_in_absentia" || bro.getBackground().getID() == "background.bastard" || bro.getBackground().getID() == "background.hedge_knight") && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Jouster = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 25;
	}

	function onPrepare()
	{
		this.m.Opponent = this.Const.Strings.KnightNames[this.Math.rand(0, this.Const.Strings.KnightNames.len() - 1)];
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"jouster",
			this.m.Jouster.getName()
		]);
		_vars.push([
			"opponent",
			this.m.Opponent
		]);
		_vars.push([
			"bet",
			500
		]);
		_vars.push([
			"compensation",
			500
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Jouster = null;
		this.m.Opponent = "";
		this.m.Bet = 0;
	}

});

