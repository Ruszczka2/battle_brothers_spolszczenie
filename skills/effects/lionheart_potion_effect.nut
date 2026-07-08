this.lionheart_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {
		IsCountingBattle = false
	},
	function create()
	{
		this.m.ID = "effects.lionheart_potion";
		this.m.Name = "Zwiększona Odwaga";
		this.m.Icon = "skills/status_effect_90.png";
		this.m.IconMini = "status_effect_90_mini";
		this.m.Overlay = "status_effect_90";
		this.m.Type = this.Const.SkillType.StatusEffect | this.Const.SkillType.DrugEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Dzięki koktajlowi z psychoaktywnych substancji, lęki tej postaci, tak jak i jej zdolność do trzeźwej oceny sytuacji, zostały przytłumione i postać znalazła w sobie odwagę do zmierzenia się nawet z niemożliwymi do pokonania trudnościami.";
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
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] do Stanowczości"
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
		_properties.Bravery += 20;
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
});

