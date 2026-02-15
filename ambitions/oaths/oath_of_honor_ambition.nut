this.oath_of_honor_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_honor";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Jako wojownicy nigdy nie możemy tracić z oczu prawdziwego honoru.\nZłóżmy Przysięgę Honoru i spotykajmy przeciwników w zwarciu!";
		this.m.TooltipText = "\"Gdy strzała jest na cięciwie, umysł błądzi. Gdy miecz się zamachuje, wszystko jest na swoim miejscu. Odłóż rzemiosło łucznicze i idź ku zwarciu, ufając, że to, czego szuka twoja stal, zostanie znalezione.\" - Młody Anzelm";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]Bez względu na to, co chcą mówić łucznicy, kiedy przychodzi co do czego, nie ma większego honoru niż stanąć z człowiekiem twarzą w twarz, każdy z was z mieczem w dłoni, łącząc spojrzenia nad skrzyżowaną stalą, znajdując w tym zderzeniu krótką ulgę, zanim któryś spotka swój kres. Nawet w turniejach wielkim wydarzeniem nie jest jakiś niedorzeczny popis, jak strzelanie do jabłek na głowach czy strącanie ptaków z nieba. Nie, to szarża kopii! Walka orężna! Największy honor w bitwie, podjęty przez największą kompanię, jaką jest %companyname%.\n\nTeraz, gdy kompania ma twardą siłę i krzepę, jest gotowa przyjąć kolejną Przysięgę!";
		this.m.SuccessButtonText = "{Za Młodego Anzelma! | Za Przysięgających! | I śmierć Dawcom Przysięgi!}";
		this.m.OathName = "Przysięga Honor";
		this.m.OathBoonText = "Twoi ludzie rozpoczynają bitwę z wysokimi morale.";
		this.m.OathBurdenText = "Twoi ludzie nie mogą używać broni dystansowej.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Zyskujesz dodatkową Sławę za pokonywanie wrogów, którzy nie są zaprzątnięci walką z innymi walczącymi (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersSoloKills");
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

		if (this.World.Ambitions.getDone() < 1)
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
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_honor_trait"));
			bro.getSkills().add(this.new("scripts/skills/special/oath_of_honor_warning"));
		}

		this.World.Statistics.getFlags().set("OathtakersSoloKills", 0);
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_honor");
			bro.getSkills().removeByID("special.oath_of_honor_warning");
		}

		this.World.Statistics.getFlags().set("OathtakersSoloKills", 0);
	}

});

