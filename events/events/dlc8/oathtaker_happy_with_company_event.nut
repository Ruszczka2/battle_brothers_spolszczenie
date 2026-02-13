this.oathtaker_happy_with_company_event <- this.inherit("scripts/events/event", {
	m = {
		Oathtaker = null
	},
	function create()
	{
		this.m.ID = "event.oathtaker_happy_with_company";
		this.m.Title = "W trakcie obozu...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_183.png[/img]{%oathtaker% Swietobiorca siada z toba przy ognisku. Kiwa glowa.%SPEECH_ON%Z szacunkiem, kapitanie, moge powiedziec, ze duzo wymagac od czlowieka, by byl naprawde dobry. Gdy cie poznalem, nie sadzilem, ze masz zadatki do takiego zadania. Myslalem, ze czolgajaca sie ciemnosc tego swiata cie wysuszy, zetrze jak piasek o kamien. A jednak jestes. Niezlomny. Trzymasz sie Slubow, jeden po drugim. Dobra robota. Mlody Anselm bylby dumny.%SPEECH_OFF%Dziekujesz Swietobiorcy za dobre slowa.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Milo, ze ktos to docenia.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Oathtaker.getImagePath());
				_event.m.Oathtaker.getBaseProperties().Bravery += 2;
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Oathtaker.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Determinacji"
				});
				_event.m.Oathtaker.improveMood(1.0, "Cieszy sie z moralnego kompasu kompani");

				if (_event.m.Oathtaker.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Oathtaker.getMoodState()],
						text = _event.m.Oathtaker.getName() + this.Const.MoodStateEvent[_event.m.Oathtaker.getMoodState()]
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

		if (this.World.Assets.getMoralReputation() < 80.0)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local oathtaker_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.paladin" && bro.getLevel() >= 5)
			{
				oathtaker_candidates.push(bro);
			}
		}

		if (oathtaker_candidates.len() == 0)
		{
			return;
		}

		this.m.Oathtaker = oathtaker_candidates[this.Math.rand(0, oathtaker_candidates.len() - 1)];
		this.m.Score = 5 * oathtaker_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"oathtaker",
			this.m.Oathtaker.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Oathtaker = null;
	}

});

