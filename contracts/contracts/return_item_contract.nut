this.return_item_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.return_item";
		this.m.Name = "Odzyskanie Przedmiotu";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 400 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		local items = [
			"Kolekcja Rzadkich Monet",
			"Obrzędowa Laska",
			"Bożek Płodności",
			"Złoty Talizman",
			"Tom Wiedzy Tajemnej",
			"Puzderko",
			"Demoniczna Statuetka",
			"Kryształowa Czaszka"
		];
		local itemsG = [
			"Kolekcji Rzadkich Monet",
			"Obrzędowej Laski",
			"Bożka Płodności",
			"Złotego Talizmanu",
			"Tomu Wiedzy Tajemnej",
			"Puzderka",
			"Demonicznej Statuetki",
			"Kryształowej Czaszki"
		];
		local itemsD = [
			"Kolekcję Rzadkich Monet",
			"Obrzędową Laskę",
			"Bożka Płodności",
			"Złoty Talizman",
			"Tom Wiedzy Tajemnej",
			"Puzderko",
			"Demoniczną Statuetkę",
			"Kryształową Czaszkę"
		];
		local r = this.Math.rand(0, items.len() - 1);
		this.m.Flags.set("Item", items[r]);
		this.m.Flags.set("ItemG", itemsG[r]);
		this.m.Flags.set("ItemD", itemsD[r]);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Podążaj za tropem w pobliżu %townname%",
					"Zwróć %itemD% do %townname%"
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
					if (this.Contract.getDifficultyMult() >= 0.95)
					{
						this.Flags.set("IsNecromancer", true);
					}
				}
				else if (r <= 30)
				{
					this.Flags.set("IsCounterOffer", true);
					this.Flags.set("Bribe", this.Contract.beautifyNumber(this.Contract.m.Payment.getOnCompletion() * this.Math.rand(100, 300) * 0.01));
				}
				else
				{
					this.Flags.set("IsBandits", true);
				}

				this.Flags.set("StartDay", this.World.getTime().Days);
				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10, [
					this.Const.World.TerrainType.Mountains
				]);
				local party;
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).spawnEntity(tile, "ZՄodzieje", false, this.Const.World.Spawn.BanditRaiders, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.setDescription("Grupa złodziei i bandytów.");
				party.setFootprintType(this.Const.World.FootprintsType.Brigands);
				party.setAttackableByAI(false);
				party.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				party.setFootprintSizeOverride(0.75);
				this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.GenericFootprints, this.Const.World.FootprintsType.Brigands, 0.75);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_bandits_0" + this.Math.rand(1, 6));
				local c = party.getController();
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(9000.0);
				c.addOrder(wait);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Podążaj za tropem na %direction% od %townname%",
					"Zwróć %itemD% do %townname%"
				];

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull())
				{
					if (this.Flags.get("IsCounterOffer"))
					{
						this.Contract.setScreen("CounterOffer1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("BattleDone");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Return");
					}
				}
				else if (this.World.getTime().Days - this.Flags.get("StartDay") >= 3 && this.Contract.m.Target.isHiddenToPlayer())
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					if (this.Flags.get("IsNecromancer"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
						this.Contract.setScreen("Necromancer");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
						this.Contract.setScreen("Bandits");
						this.World.Contracts.showActiveContract();
					}
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Zwróć %itemD% do %townname%"
				];
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% nerwowo chodzi tam i z powrotem, wyjaśniając, co go trapi.%SPEECH_ON%Doszło do zuchwałej kradzieży! Podli zbóje ukradli mój %itemLower%, który ma dla mnie niezmierzoną wartość. Błagam, wytrop tych złodziei i zwróć mi ten przedmiot.%SPEECH_OFF%Ścisza głos do natarczywego tonu.%SPEECH_ON%Nie tylko sowicie ci zapłacimy, ale i uspokoisz zmartwione umysły uczciwych ludzi z %townname%!%SPEECH_OFF% | %employer% czyta jeden z wielu zwojów. Ze złością rzuca go na stertę pozostałych.%SPEECH_ON%Ludzie z %townname% są słusznie wściekli. Wiesz, że zbój, być może w zmowie z innymi włóczęgami, zdołał ukraść nam mój %itemLower%? Ten artefakt ma dla mnie niezmierzoną wartość! I... dla ludzi, oczywiście.%SPEECH_OFF%Wzruszasz ramionami.%SPEECH_ON%I chcesz, żebym ci to odzyskał?%SPEECH_OFF%Mężczyzna wskazuje palcem.%SPEECH_ON%Dokładnie, bystry najemniku! Dokładnie tego od ciebie oczekuję. Podążaj tropem kradzieży i zwróć mi przedmiot, który ja... to znaczy miasto, słusznie posiada!%SPEECH_OFF% | %employer% obraca w dłoni jabłko. Wygląda na zirytowanego, jakby wolał, by było czymś innym, na przykład kosztownym bibelotem albo chociaż smaczniejszym owocem.%SPEECH_ON%Zdarzyło ci się zgubić coś, co kochałeś?%SPEECH_OFF%Wzruszasz ramionami i odpowiadasz.%SPEECH_ON%Była taka dziewczyna...%SPEECH_OFF%Mężczyzna kręci głową.%SPEECH_ON%Nie, nie jakaś kobieta. Coś ważniejszego. Bo mnie tak! Złodzieje ukradli mój %itemLower%. Jak zdołali przejść przez straże, cóż, nie wiem. Ale wiem, że jeśli poślę ciebie, odzyskam to, co słusznie moje. Prawda? Czy może źle mnie poinformowano o jakości twoich usług?%SPEECH_OFF% | U stóp %employer% chrapie pies. Mężczyzna pochyla się i delikatnie głaszcze go za uszami.%SPEECH_ON%Słyszałem, że masz nosa do znajdowania ludzi, najemniku. Do... rozwiązywania problemów.%SPEECH_OFF%Kiwasz głową. To w końcu prawda.%SPEECH_ON%Dobrze... dobrze... Mam dla ciebie zadanie. Proste. Coś bardzo cennego zostało mi skradzione, mój %itemLower%. Musisz wytropić tych, którzy go ukradli, zabić ich, rzecz jasna, i przynieść przedmiot z powrotem.%SPEECH_OFF% | Na oknie %employer% przysiadł ptak. Mężczyzna, siedząc, wskazuje go.%SPEECH_ON%Zastanawiam się, czy tak się dostali do środka. Zbóje, to znaczy. Myślę, że wślizgnęli się przez okno i tak samo wyszli. Tak ukradli mój %itemLower%.%SPEECH_OFF%Mężczyzna powoli wstaje i skrada się przez pokój. Kuca, gotów rzucić się na ptaka, ale stworzenie odlatuje, zanim mężczyzna zdąży drgnąć.%SPEECH_ON%Cholera.%SPEECH_OFF%Wraca na miejsce, wycierając dłonie, jakby spocił się przy tej ptasiej zasadzce.%SPEECH_ON%Moje zadanie jest proste, najemniku. Odzyskaj moją własność. Zabij też zbójów, jeśli nie masz nic przeciwko.%SPEECH_OFF% | Kurz pokrywa stół %employer%, ale jedno miejsce jest dziwnie czystsze. Wskazuje je.%SPEECH_ON%Tam stał mój %itemLower%. Jak widzisz, już go nie ma.%SPEECH_OFF%Kiwasz głową. Faktycznie zniknął.%SPEECH_ON%Złodziei powinno być łatwo wytropić. Zbóje świetnie myślą w nocy, ale za dnia popełniają masę błędów. Ślady, źle wydane korony... powinieneś ich bez trudu znaleźć.%SPEECH_OFF%Spogląda na ciebie surowo.%SPEECH_ON%Rozumiesz, najemniku? Chcę odzyskać moją własność. Chcę, by wróciła tam, gdzie jej miejsce. I... chcę, by ci złodzieje zginęli w błocie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Ile to jest dla ciebie warte? | Porozmawiajmy o zapłacie.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{To nie brzmi jak robota dla nas. | Nie sądzę.}",
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
			ID = "Bandits",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_80.png[/img]{Bandyci! Tak, jak podejrzewał %employer%. Wyglądają na przestraszonych, zapewne rozumiejąc, że za chwilę zakosztują jego szczodrze opłaconego gniewu. | Ach, złodzieje to zwykli ludzie - prosta ekipa włóczęgów i zbójców. Chwytają za broń, gdy wydajesz swoim towarzyszom rozkaz do ataku. | Przyłapujesz grupkę zbójców taszczących własność twego mocodawcy. Wydają się nad wyraz zaskoczeni tym, że ich odnalazłeś i nikt nie traci czasu na zbędne negocjacje - szybko się zbroją, a ty wydajesz rozkaz: %companyname% do ataku!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Necromancer",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_76.png[/img]{Są tu zbóje, jak się spodziewałeś, ale właśnie przekazują %itemLower% mężczyźnie w ciemnych, postrzępionych szatach. Twoja obecność, rzecz jasna, przerywa transakcję i zarówno bandyci, jak i upiorna postać dobywają broni. | Przyłapujesz zbójów handlujących własnością %employer% z kimś, kto wygląda na nekromantę! Może chciał użyć artefaktu do rzucenia jakiegoś przeklętego uroku na ród. Z pewnego punktu widzenia to wcale nie brzmi tak źle... ale ten człowiek płaci ci z powodu. Do szarży! | Własność %employer% jest sprzedawana przez zbójów bladym mężczyźnie w czerni! Patrzy na ciebie, zanim spojrzy na kogokolwiek innego, a jego paciorkowate czarne oczy zwężają się na twojej kompanii w mgnieniu oka.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						this.Const.World.Common.addTroop(this.Contract.m.Target, {
							Type = this.Const.World.Spawn.Troops.Necromancer
						});
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CounterOffer1",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_76.png[/img]{Wycierasz krew z miecza i idziesz po przedmiot. Gdy się pochylasz, by go podnieść, dostrzegasz w oddali mężczyznę, który cię obserwuje. Podchodzi, dłonie złożone razem, rękawy długie.%SPEECH_ON%Widzę, że zabiłeś ludzi mojego dobroczyńcy.%SPEECH_OFF%Chowasz miecz i kiwasz głową. Mężczyzna mówi dalej.%SPEECH_ON%Mój dobroczyńca zapłacił sporo za ten artefakt. Wygląda na to, że ci, którym zapłacił, nie są już komu winni, więc mogę porozmawiać bezpośrednio z tobą. Dam ci %bribe% koron za przedmiot.%SPEECH_OFF%To... sporo pieniędzy. %employer% jednak nie będzie zadowolony, jeśli się zgodzisz... | Po bitwie z linii drzew wychodzi mężczyzna, klaszcząc w dłonie.%SPEECH_ON%Zapłaciłem tamtym ludziom sporo koron, ale wygląda na to, że powinienem był zapłacić tobie. A skoro ci obleśni zbóje już nie żyją, mogę!%SPEECH_OFF%Mówisz mu, żeby przeszedł do rzeczy, zanim przebijesz go mieczem. Wskazuje na artefakt.%SPEECH_ON%Zapłacę ci %bribe% koron za przedmiot. To suma, która była im należna, plus trochę ekstra. Co ty na to?%SPEECH_OFF%%employer% nie będzie łaskawy wobec twojej zdrady, ale to bardzo dużo pieniędzy... | Po bitwie podnosisz %itemLower% i przyglądasz mu się. Czy naprawdę było warto tylu istnień?%SPEECH_ON%Wiem, o czym myślisz, najemniku.%SPEECH_OFF%Głos wtrąca się. Dobywasz miecza i celujesz w nieznajomego, który zdaje się pojawić znikąd.%SPEECH_ON%Myślisz: a co, jeśli ktoś zapłacił dobre pieniądze, by ukraść ten artefakt? Co, jeśli ten ktoś zapłaciłby mi jeszcze więcej? Może... więcej niż człowiek, który zapłacił ci za jego odzyskanie.%SPEECH_OFF%Opuszczasz broń i kiwasz głową.%SPEECH_ON%Ciekawa myśl.%SPEECH_OFF%Mężczyzna uśmiecha się.%SPEECH_ON%%bribe% koron. Tyle ci za to dam. To udział złodziei plus trochę ekstra. Więcej niż uczciwa oferta. Oczywiście twój pracodawca będzie bardzo niezadowolony, ale... cóż, to nie mój wybór.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Od razu potrafię rozpoznać dobrą ofertę. Dawajcie korony.",
					function getResult()
					{
						this.updateAchievement("NeverTrustAMercenary", 1, 1);
						return "CounterOffer2";
					}

				},
				{
					Text = "Zapłacono nam za zwrócenie przedmiotu i to właśnie uczynimy.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CounterOffer2",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_76.png[/img]{Oddajesz %itemLower%, a nieznajomy wciska ci bardzo ciężką, obwisłą sakiewkę. Umowa stoi. Można bezpiecznie założyć, że %employer%, twój pracodawca, nie będzie z tego zadowolony.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Dobra zapłata.",
					function getResult()
					{
						this.World.Assets.addMoney(this.Flags.get("Bribe"));
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Nie zdołałeś odzyskać skradzionego przedmiotu - " + this.Flags.get("Item"));
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
			ID = "BattleDone",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Po bitwie odzyskujesz %itemLower% z krwawych szponów wrogów i szykujesz się do powrotu do %employer%. Z pewnością ucieszy się z twojego sukcesu! | Ci, którzy ukradli %itemLower%, nie żyją, a na szczęście udało ci się znaleźć sam przedmiot. %employer% będzie bardzo zadowolony z twojej pracy. | Cóż, znalazłeś tych, którzy ukradli %itemLower%, i posłałeś ich pod miecz. Teraz wystarczy włożyć %itemLower% z powrotem w ręce %employer% i odebrać nagrodę! | Bitwa skończona, a %itemLower% łatwo było znaleźć pośród zwłok wrogów. Powinieneś zwrócić go %employer% i odebrać należną zapłatę!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Odbierzmy naszą zapłatę.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% odbiera od ciebie %itemLower% i przytula go, jakby odzyskał zagubione dziecko. Oczy ma lekko zaszklone, gdy patrzy na artefakt.%SPEECH_ON%Dziękuję, najemniku. To dla mnie wiele znaczy... to znaczy, eee, dla miasta. Macie naszą wdzięczność!%SPEECH_OFF%Milknie, gdy się w niego wpatrujesz. Jego wzrok ucieka w róg pokoju.%SPEECH_ON%Naszą... wdzięczność, najemniku...%SPEECH_OFF%Strażnik otwiera dużą drewnianą skrzynię. Liczysz korony i odchodzisz. | Gdy wracasz do %employer%, bawi się ptakiem w klatce.%SPEECH_ON%Ach, najemnik wraca... i?%SPEECH_OFF%Unosisz artefakt, po czym kładziesz go na biurku. Bierze go, obraca, kiwa głową i odkłada.%SPEECH_ON%Świetnie. A za twoje trudy...%SPEECH_OFF%Wskazuje ręką na drewnianą skrzynię pełną koron. | %employer% opiera nogi na dwóch psach, z których każdy jest ułożony na drugim, oba śpią.%SPEECH_ON%Te bestie mogłyby rozerwać mi gardło, a jednak... spójrz na nie. Jak to się dzieje? Nawet ich nie szkoliłem. Ktoś inny to zrobił. Jestem dla nich obcy, a jednak tu są.%SPEECH_OFF%Kładziesz artefakt na stole i przesuwasz go w jego stronę. Pochyla się, bierze go i chowa pod biurkiem. Gdy jego dłoń wraca, ma już sakiewkę. Rzuca ci ją.%SPEECH_ON%Jak obiecano. Dobra robota, najemniku.%SPEECH_OFF% | Gdy wchodzisz do pokoju %employer%, otacza go gromada strażników. Przez chwilę myślisz, że trafiłeś na zamach, ale ludzie się rozchodzą, zostawiając kości i karty. %employer% macha, byś podszedł.%SPEECH_ON%Chodź, chodź. Właśnie przegrałem sporo koron, najemniku. Może przyniosłeś coś, co ukoi mój ból...?%SPEECH_OFF%Wyciągasz %itemLower% i trzymasz go w dłoni. Mężczyzna bierze go ostrożnie.%SPEECH_ON%Dobrze... bardzo dobrze... twoja zapłata, oczywiście, jest tutaj.%SPEECH_OFF%Podaje ci sakiewkę z koronami, po czym odwraca się w fotelu. Zdaje się tak pochłonięty artefaktem, że nie mówi już nic więcej. | %employer% szczerzy zęby, gdy wchodzisz.%SPEECH_ON%Najemniku, najemniku, sprzedasz mi wieść o swoim sukcesie?%SPEECH_OFF%Wyciągasz artefakt i kładziesz go na jego stole.%SPEECH_ON%Pewnie.%SPEECH_OFF%Mężczyzna podrywa się w fotelu i zabiera przedmiot. Odwraca się do ciebie, uspokajając się i odzyskując opanowanie.%SPEECH_ON%Dobrze. Zrobiłeś dobrą robotę. Bardzo dobrą. %reward_completion% koron, jak obiecano.%SPEECH_OFF%Podaje ci worek monet.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Zwróciłeś skradziony przedmiot - " + this.Flags.get("Item"));
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
		this.m.Screens.push({
			ID = "Failure1",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_75.png[/img]{Kucasz na ziemi, pozwalając, by ziemia przesypała się przez palce. Ale to tylko ziemia - nie ma żadnych śladów. Właściwie od dłuższego czasu nie widziałeś żadnych tropów. %randombrother% dołącza do ciebie, kuca i wzrusza ramionami.%SPEECH_ON%Panie, chyba ich zgubiliśmy.%SPEECH_OFF%Kiwasz głową. %employer% nie będzie z tego zadowolony, ale tak już jest. | Od dłuższego czasu podążasz tropem skradzionego %itemLower%, lecz ślady się urwały. Mijani ludzie nic nie wiedzą, a ziemia nie pokazuje żadnych odcisków. Pod każdym względem %itemLower% przepadł. %employer% nie będzie zadowolony. | Ślad pozostawiony zbyt długo zostaje szybko zdeptany przez inny. I kolejny. I jeszcze kolejny. Goniłeś złodziei tak długo, że ruchliwy świat przykrył ich tropy. Nie masz już nadziei ich znaleźć, a %employer% będzie bardzo niezadowolony. | Trop złodziei %itemLower% całkiem się urwał. Ostatnie ślady zaprowadziły cię do gospodarstwa, a ci ludzie nie wyglądali na złodziei ani nie wiedzieli o takich. %employer% nie będzie zadowolony z utraty swojej własności, ale teraz niewiele możesz zrobić.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Niech szlag trafi ten kontrakt!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Nie zdołałeś odzyskać skradzionego przedmiotu - " + this.Flags.get("Item"));
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Target.getTile())]
		]);
		_vars.push([
			"item",
			this.m.Flags.get("Item")
		]);
		_vars.push([
			"itemG",
			this.m.Flags.get("ItemG")
		]);
		_vars.push([
			"itemD",
			this.m.Flags.get("ItemD")
		]);
		_vars.push([
			"itemLower",
			this.m.Flags.get("Item").tolower()
		]);
		_vars.push([
			"bribe",
			this.m.Flags.get("Bribe")
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Target != null && !this.m.Target.isNull())
		{
			_out.writeU32(this.m.Target.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});

