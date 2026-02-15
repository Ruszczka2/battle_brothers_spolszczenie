this.oath_of_camaraderie_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {
		DisableEffect = false
	},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_camaraderie";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Żaden Dawca Przysięgi nie stawi sam czoła wszystkiemu złu świata.\nZłóżmy Przysięgę Koleżeństwa, by nie stracić z oczu naszych prawdziwych sprzymierzeńców!";
		this.m.TooltipText = "Młody Anzelm wierzył, że czasem słusznie jest zebrać na bitwę tylu, ilu zdoła się zebrać, choć wielkie tłumy potrafią zagrozić łańcuchowi dowodzenia. \"Wszyscy ludzie zasługują, by stanąć u boku swych braci.\"";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]{Siła w liczbie, koleżeństwo w braterstwie. Choć większa liczba ludzi utrudniała dowodzenie, w toku każdej bitwy %companyname% szybko pojęło, że chaos walki można przezwyciężyć, stając ramię w ramię z człowiekiem obok, ufając, że wykona swoje zadanie, i dając mu pewność, że ty zrobisz swoje. To doświadczenie zahartowało kompanię na spustoszenia wojny.\n\nTeraz, gdy kompania wie, że może stawić czoło wrogom, ufając własnym ludziom, jest gotowa podjąć kolejną Przysięgę!}";
		this.m.SuccessButtonText = "{Za Młodego Anzelma! | Za Przysięgających! | I śmierć Dawcom Przysięgi!}";
		this.m.OathName = "Przysięga Koleżeństwa";
		this.m.OathBoonText = "Możesz zabrać do bitwy nawet [color=" + this.Const.UI.Color.PositiveValue + "]14[/color] ludzi.";
		this.m.OathBurdenText = "Twoi ludzie zawsze będą rozpoczynać bitwę losowo z morale na poziomie \'Waha się\' lub \'Załamuje się\'.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Zyskujesz dodatkową Sławę, jeśli twoi ludzie osiągną w bitwie morale na poziomie \'Pewny siebie\' wystarczającą ilość razy (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersBrosConfident");
	}

	function getBonusObjectiveGoal()
	{
		if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
		{
			return 150;
		}
		else if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
		{
			return 100;
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
		if (!this.m.DisableEffect)
		{
			this.World.Assets.m.BrothersMaxInCombat = 14;
		}
	}

	function onStart()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_camaraderie_trait"));
		}

		this.World.Statistics.getFlags().set("OathtakersBrosConfident", 0);
		this.World.Assets.resetToDefaults();
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_camaraderie");
		}

		this.World.Statistics.getFlags().set("OathtakersBrosConfident", 0);
		this.m.DisableEffect = true;
		this.World.Assets.resetToDefaults();
		this.World.Assets.updateFormation(true);
	}

});

