this.civilwar_savagery_event <- this.inherit("scripts/events/event", {
	m = {
		NobleHouse = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_savagery";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_79.png[/img]{Maszerując ścieżką, natrafiasz na porucznika %noblehouse%, prowadzącego bandę ludzi w rzezi. Zebrali mieszkańców małej osady i szykują się, by wyciąć ich w pień. Jeden z wieśniaków woła do ciebie, błagając o interwencję. Porucznik rzuca na ciebie okiem. Nie ma dość ludzi, by cię powstrzymać, ani ty jego, ale jest ich wystarczająco po obu stronach, by wszyscy przegrali.%SPEECH_ON%Nie zawracaj głowy, najemniku. Tu nie ma dla ciebie zysku. Po prostu idź dalej.%SPEECH_OFF% | Marsz %companyname% nagle przerywa widok bandy ludzi niosących sztandar %noblehouse%. Niestety, niesienie sztandaru to nie jedyna rzecz, którą robią - ustawili chłopów z pobliskiej osady i wyglądają na gotowych wymordować ich wszystkich. Porucznik oddziału mierzy cię wzrokiem.%SPEECH_ON%Nie róbmy bałaganu, najemniku. Sugeruję, byś szedł dalej.%SPEECH_OFF% | Docierasz do chaty. Kilku chorążych %noblehouse% stoi na straży przed drzwiami. W środku słychać krzyki kobiety i mężczyzny. Porucznik wychodzi i widzi cię. Poprawia się, nawet zaczesuje włosy do tyłu, i każe ci spadać.%SPEECH_ON%Nie zaczynaj, najemniku. Po prostu idź dalej.%SPEECH_OFF% | Trafiasz na coś w rodzaju świątyni, poświęconej temu czy innemu starymu bogu. Kilku chorążych %noblehouse% zabija deskami drzwi, a ich porucznik wymachuje pochodnią. W środku ludzie krzyczą o litość. Unosisz brew, a porucznik to dostrzega.%SPEECH_ON%Hej, najemniku. Tak, ty. Ruszaj. To nie twój pokaz.%SPEECH_OFF% | Schodząc ścieżką, natrafiasz na porucznika %noblehouse%. Ma kilka kobiet stojących na stołkach pod drzewem. Na szyjach mają pętle, a łzy spływają im po twarzach. Porucznik mierzy cię wzrokiem.%SPEECH_ON%Nie wpadaj na bohaterskie pomysły, najemniku. To nie twoja sprawa.%SPEECH_OFF% | Podczas marszu nagle słyszysz przenikliwe krzyki dzieci. Ich zawodzenie przyciąga cię bliżej i widzisz je po jednej stronie drogi, a po drugiej ich rodziców klęczących pod około tuzinem mieczy katów. Porucznik %noblehouse% stoi obok, dumnie trzymając sztandar swojego rodu. Wpatruje się w ciebie.%SPEECH_ON%Och, najemniku. Przyszedłeś popatrzeć? Mam nadzieję, bo lepiej, żebyś nie interweniował. To nie twoja walka.%SPEECH_OFF% | Chcąc się odlać, wspinasz się na pobliskie wzgórze dla odrobiny prywatności, ale głównie, by zebrać myśli. Niestety, do tego nie dojdzie. Po przeciwnej stronie zbocza stoi kilku ludzi %noblehouse%, wykonujących szczekane rozkazy porucznika, który przykuca niedaleko miejsca, gdzie miałeś sikać. Oddział spędza kobiety z kilku chatek wciśniętych w sąsiednie zbocze. Mężczyźni z osady już nie żyją, leżą martwi w trawie tu i ówdzie. Z tej odległości wyglądają jak plamiste kępy.\n\n Porucznik spogląda na ciebie.%SPEECH_ON%Witaj, najemniku, ładny dzień, co?%SPEECH_OFF%Musiał zobaczyć niepokój na twojej twarzy, bo jego mina szybko tężeje.%SPEECH_ON%Hej. Słuchaj. Nie wpadaj na bohaterskie pomysły, dobra? Po prostu idź dalej. Widziałem już ten wzrok i jeśli go nie schowasz, będą kłopoty dla nas wszystkich.%SPEECH_OFF% | Idąc ścieżką, słyszysz ujadanie psów. Najwyraźniej banda ludzi %noblehouse% oczyściła kilka chat i zostały tylko biedne kundle zamknięte w budzie. Kilku żołnierzy stoi na zewnątrz z pochodniami, gotowi spalić wszystkie psy żywcem. Porucznik stoi obok, z ohydnym uśmieszkiem, który szybko znika na twój widok.%SPEECH_ON%O, jesteś psiarzem czy co? Nie patrz tak. Lepiej idź dalej, najemniku, albo potraktuję cię jak jednego z tych psów.%SPEECH_OFF% | W czasie wojny drogi są często najgorszym miejscem - niosą grozę w tę i z powrotem, a dziś nie jest inaczej. Znajdujesz kilku żołnierzy %noblehouse% próżnujących przy ścieżce, wpatrujących się w kogoś związanego i zawieszonego nad ogniem, który jeszcze nie został rozpalony. Gdy podchodzisz, porucznik żołnierzy odwraca się, by ci się przyjrzeć.%SPEECH_ON%Hej, jeśli ci się to nie podoba, to idź dalej. To wojna, czego się spodziewałeś? A teraz znikaj, musimy rozpalić ogień.%SPEECH_OFF% | Idąc mozolnie ścieżką z dala od głównych dróg, by unikać rzezi, jaką niesie wojna domowa, trafiasz na kilku żołnierzy %noblehouse% torturujących człowieka. Rozpalili pochodnie częściowo owinięte skórą i pozwalają, by strzępy rozżarzonej skóry kapały na ich nieszczęsnego więźnia. Krzyczy o litość, ale oni na pewno jej nie mają. Widząc cię, woła o pomoc. Jeden z żołnierzy odwraca się do ciebie.%SPEECH_ON%Podoba ci się? Mój ojciec wymyślił tę formę tortury. Po prostu pozwalasz, by płonąca skóra kapała na nich. Dużo lepiej niż zwykłe żarzące się węgle.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Musimy położyć kres temu szaleństwu.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(4);

						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				},
				{
					Text = "To nie nasza sprawa, by tu interweniować.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_79.png[/img]{Krótkim rozkazem %companyname% rzuca się na ratunek. Ludzie %noblehouse% padają szybko i krwawo. Uratowani, płacząc i dozgonnie wdzięczni, niemal całują ci stopy. Każesz im uciekać, zanim pojawi się reszta armii szlachty. | Mówisz ludziom z %companyname%, by zrobili to szybko. Żołnierze %noblehouse% próbują się bronić, ale ostatnie minuty spędzili na przygotowaniach do zabijania niewinnych, nie na obronie przed twardszym przeciwnikiem. Padają bez większych trudności. Uratowani wieśniacy uciekają, krzyczą podziękowania, ale na nic więcej nie zostają. | %companyname% nie zamierza tolerować takich okrucieństw tego dnia. Rozkazujesz najemnikom zabić kilku nieprzygotowanych żołnierzy %noblehouse% i robią to szybko. Uratowani chłopi i pospólstwo dziękują. Ty tylko mówisz im, by zniknęli, bo ta ziemia wyraźnie nie jest już bezpieczna dla nikogo. | Wbrew lepszemu osądowi angażujesz się. Ludzie %companyname% ruszają do boju. Nieprzygotowani do prawdziwej walki żołnierze %noblehouse% zostają szybko, czasem z krzykiem, wycięci. Chłopi i pospólstwo dziękują za ratunek, po czym uciekają.}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Dobry uczynek został dziś spełniony.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Killed some of their men");
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
				this.List.insert(0, {
					id = 10,
					icon = "ui/icons/special.png",
					text = "Kompania zyskała renomę"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 75)
					{
						bro.improveMood(0.5, "Helped save some peasants");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_79.png[/img]{Rozkazujesz swoim ludziom ratować biednych chłopów, ale żołnierze %noblehouse% są na to gotowi. Nie z bronią w ręku - nie, nie mają na to dość ludzi - lecz z kilkoma końmi w pobliżu. Odjeżdżają, bez wątpienia po to, by zniszczyć twoją reputację w oczach szlachty, ale kogo to obchodzi. Pospólstwo, w przeciwieństwie, jest dozgonnie wdzięczne. | Każesz ludziom %companyname% szybko rozprawić się z żołnierzami. Kilku pada błyskawicznie, ale porucznikowi udaje się dosiąść konia i umknąć. To bardzo szybki koń. Wątpisz, byś mógł go dogonić, nawet gdybyś miał własnego konia, a nie masz. Uratowani chłopi są bardzo wdzięczni, choć to pewnie nie pomoże twojej reputacji u szlachty %noblehouse%. | Nie zauważyłeś kilku koni stojących w pobliżu. Choć kilku żołnierzy zostaje szybko wyciętych, twoi najemnicy nie mogą dogonić porucznika, który dosiada konia i odjeżdża w chmurze kurzu, a w twoim przypadku - zepsutej reputacji u szlachty. Nie to, żebyś miał dwie cholery do tego, co myślą. Pospólstwo natomiast niemal płacze w podziękowaniach. Mówisz im, by odeszli i to szybko. Kto wie, jakie niebezpieczeństwa lub złe intencje krążą po tych ziemiach.}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "No cóż.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationOffense, "Attacked some of their men");
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
				this.List.insert(0, {
					id = 10,
					icon = "ui/icons/special.png",
					text = "Kompania zyskała renomę"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 75)
					{
						bro.improveMood(0.5, "Helped save some peasants");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local nobleHouses = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local candidates = [];

		foreach( h in nobleHouses )
		{
			if (h.isAlliedWithPlayer())
			{
				candidates.push(h);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.NobleHouse = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noblehouse",
			this.m.NobleHouse.getName()
		]);
	}

	function onClear()
	{
		this.m.NobleHouse = null;
	}

});

