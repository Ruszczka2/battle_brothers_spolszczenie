this.alchemist_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.alchemist";
		this.m.Name = "Alchemik";
		this.m.Description = "Alchemik doskonale zna się na tworzeniu wszelakich tajemniczych przyrządów i mikstur z egzotycznych składników, gdy da mu się dostęp do ekwipunku taksydermisty, a do tego do produkcji zużywa mniej materiałów.";
		this.m.Image = "ui/campfire/alchemist_01";
		this.m.Cost = 2500;
		this.m.Effects = [
			"Ma 25% szansy przy tworzeniu przedmiotu, że żaden komponent nie zostanie zużyty",
			"Umożliwia tworzenie \'Wężowego Olejku\', który można uzyskać z dość pospolitych składników i sprzedać z zyskiem"
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = ""
			}
		];
	}

	function isValid()
	{
		return this.Const.DLC.Unhold;
	}

	function onUpdate()
	{
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "Utworzono " + this.Math.min(15, this.World.Statistics.getFlags().getAsInt("ItemsCrafted")) + "/15 przedmiotów u taksydermisty";

		if (this.World.Statistics.getFlags().getAsInt("ItemsCrafted") >= 15)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

