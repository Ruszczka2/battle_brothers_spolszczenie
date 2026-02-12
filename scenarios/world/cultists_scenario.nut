this.cultists_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.cultists";
		this.m.Name = "Kultyści Davkula";
		this.m.Description = "[p=c][img]gfx/ui/events/event_140.png[/img][/p][p]Davkul czeka. Prowadzisz małą trzódkę ludzi oddanych dawnemu bogu i nadszedł czas, by zacząć szerzyć jego słowo. Znajdź więcej wyznawców, zdobądź bogactwa i zaspokój Davkula ofiarami.\n\n[color=#bcad8c]Kultyści:[/color] Rozpoczynasz z grupą czterech kultystów i słabym wyposażeniem. Więcej kultystów może przyłączyć się do ciebie za darmo.\n[color=#bcad8c]Ofiary:[/color] Davkul będzie się czasami domagał od ciebie ofiar, ale też wynagrodzi swoich lojalnych wyznawców.[/p]";
		this.m.Difficulty = 2;
		this.m.Order = 80;
	}

	function isValid()
	{
		return this.Const.DLC.Wildmen;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local names = [];

		for( local i = 0; i < 4; i = i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = this.Time.getVirtualTimeF();
			bro.getSkills().add(this.new("scripts/skills/traits/cultist_fanatic_trait"));

			while (names.find(bro.getNameOnly()) != null)
			{
				bro.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
			}

			names.push(bro.getNameOnly());
			i = ++i;
		}

		local bros = roster.getAll();
		bros[0].setStartValuesEx([
			"cultist_background"
		]);
		bros[0].getBackground().m.RawDescription = "Gdy %name% dołączył, ciepło nazywał cię kapitanem, mówiąc \"to właściwy sposób, by odszukać ścieżkę do czerni, z której pochodzimy\".";
		bros[0].setPlaceInFormation(2);
		local items = bros[0].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Body));
		items.equip(this.new("scripts/items/weapons/scramasax"));
		items.equip(this.new("scripts/items/helmets/cultist_hood"));
		items.equip(this.new("scripts/items/armor/leather_wraps"));
		bros[1].setStartValuesEx([
			"cultist_background"
		]);
		bros[1].getBackground().m.RawDescription = "%name% znalazł cię na szlaku. Zaznaczył, że wie, iż jesteś kapitanem najemników. Byłeś wówczas jeno zwykłym łachmaniarzem, lecz on rzekł, że dzięki mrokowi Davkula otacza cię aura pożądanej czerni.";
		bros[1].setPlaceInFormation(3);
		local items = bros[1].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Body));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
		items.equip(this.new("scripts/items/weapons/two_handed_wooden_flail"));
		items.equip(this.new("scripts/items/armor/cultist_leather_robe"));
		items.equip(this.new("scripts/items/helmets/hood"));
		bros[2].setStartValuesEx([
			"cultist_background"
		]);
		bros[2].getBackground().m.RawDescription = "Cichy typ, %name%, ma jakby cienie pod opuszkami swych palców, płynące niczym solanka po bezbarwnym brzegu. Gdy uścisnął twoją dłoń, wydawało ci się, jakbyś usłyszał syczenie swego rozsądku.";
		bros[2].setPlaceInFormation(4);
		local items = bros[2].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Body));
		items.equip(this.new("scripts/items/weapons/battle_whip"));
		items.equip(this.new("scripts/items/helmets/cultist_leather_hood"));
		bros[3].setStartValuesEx([
			"cultist_background"
		]);
		bros[3].getBackground().m.RawDescription = "%name% dołączył do ciebie pod gospodą. Gdy go pierwszy raz ujrzałeś, miał blizny biegnące po całych swych rękach i w poprzek żył, które sugerowały, że powinien być martwy. Jednak każdego ranka wydaje się, jakby jego blizny zmieniały położenie, pełznąc powoli w jednym kierunku: na jego czoło.";
		bros[3].setPlaceInFormation(5);
		local items = bros[3].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Body));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
		items.equip(this.new("scripts/items/weapons/bludgeon"));
		items.equip(this.new("scripts/items/helmets/cultist_hood"));
		items.equip(this.new("scripts/items/armor/leather_wraps"));
		this.World.Assets.addMoralReputation(-10);
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.m.Money = this.World.Assets.m.Money + 400;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() == 1)
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
				else if (tile.Type != this.Const.World.TerrainType.Plains && tile.Type != this.Const.World.TerrainType.Steppe && tile.Type != this.Const.World.TerrainType.Tundra && tile.Type != this.Const.World.TerrainType.Snow)
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
		this.World.Assets.updateLook(7);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList(this.Const.Music.CivilianTracks, this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.cultists_scenario_intro");
		}, null);
	}

	function onUpdateDraftList( _list )
	{
		if (_list.len() >= 10)
		{
			_list.push("cultist_background");
		}
	}

});

