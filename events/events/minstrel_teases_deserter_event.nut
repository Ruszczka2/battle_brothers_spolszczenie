this.minstrel_teases_deserter_event <- this.inherit("scripts/events/event", {
	m = {
		Minstrel = null,
		Deserter = null
	},
	function create()
	{
		this.m.ID = "event.minstrel_teases_deserter";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img] Gdy ognisko trzaska, %minstrel% minstrela wstaje i staje wysoko na pniu. Uderza się w pierś, po czym wskazuje %deserter%.%SPEECH_ON%Hej, człeku o uciekających stopach, stopach co uciekają, nim bitwa cię spotka! Dezerter! O, dezerter! Deser dla dezertera! Odwaga mu skwaśniała, honor się potknął, męskość on zadławił! Dezerter!%SPEECH_OFF%Jednym szybkim ruchem minstrela klaszcze w dłonie i opada z powrotem na miejsce. Siedzi tam tylko chwilę, nim dłonie %deserter% lądują mu na szyi. Kompania wrze, rozdarta między rozdzieleniem ich a wybuchem histerycznego śmiechu.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Epopeja z najgorszych powodów!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Minstrel.getImagePath());
				this.Characters.push(_event.m.Deserter.getImagePath());
				_event.m.Deserter.worsenMood(2.0, "Czuł się upokorzony na oczach kompanii");

				if (_event.m.Deserter.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Deserter.getMoodState()],
						text = _event.m.Deserter.getName() + this.Const.MoodStateEvent[_event.m.Deserter.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_minstrel = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.minstrel")
			{
				candidates_minstrel.push(bro);
			}
		}

		if (candidates_minstrel.len() == 0)
		{
			return;
		}

		local candidates_deserter = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.deserter")
			{
				candidates_deserter.push(bro);
			}
		}

		if (candidates_deserter.len() == 0)
		{
			return;
		}

		this.m.Minstrel = candidates_minstrel[this.Math.rand(0, candidates_minstrel.len() - 1)];
		this.m.Deserter = candidates_deserter[this.Math.rand(0, candidates_deserter.len() - 1)];
		this.m.Score = (candidates_minstrel.len() + candidates_deserter.len()) * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"minstrel",
			this.m.Minstrel.getNameOnly()
		]);
		_vars.push([
			"deserter",
			this.m.Deserter.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Minstrel = null;
		this.m.Deserter = null;
	}

});

