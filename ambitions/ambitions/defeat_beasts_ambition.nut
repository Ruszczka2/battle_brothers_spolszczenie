this.defeat_beasts_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		BeastsToDefeat = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_beasts";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Dzikie bestie napastują wioski na obrzeżach cywilizacji.\nPowinniśmy zapolować na nie dla zysku!";
		this.m.UIText = "Pokonaj stado grasujących bestii";
		this.m.TooltipText = "Pokonaj w bitwie 5 grup wędrujących bestii, takich jak Wilkory lub Nachzehrery, czy to w ramach kontaktu, czy wyruszając w świat samopas.";
		this.m.SuccessText = "[img]gfx/ui/events/event_56.png[/img]Having dispatched yet another band of beasts, you find yourself pondering the nature of your ancestors. Here you are, organized, armed and armored, world-traveled, experienced in matters of war and combat, and yet the monsters of this world still serve to be as dangerous as ever. Your ancestors, what did they have? No civilization to blanket themselves under, no cities to light the night and warm the courage, no maps to give a comforting border to the world. And yet... they survived. What was it? How? Perhaps, in those days, it was man who was the threat, and the beasts saw him the monster. Or perhaps there are times before the ancients, times of when they had their own cities, and all the world simply shifts in balance, beast and man, since time immemorial. And if that is the case, then it is not the past you should dwell on, but the days and years and millennia to come...";
		this.m.SuccessButtonText = "Tak ludzie, jak i bestie, poznają nazwę naszej kompanii.";
	}

	function getUIText()
	{
		local d = 5 - (this.m.BeastsToDefeat - this.World.Statistics.getFlags().getAsInt("BeastsDefeated"));
		return this.m.UIText + " (" + this.Math.min(5, d) + "/5)";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 1 && this.World.Assets.getOrigin().getID() != "scenario.beast_hunters")
		{
			return;
		}

		this.m.BeastsToDefeat = this.World.Statistics.getFlags().getAsInt("BeastsDefeated") + 5;
		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("BeastsDefeated") >= this.m.BeastsToDefeat)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU16(this.m.BeastsToDefeat);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.BeastsToDefeat = _in.readU16();
	}

});

