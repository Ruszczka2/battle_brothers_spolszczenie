this.oath_of_fortification_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_fortification";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Złoczyńcy kryją się i czają z dala od murów sprawiedliwych.\nZłóżmy Przysięgę Obwarowania i zanieśmy te mury do nich!";
		this.m.TooltipText = "\"Zaufaj tarczom tak, jak zaufałbyś starym bogom, bo dar drzew i ziemi nie powinien marnować się na drżącym zawiasie ramienia tchórza.\" - Młody Anzelm";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]{Teksty Starożytnego Imperium opowiadają o szykach tak ściśle splecionych i zwartych, że były niczym wędrujące zamki na nogach: setki tarcz trzymanych razem jak łuski węża lub skorupa żółwia. %companyname% starało się odtworzyć te teorie. Zawsze potrzeba było kilku chwil, by ułożyć elementy, lecz nigdy nie zamierzałeś uczynić z tego ćwiczenia w doskonałości. Starożytni mieli imperium nie bez powodu, a ty masz kompanię obdartusów i Dawców Przysięgi. Ale wedle twojej miary, która zaczyna się i kończy na tym, czy kompania wciąż ma puls, ta przysięga okazała się wybitnym sukcesem.\n\nCzas opuścić tarcze i żarliwość Starożytnego Imperium i podjąć nową Przysięgę!}";
		this.m.SuccessButtonText = "{Za Młodego Anzelma! | Za Przysięgających! | I śmierć Dawcom Przysięgi!}";
		this.m.OathName = "Przysięga Obwarowania";
		this.m.OathBoonText = "Twoi ludzie akumulują o [color=" + this.Const.UI.Color.NegativeValue + "]25%[/color] Zmęczenia podczas używania umiejętności tarczy. Umiejętność \'Ściana Tarcz\' daje dodatkowe [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] do Obrony w zwarciu oraz [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] do Obrony dystansowej. Umiejętność \'Odepchnij\' wytrąca cele z równowagi.";
		this.m.OathBurdenText = "Twoi ludzie nie mogą się poruszyć w pierwszej turze walki.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() <= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Zyskujesz dodatkową Sławę, jeśli żaden z twoich ludzi nie zginie podczas wypełniania Przysięgi (ilość poległych: " + this.getBonusObjectiveProgress() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersBrosDead");
	}

	function getBonusObjectiveGoal()
	{
		return 0;
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
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_fortification_trait"));
			bro.getSkills().add(this.new("scripts/skills/special/oath_of_fortification_warning"));
		}

		this.World.Statistics.getFlags().set("OathtakersBrosDead", 0);
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_fortification");
			bro.getSkills().removeByID("special.oath_of_fortification_warning");
		}

		this.World.Statistics.getFlags().set("OathtakersBrosDead", 0);
	}

});

