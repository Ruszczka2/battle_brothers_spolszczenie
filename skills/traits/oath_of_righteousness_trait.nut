this.oath_of_righteousness_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {
		ApplyEffect = true
	},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.oath_of_righteousness";
		this.m.Name = "Przysięga Prawości";
		this.m.Icon = "ui/traits/trait_icon_78.png";
		this.m.Description = "Ta postać złożyła Przysięgę Prawości i jest zobowiązana do złożenia nieumarłych do ich wiecznego odpoczynku.";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
		this.m.Excluded = [];
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
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] do Stanowczości podczas walki z nieumarłymi"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] do Ataku w zwarciu podczas walki z nieumarłymi"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] do Ataku dystansowego podczas walki z nieumarłymi"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] do Obrony w zwarciu podczas walki z nieumarłymi"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] do Obrony dystansowej podczas walki z nieumarłymi"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] do Stanowczości, gdy nie walczy z nieumarłymi"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] do Ataku w zwarciu, gdy nie walczy z nieumarłymi"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] do Ataku dystansowego, gdy nie walczy z nieumarłymi"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] do Obrony w zwarciu, gdy nie walczy z nieumarłymi"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] do Obrony dystansowej, gdy nie walczy z nieumarłymi"
			}
		];
	}

	function onCombatStarted()
	{
		this.m.ApplyEffect = true;
	}

	function onCombatFinished()
	{
		this.m.ApplyEffect = false;
	}

	function onUpdate( _properties )
	{
		if (!this.m.ApplyEffect)
		{
			return;
		}

		if (!this.getContainer().getActor().isPlacedOnMap())
		{
			return;
		}

		local fightingUndead = false;
		local enemies = this.Tactical.Entities.getAllHostilesAsArray();

		foreach( enemy in enemies )
		{
			if (this.Const.EntityType.getDefaultFaction(enemy.getType()) == this.Const.FactionType.Zombies || this.Const.EntityType.getDefaultFaction(enemy.getType()) == this.Const.FactionType.Undead)
			{
				fightingUndead = true;
				break;
			}
		}

		if (fightingUndead)
		{
			_properties.Bravery += 15;
			_properties.MeleeSkill += 10;
			_properties.RangedSkill += 10;
			_properties.MeleeDefense += 5;
			_properties.RangedDefense += 5;
		}
		else
		{
			_properties.Bravery -= 10;
			_properties.MeleeSkill -= 5;
			_properties.RangedSkill -= 5;
			_properties.MeleeDefense -= 5;
			_properties.RangedDefense -= 5;
		}
	}

});

