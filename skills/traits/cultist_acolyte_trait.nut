this.cultist_acolyte_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.cultist_acolyte";
		this.m.Name = "Akolita Davkula";
		this.m.Icon = "ui/traits/trait_icon_66.png";
		this.m.Description = "Ta postać jest akolitą Davkula, jednostką posiadającą poufną wiedzę nauk o tym starym bogu. Z radością wita ból fizyczny i niebezpieczeństwa, gdyż zbliżają ją one do zbawienia.";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
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
				id = 11,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+2[/color] odnowy Zmęczenia na turę"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] do Stanowczości"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/morale.png",
				text = "Brak testów na morale po śmierci sojusznika"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/morale.png",
				text = "Brak testów na morale po utraceniu punktów zdrowia"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.FatigueRecoveryRate += 2;
		_properties.Bravery += 10;
		_properties.IsAffectedByDyingAllies = false;
		_properties.IsAffectedByLosingHitpoints = false;
	}

});

