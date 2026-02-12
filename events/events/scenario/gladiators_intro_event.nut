this.gladiators_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.gladiators_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_147.png[/img]{Zabicie człowieka powinno być łatwiejsze, ale nieobeznanie utwardza ciało: mordercy złapani w uliczce, duszący ofiarę, ręce sztywne, dłonie zaciśnięte, wrzeszczący dlaczego ich ofiary nie umierają. Żona uderzająca swego męża pogrzebaczem, raz za razem, a on nadal łapie oddech, mimo iż ogień w kominku dawno już zdążył wygasnąć. Znudzony Wezyr, nie potrafiący pojąć dlaczego jego oprawcy męczą się tak z przestępcą, oszalałym człowiekiem, który szydzi z nich, podczas gdy oni odcinają mu najistotniejsze członki.\n\nJednak dla gladiatora mężczyzna nie jest jeno mężczyzną, jest dzierżycielem broni. Miecze, topory, włócznie, trójzęby i inne. Gdy już przebijesz się przez te uzewnętrznione przeszkody, człek staje się zwykłym mięsem, a zlikwidowanie go nie jest kwestią walki, a rozrywki. Rozrywki! Rywalizacja z każdą uncją skóry w rozgrywce oraz huczność publiczności. To właśnie kochasz. Niechaj filozofowie roztrząsają się o naturze tego, jak rzeczy rodzą się i umierają. Gdy zanurzysz miecz w gardle jakiegoś głupca, tryska nie tylko krew na klingę, ale i publiczność radością! To najwspanialszy dźwięk na świecie! A te kobiety, które przychodzą później, jakże gorące i zaniepokojone, nie czekają nawet aż obmyjesz z siebie krew i trzewia, tylko od razu na ciebie wskakują? Wspaniałe.\n\nAle to zaczyna się nudzić. Ile to już walk? Nie jesteś w stanie zliczyć. Ile prawdziwych wyzwań? Nie potrafisz wskazać nawet jednego. Nawet jednego! %g1%, %g2% oraz %g3%, wszyscy są zgodni: jesteś zbyt dobry. A oni też są całkiem nieźli, szczerze mówiąc. Wszyscy czterej twierdzicie to samo:powinniście pożegnać się z areną i wykuć ducha w ludziach całej krainy.\n\nGladiatorzy mają upodobanie do wykwintności, zwłaszcza wonnych kąpieli oraz osobistej biżuterii, więc gotowi są za te rzeczy sporo zapłacić, gdy ty finansujesz ich rozrzutny styl życia poza wygodami państwa-miasta. I tak też będzie. Twoi trzej solidni, waleczni kumple będą pokazywać swoje męstwo w wojennej sztuce, a ty zmierzysz się z nowym wyzwaniem: jak radzić sobie z wojownikami i ich potrzebami.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To powinno być łatwe.",
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
		this.m.Title = "Gladiatorzy";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"g1",
			brothers[0].getName()
		]);
		_vars.push([
			"g2",
			brothers[1].getName()
		]);
		_vars.push([
			"g3",
			brothers[2].getName()
		]);
	}

	function onClear()
	{
	}

});

