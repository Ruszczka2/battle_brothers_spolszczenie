this.aging_swordmaster_event <- this.inherit("scripts/events/event", {
	m = {
		Swordmaster = null
	},
	function create()
	{
		this.m.ID = "event.aging_swordmaster";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_17.png[/img]Zastajesz %swordmaster%, jak z trudem próbuje usiąść na pniaku. Gdy ostrożnie opada, widzisz, że nogi drżą mu tak, jakby ledwo mogły się zgiąć. Po zajęciu miejsca wydaje długie westchnienie. Jego miecz leży obok. Jest młodszy niż dłonie, które go trzymają - to zastępstwo zastępstwa zastępstwa. Nie okazuje mu czułości, lecz gdy go dotyka, czujesz odbicie w samej idei miecza, w tym jak człowiek wydłuża siebie nim, i jak skraca innych jego ostrzem. Odwracasz się, chcąc dać mistrzowi miecza chwilę dla siebie, ale on zauważa twoje odejście i woła.%SPEECH_ON%Hej, kapitanie. Nie chciałem, żebyś to widział.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jak się trzymasz?",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Cóż, widziałem. Teraz ruszaj.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_17.png[/img]Opiera się i pociera jedno z kolan zrogowaciałą dłonią. Podmuch wiatru rozrzuca pasma jego posiwiałych włosów.%SPEECH_ON%Stary. Tak się trzymam. I nie mam na myśli wieku. Wedle lat jestem stary od dawna. Mam na myśli stare kości. Chyba bardziej żyję dziś reputacją niż umiejętnościami.%SPEECH_OFF%Natychmiast się z nim nie zgadzasz, mówiąc, że jest jednym z najgroźniejszych ludzi, jakich spotkałeś.%SPEECH_ON%Zostaw uprzejmości kobietom, kapitanie. Wzrok mi siada. Pewnie nie chcesz tego słyszeć, ale tak jest. Moja przednia noga nie stawia już tak jak kiedyś. Kolano klika, blokuje się. Pewnego dnia mnie to zgubi. W lewej dłoni nie czuję nic.%SPEECH_OFF%Mistrz miecza zaciska i rozluźnia wolną dłoń.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Czujesz coś?",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_17.png[/img]%SPEECH_ON%Nic. Chyba nerwy obumierają. I czasem zapominam. Nie chodzi o to, gdzie zostawiłem buty. Zapominam, czy ktoś stoi za mną, czy nie. Moje wyczucie otoczenia, mój prawdziwy oręż, stępiło się. Przy całej mojej szybkości i instynkcie to czas zakradł się do mnie, powoli i równo, bez gorąca ani zimna, po prostu był, jest i będzie. Zawsze myślałem, że pokona mnie inny szermierz. Ktoś z talentem. Ale chyba byłem na to zbyt dobry.%SPEECH_OFF%Mistrz miecza uśmiecha się figlarnie. Pytasz, czy boi się śmierci bez honoru.%SPEECH_ON%Dawno temu zrozumiałem, że gdy stajesz się kimś o mojej reputacji, każda droga do śmierci będzie rozczarowaniem. W księgach zapiszą, jak ktoś poniżej mojej rangi zabił wielkiego mistrza miecza. Bzdura. Jeśli chcesz prawdy, powiem ci. Boję się tego, co nadchodzi. Że ciało zdradzi mnie w ostatnich chwilach. Z czasem po swojej stronie to ciało mnie zabije. Kolano się zablokuje, chwyt osłabnie, bark zwiotczeje. Nie boję się śmierci. Byłem zbyt dobry na śmierć, więc śmierć musi poczekać. Najpierw zabije mnie moje ciało, a potem śmierć weźmie to, co zostanie, żałosny czarny skrawek. Pisarze i kronikarze? Sikać na nich. Gdybym chciał wiecznej chwały, walczyłbym sam z armią.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Z tego co słyszałem, zrobiłeś to.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_17.png[/img]Stary mistrz miecza uśmiecha się. %SPEECH_ON%Daj spokój, kapitanie. Pomóż mi wstać, żebyśmy mogli wrócić na drogę.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Czas płynie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
				local old_trait = this.new("scripts/skills/traits/old_trait");
				_event.m.Swordmaster.getSkills().add(old_trait);
				_event.m.Swordmaster.setHitpoints(this.Math.min(_event.m.Swordmaster.getHitpoints(), _event.m.Swordmaster.getHitpointsMax()));
				this.List = [
					{
						id = 13,
						icon = old_trait.getIcon(),
						text = _event.m.Swordmaster.getName() + " zestarzał się"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_17.png[/img]Słyszysz westchnienie starego mistrza miecza, gdy odchodzisz. Nadążanie za resztą kompanii stało się dla niego, jak się zdaje, walką samą w sobie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Czas płynie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
				local old_trait = this.new("scripts/skills/traits/old_trait");
				_event.m.Swordmaster.getSkills().add(old_trait);
				_event.m.Swordmaster.setHitpoints(this.Math.min(_event.m.Swordmaster.getHitpoints(), _event.m.Swordmaster.getHitpointsMax()));
				this.List = [
					{
						id = 13,
						icon = old_trait.getIcon(),
						text = _event.m.Swordmaster.getName() + " zestarzał się"
					}
				];
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 9 && bro.getBackground().getID() == "background.swordmaster" && !bro.getSkills().hasSkill("trait.old") && !bro.getFlags().has("IsRejuvinated"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() > 0)
		{
			this.m.Swordmaster = candidates[this.Math.rand(0, candidates.len() - 1)];
			this.m.Score = this.m.Swordmaster.getLevel() - 5;
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"swordmaster",
			this.m.Swordmaster.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Swordmaster = null;
	}

});

