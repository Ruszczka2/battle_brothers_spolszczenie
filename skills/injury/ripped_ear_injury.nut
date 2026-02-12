this.ripped_ear_injury <- this.inherit("scripts/skills/injury/injury", {
	m = {},
	function create()
	{
		this.injury.create();
		this.m.ID = "injury.ripped_ear";
		this.m.Name = "Rozerwane Ucho";
		this.m.Description = "Ucho tej postaci zostało niemal całkowicie oderwane, zalewając głowę oraz kark krwią i sprawiając, że postać słabiej reaguje na to, co się dookoła dzieje.";
		this.m.Type = this.m.Type | this.Const.SkillType.TemporaryInjury;
		this.m.DropIcon = "injury_icon_42";
		this.m.Icon = "ui/injury/injury_icon_42.png";
		this.m.IconMini = "injury_icon_42_mini";
		this.m.HealingTimeMin = 2;
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
				id = 11,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] do Inicjatywy"
			}
		];
		this.addTooltipHint(ret);
		return ret;
	}

	function onUpdate( _properties )
	{
		this.injury.onUpdate(_properties);

		if (!_properties.IsAffectedByInjuries || this.m.IsFresh && !_properties.IsAffectedByFreshInjuries)
		{
			return;
		}

		_properties.InitiativeMult *= 0.85;
	}

});

