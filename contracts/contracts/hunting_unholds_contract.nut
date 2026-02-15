this.hunting_unholds_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = true
	},
	function setEnemyType( _t )
	{
		this.m.Flags.set("EnemyType", _t);
	}

	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_unholds";
		this.m.Name = "Polowanie na Olbrzymy";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 750 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
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
					"Zapoluj na Unholdy w pobliżu " + this.Contract.m.Home.getName()
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

				if (r <= 40)
				{
					this.Flags.set("IsDriveOff", true);
				}
				else if (r <= 50)
				{
					this.Flags.set("IsSignsOfAFight", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 6, 12, [
					this.Const.World.TerrainType.Mountains
				]);
				local nearTile = this.Contract.getTileToSpawnLocation(playerTile, 4, 8);
				local party;

				if (this.Flags.get("EnemyType") == 0)
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Unholdy", false, this.Const.World.Spawn.UnholdBog, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				}
				else if (this.Flags.get("EnemyType") == 1)
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Unholdy", false, this.Const.World.Spawn.UnholdFrost, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Unholdy", false, this.Const.World.Spawn.Unhold, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				}

				party.setDescription("Jeden lub kilka rosłych olbrzymów.");
				party.setFootprintType(this.Const.World.FootprintsType.Unholds);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);
				party.getFlags().set("IsUnholds", true);
				this.Const.World.Common.addFootprintsFromTo(nearTile, party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Unholds, 0.75);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Home);
				roam.setMinRange(2);
				roam.setMaxRange(8);
				roam.setAllTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
				roam.setTerrain(this.Const.World.TerrainType.Shore, false);
				roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
				c.addOrder(roam);
				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					if (this.Flags.get("IsSignsOfAFight"))
					{
						this.Contract.setScreen("SignsOfAFight");
					}
					else
					{
						this.Contract.setScreen("Victory");
					}

					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsBanterShown") && this.Contract.m.Target.isHiddenToPlayer() && this.Math.rand(1, 1000) <= 1 && this.Flags.get("StartTime") + 10.0 <= this.Time.getVirtualTimeF())
				{
					this.Flags.set("IsBanterShown", true);
					this.Contract.setScreen("Banter");
					this.World.Contracts.showActiveContract();
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsDriveOff") && !this.Flags.get("IsEncounterShown"))
				{
					this.Flags.set("IsEncounterShown", true);
					local bros = this.World.getPlayerRoster().getAll();
					local candidates = [];

					foreach( bro in bros )
					{
						if (bro.getBackground().getID() == "background.beast_slayer" || bro.getBackground().getID() == "background.wildman" || bro.getBackground().getID() == "background.barbarian" || bro.getSkills().hasSkill("trait.dumb"))
						{
							candidates.push(bro);
						}
					}

					if (candidates.len() == 0)
					{
						this.World.Contracts.showCombatDialog(_isPlayerAttacking);
					}
					else
					{
						this.Contract.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
						this.Contract.setScreen("DriveThemOff");
						this.World.Contracts.showActiveContract();
					}
				}
				else if (!this.Flags.get("IsEncounterShown"))
				{
					this.Flags.set("IsEncounterShown", true);
					this.Contract.setScreen("Encounter");
					this.World.Contracts.showActiveContract();
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
					"Wróć do " + this.Contract.m.Home.getName()
				];
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("IsDriveOffSuccess"))
					{
						this.Contract.setScreen("SuccessPeaceful");
					}
					else
					{
						this.Contract.setScreen("Success");
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
			Text = "[img]gfx/ui/events/event_79.png[/img]{Gdy wchodzisz do komnaty %employer%, zastajesz go pochylonego przy oknie, wyglądającego przez nie niemal spiskowo. Jego oczy zwężają się, rozszerzają i znów zwężają. Zasłania okno zasłoną i szarpie głową w twoją stronę.%SPEECH_ON%Nie widziałeś przypadkiem bardzo wściekłej kobiety, która zmierzała w moją stronę? A, nieważne. Spójrz na to.%SPEECH_OFF%Rzuca ci zwój, który rozwijasz. Jest na nim prymitywny rysunek czegoś, co wygląda jak człowiek pochylony nad mrówką albo innym owadem. Trudno powiedzieć. %employer% klaszcze w dłonie.%SPEECH_ON%Miejscowi rolnicy zgłaszają znikające bydło. Jedyne co znaleźli to ślady tak duże, że zmieściłby się w nich człowiek w trumnie. Brzmi mi to jak plotki i sianie paniki, może rywale ukrywają swoje przekręty, ale zostawiam to tobie. Przeszukaj okolicę i sprawdź, co znajdziesz. Jeśli natkniesz się na prawdziwego olbrzyma, myślę, że wiesz, co zrobić.%SPEECH_OFF% | Zastajesz %employer% siedzącego przy biurku, jakby naradzał się z połową wioski. Pochyleni nad zwojami, zostawiają ołowiane ślady na papierze, szkicując olbrzymów lub grubych ludzi z rogami. Jeden z nich bazgrze patyczka bzyczącego innego patyczka. %employer% podaje ci bardziej rzeczowną kartę z wizerunkiem potwora.%SPEECH_ON%Ci zacni panowie mówią mi, że gdzieś kręci się olbrzym. Nie chcę podważać obaw moich współziomków, więc proszę o twoje usługi, najemniku. Pieniądze leżą na stole, musisz tylko przeszukać okolice %townname% i znaleźć tę bestię. Co powiesz?%SPEECH_OFF% | Zastajesz %employer% odpierającego tłum chłopów. Wpadli do jego komnaty z widłami i nieodpalonymi pochodniami, które musi im ciągle kazać trzymać z dala, zważywszy na drewnianą architekturę. Widząc cię, %employer% woła jak tonący wzywający tratwę.%SPEECH_ON%Najemniku! Na bogów, chodź tutaj. Ci zacni ludzie twierdzą, że kręci się tu bestia.%SPEECH_OFF%Jeden z chłopów wbija widły w ziemię.%SPEECH_ON%Nie, nie zwykła bestia, ale potwór, co? Olbrzym! Wielki. Wielgaśny olbrzym. Tam, o, w tamtą stronę. Widziałem go.%SPEECH_OFF%Wzdychając i kiwając głową, %employer% wtrąca się z powrotem.%SPEECH_ON%Dobrze. Jestem więc gotów zapłacić ci, byś go odszukał. Podejmiesz się zadania?%SPEECH_OFF% | %employer% siedzi przy biurku z głową w dłoniach. Mamrocze do siebie.%SPEECH_ON%Potwór taki, bestia taka. \'O, moja kura zginęła\', o, może byś ją trzymał w kurniku, ty cholerny... o, hej, najemniku!%SPEECH_OFF%Mężczyzna wstaje i rzuca ci kartkę. Jest na niej prymitywny rysunek bestii z wielką głową.%SPEECH_ON%Ludzie donoszą, że po okolicy kręci się olbrzym. Zapłacę dobrą monetę za rzetelne zbadanie tych doniesień i oczywiście dobrą monetę za porządne ubicie bestii. Podejmiesz się? Proszę, powiedz, że tak.%SPEECH_OFF% | %employer% niechętnie wita cię w swojej komnacie, udając, że nie potrzebuje pomocy, choć widać, że wolałby jej nie chcieć wcale.%SPEECH_ON%Ach, najemniku. Nieczęsto miejsce takie jak %townname% szuka ludzi twojego pokroju, ale obawiam się, że widziano unholdy plądrujące te ziemie, kradnące tyle bydła, że mieszczanie złożyli się, by sprowadzić kogoś takiego jak ty. Jesteś zainteresowany upolowaniem tego plugastwa?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Walczenie z olbrzymami tanie nie będzie. | Nasza kompania ci pomoże, za odpowiednia cenę. | Porozmawiajmy o koronach.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{To nie brzmi jak robota dla nas. | To nie jest warte ryzyka.}",
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
			ID = "Banter",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{%randombrother% wraca z rozpoznania. Melduje, że pobliska farma została zniszczona, a w dachu wybito dziurę, jakby ktoś kopnął mrowisko. Pytasz, czy są ocaleni. Kiwając głową, mówi.%SPEECH_ON%W pewnym sensie. Młody chłopak, który nie chciał powiedzieć ani słowa. Kobieta, która wciąż krzyczała, żebym spadał. Poza tym nie. Przeżyli dzięki przypadkowi i szczęściu. Ten świat nie pozwoli im tu zostać na długo.%SPEECH_OFF%Mówisz najemnikowi, by zachował osądy dla siebie i ponownie ruszył z kompanią. | Znajdujesz przy drodze połowę krowy. Nie została wyćwiartowana, lecz nierówno rozerwana z ogromną siłą. Wnętrzności spłynęły na ziemię w kupie. Ślady wielkości grobów prowadzą dalej. Szlak rzezi przecina ogrodzenie, które leży rozerwane, a dalej widać ruiny stodoły. %randombrother% śmieje się.%SPEECH_ON%Brakuje nam tylko wielkiej kupy gówna.%SPEECH_OFF%Mówisz mu, żeby sprawdził but. | Kilku chłopów na drodze ostrzega cię.%SPEECH_ON%Zmykaj stąd! Ta zbroja nie uratuje cię nawet przed jednym liznięciem!%SPEECH_OFF%Pytasz ich o unholda, a oni kreślą barwny opis potwornego olbrzyma, który niedawno spustoszył okolicę. Wygląda na to, że jesteś na właściwym tropie. | Unhold zostawił za sobą wielki bałagan. Zdeptane bydło, inne zwierzęta rozerwane i wyssane jak wiciokrzewy. Kury kręcą się, dziobiąc ziemię, a rolnik pilnuje ich. Kiwając głową, mówi.%SPEECH_ON%Spóźniliście się na przedstawienie.%SPEECH_OFF%Wygląda na to, że jesteś blisko.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nie mogą być daleko.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Encounter",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_104.png[/img]{Unholdy przypominają ci trochę grupę robotników, krążących wokół wygasłego ognia, pocierających brzuchy i wyglądających jak głazy, kucnięte na ziemi. Oczywiście twoje przybycie stawia ich na nogi i niszczy wszelkie złudzenia, że w ogóle jesteś do nich podobny, może poza równie wielkimi trzecimi nogami. Bestie warczą i tupią, ale nie atakują. Wyrzucają ręce i próbują cię przegonić. Ale %companyname% nie zaszło tak daleko, by się wycofać. Dobywasz miecza i prowadzisz ludzi naprzód. | Każdy unhold jest niewyobrażalnie ogromny. Są zdumieni mrówkami, które przyszły się z nimi bić. Jeden drapie się po głowie i beztrosko bekając, opryskuje kompanię bydlęcą krwią. Zdają się jednak rozpoznawać stal twojego dobytego miecza, a jego błysk budzi ich z sytego otępienia. Po wstrząsających krokach ruszają, by przepędzić cię z tej ziemi lub wcisnąć w nią. | Nawet gdyby %companyname% ułożyć od stóp do głów, nie dorównałaby jednemu unholdowi. A jednak stoisz tu z mieczem i gotów do walki z tymi ogromnymi potworami. Patrzą na ciebie z niedowierzaniem, niepewni, co myśleć o tych małych stworach tak chętnych do konfrontacji. Jeden drapie się po brzuchu, a płaty złuszczonej skóry wielkości psów opadają na ziemię. Dość roztrząsania. Rozkazujesz kompanii naprzód! | Unholdy węszą was i pędzą przez ziemię, by spotkać %companyname%. Wyglądają jak małe dzieci wielkości gór, z niezgrabnymi nogami, które mimo to wstrząsają ziemią przy każdym kroku, z paszczami rozdziawionymi i śliniącymi się na posiłek. Spokojnie dobywasz miecza i ustawiasz ludzi w szyku.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do ataku!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "DriveThemOff",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_104.png[/img]{Gdy ustawiasz ludzi w szyku, %shouter% przebiega obok ciebie prosto w stronę unholdów. Huczy i krzyczy, wymachuje ramionami jak morski dziwak wyciągnięty na haku. Unholdy zatrzymują się i spoglądają na siebie. Nie wiesz, czy pozwolić temu trwać...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Atakować ich!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				},
				{
					Text = "%shouter% wie co robi.",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 35)
						{
							return "DriveThemOffSuccess";
						}
						else
						{
							return "DriveThemOffFailure";
						}
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "DriveThemOffSuccess",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_104.png[/img]{Wbrew rozsądkowi pozwalasz %shouter% biec. Nie zatrzymuje się przed niczym, jakby gonił tłum pięknych kobiet rozbierających się tylko dla niego. Ku zaskoczeniu unholdy cofają się o krok. Zaczynają ustępować jeden po drugim, aż zostaje tylko samotny olbrzym.\n\n%shouter% dopada jego stóp jak ujadający pies i wydaje jakiś atawistyczny krzyk tak chrapliwy, że zastanawiasz się, czy usłyszał go każdy przodek pochowany w ziemi i poza nią. Unhold zasłania twarz ramieniem, po czym cofa się dalej i dalej, aż znika! Wszyscy zniknęli!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I nie wracać mi tu!",
					function getResult()
					{
						this.Contract.m.Target.die();
						this.Contract.m.Target = null;
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
				this.Contract.m.Dude.improveMood(3.0, "Zdołał samodzielnie odpędzić unholdy");

				if (this.Contract.m.Dude.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[this.Contract.m.Dude.getMoodState()],
						text = this.Contract.m.Dude.getName() + this.Const.MoodStateEvent[this.Contract.m.Dude.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "DriveThemOffFailure",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_104.png[/img]{Wbrew rozsądkowi pozwalasz %shouter% biec. Nie zatrzymuje się przed niczym, jakby gonił tłum pięknych kobiet rozbierających się tylko dla niego. Ku zaskoczeniu unholdy cofają się o krok. Zaczynają ustępować jeden po drugim, aż zostaje tylko samotny olbrzym.\n\n%shouter% dopada jego stóp jak ujadający pies i wydaje jakiś atawistyczny krzyk tak chrapliwy, że zastanawiasz się, czy usłyszał go każdy przodek pochowany w ziemi i poza nią. Unhold zasłania twarz ramieniem, po czym opuszcza je i odrzuca %shouter%a na bok. Mężczyzna koziołkuje w powietrzu, a jego krzyki lecą z nim jak królik porwany przez jastrzębia. Jego wrzaski koziołkują z powrotem ku ziemi echem oszałamiających okrzyków i ląduje z tępym łupnięciem. Olbrzym trzęsie się od ziemistego chichotu. Jego rozbawienie zwraca uwagę oddalających się unholdów, którzy wszyscy się odwracają i zaczynają wracać.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To by było na tyle.",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, false);
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
				local injury;

				if (this.Math.rand(1, 100) <= 50)
				{
					injury = this.Contract.m.Dude.addInjury(this.Const.Injury.BluntBody);
				}
				else
				{
					injury = this.Contract.m.Dude.addInjury(this.Const.Injury.BluntHead);
				}

				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = this.Contract.m.Dude.getName() + " cierpi na " + injury.getNameOnly()
				});
				this.Contract.m.Dude.worsenMood(1.0, "Nie zdołał samodzielnie odpędzić unholdów");

				if (this.Contract.m.Dude.getMoodState() <= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[this.Contract.m.Dude.getMoodState()],
						text = this.Contract.m.Dude.getName() + this.Const.MoodStateEvent[this.Contract.m.Dude.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_113.png[/img]{Unholdy padły, rozkazujesz ludziom zabrać trofea jako dowód waszej pracy, a może coś do własnego użytku. Skoro z krowy można zrobić skórę, to na pewno da się zrobić coś godnego takich olbrzymów. Tak czy inaczej, %employer% będzie czekał. | Gdy olbrzymy padły co do jednego, %employer% powinien już czekać na twój powrót. Jego miasto będzie teraz bezpieczne na zawsze i nie będzie już potrzebować usług takich najemników jak ty. Rozmyślasz o tym, aż wybuchasz śmiechem, którego nikt z ludzi nie rozumie. Mówisz im, żeby to zignorowali i zbierasz ich do powrotu. | Te potworne bestie stawiały piekielny opór, ale nie miały szans z połączoną siłą, sprytem i zwykłymi jajami %companyname%. Każesz ludziom zabrać, co się da na trofea, i przygotować się do marszu powrotnego do %employer%. | Gdy padł ostatni z unholdów, zbierasz ludzi. %randombrother% skacze po brzuchu jednego z nich i wygląda na rozczarowanego, gdy każesz mu przestać i zejść. %employer% będzie szukał zabójców i ich trofeów, a nie gromady dzieci.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Czas na zapłatę.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SignsOfAFight",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_113.png[/img]{Gdy olbrzymy padły, szykujesz ludzi do powrotu do %employer%, ale %randombrother% zwraca twoją uwagę drżeniem w głosie. Podchodzisz i widzisz, jak stoi przy jednym z powalonych unholdów. Wskazuje na jego ciało rozerwane na plastry, zwisające jak kłosy kukurydzy. Te obrażenia znacznie przewyższają możliwości waszej broni. Najemnik odwraca się i patrzy gdzieś za ciebie, oczy mu się rozszerzają.%SPEECH_ON%Jak myślisz, co to zrobiło?%SPEECH_OFF%Dalej na skórze widać wklęsłe blizny jak spodki z przebitymi otworami. Wspinasz się na unholda i wbijasz miecz w jedno z tych wgłębień, wyrywając z niego ząb długości przedramienia. Na krawędziach ma zadziory, jakby ząb miał zęby. Ludzie to widzą i zaczynają szeptać, a ty żałujesz, że to widziałeś, bo nie potrafisz tego pojąć.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Dzicz jest ciemna i pełna strachów.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Success",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_79.png[/img]{%employer% wita twój powrót, niemal natychmiast mówiąc, że od czasu twojego wyjścia nie słyszał ani jednej historii o splądrowaniu przez unholdy. Kiwasz głową i przedstawiasz dowód, mokre szczątki zabitych olbrzymów chlupią, gdy toczysz je po jego podłodze. Drewno plami się jakbyś rozwinął dywan. Burmistrz zaciska usta.%SPEECH_ON%Co do diabła, najemniku?%SPEECH_OFF%Przechylasz głowę i unosisz brwi. Mężczyzna opuszcza dłonie i lekko się kłania.%SPEECH_ON%Ach, nie szkodzi! Wszystko w porządku! Proszę, twoja zapłata, jak obiecano!%SPEECH_OFF% | Wracasz do %employer% i zastajesz go, jak czyta dzieciom opowieści. Machając ręką, ryczy jak bestia. Pukasz do drzwi i wchodzisz w sam środek przedstawienia.%SPEECH_ON%A wtedy wielebnie szanowni najemnicy ubili potwora!%SPEECH_OFF%Dzieci wiwatują na twój widok. Burmistrz wstaje i wręcza ci obiecaną zapłatę, mówiąc, że miał zwiadowcę śledzącego każdy twój ruch i już słyszał raporty o sukcesie. Pyta, czy zostaniesz i opowiesz historię dzieciakom. Mówisz, że nie pracujesz za darmo, i wychodzisz. | Musisz trochę poszukać po mieście, by znaleźć %employer%, który akurat jest zajęty w swojej komnacie z młodą dziewczyną chowającą się pod prześcieradłem, na którym ich przyłapałeś. Burmistrz ubiera się bez skrępowania nagością. Rzuca dziewczynie monetę i zwraca się do ciebie.%SPEECH_ON%Tak, najemniku, spodziewałem się ciebie! Twoja nagroda, jak obiecano!%SPEECH_OFF%Podaje ci sakiewkę, ale jedna moneta wysuwa się i toczy między deski podłogi. Mężczyzna zaciska usta, po czym wraca do dziewczyny, wyrywa monetę z jej dłoni i wrzuca ją do sakiewki. | %employer% kłóci się z chłopami o niezapłacone podatki i o to, że panowie ziemi i tak dostaną swoje monety. Pojawienie się uzbrojonego człowieka takiego jak ty jest nader na miejscu i sprawia, że parobki uciekają po sakiewki. Mówisz im, żeby się uspokoili, po czym zwracasz się do burmistrza po pieniądze. Wyciąga je z szuflady, zatrzymując się tylko po to, by wypełnić sakiewkę po brzegi, zabierając monetę chłopu, po czym wręcza ją tobie.%SPEECH_ON%Doceniam twoją pracę, najemniku.%SPEECH_OFF% | Zdajesz %employer% relację, a on, co zaskakujące, wcale nie okazuje niedowierzania.%SPEECH_ON%Ano. Miałem zwiadowcę śledzącego twoją kompanię i wrócił do miasta przed tobą. Każde twoje słowo pokrywa się z jego raportem. Twoja zapłata, jak obiecano.%SPEECH_OFF%Podaje ci sakiewkę.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Udane polowanie.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Oczyściłeś okolicę z unholdów");
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "SuccessPeaceful",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_79.png[/img]{%employer% przykłada palce do kącików oczu, po czym rozkłada je na boki.%SPEECH_ON%Niech zrozumiem, jeden z twoich najemników wykrzyczał olbrzymy do odwrotu?%SPEECH_OFF%Kiwasz głową i mówisz, w którą stronę poszły, co, co ważne, jest kierunkiem od %townname%. Burmistrz odchyla się na krześle.%SPEECH_ON%Cóż. No to dobrze. Chyba to już nie mój problem. Martwe czy gone, wszystko jedno.%SPEECH_OFF%Podaje ci sakiewkę, ale przez chwilę trzyma na niej dłoń.%SPEECH_ON%Wiesz, że jeśli kłamiesz i wrócą, wyślę każdego gołębia, jakiego mam, by opowiadał o twoim honorze.%SPEECH_OFF%Wstajesz, dobywasz miecza i mówisz, że gdy wrócą, będą mieli jego czaszkę jako podnóżek. Mężczyzna kiwa głową i puszcza sakiewkę.%SPEECH_ON%Bez urazy, najemniku, to tylko interes.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Udane polowanie.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Oczyściłeś okolicę z unholdów");
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"shouter",
			this.m.Dude != null ? this.m.Dude.getName() : ""
		]);
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Target.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/unhold_attacks_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.setAttackableByAI(true);
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Home != null && !this.m.Home.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Home.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(3);
			}
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

