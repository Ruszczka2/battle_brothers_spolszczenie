this.early_access_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.early_access_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_80.png[/img]Przesiąkasz chłodnym i rześkim porannym powietrzem. Słońce leniwie się podnosi, rozpoczyna się nowy dzień, jak i nowy rozdział w twoim życiu. Po latach broczenia swego miecza we krwi za mizerną zapłatę, odłożyłeś wystarczająco dużo koron, aby założyć swoją własną kompanię najemników. Wraz z tobą są %bro1%, %bro2% oraz %bro3%, u boku których walczyłeś wcześniej w murze tarcz, ramię w ramię. Teraz jesteś ich dowódcą, przywódcą kompani zwanej %companyname%.\n\nPodczas swych podróży po świecie powinieneś zwerbować nowych ludzi w wioskach i miastach, aby zapełnić swoje szeregi. Wielu z tych, którzy oferują swe usługi, nigdy wcześniej nie miało w rękach broni. Może są zdesperowani, a może tylko chciwi i pragną szybko wzbogacić się na łupach wojennych. Większość z nich polegnie na polu bitwy. Niechaj cię to jednak nie zniechęca. Takie bowiem jest życie najemnika, a w następnej wiosce zawsze będą ludzie chętni zacząć nowe życie.\n\nKraina stała się niebezpieczna ostatnimi laty. Rabusie i łupieżcy czają się przy szlakach, dzikie bestie grasują w mrocznych lasach, a plemiona orków, żyjące tuż za granicami cywilizacji, robią się coraz bardziej niespokojne. Krążą nawet plotki o tym, że odżyła czarna magia i że umarli powstali ze swych grobów, by znów przemierzać świat. Jest wiele okazji do zarobienia porządnych pieniędzy, czy to podejmując się kontraktów w wioskach i miastach, czy to poprzez samodzielne wędrowanie i odkrywanie nieznanych lądów.\n\nTwoi ludzie czekają na twój rozkaz. Teraz żyją i będą umierać dla twojej kompani. Wiwat %companyname%!",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Hura!",
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

