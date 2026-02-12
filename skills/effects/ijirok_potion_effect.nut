this.ijirok_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.ijirok_potion";
		this.m.Name = "Patronat Szalonego Boga";
		this.m.Icon = "skills/status_effect_150.png";
		this.m.IconMini = "status_effect_150_mini";
		this.m.Overlay = "status_effect_150";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Z tą postacią jest coś nie tak. Pomijając napady szalonego śmiechu i mamrotanych tyrad, jej ciało zdaje się, całkiem losowo, odrzucać wszelkie zmiany, które się na nim pojawiły. W bitwie ma to o tyle szczęśliwe zastosowanie, że pozwala czasem uniknąć różnych osłabiających efektów.";
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] szansy, aby odeprzeć dowolny efekt stanu, jak np. Oszołomienie czy Ogłuszenie"
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

	function onUpdate( _properties )
	{
		_properties.IsResistantToAnyStatuses = true;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isIjirokPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isIjirokPotionAcquired", false);
	}

});

