this.cultist_vs_old_gods_event <- this.inherit("scripts/events/event", {
	m = {
		Cultist = null,
		OldGods = null
	},
	function create()
	{
		this.m.ID = "event.cultist_vs_old_gods";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_06.png[/img]Zajadając kawałek boczku, słyszysz, że gdzieś wybuchła kłótnia. Przez chwilę to ignorujesz, ale krzyki tylko narastają, szybko zagłuszając twoją przyjemność z posiłku. Poirytowany wstajesz i ruszasz w stronę zamieszania. Zastajesz %cultist% i %oldgods% naprzeciw siebie, kultystę i wyznawcę starych bogów, którzy najwyraźniej odkryli pewne różnice.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niech bogowie zajmą się najkrwawszym!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Dość tych bzdur.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OldGods.getImagePath());
				this.Characters.push(_event.m.Cultist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_06.png[/img] Odsuwasz się na bok, pozwalając ludziom rozstrzygnąć spór tak, jak to robią mężczyźni o wielkich różnicach. Pięści jako argumenty, wyznawca starych bogów przedstawia swoją rację, okładając kultystę raz po raz. Lecz człowiek z bliznami na głowie tylko się uśmiecha. Jego oczy puchną, powieki sinieją i zaciskają się na wzroku. A jednak wciąż się szczerzy, a z zaczerwienionych ust tryska krwawy śmiech.%SPEECH_ON%Taka ciemność! Davkul jest wielce zadowolony!%SPEECH_OFF%Z niespokojnym spojrzeniem %oldgods% schodzi z %cultist% i cofa się. Pociera zakrwawione kostki, uświadamiając sobie, że w tej pozornie jednostronnej bójce mógł kilka złamać. Ale to słowa kultysty ranią go najbardziej.%SPEECH_ON%Człowiek nie ulega pokusie ciemności, on jest do niej wzywany! Zgubiony bez niej! Uradowany jej powrotem!%SPEECH_OFF%Niemal bojąc się obejrzeć, %oldgods% pospiesznie odchodzi, a kultysta zostaje, śmiejąc się i chichocząc na trawie, podczas gdy nikt nie odważa się do niego zbliżyć.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie wiedziałem, że %oldgods% ma to w sobie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OldGods.getImagePath());
				this.Characters.push(_event.m.Cultist.getImagePath());
				_event.m.OldGods.worsenMood(1.0, "Lost composure and resorted to violence");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.OldGods.getMoodState()],
					text = _event.m.OldGods.getName() + this.Const.MoodStateEvent[_event.m.OldGods.getMoodState()]
				});
				_event.m.OldGods.getBaseProperties().Bravery += -1;
				_event.m.OldGods.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.OldGods.getName() + " traci [color=" + this.Const.UI.Color.NegativeEventValue + "]-1[/color] Determinacji"
				});
				local injury = _event.m.Cultist.addInjury(this.Const.Injury.Brawl);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Cultist.getName() + " doznaje " + injury.getNameOnly()
				});
				_event.m.Cultist.getBaseProperties().Bravery += 2;
				_event.m.Cultist.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Cultist.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Determinacji"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_03.png[/img] Przy takiej sytuacji ledwo masz człowieka do oszczędzenia. Gdy pięści mają już pójść w ruch, wchodzisz między nich i kończysz sprawę. Mówisz %oldgods%, że stać go na więcej, a %cultist% nie mówisz nic, bo kultysta niemal zanosi się śmiechem. Wskazuje palcem, szczerząc się obłąkańczo.%SPEECH_ON%Światło wkracza, ale ciemność jest cierpliwa. Davkul na was czeka.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A praca na ciebie czeka, ruszaj.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OldGods.getImagePath());
				this.Characters.push(_event.m.Cultist.getImagePath());
				_event.m.OldGods.worsenMood(1.0, "Was denied the chance to enlighten a cultist");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.OldGods.getMoodState()],
					text = _event.m.OldGods.getName() + this.Const.MoodStateEvent[_event.m.OldGods.getMoodState()]
				});
				_event.m.Cultist.worsenMood(1.0, "Was denied the chance to break a follower of the old gods");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Cultist.getMoodState()],
					text = _event.m.Cultist.getName() + this.Const.MoodStateEvent[_event.m.Cultist.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getOrigin().getID() == "scenario.cultists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local cultist_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				cultist_candidates.push(bro);
			}
		}

		if (cultist_candidates.len() == 0)
		{
			return;
		}

		local oldgods_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.monk" || bro.getBackground().getID() == "background.flagellant" || bro.getBackground().getID() == "background.pacified_flagellant" || bro.getBackground().getID() == "background.monk_turned_flagellant")
			{
				oldgods_candidates.push(bro);
			}
		}

		if (oldgods_candidates.len() == 0)
		{
			return;
		}

		this.m.Cultist = cultist_candidates[this.Math.rand(0, cultist_candidates.len() - 1)];
		this.m.OldGods = oldgods_candidates[this.Math.rand(0, oldgods_candidates.len() - 1)];
		this.m.Score = (cultist_candidates.len() + oldgods_candidates.len()) * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cultist",
			this.m.Cultist.getName()
		]);
		_vars.push([
			"oldgods",
			this.m.OldGods.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Cultist = null;
		this.m.OldGods = null;
	}

});

