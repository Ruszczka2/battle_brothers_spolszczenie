this.anatomist_exhumes_hero_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Graver = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_exhumes_hero";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_20.png[/img]{Będąc w %townname%, dowiadujesz się o lokalnym bohaterze, który niedawno został pochowany. Dla ciebie to błaha wiadomość. Ten człowiek pewnie nie był nawet bohaterem, jeśli porównać go do czegokolwiek ponad poziom zabójcy szczurów, więc mało cię to obchodzi. Oczywiście, anatomistów to nie zraża i chwytają się wieści jak muchy kadaveru. Proponują, by kompania wykopała zwłoki bohatera, aby mogli zobaczyć po ich kształcie, co odróżnia ten \"bohaterski pierwiastek\" od zwykłego człowieka. %anatomist% wyjaśnia.%SPEECH_ON%Zwłoki bohatera to nie są byle zwłoki. Są nasycone czymś zupełnie innym, jakimś kuszącym impulsem, który odróżnia je od reszty z nas.%SPEECH_OFF%Widziałeś w życiu sporo i zapewniasz anatomistów, że ciało będzie wyglądać jak każde inne. Mimo to są zdeterminowani, by zerknąć, nawet jeśli obrazi to tłum.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze, wykopmy je.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "Dziś nie wykopujemy grobów.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Graver != null)
				{
					this.Options.push({
						Text = "%graver%, co ty tu robisz?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Po długich namowach anatomistom udaje się przełamać twoją obronę i zgadzasz się wydobyć z grobu zimne, martwe ciało lokalnego bohatera, rzekomo o bohaterskim kształcie. W tej sprawie jest dużo skradania i cichych kroków, bo przemykacie przez cmentarz jak banda dzieciaków, które robią coś niedobrego, co zresztą jest prawdą. Grób bohatera łatwo znaleźć, bo zdobią go kwiaty i inne ozdoby.\n\n%anatomist% kopie kwiaty na bok, zrzuca łopatą dziecięcą zabawkę i ciska ją przez cmentarz. Szybko wbija łopatę i zaczyna się kopanie. Nie trwa to długo, ziemia jest świeżo ruszona. W grobie leży kilka przedmiotów, a obok nich samo ciało: zwykły człowiek o bladosinym obliczu. Wyciągają je z grobu, anatomici przerzucają je jak deskę i gdy ląduje na trawie, gonią za nim jak chochliki, tnąc, krojąc i rozgrzebując z niepokojącą gorliwością. Gdy kończą, wtaczają ciało z powrotem do grobu, jego kształt jest bardziej poszarpany niż wcześniej. Narzekają, że być może miałeś rację, że ciało bohatera nie ma żadnych niezwykłych cech. Ale zamiast zgodzić się z niewykształconym najemnikiem, stwierdzają, że może wcale nie był bohaterem, i ich poszukiwania muszą trwać dalej. Cieszysz się, że nie zostaliście przyłapani.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ohyda. Zmykajmy stąd.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.anatomist")
					{
						bro.improveMood(1.0, "Mógł zbadać zwłoki bohatera");
						bro.worsenMood(0.5, "Został wprowadzony w błąd co do osobliwości tych zwłok");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}

						bro.addXP(150, false);
						bro.updateLevel();
						this.List.push({
							id = 16,
							icon = "ui/icons/xp_received.png",
							text = bro.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+150[/color] doświadczenia"
						});
					}
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_141.png[/img]{Po długich namowach anatomistom udaje się przełamać twoje mizerne opory i zgadzasz się wydobyć z grobu zimne, martwe ciało lokalnego bohatera. W tej sprawie jest dużo skradania i cichych kroków, bo przemykacie przez cmentarz jak banda dzieciaków robiących coś niedobrego, i w istocie tak jest. Docierasz na cmentarz i pytasz, czy ktoś z nich zna imię bohatera. %anatomist% mówi, że ironicznie było to Mortimer.\n\nZnajdujesz taki grób i zaczynasz kopać, ale gdy docierasz na dno, znajdujesz tylko martwego kota, zwiniętego, szarego i zniszczonego, z większą ilością robaków niż futra. Gdy anatomici podnoszą go, z linii drzew dobiega krzyk. Odwracasz się i widzisz młodego chłopca, który płacze i wskazuje. Zanim go złapiesz, odwraca się i ucieka, wrzeszcząc dość obrazowe słowa o waszym źle przemyślanym przedsięwzięciu. W odpowiedzi słychać pomruki tłumu, a słowa giną w zamieszaniu, ale nadal wyłapujesz nazwę %companyname% i brzęk kilku widłów uderzających o siebie. Odwracasz się, by kazać anatomistom przestać kopać, tylko po to, by zobaczyć, że są już w połowie drogi z cmentarza i uciekają, ratując życie. Klnąc, dołączasz do nich w tej haniebnej rejteradzie i opuszczasz miasto.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "W jakie gówno mnie wciągają...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local f = _event.m.Town.getFactionOfType(this.Const.FactionType.Settlement);
				f.addPlayerRelation(this.Const.World.Assets.RelationMinorOffense, "Your company was caught graverobbing");
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "Twoje relacje z " + f.getName() + " ucierpiały"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.anatomist")
					{
						bro.worsenMood(0.75, "Nie zdołał ekshumować niezwykłych zwłok");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_46.png[/img]{%graver% nagle pojawia się u twojego boku. Znajomy cmentarza wbija brudny kciuk w pierś.%SPEECH_ON%Chcesz wykopać trupa? Jestem twoim człowiekiem.%SPEECH_OFF%Z jego pomocą decydujesz się pójść za ponurymi planami anatomistów. Znajdujecie cmentarz i przemierzacie go w poszukiwaniu grobu bohatera. To cała działka dla biedoty, ale w końcu znajdujecie znak pokryty świeżymi kwiatami i innymi ozdobami, które ludzie bezceremonialnie depczą i odrzucają. Prace ruszają, a dzięki %graver% ciało zostaje wykopane w błyskawicznym tempie. Anatomiści zabierają się do pracy nad zwłokami, pochylając się i mamrocząc do siebie, ich zgarbione sylwetki jak sępy. %graver% tymczasem grzebie w samym grobie, po czym znajduje broń schowaną w rogu. To niezły łup, biorąc wszystko pod uwagę, i niemal sprawia, że ta seria wydarzeń była warta zachodu. Odwracasz się i widzisz, jak anatomici kopią ciało z powrotem do grobu, kończyny wyginają się i sztywnie łopoczą na boki, a twarz bohatera spoczywa, oczy otwarte, wpatrzone w rozgrzebaną ziemię, gdzie robaki wychodzą i szukają powietrza. Gdy wszyscy dostali to, czego potrzebowali, szybko opuszczacie to miejsce, zanim miejscowi się zjawiają i zlinczują was do ostatniego.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wracajmy na drogę.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.anatomist")
					{
						bro.improveMood(1.0, "Mógł zbadać niezwykłe zwłoki bohatera");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}

						bro.addXP(150, false);
						bro.updateLevel();
						this.List.push({
							id = 16,
							icon = "ui/icons/xp_received.png",
							text = bro.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+150[/color] doświadczenia"
						});
					}
				}

				_event.m.Graver.improveMood(1.0, "Wykorzystał swoje umiejętności ekshumacji");

				if (_event.m.Graver.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Graver.getMoodState()],
						text = _event.m.Graver.getName() + this.Const.MoodStateEvent[_event.m.Graver.getMoodState()]
					});
				}

				local weaponList = [
					"arming_sword",
					"hand_axe",
					"military_pick",
					"boar_spear"
				];
				local item = this.new("scripts/items/weapons/" + weaponList[this.Math.rand(0, weaponList.len() - 1)]);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				this.World.Assets.getStash().add(item);
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Graver.getImagePath());
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
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local graver_candidates = [];
		local anatomist_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.graverobber")
			{
				graver_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
		}

		if (graver_candidates.len() > 0)
		{
			this.m.Graver = graver_candidates[this.Math.rand(0, graver_candidates.len() - 1)];
		}

		if (anatomist_candidates.len() > 1)
		{
			this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		}
		else
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = 10 + anatomist_candidates.len();
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
			"graver",
			this.m.Graver != null ? this.m.Graver.getName() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Graver = null;
		this.m.Town = null;
	}

});

