this.hyena_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.hyena_potion";
		this.m.Name = "Podskórne Zakrzepy";
		this.m.Icon = "skills/status_effect_143.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_143";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Kiedy skóra tej postaci zostanie przebita, wydzielana jest substancja, która drastycznie przyspiesza proces krzepnięcia krwi w okolicy uszkodzenia tkanek. Dzięki temu krwawiące rany są znacznie mniej groźne, aczkolwiek nadal ma miejsce częściowa utrata krwi.";
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
				icon = "ui/icons/special.png",
				text = "Obrażenia od krwawienia są zredukowane o [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color]"
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
			this.World.Statistics.getFlags().set("isHyenaPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isHyenaPotionAcquired", false);
	}

});

