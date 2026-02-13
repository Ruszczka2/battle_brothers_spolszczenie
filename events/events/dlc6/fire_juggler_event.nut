this.fire_juggler_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null,
		Juggler = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.fire_juggler";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 160.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Żongler ogniem przykuwa uwagę wszystkich na placu w %townname%. Ma zestaw trzech pochodni z brązowymi uchwytami. Jego występ idzie całkiem nieźle, ale w pewnym momencie upuszcza pochodnię, co wywołuje szyderstwa. Kolejny numer ma polegać na położeniu deski nad otwartą beczką z olejem i żonglowaniu pochodniami z ramionami na boki, tyle że teraz pięcioma zamiast trzech.\n\nW skrócie, następny numer wygląda na samobójstwo i nic dziwnego, że żongler nie chce go wykonać. Ale tłum wciąż wiwatuje i kpi, sapie i warczy jak wilk przyciskający jelenia do urwiska, a żongler, z szeroko otwartymi oczami, rozgląda się za jakąś drogą ucieczki.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zobaczmy, jak to zrobi.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "C" : "D";
					}

				},
				{
					Text = "Musimy mu pomóc!",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Juggler != null && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
				{
					this.Options.push({
						Text = "%juggler%, potrafisz żonglować, pomożesz mu?",
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
			Text = "[img]gfx/ui/events/event_163.png[/img]{Wzdychasz i robisz krok do przodu, głośno krzycząc do żonglera i udając, że jesteś jego menedżerem, mówiąc mu, że jeszcze nie czas na wielki pokaz. Tłum cichnie, zdezorientowany, po czym kpi z ciebie. Wysunięcie połowy miecza ucisza ich, a inni mamroczą słowo \'Koroniarz\', co wywołuje syknięcia i buczenie. Ostatecznie jednak się rozchodzą. Żongler schodzi ze swojej scenki i wielokrotnie ci dziękuje.%SPEECH_ON%Nie byłem gotów, nie byłem gotów, a ty to dostrzegłeś sokolim okiem, dobry nieznajomy! Oto mój dzienny zarobek, weź wszystko, bo nie byłby wart nawet korony, gdybym miał tam wejść i zginąć!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Uważaj na siebie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local money = this.Math.rand(1, 40);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] koron"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Krzyżujesz ręce i czekasz na pokaz. Żongler ogniem przełyka ślinę i wchodzi na beczkę. Opuszcza pochodnię, a jeden z mieszkańców ją podpala, lecz kiedy błazen podnosi pochodnię, wieśniak udaje, że wrzuca własny ogień do kadzi z olejem. Żongler odskakuje na moment, a tłum się śmieje, tak jak rozbawiony błazen.\n\n Ale żongler daje radę. Wszystkie pięć pochodni wiruje i kręci się, a parę razy żar spada na rant beczki z olejem, lecz ma wszystko pod kontrolą, a szyderstwa tłumu zamieniają się w okrzyki, i gdy kończy, ludzie klaszczą, po czym powoli się rozchodzą, szukając kolejnej rozrywki. Jeden z mężczyzn wrzuca kilka koron w dłonie żonglera i na tym koniec.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Brawo!",
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
					if (this.Math.rand(1, 100) <= 75)
					{
						bro.improveMood(0.5, "Został rozbawiony przez żonglera ogniem");

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
			ID = "D",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Krzyżujesz ręce i czekasz na pokaz. Żongler ogniem przełyka ślinę i wchodzi na beczkę. Opuszcza pochodnię, a jeden z mieszkańców ją podpala, lecz kiedy błazen podnosi pochodnię, wieśniak udaje, że wrzuca własny ogień do kadzi z olejem. Żongler odskakuje na moment, a tłum się śmieje, tak jak rozbawiony błazen.\n\n Gdy błazen zaczyna numer, zaczyna od podpalenia siebie. Dosłownie pierwsza pochodnia wyślizguje mu się z dłoni i wpada do kadzi, wyrzucając pióropusz płomieni, w którym nie da się odróżnić człowieka od ognia, poza piekielnymi krzykami. Zbiega ze \'sceny\', a tłum tylko cofa się, by wskazywać palcem i śmiać się. Gdy umiera, jeden z mieszkańców zabiera jego korony. Podnoszą złoto ku niebu, wspominają mimochodem o Złoconym, a potem wrzucają korony w płomienie. Jego ciało zostaje dla psów. Gdy wszystko się kończy, grzebiesz w popiele i znajdujesz płytkę stopionego złota. Niezbyt wartościowa, ale coś warta, więc zabierasz ją, kiedy nikt - nawet psy - nie patrzy.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Złoto to złoto.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local money = this.Math.rand(1, 40);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] koron"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_163.png[/img]{%juggler%, dawny żongler z kompanii, wysuwa się do przodu. Wchodzi na \'scenę\', która niebezpiecznie wisi nad kadzią z olejem. Obaj wymieniają kilka słów, po czym %juggler% zostaje na nogach. Wykonuje numer - którego ani nie ćwiczył, ani nie widział wcześniej - i kończy go bez problemu. Tłum jednak milczy. Po prostu patrzą, tylko czasem zerkając na ciebie i kompanię. Gdy %juggler% kończy, rozkłada ramiona szeroko, ale nie ma oklasków.%SPEECH_ON%Złocony spluwa na Koroniarzy, przybyszu, nie tańczysz dla nikogo. A ty, żonglerze, co masz do powiedzenia?%SPEECH_OFF%Żongler z %townname% myśli, po czym odwraca się do ciebie.%SPEECH_ON%Mówię, że mam dość tych bredni, a jeśli Złocony tak nami gardzi, to niech gardzi mną pośród szeregów tej kompanii. Co powiesz, kapitanie Koroniarzy, przyjmiesz mnie?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Witaj w %companyname%.",
					function getResult( _event )
					{
						return "F";
					}

				},
				{
					Text = "To nie miejsce dla ciebie.",
					function getResult( _event )
					{
						return "G";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"juggler_southern_background"
				]);
				_event.m.Dude.setTitle("the Fire Juggler");
				_event.m.Dude.getBackground().m.RawDescription = "Znalazłeś %name% na ulicach " + _event.m.Town.getName() + ", gotowego dać ognisty pokaz rekordowej żonglerki, który mógł go kosztować życie. Na szczęście " + _event.m.Juggler.getName() + " wskoczył, by wykonać numer razem z nim, być może ratując mu życie. Po wszystkim %name% miał już dość swojego fachu i zgłosił się do twojej kompanii.";
				_event.m.Dude.getBackground().buildDescription(true);
				local trait = this.new("scripts/skills/traits/fearless_trait");

				foreach( id in trait.m.Excluded )
				{
					_event.m.Dude.getSkills().removeByID(id);
				}

				_event.m.Dude.getSkills().add(trait);
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Dude.improveMood(1.0, "Został uratowany przed możliwą płomienną śmiercią przez innego żonglera");
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Kiwasz głową.%SPEECH_ON%Ognik, Koroniarz, wszystko jedno. Jesteś z %companyname%.%SPEECH_OFF%Tłum znów syczy, ale każesz im się odczepić, podkreślając groźbę błyskiem miecza, na wypadek gdyby mieli problemy ze zrozumieniem. %firejuggler%, żongler ogniem, dziękuje ci gorąco i szybko idzie do twoich szeregów, gdzie kompania wita go równie niechętnie jak każdego nowego rekruta. Co do ludzi z %townname%, szybko mają dość dramatu i wracają do swoich spraw.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Przedstawienie skończone, ludzie.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				this.Characters.push(_event.m.Dude.getImagePath());
				local meleeSkill = this.Math.rand(1, 3);
				_event.m.Juggler.getBaseProperties().MeleeSkill += meleeSkill;
				_event.m.Juggler.getSkills().update();
				_event.m.Juggler.improveMood(1.0, "Dał świetny pokaz żonglerki ogniem");
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Juggler.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color] Umiejętności walki wręcz"
				});

				if (_event.m.Juggler.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Juggler.getMoodState()],
						text = _event.m.Juggler.getName() + this.Const.MoodStateEvent[_event.m.Juggler.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Kręcisz głową. Żongler opuszcza swoją.%SPEECH_ON%Och. Myślałem, że coś nas łączy.%SPEECH_OFF%Zaciskasz usta i kręcisz głową ponownie.%SPEECH_ON%Nie... nic nas nie łączy. Po prostu nie chcę cię w mojej kompanii, bez urazy. Ćwicz dalej, no wiesz, z ogniem i kijami, kiedyś na pewno ci wyjdzie.%SPEECH_OFF%Żongler przytakuje.%SPEECH_ON%Oczywiście. I choć mnie odrzuciłeś, wierzę, że Gilder ma nas obu dokładnie tam, gdzie mamy być, a Jego zamiarem nie było, by nasze drogi przecięły się bezowocnie. Na pewno będę dobrze mówił o twojej kompanii, gdziekolwiek się pojawię!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niech ścieżka Gildera dla nas obu będzie tak dobra, jak masz nadzieję.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				this.Characters.push(_event.m.Dude.getImagePath());
				local meleeSkill = this.Math.rand(1, 3);
				_event.m.Juggler.getBaseProperties().MeleeSkill += meleeSkill;
				_event.m.Juggler.getSkills().update();
				_event.m.Juggler.improveMood(1.0, "Put on a great display of fire juggling");
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Juggler.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color] Melee Skill"
				});

				if (_event.m.Juggler.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Juggler.getMoodState()],
						text = _event.m.Juggler.getName() + this.Const.MoodStateEvent[_event.m.Juggler.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local currentTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() && t.getTile().getDistanceTo(currentTile) <= 4 && t.isAlliedWithPlayer())
			{
				this.m.Town = t;
				break;
			}
		}

		if (this.m.Town == null)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_juggler = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.juggler")
			{
				candidates_juggler.push(bro);
			}
		}

		if (candidates_juggler.len() != 0)
		{
			this.m.Juggler = candidates_juggler[this.Math.rand(0, candidates_juggler.len() - 1)];
		}

		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"juggler",
			this.m.Juggler != null ? this.m.Juggler.getNameOnly() : ""
		]);
		_vars.push([
			"firejuggler",
			this.m.Dude != null ? this.m.Dude.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
		this.m.Juggler = null;
		this.m.Dude = null;
	}

});

