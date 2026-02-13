this.ijirok_1_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.ijirok_1";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_143.png[/img]%randombrother% zatrzymuje cię i mówi, że jest coś, co powinieneś zobaczyć. Na pewno coś, co leży w całym tym lodzie i pustce, jest warte uwagi.\n\n Najemnik prowadzi cię do ogromnej dziury w ziemi. Zapala pochodnię i schodzi, a ty za nim. Na dole znajdujesz kilku innych ludzi. Stoją wokół czegoś, co wygląda jak sarkofag z lodu, tylko bez wieka. Zamarznięta czerń oblepia krawędzie pojemnika. W rogu komnaty tkwi w ścianie lodowe zwłoki. Ręce ma wzdłuż ciała, a z nadgarstków spływają sopelki krwi. Obok wisi para ubrań na lodowych hakach, ale nie ma do nich ciała. Smuga krwi prowadzi od ubrań do tamtego mężczyzny, a potem z powrotem na zewnątrz jaskini.%SPEECH_ON%Nie wiem, co o tym myśleć, sir.%SPEECH_OFF%mówi jeden z najemników. Pytasz ludzi, czy podczas zwiadu widzieli cokolwiek, dosłownie cokolwiek. Ale wszyscy kręcą głowami. Jeśli coś było w tej skrzyni, to na pewno już tego nie ma. Każesz ludziom wyjść z jaskini i wrócić do obozu.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I miejcie się na baczności.",
					function getResult( _event )
					{
						this.World.Flags.set("IjirokStage", 1);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (!this.World.Flags.has("IjirokStage") || this.World.Flags.get("IjirokStage") >= 5)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Snow)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 10)
			{
				return;
			}
		}

		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

