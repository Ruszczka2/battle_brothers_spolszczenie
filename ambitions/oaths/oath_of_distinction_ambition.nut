this.oath_of_distinction_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_distinction";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Prawdziwie wyróżnieni są ci, którzy potrafią podążać naukami Młodego Anzelma.\nZłóżmy Przysięgę Wyróżnienia i udowodnijmy, że zasługujemy, by kroczyć jego ścieżką!";
		this.m.TooltipText = "Młody Anzelm często wybierał samotność, czasem nawet na polu bitwy. \"Udowodnij swą wartość tak, by nawet starzy bogowie nie mogli rzec, że ich oczy zawiodły, gdy oglądali chwałę, jaką ujrzeli.\"";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]{Wielu mistrzów miecza ćwiczy w samotności. Uważa się, że nie walczą z ludźmi stojącymi przed nimi, lecz z przestrzeniami pomiędzy. Choć nie sposób pojąć drobnych niuansów, które odróżniają mistrza miecza od niedoszłego najemnika tnącego powietrze, rozumiesz ziarno prawdy w tej maksymie. Dawcy Przysięgi, choć honorowi i pilni, w sercu wciąż są brutalnie odważni i niedorzecznie pewni siebie. Przysięga Wyróżnienia podążała duchem za sztuką mistrza miecza, a umysłem za Dawcami Przysięgi. Każdy, stojąc osobno, starał się dowieść swej wartości na własny rachunek i zasłużyć na cudzą pochwałę. A jeśli jacyś bezstronni świeccy akurat patrzyli, to diabli by nie potrafili powiedzieć, że %companyname% nie wyróżniło się jako porządny oddział.\n\nAle niech diabli wezmą wyróżnienie. Nie będziemy przecież całe życie gonić za chwałą! Do następnej Przysięgi!}";
		this.m.SuccessButtonText = "{Za Młodego Anzelma! | Za Przysięgających! | I śmierć Dawcom Przysięgi!}";
		this.m.OathName = "Przysięga Wyróżnienia";
		this.m.OathBoonText = "Twoi ludzie zyskują [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Stanowczości, [color=" + this.Const.UI.Color.PositiveValue + "]+3[/color] odnowy Zmęczenia na turę, oraz [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] do zadawanych obrażeń, jeśli na przyległych polach nie ma sojuszników.";
		this.m.OathBurdenText = "Twoi ludzie nie otrzymują doświadczenia za wrogów zabitych przez sojuszników.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Zyskujesz dodatkową Sławę, jeśli jeden z twoich ludzi awansuje " + this.getBonusObjectiveGoal() + " razy (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		brothers.sort(function ( _a, _b )
		{
			if (_a.getFlags().getAsInt("OathtakersDistinctionLevelUps") > _b.getFlags().getAsInt("OathtakersDistinctionLevelUps"))
			{
				return -1;
			}
			else if (_a.getFlags().getAsInt("OathtakersDistinctionLevelUps") < _b.getFlags().getAsInt("OathtakersDistinctionLevelUps"))
			{
				return 1;
			}

			return 0;
		});
		return brothers[0].getFlags().getAsInt("OathtakersDistinctionLevelUps");
	}

	function getBonusObjectiveGoal()
	{
		if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
		{
			return 3;
		}
		else if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
		{
			return 2;
		}
		else
		{
			return 2;
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
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_distinction_trait"));
			bro.getFlags().set("OathtakersDistinctionLevelUps", 0);
		}
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_distinction");
			bro.getFlags().set("OathtakersDistinctionLevelUps", 0);
		}
	}

});

