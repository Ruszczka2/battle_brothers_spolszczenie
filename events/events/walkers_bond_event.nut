this.walkers_bond_event <- this.inherit("scripts/events/event", {
	m = {
		Walker1 = null,
		Walker2 = null
	},
	function create()
	{
		this.m.ID = "event.walkers_bond";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_16.png[/img]{Ludzie drogi, %walker1% i %walker2%, dzielą się opowieściami ze swoich wędrówek. Nie bardzo rozumiesz, co takiego bogatego jest w chodzeniu, ale ci dwaj zbliżają się dzięki swoim historiom i to ci wystarcza. | %walker1% i %walker2% widzieli kawał świata. Spędzili lata na drogach i teraz opowiadają sobie historie z tamtych lat.\n\nIch wzajemna sympatia rośnie, a twoja sympatia do nie słuchania nudnych opowieści o podróżach też wzrasta. | Większość ludzi uważa chodzenie za dość proste zajęcie, ale ci, którzy nie robią prawie nic poza chodzeniem, znajdują w tym więcej zainteresowania. Nic dziwnego, że %walker1% i %walker2% zbliżyli się dzięki opowieściom o... chodzeniu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Maszerujemy dalej.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Walker1.getImagePath());
				this.Characters.push(_event.m.Walker2.getImagePath());
				_event.m.Walker1.improveMood(1.0, "Zbliżył się do " + _event.m.Walker2.getName());
				_event.m.Walker2.improveMood(1.0, "Zbliżył się do " + _event.m.Walker1.getName());

				if (_event.m.Walker1.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Walker1.getMoodState()],
						text = _event.m.Walker1.getName() + this.Const.MoodStateEvent[_event.m.Walker1.getMoodState()]
					});
				}

				if (_event.m.Walker2.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Walker2.getMoodState()],
						text = _event.m.Walker2.getName() + this.Const.MoodStateEvent[_event.m.Walker2.getMoodState()]
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

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.vagabond" || bro.getBackground().getID() == "background.messenger" || bro.getBackground().getID() == "background.refugee" || bro.getBackground().getID() == "background.nomad")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		this.m.Walker1 = candidates[this.Math.rand(0, candidates.len() - 1)];

		do
		{
			this.m.Walker2 = candidates[this.Math.rand(0, candidates.len() - 1)];
		}
		while (this.m.Walker2 == this.m.Walker1);

		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"walker1",
			this.m.Walker1.getName()
		]);
		_vars.push([
			"walker2",
			this.m.Walker2.getName()
		]);
	}

	function onClear()
	{
		this.m.Walker1 = null;
		this.m.Walker2 = null;
	}

});

