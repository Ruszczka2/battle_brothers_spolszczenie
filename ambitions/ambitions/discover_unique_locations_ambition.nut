this.discover_unique_locations_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		LocationsDiscovered = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.discover_unique_locations";
		this.m.Duration = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "W dzicy aż roi się od ukrytych skarbów, po które inni nie mają odwagi sięgnąć.\nTo nasza szansa, więc ruszajmy i odnajdźmy trzy legendarne miejsca!";
		this.m.UIText = "Odkryj legendarne lokacje podczas eksploracji świata";
		this.m.TooltipText = "Odkryj 3 legendarne lokacje wyruszając samodzielnie na odkrywanie świata. Przed wyruszeniem w drogę upewnij się, ze zrobiłeś odpowiednie zapasy!";
		this.m.SuccessText = "[img]gfx/ui/events/event_41.png[/img]Do kompanii podchodzi człowiek z mułem. Gdy się zbliża, zauważasz, że zwierzę juczne jest obładowane pakunkami długimi i ciasno zwiniętymi jak lunety. Z juków wystają smukłe wiatrowskazy, a obok nich podskakuje kałamarz. Przedstawia się jako kartograf tych stron i zna twoją kompanię z imienia. Kłania się.%SPEECH_ON%Jako towarzysz mapy, masz moje podziękowania.%SPEECH_OFF%Pytasz, za co. Nieznajomy wydaje się zaskoczony, że musi tłumaczyć swój zachwyt, jakbyś nie miał pojęcia o własnej sławie. A nie masz.%SPEECH_ON%Właśnie dlatego, że otworzyłeś tę krainę! Przed tobą nikt nie zapuszczał się w te strony i nie miałem czego nanieść na papier poza ostrzeżeniami, by tam nie iść. Widziałeś kiedyś napis tu są smoki? To moje dzieło! A teraz zamierzam go zmazać i jeszcze nigdy nie byłem z tego tak zadowolony. Dziękuję, odkrywco, i możesz wziąć jedno z tych piór, ozdobę, by inni znali twoje czyny!%SPEECH_OFF%Odkrywca? Towarzysz mapy? Wygląda na to, że ten nieznajomy ma o tobie błędne wyobrażenia, ale i tak je podtrzymujesz. Wręcza ci ozdobne pióro na znak wdzięczności i żegna się. Wygląda na to, że %companyname% zdobywa sławę nie tylko dzięki zabijaniu i rąbaniu. Nie wiesz, czy to dobrze, czy źle.";
		this.m.SuccessButtonText = "Kreślimy swe własne mapy.";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.m.LocationsDiscovered + "/3)";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.discover_locations").isDone())
		{
			return;
		}

		if (!this.World.Flags.has("LegendaryLocationsDiscovered"))
		{
			this.World.Flags.set("LegendaryLocationsDiscovered", 0);
		}

		if (this.World.Flags.get("LegendaryLocationsDiscovered") >= 11 - 3)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.m.LocationsDiscovered >= 3)
		{
			return true;
		}

		return false;
	}

	function onLocationDiscovered( _location )
	{
		if (this.World.Contracts.getActiveContract() == null || !this.World.Contracts.getActiveContract().isTileUsed(_location.getTile()))
		{
			if (_location.isLocationType(this.Const.World.LocationType.Unique))
			{
				this.m.LocationsDiscovered = this.Math.min(3, this.m.LocationsDiscovered + 1);
				this.World.Ambitions.updateUI();
			}
		}
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU8(this.m.LocationsDiscovered);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.LocationsDiscovered = _in.readU8();
	}

});

