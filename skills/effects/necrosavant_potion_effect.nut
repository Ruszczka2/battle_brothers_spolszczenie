this.necrosavant_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {
		ShouldHeal = false
	},
	function create()
	{
		this.m.ID = "effects.necrosavant_potion";
		this.m.Name = "Cudzożywna Krew";
		this.m.Icon = "skills/status_effect_133.png";
		this.m.IconMini = "status_effect_133_mini";
		this.m.Overlay = "status_effect_133";
		this.m.SoundOnUse = [
			"sounds/enemies/vampire_life_drain_01.wav",
			"sounds/enemies/vampire_life_drain_02.wav",
			"sounds/enemies/vampire_life_drain_03.wav"
		];
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Ciało tej postaci posiada niezwykłą zdolność do absorbowania różnych typów krwi - albo wręcz krwi z zupełnie innych stworzeń. Daje to niesamowite zdolności leczenia poprzez wchłanianie krwi przez pory na skórze (lub bardziej drastycznie, poprzez picie jej bezpośrednio).";
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/health.png",
				text = "Leczy równowartość [color=" + this.Const.UI.Color.PositiveValue + "]25%[/color] obrażeń Zdrowia zadanych wrogom znajdującym się na przyległych polach, o ile posiadają oni krew"
			},
			{
				id = 12,
				type = "hint",
				icon = "ui/tooltips/warning.png",
				text = "Dalsze mutacje spowodują dłuższy okres trwania choroby"
			}
		];
		return ret;
	}

	function onCombatStarted()
	{
		this.m.ShouldHeal = false;
	}

	function onCombatFinished()
	{
		this.m.ShouldHeal = false;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		local actor = this.m.Container.getActor();

		if (actor.getHitpoints() == actor.getHitpointsMax())
		{
			return;
		}

		if (_damageInflictedHitpoints <= 0)
		{
			return;
		}

		if (this.m.ShouldHeal)
		{
			this.lifesteal(_damageInflictedHitpoints);
			this.m.ShouldHeal = false;
			return;
		}

		if (_targetEntity == null || !_targetEntity.isAlive())
		{
			return;
		}

		if (_targetEntity.getCurrentProperties().IsImmuneToBleeding)
		{
			return;
		}

		if (actor.getTile().getDistanceTo(_targetEntity.getTile()) != 1)
		{
			return;
		}

		this.lifesteal(_damageInflictedHitpoints);
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		if (_targetEntity.getCurrentProperties().IsImmuneToBleeding)
		{
			return;
		}

		local actor = this.m.Container.getActor();

		if (actor.getTile().getDistanceTo(_targetEntity.getTile()) != 1)
		{
			return;
		}

		if (actor.getHitpoints() == actor.getHitpointsMax())
		{
			return;
		}

		this.m.ShouldHeal = true;
	}

	function lifesteal( _damageInflictedHitpoints )
	{
		local actor = this.m.Container.getActor();
		this.spawnIcon("status_effect_09", actor.getTile());
		local hitpointsHealed = this.Math.round(_damageInflictedHitpoints * 0.25);

		if (!actor.isHiddenToPlayer())
		{
			if (this.m.SoundOnUse.len() != 0)
			{
				this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect, actor.getPos());
			}

			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " heals for " + this.Math.min(actor.getHitpointsMax() - actor.getHitpoints(), hitpointsHealed) + " points");
		}

		actor.setHitpoints(this.Math.min(actor.getHitpointsMax(), actor.getHitpoints() + hitpointsHealed));
		actor.onUpdateInjuryLayer();
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isNecrosavantPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isNecrosavantPotionAcquired", false);
	}

});

