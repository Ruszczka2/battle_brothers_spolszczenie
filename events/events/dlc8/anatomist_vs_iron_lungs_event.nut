this.anatomist_vs_iron_lungs_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		IronLungs = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_vs_ironlungs";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{W swiecie najemnikow duza wytrzymalosc jest bardzo wazna, ale widac, ze niektorzy mezczyzni znacznie lepiej walcza ze zmeczeniem niz inni. %ironlungs% to jeden z nich, wojownik znany z tego, ze potrafi utrzymac rowny oddech daleko w trakcie wyczerpujacej bitwy. Dla ciebie to tylko ciekawostka, jak dziwna szyja, ogromne dlonie czy wielki mlot miedzy nogami. Ale dla %anatomist% to cos zupelnie innego. Chce wiedziec, jak to mozliwe, ze jeden czlowiek ma tak mocne i wydajne pluca, skoro jego codzienne zycie niewiele rozni sie od zycia innych.%SPEECH_ON%Wszyscy jestesmy tu wojownikami, wiec jak to sie stalo, ze ten czlowiek oddycha tak rowno w porownaniu do reszty? Musi miec w sobie jakis element, ktorego my nie mamy, i sadze, ze moge go znalezc.%SPEECH_OFF%Czekaj, \'wszyscy\' jestesmy tu wojownikami? Nie posunalbys sie az tak daleko, ale nie poprawiasz anatomisty. Pytasz go, jak dokladnie zamierza to zbadac.%SPEECH_ON%Prosta sekcja zwlok nie bylaby niczym nadzwyczajnym, ale sadze, ze %ironlungs% odmowilby. Zostaje mi wiec jedna opcja: badac go uwaznie i sprawdzic, czy moge odtworzyc jego zalety u siebie poprzez manipulacje kosci i ostrozne naciecia.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Hej, to twoje cialo.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "Nie ma mowy.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.IronLungs.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Mowisz anatomiscie, by robil, co chce. Wyciaga pioro i kilka ksiazek, a potem torbe pelna metalowych szczypiec, nozyc i skalpeli. Sprawdza ich czystosc, po czym podnosi je i podchodzi do %ironlungs%. Najemnik odpowiada niezrecznym spojrzeniem. W koncu anatomista namawia mezczyzne, by wszedl z nim do namiotu. Pilnujesz okolicy na wypadek, gdyby anatomista postradal zmysly i wpadl w szalony naukowy amok. W koncu %anatomist% wraca z fiolka, ktora przez chwile obraca, po czym wypija. Kiwal glowa.%SPEECH_ON%Mam nadzieje, ze to zadziala. Mocno obciazylem swoje cialo, by naprawde przecwiczyc pluca, a potem dodalem skladniki pochodzace od samego %ironlungs%. Nastepnie, rzecz jasna, dodatkowe elementy, o ktorych nie bede nikomu opowiadal, bo jesli to zadziala, moge stac sie ekspertem w tej dziedzinie, prawdziwym bohaterem nauki i zdecydowanie przescignac innych anatomistow.%SPEECH_OFF%Dobrze. %ironlungs% wychodzi teraz z namiotu. Pytasz go, co sie stalo. Mezczyzna wzrusza ramionami.%SPEECH_ON%Powiedzialem mu, ze duzo sie rozciagam i mam dobra postawe oraz ze czasem cwicze oddech. Odrzucil te odpowiedzi, przekonujac siebie, ze musi byc jakis inny sposob. Potem oszalal z tymi narzedziami i zaczal, hmm, \'pracowac\' na sobie. Cokolwiek zrobil, wygladalo na potwornie bolesne, ale zniósl to dobrze.%SPEECH_OFF%Czekaj, cwiczysz oddech?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Teraz oddycham swiadomie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local trait = this.new("scripts/skills/traits/iron_lungs_trait");
				_event.m.Anatomist.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Anatomist.getName() + " zyskuje Zelazne Pluca"
				});
				local injury = _event.m.Anatomist.addInjury([
					{
						ID = "injury.pierced_lung",
						Threshold = 0.0,
						Script = "injury/pierced_lung_injury"
					}
				]);
				this.List.push({
					id = 11,
					icon = injury.getIcon(),
					text = _event.m.Anatomist.getName() + " odnosi " + injury.getNameOnly()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.IronLungs.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%anatomist% dostaje zielone swiatlo i pospiesznie wraca do namiotu z torba narzedzi i %ironlungs% u boku. Wchodzisz do namiotu i widzisz %anatomist% siedzacego prosto z nieskazitelna postawa, po czym zgina sie jak starzec z kregoslupem zlamanym przez wiek, a potem znowu prostuje.\n\nNagle bierze jedno z narzedzi i przebija sie nim. %ironlungs% cofa sie, zaskoczony takim autodestrukcyjnym czynem. Wyciaga dlon, by pomoc anatomiscie, ale ten go odgania. Zaciskajac zeby, %anatomist% zaczyna robic notatki, gdy krew tryska z jego ust na kartki. Potem powtarza to jeszcze raz, tym razem z innego kata.\n\nNawet z daleka widzisz, jak krew wyplywa grubymi strugami ciemnej czerwieni, a co chwila pryska jasnym szkarłatem. Zaciska zeby i zadaje kolejne uderzenie. Tym razem z rany tryska wielka fala krwi. Widziales juz dosc, ale zanim zdazysz interweniowac, oczy anatomisty wywracaja sie do tylu i ten traci przytomnosc. %ironlungs% wyglada na wstrzasnietego.%SPEECH_ON%Co do cholery? Ty mu na to pozwoliles, kapitanie? Czego on chcial sie nauczyc?%SPEECH_OFF%Nie placa ci wystarczajaco, by znosic tych durniow. Patrzac na notatki anatomisty, przez zakrwawiona strone widzisz, ze po prostu napisal \'nie dziala\' w kolko.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Gdy samo oddychanie czyni z ciebie nudziarza.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local injury = _event.m.Anatomist.addInjury([
					{
						ID = "injury.pierced_lung",
						Threshold = 0.0,
						Script = "injury/pierced_lung_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Anatomist.getName() + " odnosi " + injury.getNameOnly()
				});
				_event.m.Anatomist.worsenMood(0.5, "Jego eksperymentalna operacja nie zadzialala");
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.IronLungs.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Mowisz anatomiscie, by pilnowal swojego nosa. Gdy zaczyna sie burzyc, co zaczyna byc niebezpiecznie bliskie twojej sprawie, tlumaczysz mu, ze %ironlungs% jest swoim wlasnym czlowiekiem i nalezy tylko do siebie, a z jego istnienia nie ma nic poza odrobina podziwu. I tyle. %anatomist% otwiera usta, by odpowiedziec, po czym je zamyka. Zamiast tego to, co myslal, zapisuje w notatkach. Masz nadzieje, ze wszelki dramat wyschnie razem z atramentem.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cholerni madralowie.",
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
		local ironLungsCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist" && !bro.getSkills().hasSkill("trait.iron_lungs"))
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() != "background.anatomist" && bro.getSkills().hasSkill("trait.iron_lungs"))
			{
				ironLungsCandidates.push(bro);
			}
		}

		if (ironLungsCandidates.len() == 0 || anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.IronLungs = ironLungsCandidates[this.Math.rand(0, ironLungsCandidates.len() - 1)];
		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Score = 5 * ironLungsCandidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
		_vars.push([
			"ironlungs",
			this.m.IronLungs.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.IronLungs = null;
	}

});

