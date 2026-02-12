this.glutton_gets_fat_event <- this.inherit("scripts/events/event", {
	m = {
		Glutton = null
	},
	function create()
	{
		this.m.ID = "event.glutton_gets_fat";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_14.png[/img] Zastajesz %glutton% zajadającego się trzecią porcją jedzenia. To zdecydowanie za dużo, więc żądasz, by była to jego ostatnia. Inny brat dołącza, kpiąc z jego nawyków. Łakomiec, rozwścieczony, wali jedzeniem o ziemię i wstaje. Jego brzuch jednak kołysze się w innym rytmie niż reszta ciała i dość utuczony mężczyzna pada w kłąb machających kończyn. Gdy reszta kompanii się śmieje, nie możesz nie zastanowić się, czy ten najemnik rzeczywiście nie zrobił się zbyt gruby.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Odłóż wieprzowinę. Natychmiast.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Glutton.getImagePath());
				local trait = this.new("scripts/skills/traits/fat_trait");
				_event.m.Glutton.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Glutton.getName() + " tyje"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getFood() < 100)
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
			if (bro.getLevel() >= 3 && bro.getSkills().hasSkill("trait.gluttonous") && !bro.getSkills().hasSkill("trait.fat"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Glutton = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"glutton",
			this.m.Glutton.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Glutton = null;
	}

});

