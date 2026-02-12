this.disloyal_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.disloyal";
		this.m.Name = "Nielojalny";
		this.m.Icon = "ui/traits/trait_icon_35.png";
		this.m.Description = "Muszę myśleć przede wszystkim o sobie! Ta postać jest niezbyt lojalna i szybko opuści kompanię, jeśli skończą się korony lub zapasy żywności.";
		this.m.Titles = [
			"Kłamca"
		];
		this.m.Excluded = [
			"trait.loyal",
			"trait.brave",
			"trait.fearless"
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
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Nigdy nie przeszkadza mu bycie w rezerwie"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.IsContentWithBeingInReserve = true;
	}

});

