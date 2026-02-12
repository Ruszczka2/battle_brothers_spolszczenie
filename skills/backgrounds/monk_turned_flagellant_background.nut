this.monk_turned_flagellant_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.monk_turned_flagellant";
		this.m.Name = "Mnich Biczownik";
		this.m.Icon = "ui/backgrounds/background_26.png";
		this.m.HiringCost = 60;
		this.m.DailyCost = 5;
		this.m.Excluded = [
			"trait.clubfooted",
			"trait.tough",
			"trait.strong",
			"trait.disloyal",
			"trait.insecure",
			"trait.cocky",
			"trait.fat",
			"trait.fainthearted",
			"trait.bright",
			"trait.craven",
			"trait.greedy",
			"trait.gluttonous"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.IsOffendedByViolence = true;
	}

	function onBuildDescription()
	{
		return "Ten świat był zbyt mroczny, by %name% dalej podążał swoją ścieżką. Rozmowa z biczownikiem pokazała mu, że dawni bogowie nie są zadowoleni z ludzi, którzy szukają sprawiedliwości drogą rozsądku. Teraz można dostrzec, jak były mnich biczuje się, krwawiąc prawością na ten świat z każdym kolejnym uderzeniem.";
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 3) == 3)
		{
			local actor = this.getContainer().getActor();

			if (actor.getTitle() == "")
			{
				actor.setTitle(this.Const.Strings.PilgrimTitles[this.Math.rand(0, this.Const.Strings.PilgrimTitles.len() - 1)]);
			}
		}
	}

	function onAddEquipment()
	{
	}

});

