this.oath_of_righteousness_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_righteousness";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Niewiele wynaturzeń jest tak odrażających jak nieumarli.\nZłóżmy Przysięgę Prawości i strąćmy te karykatury życia!";
		this.m.TooltipText = "\"Strzeżcie się zła, które wdarło się do tego królestwa. Odłóżcie sprawy doczesne i poświęćcie się złożeniu naszych zmarłych do spoczynku raz na zawsze. Żaden człowiek nie zasługuje, by przejść dwa razy przez tę mroczną ziemię.\" - Młody Anzelm";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]Kiedy kroczysz po ziemi, nie sposób nie zastanawiać się, kto był przed tobą i kto lub co przyjdzie po tobie. Widok umarłych, którzy znów chodzą, jest tak niepokojącą odpowiedzią na to pytanie, że większość wolałaby uciec, niż szukać potwierdzenia, a w tym potwierdzeniu: konfrontacji. Ale to właśnie tych bezbożnych łajdaków ścigało %companyname%, przysięgając zgładzić ich wszędzie, gdzie się pojawią. Była to sprawa prawego serca, wymagająca wielkiego hartu i zdumiewającej odwagi, a po jej ukończeniu nie ma wątpliwości, że ludzie %companyname% zostali natchnieni poczuciem spełnienia, jakiego mało kto chodzący po tej ziemi, żywy czy martwy, kiedykolwiek doświadczy.\n\nZ żyłami płonącymi prawością %companyname% jest gotowa na kolejną Przysięgę!";
		this.m.SuccessButtonText = "{Za Młodego Anzelma! | Za Przysięgających! | I śmierć Dawcom Przysięgi!}";
		this.m.RewardTooltip = "";
		this.m.OathName = "Przysięga Prawości";
		this.m.OathBoonText = "Twoi ludzie mają [color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] do Stanowczości, [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] do Ataku w zwarciu i dystansowego oraz [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] do Obrony w zwarciu i dystansowej podczas walki z nieumarłymi.";
		this.m.OathBurdenText = "Twoi ludzie mają [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] do Stanowczości, [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] do Ataku w zwarciu i dystansowego oraz [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color]  do Obrony w zwarciu i dystansowej podczas walki z pozostałymi wrogami.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Zyskujesz dodatkową Sławę za zabijanie nieumarłych (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersUndeadSlain");
	}

	function getBonusObjectiveGoal()
	{
		if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
		{
			return 75;
		}
		else if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
		{
			return 50;
		}
		else
		{
			return 25;
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

		if (this.World.Ambitions.getDone() < 3)
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
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_righteousness_trait"));
		}

		this.World.Statistics.getFlags().set("OathtakersUndeadSlain", 0);
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_righteousness");
		}

		this.World.Statistics.getFlags().set("OathtakersUndeadSlain", 0);
	}

});

