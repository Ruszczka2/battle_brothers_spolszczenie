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
			Text = "{[img]gfx/ui/events/event_183.png[/img]{%oathtaker% Świętobiorca siada z tobą przy ognisku. Kiwa głową.%SPEECH_ON%Z szacunkiem, kapitanie, mogę powiedzieć, że dużo wymagać od człowieka, by był naprawdę dobry. Gdy cię poznałem, nie sądziłem, że masz zadatki do takiego zadania. Myślałem, że czołgająca się ciemność tego świata cię wysuszy, zetrze jak piasek o kamień. A jednak jesteś. Niezłomny. Trzymasz się Ślubów, jeden po drugim. Dobra robota. Młody Anselm byłby dumny.%SPEECH_OFF%Dziękujesz Świętobiorcy za dobre słowa.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Miło, że ktoś to docenia.",
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
				_event.m.Oathtaker.improveMood(1.0, "Cieszy się z moralnego kompasu kompanii");

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

