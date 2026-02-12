this.gambler_vs_other_event <- this.inherit("scripts/events/event", {
	m = {
		DumbGuy = null,
		Gambler = null
	},
	function create()
	{
		this.m.ID = "event.gambler_vs_other";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_06.png[/img]{%gambler% i %nongambler% podchodzą do ciebie poobijani i pokryci siniakami. Wygląda na to, że stoczyli bójkę. Skoro żaden nie zginął, nie bardzo obchodzi cię, o co poszło, ale i tak ci mówią.\n\nPodobno hazardzista podstępnie zgarnął trochę pieniędzy w trakcie karcianych sztuczek. Pytasz, czy były w to zamieszane pieniądze kompanii. Mówią, że nie. Pytasz więc, czego do cholery od ciebie chcą. | Gra w karty kończy się przewróceniem stołu, gdy %nongambler% zrywa się ze stołka i rzuca tyradę na %gambler%. Profesjonalny hazardzista rozgląda się z zakłopotanym niedowierzaniem. Pyta, jak taki człowiek mógł wygrać tyle pieniędzy w grze w karty, ale gdy unosi dłonie, by udawać zdziwienie, z jego rękawów wypada kilka \"dodatkowych\" kart. Następująca bójka jest zabawna, ale przerywasz ją, zanim ktoś poważnie ucierpi.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zachowajcie to na bitwę.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gambler.getImagePath());
				this.Characters.push(_event.m.DumbGuy.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					_event.m.Gambler.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Gambler.getName() + " doznaje lekkich ran"
					});
				}
				else
				{
					local injury = _event.m.Gambler.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Gambler.getName() + " doznaje " + injury.getNameOnly()
					});
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					_event.m.DumbGuy.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.DumbGuy.getName() + " doznaje lekkich ran"
					});
				}
				else
				{
					local injury = _event.m.DumbGuy.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.DumbGuy.getName() + " doznaje " + injury.getNameOnly()
					});
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

		local gambler_candidates = [];
		local dumb_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.gambler")
			{
				gambler_candidates.push(bro);
			}
			else if (!bro.getSkills().hasSkill("trait.bright"))
			{
				dumb_candidates.push(bro);
			}
		}

		if (gambler_candidates.len() == 0 || dumb_candidates.len() == 0)
		{
			return;
		}

		this.m.DumbGuy = dumb_candidates[this.Math.rand(0, dumb_candidates.len() - 1)];
		this.m.Gambler = gambler_candidates[this.Math.rand(0, gambler_candidates.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"nongambler",
			this.m.DumbGuy.getName()
		]);
		_vars.push([
			"gambler",
			this.m.Gambler.getName()
		]);
	}

	function onClear()
	{
		this.m.DumbGuy = null;
		this.m.Gambler = null;
	}

});

