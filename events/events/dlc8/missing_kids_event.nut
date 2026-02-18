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
			Text = "[img]gfx/ui/events/event_31.png[/img]{Gdy wędrujesz ulicami %townname%, gromadka wychudzonych strażników nagle wylania się z zaułka jak stado szczurów i, jak szczury, jest ich niepokojąco wielu. Gdy trzymasz głowę nisko, %anatomist% anatomista nie potrafi się powstrzymać i gapi się głupio, przyciągając ich uwagę. Strażnicy łapią kontakt wzrokowy, podchodzą i jak zwykle zaczynają z korupcją.%SPEECH_ON%Hej, podróżni. Mówi się w mieście, że ktoś zabija dzieci. Mamy powód sądzić, że to wasz dziwak tu odpowiada za to paskudne, paskudne sprawy.%SPEECH_OFF%Anatomista próbuje się bronić, ale wiesz, że rozsądek nie wchodzi w grę. Pytasz strażników, ile chcą. Mówią.%SPEECH_ON%Co powiesz na %blackmail% koron i przymkniemy oko na to całe dzieciobójstwo. Albo nie przymkniemy i skopiemy wam dupska.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze, zapłacimy ten \'mandat.\'",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Nie zapłacimy nic.",
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
						Text = "Gdzie jest ten rycerz żywopłotu %hedgeknight%, kiedy go potrzeba?",
						function getResult( _event )
						{
							return "Hedge";
						}

					});
				}

				if (_event.m.Cultist != null)
				{
					this.Options.push({
						Text = "Masz coś do powiedzenia, %cultist% kultysto?",
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
			Text = "[img]gfx/ui/events/event_31.png[/img]{Płacisz im złoto. Biorą je i odchodzą, śmiejąc się. %anatomist% wyjaśnia, że nigdy nie zabił żadnego dziecka, ani by tego nie zrobił, chyba że byłaby z tego wartość naukowa. Zamykasz oczy i pytasz, czy zabiłby dziecko, gdyby była z tego wartość naukowa. Anatomista prycha.%SPEECH_ON%Zrobiłbym z nich pustkowie, panie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oczywiście, że tak.",
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
			Text = "[img]gfx/ui/events/event_31.png[/img]{Mówisz im, że musisz policzyć, ile masz pieniędzy. Patrząc do kieszeni, mówisz.%SPEECH_ON%Chyba mam pięć.%SPEECH_OFF%Najchudszy ze strażników podchodzi i pyta \"pięć czego?\" Odpowiadasz pięścią w jego twarz. Zanim jeszcze upadnie, pozostali strażnicy już są na was, kopią, biją i depczą. Przeszukują wam kieszenie, ale nie masz przy sobie ani jednej korony. W końcu odpuszczają i stają z boku, a tłum chłopów powoli zbiera się wokół zamieszania. Jeden strażnik klepie drugiego, sugerując, że czas iść. Dowódca patrzy na ciebie z góry.%SPEECH_ON%Cholera, chłopie, umiesz przyjąć cios. Mam nadzieję, że ten łomot był tego wart. No dawaj, wynośmy się stąd.%SPEECH_OFF%Powoli wstajesz i pomagasz %anatomist% się podnieść. Wyciera krew z twarzy. Dla ciebie lanie to nic nowego, ale dla anatomisty to pewnie pierwszy raz. Krew wciąż leci mu z nosa i wciąż ją wyciera. Każesz mu odchylić głowę do tyłu i prowadzisz go do wozu. Anatomista mówi piskliwym głosem.%SPEECH_ON%To dalej krwawi. Wiem, że tak ma być, ale widzieć to i czuć na własnej skórze...fascynujące. Bardzo fascynujące.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_96.png[/img]{%hedgeknight% rycerz żywopłotu nagle wylania się zza rogu. Strażnicy cofają się o krok. Je jabłko jedną ręką, a druga spoczywa na głowicy broni jak dłoń kata na dźwigni. Spogląda na strażników, oceniając każdego po kolei i uznając ich za niewystarczających. Bierze kolejny gryz jabłka i zwraca się do ciebie.%SPEECH_ON%Czy jest tu jakiś problem, kapitanie?%SPEECH_OFF%Jeden ze strażników szybko wychodzi naprzód, uśmiechając się nerwowo.%SPEECH_ON%Ach, nie, żaden problem. Po prostu, eee, wykonywaliśmy należytą staranność w pewnej sprawie.%SPEECH_OFF%Rycerz żywopłotu rzuca ogryzek za siebie, potem przeciąga się długo, a elementy zbroi chrzęszczą i stukają o siebie. Kiwał głową.%SPEECH_ON%I jak wam to idzie?%SPEECH_OFF%Strażnicy oznajmiają, że właśnie skończyli. Rycerz uśmiecha się i mówi, że jeśli czyjś czas został zmarnowany, należy mu się rekompensata. Połykając nerwowo, jeden ze strażników oddaje sakiewkę monet. Przeprasza cię za zmarnowany czas. Chudzi strażnicy wycofują się w popłochu, cofając się, aż znikają. %hedgeknight% wzdycha. Mówi, że czekał na twoje słowo. Pytasz, jakie słowo i po co. Wyjmuje kolejne jabłko i miażdży je zaciskiem swojej dłoni. Wkłada kawałek do ust.%SPEECH_ON%No i co myślisz?%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_03.png[/img]{Zanim zdążysz odpowiedzieć, między strony leci mała torba i gdy spada, wysypuje się z niej sterta kurzych kości. Słychać kroki i wszyscy odwracają się, by zobaczyć, kto je wydaje. %cultist% kultysta wychodzi naprzód, schyla się i podnosi jedną z kości. Odwraca się do strażników i mówi, że żadne dziecko tu nie zaginęło, a ich raporty to kłamstwa. Jeden z chudych strażników przechyla głowę.%SPEECH_ON%A ty niby kto jesteś?%SPEECH_OFF%Kultysta podchodzi do strażników, kości chrzęszczą pod jego butami. Pochyla się do ucha jednego z nich i zaczyna szeptać. Gdy kończy, strażnik odchyla się.%SPEECH_ON%Testuje jego cierpliwość?%SPEECH_OFF%Kultysta kiwa głową i mówi.%SPEECH_ON%A zakończenie tego, co ma być wieczne, przyniesie ci tak straszliwe konsekwencje, że uznasz, iż samo życie było wielkim błędem, i tak jest, wszystko nim jest.%SPEECH_OFF%Strażnicy spoglądają po sobie. Jeden podaje korony, jakby to była pokuta. Chętnie je bierzesz i, co dziwne, są ciepłe w dotyku. %cultist% odwraca się i kiwa głową, szepcząc coś o determinacji istot daleko poza twoim pojęciem. Patrzysz na kości, ale nie pamiętasz, by kompania kupowała kury, ani nie pamiętasz żadnych kurników po drodze.%SPEECH_ON%To wygląda jak-%SPEECH_OFF%Anatomista mówi za głośno o tym, na co to wygląda, więc przerywasz mu, po czym pospiesznie wycofujesz się z ulicy, zanim z tego dziwnego zamieszania wyniknie coś gorszego.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wynosmy się stąd.",
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{Otwierasz usta, by odpowiedzieć, gdy nagle kobieta krzyczy. Obie strony patrzą i widzą półnagiego mężczyznę wijącego się na końcu liny, z szyją wygiętą pod kątem niezgodnym z życiem. Jednak nie upadek go zabił: jego ciało jest okaleczone i zmasakrowane, pocięte wszelkimi narzędziami tortur. Na balkonie stoi sylwetka, a dzikie oczy spoglądają spod kaptura, a pod nimi kpiący uśmiech, który wyklucza jakąkolwiek skruchę. Strażnicy krzyczą i ruszają w pogoń. Śmiejąc się, postać znika z balkonu. Słuchasz pogoni strażników za mordercą, gdy oddala się w %townname%. Wkrótce słyszysz tylko odgłos kropli krwi spadających z ciała i mlaskanie psów z zaułka, które przyszły ją wylizać. %anatomist% wpatruje się w zwłoki. Otwiera usta, ale %killer% zbieg pojawia się nagle.%SPEECH_ON%Hej, kapitanie. Pomyślałem, że ci się to spodoba.%SPEECH_OFF%Podaje ci kilka dodatków do zbroi, metal pokryty krwią. Nie trzeba geniusza, by wiedzieć, skąd to pochodzi, ale i tak jest to ładne i warte zachowania. Każesz mu to wyczyścić i zabrać do ekwipunku. Mężczyzna kiwa głową. Bierze długi oddech i wypuszcza go z szerokim uśmiechem.%SPEECH_ON%Czy nie kochasz życia w wielkim mieście?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Przynajmniej ktoś dobrze się bawi.",
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

