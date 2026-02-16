this.something_in_barn_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		BeastSlayer = null,
		Farmer = null
	},
	function create()
	{
		this.m.ID = "event.something_in_barn";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Mężczyzna przychodzi do kompanii, mówiąc, że w jego stodole uwięziony jest zły szczeniak wilko-wilka. %anatomist% anatomista to słyszy i podchodzi. Pyta, czy wie na pewno, że szczeniak jest zły. Nieznajomy kiwa głową.%SPEECH_ON%Część wilko-wilka, wyobrażam sobie, że jego rodowód jest przesiąknięty złem. Cholerstwo siedzi w stodole, a wejście jest tylko jedno, więc cała sprawa jest cholernie kłopotliwa.%SPEECH_OFF%Prosi, byście poszli i zabili szczeniaka, zanim ucieknie. %anatomist% jest bardzo ciekaw tego zadania, bo o wilko-wilkach w młodym wieku niewiele wiadomo. Zgłasza się na ochotnika, by pójść z wami i zająć się tym małym stworzeniem.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Chodźmy to zobaczyć.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 55 ? "B" : "C";
					}

				},
				{
					Text = "To nie nasza sprawa.",
					function getResult( _event )
					{
						return "F";
					}

				}
			],
			function start( _event )
			{
				if (this.Const.DLC.Unhold && _event.m.BeastSlayer != null)
				{
					this.Options.push({
						Text = "%beastslayer% pogromca bestii powinien się tym zająć.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Farmer != null)
				{
					this.Options.push({
						Text = "Nasz gospodarz %farmer% chyba ma pomysł.",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_27.png[/img]{Spełnisz prośbę nieznajomego i idziecie do stodoły. Jest zupełnie niepozorna, a on wyjaśnia, że wejście jest tylko jedno. Opiera się o drzwi i słucha, po czym kiwa głową.%SPEECH_ON%O tak, nadal tam jest.%SPEECH_OFF%Drzwi się otwierają i ty oraz %anatomist% wchodzicie do środka, mijając sterty gówien i boksy z wystraszonymi zwierzętami wciśniętymi w kąty, unoszącymi głowy, gdy przechodzicie. Na drugim końcu stodoły widzisz niechlujne stworzenie grzebiące w stercie siana. %anatomist% wpada w panikę, chwyta widły i rusza do ataku. Powstrzymujesz go, chwytając drzewce i unosząc je w górę. Krzyczysz na niego i wskazujesz w dół. Bestia wcale nie jest wilko-wilkiem, tylko zwykłym psem, a kundel patrzy na was z zapłakanymi oczami. Mężczyzna stoi za tobą, pocierając kark.%SPEECH_ON%Oof, no tak, to moja wina. Byłem pewien, że to wilcza potworność.%SPEECH_OFF%Przy odrobinie jedzenia i tresury nie ma wątpliwości, że ten kundel może stać się czymś przydatnym dla %companyname%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tylko trzymajcie to z dala od %anatomist%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/accessory/wardog_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_06.png[/img]{Idziesz do niepozornej stodoły z łańcuchami na drzwiach. Mężczyzna opiera się o framugę, przez chwilę słucha, potem kiwa głową i zdejmuje łańcuchy. Gdy otwiera drzwi, cofa się za ciebie i patrzy z bezpiecznego miejsca.%SPEECH_ON%Jest tam, w sianie.%SPEECH_OFF%Widzisz zarys bestii i, dobywając miecza, skradasz się do przodu. %anatomist% jednak podskakuje na sam widok, tracąc opanowanie z niezgrabnym jękiem i kobiecym krzykiem. Chwyta widły i wbija je w siano. Bestia piszczy, gdy anatomista wbija zęby wideł raz za razem, aż stworzenie ginie. Kucasz i odsuwasz zakrwawioną słomę. To wcale nie wilko-wilk, nawet nie młody szczeniak. To po prostu zwykły pies, a teraz zwyczajnie martwy.\n\nWtedy słyszysz głos za sobą. To nie mężczyzna, który cię przyprowadził, ale ktoś inny. Krzyczy, że zabiliście mu psa. %anatomist% rzuca widły. Wyjaśnia, że to była pomyłka. Skoro anatomista postanowił sam rozstrzygnąć sprawę, pospiesznie zostawiasz mu sytuację, słysząc tylko ciche krzyki właściciela psa i %anatomist% próbującego tłumaczyć, że to był wypadek. Masz ochotę znaleźć drania, który ci to zgotował, ale masz wrażenie, że zniknął bez śladu. Możesz tylko iść policzyć zapasy, ignorując zawodzenia właściciela martwego psa i żałosne zaprzeczenia %anatomist%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oof.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(0.75, "Przypadkowo zabił czyjegoś psa");

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
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_131.png[/img]{Jeśli to rzeczywiście bestia, najlepiej, by poszedł z wami %beastslayer% - prawdziwy pogromca bestii. Cała trójka idziecie do stodoły. Po chwili ciszy liczysz do trzech i ty oraz pogromca bestii wyważacie drzwi. Anatomista spóźnia się i nawet nie zrozumiał planu, kopie na końcu, za późno, a jego but wymiata powietrze, noga ląduje i rozjeżdża się okropnie po klepisku. Próbując odzyskać godność i wstać, wygląda na to, że naciągnął mięsień w pachwinie. Ty i %beastslayer% wybuchacie śmiechem. Gdy pomagasz anatomiscie wstać, pogromca bestii przestaje się zastanawiać i nagle jest szarpnięcie ruchu, uderzenie powietrza i głuchy trzask w jeden z boksów. Patrzysz i widzisz, jak pogromca przygniata blade, upiorne stworzenie, a jego broń przebija mu czaszkę, gdy ramieniem trzyma je za szyję.%SPEECH_ON%To szczeniak, zgadza się, ale na pewno nie jest to wilko-wilk.%SPEECH_OFF%Mówi i upuszcza małego nachzehrera na ziemię. Spogląda.%SPEECH_ON%Trochę przypomina anatomistę.%SPEECH_OFF%%anatomist% przyjmuje to na klatę, niezręcznie wstając i drepcząc w kolanawym chodzie. Zauważa, że bestia nadal może być przydatna naukowo. Mimo że nie jest tak szorstki jak inni, nie możesz nie docenić jego podziwu dla nauki.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra robota.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/misc/ghoul_teeth_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				_event.m.BeastSlayer.improveMood(1.0, "Wykorzystał swoje umiejętności zabijania potworów");

				if (_event.m.BeastSlayer.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.BeastSlayer.getMoodState()],
						text = _event.m.BeastSlayer.getName() + this.Const.MoodStateEvent[_event.m.BeastSlayer.getMoodState()]
					});
				}

				_event.m.Anatomist.worsenMood(0.5, "Skonfundowany próbując zabić potwora");
				_event.m.Anatomist.addXP(200, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Doświadczenia"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.BeastSlayer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_131.png[/img]{%farmer% gospodarz podchodzi. Mówi do mężczyzny.%SPEECH_ON%To nie była twoja stodoła od początku, prawda?%SPEECH_OFF%Mężczyzna kręci głową. %farmer% kiwa głową.%SPEECH_ON%Tak myślałem, bo takie stodoły nie mają tylko jednego wejścia. Jest wyjście ziemne, trzeba tylko wiedzieć, gdzie szukać. Daj mi chwilę, spłoszę bestię od tyłu, a wy bądźcie gotowi z przodu.%SPEECH_OFF%Zgodnie z planem czekacie z przodu. Niedługo potem słyszysz skowyt bestii w środku i coś pędzi w stronę drzwi. Gdy tylko wychodzi, wbijasz miecz w jej czaszkę, a gdy przewraca się na ziemię, widzisz, że to mały nachzehrer. %anatomist% klaszcze w dłonie, bo ma coś wartego zbadania. %farmer% wraca z boku stodoły, niosąc długą dwuręczną broń.%SPEECH_ON%Wygląda na to, że ktoś o tym zapomniał, gdy ryli wyjście z tyłu stodoły. Myślę, że weźmiemy to jako zapłatę, zgoda?%SPEECH_OFF%Kiwasz głową, a mężczyzna, który prosił o pomoc, nie protestuje.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra robota.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local twoHanders = [
					"weapons/woodcutters_axe",
					"weapons/hooked_blade",
					"weapons/warbrand"
				];

				if (this.Const.DLC.Unhold)
				{
					twoHanders.extend([
						"weapons/two_handed_wooden_hammer",
						"weapons/two_handed_wooden_flail",
						"weapons/spetum",
						"weapons/goedendag"
					]);
				}

				local item = this.new("scripts/items/" + twoHanders[this.Math.rand(0, twoHanders.len() - 1)]);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				_event.m.Anatomist.improveMood(1.0, "Mógł zbadać interesujący okaz");
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Farmer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Mimo życzeń %anatomist% mówisz chłopowi, że jeśli to naprawdę wilko-wilk w stodole, to powinien sam się tym zająć. Takie kłopoty nie są twoją sprawą, a jeśli mają być, to ktoś powinien ci za to cholernie dobrze zapłacić. Kto wie, może ten szczeniak wilko-wilka da sporo okazji do kontraktów, gdy już urośnie i przestraszy chłopów prosto w ramiona %companyname%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Prowadzimy tu interes.",
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

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary() || t.getSize() >= 2)
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];
		local beastSlayerCandidates = [];
		local farmerCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.beast_slayer")
			{
				beastSlayerCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.farmhand")
			{
				farmerCandidates.push(bro);
			}
		}

		if (beastSlayerCandidates.len() > 0)
		{
			this.m.BeastSlayer = beastSlayerCandidates[this.Math.rand(0, beastSlayerCandidates.len() - 1)];
		}

		if (farmerCandidates.len() > 0)
		{
			this.m.Farmer = farmerCandidates[this.Math.rand(0, farmerCandidates.len() - 1)];
		}

		if (anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Score = 10;
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
			"beastslayer",
			this.m.BeastSlayer != null ? this.m.BeastSlayer.getNameOnly() : ""
		]);
		_vars.push([
			"farmer",
			this.m.Farmer != null ? this.m.Farmer.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.BeastSlayer = null;
		this.m.Farmer = null;
	}

});

