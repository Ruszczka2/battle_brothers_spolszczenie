this.cocky_vs_iron_lungs_event <- this.inherit("scripts/events/event", {
	m = {
		Cocky = null,
		IronLungs = null
	},
	function create()
	{
		this.m.ID = "event.cocky_vs_iron_lungs";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 150.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Gdy zwijasz mapy i odkładasz je do juków, hałas wyciąga cię z namiotu. Ludzie ciągną %cocky% po ziemi. Jego ubranie jest przemoczone, a twarz bliska śmierci. Mężczyźni dają mu kilka mocnych policzków. W końcu się budzi, oczy ma dzikie, a usta bulgoczą wodą niczym zepsuta fontanna. Rozgląda się i pyta o to, co i ty chciałbyś wiedzieć.%SPEECH_ON%Co się stało?%SPEECH_OFF%%ironlungs% podchodzi, równie mokry, ale o znacznie bardziej rumianej twarzy.%SPEECH_ON%Ty, pyszałek, chciałeś sprawdzić, kto z nas najdłużej wstrzyma oddech. Przegrałeś, bo nie bez powodu nazywają mnie żelaznymi płucami.%SPEECH_OFF%Ludzie śmieją się, gdy %ironlungs% z dumą bije się w pierś. %cocky%, wciąż chwiejny, podnosi się. Zaledwie chwilę po tym, jak był nieprzytomny, znów wraca do swojej dumy.%SPEECH_ON%Tak, tak, dziś mnie pokonałeś, ale ja będę najlepszy, zobaczysz!%SPEECH_OFF%Inny najemnik żartobliwie zauważa, że pyszałek ma z nosa długi glut. Pewnie wyciera go, mimo ryku śmiechu kompanii.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ach, zawsze bezpieczny pomiar męskości.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cocky.getImagePath());
				this.Characters.push(_event.m.IronLungs.getImagePath());
				_event.m.Cocky.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Cocky.getName() + " doznaje lekkich ran"
				});
				_event.m.Cocky.worsenMood(1.0, "Został upokorzony przed kompanią");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Cocky.getMoodState()],
					text = _event.m.Cocky.getName() + this.Const.MoodStateEvent[_event.m.Cocky.getMoodState()]
				});
				_event.m.IronLungs.improveMood(1.0, "Pokonał " + _event.m.Cocky.getName() + " w próbie siły");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.IronLungs.getMoodState()],
					text = _event.m.IronLungs.getName() + this.Const.MoodStateEvent[_event.m.IronLungs.getMoodState()]
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() != _event.m.Cocky.getID() && bro.getID() != _event.m.IronLungs.getID() && this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(0.5, "Bawił się widokiem " + _event.m.Cocky.getNameOnly());

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

		if (brothers.len() < 2)
		{
			return;
		}

		local cocky_candidates = [];
		local ironlungs_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.cocky"))
			{
				cocky_candidates.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.iron_lungs"))
			{
				ironlungs_candidates.push(bro);
			}
		}

		if (cocky_candidates.len() == 0 || ironlungs_candidates.len() == 0)
		{
			return;
		}

		this.m.Cocky = cocky_candidates[this.Math.rand(0, cocky_candidates.len() - 1)];
		this.m.IronLungs = ironlungs_candidates[this.Math.rand(0, ironlungs_candidates.len() - 1)];
		this.m.Score = (cocky_candidates.len() + ironlungs_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cocky",
			this.m.Cocky.getNameOnly()
		]);
		_vars.push([
			"ironlungs",
			this.m.IronLungs.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Cocky = null;
		this.m.IronLungs = null;
	}

});

