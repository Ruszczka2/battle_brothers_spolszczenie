this.perk_battle_forged <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.battle_forged";
		this.m.Name = this.Const.Strings.PerkName.BattleForged;
		this.m.Description = this.Const.Strings.PerkDescription.BattleForged;
		this.m.Icon = "ui/perks/perk_03.png";
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function isHidden()
	{
		local armor = this.getContainer().getActor().getArmor(this.Const.BodyPart.Head) + this.getContainer().getActor().getArmor(this.Const.BodyPart.Body);
		local fm = this.Math.floor((1.0 - armor * 0.05 * 0.01) * 100);
		return fm >= 100;
	}

	function getDescription()
	{
		return "Specjalizuj się w ciężkiej zbroi! Otrzymane obrażenia pancerza zostają pomniejszone o wartość procentową równą [color=" + this.Const.UI.Color.PositiveValue + "]5%[/color] twojego obecnego całkowitego pancerza - sumy pancerza ciała i głowy. Im cięższa zbroja i hełm, tym więcej skorzystasz.";
	}

	function getTooltip()
	{
		local armor = this.getContainer().getActor().getArmor(this.Const.BodyPart.Head) + this.getContainer().getActor().getArmor(this.Const.BodyPart.Body);
		local fm = this.Math.floor((1.0 - armor * 0.05 * 0.01) * 100);
		local tooltip = this.skill.getTooltip();

		if (fm < 100)
		{
			tooltip.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Otrzymuje jedynie [color=" + this.Const.UI.Color.PositiveValue + "]" + fm + "%[/color] obrażeń pancerza od ataków"
			});
		}
		else
		{
			tooltip.push({
				id = 6,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Pancerz tej postaci jest słaby, aby móc przyznać jakieś korzyści z talentu Zaprawiony w Boju[/color]"
			});
		}

		return tooltip;
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_attacker != null && _attacker.getID() == this.getContainer().getActor().getID() || _skill != null && !_skill.isAttack())
		{
			return;
		}

		local armor = this.getContainer().getActor().getArmor(this.Const.BodyPart.Head) + this.getContainer().getActor().getArmor(this.Const.BodyPart.Body);
		_properties.DamageReceivedArmorMult *= 1.0 - armor * 0.05 * 0.01;
	}

});

