this.oath_of_humility_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_humility";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Pycha to podstępny zabójca.\nZłóżmy Przysięgę Pokory i przez jakiś czas pochylmy się nad własnymi brakami.";
		this.m.TooltipText = "\"Skoro rzeczywiście jesteście ludźmi w pogoni za potęgą, zawsze słuchajcie słabych... bo słabi znają silnych lepiej, niż wy znacie ich, a w zamian poznają was lepiej, niż wy znacie samych siebie.\" - Młody Anzelm";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]Każdy słaby człowiek potrafi uklęknąć, lecz uczynić to z pozycji siły to prawdziwa pokora. Choć %companyname% mogło użyć swej sławy do zbicia nowej fortuny, zamiast tego stanęło z boku, przeznaczając część majątku potrzebującym i z powrotem dla wspólnot, które w pierwszej kolejności oferowały te kontrakty. Wielu ludzi wiele się z tego nauczyło i jest nadzieja, że zastosowane metody przydadzą się w przyszłości, czy to w tym życiu, czy w następnym.\n\n%companyname% jest gotowa na kolejne wyzwanie.";
		this.m.SuccessButtonText = "{Za Młodego Anzelma! | Za Przysięgających! | I śmierć Dawcom Przysięgi!}";
		this.m.OathName = "Przysięga Pokory";
		this.m.OathBoonText = "Twoi ludzie zdobywają o [color=" + this.Const.UI.Color.PositiveValue + "]10%[/color] więcej doświadczenia.";
		this.m.OathBurdenText = "Zdobywasz o [color=" + this.Const.UI.Color.NegativeValue + "]25%[/color] mniej koron z kontraktów.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Zyskujesz dodatkową Sławę za wykonywanie kontraktów (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersContractsComplete");
	}

	function getBonusObjectiveGoal()
	{
		if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
		{
			return 7;
		}
		else if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
		{
			return 6;
		}
		else
		{
			return 5;
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

	function onUpdateEffect()
	{
		this.World.Assets.m.ContractPaymentMult *= 0.75;
	}

	function onStart()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_humility_trait"));
		}

		this.World.Statistics.getFlags().set("OathtakersContractsComplete", 0);
		this.World.Assets.resetToDefaults();
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_humility");
		}

		this.World.Statistics.getFlags().set("OathtakersContractsComplete", 0);
	}

});

