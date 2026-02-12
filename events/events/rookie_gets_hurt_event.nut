this.rookie_gets_hurt_event <- this.inherit("scripts/events/event", {
	m = {
		Rookie = null
	},
	function create()
	{
		this.m.ID = "event.rookie_gets_hurt";
		this.m.Title = "Po bitwie...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_22.png[/img]Gdy bitwa się kończy, znajdujesz %noncombat% na kolanach, a jego ciało kołysze się w przód i w tył, gdy opatruje ranę. Słyszysz stłumione szlochy między zbyt głośnymi jękami. Podchodzisz i pytasz, czy wszystko w porządku. Kręci głową i wyjaśnia, że to był jego pierwszy smak prawdziwej, brutalnej walki. To nie było to, czego się spodziewał, i nie wie, czy potrafi dalej.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Weź się w garść!",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 30 ? "B" : "C";
					}

				},
				{
					Text = "Nie ma tu nikogo, kto by się nie bał.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 70 ? "D" : "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Rookie.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_22.png[/img]Mówisz najemnikowi, by się zebrał. Gdy zatrzymuje się, tłumiąc okrzyk, mówisz mu to ponownie. Tym razem wysuwa nogę i stawia stopę, stabilizując się. Z prawdziwym uporem udaje mu się stanąć na nogi. Koszula jest przesiąknięta krwią, twarz pokryta błotem, posoką i innymi wnętrznościami, jakie bitwa robi z żywych. Ale w jego oczach pojawia się oznaka determinacji, której wcześniej nie było. Kiwając ci głową, wraca do reszty ludzi.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Żelazo ostrzy żelazo.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Rookie.getImagePath());
				_event.m.Rookie.improveMood(1.0, "Odbył zachęcającą rozmowę");
				_event.m.Rookie.getBaseProperties().Bravery += 3;
				_event.m.Rookie.getSkills().update();
				this.List = [
					{
						id = 16,
						icon = "ui/icons/bravery.png",
						text = _event.m.Rookie.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+3[/color] Determinacji"
					}
				];

				if (_event.m.Rookie.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Rookie.getMoodState()],
						text = _event.m.Rookie.getName() + this.Const.MoodStateEvent[_event.m.Rookie.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_22.png[/img]Niestety powiedzenie mu, by \"wziął się w garść\", nic nie daje. Odwraca się do ciebie, twarz ma pokrytą krwią i flakami bitwy, lecz zanim padną jakiekolwiek słowa, drży mu warga i znów się osuwa. Pytasz, czy chce odejść z kompanii, ale kręci głową. Będzie lepiej, tłumaczy. Kiwasz głową i odchodzisz, ale nie ma wątpliwości, że ten słaby pokaz hartu zranił jego dumę.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zahartuje go walka albo go zabije.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Rookie.getImagePath());
				_event.m.Rookie.getBaseProperties().Bravery -= 3;
				_event.m.Rookie.getSkills().update();
				this.List = [
					{
						id = 16,
						icon = "ui/icons/bravery.png",
						text = _event.m.Rookie.getName() + " traci [color=" + this.Const.UI.Color.NegativeEventValue + "]-3[/color] Determinacji"
					}
				];
				_event.m.Rookie.worsenMood(1.0, "Stracił wiarę w siebie");

				if (_event.m.Rookie.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Rookie.getMoodState()],
						text = _event.m.Rookie.getName() + this.Const.MoodStateEvent[_event.m.Rookie.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_22.png[/img]Mężczyzna rozgląda się dookoła, na ciała, na ziemię, na niebo. Kiwając głową, podnosi się. Zanim wróci do obozu, dziękuje ci za słowa.%SPEECH_ON%Dzięki, kapitanie. Postaram się lepiej ukrywać swoje lęki.%SPEECH_OFF%Odwzajemniasz skinienie z krótkim uśmiechem, po czym przykładasz pięść do piersi.%SPEECH_ON%Zamknij to wszystko tutaj i nie pozwól nikomu tego zobaczyć. Połowa każdej bitwy to przekonanie przeciwnika, że jesteś bardziej szalony niż on. Być nieustraszonym jest niemożliwe, ale udawać przez jakiś czas - już nie.%SPEECH_OFF%Mężczyzna znów kiwa głową i wraca do obozu z nieco wyżej uniesioną głową.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To jest duch!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Rookie.getImagePath());
				_event.m.Rookie.improveMood(1.0, "Odbył zachęcającą rozmowę");
				_event.m.Rookie.getBaseProperties().Bravery += 2;
				_event.m.Rookie.getSkills().update();
				this.List = [
					{
						id = 16,
						icon = "ui/icons/bravery.png",
						text = _event.m.Rookie.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Determinacji"
					}
				];

				if (_event.m.Rookie.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Rookie.getMoodState()],
						text = _event.m.Rookie.getName() + this.Const.MoodStateEvent[_event.m.Rookie.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_22.png[/img]Mężczyzna odwraca się do ciebie, a łzy przecinają strupy krwi na jego policzkach. Kręci głową i pyta, czemu jest jedynym, który tu płacze. Wzruszasz ramionami i pytasz, czy chce odejść z kompanii. Znowu kręci głową.%SPEECH_ON%Poprawię się. Po prostu... po prostu potrzebuję na to trochę czasu, tyle.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zahartuje go walka albo go zabije.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Rookie.getImagePath());
				_event.m.Rookie.worsenMood(1.0, "Zrozumiał, co znaczy być najemnikiem");

				if (_event.m.Rookie.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Rookie.getMoodState()],
						text = _event.m.Rookie.getName() + this.Const.MoodStateEvent[_event.m.Rookie.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() > 8.0)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() == 1 && bro.getBackground().getID() != "background.slave" && !bro.getBackground().isCombatBackground() && bro.getPlaceInFormation() <= 17 && bro.getLifetimeStats().Battles >= 1)
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 1)
		{
			return;
		}

		this.m.Rookie = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 500;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noncombat",
			this.m.Rookie.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Rookie = null;
	}

});

