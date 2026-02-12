this.win_against_x_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		IsFulfilled = false
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.win_against_x";
		this.m.Duration = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Odstawmy na razie potyczki i spróbujmy pokonać grupę co najmniej tuzina\nprzeciwników. W ten sposób staniemy się sławni w okolicy!";
		this.m.RewardTooltip = "Zdobędziesz dodatkowe 150 sławy za swe zwycięstwo.";
		this.m.UIText = "Wygraj bitwę przeciwko 12 lub więcej wrogów";
		this.m.TooltipText = "Wygraj bitwę przeciwko 12 lub więcej wrogów, czy to zabijając ich, czy zmuszając do ucieczki. Możesz to zrobić tak w ramach kontraktu, jak i walcząc na własnych zasadach.";
		this.m.SuccessText = "[img]gfx/ui/events/event_22.png[/img]Gdy wszyscy twoi wrogowie leżą martwi lub uciekają w popłochu, %bravest_brother% macha sztandarem kompanii w geście świętowania.%SPEECH_ON%Po raz kolejny %companyname% walczy i po raz kolejny %companyname% zwycięża!%SPEECH_OFF%Wszędzie rozbrzmiewają gromkie okrzyki radości. Szybko odkrywasz, że twoja niedawna bitwa jest tematem rozmów w okolicznych miasteczkach i wioskach. Za każdym razem, gdy bracia zatrzymują się w przydrożnej gospodzie, odkrywają, że gdy opowiadana jest historia tej bitwy, rozlewane są napitki, a im bardziej opowieść jest ubarwiana, tym swobodniej płyną trunki.";
		this.m.SuccessButtonText = "Któż teraz ośmieli się stanąć przeciwko nam?";
	}

	function onUpdateScore()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 12)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.battle_standard").isDone())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 12 || this.m.IsFulfilled)
		{
			return true;
		}

		return false;
	}

	function onLocationDestroyed( _location )
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 12)
		{
			this.m.IsFulfilled = true;
		}
	}

	function onPartyDestroyed( _party )
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 12)
		{
			this.m.IsFulfilled = true;
		}
	}

	function onReward()
	{
		this.World.Assets.addBusinessReputation(150);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/special.png",
			text = "Zdobywasz dodatkową sławę za swe zwycięstwo"
		});
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeBool(this.m.IsFulfilled);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.IsFulfilled = _in.readBool();
	}

});

