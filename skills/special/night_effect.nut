this.night_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "special.night";
		this.m.Name = "Noc";
		this.m.Description = "Czy ten cień właśnie się poruszył? Nikłe światło księżyca sprawia, że ciężko jest dostrzec coś na odległość większą niż kilka stóp przed sobą, co ogranicza widoczność i czyni broń dystansową mało efektywną dla każdego, kto nie potrafi widzieć w ciemności.";
		this.m.Icon = "skills/status_effect_35.png";
		this.m.IconMini = "status_effect_35_mini";
		this.m.Type = this.Const.SkillType.StatusEffect | this.Const.SkillType.Special;
		this.m.IsActive = false;
		this.m.IsSerialized = false;
		this.m.IsRemovedAfterBattle = true;
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
			}
		];
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-2[/color] Wzroku"
		});
		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/ranged_skill.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30%[/color] do Ataku dystansowego"
		});
		ret.push({
			id = 13,
			type = "text",
			icon = "ui/icons/ranged_defense.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30%[/color] do Obrony dystansowej"
		});
		return ret;
	}

	function onUpdate( _properties )
	{
		this.m.IsHidden = !_properties.IsAffectedByNight;

		if (_properties.IsAffectedByNight)
		{
			_properties.Vision -= 2;
			_properties.RangedSkillMult *= 0.7;
			_properties.RangedDefense *= 0.7;
		}
	}

});

