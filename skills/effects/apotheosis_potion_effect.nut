this.apotheosis_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.apotheosis_potion";
		this.m.Name = "Apoteoza";
		this.m.Icon = "skills/status_effect_158.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_158";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Ta postać zażyła dość mocny stymulant. Chociaż sam mechanizm dostarczania jest rewolucyjny, sam lek nie jest aż tak potężny, jak sugeruje jego nazwa.";
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
				icon = "ui/icons/health.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+1[/color] do Zdrowia"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+1[/color] Zmęczenia"
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
		_properties.Hitpoints += 1;
		_properties.Stamina += 1;
	}

});

