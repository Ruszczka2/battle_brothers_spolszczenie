this.discover_location_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Location = null,
		LastHelpTime = 0.0
	},
	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = this.Math.rand(75, 105) * 0.01;
		this.m.Type = "contract.discover_location";
		this.m.Name = "Odszukanie Lokacji";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		if (this.m.Home == null)
		{
			this.setHome(this.World.State.getCurrentTown());
		}

		this.contract.start();
	}

	function setup()
	{
		local locations = clone this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
		locations.extend(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getSettlements());
		local lowestDistance = 9000;
		local best;
		local myTile = this.m.Home.getTile();

		foreach( b in locations )
		{
			if (b.isLocationType(this.Const.World.LocationType.Unique))
			{
				continue;
			}

			if (b.isDiscovered())
			{
				continue;
			}

			local region = this.World.State.getRegion(b.getTile().Region);

			if (!region.Center.IsDiscovered)
			{
				continue;
			}

			if (region.Discovered < 0.25)
			{
				this.World.State.updateRegionDiscovery(region);
			}

			if (region.Discovered < 0.25)
			{
				continue;
			}

			local d = myTile.getDistanceTo(b.getTile());

			if (d > 20)
			{
				continue;
			}

			if (d + this.Math.rand(0, 5) < lowestDistance)
			{
				lowestDistance = d;
				best = b;
			}
		}

		if (best == null)
		{
			this.m.IsValid = false;
			return;
		}

		this.m.Location = this.WeakTableRef(best);
		this.m.Flags.set("Region", this.World.State.getTileRegion(this.m.Location.getTile()).Name);
		this.m.Flags.set("Location", this.m.Location.getName());
		this.m.DifficultyMult = this.Math.rand(70, 85) * 0.01;
		this.m.Payment.Pool = this.Math.max(300, 100 + (this.World.Assets.isExplorationMode() ? 100 : 0) + lowestDistance * 15.0 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentLightMult());

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.m.Flags.set("Bribe", this.beautifyNumber(this.m.Payment.Pool * (this.Math.rand(110, 150) * 0.01)));
		this.m.Flags.set("HintBribe", this.beautifyNumber(this.m.Payment.Pool * 0.1));
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Odszukaj miejsce zwane %location% %distance% na %direction%, gdzieś w regionie %region%"
				];

				if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.IntroChance)
				{
					this.Contract.setScreen("Intro");
				}
				else
				{
					this.Contract.setScreen("Task");
				}
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 15)
				{
					this.Flags.set("IsAnotherParty", true);
					this.Flags.set("IsShowingAnotherParty", true);
				}

				this.Contract.m.LastHelpTime = this.Time.getVirtualTimeF() + this.Math.rand(10, 40);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Odszukaj miejsce zwane %location% na %direction%, gdzieś w regionie %region%"
				];

				if (this.Contract.m.Location != null && !this.Contract.m.Location.isNull())
				{
					this.Contract.m.Location.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Flags.get("IsShowingAnotherParty"))
				{
					this.Flags.set("IsShowingAnotherParty", false);
					this.Contract.setScreen("AnotherParty1");
					this.World.Contracts.showActiveContract();
				}

				if (this.TempFlags.get("IsDialogTriggered"))
				{
					return;
				}

				if (this.Contract.m.Location.isDiscovered())
				{
					if (this.Flags.get("IsTrap"))
					{
						this.TempFlags.set("IsDialogTriggered", true);
						this.Contract.setScreen("Trap");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("FoundIt");
						this.World.Contracts.showActiveContract();
					}
				}
				else
				{
					local parties = this.World.getAllEntitiesAtPos(this.World.State.getPlayer().getPos(), 400.0);

					foreach( party in parties )
					{
						if (!party.isAlliedWithPlayer)
						{
							return;
						}
					}

					if (this.Time.getVirtualTimeF() >= this.Contract.m.LastHelpTime + 70.0)
					{
						this.Contract.m.LastHelpTime = this.Time.getVirtualTimeF() + this.Math.rand(0, 30);
						local r = this.Math.rand(1, 100);

						if (r <= 50)
						{
							this.Contract.setScreen("SurprisingHelpAltruists");
						}
						else
						{
							this.Contract.setScreen("SurprisingHelpOpportunists1");
						}

						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "DiscoverLocation")
				{
					this.Contract.setState("Return");
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "DiscoverLocation")
				{
					this.Contract.setState("Return");
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Wróć do " + this.Contract.m.Home.getName()
				];

				if (this.Contract.m.Location != null && !this.Contract.m.Location.isNull())
				{
					this.Contract.m.Location.getSprite("selection").Visible = false;
				}

				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("IsAnotherParty"))
					{
						this.Contract.setScreen("AnotherParty2");
					}
					else
					{
						this.Contract.setScreen("Success1");
					}

					this.World.Contracts.showActiveContract();
				}
			}

		});
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationDefault);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "Negocjacje",
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% przygląda się kiepsko naszkicowanej mapie, po czym spogląda na ciebie, jakbyś to ty był za nią odpowiedzialny.%SPEECH_ON%Słuchaj, najemniku, to dziwne zadanie, ale wyglądasz na człowieka z głową na karku. Widzisz tę ciemną plamę? Czy byłbyś skłonny zapuścić się w tamtą stronę i spróbować znaleźć %location%? To gdzieś w regionie %region% albo w jego pobliżu.%SPEECH_OFF% | Wchodzisz do komnaty %employer%a, a on wciska ci mapę prosto w twarz.%SPEECH_ON%{Najemniku! Czas na wyprawę! Widzisz ten niezbadany punkt, %direction% stąd w regionie %region%? Właśnie tam musisz szukać %location%. Przyjmujesz czy nie? | Dobra, to może brzmieć dziwnie, ale potrzebuję odnaleźć i nanieść na mapę miejsce zwane %location%. Nasze mapy są w tym zakresie niekompletne i przynajmniej tyle wiem, że jest gdzieś w regionie %region% %direction% stąd lub w jego pobliżu. Idź, znajdź je i wróć z koordynatami, a zostaniesz porządnie wynagrodzony. | Są na tym świecie miejsca, których człowiek wciąż nie odnalazł i nie naniósł na mapy. Szukam %location% %direction% stąd, w regionie %region% lub w jego pobliżu. To wszystko, co o nim wiem, ale wiem, że istnieje. Idź i znajdź je dla mnie, a zostaniesz porządnie wynagrodzony. | Potrzebuję odnaleźć miejsce, najemniku. Leży %direction% stąd, w regionie %region% lub w jego pobliżu. Pospólstwo nazywa je %location%, ale cokolwiek to jest, muszę wiedzieć, GDZIE jest, rozumiesz? Znajdź je, a hojnie zapłacę. | Potrzebuję żołnierza i odkrywcy, najemniku, i myślę, że nadajesz się na oba. Zanim oskarżysz mnie o skąpstwo, że nie zatrudniam osobno, powiem tylko, że mam dla ciebie sporo koron do zarobienia. O co chodzi, hm? Otóż znam miejsce zwane %location%, ale nie wiem, gdzie się znajduje, poza tym, że leży %direction% stąd w pasie ziemi zwanym %region%. Znajdź je, zaznacz na mapie, a dostaniesz zapłatę za dwóch!}%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Jaka jest płaca? | Odnajdziemy to miejsce, za odpowiednia cenę.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Nie jestem zainteresowany. | W najbliższym czasie raczej nie będziemy w tamtych stronach. | Nie takiego rodzaju pracy szukamy.}",
					function getResult()
					{
						this.World.Contracts.removeContract(this.Contract);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "FoundIt",
			Title = "%location%",
			Text = "[img]gfx/ui/events/event_57.png[/img]{Dostrzegasz %location% w lunecie i zaznaczasz na mapie. Proste. Czas wracać do %employer%a. | Cóż, pora wracać do %employer%a, bo %location% okazało się łatwiejsze do znalezienia, niż sądziłeś. Zaznaczasz je na mapie, zatrzymujesz się, chichoczesz i kręcisz głową. Co za szczęście. | %location% pojawia się w zasięgu wzroku i natychmiast odradza się na twojej mapie, na ile pozwalają twoje zdolności kreślarskie. %randombrother% pyta, czy to wszystko. Kiwasz głową. Trudna czy łatwa wyprawa, %employer% i tak będzie czekał, by ci zapłacić.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Czas wracać.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Trap",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_07.png[/img]%location% zostało dostrzeżone - i tak samo %companyname%. Rzekomy \"altruista\", który dał ci wskazówki, stoi na miejscu, ale tym razem ma przy sobie bandę twardych i nieprzyjaznych ludzi.%SPEECH_ON%{No proszę, jednak potrafisz podążać za wskazówkami. Zastawienie zasadzki jest proste, gdy mówi się idiocie, gdzie się z nim spotkać. A teraz, zabijcie ich wszystkich! | Hej, najemniku. Dziwnie cię tu widzieć. Och, chwila, jednak nie. Zabić ich wszystkich! | Cholera, tyle ci to zajęło! Co, nie potrafisz wykonać prostych poleceń, jak wejść do własnego grobu? Głupi najemniku, i do tego irytująco głupi. Dobra, kończmy to. Zabić ich wszystkich.}%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.BanditTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "DiscoverLocation";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.BanditRaiders, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, false, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SurprisingHelpAltruists",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_76.png[/img]{Machając przyjaźnie ręką, podchodzi do ciebie mężczyzna. Odpowiadasz, wysuwając miecz do połowy. On się śmieje.%SPEECH_ON%Wielu interesuje się %location%, więc nie mam ci za złe, że jesteś taki ostrożny. Słuchaj, powiem ci dokładnie, gdzie to jest. Po prostu %distance% na %direction% stąd, %terrain%.%SPEECH_OFF%Odchodzi, chichocząc.%SPEECH_ON%Nie wiem, czy zrobiłem dobrze czy źle, ale to właśnie taki rodzaj zabawy, który lubię!%SPEECH_OFF% | Grupa zmęczonych podróżników! Zatrzymują się pośrodku drogi, w połowie oblepieni błotem i w połowie liśćmi, w całkiem niezamierzonym kamuflażu. Jeden pociera czoło, uważnie cię obserwuje, po czym jego uśmiech się poszerza.%SPEECH_ON%Eh, znam poszukiwacza, gdy go widzę. Szukasz %location%, co? Masz szczęście, właśnie stamtąd wracamy! Dawaj mapę, a pokażę ci, gdzie to jest. Widzisz, %terrain% %distance% na %direction% od miejsca, w którym teraz jesteśmy.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Dzięki.",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 20 && this.Contract.getDifficultyMult() > 0.95)
						{
							this.Flags.set("IsTrap", true);
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SurprisingHelpOpportunists1",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_76.png[/img]{Nieznajomy to samotny mężczyzna, który trzyma dystans, jedną stopą na ścieżce, drugą gotową do ucieczki.%SPEECH_ON%Hej tam.%SPEECH_OFF%Rozgląda się po twoich ludziach i powoli się uśmiecha, jakby wyczuwał, że jesteście zagubieni.%SPEECH_ON%Szukacie %location%, co? Hmm, tak. Powiem wam co, dajcie mi %hint_bribe% koron, a powiem dokładnie, gdzie to jest! Spróbujcie mnie gonić z mieczami, a zniknę szybciej, niż zdążycie mrugnąć!%SPEECH_OFF% | Patrzysz, jak nieznajomy wchodzi w światło ścieżki, zasłaniając oczy, by ukryć większość twarzy.%SPEECH_ON%Wyglądacie na takich, co czegoś szukają, ale nie wiedzą gdzie! %location% jest właśnie takie podchwytliwe. Dobrze, że wiem, gdzie jest. Dobrze, że i wy możecie to wiedzieć, jeśli wsuniecie mi %hint_bribe% koron. Jestem najszybszym sprinterem, jakiego widzieliście, więc nie próbujcie tego wyciągnąć ze mnie jednym z tych lśniących mieczy, które macie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "W porządku, oto korony. A teraz mów.",
					function getResult()
					{
						return "SurprisingHelpOpportunists2";
					}

				},
				{
					Text = "Nie trzeba, sami sobie poradzimy.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SurprisingHelpOpportunists2",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_76.png[/img]Przyjmujesz propozycję mężczyzny, który zgodnie z obietnicą zdradza ci szczegóły.%SPEECH_ON%No wiesz, to tam, oczywiście, %terrain% %distance% na %direction% od miejsca, gdzie teraz jesteśmy. Łatwizna.%SPEECH_OFF%Pogwizduje sobie, odchodząc, bez wątpienia była to dla niego bardzo łatwa forsa.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Rozumiem.",
					function getResult()
					{
						this.World.Assets.addMoney(-this.Flags.get("HintBribe"));
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + this.Flags.get("HintBribe") + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "AnotherParty1",
			Title = "W %townname%",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Gdy ty i %companyname% szykujecie się do drogi, %randombrother% mówi, że jest mężczyzna, który chce mówić z tobą bezpośrednio. Kiwasz głową i każesz go przyprowadzić. To ponury, niski człowiek, który twierdzi, że \"władcy\" %townname% interesują się %location% wyłącznie z chciwości. Oczywiście, że tak, więc w czym problem? Mężczyzna kiwa głową.%SPEECH_ON%Słuchaj, są tacy, którzy chcą, by %location% pozostało na zawsze ukryte. Jeśli je znajdziesz, porozmawiaj najpierw ze mną. Dobrze ci za to zapłacimy.%SPEECH_OFF% | Gdy %companyname% szykuje wyprawę na poszukiwanie %location%, mężczyzna podchodzi do ciebie bokiem. Wręcza notatkę i odchodzi bez słowa. Zwój głosi: ZOSTAW %locationC% TAM, GDZIE JEST. JEŚLI JE ZNAJDZIESZ, POROZMAWIAJ Z NAMI. KORONY ZA MILCZENIE. WŁADCY %townnameC% NIE MUSZĄ NIC WIEDZIEĆ! | Mężczyzna podchodzi do kompanii. Za nim dostrzegasz kilka biednych rodzin, które przyglądają się z daleka. Nie wiesz, czy jest ich rzecznikiem, ale w każdym razie podchodzi prosto do ciebie z propozycją wypowiedzianą cicho i nisko.%SPEECH_ON%Słuchaj, najemniku. Jeśli pójdziesz i znajdziesz %location%, przyjdź najpierw do nas. Władcy %townname% nie muszą wnosić tam swojej chciwości i żądzy władzy. Zostaw to nam, dobrze? Zapłacimy ci dobrze.%SPEECH_OFF%Zanim zdążysz coś powiedzieć, prostuje się i idzie dalej. Gdy spoglądasz z powrotem na drogę, tych rodzin już nie ma.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "I\'ll think about it.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AnotherParty2",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Gdy zmierzasz do %townname%, na ścieżkę wychodzi nieznajomy. To mężczyzna, z którym rozmawiałeś wcześniej, ale tym razem ma przy sobie sakiewkę.%SPEECH_ON%{Nie masz powodu, by mówić władcom tego miasta, gdzie jest %location%. Zostaw jego tajemnice nam, nie masz pojęcia, jakie relikwie i historia tam spoczywają. Za twoje milczenie jesteśmy gotowi zapłacić %bribe% koron. Proszę, panie, przyjmij. | Słuchaj, najemniku, wiem, że mówisz jednym językiem, językiem pieniędzy. Weź tę sakiewkę jako dowód naszej wdzięczności - jeśli zachowasz milczenie. Nie musisz mówić władcom %townname%, gdzie jest %location%. To miejsce należy do naszych rodzin. Ci drobni władcy tylko zniszczą je swoją chciwością i żądzą władzy. Więc jak, przyjmiesz? Jest tam %bribe% koron. Wystarczy, że je weźmiesz i nie powiesz nic.}%SPEECH_OFF% | Wchodząc do %townname%, zatrzymuje cię znajoma twarz: mężczyzna, który żegnał cię przed wyprawą. Ale tym razem ma ze sobą sakiewkę.%SPEECH_ON%{%bribe% koron za twoje milczenie. Nie mów władcom tego miasta absolutnie nic, a będzie twoje. Nie muszą wiedzieć o naszej umowie, po prostu nie muszą wiedzieć, gdzie to miejsce jest. To dla nas ważne, z historią bez miary, a oni tylko je splądrują i złupią. Proszę, przyjmij. | Weź to, to %bribe% koron. Tyle jesteśmy gotowi dać za twoje milczenie. Władcy %townname% wezmą twoją informację i użyją jej, by splądrować %location%, bo znają nasze rodzinne związki z tym miejscem i, cóż, dawno wypadliśmy tu z łask. Niewiele nam zostało, więc proszę, pozwól nam zachować nasze pamiątki i stary dom.}%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nie sądzę. Tylko nasz zleceniodawca dowie się, gdzie to jest.",
					function getResult()
					{
						return "AnotherParty3";
					}

				},
				{
					Text = "Umowa stoi. Nikt poza tobą nie dowie się gdzie to jest.",
					function getResult()
					{
						return "AnotherParty4";
					}

				},
				{
					Text = "Czemu mamy dostać jedną zapłatę, skoro możemy dostać dwie?",
					function getResult()
					{
						return "AnotherParty5";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AnotherParty3",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Gdy mówisz mężczyźnie \"nie\", pada na kolana i zaczyna płakać, ku uciesze %companyname%. Zawodzi, że zostawiłeś historyczną przeszłość jego rodziny w rękach lubieżników i lichwiarzy. Mówisz mu, że to cię nie obchodzi. | Gdy mówisz mężczyźnie, że nie zamierzasz zdradzić swojego pierwotnego zleceniodawcy, wpada w szał. Próbuje cię zaatakować, rzucając się naprzód i chwytając cię roztrzęsionymi rękami. %randombrother% odpycha go i grozi, że zabije go ostrzem. Mężczyzna się wycofuje. Siada przy drodze z głową między kolanami, szlochając. Jeden z ludzi podaje mu chustkę, gdy przechodzicie obok. | Mówisz mężczyźnie nie. Błaga. Mówisz nie ponownie. Błaga jeszcze. Nagle uświadamiasz sobie, że przerabiałeś to już z jedną czy dwiema kobietami. To naprawdę nie wygląda dobrze. Mówisz mu to, ale emocje chwili są dla niego zbyt silne. Zaczyna zawodzić, opowiadając o tym, jak nazwisko jego rodziny zostanie zniszczone przez chciwych drani, którzy rządzą %townname%. Mówisz mu, że jego rzekome nazwisko byłoby bezpieczne, gdyby to on rządził tym miastem. To nie osusza jego łez.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Z drogi.",
					function getResult()
					{
						return "Success1";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AnotherParty4",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Zgadzasz się sprzedać mężczyźnie szczegóły swojej wyprawy. Jest przesadnie uradowany całą sprawą, ale %employer% już nie. Podobno małe dziecko widziało tę wymianę i doniosło o twojej zdradzie zwierzchnikowi %townname%. Twoja reputacja tutaj bez wątpienia ucierpiała. | Cóż, z jednej strony oszczędziłeś rzekomy rodzinny dom tego człowieka przed zniszczeniem z rąk tych, którzy rządzą %townname%. Z drugiej, ci którzy rządzą %townname% szybko usłyszeli, co zrobiłeś. Powinieneś był bardziej uważać, że populacja małego miasteczka potrafi być wyjątkową maszyną do plotek.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Cóż, %employer% powinien był nam zapłacić więcej.",
					function getResult()
					{
						this.World.Assets.addMoney(this.Flags.get("Bribe"));
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Sprzedałeś lokalizację miejsca zwanego " + this.Flags.get("Location") + " innej osobie");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("Bribe") + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "AnotherParty5",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]Mówisz mężczyźnie, że zachowasz w tajemnicy położenie rodzinnego domu. Gdy on świętuje, idziesz do %employer%a i mówisz mu, gdzie jest %location%. Płaca z obu stron to całkiem słodki interes. Zbieranie nienawiści z obu stron już mniej, ale czego się spodziewali, mając do czynienia z najemnikiem?",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ci ludzie nigdy się nie nauczą.",
					function getResult()
					{
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.Assets.addMoney(this.Flags.get("Bribe"));
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 1.5, "Dałeś informacje przeciwnikowi");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] koron"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("Bribe") + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% wita cię z powrotem. Oddajesz świeżo narysowaną mapę, a on ją studiuję, klepiąc zaznaczone miejsce wierzchem dłoni.%SPEECH_ON%Oczywiście, że to tam!%SPEECH_OFF%Uśmiecha się krzywo i wypłaca ci należność. | Przychodzisz do komnaty %employer%a z nową mapą w ręku. Bierze ją i ogląda.%SPEECH_ON%No proszę. Miałbym powiedzieć, że to miejsce było zbyt łatwe, ale umowa to umowa.%SPEECH_OFF%Wręcza ci sakiewkę dociążoną dokładnie tym, co się należy. | Zdajesz relację %employer%owi, mówiąc, gdzie leży %location%. Kiwając głową, notuje i przepisuje zapiski z twojej mapy. Z ciekawości pytasz, skąd wie, że nie kłamiesz. Mężczyzna siada na krześle i odchyla się, splatając dłonie na brzuchu.%SPEECH_ON%Zainwestowałem w tropiciela, który trzymał się blisko twojej kompanii. Dotarł tu przed tobą i tylko potwierdziłeś to, co już wiem. Mam nadzieję, że nie masz nic przeciwko takim środkom.%SPEECH_OFF%Kiwasz głową, uznając to za rozsądne, bierzesz zapłatę i odchodzisz.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "W pełni zasłużona zapłata.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Najęto cię do odnalezienia miejsca zwanego " + this.Flags.get("Location"));
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] koron"
				});
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		local distance = this.m.Location != null && !this.m.Location.isNull() ? this.World.State.getPlayer().getTile().getDistanceTo(this.m.Location.getTile()) : 0;
		distance = this.Const.Strings.Distance[this.Math.min(this.Const.Strings.Distance.len() - 1, distance / 30.0 * (this.Const.Strings.Distance.len() - 1))];
		_vars.push([
			"region",
			this.m.Flags.get("Region")
		]);
		_vars.push([
			"location",
			this.m.Flags.get("Location")
		]);
		_vars.push([
			"locationC",
			this.m.Flags.get("Location").toupper()
		]);
		_vars.push([
			"townnameC",
			this.m.Home.getName().toupper()
		]);
		_vars.push([
			"direction",
			this.m.Location == null || this.m.Location.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Location.getTile())]
		]);
		_vars.push([
			"terrain",
			this.m.Location != null && !this.m.Location.isNull() ? this.Const.Strings.Terrain[this.m.Location.getTile().Type] : ""
		]);
		_vars.push([
			"distance",
			distance
		]);
		_vars.push([
			"bribe",
			this.m.Flags.get("Bribe")
		]);
		_vars.push([
			"hint_bribe",
			this.m.Flags.get("HintBribe")
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Location != null && !this.m.Location.isNull())
			{
				this.m.Location.getSprite("selection").Visible = false;
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (this.m.Location == null || this.m.Location.isNull() || !this.m.Location.isAlive() || this.m.Location.isDiscovered())
		{
			return false;
		}

		return true;
	}

	function onIsTileUsed( _tile )
	{
		if (this.m.Location != null && !this.m.Location.isNull() && _tile.ID == this.m.Location.getTile().ID)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		if (this.m.Location != null && !this.m.Location.isNull())
		{
			_out.writeU32(this.m.Location.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local location = _in.readU32();

		if (location != 0)
		{
			this.m.Location = this.WeakTableRef(this.World.getEntityByID(location));
		}

		this.contract.onDeserialize(_in);
	}

});

