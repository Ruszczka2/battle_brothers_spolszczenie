this.militia_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.militia_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_141.png[/img]{Polowanie na bandytów. Odpieranie najeźdźców. Złapanie wilków atakujących gospodarstwa. Wszystko to w zakresie pracy milicji. Jeśli o więcej was proszono, na więcej się zdobywaliście. Wszystko, aby %home% było bezpieczne.\n\n Kiedy wezwał was szlachcic, ty i grupka doraźnych wojowników stanęliście na ubitej ziemi w bitwie między wysoko urodzonymi. Nie wiedziałeś jak się zwą, ani skąd ta waśń, wiedziałeś tylko, że wezwali ciebie i twoich ludzi na pole bitwy. Więc ruszyliście. Niestety, dla nich człek z pospólstwa, nawet z tarczą i włócznią w dłoniach, to wciąż jeno zwykły wieśniak, nie mający pojęcia o wojaczce. Twoją milicję wykorzystano, by utrzymać grupę wrogich rycerz w miejscu, podczas gdy łucznicy po waszej stronie zasypywali okolicę gradem strzał, trafiając tak rycerzy, jak i chłopstwo.\n\n Po bitwie ty i twoi ludzie uciekliście z pól na dobre. Chwyciliście za broń jako najemnicy i poprzysięgliście sobie nawzajem w pakcie krwi, że nigdy żaden wysoko urodzony nie znajdzie miejsca w waszej kompanii. Kompania najemnicza różnorakich łachmaniarzy, i tyle.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Sami jesteśmy sobie panami.",
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
		this.m.Title = "Milicja Chłopska";
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"home",
			this.World.Flags.get("HomeVillage")
		]);
	}

	function onClear()
	{
	}

});

