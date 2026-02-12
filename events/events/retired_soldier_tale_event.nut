this.retired_soldier_tale_event <- this.inherit("scripts/events/event", {
	m = {
		Soldier = null
	},
	function create()
	{
		this.m.ID = "event.retired_soldier_tale";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]%retiredsoldier% siedzi przy ognisku i opowiada wojenne historie. Jeśli kłamie, to tylko podkolorowuje, bo blizny na jego ciele mówią niezbyt piękną prawdę. Z każdą opowieścią ludzie stają się bardziej wciągnięci, odważniejsi i gotowi wrócić na szlak, by kuć własne historie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zabijanie ludzi to niezłe historie na dobranoc.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Soldier.getImagePath());
				_event.m.Soldier.improveMood(0.25, "Opowiedział jedną ze swoich wojennych historii");

				if (_event.m.Soldier.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Soldier.getMoodState()],
						text = _event.m.Soldier.getName() + this.Const.MoodStateEvent[_event.m.Soldier.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Soldier.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(1.0, "Poczuł się ośmielony wojennymi historiami " + _event.m.Soldier.getName());

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
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 3 && bro.getBackground().getID() == "background.retired_soldier")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Soldier = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"retiredsoldier",
			this.m.Soldier.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Soldier = null;
	}

});

