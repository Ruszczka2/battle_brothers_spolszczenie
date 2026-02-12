this.dismiss_legend_event <- this.inherit("scripts/events/event", {
	m = {
		Fired = null
	},
	function setFired( _f )
	{
		this.m.Fired = _f;
	}

	function create()
	{
		this.m.ID = "event.dismiss_legend";
		this.m.Title = "W trakcie podróży...";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]Człowiek, którego odprawiłeś, nie był jakąś tam częścią kompanii: był legendą. Imię %dismissed% znane było nie tylko przez ciebie i garstkę najemników, ale i przez wielu innych, więc wylanie go było niczym zwolnienie bohaterskiego generała tuż przed bitwą, która ma zakończyć wojnę. Ta decyzja, co oczywiste, niezbyt spodobała się reszcie najemników.",
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

					bro.worsenMood(this.Const.MoodChange.VeteranDismissed, "" + _event.m.Fired + ", legenda kompanii, został przez ciebie zwolniony");

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
		if (this.World.Statistics.hasNews("dismiss_legend"))
		{
			this.m.Score = 2000;
		}

		return;
	}

	function onPrepare()
	{
		local news = this.World.Statistics.popNews("dismiss_legend");
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

