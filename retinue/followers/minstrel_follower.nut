this.minstrel_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.minstrel";
		this.m.Name = "Minstrel";
		this.m.Description = "Dobra pieśń i opowieść odgrywają znaczną rolę w tworzeniu reputacji kompanii. Minstrel jest mistrzem tego rzemiosła i dopilnuje, aby wieści o twoich wyczynach dotarły do uszu wszystkich - czy będą chcieli słuchać, czy nie.";
		this.m.Image = "ui/campfire/minstrel_01";
		this.m.Cost = 2000;
		this.m.Effects = [
			"Sprawia, że zyskujesz 15% więcej sławy",
			"Zwiększa szansę, że plotki w gospodach będą zawierały jakieś użyteczne informacje"
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
		this.World.Assets.m.BusinessReputationRate *= 1.15;
		this.World.Assets.m.IsNonFlavorRumorsOnly = true;
	}

	function onEvaluate()
	{
		local settlements = this.World.EntityManager.getSettlements();
		local settlementsVisited = 0;
		local maxSettlements = settlements.len();

		foreach( s in settlements )
		{
			if (s.isVisited())
			{
				settlementsVisited = ++settlementsVisited;
				settlementsVisited = settlementsVisited;
			}
		}

		this.m.Requirements[0].Text = "Odwiedź " + settlementsVisited + "/" + maxSettlements + " osad";

		if (settlementsVisited >= maxSettlements)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

