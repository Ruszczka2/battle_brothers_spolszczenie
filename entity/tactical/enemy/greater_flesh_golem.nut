this.greater_flesh_golem <- this.inherit("scripts/entity/tactical/actor", {
	m = {},
	function create()
	{
		this.m.Type = this.Const.EntityType.GreaterFleshGolem;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.XP = this.Const.Tactical.Actor.GreaterFleshGolem.XP;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(40, -20);
		this.m.DecapitateBloodAmount = 3.0;
		this.m.ExcludedInjuries = [
			"injury.sprained_ankle",
			"injury.injured_knee_cap",
			"injury.inhaled_flames",
			"injury.dislocated_shoulder",
			"injury.cut_achilles_tendon",
			"injury.burnt_legs",
			"injury.bruised_leg",
			"injury.broken_leg"
		];
		this.actor.create();
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/big_golem_death_01.wav",
			"sounds/enemies/big_golem_death_02.wav",
			"sounds/enemies/big_golem_death_03.wav",
			"sounds/enemies/big_golem_death_04.wav",
			"sounds/enemies/big_golem_death_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/big_golem_hurt_01.wav",
			"sounds/enemies/big_golem_hurt_02.wav",
			"sounds/enemies/big_golem_hurt_03.wav",
			"sounds/enemies/big_golem_hurt_04.wav",
			"sounds/enemies/big_golem_hurt_05.wav",
			"sounds/enemies/big_golem_hurt_06.wav",
			"sounds/enemies/big_golem_hurt_07.wav",
			"sounds/enemies/big_golem_hurt_08.wav",
			"sounds/enemies/big_golem_hurt_09.wav",
			"sounds/enemies/big_golem_hurt_10.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/big_golem_idle_01.wav",
			"sounds/enemies/big_golem_idle_02.wav",
			"sounds/enemies/big_golem_idle_03.wav",
			"sounds/enemies/big_golem_idle_04.wav",
			"sounds/enemies/big_golem_idle_05.wav",
			"sounds/enemies/big_golem_idle_06.wav"
		];
		this.m.SoundPitch = this.Math.rand(0.9, 1.1);
		this.m.SoundVolumeOverall = 1.25;
		this.getFlags().add("undead");
		this.getFlags().add("flesh_golem");
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/greater_flesh_golem_agent");
		this.m.AIAgent.setActor(this);
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
		local skillsToClear = [
			"actives.flurry_skill",
			"actives.spike_skill",
			"actives.corpse_hurl_skill"
		];

		foreach( skillID in skillsToClear )
		{
			if (this.getSkills().hasSkill(skillID) && "clearAffectedTiles" in this.getSkills().getSkillByID(skillID))
			{
				this.getSkills().getSkillByID(skillID).clearAffectedTiles();
			}
		}

		local flip = this.Math.rand(1, 100) < 50;

		if (_tile != null)
		{
			this.m.IsCorpseFlipped = flip;
			this.spawnBloodPool(_tile, 1);
			local decal;
			local appearance = this.getItems().getAppearance();
			local sprite_body = this.getSprite("body");
			local sprite_head = this.getSprite("head");
			decal = _tile.spawnDetail("bust_greater_flesh_golem_body_01_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
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

	function generateCorpse( _tile, _fatalityType, _killer )
	{
		local corpse = clone this.Const.Corpse;
		corpse.CorpseName = "Większy Cielisty Golem";
		corpse.Tile = _tile;
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
		b.setValues(this.Const.Tactical.Actor.GreaterFleshGolem);
		b.IsImmuneToDisarm = true;
		b.IsImmuneToRotation = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToKnockBackAndGrab = true;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.addSprite("socket").setBrush("bust_base_undead");
		this.addSprite("body");
		this.addSprite("injury");
		this.addSprite("armor");
		this.addSprite("head");
		this.addSprite("helmet");
		local variant = this.Math.rand(1, 3);
		this.setVariant(variant);
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", this.createVec(-10, 16));
		this.setSpriteOffset("status_stunned", this.createVec(0, 10));
		this.setSpriteOffset("arrow", this.createVec(0, 10));
		this.m.Skills.add(this.new("scripts/skills/racial/flesh_golem_racial"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_underdog"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_hold_out"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fearsome"));
		this.m.Skills.add(this.new("scripts/skills/actives/greater_flesh_golem_attack_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/flurry_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/spike_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/corpse_hurl_skill"));
	}

	function setVariant( variant )
	{
		local body_brush_name = "bust_greater_flesh_golem_body_0" + variant;
		local head_brush_name = "bust_greater_flesh_golem_head_0" + variant;
		this.assignEquipment(variant);
		this.m.Items.getAppearance().Body = body_brush_name;
		local body = this.getSprite("body");
		body.setBrush(body_brush_name);
		body.varySaturation(0.1);
		body.varyColor(0.09, 0.09, 0.09);
		local injury_body = this.getSprite("injury");
		injury_body.Visible = false;
		injury_body.setBrush(body_brush_name + "_injured");
		local head = this.getSprite("head");
		head.setBrush(head_brush_name);
		head.Saturation = body.Saturation;
		head.Color = body.Color;
		this.setDirty(true);
	}

	function assignEquipment( variant )
	{
		this.m.Items.unequip(this.m.Items.getItemAtSlot(this.Const.ItemSlot.Head));
		this.m.Items.unequip(this.m.Items.getItemAtSlot(this.Const.ItemSlot.Body));
		this.m.Items.equip(this.new("scripts/items/helmets/golems/greater_flesh_golem_helmet_0" + variant));
		this.m.Items.equip(this.new("scripts/items/armor/golems/greater_flesh_golem_armor_0" + variant));
	}

});

