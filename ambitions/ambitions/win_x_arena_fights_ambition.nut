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
		this.m.SuccessText = "[img]gfx/ui/events/event_22.png[/img]Po odprawieniu wszelkiego rodzaju stworzeń, które chodzą na dwóch nogach lub więcej, a czasem pewnie na żadnych, zebrałeś całkiem sporo sławy za swój gladiatorski kunszt. Południowcy wypowiadają twoje imię tak, jakby samo niosło dobre wieści, rozkoszując się twoimi zwycięstwami i licząc na kolejne. To dziwny obrót losu, bo większość przychodzi na areny, by oglądać jak najbardziej okrutną śmierć gladiatorów. To, że tłumy kibicują tobie, jest osobliwym odkryciem, choć szybko pojmujesz, że gdy to ty jesteś w świetle reflektorów, a twoja obecność wypełnia trybuny, to wciąż istnieje brzydki koniec, którego tłum pragnie: śmierć twojego przeciwnika. I szczerze mówiąc, za taką monetę nie masz problemu, by nasycić ich żądzę krwi.";
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

