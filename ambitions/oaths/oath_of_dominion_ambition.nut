this.oath_of_dominion_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_dominion";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Bestie od zawsze zagrażały cywilizacji.\nZłóżmy Przysięgę Zwierzchnictwa i postawmy się przypływom natury!";
		this.m.TooltipText = "\"Jesteśmy z bestii, ale bestie pragną nas z powrotem. Odgrodź się od prymitywności natury i dowiedź swej wartości nad Nią, by twoje człowieczeństwo spoczywało w uścisku własnych dłoni i było widziane własnymi oczami.\" - Młody Anzelm";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]Nie ma w tym świecie bardziej pospolitego zagrożenia niż zwykła bestia. A jednak, mimo tej plagi stworzeń, niewielu ludzi gotowych jest chwycić za broń i wyruszyć na ich zgładzenie. Tylko wy, %companyname%, złożyliście przysięgę, by zabijać potwory, i tak też uczyniliście. Ze spokojnymi dłońmi i uciszonymi sercami dochowaliście Przysięgi.\n\nTriumfując nad bestiami i potworami, ludzie są gotowi na to, co będzie dalej!";
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

