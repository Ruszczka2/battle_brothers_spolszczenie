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
			Text = "[img]gfx/ui/events/event_46.png[/img]{A cairn of humanly skulls freshly removed. %randombrother% stares at the totem of anguished faces and shakes his own head.%SPEECH_ON%You suppose they consider this art? Like did one of them savages take a step back and said, Yeah, that looks good.%SPEECH_OFF%You\'re not sure. You very much hope that humans are not the brush and canvas for the greenskins. | You come across a field of slaughtered farm animals. Entrails have been run down the farm\'s corrugated soils like some sanguinary irrigation. Either a farmer horribly misread the weather, or this is a sure sign of the orcs being close. | Dead bodies. Some cleaved in twain, others rather peaceful with but a few darts pocking their backs. Both forms of finality are a sure sign of greenskins being close. | You come to an abandoned greenskin encampment. There\'s a goblin with its head crushed. Perhaps it got into a fight with a much larger, stronger orc. Some ghastly shape is sitting over a spit. You just hope it\'s not what you think it is. %randombrother% points at the embers crackling beneath the meal.%SPEECH_ON%This is fresh. They aren\'t far off, sir.%SPEECH_OFF% | You come to a barn with its doors creaking open and shut in a pungent wind. %randombrother% peaks inside, then quickly bolts back with a hand to his nose.%SPEECH_ON%Yeah, the greenskins have been here.%SPEECH_OFF%Sparing yourself a look into the barn, you tell the men to prepare for a battle because it is surely coming. | You find a dead orc with a dead goblin splayed across its back. Pushing both bodies over, you find a dead farmer beneath. %randombrother% nods.%SPEECH_ON%Well, he gave a hell of a fight. A shame we couldn\'t have gotten here sooner.%SPEECH_OFF%You point to a running of fresh tracks in the mud.%SPEECH_ON%He was outnumbered and the rest of them aren\'t far off. Tell the men to prepare for battle.%SPEECH_OFF% | You come across a man wrapped in heavy chains and, apparently, squeezed to death by them. His purpled and crushed body chinks and chimes as the chains swing and twist. %randombrother% cuts the body down. The corpse spews dark blood from its mouth and the sellsword jumps away.%SPEECH_ON%Hell, this guy\'s fresh! Whoever did this ain\'t far off!%SPEECH_OFF%You point at tracks in the mud and tell him this is no doubt the work of greenskins and, indeed, they are very close by. | You find a bag made of flesh in the road. Inside it are human ears, tanned and stiff with holes to run keychains through. %randombrother% gags. You inform the men that the greenskins aren\'t far off. No doubt a battle is coming! | You come across the remains of a hovel. Embers crackle in the blackened remains. %randombrother% finds a couple of skeletons, noting that they are missing half their bodies. Seeing some deep tracks in the ashen mud, you inform the men to ready themselves as greenskins are no doubt close by. | You find a man sobbing by the road. He\'s sitting cross-legged, body bobbing forward and back. When you get near, he twists his head around, eyeless and noseless and with the lips cut away.%SPEECH_ON%No more! Please, no more!%SPEECH_OFF%He falls to his side and starts convulsing and then he is still. %randombrother% pokes around the body then stands up, shaking his head.%SPEECH_ON%Greenskins?%SPEECH_OFF%You point at the deep tracks in the mud and nod. | You come across a woman wailing over a corpse. She is dripping blood and gore, and the body beneath her knees has had its head completely caved in. You crouch beside her. She glances at you and moans. You ask who or what did this. The woman clears her throat and answers.%SPEECH_ON%Greenskins. Big ones. Small ones. They laughed as they did it. Their clubs went up, down, over and over, and in between they would not stop laughing.%SPEECH_OFF% | You find a horse dead beside the path with its stomach turned out into the trail. Its rib cage is still pouring a fresh drip. %randombrother% notes that the heart, liver, and other gourmet segments are missing. You point at big and small footprints tracking blood further up the path.%SPEECH_ON%Goblins and orcs.%SPEECH_OFF%And they\'re not far off. You order the %companyname% properly prepare itself for a fight.}",
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
			Text = "[img]gfx/ui/events/event_81.png[/img]{With this many greenskins dead, it seems only a matter of time until their warlord comes out to play. | You\'ve left a trail of dead greenskins. Their warlord will catch wind of you real soon. | The greenskins\' warlord is surely hearing stories of its warriors being cut down by now. He\'s no doubt getting a scent of you. | If you were the greenskins\' warlord, you\'d probably be readying to hunt down the bastard cutting down your troops. Keep these killings up and you\'ll no doubt see how similarly you and that savage think. | A savage understands violence, and you\'ve surely left a trail of gory teachings all over the region. If the warlord is a learning creature, it\'ll no doubt be heading for you real soon. | By more wrathful estimations, the orc warlord is for sure angered as fark against some wayward human making a mess of his plans. You should expect that savage sooner or later. Most likely the former. | With this many orc and goblin killings, it is only a matter of time until their head master personally comes after you. | If orcs speak the language of violence, then you\'ve been penning a real love letter up and down the region. Surely the orc warlord will be in a requiting mood. | If violence is the orcish language for love, then you\'ve been standing in their warlord\'s yard throwing a lot of rocks through the window trying to get its attention. But, instead of rocks, it\'s the limbs and heads of its soldiers. That brute will be sure to respond any day now. | You\'ve left a long trail of dead greenskins no doubt sure to attract the attention of their warlord. | Business is good for the buzzards: you\'ve cut a path of dead greenskins and it seems likely that, any day now, their warlord will come and see for himself what you are up to. | Killing greenskins like you\'ve been doing is a surefire way to get an orc warlord\'s attention - and that heat is rising. | If things keep going according to plan, that is to say the unimpeded slaughter of green savages, then surely it is only a matter of time until an orc warlord comes to see you personally. | A stampede could hardly make more noise than you have this past week. If you keep it up with slaying greenskins left and right, it is but a matter of time until their warlord shows up. | You have a feeling that somewhere in this region is a very, very mad orc warlord staring at a crude drawing of your face. | You like to think you\'ve generated \'wanted\' posters of yourself within the greenskin circles. A stick figure of a man with a price beneath it. Wanted Dead or Very Dead. Problem is you\'ll keep killing all who come your way until the orc warlord himself makes an appearance - and you got the feeling that will be happening real soon. | Surely by now the greenskins are sharing stories of you around their campfires. Some damned human terrorizing their ranks. And you\'ve little doubt an orc warlord would hear those stories and feel compelled to see for himself if what they say are true... | Keep killing greenskins like this and their warlord will be sure to come around. | You\'re treading dangerous waters now. With this many greenskins slain, the orc warlord is sure to be coming sooner or later. | You\'ve got a strong inclination that the orc warlord is going to be coming around real soon. Might have something to do with you killing all his soldiers. Just a hunch. | You\'ve killed little greenskins and big greenskins. Now, it\'s time to kill the biggest of them all: a warlord. That savage has gotta be footing around here somewhere... | You\'ve made war on the greenskins and for that their warlord is sure to appear sooner or later. | Greenskins dying left and right. At some point their warlord is going to realize that it ain\'t because of natural causes. Once he figures it out, he\'ll be coming for you double time.}",
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
			Text = "[img]gfx/ui/events/event_81.png[/img]{You\'re hearing a lot of rumors from countryfolk that an orcish warlord is amassing his soldiers and heading your way. If these rumors are true, you should prepare as best you can. | Well, there\'s a lot of buzz about an orc warlord marching through the region. It just so happens to be heading your way - which makes you think your plan has worked! The %companyname% should prepare itself for one hell of a fight. | Word has it that the orc warlord is heading your way! Prepare the %companyname% as they are in for one hell of a fight! | Every peasant you pass seems to be carrying the same rumor: there\'s an orc warlord coming your way! This is most likely not a coincidence and the %companyname% should prepare itself accordingly. | Well, the news on the wind is that that the %companyname% is the target of an orc warlord marching with a small army. It appears your plan has worked. The company should prepare for the incredible battle coming its way! | It seems that every peasant you pass has a story to tell and they\'re all the same: an orc warlord has amassed a small army and just coincidentally happens to be heading your way. The %companyname% should prepare itself for a hell of a fight! | A little old lady comes rushing to you. She explains that everyone is talking about an orc warlord that is heading your way. You\'re not sure if it\'s true, but given your purpose these past days it is certainly far too coincidental. The %companyname% should prepare for battle. | Well, the %companyname% should prepare itself or a battle. Everybody you pass is telling you the same story: an orc warlord has amassed a small army and is heading your way! | It appears the killings have worked: news has it that an orc warlord and his army is heading your way to take care of the company personally. The %companyname% should prepare itself for a fight! | A small kid approaches you. He glances at the %companyname%\'s sigil and then at you. He smiles.%SPEECH_ON%I think y\'all need help.%SPEECH_OFF%That might be true, but it sounds strange coming from the kid. You ask him why and he responds.%SPEECH_ON%My father said a big mean orc is going to kill you all. He said traders have been talking about it allllllll day!%SPEECH_OFF%Hmmm, if true it means the strategy has paid off and the %companyname% should prepare for battle. You thank the kid. He shrugs.%SPEECH_ON%I just saved your life and all I get is a thanks? You people!%SPEECH_OFF%The kid spits and walks off kicking rocks.}",
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
			Text = "[img]gfx/ui/events/event_49.png[/img]{The warlord is at the head of a group of orcs and goblins. He stands tall among the already enormous warriors which surround him. You order your men to take battle lines and no sooner do the words leave your lips does the warlord roar and his warriors come running toward you! | A large formation of orcs and goblins stand before you, their warlord standing at the front. He steps forward and heaves a knapsack toward you. It unfurls midair and opens upon hitting the ground. A dozen heads roll forth like mere marbles from a kid\'s playbag. The warlord raises its weapon high and roars. As the greenskins come your way, you quickly order the %companyname% into formation. | The %companyname% stands before a massed array of greenskins: orcs, goblins, and their warlord, a beastly creature that seems ungainly even among the ranks of its own kind. The enormous warrior raises its weapon and roars, flying birds out of trees and sending critters scuttling into holes.\n\nAs the greenskins begin to charge, you shout to your men to fall into formation and remember who they are: the %companyname%! | You and the %companyname% finally come to stand before the warlord and its army of orcs and goblins. This seems the occasion or a speech, but before you can even say a word the brutish savages start charging! | Finally, the forces of man and beast square off. Across from the %companyname% are a small army of orcs and goblins, a brutish warlord standing at their head. You take out your sword and the warlord raises its weapon. If only for a moment, there is an understanding that it is warriors and only warriors who are going to die today. | The orc warlord and its army are charging! You tell the %companyname% that this is what they\'ve trained and prepared for.%SPEECH_ON%We wouldn\'t be here lest we wanted it!%SPEECH_OFF%The men roar and unsheathe their blades and fall into formation. | As a horde of goblins and orcs charge across the battlefield, an enormous warlord at their head, you tell the men to fear not.%SPEECH_ON%We will have much to celebrate tonight, men!%SPEECH_OFF%They unsheathe their weapons and roar, a deafening scream that echoes back upon the greenskins who look, for the first time, momentarily surprised. | %randombrother% comes to you, pointing out a small army of orcs and goblins charging your way, a warlord at their head.%SPEECH_ON%Not to point out the obvious, but the geenskins are here.%SPEECH_OFF%You nod and shout to your men.%SPEECH_ON%Who else is here?%SPEECH_OFF%The men draw out their weapons.%SPEECH_ON%The %companyname%!%SPEECH_OFF% | You and %randombrother% watch as an orc warlord charges your way, a small army of orcs and goblins behind it. The mercenary laughs.%SPEECH_ON%Well, here they come.%SPEECH_OFF%Nodding, you address the men.%SPEECH_ON%They charge because they are afraid. Because they have no ground to stand on. But we do, because we make our stand right here!%SPEECH_OFF%You plant a banner of the %companyname% into the ground. The sigil waves in the wind as the men roar to life. | You watch as the greenskins charge forward with their warlord leading the way. Drawing out your sword, you yell at the men.%SPEECH_ON%A good night\'s to any man who takes a savage\'s head. Who sleeps well tonight?%SPEECH_OFF%Metals rattle as the men draw their weapons and shout.%SPEECH_ON%The %companyname%!%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_81.png[/img]{The warlord is right where he should be: dead on the ground. You watch as the rest of the greenskins take for the hills. Your employer, %employer%, will be most pleased with the work the %companyname% has put in this day. | The %companyname% has triumphed this day! The orc warlord is dead in the mud and his army scattered to the hills. This is a result your employer, %employer%, will be most pleased with. | Your employer, %employer%, paid for the best and got just that: the orc warlord is dead and its roaming band of savages has fled. With no leader, there\'s little doubt the beasts will scatter and die off on their own. You should go back to the nobleman for your pay. | You have stamped out the greenskins, killing their warlord and sending them running for the hills. Your employer, %employer%, will be most pleased with the %companyname%. | The orc warlord is dead and with no head, the snake of the greenskin gang will shrivel and die. Your employer, %employer%, will be most pleased by this news. | The orc warlord is dead. It looks surprisingly at peace given the amount of terror and chaos it put on this earth. %randombrother% comes up, laughing.%SPEECH_ON%It\'s big, but it dies. I feel like people always forget that last part.%SPEECH_OFF%You nod and tell the men to prepare a return to %employer% at %townname%. | The warlord is dead at your feet, right where he should be. The %companyname% has earned its payday from %employer%. All that\'s left is to return to the nobleman and give him the news. | %employer% probably didn\'t believe in you. He probably didn\'t foresee this moment where you, a mercenary captain, stands over a dead orc warlord. But that\'s where you are this day, because the %companyname% is not to be trifled with. Time to go back to that nobleman and get your payday. | The orc warlord is dead and its army scattered. You take a look around and yell to your men.%SPEECH_ON%Men, my friend wants to kill his worst enemy, who should he call upon?%SPEECH_OFF%They raise their fists.%SPEECH_ON%The %companyname%!%SPEECH_OFF%You laugh and continue.%SPEECH_ON%An old woman wants us to kill all the rats in her attic, who should she call upon?%SPEECH_OFF%The men, quieter this time.%SPEECH_ON%The %companyname%?%SPEECH_OFF%You grin widely and continue.%SPEECH_ON%If a dainty man is scared of a spider on his wall, who should he call upon?%SPEECH_OFF%%randombrother% spits.%SPEECH_ON%Let\'s just get back to %townname% and %employer% already!%SPEECH_OFF% | You watch as the greenskins scatter like rats. %randombrother% looks ready to give chase, but you stop him.%SPEECH_ON%Let them run.%SPEECH_OFF%The mercenary shakes his head.%SPEECH_ON%But they\'ll speak of us! They know who we are.%SPEECH_OFF%You grin widely and clap the man on the shoulder.%SPEECH_ON%Exactly. C\'mon, let\'s head on back to %townname% and %employer%.%SPEECH_OFF% | You walk through the mounds of the dead, coming to stand before the slain orc warlord. The flies are already upon him. %randombrother% stands beside you, looking down at the beast.%SPEECH_ON%He wasn\'t so bad. I mean, okay, yeah he was pretty scary. A little on the gonna give me nightmares side of things, but all in all, not too bad.%SPEECH_OFF%You smile and clap the man on the shoulder.%SPEECH_ON%I hope one day you\'ll be able to scare you grandchildren with stories of it.%SPEECH_OFF% | The battlefield has settled. The dead are in the places they spent their whole lives getting to. The greenskins are out running for the hills. And the %companyname% is cheering in victory. %employer% will be most pleased with this series of events. | The %companyname% stands triumphant over the greenskin savages. You look down upon the orc warlord, taking into consideration that a lot of things had to die just so... it could die. A strange world with strange rules, but this is simply how it is.\n\n%employer% will be pleased and paying you a lot - and the world of the coin is the world you understand best. | You and %randombrother% look at the orc warlord\'s corpse. Flies are already busying themselves on its tongue, farking one another and spreading their plague. The mercenary looks at you and laughs.%SPEECH_ON%Is that the end you see for yourself, a bunch of insects doing the business on your goddam face?%SPEECH_OFF%You shrug and answer.%SPEECH_ON%It\'s a long ways away from dying while wrapped in a blanket and surrounded by family, that\'s for sure.%SPEECH_OFF%You slap the sellsword on the chest.%SPEECH_ON%C\'mon, enough of that talk. Let\'s get back to %employer% and get our pay.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_93.png[/img]While on the path, %randombrother% suddenly straightens up and tells everyone to get quiet. You crouch low and crabwalk to him. He points through some bushes.%SPEECH_ON%There. Trouble. Big, fat trouble.%SPEECH_OFF%You stare through the bushes to see a camp of orc berserkers. They\'ve got a small fire going with a spit of spinning meat. Nearby are a cluster of cages, each one holding a whining dog. You watch as one of the greenskins opens a cage and yanks a dog out. He drags it kicking and screaming toward the fire and holds it over the flames.\n\n The mercenary glances at you.%SPEECH_ON%What should we do, sir?%SPEECH_OFF%",
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
			Text = "[img]gfx/ui/events/event_93.png[/img]This isn\'t your fight nor would it ever be. You have the men swing around the encampment, quietly avoiding what could very easily be a devastating fight with a group of berserkers. The howls of dogs seem to chase you away and linger with a few of the men long after you\'ve left the place.",
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
			Text = "[img]gfx/ui/events/event_32.png[/img]The fight over, you take a good look around the berserkers\' encampment. Each of the cages is home to a shriveled, cornered dog. When you open one of the cages, the dog sprints out, yelping and yapping as it darts over the hills and is gone, just like that. Most of the other mutts follow suit. Two, however, remain. They follow you around as you inspect the rest of the encampment. %randombrother% notes that they\'re war dogs.%SPEECH_ON%Look at the size of \'em. Big, burly, nasty farks. Their owners must\'ve been killed by the orcs and now, well, they\'ve reason to trust us. Welcome to the company, little buddies.%SPEECH_OFF%",
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
			Text = "[img]gfx/ui/events/event_32.png[/img]With the last of the berserkers slain, you start in on their camp. You find the burnt bones of dogs strewn about the campfire. The meat has been picked clean and a collection of heads was teetering like some sickly cairn. %randombrother% goes about opening the cages. All the dogs, the very second they have a gap, sprint out and run away. The mercenary manages to snag one, but it yelps and goes limp, dying from sheer panic and fear. The rest of the camp has nothing of value aside from disappointment and piles of orc shite.",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{You find %employer% talking to his generals. He turns to you with a smile and arms open.%SPEECH_ON%Well, you did it, sellsword. I gotta admit, I didn\'t think you could. Funny business, killing orcs.%SPEECH_OFF%It wasn\'t especially funny, but you nod anyway. The nobleman goes and gets a satchel of %reward_completion% crowns and hands it to you personally.%SPEECH_ON%Job well done.%SPEECH_OFF% | %employer% is found in bed with a few women. His guard stands at the door, shrugging with a \'you said let him in\' look on his face. The nobleman waves at you.%SPEECH_ON%I\'m a bit busy, but I understand that you have been successful in all your... ehem, endeavors.%SPEECH_OFF%He snaps his fingers and one of the women slides out of the blankets. She daintily crosses the cold stone floor to pick up a satchel and carry it over to you. %employer% speaks again.%SPEECH_ON%%reward_completion% crowns, was it? I think that\'s some pretty pay for what you have done. I hear killing an orc warlord isn\'t exactly easy business.%SPEECH_OFF%The woman stares deep into your eyes as she hands the money over.%SPEECH_ON%You killed an orc warlord? That\'s so brave...%SPEECH_OFF%You nod and the lithe lady twists on her toes. The nobleman snaps his fingers again and she returns to his bed.%SPEECH_ON%Careful, mercenary.%SPEECH_OFF% | A guard takes you to a gardening %employer%. He snips at the vegetables and drops them into a basket held by a servant.%SPEECH_ON%Judging by your not being dead, my deductive skills tells me you were successful in killing the orc warlord.%SPEECH_OFF%You respond.%SPEECH_ON%It wasn\'t easy.%SPEECH_OFF%The nobleman nods, staring at the dirt, then continues clipping off a series of tomatoes.%SPEECH_ON%The guard standing yonder will have your pay. %reward_completion% crowns as we agreed upon. I\'m very busy right now, but you should know that I and the people of this town owe you a lot.%SPEECH_OFF%And by \'a lot\' he just means %reward_completion% crowns, apparently. | %employer% welcomes you into his room.%SPEECH_ON%My little birds have been chirping a lot these days, telling me stories of a sellsword that slew an orc warlord and scattered his army. And I thought to myself, hey, I think I know that guy.%SPEECH_OFF%The nobleman grins and hands over a satchel of %reward_completion% crowns.%SPEECH_ON%Good work, mercenary.%SPEECH_OFF% | %employer% greets you with a satchel of %reward_completion% crowns.%SPEECH_ON%My spies have already told me everything I need to know. You are the man to trust, sellsword.%SPEECH_OFF% | When you enter %employer%\'s room you find the nobleman listening to the whispers of one of his scribes. Seeing you, the man bolts upright.%SPEECH_ON%Speak of the devil and he will come. You are the talk of the town, sellsword. Killing an orc warlord and scattering its army? Well, I\'d say that\'s worth the %reward_completion% crowns we agreed upon.%SPEECH_OFF% | %employer% is staring dutifully at a map.%SPEECH_ON%I\'m gonna have to redraw some of this thank to you - and I mean that in the good way. Killing that orc warlord will allow us to rebuild from the ashes it had sown over these lands.%SPEECH_OFF%You nod, but subtly ask about the pay. The nobleman smiles.%SPEECH_ON%%reward_completion% crowns, was it? Also, you should at least take a moment to let the accolades come in, sellsword. The money isn\'t going nowhere, but the pride you feel now will one day fade.%SPEECH_OFF%You disagree. That money is going to fade its way into a pint of good mead. | %employer% is pacing his room while generals stand by the wayside in almost dutiful silence. You ask what the problem is and the man bolts upright.%SPEECH_ON%By the old gods on a fly\'s ass, I didn\'t think you\'d make it.%SPEECH_OFF%You ignore that soaring vote of confidence and inform the nobleman of all that you\'ve done. He nods repeatedly then takes out a satchel of %reward_completion% crowns and hands it over.%SPEECH_ON%That is a job well done, mercenary. Well damn done!%SPEECH_OFF% | You find %employer% watching a servant chop wood. Seeing your shadow, the nobleman wheels around.%SPEECH_ON%Ah, the man of the hour! I\'ve already heard so much of what you\'ve done. We\'re actually having a celebration - gotta prep the firewood for cooking and nighttime festivities. I\'d invite you, but this is for the highborn only, I\'m sure you understand.%SPEECH_OFF%You shrug and respond.%SPEECH_ON%I\'d understand a lot better if I had the %reward_completion% crowns we agreed upon.%SPEECH_OFF%%employer% laughs and snaps his fingers to a guard who promptly brings your pay over. | %employer% is found talking to the captain of another mercenary band. He\'s a frail leader, probably just getting his start. But upon seeing you, the nobleman quickly dismisses him and welcomes you.%SPEECH_ON%Ah hell, it is good seeing you, mercenary! Things were about to get a little desperate around here.%SPEECH_OFF%You remark that the captain you just saw would be most unfit to handle any job, much less that of hunting an orc warlord. The nobleman hands you a satchel of %reward_completion% crowns and responds.%SPEECH_ON%Look, let\'s just agree that you\'ve done good this day. We can finally start rebuilding what that damned orc savage destroyed and that\'s what matters.%SPEECH_OFF%The crowns in your hand are what matters, but you agree to no longer dawdle on the point.}",
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

