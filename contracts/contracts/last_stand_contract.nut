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
			Text = "[img]gfx/ui/events/event_29.png[/img]{Zblizajac sie do %objective%, %randombrother% nagle wolą z wysunietego czola.%SPEECH_ON%Panie, szybko!%SPEECH_OFF%Biegniesz do niego i patrzysz przed siebie. Miasto jest kompletnie otoczone bladym morzem nieumarlych, kiwajacych sie i jęczacych! %companyname% musi sie przez nich przebic, by wejsc do srodka. | Mezczyzna podbiega do %companyname%. Trzyma sie za reke, a strumien krwi splywa mu po glowie. Krzyczy.%SPEECH_ON%Uciekajcie! Tu nic dla was poza groza!%SPEECH_OFF%%randombrother% rzuca nieznajomego na ziemie i dobywa broni, by go zatrzymac. Powstrzymujesz najemnika, gdy patrzysz przed siebie: %objective% jest juz otoczone przez wielu nieumarlych. %companyname% musi dzialac szybko! | Przybyles w sam czas: mury %objective% sa juz atakowane przez nieumarlych! | Zakrecajac za sciezke, zatrzymujesz sie nagle. Przed toba %objective% otacza tlum nieumarlych. Blizej stoi kilku, dziwnie odseparowanych od hordy. %companyname% musi przebic sie do %objective%! | Mury %objective% sa dziwnie szare - chwila, to nie drewno, to nieumarly! Z groza widzisz, ze blade potwory juz atakuja, ale masz jeszcze czas, by ocalic %objective% i przebic sie do srodka. Dobywasz miecza i rozkazujesz %companyname% do boju! | Bezksztaltny tlum nieumarlych stoi juz pod murami %objective%. Widzisz glowy obroncow wychylajace sie nad palisada, starajacych sie nie zdradzic. Dobywasz miecza i mowisz %companyname%, ze musza przebic sie do miasta. | Kilku nieumarlych jest juz przy bramach %objective%! Straznicy na bramie machaja do ciebie, przykladaja palec do ust, po czym wskazuja w dol. Wyglada na to, ze potwory jeszcze nie atakuja, bo nie wiedza? Nie jestes pewien, wiesz tylko, ze %companyname% ma jedna droge do srodka i prowadzi ona przez ostrze! | Na szczescie %objective% wciaz stoi. Niestety mury sa oblegane przez tlum bladych nieumarlych. %companyname% musi sie przebic do srodka!}",
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
			Text = "[img]gfx/ui/events/event_79.png[/img]{Zastajesz straznikow w %objective% wygladajacych, jakby nie spali od tygodni, ale sie usmiechaja. Twoje niezgrabne przedzieranie sie do bramy najwyrazniej ich rozbawilo. | Niezgrabna i potykajaca sie, %companyname% wreszcie przechodzi przez brame. W srodku straznicy stoja z rozbawiona rezygnacja, jakby dopiero co wyszli z koszmarnej bitwy, by byc swiadkami dziwnego zartu. Jeden klepie cie po ramieniu.%SPEECH_ON%To bylo cholernie zabawne do ogladania, najemniku, a moim ludziom podnioslo morale. Dziekuje.%SPEECH_OFF% | Rozgladasz sie i widzisz straznikow jako chudych, koscistych ludzi pilnujacych mieszkancow, ktorzy wygladaja jak na pol umarli. Zablocone drogi sa pelne brudu, smieci i trupow zwierzat. Kobiety i dzieci placza nad prowizorycznym cmentarzem: rowem z lista imion, ktora co chwile jest dopisywana. | Wchodzisz przez bramy %objective% i widzisz kilku straznikow z dlonmi opartymi na wloczniach. Ich ubrania zwisaja na kosciach jak firanki. W powietrzu czuje sie glod, a spojrzenia pelne oblizywania ust zdradzaja, jak zdrowo wygladasz. Jeden z obroncow wita cie dosc serdecznie.%SPEECH_ON%Jestesmy zmeczeni i troche glodni, ale damy rade. Walka wciaz w nas siedzi, nie watp w to.%SPEECH_OFF% | Gdy wchodzisz przez brame %objective%, pierwszym, kto cie wita, jest pies, lizacy twoje nogi i obwąchujacy spodnie. Nagle pojawia sie mezczyzna z maczuga, a zaraz potem czlowiek i pies pędza blotniasta ulica, obaj jakby szczekajac. Kundel umyka powolnym skokom glodnej tluszczy i znika. Usmiechniety straznik podchodzi, podpierajac sie kijem.%SPEECH_ON%Dobry wieczor, najemniku. Zapasy sa niskie, a taki piesek to uczciwa zdobycz w krainie pustych brzuchow.%SPEECH_OFF%Pytasz, czy wciaz potrafia walczyc, a on sie smieje.%SPEECH_ON%Do diabla, tylko walka nam zostala!%SPEECH_OFF% | Przejscie przez bramy %objective% to jak wejscie z normalnosci w same pieklo. Mieszkancy powloką sie bez celu, glodni i coraz bardziej slabnacy, a straznicy dziela sie zartami jak jedzeniem, smiejac sie i trzymając sie za brzuchy. Dowodca obrony podchodzi. Jest nieogolony, poraniony, z opuszczona szczeka, oczy ma zmeczone jak on sam. Choć stoi blisko, sprawia wrazenie, jakby patrzyl z innego swiata.%SPEECH_ON%Cieszę sie, ze dotarles, najemniku. Potrzebujemy twojej pomocy bardziej niz kiedykolwiek.%SPEECH_OFF% | Przechodzisz przez bramy %objective% i witasz sie z pieklem. Straznicy stoja jak szkielety podparte przez szalenca, a mieszkancy leza w brudzie albo opieraja sie twarza o mury. Dzieci stoja na strzechach i szukaja owadow. Porucznik obrony wita cie krótko.%SPEECH_ON%Dzieki, ze przyszedles, najemniku, ale powinienes byl zostac w domu.%SPEECH_OFF% | Przednie wrota %objective% z trudem sie otwieraja. Wchodzisz do miasta i widzisz grabarzy kopiących ogromny rów tuz przy drodze. Wrzucaja ciala i szykuja ognie do spalenia zwlok. Porucznik obrony podchodzi.%SPEECH_ON%Czasem martwi wracaja, ale popiolu juz nie. No moze wracaja, ale nikomu nie szkodzi.%SPEECH_OFF%Chcesz wspomniec o strasznym smrodzie, ale rozumiesz, ze pewnie przywykli do niego dawno temu. | Za zagraconymi bramami %objective% widzisz miasto, ktore jakby juz uleglo hordom nieumarlych. Mieszkancy powloka sie bez celu i bez nadziei. Kilku straznikow stoi przy wozie, rozdaja racje. Widzisz kilku obroncow śpiacych na murach, z rekami zwisajacymi na blankach i scisnietymi na broni, jak lalki rzucone w kat. Porucznik obrony podchodzi.%SPEECH_ON%Dziekuje, ze przyszedles, najemniku. Wielu z nas nie myslalo, ze przyjdziesz, biorac pod uwage, ze to pieklo.%SPEECH_OFF% | Bramy %objective% otwieraja sie i wchodzisz do srodka. Widzisz dwoch straznikow ciagnacych zwloki w strone plonacego stosu. Kobieta trzyma buty zmarlego, proszac o ostatnie spojrzenie. Ignoruja ja, wrzucaja cialo w ogien, a ona pada przed stosem, gdy skora jej meza trzaska i peka. Porucznik obrony podchodzi i klepie cie po ramieniu.%SPEECH_ON%Dobrze, ze jestes, najemniku.%SPEECH_OFF% | Za bramami %objective% podbiega do ciebie mezczyzna i chwyta za kolnierz.%SPEECH_ON%Masz jedzenie? Hmm? Czuje je, a moze to ty jestes jedzeniem?%SPEECH_OFF%Straznik odrywa go koncem wloczni. Szaleniec trzyma sie za brzuch i mowi, wydlubujac wszy z brwi i zjadajac je.%SPEECH_ON%Przyniesliscie wiecej mieczy, ale miecze nie sa tym, czego nam trzeba!%SPEECH_OFF%Straznicy odprowadzaja go, a porucznik podchodzi.%SPEECH_ON%Nie zwracaj na niego uwagi. Kiedys byl grubszy, więc obecne czasy szczególnie go bola. Mamy jeszcze jedzenie, tylko trzeba je racjonowac. Doceniamy wasze miecze, najemniku, i nie myl sie, wkrótce ich uzyjesz.%SPEECH_OFF% | Wchodzisz przez bramy %objective% i uderza cie zapach spalonego miesa. Jest tam tlacy sie stos zwlok, przy ktorym stoi straznik z kijem, mieszajac popiol jak kucharz zupę. Mieszkancy stoja obok zwęglonych szczatkow, wykonujac obrzedy i ocierajac lzy. Porucznik miasta podchodzi.%SPEECH_ON%Atak moze przyjsc z kazdej strony. Martwi wracaja, a my cierpimy. Ten stos to byla rodzina. Zona umarla w nocy i, pod osloną ciemnosci, jadla i jadla. Palimy wszystkie ciala. Musimy.%SPEECH_OFF%Porucznik widzi twoja krzywizne i łagodzi ton z usmiechem.%SPEECH_ON%A jak ci mija dzien?%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_46.png[/img]{Wygrales dzien, ale milicja mogla przegrac wojne: straz miejska poniosla tak duze straty, ze coraz wiecej mieszkancow pakuje sie i opuszcza wioske, zamiast zostac i bronic! | Zwyciestwo, ale jakim kosztem? Tylu milicjantow poleglo w bitwie, ze zadnen mieszkaniec %objective% nie chce ich zastapic!}",
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
			Text = "[img]gfx/ui/events/event_46.png[/img]{Bitwa wygrana, ale nie bez strat. Kilku mieszkancow %objective% zapisuje sie do obrony miasta, podczas gdy inni pakuja dobytek, by odejsc. | Wygrales dzien, ale nieumarli kazali ci za to drogo zaplacic. Część mieszkancow zgadza sie wspomoc milicje i uzupelnic jej szeregi, a tyle samo trzyma dystans i szykuje sie na najgorsze.}",
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
			Text = "[img]gfx/ui/events/event_80.png[/img]{Coz za zwyciestwo! Nie tylko odepchnales nieumarlych, ale twoj sukces byl tak imponujacy, ze wielu mieszkancow %objective% dolaczylo do milicji na kolejne bitwy! | Nieumarli zostali tak dotkliwie pobici, ze wielu mieszkancow %objective% dolaczylo do milicji, by pomoc w nadchodzacych starciach!}",
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
			Text = "[img]gfx/ui/events/event_69.png[/img]{Gdy szykujesz sie do walki, zauwazasz dziwne ksztalty krecace sie wśród nieumarlych: nachzehrery. Te stwory musza podazac za hordami, by pozerac to, co zabija, niczym mewy za kutrem rybackim. | Nachzehrery! Te paskudne stworzenia przemykaja miedzy tlumami trupow, na pewno szukajac kolejnego posilku. | Nieumarli zostawiaja po sobie wiele martwych i umierajacych, a nic dziwnego, ze padlinozercy ida ich tropem. W tym wypadku to nachzehrery, odrazajace bestie warczace i szczerzace zeby w oczekiwaniu na posilek. | Gdy pladrujesz spizarnie, zawsze pojawiaja sie myszy. Teraz, gdy nieumarli atakuja %objective%, przywlokli za soba orszak padlinozercow: nachzehery.}",
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
			Text = "[img]gfx/ui/events/event_46.png[/img]{Wpatrujesz sie w pole bitwy. Usiane jest martwymi, umierajacymi, nieumarlymi i umierajacymi nieumarlymi. Zywi, oddychajacy ludzie brodza w blotnistym brudzie, dobijajac wszystko, co chocby przypomina ozywienca. Walka sie skonczyla, miasto ocalone, a %employer% powinien cie teraz oczekiwac. | Bitwa zakonczona, miasto ocalone. Czas wracac do %employer% po sowita zaplate. | %objective% bardziej przypomina zalany cmentarz niz jakiekolwiek znane ci miasto. Nowe i stare zwloki porozrzucane sa po ziemi, a krew i spleśniały brud zbieraja sie wokol kazdego ciala. Smród przypomina ci zdechlego psa znalezionego przy strumieniu, kosci ociekajace rozkladem, cialo pozerane przez raki i larwy.\n\nNiestrudzone ataki wreszcie ucichly, %objective% wydaje sie bezpieczne. %employer% powinien cie oczekiwac, a ty nie masz powodow, by dluzej zwlekac z ucieczka z tego okropnego miejsca. | No cóż, miasto ocalone. Chlopi krążą po polu bitwy z dlugimi kijami, szturchajac ziemie jak pelikan w niebezpiecznym stawie. %randombrother% podchodzi, czysciac swoje ostrze z brei, i pyta, czy czas wracac do %employer%. Kiwasz glowa. Im szybciej wrócisz po zaplate, tym lepiej. | Bitwa zakonczona. Wsrod martwych sa chlopi i milicjanci, kazdy otoczony przez ocalałych, ktorzy przyszli przykryc ciala, placzac. A co do martwych nieumarlych, cóż, nikogo to nie obchodzi. Leza tak, jakby przyszli bez celu, a odeszli zostawiajac zniszczenie wszystkiego, czego dotkneli. Widok ich zwlok i chaotycznej pustki, ktora reprezentuja, jest wsciekły. Nie chcac tu byc ani chwili dluzej, kazesz ludziom szykowac sie do powrotu do %employer%. | Ty i %companyname% stoicie zwyciesko. Miasto i jego ludzie przetrwaja, przynajmniej na razie, a ty mozesz wrócić do %employer% po zaplate. | Porucznik strazy dziekuje ci za ocalenie miasta. Wspominasz, ze jedyny powod, dla ktorego tu jestes, to zaplata. Wzrusza ramionami.%SPEECH_ON%Dziekuje deszczom, na ktore nie mam wplywu, i bede dziekowal tobie, najemniku, czy ci sie to podoba, czy nie.%SPEECH_OFF% | Bitwa zakonczona i na szczescie wygrana. Ciala nieumarlych wala sie w takim nieładzie, ze prawie nie roznia sie od tego, jak wygladaly kilka godzin temu. Ale swiezo zmarli nie poddaja sie takiej kosmicznej apatii. Otaczaja ich placzace kobiety i zagubione dzieci. Odwracasz wzrok i rozkazujesz %companyname% przygotowac sie do powrotu do %employer%. | U twoich stop lezy martwy czlowiek, a obok niego trup nieumarly. To dziwny widok: obaj sa juz poza tym swiatem, ale w tamtym jeszcze tli sie zycie, tchnienie niedawnej pamieci. Widziales, jak walczyl do samego konca. Szlachetny koniec dla wojownika. A ten trup? Co o nim? Zapamietasz go, jak rozdzieral gardlo czlowiekowi gołymi zebami. Moze kiedys mial rodzine, moze byl dobrym czlowiekiem, ale teraz to tylko potwor, ktory rozrywa gardła. I tak zostanie zapamietany.\n\nNiestrudzone ataki na %objective% wreszcie ustały, wiec spieszysz zebrac kompanie i przygotowac powrot do %employer% w %townname%. Dobra zaplata jest lepsza niz kolejna chwila patrzenia na ten syf. | Czym jest martwy czlowiek? A martwy czlowiek zabity dwa razy? A zabity trzy razy? Pech. Jeszcze większy pech. I zart.\n\n Przemierzasz pole bitwy, zbierajac ludzi z %companyname%. Miasto %objective% jest ocalone, przynajmniej na razie, wiec czas wracac do %employer% w %townname% po zaslużona zaplate. | %randombrother% wyciera czolo szmata, zostawiajac obrzydliwa smuge bladej cieczy.%SPEECH_ON%Cholera, co to jest? To mozg? Panie, no prosze...%SPEECH_OFF%Pomagasz mu sie oczyścić. Staje, rozkładajac ręce. Wciaz jest cały we krwi, flakach i rzeczach, ktorych lepiej nie nazywac.%SPEECH_ON%Jak wygladam?%SPEECH_OFF%Jego usmiech wyłania sie z mroku jak sierp ksiezyca na bladym niebie. Nie odpowiadasz, tylko kazesz mu isc zebrac ludzi. %objective% ocalone, %employer% bedzie oczekiwal kompanii w %townname%, a kompania powinna spodziewac sie zasluzonej zaplaty. | %randombrother% podchodzi do ciebie i razem spoglądacie na pole bitwy. Widzisz juz rodziny martwych, ktore wychodza szukac swoich bliskich. Ich lament jest ostry i ludzki, dziwnie mile wytchnienie od jeczenia nieumarlych. Najemnik klepie cie po ramieniu.%SPEECH_ON%Pójdę zebrać ludzi, zebyśmy mogli wrócić do %townname% po nasza zaplate.%SPEECH_OFF% | Patrzysz, jak kobiety powloka sie po polu bitwy, podnoszac suknie jak mokre ptaki, by omijac brunatna maź. Gdy znajduja to, czego szukaja, porzucaja wszelka troske o czystosc, rzucaja sie w brud, wyjac i szlochajac, okrywajac sie tymi samymi okropnosciami, ktore z wsciekla obojetnoscia zabiły ich ojcow i meżow.\n\n %randombrother% dolacza do ciebie.%SPEECH_ON%Panie, ataki ustały, a ludzie sa gotowi do powrotu do %townname%. Wystarczy rozkaz.%SPEECH_OFF% | Porucznik strazy podchodzi i sciska twoja dlon. Zaschla krew peka i kruszy sie przy uścisku. Staje, opiera dłonie na biodrach i kiwa glowa na scene.%SPEECH_ON%Dobrze sobie poradziliscie, najemniku, i bez ciebie bysmy nie dali rady. Chcialbym dac wiecej w podziece, ale to miasto potrzebuje wszystkich zasobow do odbudowy. Mam nadzieje, ze %employer% zaplaci ci tyle, ile jestes wart.%SPEECH_OFF%Tez na to liczysz.}",
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
			Text = "[img]gfx/ui/events/event_30.png[/img]{Nieumarlych bylo zbyt wielu i musiales sie wycofac. Niestety cale miasto nie ma takiego przywileju, więc %objective% zostalo calkowicie zalane. Nie zostales, by zobaczyc, co stalo sie z mieszkancami, ale nie trzeba geniusza, by zgadnac. | %companyname% zostala pokonana w polu przez hordy nieumarlych! W wyniku porazki %objective% zostaje szybko zalane. Masa chlopow ucieka, a ci, ktorzy sa zbyt wolni, dolaczaja do morza szurajacych trupow. | Nie udalo ci sie powstrzymac nieumarlych! Trupy powoli przesuwaja sie poza mury %objective% i zabijaja oraz pozeraja wszystko, co napotkaja. Uciekajac z pola bitwy, widzisz porucznika strazy szurajacego obok hordy trupow.}",
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

		local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).spawnEntity(tile, "Horda NieumarՄych", false, this.Const.World.Spawn.UndeadArmy, (80 + this.m.Flags.get("Wave") * 10) * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
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
		local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).spawnEntity(this.m.Origin.getTile(), "Horda NieumarՄych", false, this.Const.World.Spawn.ZombiesOrZombiesAndGhosts, 100 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
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

