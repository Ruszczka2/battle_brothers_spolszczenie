this.oath_of_vengeance_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_vengeance";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Zbyt długo zielonoskórzy nękają nasze ziemie.\nZłóżmy Przysięgę Zemsty i uderzmy w to zagrożenie!";
		this.m.TooltipText = "Rodzina Młodego Anzelma została wybita przez orków podczas Bitwy Wielu Imion. Gdy sam stanął przeciw zielonoskórym, powiada się, że był niepowstrzymanym wojownikiem, a jego wyznawcy pragną naśladować ten mściwy przypływ wojennej biegłości.";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]Zielonoskórzy od dawna trapią ziemie ludzi. Mimo ich wiecznego zagrożenia, niewielu kiedykolwiek złożyłoby przysięgę zniszczenia tych stworów. To plaga właśnie dlatego, że są tak niebezpieczne, a ponieważ są tak niebezpieczne, większość wolałaby odwrócić wzrok, niż śmieć się z nimi zmierzyć. Jednak ludzie %companyname% postanowili złożyć przysięgę przeciw orkom i goblinom, wyruszyć daleko, znaleźć ich i wytropić. Gdy dotrzymali słowa, na kompanię spływa poczucie spełnienia.\n\nLudzie już przebierają nogami: jaką Przysięgę podjąć teraz?";
		this.m.SuccessButtonText = "{Za Młodego Anzelma! | Za Przysięgających! | I śmierć Dawcom Przysięgi!}";
		this.m.RewardTooltip = "";
		this.m.OathName = "Przysięga Zemsty";
		this.m.OathBoonText = "Twoi ludzie mają [color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] do Stanowczości, [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] do Ataku w zwarciu i dystansowego oraz [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] do Obrony w zwarciu i dystansowej podczas walki z zielonoskórymi.";
		this.m.OathBurdenText = "Twoi ludzie mają [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] do Stanowczości, [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] o Ataku w zwarciu i dystansowego oraz [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] do Obrony w zwarciu i dystansowej, gdy walczą z innymi wrogami.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Zyskujesz dodatkową Sławę za zabijanie zielonoskórych (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersGreenskinsSlain");
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
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_vengeance_trait"));
		}

		this.World.Statistics.getFlags().set("OathtakersGreenskinsSlain", 0);
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_vengeance");
		}

		this.World.Statistics.getFlags().set("OathtakersGreenskinsSlain", 0);
	}

});

