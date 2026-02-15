this.oath_of_wrath_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_wrath";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "W bitwie nie ma błędu bardziej śmiercionośnego niż potulność.\nZłóżmy Przysięgę Gniewu i pokażmy wrogom, co naprawdę znaczy zostać powalonym!";
		this.m.TooltipText = "Młody Anzelm spisał wiele podręczników walki, z których najpopularniejsze zalecają użycie broni dwuręcznej oraz porzucenie taktyki bitewnej. Zasuszona krew plami karty tych ksiąg.";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]Kiedy przychodzi do śmiertelnej walki, jest tylko jeden pewny sposób: całkowite zniszczenie. A orężem z wyboru w tym krwawym dziele jest broń dwuręczna. Ludzie %companyname% przyjęli Przysięgę Gniewu jak ćmy do ognistego, ledwie dokończonego żelaza kowala, gdy wypluwa je z węgli, czerwone i płonące, a kowal stoi nad nim jak obłąkany kat, młot w dłoni, gotów spłaszczyć rozżarzone krawędzie w gotowy produkt ostatecznego zabijania, po czym unosi je i uświadamia sobie, że bryła metalu jest za duża dla zwykłego człowieka, lecz dość wielka, by przeciąć kogoś na pół, jeśli trafi w odpowiednie ręce. I tak %companyname% porzuciło obronę i z otwartymi ramionami powitało rozlew krwi.\n\nZbroczeni krwią i z nasyconym gniewem, %companyname% jest gotowa na kolejną Przysięgę!";
		this.m.SuccessButtonText = "{Za Młodego Anzelma! | Za Przysięgających! | I śmierć Dawcom Przysięgi!}";
		this.m.OathName = "Przysięga Gniewu";
		this.m.OathBoonText = "Twoi ludzie mają [color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color]  do szansy trafienia podczas władania dwuręczną lub oburącz trzymaną bronią do walki w zwarciu, a ich zabójstwa zawsze będą śmiertelne, o ile będzie to możliwe.";
		this.m.OathBurdenText = "Twoi ludzie mają [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] do Ataku w zwarciu oraz [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] do Obrony dystansowej.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Zyskujesz dodatkową Sławę za zabijanie swych wrogów (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersWrathSlain");
	}

	function getBonusObjectiveGoal()
	{
		if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
		{
			return 100;
		}
		else if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
		{
			return 75;
		}
		else
		{
			return 50;
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
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_wrath_trait"));
		}

		this.World.Statistics.getFlags().set("OathtakersWrathSlain", 0);
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_wrath");
		}

		this.World.Statistics.getFlags().set("OathtakersWrathSlain", 0);
	}

});

