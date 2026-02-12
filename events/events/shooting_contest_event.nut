this.shooting_contest_event <- this.inherit("scripts/events/event", {
	m = {
		Archer1 = null,
		Archer2 = null
	},
	function create()
	{
		this.m.ID = "event.shooting_contest";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Szmer rozmów narasta, aż nie możesz się już skupić. Odkładasz pióro z taką energią, jaką kałamarz jest w stanie znieść bez rozbicia, i wychodzisz z namiotu. %archer1% i %archer2% stoją i kłócą się o to, kto lepiej strzela. Gdy cię widzą, niewiele czasu mija, zanim pytają, czy mogą urządzić konkurs strzelecki, by rozstrzygnąć, kto ma rację.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze, niech będzie.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "Nie stać nas na marnowanie strzał.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Archer1.getImagePath());
				this.Characters.push(_event.m.Archer2.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_10.png[/img]Rozkładasz ręce i mówisz ludziom, by robili, co muszą, a potem wracasz do namiotu. Na zewnątrz słychać świst wypuszczanych strzał, zaraz potem głuche uderzenia w cel. Raz po raz. Gwar mężczyzn narasta, bo najwyraźniej zbiera się tłum obserwatorów. W końcu konkurs jakoś dobiega końca - o czym świadczy kojąca cisza - i wracasz do pracy.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wreszcie spokój i cisza.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Archer1.getImagePath());
				this.Characters.push(_event.m.Archer2.getImagePath());
				_event.m.Archer1.getFlags().increment("ParticipatedInShootingContests", 1);
				_event.m.Archer2.getFlags().increment("ParticipatedInShootingContests", 1);
				this.World.Assets.addAmmo(-30);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_ammo.png",
						text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]-30[/color] amunicji"
					}
				];
				_event.m.Archer1.getBaseProperties().RangedSkill += 1;
				_event.m.Archer1.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_skill.png",
					text = _event.m.Archer1.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] umiejętności dystansowej"
				});
				_event.m.Archer2.getBaseProperties().RangedSkill += 1;
				_event.m.Archer2.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_skill.png",
					text = _event.m.Archer2.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] umiejętności dystansowej"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_10.png[/img]Czując, że ich kłótnia nigdy się nie skończy, pozwalasz im na mały konkurs, zanim wracasz do namiotu. Wkrótce słychać zakładanie strzał, ich wypuszczanie i trafianie w cele. Dźwięki \'thwang\' szybko zmieniają się w \'thwap\', a powietrze powoli wypełnia gwar widowni. Gdy próbujesz się skupić, zauważasz, że mężczyźni strzelają zawzięcie już od dłuższego czasu. Wychodzisz z namiotu i widzisz, jak dwóch łuczników znowu się kłóci, każdy wskazuje palcem na drugiego, po czym chwyta strzałę i z wściekłością posyła ją w dół strzelnicy. Ich cele nie są już nawet celami, tylko małymi krzakami z drzewców strzał, na których co drugie trafienie się łamie.\n\nKręcisz głową i każesz im natychmiast przestać, zanim zużyją ostatnią strzałę kompanii.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie można was zostawić na dwie sekundy!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Archer1.getImagePath());
				this.Characters.push(_event.m.Archer2.getImagePath());
				_event.m.Archer1.getFlags().increment("ParticipatedInShootingContests", 1);
				_event.m.Archer2.getFlags().increment("ParticipatedInShootingContests", 1);
				this.World.Assets.addAmmo(-60);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_ammo.png",
						text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]-60[/color] amunicji"
					}
				];
				_event.m.Archer1.getBaseProperties().Bravery += 1;
				_event.m.Archer1.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Archer1.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] determinacji"
				});
				_event.m.Archer2.getBaseProperties().Bravery += 1;
				_event.m.Archer2.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Archer2.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] determinacji"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "Kręcisz głową, bo zapasy są zbyt małe, by bawić się w takie rzeczy. Mężczyźni wzdychają i odchodzą, dalej kłócąc się głośno w oddali.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Są ważniejsze rzeczy do zrobienia.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Archer1.getImagePath());
				this.Characters.push(_event.m.Archer2.getImagePath());
				_event.m.Archer1.worsenMood(1.0, "Odmówiono mu prośby");

				if (_event.m.Archer1.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Archer1.getMoodState()],
						text = _event.m.Archer1.getName() + this.Const.MoodStateEvent[_event.m.Archer1.getMoodState()]
					});
				}

				_event.m.Archer2.worsenMood(1.0, "Odmówiono mu prośby");

				if (_event.m.Archer2.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Archer2.getMoodState()],
						text = _event.m.Archer2.getName() + this.Const.MoodStateEvent[_event.m.Archer2.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.Assets.getAmmo() <= 80)
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
			if (bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.poacher" || bro.getBackground().getID() == "background.sellsword" || bro.getBackground().getID() == "background.bowyer")
			{
				if (!bro.getFlags().has("ParticipatedInShootingContests") || bro.getFlags().get("ParticipatedInShootingContests") < 3)
				{
					candidates.push(bro);
				}
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		this.m.Archer1 = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Archer2 = null;
		this.m.Score = candidates.len() * 5;

		do
		{
			this.m.Archer2 = candidates[this.Math.rand(0, candidates.len() - 1)];
		}
		while (this.m.Archer2 == null || this.m.Archer2.getID() == this.m.Archer1.getID());
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"archer1",
			this.m.Archer1.getName()
		]);
		_vars.push([
			"archer2",
			this.m.Archer2.getName()
		]);
	}

	function onClear()
	{
		this.m.Archer1 = null;
		this.m.Archer2 = null;
	}

});

