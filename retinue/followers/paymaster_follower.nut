this.paymaster_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.paymaster";
		this.m.Name = "Płatnik";
		this.m.Description = "Płatnik zajmuje się wszystkimi codziennymi finansami i aspektami organizacyjnymi prowadzenia kompanii najemników, jak na przykład wypłacanie żołdu.";
		this.m.Image = "ui/campfire/paymaster_01";
		this.m.Cost = 3500;
		this.m.Effects = [
			"Zmniejsza dzienny żołd każdej postaci o 15%",
			"Zmniejsza szansę na dezercję o 50%",
			"Zapobiega żądaniom zwiększenia żołdów podczas wydarzeń"
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = ""
			}
		];
	}

	function isVisible()
	{
		return this.World.Assets.getBrothersMax() >= 16;
	}

	function onUpdate()
	{
		this.World.Assets.m.DailyWageMult *= 0.85;
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "Miej kompanię liczącą " + this.Math.min(16, this.World.getPlayerRoster().getSize()) + "/16 ludzi";

		if (this.World.getPlayerRoster().getSize() >= 16)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

