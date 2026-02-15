this.defeat_undead_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_undead";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Nieumarli wstają z grobów w całej krainie, zabijając i pożerając ludzi.\nMusimy położyć temu kres, albo świat jaki znamy wkrótce całkiem zginie!";
		this.m.UIText = "Pokonaj Plagę Nieumarłych";
		this.m.TooltipText = "Pokonaj Plagę Nieumarłych! Każdy wykonany przeciwko nim kontrakt, każda zniszczona armia lub lokacja, przybliżą cię do ocalenia ludzkiego świata.";
		this.m.SuccessText = "[img]gfx/ui/events/event_73.png[/img]Chodzące trupy w łachmanach. Cmentarze każdej wioski wkrótce zaczęły je wypluwać, a to był dopiero początek. Przebudziły się pradawne legiony z dawno minionej epoki. Nigdy niezmęczone, nigdy nieustraszone, maszerowały jak zimna machina, wciąż naprzód. Kiedyś podbiły znany świat i mogłyby zrobić to ponownie, gdyby nie zgrana banda najemników.%SPEECH_ON%Martwi maszerujący, chodzące kości w obcych zbrojach, rzeczy nie z tego świata... Nie sądziłem, że zobaczę takie okropności. Ale zwyciężyliśmy!%SPEECH_OFF%%bravest_brother% wykrzykuje, wznosząc broń wysoko, jakby dawał sygnał do szarży.%SPEECH_ON%%companyname% zwyciężyło nawet nad tym wrogiem! Kto teraz nam się postawi?%SPEECH_OFF%Kto, rzeczywiście?";
		this.m.SuccessButtonText = "Świat ludzi znów jest bezpieczny. Na razie.";
	}

	function getUIText()
	{
		local f = this.World.FactionManager.getGreaterEvil().Strength / this.Const.Factions.GreaterEvilStartStrength;
		local text;

		if (f >= 0.95)
		{
			text = "Losing";
		}
		else if (f >= 0.5)
		{
			text = "Undecided";
		}
		else if (f >= 0.25)
		{
			text = "Winning Slightly";
		}
		else
		{
			text = "Winning";
		}

		return this.m.UIText + " (" + text + ")";
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isUndeadScourge())
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
		if (this.World.FactionManager.getGreaterEvil().Type == 0 && this.World.FactionManager.getGreaterEvil().LastType == 3)
		{
			return true;
		}

		this.World.Ambitions.updateUI();
		return false;
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

