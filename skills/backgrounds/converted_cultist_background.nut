this.converted_cultist_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.converted_cultist";
		this.m.Name = "Kultysta";
		this.m.Icon = "ui/backgrounds/background_34.png";
		this.m.HiringCost = 45;
		this.m.DailyCost = 4;
		this.m.Excluded = [
			"trait.athletic",
			"trait.bright",
			"trait.drunkard",
			"trait.dastard",
			"trait.gluttonous",
			"trait.insecure",
			"trait.disloyal",
			"trait.hesitant",
			"trait.fat",
			"trait.bright",
			"trait.greedy",
			"trait.craven",
			"trait.fainthearted"
		];
		this.m.Titles = [
			"Kultysta",
			"Szalony",
			"Wierzący",
			"Obłąkany"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
	}

	function onBuildDescription()
	{
		return "Już nieistotne jest to, kim wcześniej był ten człowiek. Teraz nosi piętno Davkula na swym czole i choć jego usta jeszcze nie znają słów jego nowej religii, przemawiają o fascynacji kultu w znajomym języku. Ciemność, jak rzecze, nadciąga...";
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (!tattoo_body.HasBrush && this.Math.rand(1, 100) <= 50)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("tattoo_01_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		actor.setDirty(true);
	}

});

