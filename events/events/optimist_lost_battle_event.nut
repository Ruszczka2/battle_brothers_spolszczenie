this.optimist_lost_battle_event <- this.inherit("scripts/events/event", {
	m = {
		Optimist = null
	},
	function create()
	{
		this.m.ID = "event.optimist_lost_battle";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_88.png[/img]Mimo niedawnej porażki %optimist% wciąż widzi świetlaną przyszłość dla %companyname%.%SPEECH_ON%Nie całe życie można spędzić na nogach, chłopaki. Czasem trzeba je spędzić, podnosząc się. Ale nie spędzimy go na leżeniu na zawsze, to wiem na pewno! Ta kompania jest za dobra na takie obijanie się.%SPEECH_OFF%Nieustanna pozytywność wiecznie optymistycznego najemnika udziela się części ludzi, podnosząc ich na duchu i sprawiając, że są gotowi na to, co przyniesie jutro.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Człowiek, z którym warto zginąć w walce.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Optimist.getImagePath());
				_event.m.Optimist.improveMood(0.5, "Jest optymistą mimo niedawnej porażki");

				if (_event.m.Optimist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Optimist.getMoodState()],
						text = _event.m.Optimist.getName() + this.Const.MoodStateEvent[_event.m.Optimist.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Optimist.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50 && !bro.getSkills().hasSkill("trait.pessimist"))
					{
						bro.improveMood(0.5, "Podniesiony na duchu przez optymizm " + _event.m.Optimist.getName());

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
	}

	function onUpdateScore()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastCombatResult") != 2)
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
			if (bro.getSkills().hasSkill("trait.optimist") && bro.getBackground().getID() != "background.slave" && bro.getLifetimeStats().Battles >= 1)
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 1)
		{
			return;
		}

		this.m.Optimist = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 50;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"optimist",
			this.m.Optimist.getName()
		]);
	}

	function onClear()
	{
		this.m.Optimist = null;
	}

});

