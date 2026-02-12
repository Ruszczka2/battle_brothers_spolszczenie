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
		this.m.SuccessText = "[img]gfx/ui/events/event_65.png[/img]At the behest of %winninghouse%, the %companyname% confronted the armored ranks of the other houses, a seemingly insurmountable challenge. It was a hard fought struggle, against opponents trained, disciplined, and well equipped, but in the end you overcame the enemies of %winninghouse% and triumphed on its behalf.\n\nDuring the celebrations that follow, %randomnoble%, one of the lesser members of %winninghouse%, suggests that you end the festivities early. Your men are getting too rowdy, and he\'s concerned they may take advantage of his family\'s hospitality, walking off with the silver plate or fighting with the staff. He notes that there has already been a broken window and points towards some broken glass on the floor.\n\nYou reply that although %winninghouse% was victorious, it is also at this point much weaker and more vulnerable than ever. Now would be a foolish time to alienate friends... or to make new enemies.\n\nHe takes your advice to heart and the celebration continues until dawn.";
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

