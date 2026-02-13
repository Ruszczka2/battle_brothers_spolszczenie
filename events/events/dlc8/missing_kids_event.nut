this.missing_kids_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Cultist = null,
		Hedge = null,
		Killer = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.missing_kids";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Gdy wedrujesz ulicami %townname%, gromadka wychudzonych straznikow nagle wylania sie z zaulka jak stado szczurow i, jak szczury, jest ich niepokojaco wielu. Gdy trzymasz glowe nisko, %anatomist% anatomista nie potrafi sie powstrzymac i gapi sie glupio, przyciagajac ich uwage. Straznicy lapia kontakt wzrokowy, podchodza i jak zwykle zaczynaja z korupcja.%SPEECH_ON%Hej, podrozni. Mowi sie w miescie, ze ktos zabija dzieci. Mamy powod sadzic, ze to wasz dziwak tu odpowiada za to paskudne, paskudne sprawy.%SPEECH_OFF%Anatomista probuje sie bronic, ale wiesz, ze rozsadek nie wchodzi w gre. Pytasz straznikow, ile chca. Mowia.%SPEECH_ON%Co powiesz na %blackmail% koron i przymkniemy oko na to cale dzieciobojstwo. Albo nie przymkniemy i skopiemy wam dupska.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze, zaplacimy ten \'mandat.\'",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Nie zaplacimy nic.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Hedge != null)
				{
					this.Options.push({
						Text = "Gdzie jest ten rycerz zywoplotu %hedgeknight%, kiedy go potrzeba?",
						function getResult( _event )
						{
							return "Hedge";
						}

					});
				}

				if (_event.m.Cultist != null)
				{
					this.Options.push({
						Text = "Masz cos do powiedzenia, %cultist% kultysto?",
						function getResult( _event )
						{
							return "Cultist";
						}

					});
				}

				if (this.Const.DLC.Unhold && _event.m.Killer != null)
				{
					this.Options.push({
						Text = "%killer% zawsze unika strazy, co by zrobil?",
						function getResult( _event )
						{
							return "Killer";
						}

					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Placisz im zloto. Biora je i odchodza smiejac sie. %anatomist% wyjasnia, ze nigdy nie zabil zadnego dziecka, ani by tego nie zrobil, chyba ze bylaby z tego wartosc naukowa. Zamykasz oczy i pytasz, czy zabilby dziecko, gdyby byla z tego wartosc naukowa. Anatomista prycha.%SPEECH_ON%Zrobilbym z nich pustkowie, panie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oczywiscie, ze tak.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-750);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]750[/color] Koron"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Mowisz im, ze musisz policzyc, ile masz pieniedzy. Patrzac do kieszeni, mowisz.%SPEECH_ON%Chyba mam piec.%SPEECH_OFF%Najchudszy ze straznikow podchodzi i pyta \"piec czego?\" Odpowiadasz piescia w jego twarz. Zanim jeszcze upadnie, pozostali straznicy juz sa na was, kopia, bija i depcza. Przeszukuja wam kieszenie, ale nie masz przy sobie ani jednej korony. W koncu odpuszczaja i staja z boku, a tlum chlopow powoli zbiera sie wokol zamieszania. Jeden straznik klepie drugiego, sugerujac, ze czas isc. Dowodca patrzy na ciebie z gory.%SPEECH_ON%Cholera, chlopie, umiesz przyjac cios. Mam nadzieje, ze ten lomot byl tego wart. No dawaj, wynosmy sie stad.%SPEECH_OFF%Powoli wstajesz i pomagasz %anatomist% sie podniesc. Wyciera krew z twarzy. Dla ciebie lanie to nic nowego, ale dla anatomisty to pewnie pierwszy raz. Krew wciaz leci mu z nosa i wciaz ja wyciera. Kazesz mu odchylic glowe do tylu i prowadzisz go do wozu. Anatomista mowi piskliwym glosem.%SPEECH_ON%To dalej krwawi. Wiem, ze tak ma byc, ale widziec to i czuc na wlasnej skorze...fascynujace. Bardzo fascynujace.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Szybko powszednieje, zaufaj mi.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				local injury = _event.m.Anatomist.addInjury([
					{
						ID = "injury.broken_nose",
						Threshold = 0.0,
						Script = "injury/broken_nose_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Anatomist.getName() + " odnosi " + injury.getNameOnly()
				});
			}

		});
		this.m.Screens.push({
			ID = "Hedge",
			Text = "[img]gfx/ui/events/event_96.png[/img]{%hedgeknight% rycerz zywoplotu nagle wylania sie zza rogu. Straznicy cofaja sie o krok. Je jablko jedna reka, a druga spoczywa na glowicy broni jak dlon kata na dzwigni. Spoglada na straznikow, oceniajac kazdego po kolei i uznajac ich za niewystarczajacych. Bierze kolejny gryz jablka i zwraca sie do ciebie.%SPEECH_ON%Czy jest tu jakis problem, kapitanie?%SPEECH_OFF%Jeden ze straznikow szybko wychodzi naprzod, usmiechajac sie nerwowo.%SPEECH_ON%Ach, nie, zaden problem. Po prostu, eee, wykonywalismy nalezyta starannosc w pewnej sprawie.%SPEECH_OFF%Rycerz zywoplotu rzuca ogryzek za siebie, potem przeciaga sie dlugo, a elementy zbroi chrzeszcza i stukaja o siebie. Kiwal glowa.%SPEECH_ON%I jak wam to idzie?%SPEECH_OFF%Straznicy oznajmiaja, ze wlasnie skonczyli. Rycerz usmiecha sie i mowi, ze jesli czyjs czas zostal zmarnowany, nalezy mu sie rekompensata. Polykajac nerwowo, jeden ze straznikow oddaje sakiewke monet. Przeprasza cie za zmarnowany czas. Chudzi straznicy wycofuja sie w poplochu, cofajac sie, az znikaja. %hedgeknight% wzdycha. Mowi, ze czekal na twoje slowo. Pytasz, jakie slowo i po co. Wyjmuje kolejne jablko i miazdzy je zaciskiem swojej dloni. Wklada kawalek do ust.%SPEECH_ON%No i co myslisz?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Eee...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(150);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]150[/color] Koron"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Hedge.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Cultist",
			Text = "[img]gfx/ui/events/event_03.png[/img]{Zanim zdazysz odpowiedziec, miedzy strony leci mala torba i gdy spada, wysypuje sie z niej sterta kurzych kosci. Slychac kroki i wszyscy odwracaja sie, by zobaczyc, kto je wydaje. %cultist% kultysta wychodzi naprzod, schyla sie i podnosi jedna z kosci. Odwraca sie do straznikow i mowi, ze zadne dziecko tu nie zaginelo, a ich raporty to klamstwa. Jeden z chudych straznikow przechyla glowe.%SPEECH_ON%A ty niby kto jestes?%SPEECH_OFF%Kultysta podchodzi do straznikow, kosci chrzescza pod jego butami. Pochyla sie do ucha jednego z nich i zaczyna szeptac. Gdy konczy, straznik odchyla sie.%SPEECH_ON%Testuje jego cierpliwosc?%SPEECH_OFF%Kultysta kiwa glowa i mowi.%SPEECH_ON%A zakonczenie tego, co ma byc wieczne, przyniesie ci tak straszliwe konsekwencje, ze uznasz, iz samo zycie bylo wielkim bledem, i tak jest, wszystko nim jest.%SPEECH_OFF%Straznicy spogladaja po sobie. Jeden podaje korony, jakby to byla pokuta. Chetnie je bierzesz i, co dziwne, sa cieple w dotyku. %cultist% odwraca sie i kiwa glowa, szepczac cos o determinacji istot daleko poza twoim pojeciem. Patrzysz na kosci, ale nie pamietasz, by kompania kupowala kury, ani nie pamietasz zadnych kurnikow po drodze.%SPEECH_ON%To wyglada jak-%SPEECH_OFF%Anatomista mowi za glosno o tym, na co to wyglada, wiec przerywasz mu, po czym pospiesznie wycofujesz sie z ulicy, zanim z tego dziwnego zamieszania wyniknie cos gorszego.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wynosmy sie stad.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local initiativeBoost = this.Math.rand(1, 3);
				_event.m.Cultist.getBaseProperties().Initiative += initiativeBoost;
				_event.m.Cultist.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Cultist.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiativeBoost + "[/color] Inicjatywy"
				});
				this.World.Assets.addMoney(75);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]75[/color] Koron"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Cultist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Killer",
			Text = "[img]gfx/ui/events/event_20.png[/img]{Otwierasz usta, by odpowiedziec, gdy nagle kobieta krzyczy. Obie strony patrza i widza polnagiego mezczyzne wijacego sie na koncu liny, z szyja wygieta pod katem niezgodnym z zyciem. Jednak nie upadek go zabil: jego cialo jest okaleczone i zmasakrowane, pociete wszelkimi narzedziami tortur. Na balkonie stoi sylwetka, a dzikie oczy spogladaja spod kaptura, a pod nimi kpiacy usmiech, ktory wyklucza jakakolwiek skruche. Straznicy krzycza i ruszaja w pogon. Smiejac sie, postac znika z balkonu. Sluchasz pogoni straznikow za morderca, gdy oddala sie w %townname%. Wkrotce slyszysz tylko odglos kropli krwi spadajacych z ciala i mlaskanie psow z zaulka, ktore przyszly ja wylizac. %anatomist% wpatruje sie w zwloki. Otwiera usta, ale %killer% zbieg pojawia sie nagle.%SPEECH_ON%Hej, kapitanie. Pomyslalem, ze ci sie to spodoba.%SPEECH_OFF%Podaje ci kilka dodatkow do zbroi, metal pokryty krwia. Nie trzeba geniusza, by wiedziec, skad to pochodzi, ale i tak jest to ladne i warte zachowania. Kazesz mu to wyczyscic i zabrac do ekwipunku. Mezczyzna kiwa glowa. Bierze dlugi oddech i wypuszcza go z szerokim usmiechem.%SPEECH_ON%Czy nie kochasz zycia w wielkim miescie?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Przynajmniej ktos dobrze sie bawi.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local attachmentList = [
					"mail_patch_upgrade",
					"double_mail_upgrade"
				];
				local item = this.new("scripts/items/armor_upgrades/" + attachmentList[this.Math.rand(0, attachmentList.len() - 1)]);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				this.World.Assets.getStash().add(item);
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Killer.getImagePath());
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

		if (this.World.Assets.getMoney() < 900)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.getSize() < 2)
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
		local anatomist_candidates = [];
		local cultist_candidates = [];
		local hedge_candidates = [];
		local killer_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist" && !bro.getSkills().hasSkill("injury.broken_nose"))
			{
				anatomist_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				cultist_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.hedge_knight")
			{
				hedge_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.killer_on_the_run")
			{
				killer_candidates.push(bro);
			}
		}

		if (cultist_candidates.len() > 0)
		{
			this.m.Cultist = cultist_candidates[this.Math.rand(0, cultist_candidates.len() - 1)];
		}

		if (hedge_candidates.len() > 0)
		{
			this.m.Hedge = hedge_candidates[this.Math.rand(0, hedge_candidates.len() - 1)];
		}

		if (killer_candidates.len() > 0)
		{
			this.m.Killer = killer_candidates[this.Math.rand(0, killer_candidates.len() - 1)];
		}

		if (anatomist_candidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 8 + anatomist_candidates.len();
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
			"blackmail",
			750
		]);
		_vars.push([
			"cultist",
			this.m.Cultist != null ? this.m.Cultist.getNameOnly() : ""
		]);
		_vars.push([
			"hedgeknight",
			this.m.Hedge != null ? this.m.Hedge.getNameOnly() : ""
		]);
		_vars.push([
			"killer",
			this.m.Killer != null ? this.m.Killer.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Cultist = null;
		this.m.Hedge = null;
		this.m.Killer = null;
		this.m.Town = null;
	}

});

