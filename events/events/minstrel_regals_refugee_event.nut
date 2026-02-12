this.minstrel_regals_refugee_event <- this.inherit("scripts/events/event", {
	m = {
		Minstrel = null,
		Refugee = null
	},
	function create()
	{
		this.m.ID = "event.minstrel_regals_refugee";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img] Kompania siedzi przy ognisku, gdy %minstrel% minstrela zauważa uchodźcę, %refugee%, siedzącego samotnie i posępnie. Po chwili minstrela jest już na nogach, stoi wysoko na pniu i szeroko rozkłada ramiona.%SPEECH_ON%Oto miasto %refugee% było małe, miejsce urocze, a jedzenie, cóż, tak sobie. Lecz hoj! Lud jego był wielki! Bo oto pośród naszej kompanii siedzi jeden z nich, świat depcze mu po piętach, śmierć u jego stóp, a jednak tu jest, a my mamy mu do zaoferowania tylko wdzięczność - i korony! - to cena jego towarzystwa, a taką jesteśmy gotowi zapłacić.%SPEECH_OFF%Minstrela siada z powrotem i kłania się uchodźcy. Cała %companyname% wstaje i wiwatuje, wywołując rzadki uśmiech na twarzy %refugee%.",
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
				this.Characters.push(_event.m.Minstrel.getImagePath());
				this.Characters.push(_event.m.Refugee.getImagePath());
				_event.m.Refugee.improveMood(1.0, "Został uraczony przez " + _event.m.Minstrel.getName());

				if (_event.m.Refugee.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Refugee.getMoodState()],
						text = _event.m.Refugee.getName() + this.Const.MoodStateEvent[_event.m.Refugee.getMoodState()]
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

		local candidates_refugee = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.refugee")
			{
				candidates_refugee.push(bro);
			}
		}

		if (candidates_refugee.len() == 0)
		{
			return;
		}

		this.m.Minstrel = candidates_minstrel[this.Math.rand(0, candidates_minstrel.len() - 1)];
		this.m.Refugee = candidates_refugee[this.Math.rand(0, candidates_refugee.len() - 1)];
		this.m.Score = (candidates_minstrel.len() + candidates_refugee.len()) * 5;
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
			"refugee",
			this.m.Refugee.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Minstrel = null;
		this.m.Refugee = null;
	}

});

