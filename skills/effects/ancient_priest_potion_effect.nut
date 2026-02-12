this.ancient_priest_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.ancient_priest_potion";
		this.m.Name = "Niedrożność Synapsy";
		this.m.Icon = "skills/status_effect_134.png";
		this.m.IconMini = "status_effect_134_mini";
		this.m.Overlay = "status_effect_134";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Ciało tej postaci zmutowało w taki sposób, że zmieniły się jej odruchy samozachowawcze. W mocno stresowych sytuacjach jej układ limbiczny zwyczajnie odmawia dostarczenia zasobów na próbę podjęcia ucieczki, co efektywnie czyni ją niezłomnym wojownikiem na polu bitwy.";
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
				icon = "ui/icons/morale.png",
				text = "Nie można obniżyć morale do stopnia, w którym spowodują one ucieczkę"
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

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isAncientPriestPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isAncientPriestPotionAcquired", false);
	}

});

