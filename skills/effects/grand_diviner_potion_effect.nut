this.grand_diviner_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.grand_diviner_potion";
		this.m.Name = "Przeklęte Widzenie";
		this.m.Icon = "skills/status_effect_152.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_152";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Ta postać widziała rzeczy, których nie powinna była widzieć i czerpie z doświadczeń, które nie są jej własne. Możesz dostrzec nieskrępowany strach na jej twarzy w tych rzadkich momentach, gdy przyłapiesz ją samą. A może to po prostu presja życia najemnika w końcu odcisnęła na niej swoje piętno.";
	}

	function onDeath()
	{
		this.World.Statistics.getFlags().set("isGrandDivinerPotionAcquired", false);
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isGrandDivinerPotionAcquired", false);
	}

});

