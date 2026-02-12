this.player_plays_dice_event <- this.inherit("scripts/events/event", {
	m = {
		Gambler = null,
		PlayerDice = 0,
		GamblerDice = 0
	},
	function create()
	{
		this.m.ID = "event.player_plays_dice";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_62.png[/img]Gdy odpoczywasz po całodziennym marszu, %gambler% podchodzi do ciebie z parą kości i kubkiem w dłoni. Pyta, czy chcesz zagrać w krótką grę. Zasady są proste: rzucacie kośćmi z kubka, a kto wyrzuci wyższy wynik, wygrywa. To czysty los! Stawka to dwadzieścia pięć koron za każdy rzut.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zagrajmy!",
					function getResult( _event )
					{
						_event.m.Gambler.improveMood(1.0, "Zagrał z tobą w kości");
						_event.m.PlayerDice = this.Math.rand(3, 18);
						_event.m.GamblerDice = this.Math.rand(3, 18);

						if (_event.m.PlayerDice == _event.m.GamblerDice)
						{
							return "D";
						}
						else if (_event.m.PlayerDice > _event.m.GamblerDice)
						{
							return "C";
						}
						else
						{
							return "B";
						}
					}

				},
				{
					Text = "Nie mam na to czasu.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gambler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_62.png[/img]Rzucasz kośćmi, uzyskując łącznie %playerdice%.\n\n%gambler% rzuca jako następny, uzyskując łącznie %gamblerdice%.\n\n{Cóż, przegrałeś. Gracz zgarnia kości - i twoje dwadzieścia pięć koron - po czym pyta, czy chcesz spróbować jeszcze raz. | Kości nie były po twojej stronie i gracz zgarnia wygraną. Spogląda na ciebie, uśmiechając się.%SPEECH_ON%Chcesz spróbować jeszcze raz?%SPEECH_OFF% | Liczby są policzone i, niestety, przegrałeś. Gracz pyta, czy chcesz zagrać ponownie. | Przegrana! Ale może jeśli rzucisz jeszcze raz... | Przegrywasz! Prosty rzut kośćmi i prosta przegrana. Ale ta boli o wiele mniej niż to, co widziałeś na polach bitew. Gracz pyta, czy chcesz spróbować jeszcze raz. | Bogowie odwrócili się od ciebie i twoich głupich kości. Przegrana to drobna porażka, ale twoja duma kosztuje odrobinę więcej niż dwadzieścia pięć koron. Rzucasz jeszcze raz? | Los cię zdradził za marne dwadzieścia koron. Może jeśli rzucisz jeszcze raz, odzyskasz je? | Patrzysz, jak kości toczą się, przez chwilę pokazując wygrywające liczby, po czym przechylają się i odsłaniają przegrany wynik. Gracz śmieje się i pyta, czy chcesz rzucić ponownie. | Twój rzut był idealny! Jak mogłeś przegrać? On potrzebował właśnie tych liczb, żeby wygrać! Kręcisz głową, zastanawiając się, czy rzucić jeszcze raz.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Rzucamy jeszcze raz!",
					function getResult( _event )
					{
						_event.m.PlayerDice = this.Math.rand(3, 18);
						_event.m.GamblerDice = this.Math.rand(3, 18);

						if (_event.m.PlayerDice == _event.m.GamblerDice)
						{
							return "D";
						}
						else if (_event.m.PlayerDice > _event.m.GamblerDice)
						{
							return "C";
						}
						else
						{
							return "B";
						}
					}

				},
				{
					Text = "Na dziś mam dość.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gambler.getImagePath());
				this.World.Assets.addMoney(-25);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]25[/color] koron"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_62.png[/img]Rzucasz kośćmi, uzyskując łącznie %playerdice%.\n\n%gambler% rzuca jako następny, uzyskując łącznie %gamblerdice%.\n\n{Wygrałeś! Gracz klaszcze w dłonie.%SPEECH_ON%Szczęście nowicjusza!%SPEECH_OFF%Krzyżujesz ręce.%SPEECH_ON%Myślałem, że to sama fortuna?%SPEECH_OFF%Gracz śmieje się i pyta, czy chcesz sprawdzić tę teorię. | Gracz odchyla się.%SPEECH_ON%No to pięknie. Rzućmy jeszcze raz!%SPEECH_OFF% | Gracz odchyla się.%SPEECH_ON%{No to mnie osrał koński zad | Niech mnie diabli, jeśli bogowie się ode mnie nie odwrócili | To dopiero kiepski występ pani Fortuny | Sypiałem z panną o imieniu Fortuna, a na co mi to było | To prawdziwe nieszczęście, dla mnie przynajmniej | Oj, to zwycięski rzut | Niech mnie licho | Syn wałacha | Świnia w błocie | Przeklęty jak zakonnica na plecach | Rzut mistrza, mówię ci | Jesteś rabusiem z takim rzutem, no | Niech %randomtown% dołączy do orków | I mówią, że ślepa wiewiórka nie znajdzie orzecha | Połaskocz mi zad różanym krzakiem i mów mi Sally Siegfried}, wygrałeś! Rzucamy jeszcze raz!%SPEECH_OFF% | Wygrałeś! Śmiejąc się, zabierasz wygraną, a gracz pyta, czy chcesz rzucić ponownie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Rzucamy jeszcze raz!",
					function getResult( _event )
					{
						_event.m.PlayerDice = this.Math.rand(3, 18);
						_event.m.GamblerDice = this.Math.rand(3, 18);

						if (_event.m.PlayerDice == _event.m.GamblerDice)
						{
							return "D";
						}
						else if (_event.m.PlayerDice > _event.m.GamblerDice)
						{
							return "C";
						}
						else
						{
							return "B";
						}
					}

				},
				{
					Text = "Na dziś mam dość.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gambler.getImagePath());
				this.World.Assets.addMoney(25);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Wygrywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]25[/color] koron"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_62.png[/img]Rzucasz kośćmi, uzyskując łącznie %playerdice%.\n\n%gambler% rzuca jako następny, uzyskując łącznie %gamblerdice%.\n\nLiczby są takie same. Remis! Rzucić jeszcze raz?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Rzucamy jeszcze raz!",
					function getResult( _event )
					{
						_event.m.PlayerDice = this.Math.rand(3, 18);
						_event.m.GamblerDice = this.Math.rand(3, 18);

						if (_event.m.PlayerDice == _event.m.GamblerDice)
						{
							return "D";
						}
						else if (_event.m.PlayerDice > _event.m.GamblerDice)
						{
							return "C";
						}
						else
						{
							return "B";
						}
					}

				},
				{
					Text = "Na dziś mam dość.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gambler.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() <= 100)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.gambler" || bro.getBackground().getID() == "background.vagabond" || bro.getBackground().getID() == "background.thief" || bro.getBackground().getID() == "background.raider")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Gambler = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"gambler",
			this.m.Gambler.getName()
		]);
		_vars.push([
			"playerdice",
			this.m.PlayerDice
		]);
		_vars.push([
			"gamblerdice",
			this.m.GamblerDice
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Gambler = null;
		this.m.PlayerDice = 0;
		this.m.GamblerDice = 0;
	}

});

