this.beast_hunters_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.beast_hunters";
		this.m.Name = "Pogromcy Bestii";
		this.m.Description = "[p=c][img]gfx/ui/events/event_122.png[/img][/p][p]Ty i twoi ludzie zarabiacie na życie polując na różnorakie bestie, które dręczą wioski na obrzeżach cywilizacji. To niebezpieczny fach, ale dość dobrze płatny i zawsze znajdzie się jakaś większa poczwara do ubicia oraz więcej koron do zarobienia.\n\n[color=#bcad8c]Pogromcy Bestii:[/color] Rozpoczynasz z trzema pogromcami bestii i przyzwoitym ekwipunkiem, a także z garścią trofeów.\n[color=#bcad8c]Tropiciele:[/color] Widzisz tropy z większej odległości.\n[color=#bcad8c]Skórownicy:[/color] Każda zabita przez was bestia ma 50% szansy na zapewnienie dodatkowego trofeum.\n[color=#bcad8c]Uprzedzenie:[/color] Większość ludzi nie ufa takim, jak ty, więc dają wam o 10% gorsze ceny.[/p]";
		this.m.Difficulty = 3;
		this.m.Order = 90;
		this.m.IsFixedLook = true;
	}

	function isValid()
	{
		return this.Const.DLC.Unhold;
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
			bro.improveMood(1.0, "Zabił niebezpieczną wiedźmę");
			bro.worsenMood(2.5, "Stracił większość kompanów przez zdradę");

			while (names.find(bro.getNameOnly()) != null)
			{
				bro.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
			}

			names.push(bro.getNameOnly());
			i = ++i;
		}

		local bros = roster.getAll();
		bros[0].setStartValuesEx([
			"beast_hunter_background"
		]);
		bros[0].getBackground().m.RawDescription = "%name% ocalił cię podczas zasadzki bandytów, która zniszczyła waszą bandę pogromców. Nie wypomina ci tego, bo i ty wielokrotnie ocaliłeś jego skórę. Nie okazuje emocji, które mu się nie przysługują i już samo to czyni z niego porządnego pogromcę.";
		bros[0].setPlaceInFormation(3);
		bros[0].addLightInjury();
		bros[0].m.Talents = [];
		local talents = bros[0].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.MeleeSkill] = 2;
		talents[this.Const.Attributes.MeleeDefense] = 1;
		talents[this.Const.Attributes.Fatigue] = 1;
		local items = bros[0].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Offhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Ammo));
		items.equip(this.new("scripts/items/weapons/boar_spear"));
		items.equip(this.new("scripts/items/tools/throwing_net"));
		bros[1].setStartValuesEx([
			"beast_hunter_background"
		]);
		bros[1].getBackground().m.RawDescription = "%name% to młody chłopak z miasta, który zaczął swoją przygodę z zabijaniem bestii poprzez wyplenienie \'wściekłych królików\' z królikarni, jak sam to ujął. Nie wiesz, na ile jest to prawda, ale nie ma to znaczenia, bo swojej wartości dowiódł już na polu bitwy więcej razy, niż zdołałbyś zliczyć.";
		bros[1].setPlaceInFormation(4);
		bros[1].addLightInjury();
		bros[1].m.Talents = [];
		local talents = bros[1].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.Fatigue] = 2;
		talents[this.Const.Attributes.MeleeSkill] = 1;
		talents[this.Const.Attributes.Bravery] = 1;
		local items = bros[1].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Offhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Ammo));
		items.equip(this.new("scripts/items/weapons/spetum"));
		bros[2].setStartValuesEx([
			"beast_hunter_background"
		]);
		bros[2].getBackground().m.RawDescription = "Osiwiali weterani są rzadkością w fachu zabijania bestii, a i %name% z pewnością takim nie jest. Jest natomiast inteligentnym człowiekiem, który zaczął swą przygodę z polowaniem na potwory od czytania ksiąg, zamiast ćwiczeń z mieczem. W głębi serca nadal jest przyzwoitym wojownikiem, ale to jego nauka i przygotowania dają mu przewagę w bitwie.";
		bros[2].setPlaceInFormation(5);
		bros[2].addInjury(this.Const.Injury.Brawl);
		bros[2].m.Talents = [];
		local talents = bros[2].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.RangedSkill] = 2;
		talents[this.Const.Attributes.RangedDefense] = 1;
		talents[this.Const.Attributes.Fatigue] = 1;
		local items = bros[2].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Offhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Ammo));
		items.equip(this.new("scripts/items/weapons/hunting_bow"));
		items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		items.equip(this.new("scripts/items/accessory/wardog_item"));

		foreach( bro in bros )
		{
			bro.m.PerkPoints = 1;
			bro.m.LevelUps = 1;
			bro.m.Level = 2;
		}

		this.World.Assets.m.BusinessReputation = 200;
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/misc/witch_hair_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/misc/werewolf_pelt_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/misc/werewolf_pelt_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/accessory/night_vision_elixir_item"));
		this.World.Assets.m.Money = this.Math.round(this.World.Assets.m.Money * 0.75);
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() <= 1)
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
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 3), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 3));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 3), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 3));

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
		this.World.Assets.updateLook(11);
		this.World.spawnLocation("scripts/entity/world/locations/battlefield_location", randomVillageTile.Coords).setSize(1);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList(this.Const.Music.CivilianTracks, this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.beast_hunters_scenario_intro");
		}, null);
	}

	function onInit()
	{
		this.World.Assets.m.BuyPriceMult = 1.1;
		this.World.Assets.m.SellPriceMult = 0.9;
		this.World.Assets.m.ExtraLootChance = 50;
		this.World.Assets.m.FootprintVision = 1.5;
	}

});

