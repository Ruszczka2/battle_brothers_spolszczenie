this.flagellant_vs_monk_event <- this.inherit("scripts/events/event", {
	m = {
		Monk = null,
		Flagellant = null
	},
	function create()
	{
		this.m.ID = "event.flagellant_vs_monk";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Ognisko świeci jasno, skręcając twarze mężczyzn w płynącej pomarańczy, jakby sami byli z płonącego drewna.\n\n To tutaj zastajesz %monk% i %flagellant% rozmawiających ze sobą. Ich dyskusja na początku jest spokojna. Mnich błaga biczownika, by odłożył bicz. Choć niekoniecznie chcesz się wtrącać, nie możesz nie zgodzić się, że niszczenie własnego ciała według wyśrubowanego harmonogramu rzezi nie jest najlepszym sposobem na życie. Ale wtedy biczownik odpowiada czymś, co was obu zatrzymuje. To zdanie tak dobrze ułożone, że sama myśl, iż mogłoby usprawiedliwiać jego osobiste nawyki, każe ci jak najszybciej wyrzucić tę myśl z głowy. Niepokojąca była też łatwość, z jaką to powiedział. Że tak kojący głos mógł być tak ciepło uwięziony w tej pokrytej bliznami skorupie ciała. Co mogło to zrodzić?\n\n Mnich jąka się przez chwilę, po czym kładzie dłonie na ramionach biczownika, przytrzymując go, by mogli patrzeć sobie w oczy. Szepcze słowa, które łaskoczą twoje uszy, ale nie brzmią dość głośno, by miały prawdziwe znaczenie. Możesz tylko zakładać, że mają znów przekonać biczownika do lepszego, mniej brutalnego życia.\n\n Ale znów biczownik zaczyna odpowiadać i tak przerzucają się słowami dalej.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To fascynujące. Zobaczmy, dokąd to doprowadzi.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "Dobrze, dość tego. Mamy prawdziwą robotę.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				this.Characters.push(_event.m.Flagellant.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]Postanawiasz pozwolić im rozmawiać i odchodzisz na chwilę. Gdy wracasz, zastajesz biczownika siedzącego obok mnicha. Oboje kołyszą się na kłodzie, dłonie złożone do modlitwy, a z ich ust płyną szeptane, niebiańskie słowa. Nie masz ochoty podchodzić bliżej, by słyszeć, o czym mówią, bo sam widok jest kojący. Choć nie masz zdania, jaka droga najlepiej zadowala bogów, nie możesz nie poczuć się lepiej, widząc, że biczownik odłożył swoje narzędzia samoudręki.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niech teraz odnajdzie spokój.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				this.Characters.push(_event.m.Flagellant.getImagePath());
				local background = this.new("scripts/skills/backgrounds/pacified_flagellant_background");
				_event.m.Flagellant.getSkills().removeByID("background.flagellant");
				_event.m.Flagellant.getSkills().add(background);
				_event.m.Flagellant.m.Background = background;
				background.buildDescription();
				this.List = [
					{
						id = 13,
						icon = background.getIcon(),
						text = _event.m.Flagellant.getName() + " jest teraz Uspokojonym Biczownikiem"
					}
				];
				_event.m.Monk.getBaseProperties().Bravery += 2;
				_event.m.Monk.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Monk.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Determinacji"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]Postanawiasz pozwolić im rozmawiać i odchodzisz na chwilę.\n\nKiedy wracasz, mnich jest nagi i pochylony, z łzami w oczach. Jego postawa jest tchórzliwa, ale twarz rozdzierająca, jakby tego właśnie zawsze pragnął. Z łapczywym wdechem prostuje się i przerzuca nad ramieniem nadgarstek. Biczownik trzyma bicz i słyszysz, jak skóra uderza o plecy mnicha. Odsuwa narzędzie, a dźwięk szkła i kolców rozrywających ciało dzwoni ci w uszach. Sam biczownik nic nie mówi. Siada obok mnicha. Wpatruje się w przestrzeń, ale w jego oczach ledwie tli się życie, choć wyraźnie widzisz krew życia spływającą mu po plecach, gdy funduje sobie chłostę.\n\nOdchodzisz raz jeszcze, ale trawa pod stopami nie ma już tego samego chrupnięcia, a w powietrzu czuć metaliczny zapach. Ciche uderzenia skóry podążają za tobą aż do namiotu.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Człowiek pozostawiony sam sobie w torturach może znaleźć najprawdziwsze koszmary.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				this.Characters.push(_event.m.Flagellant.getImagePath());
				local background = this.new("scripts/skills/backgrounds/monk_turned_flagellant_background");
				_event.m.Monk.getSkills().removeByID("background.monk");
				_event.m.Monk.getSkills().add(background);
				_event.m.Monk.m.Background = background;
				background.buildDescription();
				this.List = [
					{
						id = 13,
						icon = background.getIcon(),
						text = _event.m.Monk.getName() + " jest teraz Mnichem, który stał się Biczownikiem"
					}
				];
				_event.m.Flagellant.getBaseProperties().Bravery += 2;
				_event.m.Flagellant.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Flagellant.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Determinacji"
				});
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local flagellant_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.flagellant")
			{
				flagellant_candidates.push(bro);
			}
		}

		if (flagellant_candidates.len() == 0)
		{
			return;
		}

		local monk_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.monk")
			{
				monk_candidates.push(bro);
			}
		}

		if (monk_candidates.len() == 0)
		{
			return;
		}

		this.m.Flagellant = flagellant_candidates[this.Math.rand(0, flagellant_candidates.len() - 1)];
		this.m.Monk = monk_candidates[this.Math.rand(0, monk_candidates.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"monk",
			this.m.Monk.getName()
		]);
		_vars.push([
			"flagellant",
			this.m.Flagellant.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Monk = null;
		this.m.Flagellant = null;
	}

});

