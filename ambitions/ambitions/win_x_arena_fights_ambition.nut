this.win_x_arena_fights_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		ArenaMatchesToWin = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.win_x_arena_fights";
		this.m.Duration = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Poszukajmy sławy i bogactwa walcząc przed tłumami skandującymi nasze imiona.\nBędziemy przelewać krew na arenach południa!";
		this.m.UIText = "Wygraj walki na arenie";
		this.m.TooltipText = "Weź udział i wygraj 5 walk na arenie w południowych państwach-miastach.";
		this.m.SuccessText = "[img]gfx/ui/events/event_22.png[/img]Having dispatched all manner of creatures that walk on two legs or more, and sometimes perhaps none at all, you\'ve come to collect a fair bit of renown for your gladiatorial prowess. Southerners speak your name as though itself were the carrier of good news, vicariously relishing in your victories and hoping to see you win more. It is an odd spin of fate, as most attend the arenas to see gladiators find as grisly a demise as possible. To have the masses cheer for you is a strange realization indeed, though you just realize that when it is you in that light, your very presence filling the stands and bannisters, that there is still an ugly end the crowd seeks: that of your opponent. And, frankly, for that much coin you\'ve no problem satiating the audience\'s bloodlust.";
		this.m.SuccessButtonText = "Wciąż słyszę, jak skandują nasze imiona!";
	}

	function getUIText()
	{
		local d = 5 - (this.m.ArenaMatchesToWin - this.World.Statistics.getFlags().getAsInt("ArenaFightsWon"));
		return this.m.UIText + " (" + this.Math.min(5, d) + "/5)";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 1 && this.World.Assets.getOrigin().getID() != "scenario.gladiators")
		{
			return;
		}

		if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") > 10)
		{
			return;
		}

		this.m.ArenaMatchesToWin = this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") + 5;
		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= this.m.ArenaMatchesToWin)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU16(this.m.ArenaMatchesToWin);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);

		if (_in.getMetaData().getVersion() >= 55)
		{
			this.m.ArenaMatchesToWin = _in.readU16();
		}
	}

});

