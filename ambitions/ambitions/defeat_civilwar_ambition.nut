this.defeat_civilwar_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_civilwar";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Jeśli zdołamy wygrać tę wojnę dla jednego z rodów, będziemy niezrównani.\nWybierzmy stronę konfliktu, ogrzejmy w chwale bitwy i wzbogaćmy!";
		this.m.UIText = "Zakończ wojnę między rodami szlacheckimi";
		this.m.TooltipText = "Wybierz jeden z rodów szlacheckich i pracuj z nim, aby rozbić ich wrogów. Każda zniszczona armia oraz każdy wypełniony kontrakt zbliżają cię do zakończenia wojny.";
		this.m.SuccessText = "[img]gfx/ui/events/event_65.png[/img]Z woli %winninghouse% %companyname% stanęło naprzeciw opancerzonych szeregów pozostałych rodów, wyzwania zdającego się nie do pokonania. To była ciężka, zacięta walka z przeciwnikami wyszkolonymi, zdyscyplinowanymi i dobrze wyposażonymi, lecz ostatecznie pokonałeś wrogów %winninghouse% i zwyciężyłeś w jego imieniu.\n\nPodczas późniejszych świętowań %randomnoble%, jeden z pomniejszych członków %winninghouse%, sugeruje, by zakończyć ucztę wcześniej. Twoi ludzie robią się zbyt hałaśliwi i obawia się, że nadużyją gościnności jego rodu, wynosząc srebrne naczynia albo wdając się w bójki ze służbą. Zauważa, że jedno okno już wybito, i wskazuje na odłamki szkła na podłodze.\n\nOdpowiadasz, że choć %winninghouse% zwyciężył, to właśnie teraz jest najsłabszy i najbardziej podatny na ciosy. To byłby nierozsądny moment, by zrażać przyjaciół... lub tworzyć nowych wrogów.\n\nBierze twoją radę do serca i świętowanie trwa aż do świtu.";
		this.m.SuccessButtonText = "Czy nas wielbią, czy nienawidzą, wszyscy teraz znają nazwę %companyname%!";
	}

	function getUIText()
	{
		local f = this.World.FactionManager.getGreaterEvil().Strength / this.Const.Factions.GreaterEvilStartStrength;
		local text;

		if (f >= 0.95)
		{
			text = "Ledwie się zaczęła";
		}
		else if (f >= 0.5)
		{
			text = "Szaleje";
		}
		else if (f >= 0.25)
		{
			text = "Ciągnie się";
		}
		else
		{
			text = "Prawie zakończona";
		}

		return this.m.UIText + " (" + text + ")";
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 1500)
		{
			return;
		}

		this.m.Score = 10;
	}

	function onCheckSuccess()
	{
		if (this.World.FactionManager.getGreaterEvil().Type == 0 && this.World.FactionManager.getGreaterEvil().LastType == 1)
		{
			return true;
		}

		this.World.Ambitions.updateUI();
		return false;
	}

	function onPrepareVariables( _vars )
	{
		local allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);
		local bestRelations = -1.0;
		local best;

		foreach( a in allies )
		{
			local f = this.World.FactionManager.getFaction(a);

			if (f != null && f.getType() == this.Const.FactionType.NobleHouse && f.getPlayerRelation() > bestRelations)
			{
				bestRelations = f.getPlayerRelation();
			}
		}

		if (best == null)
		{
			return;
		}

		_vars.push([
			"winninghouse",
			best.getName()
		]);
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});

