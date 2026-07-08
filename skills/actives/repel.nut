this.repel <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.repel";
		this.m.Name = "Odeprzyj";
		this.m.Description = "Dźgnij i naprzyj na cel, aby odepchnąć go o jedno pole z dala od postaci. Trafiony cel straci równowagę i utraci inicjatywę, może też otrzymać obrażenia, jeśli zostanie zepchnięty z dużej wysokości. Umiejętności takie jak Ściana Tarcz, Ściana Włóczni czy Riposta celu zostaną anulowane, jeśli zostanie on skutecznie odepchnięty. Ukorzeniony cel nie może zostać odparty.";
		this.m.Icon = "skills/active_55.png";
		this.m.IconDisabled = "skills/active_55_sw.png";
		this.m.Overlay = "active_55";
		this.m.SoundOnHit = [
			"sounds/combat/repel_hit_01.wav",
			"sounds/combat/repel_hit_02.wav",
			"sounds/combat/repel_hit_03.wav"
		];
		this.m.SoundOnMiss = [
			"sounds/combat/impale_01.wav",
			"sounds/combat/impale_02.wav",
			"sounds/combat/impale_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsTooCloseShown = true;
		this.m.IsWeaponSkill = true;
		this.m.HitChanceBonus = 0;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Ma zasięg [color=" + this.Const.UI.Color.PositiveValue + "]2[/color] pól"
		});
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Ma [color=" + this.Const.UI.Color.PositiveValue + "]100%[/color] szansy na wytrącenie celu z równowagi"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "Ma [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] szansy na trafienie"
		});

		if (!this.getContainer().getActor().getCurrentProperties().IsSpecializedInPolearms)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Ma [color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] szansy na trafienie celów bezpośrednio sąsiadujących, ponieważ broń jest zbyt nieporęczna"
			});
		}

		return ret;
	}

	function findTileToKnockBackTo( _userTile, _targetTile )
	{
		local dir = _userTile.getDirectionTo(_targetTile);

		if (_targetTile.hasNextTile(dir))
		{
			local knockToTile = _targetTile.getNextTile(dir);

			if (knockToTile.IsEmpty && knockToTile.Level - _userTile.Level <= 1)
			{
				return knockToTile;
			}
		}

		local altdir = dir - 1 >= 0 ? dir - 1 : 5;

		if (_targetTile.hasNextTile(altdir))
		{
			local knockToTile = _targetTile.getNextTile(altdir);

			if (knockToTile.IsEmpty && knockToTile.Level - _userTile.Level <= 1)
			{
				return knockToTile;
			}
		}

		altdir = dir + 1 <= 5 ? dir + 1 : 0;

		if (_targetTile.hasNextTile(altdir))
		{
			local knockToTile = _targetTile.getNextTile(altdir);

			if (knockToTile.IsEmpty && knockToTile.Level - _userTile.Level <= 1)
			{
				return knockToTile;
			}
		}

		return null;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInPolearms ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		this.m.ActionPointCost = _properties.IsSpecializedInPolearms ? 5 : 6;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (_targetTile.getEntity().getCurrentProperties().IsRooted)
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local success = this.Math.rand(1, 100) <= this.getHitchance(_targetTile.getEntity());

		if (!success)
		{
			target.onMissed(this.getContainer().getActor(), this);
		}

		local knockToTile = this.findTileToKnockBackTo(_user.getTile(), _targetTile);

		if (knockToTile == null)
		{
			success = false;
		}

		if (success)
		{
			this.applyFatigueDamage(target, 10);
		}

		if (target.getCurrentProperties().IsImmuneToKnockBackAndGrab)
		{
			success = false;
		}

		if (!success)
		{
			if (this.m.SoundOnMiss.len() != 0)
			{
				this.Sound.play(this.m.SoundOnMiss[this.Math.rand(0, this.m.SoundOnMiss.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());
			}

			_user.getSkills().onTargetMissed(this, target);
			return success;
		}

		if (!_user.isHiddenToPlayer() && (_targetTile.IsVisibleForPlayer || knockToTile.IsVisibleForPlayer))
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " odpycha w tył: " + this.Const.UI.getColorizedEntityName(target));
		}

		local skills = target.getSkills();
		skills.removeByID("effects.shieldwall");
		skills.removeByID("effects.spearwall");
		skills.removeByID("effects.riposte");

		if (this.m.SoundOnHit.len() != 0)
		{
			this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());
		}

		local stagger = this.new("scripts/skills/effects/staggered_effect");
		target.getSkills().add(stagger);

		if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(stagger.getLogEntryOnAdded(this.Const.UI.getColorizedEntityName(_user), this.Const.UI.getColorizedEntityName(target)));
		}

		_user.getSkills().onTargetHit(this, target, this.Const.BodyPart.Body, 0, 0);
		target.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
		local damage = this.Math.max(0, this.Math.abs(knockToTile.Level - _targetTile.Level) - 1) * this.Const.Combat.FallingDamage;

		if (damage == 0)
		{
			this.Tactical.getNavigator().teleport(target, knockToTile, null, null, true);
		}
		else
		{
			local p = this.getContainer().getActor().getCurrentProperties();
			local tag = {
				Attacker = _user,
				Skill = this,
				HitInfo = clone this.Const.Tactical.HitInfo,
				HitInfoBash = null
			};
			tag.HitInfo.DamageRegular = damage;
			tag.HitInfo.DamageFatigue = this.Const.Combat.FatigueReceivedPerHit;
			tag.HitInfo.DamageDirect = 1.0;
			tag.HitInfo.BodyPart = this.Const.BodyPart.Body;
			tag.HitInfo.BodyDamageMult = 1.0;
			tag.HitInfo.FatalityChanceMult = 1.0;
			this.Tactical.getNavigator().teleport(target, knockToTile, this.onKnockedDown, tag, true);
		}

		return success;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )

	{

		if (_skill == this)

		{

			_properties.MeleeSkill += this.getHitChanceModifier();

			this.m.HitChanceBonus += this.getHitChanceModifier();



			if (_targetEntity != null && !this.getContainer().getActor().getCurrentProperties().IsSpecializedInPolearms && this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile()) == 1)

			{

				_properties.MeleeSkill += -15;

				this.m.HitChanceBonus += -15;

			}

		}

	}

	function onKnockedDown( _entity, _tag )
	{
		if (_tag.HitInfo.DamageRegular != 0)
		{
			_entity.onDamageReceived(_tag.Attacker, _tag.Skill, _tag.HitInfo);
		}

		if (_tag.HitInfoBash != null)
		{
			_entity.onDamageReceived(_tag.Attacker, _tag.Skill, _tag.HitInfoBash);
		}
	}


	function getHitChanceModifier()

	{

		return 10;

	}
});

