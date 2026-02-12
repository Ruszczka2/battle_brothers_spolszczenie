this.warriors_death_event <- this.inherit("scripts/events/event", {
	m = {
		Gravedigger = null,
		Casualty = null
	},
	function create()
	{
		this.m.ID = "event.warriors_death";
		this.m.Title = "Po bitwie...";
		this.m.Cooldown = 200.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_87.png[/img]Bitwa skończona, rozglądasz się po zniszczeniu, jakie pozostawiła. %deadbrother% leży na plecach, wpatrując się bezmyślnie w niebo szklistymi oczami. Inni bracia leżą na polu bitwy. Są zdeformowani, poszarpani, połamani i rozerwani, wkrótce zaczną gnić. To wspólnie okrutny koniec. A teraz zlatują się muchy, znacząc martwych jak wiercące się krety. Kopulują na zimnej skórze bezwstydnie i zaczynają drążyć nowe gniazda w wciąż ciepłej rzezi. %randombrother% podchodzi i pyta, co chcesz zrobić z ciałami.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zostawcie ich tam.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Uczcijmy zmarłych!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Gravedigger != null)
				{
					this.Options.push({
						Text = "Niech %gravedigger% grabarz się tym zajmie.",
						function getResult( _event )
						{
							return "E";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_87.png[/img]Zerkasz w niebo. Kruki i arkikruki krążą nad głową. Skrzeczą i kłócą się, czekając na twoje odejście. Chowając miecz, skinieniem wskazujesz pole bitwy.%SPEECH_ON%Splądrujcie ciała. Zostawcie martwych ptakom.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To w końcu głodny świat.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local r;
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					local chance = 25;

					if (bro.getBackground().getID() == "background.monk")
					{
						chance = 100;
					}
					else if (bro.getSkills().hasSkill("trait.fainthearted") || bro.getSkills().hasSkill("trait.craven") || bro.getSkills().hasSkill("trait.dastard") || bro.getSkills().hasSkill("trait.pessimist") || bro.getSkills().hasSkill("trait.superstitious") || bro.getSkills().hasSkill("trait.insecure") || bro.getSkills().hasSkill("trait.disloyal"))
					{
						chance = 75;
					}
					else if (bro.getSkills().hasSkill("trait.cocky") || bro.getSkills().hasSkill("trait.loyal") || bro.getSkills().hasSkill("trait.optimist") || bro.getSkills().hasSkill("trait.deathwish"))
					{
						chance = 10;
					}

					if (this.Math.rand(1, 100) > r)
					{
						continue;
					}

					bro.worsenMood(0.5, "Przygnębiony tym, że polegli towarzysze zostali na polu bitwy");

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

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_28.png[/img]Wskazujesz na zmarłych.%SPEECH_ON%To byli dobrzy ludzie, a dobrzy ludzie zasługują na godny pochówek. Uczcimy ich tak, jak należy: porządną jamą do snu, koronami, które wydadzą w następnym świecie, i ucztą na cześć. Tego samego oczekiwałbym dla siebie!%SPEECH_OFF%Ci, którzy przeżyli, wiwatują i zaczynają przygotowania.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Teraz możemy zostawić ich w ich ostatecznym spoczynku.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local r;
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					local chance = 50;

					if (this.Math.rand(1, 100) > r)
					{
						continue;
					}

					bro.improveMood(0.5, "Cieszy się, że polegli towarzysze dostali godne pożegnanie");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}

				this.World.Assets.addMoney(-60);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]60[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_28.png[/img]Powierzasz obowiązek pochówku %gravedigger%, człowiekowi zaprawionemu w tym rzemiośle. Nie zajmuje mu długo wykopanie równych, kwadratowych dołów w ziemi. Owija ciała w płótno, nim ostrożnie ułoży je w ich ostatecznym spoczynku. Gdy wszystko się kończy, groby leżą w ziemi jakby były zbitą, rozrzuconą linią płotu. Każdy kopiec ma przed sobą palik z imieniem poległego brata wyrytym w drewnie. %gravedigger% opiera łopatę i kładzie na niej dłonie. Kiwając głową na swoją pracę, mówi:%SPEECH_ON%Są głęboko.%SPEECH_OFF%Mężczyzna spluwa.%SPEECH_ON%Teraz tylko robaki po nich będą. Mam nadzieję, że ci to nie przeszkadza - ale gdziekolwiek człowiek trafia po śmierci, tam jest paszcza potrzebująca nowej strawy. Chyba że spalisz ciała, co? Ale mówią, że nawet wtedy duchy mają swoje kąski. Wdychanie dymu to przyprawa ducha czy coś takiego.%SPEECH_OFF%Podnosząc łopatę, grabarz odwraca się i odchodzi, jakby jego praca i słowa były tylko snem we śnie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cóż... niech spoczywają w pokoju.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gravedigger.getImagePath());
				local r;
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					local chance = 75;

					if (this.Math.rand(1, 100) > r)
					{
						continue;
					}

					bro.improveMood(0.5, "Cieszy się, że polegli towarzysze dostali godne pożegnanie");

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

		});
	}

	function onUpdateScore()
	{
		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() > 8.0)
		{
			return;
		}

		local fallen = [];
		local fallen = this.World.Statistics.getFallen();

		if (fallen.len() < 3)
		{
			return;
		}

		local f0;
		local f1;

		foreach( f in fallen )
		{
			if (f.Expendable)
			{
				continue;
			}

			if (f0 == null)
			{
				f0 = f;
			}
			else if (f1 == null)
			{
				f1 = f;
			}
			else
			{
				break;
			}
		}

		if (f0 == null || f1 == null)
		{
			return;
		}

		if (f0.Time < this.World.getTime().Days || f1.Time < this.World.getTime().Days)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_gravedigger = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.gravedigger")
			{
				candidates_gravedigger.push(bro);
			}
		}

		this.m.Casualty = f0.Name;

		if (candidates_gravedigger.len() != 0)
		{
			this.m.Gravedigger = candidates_gravedigger[this.Math.rand(0, candidates_gravedigger.len() - 1)];
		}

		this.m.Score = 500;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"gravedigger",
			this.m.Gravedigger != null ? this.m.Gravedigger.getNameOnly() : ""
		]);
		_vars.push([
			"deadbrother",
			this.m.Casualty
		]);
	}

	function onClear()
	{
		this.m.Gravedigger = null;
		this.m.Casualty = null;
	}

});

