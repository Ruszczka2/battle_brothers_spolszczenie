this.ijirok_3_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.ijirok_3";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_76.png[/img]{Podczas biwakowania na północnych pustkowiach zbliża się sylwetka, płaska czerń, jakby wycięta z powietrza. Gdy się zbliża, z rogu ognia rozkwita pomarańczowa poświata. Kompania dobywa broni - cóż za mroczna postać mogłaby być tutaj, wśród tej pustki? Co za \'coś\' przemierza tak nędzną krainę? Ale okazuje się, że to tylko starszy mężczyzna z łysą czaszką i bulwiastym, czerwonym nosem. Gdyby śnieg miał wyrzeźbić człowieka z granitu, tak wyglądałby jego twór. Nieznajomy przechodzi przez obóz, a kompania odwraca się do niego i krzyczy, lecz żaden najemnik nie podchodzi. W końcu schyla się i kładzie róg na ziemi, a śnieg gasi jego ogień. Potem wstaje, idzie dalej i wkrótce znika w nocnej mgle.\n\n  %randombrother% podnosi róg i przechyla go. Wypada z niego róża i nawet w ciemności widać, że płatki są miękkie, ale już podwijają się od okrutnego chłodu. Rozglądasz się za starcem i widzisz jego ślady wciąż świeże w puchu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Na tych pustkowiach pełno dziwactw.",
					function getResult( _event )
					{
						this.World.Flags.set("IjirokStage", 3);
						local locations = this.World.EntityManager.getLocations();

						foreach( v in locations )
						{
							if (v.getTypeID() == "location.icy_cave_location")
							{
								this.Const.World.Common.addFootprintsFromTo(this.World.State.getPlayer().getTile(), v.getTile(), this.Const.GenericFootprints, 0.5);
								break;
							}
						}

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

		if (!this.World.Flags.has("IjirokStage") || this.World.Flags.get("IjirokStage") == 0 || this.World.Flags.get("IjirokStage") >= 4)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Snow || currentTile.Type != this.Const.World.TerrainType.SnowyForest)
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

		local locations = this.World.EntityManager.getLocations();

		foreach( v in locations )
		{
			if (v.getTypeID() == "location.icy_cave_location")
			{
				if (v.getTile().getDistanceTo(currentTile) > 10)
				{
					return;
				}
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

