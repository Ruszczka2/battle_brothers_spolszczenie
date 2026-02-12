this.censer_strike <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.censer_strike";
		this.m.Name = "Cios Kadzielnicą";
		this.m.Description = "Uderz w cel zmodyfikowaną kadzielnicą i zostaw po ataku żrące wyziewy. Atak nieco nieprzewidywalny, ale zdolny do uderzenia z odległości 2 pól oraz, przy odrobinie szczęścia i umiejętności, omijając tarczę wroga.";
		this.m.KilledString = "Zatłuczony na śmierć";
		this.m.Icon = "skills/active_228.png";
		this.m.IconDisabled = "skills/active_228_sw.png";
		this.m.Overlay = "active_228";
		this.m.SoundOnUse = [
			"sounds/combat/pound_01.wav",
			"sounds/combat/pound_02.wav",
			"sounds/combat/pound_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/pound_hit_01.wav",
			"sounds/combat/pound_hit_02.wav",
			"sounds/combat/pound_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsTooCloseShown = true;
		this.m.IsShieldRelevant = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 66;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Ma zasięg [color=" + this.Const.UI.Color.PositiveValue + "]2" + "[/color] pól"
		});

		if (!this.getContainer().getActor().getCurrentProperties().IsSpecializedInFlails)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Ma [color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] szans na trafienie celów bezpośrednio sąsiadujących, gdyż broń jest zbyt nieporęczna"
			});
		}
		else
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Ignoruje premię do Obrony w zwarciu przyznanej przez tarcze"
			});
		}

		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Pozostawia chmurę trujących wyziewów w miejscu trafienia"
		});
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInFlails ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectBash);
		local success = this.attackEntity(_user, _targetTile.getEntity());
		local miasma_effect = {
			Type = "miasma",
			Tooltip = "Pozostał tu wyziew groźny dla każdej żyjącej istoty",
			IsPositive = false,
			IsAppliedAtRoundStart = false,
			IsAppliedAtTurnEnd = true,
			IsAppliedOnMovement = false,
			IsAppliedOnEnter = false,
			IsByPlayer = false,
			Timeout = this.Time.getRound() + 3,
			Callback = this.Const.Tactical.Common.onApplyMiasma,
			function Applicable( _a )
			{
				return !_a.getFlags().has("undead");
			}

		};

		if (_targetTile.Properties.Effect != null && _targetTile.Properties.Effect.Type == "miasma")
		{
			_targetTile.Properties.Effect.Timeout = this.Time.getRound() + 3;
		}
		else
		{
			if (_targetTile.Properties.Effect != null)
			{
				this.Tactical.Entities.removeTileEffect(_targetTile);
			}

			_targetTile.Properties.Effect = clone miasma_effect;
			local particles = [];

			for( local i = 0; i < this.Const.Tactical.MiasmaParticles.len(); i = i )
			{
				particles.push(this.Tactical.spawnParticleEffect(true, this.Const.Tactical.MiasmaParticles[i].Brushes, _targetTile, this.Const.Tactical.MiasmaParticles[i].Delay, this.Const.Tactical.MiasmaParticles[i].Quantity, this.Const.Tactical.MiasmaParticles[i].LifeTimeQuantity, this.Const.Tactical.MiasmaParticles[i].SpawnRate, this.Const.Tactical.MiasmaParticles[i].Stages));
				i = ++i;
			}

			this.Tactical.Entities.addTileEffect(_targetTile, _targetTile.Properties.Effect, particles);
		}

		if (!_user.isAlive() || _user.isDying())
		{
			return success;
		}

		return success;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			if (_targetEntity != null && !this.getContainer().getActor().getCurrentProperties().IsSpecializedInFlails && this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile()) == 1)
			{
				_properties.MeleeSkill += -15;
				this.m.HitChanceBonus = -15;
			}
			else
			{
				this.m.HitChanceBonus = 0;
			}

			if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInFlails)
			{
				this.m.IsShieldRelevant = false;
			}
		}
	}

});

