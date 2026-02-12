this.recovery_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {
		IsCountingBattle = false
	},
	function create()
	{
		this.m.ID = "effects.recovery_potion";
		this.m.Name = "Podwyższona Energia";
		this.m.Icon = "skills/status_effect_89.png";
		this.m.IconMini = "status_effect_89_mini";
		this.m.Overlay = "status_effect_89";
		this.m.Type = this.Const.SkillType.StatusEffect | this.Const.SkillType.DrugEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Mogę tak całą noc! Dzięki koktajlowi z ergogenicznych substancji, eufemistycznie zwanemu \'Mikstura Drugiej Świeżości\', serce tej postaci bije jak szalone, postać niełatwo się męczy i jest bardziej energiczna. Ponadto, czy mi się zdaje, czy zrobiło się tu jakoś gorąco?";
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
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+4[/color] odnowy Zmęczenia na turę"
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

	function onCombatStarted()
	{
		this.m.IsCountingBattle = true;
	}

	function onCombatFinished()
	{
		if (!this.m.IsCountingBattle)
		{
			return;
		}

		this.removeSelf();
	}

	function onUpdate( _properties )
	{
		_properties.FatigueRecoveryRate += 4;
	}

});

