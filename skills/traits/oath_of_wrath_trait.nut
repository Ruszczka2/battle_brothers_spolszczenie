this.oath_of_wrath_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.oath_of_wrath";
		this.m.Name = "Przysięga Gniewu";
		this.m.Icon = "ui/traits/trait_icon_80.png";
		this.m.Description = "Ta postać złożyła Przysięgę Gniewu i jest zobowiązana do gromienia nawet największych przeciwników.";
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
				icon = "ui/icons/hitchance.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color] do szansy trafienia podczas władania dwuręczną lub oburącz trzymaną bronią do walki w zwarciu"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] do Obrony w zwarciu"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] do Obrony dystansowej"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Wszystkie zabójstwa są śmiertelne i wyjątkowo brutalne (o ile broń na to pozwala)."
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.MeleeDefense -= 5;
		_properties.RangedDefense -= 10;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill.isAttack())
		{
			_properties.FatalityChanceMult = 1000.0;
			local items = this.getContainer().getActor().getItems();
			local main = items.getItemAtSlot(this.Const.ItemSlot.Mainhand);

			if (main != null && main.isItemType(this.Const.Items.ItemType.MeleeWeapon))
			{
				if (main.isItemType(this.Const.Items.ItemType.TwoHanded) || items.getItemAtSlot(this.Const.ItemSlot.Offhand) == null && !items.hasBlockedSlot(this.Const.ItemSlot.Offhand))
				{
					_properties.MeleeSkill += 15;
				}
			}
		}
	}

});

