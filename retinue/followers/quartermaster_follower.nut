this.quartermaster_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.quartermaster";
		this.m.Name = "Kwatermistrz";
		this.m.Description = "Dzięki doświadczeniu zdobytemu przez długie lata poróżowania z karawanami, Kwatermistrz jest w stanie upchać każdą część sprzętu, tobołków czy zbroi w idealne miejsce, aby jak najlepiej wykorzystać dostępną pojemność inwentarza.";
		this.m.Image = "ui/campfire/quartermaster_01";
		this.m.Cost = 3000;
		this.m.Effects = [
			"Zwiększa o 100 maksymalną posiadaną ilość amunicji",
			"Zwiększa o 50 maksymalną posiadaną ilość medykamentów oraz narzędzi"
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
		this.World.Assets.m.AmmoMaxAdditional = 100;
		this.World.Assets.m.MedicineMaxAdditional = 50;
		this.World.Assets.m.ArmorPartsMaxAdditional = 50;
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "Ukończ " + this.Math.min(5, this.World.Statistics.getFlags().getAsInt("EscortCaravanContractsDone")) + "/5 kontraktów na eskortę karawany";

		if (this.World.Statistics.getFlags().getAsInt("EscortCaravanContractsDone") >= 5)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

