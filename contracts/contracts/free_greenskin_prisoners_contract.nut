this.free_greenskin_prisoners_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		BattlesiteTile = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.free_greenskin_prisoners";
		this.m.Name = "Uwolnienie Jeńców";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		if (this.m.BattlesiteTile == null || this.m.BattlesiteTile.IsOccupied)
		{
			local playerTile = this.World.State.getPlayer().getTile();
			this.m.BattlesiteTile = this.getTileToSpawnLocation(playerTile, 6, 12, [
				this.Const.World.TerrainType.Shore,
				this.Const.World.TerrainType.Ocean,
				this.Const.World.TerrainType.Mountains
			], false);
		}

		this.m.Payment.Pool = 1350 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 2);

		if (r == 1)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else if (r == 2)
		{
			this.m.Payment.Completion = 1.0;
		}

		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Przeszukaj tropów na polu bitwy na %direction% od %origin%",
					"Uwolnij wszelkich jeńców, których znajdziesz"
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
				if (this.Contract.m.BattlesiteTile == null || this.Contract.m.BattlesiteTile.IsOccupied)
				{
					local playerTile = this.World.State.getPlayer().getTile();
					this.Contract.m.BattlesiteTile = this.getTileToSpawnLocation(playerTile, 6, 12, [
						this.Const.World.TerrainType.Shore,
						this.Const.World.TerrainType.Ocean,
						this.Const.World.TerrainType.Mountains
					], false);
				}

				local tile = this.Contract.m.BattlesiteTile;
				tile.clear();
				this.Contract.m.Destination = this.WeakTableRef(this.World.spawnLocation("scripts/entity/world/locations/battlefield_location", tile.Coords));
				this.Contract.m.Destination.onSpawned();
				this.Contract.m.Destination.setFaction(this.Const.Faction.PlayerAnimals);
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 5)
				{
					this.Flags.set("IsSurvivor", true);
				}
				else if (r <= 10)
				{
					this.Flags.set("IsLuckyFind", true);
				}
				else if (r <= 15)
				{
					this.Flags.set("IsAccident", true);
				}
				else if (r <= 35)
				{
					if (this.Contract.getDifficultyMult() > 0.85)
					{
						this.Flags.set("IsScouts", true);
					}
				}

				r = this.Math.rand(1, 100);

				if (r <= 50)
				{
					this.Flags.set("IsEnemyCamp", true);

					if (this.Math.rand(1, 100) <= 20 && this.Contract.getDifficultyMult() < 1.15)
					{
						this.Flags.set("IsEmptyCamp", true);
					}
				}
				else
				{
					this.Flags.set("IsEnemyParty", true);
				}

				if (this.Math.rand(1, 100) <= 20)
				{
					this.Flags.set("IsAmbush", true);
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (!this.TempFlags.get("IsBattlefieldReached") && this.Contract.isPlayerAt(this.Contract.m.Destination))
				{
					this.TempFlags.set("IsBattlefieldReached", true);
					this.Contract.setScreen("Battlesite1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsScoutsDefeated"))
				{
					this.Flags.set("IsScoutsDefeated", false);
					this.Contract.setScreen("Battlesite2");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Scouts")
				{
					this.World.Contracts.removeContract(this.Contract);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Scouts")
				{
					this.Flags.set("IsScoutsDefeated", true);
				}
			}

		});
		this.m.States.push({
			ID = "Pursuit",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Podążaj za tropem zielonoskórych, wiodącym od pola bitwy",
					"Uwolnij wszelkich jeńców, których znajdziesz"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;

					if (this.Flags.get("IsEmptyCamp"))
					{
						this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
					}
				}
			}

			function update()
			{
				if ((this.Contract.m.Destination == null || this.Contract.m.Destination.isNull()) && !this.Flags.get("IsEmptyCamp"))
				{
					this.Contract.setScreen("Battlesite3");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAmbush") && !this.Flags.get("IsAmbushTriggered") && !this.TempFlags.get("IsAmbushTriggered") && this.Contract.m.Destination.isHiddenToPlayer() && this.Contract.getDistanceToNearestSettlement() >= 5 && this.Math.rand(1, 1000) <= 2)
				{
					this.TempFlags.set("IsAmbushTriggered", true);
					this.Contract.setScreen("Ambush");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAmbushDefeated"))
				{
					this.Contract.setScreen("AmbushFailed");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Ambush")
				{
					this.Flags.set("IsAmbushTriggered", true);
					this.World.Contracts.removeContract(this.Contract);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Ambush")
				{
					this.Flags.set("IsAmbushTriggered", true);
					this.Flags.set("IsAmbushDefeated", true);
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				this.Contract.setScreen("EmptyCamp");
				this.World.Contracts.showActiveContract();
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Wróć z uwolnionymi jeńcami do " + this.Contract.m.Home.getName()
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(null);
				}

				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success1");
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{Gdy znajdujesz %employer%a, pochyla się nad chłopem mówiącym rozpaczliwie ochrypłym głosem. Najwyraźniej zielonoskórzy napadli pobliską wioskę i uprowadzili jeńców. Szlachcic natychmiast wzywa twoich usług: sprowadź tych ludzi z powrotem... oczywiście za odpowiednią cenę. | %employer% wpatruje się w mapy, gdy wchodzisz do jego pokoju. Kilku dowódców stoi u jego boku, używając patyków jako wskaźników do śledzenia i zaznaczania topografii na papierze. Gdy cię widzi, szlachcic natychmiast przywołuje cię bliżej.%SPEECH_ON%Mam problem, najemniku. Zielonoskórzy plądrują te ziemie, jak zapewne zauważyłeś, ale ostatnio otrzymaliśmy raporty, że zabrali jeńców. Nie jesteśmy pewni, dokąd poszli, ale wiemy, gdzie byli widziani po raz ostatni. Jeśli tam pójdziesz, myślę, że zdołasz znaleźć wskazówki, gdzie są teraz. Mam nadzieję, że to cię interesuje, najemniku.%SPEECH_OFF% | Widzisz %employer%a rozmawiającego z chłopem. Kilku strażników trzyma go pod ręce, najwyraźniej przywlekli go przed szlachcica. Zakładasz, że popełnił jakieś przestępstwo, ale to po prostu sposób, w jaki %employer% woli rozmawiać z motłochem. Wieści ludu mówią, że zielonoskórzy napadli okolicę i zabrali jeńców. Pozostawili wystarczająco dużo tropów, by ich odnaleźć nie było trudno, o ile zechcesz podjąć się zadania. | %employer% zapadł się w fotel.%SPEECH_ON%Moi ludzie tracą do mnie wiarę. Mówi się, że zielonoskórzy nie tylko plądrują wioski, ale też biorą jeńców, i chyba to jest jeszcze gorsze! Ale może jeśli ktoś sprowadzi tych ludzi z powrotem, moi poddani znów mi zaufają. Co powiesz, najemniku, pomożesz znaleźć te biedne zagubione dusze? Za odpowiednią zapłatą, oczywiście.%SPEECH_OFF% | %employer% rozmawia z jednym ze swoich dowódców.%SPEECH_ON%Odbijemy ich, nie martw się.%SPEECH_OFF%Gdy cię widzi, szlachcic szybko informuje, że doszło do dużej bitwy z zielonoskórymi i według raportów zabrano jeńców. Dowódca podchodzi, trzymając kciuki za pasem, a wielki miecz brzęczy u jego boku.%SPEECH_ON%Najemniku, byłaby to wielka przysługa, gdybyś sprowadził tych ludzi z powrotem.%SPEECH_OFF% | %employer% kłóci się z jednym ze swoich dowódców.%SPEECH_ON%Spójrz, nie możemy pozwolić sobie na wysyłanie kolejnych ludzi.%SPEECH_OFF%Dowódca wskazuje na ciebie.%SPEECH_ON%A co z nim?%SPEECH_OFF%Szybko zostajesz poinformowany o sytuacji: doszło do dużej bitwy z zielonoskórymi %direction% stąd i zabrano jeńców. %employer% nie ma dość ludzi, by ich szukać, i potrzebuje kogoś o twojej elastyczności, by wykonał to zadanie. | Zastajesz %employer%a wpatrującego się w mapę. Wskazuje na miejsce.%SPEECH_ON%%direction% stąd była duża bitwa z zielonoskórymi. Mamy powody wierzyć, że zabrali jeńców - i mam powody wierzyć, że możesz ich odzyskać.%SPEECH_OFF% | Strażnik kuśtyka do ciebie na kulach. Jego noga kapie krwią na kamienną posadzkę.%SPEECH_ON%Hej, jesteś z %companyname%, tak? %employer% kazał mi się z tobą spotkać.%SPEECH_OFF%Wyjaśnia, że jego ludzie starli się z zielonoskórymi %direction% stąd i że ci mogli uprowadzić grupę jeńców. Pytasz go, czemu nie ma opieki.%SPEECH_ON%Ja, eee, uciekłem z pola. To moja kara. I tak bez znaczenia, aptekarz mówi, że do miesiąca będę martwy. Widzisz to? Paskudne, co?%SPEECH_OFF%Ostrożnie podnosi nogę. Wokół bandaży rosną zielone krosty. To naprawdę paskudne. | %employer% próbuje odebrać psu kałamarz.%SPEECH_ON%Połkniesz to, to zdechniesz, czemu tego nie rozumiesz, ty głupi kundlu?%SPEECH_OFF%Szlachcic dostrzega cię i prostuje się.%SPEECH_ON%Najemniku! Dobrze cię widzieć, bo to naprawdę mroczne czasy. Była bitwa z zielonoskórymi %direction% stąd i moi dowódcy meldują, że bestie zabrały jeńców! Potrzebuję człowieka twojego fachu, by ich odzyskać.%SPEECH_OFF%Gdy to rozważasz, pies połyka kałamarz i natychmiast zaczyna się krztusić. Wypluwa go strumieniem czarnej wymiociny. Pióro spokojnie sunie po wymiotach. %employer% unosi ręce z niedowierzaniem.%SPEECH_ON%Szukałem tego godzinę! To był mój ulubiony, ty przeklęty psie.%SPEECH_OFF% | Zastajesz %employer%a rozwijającego zwój. Czyta go sumiennie, a zamyślony skryba spogląda mu przez ramię. Szlachcic uderza papierem o biurko i gestem przywołuje cię do środka.%SPEECH_ON%Była duża bitwa z zielonoskórymi %direction% stąd i te bestie zabrały jeńców! Jeńców, wyobrażasz to sobie?%SPEECH_OFF%Zanim zdążysz odpowiedzieć, %employer% kontynuuje.%SPEECH_ON%Słuchaj, nie mam ludzi na zbyciu, ale jeśli to prawda, że zielonoskórzy zabrali jeńców, to może ktoś o twoich możliwościach mógłby ich odzyskać?%SPEECH_OFF% | Jeden z dowódców %employer%a spotyka cię przed drzwiami jego pokoju. Wręcza ci zwój z instrukcjami. Według raportu, duża bitwa %direction% stąd zakończyła się zabraniem jeńców przez zielonoskórych. %employer% chce ich odzyskać, ale nie ma żołnierzy, których mógłby wysłać na ratunek. Dowódca krzyżuje ramiona.%SPEECH_ON%Jeśli chcesz negocjować, mój pan upoważnił mnie do tego.%SPEECH_OFF% | Zastajesz %employer%a, który kopie kota po swoim pokoju, goniąc go stopą, aż zwierzak wdrapuje się na sufit, kurczowo trzymając się karnisza. Szlachcic wpatruje się w niego.%SPEECH_ON%Nie sądzę, bym kiedykolwiek znalazł słowa, które oddałyby, jak bardzo nienawidzę tego przeklętego stwora.%SPEECH_OFF%Odwraca się i widzi ciebie.%SPEECH_ON%Najemniku! Miło cię widzieć! Potrzebuję czegoś, i nie, nie chodzi o to przeklęte zwierzę. Moi żołnierze starli się z zielonoskórymi %direction% stąd. Raporty mówią, że bestie zabrały jeńców, co oznacza, że być może da się ich odzyskać. I myślę, że to ty, panie, jesteś człowiekiem do tej roboty.%SPEECH_OFF%Kot miauczy i kuli się na tylnych łapach. %employer% obraca się, wskazując palcem.%SPEECH_ON%Chcę, żebyś zeskoczył na dół! Chcę tego!%SPEECH_OFF% | Wokół %employer%a stoi grupa dowódców. Na biurku leży też ludzka głowa. %employer% spogląda na ciebie.%SPEECH_ON%Oddział żołnierzy starł się z zielonoskórymi %direction% stąd. Przegrali, jeśli nie zauważyłeś. Zabrano też jeńców i jeśli to prawda, mam ogromny interes w sprowadzeniu tych ludzi z powrotem! Myślę, że jesteś idealnym człowiekiem do tej roboty, najemniku, co powiesz?%SPEECH_OFF% | Chudy chłopak stoi obok %employer%a, szkicując mapę i opisując wydarzenia, które widział na własne oczy: oddział żołnierzy starł się z zielonoskórymi %direction% stąd i przegrał. Bestie zabrały potem jeńców i zniknęły. %employer% zwraca się do ciebie.%SPEECH_ON%Cóż, jeśli to, co mówi ten chudy chłop, jest prawdą, musimy tych ludzi odzyskać. Najemniku, co powiesz? Jesteś zainteresowany ratowaniem moich żołnierzy?%SPEECH_OFF% | Zastajesz %employer%a rozmawiającego z płaczącym dowódcą.%SPEECH_ON%Więc pozwól, że to podsumuję. %direction% stąd natknąłeś się na grupę zielonoskórych, przegrałeś, uciekłeś i patrzyłeś, jak kilku twoich ludzi zostało wziętych do niewoli?%SPEECH_OFF%Dowódca przytakuje. %employer% macha ręką do strażników.%SPEECH_ON%Niehonorowe tchórzostwo nie znajdzie nagrody w tych salach, zabierzcie go! A ty, najemniku! Potrzebuję człowieka o twardszej psychice, by wyruszył tam i odzyskał tych jeńców!%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Ufam, że sowicie nas za to wynagrodzisz. | Porozmawiajmy o pieniądzach. | Wszystko da się załatwić, jeśli cena jest odpowiednia.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{To nie jest tego warte. | Jesteśmy potrzebni gdzie indziej.}",
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
			ID = "Battlesite1",
			Title = "Na polu bitwy...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Muchy bzyczą tak głośno, że słyszysz je, zanim poczujesz, czym są zajęte. Horda owadów spadła na pole brudu, plamę grozy, gdzie starli się ludzie i zielonoskórzy, a była rozpacz o zwycięstwo, choć wszyscy przegrali. Przeciskasz się przez chmurę much i każesz %companyname% szukać ocalałych lub wskazówek. | Trupy leżą jeden na drugim. Konie tu i ówdzie. Jeden ucieka w dal, brykając dziko. Smród wyprutych wnętrzności. Każdy krok w krwawą kałużę. %randombrother% podchodzi, przyciskając szmatę do nosa.%SPEECH_ON%Zaczniemy szukać śladów, panie, ale będzie ciężko.%SPEECH_OFF% | Dym, krew i ziemia zamieniona w błoto. Krążysz po polu bitwy, każąc najemnikom rozproszyć się i szukać wskazówek. %randombrother% wpatruje się w zielonoskórego nabitego na złamane widły, a orka, który sam wbił zardzewiałe ostrze w czaszkę swojego zabójcy. Kręci głową.%SPEECH_ON%Jasne. \'Wskazówek\', jakbyśmy musieli się zastanawiać, co tu się stało.%SPEECH_OFF%Przypominasz mu, że zielonoskórzy uprowadzili jeńców i %companyname% ma ich uratować. | %randombrother% spogląda na pole bitwy.%SPEECH_ON%Jesteś pewien, że byli tu jacyś ocaleni do zabrania?%SPEECH_OFF%Rzeczywiście wygląda, jakby ogromna kula ciał uderzyła w ziemię i uczyniła ją krwawą i obcą. Trupy powykręcane i zesztywniałe na wiele sposobów, orki z rozdziawionymi paszczami w wiecznym warkocie, mężczyźni i kobiety rozerwani na strzępy. Konie pogrzebane pośród zwłok z nogami sterczącymi w powietrzu jak krzywe totemy bestialskiej furii. Nie jesteś pewien, czy stąd wzięto jeńców, ale każesz %companyname% rozpocząć poszukiwania. | Jeńcy zabrani stąd byliby jak demony wyciągnięte z piekieł. Patrząc na kopce martwych z powykręcanymi kończynami i wystającymi kośćmi, nie potrafisz sobie wyobrazić, jak ktokolwiek mógł przeżyć. To tak, jakby wielki tłum ludzi i bestii stał razem, a jeszcze większy głaz zniszczenia przetoczył się przez nich wszystkich, a resztki to rozsypka, którą widzisz przed sobą. Niewielu można nazwać nienaruszonymi. %randombrother% przykłada szmatę do twarzy i odgania muchy.%SPEECH_ON%Cóż, chyba zaczniemy szukać tropów. Nie obiecuję jednak niczego.%SPEECH_OFF% | Szukanie tropów tutaj to jak szukanie igły w stogu poćwiartowanych zwłok. %randombrother% opiera dłonie na biodrach i śmieje się z niedowierzaniem.%SPEECH_ON%Ktoś przeżył to gówno, i to jeszcze uznał, że warto brać jeńców?%SPEECH_OFF%Wzruszasz ramionami i każesz %companyname% rozpocząć poszukiwania wskazówek. | Masz wrażenie, że to miejsce było kiedyś spokojnym zakątkiem dla zbiegłych kochanków i bawiących się dzieci. Teraz ziemia zamieniła się w błoto, a martwi leżą na niej licznie jak ślady, które zostawili w swoich chaotycznych końcach. %randombrother% ociera czoło.%SPEECH_ON%Niezłe bagno. No cóż, będziemy grzebać i sprawdzimy, czy da się znaleźć jakieś ślady albo tropy.%SPEECH_OFF% | Natrafiasz na pole bitwy. %randombrother% odchyla się, śmiejąc się z absolutnej grozy przed nim.%SPEECH_ON%Na bogów, co tu się dzieje? Chyba żartujesz!%SPEECH_OFF%Najpierw była bitwa. Ludzie i bestie. Wściekła desperacja. Umierający zabrali ze sobą wielu. Potem przyszedł deszcz. Stratowana ziemia zamieniła się w błoto. Zakrwawione pola w dosłowną krwawą łaźnię. A teraz wy, najemnicy, świadkowie, brodzicie w spienionej czerwieni, podsumowując resztki totalnej ruiny. Kręcisz głową i zaczynasz rozkazywać ludziom.%SPEECH_ON%Jesteśmy tu po tropy. Szukajcie śladów prowadzących na zewnątrz. To, co przeżyło, zabrało jeńców.%SPEECH_OFF% | Nie widzisz tu tyle ciał, co części. Rozsypkę wskazówek, że pewnego dnia i o pewnej porze spotkali się tu ludzie i bestie, a w swej dzikości zniszczyli każdą myśl, że wojownicy byli kiedyś całością. %randombrother% podnosi czubkiem kija but, z którego wysuwa się stopa. Kręci głową.%SPEECH_ON%Dobra, możemy zacząć szukać tropów, ale będę cholernie zdziwiony, jeśli ktoś tu przeżył, a tym bardziej, że wziął jeńców.%SPEECH_OFF% | %randombrother% spogląda na pole bitwy.%SPEECH_ON%Cholera.%SPEECH_OFF%Znajdujesz resztki walki, masę zmasakrowanych zielonoskórych i ludzi zlepionych w skręconą, krwawą ceremonię. Konie stoją z boku, wyciągając głowy ku scenie z niepewną ciekawością. Rozbiegają się, gdy twoi ludzie zaczynają przeszukiwać teren w poszukiwaniu wskazówek. Wydajesz rozkaz.%SPEECH_ON%Pamiętajcie, zielonoskórzy zabrali jeńców! Szukajcie tropów, ludzie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Szukać wszędzie!",
					function getResult()
					{
						if (this.Flags.get("IsAccident"))
						{
							return "Accident";
						}
						else if (this.Flags.get("IsLuckyFind"))
						{
							return "LuckyFind";
						}
						else if (this.Flags.get("IsSurvivor") && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
						{
							return "Survivor";
						}
						else if (this.Flags.get("IsScouts"))
						{
							return "Scouts";
						}
						else
						{
							return "Battlesite2";
						}
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Battlesite2",
			Title = "Na polu bitwy...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{%randombrother% znalazł zestaw tropów prowadzących z pola bitwy. %companyname% powinno za nimi podążyć! | Znaleziono tropy prowadzące z pola bitwy. Wśród większych śladów orków widać mniejsze, ludzkie odciski. Jeśli podążycie za nimi, najpewniej znajdziecie jeńców. | %randombrother% kuca nisko przy ziemi i woła cię. Wskazuje odciski w ziemi.%SPEECH_ON%Jak to wygląda, panie?%SPEECH_OFF%Widzisz mniejsze odciski butów i znacznie, znacznie większe stopy. Są też serie drobnych śladów biegnących z boku. Wskazujesz i oceniasz kolejno.%SPEECH_ON%Człowiek, ork, goblin. Mówię, że jeśli podążymy za tymi tropami, to możemy znaleźć jeńców.%SPEECH_OFF% | Potykasz się, a raczej wpadasz, na duży zestaw śladów. Sądząc po grubych palcach i braku butów, to ślady orków. Jednak obok nich są tropy, które rozpoznajesz od razu. %randombrother% podchodzi.%SPEECH_ON%Wygląda na to, że to nasz ślad, panie. Podążymy za nimi, a jeńcy nie będą daleko od lepszych dni.%SPEECH_OFF% | Kucasz i przyglądasz się serii tropów. Ludzie, orki, gobliny. Wszystkie świeże i prowadzące z pola bitwy. Jeśli się za nimi podąży, najpewniej doprowadzą do jeńców. | Odciski stóp masy orków i goblinów prowadzą z pola bitwy. Wzdłuż nich biegną świeże ludzkie ślady. %randombrother% spluwa i przytakuje.%SPEECH_ON%To jest to, czego szukamy. Podążymy za tymi tropami i może znajdziemy jeńców. Znaczy, pewnie są martwi jak moja babka, a ona zginęła na dobre w osuwisku, ale i tak warto poszukać.%SPEECH_OFF% | %randombrother% ogłasza niezwykle ważne odkrycie: serię odcisków, człowieka i bestii, prowadzących z pola bitwy. Jeśli %companyname% za nimi podąży, znalezienie jeńców nie powinno być daleko. | Zbliża się mężczyzna z widłami, wbijając je w ziemię jak podpórkę, gdy podchodzi pod górę. Krzyczy, byś podszedł, co powoli czynisz. Mężczyzna uśmiecha się, gdy jesteś blisko.%SPEECH_ON%Szukasz jeńców, prawda?%SPEECH_OFF%Przeżuwa źdźbło słomy między zębami, albo tym, co za nie uchodzi. Wskazuje.%SPEECH_ON%Tam, na błotnistej ścieżce, są tropy. Nie wiem, czemu bestie zostawiły ślady swoich przyjść i odejść, ale chyba dlatego nazywa się je bestiami, co?%SPEECH_OFF%Dziękujesz rolnikowi za pomoc i, tak jak mówił, wkrótce znajdujesz tropy prowadzące z pola bitwy. %companyname% powinno za nimi podążyć, by odnaleźć jeńców. | Podczas przeszukiwania pola bitwy %randombrother% przestrasza się dzieciaka, który wyskakuje z trupa z rękami rozłożonymi przy głowie jak jakaś chorowita roślina, która ożyła, by pożerać. Najemnik dobywa broni.%SPEECH_ON%Zapłacisz za to, mały gówniarzu!%SPEECH_OFF%Powstrzymujesz go i pytasz chłopca, co robi. Maluch wzrusza ramionami.%SPEECH_ON%Bawię się. A powiedz, nie chciałbyś wiedzieć, dokąd poszli zieloni, co?%SPEECH_OFF%Oczywiście, że chcesz. Dzieciak prowadzi cię do serii tropów: ludzkich, orczych i goblińskich. Wszystkie świeże. Mówisz mu, żeby wracał do domu, bo tu niebezpiecznie. Przewraca oczami.%SPEECH_ON%{No proszę, ale piękne \'dzięki\' mi pan dał. | No cóż, panie, nie ma za co. Myślałem, że jestem tu dla zabawy, ale wygląda na to, że moim prawdziwym celem było czekać, aż się pan pojawi. | Świetnie, myślałem, że uciekłem od matki, a tu i tak jest, do cholery.}%SPEECH_OFF% | Zaczynasz tracić nadzieję na znalezienie czegokolwiek, gdy nadchodzi młoda kobieta z koszem. Zbiera z trupów strzępy szmat, wyciskając z nich krew. Pytasz, czy coś widziała. Przytakuje.%SPEECH_ON%Pewnie, że coś widziałam, mam oczy, nie? Mam też coś w głowie i dobrze mi zasugerowano, że pan, panie, szuka jeńców, których te zielone gnidy zabrały.%SPEECH_OFF%Przytakujesz i pytasz, dokąd poszli. Wskazuje w dół wzgórza.%SPEECH_ON%Widzisz ten szlak? Są na nim tropy. Bestie zostawiły sporo śladów, dokąd szły. Ja bym za nimi nie poszła, ale ty wyglądasz na twardziela. A powiedz, co to za materiał?%SPEECH_OFF%Wskazuje na sztandar %companyname%. Wzruszasz ramionami. Ona też wzrusza.%SPEECH_ON%No, ładny. Jak zobaczysz coś podobnego, to mi powiedz, dobra? Szykuję suknię na wesele.%SPEECH_OFF% | Mężczyzna idzie ciężko ścieżką, machając nogami jak żołnierz, a z biodra zwisa mu pęk martwych ryb. Zatrzymuje się na twój widok.%SPEECH_ON%Pozwól, że zgadnę, szukasz, dokąd poszli jeńcy, co?%SPEECH_OFF%Kiwasz głową i pytasz, czy widział, gdzie poszli. Kręci głową, ale wskazuje pod nogi.%SPEECH_ON%Nie, panie, nie do końca. Ale tropy są tutaj. Widzisz, człowiek i zielonoskóry. To może mieć z tym coś wspólnego, nie sądzisz?%SPEECH_OFF%Owszem. Każesz %companyname% przygotować się do marszu. | Na polu bitwy nie ma wskazówek, ale tuż obok już tak: znajdujesz serię tropów przeplataną odciskami ludzi i zielonoskórych. Bez wątpienia doprowadzą do jeńców lub przynajmniej do tych, którzy ich zabrali. | %randombrother% woła cię. U jego stóp widać serię dużych odcisków i kilka coraz mniejszych. Łączą się w ciąg prowadzący z pola bitwy. Najemnik zerka na ciebie.%SPEECH_ON%Jak nic, to jeńcy, tam orki, a te małe ślady obok to gobbosy.%SPEECH_OFF%Kiwasz głową i krzyczysz do %companyname%, by przygotowali się do podążenia śladami. | %randombrother% znajduje kilka tropów tuż poza polem bitwy. Podchodzisz, by je obejrzeć, a on wskazuje po kolei ich różne rozmiary.%SPEECH_ON%Te chyba należą do orków, te do goblinów, a te... to jeńcy, których szukamy.%SPEECH_OFF%Zgadzasz się z jego oceną. Jeśli %companyname% podąży tymi tropami, najpewniej znajdzie jeńców i ich porywaczy.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ruszajmy!",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						local playerTile = this.World.State.getPlayer().getTile();
						local nearest_goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(playerTile);
						local nearest_orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(playerTile);
						local camp;

						if (nearest_goblins.getTile().getDistanceTo(playerTile) <= nearest_orcs.getTile().getDistanceTo(playerTile))
						{
							camp = nearest_goblins;
						}
						else
						{
							camp = nearest_orcs;
						}

						if (this.Flags.get("IsEnemyParty"))
						{
							local tile = this.Contract.getTileToSpawnLocation(playerTile, 10, 15);
							local party = this.World.FactionManager.getFaction(camp.getFaction()).spawnEntity(tile, "Horda Zielonosk\x0480rych", false, this.Const.World.Spawn.GreenskinHorde, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
							party.getSprite("banner").setBrush(camp.getBanner());
							party.setDescription("Horda zielonoskórych, maszerująca na wojnę.");
							party.setFootprintType(this.Const.World.FootprintsType.Orcs);
							this.Contract.m.UnitsSpawned.push(party);
							party.getLoot().ArmorParts = this.Math.rand(0, 25);
							party.getLoot().Ammo = this.Math.rand(0, 10);
							party.addToInventory("supplies/strange_meat_item");
							this.Contract.m.Destination = this.WeakTableRef(party);
							party.setAttackableByAI(false);
							party.setFootprintSizeOverride(0.75);
							local c = party.getController();
							c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
							local wait = this.new("scripts/ai/world/orders/wait_order");
							wait.setTime(15.0);
							c.addOrder(wait);
							local roam = this.new("scripts/ai/world/orders/roam_order");
							roam.setPivot(camp);
							roam.setMinRange(5);
							roam.setMaxRange(10);
							roam.setAllTerrainAvailable();
							roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
							roam.setTerrain(this.Const.World.TerrainType.Shore, false);
							roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
							c.addOrder(roam);
						}
						else
						{
							this.Contract.m.Destination = this.WeakTableRef(camp);
							camp.clearTroops();

							if (this.Flags.get("IsEmptyCamp"))
							{
								camp.setResources(0);
								this.Contract.m.Destination.setLootScaleBasedOnResources(0);
							}
							else
							{
								this.Contract.m.Destination.setLootScaleBasedOnResources(120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());

								if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
								{
									this.Contract.m.Destination.getLoot().clear();
								}

								camp.setResources(this.Math.min(camp.getResources(), 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
								this.Contract.addUnitsToEntity(camp, this.Const.World.Spawn.GreenskinHorde, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
							}
						}

						this.Const.World.Common.addFootprintsFromTo(playerTile, this.Contract.m.Destination.getTile(), this.Const.OrcFootprints, this.Const.World.FootprintsType.Orcs, 0.75, 10.0);
						this.Contract.setState("Pursuit");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Battlesite3",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Zielonoskórzy pokonani, ruszasz do ich obozu i znajdujesz jeńców uwięzionych i z zawiązanymi oczami. Każesz najemnikom ich uwolnić. Myśląc, że już są martwi, większość jeńców wybucha płaczem i dziękuje za ratunek. Ot, zwykły dzień w pracy. | Zielonoskórzy zostali pokonani i szybko wkraczasz do ich obozu. Znajdujesz jeńców w namiocie, skulonych i nagich. Uwolnieni ledwo mówią, ale ich oczy wiele mówią o okropnościach, które przeżyli. %randombrother% idzie po koce, by okryć ich na drogę powrotną do zleceniodawcy, %employer%a. | Z zielonoskórymi rozprawiono się, więc ty i twoi ludzie zaczynacie przeszukiwać ich porzucony obóz. Natychmiast słyszysz krzyki dobiegające z namiotu. %randombrother% odsuwa płachtę i widzi goblina machającego rozżarzonym żelazem przed grupą skulonych, nagich mężczyzn. Najemnik jednym cięciem odcina mu głowę, zanim stwór zrozumie odmianę losu. Jeńcy krzyczą z wdzięczności za ratunek. Twój zleceniodawca, %employer%, powinien być bardzo zadowolony, że przynajmniej część jego ludzi wróci do domu. | Zielonoskórzy pokonani, ty i %companyname% pędzicie do ich obozowiska. Tam widzisz goblina szturchającego człowieka, który zmarł od tortur. %randombrother% łapie niczego nieświadomego goblina i przebija mu tył czaszki ostrzem. Idziesz śladem krwi do pobliskiego namiotu, gdzie znajduje się grupa mężczyzn z zawiązanymi oczami, skulonych razem. Cofają się na dźwięk twojego głosu, ale szybko dajesz im do zrozumienia, że jesteś tu, by pomóc. Biedne dusze wiele przeszły. Odprowadzenie ich do zleceniodawcy, %employer%a, i do domów powinno pomóc w powrocie do zdrowia. | Wszelkie nadzieje zielonoskórych na zwycięstwo w tej walce legły w gruzach: te bestie są zupełnie martwe.\n\nRozkazujesz ludziom przeszukać obóz, by znaleźć jeńców. Nie mija dużo czasu, a %randombrother% odnajduje mężczyzn skulonych pod namiotem. Zostali pobici i torturowani, ale przeżyją. Kilku dziękuje tobie, a większość starym bogom. Przeklęte bóstwa znów kradną ci blask. Tak czy inaczej, twój zleceniodawca, %employer%, będzie bardzo zadowolony. | %companyname% rozprawia się z zielonoskórymi bez trudu i szybko wpada do ich porzuconego obozowiska. Okropności tam są nie do pojęcia. Ludzie nadziani na rożna, inni wbici jak namiotowe tyczki w niebo na końcach ogromnych pali. Na szczęście w tej ciemności wciąż jest światło: odnajdujecie jeńców, których szukaliście. Są ciężko pobici, ale żyją. | Zielonoskórzy zostali pokonani. Wchodzisz do ich obozowiska i widzisz świeżo czerwone okropności. Odarte ze skóry postacie wiszą na stojakach z poskręcanych cierni i gałęzi. Szare ciała wypatroszone, a ich wychudzone, rozciągnięte twarze wciąż świadczą o najbardziej groteskowym końcu. Więcej ludzi znajduje się w płytkim rowie, związanych twarzami w dół w spienionych wodach, z wielkimi głazami położonymi na plecach, tak by utopili się, mając oddech na wyciągnięcie dłoni.\n\nNie tylko martwisz się, że nie ma ocalałych, ale część ciebie ma nadzieję, że tak właśnie jest. Takie okropności nie powinny iść w świat. Niestety, %randombrother% wzywa cię do namiotu. W środku kilku jeńców kuli się, nagich i cofających się przed twoją obecnością. Każesz %companyname% ubrać ich, nakarmić i napoić na drogę powrotną do zleceniodawcy, %employer%a. | %companyname% pokonuje zielonoskórych bez większych trudności i wchodzi do obozu bestii. Tam znajdujesz ludzi przerobionych na święte totemy, wielkie obeliski z lśniącej kości i kopce przechylonych czaszek. %randombrother% woła cię do jednego z namiotów z koziej skóry. Pędzisz tam i znajdujesz kilku jeńców, każdy zamknięty w klatce z ciasno powyginanych metalowych kolców. Ostrożnie uwalniacie każdego z nich, a każdy opowiada o okropnościach, które zniósł. Zapewniasz ich, że zostaną odesłani do rodzin. | Po pokonaniu zielonoskórych szybko wpadasz do ich obozu, by znaleźć jeńców. Widzisz ich przykutych do długiego czarnego łańcucha. Cherlawy ork o krzywych oczach i zniekształconych dłoniach próbuje ich wyprowadzić. %randombrother% rusza naprzód i uderza zielonoskórego maczugą w tył głowy. Stwór pada na ziemię i przewraca się na bulwiasty grzbiet. Zdeformowana bestia wydaje nieuczony krzyk, jakaś ułomność języka nawet ponad brutalną orczą mowę. %randombrother% zawaha się na chwilę, oczy orka są jedynym świadkiem świata, którego nigdy nie zrozumiał, po czym mężczyzna zaciska zęby i miażdży mu czaszkę.\n\nUwalniasz jeńców, którzy wyjaśniają, że mieli zostać wywiezieni przez kogoś, kto mógł być plemiennym idiotą. Tak czy inaczej, są już uratowani, a %employer% będzie bardzo zadowolony, że ich odzyskał! | Zielonoskórzy zostali pokonani, a jeńcy szybko uratowani z obozu bestii. Każdy jeniec ma historię grozy do opowiedzenia, nawet ci, którzy nie mówią ani słowa. Twój zleceniodawca, %employer%, będzie bardzo zadowolony. | Twój zleceniodawca, %employer%, zapewne nie wierzył, że to się uda, ale po pokonaniu zielonoskórych i wtargnięciu do ich obozu udaje ci się uratować jeńców! Nie są w najlepszym stanie, ale widok %companyname% zamiast orka z pochodnią czy toporem kata zdecydowanie podniósł ich na duchu. | Po pokonaniu zielonoskórych %companyname% szybko pędzi do obozowiska bestii. Tam znajdujesz jeńców przywiązanych linami do słupa na niedźwiedzie harce. Jeden martwy niedźwiedź leży w błocie, wraz z kilkoma straszliwie okaleczonymi mężczyznami. Ocalali, którzy najwyraźniej zabili zwierzę gołymi rękami, powinni zostać jak najszybciej odprowadzeni do twojego zleceniodawcy w %townname%. | %companyname% triumfuje nad zielonoskórymi i pędzi, by odnaleźć jeńców w obozowisku bestii. Nie jesteś pewien, czy żołnierze kiedykolwiek będą zdolni do walki, ale miejmy nadzieję, że zleceniodawca, %employer%, mimo to zadba o nich.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Mamy to, po co przyszliśmy. Czas wracać do %townname%!",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Scouts",
			Title = "Na polu bitwy...",
			Text = "[img]gfx/ui/events/event_49.png[/img]{Krążąc między zwłokami w poszukiwaniu wskazówek, zostajesz nagle zaatakowany przez grupę zielonoskórych! Prawdopodobnie wrócili, by złupić pole bitwy. Szybko ustawiasz ludzi w szyku, a bestie robią to samo. | Zwiadowcza grupa zielonoskórych, która chciała ograbić pole bitwy, zamiast tego natyka się na %companyname%. Przygotuj się do walki! | Przeszukując teren w poszukiwaniu tropów, mała grupa zielonoskórych wpada na %companyname%. Prawdopodobnie wracali po łupy, ale teraz dołączycie ich do stosu trupów! | %companyname% szuka wskazówek, gdy na pole bitwy wraca banda zielonoskórych rabusiów! | Przewracasz ciało i goblin gapi się na ciebie. Próbujesz kopnąć i to ciało, ale ono warczy i chwyta cię za stopę. Nie jest martwy! Podnosisz wzrok i widzisz równie zaskoczoną grupę zielonoskórych rabusiów wpatrujących się w ciebie. Goblin krzyczy i cofa się, a ty również szybko się wycofujesz, rozkazując %companyname% ustawić się w szyku.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "Scouts";
						p.Music = this.Const.Music.GoblinsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						local nearest_goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(tile);
						local nearest_orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(tile);
						local camp;

						if (nearest_goblins.getTile().getDistanceTo(tile) <= nearest_orcs.getTile().getDistanceTo(tile))
						{
							camp = nearest_goblins;
						}
						else
						{
							camp = nearest_orcs;
						}

						p.EnemyBanners.push(camp.getBanner());
						p.Entities = [];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.GreenskinHorde, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivor",
			Title = "Na polu bitwy...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{%randombrother% grzebie w ciałach, gdy nagle odskakuje.%SPEECH_ON%Panie! Tu jest żywy!%SPEECH_OFF%Podbiegasz i widzisz mężczyznę wygrzebującego się z kłębu kończyn. Chwiejąc się, staje na nogi, a jego zakrwawiona twarz marszczy się w świetle. Mężczyzna mówi, że walczył w tej bitwie - i że ma pełny zamiar ją dokończyć. Najwyraźniej dołączy do %companyname% za darmo! | Przeszukując szczątki pola bitwy, nagle słyszysz krzyk spod zwłok. %randombrother% zaczyna zrzucać ciała, aż znajdujesz twarz mężczyzny, który uśmiecha się do ciebie.%SPEECH_ON%Na starych bogów, myślałem, że tam umrę.%SPEECH_OFF%Pytasz, czy walczył w tej bitwie, a on potwierdza. Wyciąga rękę, a ty wyciągasz go ze stosu. Wychodzi, zeskrobując z ramion krew i wnętrzności. Widząc sztandar %companyname%, pyta, czy macie miejsce dla jednego więcej.%SPEECH_ON%Mam trochę niedokończonych spraw, na pewno rozumiesz.%SPEECH_OFF% | Byłeś przekonany, że nie ma tu nic poza martwymi: %randombrother% znalazł ocalałego zakopanego pod stosami ciał. Podchodzisz do niego, wojownika, który chwieje się na zwłokach poległych. Mruży oczy, gdy łapie orientację.%SPEECH_ON%Ach, rozpoznaję ten znak. Jesteście %companyname%. Panowie, niewiele mnie tu trzyma i nigdy nie lubiłem sprzątać bałaganu. Co powiecie, jeśli do was dołączę?%SPEECH_OFF% | Ocalały wystawia głowę spod pachy orczego wojownika. Łapie powietrze, gdy ty i %randombrother% pomagacie go wyciągnąć. %randombrother% daje mu łyk wody, a ty pytasz, czy są inni ocalałych. Wzrusza ramionami.%SPEECH_ON%Cóż, przez jakiś czas krzyczeli, ale już nie. Powiedz, jesteście z %companyname%?%SPEECH_OFF%Mężczyzna wyciera usta i wskazuje sztandar kompanii. Kiwasz głową. On też i bierze kolejny łyk.%SPEECH_ON%Cóż, najemnicy, nie ma już dla mnie nic tutaj. Już nie. Mam nadzieję, że to nie za wiele, ale może mógłbym dołączyć do waszej kompanii?%SPEECH_OFF% | Znalazłeś ocalałego! Mężczyzna wygrzebuje się ze stosu zwłok jak robak pełznący z kosza zgniłych jabłek. Wyciera krew i szarą posokę z twarzy i śmieje się.%SPEECH_ON%Leżałem tam, myśląc, że zielonoskórzy wrócą, ale wy, chłopaki, to prawdziwa ulga dla oczu!%SPEECH_OFF%Gdy %randombrother% podaje mu wodę, pytasz, czy byli inni ocalali. Kiwając głową, odpowiada.%SPEECH_ON%Tak, ale wzięli ich do niewoli, starzy bogowie wiedzą, co się z nimi stało. Powiedz, jeśli to sztandar %companyname%, który widzę, czy miałbyś coś przeciwko, gdybym dołączył do kompanii? Jak pewnie zauważyłeś, nie ma tu już dla mnie nic.%SPEECH_OFF% | Mężczyzna wstaje spośród martwych, jakby was oczekiwał. %randombrother% odskakuje przestraszony, dobywając broni. Ocalały przyjaźnie macha.%SPEECH_ON%Muszę przyznać, że nie spodziewałem się waszej bandy. Byłem pewien, że zielonoskórzy wrócą, by ograbić to, co zostało. Powiedz, czy to sztandar %companyname%, który tam niesiecie?%SPEECH_OFF%Odpowiadasz, że tak. Klaszcze w dłonie i rusza do przodu, potykając się o czaszki i poćwiartowane kończyny oraz zsuwając stopy po krwistym błocie.%SPEECH_ON%Co za szczęście! Potrzebuję nowego przyodziewku i jeśli to nie problem, chętnie dołączę do waszej kompanii!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Witaj w kompanii!",
					function getResult()
					{
						this.World.getPlayerRoster().add(this.Contract.m.Dude);
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude.onHired();
						this.Contract.m.Dude = null;
						return "Battlesite2";
					}

				},
				{
					Text = "Nie ma mowy. Zmykaj stąd.",
					function getResult()
					{
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude = null;
						return "Battlesite2";
					}

				}
			],
			function start()
			{
				local roster = this.World.getTemporaryRoster();
				this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
				this.Contract.m.Dude.setStartValuesEx(this.Const.CharacterVeteranBackgrounds);
				this.Contract.m.Dude.setHitpointsPct(0.6);

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).setArmor(this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).getArmor() * 0.33);
				}

				if (this.Contract.m.Dude.getTitle() == "")
				{
					this.Contract.m.Dude.setTitle("Ocalały");
				}

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Accident",
			Title = "Na polu bitwy...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Przeszukiwanie pola bitwy nie należy do najbezpieczniejszych zajęć i ta zasada daje o sobie znać, gdy %hurtbro% robi sobie krzywdę. | %hurtbro% poślizgnął się i wpadł na stertę broni. Naturalnie trochę ucierpiał. | Niestety %hurtbro% poślizgnął się na krwawym błocie i upadł twarzą prosto w otwartą paszczę orczego wojownika. Odniósł kilka obrażeń. | Pola bitew są niebezpieczne długo po zakończeniu walk: %hurtbro% poślizgnął się i upadł. Jest tylko trochę potłuczony, będzie dobrze. | Wiedziałeś, że jeden z tych idiotów w końcu się poślizgnie: %hurtbro% postawił stopę na tarczy, która natychmiast zsunęła się po stercie zwłok. Wpadł prosto na stertę broni i poniósł oczywiste konsekwencje. | %hurtbro% krzyczy.%SPEECH_ON%Hej, patrzcie na to!%SPEECH_OFF%Skacze na tarczę i zaczyna zjeżdżać po stercie zwłok. Niestety ogromna orcza dłoń zahacza tarczę i wprawia go w obroty. Spada do tyłu z tarczy i ląduje na stercie broni. Jęczy z bólu. %randombrother% krzyczy.%SPEECH_ON%{Widziałem, co zrobiłeś. | Nie ma tu żadnych dam do popisu, ty matole.}%SPEECH_OFF% | %hurtbro% podnosi zardzewiałe orcze ostrze i próbuje się nim posłużyć. Niestety potyka się o jego dawnego właściciela i w czasie upadku się kaleczy. Idiota wyleczy się z czasem. | Widzisz, jak %hurtbro% podnosi i testuje różne orcze bronie. Na moment odwracasz wzrok, a ten cholerny głupiec robi sobie krzywdę. Odwracasz się i widzisz, jak leży skulony i jęczy z bólu. Nic poważnego, ale cholera, chciałbyś, żeby ci idioci byli ostrożniejsi. | Pomimo tego, że kazałeś ludziom uważać, %hurtbro% zdołał poślizgnąć się i upaść na twarz orka, co właściwie było równoznaczne z upadkiem na prawdziwą broń. Jest ranny, ale przeżyje. | %hurtbro% podnosi małego goblina i bawi się nim jak marionetką. Duch zielonoskórego musiał się obrazić, bo najemnik ślizga się na porzuconej tarczy i leci do tyłu, a martwy goblin koziołkuje w powietrzu. Najemnik jest ranny, ale przeżyje.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bądź ostrożniejszy.",
					function getResult()
					{
						this.Contract.m.Dude = null;
						return "Battlesite2";
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local bro = brothers[this.Math.rand(0, brothers.len() - 1)];
				local injury = bro.addInjury(this.Const.Injury.Accident1);
				this.Contract.m.Dude = bro;
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = bro.getName() + " cierpi na " + injury.getNameOnly()
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "LuckyFind",
			Title = "Na polu bitwy...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Nie sądziłeś, że ludzie znajdą cokolwiek wartościowego, grzebiąc po polu bitwy, ale okazuje się, że %randombrother% znalazł potężną broń! | Podczas przeszukiwania pozostałości pola bitwy %randombrother% odkrywa wyjątkowo dobrze wykonaną broń, która jakimś cudem przetrwała rzeź w nienaruszonym stanie! | Znaleziono potężną broń! %randombrother% z radością unosi ją wysoko, by wszyscy mogli zobaczyć. | %randombrother% zaczyna grzebać w stercie broni. Mówisz mu, żeby przestał, zanim się skaleczy i straci kończynę. Nagle prostuje się, trzymając w dłoniach dziwnie wyglądającą relikwię bitewną.%SPEECH_ON%No i co teraz, panie?%SPEECH_OFF%Dobra, tym razem wygrał. | Ostrzegasz ludzi, by wypatrywali tropów prowadzących z pola bitwy, ale %randombrother% zaczyna grzebać w stosach zwłok, szukając czegoś do zrabowania. Gdy już masz mu powiedzieć, że zaraz zrobi sobie krzywdę, mężczyzna prostuje się z bardzo ładnie wyglądającą bronią w ręku. Dajesz mu kciuka w górę.%SPEECH_ON%Dobra robota, najemniku!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niezłe znalezisko.",
					function getResult()
					{
						return "Battlesite2";
					}

				}
			],
			function start()
			{
				local item;
				local r = this.Math.rand(1, 10);

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/greatsword");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/greataxe");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/billhook");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/noble_sword");
				}
				else if (r == 5)
				{
					item = this.new("scripts/items/weapons/warbrand");
				}
				else if (r == 6)
				{
					item = this.new("scripts/items/weapons/two_handed_hammer");
				}
				else if (r == 7)
				{
					item = this.new("scripts/items/weapons/greenskins/orc_axe_2h");
				}
				else if (r == 8)
				{
					item = this.new("scripts/items/weapons/greenskins/orc_cleaver");
				}
				else if (r == 9)
				{
					item = this.new("scripts/items/weapons/greenskins/named_orc_cleaver");
				}
				else if (r == 10)
				{
					item = this.new("scripts/items/weapons/greenskins/named_orc_axe");
				}

				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Ambush",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_48.png[/img]{Gdy podążasz za tropami, nagle z zarośli wyskakuje zielonoskóry i wrzeszczy. Wokół ciebie wybiegają kolejni. To zasadzka! | Podążasz za tropami, ale zauważasz coś nie tak. Kucasz i zaczynasz zmiatać kurz oraz liście z odcisku. Jest skierowany w przeciwną stronę. Ktoś, kto zostawił te ślady, zawrócił, co oznacza...\n\n%randombrother% kończy twoją myśl, wskazując i krzycząc.%SPEECH_ON%Zasadzka! Zielonoskórzy!%SPEECH_OFF% | Trafiasz na parę tropów, które nagle rozchodzą się w losowych kierunkach. Podążając za nimi, zauważasz, że znikają w krzakach otaczających ścieżkę. Wzdychasz i każesz ludziom szykować się do walki. Nim słowa opuszczą twoje usta, z zarośli wybiega banda zielonoskórych w zasadzce! | Rzeczy nie są takie, jak się wydają... I właśnie w tej chwili %randombrother%, z wytrzeszczonymi oczami i poparzoną słońcem twarzą, krzyczy.%SPEECH_ON%To pułapka!%SPEECH_OFF%Zielonoskórzy wysypują się z okolicznych krzaków. To zasadzka! Szybko ustawiasz ludzi w szyku. | Tropów łatwo się trzyma, aż za łatwo, jeśli być szczerym - zanim skończysz tę myśl, zielonoskóry wyskakuje z krzaków i warczy. Po drugiej stronie ścieżki inni robią to samo. To była ustawka! Szykować się do walki! | Zauważasz rozgałęzienie tropów. Część prowadzi prosto, a inne skręcają i znikają w krzakach wzdłuż ścieżki. Nie trzeba geniusza, by zrozumieć, co się dzieje: wydajesz rozkazy, by ludzie ustawili się w szyku. Na znak grupy zielonoskórych z krzykiem wyskakują z krzaków, by urządzić zasadzkę na %companyname%. Szykować się do walki! | Tropy znikają pod twoimi stopami i dokładnie wiesz, co to znaczy. Podnosząc głos, każesz ludziom ustawić się w szyku. Zielonoskórzy wysypują się z krzaków, wrzeszcząc jak banshee. To zasadzka! | Tropy prowadzą dalej, ale zauważasz ślady naruszonej ziemi tuż obok. Każesz ludziom zatrzymać się i kucnąć, by zbadać teren. Gdy odgarniesz liście i ziemię, powoli odsłaniasz tropy, które w rzeczywistości prowadzą w przeciwną stronę. Zielonoskórzy zawrócili... %randombrother% wrzeszczy.%SPEECH_ON%Zasadzka! Zasadzka!%SPEECH_OFF%Odwracasz się i widzisz bestie wysypujące się z krzaków z bronią uniesioną wysoko i z zamiarem przemocy. Szybko przejmujesz dowodzenie i rozkazujesz ludziom ustawić się w szyku. Szykować się do walki!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "Ambush";
						p.Music = this.Const.Music.GoblinsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						local nearest_goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(tile);
						p.EnemyBanners.push(nearest_goblins.getBanner());
						p.Entities = [];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.GoblinRaiders, 125 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "AmbushFailed",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Zasadzka rozbita, ruszasz do obozu zielonoskórych i znajdujesz jeńców uwięzionych i z zawiązanymi oczami. Każesz najemnikom ich uwolnić. Myśląc, że już są martwi, większość jeńców wybucha płaczem i dziękuje za ratunek. Ot, zwykły dzień w pracy. | Zasadzka zielonoskórych nie powiodła się, więc wkraczasz do ich obozu. Każdy czający się zielonoskóry szybko ucieka, porzucając wszystko. Znajdujesz jeńców w namiocie, skulonych i nagich. %randombrother% idzie po koce, by okryć ich na drogę powrotną do %employer%a. Uwolnieni ledwo mówią, ale ich oczy wiele mówią o okropnościach, które przeżyli. | Z zasadzką rozprawiono się, więc ty i twoi ludzie zaczynacie przeszukiwać porzucony obóz zielonoskórych. Natychmiast słyszysz krzyki z namiotu. %randombrother% odsuwa płachtę i widzi goblina machającego rozżarzonym żelazem przed grupą skulonych, nagich mężczyzn. Najemnik jednym cięciem odcina mu głowę. Jeńcy krzyczą z wdzięczności za ratunek. %employer% powinien być bardzo zadowolony, że przynajmniej część jego ludzi wróci do domu. | Zasadzka rozbita, ty i %companyname% pędzicie do obozowiska zielonoskórych. Tam widzisz goblina szturchającego człowieka, który najwyraźniej umarł od tortur. %randombrother% łapie niczego nieświadomego goblina i tłucze go na śmierć. Przeszukujesz pobliski namiot i znajdujesz grupę mężczyzn z zawiązanymi oczami, skulonych w kącie. Cofają się na dźwięk twojego głosu, ale szybko dajesz im do zrozumienia, że jesteś tu, by pomóc. Biedne dusze wiele przeszły. Odprowadzenie ich do %employer%a i do domów powinno pomóc w powrocie do zdrowia. | Wszelkie nadzieje zielonoskórych na zwycięstwo w tej walce legły w gruzach: te bestie są dokładnie martwe.\n\nRozkazujesz ludziom przeszukać obóz, by znaleźć jeńców. Nie mija dużo czasu, a %randombrother% odnajduje mężczyzn skulonych pod namiotem. Zostali pobici i torturowani, ale przeżyją. Kilku dziękuje tobie, a większość starym bogom. Przeklęte bóstwa znów kradną ci blask. Tak czy inaczej, %employer% będzie bardzo zadowolony. | %companyname% rozprawia się z zasadzką i szybko wpada do porzuconego obozowiska zielonoskórych. Znajdujesz człowieka pieczonego na rożnie nad ogniem. Inny wisi na drzewie z odciętymi stopami. Krzyki przyciągają twoją uwagę do pobliskiego namiotu, gdzie znajdujesz resztę mężczyzn skulonych razem i błagających o wodę. Twoi ludzie zaczynają podawać wodę i opatrywać rany. Będą musieli być w stanie dojść z powrotem do %employer%a i do domów. | Zasadzka zniszczona, szybko przeszukujesz obóz zielonoskórych. Znajdujesz kilku maruderów, w tym goblina próbującego uciec z wiązką trofeów czaszek. %randombrother% sprawia, że bestia płaci za swoją makabryczną chciwość własną głową.\n\nNiedługo potem znajdujesz jeńców skulonych pod namiotem z owczej skóry. Jeden krzyczy.%SPEECH_ON%Wiedziałem, że starzy bogowie odpowiedzą na nasze modlitwy!%SPEECH_OFF%Pytasz, czy starzy bogowie rozwiążą też ich więzy. Ciekawskie, filozoficzne pytanie pozostaje bez odpowiedzi, gdy %randombrother% wpada i uwalnia jeńców. Ostatecznie %employer% będzie zadowolony, niezależnie od tego, kto lub co odpowiada za ich ratunek. | Zielonoskórzy padli, a ty i %companyname% przeszukujecie ich obozowisko, zabijając każdego marudera, którego znajdziecie. Jeńcy zostają uwolnieni z dołu w ziemi, gdzie najwyraźniej musieli sikać i srać przez wiele dni. Całują ziemię i dziękują za ratunek. %employer% powinien być bardzo zadowolony z tego wyniku. | Zasadzka została rozwiązana, ale co z jeńcami? Szybko wpadasz do porzuconego obozu zielonoskórych i znajdujesz jeńców przywiązanych do serii słupów. Niestety mężczyzna na końcu został już zamęczony na śmierć. Sądząc po wciąż sączących się ranach, spóźniłeś się odrobinę. Pozostali jeńcy krzyczą z radości. Jeden po drugim całują ziemię u twoich stóp. Jednak to nie czas na samozadowolenie. %employer% będzie na ciebie czekał z własnym podziękowaniem: wielką stertą koron.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mamy to, po co przyszliśmy. Czas wracać do %townname%!",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "EmptyCamp",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Wpadasz do obozowiska zielonoskórych z bronią w dłoni, ale zastajesz je całkowicie opuszczone. Garnki z gulaszem są przewrócone, a ogniska wciąż świeże - zostawili je w pośpiechu. %randombrother% otwiera namiot z koziej skóry i znajduje jeńców skulonych razem. Na twój widok chwalą starych bogów. %employer% będzie zadowolony z tego wyniku, a ty cieszysz się, że zielonoskórzy poddali się bez walki. | Obóz zielonoskórych jest opuszczony. Znajdujesz zwęglone resztki świni pozostawionej na rożnie i przewrócone gary z gulaszem. Zdecydowanie uciekali w pośpiechu.\n\n%randombrother% woła cię. Jeńcy są w dole w ziemi, z wodą sięgającą im do pasa. Uwięzieni są za kolczastą drewnianą kratą, splątaną z zakrwawionymi ubraniami, co sugeruje, że przynajmniej jeden z ludzi próbował się wydostać. Szybko podnosisz pokrywę i pomagasz im wyjść. Spoglądasz w dół i widzisz jedno ciało unoszące się w wodzie. Nie wszyscy wrócą, ale %employer% powinien być więcej niż zadowolony z tych kilku szczęśliwych dusz. | Wpadasz do obozowiska zielonoskórych i widzisz namioty przewrócone, a wiodący z obozu wielki pęd śladów stóp. Opuścili obóz w pośpiechu. %randombrother% śmieje się.%SPEECH_ON%Wygląda na to, że wiedzieli, że %companyname% nadchodzi.%SPEECH_OFF%Nagle z jednego z namiotów rozlega się krzyk. Podbiegasz i znajdujesz mężczyznę w histerii, rozciągniętego na ziemi, podczas gdy grupa mężczyzn z zawiązanymi oczami kuli się w rogu. Jeńcy. Brakujące palce, stopy, oczy, nosy, kończyny - tykanie czasu spędzonego w towarzystwie zielonoskórych. Kręcisz głową i każesz ludziom zacząć udzielać pomocy. %employer% będzie zadowolony, że żyją, ale ci ludzie są bez wątpienia złamani na zawsze. | Obóz zielonoskórych jest pusty. Kilka czarnych ptaków skrzeczy i walczy o rozlany gulasz, a zdziczałe psy uciekają na sam twój widok. Twoi ludzie zaczynają przeszukiwać porzucone namioty z koziej skóry. Nie znajdujesz nic, aż twoja stopa nagle zapada się nieco głębiej w ziemię, niż powinna. Kucasz i odgarniasz kamuflaż, odkrywając klapę. Podnosisz ją i znajdujesz szyb studni, który zielonoskórzy przerobili na bardzo pionową celę więzienną. Jeńcy są ściśnięci jak podpałka i spoglądają w górę na światło z wysuszonymi, wodą zżartymi twarzami. %randombrother% spogląda w dół i mruczy.%SPEECH_ON%Cóż, żyją. Pójdę po linę.%SPEECH_OFF% | Ślady stóp prowadzą z obozu. Sądząc po rozstawie i porozrzucanych śmieciach, uciekali w pośpiechu. %randombrother% woła cię. Stoi przy namiocie, trzymając odsuniętą płachtę. Gdy podchodzisz, widzisz, że służył jako miejsce dla jeńców. Wszyscy są nadzy, leżą na ziemi, z zatkanymi uszami i zawiązanymi oczami. Wygląda na to, że pobito ich tak, by nie ruszali się bez rozkazu. W rogu leży sterta ludzkich kończyn, jakby ktoś używał czaszek do prymitywnej sztuki. Kręcisz głową.%SPEECH_ON%Uwolnijcie ich i dajcie im wody. %employer% zapewne liczył na najlepszy wynik, ale to dokładnie to, czego się spodziewałem.%SPEECH_OFF% | Zielonoskórzy porzucili obóz. Nie wiesz dlaczego, ale najpewniej zwiadowcy dostrzegli twoją kompanię i podjęli rozsądną decyzję o ucieczce, póki mogli.\n\nKażesz ludziom szukać jeńców i wkrótce ich znajdują: namiot z koziej skóry, pod którego żerdzią mężczyźni kucają ze związanymi rękami i twarzami dosłownie w ziemi. Dostali słomki do oddychania. %randombrother% podbiega i zaczyna wyciągać ich głowy z ziemi. Twarze każdego mężczyzny są sine i łapczywie chwytają powietrze, ale żyją, a tortury dobiegły końca. %employer% powinien być zadowolony, że wracają. | Obóz okazuje się pusty. %randombrother% podnosi przewrócony kocioł, z którego wypływa bardziej ścieki niż gulasz. Upuszcza go i kręci głową.%SPEECH_ON%Ogień wciąż skwierczy. Uciekli w pośpiechu.%SPEECH_OFF%Kiwasz głową i każesz ludziom rozproszyć się i szukać jeńców. Nim słowa opuszczą twoje usta, słyszysz krzyk z pobliskiego namiotu. W środku znajdujesz jeńców - lub tych, którzy przeżyli. Po jednej stronie pokoju żywi są nadzy i skuleni. Po drugiej widzisz kałużę krwi, pniak egzekucyjny, czerwono zabarwiony młot i kilka ciał pozbawionych głów jak kwiaty użyte jako zakładki. %employer% nie odzyska wszystkich swoich ludzi. | Wchodząc do obozowiska zielonoskórych, {znajdujesz goblina, który ładuje kości do torby. Szybko porzuca swoje rzeczy. %randombrother% dopada go i przebija ostrzem. | znajdujesz rannego orka opartego o słup. Ciężko oddycha, ale jednym szybkim pchnięciem %randombrother% upewnia się, że już nie oddycha.} Reszta obozu wydaje się opuszczona, ten zielonoskóry to ostatni, który został. Znajdujesz jeńców w namiocie. Mają zawiązane oczy, a kilku brakuje palców u rąk lub nóg. %employer% będzie bardzo zadowolony. | Obozowisko zostało opuszczone, ale jeńców pozostawiono. Ratujesz ich, a raczej to, co z nich zostało: niektórym odcięto palce u rąk i nóg, inni oddychają przez otwory, gdzie kiedyś mieli nosy. Ale żyją. To się liczy, prawda? | Wchodzisz do obozu porzuconego w pośpiechu. Zielonoskórzy najpewniej dostrzegli %companyname% i podjęli mądrą decyzję, by uciec, póki mogli. Jeńcy, na szczęście, zostali znalezieni żywi. Dziękują starym bogom i kłaniają się przed tobą jak biedacy przed wyrocznym mędrcem. Dajesz biednym ocalałym wodę i szykujesz powrót do %employer%a. | W obozowisku znajduje się tylko jeden ork. Odpoczywa oparty o klatkę, w której przetrzymywano jeńców. Jeden z jeńców ma łańcuch wokół szyi zielonoskórego i ciągnie go przez kraty, strażnik i więzień spleceni w ironicznej walce. %randombrother% pędzi i przebija orka w oko, uwalniając ludzi. Jeńcy wybiegają z klatki, całując ziemię i skacząc z radości. Rozradowany mężczyzna wyjaśnia, że zielonoskórzy uciekli w pośpiechu i wygląda na to, że byli bardzo przestraszeni. Kiwasz głową i wskazujesz kciukiem przez ramię na znak %companyname%.%SPEECH_ON%Mieli czego się bać.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mamy to, po co przyszliśmy. Czas wracać do %townname%!",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% wita cię w swoim pokoju.%SPEECH_ON%Przyjrzałem się jeńcom. A raczej temu, co z nich zostało. Są w złym stanie, ale wykonałeś dobrą robotę. %reward_completion% koron, tak?%SPEECH_OFF% | %employer% krąży po pokoju, od czasu do czasu spoglądając przez okno. Na dole opiekują się jeńcami. Kręci głową.%SPEECH_ON%Naprawdę nie sądziłem, że choć jedna z tych biednych dusz wróci. Dobra robota, najemniku.%SPEECH_OFF%Przesuwa w twoją stronę sakiewkę %reward_completion% koron. | Zastajesz %employer%a, jak osobiście pomaga karmić jeńców. Mówi do nich życzliwie. Widząc ciebie, przekazuje obowiązki służącemu i bierze cię na bok.%SPEECH_ON%Słuchaj, wiem, że ci ludzie są teraz w zasadzie bezużyteczni. Zielonoskórzy ich nie zabili, ale równie dobrze mogli. Ich ciała idą dalej, ale dusze są złamane. Nieważne. Zrobiłeś to, o co prosiłem. Strażnik, który stoi tam, ma dla ciebie %reward_completion% koron. Nie wiem, jak to robisz, najemniku. Dzień po dniu. Ale cenię twoje usługi.%SPEECH_OFF% | %employer% wpatruje się przez okno, jego przygaszona sylwetka ledwo widoczna za cienkimi zasłonami. Na dole opatrują uwolnionych jeńców. Kręci głową i podchodzi do biurka.%SPEECH_ON%Smutno patrzeć na tych ludzi w takim stanie.%SPEECH_OFF%Wyjmuje sakiewkę %reward_completion% koron i przesuwa ją w twoją stronę, po czym dodaje.%SPEECH_ON%Ale sprowadziłeś ich do domu, najemniku, i to jest najważniejsze. Żaden człowiek nie zasługuje na śmierć w obozie bestii.%SPEECH_OFF% | Zastajesz %employer%a nad stertą zwojów. Skryba stoi u jego boku, patrząc w dół, gdy obraca paciorek między kciukiem a palcem. Oboje spoglądają na ciebie, gdy wchodzisz. Zdajesz raport, że jeńcy zostali uratowani. Szlachcic odkłada zwój i kiwa na skrybę, który natychmiast wypłaca ci %reward_completion% koron. %employer% klaszcze w dłonie.%SPEECH_ON%Mam nadzieję, że wszyscy wrócili cali.%SPEECH_OFF%Gdy otwierasz usta, by powiedzieć, że nie wszyscy, szlachcic cię ucina.%SPEECH_ON%Nie potrzebuję przemowy, najemniku. Mam pracę do wykonania.%SPEECH_OFF%Skryba uśmiecha się ciepło, wyprowadzając cię. | Jeńcy trafiają do uzdrowiciela, który opatruje ich okropne rany. Niestety to niewidoczne blizny będą dręczyć tych ludzi do końca życia. %employer% wygląda jednak na zadowolonego.%SPEECH_ON%Dobrze, że wrócili. Na pewno nie sądziłem, że kiedykolwiek przyjdą do domu. Masz wyjątkowy talent, najemniku.%SPEECH_OFF%Wyjątkowy, może, ale nie różnisz się aż tak od innych kompanii: prosisz o zapłatę. To przypomnienie sprawia, że szlachcic pstryka palcami. Strażnik natychmiast podchodzi z %reward_completion% koron. | Eskortujesz uratowanych ludzi do %townname%. %employer% stoi na balkonie i klaszcze.%SPEECH_ON%Brawo, brawo! Straż!%SPEECH_OFF%Opancerzony mężczyzna podbiega do ciebie z sakiewką %reward_completion% koron. | Uratowani jeńcy trafiają pod opiekę grupy starych uzdrowicieli, którzy sami wyglądają, jakby spędzili życie w obozie zielonoskórych. Ranni wojownicy leczeni przez swoich przodków. %employer% wygląda na niezwykle zadowolonego, osobiście wręczając ci sakiewkę %reward_completion% koron.%SPEECH_ON%Wiesz, my, szlachcice, zakładaliśmy się, czy ci ludzie wrócą żywi. Postawiłem na ciebie, najemniku. Wiedziałem, że dasz radę! Zarobiłem więcej niż właśnie ci zapłaciłem! Czy to nie zabawne?%SPEECH_OFF% | Ty i %employer% obserwujecie, jak uratowani jeńcy są prowadzeni do apteki. Szlachcic rozczarowany wzrusza ramionami.%SPEECH_ON%Cóż, cholera.%SPEECH_OFF%To nie była reakcja, której się spodziewałeś. Pochyla się i wyjaśnia szeptem.%SPEECH_ON%Mieliśmy zakłady, czy ci ludzie wrócą. Straciłem sporo koron na twojej dobrej robocie, najemniku.%SPEECH_OFF%Kiwasz głową i wyciągasz dłoń.%SPEECH_ON%Cóż, czas, byś stracił jeszcze %reward_completion% koron.%SPEECH_OFF% | %employer% wita cię w drzwiach z uśmiechem i sakiewką %reward_completion% koron.%SPEECH_ON%Spodziewaliśmy się porażki, najemniku. Ja, inni szlachcice, mieszkańcy. Nikt nie sądził, że ci ludzie kiedykolwiek wrócą, a jednak oto są.%SPEECH_OFF% | %employer% osobiście dba o to, by uratowani jeńcy otrzymali opiekę, rozdając wodę, jedzenie i bandaże. Wygląda na to, że robi to bardziej dla rozgłosu niż z troski. %employer% widzi cię i podchodzi, wycierając grzbiet dłoni o twój rękaw.%SPEECH_ON%Ugh, jeden z nich mnie ubrudził. Oto twoje %reward_completion% koron, najemniku. Nie sądziłem, że dasz radę, ale oto są. Szczerze mówiąc, wątpię, by byli mi szczególnie przydatni, ale liczy się gest.%SPEECH_OFF%Dziwnie masz ochotę powiedzieć mu, by nieco przyhamował ze szczerością. | Pomagasz uratowanym jeńcom przejść przez bramy %townname%. %employer% czeka na schodach apteki z orszakiem strażników. Pomagają ludziom w opiece. Szlachcic posyła w twoją stronę skrybę z sakiewką %reward_completion% koron. | Zastajesz %employer%a w jego pokoju. Zwinna kobieta sumiennie uciera liście w moździerzu. Nie widząc ciebie, odwraca się do szlachcica, podając misę.%SPEECH_ON%To powinno mu pomóc wstać.%SPEECH_OFF%%employer% widzi cię ponad jej ramieniem i zrywa się na nogi.%SPEECH_ON%Najemniku! Dobrze cię widzieć! Zakładam, że jeńcy zostali uwolnieni?%SPEECH_OFF%Zdajesz raport. Szlachcic przywołuje kobietę z sakiewką %reward_completion% koron.%SPEECH_ON%Daj temu człowiekowi nagrodę, pani.%SPEECH_OFF% | Prowadzisz uratowanych jeńców przez bramy %townname%. Tłum kobiet czeka na nich: żony obejmują mężów, wdowy osuwają się na kolana.\n\n%employer% podchodzi, z damą pod każdą ręką. Kiwając głową na tę scenę, mówi.%SPEECH_ON%Bardzo smutne. Powiedz, jaka była twoja nagroda, %reward_completion% koron?%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Uwolniłeś jeńców pojmanych przez zielonoskórych");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isGreenskinInvasion())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCriticalContract);
						}

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
		if (this.m.BattlesiteTile == null || this.m.BattlesiteTile.IsOccupied)
		{
			local playerTile = this.World.State.getPlayer().getTile();
			this.m.BattlesiteTile = this.getTileToSpawnLocation(playerTile, 6, 12, [
				this.Const.World.TerrainType.Shore,
				this.Const.World.TerrainType.Ocean,
				this.Const.World.TerrainType.Mountains
			], false);
		}

		_vars.push([
			"location",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.m.Destination.getName()
		]);
		_vars.push([
			"dude_name",
			this.m.Dude == null ? "" : this.m.Dude.getNameOnly()
		]);
		_vars.push([
			"hurtbro",
			this.m.Dude == null ? "" : this.m.Dude.getName()
		]);

		if (this.m.Destination == null)
		{
			_vars.push([
				"direction",
				this.m.BattlesiteTile == null ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.BattlesiteTile)]
			]);
		}
		else
		{
			_vars.push([
				"direction",
				this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Destination.getTile())]
			]);
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isGreenskinInvasion())
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull())
		{
			_out.writeU32(this.m.Destination.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		this.contract.onDeserialize(_in);
	}

});

