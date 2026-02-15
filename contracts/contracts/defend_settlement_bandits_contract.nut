this.defend_settlement_bandits_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Reward = 0,
		Kidnapper = null,
		Militia = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.defend_settlement_bandits";
		this.m.Name = "Obrona Osady";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 5.0;
		this.m.MakeAllSpawnsResetOrdersOnContractEnd = false;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 700 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Obroń osadę %townname% i jej obrzeża przed oddziałami najeźdźców"
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
				local nearestBandits = this.Contract.getNearestLocationTo(this.Contract.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getSettlements());
				local nearestZombies = this.Contract.getNearestLocationTo(this.Contract.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getSettlements());

				if (nearestZombies.getTile().getDistanceTo(this.Contract.m.Home.getTile()) <= 20 && nearestBandits.getTile().getDistanceTo(this.Contract.m.Home.getTile()) > 20)
				{
					this.Flags.set("IsUndead", true);
				}
				else
				{
					local r = this.Math.rand(1, 100);

					if (r <= 20)
					{
						this.Flags.set("IsKidnapping", true);
					}
					else if (r <= 40)
					{
						if (this.Contract.getDifficultyMult() >= 0.95)
						{
							this.Flags.set("IsMilitia", true);
						}
					}
					else if (r <= 50 || this.World.FactionManager.isUndeadScourge() && r <= 70)
					{
						if (nearestZombies.getTile().getDistanceTo(this.Contract.m.Home.getTile()) <= 20)
						{
							this.Flags.set("IsUndead", true);
						}
					}
				}

				local number = 1;

				if (this.Contract.getDifficultyMult() >= 0.95)
				{
					number = number + this.Math.rand(0, 1);
				}

				if (this.Contract.getDifficultyMult() >= 1.1)
				{
					number = number + 1;
				}

				local locations = this.Contract.m.Home.getAttachedLocations();
				local targets = [];

				foreach( l in locations )
				{
					if (l.isActive() && !l.isMilitary() && l.isUsable())
					{
						targets.push(l);
					}
				}

				number = this.Math.min(number, targets.len());
				this.Flags.set("ActiveLocations", targets.len());

				for( local i = 0; i != number; i = i )
				{
					local party;

					if (this.Flags.get("IsUndead"))
					{
						party = this.Contract.spawnEnemyPartyAtBase(this.Const.FactionType.Zombies, this.Math.rand(80, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					}
					else
					{
						party = this.Contract.spawnEnemyPartyAtBase(this.Const.FactionType.Bandits, this.Math.rand(80, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					}

					party.setAttackableByAI(false);
					local c = party.getController();
					c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
					c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
					local t = this.Math.rand(0, targets.len() - 1);

					if (i > 0)
					{
						local wait = this.new("scripts/ai/world/orders/wait_order");
						wait.setTime(4.0 * i);
						c.addOrder(wait);
					}

					local move = this.new("scripts/ai/world/orders/move_order");
					move.setDestination(targets[t].getTile());
					c.addOrder(move);
					local raid = this.new("scripts/ai/world/orders/raid_order");
					raid.setTime(40.0);
					raid.setTargetTile(targets[t].getTile());
					c.addOrder(raid);
					targets.remove(t);
					i = ++i;
				}

				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.World.FactionManager.getFaction(this.Contract.getFaction()).setActive(false);
			}

			function update()
			{
				if (this.Contract.m.UnitsSpawned.len() == 0 || this.Flags.get("IsEnemyHereDialogShown"))
				{
					local isEnemyGone = true;

					foreach( id in this.Contract.m.UnitsSpawned )
					{
						local p = this.World.getEntityByID(id);

						if (p != null && p.isAlive() && p.getDistanceTo(this.Contract.m.Home) <= 1200.0)
						{
							isEnemyGone = false;
							break;
						}
					}

					if (isEnemyGone)
					{
						if (this.Flags.get("HadCombat"))
						{
							this.Contract.setScreen("ItsOver");
							this.World.Contracts.showActiveContract();
						}

						this.Contract.setState("Return");
						return;
					}
				}

				if (!this.Flags.get("IsEnemyHereDialogShown"))
				{
					local isEnemyHere = false;

					foreach( id in this.Contract.m.UnitsSpawned )
					{
						local p = this.World.getEntityByID(id);

						if (p != null && p.isAlive() && p.getDistanceTo(this.Contract.m.Home) <= 700.0)
						{
							isEnemyHere = true;
							break;
						}
					}

					if (isEnemyHere)
					{
						this.Flags.set("IsEnemyHereDialogShown", true);

						foreach( id in this.Contract.m.UnitsSpawned )
						{
							local p = this.World.getEntityByID(id);

							if (p != null && p.isAlive())
							{
							}
						}

						if (this.Flags.get("IsUndead"))
						{
							this.Contract.setScreen("UndeadAttack");
						}
						else
						{
							this.Contract.setScreen("DefaultAttack");
						}

						this.World.Contracts.showActiveContract();
					}
				}
				else if (this.Flags.get("IsKidnapping") && !this.Flags.get("IsKidnappingInProgress") && this.Contract.m.UnitsSpawned.len() == 1)
				{
					local p = this.World.getEntityByID(this.Contract.m.UnitsSpawned[0]);

					if (p != null && p.isAlive() && !p.isHiddenToPlayer() && !p.getController().hasOrders())
					{
						local c = p.getController();
						c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(true);
						c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(true);
						this.Contract.m.Kidnapper = this.WeakTableRef(p);
						this.Flags.set("IsKidnappingInProgress", true);
						this.Flags.set("KidnappingTooLate", this.Time.getVirtualTimeF() + 60.0);
						this.Contract.setScreen("Kidnapping1");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Kidnapping");
					}
				}

				if (this.Flags.get("IsMilitia") && !this.Flags.get("IsMilitiaDialogShown"))
				{
					this.Flags.set("IsMilitiaDialogShown", true);
					this.Contract.setScreen("Militia1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("HadCombat", true);
			}

			function onCombatVictory( _combatID )
			{
				this.Flags.set("HadCombat", true);
			}

		});
		this.m.States.push({
			ID = "Kidnapping",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Ocal więźniów, którzy zostali porwani",
					"Wróć do " + this.Contract.m.Home.getName()
				];
				this.Contract.m.Home.getSprite("selection").Visible = false;
				this.World.FactionManager.getFaction(this.Contract.getFaction()).setActive(false);

				if (this.Contract.m.Kidnapper != null && !this.Contract.m.Kidnapper.isNull())
				{
					this.Contract.m.Kidnapper.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.m.Kidnapper == null || this.Contract.m.Kidnapper.isNull() || !this.Contract.m.Kidnapper.isAlive())
				{
					if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() <= 5.0)
					{
						this.Flags.set("IsKidnapping", false);
						this.Contract.setScreen("Kidnapping2");
					}
					else
					{
						this.Contract.setScreen("Kidnapping3");
					}

					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (this.Contract.m.Kidnapper.isHiddenToPlayer() && this.Time.getVirtualTimeF() > this.Flags.get("KidnappingTooLate"))
				{
					this.Contract.setScreen("Kidnapping3");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("HadCombat", true);
			}

			function onCombatVictory( _combatID )
			{
				this.Flags.set("HadCombat", true);
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
				this.World.FactionManager.getFaction(this.Contract.getFaction()).setActive(true);

				if (this.Contract.m.Kidnapper != null && !this.Contract.m.Kidnapper.isNull())
				{
					this.Contract.m.Kidnapper.getSprite("selection").Visible = false;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					local locations = this.Contract.m.Home.getAttachedLocations();
					local numLocations = 0;

					foreach( l in locations )
					{
						if (l.isActive() && !l.isMilitary() && l.isUsable())
						{
							numLocations = ++numLocations;
							numLocations = numLocations;
						}
					}

					if (numLocations == 0 || this.Flags.get("ActiveLocations") - numLocations >= 2)
					{
						if (this.Flags.get("IsKidnapping") && this.Flags.get("IsKidnappingInProgress"))
						{
							this.Contract.setScreen("Failure2");
						}
						else
						{
							this.Contract.setScreen("Failure1");
						}
					}
					else if (this.Flags.get("ActiveLocations") - numLocations >= 1)
					{
						if (this.Flags.get("IsKidnapping") && this.Flags.get("IsKidnappingInProgress"))
						{
							this.Contract.setScreen("Success4");
						}
						else
						{
							this.Contract.setScreen("Success2");
						}
					}
					else if (this.Flags.get("IsKidnapping") && this.Flags.get("IsKidnappingInProgress"))
					{
						this.Contract.setScreen("Success3");
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% wygląda przez okno. Macha, byś dołączył.%SPEECH_ON%Spójrz na tych ludzi.%SPEECH_OFF%Poniżej kłębi się tłum, zawodząc o tym czy tamtym.%SPEECH_ON%Bandyci krążą po tych stronach od jakiegoś czasu i ludzie wierzą, że wkrótce zaatakują nas wielką liczbą.%SPEECH_OFF%Mężczyzna zaciąga zasłony i zapala świecę. Mówi nad płomieniem, a oddech drga światłem.%SPEECH_ON%Potrzebujemy, byś nas chronił, najemniku. Jeśli powstrzymasz tych bandytów, zapłacimy hojnie. Jesteś zainteresowany?%SPEECH_OFF% | Kilku chłopów krąży po korytarzu na zewnątrz. Słyszysz ich krzyki - nerwowe i niepewne. %employer% nalewa trunek i upija łyk drżącą dłonią.%SPEECH_ON%Powiem wprost, najemniku. Mamy wiele, wiele doniesień, że bandyci szykują się do ataku na to miasto. Jeśli chcesz wiedzieć, te raporty dotarły do nas przez martwe kobiety i dzieci. Wyraźnie nie mamy powodu, by wątpić w ich powagę. Więc pytanie brzmi: czy nas ochronisz?%SPEECH_OFF% | %employer% przegląda papiery na biurku. Siadasz i pytasz, czego chce.%SPEECH_ON%Witaj, najemniku. Mamy problem, z którym, jak sądzę, poradzisz sobie... znakomicie.%SPEECH_OFF%Prosisz go, by przeszedł do sedna, a on robi to od razu.%SPEECH_ON%Bandyci spalili kilka domów i lepianki tuż za miastem. Wieści mówią, że szykują znacznie większy, gwałtowniejszy atak. Potrzebuję cię tutaj, by ich powstrzymać. Myślisz, że podołasz temu zadaniu?%SPEECH_OFF% | %employer% wpatruje się w regał z książkami, plecami do ciebie. Mówi ponuro.%SPEECH_ON%Szkoda, że tak niewielu potrafi to czytać. Może nasze problemy by zniknęły, gdyby potrafili. A może tylko by się nasiliły.%SPEECH_OFF%Kręci głową i odwraca się.%SPEECH_ON%Wkrótce zleci się na nas banda bandytów. Potrzebuję cię, najemniku, by ich powstrzymać. Moje książki na pewno tego nie zrobią. Jeśli zapłata jest odpowiednia, a obiecuję, że będzie, wchodzisz w to?%SPEECH_OFF% | %employer% trzyma dwa papiery. Na każdym naszkicowano twarz.%SPEECH_ON%Złapaliśmy tych dwóch ostatnio. Powiesiliśmy ich, spaliliśmy zwłoki.%SPEECH_OFF%Wzruszasz ramionami.%SPEECH_ON%Gratulacje?%SPEECH_OFF%Mężczyzna nie jest rozbawiony.%SPEECH_ON%Dotarła do nas wieść, że ich bandyccy kumple idą się na nas zemścić! I tak, potrzebujemy twojej pomocy, by ich odeprzeć. Jesteś zainteresowany?%SPEECH_OFF% | Rozsiadasz się w komnacie %employer%a, siadając i przesuwając dłonie po drewnianej ramie krzesła. Dobra dębina. Drzewo, na którym warto usiąść.%SPEECH_ON%Dobrze, że ci wygodnie, najemniku, bo mi, do diabła, nie. Mamy wiele, wiele ostrzeżeń, że duża grupa bandytów szykuje się do ataku na nasze miasto. Z obroną jesteśmy krótko, ale nie z koronami. Oczywiście tu wchodzisz ty. Jesteś zainteresowany?%SPEECH_OFF% | %employer% roztrzaskuje kubek o ścianę. Rozsypuje się, wirując, a krople wina pryskają ci na policzek.%SPEECH_ON%Włóczędzy! Bandyci! Maruderzy! To się nigdy nie kończy!%SPEECH_OFF%Bezmyślnie podaje ci serwetkę.%SPEECH_ON%Właśnie dostałem wieść, że duża grupa tych zbirów nadchodzi spalić to miasto do gołej ziemi! Cóż, mam dla nich coś w zanadrzu: ciebie. Co powiesz, najemniku? Czy nas obronisz?%SPEECH_OFF% | Tuż za komnatą %employer%a słychać zawodzące kobiety. Mężczyzna odwraca się do ciebie.%SPEECH_ON%Słyszysz? Tak się kończy, gdy przychodzą bandyci. Kradną, gwałcą i mordują.%SPEECH_OFF%Kiwasz głową. W końcu taka jest natura bandyty.%SPEECH_ON%Teraz chłopi z zaplecza mówią, że te łajdaki szykują się do wielkiego szturmu na naszą wioskę. Musisz coś zrobić, najemniku. Heh, mówię \'musisz\'. Tak naprawdę chodzi o to, że zapłacimy ci, byś nam pomógł...%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Ile %townname% jest gotowe zapłacić za swe bezpieczeństwo? | To powinno być dla ciebie warte sporo koron, prawda?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Obawiam się, że jesteście zdani na siebie. | Mamy ważniejsze sprawy do załatwienia. | Życzę wam powodzenia, ale nie weźmiemy w tym udziału.}",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 60)
						{
							this.World.Contracts.removeContract(this.Contract);
							return 0;
						}
						else
						{
							return "Plea";
						}
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Plea",
			Title = "Negocjacje",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Gdy opuszczasz %employer%a z odmową, na zewnątrz czeka tłum chłopów. Każdy trzyma jakąś osobliwość, taki majątek, jaki prostacy zdołali wyszarpać: kury, tanie naszyjniki, znoszone ubrania, zardzewiałe narzędzia kowalskie - lista dobytku ciągnie się bez końca. Jeden z nich wychodzi naprzód, z kurą pod każdą pachą.%SPEECH_ON%Proszę! Nie możecie odejść! Musicie nam pomóc!%SPEECH_OFF%%randombrother% się śmieje, ale musisz przyznać, że biedacy potrafią poruszyć serce. Może jednak zostać i pomóc? | Gdy wychodzisz od %employer%a, widzisz kobietę stojącą z gromadą dzieci biegających wokół jej nóg i niemowlęciem ssącym pierś.%SPEECH_ON%Najemniku, proszę, nie możesz nas tak zostawić! To miasto cię potrzebuje! Dzieci cię potrzebują!%SPEECH_OFF%Robi pauzę, po czym opuszcza drugą stronę koszuli, odsłaniając dość lubieżną i kuszącą zachętę.%SPEECH_ON%Potrzebuję cię...%SPEECH_OFF%Unosisz rękę, by ją powstrzymać i otrzeć nagle spoconą twarz. Może jednak pomaganie tym, eee, biednym ludziom nie byłoby takie złe? | Gdy szykujesz się do wyjścia z %townname%, podbiega do ciebie mały szczeniak, szczekając i liżąc ci buty. Jeszcze mniejsze dziecko goni go, niemal trzymając się jego ogona. Dzieciak przewraca się na psie i obejmuje jego potargane futro.%SPEECH_ON%Och {Marley | Yeller | Jo-Jo}, tak bardzo cię kocham!%SPEECH_OFF%W głowie przelatuje ci obraz bandytów mordujących dziecko i jego pupila. Masz lepsze rzeczy do roboty niż bawić się w szeryfa przeciw pospolitym złodziejom, ale pies dalej liże chłopcu twarz, a on wygląda na tak szczęśliwego.%SPEECH_ON%Haha! Będziemy żyć wiecznie i na zawsze, prawda? Wiecznie i na zawsze!%SPEECH_OFF%Cholera. | Gdy opuszczasz dom %employer%a, podchodzi do ciebie mężczyzna.%SPEECH_ON%Panie, słyszałem, że odrzuciłeś jego ofertę. Szkoda, tylko tyle chciałem powiedzieć. Myślałem, że na świecie jest wielu dobrych ludzi, ale chyba się myliłem. Szczęśliwej drogi i mam nadzieję, że pomodlisz się za nas podczas podróży.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = false,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Niech to, nie możemy zostawić tych ludzi na śmierć. | Dobrze, dobrze, nie opuścimy %townname%. Przynajmniej porozmawiajmy o zapłacie.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Jestem pewien, że jakoś sobie poradzicie. Z drogi. | Nie mam zamiaru ryzykować całej kompanii, by ocalić jakichś wygłodzonych wieśniaków.}",
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
			ID = "UndeadAttack",
			Title = "W pobliżu %townname%",
			Text = "[img]gfx/ui/events/event_29.png[/img]{Podczas warty podbiega do ciebie szalony chłop. Z rozdziawioną gębą, bez tchu, opiera dłonie o kolana i niemal wypluwa słowa:%SPEECH_ON%Umarli... oni nadchodzą!%SPEECH_OFF%Zerkając ponad nim, rzeczywiście widzisz w oddali kłębiący się tłum bladych postaci, które powłóczą nogami. | Żadnych bandytów, tylko nieumarli! Czekając na bandycką hołotę, widzisz zamiast nich nadciągającą gromadę szurających kreatur. To, że zmienia się cel, nie znaczy, że kontrakt znika - szykuj się! | W kaplicy miasteczka biją dzwony alarmowe. Słuchasz ich, wpatrując się w horyzont. Wciąż dzwonią. Miejscowy stoi obok ciebie.%SPEECH_ON%Jeden... dwa... trzy dzwony... cztery...%SPEECH_OFF%Zaczyna się pocić. Potem jego oczy rozszerzają się, gdy dzwon bije raz ostatni.%SPEECH_ON%To... to niemożliwe.%SPEECH_OFF%Pytasz, czego tak się boi. Odstępuje.%SPEECH_ON%Umarli znów chodzą po ziemi!%SPEECH_OFF%Świetnie, akurat gdy myślałeś, że kontrakt będzie łatwy. | Jęcząc i stękając, nieumarli wypełzają w pole widzenia. Nie ma bandytów - może te paskudne stwory ich zjadły - ale kontrakt nie jest nieważny: broń miasta!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "DefaultAttack",
			Title = "W pobliżu %townname%",
			Text = "[img]gfx/ui/events/event_07.png[/img]Bandyci są w zasięgu wzroku! Przygotować się do bitwy i bronić miasta!",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ItsOver",
			Title = "W pobliżu %townname%",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Walka dobiegła końca, a ludzie odpoczywają w upragnionym wytchnieniu. %employer% będzie czekał na ciebie w mieście. | Po bitwie oglądasz zwłoki rozsiane po polu. To makabryczny widok, a jednak z jakiegoś powodu daje ci energię. Upiorne pagórki trupów przypominają ci tylko o witalności, której jeszcze nie oddałeś temu okrutnemu światu. Ludzie tacy jak %employer% powinni to zobaczyć, ale on nie przyjdzie, więc to ty musisz pójść do niego. | Mięso i kości rozsiane po polu, ledwie da się odróżnić, do kogo należą. Czarne myszołowy krążą nad głowami, ich cienie układają się w zygzakowate halo nad zmarłymi, ptaki czekają, aż żałobnicy znikną. %randombrother% podchodzi i pyta, czy powinni ruszać z powrotem do %employer%a. Zostawiasz pole bitwy za sobą i kiwasz głową. | Martwi tworzą spokojny rodzaj ruiny. Jakby to był ich naturalny stan, zastygły i na wieki stracony, a całe ich życie było tylko chwilowym wybrykiem nieszczęścia, które właśnie dobiegło końca. %randombrother% podchodzi i pyta, czy wszystko w porządku. Szczerze mówiąc, nie wiesz, i tylko odpowiadasz, że czas iść do %employer%a. | Zniekształceni ludzie i pokrzywione trupy zaścielają ziemię, bo bitwa nie daje zmarłym prawa do godnego spoczynku. Odtarte głowy wyglądają na najbardziej spokojne, bo w walce nikt nie ma czasu naprawdę odrąbać szyi - to dzieje się tylko przy najszybszym i najostrzejszym cięciu. Część ciebie liczy na tak szybki finał, a część ma nadzieję, że zdążysz jeszcze zabrać ze sobą zabójcę.\n\n %randombrother% podchodzi i pyta o rozkazy. Odwracasz się od pola i każesz %companyname% przygotować powrót do %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wracamy do ratusza!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ItsOverDidNothing",
			Title = "W pobliżu %townname%",
			Text = "[img]gfx/ui/events/event_30.png[/img]Dym wypełnia powietrze, dym oraz gryzący zapach płonącego drewna, płonącego dobytku. Ludzie z %townname% powierzyli całe swoje nadzieje w najęciu kompanii %companyname%, fatalny błąd.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To nie poszło zgodnie z planem...",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Militia1",
			Title = "W %townname%",
			Text = "[img]gfx/ui/events/event_80.png[/img]{Podczas przygotowań do obrony %townname%, miejscowa milicja staje po twojej stronie. Podporządkowują się twoim rozkazom, prosząc jedynie, byś wysłał ich tam, gdzie uznasz, że są najbardziej potrzebni. | Wygląda na to, że miejscowa milicja dołącza do bitwy! Zbieranina ludzi, ale mimo wszystko się przydadzą. Teraz pytanie brzmi: gdzie ich posłać? | Milicja %townname% dołącza do walki! Choć to marna banda słabo uzbrojonych ludzi, są chętni bronić domu i lepianki. Podporządkowują się twojemu dowództwu, ufając, że wyślesz ich tam, gdzie są najbardziej potrzebni. | Nie jesteś w tej walce sam! Milicja %townname% dołącza do ciebie. Są chętni do walki i pytają, gdzie są najbardziej potrzebni.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Dołączcie do szeregu, będziecie pod moją komendą.",
					function getResult()
					{
						return "Militia2";
					}

				},
				{
					Text = "Ruszajcie bronić ratusza %townname%.",
					function getResult()
					{
						local home = this.Contract.m.Home;
						local party = this.World.FactionManager.getFaction(this.Contract.getFaction()).spawnEntity(home.getTile(), "Milicja z " + home.getName(), false, this.Const.World.Spawn.Militia, home.getResources() * 0.7, this.Contract.getMinibossModifier());
						party.getSprite("banner").setBrush(home.getBanner());
						party.setDescription("Odważni ludzie broniący swoich domów własnym życiem. Rolnicy, rzemieślnicy, czeladnicy - jednak ani jednego prawdziwego żołnierza.");
						party.setFootprintType(this.Const.World.FootprintsType.Militia);
						this.Contract.m.Militia = this.WeakTableRef(party);
						local c = party.getController();
						local guard = this.new("scripts/ai/world/orders/guard_order");
						guard.setTarget(home.getTile());
						guard.setTime(300.0);
						local despawn = this.new("scripts/ai/world/orders/despawn_order");
						c.addOrder(guard);
						c.addOrder(despawn);
						return 0;
					}

				},
				{
					Text = "Ruszajcie bronić obrzeży %townname%.",
					function getResult()
					{
						local home = this.Contract.m.Home;
						local party = this.World.FactionManager.getFaction(this.Contract.getFaction()).spawnEntity(home.getTile(), "Milicja z " + home.getName(), false, this.Const.World.Spawn.Militia, home.getResources() * 0.7, this.Contract.getMinibossModifier());
						party.getSprite("banner").setBrush(home.getBanner());
						party.setDescription("Odważni ludzie broniący swoich domów własnym życiem. Rolnicy, rzemieślnicy, czeladnicy - jednak ani jednego prawdziwego żołnierza.");
						party.setFootprintType(this.Const.World.FootprintsType.Militia);
						this.Contract.m.Militia = this.WeakTableRef(party);
						local c = party.getController();
						local locations = home.getAttachedLocations();
						local targets = [];

						foreach( l in locations )
						{
							if (l.isActive() && !l.isMilitary() && l.isUsable())
							{
								targets.push(l);
							}
						}

						local guard = this.new("scripts/ai/world/orders/guard_order");
						guard.setTarget(targets[this.Math.rand(0, targets.len() - 1)].getTile());
						guard.setTime(300.0);
						local despawn = this.new("scripts/ai/world/orders/despawn_order");
						c.addOrder(guard);
						c.addOrder(despawn);
						return 0;
					}

				},
				{
					Text = "Ukryjcie się gdzieś i nie wchodźcie nam w drogę.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Militia2",
			Title = "W %townname%",
			Text = "[img]gfx/ui/events/event_80.png[/img]Teraz, gdy już zdecydowałeś wziąć część milicji pod swoją komendę, jak powinni się oni uzbroić na nadchodzącą bitwę.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Weźcie łuki, będziecie ostrzeliwać wroga z tyłów.",
					function getResult()
					{
						for( local i = 0; i != 4; i = i )
						{
							local militia = this.World.getGuestRoster().create("scripts/entity/tactical/humans/militia_guest_ranged");
							militia.setFaction(1);
							militia.setPlaceInFormation(19 + i);
							militia.assignRandomEquipment();
							i = ++i;
						}

						return 0;
					}

				},
				{
					Text = "Weźcie miecze i tarcze, będziecie walczyć w pierwszym szeregu.",
					function getResult()
					{
						for( local i = 0; i != 4; i = i )
						{
							local militia = this.World.getGuestRoster().create("scripts/entity/tactical/humans/militia_guest");
							militia.setFaction(1);
							militia.setPlaceInFormation(19 + i);
							militia.assignRandomEquipment();
							i = ++i;
						}

						return 0;
					}

				},
				{
					Text = "Uzbrójcie się w co tam chcecie.",
					function getResult()
					{
						for( local i = 0; i != 4; i = i )
						{
							local militia;

							if (this.Math.rand(0, 1) == 0)
							{
								militia = this.World.getGuestRoster().create("scripts/entity/tactical/humans/militia_guest");
							}
							else
							{
								militia = this.World.getGuestRoster().create("scripts/entity/tactical/humans/militia_guest_ranged");
							}

							militia.setFaction(1);
							militia.setPlaceInFormation(19 + i);
							militia.assignRandomEquipment();
							i = ++i;
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "MilitiaVolunteer",
			Title = "W pobliżu %townname%",
			Text = "[img]gfx/ui/events/event_80.png[/img]{Gdy walka dobiega końca, jeden z milicjantów, który pomagał w obronie, podchodzi do ciebie osobiście, kłania się nisko i oferuje swój miecz.%SPEECH_ON%Panie, mój czas w %townname% dobiegł końca. Ale sprawność %companyname% to naprawdę niesamowity widok. Jeśli pan pozwoli, chciałbym walczyć u pana boku i u boku pana ludzi.%SPEECH_OFF% | Po bitwie jeden z milicjantów z %townname% oznajmia, że chętnie będzie walczył dla %companyname%. Częściowo dlatego, że był pod ogromnym wrażeniem walki kompanii, a częściowo dlatego, że przymusowa obrona miasta nie służy ani portfelowi, ani zdrowiu.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Witaj w kompanii!",
					function getResult()
					{
						return 0;
					}

				},
				{
					Text = "To nie miejsce dla ciebie.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Kidnapping1",
			Title = "W pobliżu %townname%",
			Text = "[img]gfx/ui/events/event_30.png[/img]{Podczas czuwania przed bandytami podchodzi chłop i mówi, że grupa zbirów napadła w pobliżu, uciekając z zakładnikami. Kręcisz głową z niedowierzaniem. Jak mogli się zakraść i to zrobić? Chłop też kręci głową.%SPEECH_ON%Myślałem, że macie nam pomóc. Czemu nic nie zrobiliście?%SPEECH_OFF%Pytasz, czy bandyci są daleko. Chłop kręci głową. Wygląda na to, że wciąż macie szansę ich dogonić. | Mężczyzna w łachmanach, z połamanymi widłami w ręku, pędzi do twojej kompanii. Pada i zawodzi u twoich stóp.%SPEECH_ON%Bandyci zaatakowali! Gdzie byliście? Zabili ludzi... spalili... i... i zabrali więźniów! Proszę, idźcie ich uratować!%SPEECH_OFF%Spoglądasz na %randombrother%a i kiwasz głową.%SPEECH_ON%Szykować ludzi. Musimy dogonić te łajdaki, zanim uciekną na dobre.%SPEECH_OFF% | Wypatrujesz na horyzoncie jakiegokolwiek znaku włóczęgi czy złodzieja. Nagle %randombrother% podchodzi z kobietą u boku. Opowiada, że zbiry już zaatakowały, zabijając wielu chłopów, a tych, których nie zabili, zabrali ze sobą. Najemnik kiwa głową.%SPEECH_ON%Wygląda na to, że prześlizgnęli się obok nas, panie.%SPEECH_OFF%Masz teraz tylko jeden wybór - iść i odzyskać tych ludzi! | Stacjonując blisko %townname%, wyczekujesz ataku bandytów. Myślałeś, że będzie łatwo, ale nagłe pojawienie się szalonego chłopa mówi inaczej. Tłumaczy, że maruderzy już napadli na obrzeża. Zabili, kogo mogli, a potem zabrali kilku mężczyzn, kobiet i dzieci. Mężczyzna, pijany lub w szoku, bełkocze błagania.%SPEECH_ON%Odzyskajcie... odzyskajcie ich, no...%SPEECH_OFF% | Podczas warty kilku wściekłych chłopów wbija się na drogę, pędząc ku tobie w wirze gniewu tłumu.%SPEECH_ON%Myślałem, że płacimy wam za ochronę! Gdzie byliście?!%SPEECH_OFF%Są pokryci krwią. Niektórzy półnadzy. U kobiety wystaje pierś, ale jest zbyt wściekła, by przejmować się wstydem. Pytasz, o czym mówią. Mężczyzna, ściskając laskę przy piersi, wyjaśnia, że najeźdźcy już zaatakowali, uderzając w pobliski przysiółek. Zasiekli wszystko, co się ruszało, a potem, nasyciwszy żądzę krwi, zabrali tylu więźniów, ilu zdołali.\n\nKiwasz głową.%SPEECH_ON%Odzyskamy ich.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ruszajmy po nich!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Kidnapping2",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Chowając miecz, każesz %randombrother%owi uwolnić więźniów. Cała gromada oszołomionych chłopów zostaje uwolniona ze skórzanych smyczy, łańcuchów i psich klatek. Dziękują ci za przybycie w porę i za przemoc, którą sprowadziłeś na bandytów. | Bandyci zostają wybici co do jednego. Wysyłasz ludzi, by ratowali każdego chłopa, jakiego znajdą. Każdy z nich przytula się i płacze, oszalały ze szczęścia, że przeżył tę straszliwą próbę. | Po zabiciu ostatniego bandyty każesz kompanii uwolnić zakładników, których włóczędzy zabrali. Każdy z nich podchodzi do ciebie po kolei, jedni całują dłoń, inni stopy. Mówisz im tylko, by wracali do %townname%, tak jak zrobisz to ty.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wygląda na to, że to koniec.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Kidnapping3",
			Title = "W pobliżu %townname%",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Niestety bandyci uciekli z zakładnikami. Niech bogowie będą teraz z tymi biednymi duszami. | Nie udało się - nie zdołałeś uratować tych biednych chłopów. Teraz tylko bogowie wiedzą, co ich czeka. | Niestety maruderzy uciekli z ludzkim ładunkiem na holu. Ci biedni ludzie będą musieli teraz radzić sobie sami. Jednak opowieści, które słyszysz, mówią, że nie spotka ich nic dobrego. | Bandyci uciekli, a wraz z nimi ich więźniowie. Nie masz pojęcia, co teraz spotka tych ludzi, ale wiesz, że nic dobrego. Niewola. Tortury. Śmierć. Nie wiesz, co gorsze.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{Ludziom z %townname% się to nie spodoba... | Być może da radę ich wykupić...}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{Wracasz do %employer%a z miną słusznie zadowoloną.%SPEECH_ON%Robota zrobiona.%SPEECH_OFF%Kiwa głową, przechylając kielich wina, choć niekoniecznie go oferuje.%SPEECH_ON%Tak. Miasto jest wiecznie wdzięczne za twoją pomoc. A także... wdzięczne finansowo.%SPEECH_OFF%Mężczyzna wskazuje róg pokoju. Widzisz tam sakiewkę koron.%SPEECH_ON%%reward% koron, tak jak się umawialiśmy. Dzięki jeszcze raz, najemniku.%SPEECH_OFF% | %employer% wita twój powrót kielichem wina.%SPEECH_ON%Pij, najemniku, zasłużyłeś.%SPEECH_OFF%Smakuje... osobliwie. Dumnie, jeśli to może być smak. Pracodawca okrąża biurko i siada z zadowoleniem.%SPEECH_ON%Udało ci się ochronić miasto, tak jak obiecałeś! Jestem pod wrażeniem.%SPEECH_OFF%Kiwa głową, wskazując kielichem drewnianą skrzynię.%SPEECH_ON%BARDZO pod wrażeniem.%SPEECH_OFF%Otwierasz skrzynię i widzisz stos złotych koron. | %employer% wita cię w swojej komnacie.%SPEECH_ON%Widziałem wszystko z okna, wiesz? No, prawie wszystko. Te dobre momenty, jak mniemam.%SPEECH_OFF%Unosisz brew.%SPEECH_ON%Och, nie rób takiej miny. Nie mam wyrzutów sumienia, że podobało mi się to, co widziałem. Żyjemy, prawda? My, ci dobrzy.%SPEECH_OFF%Druga brew idzie w górę.%SPEECH_ON%Cóż... w każdym razie, twoja zapłata, jak obiecałem.%SPEECH_OFF%Mężczyzna wręcza skrzynię z %reward% koronami. | Gdy wracasz do %employer%a, widzisz, że jego komnata jest niemal spakowana, wszystko gotowe do przeprowadzki. Z nutą żartu pytasz.%SPEECH_ON%Szykowanie do drogi?%SPEECH_OFF%Mężczyzna opada na krzesło.%SPEECH_ON%Miałem wątpliwości, najemniku. Możesz mi się dziwić? Tak czy inaczej, nie powinieneś wątpić w moją zdolność do płacenia.%SPEECH_OFF%Przesuwa dłonią po biurku. Na rogu leży sakiewka, pękata od monet.%SPEECH_ON%%reward% koron, jak obiecałem.%SPEECH_OFF% | %employer% wstaje z krzesła, gdy wchodzisz. Kłania się nieco z niedowierzaniem, ale szczerze. Wskazuje głową na okno, skąd dobiega szmer zadowolonych chłopów.%SPEECH_ON%Słyszysz to? Zasłużyłeś na to, najemniku. Ludzie cię tu kochają.%SPEECH_OFF%Kiwasz głową, ale miłość pospólstwa nie jest tym, po co tu przyszedłeś.%SPEECH_ON%Co jeszcze zarobiłem?%SPEECH_OFF%%employer% uśmiecha się.%SPEECH_ON%Człowiek rzeczowy. Założę się, że to właśnie nadaje ci... ostrość. Oczywiście, zarobiłeś też to.%SPEECH_OFF%Wnosi drewnianą skrzynię na biurko i ją otwiera. Blask złotych koron ogrzewa serce. | %employer% wpatruje się w okno, gdy wchodzisz. Jest niemal jak w śnie, głowa oparta o dłoń. Przerywasz jego myśli.%SPEECH_ON%Myślisz o mnie?%SPEECH_OFF%Mężczyzna chichocze i żartobliwie chwyta się za pierś.%SPEECH_ON%Jesteś prawdziwym mężczyzną moich snów, najemniku.%SPEECH_OFF%Przechodzi przez pokój i bierze skrzynię z półki. Otwiera ją, kładąc na stole. Wspaniały stos złotych koron patrzy ci w twarz. %employer% się szczerzy.%SPEECH_ON%No i kto teraz śni?%SPEECH_OFF% | %employer% siedzi przy biurku, gdy wchodzisz.%SPEECH_ON%Widziałem sporo. Zabijanie, umieranie.%SPEECH_OFF%Siadasz.%SPEECH_ON%Mam nadzieję, że podobał ci się pokaz. Oglądanie nie jest jednak darmowe.%SPEECH_OFF%Mężczyzna kiwa głową, bierze sakiewkę i podaje ją tobie.%SPEECH_ON%Zapłaciłbym za bis, ale nie jestem pewien, czy %townname% tego chce.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Kompania %companyname% zrobi z tego dobry użytek. | Zapłata za ciężką robotę.}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Obroniłeś osadę przed bandytami");
						this.World.Contracts.finishActiveContract();

						if (this.Flags.get("IsUndead") && this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
						}

						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_30.png[/img]{%employer% wita twój powrót, wskazując za okno.%SPEECH_ON%Widzisz to? Tam, w oddali.%SPEECH_OFF%Stajesz obok niego. Pyta.%SPEECH_ON%Co widzisz?%SPEECH_OFF%Na horyzoncie unosi się dym. Mówisz mu, że to widzisz.%SPEECH_ON%Właśnie, dym. Nie wynająłem cię po to, by bandyci robili dym, rozumiesz? Oczywiście... większość miasta wciąż stoi...%SPEECH_OFF%Wrzuca ci w pierś sakiewkę.%SPEECH_ON%Dobra robota, najemniku. Po prostu... nie dość dobra.%SPEECH_OFF% | Wracasz do %employer%a, wygląda na mieszankę zadowolenia i smutku, gdzieś między trzeźwym a pijanym. To nie jest spojrzenie, które chcesz zobaczyć.%SPEECH_ON%Dobra robota, najemniku. Mówią, że rozsmarowałeś bandytów na amen. Mówią też, że spalili część naszych obrzeży.%SPEECH_OFF%Kiwasz głową. Nie warto kłamać, skoro nie da się tego ukryć.%SPEECH_ON%Zapłata będzie, ale musisz zrozumieć, że odbudowa kosztuje. Oczywiście korony na to pójdą z twojej kieszeni...%SPEECH_OFF% | %employer% jest zapadnięty w fotelu, gdy wracasz.%SPEECH_ON%Większość w %townname% jest zadowolona, ale kilka osób nie. Zgadniesz, które?%SPEECH_OFF%Bandyci zdołali zniszczyć kilka części obrzeży, ale to pytanie retoryczne.%SPEECH_ON%Potrzebuję środków, by odbudować tereny, do których dorwali się maruderzy. Rozumiesz więc, czemu zapłata będzie mniejsza...%SPEECH_OFF%Wzruszasz ramionami. Tak bywa. | %employer% stoi przy regale. Bierze książkę, obraca się i otwiera ją jednym ruchem. Kładzie ją na stole.%SPEECH_ON%Są tam liczby. Jestem pewien, że nie umiesz ich czytać, ale oto co znaczą: bandyci zniszczyli część tego miasta i teraz potrzebuję koron na odbudowę. Niestety nie mam ich aż tyle pod ręką. Jestem pewien, że rozumiesz tę sytuację.%SPEECH_OFF%Kiwasz głową i mówisz oczywiste.%SPEECH_ON%To idzie z mojej zapłaty.%SPEECH_OFF%Mężczyzna kiwa głową i przesuwa otwartą dłonią po biurku, zwracając twoją uwagę na sakiewkę. Nie ma sensu spierać się o zapłatę. Bierzesz sakiewkę i wychodzisz.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{To tylko połowa tego, na co się umawialiśmy! | Jest, jak jest...}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor, "Obroniłeś osadę przed bandytami");
						this.World.Contracts.finishActiveContract();

						if (this.Flags.get("IsUndead") && this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
						}

						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() / 2;
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] koron"
				});
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success3",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Wracasz do %employer%a z miną słusznie zadowoloną.%SPEECH_ON%Robota zrobiona.%SPEECH_OFF%Kiwa głową, przechylając kielich wina, choć niekoniecznie go oferuje.%SPEECH_ON%Tak. Miasto jest wiecznie wdzięczne za twoją pomoc. A także... wdzięczne finansowo.%SPEECH_OFF%Mężczyzna wskazuje róg pokoju. Widzisz tam sakiewkę koron.%SPEECH_ON%%reward% koron, tak jak się umawialiśmy. Dzięki jeszcze raz, najemniku. Ach, i szkoda tych chłopów...%SPEECH_OFF% | %employer% wita twój powrót kielichem wina.%SPEECH_ON%Pij, najemniku, zasłużyłeś.%SPEECH_OFF%Smakuje... osobliwie. Dumnie, jeśli to może być smak. Pracodawca okrąża biurko i siada z zadowoleniem.%SPEECH_ON%Udało ci się ochronić miasto, tak jak obiecałeś! Jestem pod wrażeniem.%SPEECH_OFF%Kiwa głową, wskazując kielichem drewnianą skrzynię.%SPEECH_ON%BARDZO pod wrażeniem.%SPEECH_OFF%Otwierasz skrzynię i widzisz stos złotych koron.%SPEECH_ON%Szkoda tych chłopów, których zabrano. Wprowadziłem odpowiednie korekty...%SPEECH_OFF% | %employer% wita cię w swojej komnacie.%SPEECH_ON%Widziałem wszystko z okna, wiesz? No, prawie wszystko. Te dobre momenty, jak mniemam.%SPEECH_OFF%Unosisz brew.%SPEECH_ON%Och, nie rób takiej miny. Nie mam wyrzutów sumienia, że podobało mi się to, co widziałem. Żyjemy, prawda? My, ci dobrzy.%SPEECH_OFF%Druga brew idzie w górę.%SPEECH_ON%Cóż... w każdym razie, twoja zapłata, jak obiecałem. Słyszałem, że zabrano kilku chłopów. Zrobiłem pewne potrącenia. Te pieniądze trafią do ocalałych.%SPEECH_OFF%Mężczyzna wręcza skrzynię z %reward% koronami. | Gdy wracasz do %employer%a, widzisz, że jego komnata jest niemal spakowana, wszystko gotowe do przeprowadzki. Z nutą żartu pytasz.%SPEECH_ON%Szykowanie do drogi?%SPEECH_OFF%Mężczyzna opada na krzesło.%SPEECH_ON%Miałem wątpliwości, najemniku. Możesz mi się dziwić? Tak czy inaczej, nie powinieneś wątpić w moją zdolność do płacenia.%SPEECH_OFF%Przesuwa dłonią po biurku. Na rogu leży sakiewka, pękata od monet.%SPEECH_ON%O kilka koron mniej niż obiecałem. Wiesz, co się stanie z chłopami, których bandyci zabrali? Tak, obniżyłem twoją zapłatę nie bez powodu.%SPEECH_OFF% | %employer% wstaje z krzesła, gdy wchodzisz. Kłania się nieco z niedowierzaniem, ale szczerze. Wskazuje głową na okno, skąd dobiega szmer zadowolonych chłopów.%SPEECH_ON%Słyszysz to? Zasłużyłeś na to, najemniku. Ludzie cię tu kochają.%SPEECH_OFF%Kiwasz głową, ale miłość pospólstwa nie jest tym, po co tu przyszedłeś.%SPEECH_ON%Co jeszcze zarobiłem?%SPEECH_OFF%%employer% uśmiecha się.%SPEECH_ON%Człowiek rzeczowy. Założę się, że to właśnie nadaje ci... ostrość. Oczywiście, zarobiłeś też to. Cóż, trochę mniej. Brudna sprawa z tymi chłopami, których pozwoliłeś bandytom zabrać, prawda?%SPEECH_OFF%Wnosi drewnianą skrzynię na biurko i ją otwiera. Blask złotych koron ogrzewa serce. | %employer% wpatruje się w okno, gdy wchodzisz. Jest niemal jak w śnie, głowa oparta o dłoń. Przerywasz jego myśli.%SPEECH_ON%Myślisz o mnie?%SPEECH_OFF%Mężczyzna chichocze i żartobliwie chwyta się za pierś.%SPEECH_ON%Jesteś prawdziwym mężczyzną moich snów, najemniku.%SPEECH_OFF%Przechodzi przez pokój i bierze skrzynię z półki. Otwiera ją, kładąc na stole. Wspaniały stos złotych koron patrzy ci w twarz. %employer% uśmiecha się, ale uśmiech gaśnie tak szybko, jak się pojawił.%SPEECH_ON%Trochę lżej, niż się spodziewałeś? Rodziny ocalałych chłopów, których pozwoliłeś zabrać bandytom, dostaną swoją część. Jestem pewien, że rozumiesz.%SPEECH_OFF% | %employer% siedzi przy biurku, gdy wchodzisz.%SPEECH_ON%Widziałem sporo. Zabijanie, umieranie.%SPEECH_OFF%Siadasz.%SPEECH_ON%Mam nadzieję, że podobał ci się pokaz. Oglądanie nie jest jednak darmowe.%SPEECH_OFF%Mężczyzna kiwa głową, bierze sakiewkę i podaje ją tobie.%SPEECH_ON%Zapłaciłbym za bis, ale nie jestem pewien, czy %townname% tego chce. Oczywiście ci biedni ludzie, których zabrali ci najeźdźcy, nie chcą tego, co dostali.%SPEECH_OFF%Zerkasz do worka i zauważasz, że jest o kilka koron lżejszy, niż się spodziewałeś.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{To tylko połowa tego, na co się umawialiśmy! | Jest, jak jest...}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor, "Obroniłeś osadę przed bandytami");
						this.World.Contracts.finishActiveContract();

						if (this.Flags.get("IsUndead") && this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
						}

						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() / 2;
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] koron"
				});
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success4",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_30.png[/img]{%employer% wita twój powrót, wskazując za okno.%SPEECH_ON%Widzisz to? Tam, w oddali.%SPEECH_OFF%Stajesz obok niego. Pyta.%SPEECH_ON%Co widzisz?%SPEECH_OFF%Na horyzoncie unosi się dym. Mówisz mu, że to widzisz.%SPEECH_OFF%Właśnie, dym. Nie wynająłem cię po to, by bandyci robili dym, rozumiesz? Oczywiście... większość miasta wciąż stoi...%SPEECH_OFF%Wrzuca ci w pierś sakiewkę.%SPEECH_ON%Dobra robota, najemniku. Po prostu... nie dość dobra. I szkoda tych biednych chłopów, których pozwoliłeś zabrać tym przeklętym bandytom.%SPEECH_OFF% | Wracasz do %employer%a, wygląda na mieszankę zadowolenia i smutku, gdzieś między trzeźwym a pijanym. To nie jest spojrzenie, które chcesz zobaczyć.%SPEECH_ON%Dobra robota, najemniku. Mówią, że rozsmarowałeś bandytów na amen. Mówią też, że spalili część naszych obrzeży.%SPEECH_OFF%Kiwasz głową. Nie warto kłamać, skoro nie da się tego ukryć.%SPEECH_ON%Zapłata będzie, ale musisz zrozumieć, że odbudowa kosztuje. A co z tymi biednymi ludźmi, których pozwoliłeś najeźdźcom porwać? Ich rodziny też będą potrzebowały pomocy. Oczywiście korony na to pójdą z twojej kieszeni...%SPEECH_OFF% | %employer% jest zapadnięty w fotelu, gdy wracasz.%SPEECH_ON%Większość w %townname% jest zadowolona, ale kilka osób nie. Zgadniesz, które?%SPEECH_OFF%Bandyci zdołali zniszczyć kilka części obrzeży, ale to pytanie retoryczne.%SPEECH_ON%Potrzebuję środków, by odbudować tereny, do których dorwali się maruderzy. Potrzebuję też koron, by pomóc ocalałym rodzinom tych chłopów, których nie zdołałeś uratować. Rozumiesz więc, czemu zapłata będzie mniejsza...%SPEECH_OFF%Wzruszasz ramionami. Tak bywa. | %employer% stoi przy regale. Bierze książkę, obraca się i otwiera ją jednym ruchem. Kładzie ją na stole.%SPEECH_ON%Są tam liczby. Jestem pewien, że nie umiesz ich czytać, ale oto co znaczą: bandyci zniszczyli część tego miasta i teraz potrzebuję koron na odbudowę. Niestety nie mam ich aż tyle pod ręką. Jestem pewien, że rozumiesz tę sytuację.%SPEECH_OFF%Kiwasz głową i mówisz oczywiste.%SPEECH_ON%To idzie z mojej zapłaty. A ci chłopi, których pozwoliłeś bandytom zabrać? Mają rodziny. Ocalałych. Oni też dostaną część naszej \'umowy\'.%SPEECH_OFF%Mężczyzna kiwa głową i przesuwa otwartą dłonią po biurku, zwracając twoją uwagę na sakiewkę. Nie ma sensu spierać się o zapłatę. Bierzesz sakiewkę i wychodzisz.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{To tylko połowa tego, na co się umawialiśmy! | Jest, jak jest...}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(0);
						this.World.Contracts.finishActiveContract();

						if (this.Flags.get("IsUndead") && this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
						}

						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() / 2;
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] koron"
				});
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_30.png[/img]{Gdy wchodzisz do komnaty %employer%a, każe ci zamknąć drzwi. Ledwo zapadka kliknie, mężczyzna zasypuje cię strumieniem obelg, których nie sposób spamiętać. Gdy się uspokaja, jego głos - i język - wracają do względnej normalności.%SPEECH_ON%Wszystkie nasze obrzeża zostały zniszczone. Za co, dokładnie, myślałeś, że ci płacę? Wynoś się stąd.%SPEECH_OFF% | %employer% opróżnia kielichy wina, gdy wchodzisz. Za oknem słychać gwar wściekłych chłopów.%SPEECH_ON%Słyszysz? Urwą mi głowę, jeśli ci zapłacę, najemniku. Miałeś jedno zadanie, jedno! Chronić to miasto. A nie potrafiłeś. Więc teraz możesz zrobić jedną rzecz i jest za darmo: wynoś się mi z oczu.%SPEECH_OFF% | %employer% splata dłonie na biurku.%SPEECH_ON%Czego, dokładnie, spodziewasz się tutaj dostać? Dziwię się, że w ogóle wróciłeś. Połowa miasta płonie, a druga to już popiół. Nie wynająłem cię po to, byś robił dym i spustoszenie, najemniku. Wynoś się stąd.%SPEECH_OFF% | Kiedy wracasz do %employer%a, trzyma kufel piwa. Drży mu ręka. Twarz ma czerwoną.%SPEECH_ON%Kosztuje mnie wszystko, by nie rzucić tym w twoją twarz.%SPEECH_OFF%Na wszelki wypadek kończy piwo jednym haustem. Uderza kuflem o biurko.%SPEECH_ON%To miasto oczekiwało, że je obronisz. Tymczasem bandyci zalali obrzeża jakby urządzali cholerną wycieczkę! Nie jestem od sprawiania maruderom miłego dnia, najemniku. Wynoś się, do cholery!%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Zaraza z tymi wieśniakami! | Powinniśmy byli zażądać więcej pieniędzy z góry... | A niech to!}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Nie zdołałeś obronić osady przed bandytami");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_30.png[/img]{Gdy wchodzisz do komnaty %employer%a, każe ci zamknąć drzwi. Ledwo zapadka kliknie, mężczyzna zasypuje cię strumieniem obelg, których nie sposób spamiętać. Gdy się uspokaja, jego głos - i język - wracają do względnej normalności.%SPEECH_ON%Wszystkie nasze obrzeża zostały zniszczone. Ludzi porwano, bogowie wiedzą dokąd! Za co, dokładnie, myślałeś, że ci płacę? Wynoś się stąd.%SPEECH_OFF% | %employer% opróżnia kielichy wina, gdy wchodzisz. Za oknem słychać gwar wściekłych chłopów.%SPEECH_ON%Słyszysz? Urwą mi głowę, jeśli ci zapłacę, najemniku. Miałeś jedno zadanie, jedno! Chronić to miasto. A nie potrafiłeś. Do diabła, nie zdołałeś nawet uratować tych biednych chłopów, których porwano! Więc teraz możesz zrobić jedną rzecz i jest za darmo: wynoś się mi z oczu.%SPEECH_OFF% | %employer% splata dłonie na biurku.%SPEECH_ON%Czego, dokładnie, spodziewasz się tutaj dostać? Dziwię się, że w ogóle wróciłeś. Połowa miasta płonie, a druga to już popiół. Ocaleni mówią, że ich bliskich porwano! Wiesz, co spotyka tych, których zabierają najeźdźcy? Nie wynająłem cię po to, byś robił dym i spustoszenie, najemniku. Wynoś się stąd.%SPEECH_OFF% | Kiedy wracasz do %employer%a, trzyma kufel piwa. Drży mu ręka. Twarz ma czerwoną.%SPEECH_ON%Kosztuje mnie wszystko, by nie rzucić tym w twoją twarz.%SPEECH_OFF%Na wypadek, gdyby wściekłość wzięła górę, mężczyzna kończy piwo jednym haustem. Uderza kuflem o biurko.%SPEECH_ON%To miasto oczekiwało, że je obronisz. Tymczasem bandyci zalali obrzeża jakby urządzali cholerną wycieczkę! Nie jestem od sprawiania maruderom miłego dnia, najemniku. Wynoś się, do cholery!%SPEECH_OFF% | %employer% śmieje się, gdy wchodzisz do jego komnaty.%SPEECH_ON%Obrzeża są zniszczone. Ludzie z %townname% są wściekli, przynajmniej ci, którzy żyją na tyle, by się złościć. I co gorsza? Pozwoliłeś, by kilku naszych mieszkańców zostało zabranych przez te potwory!%SPEECH_OFF%Mężczyzna kręci głową i wskazuje drzwi.%SPEECH_ON%Nie wiem, za co spodziewałeś się zapłaty, ale nie za to.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Zaraza z tymi wieśniakami! | Powinniśmy byli zażądać więcej pieniędzy z góry... | A niech to!}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Nie zdołałeś obronić osady przed bandytami");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"reward",
			this.m.Reward
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			local s = this.new("scripts/entity/world/settlements/situations/raided_situation");
			s.setValidForDays(4);
			this.m.SituationID = this.m.Home.addSituation(s);
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.World.FactionManager.getFaction(this.getFaction()).setActive(true);
			this.m.Home.getSprite("selection").Visible = false;

			if (this.m.Kidnapper != null && !this.m.Kidnapper.isNull())
			{
				this.m.Kidnapper.getSprite("selection").Visible = false;
			}

			if (this.m.Militia != null && !this.m.Militia.isNull())
			{
				this.m.Militia.getController().clearOrders();
			}

			this.World.getGuestRoster().clear();
		}
	}

	function onIsValid()
	{
		local nearestBandits = this.getNearestLocationTo(this.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getSettlements());
		local nearestZombies = this.getNearestLocationTo(this.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getSettlements());

		if (nearestZombies.getTile().getDistanceTo(this.m.Home.getTile()) > 20 && nearestBandits.getTile().getDistanceTo(this.m.Home.getTile()) > 20)
		{
			return false;
		}

		local locations = this.m.Home.getAttachedLocations();

		foreach( l in locations )
		{
			if (l.isUsable() && l.isActive() && !l.isMilitary())
			{
				return true;
			}
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.m.Flags.set("KidnapperID", this.m.Kidnapper != null && !this.m.Kidnapper.isNull() ? this.m.Kidnapper.getID() : 0);
		this.m.Flags.set("MilitiaID", this.m.Militia != null && !this.m.Militia.isNull() ? this.m.Militia.getID() : 0);
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.contract.onDeserialize(_in);
		this.m.Kidnapper = this.WeakTableRef(this.World.getEntityByID(this.m.Flags.get("KidnapperID")));
		this.m.Militia = this.WeakTableRef(this.World.getEntityByID(this.m.Flags.get("MilitiaID")));
	}

});

