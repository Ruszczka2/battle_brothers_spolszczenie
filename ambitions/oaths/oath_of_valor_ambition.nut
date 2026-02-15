this.oath_of_valor_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_valor";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Musimy mieć odwagę stawić czoło każdemu wyzwaniu, choćby było jak najstraszniejsze.\nZłóżmy Przysięgę Męstwa i dowiedźmy naszej odwagi wszystkim!";
		this.m.TooltipText = "\"Pamiętaj w chwilach grozy, że odwaga potrafi pokonać kunszt. Choć niewiele da się nauczyć z samej brawury, czysta determinacja utrzyma cię przy życiu i to wystarczy jako podsumowanie lekcji bitewnych.\" - Młody Anzelm";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]{Człowiek nie przetrwa dzięki samej umiejętności i sprawności. Wielu wie, jak machać mieczem, dźwigać topór czy wypuszczać strzałę. Nie w sprawach wojennych człowiek jest kształtowany, lecz w sobie samym, w korytarzach własnego serca. Stal wykuta tam nigdy nie zostanie pokonana, bo nawet poległy człowiek męstwa pozostanie wieczny w tomach tego świata, czczony w podziwie, a jego imię niesione będzie na ustach mu podobnych.\n\nTeraz, gdy kompania dowiodła, że jest z najszlachetniejszego kruszcu, jest gotowa przyjąć kolejną Przysięgę!}";
		this.m.SuccessButtonText = "{Za Młodego Anzelma! | Za Przysięgających! | I śmierć Dawcom Przysięgi!}";
		this.m.OathName = "Przysięga Męstwa";
		this.m.OathBoonText = "Twoi ludzie nigdy nie uciekną z bitwy.";
		this.m.OathBurdenText = "Twoi ludzie zdobywają o [color=" + this.Const.UI.Color.NegativeValue + "]15%[/color] mniej doświadczenia.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Zyskujesz dodatkową Sławę za wygrywanie bitew, gdy wróg ma przewagę liczebną (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersDefeatedOutnumbering");
	}

	function getBonusObjectiveGoal()
	{
		if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
		{
			return 5;
		}
		else if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
		{
			return 4;
		}
		else
		{
			return 3;
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
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_valor_trait"));
		}

		this.World.Statistics.getFlags().set("OathtakersDefeatedOutnumbering", 0);
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_valor");
		}

		this.World.Statistics.getFlags().set("OathtakersDefeatedOutnumbering", 0);
	}

});

