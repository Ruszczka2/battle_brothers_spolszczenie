this.undead_zombie_in_granary_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.undead_zombie_in_granary";
		this.m.Title = "W %town%...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_79.png[/img]Napotykasz mężczyznę krzyczącego o pomoc, tak histerycznie, że zdaje się nie przejmować tym, że zwraca uwagę uzbrojonych najemników, którzy nie są lojalni wobec żadnego rodu ani jego praw. %SPEECH_ON%Proszę! Pomóżcie mi! Tam jest... trup! W spichlerzu!%SPEECH_OFF%Wskazuje kciukiem na duży drewniany budynek. Drzwi wejściowe niemal jak na zawołanie zaczynają się trząść. Mężczyzna wpada w panikę.%SPEECH_ON%To on! To potwór! Proszę, wejdźcie tam i go zabijcie! Nie możemy stracić całej żywności!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Najlepiej spalić spichlerz.",
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
					Text = "Jeden z moich ludzi wejdzie i się tym zajmie.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "D";
						}
						else
						{
							return "E";
						}
					}

				},
				{
					Text = "Nie mamy na to czasu.",
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
			Text = "[img]gfx/ui/events/event_30.png[/img]Chwytasz mężczyznę za ramiona i wpatrujesz się w niego, mówiąc.%SPEECH_ON%Spalimy spichlerz. Ta żywność, słyszysz? Słuchaj uważnie tego, co mówię. Ta żywność jest skażona i nie nadaje się do jedzenia. Nie ma czego ratować.%SPEECH_OFF%Chłop, drżący jak w gorączce, odsuwa się. Zakrywa twarz dłońmi, ledwo mogąc patrzeć, jak dwóch twoich najemników podchodzi z pochodniami i podpala spichlerz.\n\nDrzwi na chwilę przestają się trząść, po czym znów zaczynają, niemal wyrywając zawiasy. Gdy dym unosi się z dołu, ktoś zaczyna krzyczeć.%SPEECH_ON%Żart! Żart! Proszę, wypuśćcie mnie! Aaa, AAAH!%SPEECH_OFF%%dude% rzuca się do drzwi i wyważa je. Wybiega mały chłopiec, płonie jak pochodnia, kończyny wymachują łukami ognia. Opada na ziemię, gdzie najemnicy próbują go przykryć, ale jest już za późno. Kiedy ogień zostaje ugaszony, zostaje z niego tylko tląca się ruina. Chłop wygląda na kompletnie przerażonego.%SPEECH_ON%Ja... nie miałem pojęcia, myślałem, że to... on wydawał warczące dźwięki.%SPEECH_OFF%Kręcisz głową i każesz kompanom szybko wracać na drogę.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "No to klops.",
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
					if (bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(0.5, "Spaliłeś chłopca przez przypadek");

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
			ID = "C",
			Text = "[img]gfx/ui/events/event_30.png[/img]Jedzenie bez wątpienia już padło ofiarą choroby, a cały budynek może być skażony złem ponad ludzką miarę. Spokojnie wyjaśniasz mężczyźnie, że spalisz jego spichlerz. Nie sprzeciwia się, tylko szybko kiwa głową.%SPEECH_ON%Wiem. Nie chciałem robić tego sam, chyba trzymałem się myśli, że ktoś przyjdzie i powie mi to, co chcę usłyszeć, a nie to, co trzeba zrobić.%SPEECH_OFF%Kilku najemników przykłada pochodnie do rogów spichlerza i nie mija wiele czasu, nim ogień wspina się po jego ścianach i dachu. Minutę później cały budynek płonie. Gdy drzwi wejściowe pękają, wiederganger wyłania się przez szczelinę, całe jego ciało oblewa ogień i dym. Teraz to niemal same zwęglone kości, skóra spływa z jego szkieletu wielkimi, lepkimi płatami. %dude% odcina mu głowę szybkim ciosem. Chłop patrzy, jak reszta jego budynku się wali, a blask ognia rozświetla łzy na jego policzku.%SPEECH_ON%Cóż, chyba to wszystko. Dziękuję, najemniku.%SPEECH_OFF%Daje ci skromną sumę koron, którą z chęcią przyjmujesz za swoje 'usługi'.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Obrzydliwe.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				this.World.Assets.addMoney(50);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]50[/color] Koron"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_79.png[/img]Postanawiasz rozwiązać problem wiedergangera tak, jakby stał przed tobą w polu. %dude% wyważa drzwi i dźga pierwszą rzecz, jaką widzi. Nieumarłe ciało szarpie się, a impet zgina je na ostrzu. I wtedy to widzisz: krew powoli spływa po metalu. Gdy najemnik cofa się, światło ujawnia, że to nie nieumarły, tylko zwykły chłopiec. Dusi się, oczy szeroko otwarte, dłonie drżą na ranie.%SPEECH_ON%Ja... ja tylko się bawiłem...%SPEECH_OFF%Najemnik odciąga ramię i wyciąga broń. Chłopiec się osuwa. Odwracasz się do chłopa. Unosi dłonie.%SPEECH_ON%Ja... nie miałem pojęcia! Wydawał dźwięki! Ciągle, słyszałem... warczał! Było tego warczenia tyle, ja nie...%SPEECH_OFF%Mężczyzna pada na kolana. Patrzysz na chłopca, którego nie da się już uratować, skóra blednie mu z każdą sekundą, a strumienie karminu tryskają z ran. Kręcisz głową i każesz ludziom wracać na drogę, zanim wydarzy się coś złego.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cholera jasna.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				_event.m.Dude.worsenMood(2.0, "Zabił małego chłopca przez przypadek");

				if (_event.m.Dude.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Dude.getMoodState()],
						text = _event.m.Dude.getName() + this.Const.MoodStateEvent[_event.m.Dude.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_79.png[/img]Wysyłasz %dude% do spichlerza, by się tym zajął. Poklepuje się po ramionach, żeby się rozgrzać.%SPEECH_ON%Jednego martwego wiedergangera zaraz wam podam.%SPEECH_OFF%Najemnik wyważa drzwi i wpada do środka. Słychać zgiełk walki, a błysk światła odbija się od metalu jego broni, gdy działa w ciemności i złu. Po chwili wychodzi, wycierając pot z czoła.%SPEECH_ON%Gotowe. Krew na części jedzenia, ale można jeść dookoła tego.%SPEECH_OFF%Odwracasz się do chłopa i wyciągasz rękę. Niechętnie podaje ci mały woreczek koron.%SPEECH_ON%Dziękuję... najemniku.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra robota.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				this.World.Assets.addMoney(50);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]50[/color] Koron"
					}
				];
				_event.m.Dude.improveMood(0.25, "Uratował chłopa");

				if (_event.m.Dude.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Dude.getMoodState()],
						text = _event.m.Dude.getName() + this.Const.MoodStateEvent[_event.m.Dude.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isUndeadScourge())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local bestDistance = 9000;
		local bestTown;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() > 2)
			{
				continue;
			}

			local d = playerTile.getDistanceTo(t.getTile());

			if (d < bestDistance)
			{
				bestDistance = d;
				bestTown = t;
			}
		}

		if (bestTown == null || bestDistance > 3)
		{
			return;
		}

		this.m.Town = bestTown;
		this.m.Dude = brothers[this.Math.rand(0, brothers.len() - 1)];
		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"town",
			this.m.Town.getName()
		]);
		_vars.push([
			"dude",
			this.m.Dude.getName()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
		this.m.Dude = null;
	}

});

