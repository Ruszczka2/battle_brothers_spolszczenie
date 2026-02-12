this.gladiators_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.gladiators";
		this.m.Name = "Gladiatorzy";
		this.m.Description = "[p=c][img]gfx/ui/events/event_155.png[/img][/p][p]Walczyłeś na arenach południa od wielu lat. Najpierw za swą wolność, później dla koron, a ostatecznie, by stać się nieśmiertelnym. Cóż jeszcze ma dla ciebie w zanadrzu los?\n\n[color=#bcad8c]Gladiatorzy:[/color] Zaczynasz z trzema doświadczonymi gladiatorami i dobrym wyposażeniem, ale z bardzo wysokim dziennym żołdem.\n[color=#bcad8c]Legendy Areny:[/color] Każdy z gladiatorów ma unikalną cechę w bitwie.\n[color=#bcad8c]Wspaniała Trójca:[/color] Nie możesz mieć w szeregach więcej niż 12 ludzi, a jeśli wszyscy trzej z twoich początkowych gladiatorów polegną, twoja kampania się zakończy.[/p]";
		this.m.Difficulty = 3;
		this.m.Order = 100;
		this.m.IsFixedLook = true;
	}

	function isValid()
	{
		return this.Const.DLC.Desert;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();

		for( local i = 0; i < 3; i = i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.setStartValuesEx([
				"gladiator_origin_background"
			]);
			bro.getSkills().removeByID("trait.survivor");
			bro.getSkills().removeByID("trait.greedy");
			bro.getSkills().removeByID("trait.loyal");
			bro.getSkills().removeByID("trait.disloyal");
			bro.getSkills().add(this.new("scripts/skills/traits/arena_fighter_trait"));
			bro.getFlags().set("ArenaFightsWon", 5);
			bro.getFlags().set("ArenaFights", 5);
			bro.setPlaceInFormation(3 + i);
			bro.getFlags().set("IsPlayerCharacter", true);
			bro.getSprite("miniboss").setBrush("bust_miniboss_gladiators");
			bro.m.HireTime = this.Time.getVirtualTimeF();
			bro.m.PerkPoints = 2;
			bro.m.LevelUps = 2;
			bro.m.Level = 3;
			bro.m.Talents = [];
			bro.m.Attributes = [];
			i = ++i;
		}

		local bros = roster.getAll();
		local a;
		local u;
		bros[0].setTitle("Lew");
		bros[0].getSkills().add(this.new("scripts/skills/traits/glorious_resolve_trait"));
		bros[0].getTalents().resize(this.Const.Attributes.COUNT, 0);
		bros[0].getTalents()[this.Const.Attributes.MeleeDefense] = 2;
		bros[0].getTalents()[this.Const.Attributes.Fatigue] = 2;
		bros[0].getTalents()[this.Const.Attributes.MeleeSkill] = 3;
		bros[0].fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		a = this.new("scripts/items/armor/oriental/gladiator_harness");
		a.setUpgrade(this.new("scripts/items/armor_upgrades/light_gladiator_upgrade"));
		bros[0].getItems().equip(a);
		a = this.new("scripts/items/helmets/oriental/gladiator_helmet");
		a.setVariant(13);
		bros[0].getItems().equip(a);
		bros[0].getItems().equip(this.new("scripts/items/weapons/scimitar"));
		bros[0].getItems().equip(this.new("scripts/items/tools/throwing_net"));
		bros[0].improveMood(0.75, "Nie może się doczekać, by dowieść swej wartości poza areną");
		bros[1].setTitle("Niedźwiedź");
		bros[1].getSkills().add(this.new("scripts/skills/traits/glorious_endurance_trait"));
		bros[1].getTalents().resize(this.Const.Attributes.COUNT, 0);
		bros[1].getTalents()[this.Const.Attributes.Hitpoints] = 3;
		bros[1].getTalents()[this.Const.Attributes.Fatigue] = 2;
		bros[1].getTalents()[this.Const.Attributes.Bravery] = 2;
		bros[1].fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		a = this.new("scripts/items/armor/oriental/gladiator_harness");
		a.setUpgrade(this.new("scripts/items/armor_upgrades/heavy_gladiator_upgrade"));
		bros[1].getItems().equip(a);
		a = this.new("scripts/items/helmets/oriental/gladiator_helmet");
		a.setVariant(15);
		bros[1].getItems().equip(a);
		bros[1].getItems().equip(this.new("scripts/items/weapons/oriental/heavy_southern_mace"));
		bros[1].getItems().equip(this.new("scripts/items/shields/oriental/metal_round_shield"));
		bros[1].improveMood(0.75, "Nie może się doczekać, by dowieść swej wartości poza areną");
		bros[2].setTitle("Żmija");
		bros[2].getSkills().add(this.new("scripts/skills/traits/glorious_quickness_trait"));
		bros[2].getTalents().resize(this.Const.Attributes.COUNT, 0);
		bros[2].getTalents()[this.Const.Attributes.MeleeDefense] = 2;
		bros[2].getTalents()[this.Const.Attributes.Initiative] = 3;
		bros[2].getTalents()[this.Const.Attributes.MeleeSkill] = 2;
		bros[2].fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		a = this.new("scripts/items/armor/oriental/gladiator_harness");
		a.setUpgrade(this.new("scripts/items/armor_upgrades/light_gladiator_upgrade"));
		bros[2].getItems().equip(a);
		a = this.new("scripts/items/helmets/oriental/gladiator_helmet");
		a.setVariant(14);
		bros[2].getItems().equip(a);
		bros[2].getItems().equip(this.new("scripts/items/weapons/oriental/qatal_dagger"));
		bros[2].getItems().equip(this.new("scripts/items/tools/throwing_net"));
		bros[2].improveMood(0.75, "Nie może się doczekać, by dowieść swej wartości poza areną");
		bros[0].getBackground().m.RawDescription = "{%fullname% twierdzi, że muskuły zapewniają mu sławę. Bzdury. Kapitanie, to ja, " + bros[2].getName() + ", władam damami tego królestwa. Nie pytaj mnie jak. Patrz! Przyjrzyj się! Spójrz na ich rozmiar! Tak. Tak właśnie myślałem. Głupcy, ćwiczcie ile chcecie, nigdy nie osiągniecie tego!}";
		bros[0].getBackground().buildDescription(true);
		bros[1].getBackground().m.RawDescription = "{%fullname% nie jest tu najlepszym wojownikiem, jasno to sobie powiedzmy. Kapitanie, spójrz na moje muskuły, czy to nie ja, " + bros[0].getName() + ", jestem panem największej daru w życiu: strachu swoich wrogów! Spójrz, gdy je namydlę lekko i padnie na nie światło, me mięśnie lśnią. Czyż to nie tak, że omylnie niebios szuka się w górze, podczas gdy wszystkie kobiety mówią, że znalazły je tutaj, dokładnie tu, na mojej klacie?}";
		bros[1].getBackground().buildDescription(true);
		bros[2].getBackground().m.RawDescription = "{Dlaczego %fullname% tak przyciąga twój wzrok? Kapitanie, to ja, " + bros[1].getName() + ", jestem twym najwspanialszym gladiatorem. To ja odciąłem łapy lidwurma i udusiłem go jego własnym ogonem! Co wy tam mruczycie, bękarty? Że to niby bujda? Pah! To jeno pionowy gad.}";
		bros[2].getBackground().buildDescription(true);
		this.World.Assets.m.BusinessReputation = 100;
		this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() - 9);
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/dried_lamb_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/wine_item"));
		this.World.Assets.m.Money = this.World.Assets.m.Money / 2 - (this.World.Assets.getEconomicDifficulty() == 0 ? 0 : 300);
		this.World.Assets.m.ArmorParts = this.World.Assets.m.ArmorParts / 2;
		this.World.Assets.m.Medicine = this.World.Assets.m.Medicine / 2;
		this.World.Assets.m.Ammo = 0;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isIsolatedFromRoads() && randomVillage.isSouthern() && randomVillage.hasBuilding("building.arena"))
			{
				break;
			}

			i = ++i;
		}

		local randomVillageTile = randomVillage.getTile();

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 1), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 1));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 1), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 1));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) == 0)
				{
				}
				else if (!tile.HasRoad)
				{
				}
				else
				{
					randomVillageTile = tile;
					break;
				}
			}
		}
		while (1);

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(16);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/worldmap_11.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.gladiators_scenario_intro");
		}, null);
	}

	function onInit()
	{
		this.World.Assets.m.BrothersMax = 12;
	}

	function onCombatFinished()
	{
		local roster = this.World.getPlayerRoster().getAll();
		local gladiators = 0;

		foreach( bro in roster )
		{
			if (bro.getFlags().get("IsPlayerCharacter"))
			{
				gladiators = ++gladiators;
				gladiators = gladiators;
			}
		}

		if (gladiators == 2 && !this.World.Flags.get("GladiatorsOriginDeath2"))
		{
			this.World.Flags.set("GladiatorsOriginDeath2", true);

			foreach( bro in roster )
			{
				if (bro.getFlags().get("IsPlayerCharacter"))
				{
					bro.getBackground().m.RawDescription = "{%fullname% smuci się utratą dobrego przyjaciela, lecz patrzy w przyszłość, wiedząc, że cały czas ktoś stoi za jego plecami. Za jego plecami w sensie braterskim, naturalnie. I duchowym. Braterskim i duchowym, tylko i wyłącznie.}";
					bro.getBackground().buildDescription(true);
				}
			}
		}
		else if (gladiators == 1 && !this.World.Flags.get("GladiatorsOriginDeath1"))
		{
			this.World.Flags.set("GladiatorsOriginDeath1", true);

			foreach( bro in roster )
			{
				if (bro.getFlags().get("IsPlayerCharacter"))
				{
					bro.getBackground().m.RawDescription = "{Musisz coś wiedzieć, kapitanie. Cieszę się, że nie mieszałeś się do bójki. Tak żywy nie czułem się o jakichś dziesięciu lat. I jeśli zobaczysz, jak w trakcie boju padam, ani waż się ruszyć, bo będę dokładnie tam, gdzie chcę być.}";
					bro.getBackground().buildDescription(true);
				}
			}
		}

		return gladiators != 0;
	}

});

