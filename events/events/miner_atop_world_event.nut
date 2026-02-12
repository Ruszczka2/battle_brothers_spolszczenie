this.miner_atop_world_event <- this.inherit("scripts/events/event", {
	m = {
		Miner = null
	},
	function create()
	{
		this.m.ID = "event.miner_atop_world";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 80.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_42.png[/img]Kompania maszeruje w góry, albo jak to poetycko określił %randombrother%, \"cycki królestwa\". Chmury zaczynają przesuwać się na wysokości oczu, a powietrze robi się tak rzadkie, jakbyś oddychał przez słomkę. Śnieg chrzęści pod stopami, a ostre wiatry grożą, że zamienią ci oczy w kostki lodu. Mimo stromych urwisk i niebezpiecznych szczelin do pokonania, %miner% górnik wydaje się całkiem szczęśliwy, że zaszedł tak wysoko.%SPEECH_ON%To jakbyśmy byli na szczycie świata! Czy to nie wspaniałe?%SPEECH_OFF%Ledwo może oddychać, ale górnik jest zbyt szczęśliwy, by się tym przejmować. Lata kopania głęboko w ziemi sprawiły, że ta zmiana perspektywy jest tym bardziej cudowna.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cóż, przynajmniej ktoś się dobrze bawi.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Miner.getImagePath());
				_event.m.Miner.improveMood(2.0, "Cieszył się widokiem ze szczytu góry");

				if (_event.m.Miner.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Miner.getMoodState()],
						text = _event.m.Miner.getName() + this.Const.MoodStateEvent[_event.m.Miner.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Mountains)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
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
			if (bro.getLevel() <= 3 && bro.getBackground().getID() == "background.miner")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Miner = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"miner",
			this.m.Miner.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Miner = null;
	}

});

