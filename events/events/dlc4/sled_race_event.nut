this.sled_race_event <- this.inherit("scripts/events/event", {
	m = {
		Sledder = null,
		Fat = null,
		Blind = null
	},
	function create()
	{
		this.m.ID = "event.sled_race";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_143.png[/img]{Gdy śnieg i sztywne wiatry biją w twarz, niemal cudem wydaje się, że na tej górze ktoś macha do ciebie. A jednak stoi tam, brodaty facet z dwiema saniami w rękach. Krzyczy, czy jesteś zainteresowany wyścigiem.%SPEECH_ON%Kto pierwszy rozdzieli te dwa głazy w kształcie kutasów, wygrywa!%SPEECH_OFF%Pytasz, co jest stawką. Gdy patrzy na ciebie jak pies, do którego mówi się w obcym języku, pytasz, o co się zakładacie. Śmieje się.%SPEECH_ON%Nie ma zakładu! To tylko zabawa!%SPEECH_OFF%No dobrze. Może ktoś z %companyname% chciałby spróbować?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niech ktoś wystąpi i to zrobi!",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Fat != null)
				{
					this.Options.push({
						Text = "Wygląda na to, że %fat% się zgłasza.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Blind != null)
				{
					this.Options.push({
						Text = "Wygląda na to, że %shortsighted% się zgłasza.",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				this.Options.push({
					Text = "Mamy ważniejsze sprawy.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_143.png[/img]{%sledder% bierze sanie od górala.%SPEECH_ON%Wygram z tobą do tych skalnych kutasów we właściwym czasie.%SPEECH_OFF%Wszyscy unoszą brwi, gdy kładzie sanie. Wbija buty w ich przód i kieruje je ku krawędzi zbocza.%SPEECH_ON%Gotowy, kiedy ty jesteś.%SPEECH_OFF%Góral daje znak startu i obaj w mgnieniu oka śmigają w dół po śniegu. Nie wiesz, czy twój najemnik zagrał nieczysto, ale góral nagle skręca i wywraca sanie, a potem turla się po puchu, machając brodą i kończynami. %sledder% tymczasem sunie po łatwe zwycięstwo. Kompania ryczy z radości i niesie go na barkach pod górę. Jeśli najemnik oszukał, nie widać tego po góralskiej twarzy - cieszy się, że w ogóle się pościgał.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Świetnie!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Sledder.getImagePath());
				_event.m.Sledder.getBaseProperties().Initiative += 1;
				_event.m.Sledder.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Sledder.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Inicjatywy"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "Dobrze się bawił");

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
			Text = "[img]gfx/ui/events/event_143.png[/img]{%sledder% bierze sanie od górala.%SPEECH_ON%Wygram z tobą do tych skalnych kutasów we właściwym czasie.%SPEECH_OFF%Wszyscy unoszą brwi, gdy kładzie sanie. Wbija buty w ich przód i kieruje je ku krawędzi zbocza.%SPEECH_ON%Gotowy, kiedy ty jesteś.%SPEECH_OFF%Góral daje znak startu i obaj w mgnieniu oka śmigają w dół po śniegu. Pióropusze puchu wystrzeliwują za nimi i wygląda na to, że %sledder% wygra, aż źle obiera kąt i wali prosto w jeden ze skalnych kutasów. Sanie roztrzaskują się na kawałki, a najemnik przelatuje nad głazem i bezwładnie ląduje w śniegu. Śmiejąc się, kompania rzuca mu się na pomoc i stawia go na nogi. Ma trochę obić i coś mu klika, ale przeżyje. Góral wiwatuje.%SPEECH_ON%Prawie mnie miałeś, ale miałeś rozdzielić kutasy, a nie na nie wjechać!%SPEECH_OFF%To powala twoich ludzi na kolana od płaczu ze śmiechu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Au.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Sledder.getImagePath());
				local injury = _event.m.Sledder.addInjury(this.Const.Injury.Mountains);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Sledder.getName() + " doznaje " + injury.getNameOnly()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Sledder.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "Dobrze się bawił");

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
			Text = "[img]gfx/ui/events/event_08.png[/img]{%fat%, najtłuściejszy człowiek w kompanii, postanawia spróbować. Podoba ci się jego szansa - przy jego wadze pewnie poleci prosto w dół zbocza. Góral chętnie podejmuje wyzwanie, ustala zasady i rozpoczyna właściwy wyścig. Obaj mkną po śniegu z łatwością i, jak przewidziałeś, grubas ryczy przez puch jak piorun przez chmurę. Tyle że nie zwalnia. Przelatuje dokładnie między dwoma skalnymi kutasami, sygnalizując zwycięstwo, ale nie potrafi chwycić za liny ani wyhamować. Pędzi przez uskok i to mniej więcej ostatnie, co z niego widzisz. Góral krzywi się i biegnie ku zboczu.%SPEECH_ON%Żyje! Poturbowany, ale żyje!%SPEECH_OFF%Choć bardzo się niepokoisz, odwracasz się i widzisz, że cała kompania zwija się lub klęczy, dławiąc się śmiechem.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Rany!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Fat.getImagePath());
				local injury = _event.m.Fat.addInjury(this.Const.Injury.Mountains);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Fat.getName() + " doznaje " + injury.getNameOnly()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Fat.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "Dobrze się bawił");

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
			ID = "E",
			Text = "[img]gfx/ui/events/event_143.png[/img]{%shortsighted% zgłasza się do wyścigu z góralem. Niechętnie na to pozwalasz, biorąc pod uwagę słaby wzrok najemnika, ale jest w tej sprawie dość zawzięty. Gdy kuca na saniach i chwyta liny, nie możesz nie zauważyć, że już mruży oczy w dół zbocza, jakby nie odróżniał stoku od czerwonej stodoły.%SPEECH_ON%Gotowy!%SPEECH_OFF%Góral ustala zasady i rozpoczyna wyścig. Niemal natychmiast krótkowzroczny najemnik zjeżdża z trasy. Na szczęście nie jedzie jeszcze pełną prędkością, gdy uderza głową w skalną formację. Sanie roztrzaskują się jak pomidor o pręgierz, a sam mężczyzna rozkleja się o kamień. Pędzisz mu z pomocą i stawiasz go na nogi, ale wtedy czujesz pod stopą coś metalowego. Skrzynia ze skarbem! Każesz kompanii udzielić mu porządnej pomocy, a sam wykopujesz, co się da.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ślepy prowadzi widzących.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Blind.getImagePath());
				local injury = _event.m.Blind.addInjury(this.Const.Injury.Mountains);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Blind.getName() + " doznaje " + injury.getNameOnly()
				});
				local item = this.new("scripts/items/loot/ancient_gold_coins_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Mountains)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_fat = [];
		local candidates_blind = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getSkills().hasSkill("trait.fat"))
			{
				candidates_fat.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.short_sighted"))
			{
				candidates_blind.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Sledder = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_fat.len() != 0)
		{
			this.m.Fat = candidates_fat[this.Math.rand(0, candidates_fat.len() - 1)];
		}

		if (candidates_blind.len() != 0)
		{
			this.m.Blind = candidates_blind[this.Math.rand(0, candidates_blind.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"sledder",
			this.m.Sledder.getNameOnly()
		]);
		_vars.push([
			"fat",
			this.m.Fat ? this.m.Fat.getNameOnly() : ""
		]);
		_vars.push([
			"shortsighted",
			this.m.Blind ? this.m.Blind.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Sledder = null;
		this.m.Fat = null;
		this.m.Blind = null;
	}

});

