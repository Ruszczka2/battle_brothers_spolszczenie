this.raiders_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.raiders";
		this.m.Name = "Najeźdźcy z Północy";
		this.m.Description = "[p=c][img]gfx/ui/events/event_139.png[/img][/p][p]Przez całe swe dorosłe życie napadałeś i plądrowałeś okoliczne ziemie. Jednak miejscowe chłopstwo jest biedne, więc rozważasz rozwiniecie działalności o bardziej dochodową pracę najemną - znaczy, o ile twoi potencjalni zleceniodawcy zechcą przymknąć oko na twe dawne występki.\n\n[color=#bcad8c]Bojowa Banda:[/color] Rozpoczynasz z trzema doświadczonymi barbarzyńcami.\n[color=#bcad8c]Łupieżcy:[/color] Masz wyższą szansę na zdobycie łupów z zabitych wrogów.\n[color=#bcad8c]Banici:[/color] Rozpoczynasz ze złymi relacjami z większością ludzkich frakcji.[/p]";
		this.m.Difficulty = 2;
		this.m.Order = 60;
	}

	function isValid()
	{
		return this.Const.DLC.Wildmen;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();

		for( local i = 0; i < 4; i = i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = this.Time.getVirtualTimeF();
			i = ++i;
		}

		local bros = roster.getAll();
		bros[0].setStartValuesEx([
			"barbarian_background"
		]);
		bros[0].getBackground().m.RawDescription = "Wytrzymały wojownik, %name%, przeżył wiele kampanii łupieżczych i napadów. Choć niewiele mówi, jest niesłychanie zaciekłym okazem w bitwie. To, co robi pokonanym wieśniakom, drażni nawet innych najeźdźców. Dość prawdopodobne, że ruszył z tobą, aby zaspokoić swoje jeszcze bardziej sadystyczne żądze.";
		bros[0].improveMood(1.0, "Udała mu się wyprawa łupieżcza");
		bros[0].setPlaceInFormation(3);
		bros[0].m.PerkPoints = 2;
		bros[0].m.LevelUps = 2;
		bros[0].m.Level = 3;
		bros[0].m.Talents = [];
		local talents = bros[0].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.MeleeSkill] = 2;
		talents[this.Const.Attributes.Hitpoints] = 2;
		talents[this.Const.Attributes.Fatigue] = 1;
		local items = bros[0].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Body));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
		local warhound = this.new("scripts/items/accessory/warhound_item");
		warhound.m.Name = "Fenrir Ogar Wojenny";
		items.equip(warhound);
		items.equip(this.new("scripts/items/armor/barbarians/reinforced_animal_hide_armor"));
		items.equip(this.new("scripts/items/helmets/barbarians/bear_headpiece"));
		bros[1].setStartValuesEx([
			"barbarian_background"
		]);
		bros[1].getBackground().m.RawDescription = "%name% był jeszcze chłopcem, gdy zabrano go z wioski na południu i wychowano na barbarzyńskich pustkowiach. Mimo iż nauczył się języka i kultury, nigdy tak na prawdę nie pasował do reszty i ciągle był obiektem okrutnych żartów i kpin. Nie jesteś pewny, czy podążył za tobą, aby powrócić do swego ojczystego domu, czy też może by uciec od swej północnej \'rodziny\'.";
		bros[1].improveMood(1.0, "Udała mu się wyprawa łupieżcza");
		bros[1].setPlaceInFormation(4);
		bros[1].m.PerkPoints = 2;
		bros[1].m.LevelUps = 2;
		bros[1].m.Level = 3;
		bros[1].m.Talents = [];
		local talents = bros[1].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.MeleeSkill] = 2;
		talents[this.Const.Attributes.Hitpoints] = 1;
		talents[this.Const.Attributes.Fatigue] = 2;
		local items = bros[1].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Body));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
		items.equip(this.new("scripts/items/armor/barbarians/scrap_metal_armor"));
		items.equip(this.new("scripts/items/helmets/barbarians/leather_headband"));
		bros[2].setStartValuesEx([
			"barbarian_background"
		]);
		bros[2].getBackground().m.RawDescription = "Barbarzyńscy najeźdźcy często grabią z ziem, które są dla nich obce. Większość traktuje wyprawy łupieżcze jako sposób zdobycia materiałów i kobiet, jednak czasem zniewalają też nadzwyczajnych chłopców o sporym potencjale. %name%, wywodzący się z północy, był właśnie takim dzieckiem i sam został wychowany na najeźdźcę. Połowę życia spędził ze swym prymitywnym klanem, drugą zaś z tymi, którzy go zabrali. To uczyniło z niego tak odpornego i brutalnego wojownika, jak tylko się da.";
		bros[2].improveMood(1.0, "Udała mu się wyprawa łupieżcza");
		bros[2].setPlaceInFormation(5);
		bros[2].m.PerkPoints = 2;
		bros[2].m.LevelUps = 2;
		bros[2].m.Level = 3;
		bros[2].m.Talents = [];
		local talents = bros[2].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.MeleeSkill] = 1;
		talents[this.Const.Attributes.MeleeDefense] = 2;
		talents[this.Const.Attributes.Hitpoints] = 2;
		local items = bros[2].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Body));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
		items.equip(this.new("scripts/items/armor/barbarians/hide_and_bone_armor"));
		items.equip(this.new("scripts/items/helmets/barbarians/leather_helmet"));
		bros[3].setStartValuesEx([
			"monk_background"
		]);
		bros[3].getBackground().m.RawDescription = "%name% to człowiek, który sprowadził cię na tę ścieżkę i wierzysz, że może odegrać znaczącą rolę w zdobywaniu przez ciebie przepastnych bogactw. Widywałeś już północnych, jednorękich i kuśtykających kaleków, którzy bez trudu pokonaliby go w boju, jednak jego wiedza i bystrość umysłu mogą być ostrzejsze niźli miecze, jeśli należycie je wykorzystać.";
		bros[3].improveMood(2.0, "Myśli, że zdołał przekonać cię do porzucenia napadów łupieżczych");
		bros[3].setPlaceInFormation(13);
		bros[3].m.Talents = [];
		local talents = bros[3].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.Bravery] = 3;
		this.World.Assets.m.BusinessReputation = -50;
		this.World.Assets.addMoralReputation(-30.0);
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/goat_cheese_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/smoked_ham_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/loot/silverware_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/loot/silver_bowl_item"));
		this.World.Assets.m.Money = this.World.Assets.m.Money / 2;
		this.World.Assets.m.Ammo = this.World.Assets.m.Ammo / 2;
	}

	function onSpawnPlayer()
	{
		local randomVillage;
		local northernmostY = 0;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = i )
		{
			local v = this.World.EntityManager.getSettlements()[i];

			if (v.getTile().SquareCoords.Y > northernmostY && !v.isMilitary() && !v.isIsolatedFromRoads() && v.getSize() <= 2)
			{
				northernmostY = v.getTile().SquareCoords.Y;
				randomVillage = v;
			}

			i = ++i;
		}

		randomVillage.setLastSpawnTimeToNow();
		local randomVillageTile = randomVillage.getTile();
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 2), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 2));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 2), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 2));

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

		local attachedLocations = randomVillage.getAttachedLocations();
		local closest;
		local dist = 99999;

		foreach( a in attachedLocations )
		{
			if (a.getTile().getDistanceTo(randomVillageTile) < dist)
			{
				dist = a.getTile().getDistanceTo(randomVillageTile);
				closest = a;
			}
		}

		if (closest != null)
		{
			closest.setActive(false);
			closest.spawnFireAndSmoke();
		}

		local s = this.new("scripts/entity/world/settlements/situations/raided_situation");
		s.setValidForDays(5);
		randomVillage.addSituation(s);
		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local houses = [];

		foreach( n in nobles )
		{
			local closest;
			local dist = 9999;

			foreach( s in n.getSettlements() )
			{
				local d = s.getTile().getDistanceTo(randomVillageTile);

				if (d < dist)
				{
					dist = d;
					closest = s;
				}
			}

			houses.push({
				Faction = n,
				Dist = dist
			});
		}

		houses.sort(function ( _a, _b )
		{
			if (_a.Dist > _b.Dist)
			{
				return 1;
			}
			else if (_a.Dist < _b.Dist)
			{
				return -1;
			}

			return 0;
		});

		for( local i = 0; i < 2; i = i )
		{
			houses[i].Faction.addPlayerRelation(-100.0, "Jesteście uważani za banitów i barbarzyńców");
			i = ++i;
		}

		houses[1].Faction.addPlayerRelation(18.0);
		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(5);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/barbarians_02.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.raiders_scenario_intro");
		}, null);
	}

	function isDroppedAsLoot( _item )
	{
		return this.Math.rand(1, 100) <= 15;
	}

});

