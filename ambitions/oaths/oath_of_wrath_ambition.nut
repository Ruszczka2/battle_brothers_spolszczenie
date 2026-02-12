this.oath_of_wrath_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_wrath";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "There is no error in battle more fatal than meekness.\nLet us take an Oath of Wrath and show our foes what it truly means to be lain low!";
		this.m.TooltipText = "Young Anselm wrote many manuals on martial fighting, the most popular of which implore the use of two-handed weaponry and the absconsion of battle tact. Dried blood mottles the pages of these texts.";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]When it comes to mortal combat, there\'s only one way to be sure: total annihilation. And the weapon of choice in this death dealing endeavor is that of the two-hander. The men of the %companyname% took to the Oath of Wrath like moths to a fiery half-completed blacksmith\'s iron, when it retches from the coals red hot and blazing, the smithy standing over it as some mad executioner, hammer in hand, ready to flatten its glowing edges into a finished product of ultimate killing, and he turns it up and realizes the chunk of metal is too large for an ordinary man, but big enough to cleave someone in two if put in the proper hands. And so the %companyname% disregarded defense and welcomed bloodletting with open arms.\n\nBloodslaked and with satiated wrath, the %companyname% is ready to take its next Oath!";
		this.m.SuccessButtonText = "{Za Młodego Anzelma! | Za Przysięgających! | I śmierć Dawcom Przysięgi!}";
		this.m.OathName = "Przysięga Gniewu";
		this.m.OathBoonText = "Twoi ludzie mają [color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color]  do szansy trafienia podczas władania dwuręczną lub oburącz trzymaną bronią do walki w zwarciu, a ich zabójstwa zawsze będą śmiertelne, o ile będzie to możliwe.";
		this.m.OathBurdenText = "Twoi ludzie mają [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] do Ataku w zwarciu oraz [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] do Obrony dystansowej.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Zyskujesz dodatkową Sławę za zabijanie swych wrogów (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersWrathSlain");
	}

	function getBonusObjectiveGoal()
	{
		if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
		{
			return 100;
		}
		else if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
		{
			return 75;
		}
		else
		{
			return 50;
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
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_wrath_trait"));
		}

		this.World.Statistics.getFlags().set("OathtakersWrathSlain", 0);
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_wrath");
		}

		this.World.Statistics.getFlags().set("OathtakersWrathSlain", 0);
	}

});

