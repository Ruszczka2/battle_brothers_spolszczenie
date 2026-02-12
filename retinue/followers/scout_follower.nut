this.scout_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.scout";
		this.m.Name = "Zwiadowca";
		this.m.Description = "Zwiadowca jest mistrzem w odnajdywaniu górskich ścieżek, nawigowaniu po zdradzieckich grzęzawiskach i przeprowadzaniu bezpiecznie każdego przez mroki gęstych kniei.";
		this.m.Image = "ui/campfire/scout_01";
		this.m.Cost = 2500;
		this.m.Effects = [
			"Sprawia, że kompania podróżuje o 15% szybciej na każdym terenie",
			"Zapobiega chorobom i wypadkom związanym z terenem"
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = ""
			}
		];
	}

	function onUpdate()
	{
		for( local i = 0; i < this.World.Assets.m.TerrainTypeSpeedMult.len(); i = i )
		{
			this.World.Assets.m.TerrainTypeSpeedMult[i] *= 1.15;
			i = ++i;
		}
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "Wygraj " + this.Math.min(5, this.World.Statistics.getFlags().getAsInt("BeastsDefeated")) + "/5 bitew przeciwko bestiom";

		if (this.World.Statistics.getFlags().getAsInt("BeastsDefeated") >= 5)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

