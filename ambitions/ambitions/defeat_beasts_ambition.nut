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
		this.m.SuccessText = "[img]gfx/ui/events/event_56.png[/img]Po rozprawieniu się z kolejną watahą bestii zaczynasz rozmyślać o naturze swoich przodków. Oto jesteś, zorganizowany, uzbrojony i opancerzony, obyty ze światem, zaprawiony w wojnie i boju, a jednak potwory tego świata wciąż bywają równie groźne. Twoi przodkowie, co mieli? Żadnej cywilizacji, pod którą mogliby się schronić, żadnych miast, by rozjaśnić noc i dodać odwagi, żadnych map, by dać światu uspokajające granice. A jednak... przetrwali. Jak? Dlaczego? Być może wtedy to człowiek był zagrożeniem, a bestie widziały w nim potwora. A może są czasy sprzed starożytnych, czasy, gdy mieli własne miasta, a cały świat po prostu przesuwa równowagę, bestia i człowiek, od niepamiętnych epok. I jeśli tak jest, to nie w przeszłości należy tkwić, lecz w dniach, latach i tysiącleciach, które dopiero nadejdą...";
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

