this.oath_of_sacrifice_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_sacrifice";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Nie będziemy jak Młody Anzelm, jeśli zajmiemy się rzeczami przyziemnymi.\nZłóżmy Przysięgę Poświęcenia i naostrzmy nasz cel do kresu.";
		this.m.TooltipText = "\"Jeśli wszystko jest w zasięgu darów starych bogów, to ból sam w sobie jest ich najgorzszym owocem. Lecz ofiarą pozostaje mimo to, a więc nasza walka z bólem jest w istocie wielką samolubnością. Odrzućcie uzdrowicieli i ich leczenie, a także kupców i ich pożyczki.\" - Młody Anzelm";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]{Mnisi z przeoratu potrafią przeżyć dni bez wody, tygodnie bez jedzenia i całe życie bez seksu. Wierzy się, że poświęcenie jest \'solą wszystkich rzeczy\', tak potężnym składnikiem, że w popiołach tych, którzy dobrowolnie cierpieli, znajduje się osad samej wytrzymałości. Teraz, gdy podjąłeś podobną przysięgę, rozumiesz, dlaczego święci mężowie obchodzą się z popiołami swych braci z matczyną troską. Dla %companyname% ta nieprzemijająca siła rozeszła się po całej kompanii, bo niedola to straszna rzecz, ale wspólna niedola, przyjęta z otwartą przyłbicą i ramię w ramię z braćmi w broni, jest przejmującym eliksirem, takim, który zwęża umysł do tego, co trzeba uczynić, i odrzuca wszystkie sprawy ziemskie.\n\nTeraz ludzie wyleczą rany, a ich umysły powrócą do uwięzi, która trzyma ich przy ziemi. Niech to mnisi składają długofalowe ofiary, bo mają silniejszy umysł i wiarę, tych należy podziwiać, a nie bezmyślnie naśladować, sądząc, że można zrobić to samo.\n\nA co do przyszłości, czas, by Dawcy Przysięgi podjęli kolejną Przysięgę!}";
		this.m.SuccessButtonText = "{Za Młodego Anzelma! | Za Przysięgających! | I śmierć Dawcom Przysięgi!}";
		this.m.OathName = "Przysięga Poświęcenia";
		this.m.OathBoonText = "Żaden z twoich ludzi nie przyjmuje żołdu.";
		this.m.OathBurdenText = "Rany i kontuzje twoich ludzi się nie leczą.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() <= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Zyskujesz dodatkową Sławę za otrzymanie nie więcej, niż " + this.getBonusObjectiveGoal() + " ran bitewnych (rany otrzymane do tej pory: " + this.getBonusObjectiveProgress() + ")";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersInjuriesSuffered");
	}

	function getBonusObjectiveGoal()
	{
		if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
		{
			return 4;
		}
		else if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
		{
			return 6;
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

		this.m.Score = 1 + this.Math.rand(0, 5) + (this.m.IsDone ? 0 : 10) + this.m.TimesSkipped * 2;
	}

	function onStart()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_sacrifice_trait"));
		}

		this.World.Statistics.getFlags().set("OathtakersInjuriesSuffered", 0);
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_sacrifice");
		}

		this.World.Statistics.getFlags().set("OathtakersInjuriesSuffered", 0);
	}

});

