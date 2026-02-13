this.gladiators_vibes_event <- this.inherit("scripts/events/event", {
	m = {
		Gladiator1 = null,
		Gladiator2 = null
	},
	function create()
	{
		this.m.ID = "event.gladiators_vibes";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_155.png[/img]{%gl1% obserwuje, jak %gl2% skubie brwi, używając połysku ostrza jako lustra.%SPEECH_ON%Twoje plecy wyglądają masywnie i ciasno, %gl2%. O to chodzi, stary.%SPEECH_OFF%Gladiator odwraca się i przytakuje.%SPEECH_ON%Dzięki, używam ich do noszenia tej kompanii.%SPEECH_OFF% | %SPEECH_ON%Sprawdzenie formy! Sprawdzenie formy!%SPEECH_OFF%%gl1% jest w połowie przysiadu, gdy krzyczy. %gl2% podbiega, klepie gladiatora po pośladkach i woła: jazda! Mężczyzna schodzi w przysiad głęboko poniżej dziewięćdziesięciu stopni.%SPEECH_ON%Jest napięcie!%SPEECH_OFF%%gl2% potwierdza.%SPEECH_ON%Jakie napięcie?%SPEECH_OFF%%gl2% cofa dłoń, zaciska pięść i uderza go w tyłek. Potem macha dłonią, jakby dotknął rozgrzanej patelni.%SPEECH_ON%Twardszy niż sakiewka wezyra!%SPEECH_OFF%%gl1% kończy przysiad, wstaje, i zderzają się klatkami piersiowymi.%SPEECH_ON%Twoja kolej, stary! Jedziemy!%SPEECH_OFF% | %SPEECH_ON%Ej. Spójrz na to.%SPEECH_OFF%Klatka %gl1% podskakuje, jeden cycek na raz. Mówisz mu "ładne cycki" i idziesz dalej, ale on cię łapie.%SPEECH_ON%To nie cycki, to piersiowe. I są piękne. Ej. Powiedz, że są piękne.%SPEECH_OFF%Jeden cycek podskakuje, potem drugi, tam i z powrotem. Wzdychasz i mówisz, że są piękne. %gl1% kiwa głową i wyciera coś z oka.%SPEECH_ON%Dzięki, kapitanie.%SPEECH_OFF% | Zastajesz %gl1% wyciskającego na ławce %gl2%, ten drugi czyta zwój, gdy idzie w górę i w dół.%SPEECH_ON%%randomcitystate% podobno ma piękne kobiety.%SPEECH_OFF%Odwraca się do mężczyzny, który go podnosi. %gl1% zerka na ciebie, po czym wraca do ćwiczeń.%SPEECH_ON%Dziewięćdziesiąt osiem. Dziewięćdziesiąt dziewięć. Sto! Dobra, obracaj się.%SPEECH_OFF%%gl2% przewraca się, dłonie %gl1% ugniatają jego klatkę i brzuch.%SPEECH_ON%Dobra, sto powtórzeń więcej.%SPEECH_OFF% | %gl1% pokazuje cztery palce. %gl2% pokazuje sześć. Przechylając głowę, %gl1% śmieje się.%SPEECH_ON%W jedną noc?%SPEECH_OFF%Drugi gladiator przytakuje.%SPEECH_ON%Tak, panie. W jedną noc.%SPEECH_OFF%%gl1% śmieje się i pyta, czy to były same kobiety. %gl2% waha się.%SPEECH_ON%Cóż, było tam kilku mężczyzn. Ale nie, wiesz, nie dotykaliśmy się ani nic. Byliśmy blisko, bo w pewnym momencie on był tam, a ja stałem tak za-%SPEECH_OFF%Podchodzisz, klaszcząc, nie z aplauzu, lecz żeby kazać gladiatorom się skupić. Wiesz, że drogi bywają długie i nudne, ale to już robi się absurdalne. | %gl1% napina bicepsy.%SPEECH_ON%Mógłbym jednym ramieniem złamać kark muła.%SPEECH_OFF%%gl2% kręci głową i pyta, czemu w takim razie napina oba ramiona. %gl1% przechyla głowę w odpowiedzi.%SPEECH_ON%Bo oczywiście planuję zabić dwa muły naraz, stary.%SPEECH_OFF%Przerywasz, mówiąc gladiatorom, że nie będą zabijać żadnych zwierząt, dopóki nie wykonają głównych zadań %companyname%, a te tylko czasem polegają na zabijaniu zwierząt. | %gl1% siada obok %gl2% i odwraca się. Mówi.%SPEECH_ON%Połóż dłoń na moim kręgosłupie. Tuż między łopatkami.%SPEECH_OFF%Drugi gladiator robi to bez pytania i ciekawości. %gl1% napina się, zaciskając dłoń mężczyzny między dwiema masami mięśni.%SPEECH_ON%Jak ci się podoba taka siła?%SPEECH_OFF%Znów, bez śladu ironii czy niedowierzania, %gl2% odpowiada.%SPEECH_ON%To jest niesamowite, stary! Słyszę, jak trzeszczą mi kości dłoni!%SPEECH_OFF%Myślisz, żeby przerwać, ale technicznie rzecz biorąc nikt jeszcze nie ucierpiał... jeszcze. Zostawiasz gladiatorów ich, eee, skłonnościom. | %SPEECH_START%Więc ułożyłem ją tak na wozie z owocami i właśnie mieliśmy świetny czas, gdy wchodzi jej ojciec. Stoi z rozdziawioną gębą i ledwo może wydusić słowo.%SPEECH_OFF%%gl1% przytakuje.%SPEECH_ON%Więc mówię mu: patrz na to. I cofam się, napinam oba ramiona i powoli, bardzo powoli, ona unosi się nad ziemię.%SPEECH_OFF%%gl2% klepie drugiego gladiatora po lśniącej klatce.%SPEECH_ON%Łżesz! To stek kłamstw!%SPEECH_OFF%Gladiator unosi dłoń.%SPEECH_ON%Na światło Gildera, i jakiekolwiek inne bóstwa zechcą gapić się na moje ciało, to prawda. Mój kij ma moc.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "No proszę.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gladiator1.getImagePath());
				this.Characters.push(_event.m.Gladiator2.getImagePath());
				_event.m.Gladiator1.improveMood(1.0, "Czuje się silny i piękny");

				if (_event.m.Gladiator1.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Gladiator1.getMoodState()],
						text = _event.m.Gladiator1.getName() + this.Const.MoodStateEvent[_event.m.Gladiator1.getMoodState()]
					});
				}

				_event.m.Gladiator2.improveMood(1.0, "Czuje się silny i piękny");

				if (_event.m.Gladiator2.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Gladiator2.getMoodState()],
						text = _event.m.Gladiator2.getName() + this.Const.MoodStateEvent[_event.m.Gladiator2.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_155.png[/img]{%gl1% wpada do twojego namiotu.%SPEECH_ON%Kapitanie! Szybko, %gl2% potrzebuje pomocy!%SPEECH_OFF%Wybiegasz z namiotu i znajdujesz %gl2% siedzącego przy ognisku. Trzęsie się. %gl1% mówi, że mężczyzna miał koszmar.%SPEECH_ON%Śniło mu się, że jest tak chudy, iż ledwie unosi kosz jabłek. Kobiety na niego pluły. Dzieci uciekały w strachu. I poszedł na areny, tylko że musiał siedzieć na trybunach!%SPEECH_OFF%%gl2% spogląda smutno.%SPEECH_ON%To nawet nie były dobre miejsca, kapitanie. To nawet nie były dobre miejsca.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To był tylko zły sen.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gladiator1.getImagePath());
				this.Characters.push(_event.m.Gladiator2.getImagePath());
				_event.m.Gladiator2.worsenMood(1.0, "Miał zły sen o tym, że nie jest silny i piękny");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Gladiator2.getMoodState()],
					text = _event.m.Gladiator2.getName() + this.Const.MoodStateEvent[_event.m.Gladiator2.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.gladiators")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.gladiator" && bro.getFlags().get("IsPlayerCharacter"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		local r = candidates.len() - 1;
		this.m.Gladiator1 = candidates[r];
		candidates.remove(r);
		local r = candidates.len() - 1;
		this.m.Gladiator2 = candidates[r];
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"gl1",
			this.m.Gladiator1 != null ? this.m.Gladiator1.getName() : ""
		]);
		_vars.push([
			"gl2",
			this.m.Gladiator2 != null ? this.m.Gladiator2.getName() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		if (this.Math.rand(1, 100) <= 90)
		{
			return "A";
		}
		else
		{
			return "B";
		}
	}

	function onClear()
	{
		this.m.Gladiator1 = null;
		this.m.Gladiator2 = null;
	}

});

