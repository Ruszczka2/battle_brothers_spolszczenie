this.flagellation_event <- this.inherit("scripts/events/event", {
	m = {
		Flagellant = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.flagellation";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%otherguy% podchodzi z bolesnym wyrazem twarzy. Trzyma hełm w dłoni, ocierając czoło.%SPEECH_ON%Panie, eee, powinieneś to zobaczyć.%SPEECH_OFF%Pytasz, co takiego masz zobaczyć.%SPEECH_ON%Nie mam na to słów. Najlepiej zobaczysz na własne oczy.%SPEECH_OFF%Spoglądasz na swoją pracę - planowanie marszu na nadchodzące dni - ale sądząc po wyrazie twarzy brata, to może poczekać.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "W takim razie pokaż.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OtherGuy.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_38.png[/img]Wstajesz i pozwalasz mu zaprowadzić się do tego, co wywołuje problem. Natrafiasz na tłum braci otaczających coś lub kogoś. Przepychając się przez nich, wchodzisz na polanę, a kompania cichnie, gdy znajdujesz %flagellant_short% biczownika nieprzytomnego na ziemi.\n\nJego plecy są zdarte do żywego i wydaje ci się, że widzisz nawet jedno czy dwa żebra. Z jego brutalnego bicza odłamały się ciernie, wbijając się w ciało, a skóra zwisa pasmami tam, gdzie w ogóle jeszcze się trzyma. Dobrze, że zemdlał. Nie dlatego, że cierpiałby straszliwy ból, ale dlatego, że inaczej pewnie by się nie zatrzymał. Rozkazujesz ludziom oczyścić go, opatrzyć rany i ukryć jego narzędzia cierpienia.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Przynajmniej się nie zabił.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OtherGuy.getImagePath());
				this.Characters.push(_event.m.Flagellant.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury = _event.m.Flagellant.addInjury(this.Const.Injury.Flagellation);
					this.List = [
						{
							id = 10,
							icon = injury.getIcon(),
							text = _event.m.Flagellant.getName() + " doznaje " + injury.getNameOnly()
						}
					];
				}
				else
				{
					_event.m.Flagellant.addLightInjury();
					this.List = [
						{
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = _event.m.Flagellant.getName() + " doznaje lekkich ran"
						}
					];
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

		local candidates = [];

		foreach( bro in brothers )
		{
			if ((bro.getBackground().getID() == "background.flagellant" || bro.getBackground().getID() == "background.monk_turned_flagellant") && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() > 0)
		{
			this.m.Flagellant = candidates[this.Math.rand(0, candidates.len() - 1)];
			this.m.Score = candidates.len() * 10;

			foreach( bro in brothers )
			{
				if (bro.getID() != this.m.Flagellant.getID())
				{
					this.m.OtherGuy = bro;
					break;
				}
			}
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"flagellant",
			this.m.Flagellant.getName()
		]);
		_vars.push([
			"flagellant_short",
			this.m.Flagellant.getNameOnly()
		]);
		_vars.push([
			"otherguy",
			this.m.OtherGuy.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Flagellant = null;
		this.m.OtherGuy = null;
	}

});

