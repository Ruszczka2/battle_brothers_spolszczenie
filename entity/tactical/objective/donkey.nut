this.donkey <- this.inherit("scripts/entity/tactical/actor", {
	m = {},
	function create()
	{
		this.m.IsActingEachTurn = false;
		this.m.IsNonCombatant = true;
		this.m.IsShakingOnHit = false;
		this.m.Type = this.Const.EntityType.CaravanDonkey;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.XP = this.Const.Tactical.Actor.Donkey.XP;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.actor.create();
		this.m.Name = "Osioł z Karawany";
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/misc/donkey_hurt_01.wav",
			"sounds/misc/donkey_hurt_02.wav",
			"sounds/misc/donkey_hurt_03.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/misc/donkey_death_01.wav",
			"sounds/misc/donkey_death_02.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/misc/donkey_idle_01.wav",
			"sounds/misc/donkey_idle_02.wav",
			"sounds/misc/donkey_idle_03.wav",
			"sounds/misc/donkey_idle_04.wav",
			"sounds/misc/donkey_idle_05.wav",
			"sounds/misc/donkey_idle_06.wav",
			"sounds/misc/donkey_idle_07.wav",
			"sounds/misc/donkey_idle_08.wav"
		];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Idle] = 0.35;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/donkey_agent");
		this.m.AIAgent.setActor(this);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		local flip = this.Math.rand(0, 100) < 50;

		if (_tile != null)
		{
			local decal;
			local skin = this.getSprite("body");
			decal = _tile.spawnDetail("donkey_tactical_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = skin.Color;
			decal.Saturation = skin.Saturation;

			if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Arrow)
			{
				_tile.spawnDetail("donkey_tactical_dead_arrows", this.Const.Tactical.DetailFlag.Corpse, flip);
			}
			else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Javelin)
			{
				_tile.spawnDetail("donkey_tactical_dead_javelin", this.Const.Tactical.DetailFlag.Corpse, flip);
			}

			this.spawnTerrainDropdownEffect(_tile);
		}

		local tileLoot = this.getLootForTile(_killer, []);
		local corpse = this.generateCorpse(_tile, _fatalityType, _killer);
		this.dropLoot(_tile, tileLoot, !flip);

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
		if (_killer == null || _killer.getFaction() == this.Const.Faction.Player || _killer.getFaction() == this.Const.Faction.PlayerAnimals)
		{
			_loot.push(this.new("scripts/items/supplies/strange_meat_item"));
		}

		return this.actor.getLootForTile(_killer, _loot);
	}

	function generateCorpse( _tile, _fatalityType, _killer )
	{
		local corpse = clone this.Const.Corpse;
		corpse.CorpseName = "Osioł";
		corpse.Value = 1.0;
		corpse.IsResurrectable = false;
		corpse.IsConsumable = true;
		corpse.IsHeadAttached = true;

		if (_tile != null)
		{
			corpse.Tile = _tile;
		}

		return corpse;
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		_hitInfo.BodyPart = this.Const.BodyPart.Body;
		return this.actor.onDamageReceived(_attacker, _skill, _hitInfo);
	}

	function setFlipped( _f )
	{
		this.getSprite("body").setHorizontalFlipping(_f);
		this.getSprite("injury").setHorizontalFlipping(_f);
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Donkey);
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToRoot = true;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToHeadshots = true;
		b.IsAffectedByInjuries = false;
		b.IsAffectedByNight = false;
		b.IsMovable = false;
		b.TargetAttractionMult = 1.1;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		local body = this.addSprite("body");
		body.setBrush("donkey_tactical");
		body.varySaturation(0.4);
		body.varyColor(0.035, 0.035, 0.035);
		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("donkey_tactical_injured");
		this.addDefaultStatusSprites();
		this.m.Skills.update();
	}

	function onPlacedOnMap()
	{
		this.actor.onPlacedOnMap();
		local directionPriority = [
			this.Const.Direction.NW,
			this.Const.Direction.NE,
			this.Const.Direction.N,
			this.Const.Direction.SW,
			this.Const.Direction.S,
			this.Const.Direction.SE
		];
		local myTile = this.getTile();
		local tile;
		local dir = -1;

		for( local i = 0; i < 6; i = i )
		{
			if (!myTile.hasNextTile(directionPriority[i]))
			{
			}
			else
			{
				local nextTile = myTile.getNextTile(directionPriority[i]);

				if (!nextTile.IsEmpty || this.Math.abs(nextTile.Level - myTile.Level) > 1)
				{
				}
				else
				{
					tile = nextTile;
					dir = i;
					break;
				}
			}

			i = ++i;
		}

		if (tile != null)
		{
			local cart = this.Tactical.spawnEntity("scripts/entity/tactical/objects/cart", tile.Coords);

			if (directionPriority[dir] == this.Const.Direction.NE)
			{
				cart.setFlipped(true);
				this.setFlipped(true);
			}
			else if (directionPriority[dir] == this.Const.Direction.SE)
			{
				cart.setFlipped(true);
			}
		}
	}

});

