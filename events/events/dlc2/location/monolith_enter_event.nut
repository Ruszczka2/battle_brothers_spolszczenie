this.monolith_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.monolith_enter";
		this.m.Title = "Gdy się zbliżasz...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_101.png[/img]{Z oddali Czarny Monolit wyglądał jak czarna wieża przechylona z ziemi. Niebo nad nim było nieskalane, jakby chmury i ptaki omijały niewidoczną górę. Odrętwienie spowiło jego zaplecze, ziemia ani nie umierała, ani nie rosła, a okrutna cisza sprawiała, że ospałe życie było gorsze niż żadne życie. Poszukiwacze przygód szli tam i nie wracali. Opowieści o ich zgubie piętrzyły się, aż ich brak osłonił monolit w całości, odziewając go takim strachem i grozą, że nikt nie odważył się podejść.\n\n Ale teraz %companyname% stoi przed obeliskiem jak mrówki przy stali wbitego miecza. Tutaj widzisz, że struktura w ogóle nie została zbudowana na ziemi: obelisk spoczywa w wyrobisku opuszczonego kamieniołomu. Drogi i ścieżki wężowato schodzą w głąb jak jakieś wielkie, puste ziemne gniazdo. Liny niosące wiadra zwisają nad każdą szczeliną, niezliczone wiadra ziemi przechylone jak bezpłomienne latarnie w świąteczną noc. Kolejne wiązania trzymają ramy mostów, deski pomostów dawno już opadły, a jeszcze inne oplatają monolit, jakby wielka gromada ludzi próbowała go ściągnąć albo choć skorygować jego przechył. Na dnie tego opuszczonego wyrobiska jest podstawa monolitu, ale to tylko przypuszczenie. Wszystko wskazuje, że nigdy nie kończy on swojego zejścia w głąb ziemi i tego, co pod nią. Łopaty i kilofy leżą rozsiane przy jego obsydianowych ścianach, z ziemią wciąż zbryloną na metalu. %randombrother% kiwa głową na ten widok.%SPEECH_ON%Wygląda na to, że tego, kto tu kopał, coś przerwało.%SPEECH_OFF%Słowa mężczyzny niosą się daleko po kamieniołomie i tam stają się tak wyraźnie ukształtowane w echu, że niemal widzisz, jak odchodzą. Oglądając się, widzisz, że sama cisza podążyła za tobą, lecz nawet tutaj, na krawędzi wyrobiska, jest zadumana i łatwa do rozcięcia. Decyzja o wejściu do kamieniołomu ciąży na twoich barkach.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wejdź.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Wycofaj się.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_101.png[/img]{W połowie drogi przez kamieniołom, za długim zakrętem, dostrzegasz szereg korytarzy wykutych w dolnej ścianie. Podnosisz zaciśniętą pięść. Kompania zastyga, wpadając na siebie, gdy szyk się zatrzymuje. %randombrother% pyta, co jest nie tak. Przykładasz palec do ust.\n\n Najlżejszym krokiem podchodzisz do jednej z lin rozpiętych między tym poziomem a samym dnem wyrobiska. Wiadro wypełnione ziemią kołysze liną, jakby poruszone twoją obecnością. Kołowrót używany do podnoszenia i opuszczania dawno już pokrył się rdzą. Dobytasz miecza i przecinasz linę. Wiązanie strzela wstecz jak bicz, a wiadro spada. Klekoce na boki po skałach, aż uderza o ziemię metalicznym jękiem i obłokiem kurzu. I tak po prostu cisza znika.\n\n Blade postacie wylewają się z korytarzy poniżej, strumień złowrogich górników i kopaczy rowów w zszarganych spodniach, butach i pelerynach z poszarpanych koszul, wypełzających, jakby wracali do dawno porzuconej, niedokończonej pracy. Próbujesz policzyć ich liczbę, ale odciąga cię widok tłumu opancerzonych żołnierzy maszerujących za zgrają, uzbrojonych w drzewce, tarcze, włócznie i, co najgroźniejsze, w poczucie spójności.\n\nNie ma sensu uciekać z kamieniołomu. Nie ma dokąd. Gdy spoglądasz na ludzi, już dobywają broni. %randombrother% kiwa głową.%SPEECH_ON%Z tobą do końca, kapitanie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Do końca!",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setAttackable(true);
							this.World.State.getLastLocation().setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
						}

						this.World.Events.showCombatDialog(true, true, true);
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
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
	}

});

