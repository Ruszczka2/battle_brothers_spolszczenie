this.scavenger_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.scavenger";
		this.m.Name = "Szabrownik";
		this.m.Description = "Nieważne, czy jest to syn jednego z twoich ludzi, czy jakaś sierota, nad którą się zlitowałeś, Szabrownik zarabia na swój wikt i opierunek przeczesując pole bitwy i zbierając wszystko to, co jeszcze może się przydać.";
		this.m.Image = "ui/campfire/scavenger_01";
		this.m.Cost = 3000;
		this.m.Effects = [
			"Odzyskuje część amunicji użytej podczas bitwy",
			"Odzyskuje narzędzia i zapasy z każdego zniszczonego podczas bitwy pancerza"
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = "Miej serce"
			}
		];
	}

	function onUpdate()
	{
		this.World.Assets.m.IsRecoveringAmmo = true;
		this.World.Assets.m.IsRecoveringArmor = true;
	}

	function onEvaluate()
	{
		this.m.Requirements[0].IsSatisfied = true;
	}

});

