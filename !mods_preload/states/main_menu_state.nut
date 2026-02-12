::mods_hookNewObject("states/main_menu_state", function ( o )
{
	o.scenario_menu_module_onQueryData = function ()
	{
		local result = [
			{
				id = 0,
				name = "Podstawy Walki",
				description = "[p=c][img]gfx/ui/events/event_28.png[/img][/p]\n[p=c]Prosty scenariusz, aby poznać podstawy walki. Łatwizna.[/p]"
			},
			{
				id = 1,
				name = "Przeczesanie",
				description = "[p=c][img]gfx/ui/events/event_133.png[/img][/p]\n[p=c]Kilku łatwych przeciwników rozsianych po mapie i wiele przeszkód terenowych blokujących widok. Dobry scenariusz, by nauczyć się niuansów związanych z polem widzenia, \'mgłą wojny\' oraz walki na dystans. Łatwizna.[/p]"
			},
			{
				id = 4,
				name = "Wczesna Gra",
				description = "[p=c][img]gfx/ui/events/event_09.png[/img][/p]\n[p=c]Przykładowa walka, która może mieć miejsce na wczesnym etapie gry. Średni poziom trudności.[/p]"
			},
			{
				id = 15,
				name = "Obrona Wzgórza",
				description = "[p=c][img]gfx/ui/events/event_22.png[/img][/p]\n[p=c]Przetrwaj przeciwko przeważającym siłom, zajmując dogodną pozycję na szczycie wzgórza. Dobrze nadaje się do zrozumienia przewagi wysokości i by przetestować użyteczność niektórych jednostek na odpowiednich pozycjach. Trudny.[/p]"
			},
			{
				id = 6,
				name = "Bitwa Liniowa (Nieumarli)",
				description = "[p=c][img]gfx/ui/events/event_143.png[/img][/p]\n[p=c]Dwie linie bojowe ścierają się ze sobą w zwarciu. Trudny.[/p]"
			},
			{
				id = 9,
				name = "Bitwa Liniowa (Okrowie)",
				description = "[p=c][img]gfx/ui/events/event_49.png[/img][/p]\n[p=c]ORK ORK ORK ORK ORK ORK. Trudny.[/p]"
			},
			{
				id = 10,
				name = "Bitwa Liniowa (Gobliny)",
				description = "[p=c][img]gfx/ui/events/event_48.png[/img][/p]\n[p=c]Dwie linie bojowe ścierają się ze sobą w zwarciu. Trudny.[/p]"
			},
			{
				id = 13,
				name = "Wilczy Jeźdźcy",
				description = "[p=c][img]gfx/ui/events/event_60.png[/img][/p]\n[p=c]Obroń się przed sforą nikczemnych Goblińskich Wilczych Jeźdźców. Nie pozwól, aby cię otoczyli! Średni poziom trudności.[/p]"
			},
			{
				id = 3,
				name = "Przechadzka po Lesie",
				description = "[p=c][img]gfx/ui/events/event_127.png[/img][/p]\n[p=c]Przykładowa walka, która może mieć miejsce w późniejszym etapie gry. Trudny.[/p]"
			}
		];

		if (!this.isReleaseBuild())
		{
			result.push({
				id = 20,
				name = "Test",
				description = "[p=c]An empty map for AI testing. Spawn combatants manually and let them fight it out.[/p]"
			});
		}

		return result;
	};
});

