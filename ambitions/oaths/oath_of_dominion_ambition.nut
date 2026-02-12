this.oath_of_dominion_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_dominion";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Beasts have always threatened civilization.\nLet us take an Oath of Dominion and stake our claim against the tides of nature!";
		this.m.TooltipText = "\"We are from the beasts, but the beasts wish to have us back. Distance oneself from nature\'s primitiveness, prove your worth over Her such that your humanity be held in the grip of your own hands and seen through thine own eyes.\" - Young Anselm";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]There is no more common a menace in this world than that of the common beast. And yet, despite this rampant disease of creatures, very few men are willing to take up arms and go seeking their vanquishment. It is only you all, the %companyname%, who swore an oath to slay the monsters, and slay them you did. With steady hands and stilled hearts, you kept to that Oath.\n\nTriumphant over beasts and monsters, the men are ready to take on whatever\'s next!";
		this.m.SuccessButtonText = "{Za Młodego Anzelma! | Za Przysięgających! | I śmierć Dawcom Przysięgi!}";
		this.m.RewardTooltip = "";
		this.m.OathName = "Przysięga Zwierzchnictwa";
		this.m.OathBoonText = "Twoi ludzie mają [color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] do Stanowczości oraz [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] do Ataku w zwarciu i dystansowego podczas walk z bestiami.";
		this.m.OathBurdenText = "Twoi ludzie mają [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color]  do Stanowczości oraz [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] do Ataku w zwarciu i dystansowego podczas walk z pozostałymi wrogami.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Zyskujesz dodatkową Sławę za zabijanie bestii (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersBeastsSlain");
	}

	function getBonusObjectiveGoal()
	{
		if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
		{
			return 50;
		}
		else if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
		{
			return 35;
		}
		else
		{
			return 20;
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

		if (this.World.Ambitions.getDone() < 2)
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
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_dominion_trait"));
		}

		this.World.Statistics.getFlags().set("OathtakersBeastsSlain", 0);
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_dominion");
		}

		this.World.Statistics.getFlags().set("OathtakersBeastsSlain", 0);
	}

});

