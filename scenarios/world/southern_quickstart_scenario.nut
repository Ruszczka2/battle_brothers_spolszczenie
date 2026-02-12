this.southern_quickstart_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.southern_quickstart";
		this.m.Name = "Południowi Najemnicy";
		this.m.Description = "[p=c][img]gfx/ui/events/event_156.png[/img][/p][p]Ty i twoja mała grupka najemników przez lata odwalaliście brudną robotę dla pomniejszych kupców, niewiele różniąc się od pospolitych bandytów. Chcecie czegoś więcej. Chcecie wszystkiego. A Pozłotnik wskaże wam drogę.\n\n[color=#bcad8c]Szybki start w południowej części świata, bez żadnych konkretnych plusów i minusów.[/color][/p]";
		this.m.Difficulty = 1;
		this.m.Order = 11;
	}

	function isValid()
	{
		return this.Const.DLC.Desert;
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
				bro.setName(this.Const.Strings.SouthernNames[this.Math.rand(0, this.Const.Strings.SouthernNames.len() - 1)]);
			}

			names.push(bro.getNameOnly());
			i = ++i;
		}

		local bros = roster.getAll();
		bros[0].setStartValuesEx([
			"companion_1h_southern_background"
		]);
		bros[0].getBackground().m.RawDescription = "{%name% należał kiedyś do elitarnej straży przedniej Wezyra. W walnej bitwie cały jego legion został unicestwiony, a on sam pogrzebany pod ciałami swych towarzyszy. Został zostawiony na śmierć na pustyni, ale zdołał przeżyć, choć nikomu nie chce zdradzić jak mu się to udało. Jednak jego niesamowita lojalność wobec ciebie mówi więcej, niż mogłaby powiedzieć jakakolwiek opowieść wojenna..}";
		bros[0].setPlaceInFormation(3);
		bros[1].setStartValuesEx([
			"companion_2h_southern_background"
		]);
		bros[1].getBackground().m.RawDescription = "{Gdyby lojalność była złotem, %name% byłby zapewne jednym z najbogatszych ludzi pod słońcem. natknąłeś się na niego, gdy wpadł w zasadzkę w uliczce. Pomogłeś mu w walce ze złodziejami, a on w zamian obiecał ci służyć przez rok. A od tamtego czasu lat minęło już wiele. Mimo iż przy pierwszym waszym spotkaniu dostawał łupnia, to jest z niego niezwykle groźny wojownik, o ile nie zaatakuje się go znienacka.}";
		bros[1].setPlaceInFormation(4);
		bros[2].setStartValuesEx([
			"companion_ranged_southern_background"
		]);
		bros[2].getBackground().m.RawDescription = "{Nie jesteś całkiem pewny co do tego, jaką %name% miał przeszłość, poza tym, że nie była ona zbyt chwalebna. Sam mówi, że robił sporo rzeczy, choć nie chciała go armia, nie chciała go straż miejska, z pewnością nie chciały go też kobiety, więc przyjął żywot najemnika. Jest przekonany, że wspaniała i przyśpieszona śmierć przyciągnie oko Złotnika, a wtedy będzie go mógł zapytać, dlaczego tak surowo traktował go w życiu. O ile nie zwiesza nosa na kwintę, %name% potrafi być radosny i zabawny. Tylko trzymaj go z dala od napitków i kapłanów.}";
		bros[2].setPlaceInFormation(5);
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/rice_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/rice_item"));
		this.World.Assets.m.Money = this.World.Assets.m.Money + 400;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isIsolatedFromRoads() && randomVillage.isSouthern())
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
		this.World.Assets.updateLook(13);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/worldmap_11.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.southern_quickstart_scenario_intro");
		}, null);
	}

});

