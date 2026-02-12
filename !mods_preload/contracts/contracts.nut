::mods_hookBaseClass("contracts/contract", function ( o )
{
	while (!("getUIBulletpoints" in o))
	{
		o = o[o.SuperName];
	}

	o.getUIBulletpoints = function ( _objectives = true, _payment = true )
	{
		local ret = [];

		if (_objectives && this.m.BulletpointsObjectives.len() != 0)
		{
			local r = {
				title = "Cele",
				items = [],
				fixed = true
			};

			foreach( i, b in this.m.BulletpointsObjectives )
			{
				r.items.push({
					icon = "ui/icons/money.png",
					text = this.buildText(b)
				});
			}

			ret.push(r);
		}

		if (_payment && this.m.BulletpointsPayment.len() != 0)
		{
			local r = {
				title = "Zapłata",
				items = [],
				fixed = true
			};

			foreach( i, b in this.m.BulletpointsPayment )
			{
				r.items.push({
					icon = "ui/icons/money.png",
					text = this.buildText(b)
				});
			}

			ret.push(r);
		}

		return ret;
	};
	o.cancel = function ()
	{
		this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractCancel);

		if (this.m.Faction != 0)
		{
			this.World.FactionManager.getFaction(this.m.Faction).addPlayerRelation(this.Const.World.Assets.RelationContractCancel, "Złamałeś kontrakt");

			if (this.m.Payment.Advance != 0)
			{
				this.World.FactionManager.getFaction(this.m.Faction).addPlayerRelation(this.Const.World.Assets.RelationContractCancelAdvance, "Złamałeś kontrakt");
			}
		}

		this.onCancel();
	};
	o.spawnEnemyPartyAtBase = function ( _factionType, _resources )
	{
		local myTile = this.World.State.getPlayer().getTile();
		local enemyBase = this.World.FactionManager.getFactionOfType(_factionType).getNearestSettlement(myTile);
		local party;

		if (_factionType == this.Const.FactionType.Bandits)
		{
			party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).spawnEntity(enemyBase.getTile(), "Bandyci", false, this.Const.World.Spawn.BanditRaiders, _resources);
			party.setDescription("Szajka zatwardziałych bandytów szukająca pożywienia.");
			party.setFootprintType(this.Const.World.FootprintsType.Brigands);
			party.getLoot().Money = this.Math.rand(50, 100);
			party.getLoot().ArmorParts = this.Math.rand(0, 10);
			party.getLoot().Medicine = this.Math.rand(0, 2);
			party.getLoot().Ammo = this.Math.rand(0, 20);
			local r = this.Math.rand(1, 6);

			if (r == 1)
			{
				party.addToInventory("supplies/bread_item");
			}
			else if (r == 2)
			{
				party.addToInventory("supplies/roots_and_berries_item");
			}
			else if (r == 3)
			{
				party.addToInventory("supplies/dried_fruits_item");
			}
			else if (r == 4)
			{
				party.addToInventory("supplies/ground_grains_item");
			}
			else if (r == 5)
			{
				party.addToInventory("supplies/pickled_mushrooms_item");
			}
		}
		else if (_factionType == this.Const.FactionType.Goblins)
		{
			party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).spawnEntity(enemyBase.getTile(), "Gobliny NajeЄdЄcy", false, this.Const.World.Spawn.GoblinRaiders, _resources);
			party.setDescription("Banda złośliwych goblinów, małych, acz przebiegłych i których nigdy nie można lekceważyć.");
			party.setFootprintType(this.Const.World.FootprintsType.Goblins);
			party.getLoot().ArmorParts = this.Math.rand(0, 10);
			party.getLoot().Medicine = this.Math.rand(0, 2);
			party.getLoot().Ammo = this.Math.rand(0, 30);

			if (this.Math.rand(1, 100) <= 75)
			{
				local loot = [
					"supplies/strange_meat_item",
					"supplies/roots_and_berries_item",
					"supplies/pickled_mushrooms_item"
				];
				party.addToInventory(loot[this.Math.rand(0, loot.len() - 1)]);
			}

			if (this.Math.rand(1, 100) <= 33)
			{
				local loot = [
					"loot/goblin_carved_ivory_iconographs_item",
					"loot/goblin_minted_coins_item",
					"loot/goblin_rank_insignia_item"
				];
				party.addToInventory(loot[this.Math.rand(0, loot.len() - 1)]);
			}
		}
		else if (_factionType == this.Const.FactionType.Orcs)
		{
			party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).spawnEntity(enemyBase.getTile(), "Orkowie Maruderzy", false, this.Const.World.Spawn.OrcRaiders, _resources);
			party.setDescription("Banda złowrogich orków, zielonoskórych i górujących nad każdym człowiekiem.");
			party.setFootprintType(this.Const.World.FootprintsType.Orcs);
			party.getLoot().ArmorParts = this.Math.rand(0, 25);
			party.getLoot().Ammo = this.Math.rand(0, 10);
			party.addToInventory("supplies/strange_meat_item");
		}
		else if (_factionType == this.Const.FactionType.Undead)
		{
			party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).spawnEntity(enemyBase.getTile(), "Nieumarli", false, this.Const.World.Spawn.UndeadArmy, _resources);
			party.setDescription("Legion chodzących trupów, które powróciły, aby odebrać żywym to, co niegdyś należało do nich.");
			party.setFootprintType(this.Const.World.FootprintsType.Undead);
			party.getLoot().ArmorParts = this.Math.rand(0, 10);
			party.getLoot().Ammo = this.Math.rand(0, 5);
		}
		else if (_factionType == this.Const.FactionType.Zombies)
		{
			party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).spawnEntity(enemyBase.getTile(), "Nieumarli", false, this.Const.World.Spawn.Necromancer, _resources);
			party.setDescription("Coś wydaje się nie w porządku.");
			party.setFootprintType(this.Const.World.FootprintsType.Undead);
			party.getLoot().ArmorParts = this.Math.rand(0, 10);
			party.getLoot().Ammo = this.Math.rand(0, 5);
		}

		party.getSprite("banner").setBrush(enemyBase.getBanner());
		this.m.UnitsSpawned.push(party.getID());
		return party;
	};
});

