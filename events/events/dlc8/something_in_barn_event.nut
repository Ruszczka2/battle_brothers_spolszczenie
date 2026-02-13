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
			Text = "[img]gfx/ui/events/event_115.png[/img]{Mezczyzna przychodzi do kompanii, mowiac, ze w jego stodole uwieziony jest zly szczeniak wilko-wilka. %anatomist% anatomista to slyszy i podchodzi. Pyta, czy wie na pewno, ze szczeniak jest zly. Nieznajomy kiwa glowa.%SPEECH_ON%Czesc wilko-wilka, wyobrazam sobie, ze jego rodowod jest przesiakniety zlem. Cholerstwo siedzi w stodole, a wejscie jest tylko jedno, wiec cala sprawa jest cholernie klopotliwa.%SPEECH_OFF%Prosi, byscie poszli i zabili szczeniaka, zanim ucieknie. %anatomist% jest bardzo ciekaw tego zadania, bo o wilko-wilkach w mlodym wieku niewiele wiadomo. Zglasza sie na ochotnika, by pojsc z wami i zajac sie tym malym stworzeniem.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Chodzmy to zobaczyc.",
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
						Text = "%beastslayer% pogromca bestii powinien sie tym zajac.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Farmer != null)
				{
					this.Options.push({
						Text = "Nasz gospodarz %farmer% chyba ma pomysl.",
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
			Text = "[img]gfx/ui/events/event_27.png[/img]{Spelnisz prosbe nieznajomego i idziecie do stodoly. Jest zupelnie niepozorna, a on wyjasnia, ze wejscie jest tylko jedno. Opiera sie o drzwi i slucha, po czym kiwa glowa.%SPEECH_ON%O tak, nadal tam jest.%SPEECH_OFF%Drzwi sie otwieraja i ty oraz %anatomist% wchodzicie do srodka, mijajac sterty gowien i boksy z wystraszonymi zwierzetami wcisnietymi w katy, unoszacymi glowy, gdy przechodzicie. Na drugim koncu stodoly widzisz niechlujne stworzenie grzebiace w stercie siana. %anatomist% wpada w panike, chwyta widly i rusza do ataku. Powstrzymujesz go, chwytajac drzewce i unoszac je w gore. Krzyczysz na niego i wskazujesz w dol. Bestia wcale nie jest wilko-wilkiem, tylko zwyklym psem, a kundel patrzy na was z zaplakanymi oczami. Mezczyzna stoi za toba, pocierajac kark.%SPEECH_ON%Oof, no tak, to moja wina. Bylem pewien, ze to wilcza potwornosc.%SPEECH_OFF%Przy odrobinie jedzenia i tresury nie ma watpliwosci, ze ten kundel moze stac sie czyms przydatnym dla %companyname%.}",
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
			Text = "[img]gfx/ui/events/event_06.png[/img]{Idziesz do niepozornej stodoły z lancuchami na drzwiach. Mezczyzna opiera sie o framuge, przez chwile slucha, potem kiwa glowa i zdejmuje lancuchy. Gdy otwiera drzwi, cofa sie za ciebie i patrzy z bezpiecznego miejsca.%SPEECH_ON%Jest tam, w sianie.%SPEECH_OFF%Widzisz zarys bestii i, dobywajac miecza, skradasz sie do przodu. %anatomist% jednak podskakuje na sam widok, tracac opanowanie z niezgrabnym jekiem i kobiecym krzykiem. Chwyta widly i wbija je w siano. Bestia piszczy, gdy anatomista wbija zeby widel raz za razem, az stworzenie ginie. Kucasz i odsuwasz zakrwawiona slome. To wcale nie wilko-wilk, nawet nie mlody szczeniak. To po prostu zwykly pies, a teraz zwyczajnie martwy.\n\nWtedy slyszysz glos za soba. To nie mezczyzna, ktory cie przyprowadzil, ale ktos inny. Krzyczy, ze zabiliscie mu psa. %anatomist% rzuca widly. Wyjasnia, ze to byla pomylka. Skoro anatomista postanowil sam rozstrzygnac sprawe, pospiesznie zostawiasz mu sytuacje, slyszac tylko ciche krzyki wlasciciela psa i %anatomist% probujacego tlumaczyc, ze to byl wypadek. Masz ochote znalezc drania, ktory ci to zgotowal, ale masz wrazenie, ze zniknal bez sladu. Mozesz tylko isc policzyc zapasy, ignorujac zawodzenia wlasciciela martwego psa i zalosne zaprzeczenia %anatomist%.}",
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
				_event.m.Anatomist.worsenMood(0.75, "Przypadkowo zabil czyjegos psa");

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
			Text = "[img]gfx/ui/events/event_131.png[/img]{Jesli to rzeczywiscie bestia, najlepiej, by poszedl z wami %beastslayer% - prawdziwy pogromca bestii. Cala trojka idziecie do stodoly. Po chwili ciszy liczysz do trzech i ty oraz pogromca bestii wywazacie drzwi. Anatomista spoznia sie i nawet nie zrozumial planu, kopie na koncu, za pozno, a jego but wymiata powietrze, noga laduje i rozjezdza sie okropnie po klepisku. Probujac odzyskac godnosc i wstac, wyglada na to, ze naciagnal miesien w pachwinie. Ty i %beastslayer% wybuchacie smiechem. Gdy pomagasz anatomiscie wstac, pogromca bestii przestaje sie zastanawiac i nagle jest szarpniecie ruchu, uderzenie powietrza i gluchy trzask w jeden z boksow. Patrzysz i widzisz, jak pogromca przygniata blade, upiorne stworzenie, a jego bron przebija mu czaszke, gdy ramieniem trzyma je za szyje.%SPEECH_ON%To szczeniak, zgadza sie, ale na pewno nie jest to wilko-wilk.%SPEECH_OFF%Mowi i upuszcza malego nachzehrera na ziemie. Spoglada.%SPEECH_ON%Troche przypomina anatomiste.%SPEECH_OFF%%anatomist% przyjmuje to na klate, niezrecznie wstajac i dreptajac w kolanawym chodzie. Zauwaza, ze bestia nadal moze byc przydatna naukowo. Mimo ze nie jest tak szorstki jak inni, nie mozesz nie docenic jego podziwu dla nauki.}",
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
				_event.m.BeastSlayer.improveMood(1.0, "Wykorzystal swoje umiejetnosci zabijania potworow");

				if (_event.m.BeastSlayer.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.BeastSlayer.getMoodState()],
						text = _event.m.BeastSlayer.getName() + this.Const.MoodStateEvent[_event.m.BeastSlayer.getMoodState()]
					});
				}

				_event.m.Anatomist.worsenMood(0.5, "Skonfundowany probujac zabic potwora");
				_event.m.Anatomist.addXP(200, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Doswiadczenia"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.BeastSlayer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_131.png[/img]{%farmer% gospodarz podchodzi. Mowi do mezczyzny.%SPEECH_ON%To nie byla twoja stodola od poczatku, prawda?%SPEECH_OFF%Mezczyzna kreci glowa. %farmer% kiwa glowa.%SPEECH_ON%Tak myslalem, bo takie stodoly nie maja tylko jednego wejscia. Jest wyjscie ziemne, trzeba tylko wiedziec, gdzie szukac. Daj mi chwile, splosze bestie od tylu, a wy badzcie gotowi z przodu.%SPEECH_OFF%Zgodnie z planem czekacie z przodu. Niedlugo potem slyszysz skowyt bestii w srodku i cos pedzi w strone drzwi. Gdy tylko wychodzi, wbijasz miecz w jej czaszke, a gdy przewraca sie na ziemie, widzisz, ze to maly nachzehrer. %anatomist% klaszcze w dlonie, bo ma cos wartego zbadania. %farmer% wraca z boku stodoly, niosac dluga dwureczna bron.%SPEECH_ON%Wyglada na to, ze ktos o tym zapomnial, gdy ryli wyjscie z tylu stodoly. Mysle, ze wezniemy to jako zaplate, zgoda?%SPEECH_OFF%Kiwasz glowa, a mezczyzna, ktory prosil o pomoc, nie protestuje.}",
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
				_event.m.Anatomist.improveMood(1.0, "Mogl zbadac interesujacy okaz");
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Farmer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Mimo zyczen %anatomist% mowisz chlopowi, ze jesli to naprawde wilko-wilk w stodole, to powinien sam sie tym zajac. Takie klopoty nie sa twoja sprawa, a jesli maja byc, to ktos powinien ci za to cholernie dobrze zaplacic. Kto wie, moze ten szczeniak wilko-wilka da sporo okazji do kontraktow, gdy juz urosnie i przestraszy chlopow prosto w ramiona %companyname%.}",
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

