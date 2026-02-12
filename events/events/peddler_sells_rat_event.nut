this.peddler_sells_rat_event <- this.inherit("scripts/events/event", {
	m = {
		Peddler = null,
		Ratcatcher = null
	},
	function create()
	{
		this.m.ID = "event.peddler_sells_rat";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 80.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%SPEECH_ON%Po raz ostatni: nie, nie kupię szczura.%SPEECH_OFF%Widzisz, jak %ratcatcher% łowca szczurów skręca za róg, a za nim podąża podejrzany przekupień %peddler%. Sprzedawca rzuca kolejną gadkę.%SPEECH_ON%No jasne, że nie kupisz! Jesteś łowcą szczurów, czemu miałbyś kupować? Ale co jeśli...%SPEECH_OFF%Łowca szczurów zatrzymuje się i odwraca na pięcie, wbijając palec w pierś przekupnia.%SPEECH_ON%Szczury domowe nie rosną na drzewach, %peddler%! Rodzą się z innego miotu! Jeśli będę potrzebował szczura u boku, znajdę go sam! A jeśli masz szczura do zabicia, to co innego.%SPEECH_OFF%Oczy %peddler% opadają ku ziemi, gdy chwilę się zastanawia. Nagle jego wzrok i nastrój unoszą się wraz z wyciągniętym palcem.%SPEECH_ON%A więc złota rybka? Kupiłbyś złotą rybkę?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wszystko w porządku.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Peddler.getImagePath());
				this.Characters.push(_event.m.Ratcatcher.getImagePath());
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

		local candidates_peddler = [];
		local candidates_ratcatcher = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.peddler")
			{
				candidates_peddler.push(bro);
			}
			else if (bro.getBackground().getID() == "background.ratcatcher")
			{
				candidates_ratcatcher.push(bro);
			}
		}

		if (candidates_peddler.len() == 0 || candidates_ratcatcher.len() == 0)
		{
			return;
		}

		this.m.Peddler = candidates_peddler[this.Math.rand(0, candidates_peddler.len() - 1)];
		this.m.Ratcatcher = candidates_ratcatcher[this.Math.rand(0, candidates_ratcatcher.len() - 1)];
		this.m.Score = candidates_peddler.len() * candidates_ratcatcher.len() * 3 * 50000;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"peddler",
			this.m.Peddler.getName()
		]);
		_vars.push([
			"ratcatcher",
			this.m.Ratcatcher.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Peddler = null;
		this.m.Ratcatcher = null;
	}

});

