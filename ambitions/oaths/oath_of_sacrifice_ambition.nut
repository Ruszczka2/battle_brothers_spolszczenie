this.oath_of_sacrifice_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_sacrifice";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "We cannot live up to Young Anselm\'s example if we obsess over worldly matters.\nLet us take an Oath of Sacrifice and hone our purpose to its sharpest point.";
		this.m.TooltipText = "\"If all is within the realm of the old gods\' gifts, then pain itself shall be their bitterest fruit. But an offering it is, nonetheless, and so our battle against pain is one of great selfishness. Abscise from the healer\'s mend, and equally so from the merchant\'s lend.\" - Young Anselm";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]{The priory monks will go days without water, weeks without food, and forever without sex. It is believed that sacrifice is the \'salt of all things\', and is so powerful an element that in the ashes of those who have willingly suffered one finds the residue of endurance itself. Now, having undertaken a similar oath, you understand why the holy men handle the ashen remains of their brethren with a sort of maternal care. For the %companyname%, this everlasting strength was spread across the company, for misery is a terrible thing, but shared misery, taken head on and shoulder to shoulder with your brothers in arms, is a poignant elixir, one that narrows the mind unto that which needs to be done, and eschews all earthly matters.\n\nNow the men shall heal up and their minds return to the tethers which keep them grounded. Leave it to the monks to sacrifice for the long haul, they are of stronger intellects and faiths, ones to look to, not foolishly follow feeling you may do the same as them.\n\nAs for the future, it is time the Oathtakers take on another Oath!}";
		this.m.SuccessButtonText = "{Za Młodego Anzelma! | Za Przysięgających! | I śmierć Dawcom Przysięgi!}";
		this.m.OathName = "Przysięga Poświęcenia";
		this.m.OathBoonText = "Żaden z twoich ludzi nie przyjmuje żołdu.";
		this.m.OathBurdenText = "Rany i kontuzje twoich ludzi się nie leczą.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() <= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Zyskujesz dodatkową Sławę za otrzymanie nie więcej, niż " + this.getBonusObjectiveGoal() + " ran bitewnych (rany otrzymane do tej pory: " + this.getBonusObjectiveProgress() + ")";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersInjuriesSuffered");
	}

	function getBonusObjectiveGoal()
	{
		if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
		{
			return 4;
		}
		else if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
		{
			return 6;
		}
		else
		{
			return 8;
		}
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5) + (this.m.IsDone ? 0 : 10) + this.m.TimesSkipped * 2;
	}

	function onStart()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_sacrifice_trait"));
		}

		this.World.Statistics.getFlags().set("OathtakersInjuriesSuffered", 0);
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_sacrifice");
		}

		this.World.Statistics.getFlags().set("OathtakersInjuriesSuffered", 0);
	}

});

