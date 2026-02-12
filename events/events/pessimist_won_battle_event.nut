this.pessimist_won_battle_event <- this.inherit("scripts/events/event", {
	m = {
		Pessimist = null
	},
	function create()
	{
		this.m.ID = "event.pessimist_won_battle";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]Jak zwykle ponurak, %pessimist% snuje się, taplając w zwycięstwie jak każdy wkurzony pesymista. Machina dłonią z pogardą.%SPEECH_ON%Zakosztowaliśmy zwycięstwa i co z tego? Nasze zwycięstwo było ich porażką, więc całkiem możliwe, że pewnego dnia czyjeś zwycięstwo przyjdzie naszym kosztem, nie widzisz? Nie stawiajmy wozu przed koniem, aby cienie jutra nie zakradły się do nas, gdy wygrzewamy się w tym rzekomo chwalebnym blasku.%SPEECH_OFF%Kilku najemników każe mu przestać być takim dupkiem, ale jego twardy realizm studzi zapał innych.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Najgorsze w pesymistach jest to, że zwykle mają rację.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Pessimist.getImagePath());
				_event.m.Pessimist.worsenMood(0.5, "Jest pesymistą mimo niedawnego zwycięstwa");

				if (_event.m.Pessimist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Pessimist.getMoodState()],
						text = _event.m.Pessimist.getName() + this.Const.MoodStateEvent[_event.m.Pessimist.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Pessimist.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50 && !bro.getSkills().hasSkill("trait.optimist"))
					{
						bro.worsenMood(0.4, "Stonowany przez pesymizm " + _event.m.Pessimist.getName());

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
	}

	function onUpdateScore()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastCombatResult") != 1)
		{
			return;
		}

		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() > 20.0)
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
			if (bro.getSkills().hasSkill("trait.pessimist") && !bro.getSkills().hasSkill("trait.dumb") && bro.getBackground().getID() != "background.slave" && bro.getLifetimeStats().Battles >= 1)
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 1)
		{
			return;
		}

		this.m.Pessimist = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 50;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"pessimist",
			this.m.Pessimist.getName()
		]);
	}

	function onClear()
	{
		this.m.Pessimist = null;
	}

});

