this.no_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.none";
		this.m.Duration = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Kompania świetnie sobie radzi, tylko tak trzymać!\n(Brak Ambicji)";
		this.m.RewardTooltip = null;
	}

	function getButtonTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "header",
				text = "Brak Ambicji"
			},
			{
				id = 2,
				type = "text",
				text = "Nie wybieraj teraz ambicji. Zostaniesz ponownie zapytany o wybranie nowej za trzy dni."
			}
		];
		return ret;
	}

});

