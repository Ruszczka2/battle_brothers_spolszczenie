this.undead_town_destroyed_event <- this.inherit("scripts/events/event", {
	m = {
		News = null
	},
	function create()
	{
		this.m.ID = "event.crisis.undead_town_destroyed";
		this.m.Title = "Wzdłuż drogi...";
		this.m.Cooldown = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_99.png[/img]{Napotykasz osła stojącego obok wozu pełnego zwęglonych zwłok. Obok stoi mężczyzna, wyglądający, co zrozumiałe, na mocno sponiewieranego. Patrzy na ciebie i kręci głową.%SPEECH_ON%Mam nadzieję, że nie zmierzasz do %city%.%SPEECH_OFF%Nie chcesz mówić obcym, dokąd się wybierasz, więc po prostu pytasz dlaczego. Kręci głową po raz drugi.%SPEECH_ON%Dopadli ich chodzący nieumarli. Choroba rozniosła się po mieście, a ci, którzy umierali, wstawali znowu. Niewiele czasu minęło, zanim całe miejsce padło łupem tych nieśmiertelnych dusz. Mówi się, że miastem rządzą teraz nekromanci, ale kto to wie. Na pewno nie zamierzam podchodzić, by się przekonać.%SPEECH_OFF% | Na środku ścieżki kuca blady siwobrody. Słyszy, że nadchodzisz, ale nie odwraca się. Po prostu mówi.%SPEECH_ON%Widziałem was w wizji. Wszystkich. Najemnicy na drodze do naprawy nieszczęść tego świata, choć możecie nie rozumieć swojego celu lepiej niż królewskie niemowlę rozumie swoje miejsce. Ale spóźniliście się.%SPEECH_OFF%Jego głowa odwraca się gwałtownie. Białe oczy patrzą spod krzaczastych brwi. Brakuje mu nosa, a wargi marszczą się w chorobliwie żółtych fałdach.%SPEECH_ON%%city% jest stracone! Umarli błąkają się po ulicach, na smyczy tych, których nazywacie nekromantami.%SPEECH_OFF%Ostrożnie podchodzisz i pytasz, skąd to wszystko wie. Blady mężczyzna unosi okrągły amulet, który faluje, jakby bóg trzymał w dłoni kształt stawu. Obrazy skręcają się w jego odbiciach, pojawiają się i znikają, wydarzenia bez początku i końca. Śmieje się.%SPEECH_ON%Kto lepiej zna los miasta niż człowiek, który zaaranżował jego upadek?%SPEECH_OFF%Nagle ciało nieznajomego pęka, odsłaniając pod spodem tylko powietrze, a zwęglone odłamki jego nowej formy rozlatują się w chmurę nietoperzy. Dobywasz miecza, ale stworzenia odskakują, skrzecząc i ćwierkając, gdy szybują ku horyzontowi. | Dwóch mężczyzn stoi nieopodal ścieżki. Jeden stoi przy sztaludze, w jednej dłoni pędzel, w drugiej paleta z wymieszanymi kolorami. Drugi pozuje, ręce ma na głowie, z wyrazem absolutnej grozy. Malarz spogląda na ciebie.%SPEECH_ON%Ach, najemnicy. Pewnie zmierzacie do miasta, co?%SPEECH_OFF%Pytasz, skąd taki wniosek. Nerwowo odkłada pędzel. Widzisz, że obraz przedstawia mroczne miasto z niebieską miazmą unoszącą się zza murów, a nad nim zawisa blady księżyc. Na pierwszym planie stoi niedokończona postać, odwzorowująca wyraz twarzy modela. Pozujący odpowiada, nie ruszając się ani o cal.%SPEECH_ON%%city% zostało zniszczone. No, nie zniszczone, ale opanowane przez te chodzące trupy. Mówi się, że rządzą nim bladzi ludzie.%SPEECH_OFF%Pytasz, czy są tego pewni. Malarz macha ręką, wskazując na swoje dzieło.%SPEECH_ON%Gdybym nie widział tego na własne oczy, czy nie byłoby to dziełem szaleńca? A teraz, proszę, muszę wrócić do pracy, zanim upiorne wspomnienie wyblaknie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Czy przegrywamy tę wojnę?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.State.getPlayer().getTile().HasRoad)
		{
			return;
		}

		if (this.World.Statistics.hasNews("crisis_undead_town_destroyed"))
		{
			this.m.Score = 2000;
		}
	}

	function onPrepare()
	{
		this.m.News = this.World.Statistics.popNews("crisis_undead_town_destroyed");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"city",
			this.m.News.get("City")
		]);
	}

	function onClear()
	{
		this.m.News = null;
	}

});

