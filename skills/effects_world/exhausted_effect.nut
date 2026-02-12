this.exhausted_effect <- this.inherit("scripts/skills/injury/injury", {
	m = {},
	function create()
	{
		this.injury.create();
		this.m.ID = "effects.exhausted";
		this.m.Name = "Wyczerpany";
		this.m.Description = "Niedawne wydarzenia sprawiły, że ta postać jest fizycznie wyczerpana i ledwie potrafi dotrzymać kroku reszcie kompanii, a co dopiero mówić o walce. Kilka dni odpoczynku powinno zdziałać cuda.";
		this.m.Icon = "skills/status_effect_53.png";
		this.m.IconMini = "status_effect_53_mini";
		this.m.Type = this.m.Type | this.Const.SkillType.StatusEffect | this.Const.SkillType.SemiInjury;
		this.m.IsHealingMentioned = false;
		this.m.IsTreatable = false;
		this.m.HealingTimeMin = 1;
		this.m.HealingTimeMax = 3;
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
				id = 13,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-40%[/color] maksymalnego zmęczenia"
			}
		];
		this.addTooltipHint(ret);
		return ret;
	}

	function onUpdate( _properties )
	{
		this.injury.onUpdate(_properties);
		_properties.StaminaMult *= 0.6;
	}

});

