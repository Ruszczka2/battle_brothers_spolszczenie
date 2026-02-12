this.southern_quickstart_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.southern_quickstart_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_156.png[/img]{Mogłeś zostać w domu. Nigdy nie opuszczać miasta. Dożyć w spokoju swej śmierci, pracując dla jakiegoś Wezyra. Zamiast tego chwyciłeś miecz, zebrałeś resztkę monet i założyłeś kompanię najemników.\n\nŻywot najemnika zabrał cię w miejsca, których większość ludzi nigdy nie widziała na oczy. W pewnym sensie, wyciąłeś sobie drogę przemocą. Jednak lata mijały, a do ciebie coraz bardziej docierała brzydka prawda: byłeś czymś niewiele lepszym od pospolitego bandyty. Zatrudniali cię miejscowi do prostych zadań za niewielką zapłatę, a potem pozbywali się ciebie. Chcesz, aby %companyname% znaczyło coś więcej. Chcesz, aby twą kompanię pokazano urzędom Wezyra, chcesz, aby zdobyła chwałę, na którą zasługuje, a może nawet aby zawędrowała na odległe północne ziemie. Cholera, może właśnie na północy traktują najemników z szacunkiem!\n\nOczywiście, lekko nie będzie. Jest was zaledwie garstka. Ale są z tobą %bro1%, %bro2% oraz %bro3%, a to najlepsi wojownicy, jakich znasz. Z nimi u twego boku, świat wkrótce usłyszy nazwę %companyname%!}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Złotnik wskaże nam drogę.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = this.World.Assets.getName();
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"bro1",
			brothers[0].getName()
		]);
		_vars.push([
			"bro2",
			brothers[1].getName()
		]);
		_vars.push([
			"bro3",
			brothers[2].getName()
		]);
	}

	function onClear()
	{
	}

});

