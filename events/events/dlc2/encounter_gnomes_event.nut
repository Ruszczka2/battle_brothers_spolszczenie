this.encounter_gnomes_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.encounter_gnomes";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 200.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]Dajesz ludziom chwilę wytchnienia i postanawiasz samemu zwiadować las przed wami. Po nie więcej niż pięciu minutach słyszysz jednostajny pomruk śpiewu. Dobywasz miecza, wspinasz się na zwał powalonych drzew i zaglądasz przez krawędź. Tam widzisz tuzin postaci przypominających miniaturowych ludzi tańczących w kręgu. Połowa gwiżdże nisko, a reszta wciąż powtarza jakieś słowo, którego nigdy wcześniej nie słyszałeś. W centrum tego absurdu jest grzyb i bardzo znudzona ropucha, której czasem jeden z małych ludziaków dotyka, po czym z uśmiechem wraca do kręgu, jakby uszedł z jakimś łotrowskim występkiem.\n\n To już przesada. Skradasz się, by lepiej zobaczyć, ale gałąź pęka pod twoim ciężarem. Maluchy natychmiast się zatrzymują i patrzą na ciebie jak stado ofiar. Jeden krzyczy coś bełkotliwie, a reszta podskakuje i ucieka, nurkując w dziuple lub krzaki. Gdy schodzisz, by to sprawdzić, nie znajdujesz niczego. Zniknęli całkowicie. Podchodzisz do pnia i znajdujesz ropuchę przebitą po rękojeść sztyletem, a grzyba już nie ma.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dziwne.",
					function getResult( _event )
					{
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
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 25)
			{
				return false;
			}
		}

		this.m.Score = 10;
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

