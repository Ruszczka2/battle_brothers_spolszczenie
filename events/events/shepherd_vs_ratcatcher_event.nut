this.shepherd_vs_ratcatcher_event <- this.inherit("scripts/events/event", {
	m = {
		Shepherd = null,
		Ratcatcher = null
	},
	function create()
	{
		this.m.ID = "event.shepherd_vs_ratcatcher";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]%ratcatcher% i %shepherd% siedzą przy ognisku. W trakcie rozmowy łapacz szczurów robi się nieco skonfundowany.%SPEECH_ON%Niech, niech, niech to dobrze pojmę. T-ty używasz kija i dlatego idą za tobą, bo masz kij? Chodzi o ten kij?%SPEECH_OFF%Pasterz, kiwając głową, wyjaśnia.%SPEECH_ON%Wolę nazywać to laską pasterską, ale tak. Owce to proste stworzenia i wszystko, czego potrzebują, to przywódca. Laska jest znakiem mojej roli. Dzierżę laskę, więc jestem przywódcą. Przynajmniej w oczach małej owcy. Posłuszny pies również bardzo pomaga. Prawdę mówiąc, to pies byłby prawdziwym przywódcą, gdyby nie miał lojalności i honoru, których sami chcielibyśmy mieć.%SPEECH_OFF%%ratcatcher% kiwa głową.%SPEECH_ON%Będę musiał spróbować kija, znaczy laski, ze swoimi szczurami. I też zdobyć psa.%SPEECH_OFF%Pasterz uśmiecha się.%SPEECH_ON%Albo kota. Co? Żartuję, przyjacielu, tylko żartuję.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jak dwa groszki w strąku. Albo świnie w chlewie?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Shepherd.getImagePath());
				this.Characters.push(_event.m.Ratcatcher.getImagePath());
				_event.m.Shepherd.improveMood(1.0, "Zbliżył się do " + _event.m.Ratcatcher.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Shepherd.getMoodState()],
					text = _event.m.Shepherd.getName() + this.Const.MoodStateEvent[_event.m.Shepherd.getMoodState()]
				});
				_event.m.Ratcatcher.improveMood(1.0, "Zbliżył się do " + _event.m.Shepherd.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Ratcatcher.getMoodState()],
					text = _event.m.Ratcatcher.getName() + this.Const.MoodStateEvent[_event.m.Ratcatcher.getMoodState()]
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

		local shepherd_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 4 && bro.getBackground().getID() == "background.shepherd")
			{
				shepherd_candidates.push(bro);
				break;
			}
		}

		if (shepherd_candidates.len() == 0)
		{
			return;
		}

		local ratcatcher_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 3 && bro.getBackground().getID() == "background.ratcatcher")
			{
				ratcatcher_candidates.push(bro);
			}
		}

		if (ratcatcher_candidates.len() == 0)
		{
			return;
		}

		this.m.Shepherd = shepherd_candidates[this.Math.rand(0, shepherd_candidates.len() - 1)];
		this.m.Ratcatcher = ratcatcher_candidates[this.Math.rand(0, ratcatcher_candidates.len() - 1)];
		this.m.Score = (shepherd_candidates.len() + ratcatcher_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"shepherd",
			this.m.Shepherd.getNameOnly()
		]);
		_vars.push([
			"ratcatcher",
			this.m.Ratcatcher.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Shepherd = null;
		this.m.Ratcatcher = null;
	}

});

