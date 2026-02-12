this.negotiator_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.negotiator";
		this.m.Name = "Negocjator";
		this.m.Description = "Negocjator był stałym bywalcem szlacheckich dworów i wykwintnych sal, nie przywykł więc do podróżowania z bandą najemników w zabłoconych trzewikach. Jest jednak ekspertem w poprawianiu relacji oraz negocjowaniu warunków kontraktów.";
		this.m.Image = "ui/campfire/negotiator_01";
		this.m.Cost = 3000;
		this.m.Effects = [
			"Pozwala na więcej rund przy negocjacjach kontraktu, a twoja reputacja nie ucierpi przy fiasku",
			"Sprawia, że dobre relacje z frakcjami degradują wolniej, a złe szybciej się poprawiają"
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
		this.World.Assets.m.NegotiationAnnoyanceMult = 0.5;
		this.World.Assets.m.AdvancePaymentCap = 0.75;
		this.World.Assets.m.RelationDecayGoodMult = 0.85;
		this.World.Assets.m.RelationDecayBadMult = 1.15;
	}

	function onNewDay()
	{
		this.onUpdate();
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "Wypełnij " + this.Math.min(15, this.World.Contracts.getContractsFinished()) + "/15 kontraków";

		if (this.World.Contracts.getContractsFinished() >= 15)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

