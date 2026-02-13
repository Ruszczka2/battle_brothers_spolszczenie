this.waterwheel_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.waterwheel_enter";
		this.m.Title = "Gdy się zbliżasz...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_109.png[/img]{Koło młyńskie chwieje się na zawiasach, gdy jego czerpaki zanurzają się i wyciągają wodę. Do boku przylega kamienne domostwo z kominem wyrzucającym czarne kłęby. Na ścianach wiszą skóry i sidła, a na ganku stoi dębowe krzesło. Okna są zbyt mętne, by przez nie patrzeć, ale słychać, jak młyńskie koło w środku wznosi się i miele z drewnianymi jękami. Dobywając miecza, wchodzisz na ganek i otwierasz drzwi.\n\n Mężczyzna wita cię w pierwszym i jedynym pomieszczeniu. Stoi obok studni młyńskiej, przesuwając dłonią po ziarnie. Jest starszym człowiekiem, lecz skromnego wzrostu, jakby czas nie miał prawa do jego postawy ani umiejętności. Nad kominkiem wisi rękojeść miecza. Jej blask jest nieomylnie szlachetny, a starzec spogląda na twoje spojrzenie z ciepłym uśmiechem.%SPEECH_ON%Tylko godni mogą mieć rękojeść %weapon%. Ty, nieznajomy, nie jesteś godny.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ten starzec mnie nie powstrzyma.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Co uczyniłoby mnie godnym?",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_109.png[/img]{Robisz krok naprzód i grozisz mężczyźnie, by się odsunął albo zmierzył z twoją stalą. Macha dłonią, a twoje stopy odrywają się od ziemi. Podmuch wiatru uderza cię o ścianę z taką siłą, że słyszysz grzechot sztućców, a z sufitu sypie się kurz. Starzec patrzy na ciebie tak spokojnie, jak w chwili, gdy przekroczyłeś próg.%SPEECH_ON%Tylko godni. Rozumiesz?%SPEECH_OFF%Nie ma tu innej odpowiedzi niż skinąć głową na zgodę. Dłoń starca opada, a ty spadasz na podłogę. Podnosisz miecz, upewniając się, że rozumie, iż tylko go chowasz. Pytasz, co uczyniłoby cię godnym. Starzec uśmiecha się ponownie.%SPEECH_ON%Mój jedyny syn był godny. Wyruszył, by walczyć z wielką bestią. Pomszczij go, a będziesz godny.%SPEECH_OFF%Zostajesz wypchnięty z domu, a drzwi trzaskają za tobą. Wygląda na to, że masz zadanie, choć nie masz nawet bladego pojęcia, gdzie leży północ kompasu, by wiedzieć, dokąd z nim iść.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Musimy to rozwiązać sami.",
					function getResult( _event )
					{
						this.World.Flags.set("IsWaterWheelVisited", true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_109.png[/img]{Starzec wpatruje się w młyn. Unosi dłoń i rój ziaren krąży wokół jego palców jak pszczoły wokół pąków trzciny cukrowej.%SPEECH_ON%Mój jedyny syn wyruszył zabić wielką bestię. Jego giermek przyniósł mi rękojeść, ale ostrze zniknęło. Pomszczij mojego syna, a będziesz godny, nieznajomy.%SPEECH_OFF%Pytasz, gdzie jest bestia, a mężczyzna znów wkłada dłoń w młyńskie mechanizmy.%SPEECH_ON%Gdybym tylko wiedział. Ufam, że ty to odkryjesz, najemniku.%SPEECH_OFF%Twoje stopy nagle zsuwają się po podłodze, na ganek i na trawę. Drzwi trzaskają przed tobą i nie otworzą się ponownie. Wygląda na to, że niechcący podjąłeś zadanie, a może jedno z tych, które trzyma się na boku.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Musimy to rozwiązać sami.",
					function getResult( _event )
					{
						this.World.Flags.set("IsWaterWheelVisited", true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "A2",
			Text = "[img]gfx/ui/events/event_109.png[/img]{Starszy mężczyzna już na ciebie czeka, gdy wchodzisz. Odwraca się dość szybko, jakbyś mu przeszkodził.%SPEECH_ON%Więc wróciłeś! I czy ci się udało? Czy pomściłeś mojego chłopca? Czy jesteś, najemniku, godny?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Czy to uczyni mnie godnym?",
					function getResult( _event )
					{
						return "C2";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B2",
			Text = "[img]gfx/ui/events/event_109.png[/img]{Koło młyńskie chwieje się na zawiasach, gdy jego czerpaki zanurzają się i wyciągają wodę. Do boku przylega kamienne domostwo z kominem wyrzucającym czarne kłęby. Na ścianach wiszą skóry i sidła, a na ganku stoi dębowe krzesło. Okna są zbyt mętne, by przez nie patrzeć, ale słychać, jak młyńskie koło w środku wznosi się i miele z drewnianymi jękami. Dobywając miecza, wchodzisz na ganek i otwierasz drzwi.\n\n Mężczyzna wita cię w pierwszym i jedynym pomieszczeniu. Stoi obok studni młyńskiej, przesuwając dłonią po ziarnie. Jest starszym człowiekiem, lecz skromnego wzrostu, jakby czas nie miał prawa do jego postawy ani umiejętności. Nad kominkiem wisi rękojeść miecza, a jej blask jest nieomylnie szlachetny, i starzec spogląda na twoje spojrzenie z ciepłym uśmiechem.%SPEECH_ON%Tylko godni mogą mieć rękojeść %weapon%. Tylko ci, którzy pomszczą mojego syna i przyniosą mi jego ostrze, będą godni. Aby to zrobić, musisz znaleźć bestię.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Czy to uczyni mnie godnym?",
					function getResult( _event )
					{
						return "C2";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C2",
			Text = "[img]gfx/ui/events/event_109.png[/img]{Ostrze %weapon% wibruje i brzęczy. Trzymasz je przed sobą obiema dłońmi, stal drży lekko na twoich palcach. Uśmiechając się ponownie, starzec kiwa głową i kieruje dłoń ku wiszącej rękojeści. Ta unosi się z uchwytu i płynie przez pokój do twoich rąk. Tam odchyla się i stapia ze stalą, stając się całością w błysku pomarańczu i błękitu. To jedna z najbardziej niezwykłych kling, jakie kiedykolwiek widziałeś, z glifami księżyców i gwiazd rozbłyskującymi w zbroczu. Gdy podnosisz wzrok, widzisz przez pierś starca, gdy stopniowo znika.%SPEECH_ON%Mój syn został pomszczony. Jego duch może spocząć, i teraz mój także.%SPEECH_OFF%Patrzysz, jak ukończony miecz unosi się w powietrze i obraca ze stalą skierowaną w dół. Szafki otwierają się z trzaskiem, a pasy skóry wylatują i zatrzaskują się w wiązania, które zbierają się, by stworzyć pochwę.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wezmę go.",
					function getResult( _event )
					{
						return "D2";
					}

				}
			],
			function start( _event )
			{
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "misc.legendary_sword_blade")
					{
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Tracisz " + item.getName()
						});
						break;
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D2",
			Text = "[img]gfx/ui/events/event_109.png[/img]{%weapon% opada, a ty sięgasz, by go złapać, lecz zjawiła się upiorna dłoń, która kradnie go z powietrza. Podnosisz wzrok, widząc starca dobywającego ostrza, odsłaniającego jego ogień i lód, jakby to on rozdzielał nowy dzień i ponurą noc w samym spektrum stali. Krztusi się śmiechem.%SPEECH_ON%\'Pomszczij mojego syna!\' \'Bądź godny!\' Próżne igraszki dla prostaczków. Dobrze goniłeś marchewkę, najemniku, i za to zabiję cię szybko.%SPEECH_OFF%Naramienniki, karwasze i napierśnik wznoszą się z młyńskiej studni, ziarno spływa z nich płatami, odsłaniając krzykliwe kształty, a metale skręcają się i płyną do starca, uderzając jego ciało, jakby chciały opancerzyć samo kowadło, które pomogło je wykuć. Zbroja składa się w całość, gdy jej właściciel zachrypnięcie śmiechem. Ręce chwytają cię za ramiona i wyciągają z domu. Osłania cię %companyname%. Starszy upiór odwraca głowę.%SPEECH_ON%Gromada moronów, co? Odejdźcie wszyscy, a oszczędzę was. Proszę tylko, zostawcie mi kapitana, bo już obiecałem jego zgubę.%SPEECH_OFF%%randombrother% dobywa broni, a reszta kompanii robi to samo. Starzec w odpowiedzi unosi zmierzchowy miecz. Choć stal jest całkowicie realna, ciało starca faluje w tę i z powrotem jak cienko zasłonięta kotara w świetle księżyca. Wzdycha, a z jego ust uchodzą smugi błękitnego eteru. Obraca ostrze tak, by krawędź była skierowana ku tobie.%SPEECH_ON%Niech tak będzie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Do boju!",
					function getResult( _event )
					{
						this.World.State.getLastLocation().setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getID());
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
		_vars.push([
			"weapon",
			"Nagana Starych Bogów"
		]);
	}

	function onDetermineStartScreen()
	{
		local hasBlade = false;
		local hasBeenHereBefore = this.World.Flags.get("IsWaterWheelVisited");
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && item.getID() == "misc.legendary_sword_blade")
			{
				hasBlade = true;
				break;
			}
		}

		if (hasBlade)
		{
			if (hasBeenHereBefore)
			{
				return "A2";
			}
			else
			{
				return "C2";
			}
		}
		else
		{
			return "A";
		}
	}

	function onClear()
	{
	}

});

