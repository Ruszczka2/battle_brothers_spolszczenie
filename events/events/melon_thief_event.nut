this.melon_thief_event <- this.inherit("scripts/events/event", {
	m = {
		Other = null,
		Dude = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.melon_thief";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_43.png[/img]Przyglądasz się dużej grupie wrzeszczących wieśniaków. Pijani niosą ścięte drzewo jak stado mrówek niosących chrząszcza. Na pniu siedzi mężczyzna z zawiązanymi oczami i w kajdanach. Gdy tłum się zbliża, ostry zapach alkoholu bije od motłochu jak miazma z wyjątkowo wściekłego bagna.\n\n %otherbro% pyta hołotę, dokąd idą. Brodaty błazen zatacza się do przodu, hamując jednocześnie piętą i czubkiem stopy, jak niewprawna marionetka.%SPEECH_ON%Oj! Idziem go wytarować i oskubać, tego, tego, eee...%SPEECH_OFF%Ktoś z tłumu krzyczy \"owocowy bawidamek!\". Błazen pstryka palcami.%SPEECH_ON%Racja! Ten rabuś melonów dostanie to, co mu się, eee, należy...%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Złodziej melonów?",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Tak, to zdecydowanie nie nasza sprawa.",
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
			Text = "[img]gfx/ui/events/event_43.png[/img]Błazen chwieje się na nogach. W jego brodzie jest dość piany z piwa, by upić dziewkę. Wskazuje do przodu.%SPEECH_ON%To... to prawda! Skroił melona, owszem, ale to nie byle jaki złodziejaszek! Nie, on go zatyczkował, że aż strach! Znaleźliśmy surowe ścieki jego roboty wokół niego, kiedy dopadliśmy jego sprawki! A przez surowe ścieki mam na myśli źle odmierzony wyciek z jego fiuta!%SPEECH_OFF%Ledwo co z tego łapiesz, więc prosisz, by wyjaśnił - tym razem powoli. Rozkłada ręce, jakbyś był idiotą.%SPEECH_ON%O co tyle gadania? Człowiek puknie melona i już! Takie nierządy to, no, to... to poza zwykłym wołaniem o sprawiedliwość! A teraz z drogi, nieznajomy, musimy zebrać pióra, a potem je rozdać przy pomocy porządnego tarowania i oskubania, a może i jeszcze trochę tarowania, jeśli nam zostanie!%SPEECH_OFF%Tłum wiwatuje.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Co powiesz, Człeku od Melona?",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Owocowy nierząd? %otherbro%, wytaruj tego głupca!",
					function getResult( _event )
					{
						return "H";
					}

				},
				{
					Text = "Dobra. Nie nasza sprawa.",
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
			ID = "C",
			Text = "[img]gfx/ui/events/event_43.png[/img]Pytasz mężczyznę na pniu, czy ma coś do powiedzenia. Wzrusza ramionami i mówi.%SPEECH_ON%Słuchaj, to, co dzieje się między mężczyzną a melonem, to ich sprawa i tylko ich. Nikomu krzywdy, nikomu szkody.%SPEECH_OFF%Błazen uderza go kijem.%SPEECH_ON%Nie, powiedz temu kolesiowi wprost, powiedz, co zrobiłeś!%SPEECH_OFF%Melonowy człowiek wzdycha i kiwa głową.%SPEECH_ON%Dobra, jeśli to koniec tych negocjacji, a ja tu siedzę i czuję zapach smoły w powietrzu, to powiem prawdę. Pieprzyłem tego melona i dobrze się bawiłem.%SPEECH_OFF%Tłum syczy i buczy, a twoi ludzie śmieją się między sobą.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie pozwolimy wam wytarować tego człowieka.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Owocowy nierząd? %otherbro%, pomóż wytarować tego głupca!",
					function getResult( _event )
					{
						return "H";
					}

				},
				{
					Text = "Dobra. Nie nasza sprawa.",
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
			ID = "D",
			Text = "[img]gfx/ui/events/event_43.png[/img]Chwytasz błazna.%SPEECH_ON%Puśćcie tego człowieka.%SPEECH_OFF%Mężczyzna pyta, czy naprawdę bronisz tego owocowego chędożcy. Kiwasz głową i mówisz mu, że cudzołóstwo z melonem, choć obrzydliwe i mylące, jest ostatecznie nieszkodliwe. Pijany wieśniak wskazuje kciukiem przez ramię.%SPEECH_ON%Co? Przed tygodniem zabraliśmy starego Bentleya za szopę, bo złamał kark tej biednej kaczce.%SPEECH_OFF%Mężczyzna marszczy twarz i dopija resztę trunku. Mamrocze coś o tym, że naprawdę brakuje mu tej kaczki. Być może nie wyrażasz się dość jasno i mając dość wybryków tych idiotów, dobywasz miecza i uwalniasz melonowego rabusia. Kierujesz ostrze w stronę tłumu i szybko się rozpraszają w pijackim odwrocie, rozłażąc się przy drodze, rozbiegając się, skąd przyszli, jak kamienie odbijane po falującym jeziorze.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zmiatać, idioci, zmiatać!",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_43.png[/img]\"Melonowy rabuś\" podchodzi do ciebie. Poprawia spodnie kawałkiem sznura i wiązań.%SPEECH_ON%No, eee, skoro oszczędziłeś mi tego okropnego losu, co powiesz, żebym się odwdzięczył? I tak mam dość tego miasta.%SPEECH_OFF%Mówisz mu, że bycie najemnikiem nie jest godnym pozazdroszczenia fachem, by brać się za niego z marszu. Wskazuje cię zadziornie palcem.%SPEECH_ON%Słuchaj, jeśli się boisz, że będę rżnął wasze zapasy, to przysięgam na grób matki, że mój wiejski świder zostanie w spodniach.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze. Witaj w %companyname%!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "Nie, wolimy nie sprawdzać jedzenia za każdym kęsem.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"thief_background"
				]);
				_event.m.Dude.setTitle("Rabuś Melonów");
				_event.m.Dude.getSprite("head").setBrush("bust_head_03");
				_event.m.Dude.getBackground().m.RawDescription = "%name% to po prostu zwykły złodziej melonów — tak mówisz tym, którzy pytają.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.improveMood(1.0, "Zaspokoił potrzeby z melonem");
				_event.m.Dude.worsenMood(0.5, "O mało nie został wytarowany i oskubany");

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_43.png[/img]%otherbro% kiwa głową.%SPEECH_ON%Z przyjemnością! Z drogi, hołoto, niech prawdziwy mężczyzna tu popracuje.%SPEECH_OFF%Najemnik chwyta \"wiadro ze smołą\" i wylewa je na owocowego nierządnika. Mężczyzna krzyczy, gdy gorące płyny syczą, a w powietrze unosi się mocny smród. Patrzysz, jak %otherbro% łapie kilka nagich kur - bez piór, tylko same kury - i zaczyna okładać melonowego rabusia nimi jak wściekły duchowny machający kadzielnicami na łańcuchach. Wytarowany mężczyzna wrzeszczy, częściowo z bólu, częściowo zdezorientowany. Tłum, również zdezorientowany, niechętnie wiwatuje. Gdy kończy, %otherbro% upuszcza kury, które w tym momencie są już tylko breją zwisającego mięsa i smoły. Ociera czoło.%SPEECH_ON%No jasne, panie.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie sądzę, by zrozumiał, ale to działa.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				_event.m.Other.improveMood(0.5, "Wymierzył sprawiedliwą karę");

				if (_event.m.Other.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Other.getMoodState()],
						text = _event.m.Other.getName() + this.Const.MoodStateEvent[_event.m.Other.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (!t.isMilitary() && !t.isSouthern() && t.getSize() <= 1 && t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
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

		foreach( b in brothers )
		{
			candidates.push(b);
		}

		this.m.Other = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"otherbro",
			this.m.Other != null ? this.m.Other.getName() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Other = null;
		this.m.Dude = null;
		this.m.Town = null;
	}

});

