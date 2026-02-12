this.oath_of_vengeance_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {
		ApplyEffect = true
	},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.oath_of_vengeance";
		this.m.Name = "Przysięga Zemsty";
		this.m.Icon = "ui/traits/trait_icon_77.png";
		this.m.Description = "Ta postać złożyła Przysięgę Zemsty i jest zobowiązana do walki z zielonoskórą plagą, która nęka ludzkość.";
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] do Stanowczości podczas walki z zielonoskórymi"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] do Ataku w zwarciu podczas walki z zielonoskórymi"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] do Ataku dystansowego podczas walki z zielonoskórymi"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] do Obrony w zwarciu podczas walki z zielonoskórymi"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] do Obrony dystansowej podczas walki z zielonoskórymi"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] do Stanowczości, gdy nie walczy z zielonoskórymi"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] do Ataku w zwarciu, gdy nie walczy z zielonoskórymi"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] do Ataku dystansowego, gdy nie walczy z zielonoskórymi"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] do Obrony w zwarciu, gdy nie walczy z zielonoskórymi"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] do Obrony dystansowej, gdy nie walczy z zielonoskórymi"
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

		local fightingGreenskins = false;
		local enemies = this.Tactical.Entities.getAllHostilesAsArray();

		foreach( enemy in enemies )
		{
			if (this.Const.EntityType.getDefaultFaction(enemy.getType()) == this.Const.FactionType.Orcs || this.Const.EntityType.getDefaultFaction(enemy.getType()) == this.Const.FactionType.Goblins)
			{
				fightingGreenskins = true;
				break;
			}
		}

		if (fightingGreenskins)
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

