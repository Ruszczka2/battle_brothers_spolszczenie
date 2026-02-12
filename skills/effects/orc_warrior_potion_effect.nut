this.orc_warrior_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.orc_warrior_potion";
		this.m.Name = "Czuciowa Redundancja";
		this.m.Icon = "skills/status_effect_128.png";
		this.m.IconMini = "status_effect_128_mini";
		this.m.Overlay = "status_effect_128";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Ciało tej postaci uległo mutacji i rozwinęło wiele zbędnych synaps, co pozwala jej zachować pewien stopień kontroli nad wzrokiem, słuchem i mięśniami, nawet po otrzymaniu wyniszczających ciosów.";
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]33%[/color] szansy na odparcie efektów Oszołomienia, Ogłuszenia, Rozkojarzenia, Uwiądu i Zachwiania"
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
		_properties.IsResistantToPhysicalStatuses = true;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isOrcWarriorPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isOrcWarriorPotionAcquired", false);
	}

});

