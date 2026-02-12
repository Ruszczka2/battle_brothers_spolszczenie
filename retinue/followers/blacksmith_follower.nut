this.blacksmith_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.blacksmith";
		this.m.Name = "Kowal";
		this.m.Description = "Najemnicy świetnie sobie radzą z niszczeniem broni i pancerzy, gorzej z ich konserwacją. Kowal zajmie się tym nudnym zajęciem szybko i efektywnie, może też naprawić wyposażenie, które wydawałoby się całkowicie zniszczone.";
		this.m.Image = "ui/campfire/blacksmith_01";
		this.m.Cost = 3000;
		this.m.Effects = [
			"Naprawia wszystkie zbroje, hełmy, broń i tarcze noszone przez twych ludzi, nawet jeśli są trwale uszkodzone lub zostały utracone przez śmierć któregoś z twoich wojowników",
			"Zwiększa szybkość napraw o 20%",
			"Zmniejsza zużycie narzędzi o 20%"
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
		this.World.Assets.m.RepairSpeedMult *= 1.2;
		this.World.Assets.m.ArmorPartsPerArmor *= 0.8;
		this.World.Assets.m.IsBlacksmithed = true;
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "Napraw " + this.Math.min(5, this.World.Statistics.getFlags().getAsInt("ItemsRepaired")) + "/5 przedmiotów u miejskiego kowala";

		if (this.World.Statistics.getFlags().getAsInt("ItemsRepaired") >= 5)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

