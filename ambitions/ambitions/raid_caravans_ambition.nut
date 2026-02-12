this.raid_caravans_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		RaidsToComplete = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.raid_caravans";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Wiele bogactwa można zdobyć z karawan.\nSięgnijmy po nie, niczym po owoc z drzewa!";
		this.m.UIText = "Napadnij na karawany kupieckie lub zaopatrzeniowe";
		this.m.TooltipText = "Napadnij na 4 kupieckie lub zaopatrzeniowe karawany, podróżujące po szlakach. Jeśli nie jesteś wrogiem ich frakcji, może wymusić atak wciskając klawisz CTRL i klikając lewym przyciskiem myszy na karawanie - jednak tylko wtedy, gdy nie wykonujesz aktualnie kontraktu.";
		this.m.SuccessText = "[img]gfx/ui/events/event_60.png[/img]Głos martwego kupca dźwięczy ci w uszach.%SPEECH_ON%Dlaczego to zrobiliście? Wszystko byśmy wam oddali.%SPEECH_OFF%Ale nie wspominasz jego. Wspominasz jego wóz i towary, które na nim skrywał. Odkąd postanowiliście zacząć napadać na karawany, stało się do dla was swego rodzaju sportem. Skąpani w bogactwach z zasadzek, twoi ludzie są szczęśliwi, a ty zyskałeś nieco sławy swymi nikczemnymi czynami.";
		this.m.SuccessButtonText = "Jak odbieranie cukierka dziecku.";
	}

	function getUIText()
	{
		local d = 4 - (this.m.RaidsToComplete - this.World.Statistics.getFlags().getAsInt("CaravansRaided"));
		return this.m.UIText + " (" + this.Math.min(4, d) + "/4)";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Statistics.getFlags().getAsInt("CaravansRaided") <= 0 && this.World.Assets.getOrigin().getID() != "scenario.raiders")
		{
			return;
		}

		this.m.RaidsToComplete = this.World.Statistics.getFlags().getAsInt("CaravansRaided") + 4;
		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("CaravansRaided") >= this.m.RaidsToComplete)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU16(this.m.RaidsToComplete);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.RaidsToComplete = _in.readU16();
	}

});

