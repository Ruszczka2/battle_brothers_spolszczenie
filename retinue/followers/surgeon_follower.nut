this.surgeon_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.surgeon";
		this.m.Name = "Felczer";
		this.m.Description = "Felczer to chodzący tom wiedzy anatomicznej. Kompania najemników wydaje się idealnym miejscem, zarówno by wykorzystać tę wiedzę do leczenia, jak i by lepiej przyjrzeć się ludzkim wnętrznościom.";
		this.m.Image = "ui/campfire/surgeon_01";
		this.m.Cost = 3500;
		this.m.Effects = [
			"Sprawia, że każda osoba bez permanentnej rany ma zagwarantowane to, że przeżyje cios, który inaczej byłby śmiertelny",
			"Sprawia, że każda rana goi się o jeden dzień szybciej"
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
		this.World.Assets.m.IsSurvivalGuaranteed = true;
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "Opatrz " + this.Math.min(5, this.World.Statistics.getFlags().getAsInt("InjuriesTreatedAtTemple")) + "/5 rannych ludzi w świątyni";

		if (this.World.Statistics.getFlags().getAsInt("InjuriesTreatedAtTemple") >= 5)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

