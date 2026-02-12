this.flurry_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.flurry_skill";
		this.m.Name = "Burza Ciosów";
		this.m.Description = "";
		this.m.KilledString = "Zatłuczony na śmierć";
		this.m.Icon = "skills/active_229.png";
		this.m.IconDisabled = "skills/active_229.png";
		this.m.Overlay = "active_229";
		this.m.SoundOnUse = [
			"sounds/enemies/big_golem_windup_01.wav",
			"sounds/enemies/big_golem_windup_02.wav",
			"sounds/enemies/big_golem_windup_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/golem_flurry_01.wav",
			"sounds/enemies/golem_flurry_02.wav"
		];
		this.m.SoundOnHitDelay = 0;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsAOE = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.HitChanceBonus = -15;
		this.m.DirectDamageMult = 0.2;
		this.m.ActionPointCost = 12;
		this.m.FatigueCost = 30;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 66;
	}

	function isUsable()
	{
		return this.skill.isUsable();
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin += 40;
			_properties.DamageRegularMax += 65;
			_properties.DamageArmorMult *= 0.65;
		}
	}

	function onUse( _user, _targetTile )
	{
		local user = this.m.Container.getActor();
		this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], 1.0, _targetTile.Pos);
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(user) + " wyzwala burzę ciosów wokół siebie");
		local ownTile = user.getTile();
		local numAttacks = 6;
		local targetTiles = [];
		local attackDelay = 0;
		local currentTileIndex = 0;

		for( local i = 0; i < 6; i = i )
		{
			if (!ownTile.hasNextTile(i))
			{
			}
			else
			{
				targetTiles.push(ownTile.getNextTile(i));
			}

			i = ++i;
		}

		while (numAttacks > 0)
		{
			local tile = targetTiles[currentTileIndex];

			if (!tile.IsEmpty && tile.getEntity().isAttackable() && this.Math.abs(tile.Level - ownTile.Level) <= 1 && !user.isAlliedWith(tile.getEntity()))
			{
				this.m.Container.setBusy(true);
				this.Time.scheduleEvent(this.TimeUnit.Virtual, attackDelay, function ( _skill )
				{
					if (tile.getEntity() != null && tile.getEntity().isAlive())
					{
						this.spawnAttackEffect(tile, this.Const.Tactical.AttackEffectChop);
						_skill.attackEntity(user, tile.getEntity());

						if (numAttacks == 1)
						{
							_skill.getContainer().setBusy(false);
						}
					}
				}.bindenv(this), this);
				attackDelay = attackDelay + 200;
				numAttacks--;
			}

			currentTileIndex++;

			if (currentTileIndex >= targetTiles.len())
			{
				if (numAttacks == 6)
				{
				}
				else
				{
					currentTileIndex = 0;
				}
			}

			  // [113]  OP_CLOSE          0      9    0    0
		}

		return true;
	}

});

