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
			Text = "[img]gfx/ui/events/event_05.png[/img]{Zastajesz %anatomist% anatomistę rozmawiającego z %asthmatic%, człowiekiem, który słynie z kiepskiego oddychania. Niemal na czas, mężczyzna przychodzi do ciebie z prośbą. Mówi, że anatomista zna sposób, by wyleczyć jego słabe płuca. %anatomist% kiwa głową.%SPEECH_ON%To tylko drobny zabieg, choć bolesny. Ten śmiały osobnik - przepraszam, to śmiałe zwierzę - na bogów, przepraszam, ten śmiały pacjent jest gotów podjąć wyzwanie. Za twoją zgodą mogę zacząć proces i skończyć go bardzo szybko.%SPEECH_OFF%Nie jesteś tego pewien, ale byłoby miło, gdyby %asthmatic% przestał świszczeć w nocy jak królik duszony na śmierć.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zrób to, ale bądź ostrożny.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "Zrób to i użyj wszelkich środków.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Nie, nie zaryzykuję jego życia.",
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
			Text = "[img]gfx/ui/events/event_05.png[/img]{Zgadzasz się na zabieg i obaj znikają na chwilę. Niedługo potem %asthmatic%, człowiek o płucach jak zdechły pies deptany pod butem, wraca do ciebie z szerokim uśmiechem. Staje prosto, wypina pierś i bierze długi, głęboki oddech, ciało nabrzmiewa mu jak u ropuchy, policzki puchną, a potem powoli, bardzo powoli wypuszcza powietrze. Nie ma świstu. Nie ma drapania w gardle. Twarz nie czerwienieje. Ramiona opadają, a jednak nie kręci mu się w głowie.%SPEECH_ON%Ten anatomista załatał mnie idealnie. To cud na dwóch nogach.%SPEECH_OFF%Mężczyzna odwraca się, ukazując serię otworów w ciele, które zasysają i marszczą się, gdy oddycha. %anatomist% podchodzi, czyszcząc jakieś dziwne metalowe narzędzie. Kręci głową.%SPEECH_ON%Przynajmniej jeden z nas jest zadowolony z tych rezultatów, które zaszły.%SPEECH_OFF%Nie wiesz, czemu anatomista jest zdenerwowany, ale zerkasz na jeden z jego tekstów, gdzie opisano operację usunięcia płuca przy pomocy skalpela i łyżki. Oby na pewno nie to zrobił %asthmatic%. Oby.}",
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
					text = _event.m.Asthmatic.getName() + " nie jest już Astmatykiem"
				});
				_event.m.Asthmatic.addHeavyInjury();
				this.List.push({
					id = 11,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Asthmatic.getName() + " odnosi poważne rany"
				});
				_event.m.Asthmatic.improveMood(1.0, "Nie jest już astmatykiem");

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
			Text = "[img]gfx/ui/events/event_05.png[/img]{Zgadzasz się na zabieg. %asthmatic% odwraca się, by powiedzieć anatomiscie, a ten natychmiast wbija metalowy kolec głęboko w pierś mężczyzny. Ten krzywi się i wrzeszczy, palce mu się zwijają, jakby chciał chwycić sam ból. Cofa się, a %anatomist% trzyma narzędzie jak sztylet. Gdy anatomista robi krok naprzód, by zadać kolejny cios, wyskakujesz i go powstrzymujesz. Patrzy na ciebie z dezorientacją.%SPEECH_ON%To część procesu, czyż nie rozumiesz? Teraz muszę kontynuować nakłuwanie. Zrobimy jeszcze osiem otworów.%SPEECH_OFF%%asthmatic% krzyczy, raczej mało godnie protestując przeciwko procedurze. Mówisz anatomiscie, że to koniec. Ten wzdycha, opuszczając narzędzie.%SPEECH_ON%Wszystko, co ważne, wymaga bólu, najemniku. Czy to ty zdobywasz głowy, by sprzedać je za korony, czy ja szukam lekarstwa. Gdyby ból nie był kluczowy, nie burzylibyśmy naturalnego porządku na swoje sposoby.%SPEECH_OFF%Każesz mu zamknąć usta i kończysz sprawę. Wzdycha i odchodzi, czyszcząc narzędzie szmatą. %asthmatic% sapie, dziękując ci za interwencję.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Po prostu odpocznij przez chwilę.",
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
				_event.m.Asthmatic.worsenMood(0.5, "Został zraniony przez szaleńca");

				if (_event.m.Asthmatic.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 11,
						icon = this.Const.MoodStateIcon[_event.m.Asthmatic.getMoodState()],
						text = _event.m.Asthmatic.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.worsenMood(1.0, "Odmówiono mu okazji do badań");

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
			Text = "[img]gfx/ui/events/event_05.png[/img]{Myślisz, czemu by nie pójść na całego i wybrać ścieżkę eksperymentalną? %asthmatic% się zgadza.%SPEECH_ON%Skoro ma boleć, to niech przynajmniej ma to sens.%SPEECH_OFF%Gdy obaj odchodzą do namiotu, część ciebie rozważa podglądanie. Inna część zdaje sobie sprawę, że pewnie nie masz na to żołądka, cokolwiek by tam było, i że sama twoja obecność mogłaby przeszkodzić pracy anatomisty. Tak czy inaczej, nie trwa to długo, zanim obaj wyjdą. %asthmatic% staje prosto, bierze długi, ciężki wdech, a potem wypuszcza wszystko jednym, gładkim wydechem.%SPEECH_ON%Nigdy nie czułem się lepiej.%SPEECH_OFF%Mówi, po czym podaje rękę %anatomist%. Wyleczony mężczyzna odchodzi. %anatomist% wyciera dłonie.%SPEECH_ON%Niestety, było kilka komplikacji. Zobaczmy, co my tu mamy...%SPEECH_OFF%Anatomista rozkłada zwój pospiesznie spisanych notatek, z których niektóre są pokryte krwią. Czytasz...}",
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
					text = _event.m.Asthmatic.getName() + " nie jest już Astmatykiem"
				});
				local trait = this.new("scripts/skills/traits/iron_lungs_trait");
				_event.m.Asthmatic.getSkills().add(trait);
				this.List.push({
					id = 11,
					icon = trait.getIcon(),
					text = _event.m.Asthmatic.getName() + " zyskuje Żelazne Płuca"
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
			Text = "[img]gfx/ui/events/event_05.png[/img]{Mówisz %anatomist%, że nie. Anatomista zaciska usta i prawi jakieś madralińskie wywody o wartości medycyny i nauki, a ty przypominasz mu o wartości najemnika, któremu jakiś głupiec nie majstruje przy płucach.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Taa, taa, idź sobie popłakać w podręczniki.",
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

