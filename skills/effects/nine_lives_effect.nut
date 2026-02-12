this.nine_lives_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.nine_lives";
		this.m.Name = "Dziewięć Żywotów";
		this.m.Description = "Ta postać zdaje się mieć dziewięć żyć! Mając bliskie spotkanie ze śmiercią wchodzi w podwyższony stan przeżycia aż do następnej tury.";
		this.m.Icon = "ui/perks/perk_07.png";
		this.m.IconMini = "perk_07_mini";
		this.m.Overlay = "perk_07";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		return [
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
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] do Obrony w zwarciu"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] do Obrony dystansowej"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] do Stanowczości"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] do Inicjatywy"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.MeleeDefense += 15;
		_properties.RangedDefense += 15;
		_properties.Bravery += 15;
		_properties.Initiative += 15;
	}

	function onTurnStart()
	{
		this.removeSelf();
	}

});

