this.religious_peasants_event <- this.inherit("scripts/events/event", {
	m = {
		Monk = null
	},
	function create()
	{
		this.m.ID = "event.religious_peasants";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 200.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_59.png[/img]Lasy zawsze były schronieniem dla człowieka - dzicz, z której wyszedł, i dzicz, do której zawsze chce wrócić. I tu znajdujesz wielką liczbę ludzi, plemię zagubionych, obojętnych wobec porzuconej cywilizacji, odzianych w religijne szaty, niosących wielkie symbole wiary i tomy prawdy. Są ubodzy niemal do granic przesadnej wytworności, niczym wielcy królowie chcący wtopić się w pospólstwo. Siedzisz i patrzysz, jak suną obok, brzękając, stukając, grzechocząc pustymi drewnianymi paciorkami, szepcząc pod nosem, chrapliwie i sucho. I tak idą dalej, ledwie zawracając sobie głowę, by na ciebie spojrzeć.",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Zobaczmy, dokąd idą.",
					function getResult( _event )
					{
						if (_event.m.Monk != null)
						{
							local r = this.Math.rand(1, 3);

							if (r == 1)
							{
								return "B";
							}
							else if (r == 2)
							{
								return "C";
							}
							else
							{
								return "F";
							}
						}
						else
						{
							local r = this.Math.rand(1, 2);

							if (r == 1)
							{
								return "B";
							}
							else
							{
								return "C";
							}
						}
					}

				},
				{
					Text = "Lepiej zostawić ich w spokoju.",
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
			Text = "[img]gfx/ui/events/event_03.png[/img]Zaciekawiony, wołasz do ludzi, pytając, dokąd idą. Mężczyzna z przodu powoli odwraca się do ciebie, a jego oczy wyglądają z mroku otulonego szalem. Powoli odsuwa płaszcz, odsłaniając głowę naznaczoną bliznami w wzorze religijnych rytów. Wszyscy mężczyźni za nim czynią to samo, jak rząd kart przewracanych przez chaotyczny, szalony wiatr.%SPEECH_ON%Davkul zobaczy cię w następnym świecie!%SPEECH_OFF%Jeden z nich krzyczy i ruszają do szarży.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.CivilianTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];

						for( local i = 0; i < 25; i = ++i )
						{
							local unit = clone this.Const.World.Spawn.Troops.Cultist;
							unit.Faction <- this.Const.Faction.Enemy;
							properties.Entities.push(unit);
						}

						this.World.State.startScriptedCombat(properties, false, false, true);
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
			Text = "[img]gfx/ui/events/event_12.png[/img]{To oczywiście niecodzienny widok, więc z ciekawości wołasz do zmęczonych wędrowców. Słowa ledwie opuszczają twoje usta, gdy cały szereg ludzi staje w miejscu i prostuje się jak na komendę. Płaszcze rozwijają się i opadają z głów, a ich księgi, kije i religijne rekwizyty rozsypują się z jednolitym stukotem. Mężczyźni rozglądają się, z szeroko otwartymi oczami, bardziej żywymi niż kiedykolwiek. Jeden krzyczy. Potem drugi. Wkrótce krzyczą wszyscy, a niektórzy osuwają się na ziemię, zasłaniając uszy, jakby chcieli uciszyć przeraźliwe wycia własnych ust, podczas gdy inni kręcą się w kółko, z wyciągniętymi ramionami, błagając o odpowiedzi.\n\n Samym słowem zdajesz się przerwać zaklęcie, które tak długo wisiało nad ich głowami, że doprowadziło ich tu, biednych, głodnych i szalonych. Krok po kroku rządziła nimi złośliwa wyższa siła, a z każdym krokiem czuli, jak kontrola nad ich życiem się wymyka, a wraz z nią rozsądek potrzebny każdemu, by być sobą. Niestety, nie możesz nawet zapytać, co lub kto im to zrobił, bo część pada martwa, a inni nago uciekają w las. | Taki widok aż prosi się o pytania, ale gdy tylko słowo opuszcza twoje usta, cały zastęp religijnych mężczyzn prostuje się, a nagły szelest ubrań i sprzętu rozbrzmiewa tak równym stukotem, jakby zatrzasnęły się drzwi. Mężczyźni upuszczają swoje rzeczy i zaczynają krzyczeć. To chrapliwy chór. Wszyscy zaczynają się osuwać, jedni klękając na kościstych kolanach, inni chwytając się za brzuchy z bolesnego głodu.\n\n %randombrother% podchodzi, kręcąc głową.%SPEECH_ON%Byli przeklęci? Co mogło to zrobić?%SPEECH_OFF%Odpowiedzi nie poznasz, bo minutę później każdy z nich nie żyje, wyglądając nie lepiej niż trupy niedawno rozmrożone z gór. Zaklęcie musiało siłą prowadzić ich pielgrzymkę, nadwyrężając ludzkie ciało, a przy życiu trzymając je tylko cienką nicią eterycznej złośliwości. Choć wszyscy nie żyją, nie żałujesz uwolnienia ich od tak strasznej klątwy.}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Niech spoczywają w pokoju.",
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
					if (bro.getSkills().hasSkill("trait.superstitious") || this.Math.rand(1, 100) <= 33)
					{
						bro.worsenMood(0.5, "Był świadkiem strasznej klątwy");

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
			ID = "F",
			Text = "[img]gfx/ui/events/event_59.png[/img]Ciekaw, dokąd idą ci ludzie, otwierasz usta, ale %monk% mnich robi krok do przodu, przerywając ci. Podchodzi do mężczyzny z przodu i prowadzi z nim cichą rozmowę. Jest wiele kiwania głową, pomruków i innych gestów ludzi, którzy długo rozważają sprawy daleko poza ludzkim światem. W końcu mnich wraca.%SPEECH_ON%Są na pielgrzymce, a teraz nasze imię wędruje wraz z nimi. Wielu o nim usłyszy.%SPEECH_OFF%Dziękujesz mnichowi za dobrze wykonaną robotę.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Na pewno jesteśmy potępionymi duszami, ale oni o tym nie wiedzą...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				this.World.Assets.addMoralReputation(1);
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
				this.List.insert(0, {
					id = 10,
					icon = "ui/icons/special.png",
					text = "Kompania zyskała sławę"
				});
				_event.m.Monk.improveMood(1.0, "Pomógł rozgłosić wieści o kompanii");

				if (_event.m.Monk.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk.getMoodState()],
						text = _event.m.Monk.getName() + this.Const.MoodStateEvent[_event.m.Monk.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.monk")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Monk = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Score = 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Monk = null;
	}

});

