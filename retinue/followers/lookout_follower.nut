this.lookout_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.lookout";
		this.m.Name = "Czujka";
		this.m.Description = "Posiadanie żwawej Czujki o ostrym wzroku, która podróżuje przed kompanią i dokonuje zwiadu, może się czasem okazać bezcenne w rozpoznawaniu niebezpieczeństw i dostrzeganiu interesujących miejsc, zanim wrogowie cię zauważą.";
		this.m.Image = "ui/campfire/lookout_01";
		this.m.Cost = 2500;
		this.m.Effects = [
			"Zwiększa zasięg wzroku na mapie o 25%",
			"Odkrywa dodatkowe informacje z tropów"
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
		this.World.Assets.m.VisionRadiusMult = 1.25;
		this.World.Assets.m.IsShowingExtendedFootprints = true;
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "Odkryj samodzielnie " + this.Math.min(10, this.World.Statistics.getFlags().getAsInt("LocationsDiscovered")) + "/10 lokacji";

		if (this.World.Statistics.getFlags().getAsInt("LocationsDiscovered") >= 10)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

