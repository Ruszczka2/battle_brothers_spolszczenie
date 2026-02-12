this.cripple_pep_talk_event <- this.inherit("scripts/events/event", {
	m = {
		Cripple = null,
		Veteran = null
	},
	function create()
	{
		this.m.ID = "event.cripple_pep_talk";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_06.png[/img]%cripple%, kaleka, pyta, jak %veteran% to robi. Weteran unosi brew.%SPEECH_ON%Co robi?%SPEECH_OFF%Kaleka kręci głową, jakby symbolicznie krążył wokół tematu.%SPEECH_ON%No wiesz, to. Walczę. Za każdym razem, gdy wychodzę na pole, myślę, że się do tego nie nadaję, jakbym ściągał was w dół.%SPEECH_OFF%%veteran% śmieje się.%SPEECH_ON%Tak, rozumiem. Kaleka nie nadaje się na najemnika. Ale czy to naprawdę wszystko, kim jesteś? Tylko kaleką? A może jesteś mężczyzną? Możesz pozwolić, by twoje chwiejności i niezdarność cię definiowały, albo możesz wytyczyć własną drogę, choćby była kręta i ułomna.%SPEECH_OFF%Kiwnąwszy głową, twarz %cripple% zaczyna jaśnieć.%SPEECH_ON%Masz rację. Nie jestem tym, kim mógłbym być, i mam ciało jak umierająca zakonnica, ale nikt nie włoży w to więcej wysiłku niż ja!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze powiedziane.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cripple.getImagePath());
				this.Characters.push(_event.m.Veteran.getImagePath());
				local resolve = this.Math.rand(1, 3);
				local fatigue = this.Math.rand(1, 3);
				local initiative = this.Math.rand(1, 3);
				_event.m.Cripple.getBaseProperties().Bravery += resolve;
				_event.m.Cripple.getBaseProperties().Stamina += fatigue;
				_event.m.Cripple.getBaseProperties().Initiative += initiative;
				_event.m.Cripple.getSkills().update();
				this.List = [
					{
						id = 16,
						icon = "ui/icons/bravery.png",
						text = _event.m.Cripple.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] Determinacji"
					},
					{
						id = 17,
						icon = "ui/icons/fatigue.png",
						text = _event.m.Cripple.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + fatigue + "[/color] Maks. Zmęczenia"
					},
					{
						id = 17,
						icon = "ui/icons/initiative.png",
						text = _event.m.Cripple.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative + "[/color] Inicjatywy"
					}
				];
				_event.m.Cripple.improveMood(2.0, "Was motivated by " + _event.m.Veteran.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Cripple.getMoodState()],
					text = _event.m.Cripple.getName() + this.Const.MoodStateEvent[_event.m.Cripple.getMoodState()]
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

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 3 && bro.getBackground().getID() == "background.cripple")
			{
				cripple_candidates.push(bro);
			}
		}

		if (cripple_candidates.len() == 0)
		{
			return;
		}

		local veteran_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 5)
			{
				veteran_candidates.push(bro);
			}
		}

		if (veteran_candidates.len() == 0)
		{
			return;
		}

		this.m.Cripple = cripple_candidates[this.Math.rand(0, cripple_candidates.len() - 1)];
		this.m.Veteran = veteran_candidates[this.Math.rand(0, veteran_candidates.len() - 1)];
		this.m.Score = cripple_candidates.len() * 5;
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
			"veteran",
			this.m.Veteran.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Cripple = null;
		this.m.Veteran = null;
	}

});

