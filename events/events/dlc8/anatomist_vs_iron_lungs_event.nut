this.anatomist_vs_iron_lungs_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		IronLungs = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_vs_ironlungs";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{W świecie najemników duża wytrzymałość jest bardzo ważna, ale widać, że niektórzy mężczyźni znacznie lepiej walczą ze zmęczeniem niż inni. %ironlungs% to jeden z nich, wojownik znany z tego, że potrafi utrzymać równy oddech daleko w trakcie wyczerpującej bitwy. Dla ciebie to tylko ciekawostka, jak dziwna szyja, ogromne dłonie czy wielki młot między nogami. Ale dla %anatomist% to coś zupełnie innego. Chce wiedzieć, jak to możliwe, że jeden człowiek ma tak mocne i wydajne płuca, skoro jego codzienne życie niewiele różni się od życia innych.%SPEECH_ON%Wszyscy jesteśmy tu wojownikami, więc jak to się stało, że ten człowiek oddycha tak równo w porównaniu do reszty? Musi mieć w sobie jakiś element, którego my nie mamy, i sądzę, że mogę go znaleźć.%SPEECH_OFF%Czekaj, \'wszyscy\' jesteśmy tu wojownikami? Nie posunąłbyś się aż tak daleko, ale nie poprawiasz anatomisty. Pytasz go, jak dokładnie zamierza to zbadać.%SPEECH_ON%Prosta sekcja zwłok nie byłaby niczym nadzwyczajnym, ale sądzę, że %ironlungs% odmówiłby. Zostaje mi więc jedna opcja: badać go uważnie i sprawdzić, czy mogę odtworzyć jego zalety u siebie poprzez manipulacje kości i ostrożne nacięcia.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Hej, to twoje cialo.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "Nie ma mowy.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.IronLungs.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Mówisz anatomiscie, by robił, co chce. Wyciąga pióro i kilka książek, a potem torbę pełną metalowych szczypiec, nożyc i skalpeli. Sprawdza ich czystość, po czym podnosi je i podchodzi do %ironlungs%. Najemnik odpowiada niezręcznym spojrzeniem. W końcu anatomista namawia mężczyznę, by wszedł z nim do namiotu. Pilnujesz okolicy na wypadek, gdyby anatomista postradał zmysły i wpadł w szalony naukowy amok. W końcu %anatomist% wraca z fiolką, którą przez chwilę obraca, po czym wypija. Kiwał głową.%SPEECH_ON%Mam nadzieję, że to zadziała. Mocno obciążyłem swoje ciało, by naprawdę przećwiczyć płuca, a potem dodałem składniki pochodzące od samego %ironlungs%. Następnie, rzecz jasna, dodatkowe elementy, o których nie będę nikomu opowiadał, bo jeśli to zadziała, mogę stać się ekspertem w tej dziedzinie, prawdziwym bohaterem nauki i zdecydowanie prześcignąć innych anatomistów.%SPEECH_OFF%Dobrze. %ironlungs% wychodzi teraz z namiotu. Pytasz go, co się stało. Mężczyzna wzrusza ramionami.%SPEECH_ON%Powiedziałem mu, że dużo się rozciągam i mam dobrą postawę oraz że czasem ćwiczę oddech. Odrzucił te odpowiedzi, przekonując siebie, że musi być jakiś inny sposób. Potem oszalał z tymi narzędziami i zaczął, hmm, \'pracować\' na sobie. Cokolwiek zrobił, wyglądało na potwornie bolesne, ale zniósł to dobrze.%SPEECH_OFF%Czekaj, ćwiczysz oddech?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Teraz oddycham świadomie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local trait = this.new("scripts/skills/traits/iron_lungs_trait");
				_event.m.Anatomist.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Anatomist.getName() + " zyskuje Żelazne Płuca"
				});
				local injury = _event.m.Anatomist.addInjury([
					{
						ID = "injury.pierced_lung",
						Threshold = 0.0,
						Script = "injury/pierced_lung_injury"
					}
				]);
				this.List.push({
					id = 11,
					icon = injury.getIcon(),
					text = _event.m.Anatomist.getName() + " odnosi " + injury.getNameOnly()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.IronLungs.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%anatomist% dostaje zielone światło i pospiesznie wraca do namiotu z torbą narzędzi i %ironlungs% u boku. Wchodzisz do namiotu i widzisz %anatomist% siedzącego prosto z nieskazitelną postawą, po czym zgina się jak starzec z kręgosłupem złamanym przez wiek, a potem znowu prostuje.\n\nNagle bierze jedno z narzędzi i przebija się nim. %ironlungs% cofa się, zaskoczony takim autodestrukcyjnym czynem. Wyciąga dłoń, by pomóc anatomiscie, ale ten go odgania. Zaciskając zęby, %anatomist% zaczyna robić notatki, gdy krew tryska z jego ust na kartki. Potem powtarza to jeszcze raz, tym razem z innego kąta.\n\nNawet z daleka widzisz, jak krew wypływa grubymi strugami ciemnej czerwieni, a co chwilę pryska jasnym szkarłatem. Zaciska zęby i zadaje kolejne uderzenie. Tym razem z rany tryska wielka fala krwi. Widziałeś już dość, ale zanim zdążysz interweniować, oczy anatomisty wywracają się do tyłu i ten traci przytomność. %ironlungs% wygląda na wstrząśniętego.%SPEECH_ON%Co do cholery? Ty mu na to pozwoliłeś, kapitanie? Czego on chciał się nauczyć?%SPEECH_OFF%Nie płacą ci wystarczająco, by znosić tych durniów. Patrząc na notatki anatomisty, przez zakrwawioną stronę widzisz, że po prostu napisał \'nie działa\' w kółko.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Gdy samo oddychanie czyni z ciebie nudziarza.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local injury = _event.m.Anatomist.addInjury([
					{
						ID = "injury.pierced_lung",
						Threshold = 0.0,
						Script = "injury/pierced_lung_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Anatomist.getName() + " odnosi " + injury.getNameOnly()
				});
				_event.m.Anatomist.worsenMood(0.5, "Jego eksperymentalna operacja nie zadziałała");
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.IronLungs.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Mówisz anatomiscie, by pilnował swojego nosa. Gdy zaczyna się burzyć, co zaczyna być niebezpiecznie bliskie twojej sprawie, tłumaczysz mu, że %ironlungs% jest swoim własnym człowiekiem i należy tylko do siebie, a z jego istnienia nie ma nic poza odrobiną podziwu. I tyle. %anatomist% otwiera usta, by odpowiedzieć, po czym je zamyka. Zamiast tego to, co myślał, zapisuje w notatkach. Masz nadzieję, że wszelki dramat wyschnie razem z atramentem.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cholerni madralowie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(1.0, "Odmówiono mu okazji do badań");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];
		local ironLungsCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist" && !bro.getSkills().hasSkill("trait.iron_lungs"))
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() != "background.anatomist" && bro.getSkills().hasSkill("trait.iron_lungs"))
			{
				ironLungsCandidates.push(bro);
			}
		}

		if (ironLungsCandidates.len() == 0 || anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.IronLungs = ironLungsCandidates[this.Math.rand(0, ironLungsCandidates.len() - 1)];
		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Score = 5 * ironLungsCandidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
		_vars.push([
			"ironlungs",
			this.m.IronLungs.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.IronLungs = null;
	}

});

