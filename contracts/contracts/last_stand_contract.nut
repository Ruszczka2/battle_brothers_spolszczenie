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
			Text = "[img]gfx/ui/events/event_45.png[/img]{Zastajesz %employer%a, jak pomaga mlodemu szlachcicowi celowac z luku w slomiana kukle. Prostuje chlopakowi plecy i każe mu gleboko odetchnac przed strzalem. Niedoswiadczony lucznik kiwa glowa i robi, co mu kazano. Strzala wylatuje, odbija sie od ziemi i z trzaskiem wpada do stajni, gdzie kilka koni rży na ten strach. Szlachcic klepie chlopca po plecach.%SPEECH_ON%Zaufaj mi, za pierwszym razem bylem gorszy. Cwicz dalej. Za chwile wracam.%SPEECH_OFF%Szlachcic podchodzi do ciebie, krecac glowa i sciszajac glos.%SPEECH_ON%Sprawy sa zle, najemniku. Mlodzi nie wiedza, jakie niebezpieczenstwa czaja sie teraz, ale ty wiesz. Mamy osade, %objective% %direction% stad, ktora otoczona jest przez... no, zlo tego swiata. Nie mam ludzi do wyslania, dlatego potrzebuje ciebie. Jedz tam i ocal wioske, a dobrze cie oplace, zapewniam!%SPEECH_OFF% | Zastajesz %employer%a wpatrzonego w jeden ze swoich mieczy. Ma go wyciagnietego i oglada swoja twarz w stalowym odbiciu.%SPEECH_ON%Gdy uczono mnie uzywac takiego ostrza, bylo to przeciw ludziom. A teraz? Mowia o umarlych, o zielenskorych, o bestiach bez miary!%SPEECH_OFF%Wbija miecz do pochwy i rzuca go na stol. Przeczesuje wlosy dlonia.%SPEECH_ON%%objective% %direction% stad potrzebuje pomocy. Otoczyly je te... te rzeczy! Nie wiem, czym sa, ale wiem, ze zabijaja i zabijaja! Nie mam ludzi do wyslania, ale jesli tam pojedziesz i pomozesz, zostaniesz sowicie wynagrodzony!%SPEECH_OFF% | Zastajesz %employer%a siedzacego miedzy opatem i skryba, ktorzy kloca sie starymi, trzeszczacymi glosami. Skoro umarli powstaja, dyskusje o smierci i zyciu po niej tocza sie zaciekle. Szlachcic dostrzega cie i zrywa sie na nogi. Podbiega, a klotnia trwa dalej w tle.%SPEECH_ON%Dzieki starym bogom, ze jestes, najemniku. %objective% lezy %direction% stad i jest oblezone przez armie potwornosci. Nieumarlych, paskudztw, sam nie wiem. Wiem tylko, ze nie mam ludzi, by je obronic. Jedz tam, upewnij sie, ze ludzie sa bezpieczni, a dobrze cie oplace!%SPEECH_OFF% | Zastajesz %employer%a nad sextonami opuszczajacymi trumne do grobu. Jest mocno przybita, wrecz w pospiechu: gwozdzie sa powyginane, a po bokach widac zarysowania. Na twój widok szlachcic podchodzi.%SPEECH_ON%Mieszkaniec tego pudla postanowil wyjsc. Zabil dziecko i psa. Prawie zabil kolejnego, zanim straż go polozyl z powrotem.%SPEECH_OFF%Z dna trumny wyplywa czarna ciecz. Grabarze odskakuja, upuszczajac skrzynie prosto do grobu z gluchym lomotem. %employer% kreci glowa.%SPEECH_ON%Przez te 'nieumarle' przypadki moje sily sa rozproszone. Wlasnie dotarla wiadomosc, ze %objective% %direction% stad tez jest atakowane. Najemniku, pojedziesz tam i pomozesz je ocalic?%SPEECH_OFF% | Zastajesz %employer%a nad sterta ksiazek porozrzucanych na biurku. Kreci glowa, jakby kazde poruszenie przewracalo kolejna strone. Zniecierpliwiony macha na ciebie.%SPEECH_ON%Nie ociagaj sie, najemniku, nie mamy na to czasu. Musisz isc do %objective% %direction% stad. Moje ptaki mowia, ze jest atakowane, kolejne te przeklete 'martwe' wstaly. Jestes zainteresowany? Zaplata w pelni wynagrodzi wysilek.%SPEECH_OFF% | Zastajesz %employer%a obserwujacego kamieniarzy ukladajacych przyciete bloki. Sciska ci dlon.%SPEECH_ON%Budujemy kolejne opactwo, najemniku, jak wyglada?%SPEECH_OFF%Wyglada dobrze, ale wskazujesz, ze po drugiej stronie drogi stoi juz inne. Szlachcic sie usmiecha.%SPEECH_ON%Martwi znow chodza po ziemi, a lawki w swiatyniach nie wystarcza dla przestraszonych. Wezwalem cie, bo moje sily sa rozproszone przez ten... dziwny problem. Jest miasteczko %direction% stad, %objective%, ktore pilnie potrzebuje pomocy. Moje ptaki mowia, ze jest pod atakiem, a ty wygladasz na kogos, kto chetnie je uratuje. Za odpowiednia cene, oczywiscie.%SPEECH_OFF% | %employer%, skarbnik i dowodca rozmawiaja. Skarbnik mowi, ze koron nie brakuje, ale dowodca twierdzi, ze nie ma ludzi do walki. Wchodzisz i od razu przechodza do rzeczy.%SPEECH_ON%Najemniku! Potrzebujemy twoich uslug natychmiast! Mamy wioske %direction% stad, zwana %objective%, ktora jest atakowana przez... eee, jak to sie zwie?%SPEECH_OFF%Dowodca pochyla sie do szlachcica i szepcze odpowiedz. Ten prostuje sie.%SPEECH_ON%Atakowana przez... 'nieumarlych'. Tak. Pojedziesz tam i obronisz tych biedakow?%SPEECH_OFF% | W koncu znajdujesz %employer%a w stajni. Zaklada siodlo na konia i zauwaza, ze trzymasz dystans.%SPEECH_ON%Bojisz sie, najemniku?%SPEECH_OFF%Wzruszasz ramionami, mowiac, ze nigdy nie lubiles bestii. Szlachcic wzrusza ramionami i dosiada konia.%SPEECH_ON%Jak chcesz. Moje ptaki donosza o klopotach %objective% - wielka horda nieumarlych dobija sie do bram i raczej nie przynosza mleka. Jesli tam pojedziesz i pomozesz obronic wioske, po powrocie bedzie tu na ciebie czekac solidna sakiewka.%SPEECH_OFF% | Zastajesz %employer%a spacerujacego po murach fortecy. Straznicy sa wyprostowani i czujni. Na twoj widok szlachcic macha, bys podszedl. Razem patrzycie przez blanki. Ziemia rozciaga sie przed wami, lasy wygladaja jak kropki, góry jak groty strzal, ptaki rysuja luki na niebie.%SPEECH_ON%%direction% stad lezy %objective%. Poslancy mowia, ze jest atakowane przez niewiarygodna sile, konkretnie nieumarlych. Tak, az tak niewiarygodne. Cokolwiek naciera na mury, nie mam ludzi, by temu sprostac. Ale ty, najemniku, idealnie sie do tego nadajesz. Zainteresowany?%SPEECH_OFF% | Zastajesz %employer%a i wychudzonego skrybe wpatrzonych w bezglowe cialo na kamiennej plycie. Glowa lezy w rogu, oczy przysloniete, stalowe pręty wystaja z polowy wyrzezbionej czaszki. Na twój widok szlachcic wyciaga dlon.%SPEECH_ON%Nie ma sie czego bac, najemniku. Jak pewnie slyszales, umarli znow chodza po ziemi, a to rodzi wiele spekulacji, dlaczego.%SPEECH_OFF%Skryba podnosi wzrok i wtraca.%SPEECH_ON%Albo jak...%SPEECH_OFF%Szlachcic usmiecha sie i kontynuuje.%SPEECH_ON%W kazdym razie %objective% %direction% stad jest atakowane przez te potwory, eee, bylach ludzi? Nie mam ludzi, by poslac pomoc. Ty jednak jestes idealny do tej roboty. Podejmiesz sie?%SPEECH_OFF% | %employer% slucha szeptow skryby, gdy wchodzisz do pokoju. Skryba rzuca na ciebie żolte spojrzenie i kontynuuje, po czym obaj kiwaja glowami, a starszy odchodzi. Nawet na ciebie nie patrzy. %employer% wola.%SPEECH_ON%Dobrze, ze jestes, najemniku! To naprawde trudne czasy. Moi ludzie sa rozproszeni po kraju, walczac z roznymi potwornosciami. Na pewno juz slyszales, ale 'martwi', czymkolwiek sa, znow chodza. I atakuja %objective% %direction% stad. Nie mam ludzi do wyslania, wiec licze na ciebie. Pomożesz ocalic to miasto?%SPEECH_OFF% | %employer% slucha prosb grupy chlopow. Docierasz na koncowke rozmowy, gdy szlachcic gniewnie ich odprawia. Gdy prostacy krzycza, straznicy odprowadzaja ich na zewnatrz, pokojowo na razie, brutalnie gdyby trzeba. Odchodza bez dalszych protestow, choć jeden chlop patrzy na ciebie i bezglosnie mowi 'pomoz nam'. %employer% macha reka.%SPEECH_ON%No prosze, jesli to nie najemnik! W sam czas, moj pazerne przyjacielu. Mam miasto %direction% stad, %objective%, ktore desperacko potrzebuje pomocy. Obecnie, jak powiadaja, jest oblezone przez nieumarlych. Jesli tam pojedziesz i pomożesz je obronic, czeka tu na ciebie duza sakiewka. Co ty na to, hm?%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_29.png[/img]{Czekanie niemal cie zabija, gdy nagle nadchodzi cos, co zrobi to szybciej: nieumarli! Dzwony %objective% zaczynaja bic, a straznicy ruszaja do akcji z niespodziewana zywoscia. Rozkazujesz %companyname% przygotowac sie do bitwy. | Gdy przygladasz sie grze w karty, rozlegaja sie dzwony. Spogladasz na klasztor i widzisz starca bijacego w dzwon z calej sily. Straznicy reagują, odzyskujac energie. Jeden krzyczy z bramy.%SPEECH_ON%Nadchodza, do broni!%SPEECH_OFF% | Gdy myslisz, ze dołączysz do mieszkancow w bezczynnosci i powolnym umieraniu, brama sie otwiera i wjezdza zwiadowca na koniu. Zwierze pada wyczerpane, sunie po blotnym gruncie, a jezdziec zeskakuje i turla sie. Wstaje i krzyczy.%SPEECH_ON%Umarli nadchodza! Musimy sie przygotowac!%SPEECH_OFF% | Z warty rozlega sie okrzyk.%SPEECH_ON%Nadchodzi wiadomosc, uwaga na glowy!%SPEECH_OFF%Patrzysz w gore i widzisz strzale lukujaсa przez niebo, spadajaca w blotno kilka krokow od ciebie. Porucznik zrywa zwój z grotu. Im dluzej czyta, tym bardziej blednie, po czym rzuca papier.%SPEECH_ON%Czas sie szykowac, najemniku, umarli idą.%SPEECH_OFF%Odwraca sie do zolnierzy.%SPEECH_ON%Obroncy %objective%! Do broni!%SPEECH_OFF% | Jeden ze straznikow krzyczy.%SPEECH_ON%Bramy otwarte, uchodzcy nadchodza!%SPEECH_OFF%Przez brame wpada rozbiegana gromadka dzieci. Jedno tlumaczy, ze zbliza sie horda bladych ludzi. Porucznik patrzy na ciebie.%SPEECH_ON%Lepiej przygotuj ludzi, najemniku.%SPEECH_OFF%Nieumarli ida, szykujcie sie do walki! | Zwiadowca wjezdza do %objective% i zsiada z konia o zakrwawionych nogach i bez ogona. Trzyma bezdłonna reke, a z twarzy wyrwana ma czesc ucha i oka. Porucznik podbiega, rozmawiaja, po czym zwiadowca traci przytomnosc. Porucznik wzdycha i podchodzi.%SPEECH_ON%Nieumarli atakuja, szykujcie sie! I dobijcie tego rumaka!%SPEECH_OFF%Kiwasz glowa i rozkazujesz %companyname% gotowac sie do bitwy. Gdy najemnicy sie przygotowuja, podchodzi rzeznik i rąbie konia tasakiem. Porucznik klepie cie po ramieniu.%SPEECH_ON%Hej, przynajmniej bedzie co zjesc, jesli to przetrwamy.%SPEECH_OFF% | Siadasz obok porucznika. Dzieli sie chlebem.%SPEECH_ON%Od kiedy przybyles, jest podejrzanie cicho.%SPEECH_OFF%Gryziesz i pytasz, czy sugeruje, ze jestes podwojnym agentem umarlych. Smieje sie.%SPEECH_ON%W tych czasach niczego nie mozna byc pewnym.%SPEECH_OFF%W tej chwili rozlega sie dzwon, a straznicy ruszaja na mury. Wybuchaja krzyki. Nieumarli atakuja!\n\n Porucznik zarzuca helm i pomaga ci wstac.%SPEECH_ON%Czas udowodnic swa wartosc, najemniku.%SPEECH_OFF% | Jeden ze straznikow bierze lunete w skorzanym futerale i zaglada przez blanki. Rece zaczynaja mu drzec, luneta wypada i roztrzaskuje sie o kamienie. Wskazuje i krzyczy.%SPEECH_ON%N-nieumarli sa tu! D-do broni! Bicie w dzwony!%SPEECH_OFF%Patrzysz przez mury, ale nie potrzebujesz lunety, by zobaczyc nadchodzaca fale bladych. Uspokajasz straznika i pędzisz szykowac %companyname% do bitwy. | Wataha psow dotarla do %objective% i wyje, by je wpuscic. Glodni mieszkancy spełniaja ich prosbe i gdy tylko kundelki wchodza, rzucaja sie na nie noze i kosy. Mimo rzezi psy wciaz napieraja, walczac i gryząc, by znalezc bezpieczenstwo w rzeźni. Spogladasz na mury i widzisz, dlaczego ryzykuja: nieumarli nadchodza, sunac i szurajac po horyzoncie.\n\n Gwiżdżesz na czlowieka w dzwonnicy i wskazujesz. Prostuje sie tak szybko, ze metalowy kapturek spada i z brzękiem uderza o kamien. Pośpiesznie bije w dzwon, a jego glos ucisza psie wycie ponizej. Ludzie i zwierzeta zamieraja, zapada ponury bezruch. Powoli w powietrze wsiaka jazgot smierci, jeczenie i warczenie. Porucznik strazy wkracza z bronia w dloni.%SPEECH_ON%Do broni, ludzie! Do broni!%SPEECH_OFF% | Jeden nieumarly szura pod murem %objective%. Straznicy na zmiane strzelaja do niego z lukow.%SPEECH_ON%Patrzcie, trafil go w stope!%SPEECH_OFF%Inny straznik naciaga cięciwe.%SPEECH_ON%Wciaz idzie. Celuj w glowe, glupcze.%SPEECH_OFF%Strzala trafia i slychac cichy -tok- gdy przebija pusty mozg. Cialo na moment traci rownowage, zatrzymuje sie, po czym idzie dalej, jakby przypomnialo sobie cel. Kolejny straznik kręci glowa i naciaga cięciwe. Mruzy jedno oko, potem powoli je otwiera. Ręce mu drza, a strzala stuka o drewniany luk.%SPEECH_ON%D-do... do broni! Bijcie na alarm!%SPEECH_OFF%Patrzysz na mury i widzisz szare morze wyłaniajace sie na horyzoncie. Nieumarli atakuja! | Miasto jest ciche, tylko trzaski ognia wypełniaja powietrze. Widzisz, jak ludzie pieka szczura na rożnie i odkrawaja kawalki. Gdy masz dosc, idziesz na mury, gdzie porucznik strazy obserwuje horyzont przez lunete. Odkłada ja ponuro.%SPEECH_ON%No to po nas, nadchodza.%SPEECH_OFF%Podaje ci szkło i spogladasz. Gromada rybich, znieksztalconych nieumarlych sunie ku %objective%. Porucznik odbiera lunete.%SPEECH_ON%Czas zarobic na zaplate, najemniku.%SPEECH_OFF% | Krzyk kobiety zmusza cie do odwrócenia sie. Widzisz, jak mezczyzna skacze z wiezy i łamie kark na linie. Cialo kiwa sie, obija o mury. Porucznik zaciska usta i pluje.%SPEECH_ON%Cholera, mial pilnowac horyzontu. %randomname%! Wez go, odetnij i zajmij jego posterunek!%SPEECH_OFF%Inny straznik mruczy i robi, co kazano, ale gdy dociera na wieze, zaczyna histerycznie krzyczec.%SPEECH_ON%Panie! Panie! Nadchodza! Ci wszyscy bladzi, ida!%SPEECH_OFF%Porucznik krzyczy na zolnierzy, by szykowali sie do walki, a ty na swoich. Mezczyzna spoglada na ciebie z nadzieja.%SPEECH_ON%Cokolwiek ci placa, mam nadzieje, ze jestes wart kazdej korony, najemniku.%SPEECH_OFF% | Jeden ze straznikow znalazl gniazdo szczurów, co wywoluje ponura radosc. Mieszkancy krzycza i placza, a przenikliwe pisky gryzoni ida na rożnie i do ognia. Porucznik strazy podchodzi, obserwuje z usmiechem, ktory znika, gdy powietrze rozdziera krzyk. Wszyscy odwracaja sie ku murom, gdzie straznik wskazuje horyzont. Nawet stad widzisz białka jego przestraszonych oczu.%SPEECH_ON%Umarli ida! Idą nas zabić! Nie mamy dosc ludzi!%SPEECH_OFF%Porucznik każe mu wziac sie w garsc, po czym cicho zwraca sie do ciebie.%SPEECH_ON%Przygotuj ludzi, najemniku, i udowodnij, ze jestes wart tego, co ci placa.%SPEECH_OFF% | Zlapano straznika, ktory probowal zdezerterowac. Klęczy, a porucznik chodzi wokol z rozczarowaniem.%SPEECH_ON%Nie mamy ludzi, a ty nam to robisz?%SPEECH_OFF%Jeden z mieszczan rzuca bryla blota, ktora leci w bok, ale intencja jest jasna.%SPEECH_ON%Zywcem go zakopac! Jedna paszcza mniej do karmienia!%SPEECH_OFF%Gdy tlum robi sie burzliwy, dzwon miejski zaczyna bić. Mezczyzna na wiezy krzyczy na cale gardlo.%SPEECH_ON%Ida! Nieumarli, na horyzoncie!%SPEECH_OFF%Porucznik patrzy na dezertera.%SPEECH_ON%Chcesz odzyskac honor, zrob to teraz. Będziesz walczyl?%SPEECH_OFF%Mezczyzna szybko kiwa glowa. Porucznik zwraca sie do ciebie, ale ty unoszisz dlon.%SPEECH_ON%Nie musisz zadawac %companyname% takich pytan.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_73.png[/img]{Gdy %companyname% odpoczywa, czyszczac z broni sluz i scieki, z dzwonnicy nadchodzi kolejny sygnal. Nieumarli znów atakuja! | Porucznik obchodzi ludzi, upewniajac sie, ze odpoczywaja i pija wode. Gdy podchodzi do ciebie, dzwon bije, a wartownik krzyczy, ze nadchodzi kolejny atak! Usmiechasz sie i klepiesz porucznika po ramieniu.%SPEECH_ON%Robimy tylko to, co trzeba. Nic prostszego, prawda?%SPEECH_OFF%Porucznik kiwa glowa i idzie szykowac ludzi. | Widzisz, jak %randombrother% zeskrobuje z ostrzy bladych resztki miesa i mokre strzepy odzienia.%SPEECH_ON%Na starych bogow, jaki syf po sobie zostawiaja.%SPEECH_OFF%W tej chwili wartownik gwiżdże i krzyczy, ze nieumarli znów atakuja! Najemnik wsciekle zrzuca kawalek mozgu z ostrza.%SPEECH_ON%A akurat zaczalem widziec swoje odbicie!%SPEECH_OFF%Pomagasz mu wstac, klepiac po ramieniu.%SPEECH_ON%Uwierz, niewiele tracisz.%SPEECH_OFF% | Jeden ze straznikow kruszy twarda bule i rozdaje okruchy. Inny pyta, skad ma jedzenie, a ten odpowiada krótko.%SPEECH_ON%Z kieszeni jednego z tych trupów.%SPEECH_OFF%Jedzacy wypluwaja jedzenie, jeden nawet wymiotuje. Widzisz, jak mezczyzni zaczynaja sie bic, ale gwizd wartownika szybko ich rozdziela. Straznik na wiezy wskazuje horyzont.%SPEECH_ON%Znów nadchodza! Do boju!%SPEECH_OFF%Szykuj sie do walki i postaraj sie nie zabierac jedzenia z cial, ktore uwazaja cie za obiad. | Gdy twoi ludzie odpoczywaja, wartownik krzyczy.%SPEECH_ON%Znów nadchodza!%SPEECH_OFF%Wojna rzadko daje wytchnienie, zwlaszcza z nieumarlymi. | Widzisz %randombrother%a, jak wyciera twarz blotem. Zatrzymuje sie, widzac twoje spojrzenie.%SPEECH_ON%Blotna kapiel, panie. Zeby zmyc... krwawa kapiel.%SPEECH_OFF%Przewracasz oczami. W tej chwili dzwon bije, a wartownik krzyczy, ze nadchodzi kolejny atak! Kazesz najemnikowi skonczyc 'kapiel' i szykowac sie do walki. | Zastajesz %randombrother%a, jak wyciaga zebrane strzepy szarych flaków zza uszu.%SPEECH_ON%Mama zawsze mowila, zeby myc za uszami, ale chyba tego nie przewidziala!%SPEECH_OFF%Mowisz mu, ze dobra matka przewiduje wszystko. Smieje sie i kiwa glowa.%SPEECH_ON%No tak, krzyczalaby tylko, skad ja wzialem ten brud!%SPEECH_OFF%W tej chwili wartownik na wiezy krzyczy, ze nieumarli znów atakuja. Odwracasz sie do najemnika.%SPEECH_ON%No cóż, czas sie znowu ubrudzic.%SPEECH_OFF% | Zastajesz jednego z chlopow, jak nacina kreski na kamiennym murze. Na twój widok wyjasnia.%SPEECH_ON%Licze poleglych. Tylu ich bylo, ze nie zapamietam imion, ale potrafie liczyc.%SPEECH_OFF%Patrzysz wzdłuż muru i widzisz, jak imiona zastepowane sa liczbami.%SPEECH_ON%Robimy, co mozemy, zeby pamietac, wiesz?%SPEECH_OFF%Kiwasz glowa i wtedy wartownicy krzycza, ze nadchodzi kolejny atak. Chlop chwyta cie za ramie z błagalnym spojrzeniem.%SPEECH_ON%Powiedz mi swoje imie, to wpisze je, gdy nadejdzie czas.%SPEECH_OFF%Wyrywasz ramie i wpatrujesz sie w niego tak, że maleje.%SPEECH_ON%Jestem zabojca, glupcze, nie twoim przyjacielem. Jedyna roznica miedzy moim ostrzem a twoja szyja to ten, kto mi placi. Jesli spytasz jeszcze raz, wpisze twoj numer na ten mur za darmo, rozumiesz?%SPEECH_OFF%Mezczyzna kiwa glowa. Ty rowniez i odchodzisz szykowac najemnikow do bitwy. | Gdy ty i ludzie szykujecie sie do odpoczynku, wartownicy krzycza, a dzwon zaczyna bić. Nadchodzi kolejny atak! Rozkazujesz %companyname% przygotowac sie do walki. | Wspinasz sie na mury %objective% i znajdujesz porucznika strazy. Wzdycha.%SPEECH_ON%Atakuja. Znowu.%SPEECH_OFF%Patrzysz na horyzont i faktycznie, kolejna fala nadchodzi. Porucznik idzie zbierac ludzi do walki, a ty robisz to samo.}",
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
			Text = "[img]gfx/ui/events/event_73.png[/img]{Gdy wszyscy odpoczywaja, wartownik, z ochryplym glosem, krzyczy zrezygnowany.%SPEECH_ON%Znowu. Nadchodza... znowu.%SPEECH_OFF%%companyname% musi sprostac wyzwaniu, jesli %objective% ma przetrwac! | Jeden ze straznikow wpatruje sie w ogien, rece mu drza. Mamrocze do siebie, ale glosniej, by wszyscy slyszeli.%SPEECH_ON%Tak, to zrobimy! Mozemy z nimi pogadac! Dogadamy sie! Porozmawiamy! Ja to zrobie, ja z nimi pogadam!%SPEECH_OFF%Mezczyzna wstaje. Kilku probuje go powstrzymac, ale wymyka sie i biegnie na mury, po czym skacze na zewnatrz. Widzisz, jak ten szaleniec pędzi prosto ku ogromnej fali nieumarlych! Inny straznik zaczyna drzec.%SPEECH_ON%Na starych bogow, znów nadchodza? Skad ich tyle?%SPEECH_OFF%Ignorujesz go i patrzysz, jak wariat znika w tlumie trupow. Horda na chwile zwalnia, po czym rusza dalej, jak blada tafla poruszona kamieniem. Krzyczysz do ludzi.%SPEECH_ON%Do boju, ludzie! Znowu w ogien!%SPEECH_OFF% | Jeden z wartownikow dostrzega kolejny atak! Krzyczy tak mocno, ze peka mu glos i mdleje. Milicja %objective% jest na skraju wyczerpania, oby to byl ostatni szturm! | Wartownik gwiżdże ostrzezenie, ze nadchodza kolejni nieumarli. Porucznik kręci glowa.%SPEECH_ON%Na starych bogow, czy oni kiedys przestaną? Dzis naprawde zasluzyles na swoj zoldu, najemniku.%SPEECH_OFF%Masz ochote zartowac, ze nalezy ci sie wiecej, ale to nie czas. Kiwasz glowa i idziesz szykowac %companyname% do kolejnej bitwy. | Gdy ty i porucznik wymieniacie opowiesci, podchodzi milicjant. Widzisz, ze to straznik, ktory mial pilnowac murów. Mowi krótko.%SPEECH_ON%Panowie, znów atakuja.%SPEECH_OFF%I tak po prostu odwraca sie na piecie i idzie do zbrojowni. Wstajesz i pomagasz porucznikowi. Ten klepie cie po ramieniu, z powaznym usmiechem.%SPEECH_ON%Znowu w wir, co?%SPEECH_OFF%Wzruszasz ramionami.%SPEECH_ON%Po to tu jestesmy. Do zobaczenia na polu, poruczniku.%SPEECH_OFF% | Patrzysz z murów %objective% i widzisz kolejna fale nieumarlych. Cala ekscytacja poprzednich atakow znika. Obronców ogarnia cisza, gdy ciala szuraja dalej. Porucznik podchodzi do ciebie.%SPEECH_ON%To byl zaszczyt walczyc u twego boku, najemniku.%SPEECH_OFF%Kiwasz glowa i odpowiadasz.%SPEECH_ON%Mmm, zaszczyt, owszem.%SPEECH_OFF%Porucznik spoglada na ciebie.%SPEECH_ON%Myslisz o zaplacie, prawda?%SPEECH_OFF%Kiwajac znow, odpowiadasz.%SPEECH_ON%Mysle, co kupi: cieple lozko, cieplejszy posilek i jeszcze cieplejsza dziewke.%SPEECH_OFF% | Stoisz na murach %objective% i patrzysz na horyzont. Nadchodzi kolejny atak, ale nie ma w tym ekscytacji. Zadnych krzykow, histerii. Juz nie. Po prostu nadchodzi. Nabrzmiala, szurajaca, znieksztalcona armia trupow sunie naprzod, jakby prosila o kolejny rozbior. Rozkazujesz %companyname% przygotowac sie. %randombrother% niedowierzajaco rozklada rece, polowa ciala oklejona mokrymi resztkami rozerwanych nieumarlych.%SPEECH_ON%Panie, chyba mamy ich dosc.%SPEECH_OFF%Ludzie smieja sie, milicja dołącza, a wkrotce smiech wypelnia powietrze, zmieszany z jeczeniem coraz blizszych nieumarlych, szalenstwo wzmocnione. | %randombrother% podchodzi do ogniska, zrzucajac dlugie pasma wnetrznosci z ramion. Chlop zerka na trzewia, jakby byl o jedno burczenie brzucha od ugryzienia. Najemnik siada z ciezkim westchnieniem.%SPEECH_ON%Jesli jeszcze raz zobacze trupa idacego na mnie jak na obiad, to ja...%SPEECH_OFF%Zanim konczy zdanie, wartownik na murach dmie w rog i ryczy ostrzezenie. Upuszcza go, czerwony na twarzy i zziajany.%SPEECH_ON%Ni... nieumarli... znów atakuja!%SPEECH_OFF%Twarz najemnika kamienieje. Wstaje i bez slowa idzie po bron. | Rolnik stoi przy bramach %objective% i kłóci sie z obroncami.%SPEECH_ON%Wypuscic mnie! Przeciez juz ich wybiliscie, chce wrocic na swoje pola. Mam dwie krowy!%SPEECH_OFF%Wystawia dwa palce, na wszelki wypadek. Straznicy wzruszaja ramionami i otwieraja brame, ale rolnik nie rusza sie. Zamiast tego robi krok w tył.%SPEECH_ON%W sumie krowy moga poczekac, az wroce do domu.%SPEECH_OFF%Za murami widzisz ogromna horde nieumarlych wylewajaca sie na horyzoncie. W chwili, gdy sygnaly alarmowe ida w ruch, %objective% tetni ruchem ludzi biegnacych po bron do kolejnej bitwy. | Spotykasz porucznika strazy na murach. Dzieli sie chlebem z milicja i proponuje ci kawalek. Odmawiasz i pytasz, co na horyzoncie. Wskazuje pole.%SPEECH_ON%A nic, po prostu znów atakuja.%SPEECH_OFF%Podaje ci lunete. Patrzysz i widzisz ogromna zgraje trupow sunacych ku %objective%. Odkładasz szkło i pytasz, czemu nie podniesiono alarmu. Wzrusza ramionami.%SPEECH_ON%Daje ludziom minutę czy dwie. Chodzace trupy chca nas zabic, ale nie spiesza sie, wiesz?%SPEECH_OFF%Rozumiesz. Przyjmujesz podany chleb, a po chwili idziesz szykowac %companyname% do bitwy. | Jeden z milicjantow przyprowadza żywego trupa za mury. Ma go na lancuchu, cialu odcieto ręce. Z ust zwisa dlugi jezor. Porucznik schodzi, czerwony ze wscieklosci jakby mial zaraz zaklnac.%SPEECH_ON%Co, do cholery, ty wyprawiasz?%SPEECH_OFF%Milicjant szarpie lancuch i przewraca nieumarlych na ziemie. Nerwowo sie tlumaczy.%SPEECH_ON%Moze cos od nich wydedukujemy? Co ich porusza, jak ich przywrocic?%SPEECH_OFF%Zanim klotnia sie rozkreca, z wiezy słychać krzyk o kolejnym ataku. Porucznik odwraca sie z ostrzem w dloni i jednym ruchem odcina glowe nieumarlych. Jego bezbroda glowa toczy sie, a jęzor wije się jak wąż w słoju. Porucznik chwyta milicjanta za kołnierz.%SPEECH_ON%Nie rób takiego gówna drugi raz, rozumiesz? Oni są martwi. Tylko tyle. A teraz chwytaj, do cholery, bron.%SPEECH_OFF%%companyname% juz stoi gotowe, nie czekajac na rozkazy. | Zastajesz kowala, jak kuje 'najlepsza' bron %objective%. Jego masywne ramiona machaja młotem i szczypcami jakby byly z patyków. Na dłoni ma wytatuowana lemniskate. Iskry wiruja jak swietliki, a on szybko zauwaza twoj cien rzucany na jego otwarty warsztat.%SPEECH_ON%Witaj, najemniku.%SPEECH_OFF%Z czystej ciekawosci pytasz, jak sie miewa. Splaszcza kawalek stali i obraca go, powtarzajac ruch.%SPEECH_ON%Bywalo lepiej. Moglo byc gorzej. Jak wyglada?%SPEECH_OFF%Kowal podnosi ostrze do oceny. Zanim odpowiesz, dzwony biją na alarm, a ludzie ruszaja do obrony miasta. Milicjanci przebiegaja obok, zrywajac bron z hakow w jego kuźni. Opuszcza ostrze i smieje sie.%SPEECH_ON%Ech, idz walczyc, najemniku. To bylo pytanie retoryczne.%SPEECH_OFF% | Skryba %objective% chodzi z zwojem pergaminu. Pisze na plecach slugi wszystko, co widzi. Zaciekawiony pytasz, co bada w tym chaosie. Odpowiada krótko.%SPEECH_ON%Badam emocje. Smutek jest choroba i sie tu rozprzestrzenia.%SPEECH_OFF%Taka odpowiedz domaga sie dalszych pytan, ale on je ignoruje i mierzy cie wzrokiem.%SPEECH_ON%Wedlug moich miar jestes w doskonałym zdrowiu, najemniku. Cóż, poza cialem. Utykasz jak okaleczony pies i krzywisz sie, gdy skrecasz w lewo. Latwo to zauwazyc. Ale widze, ze bol cie nie powstrzymuje. Wrecz przeciwnie... napedza. Czy probujesz nadrobic cos, co ci zabrano?%SPEECH_OFF%Zanim odpowiesz - a chcialbys mu kazac zamknac usta - dzwony przerywaja, a ludzie ruszaja szykowac sie do kolejnego ataku nieumarlych. Gdy sie odwracasz, skryba juz znika, stojac w kacie i goraczkowo piszac ostrym piorem na plecach skandujacego slugi. | Gdy szykujesz sie do odpoczynku, dzwony znów biją, a wartownicy na murach krzycza. Wyglada na to, ze nieumarli znów atakuja! Spieszysz szykowac %companyname% do kolejnej bitwy. | Zauwazasz, ze szczyty murów poczernialy od sępów. Wielkie ptaki wpatruja sie w miasto jak w procesje zalobna. Nagle milicjant wychodzi z wiezy i roztrzaskuje jednego ptaka kijem. Krótki skrzek, reszta sępów przestawia sie jak lilie na pofalowanej wodzie. Milicjant uderza drugiego w glowe i padlinozercy odlatuja. Łowca wraca do wiezy, huśtajac zdobycz za nogi.%SPEECH_ON%Hej.%SPEECH_OFF%Porucznik strazy klepie cie po ramieniu. Gdy sie odwracasz, wskazuje kciukiem swoje plecy.%SPEECH_ON%Nieumarli znów atakuja. Kazałem ludziom trzymac alarmy cicho. Wiesz, na wypadek, gdyby nasze krzyki i histeria tylko przyciagaly wiecej tych drani.%SPEECH_OFF%Brzmi rozsądnie.}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{Wchodzisz do %townname% i widzisz %employer%a na balkonie. Wola do ciebie, gdy straznik wciska ci w ramiona sakiewke z koronami.%SPEECH_ON%Najemniku! Jak milo cie widziec! Moje ptaszki juz opowiedzialy mi o twoich czynach. Mam nadzieje, ze dobrze wydasz te korony!%SPEECH_OFF%Zanim zdazysz cos powiedziec, mezczyzna odwraca sie i odchodzi. Straznik, ktory podal ci sakiewke, tez znika. Chlopi przechodza obok ciebie jak drogowskazy do miejsc, do ktorych nigdy nie pojda. | Zastajesz %employer%a, jak bije i kopie dziecko, az w koncu kopie je w klatke piersiowa. Na twój widok szlachcic ociera pot i tlumaczy sie.%SPEECH_ON%To cie nie dotyczy.%SPEECH_OFF%Dziecko podpiera sie rekami i kolanami, jedna dlon trzyma na brzuchu, druga ociera krew z nosa. Powoli podnosi sie, chwiejąc, mruzac oczy. Sluga podbiega i zaczyna polewac go woda, ale szlachcic wyrywa szmate i odrzuca ją na bok.%SPEECH_ON%Tak sie uczy. Jesli chcesz komus pomoc, pomoz temu najemnikowi. Nalezy mu sie %reward_completion% koron. Szybko.%SPEECH_OFF%Sluga kiwa glowa i odchodzi. Zostajesz chwile, patrzac jak bicie trwa. Dziecko nie placze ani nie krzyczy, bo jest przyzwyczajone. Po kilku minutach sluga wraca z sakiewka, podaje ja tobie i szepcze, zebys odszedl. | %employer% pochyla sie nad stolem, rece ma zlozone jak dach, glowa opada nisko, gdy wpatruje sie w martwego kruka.%SPEECH_ON%Znalazlem go rano w lozku. Lezal tam. Martwy. Wiesz, co to znaczy?%SPEECH_OFF%Sugerujesz, ze to byl zart. Szlachcic prycha.%SPEECH_ON%Nie. Mysle, ze to ma zwiazek z toba, najemniku. Dobrze ocaliles to miasto, ale moze nie bylo mu to pisane? Moze ten ptak to symbol. Moze smierc upomni sie o mnie, bo zostawilem ją bez zaplaty.%SPEECH_OFF%Wykorzystujesz te slowa, by przejsc do sprawy zaplaty. Mimo jego dziwnych wynurzen, szlachcic w koncu sie opanowuje i wyplaca ci %reward_completion% koron. | %employer% slucha grupy skrybow ustawionych wedlug wieku i rangi. Mlodzi milcza, slychac tylko skrobanie pior. Starsi kloca sie, podnoszac glos równie czesto jak argumenty. Taki widok stal sie codziennoscia, bo temat powstalych z grobów zmarłych niepokoi filozofów. Dla wprowadzenia ryczysz soczystym beknięciem, przerywajac dyskusje. %employer% smieje sie i macha, bys wszedl.%SPEECH_ON%Ach, najemniku! Czlowiek, ktory robi robote, przybywa do tych, co tylko trajkocza?%SPEECH_OFF%Krecisz glowa i mowisz, ze jestes tu tylko po zaplate. Szlachcic kiwa glowa.%SPEECH_ON%Oczywiscie. Dobrze uratowales to miasto. Slyszalem o twoich czynach. %reward_completion% koron czeka w rogu.%SPEECH_OFF%Przechodzisz przez pokoj, a twoje buty dudnia w nagle uciszonej sali. Skrybowie patrza za toba i szepcza. Bierzesz sakiewke, slyszac przyjemny dźwięk koron. Po cichu wychodzisz, a gdy drzwi sie zamykaja, skrybowie wracaja do klotni. | %employer% stoi z kilkoma kobietami. Opowiadaja mu o utraconych ojcach, mezach i braciach. Kiwaja mu glowami, a on od czasu do czasu zerka na piersi najmlodszej.%SPEECH_ON%Tak, tak, oczywiscie. Okropne. Okropne! Chwileczke. Najemniku!%SPEECH_OFF%Machajac, wpuszcza cie. Kobiety rozstepuja sie, a najmlodsza ociera lzy i poprawia sie, by wygladac mlodziej. Szlachcic to dostrzega i zerka na was oboje.%SPEECH_ON%Ekhm, tak, twoje korony sa w rogu. Musisz isc. Teraz. Mam sprawy do zalatwienia.%SPEECH_OFF%Wstaje, wskazuje twoje %reward_completion% korony i jednym ruchem bierze mloda kobiete za dlon.%SPEECH_ON%A teraz, mloda wyplataczko, mowilas, ze twoj maz nie zyje i nie masz juz nikogo? Nikogo?%SPEECH_OFF% | Psy rozszarpuja cos na drodze. Cokolwiek to bylo, kiedys żylo, ale kosci i organy dawno zbladly i zgnily, choć zajadla uczta sugeruje stek. %employer% wita cie, z uwaznymi straznikami po bokach.%SPEECH_ON%Moje ptaszki mowia, ze miasto zostalo ocalone. Dobrze sobie poradziles, najemniku, lepiej niz sie spodziewalem. Twoja zaplata, jak uzgodniono.%SPEECH_OFF%Podaje ci sakiewke z %reward_completion% koron. Psy zatrzymuja sie i patrza na ciebie, z kawalkami miesa zwisajacymi z zebow, czarne oczy puste jak ich glod. Straznicy opuszczaja wlocznie, a psy, jakby rozumiejac, wracaja do uczty. | %employer% siedzi nisko w krzesle. Smutno macha, bys wszedl.%SPEECH_ON%Mam straszne wieści. Moj wieszcz twierdzi, ze sciagnalem klatwe na ziemie i ludzi. Dlatego umarli znów wstaja.%SPEECH_OFF%Wzruszasz ramionami i mówisz, ze wieszcz pieprzy glupoty. Szlachcic wzrusza ramionami.%SPEECH_ON%Oby. Na co sie umowilismy, %reward_completion% koron?%SPEECH_OFF%Kusza cie, by powiedziec, ze na wiecej, ale nie chcesz drażnic tak przesadnego czlowieka. Gdy odpowiadasz, uśmiecha sie cieplo.%SPEECH_ON%Dobra odpowiedz, najemniku. Zdalas test. Mogę wariowac, ale nie znosze, gdy ktoś mnie sprawdza.%SPEECH_OFF%Pytasz, czy szczerość zostanie nagrodzona. Unosi brew.%SPEECH_ON%Twoja glowa wciaz jest na karku, prawda?%SPEECH_OFF%Wiadomosc przyjeta. | %employer% stoi na balkonie. Dolaczasz do niego, a straznicy stoja blisko, obserwujac cie uwaznie. Szlachcic wskazuje miasto ponizej.%SPEECH_ON%Wiem, ze nie uratowales tego miasta bezposrednio, ale w pewien sposob tak. Zatrzymanie nieumarlych gdziekolwiek jest tak samo dobre jak tutaj. Zgadzasz sie?%SPEECH_OFF%Podkresla to, podajac sakiewke z %reward_completion% koron. Bierzesz zaplate i kiwasz glowa. On tez kiwa.%SPEECH_ON%Ciesze sie, bo mozemy jeszcze potrzebowac twoich uslug.%SPEECH_OFF% | Wchodzisz do zaciemnionego pokoju %employer%a. Okna zasloniete sa dywanami, a wiekszosc swiec nie pali sie. Jedyne swiatlo migocze przy skrybie stojacym z kandelabrem, jego rumiana twarz usmiecha sie jak maly diabel z trójzebem. Zerka na ciebie i cicho odklada swiece. Gdy cofa sie, wyglada jakby zapadal sie w czarny staw, a jego twarz znika w ciemnosci. Wciaz tam jest, oddycha, szura płaszczem, ale nie widzisz jego postaci. %employer% macha, bys wszedl.%SPEECH_ON%Najemniku! Na starych bogow, dobrze uratowales to miasto!%SPEECH_OFF%Podchodzisz, zerkajac na przesuwajace sie cienie. %employer% podaje ci sakiewke. Błysk monet odbija sie w swietle swiec.%SPEECH_ON%%reward_completion% koron, jak uzgodniono. A teraz prosze, odejdz. Mam jeszcze wiele do zbadania, wiele do nauczenia.%SPEECH_OFF%Zabierasz zaplate i wychodzisz. Gdy drzwi sie zamykaja, widzisz skrybe wynurzajacego sie niczym chudy upior, jego kosciste dłonie znów sięgaja po swiatlo. | %employer% jest w gabinecie. Straznicy stoja w kazdym rogu, a skryba krąży wokol polek, wyciagajac i odkladajac zwoje z rowna gorliwoscia co rozczarowaniem. Szybko cie wpuszczaja i równie szybko szlachcic cie wyplaca.%SPEECH_ON%Dobra robota, najemniku. Juz jestes bohaterem w niektorych stronach. Moze trafisz do tych zwojow i zostaniesz zapamietany na zawsze.%SPEECH_OFF%Slyszysz jak skryba parska. %employer% wskazuje drzwi.%SPEECH_ON%Prosze? Mam ogrom rzeczy do zbadania i tak malo czasu.%SPEECH_OFF% | Wchodzisz do pokoju %employer%a i widzisz go zapadnietego w fotelu. Chlopi kloca sie po obu stronach, oskarzajac i wskazujac palcami.%SPEECH_ON%Ten czlowiek to morderca!%SPEECH_OFF%Oskarzony prycha.%SPEECH_ON%Morderca? To byl wypadek! Myslalem, ze to jeden z nieumarlych!%SPEECH_OFF%Drugi prycha.%SPEECH_ON%Nieumarly? Był po prostu pijany!%SPEECH_OFF%Napiecie rośnie.%SPEECH_ON%No bo slyszalem warczenie! Albo pomruki.%SPEECH_OFF%%employer% macha cie w zrezygnowany sposob.%SPEECH_ON%Najemniku, dobra robota z tym miastem. Twoja zaplata.%SPEECH_OFF%Przesuwa po stole sakiewke z %reward_completion% koron. Chlopi milkną, patrzac na blysk monet. Bierzesz sakiewke, udajac, ze jest strasznie ciezka.%SPEECH_ON%Uff, ale ciezkie! Panowie, milego dnia.%SPEECH_OFF% | %employer% wita cie w swoim pokoju.%SPEECH_ON%Moje ptaszki mowia, ze miasto ocalalo. Dobra robota, najemniku, w świecie, ktory tak pociemniał. Twoja zaplata, %reward_completion% koron, jak uzgodniono.%SPEECH_OFF% | %employer% stoi na zewnatrz, patrzac na cmentarz, ktory od twojej ostatniej wizyty zyskał wielu mieszkańców. Podaje ci sakiewke z %reward_completion% koron.%SPEECH_ON%Dobrze sobie poradziles, najemniku. Wieści o twoich czynach rozeszly sie po kraju. Jedno zwyciestwo nie ocali nas wszystkich, ale stawia nas na właściwej drodze. Jesli mamy wygrac te przekletą wojne z umarlymi, potrzebujemy tyle ducha i nadziei, ile zdołamy zebrac.%SPEECH_OFF%Zabierajac zaplate, mowisz, ze najemnicy potrzebuja jak najwiecej koron, wiesz, by trzymac 'ducha' wysoko. Szlachcic usmiecha sie.%SPEECH_ON%Jestem moralizatorem, nie filantropem. Wynoś się stąd.%SPEECH_OFF% | Straznicy %employer%a prowadza cie do jego pokoju. Zwoje leża rozlozone dookola, a po stole walaja sie połamane piorka, jakby ktoś roztrzaskał tu ptaka.%SPEECH_ON%Najemniku! Dobrze widziec czlowieka godziny, dnia, tygodnia! Dobrze uratowales to miasto.%SPEECH_OFF%Rzuca ci sakiewke z %reward_completion% koron.%SPEECH_ON%Jedno zwyciestwo, by utrzymac miasto przy życiu, jedno, by utrzymać nadzieje ludzi. Powinienem zaplacic ci wiecej. To znaczy, nie zaplace, ale powinienem.%SPEECH_OFF%Smętnie bierzesz zaplate i odpowiadasz, kiwając glowa.%SPEECH_ON%Liczy sie gest.%SPEECH_OFF%Szlachcic pstryka palcami.%SPEECH_ON%Dokladnie!%SPEECH_OFF% | Zastajesz %employer%a zapadnietego w fotelu z jeszcze glebszym grymasem. Jego ubrania lśnia opulencja, a kandelabry wygladaja na cenniejsze od slug, ktore je trzymaja. Ten pstrokaty ponurak macha cie do srodka i mowi wolno, sarkastycznie.%SPEECH_ON%Jedno zwyciestwo dla czlowieka. Jeszcze jedno, by przetrwac do jutra. Mmm, dziekuje, najemniku.%SPEECH_OFF%Podchodzisz powoli, a słudzy patrza na ciebie z obawą. Bierzesz zaplate i cofasz sie. %employer% macha, bys odszedl.%SPEECH_ON%Odejdź. Mam nadzieje, ze sie jeszcze spotkamy, chyba ze bedziesz pokrzywiony i martwy, to byloby smutne. Z drugiej strony, tak wszyscy skoncza, prawda?%SPEECH_OFF%Nie odpowiadasz i wychodzisz. Wojna z nieskonczonymi nieumarlymi najwyrazniej zuzyla szlachcica.}",
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

