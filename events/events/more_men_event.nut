this.more_men_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.more_men";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Cała kompania - barwna gromadka, jeśli sam tak powiesz - wchodzi do twojego namiotu naraz. Taki widok zgrai najemników nie jest najprzyjemniejszy, więc przez ułamek sekundy myślisz, by sięgnąć po miecz. Ale potem zauważasz, że żaden z nich nie trzyma broni w dłoni, ani nie mają twarzy ludzi gotowych do mordu. Choć nie wygląda to na bunt mający ściąć ci głowę, trzymasz tę myśl z tyłu głowy.\n\n Uspokaja cię jeszcze bardziej to, że nie zaczynają od razu mówić, tylko czekają na twoje słowa. To gest szacunku, więc myśl o sięganiu po miecz oddala się jeszcze bardziej. Krzyżujesz ręce na stole i pytasz, co im leży na sercu.\n\n Wyjaśniają, że kompania jest zbyt mała. Dokądkolwiek idą, wszędzie czyha niebezpieczeństwo, a ludzie zaczynają obawiać się, że każda kolejna bitwa może być ich ostatnią. W końcu mówią wprost: jeśli mają przeżyć, potrzebują więcej braci u boku.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zatrudniłbym więcej ludzi, gdybyśmy mogli sobie na to pozwolić.",
					function getResult( _event )
					{
						if (this.World.Assets.getMoney() >= 3000)
						{
							return "D";
						}
						else
						{
							return this.Math.rand(1, 100) <= 50 ? "E" : "F";
						}

						return "E";
					}

				},
				{
					Text = "Wkrótce wzmocnimy kompanię nowymi ludźmi - masz moje słowo.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Nie ma potrzeby zatrudniać ludzi, tak jest nam dobrze.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]Natychmiast wstajesz i pukasz knykciami w stół.%SPEECH_ON%Najlepsze umysły muszą myśleć podobnie, bo już odłożyłem nieco koron na zatrudnienie nowych braci!%SPEECH_OFF%Niespokojne, niemal smutne twarze ludzi powoli się rozjaśniają. Uśmiechają się, kiwają głowami i mówią coś w rodzaju \"dobrze\" i \"to dobra wiadomość\". Gdy się odwracają, by wyjść, zauważasz, że za plecami mają schowane sztylety.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Czas zatrudnić nowych ludzi.",
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
			Text = "[img]gfx/ui/events/event_05.png[/img]Niestety, po prostu się z nimi nie zgadzasz.%SPEECH_ON%Jesteście jednymi z najlepszych żołnierzy, jakich widziałem. Nie sądzę, byście mieli się czego bać. Nasi wrogowie drżą o własne życie, gdy was widzą!%SPEECH_OFF%Ale twoje słowa nie trafiają. Jeden z mężczyzn pochyla się do przodu, trzymając rękę za plecami, lecz inny kładzie mu dłoń na ramieniu i szybko kręci głową. Spogląda na ciebie i mówi tylko:%SPEECH_ON%To bardzo niepokojąca wiadomość, panie, ale będziemy się trzymać rozkazów.%SPEECH_OFF%Gdy odchodzą, zauważasz, że zatrzask pochwy sztyletu jednego z nich został odpięty.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To może być problem...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(this.Math.rand(1, 3), "Stracił zaufanie do twojego dowodzenia");

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
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]Rozkładając ręce i przywołując uśmiech, który nie sprzedałby wody spragnionemu, kłamiesz.%SPEECH_ON%Po prostu nie mamy sakiew, by zatrudnić więcej ludzi.%SPEECH_OFF%Ludzie nie przyjmują tego dobrze. Jeden od razu odwraca się i wychodzi z namiotu, zostawiając za sobą stek przekleństw. Drugi brat na chwilę sięga za plecy. Zerkasz znów na swój miecz. On to widzi i chowa ręce tam, gdzie je widać. W końcu kiwa głową.%SPEECH_ON%Zrobimy, co każesz, panie. Na razie.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To może być problem...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.worsenMood(this.Math.rand(1, 6), "Został okłamany i stracił zaufanie do twojego dowodzenia");
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[bro.getMoodState()],
						text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_05.png[/img]Gdy mówisz ludziom, że nie masz dość koron, by zatrudnić kolejnych, kiwają głowami.%SPEECH_ON%Myśleliśmy, że tak powiesz. Więc mamy propozycję, i nie mówimy tego lekko, ale każdy z nas odda ci część tego, co odłożyliśmy na emeryturę, byś mógł zatrudnić innych. A ty oddasz nam to z żołdu.%SPEECH_OFF%Szybko podnosisz wzrok, bo ta propozycja zdaje się brać znikąd.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tak więc zrobimy to w ten sposób - dziękuję wam wszystkim za poświęcenie.",
					function getResult( _event )
					{
						return "G";
					}

				},
				{
					Text = "To nie będzie konieczne.",
					function getResult( _event )
					{
						return "H";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_05.png[/img]Informujesz ludzi, że nie masz koron, by zaciągnąć kolejnych najemników. Wzdychają wspólnie i kiwają głowami.%SPEECH_ON%W porządku, panie. To była tylko sugestia. Jak zawsze, będziemy maszerować wedle twoich rozkazów.%SPEECH_OFF%Ludzie odwracają się i odchodzą, nieco przygarbieni i cichsi niż przedtem.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jestem pewien, że dla kompanii wszystko się poprawi.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 20)
					{
						bro.worsenMood(1, "Stracił zaufanie do twojego dowodzenia");

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
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_05.png[/img]Wstajesz i ściskasz dłoń każdego z mężczyzn. Głośno mówisz, że wolałbyś, aby do tego nie doszło, ale w duchu promieniejesz na myśl, że masz teraz więcej koron do dyspozycji.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Chodźmy zatrudnić dla kompanii jeszcze kilku ludzi!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(1000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + 1000 + "[/color] koron"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.getBaseProperties().DailyWage += 3;
					bro.getSkills().update();
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_daily_money.png",
						text = bro.getName() + " otrzymuje teraz " + bro.getDailyCost() + " koron dziennie"
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_05.png[/img]Oglądasz uważnie ludzi. Są posępnymi postaciami, nie tymi, których widziałeś ostatnio uśmiechniętych i roześmianych po ostatnim zwycięstwie. Choć jeszcze nie stać cię na więcej ludzi, nie ma potrzeby obniżać ich żołdu.%SPEECH_ON%Doceniam bezinteresowność i odwagę, jakich musiało kosztować zaproponowanie tego, ale nie mógłbym uważać się za człowieka honoru, gdybym przyjął waszą prośbę. Wasze oszczędności pozostaną nienaruszone.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mimo to doceniam propozycję.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 20)
					{
						bro.improveMood(1.0, "Zyskał zaufanie do twojego dowodzenia");

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
		if (this.World.Assets.getOrigin().getID() == "scenario.lone_wolf" || this.World.Assets.getOrigin().getID() == "scenario.gladiators")
		{
			return;
		}

		if (this.World.getTime().Days <= 10)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() == 1 || brothers.len() > 5)
		{
			return;
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

