this.confront_warlord_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		IsPlayerAttacking = false
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

		this.m.Type = "contract.confront_warlord";
		this.m.Name = "Konfrontacja z Wodzem Orków";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 1800 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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

		this.m.Flags.set("Score", 0);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Zniszcz dowolne oddziały i obozy zielonoskórych, by wywabić ich wodza",
					"Zabij wodza orków"
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
				this.Flags.set("MaxScore", 10 * this.Contract.getDifficultyMult());
				this.Flags.set("LastRandomTime", 0.0);
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					this.Flags.set("IsBerserkers", true);
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
			}

			function update()
			{
				if (this.Flags.get("Score") >= this.Flags.get("MaxScore"))
				{
					this.Contract.setScreen("FinalConfrontation1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("JustDefeatedGreenskins"))
				{
					this.Flags.set("JustDefeatedGreenskins", false);
					this.Contract.setScreen("MadeADent");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("LastRandomTime") + 300.0 <= this.Time.getVirtualTimeF() && this.Contract.getDistanceToNearestSettlement() >= 5 && this.Math.rand(1, 1000) <= 1)
				{
					this.Flags.set("LastRandomTime", this.Time.getVirtualTimeF());
					this.Contract.setScreen("ClosingIn");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsBerserkersDone"))
				{
					this.Flags.set("IsBerserkersDone", false);

					if (this.Math.rand(1, 100) <= 50)
					{
						this.Contract.setScreen("Berserkers3");
					}
					else
					{
						this.Contract.setScreen("Berserkers4");
					}

					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsBerserkers") && !this.TempFlags.has("IsBerserkersShown") && this.Contract.getDistanceToNearestSettlement() >= 7 && this.Math.rand(1, 1000) <= 1)
				{
					this.TempFlags.set("IsBerserkersShown", true);
					this.Contract.setScreen("Berserkers1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onLocationDestroyed( _location )
			{
				local f = this.World.FactionManager.getFaction(_location.getFaction());

				if (f.getType() == this.Const.FactionType.Orcs || f.getType() == this.Const.FactionType.Goblins)
				{
					this.Flags.set("Score", this.Flags.get("Score") + 4);
					this.Flags.set("JustDefeatedGreenskins", true);
				}
			}

			function onPartyDestroyed( _party )
			{
				local f = this.World.FactionManager.getFaction(_party.getFaction());

				if (f.getType() == this.Const.FactionType.Orcs || f.getType() == this.Const.FactionType.Goblins)
				{
					this.Flags.set("Score", this.Flags.get("Score") + 2);
					this.Flags.set("JustDefeatedGreenskins", true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Berserkers")
				{
					this.Flags.set("IsBerserkersDone", true);
					this.Flags.set("IsBerserkers", false);
					this.Flags.set("Score", this.Flags.get("Score") + 2);
				}
			}

		});
		this.m.States.push({
			ID = "Running_Warlord",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Zabij wodza orków"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onCombatWithWarlord.bindenv(this));
				}

				this.Flags.set("IsWarlordEncountered", false);
			}

			function update()
			{
				if (this.Flags.get("IsWarlordDefeated") || this.Contract.m.Destination == null || this.Contract.m.Destination.isNull() || !this.Contract.m.Destination.isAlive())
				{
					this.Contract.setScreen("FinalConfrontation3");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatWithWarlord( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;

				if (!this.Flags.get("IsWarlordEncountered"))
				{
					this.Flags.set("IsWarlordEncountered", true);
					this.Contract.setScreen("FinalConfrontation2");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					properties.Music = this.Const.Music.OrcsTracks;
					properties.AfterDeploymentCallback = this.OnAfterDeployment.bindenv(this);
					this.World.Contracts.startScriptedCombat(properties, this.Contract.m.IsPlayerAttacking, true, true);
				}
			}

			function OnAfterDeployment()
			{
				local all = this.Tactical.Entities.getAllInstances();

				foreach( f in all )
				{
					foreach( e in f )
					{
						if (e.getType() == this.Const.EntityType.OrcWarlord)
						{
							e.getAIAgent().getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 0.0;
							e.getFlags().add("IsFinalBoss", true);
							break;
						}
					}
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getFlags().get("IsFinalBoss") == true)
				{
					this.Flags.set("IsWarlordDefeated", true);
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{Zastajesz %employer%a, jak przechadza się po stajniach. Przesuwa dłonią po boku jednego z koni.%SPEECH_ON%Wiesz, że ork potrafi złamać kark temu stworzeniu samą siłą? Widziałem to. Wiem, bo to mój koń zginął, a jego głowa była odwrócona do tyłu z powodu jednego bardzo wściekłego zielonoskórego.%SPEECH_OFF%Wspominanie to jedno, ale nie po to tu przyszedłeś. Delikatnie prosisz szlachcica, by przeszedł do sedna. Zgadza się.%SPEECH_ON%Racja. Wojna z zielonoskórymi nie idzie tak dobrze, jak byśmy chcieli, więc doszedłem do wniosku, że musimy zabić jednego z ich wodzów. Mówiąc wprost: ork, który przewyższa swoich nędznych braci siłą, to koszmar z krwi i kości. Najlepszym sposobem, by go wywabić, jest zabicie jak największej liczby jego pobratymców. Wiem, że to brzmi brutalnie, ale gdy to się skończy, nasze szanse na wygranie tej przeklętej wojny znacznie wzrosną.%SPEECH_OFF% | %employer% wita cię w swojej komnacie. Z zaniepokojeniem patrzy na mapę.%SPEECH_ON%{Moi zwiadowcy donoszą o wodzu w okolicy, ale nie jesteśmy pewni, gdzie dokładnie jest. Mam przeczucie, że jeśli wyjdziesz i narobisz tym zielonym draniom sporo kłopotów, to może w końcu wyjdzie się pobawić. Rozumiesz? | Mamy raporty o orczym wodzu, który włóczy się po tych ziemiach. Wierzę, że jeśli go zabijemy, morale orków spadnie i może jeszcze wygramy tę przeklętą wojnę. Oczywiście, nie będzie go łatwo znaleźć. Musisz sprawić, by ten wielki bydlak się ujawnił, a najlepszym sposobem jest mówienie po orczemu: zabijać jak najwięcej. Oczywiście, zabijać zielonoskórych. Nie rób tego na oślep. | Dobrze, że przyszedłeś, najemniku, bo mam dla ciebie zadanie. Dostaliśmy wieści, że w regionie jest orczy wódz, ale nie wiemy gdzie. Chcę, byś poćwiczył orczą dyplomację: zabij jak najwięcej tych zielonych dzikusów, a wódz na pewno się ujawni. Jeśli go usuniemy, ta wojna będzie wyglądać dla nas o wiele lepiej.}%SPEECH_OFF% | %employer% stoi otoczony przez poruczników i bardzo zmęczonego chłopaka z ubłoconymi butami i spoconą twarzą. Jeden z dowódców podchodzi i zabiera cię na bok.%SPEECH_ON%Dostaliśmy wieści o orczym wodzu. Rodzina tego dzieciaka zapłaciła cenę, widząc to na własne oczy. %employer% uważa, i ja się z tym zgadzam, że jeśli zabijemy jak najwięcej zielonoskórych, wódz może się ujawnić.%SPEECH_OFF%Opierasz się i odpowiadasz.%SPEECH_ON%I zgaduję, że mam mu uciąć głowę?%SPEECH_OFF%Dowódca wzrusza ramionami.%SPEECH_ON%To nie tak wiele do żądania, prawda? Mój pan jest gotów zapłacić sporo koron za tę robotę.%SPEECH_OFF% | %employer% siedzi pośród sfory śpiących psów. W ich pyskach tkwią pióra bażantów, drgające między chrapliwymi oddechami. Pan macha na ciebie.%SPEECH_ON%Wejdź, najemniku. Właśnie skończyłem polowanie. A przy okazji muszę wysłać cię na kolejne.%SPEECH_OFF%Siadasz. Jeden z psów unosi łeb, sapie, po czym znów zasypia. Pytasz, czego szlachcic chce. Wyjaśnia szybko, drapiąc jednego kundla za uchem.%SPEECH_ON%Dostałem wieści, że orczy wódz grasuje w okolicy. Gdzie dokładnie? Nie mam pojęcia. Ale sądzę, że potrafisz go wywabić. Wiesz jak, prawda?%SPEECH_OFF%Kiwasz głową i odpowiadasz.%SPEECH_ON%Tak. Zabijasz jego żołnierzy, aż się wścieknie i sam wyjdzie walczyć. Ale to nie jest byle prośba, %employer%.%SPEECH_OFF%Szlachcic szczerzy zęby i rozkłada ręce, jakby mówił: \'porozmawiajmy o interesach\'. Jego pies spogląda w górę, jakby mówił: \'o ile to znaczy, że będziesz mnie dalej drapał\'. | %employer% siedzi za długim biurkiem, z jeszcze dłuższą mapą zwisającą z obu końców. Jeden ze skrybów szepcze mu do ucha, potem podbiega do ciebie.%SPEECH_ON%Mój pan ma prośbę. Wierzymy, że w regionie jest orczy wódz i, rzecz jasna, chcemy, by ten dzikus został zgładzony. Aby to zrobić, musimy...%SPEECH_OFF%Podnosisz rękę i przerywasz.%SPEECH_ON%Tak, wiem, jak go wywabić. Zabijamy tylu skurczybyków, ilu się da, aż wielki wściekły zielony drań sam do nas przyjdzie.%SPEECH_OFF%Skryba uśmiecha się ciepło.%SPEECH_ON%Och, więc czytałeś też książki o tej taktyce? To wspaniale!%SPEECH_OFF%Twoje spojrzenie przygasa, ale przechodzisz do pytania o zapłatę. | %employer% spotyka cię w swoim gabinecie. Wyciąga książki z półek, a po każdym ruchu unoszą się obłoki kurzu.%SPEECH_ON%Siadaj.%SPEECH_OFF%Siadasz, a on przynosi jeden z tomów. Otwiera go na stronie i wskazuje jaskrawy obraz ogromnego orka.%SPEECH_ON%Znasz je, tak?%SPEECH_OFF%Kiwasz głową. To wódz, głowa orczej bandy i tryb, wokół którego wiruje wichura przemocy. Szlachcic kiwa głową i mówi dalej.%SPEECH_ON%Prowadzę małe badania, bo zwiadowcy donoszą o jednym z nich. Oczywiście, nigdy nie da się w pełni śledzić tego cholerstwa. Idzie, gdzie chce, a gdzie idzie, tam niszczy.%SPEECH_OFF%Przerywasz szlachcicowi i tłumaczysz prostą strategię: jeśli zabijesz dość zielonoskórych, wódz się obrazi albo, kto wie, poczuje wyzwanie i wyjdzie do walki. %employer% uśmiecha się.%SPEECH_ON%Widzisz, najemniku, dlatego cię lubię. Znasz się na rzeczy. Oczywiście zakładam, że to nie jest łatwe zadanie. Zapłata będzie więcej niż odpowiednia.%SPEECH_OFF% | %employer% wertuje stertę zwojów, które przynosi skryba. Ciągle kręci głową.%SPEECH_ON%Żaden z nich nie mówi, jak go znaleźć! Jeśli nie potrafimy go znaleźć, jak mamy go zabić? To prosta matematyka! Myślałem, że znasz matematykę!%SPEECH_OFF%Skryba odsuwa się, pociągając nosem i wpatrując się w podłogę, po czym szybko wychodzi. Pytasz, w czym problem. %employer% wzdycha i mówi, że orczy wódz jest w regionie, ale nie wiedzą, jak go powstrzymać. Śmiejesz się i odpowiadasz.%SPEECH_ON%To proste: mówisz ich językiem. Zabijasz tylu skurwysynów, ilu się da, aż wódz będzie zmuszony wyjść i zobaczyć cię osobiście. Orkowie kochają przemoc, rodzą się w niej i pewnie są przez nią hodowani. Oczywiście, samo zabicie wodza nie jest szczególnie łatwe...%SPEECH_OFF%%employer% pochyla się do przodu i składa palce w namiot.%SPEECH_ON%Tak, oczywiście, ale brzmisz jak człowiek do tej roboty. A ta robota może naprawdę przechylić tę przeklętą wojnę na naszą korzyść. Porozmawiajmy o interesach.%SPEECH_OFF% | Zastajesz %employer%a, jak przechadza się po ogrodzie. Zwraca szczególną uwagę na pędy roślin.%SPEECH_ON%Dziwne, prawda? Mamy tu te rzeczy, tak zielone, a te zielonoskóre dranie też są zielone, i nie sądzę, by kiedykolwiek w życiu zjadły choćby cholernego warzywa.%SPEECH_OFF%Masz ochotę powiedzieć, że to głupia obserwacja, ale gryzesz się w język. Zamiast tego pytasz, o co chodzi z zielonoskórymi, bo to zdaje się być sedno sprawy. %employer% kiwa głową.%SPEECH_ON%Tak, oczywiście. Moi zwiadowcy wypatrzyli wodza w regionie. Problem w tym, że nie wiemy, gdzie jest ani dokąd idzie. Zwiadowcy nie mogą go długo śledzić, bo zginęliby z oczywistych powodów. Uważam, że zabicie tego wodza przybliży nas o krok do zakończenia tej przeklętej wojny, ale nie mam pojęcia, jak to zrobić. Masz?%SPEECH_OFF%Kiwasz głową i odpowiadasz.%SPEECH_ON%Chcesz go zabić, bo zabija twoich ludzi, prawda? Co sprawi, że osobiście będzie chciał zabić nas? Zabijesz tylu jego drani, ilu się da.%SPEECH_OFF%Szlachcic klaszcze i rzuca ci jasnoczerwony pomidor.%SPEECH_ON%To właśnie jest dobre myślenie, najemniku. Porozmawiajmy o interesach!%SPEECH_OFF% | Zastajesz %employer%a i jego dowódców stojących nad mapą. Odwracają się w twoją stronę, gdy wchodzisz, jak jastrzębie dostrzegające królika. Szlachcic wita cię.%SPEECH_ON%Witaj, najemniku, jesteśmy trochę podenerwowani. Zwiadowcy meldują, że orczy wódz krąży po regionie. Problem w tym, że nie jesteśmy pewni, dokąd idzie i jak go znaleźć. Moi dowódcy uważają, że jeśli zabijemy możliwie wielu zielonoskórych, wódz się ujawni, a wtedy go zabijemy. Uważasz, że temu podołasz? Jeśli tak, porozmawiajmy o interesach.%SPEECH_OFF% | Wchodzisz do komnaty %employer%a i widzisz, jak naradza się ze skrybami. Widocznie drżą, ściskając koralikowe naszyjniki i wiercąc się. Jeden z nich wskazuje na ciebie.%SPEECH_ON%Może on ma jakiś pomysł?%SPEECH_OFF%Pozostali parskają, ale pytasz, w czym problem. %employer% wyjaśnia, że po ziemiach krąży orczy wódz, ale mają problem z jego śledzeniem. Kiwasz głową i podajesz proste rozwiązanie.%SPEECH_ON%Zabij jak najwięcej zielonoskórych, a wódz, przez swoją dumę, wyjdzie do walki. A w tym przypadku wyjdzie walczyć... ze mną?%SPEECH_OFF%%employer% kiwa głową.%SPEECH_ON%Masz dobrą głowę na karku, najemniku. Porozmawiajmy o interesach.%SPEECH_OFF% | %employer% stoi z dowódcami nad mapami.%SPEECH_ON%Mamy dla ciebie cholernie trudne zadanie, najemniku. Zwiadowcy wypatrzyli wodza krążącego po regionie i potrzebujemy, byś zabił jak najwięcej zielonoskórych, by go wywabić. Jeśli zdobędziemy głowę wodza, będziemy znacznie bliżej zakończenia tej przeklętej wojny.%SPEECH_OFF% | Gdy wchodzisz do komnaty %employer%a, pyta, czy wiesz coś o polowaniu na orczych wodzów. Wzruszasz ramionami i odpowiadasz.%SPEECH_ON%Odpowiadają na język przemocy. Jeśli chcesz z jednym pogadać, musisz pozabijać wielu jego pobratymców. To jedyny sposób, by wywabić go do walki, że tak powiem.%SPEECH_OFF%Szlachcic kiwa głową ze zrozumieniem. Przesuwa dokument po biurku.%SPEECH_ON%W takim razie mam coś dla ciebie. Wiemy o orczym wodzu w naszym regionie, ale trudno go wyśledzić. Chcę, byś go wywabił i zabił. Jeśli nam się uda, nasze szanse na wygranie tej wojny z zielonymi dzikusami wzrosną dziesięciokrotnie!%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Wierzę, że obficie nas za to wynagrodzisz. | Wszystko da się zrobić, jeśli zapłata jest należyta. | Przekonaj mnie brzęczącą sakiewką.}",
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
			ID = "ClosingIn",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Kopiec świeżo odciętych ludzkich czaszek. %randombrother% wpatruje się w totem udręczonych twarzy i kręci głową.%SPEECH_ON%Myślisz, że uważają to za sztukę? Jakby jeden z tych dzikusów cofnął się i powiedział: tak, wygląda dobrze.%SPEECH_OFF%Nie jesteś pewien. Bardzo masz nadzieję, że ludzie nie są pędzlem i płótnem dla zielonoskórych. | Trafiasz na pole wymordowanych zwierząt gospodarskich. Flaki spływają po bruzdach ziemi jak krwawa irygacja. Albo rolnik fatalnie odczytał pogodę, albo to pewny znak, że orki są blisko. | Zwłoki. Niektóre rozcięte na pół, inne dość spokojne, z kilkoma bełtami w plecach. Oba rodzaje ostateczności oznaczają, że zielonoskórzy są blisko. | Docierasz do opuszczonego obozu zielonoskórych. Leży tam goblin z roztrzaskaną czaszką. Być może starł się z dużo większym, silniejszym orkiem. Nad rusztem siedzi jakaś ohydna postać. Masz nadzieję, że to nie to, o czym myślisz. %randombrother% wskazuje żarzące się węgle.%SPEECH_ON%Świeże. Nie są daleko, panie.%SPEECH_OFF% | Docierasz do stodoły, której drzwi skrzypią na wietrze i same się otwierają i zamykają. %randombrother% zagląda do środka, po czym natychmiast cofa się z dłonią na nosie.%SPEECH_ON%Tak, zielonoskórzy tu byli.%SPEECH_OFF%Oszczędzając sobie tego widoku, mówisz ludziom, by szykowali się do walki, bo ta na pewno nadejdzie. | Znajdujesz martwego orka z martwym goblinem rozłożonym na jego grzbiecie. Odsuwasz oba ciała i znajdujesz pod nimi martwego rolnika. %randombrother% kiwa głową.%SPEECH_ON%Cóż, stawiał twardy opór. Szkoda, że nie zdążyliśmy wcześniej.%SPEECH_OFF%Wskazujesz świeże ślady w błocie.%SPEECH_ON%Był w mniejszości, a reszta nie jest daleko. Powiedz ludziom, by szykowali się do walki.%SPEECH_OFF% | Natrafiasz na człowieka owiniętego ciężkimi łańcuchami i najwyraźniej uduszonego nimi. Jego posiniała, zgnieciona sylwetka brzęczy i dzwoni, gdy łańcuchy kołyszą się i skręcają. %randombrother% odcina ciało. Z ust trupa wypływa ciemna krew, a najemnik odskakuje.%SPEECH_ON%Cholera, ten typ jest świeży! Ktokolwiek to zrobił, nie jest daleko!%SPEECH_OFF%Wskazujesz ślady w błocie i mówisz mu, że to na pewno robota zielonoskórych - są bardzo blisko. | Na drodze znajdujesz worek ze skóry. W środku leżą ludzkie uszy, wyprawione i zesztywniałe, z dziurami na breloki. %randombrother% odruchowo się dławi. Informujesz ludzi, że zielonoskórzy nie są daleko. Bitwa z pewnością nadchodzi! | Trafiasz na resztki chałupy. Żar tli się w zwęglonych szczątkach. %randombrother% znajduje parę szkieletów, zauważając, że brakuje im połowy ciał. Widząc głębokie ślady w popielatym błocie, każesz ludziom szykować się, bo zielonoskórzy na pewno są blisko. | Zastajesz mężczyznę szlochającego przy drodze. Siedzi po turecku, kołysząc się w przód i w tył. Gdy się zbliżasz, odwraca głowę - bez oczu, bez nosa, z wyciętymi wargami.%SPEECH_ON%Dość! Proszę, dość!%SPEECH_OFF%Upada na bok, zaczyna drgać, po czym nieruchomieje. %randombrother% grzebie przy ciele, po czym wstaje, kręcąc głową.%SPEECH_ON%Zielonoskórzy?%SPEECH_OFF%Wskazujesz głębokie ślady w błocie i kiwasz głową. | Natrafiasz na kobietę zawodzącą nad zwłokami. Ociekają krwią i flakami, a ciało pod jej kolanami ma zupełnie roztrzaskaną czaszkę. Kucasz obok. Spogląda na ciebie i jęczy. Pytasz, kto lub co to zrobiło. Kobieta odchrząkuje i odpowiada.%SPEECH_ON%Zielonoskórzy. Duże. Małe. Śmiali się, gdy to robili. Ich maczugi chodziły w górę i w dół, raz po raz, a między uderzeniami nie przestawali się śmiać.%SPEECH_OFF% | Znajdujesz martwego konia przy ścieżce, z wywróconym żołądkiem na trakcie. Z klatki piersiowej wciąż kapie świeża krew. %randombrother% zauważa, że serce, wątroba i inne wykwintne kąski zniknęły. Wskazujesz duże i małe odciski stóp śledzące krew wzdłuż ścieżki.%SPEECH_ON%Goblini i orkowie.%SPEECH_OFF%A są niedaleko. Rozkazujesz %companyname% przygotować się do walki.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Miejcie oczy otwarte!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "MadeADent",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_81.png[/img]{Przy tylu martwych zielonoskórych to tylko kwestia czasu, aż ich wódz wyjdzie się pobawić. | Zostawiłeś ślad martwych zielonoskórych. Ich wódz szybko zwęszy twoją obecność. | Wódz zielonoskórych z pewnością słyszy już historie o tym, jak jego wojownicy padają. Na pewno wyczuwa twój trop. | Gdybyś był wodzem zielonoskórych, szykowałbyś się do polowania na skurczybyka wycinającego twoje oddziały. Kontynuuj te zabójstwa, a przekonasz się, jak podobnie myślisz z tym dzikusem. | Dzikus rozumie przemoc, a ty zostawiłeś po regionie ślad krwawych lekcji. Jeśli wódz potrafi się uczyć, na pewno ruszy po ciebie bardzo szybko. | W bardziej gniewnych ocenach orczy wódz jest wściekły jak diabli na jakiegoś zbłąkanego człowieka psującego jego plany. Spodziewaj się go wcześniej czy później. Raczej wcześniej. | Przy tylu zabójstwach orków i goblinów to tylko kwestia czasu, aż ich naczelnik osobiście ruszy po ciebie. | Jeśli orkowie mówią językiem przemocy, to piszesz po całym regionie prawdziwy list miłosny. Wódz orków na pewno będzie w nastroju do rewanżu. | Jeśli przemoc to orczy język miłości, to stoisz w podwórzu wodza i rzucasz kamieniami w okno, żeby zwrócić jego uwagę. Tyle że to nie kamienie, tylko kończyny i głowy jego żołnierzy. Ten brutal na pewno odpowie każdego dnia. | Zostawiłeś długi ślad martwych zielonoskórych, który na pewno przyciągnie uwagę ich wodza. | Sępy mają dobrą robotę: wyciąłeś ścieżkę martwych zielonoskórych i wygląda na to, że każdego dnia ich wódz może przyjść i zobaczyć, co wyprawiasz. | Zabijanie zielonoskórych tak, jak to robisz, to pewny sposób, by przyciągnąć uwagę orczego wodza - i to napięcie rośnie. | Jeśli wszystko pójdzie zgodnie z planem, czyli nieskrępowaną rzezią zielonych dzikusów, to tylko kwestia czasu, aż orczy wódz przyjdzie zobaczyć cię osobiście. | Nawet pęd stada nie robiłby większego hałasu niż ty w ostatnim tygodniu. Jeśli będziesz dalej tłukł zielonoskórych na prawo i lewo, to tylko kwestia czasu, aż ich wódz się pojawi. | Masz przeczucie, że gdzieś w tym regionie bardzo, bardzo wściekły orczy wódz wpatruje się w prymitywny rysunek twojej twarzy. | Lubisz myśleć, że wśród zielonoskórych krążą twoje listy gończe. Patyczak człowieka z ceną pod spodem. Poszukiwany: martwy albo bardzo martwy. Problem w tym, że będziesz zabijał wszystkich, którzy cię napadną, dopóki sam wódz się nie pojawi - a masz wrażenie, że to wydarzy się wkrótce. | Z pewnością do tej pory zielonoskórzy opowiadają o tobie przy swoich ogniskach. Jakiś przeklęty człowiek terroryzujący ich szeregi. I nie masz wątpliwości, że orczy wódz usłyszy te historie i zechce sam sprawdzić, czy to prawda... | Zabijaj zielonoskórych w ten sposób, a ich wódz na pewno się pojawi. | Stąpasz po niebezpiecznych wodach. Przy tylu zabitych zielonoskórych orczy wódz na pewno przyjdzie wcześniej czy później. | Masz silne przeczucie, że orczy wódz pojawi się bardzo szybko. Może ma to związek z tym, że wybiłeś mu wszystkich żołnierzy. Tylko przeczucie. | Zabiłeś małych zielonoskórych i dużych zielonoskórych. Teraz czas zabić największego z nich wszystkich: wodza. Ten dzikus musi gdzieś tu być... | Wypowiedziałeś wojnę zielonoskórym i za to ich wódz na pewno pojawi się wcześniej czy później. | Zielonoskórzy padają jeden po drugim. W końcu ich wódz zrozumie, że to nie z przyczyn naturalnych. Gdy to pojmie, ruszy po ciebie w podwójnym tempie.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{Zwycięstwo! | Przeklęci zielonoskórzy.}",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "FinalConfrontation1",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_81.png[/img]{Słyszysz od wieśniaków plotki, że orczy wódz zbiera swoich wojowników i zmierza w twoją stronę. Jeśli to prawda, musisz przygotować się najlepiej, jak potrafisz. | Krążą plotki o orczym wodzu maszerującym przez region. I przypadkiem zmierza prosto do ciebie - co każe myśleć, że plan zadziałał! %companyname% powinno szykować się na piekielną walkę. | Mówią, że orczy wódz zmierza w twoją stronę! Szykuj %companyname%, bo czeka was piekielna walka! | Każdy chłop, którego mijasz, niesie tę samą plotkę: orczy wódz idzie na ciebie! To raczej nie przypadek, więc %companyname% powinno się odpowiednio przygotować. | Wieści niesione wiatrem mówią, że %companyname% jest celem orczego wodza maszerującego z małą armią. Wygląda na to, że plan zadziałał. Kompania powinna przygotować się na niezwykłą bitwę! | Wygląda na to, że każdy chłop, którego mijasz, ma tę samą historię: orczy wódz zgromadził małą armię i całkiem przypadkiem idzie w twoją stronę. %companyname% powinno szykować się na piekielną walkę! | Mała staruszka biegnie do ciebie. Wyjaśnia, że wszyscy mówią o orczym wodzu, który idzie w twoją stronę. Nie jesteś pewien, czy to prawda, ale biorąc pod uwagę twoje ostatnie działania, to zbyt zbieżne, by było przypadkiem. %companyname% powinno przygotować się do bitwy. | Cóż, %companyname% powinno przygotować się do bitwy. Każdy, kogo mijasz, opowiada tę samą historię: orczy wódz zgromadził małą armię i idzie prosto na was! | Wygląda na to, że zabójstwa zadziałały: wieści mówią, że orczy wódz i jego armia idą po ciebie, by załatwić kompanię osobiście. %companyname% powinno szykować się do walki! | Mały chłopak podchodzi do ciebie. Zerka na znak %companyname%, a potem na ciebie. Uśmiecha się.%SPEECH_ON%Chyba potrzebujecie pomocy.%SPEECH_OFF%To może być prawda, ale dziwnie brzmi z ust dzieciaka. Pytasz go, czemu tak mówi, a on odpowiada.%SPEECH_ON%Mój tata powiedział, że wielki zły ork chce was wszystkich zabić. Mówił, że handlarze o tym gadają caaaaaały dzień!%SPEECH_OFF%Hmmm, jeśli to prawda, to znaczy, że strategia zadziałała, a %companyname% powinno szykować się do bitwy. Dziękujesz chłopcu. Wzrusza ramionami.%SPEECH_ON%Właśnie uratowałem wam życie i tylko dziękuję? Ludzie!%SPEECH_OFF%Chłopak pluje i odchodzi, kopiąc kamyki.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Musimy się na to przygotować.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				local playerTile = this.World.State.getPlayer().getTile();
				local nearest_orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(playerTile);
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 9, 15);
				local party = this.World.FactionManager.getFaction(nearest_orcs.getFaction()).spawnEntity(tile, "Horda Zielonosk\x0480rych", false, this.Const.World.Spawn.GreenskinHorde, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.getSprite("banner").setBrush(nearest_orcs.getBanner());
				party.getSprite("body").setBrush("figure_orc_05");
				party.setDescription("Horda zielonoskórych, dowodzona przez wzbudzającego grozę wodza orków.");
				party.setFootprintType(this.Const.World.FootprintsType.Orcs);
				this.Contract.m.UnitsSpawned.push(party);
				local hasWarlord = false;

				foreach( t in party.getTroops() )
				{
					if (t.ID == this.Const.EntityType.OrcWarlord)
					{
						hasWarlord = true;
						break;
					}
				}

				if (!hasWarlord)
				{
					this.Const.World.Common.addTroop(party, {
						Type = this.Const.World.Spawn.Troops.OrcWarlord
					}, false);
				}

				party.getLoot().ArmorParts = this.Math.rand(0, 35);
				party.getLoot().Ammo = this.Math.rand(0, 10);
				party.addToInventory("supplies/strange_meat_item");
				party.addToInventory("supplies/strange_meat_item");
				party.addToInventory("supplies/strange_meat_item");
				party.addToInventory("supplies/strange_meat_item");
				this.Contract.m.Destination = this.WeakTableRef(party);
				party.setAttackableByAI(false);
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local intercept = this.new("scripts/ai/world/orders/intercept_order");
				intercept.setTarget(this.World.State.getPlayer());
				c.addOrder(intercept);
				this.Contract.setState("Running_Warlord");
			}

		});
		this.m.Screens.push({
			ID = "FinalConfrontation2",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_49.png[/img]{Wódz stoi na czele grupy orków i goblinów. Wyrasta wysoko ponad i tak ogromnych wojowników, którzy go otaczają. Każesz ludziom zająć szyki i ledwie słowa padają z ust, wódz ryczy, a jego wojownicy ruszają ku tobie! | Przed tobą stoi duża formacja orków i goblinów, a ich wódz na przedzie. Wychodzi naprzód i ciska w twoją stronę tobołek. Rozwija się w locie i otwiera po uderzeniu o ziemię. Wysypuje się z niego tuzin głów, jakby były kulkami z dziecięcej torby. Wódz unosi broń i ryczy. Gdy zielonoskórzy ruszają na ciebie, szybko rozkazujesz %companyname% zająć szyki. | %companyname% stoi przed zwartą masą zielonoskórych: orków, goblinów i ich wodza, bestialskiego stworzenia, które wydaje się niezgrabne nawet wśród swoich. Ogromny wojownik unosi broń i ryczy, płosząc ptaki z drzew i wypłaszając drobnicę do nor.\n\nGdy zielonoskórzy ruszają do szarży, krzyczysz do ludzi, by ustawili się w szyku i pamiętali, kim są: %companyname%! | Ty i %companyname% wreszcie stajecie naprzeciw wodza i jego armii orków i goblinów. To wygląda na okazję do przemowy, ale zanim zdążysz powiedzieć słowo, brutalni dzicy ruszają do szarży! | Wreszcie siły człowieka i bestii stają naprzeciw siebie. Po drugiej stronie %companyname% stoi mała armia orków i goblinów, a na czele brutalny wódz. Dobywasz miecza, a wódz unosi broń. Choćby na chwilę pojawia się zrozumienie, że dziś zginą wojownicy i tylko wojownicy. | Orkowy wódz i jego armia szarżują! Mówisz %companyname%, że do tego się trenowali i przygotowywali.%SPEECH_ON%Nie byłoby nas tu, gdybyśmy tego nie chcieli!%SPEECH_OFF%Ludzie ryczą, dobywają ostrzy i ustawiają się w szyku. | Gdy horda goblinów i orków pędzi przez pole, a na czele biegnie ogromny wódz, mówisz ludziom, by się nie bali.%SPEECH_ON%Tej nocy będziemy mieli co świętować, ludzie!%SPEECH_OFF%Dobywają broni i ryczą, ogłuszającym krzykiem, który odbija się od zielonoskórych, po raz pierwszy wyraźnie zaskoczonych. | %randombrother% podchodzi do ciebie, wskazując małą armię orków i goblinów biegnącą w waszą stronę, z wodzem na czele.%SPEECH_ON%Nie chcę mówić oczywistości, ale zielonoskórzy są tutaj.%SPEECH_OFF%Kiwasz głową i krzyczysz do ludzi.%SPEECH_ON%Kto jeszcze tu jest?%SPEECH_OFF%Ludzie dobywają broni.%SPEECH_ON%%companyname%!%SPEECH_OFF% | Ty i %randombrother% patrzycie, jak orczy wódz szarżuje w waszą stronę, a za nim mała armia orków i goblinów. Najemnik śmieje się.%SPEECH_ON%Cóż, oto nadchodzą.%SPEECH_OFF%Kiwasz głową i zwracasz się do ludzi.%SPEECH_ON%Szarżują, bo się boją. Bo nie mają na czym stać. My mamy, bo my stoimy właśnie tutaj!%SPEECH_OFF%Wbijasz sztandar %companyname% w ziemię. Znak łopocze na wietrze, a ludzie ożywają w ryku. | Patrzysz, jak zielonoskórzy szarżują, a ich wódz prowadzi natarcie. Dobywając miecza, krzyczysz do ludzi.%SPEECH_ON%Dobranoc każdemu, kto zdobędzie głowę dzikusa. Kto dziś śpi spokojnie?%SPEECH_OFF%Metal grzechocze, gdy ludzie dobywają broni i krzyczą.%SPEECH_ON%%companyname%!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						this.Contract.getActiveState().onCombatWithWarlord(this.Contract.m.Destination, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "FinalConfrontation3",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_81.png[/img]{Wódz jest tam, gdzie powinien być: martwy na ziemi. Patrzysz, jak reszta zielonoskórych ucieka w góry. Twój pracodawca, %employer%, będzie bardzo zadowolony z pracy, jaką %companyname% wykonało tego dnia. | %companyname% triumfuje! Orkowy wódz leży martwy w błocie, a jego armia rozproszyła się po wzgórzach. To wynik, z którego %employer% będzie niezwykle zadowolony. | Twój pracodawca, %employer%, zapłacił za najlepszych i to właśnie dostał: orczy wódz nie żyje, a jego wędrująca banda dzikusów uciekła. Bez przywódcy bestie rozproszą się i zginą same. Powinieneś wrócić do szlachcica po zapłatę. | Zgasiłeś zielonoskórych, zabijając ich wodza i posyłając ich w popłochu na wzgórza. Twój pracodawca, %employer%, będzie bardzo zadowolony z %companyname%. | Orkowy wódz nie żyje, a bez głowy wąż zielonoskórych zwinie się i zdechnie. %employer% będzie bardzo zadowolony z tej wieści. | Orkowy wódz nie żyje. Wygląda zaskakująco spokojnie, biorąc pod uwagę ilość terroru i chaosu, jakie sprowadził na tę ziemię. %randombrother% podchodzi, śmiejąc się.%SPEECH_ON%Jest wielki, ale umiera. Ludzie chyba zawsze zapominają o tej ostatniej części.%SPEECH_OFF%Kiwasz głową i mówisz ludziom, by szykowali się do powrotu do %employer% w %townname%. | Wódz leży martwy u twoich stóp, dokładnie tam, gdzie powinien. %companyname% zarobiło swoją wypłatę od %employer%. Pozostaje wrócić do szlachcica i przekazać wieści. | %employer% pewnie w ciebie nie wierzył. Pewnie nie przewidział tej chwili, gdy ty, kapitan najemników, stoisz nad martwym orczym wodzem. Ale właśnie tu jesteś, bo z %companyname% nie ma żartów. Czas wrócić do szlachcica po zapłatę. | Orkowy wódz nie żyje, a jego armia rozproszona. Rozglądasz się i krzyczysz do ludzi.%SPEECH_ON%Ludzie, mój przyjaciel chce zabić swojego najgorszego wroga, kogo powinien wezwać?%SPEECH_OFF%Unoszą pięści.%SPEECH_ON%%companyname%!%SPEECH_OFF%Śmiejesz się i kontynuujesz.%SPEECH_ON%Starsza kobieta chce, byśmy wybili wszystkie szczury na strychu, kogo powinna wezwać?%SPEECH_OFF%Ludzie, tym razem ciszej.%SPEECH_ON%%companyname%?%SPEECH_OFF%Szeroko się uśmiechasz i ciągniesz dalej.%SPEECH_ON%Jeśli delikatny panicz boi się pająka na ścianie, kogo powinien wezwać?%SPEECH_OFF%%randombrother% spluwa.%SPEECH_ON%Chodźmy już do %townname% i %employer%!%SPEECH_OFF% | Patrzysz, jak zielonoskórzy rozbiegają się jak szczury. %randombrother% wygląda na gotowego do pościgu, ale zatrzymujesz go.%SPEECH_ON%Niech uciekają.%SPEECH_OFF%Najemnik kręci głową.%SPEECH_ON%Ale będą o nas mówić! Wiedzą, kim jesteśmy.%SPEECH_OFF%Szeroko się uśmiechasz i klepiesz go po ramieniu.%SPEECH_ON%Dokładnie. Chodźmy z powrotem do %townname% i %employer%.%SPEECH_OFF% | Przechodzisz przez sterty martwych, stając przed zabitym orczym wodzem. Muchy już na nim siedzą. %randombrother% stoi obok, spoglądając na bestię.%SPEECH_ON%Nie był taki zły. Znaczy, okej, był dość przerażający. Trochę taki, co to będzie mi się śnił po nocach, ale ogólnie nie najgorzej.%SPEECH_OFF%Uśmiechasz się i klepiesz go po ramieniu.%SPEECH_ON%Mam nadzieję, że kiedyś będziesz straszył wnuki historiami o tym.%SPEECH_OFF% | Pole bitwy ucichło. Martwi leżą tam, dokąd zmierzali przez całe życie. Zielonoskórzy uciekli w góry. A %companyname% świętuje zwycięstwo. %employer% będzie bardzo zadowolony z takiego obrotu spraw. | %companyname% triumfuje nad zielonoskórymi dzikusami. Patrzysz na orczego wodza, biorąc pod uwagę, że wiele rzeczy musiało zginąć tylko po to... by on mógł zginąć. Dziwny świat z dziwnymi zasadami, ale tak po prostu jest.\n\n%employer% będzie zadowolony i hojnie zapłaci - a świat monety to świat, który rozumiesz najlepiej. | Ty i %randombrother% patrzycie na zwłoki orczego wodza. Muchy już krzątają się na jego języku, dupcząc się i roznosząc zarazę. Najemnik patrzy na ciebie i śmieje się.%SPEECH_ON%Tak widzisz swój koniec? Banda owadów robiących interesy na twojej cholernej twarzy?%SPEECH_OFF%Wzruszasz ramionami i odpowiadasz.%SPEECH_ON%To dalekie od umierania w kocu, wśród rodziny, to na pewno.%SPEECH_OFF%Klepnąłeś najemnika w pierś.%SPEECH_ON%No już, dość gadania. Wracajmy do %employer% po zapłatę.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{%companyname% żyje nadal! | Zwycięstwo!}",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.setState("Return");
			}

		});
		this.m.Screens.push({
			ID = "Berserkers1",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_93.png[/img]Podczas marszu %randombrother% nagle prostuje się i każe wszystkim ucichnąć. Kucasz nisko i podkradasz się do niego. Wskazuje przez krzaki.%SPEECH_ON%Tam. Kłopoty. Wielkie, tłuste kłopoty.%SPEECH_OFF%Patrzysz przez krzaki i widzisz obóz orczych berserkerów. Mają małe ognisko z rusztem i obracającym się mięsem. W pobliżu stoi grupa klatek, w każdej uwięziony skomlący pies. Widzisz, jak jeden z zielonoskórych otwiera klatkę i wyciąga psa. Wlecze go wrzeszczącego ku ognisku i trzyma nad płomieniami.\n\nNajemnik spogląda na ciebie.%SPEECH_ON%Co robimy, panie?%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Jesteśmy w trakcie wojny i każda bitwa się liczy. Do broni!",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos(), true);
						p.CombatID = "Berserkers";
						p.Music = this.Const.Music.OrcsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.BerserkersOnly, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				},
				{
					Text = "To nie nasza walka.",
					function getResult()
					{
						return "Berserkers2";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Berserkers2",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_93.png[/img]To nie wasza walka i nigdy nią nie będzie. Każesz ludziom obejść obóz, po cichu unikając starcia, które łatwo mogłoby się przerodzić w wyniszczającą bitwę z grupą berserkerów. Wycie psów zdaje się was gonić i zostaje w uszach kilku ludzi na długo po tym, jak opuściliście to miejsce.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Skupmy się na naszym zadaniu, ludzie.",
					function getResult()
					{
						this.Flags.set("IsBerserkers", false);
						this.Flags.set("IsBerserkersDone", false);
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.houndmaster")
					{
						bro.worsenMood(1.0, "Nie pomogłeś psom wojennym pożeranym przez orków");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Berserkers3",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_32.png[/img]Po walce rozglądasz się po obozie berserkerów. Każda klatka kryje wychudzonego, przerażonego psa. Gdy otwierasz jedną z klatek, pies wyskakuje, skomląc i ujadając, pędzi przez wzgórza i znika. Większość kundli robi to samo. Dwa jednak zostają. Kręcą się przy tobie, gdy oglądasz resztę obozu. %randombrother% zauważa, że to psy wojenne.%SPEECH_ON%Spójrz na ich rozmiar. Wielkie, krzepkie, wredne skurczybyki. Ich właścicieli musiały zabić orki, a teraz, cóż, mają powód, by nam zaufać. Witamy w kompanii, mali kumple.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Dobra robota, bracia.",
					function getResult()
					{
						this.Flags.set("IsBerserkers", false);
						this.Flags.set("IsBerserkersDone", false);
						return 0;
					}

				}
			],
			function start()
			{
				local item = this.new("scripts/items/accessory/wardog_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + item.getName()
				});
				item = this.new("scripts/items/accessory/wardog_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Berserkers4",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_32.png[/img]Gdy ostatni berserker pada, zabierasz się za obóz. Wokół ogniska leżą spalone kości psów. Mięso zostało wyjedzone do cna, a stos głów chybotał się jak chorobliwy kopiec. %randombrother% otwiera klatki. Wszystkie psy, gdy tylko mają okazję, pędzą i uciekają. Najemnikowi udaje się złapać jednego, ale ten skomli i wiotczeje, umierając z czystej paniki i strachu. Reszta obozu nie ma nic wartościowego poza rozczarowaniem i stertami orczego gówna.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "I tak dobrze nam poszło.",
					function getResult()
					{
						this.Flags.set("IsBerserkers", false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Zastajesz %employer%a rozmawiającego z generałami. Odwraca się do ciebie z uśmiechem i rozłożonymi ramionami.%SPEECH_ON%Cóż, zrobiłeś to, najemniku. Muszę przyznać, nie sądziłem, że się uda. Zabawna sprawa, zabijać orki.%SPEECH_OFF%To nie było szczególnie zabawne, ale i tak kiwasz głową. Szlachcic idzie po sakiewkę %reward_completion% koron i wręcza ją osobiście.%SPEECH_ON%Dobrze wykonana robota.%SPEECH_OFF% | %employer% leży w łóżku z kilkoma kobietami. Jego strażnik stoi przy drzwiach, wzruszając ramionami z miną \'kazałeś go wpuścić\'. Szlachcic macha na ciebie.%SPEECH_ON%Jestem trochę zajęty, ale rozumiem, że odniosłeś sukces we wszystkich swoich... eee, przedsięwzięciach.%SPEECH_OFF%Pstryka palcami i jedna z kobiet wysuwa się spod koca. Zgrabnie przechodzi po zimnym kamieniu, podnosi sakiewkę i podaje ci ją. %employer% mówi dalej.%SPEECH_ON%%reward_completion% koron, tak? Myślę, że to całkiem niezła zapłata za to, co zrobiłeś. Słyszałem, że zabicie orczego wodza to niełatwa sprawa.%SPEECH_OFF%Kobieta patrzy ci głęboko w oczy, podając pieniądze.%SPEECH_ON%Zabiłeś orczego wodza? To takie odważne...%SPEECH_OFF%Kiwasz głową, a smukła dama obraca się na pięcie. Szlachcic znów pstryka palcami i kobieta wraca do łóżka.%SPEECH_ON%Ostrożnie, najemniku.%SPEECH_OFF% | Strażnik prowadzi cię do ogrodu, gdzie %employer% pielęgnuje grządki. Podcina warzywa i wrzuca je do kosza trzymanego przez sługę.%SPEECH_ON%Sądząc po tym, że nie jesteś martwy, moje zdolności dedukcyjne mówią mi, że udało ci się zabić orczego wodza.%SPEECH_OFF%Odpowiadasz.%SPEECH_ON%Nie było łatwo.%SPEECH_OFF%Szlachcic kiwa głową, patrząc w ziemię, po czym dalej obcina pomidory.%SPEECH_ON%Strażnik stojący tamtędy ma twoją zapłatę. %reward_completion% koron, jak uzgodniliśmy. Jestem teraz bardzo zajęty, ale powinieneś wiedzieć, że ja i mieszkańcy tego miasta dużo ci zawdzięczamy.%SPEECH_OFF%A przez \'dużo\' najwyraźniej rozumie właśnie %reward_completion% koron. | %employer% wita cię w swojej komnacie.%SPEECH_ON%Moje ptaszki ćwierkają ostatnio dużo, opowiadając o najemniku, który zabił orczego wodza i rozproszył jego armię. I pomyślałem sobie: hej, ja chyba znam tego faceta.%SPEECH_OFF%Szlachcic uśmiecha się i wręcza sakiewkę %reward_completion% koron.%SPEECH_ON%Dobra robota, najemniku.%SPEECH_OFF% | %employer% wita cię sakiewką %reward_completion% koron.%SPEECH_ON%Moi szpiedzy już powiedzieli mi wszystko, co trzeba. Jesteś człowiekiem, któremu można ufać, najemniku.%SPEECH_OFF% | Gdy wchodzisz do komnaty %employer%a, widzisz, jak słucha szeptów jednego ze skrybów. Widząc cię, mężczyzna zrywa się na nogi.%SPEECH_ON%Mówisz o diable i diabeł przychodzi. Jesteś tematem całego miasta, najemniku. Zabić orczego wodza i rozproszyć jego armię? Cóż, powiedziałbym, że to warte %reward_completion% koron, które uzgodniliśmy.%SPEECH_OFF% | %employer% wpatruje się posłusznie w mapę.%SPEECH_ON%Będę musiał to wszystko przerysować dzięki tobie - i mówię to w pozytywnym sensie. Zabicie orczego wodza pozwoli nam odbudować się z popiołów, które rozsiał po tych ziemiach.%SPEECH_OFF%Kiwając głową, delikatnie pytasz o zapłatę. Szlachcic uśmiecha się.%SPEECH_ON%%reward_completion% koron, tak? I powinieneś poświęcić chwilę, by pozwolić spłynąć pochwałom, najemniku. Pieniądze nigdzie nie znikną, ale duma, którą teraz czujesz, kiedyś zgaśnie.%SPEECH_OFF%Nie zgadzasz się. Te pieniądze zgasną w kuflu dobrego miodu. | %employer% przechadza się po komnacie, podczas gdy generałowie stoją przy ścianach w niemal służalczej ciszy. Pytasz, w czym problem, a mężczyzna gwałtownie się prostuje.%SPEECH_ON%Na starych bogów na zadzie muchy, nie sądziłem, że się uda.%SPEECH_OFF%Ignorujesz to wspaniałe wotum zaufania i informujesz szlachcica o wszystkim, co zrobiłeś. Kiwając głową, wyciąga sakiewkę %reward_completion% koron i wręcza ją.%SPEECH_ON%To robota dobrze wykonana, najemniku. Cholernie dobrze!%SPEECH_OFF% | Zastajesz %employer%a, jak ogląda sługę rąbiącego drewno. Gdy widzi twój cień, szlachcic obraca się.%SPEECH_ON%Ach, człowiek chwili! Już tyle słyszałem o tym, co zrobiłeś. Urządzamy właśnie świętowanie - trzeba przygotować drewno na gotowanie i nocne festyny. Zaprosiłbym cię, ale to tylko dla wysokourodzonych, na pewno rozumiesz.%SPEECH_OFF%Wzruszasz ramionami i odpowiadasz.%SPEECH_ON%Lepiej bym to rozumiał, gdybym miał %reward_completion% koron, które uzgodniliśmy.%SPEECH_OFF%%employer% śmieje się i pstryka palcami do strażnika, który natychmiast przynosi twoją zapłatę. | %employer% rozmawia z kapitanem innej kompanii najemników. To wątły dowódca, zapewne dopiero zaczyna. Gdy cię widzi, szlachcic szybko go odprawia i wita ciebie.%SPEECH_ON%Ach, dobrze cię widzieć, najemniku! Zaczynało się tu robić trochę rozpaczliwie.%SPEECH_OFF%Zauważasz, że kapitan, którego właśnie widziałeś, byłby najmniej odpowiednią osobą do takiego zadania, nie mówiąc już o polowaniu na orczego wodza. Szlachcic wręcza ci sakiewkę %reward_completion% koron i odpowiada.%SPEECH_ON%Słuchaj, umówmy się, że dziś dobrze się spisałeś. Wreszcie możemy zacząć odbudowę po zniszczeniach tego przeklętego orczego dzikusa i to się liczy.%SPEECH_OFF%Korony w twojej dłoni są tym, co się liczy, ale zgadzasz się przestać wałkować temat.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Zabiłeś sławnego wodza orków");
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

