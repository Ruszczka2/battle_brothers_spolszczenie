this.discover_locations_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		LocationsDiscovered = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.discover_locations";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Wielcy odkrywcy stali się legendarnymi ludźmi. Wyprawa w dzicz jest niebezpieczna\nale opowieści, jakie potem będziemy rozpowiadać, z pewnością zwiększą naszą sławę.";
		this.m.UIText = "Odkryj ukrytą lokację eksplorując świat";
		this.m.TooltipText = "Odkryj 8 ukrytych lokacji, takich jak ruiny lub wrogie obozy, wyruszając samodzielnie i eksplorując świat. Przed wyruszeniem w drogę upewnij się, ze zrobiłeś odpowiednie zapasy!";
		this.m.SuccessText = "[img]gfx/ui/events/event_54.png[/img]Chwytając los za brodę, ogłosiłeś zamiar wędrówki po krainie i pozostawienia śladu jako odkrywca. Uznając, że odkrywanie nowych miejsc, czy to siedlisk zła, czy dostatnich wiosek, otworzy drogę do nowych okazji zarobku, ludzie podążyli za tobą z entuzjazmem.\n\nW kolejnych dniach kompania oglądała rozległe panoramy, wypatrując wysokich wież i zdradliwych kanionów. Unikałeś wrogich zwiadowców i zakładałeś obozy bez ognia pod gwiazdami jak tysiące płomieni świec w pustce. Wyznaczając bieg dzikich rzek i omijając wrogie krawędzie nieprzekraczalnych pasm górskich, %companyname% może uczciwie powiedzieć, że zwiedziła świat szerzej niż wiele innych band tego rodzaju.";
		this.m.SuccessButtonText = "Kreślimy swe własne mapy.";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.m.LocationsDiscovered + "/8)";
	}

	function onUpdateScore()
	{
		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.find_and_destroy_location").isDone())
		{
			return;
		}

		local locations = this.World.EntityManager.getLocations();
		local numDiscovered = 0;

		foreach( v in locations )
		{
			if (v.isDiscovered())
			{
				numDiscovered = ++numDiscovered;
				numDiscovered = numDiscovered;
			}
		}

		if (numDiscovered + 12 >= locations.len())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.m.LocationsDiscovered >= 8)
		{
			return true;
		}

		return false;
	}

	function onLocationDiscovered( _location )
	{
		if (_location.getTypeID() == "location.battlefield")
		{
			return;
		}

		if (this.World.Contracts.getActiveContract() == null || !this.World.Contracts.getActiveContract().isTileUsed(_location.getTile()))
		{
			this.m.LocationsDiscovered = this.Math.min(8, this.m.LocationsDiscovered + 1);
			this.World.Ambitions.updateUI();
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

