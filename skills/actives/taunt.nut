this.taunt <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.taunt";
		this.m.Name = "Wydrwij";
		this.m.Description = "Walczysz jak krowa! Sprowokuj pojedynczego przeciwnika, aby zaatakował tę postać zamiast przyjąć pozycję obronną lub atakować jakiś inny, potencjalnie bardziej narażony cel.";
		this.m.Icon = "ui/perks/perk_38_active.png";
		this.m.IconDisabled = "ui/perks/perk_38_active_sw.png";
		this.m.Overlay = "perk_38_active";
		this.m.SoundOnUse = [
			"sounds/combat/taunt_01.wav",
			"sounds/combat/taunt_02.wav",
			"sounds/combat/taunt_03.wav",
			"sounds/combat/taunt_04.wav",
			"sounds/combat/taunt_05.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
		this.m.MaxLevelDifference = 4;
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
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Zmusza cel do zbliżenia się i zaatakowania tej postaci w jego następnej turze, o ile to możliwe. Pamiętaj, że cele nadal będą się stosować do ich grupowej strategii i możliwe, że nie zaszarżują na oślep."
			}
		];
		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (this.m.Container.getActor().isAlliedWith(_targetTile.getEntity()))
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		target.getAIAgent().setForcedOpponent(_user);
		target.getSkills().add(this.new("scripts/skills/effects/taunted_effect"));
		return true;
	}

});

