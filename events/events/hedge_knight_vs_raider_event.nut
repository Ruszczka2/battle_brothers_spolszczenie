this.hedge_knight_vs_raider_event <- this.inherit("scripts/events/event", {
	m = {
		HedgeKnight = null,
		Raider = null
	},
	function create()
	{
		this.m.ID = "event.hedge_knight_vs_raider";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]%raider% siedzi przy ognisku, wpatrzony głęboko w płomienie. Przed chwilą słychać było, jak kilku ludzi na niego krzyczało. Przeszłość jako rabuś nie przynosi mu wielu przyjaciół. Rycerz z żywopłotu, %hedgeknight%, podchodzi i staje obok niego. Gdy wymieniają spojrzenia, nagle obawiasz się, że wybuchnie bójka, której nie zdołasz powstrzymać. Zamiast tego rycerz siada. Mówi spokojnie, choć jego głęboki głos wciąż brzmi złowieszczo.%SPEECH_ON%Napadałeś na wybrzeża, tak? Zabijałeś kobiety i dzieci? Okradałeś duchownych?%SPEECH_OFF%Rabuś kiwa głową.%SPEECH_ON%Tak, i gorzej.%SPEECH_OFF%%hedgeknight% podnosi z ognia kawałek tlącego drewna. Miażdży go w dłoni, płomienie syczą, zamieniając się w popiół i dym. Pozwala mu się rozsypać z zrogowaciałej dłoni.%SPEECH_ON%Nie powinieneś przejmować się tym, co mówią inni, rabusiu. To paskudny, głodny świat i dobrze znasz jego zęby. Niech słabi krzyczą i giną. Możemy tylko opancerzyć się samym istnieniem, opleceni zazdrością umarłych, którzy chętnie zmiażdżyliby czaszkę niemowlęcia za sam łyk oddechu, który niosą nasze płuca.%SPEECH_OFF%Rabuś chwyta własny kawałek drewna i rozciera go w dłoniach. Ściskają dłonie i nie mówią już nic więcej.",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ten świat sprzyja silnym.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight.getImagePath());
				this.Characters.push(_event.m.Raider.getImagePath());
				_event.m.HedgeKnight.improveMood(1.0, "Bonded with " + _event.m.Raider.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.HedgeKnight.getMoodState()],
					text = _event.m.HedgeKnight.getName() + this.Const.MoodStateEvent[_event.m.HedgeKnight.getMoodState()]
				});
				_event.m.Raider.improveMood(1.0, "Bonded with " + _event.m.HedgeKnight.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Raider.getMoodState()],
					text = _event.m.Raider.getName() + this.Const.MoodStateEvent[_event.m.Raider.getMoodState()]
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

		local hedge_knight_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.hedge_knight")
			{
				hedge_knight_candidates.push(bro);
			}
		}

		if (hedge_knight_candidates.len() == 0)
		{
			return;
		}

		local raider_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.raider")
			{
				raider_candidates.push(bro);
			}
		}

		if (raider_candidates.len() == 0)
		{
			return;
		}

		this.m.HedgeKnight = hedge_knight_candidates[this.Math.rand(0, hedge_knight_candidates.len() - 1)];
		this.m.Raider = raider_candidates[this.Math.rand(0, raider_candidates.len() - 1)];
		this.m.Score = (hedge_knight_candidates.len() + raider_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hedgeknight",
			this.m.HedgeKnight.getNameOnly()
		]);
		_vars.push([
			"raider",
			this.m.Raider.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.HedgeKnight = null;
		this.m.Raider = null;
	}

});

