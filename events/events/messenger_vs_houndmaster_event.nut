this.messenger_vs_houndmaster_event <- this.inherit("scripts/events/event", {
	m = {
		Messenger = null,
		Houndmaster = null
	},
	function create()
	{
		this.m.ID = "event.messenger_vs_houndmaster";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]%messenger% i %houndmaster% dzielą się opowieściami przy ognisku. Posłaniec się śmieje.%SPEECH_ON%Posłuchaj o mojej pierwszej dostawie. Podszedłem do twierdzy z piękną fosą. Najgroźniejsze w wodzie były lilie i żaby utuczone muchami. Przeszedłem po moście zwodzonym i wszedłem do środka, list w ręku, brzuch skręcał mi się z ekscytacji. Wchodzę i co słyszę? Hau-hau-hau! Rar-rrr! Ten cholerny kundel wyskakuje z budy, zębiska na wierzchu, uszy przyklejone. Myślę: o cholera, nie na to się pisałem, i wspinam się na kurnik, a to futrzaste bydle próbuje zjeść mi stopy. W końcu wychodzi pan, a pies siada, jakby nic się nie stało. Szlachcic się śmieje i bierze list. Mówi: \"co, nie widziałeś tabliczki?\" Ja na to: eee, nie panie, ale ja już pójdę. Kiedy wychodziłem, podnieśli most zwodzony i, wyobraź sobie, od spodu mieli namalowane wielkie ostrzeżenie \"Uwaga, pies\"!%SPEECH_OFF%%houndmaster% wybucha śmiechem.%SPEECH_ON%Jak na pierwszy dzień w robocie, to nieźle. Ale wiedz, żadnen pies z %companyname% cię nie skrzywdzi! Wyszkoliłem te kundelki jak trzeba!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Biada posłańcowi.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Messenger.getImagePath());
				this.Characters.push(_event.m.Houndmaster.getImagePath());
				_event.m.Messenger.improveMood(1.0, "Zbliżył się z " + _event.m.Houndmaster.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Messenger.getMoodState()],
					text = _event.m.Messenger.getName() + this.Const.MoodStateEvent[_event.m.Messenger.getMoodState()]
				});
				_event.m.Houndmaster.improveMood(1.0, "Zbliżył się z " + _event.m.Messenger.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Houndmaster.getMoodState()],
					text = _event.m.Houndmaster.getName() + this.Const.MoodStateEvent[_event.m.Houndmaster.getMoodState()]
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

		local messenger_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 3 && bro.getBackground().getID() == "background.messenger")
			{
				messenger_candidates.push(bro);
			}
		}

		if (messenger_candidates.len() == 0)
		{
			return;
		}

		local houndmaster_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.houndmaster")
			{
				houndmaster_candidates.push(bro);
			}
		}

		if (houndmaster_candidates.len() == 0)
		{
			return;
		}

		this.m.Messenger = messenger_candidates[this.Math.rand(0, messenger_candidates.len() - 1)];
		this.m.Houndmaster = houndmaster_candidates[this.Math.rand(0, houndmaster_candidates.len() - 1)];
		this.m.Score = (messenger_candidates.len() + houndmaster_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"messenger",
			this.m.Messenger.getNameOnly()
		]);
		_vars.push([
			"houndmaster",
			this.m.Houndmaster.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Messenger = null;
		this.m.Houndmaster = null;
	}

});

