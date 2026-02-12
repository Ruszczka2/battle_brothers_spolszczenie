this.cat_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.cat_potion";
		this.m.Name = "Wyostrzony Refleks";
		this.m.Icon = "skills/status_effect_93.png";
		this.m.IconMini = "status_effect_93_mini";
		this.m.Overlay = "status_effect_93";
		this.m.Type = this.Const.SkillType.StatusEffect | this.Const.SkillType.DrugEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsSerialized = true;
	}

	function getDescription()
	{
		return "Dzięki koktajlowi z psychoaktywnych substancji, zmysły tej postaci uległy wyostrzeniu, a odruchy stały się błyskawiczne. Zwiększyła się też tendencja do paranoicznych zachowań.";
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
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] do Inicjatywy"
			},
			{
				id = 7,
				type = "hint",
				icon = "ui/icons/action_points.png",
				text = "Efekt minie po 1 bitwie"
			}
		];
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.Initiative += 20;
	}

});

