this.win_against_y_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		IsFulfilled = false
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.win_against_y";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Zdobyliśmy nieco reputacji, ale prawdziwą sławę widać już na horyzoncie.\nPokonajmy w bitwie budzący grozę oddział złożony z dwóch tuzinów wrogów!";
		this.m.UIText = "Wygraj bitwę przeciwko 24 lub więcej wrogów";
		this.m.TooltipText = "Wygraj bitwę przeciwko 24 lub więcej wrogów, czy to zabijając ich, czy zmuszając do ucieczki. Możesz to zrobić tak w ramach kontraktu, jak i walcząc na własnych zasadach.";
		this.m.SuccessText = "[img]gfx/ui/events/event_22.png[/img]Po walce %lowesthp_brother% siedzi, wpatrując się w stopy, wygląda na kompletnie wyczerpanego, podobnie jak pozostali. %SPEECH_ON%To była bitwa, do której się urodziłem! Jeśli teraz zginę, to u boku najdzielniejszej i najgroźniejszej bandy ludzi, jakich kiedykolwiek poznałem, i jestem dumny, że nazywam ich braćmi!%SPEECH_OFF%Odpowiada mu chór znużonej zgody.%SPEECH_ON%Chłopi mówią o pocie, krwi i łzach, ale ludzie %companyname% przeszli przez ogień i zwyciężyli!%SPEECH_OFF%Trzykrotnie ludzie krzyczą nazwę kompanii, zmęczeni, ale zwycięscy.\n\nW kolejnych dniach odkrywasz, że gdziekolwiek zbierają się cywilizowani ludzie, wskazują na ciebie i szepczą, nie wiesz, czy ze strachu, czy z podziwu. Gdziekolwiek pójdziesz, wieść o twoim potężnym zwycięstwie dotarła tam przed tobą.";
		this.m.SuccessButtonText = "Któż teraz ośmieli się stanąć przeciwko nam?";
	}

	function onUpdateScore()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 24)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.win_against_x").isDone())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 24 || this.m.IsFulfilled)
		{
			return true;
		}

		return false;
	}

	function onLocationDestroyed( _location )
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 24)
		{
			this.m.IsFulfilled = true;
		}
	}

	function onPartyDestroyed( _party )
	{
		if (this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") >= 24)
		{
			this.m.IsFulfilled = true;
		}
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

