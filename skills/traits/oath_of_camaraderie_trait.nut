this.oath_of_camaraderie_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.oath_of_camaraderie";
		this.m.Name = "Przysięga Koleżeństwa";
		this.m.Icon = "ui/traits/trait_icon_85.png";
		this.m.Description = "Ta postać złożyła Przysięgę Koleżeństwa i jest zobowiązana do trwania, w życiu i śmierci, przy swych sojusznikach. Jednak ogólne zamieszanie związane z większą liczebnością na polu walki oraz brak skupienia się na swych indywidualnych umiejętnościach i osobistej chwale odbiły się na determinacji tej postaci, gdy wkracza ona na pole bitwy.";
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
				icon = "ui/icons/morale.png",
				text = "Rozpocznie bitwę z morale niskim lub na granicy załamania"
			}
		];
	}

	function onUpdate( _properties )
	{
		if (this.getContainer().getActor().isPlacedOnMap() && this.Time.getRound() < 1)
		{
			if (this.Math.rand(1, 100) <= 50)
			{
				this.getContainer().getActor().setMoraleState(this.Const.MoraleState.Wavering);
			}
			else
			{
				this.getContainer().getActor().setMoraleState(this.Const.MoraleState.Breaking);
			}
		}
	}

});

