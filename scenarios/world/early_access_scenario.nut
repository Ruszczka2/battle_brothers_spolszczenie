this.early_access_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.early_access";
		this.m.Name = "Nowa Kompania";
		this.m.Description = "[p=c][img]gfx/ui/events/event_80.png[/img][/p][p]Po latach broczenia swego miecza we krwi za mizerną zapłatę, odłożyłeś wystarczająco dużo koron, aby założyć swoją własną kompanię najemników. Jest z tobą trzech doświadczonych najemników, u boku których walczyłeś wcześniej w murze tarcz, ramię w ramię.\n\n[color=#bcad8c]Szybki start w nowym świecie, bez żadnych konkretnych plusów i minusów.[/color][/p]";
		this.m.Difficulty = 1;
		this.m.Order = 10;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local names = [];

		for( local i = 0; i < 3; i = i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = this.Time.getVirtualTimeF();
			bro.improveMood(1.5, "Dołączył do kompanii najemników");

			while (names.find(bro.getNameOnly()) != null)
			{
				bro.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
			}

			names.push(bro.getNameOnly());
			i = ++i;
		}

		local bros = roster.getAll();
		bros[0].setStartValuesEx([
			"companion_1h_background"
		]);
		bros[0].getBackground().m.RawDescription = "{%name% zawdzięczał ci życie, bo ocaliłeś go w bitwie przeciwko zbójcom. Odwdzięczył się ratując cię podczas złodziejskiej zasadzki w jednej z ciemnych uliczek miasta. Jako że pospolici przestępcy są o kilka klas poniżej zbójców, często żartujesz z niego, że nadal jest trochę w tyle, gdy idzie o dług \'ratowania waszych tyłków\'.}";
		bros[0].setPlaceInFormation(3);
		bros[1].setStartValuesEx([
			"companion_2h_background"
		]);
		bros[1].getBackground().m.RawDescription = "{%name% sprawia wrażenie, że coś z nim jest nie tak, ale masz nadzieję, że nigdy się to nie zmieni. To osobnik z wyjątkowym pociągiem do bitew, dziwek, hazardu, śpiewu, walk psów, gonienia za kieckami, o dziwo mycia garów, wymiotowania oraz, oczywiście, picia na umór, ale zawsze dobrze jest mieć go przy sobie. Do tego jest doskonałym wojownikiem.}";
		bros[1].setPlaceInFormation(4);
		bros[2].setStartValuesEx([
			"companion_ranged_background"
		]);
		bros[2].getBackground().m.RawDescription = "Ty i %name% spotykaliście się kilka razy, zanim dołączył do twojej kompanii. Za pierwszym razem, gdy byliście zaledwie zwykłymi robotnikami. Za drugim, byliście najemnikami. A teraz przyszedł trzeci, gdy zasila szeregi twojej kompanii. Jeśli wszystko dobrze się potoczy, tym razem zostanie z tobą na dłużej i wspólnie odnajdziecie bogactwa, których szukacie.";
		bros[2].setPlaceInFormation(5);
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.m.Money = this.World.Assets.m.Money + 400;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() >= 3 && !randomVillage.isSouthern())
			{
				break;
			}

			i = ++i;
		}

		local randomVillageTile = randomVillage.getTile();
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 4), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 4));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 4), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 4));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore || tile.IsOccupied)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) <= 1)
				{
				}
				else
				{
					local path = this.World.getNavigator().findPath(tile, randomVillageTile, navSettings, 0);

					if (!path.isEmpty())
					{
						randomVillageTile = tile;
						break;
					}
				}
			}
		}
		while (1);

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList(this.Const.Music.IntroTracks, this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.early_access_scenario_intro");
		}, null);
	}

});

