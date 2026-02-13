this.apprentice_vs_oathtaker_event <- this.inherit("scripts/events/event", {
	m = {
		Apprentice = null,
		Oathtaker = null
	},
	function create()
	{
		this.m.ID = "event.apprentice_vs_oathtaker";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%apprentice% uczen siedzi obok ogniska, gdy %oathtaker% Swiętobiorca zaczyna go mierzyc wzrokiem. Uczen odwzajemnia spojrzenie, wyraznie zmieszany.%SPEECH_ON%O co chodzi?%SPEECH_OFF%Swiatobiorca szczerzy sie w usmiechu.%SPEECH_ON%Mlody Anselm, Pierwszy Swietobiorca, byl uczniem takim jak ty. Wedrowal po ziemiach, szukajac wiedzy i odnajdujac Ostateczna Sciezke. Nawet wygladasz jak on.%SPEECH_OFF%Uczen usmiecha sie serdecznie. Wyglada na to, ze ta wiez z niezyjacym Swietobiorca go osmielila. Ale wedlug ciebie czaszka Mlodego Anselma wcale nie wyglada jak %apprentice%. Nos jest za duzy, luk brwiowy zbyt pofalowany, a zeby Pierwszego Swietobiorcy sa nienaganne, podczas gdy %apprentice% wyglada, jakby czyscil je młotem. Ale moze %apprentice% bedzie wygladal bardziej odpowiednio, gdy sam stanie sie lśniaca czaszka otoczona opieka nieugietego kultu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie zebym chcial, zeby do tego doszlo.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Apprentice.getImagePath());
				this.Characters.push(_event.m.Oathtaker.getImagePath());
				local resolveBoost = this.Math.rand(1, 3);
				_event.m.Apprentice.getBaseProperties().Bravery += resolveBoost;
				_event.m.Apprentice.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Apprentice.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolveBoost + "[/color] Determinacji"
				});
				_event.m.Apprentice.getFlags().add("learnedFromOathtaker");
				_event.m.Apprentice.improveMood(1.0, "Uczyl sie od " + _event.m.Oathtaker.getName());
				_event.m.Oathtaker.improveMood(0.5, "Nauczyl " + _event.m.Apprentice.getName() + " czegos");

				if (_event.m.Apprentice.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Apprentice.getMoodState()],
						text = _event.m.Apprentice.getName() + this.Const.MoodStateEvent[_event.m.Apprentice.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local apprentice_candidates = [];
		local teacher_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.apprentice" && !bro.getFlags().has("learnedFromOathtaker"))
			{
				apprentice_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.paladin")
			{
				teacher_candidates.push(bro);
			}
		}

		if (apprentice_candidates.len() == 0 || teacher_candidates.len() == 0)
		{
			return;
		}

		this.m.Apprentice = apprentice_candidates[this.Math.rand(0, apprentice_candidates.len() - 1)];
		this.m.Oathtaker = teacher_candidates[this.Math.rand(0, teacher_candidates.len() - 1)];
		this.m.Score = (apprentice_candidates.len() + teacher_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"apprentice",
			this.m.Apprentice.getNameOnly()
		]);
		_vars.push([
			"oathtaker",
			this.m.Oathtaker.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Apprentice = null;
		this.m.Oathtaker = null;
	}

});

