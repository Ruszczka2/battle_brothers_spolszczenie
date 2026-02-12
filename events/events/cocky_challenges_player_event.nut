this.cocky_challenges_player_event <- this.inherit("scripts/events/event", {
	m = {
		Cocky = null
	},
	function create()
	{
		this.m.ID = "event.cocky_challenges_player";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]Gdy siedzisz z kompanią przy ognisku, %cocky% wstaje i przemawia z zaczerwienioną twarzą.%SPEECH_ON%Nie wiem, jak wy, smętne kluchy, ale ja mógłbym prowadzić ten obóz lepiej niż ktokolwiek! Zwłaszcza lepiej niż on!%SPEECH_OFF%Wskazuje na ciebie palcem.\n\nSiadasz. Ludzie wpatrują się w ciebie, czekając na odpowiedź.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Masz całkowitą rację. Powinieneś dowodzić.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Czas sprowadzić cię na ziemię.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "To ja tu dowodzę! To moja kompania!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cocky.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_26.png[/img]Wysuwasz nogi, rozkładasz je i kładziesz ręce na kolanach. Kiwasz głową i mówisz do mężczyzny.%SPEECH_ON%Dobrze, %cocky%. Teraz ty dowodzisz. Musisz liczyć zapasy co rano i co wieczór. Wiem, że nie umiesz liczyć, ale się nauczysz. Nie chcemy, żeby ci porządni ludzie szli do boju z brakującymi strzałami.%SPEECH_OFF%Wskazujesz dłonią na kilka namiotów.%SPEECH_ON%Musisz też pilnować stanu ludzi. Nie da się ich łatwo kontrolować, co może wydawać ci się ironiczne - albo nie.%SPEECH_OFF%Patrząc na swoje dłonie, które z czasem stały się zrogowaciałe i poobijane, mówisz dalej.%SPEECH_ON%I będziesz musiał wydawać rozkazy, które nie tylko mają brzmieć, ale utrzymywać ludzi przy życiu i przy oddechu. Wiesz, takich jak ty i tych, którzy siedzą obok. Więc tak, bierz robotę, %cocky%. Jest twoja.%SPEECH_OFF%Gdy kończysz, grupa braci natychmiast wstaje i błaga, byś pozostał dowódcą. %cocky%, widząc to, wycofuje się i zmyka, gdy w powietrzu rozbrzmiewają okrzyki "ty dowodzisz!".",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "No i bardzo dobrze.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cocky.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getMoodState() < this.Const.MoodState.Neutral && this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(1.0, "Nabrał pewności w twoje dowodzenie");

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
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_26.png[/img]Ognisko trzaska, rzucając pomarańczową poświatę na twoją twarz. Kiwasz głową, wstajesz i podchodzisz do %cocky%. Robi krok w tył, ale zanim to zrobi, wyciągasz rękę i chwytasz go za ramię. Szybko wysuwasz nogę za jego kolano, podcinasz go i rzucasz na plecy. Podążasz za nim na ziemię i tam jedną ręką obejmujesz jego gardło, a drugą wskazujesz oskarżycielsko.%SPEECH_ON%Jesteś dobrym człowiekiem, %cocky%, ale głupim też. Widziałem, że część z was nie jest zadowolona z tego, jak idą sprawy, ale przypominam, że wszyscy wciąż żyjecie! Gdyby ktoś taki jak %cocky% dowodził, wszyscy byście zginęli w dwa tygodnie!%SPEECH_OFF%Wstajesz i faktycznie pomagasz %cocky% się podnieść. Ten prycha i odchodzi, przewracając przy tym stos beczek. Fala bólu rozchodzi się z miejsca, gdzie niedawno trafiła cię strzała, ale zaciskasz zęby i starasz się nic nie zdradzić, siadając ponownie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nadal to mam!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cocky.getImagePath());
				_event.m.Cocky.worsenMood(3.0, "Poczuł się upokorzony przed kompanią");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Cocky.getMoodState()],
					text = _event.m.Cocky.getName() + this.Const.MoodStateEvent[_event.m.Cocky.getMoodState()]
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_26.png[/img]Natychmiast zrywasz się na nogi i zaczynasz krzyczeć.%SPEECH_ON%To ja tu dowodzę! Ja! Kto ma pieniądze? Ja! Gdyby nie ja, żaden z was nawet by tu nie był! Wciąż tkwilibyście w dołach swoich dawnych żyć! Powinniście padać do moich stóp za możliwości, które wam dałem! A %cocky%, jeśli jeszcze raz mi się sprzeciwisz, przysięgam na bogów, że cię ubiczuję i powieszę, rozumiesz?%SPEECH_OFF%Wybuch natychmiast ucisza obóz. %cocky% kiwa głową i cofa się. Kilku ludzi mruczy między sobą, gdy znów siadasz.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Poszło całkiem nieźle, co?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cocky.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 33)
					{
						bro.worsenMood(1.0, "Stracił zaufanie do twojego dowodzenia");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
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
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];
		local grumpy = 0;

		foreach( bro in brothers )
		{
			if (bro.getMoodState() < this.Const.MoodState.Neutral)
			{
				grumpy = ++grumpy;

				if (bro.getSkills().hasSkill("trait.cocky"))
				{
					candidates.push(bro);
				}
			}
		}

		if (candidates.len() == 0 || grumpy < 3)
		{
			return;
		}

		this.m.Cocky = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 3 + grumpy * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cocky",
			this.m.Cocky.getName()
		]);
	}

	function onClear()
	{
		this.m.Cocky = null;
	}

});

