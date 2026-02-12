this.brawler_teaches_event <- this.inherit("scripts/events/event", {
	m = {
		Brawler = null,
		Student = null
	},
	function create()
	{
		this.m.ID = "event.brawler_teaches";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Cień przesuwa się za tobą. Gdy się odwracasz, %brawler% stoi tam z dość nieobecnym spojrzeniem. Trzaska kostkami w długiej serii, po czym pyta, czy może wyszkolić %noncom%. Pytasz, dlaczego. Zabijaka patrzy na ciebie z góry.%SPEECH_ON%Bo jest słaby.%SPEECH_OFF%Hmm, wystarczy.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Sprawdź, jak długo wytrzyma.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Uhartuj go, dobrze?",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Pokaż mu, jak się bije.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
				this.Characters.push(_event.m.Student.getImagePath());
				_event.m.Brawler.getFlags().add("brawler_teaches");
				_event.m.Student.getFlags().add("brawler_teaches");
				_event.m.Brawler.improveMood(0.25, "Uhartował " + _event.m.Student.getName());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_06.png[/img]%brawler% i %noncom% są w błotnym dole, z rękami owiniętymi w szmaty i liście, by osłonić kostki i nie kaleczyć się przy każdym ciosie. Zabijaka każe uczniowi odbijać się przeciwnie do ruchu wskazówek zegara po kręgu, bić powietrze, a sam uderza lub kopie go przy każdym przejściu. Mężczyźni lśnią potem podczas pracy. Gdy %noncom% zaczyna zwalniać, %brawler% uderza go jak dżokej ospałego konia.\n\n Po godzinie tego treningu %brawler% odsuwa się i zachęca ucznia do ataku. Jak można się spodziewać, atak jest bezładny i żałosny. Długie, szerokie ciosy padają bez energii. Zabijaka schyla się i uskakuje, kontrowując każdą próbę uderzenia własnym ciosem.%SPEECH_ON%Widzisz, co się dzieje, gdy jesteś zmęczony? Dlatego musimy trenować. Nawet najsilniejsi i najgroźniejsi są nic niewarci bez powietrza w płucach i świeżych nóg pod sobą.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Męczę się już od samego patrzenia.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
				this.Characters.push(_event.m.Student.getImagePath());
				local skill = this.Math.rand(2, 4);
				_event.m.Student.getBaseProperties().Stamina += skill;
				_event.m.Student.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Student.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + skill + "[/color] maks. zmęczenie"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_06.png[/img]Zabijaka każe %noncom% stać zupełnie nieruchomo. Krąży wokół niego, trzaskając kostkami, gdy go mierzy. W końcu ujawnia swoje zamiary.%SPEECH_ON%Będę cię bił, aż pękniesz.%SPEECH_OFF%Uczeń dostaje chwilę, by przyjąć to, co ma się stać. Wciąga głęboko powietrze i kiwa głową. %brawler% nie traci czasu, pakując okrężny cios prosto w klatkę piersiową mężczyzny. Ten pada, po czym jest wielokrotnie kopany w ramię, aż znów wstaje.\n\nDalej zabijaka krąży i zadaje ciosy. Nie każdy cios jest pełny: większość ma sprawić ból, ale nie to, co można by nazwać nieodwracalnymi obrażeniami. Zabijaka, gdyby chciał, mógłby zabić tego człowieka gołymi pięściami, ale to nie jest cel treningu. Uświadamiasz sobie, że taki sposób \'hartowania\' spotkał kiedyś i samego zabijakę.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Co cię nie zabije, to cię wzmocni?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
				this.Characters.push(_event.m.Student.getImagePath());
				local skill = this.Math.rand(2, 4);
				_event.m.Student.getBaseProperties().Hitpoints += skill;
				_event.m.Student.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/health.png",
					text = _event.m.Student.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + skill + "[/color] punkty zdrowia"
				});
				_event.m.Student.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Student.getName() + " doznaje lekkich ran"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_06.png[/img]%brawler%, ciężkoręki zabijaka, stoi pochylony, z rękami wysuniętymi w obronnej postawie, a %noncom% stoi obok, próbując naśladować pozycję. Zabijaka obniża ciało i wchodzi pod ramiona %noncom%, oplatając jego pas obiema rękami i unosząc go w górę, po czym zrzuca na plecy. %brawler% odchodzi, trzaskając kostkami i każe %noncom% wstać.%SPEECH_ON%Musisz być gotów na dwie rzeczy: na moje wejście nisko i na moje wejście wysoko.%SPEECH_OFF%%noncom% otrzepuje się i trochę narzeka.%SPEECH_ON%Jak mam możliwie robić jedno i drugie?%SPEECH_OFF%Zabijaka ignoruje pytanie i po prostu prosi, by mężczyzna go zaatakował. %noncom% spełnia prośbę, idąc wysoko i zamachując się pięścią. %brawler% zbija cios barkowym zejściem, po czym kontruje krzyżowym, który obraca %noncom% na nogach. Pięściarz znów trzaska kostkami i spluwa.%SPEECH_ON%Praktyka. Tak. A teraz wstawaj i jeszcze raz.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Może jednak wyrośnie z niego prawdziwy najemnik.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
				this.Characters.push(_event.m.Student.getImagePath());
				local attack = this.Math.rand(1, 2);
				local defense = this.Math.rand(1, 2);
				_event.m.Student.getBaseProperties().MeleeSkill += attack;
				_event.m.Student.getBaseProperties().MeleeDefense += defense;
				_event.m.Student.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Student.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + attack + "[/color] Umiejętność walki wręcz"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_defense.png",
					text = _event.m.Student.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + defense + "[/color] Obronę wręcz"
				});
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_brawler = [];
		local candidates_student = [];

		foreach( bro in brothers )
		{
			if (bro.getFlags().has("brawler_teaches"))
			{
				continue;
			}

			if (bro.getLevel() >= 3 && bro.getBackground().getID() == "background.brawler")
			{
				candidates_brawler.push(bro);
			}
			else if (bro.getLevel() < 3 && !bro.getBackground().isCombatBackground())
			{
				candidates_student.push(bro);
			}
		}

		if (candidates_brawler.len() == 0 || candidates_student.len() == 0)
		{
			return;
		}

		this.m.Brawler = candidates_brawler[this.Math.rand(0, candidates_brawler.len() - 1)];
		this.m.Student = candidates_student[this.Math.rand(0, candidates_student.len() - 1)];
		this.m.Score = (candidates_brawler.len() + candidates_student.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"brawler",
			this.m.Brawler.getNameOnly()
		]);
		_vars.push([
			"noncom",
			this.m.Student.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Brawler = null;
		this.m.Student = null;
	}

});

