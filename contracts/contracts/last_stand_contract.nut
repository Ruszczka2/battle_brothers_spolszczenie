this.last_stand_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		local r = this.Math.rand(1, 100);

		if (r <= 70)
		{
			this.m.DifficultyMult = this.Math.rand(95, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}

		this.m.Type = "contract.last_stand";
		this.m.Name = "Obrona Osady";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.m.MakeAllSpawnsResetOrdersOnContractEnd = false;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		if (this.m.Home == null)
		{
			this.setHome(this.World.State.getCurrentTown());
		}

		this.m.Flags.set("ObjectiveName", this.m.Origin.getName());
		this.m.Name = "Obrona " + this.m.Origin.getName();
		this.m.Payment.Pool = 1600 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Udaj się do %objective% na %direction%",
					"Obroń osadę przed nieumarłymi"
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
					this.Flags.set("IsUndeadAtTheWalls", true);
				}
				else if (r <= 70)
				{
					this.Flags.set("IsGhouls", true);
				}

				this.Flags.set("Wave", 0);
				this.Flags.set("Militia", 7);
				this.Flags.set("MilitiaStart", 7);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
					this.Contract.m.Origin.setLastSpawnTimeToNow();
				}
			}

			function update()
			{
				if (this.Contract.m.Origin == null || this.Contract.m.Origin.isNull() || !this.Contract.m.Origin.isAlive())
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
					return;
				}
				else if (this.Contract.isPlayerNear(this.Contract.m.Origin, 600) && this.Flags.get("IsUndeadAtTheWalls") && !this.Flags.get("IsUndeadAtTheWallsShown"))
				{
					this.Flags.set("IsUndeadAtTheWallsShown", true);
					this.Contract.setScreen("UndeadAtTheWalls");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Origin) && this.Contract.m.UnitsSpawned.len() == 0)
				{
					this.Contract.setScreen("ADireSituation");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Running_Wait",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Obroń %objective% przed nieumarłymi"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
					this.Contract.m.Origin.setLastSpawnTimeToNow();
				}
			}

			function update()
			{
				if (this.Contract.m.Origin == null || this.Contract.m.Origin.isNull() || !this.Contract.m.Origin.isAlive())
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Contract.m.UnitsSpawned.len() != 0)
				{
					local contact = false;

					foreach( id in this.Contract.m.UnitsSpawned )
					{
						local e = this.World.getEntityByID(id);

						if (e.isDiscovered())
						{
							contact = true;
							break;
						}
					}

					if (contact)
					{
						if (this.Flags.get("Wave") == 1)
						{
							this.Contract.setScreen("Wave1");
						}
						else if (this.Flags.get("Wave") == 2)
						{
							this.Contract.setScreen("Wave2");
						}
						else if (this.Flags.get("IsGhouls"))
						{
							this.Contract.setScreen("Ghouls");
						}
						else if (this.Flags.get("Wave") == 3)
						{
							this.Contract.setScreen("Wave3");
						}

						this.World.Contracts.showActiveContract();
					}
				}
				else if (this.Flags.get("TimeWaveHits") <= this.Time.getVirtualTimeF())
				{
					if (this.Flags.get("IsGhouls") && this.Flags.get("Wave") == 3)
					{
						this.Flags.set("IsGhouls", false);
						this.Flags.set("Wave", 2);
						this.Contract.spawnGhouls();
					}
					else
					{
						this.Contract.spawnWave();
					}
				}
			}

		});
		this.m.States.push({
			ID = "Running_Wave",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Obroń %objective% przed nieumarłymi"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
					this.Contract.m.Origin.setLastSpawnTimeToNow();
				}

				foreach( id in this.Contract.m.UnitsSpawned )
				{
					local e = this.World.getEntityByID(id);

					if (e != null)
					{
						e.setOnCombatWithPlayerCallback(this.onCombatWithPlayer.bindenv(this));
					}
				}
			}

			function update()
			{
				if (this.Contract.m.Origin == null || this.Contract.m.Origin.isNull() || !this.Contract.m.Origin.isAlive())
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Contract.m.UnitsSpawned.len() == 0)
				{
					if (this.Flags.get("Wave") < 3)
					{
						local militia = this.Flags.get("MilitiaStart") - this.Flags.get("Militia");
						this.logInfo("militia losses: " + militia);

						if (militia >= 3)
						{
							this.Contract.setScreen("Militia1");
						}
						else if (militia >= 2)
						{
							this.Contract.setScreen("Militia2");
						}
						else
						{
							this.Contract.setScreen("Militia3");
						}
					}
					else
					{
						this.Contract.setScreen("TheAftermath");
					}

					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatWithPlayer( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
				local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
				p.Music = this.Const.Music.UndeadTracks;
				p.CombatID = "ContractCombat";

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull() && this.World.State.getPlayer().getTile().getDistanceTo(this.Contract.m.Origin.getTile()) <= 4)
				{
					p.AllyBanners.push("banner_noble_11");

					for( local i = 0; i < this.Flags.get("Militia"); i = i )
					{
						local r = this.Math.rand(1, 100);

						if (r < 60)
						{
							p.Entities.push({
								ID = this.Const.EntityType.Militia,
								Variant = 0,
								Row = -1,
								Script = "scripts/entity/tactical/humans/militia",
								Faction = 2,
								Callback = null
							});
						}
						else if (r < 85)
						{
							p.Entities.push({
								ID = this.Const.EntityType.Militia,
								Variant = 0,
								Row = -1,
								Script = "scripts/entity/tactical/humans/militia_veteran",
								Faction = 2,
								Callback = null
							});
						}
						else
						{
							p.Entities.push({
								ID = this.Const.EntityType.Militia,
								Variant = 0,
								Row = 2,
								Script = "scripts/entity/tactical/humans/militia_ranged",
								Faction = 2,
								Callback = null
							});
						}

						i = ++i;
					}
				}

				this.World.Contracts.startScriptedCombat(p, this.Contract.m.IsPlayerAttacking, true, true);
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_combatID == "ContractCombat" && _actor.getFlags().has("militia"))
				{
					this.Flags.set("Militia", this.Flags.get("Militia") - 1);
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

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = false;
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{Zastajesz %employer%a, jak pomaga młodemu szlachcicowi celować z łuku w słomianą kuklę. Prostuje chłopakowi plecy i każe mu głęboko odetchnąć przed strzałem. Niedoświadczony łucznik kiwa głową i robi, co mu każano. Strzała wylatuje, odbija się od ziemi i z trzaskiem wpada do stajni, gdzie kilka koni rżą na ten strach. Szlachcic klepie chłopca po plecach.%SPEECH_ON%Zaufaj mi, za pierwszym razem byłem gorszy. Ćwicz dalej. Za chwilę wracam.%SPEECH_OFF%Szlachcic podchodzi do ciebie, kręcąc głową i ściszając głos.%SPEECH_ON%Sprawy są złe, najemniku. Młodzi nie wiedzą, jakie niebezpieczeństwa czają się teraz, ale ty wiesz. Mamy osadę, %objective% %direction% stąd, która otoczona jest przez... no, zło tego świata. Nie mam ludzi do wysłania, dlatego potrzebuje ciebie. Jedź tam i ocal wioskę, a dobrze cię opłacę, zapewniam!%SPEECH_OFF% | Zastajesz %employer%a wpatrzonego w jeden ze swoich mieczy. Ma go wyciągnięty i ogląda swoją twarz w stalowym odbiciu.%SPEECH_ON%Gdy uczono mnie używać takiego ostrza, było to przeciw ludziom. A teraz? Mówią o umarłych, o zielonoskórych, o bestiach bez miary!%SPEECH_OFF%Wbija miecz do pochwy i rzuca go na stół. Przeczesuje włosy dłonią.%SPEECH_ON%%objective% %direction% stąd potrzebuje pomocy. Otoczyły je te... te rzeczy! Nie wiem, czym są, ale wiem, że zabijają i zabijają! Nie mam ludzi do wysłania, ale jeśli tam pojedziesz i pomożesz, zostaniesz sowicie wynagrodzony!%SPEECH_OFF% | Zastajesz %employer%a siedzącego między opatem i skrybą, którzy kłócą się starymi, trzeszczącymi głosami. Skoro umarli powstają, dyskusje o śmierci i życiu po niej toczą się zaciękle. Szlachcic dostrzega cię i zrywa się na nogi. Podbiega, a kłótnia trwa dalej w tle.%SPEECH_ON%Dzięki starym bogom, że jesteś, najemniku. %objective% leży %direction% stąd i jest oblężone przez armię potworności. Nieumarlych, paskudztw, sam nie wiem. Wiem tylko, że nie mam ludzi, by je obronić. Jedź tam, upewnij się, że ludzie są bezpieczni, a dobrze cię opłacę!%SPEECH_OFF% | Zastajesz %employer%a nad sextonami opuszczającymi trumnę do grobu. Jest mocno przybita, wręcz w pospiechu: gwoźdźe są powyginane, a po bokach widać zarysowania. Na twój widok szlachta podchodzi.%SPEECH_ON%Mieszkaniec tego pudła postanowił wyjść. Zabił dziecko i psa. Prawie zabił kolejnego, zanim straż go położył z powrotem.%SPEECH_OFF%Z dna trumny wypływa czarna ciecz. Grabarze odskakują, upuszczając skrzynię prosto do grobu z głuchym łomotem. %employer% kręci głową.%SPEECH_ON%Przez te 'nieumarłe' przypadki moje siły są rozproszone. Właśnie dotarła wiadomość, że %objective% %direction% stąd też jest atakowane. Najemniku, pojedziesz tam i pomożesz je ocalić?%SPEECH_OFF% | Zastajesz %employer%a nad stertą książek porozrzucanych na biurku. Kręci głową, jakby każde poruszenie przewracało kolejną stronę. Zniecierpliwiony macha na ciebie.%SPEECH_ON%Nie ociągaj się, najemniku, nie mamy na to czasu. Musisz iść do %objective% %direction% stąd. Moje ptaki mówią, że jest atakowane, kolejne te przeklęte 'nieumarłe' wstały. Jesteś zainteresowany? Zapłata w pełni wynagrodzi wysiłek.%SPEECH_OFF% | Zastajesz %employer%a obserwującego kamieniarzy układających przycięte bloki. Ściska ci dłoń.%SPEECH_ON%Budujemy kolejne opactwo, najemniku, jak wygląda?%SPEECH_OFF%Wygląda dobrze, ale wskazujesz, że po drugiej stronie drogi stoi już inne. Szlachcic się uśmiecha.%SPEECH_ON%Nieumarłe znów chodzą po ziemi, a ławki w świątyniach nie wystarczą dla przestraszonych. Wezwałem cię, bo moje siły są rozproszone przez ten... dziwny problem. Jest miasteczko %direction% stąd, %objective%, które pilnie potrzebuje pomocy. Moje ptaki mówią, że jest pod atakiem, a ty wygląd asz na kogoś, kto chętnie je uratuje. Za odpowiednią cenę, oczywiście.%SPEECH_OFF% | %employer%, skarbnik i dowódca rozmawiają. Skarbnik mówi, że koron nie brakuje, ale dowódca twierdzi, że nie ma ludzi do walki. Wchodzisz i od razu przechodzą do rzeczy.%SPEECH_ON%Najemniku! Potrzebujemy twoich usług natychmiast! Mamy wioskę %direction% stąd, zwaną %objective%, która jest atakowana przez... eee, jak to się zwie?%SPEECH_OFF%Dowódca pochyla się do szlachcica i szepce odpowiedź. Ten prostuje się.%SPEECH_ON%Atakowana przez... 'nieumarłych'. Tak. Pojedziesz tam i obronisz tych biedaków?%SPEECH_OFF% | W końcu znajdujesz %employer%a w stajni. Zakłada siodło na konia i zauważa, że trzymasz dystans.%SPEECH_ON%Boisz się, najemniku?%SPEECH_OFF%Wzruszasz ramionami, mówiąc, że nigdy nie lubiłeś bestii. Szlachcic wzrusza ramionami i dosiada konia.%SPEECH_ON%Jak chcesz. Moje ptaki donoszą o kłopotach %objective% - wielka horda nieumarłych dobija się do bram i raczej nie przynoszą mleka. Jeśli tam pojedziesz i pomożesz obronić wioskę, po powrocie będzie tu na ciebie czekać solidna sakiewka.%SPEECH_OFF% | Zastajesz %employer%a spacerującego po murach fortecy. Strażnicy są wyprostowani i czujni. Na twój widok szlachcic macha, byś podszedł. Razem patrzycie przez blanki. Ziemia rozciąga się przed wami, lasy wyglądają jak kropki, góry jak groty strzał, ptaki rysują łuki na niebie.%SPEECH_ON%%direction% stąd leży %objective%. Posłańcy mówią, że jest atakowane przez niewiarygodną siłę, konkretnie nieumarłych. Tak, aż tak niewiarygodne. Cokolwiek naciera na mury, nie mam ludzi, by temu sprostać. Ale ty, najemniku, idealnie się do tego nadajesz. Zainteresowany?%SPEECH_OFF% | Zastajesz %employer%a i wychudzonego skryby wpatrzonych w bezgłowe ciało na kamiennej płycie. Głowa leży w rogu, oczy przysłonięte, stalowe pręty wystają z połowy wyrzeźbionej czaszki. Na twój widok szlachcic wyciąga dłoń.%SPEECH_ON%Nie ma się czego bać, najemniku. Jak pewnie słyszałeś, umarli znów chodzą po ziemi, a to rodzi wiele spekulacji, dlaczego.%SPEECH_OFF%Skryba podnosi wzrok i wtrąca.%SPEECH_ON%Albo jak...%SPEECH_OFF%Szlachcic uśmiecha się i kontynuuje.%SPEECH_ON%W każdym razie %objective% %direction% stąd jest atakowane przez te potwory, eee, były ludzi? Nie mam ludzi, by posłać pomoc. Ty jednak jesteś idealny do tej roboty. Podejmiesz się?%SPEECH_OFF% | %employer% słucha szeptów skryby, gdy wchodzisz do pokoju. Skryba rzuca na ciebie żółte spojrzenie i kontynuuje, po czym obaj kiwają głowami, a starszy odchodzi. Nawet na ciebie nie patrzy. %employer% woła.%SPEECH_ON%Dobrze, że jesteś, najemniku! To naprawdę trudne czasy. Moi ludzie są rozproszeni po kraju, walcząc z różnymi potworościami. Na pewno już słyszałeś, ale 'nieumarli', czymkolwiek są, znów chodzą. I atakują %objective% %direction% stąd. Nie mam ludzi do wysłania, więc liczę na ciebie. Pomożesz ocalić to miasto?%SPEECH_OFF% | %employer% słucha próśb grupy chłopów. Docierasz na końcówkę rozmowy, gdy szlachcic gniewnie ich odprawia. Gdy prostacy krzyczą, strażnicy odprowadzają ich na zewnątrz, pokojowo na razie, brutalnie gdyby trzeba. Odchodzą bez dalszych protestów, choć jeden chłop patrzy na ciebie i bezgłośnie mówi 'pomóż nam'. %employer% macha ręką.%SPEECH_ON%No proszę, jeśli to nie najemnik! W sam czas, mój pazerny przyjacielu. Mam miasto %direction% stąd, %objective%, które desperacko potrzebuje pomocy. Obecnie, jak powiadaja, jest oblężone przez nieumarłych. Jeśli tam pojedziesz i pomożesz je obronić, czeka tu na ciebie duża sakiewka. Co ty na to, hm?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Ile to dla ciebie jest warte? | Możemy obronić %objective% za odpowiednią cenę...}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{To nie jest tego warte. | Obawiam się, że %objective% jest zdane na siebie.}",
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
			ID = "UndeadAtTheWalls",
			Title = "W %objective%...",
			Text = "[img]gfx/ui/events/event_29.png[/img]{Zbliżając się do %objective%, %randombrother% nagle woła z wysuniętego czoła.%SPEECH_ON%Panie, szybko!%SPEECH_OFF%Biegniesz do niego i patrzysz przed siebie. Miasto jest kompletnie otoczone bladym morzem nieumarłych, kiwających się i jęczących! %companyname% musi się przez nich przebić, by wejść do środka. | Mężczyzna podbiega do %companyname%. Trzyma się za rękę, a strumień krwi spływa mu po głowie. Krzyczy.%SPEECH_ON%Uciekajcie! Tu nic dla was poza grozą!%SPEECH_OFF%%randombrother% rzuca nieznajomego na ziemię i dobywa broni, by go zatrzymać. Powstrzymujesz najemnika, gdy patrzysz przed siebie: %objective% jest już otoczone przez wielu nieumarłych. %companyname% musi działać szybko! | Przybyłeś w sam czas: mury %objective% są już atakowane przez nieumarłych! | Zakręcając za ścieżkę, zatrzymujesz się nagle. Przed tobą %objective% otacza tłum nieumarłych. Bliżej stoi kilku, dziwnie odseparowanych od hordy. %companyname% musi przebić się do %objective%! | Mury %objective% są dziwnie szare - chwila, to nie drewno, to nieumarły! Z grozą widzisz, że blade potwory już atakują, ale masz jeszcze czas, by ocalić %objective% i przebić się do środka. Dobywasz miecza i rozkazujesz %companyname% do boju! | Bezkształtny tłum nieumarłych stoi już pod murami %objective%. Widzisz głowy obrońców wychylające się nad palisadą, starających się nie zdradzić. Dobywasz miecza i mówisz %companyname%, że muszą przebić się do miasta. | Kilku nieumarłych jest już przy bramach %objective%! Strażnicy na bramie machają do ciebie, przykładają palec do ust, po czym wskazują w dół. Wygląda na to, że potwory jeszcze nie atakują, bo nie wiedzą? Nie jesteś pewien, wiesz tylko, że %companyname% ma jedną drogę do środka i prowadzi ona przez ostrze! | Na szczęście %objective% wciąż stoi. Niestety mury są oblegane przez tłum bladych nieumarłych. %companyname% musi się przebić do środka!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						this.Contract.spawnUndeadAtTheWalls();
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ADireSituation",
			Title = "W %objective%...",
			Text = "[img]gfx/ui/events/event_79.png[/img]{Zastajesz strażników w %objective% wyglądających, jakby nie spali od tygodni, ale się uśmiechają. Twoje niezgrabne przedzieranie się do bramy najwyraźniej ich rozbawiło. | Niezgrabna i potykająca się, %companyname% wreszcie przechodzi przez bramę. W środku strażnicy stoją z rozbawioną rezygnacją, jakby dopiero co wyszli z koszmarnej bitwy, by być świadkami dziwnego żartu. Jeden klepie cię po ramieniu.%SPEECH_ON%To było cholernie zabawne do oglądania, najemniku, a moim ludziom podniosło morale. Dziękuję.%SPEECH_OFF% | Rozglądasz się i widzisz strażników jako chudych, kościstych ludzi pilnujących mieszkańców, którzy wyglądają jak na pół umarli. Zabłocone drogi są pełne brudu, śmieci i trupów zwierząt. Kobiety i dzieci płaczą nad prowizorycznym cmentarzem: rowem z listą imion, która co chwilę jest dopisywana. | Wchodzisz przez bramy %objective% i widzisz kilku strażników z dłońmi opartymi na włóczniach. Ich ubrania zwisają na kościach jak firanki. W powietrzu czuje się głód, a spojrzenia pełne oblizywania ust zdradzają, jak zdrowo wyglądasz. Jeden z obrońców wita cię dość serdecznie.%SPEECH_ON%Jesteśmy zmęczeni i trochę głodni, ale damy radę. Walka wciąż w nas siedzi, nie wątp w to.%SPEECH_OFF% | Gdy wchodzisz przez bramę %objective%, pierwszym, kto cię wita, jest pies, liżący twoje nogi i obwąchujący spodnie. Nagle pojawia się mężczyzna z maczugą, a zaraz potem człowiek i pies pędzą błotnistą ulicą, obaj jakby szczekając. Kundel umyka powolnym skokom głodnej tłuszczy i znika. Uśmiechnięty strażnik podchodzi, podpierając się kijem.%SPEECH_ON%Dobry wieczór, najemniku. Zapasy są niskie, a taki piesek to uczciwa zdobycz w krainie pustych brzuchów.%SPEECH_OFF%Pytasz, czy wciąż potrafią walczyć, a on się śmieje.%SPEECH_ON%Do diabła, tylko walka nam została!%SPEECH_OFF% | Przejście przez bramy %objective% to jak wejście z normalności w samo piekło. Mieszkańcy powłóczą się bez celu, głodni i coraz bardziej słabnący, a strażnicy dzielą się żartami jak jedzeniem, śmiejąc się i trzymając się za brzuchy. Dowódca obrony podchodzi. Jest nieogolony, poraniony, z opuszczoną szczęką, oczy ma zmęczone jak on sam. Choć stoi blisko, sprawia wrażenie, jakby patrzył z innego świata.%SPEECH_ON%Cieszę się, że dotarłeś, najemniku. Potrzebujemy twojej pomocy bardziej niż kiedykolwiek.%SPEECH_OFF% | Przechodzisz przez bramy %objective% i witasz się z piekłem. Strażnicy stoją jak szkielety podparte przez szaleńca, a mieszkańcy leżą w brudzie albo opierają się twarzą o mury. Dzieci stoją na strzechach i szukają owadów. Porucznik obrony wita cię krótko.%SPEECH_ON%Dzięki, że przyszedłeś, najemniku, ale powinieneś był zostać w domu.%SPEECH_OFF% | Przednie wrota %objective% z trudem się otwierają. Wchodzisz do miasta i widzisz grabarzy kopiących ogromny rów tuż przy drodze. Wrzucają ciała i szykują ognie do spalenia zwłok. Porucznik obrony podchodzi.%SPEECH_ON%Czasem martwi wracają, ale popiołu już nie. No może wracają, ale nikomu nie szkodzi.%SPEECH_OFF%Chcesz wspomnieć o strasznym smrodzie, ale rozumiesz, że pewnie przywykli do niego dawno temu. | Za zagraconymi bramami %objective% widzisz miasto, które jakby już uległo hordom nieumarłych. Mieszkańcy powłóczą się bez celu i bez nadziei. Kilku strażników stoi przy wozie, rozdają racje. Widzisz kilku obrońców śpiących na murach, z rękami zwisającymi na blankach i ściśniętymi na broni, jak lalki rzucone w kąt. Porucznik obrony podchodzi.%SPEECH_ON%Dziękuję, że przyszedłeś, najemniku. Wielu z nas nie myślało, że przyjdziesz, biorąc pod uwagę, że to piekło.%SPEECH_OFF% | Bramy %objective% otwierają się i wchodzisz do środka. Widzisz dwóch strażników ciągnących zwłoki w stronę płonącego stosu. Kobieta trzyma buty zmarłego, prosząc o ostatnie spojrzenie. Ignorują ją, wrzucają ciało w ogień, a ona pada przed stosem, gdy skóra jej męża trzaska i pęka. Porucznik obrony podchodzi i klepie cię po ramieniu.%SPEECH_ON%Dobrze, że jesteś, najemniku.%SPEECH_OFF% | Za bramami %objective% podbiega do ciebie mężczyzna i chwyta za kołnierz.%SPEECH_ON%Masz jedzenie? Hmm? Czuję je, a może to ty jesteś jedzeniem?%SPEECH_OFF%Strażnik odrywa go końcem włóczni. Szaleniec trzyma się za brzuch i mówi, wydłubując wszy z brwi i zjadając je.%SPEECH_ON%Przynieśliście więcej mieczy, ale miecze nie są tym, czego nam trzeba!%SPEECH_OFF%Strażnicy odprowadzają go, a porucznik podchodzi.%SPEECH_ON%Nie zwracaj na niego uwagi. Kiedyś był grubszy, więc obecne czasy szczególnie go bolą. Mamy jeszcze jedzenie, tylko trzeba je racjonować. Doceniamy wasze miecze, najemniku, i nie myl się, wkrótce ich użyjesz.%SPEECH_OFF% | Wchodzisz przez bramy %objective% i uderza cię zapach spalonego mięsa. Jest tam tlący się stos zwłok, przy którym stoi strażnik z kijem, mieszając popiół jak kucharz zupę. Mieszkańcy stoją obok zwęglonych szczątków, wykonując obrzędy i ocierając łzy. Porucznik miasta podchodzi.%SPEECH_ON%Atak może przyjść z każdej strony. Martwi wracają, a my cierpimy. Ten stos to była rodzina. Żona umarła w nocy i, pod osłoną ciemności, jadła i jadła. Palimy wszystkie ciała. Musimy.%SPEECH_OFF%Porucznik widzi twoją krzywiznę i łagodzi ton z uśmiechem.%SPEECH_ON%A jak ci mija dzień?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Musimy się przygotować na nadciągający atak...",
					function getResult()
					{
						this.Flags.set("Wave", 1);
						this.Flags.set("TimeWaveHits", this.Time.getVirtualTimeF() + 8.0);
						this.Contract.setState("Running_Wait");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Wave1",
			Title = "W %objective%...",
			Text = "[img]gfx/ui/events/event_29.png[/img]{Czekanie niemal cię zabija, gdy nagle nadchodzi coś, co zrobi to szybciej: nieumarli! Dzwony %objective% zaczynają bić, a strażnicy ruszają do akcji z niespodziewaną żywością. Rozkazujesz %companyname% przygotować się do bitwy. | Gdy przyglądasz się grze w karty, rozlegają się dzwony. Spoglądasz na klasztor i widzisz starca bijącego w dzwon z całej siły. Strażnicy reagują, odzyskując energię. Jeden krzyczy z bramy.%SPEECH_ON%Nadchodzą, do broni!%SPEECH_OFF% | Gdy myślisz, że dołączysz do mieszkańców w bezczynności i powolnym umieraniu, brama się otwiera i wjeżdża zwiadowca na koniu. Zwierzę pada wyczerpane, sunie po błotnistym gruncie, a jeździec zeskakuje i turla się. Wstaje i krzyczy.%SPEECH_ON%Umarli nadchodzą! Musimy się przygotować!%SPEECH_OFF% | Z warty rozlega się okrzyk.%SPEECH_ON%Nadchodzi wiadomość, uwaga na głowy!%SPEECH_OFF%Patrzysz w górę i widzisz strzałę łukującą przez niebo, spadającą w błoto kilka kroków od ciebie. Porucznik zrywa zwój z grotu. Im dłużej czyta, tym bardziej blednie, po czym rzuca papier.%SPEECH_ON%Czas się szykować, najemniku, umarli idą.%SPEECH_OFF%Odwraca się do żołnierzy.%SPEECH_ON%Obrońcy %objective%! Do broni!%SPEECH_OFF% | Jeden ze strażników krzyczy.%SPEECH_ON%Bramy otwarte, uchodźcy nadchodzą!%SPEECH_OFF%Przez bramę wpada rozbiegana gromadka dzieci. Jedno tłumaczy, że zbliża się horda bladych ludzi. Porucznik patrzy na ciebie.%SPEECH_ON%Lepiej przygotuj ludzi, najemniku.%SPEECH_OFF%Nieumarli idą, szykujcie się do walki! | Zwiadowca wjeżdża do %objective% i zsiada z konia o zakrwawionych nogach i bez ogona. Trzyma bezdłonną rękę, a z twarzy wyrwana ma część ucha i oka. Porucznik podbiega, rozmawiają, po czym zwiadowca traci przytomność. Porucznik wzdycha i podchodzi.%SPEECH_ON%Nieumarli atakują, szykujcie się! I dobijcie tego rumaka!%SPEECH_OFF%Kiwasz głową i rozkazujesz %companyname% gotować się do bitwy. Gdy najemnicy się przygotowują, podchodzi rzeźnik i rąbie konia tasakiem. Porucznik klepie cię po ramieniu.%SPEECH_ON%Hej, przynajmniej będzie co zjeść, jeśli to przetrwamy.%SPEECH_OFF% | Siadasz obok porucznika. Dzieli się chlebem.%SPEECH_ON%Od kiedy przybyłeś, jest podejrzanie cicho.%SPEECH_OFF%Gryziesz i pytasz, czy sugeruje, że jesteś podwójnym agentem umarłych. Śmieje się.%SPEECH_ON%W tych czasach niczego nie można być pewnym.%SPEECH_OFF%W tej chwili rozlega się dzwon, a strażnicy ruszają na mury. Wybuchają krzyki. Nieumarli atakują!\n\n Porucznik zarzuca hełm i pomaga ci wstać.%SPEECH_ON%Czas udowodnić swą wartość, najemniku.%SPEECH_OFF% | Jeden ze strażników bierze lunetę w skórzanym futerale i zagląda przez blanki. Ręce zaczynają mu drzeć, luneta wypada i roztrzaskuje się o kamienie. Wskazuje i krzyczy.%SPEECH_ON%N-nieumarli są tu! D-do broni! Bicie w dzwony!%SPEECH_OFF%Patrzysz przez mury, ale nie potrzebujesz lunety, by zobaczyć nadchodzącą falę bladych. Uspokajasz strażnika i pędzisz szykować %companyname% do bitwy. | Wataha psów dotarła do %objective% i wyje, by je wpuścić. Głodni mieszkańcy spełniają ich prośbę i gdy tylko kundelki wchodzą, rzucają się na nie noże i kosy. Mimo rzeźi psy wciąż napierają, walcząc i gryząc, by znaleźć bezpieczeństwo w rzeźni. Spoglądasz na mury i widzisz, dlaczego ryzykują: nieumarli nadchodzą, sunąc i szurając po horyzoncie.\n\n Gwiżdżesz na człowieka w dzwonnicy i wskazujesz. Prostuje się tak szybko, że metalowy kapturek spada i z brzęczeniem uderza o kamień. Pośpiesznie bije w dzwon, a jego głos ucisza psie wycie poniżej. Ludzie i zwierzęta zamierają, zapada ponury bezruch. Powoli w powietrze wsiąka jazgot śmierci, jęczenie i warczenie. Porucznik straży wkracza z bronią w dłoni.%SPEECH_ON%Do broni, ludzie! Do broni!%SPEECH_OFF% | Jeden nieumarły szura pod murem %objective%. Strażnicy na zmianę strzelają do niego z łuków.%SPEECH_ON%Patrzcie, trafił go w stopę!%SPEECH_OFF%Inny strażnik naciąga cięciwę.%SPEECH_ON%Wciąż idzie. Celuj w głowę, glupcze.%SPEECH_OFF%Strzała trafia i słychać cichy -tok- gdy przebija pusty mózg. Ciało na moment traci równowagę, zatrzymuje się, po czym idzie dalej, jakby przypomniało sobie cel. Kolejny strażnik kręci głową i naciąga cięciwę. Mruży jedno oko, potem powoli je otwiera. Ręce mu drzą, a strzała stuka o drewniany łuk.%SPEECH_ON%D-do... do broni! Bijcie na alarm!%SPEECH_OFF%Patrzysz na mury i widzisz szare morze wyłaniające się na horyzoncie. Nieumarli atakują! | Miasto jest ciche, tylko trzaski ognia wypełniają powietrze. Widzisz, jak ludzie pieką szczura na rożnie i odkrawają kawałki. Gdy masz dość, idziesz na mury, gdzie porucznik straży obserwuje horyzont przez lunetę. Odkłada ją ponuro.%SPEECH_ON%No to po nas, nadchodzą.%SPEECH_OFF%Podaje ci szkło i spoglądasz. Gromada rybich, zniekształconych nieumarlych sunie ku %objective%. Porucznik odbiera lunetę.%SPEECH_ON%Czas zarobić na zapłatę, najemniku.%SPEECH_OFF% | Krzyk kobiety zmusza cię do odwrócenia się. Widzisz, jak mężczyzna skacze z wieży i łamie kark na linie. Ciało kiwa się, obija o mury. Porucznik zaciska usta i pluje.%SPEECH_ON%Cholera, miał pilnować horyzontu. %randomname%! Weź go, odetnij i zajmij jego posterunek!%SPEECH_OFF%Inny strażnik mruczy i robi, co kazano, ale gdy dociera na wieżę, zaczyna histerycznie krzyczyć.%SPEECH_ON%Panie! Panie! Nadchodzą! Ci wszyscy bladzi, idą!%SPEECH_OFF%Porucznik krzyczy na żołnierzy, by szykowałi się do walki, a ty na swoich. Mężczyzna spogląda na ciebie z nadzieją.%SPEECH_ON%Cokolwiek ci płacą, mam nadzieję, że jesteś wart każdej korony, najemniku.%SPEECH_OFF% | Jeden ze strażników znalazł gniazdo szczurów, co wywołuje ponurą radość. Mieszkańcy krzyczą i placzą, a przenikliwe piski gryzoni idą na rożnie i do ognia. Porucznik straży podchodzi, obserwuje z uśmiechem, który znika, gdy powietrze rozdziera krzyk. Wszyscy odwracają się ku murom, gdzie strażnik wskazuje horyzont. Nawet stąd widzisz białka jego przestraszonych oczu.%SPEECH_ON%Umarli idą! Idą nas zabić! Nie mamy dość ludzi!%SPEECH_OFF%Porucznik każe mu wziąć się w garść, po czym cicho zwraca się do ciebie.%SPEECH_ON%Przygotuj ludzi, najemniku, i udowodnij, że jesteś wart tego, co ci płacą.%SPEECH_OFF% | Złapano strażnika, który próbował zdezerterować. Klęczy, a porucznik chodzi wokół z rozczarowaniem.%SPEECH_ON%Nie mamy ludzi, a ty nam to robisz?%SPEECH_OFF%Jeden z mieszczan rzuca bryłą błota, która leci w bok, ale intencja jest jasna.%SPEECH_ON%Żywcem go zakopać! Jedna paszcza mniej do karmienia!%SPEECH_OFF%Gdy tłum robi się burzliwy, dzwon miejski zaczyna bić. Mężczyzna na wieży krzyczy na całe gardło.%SPEECH_ON%Idą! Nieumarli, na horyzoncie!%SPEECH_OFF%Porucznik patrzy na dezertera.%SPEECH_ON%Chcesz odzyskać honor, zrób to teraz. Będziesz walczył?%SPEECH_OFF%Mężczyzna szybko kiwa głową. Porucznik zwraca się do ciebie, ale ty unosisz dłoń.%SPEECH_ON%Nie musisz zadawać %companyname% takich pytań.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Bronić miasta!",
					function getResult()
					{
						this.Contract.setState("Running_Wave");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Wave2",
			Title = "W %objective%...",
			Text = "[img]gfx/ui/events/event_73.png[/img]{Gdy %companyname% odpoczywa, czyszcząc z broni śluz i ścieki, z dzwonnicy nadchodzi kolejny sygnał. Nieumarli znów atakują! | Porucznik obchodzi ludzi, upewniając się, że odpoczywają i piją wodę. Gdy podchodzi do ciebie, dzwon bije, a wartownik krzyczy, że nadchodzi kolejny atak! Uśmiechasz się i klepiesz porucznika po ramieniu.%SPEECH_ON%Robimy tylko to, co trzeba. Nic prostszego, prawda?%SPEECH_OFF%Porucznik kiwa głową i idzie szykować ludzi. | Widzisz, jak %randombrother% zeskrobuje z ostrzy bladych resztki mięsa i mokre strzepy odzienia.%SPEECH_ON%Na starych bogów, jaki syf po sobie zostawiają.%SPEECH_OFF%W tej chwili wartownik gwiżdże i krzyczy, że nieumarli znów atakują! Najemnik wśiekle zrzuca kawałek mózgu z ostrza.%SPEECH_ON%A akurat zacząłem widzieć swoje odbicie!%SPEECH_OFF%Pomagasz mu wstać, klepiąc po ramieniu.%SPEECH_ON%Uwierz, niewiele tracisz.%SPEECH_OFF% | Jeden ze strażników kruszy twardą bułę i rozdaje okruchy. Inny pyta, skąd ma jedzenie, a ten odpowiada krótko.%SPEECH_ON%Z kieszeni jednego z tych trupów.%SPEECH_OFF%Jedzący wypluwają jedzenie, jeden nawet wymiotuje. Widzisz, jak mężzyźni zaczynają się bić, ale gwizd wartownika szybko ich rozdziela. Strażnik na wieży wskazuje horyzont.%SPEECH_ON%Znów nadchodzą! Do boju!%SPEECH_OFF%Szykuj się do walki i postaraj się nie zabierać jedzenia z ciał, które uważają cię za obiad. | Gdy twoi ludzie odpoczywają, wartownik krzyczy.%SPEECH_ON%Znów nadchodzą!%SPEECH_OFF%Wojna rzadko daje wytchnienie, zwłaszcza z nieumarłymi. | Widzisz %randombrother%a, jak wyciera twarz błotem. Zatrzymuje się, widząc twoje spojrzenie.%SPEECH_ON%Błotna kąpiel, panie. Żeby zmyć... krwawa kąpiel.%SPEECH_OFF%Przewracasz oczami. W tej chwili dzwon bije, a wartownik krzyczy, że nadchodzi kolejny atak! Każesz najemnikowi skończyć 'kąpiel' i szykować się do walki. | Zastajesz %randombrother%a, jak wyciąga zebrane strzepy szarych flaków zza uszu.%SPEECH_ON%Mama zawsze mówiła, żeby myć za uszami, ale chyba tego nie przewidziała!%SPEECH_OFF%Mówisz mu, że dobra matka przewiduje wszystko. Śmieje się i kiwa głową.%SPEECH_ON%No tak, krzychałaby tylko, skąd ja wziąłem ten brud!%SPEECH_OFF%W tej chwili wartownik na wieży krzyczy, że nieumarli znów atakują. Odwracasz się do najemnika.%SPEECH_ON%No cóż, czas się znowu ubrudzić.%SPEECH_OFF% | Zastajesz jednego z chłopów, jak nacina kreski na kamiennym murze. Na twój widok wyjaśnia.%SPEECH_ON%Liczę poległych. Tylu ich było, że nie zapamiętam imion, ale potrafię liczyć.%SPEECH_OFF%Patrzysz wzdłuż muru i widzisz, jak imiona zastępowane są liczbami.%SPEECH_ON%Robimy, co możemy, żeby pamiętać, wiesz?%SPEECH_OFF%Kiwasz głową i wtedy wartownicy krzyczą, że nadchodzi kolejny atak. Chłop chwyta cię za ramię z błagalnym spojrzeniem.%SPEECH_ON%Powiedz mi swoje imię, to wpiszę je, gdy nadejdzie czas.%SPEECH_OFF%Wyrywasz ramię i wpatrujesz się w niego tak, że maleje.%SPEECH_ON%Jestem zabójca, glupcze, nie twoim przyjacielem. Jedyna różnica między moim ostrzem a twoją szyją to ten, kto mi płaci. Jeśli spytasz jeszcze raz, wpiszę twój numer na ten mur za darmo, rozumiesz?%SPEECH_OFF%Mężczyzna kiwa głową. Ty również i odchodzisz szykować najemników do bitwy. | Gdy ty i ludzie szykujecie się do odpoczynku, wartownicy krzyczą, a dzwon zaczyna bić. Nadchodzi kolejny atak! Rozkazujesz %companyname% przygotować się do walki. | Wspinasz się na mury %objective% i znajdujesz porucznika straży. Wzdycha.%SPEECH_ON%Atakują. Znowu.%SPEECH_OFF%Patrzysz na horyzont i faktycznie, kolejna fala nadchodzi. Porucznik idzie zbierać ludzi do walki, a ty robisz to samo.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Bronić miasta!",
					function getResult()
					{
						this.Contract.setState("Running_Wave");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Wave3",
			Title = "W %objective%...",
			Text = "[img]gfx/ui/events/event_73.png[/img]{Gdy wszyscy odpoczywają, wartownik, z ochrypłym głosem, krzyczy zrezygnowany.%SPEECH_ON%Znowu. Nadchodzą... znowu.%SPEECH_OFF%%companyname% musi sprostać wyzwaniu, jeśli %objective% ma przetrwać! | Jeden ze strażników wpatruje się w ogień, ręce mu drzą. Mamrocze do siebie, ale głośniej, by wszyscy słyszeli.%SPEECH_ON%Tak, to zrobimy! Możemy z nimi pogadać! Dogadamy się! Porozmawiamy! Ja to zrobię, ja z nimi pogadam!%SPEECH_OFF%Mężczyzna wstaje. Kilku próbuje go powstrzymać, ale wymyka się i biegnie na mury, po czym skacze na zewnątrz. Widzisz, jak ten szaleniec pędzi prosto ku ogromnej fali nieumarlych! Inny strażnik zaczyna drzeć.%SPEECH_ON%Na starych bogów, znów nadchodzą? Skąd ich tyle?%SPEECH_OFF%Ignorujesz go i patrzysz, jak wariat znika w tłumie trupów. Horda na chwilę zwalnia, po czym rusza dalej, jak blada tafla poruszona kamieniem. Krzyczysz do ludzi.%SPEECH_ON%Do boju, ludzie! Znowu w ogień!%SPEECH_OFF% | Jeden z wartowników dostrzega kolejny atak! Krzyczy tak mocno, że pęka mu głos i mdleje. Milicja %objective% jest na skraju wyczerpania, oby to był ostatni szturm! | Wartownik gwiżdże ostrzeżenie, że nadchodzą kolejni nieumarli. Porucznik kręci głową.%SPEECH_ON%Na starych bogów, czy oni kiedyś przestaną? Dziś naprawdę zasłużyłeś na swój żołd, najemniku.%SPEECH_OFF%Masz ochotę żartować, że należy ci się więcej, ale to nie czas. Kiwasz głową i idziesz szykować %companyname% do kolejnej bitwy. | Gdy ty i porucznik wymieniacie opowieści, podchodzi milicjant. Widzisz, że to strażnik, który miał pilnować murów. Mówi krótko.%SPEECH_ON%Panowie, znów atakują.%SPEECH_OFF%I tak po prostu odwraca się na pięcie i idzie do zbrojowni. Wstajesz i pomagasz porucznikowi. Ten klepie cię po ramieniu, z poważnym uśmiechem.%SPEECH_ON%Znowu w wir, co?%SPEECH_OFF%Wzruszasz ramionami.%SPEECH_ON%Po to tu jesteśmy. Do zobaczenia na polu, poruczniku.%SPEECH_OFF% | Patrzysz z murów %objective% i widzisz kolejną falę nieumarłych. Cała ekscytacja poprzednich ataków znika. Obrońców ogarnia cisza, gdy ciała szurają dalej. Porucznik podchodzi do ciebie.%SPEECH_ON%To był zaszczyt walczyć u twego boku, najemniku.%SPEECH_OFF%Kiwasz głową i odpowiadasz.%SPEECH_ON%Mmm, zaszczyt, owszem.%SPEECH_OFF%Porucznik spogląda na ciebie.%SPEECH_ON%Myślisz o zapłacie, prawda?%SPEECH_OFF%Kiwając znów, odpowiadasz.%SPEECH_ON%Myślę, co kupię: ciepłe łóżko, cieplejszy posiłek i jeszcze cieplejszą dziewkę.%SPEECH_OFF% | Stoisz na murach %objective% i patrzysz na horyzont. Nadchodzi kolejny atak, ale nie ma w tym ekscytacji. Żadnych krzyków, histerii. Już nie. Po prostu nadchodzi. Nabrzmiała, szurająca, zniekształcona armia trupów sunie naprzód, jakby prosiła o kolejny rozbiór. Rozkazujesz %companyname% przygotować się. %randombrother% niedowierzająco rozkłada ręce, połowa ciała oklejona mokrymi resztkami rozerwanych nieumarlych.%SPEECH_ON%Panie, chyba mamy ich dość.%SPEECH_OFF%Ludzie śmieją się, milicja dołącza, a wkrótce śmiech wypełnia powietrze, zmieszany z jęczeniem coraz bliższych nieumarlych, szaleństwo wzmocnione. | %randombrother% podchodzi do ogniska, zrzucając długie pasma wnętrzności z ramion. Chłop zerka na trzewia, jakby był o jedno burczenie brzucha od ugrzyzienia. Najemnik siada z ciężkim westchnieniem.%SPEECH_ON%Jeśli jeszcze raz zobaczyę trupa idącego na mnie jak na obiad, to ja...%SPEECH_OFF%Zanim kończy zdanie, wartownik na murach dmie w róg i ryczy ostrzeżenie. Upuszcza go, czerwony na twarzy i zziajany.%SPEECH_ON%Ni... nieumarli... znów atakują!%SPEECH_OFF%Twarz najemnika kamienieje. Wstaje i bez słowa idzie po broń. | Rolnik stoi przy bramach %objective% i kłóci się z obrońcami.%SPEECH_ON%Wypuścić mnie! Przecież już ich wybiliście, chcę wrócić na swoje pola. Mam dwie krowy!%SPEECH_OFF%Wystawia dwa palce, na wszelki wypadek. Strażnicy wzruszają ramionami i otwierają bramę, ale rolnik nie rusza się. Zamiast tego robi krok w tył.%SPEECH_ON%W sumie krowy mogą poczekać, aż wrócę do domu.%SPEECH_OFF%Za murami widzisz ogromną hordę nieumarlych wylewającą się na horyzoncie. W chwili, gdy sygnały alarmowe idą w ruch, %objective% tętni ruchem ludzi biegnących po broń do kolejnej bitwy. | Spotykasz porucznika straży na murach. Dzieli się chlebem z milicją i proponuje ci kawałek. Odmawiasz i pytasz, co na horyzoncie. Wskazuje pole.%SPEECH_ON%A nic, po prostu znów atakują.%SPEECH_OFF%Podaje ci lunetę. Patrzysz i widzisz ogromną zgraję trupów sunących ku %objective%. Odkładasz szkło i pytasz, czemu nie podniesiono alarmu. Wzrusza ramionami.%SPEECH_ON%Daje ludziom minutę czy dwie. Chodzące trupy chcą nas zabić, ale nie spieszą się, wiesz?%SPEECH_OFF%Rozumiesz. Przyjmujesz podany chleb, a po chwili idziesz szykować %companyname% do bitwy. | Jeden z milicjantów przyprowadza żywego trupa za mury. Ma go na łańcuchu, ciału odcięto ręce. Z ust zwisa długi jęzor. Porucznik schodzi, czerwony ze wśiekłości jakby miał zaraz zakląć.%SPEECH_ON%Co, do cholery, ty wyprawiasz?%SPEECH_OFF%Milicjant szarpie łańcuch i przewraca nieumarlych na ziemię. Nerwowo się tłumaczy.%SPEECH_ON%Może coś od nich wydedukujemy? Co ich porusza, jak ich przywrócić?%SPEECH_OFF%Zanim kłótnia się rozkręca, z wieży słychać krzyk o kolejnym ataku. Porucznik odwraca się z ostrzem w dłoni i jednym ruchem odcina głowę nieumarlych. Jego bezbrodą głowa toczy się, a jęzor wije się jak wąż w słoju. Porucznik chwyta milicjanta za kołnierz.%SPEECH_ON%Nie rób takiego gówna drugi raz, rozumiesz? Oni są martwi. Tylko tyle. A teraz chwytaj, do cholery, broń.%SPEECH_OFF%%companyname% już stoi gotowe, nie czekając na rozkazy. | Zastajesz kowala, jak kuje 'najlepszą' broń %objective%. Jego masywne ramiona machają młotem i szczypcami jakby były z patyków. Na dłoni ma wytatuowaną lemniskatę. Iskry wirują jak świetliki, a on szybko zauważa twój cień rzucany na jego otwarty warsztat.%SPEECH_ON%Witaj, najemniku.%SPEECH_OFF%Z czystej ciekawości pytasz, jak się miewa. Spłaszcza kawałek stali i obraca go, powtarzając ruch.%SPEECH_ON%Bywało lepiej. Mogło być gorzej. Jak wygląda?%SPEECH_OFF%Kowal podnosi ostrze do oceny. Zanim odpowiesz, dzwony biją na alarm, a ludzie ruszają do obrony miasta. Milicjanci przebiegają obok, zrywając broń z haków w jego kuźni. Opuszcza ostrze i śmieje się.%SPEECH_ON%Ech, idź walczyć, najemniku. To było pytanie retoryczne.%SPEECH_OFF% | Skryba %objective% chodzi z zwojem pergaminu. Pisze na plecach sługi wszystko, co widzi. Zaciekawiony pytasz, co bada w tym chaosie. Odpowiada krótko.%SPEECH_ON%Badam emocje. Smutek jest chorobą i się tu rozprzestrzenia.%SPEECH_OFF%Taka odpowiedź domaga się dalszych pytań, ale on je ignoruje i mierzy cię wzrokiem.%SPEECH_ON%Według moich miar jesteś w doskonałym zdrowiu, najemniku. Cóż, poza ciałem. Utykasz jak okaleczony pies i krzywisz się, gdy skręcasz w lewo. Łatwo to zauważyć. Ale widzę, że ból cię nie powstrzymuje. Wręcz przeciwnie... napędza. Czy próbujesz nadrobic coś, co ci zabrano?%SPEECH_OFF%Zanim odpowiesz - a chciałbyś mu kazać zamknąć usta - dzwony przerywają, a ludzie ruszają szykować się do kolejnego ataku nieumarlych. Gdy się odwracasz, skryba już znika, stojąc w kącie i gorączkowo pisząc ostrym piórem na plecach skandującego sługi. | Gdy szykujesz się do odpoczynku, dzwony znów biją, a wartownicy na murach krzyczą. Wygląda na to, że nieumarli znów atakują! Spieszysz szykować %companyname% do kolejnej bitwy. | Zauważasz, że szczyty murów poczerniały od sępów. Wielkie ptaki wpatrują się w miasto jak w procesję żałobną. Nagle milicjant wychodzi z wieży i roztrzaskuje jednego ptaka kijem. Krótki skrzek, reszta sępów przestawia się jak lilie na pofalowanej wodzie. Milicjant uderza drugiego w głowę i padłinożercy odlatują. Łowca wraca do wieży, huśtając zdobycz za nogi.%SPEECH_ON%Hej.%SPEECH_OFF%Porucznik straży klepie cię po ramieniu. Gdy się odwracasz, wskazuje kciukiem swoje plecy.%SPEECH_ON%Nieumarli znów atakują. Kazałem ludziom trzymać alarmy cicho. Wiesz, na wypadek, gdyby nasze krzyki i histeria tylko przyciągały więcej tych drani.%SPEECH_OFF%Brzmi rozsądnie.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Bronić miasta!",
					function getResult()
					{
						this.Contract.setState("Running_Wave");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Militia1",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Wygrałeś dzień, ale milicja mogła przegrać wojnę: straż miejska poniosła tak duże straty, że coraz więcej mieszkańców pakuje się i opuszcza wioskę, zamiast zostać i bronić! | Zwycięstwo, ale jakim kosztem? Tylu milicjantów poległo w bitwie, że żaden mieszkaniec %objective% nie chce ich zastąpić!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Tak czy siak, zwycięstwo.",
					function getResult()
					{
						this.Flags.set("Wave", this.Flags.get("Wave") + 1);
						this.Flags.set("TimeWaveHits", this.Time.getVirtualTimeF() + 3.0);
						this.Flags.set("Militia", 3);
						this.Flags.set("MilitiaStart", 3);
						this.Contract.setState("Running_Wait");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Militia2",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Bitwa wygrana, ale nie bez strat. Kilku mieszkańców %objective% zapisuje się do obrony miasta, podczas gdy inni pakują dobytek, by odejść. | Wygrałeś dzień, ale nieumarli kazali ci za to drogo zapłacić. Część mieszkańców zgadza się wspomóc milicję i uzupełnić jej szeregi, a tyle samo trzyma dystans i szykuje się na najgorsze.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Tak czy siak, zwycięstwo.",
					function getResult()
					{
						this.Flags.set("Wave", this.Flags.get("Wave") + 1);
						this.Flags.set("TimeWaveHits", this.Time.getVirtualTimeF() + 3.0);
						this.Flags.set("Militia", 6);
						this.Flags.set("MilitiaStart", 6);
						this.Contract.setState("Running_Wait");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Militia3",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_80.png[/img]{Cóż za zwycięstwo! Nie tylko odepchnąłeś nieumarłych, ale twój sukces był tak imponujący, że wielu mieszkańców %objective% dołączyło do milicji na kolejne bitwy! | Nieumarli zostali tak dotkliwie pobici, że wielu mieszkańców %objective% dołączyło do milicji, by pomóc w nadchodzących starciach!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zwycięstwo!",
					function getResult()
					{
						this.Flags.set("Wave", this.Flags.get("Wave") + 1);
						this.Flags.set("TimeWaveHits", this.Time.getVirtualTimeF() + 3.0);
						this.Flags.set("Militia", 8);
						this.Flags.set("MilitiaStart", 8);
						this.Contract.setState("Running_Wait");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Ghouls",
			Title = "W %objective%...",
			Text = "[img]gfx/ui/events/event_69.png[/img]{Gdy szykujesz się do walki, zauważasz dziwne kształty kręcące się wśród nieumarłych: nachzehrery. Te stwory muszą podążać za hordami, by pożerać to, co zabija, niczym mewy za kutrem rybackim. | Nachzehrery! Te paskudne stworzenia przemykają między tłumami trupów, na pewno szukając kolejnego posiłku. | Nieumarli zostawiają po sobie wiele martwych i umierających, a nic dziwnego, że padlinożercy idą ich tropem. W tym wypadku to nachzehrery, odrażające bestie warczące i szczerzące zęby w oczekiwaniu na posiłek. | Gdy plądrujesz spiżarnie, zawsze pojawiają się myszy. Teraz, gdy nieumarli atakują %objective%, przywlokli za sobą orszak padlinożerców: nachzehery.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Bronić miasta!",
					function getResult()
					{
						this.Contract.spawnGhouls();
						this.Contract.setState("Running_Wave");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TheAftermath",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Wpatrujesz się w pole bitwy. Usiane jest martwymi, umierającymi, nieumarłymi i umierającymi nieumarłymi. Żywi, oddychający ludzie brodzą w błotnistym brudzie, dobijając wszystko, co choćby przypomina ożywieńca. Walka się skończyła, miasto ocalone, a %employer% powinien cię teraz oczekiwać. | Bitwa zakończona, miasto ocalone. Czas wracać do %employer% po sowitą zapłatę. | %objective% bardziej przypomina zalany cmentarz niż jakiekolwiek znane ci miasto. Nowe i stare zwłoki porozrzucane są po ziemi, a krew i spleśniały brud zbierają się wokół każdego ciała. Smród przypomina ci zdechłego psa znalezionego przy strumieniu, kości ociekające rozkładem, ciało pożerane przez raki i larwy.\n\nNiestrudzone ataki wreszcie ucichły, %objective% wydaje się bezpieczne. %employer% powinien cię oczekiwać, a ty nie masz powodów, by dłużej zwlekać z ucieczką z tego okropnego miejsca. | No cóż, miasto ocalone. Chłopi krążą po polu bitwy z długimi kijami, szturchając ziemię jak pelikan w niebezpiecznym stawie. %randombrother% podchodzi, czyszcząc swoje ostrze z brei, i pyta, czy czas wracać do %employer%. Kiwasz głową. Im szybciej wrócisz po zapłatę, tym lepiej. | Bitwa zakończona. Wśród martwych są chłopi i milicjanci, każdy otoczony przez ocalałych, którzy przyszli przykryć ciała, płacząc. A co do martwych nieumarłych, cóż, nikogo to nie obchodzi. Leżą tak, jakby przyszli bez celu, a odeszli zostawiając zniszczenie wszystkiego, czego dotknęli. Widok ich zwłok i chaotycznej pustki, którą reprezentują, jest wściekły. Nie chcąc tu być ani chwili dłużej, każesz ludziom szykować się do powrotu do %employer%. | Ty i %companyname% stoicie zwycięsko. Miasto i jego ludzie przetrwają, przynajmniej na razie, a ty możesz wrócić do %employer% po zapłatę. | Porucznik straży dziękuje ci za ocalenie miasta. Wspominasz, że jedyny powód, dla którego tu jesteś, to zapłata. Wzrusza ramionami.%SPEECH_ON%Dziękuję deszczom, na które nie mam wpływu, i będę dziękował tobie, najemniku, czy ci się to podoba, czy nie.%SPEECH_OFF% | Bitwa zakończona i na szczęście wygrana. Ciała nieumarłych walają się w takim nieładzie, że prawie nie różnią się od tego, jak wyglądały kilka godzin temu. Ale świeżo zmarli nie poddają się takiej kosmicznej apatii. Otaczają ich płaczące kobiety i zagubione dzieci. Odwracasz wzrok i rozkazujesz %companyname% przygotować się do powrotu do %employer%. | U twoich stóp leży martwy człowiek, a obok niego trup nieumarły. To dziwny widok: obaj są już poza tym światem, ale w tamtym jeszcze tli się życie, tchnienie niedawnej pamięci. Widziałeś, jak walczył do samego końca. Szlachetny koniec dla wojownika. A ten trup? Co o nim? Zapamiętasz go, jak rozdzierał gardło człowiekowi gołymi zębami. Może kiedyś miał rodzinę, może był dobrym człowiekiem, ale teraz to tylko potwór, który rozrywa gardła. I tak zostanie zapamiętany.\n\nNiestrudzone ataki na %objective% wreszcie ustały, więc spieszysz zebrać kompanię i przygotować powrót do %employer% w %townname%. Dobra zapłata jest lepsza niż kolejna chwila patrzenia na ten syf. | Czym jest martwy człowiek? A martwy człowiek zabity dwa razy? A zabity trzy razy? Pech. Jeszcze większy pech. I żart.\n\n Przemierzasz pole bitwy, zbierając ludzi z %companyname%. Miasto %objective% jest ocalone, przynajmniej na razie, więc czas wracać do %employer% w %townname% po zasłużoną zapłatę. | %randombrother% wyciera czoło szmatą, zostawiając obrzydliwą smugę bladej cieczy.%SPEECH_ON%Cholera, co to jest? To mózg? Panie, no proszę...%SPEECH_OFF%Pomagasz mu się oczyścić. Staje, rozkładając ręce. Wciąż jest cały we krwi, flakach i rzeczach, których lepiej nie nazywać.%SPEECH_ON%Jak wyglądam?%SPEECH_OFF%Jego uśmiech wyłania się z mroku jak sierp księżyca na bladym niebie. Nie odpowiadasz, tylko każesz mu iść zebrać ludzi. %objective% ocalone, %employer% będzie oczekiwał kompanii w %townname%, a kompania powinna spodziewać się zasłużonej zapłaty. | %randombrother% podchodzi do ciebie i razem spoglądacie na pole bitwy. Widzisz już rodziny martwych, które wychodzą szukać swoich bliskich. Ich lament jest ostry i ludzki, dziwnie miłe wytchnienie od jęczenia nieumarłych. Najemnik klepie cię po ramieniu.%SPEECH_ON%Pójdę zebrać ludzi, żebyśmy mogli wrócić do %townname% po naszą zapłatę.%SPEECH_OFF% | Patrzysz, jak kobiety powłóczą się po polu bitwy, podnosząc suknie jak mokre ptaki, by omijać brunatną maź. Gdy znajdują to, czego szukają, porzucają wszelką troskę o czystość, rzucają się w brud, wyjąc i szlochając, okrywając się tymi samymi okropnościami, które z wściekłą obojętnością zabiły ich ojców i mężów.\n\n %randombrother% dołącza do ciebie.%SPEECH_ON%Panie, ataki ustały, a ludzie są gotowi do powrotu do %townname%. Wystarczy rozkaz.%SPEECH_OFF% | Porucznik straży podchodzi i ściska twoją dłoń. Zaschła krew pęka i kruszy się przy uścisku. Staje, opiera dłonie na biodrach i kiwa głową na scenę.%SPEECH_ON%Dobrze sobie poradziliście, najemniku, i bez ciebie byśmy nie dali rady. Chciałbym dać więcej w podzięce, ale to miasto potrzebuje wszystkich zasobów do odbudowy. Mam nadzieję, że %employer% zapłaci ci tyle, ile jesteś wart.%SPEECH_OFF%Też na to liczysz.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Udało nam się!",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Wchodzisz do %townname% i widzisz %employer%a na balkonie. Woła do ciebie, gdy strażnik wciska ci w ramiona sakiewkę z koronami.%SPEECH_ON%Najemniku! Jak miło cię widzieć! Moje ptaszki już opowiedziały mi o twoich czynach. Mam nadzieję, że dobrze wydasz te korony!%SPEECH_OFF%Zanim zdążysz coś powiedzieć, mężczyzna odwraca się i odchodzi. Strażnik, który podał ci sakiewkę, też znika. Chłopi przechodzą obok ciebie jak drogowskazy do miejsc, do których nigdy nie pójdą. | Zastajesz %employer%a, jak bije i kopie dziecko, aż w końcu kopie je w klatkę piersiową. Na twój widok szlachcic ociera pot i tłumaczy się.%SPEECH_ON%To cię nie dotyczy.%SPEECH_OFF%Dziecko podpiera się rękami i kolanami, jedna dłoń trzyma na brzuchu, druga ociera krew z nosa. Powoli podnosi się, chwiejąc, mrużąc oczy. Sługa podbiega i zaczyna polewać go wodą, ale szlachcic wyrywa szmatę i odrzuca ją na bok.%SPEECH_ON%Tak się uczy. Jeśli chcesz komuś pomóc, pomóż temu najemnikowi. Należy mu się %reward_completion% koron. Szybko.%SPEECH_OFF%Sługa kiwa głową i odchodzi. Zostaj esz chwilę, patrząc jak bicie trwa. Dziecko nie płacze ani nie krzyczy, bo jest przyzwyczajone. Po kilku minutach sługa wraca z sakiewką, podaje ją tobie i szepce, żebyś odszedł. | %employer% pochyla się nad stołem, ręce ma złożone jak dach, głowa opada nisko, gdy wpatruje się w martwego kruka.%SPEECH_ON%Znalazłem go rano w łóżku. Leżał tam. Martwy. Wiesz, co to znaczy?%SPEECH_OFF%Sugerujesz, że to był żart. Szlachcic prycha.%SPEECH_ON%Nie. Myślę, że to ma związek z tobą, najemniku. Dobrze ocaliłeś to miasto, ale może nie było mu to pisane? Może ten ptak to symbol. Może śmierć upomni się o mnie, bo zostawiłem ją bez zapłaty.%SPEECH_OFF%Wykorzystujesz te słowa, by przejść do sprawy zapłaty. Mimo jego dziwnych wynurzeń, szlachcic w końcu się opanowuje i wypłaca ci %reward_completion% koron. | %employer% słucha grupy skrybów ustawionych według wieku i rangi. Młodzi milczą, słychać tylko skrobanie piór. Starsi kłócą się, podnosząc głos równie często jak argumenty. Taki widok stał się codziennością, bo temat powstałych z grobów zmarłych niepokoi filozofów. Dla wprowadzenia ryczysz soczystym beknięciem, przerywając dyskusję. %employer% śmieje się i macha, byś wszedł.%SPEECH_ON%Ach, najemniku! Człowiek, który robi robotę, przybywa do tych, co tylko trajkoczą?%SPEECH_OFF%Kręcisz głową i mówisz, że jesteś tu tylko po zapłatę. Szlachcic kiwa głową.%SPEECH_ON%Oczywiście. Dobrze uratowałeś to miasto. Słyszałem o twoich czynach. %reward_completion% koron czeka w rogu.%SPEECH_OFF%Przechodzisz przez pokój, a twoje buty dudnią w nagle uciszonej sali. Skrybowie patrzą za tobą i szepczą. Bierzesz sakiewkę, słysząc przyjemny dźwięk koron. Po cichu wychodzisz, a gdy drzwi się zamykają, skrybowie wracają do kłótni. | %employer% stoi z kilkoma kobietami. Opowiadają mu o utraconych ojcach, mężach i braciach. Kiwają mu głowami, a on od czasu do czasu zerka na piersi najmłodszej.%SPEECH_ON%Tak, tak, oczywiście. Okropne. Okropne! Chwileczkę. Najemniku!%SPEECH_OFF%Machając, wpuszcza cię. Kobiety rozstępują się, a najmłodsza ociera łzy i poprawia się, by wyglądać młodziej. Szlachcic to dostrzega i zerka na was oboje.%SPEECH_ON%Ekhm, tak, twoje korony są w rogu. Musisz iść. Teraz. Mam sprawy do załatwienia.%SPEECH_OFF%Wstaje, wskazuje twoje %reward_completion% korony i jednym ruchem bierze młodą kobietę za dłoń.%SPEECH_ON%A teraz, młoda wyplataczko, mówiłaś, że twój mąż nie żyje i nie masz już nikogo? Nikogo?%SPEECH_OFF% | Psy rozszarpują coś na drodze. Cokolwiek to było, kiedyś żyło, ale kości i organy dawno zbladły i zgniły, choć zajadła uczta sugeruje stek. %employer% wita cię, z uważnymi strażnikami po bokach.%SPEECH_ON%Moje ptaszki mówią, że miasto zostało ocalone. Dobrze sobie poradziłeś, najemniku, lepiej niż się spodziewałem. Twoja zapłata, jak uzgodniono.%SPEECH_OFF%Podaje ci sakiewkę z %reward_completion% koron. Psy zatrzymują się i patrzą na ciebie, z kawałkami mięsa zwisającymi z zębów, czarne oczy puste jak ich głód. Strażnicy opuszczają włócznie, a psy, jakby rozumiejąc, wracają do uczty. | %employer% siedzi nisko w krześle. Smutno macha, byś wszedł.%SPEECH_ON%Mam straszne wieści. Mój wieszcz twierdzi, że ściągnąłem klątwę na ziemie i ludzi. Dlatego umarli znów wstają.%SPEECH_OFF%Wzruszasz ramionami i mówisz, że wieszcz pieprzy głupoty. Szlachcic wzrusza ramionami.%SPEECH_ON%Oby. Na co się umówiliśmy, %reward_completion% koron?%SPEECH_OFF%Kusza cię, by powiedzieć, że na więcej, ale nie chcesz drażnić tak przesadnego człowieka. Gdy odpowiadasz, uśmiecha się ciepło.%SPEECH_ON%Dobra odpowiedź, najemniku. Zdałaś test. Mogę wariować, ale nie znoszę, gdy ktoś mnie sprawdza.%SPEECH_OFF%Pytasz, czy szczerość zostanie nagrodzona. Unosi brew.%SPEECH_ON%Twoja głowa wciąż jest na karku, prawda?%SPEECH_OFF%Wiadomość przyjęta. | %employer% stoi na balkonie. Dołączasz do niego, a strażnicy stoją blisko, obserwując cię uważnie. Szlachcic wskazuje miasto poniżej.%SPEECH_ON%Wiem, że nie uratowałeś tego miasta bezpośrednio, ale w pewien sposób tak. Zatrzymanie nieumarłych gdziekolwiek jest tak samo dobre jak tutaj. Zgadzasz się?%SPEECH_OFF%Podkreśla to, podając sakiewkę z %reward_completion% koron. Bierzesz zapłatę i kiwasz głową. On też kiwa.%SPEECH_ON%Cieszę się, bo możemy jeszcze potrzebować twoich usług.%SPEECH_OFF% | Wchodzisz do zaciemnionego pokoju %employer%a. Okna zasłonięte są dywanami, a większość świec nie pali się. Jedyne światło migocze przy skrybie stojącym z kandelabrem, jego rumiana twarz uśmiecha się jak mały diabeł z trójzębem. Zerka na ciebie i cicho odkłada świecę. Gdy cofa się, wygląda jakby zapadał się w czarny staw, a jego twarz znika w ciemności. Wciąż tam jest, oddycha, szura płaszczem, ale nie widzisz jego postaci. %employer% macha, byś wszedł.%SPEECH_ON%Najemniku! Na starych bogów, dobrze uratowałeś to miasto!%SPEECH_OFF%Podchodzisz, zerkając na przesuwające się cienie. %employer% podaje ci sakiewkę. Błysk monet odbija się w świetle świec.%SPEECH_ON%%reward_completion% koron, jak uzgodniono. A teraz proszę, odejdź. Mam jeszcze wiele do zbadania, wiele do nauczenia.%SPEECH_OFF%Zabierasz zapłatę i wychodzisz. Gdy drzwi się zamykają, widzisz skrybę wynurzającego się niczym chudy upiór, jego kościste dłonie znów sięgają po światło. | %employer% jest w gabinecie. Strażnicy stoją w każdym rogu, a skryba krąży wokół półek, wyciągając i odkładając zwoje z równą gorliwością co rozczarowaniem. Szybko cię wpuszczają i równie szybko szlachcic cię wypłaca.%SPEECH_ON%Dobra robota, najemniku. Już jesteś bohaterem w niektórych stronach. Może trafisz do tych zwojów i zostaniesz zapamiętany na zawsze.%SPEECH_OFF%Słyszysz jak skryba parska. %employer% wskazuje drzwi.%SPEECH_ON%Proszę? Mam ogrom rzeczy do zbadania i tak mało czasu.%SPEECH_OFF% | Wchodzisz do pokoju %employer%a i widzisz go zapadniętego w fotelu. Chłopi kłócą się po obu stronach, oskarżając i wskazując palcami.%SPEECH_ON%Ten człowiek to morderca!%SPEECH_OFF%Oskarżony prycha.%SPEECH_ON%Morderca? To był wypadek! Myślałem, że to jeden z nieumarłych!%SPEECH_OFF%Drugi prycha.%SPEECH_ON%Nieumarły? Był po prostu pijany!%SPEECH_OFF%Napięcie rośnie.%SPEECH_ON%No bo słyszałem warczenie! Albo pomruki.%SPEECH_OFF%%employer% macha cię w zrezygnowany sposób.%SPEECH_ON%Najemniku, dobra robota z tym miastem. Twoja zapłata.%SPEECH_OFF%Przesuwa po stole sakiewkę z %reward_completion% koron. Chłopi milkną, patrząc na błysk monet. Bierzesz sakiewkę, udając, że jest strasznie ciężka.%SPEECH_ON%Uff, ale ciężkie! Panowie, miłego dnia.%SPEECH_OFF% | %employer% wita cię w swoim pokoju.%SPEECH_ON%Moje ptaszki mówią, że miasto ocalało. Dobra robota, najemniku, w świecie, który tak pociemniał. Twoja zapłata, %reward_completion% koron, jak uzgodniono.%SPEECH_OFF% | %employer% stoi na zewnątrz, patrząc na cmentarz, który od twojej ostatniej wizyty zyskał wielu mieszkańców. Podaje ci sakiewkę z %reward_completion% koron.%SPEECH_ON%Dobrze sobie poradziłeś, najemniku. Wieści o twoich czynach rozeszyły się po kraju. Jedno zwycięstwo nie ocali nas wszystkich, ale stawia nas na właściwej drodze. Jeśli mamy wygrać tę przeklętą wojnę z umarłymi, potrzebujemy tyle ducha i nadziei, ile zdołamy zebrać.%SPEECH_OFF%Zabierając zapłatę, mówisz, że najemnicy potrzebują jak najwięcej koron, wiesz, by trzymać 'ducha' wysoko. Szlachcic uśmiecha się.%SPEECH_ON%Jestem moralizatorem, nie filantropem. Wynoś się stąd.%SPEECH_OFF% | Strażnicy %employer%a prowadzą cię do jego pokoju. Zwoje leżą rozłożone dookoła, a po stole walają się połamane piórka, jakby ktoś roztrzaskał tu ptaka.%SPEECH_ON%Najemniku! Dobrze widzieć człowieka godziny, dnia, tygodnia! Dobrze uratowałeś to miasto.%SPEECH_OFF%Rzuca ci sakiewkę z %reward_completion% koron.%SPEECH_ON%Jedno zwycięstwo, by utrzymać miasto przy życiu, jedno, by utrzymać nadzieję ludzi. Powinienem zapłacić ci więcej. To znaczy, nie zapłacę, ale powinienem.%SPEECH_OFF%Smętnie bierzesz zapłatę i odpowiadasz, kiwając głową.%SPEECH_ON%Liczy się gest.%SPEECH_OFF%Szlachcic pstryka palcami.%SPEECH_ON%Dokładnie!%SPEECH_OFF% | Zastajesz %employer%a zapadniętego w fotelu z jeszcze głębszym grymasem. Jego ubrania lśnią opulencją, a kandelabry wyglądają na cenniejsze od sług, które je trzymają. Ten pstrokaty ponurak macha cię do środka i mówi wolno, sarkastycznie.%SPEECH_ON%Jedno zwycięstwo dla człowieka. Jeszcze jedno, by przetrwać do jutra. Mmm, dziękuję, najemniku.%SPEECH_OFF%Podchodzisz powoli, a słudzy patrzą na ciebie z obawą. Bierzesz zapłatę i cofasz się. %employer% macha, byś odszedł.%SPEECH_ON%Odejdź. Mam nadzieję, że się jeszcze spotkamy, chyba że będziesz pokrzywiony i martwy, to byłoby smutne. Z drugiej strony, tak wszyscy skończą, prawda?%SPEECH_OFF%Nie odpowiadasz i wychodzisz. Wojna z nieskończonymi nieumarłymi najwyraźniej zużyła szlachcica.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "%objective% jest ocalone.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Obroniłeś " + this.Flags.get("ObjectiveName") + " przed nieumarłymi");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isUndeadScourge())
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Origin, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "W pobliżu %objective%",
			Text = "[img]gfx/ui/events/event_30.png[/img]{Nieumarłych było zbyt wielu i musiałeś się wycofać. Niestety całe miasto nie ma takiego przywileju, więc %objective% zostało całkowicie zalane. Nie zostałeś, by zobaczyć, co stało się z mieszkańcami, ale nie trzeba geniusza, by zgadnąć. | %companyname% została pokonana w polu przez hordy nieumarłych! W wyniku porażki %objective% zostaje szybko zalane. Masa chłopów ucieka, a ci, którzy są zbyt wolni, dołączają do morza szurających trupów. | Nie udało ci się powstrzymać nieumarłych! Trupy powoli przesuwają się poza mury %objective% i zabijają oraz pożerają wszystko, co napotkają. Uciekając z pola bitwy, widzisz porucznika straży szurającego obok hordy trupów.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "%objective% upadło.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Nie obroniłeś " + this.Flags.get("ObjectiveName") + " przed nieumarłymi");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function spawnWave()
	{
		local undeadBase = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getNearestSettlement(this.m.Origin.getTile());
		local originTile = this.m.Origin.getTile();
		local tile;

		while (true)
		{
			local x = this.Math.rand(originTile.SquareCoords.X - 5, originTile.SquareCoords.X + 5);
			local y = this.Math.rand(originTile.SquareCoords.Y - 5, originTile.SquareCoords.Y + 5);

			if (!this.World.isValidTileSquare(x, y))
			{
				continue;
			}

			tile = this.World.getTileSquare(x, y);

			if (tile.getDistanceTo(originTile) <= 4)
			{
				continue;
			}

			if (tile.Type == this.Const.World.TerrainType.Ocean)
			{
				continue;
			}

			local navSettings = this.World.getNavigator().createSettings();
			navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;
			local path = this.World.getNavigator().findPath(tile, originTile, navSettings, 0);

			if (!path.isEmpty())
			{
				break;
			}
		}

		local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).spawnEntity(tile, "Horda Nieumarłych", false, this.Const.World.Spawn.UndeadArmy, (80 + this.m.Flags.get("Wave") * 10) * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
		this.m.UnitsSpawned.push(party.getID());
		party.getLoot().ArmorParts = this.Math.rand(0, 15);
		party.getSprite("banner").setBrush(undeadBase.getBanner());
		party.setDescription("Legion chodzących trupów, które powróciły, aby odebrać żywym to, co niegdyś należało do nich.");
		party.setFootprintType(this.Const.World.FootprintsType.Undead);
		party.setSlowerAtNight(false);
		party.setUsingGlobalVision(false);
		party.setLooting(false);
		party.setAttackableByAI(false);
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(originTile);
		c.addOrder(move);
		local attack = this.new("scripts/ai/world/orders/attack_zone_order");
		attack.setTargetTile(originTile);
		c.addOrder(attack);
		local destroy = this.new("scripts/ai/world/orders/convert_order");
		destroy.setTime(60.0);
		destroy.setSafetyOverride(true);
		destroy.setTargetTile(originTile);
		destroy.setTargetID(this.m.Origin.getID());
		c.addOrder(destroy);
	}

	function spawnUndeadAtTheWalls()
	{
		local undeadBase = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getNearestSettlement(this.m.Origin.getTile());
		local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).spawnEntity(this.m.Origin.getTile(), "Horda Nieumarłych", false, this.Const.World.Spawn.ZombiesOrZombiesAndGhosts, 100 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
		party.setPos(this.createVec(party.getPos().X - 50, party.getPos().Y - 50));
		this.m.UnitsSpawned.push(party.getID());
		party.getLoot().ArmorParts = this.Math.rand(0, 15);
		party.getSprite("banner").setBrush(undeadBase.getBanner());
		party.setDescription("Legion chodzących trupów, które powróciły, aby odebrać żywym to, co niegdyś należało do nich.");
		party.setFootprintType(this.Const.World.FootprintsType.Undead);
		party.setSlowerAtNight(false);
		party.setUsingGlobalVision(false);
		party.setLooting(false);
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		local wait = this.new("scripts/ai/world/orders/wait_order");
		wait.setTime(15.0);
		c.addOrder(wait);
		local destroy = this.new("scripts/ai/world/orders/convert_order");
		destroy.setTime(90.0);
		destroy.setSafetyOverride(true);
		destroy.setTargetTile(this.m.Origin.getTile());
		destroy.setTargetID(this.m.Origin.getID());
		c.addOrder(destroy);
	}

	function spawnGhouls()
	{
		local originTile = this.m.Origin.getTile();
		local tile;

		while (true)
		{
			local x = this.Math.rand(originTile.SquareCoords.X - 5, originTile.SquareCoords.X + 5);
			local y = this.Math.rand(originTile.SquareCoords.Y - 5, originTile.SquareCoords.Y + 5);

			if (!this.World.isValidTileSquare(x, y))
			{
				continue;
			}

			tile = this.World.getTileSquare(x, y);

			if (tile.getDistanceTo(originTile) <= 4)
			{
				continue;
			}

			if (tile.Type == this.Const.World.TerrainType.Ocean)
			{
				continue;
			}

			local navSettings = this.World.getNavigator().createSettings();
			navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;
			local path = this.World.getNavigator().findPath(tile, originTile, navSettings, 0);

			if (!path.isEmpty())
			{
				break;
			}
		}

		local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).spawnEntity(tile, "Nachzehrery", false, this.Const.World.Spawn.Ghouls, 110 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
		this.m.UnitsSpawned.push(party.getID());
		party.getSprite("banner").setBrush("banner_beasts_01");
		party.setDescription("Stado grasujących nachzehrerów.");
		party.setSlowerAtNight(false);
		party.setUsingGlobalVision(false);
		party.setLooting(false);
		party.setAttackableByAI(false);
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(originTile);
		c.addOrder(move);
		local attack = this.new("scripts/ai/world/orders/attack_zone_order");
		attack.setTargetTile(originTile);
		c.addOrder(attack);
		local destroy = this.new("scripts/ai/world/orders/convert_order");
		destroy.setTime(60.0);
		destroy.setSafetyOverride(true);
		destroy.setTargetTile(originTile);
		destroy.setTargetID(this.m.Origin.getID());
		c.addOrder(destroy);
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective",
			this.m.Flags.get("ObjectiveName")
		]);
		_vars.push([
			"direction",
			this.m.Origin == null || this.m.Origin.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Origin.getTile())]
		]);
	}

	function onOriginSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Origin.addSituation(this.new("scripts/entity/world/settlements/situations/besieged_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			foreach( id in this.m.UnitsSpawned )
			{
				local e = this.World.getEntityByID(id);

				if (e != null && e.isAlive())
				{
					e.setAttackableByAI(true);
					e.setOnCombatWithPlayerCallback(null);
				}
			}

			if (this.m.Origin != null && !this.m.Origin.isNull() && this.m.Origin.hasSprite("selection"))
			{
				this.m.Origin.getSprite("selection").Visible = false;
			}

			if (this.m.Home != null && !this.m.Home.isNull() && this.m.Home.hasSprite("selection"))
			{
				this.m.Home.getSprite("selection").Visible = false;
			}
		}

		if (this.m.Origin != null && !this.m.Origin.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Origin.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(2);
			}
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isUndeadScourge())
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.contract.onDeserialize(_in);
	}

});

