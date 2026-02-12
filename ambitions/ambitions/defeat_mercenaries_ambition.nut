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
		this.m.SuccessText = "[img]gfx/ui/events/event_87.png[/img]%randombrother% wipes sweat and blood off of his forehead.%SPEECH_ON%These bunch of cheats! I thought only I knew that trick!%SPEECH_OFF%Mercenaries are a motley bunch and inherently unpredictable, with a bizarre array of equipment, wildly varying skills and experience, and cunning tactics. With no standards for members, they may be nothing more than a bunch of elderly tradesmen, looking for adventure. But then again, you could be surprised by a group of veteran campaigners. Worse, they follow no rules of engagement. The %defeatedcompany% did their best, but though they knew many of the same clever stratagems as the brothers, they were no match for the %companyname%.\n\nYour victory will surely show employers far and wide whose blades are the sharpest.";
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

