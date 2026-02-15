this.defeat_mercenaries_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		Defeated = 0,
		OtherMercs = ""
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_mercenaries";
		this.m.Duration = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Najlepszym sposobem, aby dowieść, żeśmy najsilniejszą kompanią w okolicy\njest pokonanie innych najemników w bitwie!";
		this.m.UIText = "Pokonaj inną kompanię najemników";
		this.m.TooltipText = "Pokonaj inną kompanię najemników wędrującą po świecie. Jeśli nie posiadasz wrogów, którzy zwerbują inną kompanię najemników, możesz zawsze wcisnąć CTRL + lewy przycisk myszy, aby zaatakować każdy oddział - o ile nie masz aktualnie aktywnego kontraktu.";
		this.m.SuccessText = "[img]gfx/ui/events/event_87.png[/img]%randombrother% ociera pot i krew z czoła.%SPEECH_ON%Ale z nich oszuści! Myślałem, że tylko ja znam ten trik!%SPEECH_OFF%Najemnicy to zbieranina i z natury są nieprzewidywalni, z osobliwym zestawem wyposażenia, skrajnie różnymi umiejętnościami i doświadczeniem oraz chytrymi taktykami. Bez żadnych standardów przyjęcia mogą okazać się tylko bandą podstarzałych rzemieślników szukających przygody. Ale równie dobrze można się zdziwić, trafiając na zaprawionych w kampaniach weteranów. Co gorsza, nie trzymają się żadnych zasad walki. %defeatedcompany% zrobiła, co mogła, lecz choć znała wiele z tych samych sprytnych forteli co bracia, nie miała szans przeciw %companyname%.\n\nTwoje zwycięstwo na pewno pokaże pracodawcom daleko i szeroko, czyje ostrza są najostrzejsze.";
		this.m.SuccessButtonText = "Kto mieczem wojuje...";
	}

	function onPartyDestroyed( _party )
	{
		if (_party.getFlags().has("IsMercenaries"))
		{
			++this.m.Defeated;
			this.m.OtherMercs = _party.getName();
		}

		this.World.Ambitions.updateUI();
	}

	function onUpdateScore()
	{
		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.m.Defeated >= 1)
		{
			return true;
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"defeatedcompany",
			this.m.OtherMercs
		]);
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU8(this.m.Defeated);
		_out.writeString(this.m.OtherMercs);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.Defeated = _in.readU8();
		this.m.OtherMercs = _in.readString();
	}

});

