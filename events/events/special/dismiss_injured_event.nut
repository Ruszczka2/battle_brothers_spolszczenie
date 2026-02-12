this.dismiss_injured_event <- this.inherit("scripts/events/event", {
	m = {
		Fired = null
	},
	function setFired( _f )
	{
		this.m.Fired = _f;
	}

	function create()
	{
		this.m.ID = "event.dismiss_injured";
		this.m.Title = "W trakcie podróży...";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]%dismissed% miał rany, które okazały się zbyt uciążliwe: niby przeżył, ale jednak w twoich oczach równie dobrze mógłby zginąć, gdyż nie nadaje się już do walki. Odprawiłeś go. Możliwe, że był to altruistyczny ruch, który ocalił życie najemnika, jednak reszta kompanii nie patrzy na to w ten sposób. Widzą tylko, że jedna kontuzja wystarczyła, abyś zwolnił człowieka. Teraz martwią się, czy jeśli odniosą rany, to czy nie pozbędziesz się ich w ten sam sposób, jak samolubny człek pozbywający się kulawego wierzchowca.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jakoś to przeżyją.",
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
					if (bro.getSkills().hasSkill("trait.player"))
					{
						continue;
					}

					if (bro.getSkills().hasSkillOfType(this.Const.SkillType.PermanentInjury))
					{
						bro.worsenMood(1.5, "Obawia się zwolnienia z powodu swych ran");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (this.Math.rand(1, 100) <= 33)
					{
						bro.worsenMood(this.Const.MoodChange.BrotherDismissed, "Stracił przekonanie co do solidarności w kompanii");

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
		if (this.World.Statistics.hasNews("dismiss_injured"))
		{
			this.m.Score = 2000;
		}

		return;
	}

	function onPrepare()
	{
		local news = this.World.Statistics.popNews("dismiss_injured");
		this.m.Fired = news.get("Name");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dismissed",
			this.m.Fired
		]);
	}

	function onClear()
	{
		this.m.Fired = null;
	}

});

