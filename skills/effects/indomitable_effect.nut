this.indomitable_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.indomitable";
		this.m.Name = "Niezłomny";
		this.m.Icon = "ui/perks/perk_30.png";
		this.m.IconMini = "perk_30_mini";
		this.m.Overlay = "perk_30";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Ta postać zebrała w sobie całą swoją fizyczną tężyznę i siłę woli, stając się niezłomna aż do swojej następnej tury.";
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
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Otrzymuje tylko [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] obrażeń"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Niewrażliwość na ogłuszenie"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Niewrażliwość na odrzucenie w tył i przyciągnięcie"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.DamageReceivedTotalMult *= 0.5;
		_properties.IsImmuneToStun = true;
		_properties.IsImmuneToKnockBackAndGrab = true;
		_properties.TargetAttractionMult *= 0.5;
	}

	function onTurnStart()
	{
		this.removeSelf();
	}

});

