this.greater_flesh_golem_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.greater_flesh_golem_potion";
		this.m.Name = "Zmutowane Gruczoły";
		this.m.Icon = "skills/status_effect_156.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_156";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Ciało tej postaci zostało nieodwracalnie zmutowane, a jego równowaga chemiczna została zachwiana przez nadprodukcję gruczołów. Jednak jakimś cudem, wydaje się, że wszystko sięustabilizowało i to w korzystny sposób.";
	}

	function onUpdate( _properties )
	{
	}

	function onDeath()
	{
		this.World.Statistics.getFlags().set("isGreaterFleshGolemPotionAcquired", false);
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isGreaterFleshGolemPotionAcquired", false);
	}

});

