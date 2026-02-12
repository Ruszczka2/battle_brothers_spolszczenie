this.oath_of_distinction_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.oath_of_distinction";
		this.m.Name = "Przysięga Wyróżnienia";
		this.m.Icon = "ui/traits/trait_icon_88.png";
		this.m.Description = "Ta postać złożyła Przysięgę Wyróżnienia i jest zobowiązana do poszukiwania swych własnych zwycięstw, bez pomocy sojuszników.";
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] do Stanowczości, jeśli na sąsiednich polach nie ma sojuszników"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+3[/color] odnowy Zmęczenia na turę, jeśli na sąsiednich polach nie ma sojuszników"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/damage_dealt.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] do zadawanych obrażeń, jeśli na sąsiednich polach nie ma sojuszników"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]0%[/color] zdobywanego doświadczenia za zabójstwa dokonane przez sojuszników"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.XPGainMult *= 1.5;
		_properties.IsAllyXPBlocked = true;
		local actor = this.getContainer().getActor();

		if (!actor.isPlacedOnMap())
		{
			return;
		}

		local myTile = actor.getTile();
		local allies = this.Tactical.Entities.getInstancesOfFaction(actor.getFaction());
		local isAlone = true;

		foreach( ally in allies )
		{
			if (ally.getID() == actor.getID() || !ally.isPlacedOnMap())
			{
				continue;
			}

			if (ally.getTile().getDistanceTo(myTile) <= 1)
			{
				isAlone = false;
				break;
			}
		}

		if (isAlone)
		{
			_properties.Bravery += 10;
			_properties.FatigueRecoveryRate += 3;
			_properties.DamageTotalMult *= 1.1;
		}
	}

});

