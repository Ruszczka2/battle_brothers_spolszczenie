this.perfect_focus <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.perfect_focus";
		this.m.Name = "Perfekcyjne Skupienie";
		this.m.Description = "Stań się jednością ze swoją bronią i osiągnij perfekcyjne skupienie, jakby sam czas nagle się zatrzymał.";
		this.m.Icon = "ui/perks/perk_37_active.png";
		this.m.IconDisabled = "ui/perks/perk_37_active_sw.png";
		this.m.Overlay = "perk_37_active";
		this.m.SoundOnUse = [
			"sounds/combat/perfect_focus_01.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 1;
		this.m.FatigueCost = 10;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
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
				text = "Koszty Punktów Akcji są obniżone o połowę do końca tej rundy, jednak koszty Zmęczenia są podwojone."
			}
		];
		return ret;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.getContainer().hasSkill("effects.perfect_focus");
	}

	function onUse( _user, _targetTile )
	{
		if (!this.getContainer().hasSkill("effects.perfect_focus"))
		{
			this.m.Container.add(this.new("scripts/skills/effects/perfect_focus_effect"));
			return true;
		}

		return false;
	}

});

