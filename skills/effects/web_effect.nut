this.web_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.web";
		this.m.Name = "Uwięziony w Sieci";
		this.m.Description = "Wielka i kleista pajęczyna trzyma tę postać w miejscu i ogranicza jej zdolność do bronienia się oraz przyłożenia się do ciosu. Aby się uwolnić, sieć trzeba rozciąć.";
		this.m.Icon = "skills/status_effect_80.png";
		this.m.IconMini = "status_effect_80_mini";
		this.m.Overlay = "status_effect_80";
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
				id = 13,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Dwukrotnie więcej obrażeń zadanych przez ataki Webknechtów zignoruje pancerz[/color]"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50%[/color] do zadawanych obrażeń"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50%[/color] do Obrony w zwarciu"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50%[/color] do Obrony dystansowej"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50%[/color] do Inicjatywy"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.IsRooted = true;
		_properties.DamageTotalMult *= 0.5;
		_properties.MeleeDefenseMult *= 0.5;
		_properties.RangedDefenseMult *= 0.5;
		_properties.InitiativeMult *= 0.5;
		_properties.TargetAttractionMult *= 1.5;
	}

});

