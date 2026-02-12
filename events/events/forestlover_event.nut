this.forestlover_event <- this.inherit("scripts/events/event", {
	m = {
		Forestlover = null
	},
	function create()
	{
		this.m.ID = "event.forestlover";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img] {%forestlover% spogląda w górę na sklepienie lasu, a jego dłoń figlarnie przesuwa się przez smugi światła. Patrzy na ciebie.%SPEECH_ON%Jako dzieciak bawiłem się w tych lasach.%SPEECH_OFF%Kiwasz głową, po czym głośno się zastanawiasz.%SPEECH_ON%Myślałem, że urodziłeś się pod %randomtown%?%SPEECH_OFF%Dłoń %forestlover% opada, a on wpatruje się w ziemię.%SPEECH_ON%Och tak, racja. No cóż, powinniśmy ruszać, prawda?%SPEECH_OFF%Zanim zdążysz powiedzieć coś więcej, czerwieniący się mężczyzna rusza naprzód. | Zauważasz, że %forestlover% ma ostatnio lepszy nastrój. Okazuje się, że te lasy są mu znane, a powrót do ich zieleni sprawia, że promienieje ciepłą nostalgią. | Choć przeszliście już sporo lasów, zieleń tego robi na tobie wrażenie. %forestlover% bez wątpienia cieszy się z powrotu do gęstego królestwa drzew. | Drzewa, grube pnie i mocne konary, wznoszą się nad tobą. %forestlover% wydaje się oczarowany ich potęgą. Zauważasz, że ostatnio ciągle się uśmiecha, jakby powrót do lasu był powrotem do lepszych czasów.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze dla niego.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Forestlover.getImagePath());
				_event.m.Forestlover.improveMood(1.0, "Enjoyed being in a forest");

				if (_event.m.Forestlover.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Forestlover.getMoodState()],
						text = _event.m.Forestlover.getName() + this.Const.MoodStateEvent[_event.m.Forestlover.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
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
			if (bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.poacher" || bro.getBackground().getID() == "background.lumberjack")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() > 0)
		{
			this.m.Forestlover = candidates[this.Math.rand(0, candidates.len() - 1)];
			this.m.Score = candidates.len() * 10;
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"forestlover",
			this.m.Forestlover.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Forestlover = null;
	}

});

