this.dismiss_veteran_event <- this.inherit("scripts/events/event", {
	m = {
		Fired = null
	},
	function setFired( _f )
	{
		this.m.Fired = _f;
	}

	function create()
	{
		this.m.ID = "event.dismiss_veteran";
		this.m.Title = "W trakcie podróży...";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]To była trudna decyzja, ale %dismissed% musiał się z nami pożegnać. Wygląda jednak na to, że powinieneś był skonsultować się pierw z resztą ludzi, gdyż nikt z nich nie jest zadowolony z twego wyboru. Ów najemnik był w kompanii od tak dawna, że zdążył się z niektórymi zaprzyjaźnić, a nawet ci, którzy nie byli z nim aż tak blisko, podupadli nieco na duchu, gdyż czuli się bezpieczniej na polu bitwy mając go u swego boku.",
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

					bro.worsenMood(this.Const.MoodChange.VeteranDismissed, _event.m.Fired + ", weteran kompanii, został przez ciebie zwolniony");

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

		});
	}

	function onUpdateScore()
	{
		if (this.World.Statistics.hasNews("dismiss_veteran"))
		{
			this.m.Score = 2000;
		}

		return;
	}

	function onPrepare()
	{
		local news = this.World.Statistics.popNews("dismiss_veteran");
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

