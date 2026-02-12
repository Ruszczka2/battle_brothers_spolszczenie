this.afraid_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.afraid";
		this.m.Name = "Przestraszony";
		this.m.Description = "Niedawne wydarzenia sprawiły, że ta postać obawia się o swoje życie. Albo coś w tym jest i wkrótce spotka ją marny koniec, albo strach minie z czasem.";
		this.m.Icon = "skills/status_effect_52.png";
		this.m.IconMini = "status_effect_52_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
	}

	function isTreated()
	{
		return true;
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
				id = 13,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50%[/color] do Stanowczości"
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Nie przeszkadza mu bycie w rezerwie"
			}
		];
	}

	function onNewDay()
	{
		if (this.Math.rand(1, 100) <= 25)
		{
			this.removeSelf();
		}
	}

	function onUpdate( _properties )
	{
		_properties.BraveryMult *= 0.5;
		_properties.IsContentWithBeingInReserve = true;
	}

});

