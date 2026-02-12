this.spartan_should_eat_more_event <- this.inherit("scripts/events/event", {
	m = {
		Spartan = null
	},
	function create()
	{
		this.m.ID = "event.spartan_should_eat_more";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%spartan% zawsze był dość oszczędny, jeśli chodzi o jedzenie. Nie wiesz, czy to część jakiegoś rytuału religijnego, poczucia obowiązku, czy po prostu niewiele je. Tak czy inaczej, niedostatek jedzenia osłabił go tak, że ledwo siedzi prosto na kłodzie. W dłoni trzymasz miskę mięsa z kukurydzą, zastanawiając się, czy powinieneś mu ją podać.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zostawię cię w spokoju.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 75 ? "B" : "C";
					}

				},
				{
					Text = "Jedz, głupcze!",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 75 ? "D" : "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Spartan.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]Uznajesz, że pewnie już to przechodził i zostawiasz go w spokoju. Po chwili widzisz go, jak chodzi i rozmawia zupełnie normalnie. W rzeczy samej, jak na człowieka, który tak mało je, radzi sobie całkiem nieźle!",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Każdemu jego własne.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Spartan.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]Ten człowiek robił to już wcześniej, zrobi to i teraz. Odwracasz się, by zjeść posiłek gdzie indziej, ale słyszysz, jak mężczyzna osuwa się na ziemię. Zemdlał i wygląda na to, że uderzył głową podczas upadku.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Co do siedmiu piekieł ci dolega?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Spartan.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					_event.m.Spartan.addLightInjury();
					this.List = [
						{
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = _event.m.Spartan.getName() + " odnosi lekkie rany"
						}
					];
				}
				else
				{
					local injury = _event.m.Spartan.addInjury(this.Const.Injury.Concussion);
					this.List = [
						{
							id = 10,
							icon = injury.getIcon(),
							text = _event.m.Spartan.getName() + " doznaje " + injury.getNameOnly()
						}
					];
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]Rozkazujesz mu jeść. Opiera się, ale przypominasz, że to \'rozkaz\', a nie prośba. Najemnik robi, co mu kazano, jedząc z twojej miski dość ostrożnie. Narzeka, że nie chce już jeść, ale każesz mu dokończyć posiłek. Z czasem wszystko, co mu dolegało, zdaje się mijać. W jego oczach wraca energia, wstaje z żwawym krokiem. Niestety, nie podoba mu się, że kazano mu złamać osobiste zasady.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie zmuszaj mnie do powtarzania.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Spartan.getImagePath());
				_event.m.Spartan.worsenMood(1.0, "Zmuszono go do jedzenia wbrew przekonaniom");

				if (_event.m.Spartan.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Spartan.getMoodState()],
						text = _event.m.Spartan.getName() + this.Const.MoodStateEvent[_event.m.Spartan.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_05.png[/img]Rozkazujesz mu jeść, a on robi, co mu kazano. Na początku wydaje się niechętny, ale po kilku kęsach rzuca się na miskę, oblepiają go soki, a ziarenka kukurydzy znaczą jego policzki. Jest niemal obłąkany z radości. Przypomniałeś mu, jak dobre może być jedzenie. Osobiście uznałeś, że mięso było trochę przypieczone.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie zmuszaj mnie do powtarzania.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Spartan.getImagePath());
				_event.m.Spartan.getSkills().removeByID("trait.spartan");
				this.List = [
					{
						id = 10,
						icon = "ui/traits/trait_icon_08.png",
						text = _event.m.Spartan.getName() + " nie jest już spartański"
					}
				];
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getSkills().hasSkill("trait.spartan") && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Spartan = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"spartan",
			this.m.Spartan.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Spartan = null;
	}

});

