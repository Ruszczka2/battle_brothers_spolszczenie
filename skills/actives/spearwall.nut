this.spearwall <- this.inherit("scripts/skills/skill", {
	m = {
		BaseAttackName = "Thrust"
	},
	function create()
	{
		this.m.ID = "actives.spearwall";
		this.m.Name = "Ściana Włóczni";
		this.m.Icon = "skills/active_23.png";
		this.m.IconDisabled = "skills/active_23_sw.png";
		this.m.Overlay = "active_23";
		this.m.SoundOnUse = [
			"sounds/combat/spearwall_01.wav",
			"sounds/combat/spearwall_02.wav",
			"sounds/combat/spearwall_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsWeaponSkill = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 30;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function getDescription()
	{
		return "Przygotuj się, by natychmiastowo zaatakować każdego przeciwnika, który spróbuje podejść na zasięg broni białej i, w przypadku trafienia, powstrzymaj tego przeciwnika przed zbliżeniem się. Trafione cele otrzymają połowę obrażeń zwykłego ataku " + this.m.BaseAttackName + ".";
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
				id = 3,
				type = "text",
				text = this.getCostString()
			}
		];

		if (this.Tactical.isActive() && !this.getContainer().getActor().getCurrentProperties().IsSpecializedInSpears && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Nie można użyć, gdyż wróg zbliżył się na odległość walki wręcz[/color]"
			});
		}

		return ret;
	}

	function isUsable()
	{
		return !this.Tactical.isActive() || this.skill.isUsable() && (this.getContainer().getActor().getCurrentProperties().IsSpecializedInSpears || !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions())) && !this.getContainer().hasSkill("effects.spearwall");
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInSpears ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Container.add(this.new("scripts/skills/effects/spearwall_effect"));

		if (!_user.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " używa ściany Włóczni");
		}

		return true;
		return false;
	}

	function onRemoved()
	{
		this.m.Container.removeByID("effects.spearwall");
	}

});

