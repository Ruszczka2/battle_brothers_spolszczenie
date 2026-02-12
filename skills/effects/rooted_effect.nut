this.rooted_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.rooted";
		this.m.Name = "Uwięziony w Pnączach";
		this.m.Description = "Grube pnącza o nienaturalnym przyroście uwięziły tę postać w miejscu i ograniczyły jej zdolności do bronienia się. Aby się uwolnić, pnącza musi zostać rozcięte.";
		this.m.Icon = "skills/status_effect_55.png";
		this.m.IconMini = "status_effect_55_mini";
		this.m.Overlay = "status_effect_55";
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
				id = 9,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Nie może się ruszyć[/color]"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-35%[/color] do Obrony w zwarciu"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-35%[/color] do Obrony dystansowej"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-35%[/color] do Inicjatywy"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.IsRooted = true;
		_properties.MeleeDefenseMult *= 0.65;
		_properties.RangedDefenseMult *= 0.65;
		_properties.InitiativeMult *= 0.65;
	}

});

