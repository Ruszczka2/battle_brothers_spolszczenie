this.hedge_knight_vs_refugee_event <- this.inherit("scripts/events/event", {
	m = {
		HedgeKnight = null,
		Refugee = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.hedge_knight_vs_refugee";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_52.png[/img]%hedgeknight%, rycerz z żywopłotu, podchodzi do jedzącego %refugee%a. Były uchodźca widzi cień górujący nad nim i powoli się odwraca.%SPEECH_ON%Tak?%SPEECH_OFF%Rycerz prycha i spluwa gulą flegmy wielkości dziecięcego ramienia. Prycha ponownie.%SPEECH_ON%Uciekłeś z domu. Patrzyłeś, jak płonie, i odwróciłeś się od ognia zamiast z nim walczyć. Ta kompania to teraz twój dom. Co powstrzyma cię przed ucieczką przed ogniem teraz?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Daj spokój, %hedgeknight%. Przestań!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Sami to załatwcie.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight.getImagePath());
				this.Characters.push(_event.m.Refugee.getImagePath());

				if (_event.m.OtherGuy != null)
				{
					this.Options.push({
						Text = "Czekaj. %streetrat%, wyglądasz, jakbyś miał coś do powiedzenia?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_52.png[/img]Występujesz do przodu i mówisz rycerzowi, żeby dał sobie spokój. Kompania nie jest tu po to, by łechtać jego ego. Śmiejąc się, niedźwiedzi mężczyzna odchodzi.%SPEECH_ON%Jak pan mówi. Nie chciałbym się bić z księżniczką kompanii.%SPEECH_OFF%Kompania się śmieje, ale uchodźca tylko wpatruje się w miskę jedzenia, jakby ktoś do niej napluł.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "No cóż, chyba po sprawie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight.getImagePath());
				this.Characters.push(_event.m.Refugee.getImagePath());
				local bravery = this.Math.rand(1, 3);
				_event.m.Refugee.getBaseProperties().Bravery -= bravery;
				_event.m.Refugee.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Refugee.getName() + " traci [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + bravery + "[/color] Determinacji"
				});
				_event.m.Refugee.worsenMood(1.0, "Został upokorzony przed kompanią");

				if (_event.m.Refugee.getMoodState() <= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Refugee.getMoodState()],
						text = _event.m.Refugee.getName() + this.Const.MoodStateEvent[_event.m.Refugee.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_06.png[/img]Nie wtrącasz się. Rycerz z żywopłotu kontynuuje.%SPEECH_ON%Nie mam litości dla twojego bólu. Rozumiesz?%SPEECH_OFF%Uchodźca kiwa głową i podnosi wzrok.%SPEECH_ON%Tak, ale jaką litość ma ktokolwiek dla twojego?%SPEECH_OFF%Ramię %refugee%a wyskakuje tak szybko, że przewraca talerz do ogniska. Widelec wbija się w udo %hedgeknight%a, a %refugee% nie potrafi go wyrwać, jakby utknął w pniu dębu. Rycerz zaciska zęby i pada na uchodźcę, spłaszczając go. Jego ogromne dłonie wciskają czaszkę uchodźcy w ziemię, aż biedak zaczyna oddychać ziemią. Reszta kompanii wstaje i odsuwa się. Podchodzisz, ale %hedgeknight% unosi dłoń, po czym wstaje.%SPEECH_ON%Dobrze, mały uciekinierze, dobrze. Masz jeszcze walkę w sobie.%SPEECH_OFF%Wyciąga widelec i podaje go. Kropla krwi spływa między zębami.%SPEECH_ON%Co jesz? O, tak? Dobrze. Podwoję to swoją porcją. Chodź i usiądź.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze, że to załatwione.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight.getImagePath());
				this.Characters.push(_event.m.Refugee.getImagePath());
				local bravery = this.Math.rand(1, 3);
				_event.m.Refugee.getBaseProperties().Bravery += bravery;
				_event.m.Refugee.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Refugee.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + bravery + "[/color] Determinacji"
				});
				_event.m.Refugee.improveMood(1.0, "Zyskał uznanie od " + _event.m.HedgeKnight.getName());

				if (_event.m.Refugee.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Refugee.getMoodState()],
						text = _event.m.Refugee.getName() + this.Const.MoodStateEvent[_event.m.Refugee.getMoodState()]
					});
				}

				_event.m.HedgeKnight.improveMood(0.5, "Trochę polubił " + _event.m.Refugee.getName());

				if (_event.m.HedgeKnight.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.HedgeKnight.getMoodState()],
						text = _event.m.HedgeKnight.getName() + this.Const.MoodStateEvent[_event.m.HedgeKnight.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_80.png[/img]%streetrat% występuje do przodu. Wskazuje palcem rycerza z żywopłotu.%SPEECH_ON%Nie masz pojęcia o ogniu ani płomieniu.%SPEECH_OFF%Śmiejąc się, %hedgeknight% odwraca się i trzaska knykciami.%SPEECH_ON%Jasne, że mam. JA jestem ogniem.%SPEECH_OFF%Niskourodzony krzyżuje ramiona z przekorą.%SPEECH_ON%A my nie jesteśmy popiołem, tylko samym drewnem. Jesteś dziwką dla szlachty, oto kim naprawdę jesteś. Płacą ci wysoką cenę, a ty idziesz ze swoją siłą i okrucieństwem i robisz, co ci każą. Jak... jak dziwka...%SPEECH_OFF%Inny najemnik unosi palec.%SPEECH_ON%Chyba opisujesz nas w ogóle. Jesteśmy najemnikami.%SPEECH_OFF%A kolejny dodaje.%SPEECH_ON%Czy ty właśnie porównałeś się do rozpałki?%SPEECH_OFF%%streetrat% pociera tył głowy.%SPEECH_ON%Tak, będę szczery, rycerz z żywopłotu trochę mnie przestraszył i zgubiłem, co miałem powiedzieć.%SPEECH_OFF%Kompania rozgląda się, po czym wybucha śmiechem, a wszelka niechęć znika.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "O co my właściwie się kłóciliśmy?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight.getImagePath());
				this.Characters.push(_event.m.OtherGuy.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.OtherGuy.getID() || bro.getID() == _event.m.HedgeKnight.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "Czuł się rozbawiony");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local hedge_knight_candidates = [];
		local refugee_candidates = [];
		local other_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.hedge_knight")
			{
				hedge_knight_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.refugee")
			{
				refugee_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.vagabond" || bro.getBackground().getID() == "background.beggar" || bro.getBackground().getID() == "background.cripple" || bro.getBackground().getID() == "background.servant" || bro.getBackground().getID() == "background.ratcatcher")
			{
				other_candidates.push(bro);
			}
		}

		if (hedge_knight_candidates.len() == 0 || refugee_candidates.len() == 0)
		{
			return;
		}

		this.m.HedgeKnight = hedge_knight_candidates[this.Math.rand(0, hedge_knight_candidates.len() - 1)];
		this.m.Refugee = refugee_candidates[this.Math.rand(0, refugee_candidates.len() - 1)];
		this.m.Score = (hedge_knight_candidates.len() + refugee_candidates.len()) * 5;

		if (other_candidates.len() != 0)
		{
			this.m.OtherGuy = other_candidates[this.Math.rand(0, other_candidates.len() - 1)];
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hedgeknight",
			this.m.HedgeKnight.getNameOnly()
		]);
		_vars.push([
			"refugee",
			this.m.Refugee.getName()
		]);
		_vars.push([
			"streetrat",
			this.m.OtherGuy != null ? this.m.OtherGuy.getName() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.HedgeKnight = null;
		this.m.Refugee = null;
		this.m.OtherGuy = null;
	}

});

