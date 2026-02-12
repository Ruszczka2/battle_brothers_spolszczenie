this.poacher_vs_thief_event <- this.inherit("scripts/events/event", {
	m = {
		Poacher = null,
		Thief = null
	},
	function create()
	{
		this.m.ID = "event.poacher_vs_thief";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 150.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]Wychodzisz z namiotu i widzisz %poacher% oraz %thief% opowiadających sobie historie. Nie wiesz, co kłusownik i złodziej mogą mieć wspólnego, ale wygląda na to, że świetnie się bawią. Śmiejąc się, %poacher% snuje kolejną opowieść.%SPEECH_ON%Raz polowałem na jelenia na ziemiach pewnego skąpego szlachcica. Zastrzelenie tego cholernego byka było najłatwiejsze. W trakcie oprawiania w polu słyszę dudnienie kopyt. Więc rzucam linę na drzewo, wiążę do niej tuszę i wciągam ją na górę. Nie mija minuta, bam-bam-bam, a tu szlachcic z żandarmem i całą świtą strażników.%SPEECH_OFF%%thief% unosi brew.%SPEECH_ON%To trudna sytuacja, panie.%SPEECH_OFF%Kłusownik kiwa głową.%SPEECH_ON%Trudniejsza niż u dziewicy z nogami na krzyż. Ten szlachcic kręci się tuż pode mną i widzi całą krew. Zaczyna ujadać, żebym wyszedł i się poddał. Nie miałem takiego zamiaru, ale niestety ten cholerny jeleń zaczął się zsuwać. Sięgam po niego i chyba gałąź nie wytrzymała, bo pękła. Szlachcic podnosi wzrok dokładnie na czas, by dostać w brzuch tego jelenia, a ja lecę na pewną śmierć, aż ta cholerna lina zahacza mi stopę i wieszam się głową w dół przed stwórcą. Macham trochę: \'hej, panowie, nie chciałem się tak wtrącać.\'%SPEECH_OFF%Złodziej śmieje się, ale wygląda na trochę zaniepokojonego. %poacher% macha na niego ręką.%SPEECH_ON%Oj, mieli poczucie humoru, dzięki starym bogom. Spędziłem tylko sześć miesięcy w ciemnym lochu. Nic strasznego, naprawdę.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jasne.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Poacher.getImagePath());
				this.Characters.push(_event.m.Thief.getImagePath());
				_event.m.Poacher.improveMood(1.0, "Zżył się z " + _event.m.Thief.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Poacher.getMoodState()],
					text = _event.m.Poacher.getName() + this.Const.MoodStateEvent[_event.m.Poacher.getMoodState()]
				});
				_event.m.Thief.improveMood(1.0, "Zżył się z " + _event.m.Poacher.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Thief.getMoodState()],
					text = _event.m.Thief.getName() + this.Const.MoodStateEvent[_event.m.Thief.getMoodState()]
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

		local poacher_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.poacher")
			{
				poacher_candidates.push(bro);
			}
		}

		if (poacher_candidates.len() == 0)
		{
			return;
		}

		local thief_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.thief")
			{
				thief_candidates.push(bro);
			}
		}

		if (thief_candidates.len() == 0)
		{
			return;
		}

		this.m.Poacher = poacher_candidates[this.Math.rand(0, poacher_candidates.len() - 1)];
		this.m.Thief = thief_candidates[this.Math.rand(0, thief_candidates.len() - 1)];
		this.m.Score = (poacher_candidates.len() + thief_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"poacher",
			this.m.Poacher.getNameOnly()
		]);
		_vars.push([
			"thief",
			this.m.Thief.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Poacher = null;
		this.m.Thief = null;
	}

});

