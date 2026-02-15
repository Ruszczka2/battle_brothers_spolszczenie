this.destroy_goblin_camp_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.destroy_goblin_camp";
		this.m.Name = "Zniszczenie Obozu Goblinów";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		local camp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(this.World.State.getPlayer().getTile());
		this.m.Destination = this.WeakTableRef(camp);
		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		this.m.Payment.Pool = 900 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 2);

		if (r == 1)
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
					"Zniszcz: " + this.Flags.get("DestinationName") + " na %direction% od %origin%"
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
				this.Contract.m.Destination.clearTroops();
				this.Contract.m.Destination.setLastSpawnTimeToNow();

				if (this.Contract.getDifficultyMult() < 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.GoblinRaiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);

				if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().get("Betrayed") && this.Math.rand(1, 100) <= 75)
				{
					this.Flags.set("IsBetrayal", true);
				}
				else
				{
					local r = this.Math.rand(1, 100);

					if (r <= 20 && this.World.Assets.getBusinessReputation() > 1000)
					{
						if (this.Contract.getDifficultyMult() >= 0.95)
						{
							this.Flags.set("IsAmbush", true);
						}
					}
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
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsBetrayal"))
					{
						if (this.Flags.get("IsBetrayalDone"))
						{
							this.Contract.setScreen("Betrayal2");
							this.World.Contracts.showActiveContract();
						}
						else
						{
							this.Contract.setScreen("Betrayal1");
							this.World.Contracts.showActiveContract();
						}
					}
					else
					{
						this.Contract.setScreen("SearchingTheCamp");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Return");
					}
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (this.Flags.get("IsAmbush"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Ambush");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.LocationTemplate = null;
						p.CombatID = "Ambush";
						p.Music = this.Const.Music.GoblinsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.GoblinRaiders, 50 * this.Contract.getScaledDifficultyMult(), this.Contract.m.Destination.getFaction());
						this.World.Contracts.startScriptedCombat(p, false, false, false);
					}
				}
				else
				{
					this.World.Contracts.showCombatDialog();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Betrayal")
				{
					this.Flags.set("IsBetrayalDone", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Betrayal")
				{
					this.Flags.set("IsBetrayalDone", true);
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
			Text = "[img]gfx/ui/events/event_61.png[/img]{%employer% czyta zwój, gdy wchodzisz. Odprawia cię, być może biorąc za sługę. Uderzasz pochwą o ścianę. Mężczyzna spogląda w górę, po czym szybko upuszcza papiery.%SPEECH_ON%Ach, najemniku! Dobrze cię widzieć. Mam problem odpowiedni dla człowieka o twoich... skłonnościach.%SPEECH_OFF%Zawiesza głos, jakby oczekiwał twojej odpowiedzi. Gdy jej nie ma, niezręcznie ciągnie dalej.%SPEECH_ON%Tak, oczywiście, zadanie. Na %direction% od %origin% gobliny ustanowiły coś na kształt przyczółka. Sam wziąłbym kilku rycerzy i zajął się sprawą, ale okazuje się, że "tłuczenie gobasów" jest poniżej ich godności. Bzdura, mówię. Myślę, że po prostu nie chcą zginąć z rąk tych karłowatych łajdaków. Honor, męstwo i te rzeczy.%SPEECH_OFF%Uśmiecha się krzywo i unosi dłoń.%SPEECH_ON%Ale dla ciebie to nie poniżej godności, o ile zapłata jest odpowiednia, prawda?%SPEECH_OFF% | %employer% wrzeszczy na mężczyznę wychodzącego z jego komnaty. Gdy się uspokaja, wita cię uprzejmie.%SPEECH_ON%Do diabła, dobrze cię widzieć. Masz pojęcie, jak trudno jest skłonić "lojalnych" ludzi do zabicia kilku goblinów?%SPEECH_OFF%Spluwa i wyciera usta rękawem.%SPEECH_ON%Podobno to niezbyt szlachetne zadanie. Podobno te małe łajdaczki nigdy nie walczą uczciwie. Wyobrażasz to sobie? Ludzie mówią mi, wysoko urodzonemu szlachcicowi, co jest "szlachetne" albo nie. Tak czy inaczej, najemniku, musisz iść na %direction% od %origin% i wykorzenić gobliny, które rozbiły obóz. Dasz radę?%SPEECH_OFF% | %employer% wysuwa i chowa miecz. Wydaje się spoglądać na siebie w odbiciu ostrza, po czym znów je zatrzaskuje.%SPEECH_ON%Chłopi znów mnie nękają. Mówią, że gobliny obozują w miejscu zwanym %location%, na %direction% od %origin%. Nie mam powodu im nie wierzyć, odkąd dziś przywleczono do mnie chłopca z zatrutym pociskiem w szyi.%SPEECH_OFF%Wbija miecz do pochwy.%SPEECH_ON%Czy zechcesz zająć się tym problemem?%SPEECH_OFF% | Czerwony na twarzy, pijany %employer% wali kuflem, gdy wchodzisz do jego komnaty.%SPEECH_ON%Najemnik, tak?%SPEECH_OFF%Jego strażnik zagląda i kiwa głową. Szlachcic się śmieje.%SPEECH_ON%Och. Dobrze. Więcej ludzi do wysłania na śmierć.%SPEECH_OFF%Zawiesza głos, po czym wybucha śmiechem.%SPEECH_ON%Żartuję, co za żart, prawda? Mamy kłopot z goblinami na %direction% od %origin%. Potrzebuję, żebyś się nimi zajął, dasz -hik- radę, czy mam poprosić kogoś innego, żeby wykopał własny... to znaczy...%SPEECH_OFF%Ucina, biorąc kolejny łyk. | %employer% porównuje dwa zwoje, gdy wchodzisz.%SPEECH_ON%Moim poborcom podatkowym trochę brakuje w ostatnich dniach. Szkoda, ale to pewnie dobry interes dla ciebie, skoro nie mogę wysłać nigdzie moich rzekomo "lojalnych" rycerzy.%SPEECH_OFF%Odrzuca papiery na bok i splata dłonie nad stołem.%SPEECH_ON%Moi szpiedzy donoszą, że gobliny rozbiły obóz w miejscu zwanym %location%, na %direction% od %origin%. Potrzebuję, byś tam poszedł i zrobił to, czego odmawiają moi chorążowie.%SPEECH_OFF% | %employer% łamie chleb, gdy wchodzisz, ale nie dzieli się. Macza oba końce w pucharze wina i pakuje do ust. Mówi, ale to bardziej okruchy niż słowa.%SPEECH_ON%Dobrze cię widzieć, najemniku. Mam kilka goblinów na %direction% od %origin%, które trzeba wykorzenić. Wysłałbym rycerzy, ale oni są, eee, trochę ważniejsi i mniej wymienni. Jestem pewien, że rozumiesz.%SPEECH_OFF%Udaje mu się wepchnąć resztę chleba do paskudnej paszczy. Przez chwilę się krztusi i przez chwilę rozważasz zamknięcie drzwi i zakończenie tego tutaj i teraz. Niestety, jego konwulsje zwracają uwagę strażnika, który wpada i wali szlachcica w pierś, wyrzucając zagrożenie z całym lepkim, niemal zabójczym skutkiem. | Gdy znajdujesz %employer%a, odsyła kilku rycerzy, przeganiając ich z drzwi paroma pożegnalnymi przekleństwami. Widok ciebie jednak na moment go uspokaja.%SPEECH_ON%Najemniku! Dobrze cię widzieć! Lepszy ty niż ci tak zwani "mężczyźni".%SPEECH_OFF%Siada i nalewa sobie drinka. Pije łyk, patrzy na niego, po czym opróżnia wszystko jednym haustem.%SPEECH_ON%Moi lojalni chorążowie odmawiają walki z goblinami, które obozują na %direction% od %origin%. Mówią o zasadzkach, truciznach i tak dalej...%SPEECH_OFF%Jego mowa staje się coraz bardziej bełkotliwa.%SPEECH_ON%Cóż... -hik-, wiesz to wszystko, prawda? I wiesz, o co zaraz poproszę, prawda? O - oczywiście, że wiesz, -hik-, potrzebuję, żebyś podał mi kolejnego drinka! Ha, żartuję. Idź zabij te gobliny, co ty na to?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Walczenie z goblinami nie będzie tanie. | Ufam, że sowicie nas za to wynagrodzisz. | Porozmawiajmy o pieniądzach.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{To nie jest tego warte. | Mamy inne zobowiązania.}",
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
			ID = "Ambush",
			Title = "Zbliżając się do obozu...",
			Text = "[img]gfx/ui/events/event_48.png[/img]{Wchodzisz do obozu goblinów i zastajesz go pustym. Ale wiesz lepiej - wiesz, że właśnie wpakowałeś się w pułapkę. W tej chwili przeklęci zielonoskórzy wyłaniają się ze wszystkich stron. Najgłośniejszym okrzykiem bojowym, jaki potrafisz, rozkazujesz ludziom szykować się do bitwy! | Gobliny cię nabrały! Opuściły obóz i obeszły was, osaczając cię. Przygotuj ludzi uważnie, bo z tej pułapki nie będzie łatwo uciec. | Powinieneś był wiedzieć lepiej: wpadłeś prosto w goblińską zasadzkę! Mają żołnierzy rozmieszczonych dookoła, a kompania stoi jak stado owiec do rzezi!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Uwaga!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Betrayal1",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Gdy dobijasz ostatniego goblina, nagle wita cię ciężko uzbrojona grupa ludzi. Ich dowódca wychodzi do przodu, kciuki zaczepione o pas podtrzymujący miecz.%SPEECH_ON%No proszę, naprawdę jesteś głupi. %employer% nie zapomina łatwo - i nie zapomniał, gdy ostatnim razem go zdradziłeś. Uznał to za mały... zwrot przysługi.%SPEECH_OFF%Nagle wszyscy ludzie za dowódcą ruszają do szarży. Do broni, to zasadzka! | Ścierając goblińską krew z miecza, nagle dostrzegasz grupę ludzi idących w twoją stronę. Niosą sztandar %employer%a i dobywają broni. Zdajesz sobie sprawę z podstępu w tej samej chwili, gdy ruszają do ataku. Pozwolili ci najpierw walczyć z goblinami, dranie! Daj im popalić! | Mężczyzna jakby znikąd wychodzi, by cię przywitać. Jest dobrze uzbrojony, dobrze opancerzony i najwyraźniej całkiem zadowolony, uśmiecha się niepewnie, gdy podchodzi.%SPEECH_ON%Dobry wieczór, najemnicy. Dobra robota z tymi zielonoskórymi, co?%SPEECH_OFF%Zatrzymuje się, by uśmiech zgasł.%SPEECH_ON%%employer% przesyła pozdrowienia.%SPEECH_OFF%W tej chwili z boków drogi wylewa się grupa ludzi. To zasadzka! Ten przeklęty szlachcic cię zdradził! | Grupa uzbrojonych ludzi w barwach %faction% ustawia się za tobą, rozchodząc się, by obserwować twoją kompanię. Ich przywódca mierzy cię wzrokiem.%SPEECH_ON%Sprawi mi przyjemność wydłubać ci ten miecz z zimnych, martwych rąk.%SPEECH_OFF%Wzruszasz ramionami i pytasz, czemu cię wrobili.%SPEECH_ON%%employer% nie zapomina tych, którzy go podwójnie krzyżują, ani jego rodu. To wszystko, co musisz wiedzieć. Nie tak, jakby moje słowa miały ci się przydać, gdy będziesz martwy.%SPEECH_OFF%Do broni, bo to zasadzka! | Twoi ludzie przeczesują obóz goblinów i nie znajdują żywej duszy. Nagle za tobą pojawiają się ludzie w barwach %faction%, a dowódca grupy podchodzi z jawnymi złymi zamiarami. Ma przy sobie tkaninę z wyhaftowanym sygnetem %employer%a.%SPEECH_ON%Szkoda, że zielonoskórzy nie dokończyli roboty. Jeśli zastanawiasz się, czemu tu jestem, przyszedłem odebrać dług wobec %employer%a. Obiecałeś dobrze wykonać zadanie. Nie dotrzymałeś obietnicy. Teraz giniesz.%SPEECH_OFF%Dobijasz miecz i błyskasz ostrzem w stronę dowódcy.%SPEECH_ON%Wygląda na to, że %employer% właśnie znów usłyszy złamaną obietnicę.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Chwytać za broń!",
					function getResult()
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationBetrayal);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().set("Betrayed", false);
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "Betrayal";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 140 * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Betrayal2",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Wycierasz miecz o nogawkę i szybko chowasz go do pochwy. Zasadzka leży martwa, przekłuta w tej czy innej groteskowej pozie. %randombrother% podchodzi i pyta, co teraz. Wygląda na to, że %faction% nie będzie już w najlepszych stosunkach. | Strącasz zwłoki zasadzki z czubka miecza. Wygląda na to, że %faction% nie będzie od teraz w najlepszych stosunkach. Może następnym razem, gdy zgodzę się coś dla nich zrobić, faktycznie to zrobię. | Cóż, jeśli nic innego, z tego można się nauczyć, by nie przyjmować zadań, których nie da się wykonać. Ludzie w tych stronach nie są szczególnie wyrozumiali wobec tych, którzy nie dotrzymują obietnic... | Zdradziłeś %faction%, ale to nie nad tym trzeba się teraz rozwodzić. To oni zdradzili ciebie, i to jest teraz ważne! A w przyszłości lepiej bądź podejrzliwy wobec nich i każdego, kto nosi ich barwy. | %employer%, sądząc po martwych chorążych u twoich stóp, przestał być z ciebie zadowolony. Jeśli miałbyś zgadywać, to przez coś, co zrobiłeś w przeszłości - zdradę, porażkę, pyskowanie, sypianie z córką szlachcica? Wszystko ci się miesza, gdy próbujesz o tym myśleć. Teraz ważne jest to, że ta rysa między wami nie zagoi się szybko. Lepiej przez jakiś czas uważaj na ludzi %faction%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To tyle, jeśli idzie o zapłatę...",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SearchingTheCamp",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_83.png[/img]{Po zabiciu ostatniego goblina rozglądasz się po ich obozowisku. Wyglądają na wesołków - stosy bibelotów i instrumentów, z których każdy mógłby posłużyć za broń. Wystarczyłoby zanurzyć je w ogromnym kotle trucizny stojącym pośrodku ruin. Kopiesz go i każesz ludziom szykować się do powrotu do %employer%a, twojego zleceniodawcy. | Gobliny stawiały dobry, przebiegły opór, ale udało ci się zabić je wszystkie. Podpalasz obóz i rozkazujesz ludziom szykować się do powrotu do %employer%a z dobrą nowiną. | Choć mali zielonoskórzy walczyli jak diabli, twoja kompania spisała się lepiej. Gdy ostatni goblin pada, rozglądasz się po zrujnowanym obozowisku. Wygląda na to, że nie byli całkiem sami - są ślady, że inne gobliny uciekły w trakcie walki. Rodzina? Dzieci? Nieważne, czas wracać do %employer%a, który cię wynajął. | Ach, to była dobra walka. %employer% będzie teraz czekał na wieści. | Nic dziwnego, że ludzie nie chcą walczyć z goblinami, stawiają opór znacznie większy niż sugeruje ich wzrost. Szkoda, że nie da się wlać ich umysłów w człowieka, ale może lepiej, że taka dzikość tkwi w tak małych istotach!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Czas odebrać naszą zapłatę.",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{Wchodzisz do komnaty %employer%a i rzucasz na podłogę kilka goblińskich głów. Spogląda na nie.%SPEECH_ON%Hę, w rzeczywistości są o wiele większe, niż mówią skrybowie.%SPEECH_OFF%Kilka słów wystarcza, by zdać relację ze zniszczenia obozowiska zielonoskórych. Szlachcic kiwa głową, pocierając brodę.%SPEECH_ON%Doskonale. Twoja zapłata, jak obiecałem.%SPEECH_OFF%Wręcza sakiewkę z %reward_completion% koronami. | %employer% rzuca kamieniami w płochliwego kota, gdy wchodzisz. Zerka na ciebie, dając biednemu stworzeniu minimalną szansę na ucieczkę przez okno. Szlachcic przegania go kolejnymi kamieniami, na szczęście chybiając każdym.%SPEECH_ON%Dobrze cię widzieć, najemniku. Moi szpiedzy już przekazali mi wieści o twoich dokonaniach. Oto twoja zapłata, jak uzgodniono.%SPEECH_OFF%Przesuwa po stole drewnianą skrzynkę z %reward_completion% koronami. | %employer% łupie orzechy, gdy wracasz. Rzuca skorupy na podłogę, mrucząc i zgrzytając zębami, gdy mówi.%SPEECH_ON%Oj, dobrze cię znów widzieć. Zakładam, że byłeś skuteczny, tak?%SPEECH_OFF%Podnosisz kilka goblińskich głów, każdą spiętą wspólnym rzemieniem. Skręcają się i wpatrują w izbę i w siebie nawzajem. Mężczyzna unosi dłoń.%SPEECH_ON%Proszę, tu są ludzie godni. Odstaw to.%SPEECH_OFF%Wzruszasz ramionami i przekazujesz je %randombrother%owi, który czeka na korytarzu. %employer% obchodzi stół i wręcza ci sakiewkę.%SPEECH_ON%%reward_completion% koron, jak uzgodniono. Dobra robota, najemniku.%SPEECH_OFF% | %employer% śmieje się, gdy widzi, że wchodzisz z goblińską głową.%SPEECH_ON%Do diabła, człowieku, nie przynoś ich tutaj. Daj je psom.%SPEECH_OFF%Jest trochę pijany. Nie jesteś pewien, czy cieszy się z powodzenia, czy po prostu jest naturalnie wesoły po odrobinie ale.%SPEECH_ON%Twoja zapłata to -hik- %reward_completion% koron, prawda?%SPEECH_OFF%Myślisz, by "poprawić" szczegóły, ale strażnik za drzwiami zagląda do środka i kręci głową. No cóż, wygląda na to, że to jednak %reward_completion% koron. | Gdy wracasz do %employer%a, ma kobietę na kolanach. Właściwie jest pochylona, a jego ręka uniesiona w powietrzu. Oboje patrzą na ciebie, zatrzymują się, po czym ona szybko chowa się pod stół, a on prostuje się.%SPEECH_ON%Najemniku! Dobrze cię widzieć! Zakładam, że z powodzeniem zniszczyłeś tych zielonoskórych, tak?%SPEECH_OFF%Biedna kobieta uderza głową pod biurkiem, ale starasz się na to nie zwracać uwagi, gdy informujesz mężczyznę o sukcesie wyprawy. Klaszcze w dłonie, wygląda, jakby miał wstać, po czym uznaje, że to zły pomysł.%SPEECH_ON%Jeśli łaska, twoja zapłata w wysokości %reward_completion% koron jest na półce za mną.%SPEECH_OFF%Uśmiecha się niezręcznie, gdy ją odbierasz.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Zniszczyłeś obozowisko goblinów");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isGreenskinInvasion())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
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
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"location",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.m.Destination.getName()
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.m.Origin.getTile().getDirection8To(this.m.Destination.getTile())]
		]);
	}

	function onOriginSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Origin.addSituation(this.new("scripts/entity/world/settlements/situations/greenskins_situation"));
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

		if (this.m.Origin != null && !this.m.Origin.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Origin.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(4);
			}
		}
	}

	function onIsValid()
	{
		if (this.m.IsStarted)
		{
			if (this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive())
			{
				return false;
			}

			if (this.m.Origin.getOwner().getID() != this.m.Faction)
			{
				return false;
			}

			return true;
		}
		else
		{
			return true;
		}
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

