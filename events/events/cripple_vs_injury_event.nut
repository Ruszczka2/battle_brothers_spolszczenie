this.cripple_vs_injury_event <- this.inherit("scripts/events/event", {
	m = {
		Cripple = null,
		Injured = null
	},
	function create()
	{
		this.m.ID = "event.cripple_vs_injury";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]Ostatnia bitwa zostawiła %injured% z przerażającą i trwałą raną. Gdy ponuro siedzi przy ognisku, %cripple%, kaleka, siada obok niego.%SPEECH_ON%I tak tu siedzisz, zdołowany czymś, co nie ma znaczenia. Spójrz na mnie. Po prostu spójrz na mnie! Spójrz, gdzie jestem! Straciłem coś, czego nie da się odzyskać, ale czy się nad tym użalałem? Nie. Parłem dalej. Dołączyłem do %companyname%. Bo to, ta rana tutaj, to już przeszłość. To tutaj...%SPEECH_OFF%Kaleka stuka się w bok głowy.%SPEECH_ON%Tutaj jest to, co można odbudować. Tutaj możesz pomyśleć: tak, to się stało, ale wciąż jestem mężczyzną i wciąż w tym jestem. Jeśli świat chce mnie martwego, będzie musiał zabrać wszystkie kawałki, które mam do oddania, bo nie poddam się, dopóki nie zniknie ze mnie ostatni skrawek!%SPEECH_OFF%%injured% kiwa głową, a jego nastrój wydaje się już nieskończenie lepszy.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Co za duch w tym człowieku.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cripple.getImagePath());
				this.Characters.push(_event.m.Injured.getImagePath());
				_event.m.Injured.improveMood(1.0, "Spirits lifted by " + _event.m.Cripple.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Injured.getMoodState()],
					text = _event.m.Injured.getName() + this.Const.MoodStateEvent[_event.m.Injured.getMoodState()]
				});
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

		local cripple_candidates = [];
		local injured_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.cripple")
			{
				cripple_candidates.push(bro);
			}
			else if (bro.getSkills().hasSkillOfType(this.Const.SkillType.PermanentInjury))
			{
				foreach( n in bro.getMoodChanges() )
				{
					if (n.Text == "Suffered a permanent injury")
					{
						injured_candidates.push(bro);
						break;
					}
				}
			}
		}

		if (cripple_candidates.len() == 0 || injured_candidates.len() == 0)
		{
			return;
		}

		this.m.Cripple = cripple_candidates[this.Math.rand(0, cripple_candidates.len() - 1)];
		this.m.Injured = injured_candidates[this.Math.rand(0, injured_candidates.len() - 1)];
		this.m.Score = (cripple_candidates.len() + injured_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cripple",
			this.m.Cripple.getNameOnly()
		]);
		_vars.push([
			"injured",
			this.m.Injured.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Cripple = null;
		this.m.Injured = null;
	}

});

