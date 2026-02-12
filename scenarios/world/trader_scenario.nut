this.trader_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.trader";
		this.m.Name = "Karawana Kupiecka";
		this.m.Description = "[p=c][img]gfx/ui/events/event_41.png[/img][/p][p]Prowadzisz małą karawanę kupiecką, a większość swoich koron zainwestowałeś w towary handlowe. Jednak szlaki stały się niebezpieczne - bandyci i zielonoskórzy czają się w zasadzkach, a krążą też plotki o rzeczach jeszcze gorszych.\n\n[color=#bcad8c]Karawana:[/color] Rozpoczynasz z dwoma pomocnikami karawany, pracującymi dla ciebie.\n[color=#bcad8c]Kupiec:[/color] Otrzymujesz o 10% lepsze ceny przy kupnie i sprzedaży.\n[color=#bcad8c]Nie Wojownik:[/color] Rozpoczynasz bez sławy i zdobywasz ją tylko w wysokości 66% normalnego poziomu.[/p]";
		this.m.Difficulty = 1;
		this.m.Order = 19;
	}

	function isValid()
	{
		return this.Const.DLC.Wildmen;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local names = [];

		for( local i = 0; i < 2; i = i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = this.Time.getVirtualTimeF();
			bro.worsenMood(0.5, "Napotkał inną karawanę, wyrżniętą przez zielonoskórych");

			while (names.find(bro.getNameOnly()) != null)
			{
				bro.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
			}

			names.push(bro.getNameOnly());
			i = ++i;
		}

		local bros = roster.getAll();
		bros[0].setStartValuesEx([
			"caravan_hand_background"
		]);
		bros[0].getBackground().m.RawDescription = "Robotnik, murarz, młynarz... %name% pracował już wszędzie, zmieniając zawody i nie mitrężąc czasu. Nie byłeś pewny, czy jego zatrudnienie jako pomocnika karawany nie będzie trwało równie krótko, ale gdy spytałeś go zmianę na zawód najemnika, to nie miał z tym żadnych problemów...";
		bros[0].setPlaceInFormation(3);
		bros[0].m.Talents = [];
		local talents = bros[0].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.MeleeSkill] = 2;
		talents[this.Const.Attributes.MeleeDefense] = 1;
		talents[this.Const.Attributes.Fatigue] = 1;
		bros[1].setStartValuesEx([
			"caravan_hand_background"
		]);
		bros[1].getBackground().m.RawDescription = "%name% i ty spotkaliście się, gdy wyrzucono go gospody. Na pierwszy rzut oka wydawał się jeno zwykłym moczymordą. Jednak chwilę później byłeś świadkiem, jak odpierał ataki trzech bandziorów. Ostatecznie udało im się zabrać jego buty, ale nie zdołali tak naprawdę pokonać jego walecznego ducha. Byłeś pod wrażeniem, więc przyjąłeś go jako pomocnika karawany.";
		bros[1].setPlaceInFormation(4);
		bros[1].m.Talents = [];
		local talents = bros[1].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.MeleeSkill] = 2;
		talents[this.Const.Attributes.MeleeDefense] = 1;
		talents[this.Const.Attributes.Hitpoints] = 1;
		local items = bros[1].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/scimitar"));
		this.World.Assets.m.BusinessReputation = 0;
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/bread_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/mead_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/wine_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/trade/amber_shards_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/trade/cloth_rolls_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/trade/dies_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/trade/furs_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/trade/salt_item"));
		this.World.Assets.m.Money = this.World.Assets.m.Money / 2 + 400;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() >= 3)
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
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 8), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 8));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 8), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 8));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.IsOccupied)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) <= 5)
				{
				}
				else if (!tile.HasRoad)
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
		this.World.Assets.updateLook(9);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/retirement_01.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.trader_scenario_intro");
		}, null);
	}

	function onInit()
	{
		this.World.Assets.m.BusinessReputationRate = 0.66;
		this.World.Assets.m.BuyPriceMult = 0.9;
		this.World.Assets.m.SellPriceMult = 1.1;
	}

});

