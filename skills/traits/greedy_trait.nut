this.greedy_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.greedy";
		this.m.Name = "Chciwy";
		this.m.Icon = "ui/traits/trait_icon_06.png";
		this.m.Description = "Chcę więcej! Ta postać jest chciwa i będzie się domagać wyższego żołdu, niż inni jej podobni, a do tego szybko da nogę, gdy kompanii skończą się korony.";
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
			}
		];
	}

	function addTitle()
	{
		this.character_trait.addTitle();
	}

	function onUpdate( _properties )
	{
		_properties.DailyWageMult *= 1.15;
	}

});

