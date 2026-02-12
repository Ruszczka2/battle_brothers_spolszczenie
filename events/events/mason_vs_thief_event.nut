this.mason_vs_thief_event <- this.inherit("scripts/events/event", {
	m = {
		Mason = null,
		Thief = null
	},
	function create()
	{
		this.m.ID = "event.mason_vs_thief";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 120.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]%mason% murarz podsyca ognisko obozowe, a obok stoi %thief%. Złodziej rozważa pewne pytanie.%SPEECH_ON%Hmm, co było najtrudniejsze do okradzenia? Cóż, skarbce były najłatwiejsze, zacznijmy od tego. Raz ukradłem ze skarbca tyle, że chcieli powiesić ślusarza za to, że dał się tak łatwo pokonać zwykłemu złodziejowi. Nie znaleźli ślusarza, bo widzisz, nie jestem zwykłym złodziejem, a ślusarzem byłem ja. Ha-ha! Odpowiadając na twoje pytanie, najtrudniej jest dostać się do wieży, szczególnie takiej, która stoi samotnie.%SPEECH_OFF%Murarz, zadowolony z siebie, kiwa głową.%SPEECH_ON%Aye, myślałem, że tak powiesz. Wieże buduje się dla ważnych więźniów lub przedmiotów o szczególnej wartości. Niewiele więcej niż klatki na niebie dla stworzeń bez skrzydeł. Ale raz pewien więzień, znany złodziej ryb, zdołał uciec. Przez lata wyrywał własne włosy i wiązał je razem, aż \"lina\" była wystarczająco długa, by ją wyrzucić i zejść. Złapali go dzień później, niestety. Kilka lat później zrobił to samo, ale wtedy uplotł linę o połowę krótszą i po prostu się powiesił.%SPEECH_OFF%%thief% się śmieje.%SPEECH_ON%To wszystko ciekawe, ale jestem prawdziwym złodziejem, murarzu, nie zwykłym okradaczem rybaków. Moje pytanie brzmi, jak dostać się -do- wieży.%SPEECH_OFF%Murarz kiwa głową.%SPEECH_ON%Proste. Popełnij... śledziowe przewinienie.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ależ przemowa.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Mason.getImagePath());
				this.Characters.push(_event.m.Thief.getImagePath());
				_event.m.Mason.improveMood(1.0, "Zbliżył się z " + _event.m.Thief.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Mason.getMoodState()],
					text = _event.m.Mason.getName() + this.Const.MoodStateEvent[_event.m.Mason.getMoodState()]
				});
				_event.m.Thief.improveMood(1.0, "Zbliżył się z " + _event.m.Mason.getName());
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

		local mason_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.mason")
			{
				mason_candidates.push(bro);
				break;
			}
		}

		if (mason_candidates.len() == 0)
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

		this.m.Mason = mason_candidates[this.Math.rand(0, mason_candidates.len() - 1)];
		this.m.Thief = thief_candidates[this.Math.rand(0, thief_candidates.len() - 1)];
		this.m.Score = (mason_candidates.len() + thief_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"mason",
			this.m.Mason.getNameOnly()
		]);
		_vars.push([
			"thief",
			this.m.Thief.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Mason = null;
		this.m.Thief = null;
	}

});

