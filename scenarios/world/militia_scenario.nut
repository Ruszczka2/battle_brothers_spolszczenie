this.militia_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.militia";
		this.m.Name = "Milicja Chłopska";
		this.m.Description = "[p=c][img]gfx/ui/events/event_141.png[/img][/p][p]Zaczęło się od obszarpanej milicji, złożonej z każdego na tyle odważnego lub zdesperowanego, by zgłosić się do obrony swych domów, ale urosła z tego mała armia. Armia, którą codziennie trzeba wykarmić. Być może usługi milicji można wynająć.\n\n[color=#bcad8c]Chłopska Armia:[/color] Rozpoczynasz z 12. kiepsko wyposażonymi wieśniakami.\n[color=#bcad8c]Ludzka Fala[/color]: Możesz wystawić aż 16 ludzi do bitwy i mieć do 25 ludzi łącznie.\n[color=#bcad8c]Brudni Wieśniacy[/color]: Nie możesz zatrudnić nikogo, kto nie jest nisko urodzonym wieśniakiem.[/p]";
		this.m.Difficulty = 1;
		this.m.Order = 20;
	}

	function isValid()
	{
		return this.Const.DLC.Wildmen;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local names = [];

		for( local i = 0; i < 12; i = i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.worsenMood(1.5, "Stracił wielu przyjaciół w bitwie");
			bro.improveMood(0.5, "Członek milicji");
			bro.m.HireTime = this.Time.getVirtualTimeF();

			while (names.find(bro.getNameOnly()) != null)
			{
				bro.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
			}

			names.push(bro.getNameOnly());
			i = ++i;
		}

		local bros = roster.getAll();
		bros[0].setStartValuesEx([
			"farmhand_background"
		]);
		bros[0].getBackground().m.RawDescription = "%name% jest synem rolnika i rzekomo chce kiedyś sam zostać ojcem. Na razie jest z tobą, co stanowi dość godnym pożałowania zderzeniem marzeń z rzeczywistością.";
		bros[0].improveMood(3.0, "Zakochał się niedawno");
		local items = bros[0].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/pitchfork"));
		bros[1].setStartValuesEx([
			"farmhand_background"
		]);
		bros[1].getBackground().m.RawDescription = "%name% posiadał gospodarstwo rolne, które już dawno zostało zadeptane przez przemarsze niezliczonych armii, wliczając te, dal których sam walczył. Jego \'wierność\' wobec ciebie jest przede wszystkim wynikiem pustego żołądka.";
		bros[1].worsenMood(0.5, "Brał udział w bójce");
		bros[1].addLightInjury();
		local items = bros[1].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/warfork"));
		bros[2].setStartValuesEx([
			"poacher_background"
		]);
		bros[2].getBackground().m.RawDescription = "Powszechnie żartuje się, że %name% tak naprawdę jest szlachcicem ukrywającym się przed światem, jednak z tego co wiesz, był jeno zwykłym kłusownikiem. Nieubłagany los zaprowadził go do miejsca, w którym teraz się znajduje i niewiele można rzec ponad to, że masz nadzieję, iż kiedyś chłopak znów stanie na nogi.";
		bros[2].worsenMood(0.5, "Brał udział w bójce");
		bros[2].addLightInjury();
		local items = bros[2].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/staff_sling"));
		bros[3].setStartValuesEx([
			"vagabond_background",
			"thief_background",
			"gambler_background"
		]);
		bros[3].getBackground().m.RawDescription = "Zauważyłeś, że %name% ukrywa się przed pewnym szlachcicem. Prawdopodobnie jest tylko pospolitym złoczyńcą, któremu upiekło się po drobnym przestępstwie, jednak tak długo, jak dla ciebie walczy, nie jest to twoja sprawa.";
		bros[3].improveMood(1.5, "Ukradł komuś saksa");
		items = bros[3].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/scramasax"));
		bros[4].setStartValuesEx([
			"daytaler_background"
		]);
		bros[4].getBackground().m.RawDescription = "%name%, pospolity robotnik, który chwytał się różnych prac, wolał dołączyć do twojej trupy, zamiast dalej niszczyć swe ciało budując kolejny wyszukany przedsionek dla jakiegoś szlachcica.";
		bros[4].worsenMood(0.5, "Brał udział w bójce");
		bros[4].addLightInjury();
		bros[5].setStartValuesEx([
			"miller_background"
		]);
		bros[5].getBackground().m.RawDescription = "Szukając bogactw, %name% trafił we właściwe miejsce w twoje nowopowstałej bandzie najemników. Niestety, ma doświadczenie tylko w rolnictwie, młynarstwie i układaniu kamieni, a do tego w każdym z tych fachów był beznadziejny.";
		bros[5].improveMood(1.0, "Nie może się doczekać zdobycia bogactw jako najemnik");
		local items = bros[5].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/pitchfork"));
		bros[6].setStartValuesEx([
			"fisherman_background"
		]);
		bros[6].getBackground().m.RawDescription = "%name% twierdzi, że był żeglarzem, zanim przybył w głąb lądu i dołączył do milicji, a teraz do bandy najemników. Ma nadzieję, że w końcu będzie go stać na zakup własnej łodzi, którą z rozpostartymi żaglami wypłynie na szerokie oceany. Ty zaś masz nadzieję, że kiedyś jego marzenie się spełni, naprawdę.";
		bros[6].worsenMood(0.25, "Ostatnio dość słabo się czuje");
		bros[7].setStartValuesEx([
			"militia_background"
		]);
		bros[7].getBackground().m.RawDescription = "%name% najwidoczniej był w wielu różnych milicjach, a każda z nich w końcu z jakiegoś powodu się rozpadła. W żadnej z nich nie zarobił złamanej korony, więc ma ogromną nadzieję, że ta sztuczka z najemnikami zmieni nieco postać rzeczy.";
		bros[7].improveMood(3.0, "Niedawno został ojcem");
		bros[7].m.PerkPoints = 0;
		bros[7].m.LevelUps = 0;
		bros[7].m.Level = 1;
		bros[8].setStartValuesEx([
			"minstrel_background"
		]);
		bros[8].getBackground().m.RawDescription = "%name% to porządny chłopak, który lubi hulać z panienkami w gospodzie i gonić za spódniczkami w kościele. Masz wrażenie, że wlecze się on z wami tylko po to, by rozpowszechnić po świecie swoją wizję tego, co uważa za \'zabawę\'.";
		local items = bros[8].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/lute"));
		bros[9].setStartValuesEx([
			"daytaler_background"
		]);
		bros[9].getBackground().m.RawDescription = "Tragarz, robotnik, pomocnik karawany, żeglarz, milicjant - %name% robił wszystkiego po trochu. Miejmy nadzieję, że przy swoim nowym najemniczym fachu zdoła wytrwać nieco dłużej, niż przy innych.";
		bros[9].worsenMood(1.0, "Ktoś ukradł mu jego zaufanego saksa");
		bros[10].setStartValuesEx([
			"militia_background"
		]);
		bros[10].getBackground().m.RawDescription = "Tak jak i ty sam, %name% miał dość wykorzystywania milicji, by rozwiązywać problemy nieprzygotowanej szlachty. Był zapewne jednym z najpoważniej podchodzących to tej zmiany ekipy w kompanię najemników.";
		bros[10].worsenMood(0.5, "Nie spodobało mu się, że niektórzy członkowie milicji wdali się w bójkę");
		bros[10].m.PerkPoints = 0;
		bros[10].m.LevelUps = 0;
		bros[10].m.Level = 1;
		bros[11].setStartValuesEx([
			"butcher_background",
			"tailor_background",
			"shepherd_background"
		]);
		bros[11].getBackground().m.RawDescription = "%name% rzekomo ucieka od swojej żony. Spotkałeś ją tylko raz, ale w pełni popierasz jego plan ucieczki i to nie tylko dlatego, że daje ci on dodatkowego człowieka w szeregach. Ta dziewucha jest zaiste obłąkana.";
		bros[11].improveMood(1.0, "Zdołał wyrwać się od swej żony");
		this.World.Assets.m.BusinessReputation = -100;
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() + 9);
		this.World.Assets.m.Money = this.World.Assets.m.Money / 2;
		this.World.Assets.m.ArmorParts = this.World.Assets.m.ArmorParts / 2;
		this.World.Assets.m.Medicine = this.World.Assets.m.Medicine / 2;
		this.World.Assets.m.Ammo = this.World.Assets.m.Ammo / 2;
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
		this.World.Flags.set("HomeVillage", randomVillage.getName());
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

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore)
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
		this.World.Assets.updateLook(8);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		randomVillage.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(40.0, "Uważani jesteście za miejscowych bohaterów za zapewnianie bezpieczeństwa wiosce");
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/retirement_01.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.militia_scenario_intro");
		}, null);
	}

	function onInit()
	{
		this.World.Assets.m.BrothersMax = 25;
		this.World.Assets.m.BrothersMaxInCombat = 16;
		this.World.Assets.m.BrothersScaleMax = 14;
	}

	function onUpdateHiringRoster( _roster )
	{
		local garbage = [];
		local bros = _roster.getAll();

		foreach( i, bro in bros )
		{
			if (!bro.getBackground().isLowborn())
			{
				garbage.push(bro);
			}
		}

		foreach( g in garbage )
		{
			_roster.remove(g);
		}
	}

});

