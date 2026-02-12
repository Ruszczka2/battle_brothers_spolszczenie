this.brigand_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.brigand";
		this.m.Name = "Zbój";
		this.m.Description = "Zbój może i jest teraz stary i słaby, ale niegdyś jego imię wzbudzało lęk w całej krainie. W zamian za ciepły posiłek z radością podzieli się tym, czego dowie się od swoich dawnych kontaktów o karawanach podróżujących po gościńcach.";
		this.m.Image = "ui/campfire/brigand_01";
		this.m.Cost = 2500;
		this.m.Effects = [
			"Sprawia, że widzisz pozycję niektórych karawan cały czas, nawet jeśli są poza zasięgiem twojego wzroku"
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
		this.World.Assets.m.IsBrigand = true;
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "Napadnij na " + this.Math.min(4, this.World.Statistics.getFlags().getAsInt("CaravansRaided")) + "/4 karawany";

		if (this.World.Statistics.getFlags().getAsInt("CaravansRaided") >= 4)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

