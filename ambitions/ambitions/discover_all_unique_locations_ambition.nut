this.discover_all_unique_locations_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.discover_all_unique_locations";
		this.m.Duration = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Miejsca legend znaczą ten świat, skrywając w sobie wspaniałe tajemnice.\nNie spoczniemy, aż odnajdziemy każde z nich!";
		this.m.UIText = "Odkryj wszystkie legendarne lokacje tego świata";
		this.m.TooltipText = "Odkryj wszystkie legendarne skarby tego świata, wyruszając samodzielnie na eksploracje dzikich lądów.  Przed wyruszeniem w drogę upewnij się, ze zrobiłeś odpowiednie zapasy!";
		this.m.SuccessText = "[img]gfx/ui/events/event_45.png[/img]Brzegi twojej mapy są postrzępione, a zagięcia tak wytarte, że pod palcami przypominają filc. Papier jest cięższy, niż wygląda, i osłaniał cię przed deszczem i śniegiem, leżał pod sianem, na którym spałeś, i bywał zagrożony użyciem na podpałkę w ciężkich czasach. Ale jest też lżejszy, niż wygląda, bo wiatr nieraz wyrywał go prosto z twoich palców i goniłeś go po polach, wrzeszcząc jak szakal, gdy się wykręcał i uciekał.\n\nZgodnie z pracą dawnego kartografa wasza kompania nie miała opuszczać dróg ani oddalać się od miast. Zapisał ostrzeżenia w rodzaju: zguba i tylko zguba oraz: tu czają się bandyci i ich niegodziwe matki. Zignorowałeś to wszystko i pokreśliłeś mapę własnymi, poskręcanymi liniami zwiadu. To nie były miejsca przesądów, to były miejsca, do których %companyname% miało iść i poszło. Za rycie linii na zwiotczałej mapie zyskałeś opinię kogoś na kształt odkrywcy miejsc, które świat dawno przestał odwiedzać. A co jeszcze może tam być, jeśli nie coś daleko poza tym miejscem?";
		this.m.SuccessButtonText = "Kreślimy swe własne mapy.";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.discover_unique_locations").isDone())
		{
			return;
		}

		if (!this.World.Flags.has("LegendaryLocationsDiscovered"))
		{
			this.World.Flags.set("LegendaryLocationsDiscovered", 0);
		}

		if (this.World.Flags.get("LegendaryLocationsDiscovered") >= 11)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		return this.World.Flags.get("LegendaryLocationsDiscovered") >= 11;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});

