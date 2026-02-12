this.strength_contest_event <- this.inherit("scripts/events/event", {
	m = {
		Strong1 = null,
		Strong2 = null
	},
	function create()
	{
		this.m.ID = "event.strength_contest";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%strong1% i %strong2% - najsilniejsi ludzie w kompanii, przynajmniej według jakiejś miary - najwyraźniej urządzili sobie zawody, by sprawdzić, kto jest lepszy. Patrzysz, jak noszą ogromne głazy z jednej strony prowizorycznego placu na drugą. Potem na zmianę sprawdzają, jak daleko potrafią rzucić te same kamienie. A potem wtaczają je na pobliskie wzgórze. A następnie mierzą się, kto najszybciej całkiem zakopie kamień.\n\nW sumie sporo ciężkich głazów jest przetaczanych, a pod koniec tej wesołej imprezy obaj są zupełnie wyczerpani. Nawet bez zwycięzcy, wiekowa tradycja turlania kamieni bez większego sensu poprawiła morale ludzi.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jesteśmy prostymi stworzeniami.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Strong1.getImagePath());
				this.Characters.push(_event.m.Strong2.getImagePath());
				_event.m.Strong1.getFlags().increment("ParticipatedInStrengthContests", 1);
				_event.m.Strong2.getFlags().increment("ParticipatedInStrengthContests", 1);
				_event.m.Strong1.getBaseProperties().Stamina += 1;
				_event.m.Strong1.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Strong1.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] maks. zmęczenia"
				});
				_event.m.Strong2.getBaseProperties().Stamina += 1;
				_event.m.Strong2.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Strong2.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] maks. zmęczenia"
				});
				_event.m.Strong1.improveMood(1.0, "Zbliżył się do " + _event.m.Strong2.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Strong1.getMoodState()],
					text = _event.m.Strong1.getName() + this.Const.MoodStateEvent[_event.m.Strong1.getMoodState()]
				});
				_event.m.Strong2.improveMood(1.0, "Zbliżył się do " + _event.m.Strong1.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Strong2.getMoodState()],
					text = _event.m.Strong2.getName() + this.Const.MoodStateEvent[_event.m.Strong2.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
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
			if (bro.getSkills().hasSkill("trait.strong") && !bro.getSkills().hasSkill("trait.bright"))
			{
				if (!bro.getFlags().has("ParticipatedInStrengthContests") || bro.getFlags().get("ParticipatedInStrengthContests") < 2)
				{
					candidates.push(bro);
				}
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		this.m.Strong1 = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Strong2 = null;
		this.m.Score = candidates.len() * 5;

		do
		{
			this.m.Strong2 = candidates[this.Math.rand(0, candidates.len() - 1)];
		}
		while (this.m.Strong2 == null || this.m.Strong2.getID() == this.m.Strong1.getID());
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"strong1",
			this.m.Strong1.getName()
		]);
		_vars.push([
			"strong2",
			this.m.Strong2.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Strong1 = null;
		this.m.Strong2 = null;
	}

});

