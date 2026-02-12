this.smoke_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.smoke";
		this.m.Name = "Spowita Dymem";
		this.m.Icon = "skills/status_effect_117.png";
		this.m.IconMini = "status_effect_117_mini";
		this.m.Overlay = "status_effect_117";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Ta postać spowita jest gęstą warstwą dymu. Raz ją widać, innym razem nie, więc może bez obawy się przemieszczać i ignorować wszelkie strefy kontroli.";
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
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50%[/color] do Ataku dystansowego"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+100%[/color] do Obrony dystansowej"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Ignoruje wszelkie Strefy Kontroli"
			}
		];
	}

	function onNewRound()
	{
		local tile = this.getContainer().getActor().getTile();

		if (tile.Properties.Effect == null || tile.Properties.Effect.Type != "smoke")
		{
			this.removeSelf();
		}
	}

	function onUpdate( _properties )
	{
		local tile = this.getContainer().getActor().getTile();

		if (tile.Properties.Effect == null || tile.Properties.Effect.Type != "smoke")
		{
			this.removeSelf();
		}
		else
		{
			_properties.RangedSkillMult *= 0.5;
			_properties.RangedDefenseMult *= 2.0;
		}
	}

});

