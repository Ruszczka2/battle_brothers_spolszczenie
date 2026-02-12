this.lesser_flesh_golem <- this.inherit("scripts/entity/tactical/actor", {
	m = {
		IsCreatingAgent = true
	},
	function create()
	{
		this.m.Type = this.Const.EntityType.LesserFleshGolem;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.XP = this.Const.Tactical.Actor.LesserFleshGolem.XP;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(33, -26);
		this.m.DecapitateBloodAmount = 0.8;
		this.m.BloodPoolScale = 0.8;
		this.actor.create();
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/small_golem_death_01.wav",
			"sounds/enemies/small_golem_death_02.wav",
			"sounds/enemies/small_golem_death_03.wav",
			"sounds/enemies/small_golem_death_04.wav",
			"sounds/enemies/small_golem_death_05.wav",
			"sounds/enemies/small_golem_death_06.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/small_golem_hurt_01.wav",
			"sounds/enemies/small_golem_hurt_02.wav",
			"sounds/enemies/small_golem_hurt_03.wav",
			"sounds/enemies/small_golem_hurt_04.wav",
			"sounds/enemies/small_golem_hurt_05.wav",
			"sounds/enemies/small_golem_hurt_06.wav",
			"sounds/enemies/small_golem_hurt_07.wav",
			"sounds/enemies/small_golem_hurt_08.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/small_golem_idle_01.wav",
			"sounds/enemies/small_golem_idle_02.wav",
			"sounds/enemies/small_golem_idle_03.wav",
			"sounds/enemies/small_golem_idle_04.wav",
			"sounds/enemies/small_golem_idle_05.wav",
			"sounds/enemies/small_golem_idle_06.wav",
			"sounds/enemies/small_golem_idle_07.wav",
			"sounds/enemies/small_golem_idle_08.wav",
			"sounds/enemies/small_golem_idle_09.wav",
			"sounds/enemies/small_golem_idle_10.wav"
		];
		this.m.SoundPitch = this.Math.rand(0.9, 1.1);
		this.m.SoundVolumeOverall = 1.25;
		this.getFlags().add("undead");
		this.getFlags().add("flesh_golem");

		if (this.m.IsCreatingAgent)
		{
			this.m.AIAgent = this.new("scripts/ai/tactical/agents/lesser_flesh_golem_agent");
			this.m.AIAgent.setActor(this);
		}
	}

	function playSound( _type, _volume, _pitch = 1.0 )
	{
		if (_type == this.Const.Sound.ActorEvent.Move && this.Math.rand(1, 100) <= 50)
		{
			return;
		}

		this.actor.playSound(_type, _volume, _pitch);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		local flip = this.Math.rand(1, 100) < 50;

		if (_tile != null)
		{
			this.m.IsCorpseFlipped = flip;
			this.spawnBloodPool(_tile, 1);
			local decal;
			local appearance = this.getItems().getAppearance();
			local sprite_body = this.getSprite("body");
			local sprite_head = this.getSprite("head");
			decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = sprite_body.Color;
			decal.Saturation = sprite_body.Saturation;
			decal.Scale = 0.9;
			decal.setBrightness(0.9);

			if (appearance.CorpseArmor != "")
			{
				decal = _tile.spawnDetail(appearance.CorpseArmor, this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
				decal.setBrightness(0.9);
			}

			if (_fatalityType != this.Const.FatalityType.Decapitated)
			{
				if (!appearance.HideCorpseHead)
				{
					decal = _tile.spawnDetail(sprite_head.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
					decal.Color = sprite_head.Color;
					decal.Saturation = sprite_head.Saturation;
					decal.Scale = 0.9;
					decal.setBrightness(0.9);
				}

				if (appearance.HelmetCorpse.len() != 0)
				{
					decal = _tile.spawnDetail(appearance.HelmetCorpse, this.Const.Tactical.DetailFlag.Corpse, flip);
					decal.Scale = 0.9;
					decal.setBrightness(0.9);
				}
			}
			else if (_fatalityType == this.Const.FatalityType.Decapitated)
			{
				local layers = [];

				if (!appearance.HideCorpseHead)
				{
					layers.push(sprite_head.getBrush().Name + "_dead");
				}

				if (appearance.HelmetCorpse.len() != 0)
				{
					layers.push(appearance.HelmetCorpse);
				}

				local decap = this.Tactical.spawnHeadEffect(this.getTile(), layers, this.createVec(-75, 50), 90.0, sprite_head.getBrush().Name + "_dead_bloodpool");
				local idx = 0;

				if (!appearance.HideCorpseHead)
				{
					decap[idx].Color = sprite_head.Color;
					decap[idx].Saturation = sprite_head.Saturation;
					decap[idx].Scale = 0.9;
					decap[idx].setBrightness(0.9);
					idx = ++idx;
					idx = idx;
				}

				if (appearance.HelmetCorpse.len() != 0)
				{
					decap[idx].Scale = 0.9;
					decap[idx].setBrightness(0.9);
					idx = ++idx;
					idx = idx;
				}
			}

			if (_fatalityType == this.Const.FatalityType.Disemboweled)
			{
				decal = _tile.spawnDetail("guts_flesh_golem_body_02_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
			}
			else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Arrow)
			{
				decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead_arrows", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
			}
			else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Javelin)
			{
				decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead_javelin", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
			}

			this.spawnTerrainDropdownEffect(_tile);
		}

		local deathLoot = this.getItems().getDroppableLoot(_killer);
		local tileLoot = this.getLootForTile(_killer, deathLoot);
		this.dropLoot(_tile, tileLoot, !flip);
		local corpse = this.generateCorpse(_tile, _fatalityType, _killer);

		if (_tile == null)
		{
			this.Tactical.Entities.addUnplacedCorpse(corpse);
		}
		else
		{
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);
		}

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function getLootForTile( _killer, _loot )
	{
		local potentialWeaponDrops = [];
		local mainhand = this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand);

		if (mainhand != null)
		{
			switch(mainhand.getID())
			{
			case "weapon.golem_cleaver_hammer":
				potentialWeaponDrops.push("butchers_cleaver");
				potentialWeaponDrops.push("pickaxe");
				break;

			case "weapon.golem_mace_flail":
				potentialWeaponDrops.push("bludgeon");
				potentialWeaponDrops.push("reinforced_wooden_flail");
				break;

			case "weapon.golem_mace_hammer":
				potentialWeaponDrops.push("bludgeon");
				potentialWeaponDrops.push("pickaxe");
				break;

			case "weapon.golem_spear_sword":
				potentialWeaponDrops.push("militia_spear");
				potentialWeaponDrops.push("shortsword");
				break;
			}
		}

		foreach( weapon in potentialWeaponDrops )
		{
			local r = this.Math.rand(1, 100);

			if (r <= 80)
			{
				local item = this.new("scripts/items/weapons/" + weapon);
				item.setCondition(this.Math.rand(1, this.Math.max(1, item.getConditionMax() - 2)) * 1.0);

				if (item.isDroppedAsLoot())
				{
					_loot.push(item);
				}
			}
		}

		return this.actor.getLootForTile(_killer, _loot);
	}

	function generateCorpse( _tile, _fatalityType, _killer )
	{
		local corpse = clone this.Const.Corpse;
		corpse.CorpseName = "Cielisty Golem";
		corpse.IsResurrectable = false;
		corpse.IsConsumable = true;
		corpse.Items = this.getItems().prepareItemsForCorpse(_killer);
		corpse.IsHeadAttached = _fatalityType != this.Const.FatalityType.Decapitated;

		if (_tile != null)
		{
			corpse.Tile = _tile;
		}

		return corpse;
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.LesserFleshGolem);
		b.IsImmuneToDisarm = true;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.m.Items.getAppearance().Body = "bust_flesh_golem_body_01";
		this.addSprite("socket").setBrush("bust_base_undead");
		local body = this.addSprite("body");
		body.setBrush("bust_flesh_golem_body_01");
		body.varySaturation(0.1);
		body.varyColor(0.09, 0.09, 0.09);
		local injury_body = this.addSprite("injury");
		injury_body.Visible = false;
		injury_body.setBrush("bust_flesh_golem_body_01_injured");
		this.addSprite("armor");
		local head = this.addSprite("head");
		head.setBrush("bust_flesh_golem_head_0" + this.Math.rand(1, 3));
		head.Saturation = body.Saturation;
		head.Color = body.Color;
		this.addSprite("helmet");
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.45;
		this.setSpriteOffset("status_rooted", this.createVec(-4, 7));
		this.m.Skills.add(this.new("scripts/skills/racial/flesh_golem_racial"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_underdog"));
	}

	function assignRandomEquipment()
	{
		this.m.Items.equip(this.new("scripts/items/helmets/golems/flesh_golem_facewrap"));
		this.m.Items.equip(this.new("scripts/items/armor/golems/flesh_golem_robes"));
		local r = this.Math.rand(0, 3);

		if (r == 0)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/golems/golem_mace_hammer"));
		}
		else if (r == 1)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/golems/golem_cleaver_hammer"));
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/golems/golem_mace_flail"));
		}
		else if (r == 3)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/golems/golem_spear_sword"));
		}
	}

});

