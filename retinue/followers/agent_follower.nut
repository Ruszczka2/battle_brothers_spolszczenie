this.agent_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.agent";
		this.m.Name = "Agentka";
		this.m.Description = "Agentka ma oczy i uszy wszędzie, więc wie dokąd należy się udać, by należycie wykorzystać aktualne wydarzenia w osadach oraz dorwać dobrze płatny kontrakt.";
		this.m.Image = "ui/campfire/agent_01";
		this.m.Cost = 4000;
		this.m.Effects = [
			"Odkrywa dostępne kontrakty oraz obecne sytuacje w podpowiedzi osady, bez względu na to gdzie się znajdujesz"
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = "Miej sojusznicze relacje ze szlacheckim rodem lub państwem-miastem"
			}
		];
	}

	function onUpdate()
	{
	}

	function onEvaluate()
	{
		local allied = false;
		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);

		foreach( n in nobles )
		{
			if (n.getPlayerRelation() >= 90.0)
			{
				this.m.Requirements[0].IsSatisfied = true;
				return;
			}
		}

		local citystates = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);

		foreach( c in citystates )
		{
			if (c.getPlayerRelation() >= 90.0)
			{
				this.m.Requirements[0].IsSatisfied = true;
				return;
			}
		}
	}

});

