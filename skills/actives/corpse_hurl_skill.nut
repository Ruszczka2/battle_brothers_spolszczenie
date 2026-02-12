this.corpse_hurl_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.corpse_hurl_skill";
		this.m.Name = "Rzut Zwłokami";
		this.m.Description = "";
		this.m.KilledString = "Zmiażdżony";
		this.m.Icon = "skills/active_233.png";
		this.m.IconDisabled = "skills/active_233.png";
		this.m.Overlay = "active_233";
		this.m.SoundOnUse = [
			"sounds/enemies/big_golem_windup_01.wav",
			"sounds/enemies/big_golem_windup_02.wav",
			"sounds/enemies/big_golem_windup_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/corpse_throw_impact_01.wav",
			"sounds/enemies/corpse_throw_impact_02.wav",
			"sounds/enemies/corpse_throw_impact_03.wav",
			"sounds/enemies/corpse_throw_impact_04.wav"
		];
		this.m.SoundOnHitDelay = 0;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 600;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsAOE = true;
		this.m.IsUsingActorPitch = true;
		this.m.IsSpearwallRelevant = false;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.4;
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 30;
		this.m.MinRange = 2;
		this.m.MaxRange = 4;
		this.m.MaxLevelDifference = 3;
		this.m.IsShowingProjectile = true;
		this.m.ProjectileType = this.Const.ProjectileType.Corpse;
		this.m.ProjectileTimeScale = 1.33;
		this.m.IsProjectileRotated = true;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 66;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin += 55;
			_properties.DamageRegularMax += 65;
			_properties.DamageArmorMult *= 1.1;
		}
	}

	function onUse( _user, _targetTile )
	{
		local user = this.m.Container.getActor();
		this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], 1.0, _targetTile.Pos);

		if (_targetTile.IsOccupiedByActor)
		{
			this.attackEntity(user, _targetTile.getEntity());
		}
		else if (this.m.IsShowingProjectile && this.m.ProjectileType != 0)
		{
			local flip = !this.m.IsProjectileRotated && _targetTile.Pos.X > user.getPos().X;

			if (user.getTile().getDistanceTo(_targetTile) >= this.Const.Combat.SpawnProjectileMinDist)
			{
				this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], user.getTile(), _targetTile, 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
			}
		}

		this.Time.scheduleEvent(this.TimeUnit.Virtual, 350, this.onRelease.bindenv(this), {
			Skill = this,
			TargetTile = _targetTile
		});
		return true;
	}

	function onRelease( _data )
	{
		local user = _data.Skill.getContainer().getActor();
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(user) + " rzuca zwłokami");
		local targetTiles = [
			_data.TargetTile
		];
		local corpseSpawnTile;

		for( local i = 0; i < 6; i = i )
		{
			if (!_data.TargetTile.hasNextTile(i))
			{
			}
			else
			{
				targetTiles.push(_data.TargetTile.getNextTile(i));
			}

			i = ++i;
		}

		if (!_data.TargetTile.IsCorpseSpawned)
		{
			corpseSpawnTile = _data.TargetTile;
		}

		foreach( tile in targetTiles )
		{
			if (tile.IsOccupiedByActor)
			{
				local hitInfo = clone this.Const.Tactical.HitInfo;
				hitInfo.DamageRegular = this.Math.rand(20, 40);
				hitInfo.DamageArmor = hitInfo.DamageRegular * 0.5;
				hitInfo.DamageDirect = 0.25;
				hitInfo.BodyPart = 0;
				hitInfo.FatalityChanceMult = 0.0;
				hitInfo.Injuries = this.Const.Injury.BluntBody;
				tile.getEntity().onDamageReceived(null, this, hitInfo);
				this.Tactical.getShaker().shake(tile.getEntity(), tile, 7);
			}
			else if (corpseSpawnTile == null && !tile.IsCorpseSpawned)
			{
				corpseSpawnTile = tile;
			}
		}

		if (corpseSpawnTile != null)
		{
			this.spawnCorpse(user, corpseSpawnTile);
		}
	}

	function spawnCorpse( _user, _tile )
	{
		if (_tile == null)
		{
			return;
		}

		local flip = this.Math.rand(1, 100) < 50;
		local decal;
		decal = _tile.spawnDetail("bust_flesh_golem_body_01_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
		decal.Scale = 0.9;
		decal.setBrightness(0.9);
		local head_brushes = [
			"bust_flesh_golem_head_01_dead",
			"bust_flesh_golem_head_02_dead",
			"bust_flesh_golem_head_03_dead"
		];
		decal = _tile.spawnDetail(head_brushes[this.Math.rand(0, head_brushes.len() - 1)], this.Const.Tactical.DetailFlag.Corpse, flip);
		decal.Scale = 0.9;
		decal.setBrightness(0.9);
		_user.spawnTerrainDropdownEffect(_tile);
		local corpse = clone this.Const.Corpse;
		corpse.CorpseName = "A Fleshy Corpse";
		corpse.Tile = _tile;
		corpse.IsResurrectable = false;
		corpse.IsConsumable = true;
		corpse.IsHeadAttached = false;
		_tile.Properties.set("Corpse", corpse);
		this.Tactical.Entities.addCorpse(_tile);
	}

});

