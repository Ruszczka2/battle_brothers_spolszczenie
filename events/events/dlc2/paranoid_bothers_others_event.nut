this.paranoid_bothers_others_event <- this.inherit("scripts/events/event", {
	m = {
		Paranoid = null
	},
	function create()
	{
		this.m.ID = "event.paranoid_bothers_others";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]{Słyszysz zamieszanie i idziesz sprawdzić, widząc %paranoid%a wymachującego bronią w stronę swoich towarzyszy.%SPEECH_ON%Wiem, kim jesteś, i wiem, kim nie jesteś, a tym, kim nie jesteś, są moi przyjaciele!%SPEECH_OFF%%randombrother% spogląda i wzrusza ramionami.%SPEECH_ON%Nigdy nie mówiłem, że jesteś moim przyjacielem.%SPEECH_OFF%Paranoiczny najemnik wciąż szczeka, żądając, by wszyscy trzymali dystans, bo inaczej ich potnie. Udaje ci się go uspokoić, głównie tłumacząc, jaka jest jego dzienna stawka i jak będzie sobie radził bez niej, ale to na pewno rozwiązanie krótkoterminowe. | Znajdujesz %paranoid%a, coraz bardziej paranoicznego najemnika, skulonego samotnie, z rękami wokół kolan. Mimo dziecięcej postawy jego oczy są twarde i uważnie obserwuje wszystko. Gdy pytasz, jak się czuje, po prostu się śmieje.%SPEECH_ON%Nie wiem, panie, jestem tylko otoczony przez bandę chciwych dupków, którzy wbiją mi nóż w plecy, kiedy tylko im to pasuje.%SPEECH_OFF%W pewnym sensie rozumiesz, skąd to się bierze, ale masz nadzieję, że ten nastrój nie zarazi reszty kompanii.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Przestań być taki paranoiczny.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Paranoid.getImagePath());
				_event.m.Paranoid.worsenMood(0.5, "Jest paranoiczny wobec swoich towarzyszy");

				if (_event.m.Paranoid.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Paranoid.getMoodState()],
						text = _event.m.Paranoid.getName() + this.Const.MoodStateEvent[_event.m.Paranoid.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.paranoid"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 1)
		{
			return;
		}

		this.m.Paranoid = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"paranoid",
			this.m.Paranoid.getName()
		]);
	}

	function onClear()
	{
		this.m.Paranoid = null;
	}

});

