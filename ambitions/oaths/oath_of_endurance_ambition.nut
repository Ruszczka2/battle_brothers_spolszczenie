this.oath_of_endurance_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_endurance";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Wypełniać Przysięgi Młodego Anzelma znaczy brać na siebie obowiązek bez końca.\nZłóżmy Przysięgę Wytrzymałości i przygotujmy się na nadchodzące zadania!";
		this.m.TooltipText = "\"Trzykroć po trzy wspięli się i w wytrwałości ją znaleźli.\" Mówi się, że gdy Młody Anzelm zdobył najwyższy szczyt pasma Higgariańskiego, zabrał ze sobą dziewięciu najgodniejszych towarzyszy.";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]{Zapytany, jaką armię chciałby ujrzeć rozstawioną przed sobą, pewien sławny generał odparł: \'taką, która nie musi oddychać.\' Bez względu na to, jak biegły jest człowiek, jeśli brak mu energii do walki, wszystkie jego umiejętności redukują się do samego tylko świstu powietrza, a w takim stanie nawet mistrz miecza bywa groźny co najwyżej jak karczemna dziewka od nalewek. Dobry oddech wzięty teraz to lepiej wymierzony cios miecza później. %companyname% poszło tą maksymą do samego końca!\n\nTeraz, gdy kompania napełniła płuca właściwym ogniem, jest gotowa przyjąć kolejną Przysięgę!}";
		this.m.SuccessButtonText = "{Za Młodego Anzelma! | Za Przysięgających! | I śmierć Dawcom Przysięgi!}";
		this.m.OathName = "Przysięga Wytrzymałości";
		this.m.OathBoonText = "Twoi ludzie mają [color=" + this.Const.UI.Color.PositiveValue + "]+3[/color] odnowy Zmęczenia na turę.";
		this.m.OathBurdenText = "Możesz wziąć do bitwy tylko [color=" + this.Const.UI.Color.NegativeValue + "]10[/color] ludzi.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Zyskujesz dodatkową Sławę za wygrywanie wielu bitew (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersBattlesWon");
	}

	function getBonusObjectiveGoal()
	{
		if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
		{
			return 10;
		}
		else if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
		{
			return 9;
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

		if (this.World.Ambitions.getDone() < 3)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() < 10)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5) + (this.m.IsDone ? 0 : 10) + this.m.TimesSkipped * 2;
	}

	function onUpdateEffect()
	{
		this.World.Assets.m.BrothersMaxInCombat = 10;
	}

	function onStart()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_endurance_trait"));
		}

		this.World.Statistics.getFlags().set("OathtakersBattlesWon", 0);
		this.World.Assets.resetToDefaults();
		this.World.Assets.updateFormation(true);
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_endurance");
		}

		this.World.Statistics.getFlags().set("OathtakersBattlesWon", 0);
	}

});

