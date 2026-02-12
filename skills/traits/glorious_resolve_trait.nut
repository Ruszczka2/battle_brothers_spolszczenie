this.glorious_resolve_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.glorious";
		this.m.Name = "Sławetna Stanowczość";
		this.m.Icon = "ui/traits/trait_icon_72.png";
		this.m.Description = "Ten gladiator walczył z ludźmi oraz bestiami na arenach południa i wiele trzeba, aby złamać jego stanowczość. Jego bajeczny styl życia wymaga wysokiego żołdu, lecz nigdy nie zdezerteruje i nie można go zwolnić. Jeśli wszyscy trzej początkowi członkowie zginą, twoja kampania się zakończy.";
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
				icon = "ui/icons/special.png",
				text = "Przy każdym nieudanym teście na morale ma drugą szansę, by wykonać ten test"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.RerollMoraleChance = 100;
	}

});

