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
			Text = "[img]gfx/ui/events/event_05.png[/img]{%ailing%, chorowity najemnik, siedzi skulony i wpatruje sie w ognisko. Choruje od dluzszego czasu i nie wyglada na to, by bylo lepiej. Jednak %anatomist% anatomista twierdzi, ze moze sporzadzic dla niego rozwiazanie - rodzaj mikstury, ktora wzmocni jego cialo i uzdrowi go.%SPEECH_ON%Widziałem, jak to dzialalo wiele razy. Jest tylko jeden problem: potrzebne skladniki nie pochodza z tych okolic, ale czytalem o tym dosc, by z latwoscia znalezc odpowiednie zamienniki.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_05.png[/img]{Pozwalasz %anatomist% wykonywac jego prace, cokolwiek to znaczy. Anatomista i %ailing% znikaja na chwile w namiocie. Gdy kompanie trzeba ruszac w droge, %ailing% jest jak nowy. Ozywiony nowa energia, ma lekki, sprezysty krok. %anatomist% wychodzi, zapisujac cos w swoim notatniku.%SPEECH_ON%Wyniki byly calkiem dobre, bardzo dobre.%SPEECH_OFF%Z ciekawosci pytasz, co zrobil. Ten odrywa sie od skupienia i rzuca ci spojrzenie, po czym odwraca ksiege, bys nie mogl jej czytac. Dalej mruczy do siebie.%SPEECH_ON%Najlepsze wyniki? Nie, nie moge napisac najlepsze wyniki. Moga wystapic jeszcze skutki uboczne, ktore nadejda, jak to ujac, bokiem.%SPEECH_OFF%Coz. Oby %ailing% byl po prostu wyleczony i na tym koniec.}",
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
			Text = "[img]gfx/ui/events/event_05.png[/img]{Dajesz %anatomist% zielone swiatlo. On i %ailing% odchodza na chwile do namiotu. Mijaja godziny i kompanie wkrotce trzeba ruszac w droge. Podchodzisz i wchodzisz do namiotu. %ailing% lezy na pryczy z rekami skrzyzowanymi nad glowa, a nogi ma zgięte w kolanach. Jest spocony i wciaz kreci glowa z lewej na prawa. %anatomist% stoi obok i robi notatki.%SPEECH_ON%Wyglada na to, ze procedura nie zadzialala tak, jak zamierzano, jednak nawet niezamierzone skutki moga niesc wazne informacje.%SPEECH_OFF%Wsciekly pytasz, czy przezyje. Anatomista kiwa glowa.%SPEECH_ON%Moze przez jakis czas miewac urojenia, ale ostatecznie nadal bedzie oddychajacym zwierzeciem - przepraszam, oddychajacym czlowiekiem.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_05.png[/img]{Decydujesz sie pozwolic anatomiscie zrobic to, co uzna za konieczne, majac nadzieje, ze %ailing% szybko wyzdrowieje. Czas mija, kompanie trzeba zbierac w droge, a %anatomist% wciaz nie wychodzi z namiotu. Podchodzisz i zagladasz do srodka.\n\nZastajesz anatomiste siedzacego na stolku z boku. Jedna reka lezy na stole, a dlon szalenie skrobie wte i wewte w notatniku. Druga reka zwisa miedzy nogami, kciuk i palec wskazujacy co chwile zaciskaja sie w dziwnym, szczypiacym ruchu, jakby odliczal sekundy. Przenosisz wzrok na %ailing%, ktory siedzi na pryczy z nogami zwisajacymi z boku i stopami na ziemi. Podnosi wzrok.%SPEECH_ON%Hej, kapitanie, chyba czuje sie juz duzo lepiej. Duuuzo lepiej. Gotowy, by... podbic swiat.%SPEECH_OFF%Mezczyzna zrywa sie na nogi i bije sie w piers, lecz jego glos nie podnosi sie.%SPEECH_ON%Czy ruszamy w droge?%SPEECH_OFF%Wychodzi z namiotu, a gdy tylko plachta opada, %anatomist% przestaje pisac i odklada pioro. Kiwa glowa.%SPEECH_ON%Procedura sie powiodla. Nie jest juz chory. Jest wyleczony i to z nadwyzka.%SPEECH_OFF%Z nadwyzka? To nie jest slownictwo, ktore chcesz teraz slyszec. Musisz miec na niego oko, by sprawdzic, co dokladnie sie w nim zmienilo.}",
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
			Text = "[img]gfx/ui/events/event_05.png[/img]{Mowisz %anatomist%, ze nie. %ailing% jest dosc silny, by wyzdrowiec sam. Anatomista wzdycha. Masz wrazenie, ze nie byl zainteresowany pomaganiem najemnikowi, tylko eksperymentowaniem na nim.%SPEECH_ON%Wielkie postepy rodza sie z wielkiego ryzyka, kapitanie.%SPEECH_OFF%Mowi, po czym odchodzi, a jego pioro skrobie imie w jednej z jego ksieg.}",
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

