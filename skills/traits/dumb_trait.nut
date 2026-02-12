this.dumb_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.dumb";
		this.m.Name = "Głupi";
		this.m.Icon = "ui/traits/trait_icon_17.png";
		this.m.Description = "Umm, że co? Ta postać nie należy do najbystrzejszych, a przyswojenie nowych rzeczy niełatwo jej przychodzi.";
		this.m.Titles = [
			"Opóźniony",
			"Dureń",
			"Osobliwy"
		];
		this.m.Excluded = [
			"trait.bright",
			"trait.aspiring",
			"trait.sophisticated",
			"trait.teamplayer"
		];
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
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] do zdobywanego doświadczenia"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.XPGainMult *= 0.85;
	}

});

