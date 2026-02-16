this.anatomist_vs_ailing_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Ailing = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_vs_ailing";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%ailing%, chorowity najemnik, siedzi skulony i wpatruje się w ognisko. Choruje od dłuższego czasu i nie wygląda na to, by było lepiej. Jednak %anatomist% anatomista twierdzi, że może sporządzić dla niego rozwiązanie - rodzaj mikstury, która wzmocni jego ciało i uzdrowi go.%SPEECH_ON%Widziałem, jak to działało wiele razy. Jest tylko jeden problem: potrzebne składniki nie pochodzą z tych okolic, ale czytałem o tym dość, by z łatwością znaleźć odpowiednie zamienniki.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Idz i wylecz go z dolegliwosci.",
					function getResult( _event )
					{
						local outcome = this.Math.rand(1, 100);

						if (outcome <= 33)
						{
							return "B";
						}
						else if (outcome <= 66)
						{
							return "C";
						}
						else
						{
							return "D";
						}
					}

				},
				{
					Text = "Nie, to wcale nie brzmi bezpiecznie.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Ailing.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Pozwalasz %anatomist% wykonywać jego pracę, cokolwiek to znaczy. Anatomista i %ailing% znikają na chwilę w namiocie. Gdy kompanię trzeba ruszać w drogę, %ailing% jest jak nowy. Ożywiony nową energią, ma lekki, sprężysty krok. %anatomist% wychodzi, zapisując coś w swoim notatniku.%SPEECH_ON%Wyniki były całkiem dobre, bardzo dobre.%SPEECH_OFF%Z ciekawości pytasz, co zrobił. Ten odrywa się od skupienia i rzuca ci spojrzenie, po czym odwraca księgę, byś nie mógł jej czytać. Dalej mruczy do siebie.%SPEECH_ON%Najlepsze wyniki? Nie, nie mogę napisać najlepsze wyniki. Mogą wystąpić jeszcze skutki uboczne, które nadejdą, jak to ująć, bokiem.%SPEECH_OFF%Cóż. Oby %ailing% był po prostu wyleczony i na tym koniec.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "W takim razie ruszajmy w droge.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Ailing.getSkills().removeByID("trait.ailing");
				this.List = [
					{
						id = 10,
						icon = "ui/traits/trait_icon_59.png",
						text = _event.m.Ailing.getName() + " nie jest juz Chorowity"
					}
				];
				local healthBoost = this.Math.rand(2, 4);
				_event.m.Ailing.getBaseProperties().Hitpoints += healthBoost;
				_event.m.Ailing.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/health.png",
					text = _event.m.Ailing.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + healthBoost + "[/color] Punkty Zycia"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Ailing.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Dajesz %anatomist% zielone światło. On i %ailing% odchodzą na chwilę do namiotu. Mijają godziny i kompanię wkrótce trzeba ruszać w drogę. Podchodzisz i wchodzisz do namiotu. %ailing% leży na pryczy z rękami skrzyżowanymi nad głową, a nogi ma zgięte w kolanach. Jest spocony i wciąż kręci głową z lewej na prawą. %anatomist% stoi obok i robi notatki.%SPEECH_ON%Wygląda na to, że procedura nie zadziałała tak, jak zamierzano, jednak nawet niezamierzone skutki mogą nieść ważne informacje.%SPEECH_OFF%Wściekły pytasz, czy przeżyje. Anatomista kiwa głową.%SPEECH_ON%Może przez jakiś czas miewać urojenia, ale ostatecznie nadal będzie oddychającym zwierzęciem - przepraszam, oddychającym człowiekiem.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "W takim razie ruszajmy w droge.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Ailing.getSkills().removeByID("trait.ailing");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_59.png",
					text = _event.m.Ailing.getName() + " nie jest juz Chorowity"
				});

				if (!_event.m.Ailing.getSkills().hasSkill("trait.paranoid"))
				{
					local trait = this.new("scripts/skills/traits/paranoid_trait");
					_event.m.Ailing.getSkills().add(trait);
					this.List.push({
						id = 10,
						icon = trait.getIcon(),
						text = _event.m.Ailing.getName() + " zyskuje Paranoiczny"
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Ailing.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Decydujesz się pozwolić anatomiscie zrobić to, co uzna za konieczne, mając nadzieję, że %ailing% szybko wyzdrowieje. Czas mija, kompanię trzeba zbierać w drogę, a %anatomist% wciąż nie wychodzi z namiotu. Podchodzisz i zaglądasz do środka.\n\nZastajesz anatomistę siedzącego na stołku z boku. Jedna ręka leży na stole, a dłoń szalenie skrobie wte i wewte w notatniku. Druga ręka zwisa między nogami, kciuk i palec wskazujący co chwilę zaciskają się w dziwnym, szczypiącym ruchu, jakby odliczał sekundy. Przenosisz wzrok na %ailing%, który siedzi na pryczy z nogami zwisającymi z boku i stopami na ziemi. Podnosi wzrok.%SPEECH_ON%Hej, kapitanie, chyba czuje się już dużo lepiej. Duuuzo lepiej. Gotowy, by... podbić świat.%SPEECH_OFF%Mężczyzna zrywa się na nogi i bije się w pierś, lecz jego głos nie podnosi się.%SPEECH_ON%Czy ruszamy w drogę?%SPEECH_OFF%Wychodzi z namiotu, a gdy tylko płachta opada, %anatomist% przestaje pisać i odkłada pióro. Kiwa głową.%SPEECH_ON%Procedura się powiodła. Nie jest już chory. Jest wyleczony i to z nadwyżką.%SPEECH_OFF%Z nadwyżką? To nie jest słownictwo, które chcesz teraz słyszeć. Musisz mieć na niego oko, by sprawdzić, co dokładnie się w nim zmieniło.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Koniec eksperymentow, anatomisto.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Ailing.getSkills().removeByID("trait.ailing");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_59.png",
					text = _event.m.Ailing.getName() + " nie jest juz Chorowity"
				});
				local new_traits = [
					"scripts/skills/traits/bloodthirsty_trait",
					"scripts/skills/traits/brute_trait",
					"scripts/skills/traits/cocky_trait",
					"scripts/skills/traits/deathwish_trait",
					"scripts/skills/traits/dumb_trait",
					"scripts/skills/traits/gluttonous_trait",
					"scripts/skills/traits/impatient_trait",
					"scripts/skills/traits/irrational_trait",
					"scripts/skills/traits/paranoid_trait",
					"scripts/skills/traits/spartan_trait",
					"scripts/skills/traits/superstitious_trait"
				];
				local num_new_traits = 2;

				while (num_new_traits > 0 && new_traits.len() > 0)
				{
					local trait = this.new(new_traits.remove(this.Math.rand(0, new_traits.len() - 1)));

					if (!_event.m.Ailing.getSkills().hasSkill(trait.getID()))
					{
						_event.m.Ailing.getSkills().add(trait);
						this.List.push({
							id = 10,
							icon = trait.getIcon(),
							text = _event.m.Ailing.getName() + " zyskuje " + trait.getName()
						});
						num_new_traits = num_new_traits - 1;
					}
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Ailing.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Mówisz %anatomist%, że nie. %ailing% jest dość silny, by wyzdrowieć sam. Anatomista wzdycha. Masz wrażenie, że nie był zainteresowany pomaganiem najemnikowi, tylko eksperymentowaniem na nim.%SPEECH_ON%Wielkie postępy rodzą się z wielkiego ryzyka, kapitanie.%SPEECH_OFF%Mówi, po czym odchodzi, a jego pióro skrobie imię w jednej z jego ksiąg.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zaraz wsadze ci piesc w...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(1.0, "Odmowiono mu okazji do badan");

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
		local ailingCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() != "background.anatomist" && bro.getSkills().hasSkill("trait.ailing"))
			{
				ailingCandidates.push(bro);
			}
		}

		if (ailingCandidates.len() == 0 || anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Ailing = ailingCandidates[this.Math.rand(0, ailingCandidates.len() - 1)];
		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Score = 5 * ailingCandidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
		_vars.push([
			"ailing",
			this.m.Ailing.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Ailing = null;
	}

});

