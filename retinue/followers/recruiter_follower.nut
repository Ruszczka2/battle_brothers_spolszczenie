this.recruiter_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.recruiter";
		this.m.Name = "Rekruter";
		this.m.Description = "Rekruter to taki podejrzany typ, który podstępami sprawia, że zdesperowani ludzie, uciekający przed złym losem, dołączają do kompanii najemników, by tam spotkał ich nieszczęsny koniec. Dość użyteczna persona w każdej kompanii najemników.";
		this.m.Image = "ui/campfire/recruiter_01";
		this.m.Cost = 3000;
		this.m.Effects = [
			"Sprawia, że płacisz 10% mniej z góry przy werbowaniu ludzi oraz 50% mniej za ich wypróbowanie",
			"Sprawia, że w każdej osadzie jest od 2 do 4 ochotników więcej"
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
		this.World.Assets.m.RosterSizeAdditionalMin += 2;
		this.World.Assets.m.RosterSizeAdditionalMax += 4;
		this.World.Assets.m.HiringCostMult *= 0.9;
		this.World.Assets.m.TryoutPriceMult *= 0.5;
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "Najmnij " + this.Math.min(12, this.World.Statistics.getFlags().getAsInt("BrosHired")) + "/12 ludzi";

		if (this.World.Statistics.getFlags().getAsInt("BrosHired") >= 12)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

