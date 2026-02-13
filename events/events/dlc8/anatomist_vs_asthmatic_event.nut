this.anatomist_vs_asthmatic_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Asthmatic = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_vs_asthmatic";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Zastajesz %anatomist% anatomiste rozmawiajacego z %asthmatic%, czlowiekiem, ktory slynie z kiepskiego oddychania. Niemal na czas, mezczyzna przychodzi do ciebie z prosba. Mowi, ze anatomista zna sposob, by wyleczyc jego slabe pluca. %anatomist% kiwa glowa.%SPEECH_ON%To tylko drobny zabieg, choc bolesny. Ten smialy osobnik - przepraszam, to smiale zwierze - na bogow, przepraszam, ten smialy pacjent jest gotow podjac wyzwanie. Za twoja zgoda moge zaczac proces i skonczyc go bardzo szybko.%SPEECH_OFF%Nie jestes tego pewien, ale byloby milo, gdyby %asthmatic% przestal swiszczec w nocy jak krolik duszony na smierc.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zrob to, ale badz ostrozny.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "Zrob to i uzyj wszelkich srodkow.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Nie, nie zaryzykuje jego zycia.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Asthmatic.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Zgadzasz sie na zabieg i obaj znikaja na chwile. Niedlugo potem %asthmatic%, czlowiek o plucach jak zdechly pies deptany pod butem, wraca do ciebie z szerokim usmiechem. Staje prosto, wypina piers i bierze dlugi, gleboki oddech, cialo nabrzmiewa mu jak u ropuchy, policzki puchna, a potem powoli, bardzo powoli wypuszcza powietrze. Nie ma swistu. Nie ma drapania w gardle. Twarz nie czerwienieje. Ramiona opadaja, a jednak nie kreci mu sie w glowie.%SPEECH_ON%Ten anatomista zalatal mnie idealnie. To cud na dwoch nogach.%SPEECH_OFF%Mezczyzna odwraca sie, ukazujac serie otworow w ciele, ktore zasysaja i marszcza sie, gdy oddycha. %anatomist% podchodzi, czyszczac jakies dziwne metalowe narzedzie. Kreci glowa.%SPEECH_ON%Przynajmniej jeden z nas jest zadowolony z tych rezultatow, ktore zaszly.%SPEECH_OFF%Nie wiesz, czemu anatomista jest zdenerwowany, ale zerkasz na jeden z jego tekstow, gdzie opisano operacje usuniecia pluca przy pomocy skalpela i lyzki. Oby na pewno nie to zrobil %asthmatic%. Oby.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oby...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Asthmatic.getSkills().removeByID("trait.asthmatic");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_22.png",
					text = _event.m.Asthmatic.getName() + " nie jest juz Astmatykiem"
				});
				_event.m.Asthmatic.addHeavyInjury();
				this.List.push({
					id = 11,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Asthmatic.getName() + " odnosi powazne rany"
				});
				_event.m.Asthmatic.improveMood(1.0, "Nie jest juz astmatykiem");

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 11,
						icon = this.Const.MoodStateIcon[_event.m.Asthmatic.getMoodState()],
						text = _event.m.Asthmatic.getName() + this.Const.MoodStateEvent[_event.m.Asthmatic.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Asthmatic.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Zgadzasz sie na zabieg. %asthmatic% odwraca sie, by powiedziec anatomiscie, a ten natychmiast wbija metalowy kolec gleboko w piers mezczyzny. Ten krzywi sie i wrzeszczy, palce mu sie zwijaja, jakby chcial chwycic sam bol. Cofa sie, a %anatomist% trzyma narzedzie jak sztylet. Gdy anatomista robi krok naprzod, by zadac kolejny cios, wyskakujesz i go powstrzymujesz. Patrzy na ciebie z dezorientacja.%SPEECH_ON%To czesc procesu, czyz nie rozumiesz? Teraz musze kontynuowac nakluwanie. Zrobimy jeszcze osiem otworow.%SPEECH_OFF%%asthmatic% krzyczy, raczej malo godnie protestujac przeciwko procedurze. Mowisz anatomiscie, ze to koniec. Ten wzdycha, opuszczajac narzedzie.%SPEECH_ON%Wszystko, co wazne, wymaga bolu, najemniku. Czy to ty zdobywasz glowy, by sprzedac je za korony, czy ja szukam lekarstwa. Gdyby bol nie byl kluczowy, nie burzylibysmy naturalnego porzadku na swoje sposoby.%SPEECH_OFF%Kazes mu zamknac usta i konczysz sprawe. Wzdycha i odchodzi, czyszczac narzedzie szmata. %asthmatic% sapie, dziekujac ci za interwencje.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Po prostu odpocznij przez chwile.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local injury = _event.m.Asthmatic.addInjury([
					{
						ID = "injury.pierced_lung",
						Threshold = 0.0,
						Script = "injury/pierced_lung_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Asthmatic.getName() + " odnosi " + injury.getNameOnly()
				});
				_event.m.Asthmatic.worsenMood(0.5, "Zostal zraniony przez szalenca");

				if (_event.m.Asthmatic.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 11,
						icon = this.Const.MoodStateIcon[_event.m.Asthmatic.getMoodState()],
						text = _event.m.Asthmatic.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.worsenMood(1.0, "Odmowiono mu okazji do badan");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 11,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Asthmatic.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Myslisz, czemu by nie pojsc na calego i wybrac sciezke eksperymentalna? %asthmatic% sie zgadza.%SPEECH_ON%Skoro ma bolec, to niech przynajmniej ma to sens.%SPEECH_OFF%Gdy obaj odchodza do namiotu, czesc ciebie rozważa podgladanie. Inna czesc zdaje sobie sprawe, ze pewnie nie masz na to zoladka, cokolwiek by tam bylo, i ze sama twoja obecnosc moglaby przeszkodzic pracy anatomisty. Tak czy inaczej, nie trwa to dlugo, zanim obaj wyjda. %asthmatic% staje prosto, bierze dlugi, ciezki wdech, a potem wypuszcza wszystko jednym, gladkim wydechem.%SPEECH_ON%Nigdy nie czulem sie lepiej.%SPEECH_OFF%Mowi, po czym podaje reke %anatomist%. Wyleczony mezczyzna odchodzi. %anatomist% wyciera dlonie.%SPEECH_ON%Niestety, bylo kilka komplikacji. Zobaczmy, co my tu mamy...%SPEECH_OFF%Anatomista rozklada zwoj pospiesznie spisanych notatek, z ktorych niektore sa pokryte krwia. Czytasz...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Och. O nie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Asthmatic.getSkills().removeByID("trait.asthmatic");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_22.png",
					text = _event.m.Asthmatic.getName() + " nie jest juz Astmatykiem"
				});
				local trait = this.new("scripts/skills/traits/iron_lungs_trait");
				_event.m.Asthmatic.getSkills().add(trait);
				this.List.push({
					id = 11,
					icon = trait.getIcon(),
					text = _event.m.Asthmatic.getName() + " zyskuje Zelazne Pluca"
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

					if (!_event.m.Asthmatic.getSkills().hasSkill(trait.getID()))
					{
						_event.m.Asthmatic.getSkills().add(trait);
						this.List.push({
							id = 12,
							icon = trait.getIcon(),
							text = _event.m.Asthmatic.getName() + " zyskuje " + trait.getName()
						});
						num_new_traits = num_new_traits - 1;
					}
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Asthmatic.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Mowisz %anatomist%, ze nie. Anatomista zaciska usta i prawi jakies madralinskie wywody o wartosci medycyny i nauki, a ty przypominasz mu o wartosci najemnika, ktoremu jakis glupiec nie majstruje przy plucach.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Taa, taa, idz sobie poplakac w podreczniki.",
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
		local asthmaticCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() != "background.anatomist" && bro.getSkills().hasSkill("trait.asthmatic"))
			{
				asthmaticCandidates.push(bro);
			}
		}

		if (asthmaticCandidates.len() == 0 || anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Asthmatic = asthmaticCandidates[this.Math.rand(0, asthmaticCandidates.len() - 1)];
		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Score = 5 * asthmaticCandidates.len();
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
			"asthmatic",
			this.m.Asthmatic.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Asthmatic = null;
	}

});

