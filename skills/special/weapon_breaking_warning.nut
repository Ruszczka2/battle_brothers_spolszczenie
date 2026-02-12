this.weapon_breaking_warning <- this.inherit("scripts/skills/skill", {
	function create()
	{
		this.m.ID = "special.weapon_breaking_warning";
		this.m.Name = "Broń w kiepskim stanie!";
		this.m.Icon = "skills/status_effect_59.png";
		this.m.IconMini = "status_effect_59_mini";
		this.m.Description = "Broń tej postaci jest w kiepskim stanie i może ulec trwałemu zniszczeniu, jeśli znów zostanie użyta.";
		this.m.Type = this.Const.SkillType.Special | this.Const.SkillType.StatusEffect | this.Const.SkillType.Alert;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsHidden = true;
		this.m.IsSerialized = false;
	}

	function getDescription()
	{
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

		if (!this.m.IsHidden && item != null)
		{
			local p = this.Math.floor(100 * item.getCondition() / item.getConditionMax());
			return "Broń tej postaci jest w kiepskim stanie(" + p + "%) i może ulec trwałemu zniszczeniu, jeśli znów zostanie użyta.";
		}
		else
		{
			return this.m.Description;
		}
	}

	function onTurnStart()
	{
		if (!this.isHidden())
		{
			this.spawnIcon("status_effect_59", this.getContainer().getActor().getTile());
		}
	}

	function isHidden()
	{
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

		if (item == null || item.getConditionMax() <= 1.0 || item.getCondition() > this.Const.Combat.AlertWeaponBreakingCondition)
		{
			this.m.IsHidden = true;
		}
		else
		{
			this.m.IsHidden = false;
		}

		return this.m.IsHidden;
	}

});

