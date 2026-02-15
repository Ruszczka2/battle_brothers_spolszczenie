this.destroy_orc_camp_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		Reward = 0
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.destroy_orc_camp";
		this.m.Name = "Zniszczenie Obozu Orków";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		local camp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(this.m.Origin.getTile());
		this.m.Destination = this.WeakTableRef(camp);
		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		this.m.Payment.Pool = 900 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 3);

		if (r == 1)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else if (r == 2)
		{
			this.m.Payment.Completion = 1.0;
		}
		else if (r == 3)
		{
			this.m.Payment.Completion = 0.5;
			this.m.Payment.Count = 0.5;
		}

		local maximumHeads = [
			20,
			25,
			30
		];
		this.m.Payment.MaxCount = maximumHeads[this.Math.rand(0, maximumHeads.len() - 1)];
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

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.OrcRaiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(115 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				this.Flags.set("HeadsCollected", 0);

				if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().get("Betrayed") && this.Math.rand(1, 100) <= 75)
				{
					this.Flags.set("IsBetrayal", true);
				}
				else
				{
					local r = this.Math.rand(1, 100);

					if (r <= 5)
					{
						this.Flags.set("IsSurvivor", true);
					}
					else if (r <= 15 && this.World.Assets.getBusinessReputation() > 800)
					{
						if (this.Contract.getDifficultyMult() >= 0.95)
						{
							this.Flags.set("IsOrcsAgainstOrcs", true);
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
					if (this.Flags.get("IsSurvivor") && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
					{
						this.Contract.setScreen("Volunteer1");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Return");
					}
					else if (this.Flags.get("IsBetrayal"))
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
				if (this.Flags.get("IsOrcsAgainstOrcs"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("OrcsAgainstOrcs");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "OrcAttack";
						p.Music = this.Const.Music.OrcsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						p.IsAutoAssigningBases = false;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.OrcRaiders, 150 * this.Contract.getScaledDifficultyMult(), this.Const.Faction.Enemy);
						this.World.Contracts.startScriptedCombat(p, false, true, true);
					}
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "OrcAttack";
					p.Music = this.Const.Music.OrcsTracks;
					this.World.Contracts.startScriptedCombat(p, true, true, true);
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

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_combatID == "OrcAttack" || this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull() && this.World.State.getPlayer().getTile().getDistanceTo(this.Contract.m.Destination.getTile()) <= 1)
				{
					if (_actor.getFaction() == this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getID())
					{
						this.Flags.set("HeadsCollected", this.Flags.get("HeadsCollected") + 1);
					}
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
		this.importScreens(this.Const.Contracts.NegotiationPerHead);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "Negocjacje",
			Text = "[img]gfx/ui/events/event_61.png[/img]{%employer% dyszy i sapie.%SPEECH_ON%Do diabła.%SPEECH_OFF%Podchodzi do okna i wygląda na zewnątrz.%SPEECH_ON%Niedawno urządziłem turniej kopijniczy i wybuchła mała afera. Teraz żaden z moich rycerzy nie będzie dla mnie walczył, dopóki to się nie wyjaśni.%SPEECH_OFF%Pytasz, czy chce, by najemnicy rozstrzygali spór wśród szlachty. Mężczyzna wybucha śmiechem.%SPEECH_ON%Na bogów nie, nisko urodzony. Potrzebuję, żebyś zajął się zielonoskórymi obozującymi na %direction% od %origin%. Od jakiegoś czasu terroryzują okolicę i chciałbym im się odwdzięczyć. Brzmi jak coś, co cię interesuje, czy mam iść rozmawiać z innym mieczem do wynajęcia?%SPEECH_OFF% | %employer% opiera stopy na stole.%SPEECH_ON%Masz jakieś zdanie o zielonoskórych, najemniku?%SPEECH_OFF%Kręcisz głową. Mężczyzna przechyla ją na bok.%SPEECH_ON%Interesujące. Większość mówi, że się boją, albo że to paskudne brutale, co potrafią rozłupać człowieka na pół. A ty... ty jesteś inny. Podoba mi się. Co powiesz, by iść na %direction% od %origin% do miejsca, które miejscowi nazwali %location%? Widziano tam dużą bandę orków, którą trzeba rozproszyć.%SPEECH_OFF% | Na stole %employer%a siedzi kot. Głaszcze go, zwierzak przywiera do drapania, ale nagle syczy, gryzie mężczyznę i wybiega przez drzwi, którymi wszedłeś. %employer% otrzepuje się.%SPEECH_ON%Cholerne zwierzęta. Jednej chwili cię kochają, następnej... cóż...%SPEECH_OFF%Ssie kroplę krwi z kciuka. Pytasz, czy masz wrócić, żeby mógł dojść do siebie.%SPEECH_ON%Bardzo śmieszne, najemniku. Nie, chcę, żebyś poszedł na %direction% od %origin% i zajął się grupą zielonoskórych, która tu urzęduje. Potrzebujemy, by zostali zniszczeni, rozproszeni, jak tam chcesz, byleby zniknęli. Brzmi jak coś, co mógłbyś dla nas zrobić?%SPEECH_OFF% | %employer% zwija zwój, wyjaśniając swój kłopot.%SPEECH_ON%Spór wśród szlachty sprawił, że brakuje mi dobrych, walczących ludzi. Niestety, banda zielonoskórych wybrała ten dokładny moment, by pojawić się w okolicy. Obozują na %direction% od %origin%. Nie mogę porządkować domu, gdy jednocześnie jestem nękany przez te przeklęte istoty, więc bardzo liczę, że cię to zainteresuje, najemniku...%SPEECH_OFF% | %employer% mierzy cię wzrokiem.%SPEECH_ON%Nadajesz się, by walczyć z zielonoskórym? A twoi ludzie?%SPEECH_OFF%Kiwasz głową i udajesz, że to kłopot nie większy niż zdjęcie kota z drzewa. %employer% się uśmiecha.%SPEECH_ON%Dobrze, bo widziano ich całe mnóstwo na %direction% od %origin%. Idź tam i ich zniszcz. Proste, prawda? Na pewno zainteresuje to człowieka o twojej... pewności siebie.%SPEECH_OFF% | %employer% dogląda psów, karmiąc każdego posiłkiem, za który niejeden chłop gotów byłby zabić. Klaszcze ręce, całe w tłuszczu.%SPEECH_ON%Mój kucharz to przygotował, wyobrażasz sobie? Ohyda. Obrzydliwe.%SPEECH_OFF%Kiwasz głową, jakbyś mógł zrozumieć świat, w którym podsuwanie dobrego jedzenia psom jest czymś normalnym. %employer% opiera łokcie o stół.%SPEECH_ON%W każdym razie ludzie, którzy dostarczają nam mięso, donoszą, że zielonoskórzy zabijają ich krowy. Podobno widziano obóz na %direction% od %origin%. Jeśli jesteś zainteresowany, chciałbym, byś poszedł tam i zniszczył ich wszystkich.%SPEECH_OFF% | Zastajesz %employer%a wpatrującego się w zwoje. Zerka na ciebie i oferuje krzesło.%SPEECH_ON%Dobrze, że jesteś, najemniku. Mam problem z zielonoskórymi w tych stronach - rozbili obóz %direction% stąd.%SPEECH_OFF%Opuszcza jeden ze zwojów.%SPEECH_ON%Nie stać mnie, by wysłać własnych ludzi. Rycerze są raczej... niewymienni. Ty jednak nadajesz się do tej roboty. Co powiesz?%SPEECH_OFF% | Gdy wchodzisz do gabinetu %employer%a, grupa mężczyzn wychodzi. To rycerze, ich pochwy brzęczą tuż pod szatami. %employer% wita cię.%SPEECH_ON%Nie przejmuj się nimi. Zastanawiają się tylko, co się stało z ostatnim człowiekiem, którego wynająłem.%SPEECH_OFF%Unosisz brew. Mężczyzna macha ręką.%SPEECH_ON%Och, nie dawaj mi tego gówna, najemniku. Znasz interes tak jak ja, czasem wam nie idzie i wiesz, co to znaczy...%SPEECH_OFF%Nic nie mówisz, ale po chwili kiwasz głową.%SPEECH_ON%Dobrze, cieszę się, że rozumiesz. Jeśli chcesz wiedzieć, mam zielonoskórych na %direction% od %origin%. Rozbili obóz, który, jak zakładam, nie ruszył się od czasu, gdy, eee, wysłałem tam ostatnio ludzi. Jesteś zainteresowany, by ich wykorzenić?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Walczenie z orkami nie będzie tanie. | Ufam, że sowicie nas za to wynagrodzisz. | Porozmawiajmy o pieniądzach.}",
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
			ID = "OrcsAgainstOrcs",
			Title = "Przed atakiem...",
			Text = "[img]gfx/ui/events/event_49.png[/img]{Gdy rozkazujesz ludziom atakować, natykają się na grupę orków... walczących ze sobą? Zielonoskórzy są podzieleni i rozstrzygają spory, rozłupując się nawzajem na pół. To brutalny pokaz przemocy. Gdy uznajesz, że pozwolisz im się wyrżnąć, dwóch orków przebija się w twoją stronę i wkrótce każdy ork patrzy na ciebie. No cóż, teraz nie ma już ucieczki... do broni! | Rozkazujesz %companyname% zaatakować, sądząc, że masz przewagę nad orkami. Ale oni są już uzbrojeni! I... walczą między sobą?\n\n Jeden ork rozcina drugiego na strzępy, a kolejny miażdży głowę następnemu. Wygląda to na jakiś konflikt klanowy. Szkoda, że nie poczekałeś chwili dłużej, aż te brutale rozstrzygną spór, bo teraz jest każdy na każdego! | Orkowie biją się między sobą! To jakaś zielonoskóra jatka, w której sam bierzesz udział. Ork przeciw orkowi przeciw człowiekowi, co za widok! Zbij ludzi bliżej siebie i może wyjdziesz z tej koziofarki żywy. | Na bogów, orków jest więcej, niż kiedykolwiek byś przypuszczał! Na szczęście wygląda na to, że mordują się nawzajem. Nie wiesz, czy to osobne klany, czy po prostu zielonoskóra wersja pijackiej burdy. Tak czy inaczej, jesteś teraz w samym środku!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
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
			Text = "[img]gfx/ui/events/event_78.png[/img]{Gdy dobijasz ostatniego orka, nagle wita cię ciężko uzbrojona grupa ludzi. Ich dowódca wychodzi do przodu, kciuki zaczepione o pas podtrzymujący miecz.%SPEECH_ON%No proszę, naprawdę jesteś głupi. %employer% nie zapomina łatwo - i nie zapomniał, gdy ostatnim razem zdradziłeś %faction%. Uznał to za mały... zwrot przysługi.%SPEECH_OFF%Nagle wszyscy ludzie za dowódcą ruszają do szarży. Do broni, to zasadzka! | Ścierając orczą krew z miecza, nagle dostrzegasz grupę ludzi idących w twoją stronę. Niosą sztandar %faction% i dobywają broni. Zdajesz sobie sprawę z podstępu w tej samej chwili, gdy ruszają do ataku. Pozwolili ci najpierw walczyć z orkami, dranie! Daj im popalić! | Mężczyzna jakby znikąd wychodzi, by cię przywitać. Jest dobrze uzbrojony, dobrze opancerzony i najwyraźniej całkiem zadowolony, uśmiecha się niepewnie, gdy podchodzi.%SPEECH_ON%Dobry wieczór, najemnicy. Dobra robota z tymi zielonoskórymi, co?%SPEECH_OFF%Zatrzymuje się, by uśmiech zgasł.%SPEECH_ON%%employer% przesyła pozdrowienia.%SPEECH_OFF%W tej chwili z boków drogi wylewa się grupa ludzi. To zasadzka! Ten przeklęty szlachcic cię zdradził! | Bitwa ledwo się kończy, gdy uzbrojeni ludzie w barwach %faction% ustawiają się za tobą, rozchodząc się, by obserwować twoją kompanię. Ich przywódca mierzy cię wzrokiem.%SPEECH_ON%Sprawi mi przyjemność wydłubać ci ten miecz z zimnego uścisku.%SPEECH_OFF%Wzruszasz ramionami i pytasz, czemu cię wrobili.%SPEECH_ON%%employer% nie zapomina tych, którzy go podwójnie krzyżują, ani jego rodu. To wszystko, co musisz wiedzieć. Nie tak, jakby moje słowa miały ci się przydać, gdy będziesz martwy.%SPEECH_OFF%Do broni, bo to zasadzka! | Twoi ludzie przeczesują obóz orków i nie znajdują żywej duszy. Nagle za tobą pojawia się kilku obcych, a dowódca grupy podchodzi z jawnymi złymi zamiarami. Ma przy sobie tkaninę z wyhaftowanym sygnetem %employer%a.%SPEECH_ON%Szkoda, że orki nie dokończyły roboty. Jeśli zastanawiasz się, czemu tu jestem, przyszedłem spłacić dług wobec %faction%. Obiecałeś dobrze wykonać zadanie. Nie dotrzymałeś obietnicy. Teraz giniesz.%SPEECH_OFF%Dobijasz miecz i błyskasz ostrzem w stronę dowódcy.%SPEECH_ON%Wygląda na to, że %faction% właśnie znów usłyszy złamaną obietnicę.%SPEECH_OFF%}",
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
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 140 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
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
			Text = "[img]gfx/ui/events/event_32.png[/img]{Po bitwie przeszukujesz obóz orków. Wśród ruin znajdujesz coś, co wygląda na ciężkie zbroje i ludzką broń, ale w kompletnie bezużytecznym stanie. Niestety nie znajdujesz tych, do których być może należały. | Gdy orki są martwe, rozglądasz się po ich obozie. Jest pełen gówna. Dosłownie, gówno jest wszędzie. Te przeklęte stwory nie mają pojęcia o czystości. %randombrother% podchodzi, wycierając but o słup namiotu.%SPEECH_ON%Panie, ruszamy dalej czy szukamy dalej...?%SPEECH_OFF%Widziałeś i wyczułeś dość. | Obóz orków to pustkowie pełne wszelkiego zepsucia. Czuć ich seks i ich odpady. Nic dziwnego, że są tacy wojowniczy, skoro nie znają nawet podstaw tego, co rozumie cywilizowany człowiek. | Obóz orków został zniszczony, ale na chwilę przeczesujesz ruiny. Wśród popiołów paleniska znajdujesz kilka ludzkich zwłok. Po uzbrojeniu wnioskujesz, że byli najemnikami jak ty. Szkoda... że ich sprzęt jest już bezużyteczny, bo wszystko się spaliło. | Kilku twoich najemników przechadza się po ruinach obozu orków. Grzebią w resztkach, wyciągając to czy owo bezużyteczne błyskotki. %randombrother% chowa zakrwawiony miecz.%SPEECH_ON%Tu nic nie ma, panie.%SPEECH_OFF%Kiwasz głową i każesz ludziom szykować się do powrotu do %employer%a. | Po bitwie kręcisz się po obozie, szukając czegoś przydatnego. Nie znajdujesz niczego, co da się zabrać, ale trafiasz na stos martwych rycerzy. Ich blade, przeżarte przez robaki i larwy twarze sugerują, że leżą tu od dawna. Kto wie, co orki z nimi robiły.}",
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
			ID = "Volunteer1",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_32.png[/img]{Bitwa się skończyła, ale wciąż słyszysz krzyki. Mówisz %randombrother%owi, żeby przestał, bo ma skłonność do losowych pomruków i jęków, ale on kręci głową i mówi, że to nie on. W tej chwili z kupy popiołu, która była kiedyś obozem orków, wynurza się zakuty mężczyzna.%SPEECH_ON%Dobry wieczór, szlachetni panowie! Zdaje się, żeście mnie uwolnili.%SPEECH_OFF%Potyka się, a za nim wiruje upiorna, skręcająca się chmura popiołu.%SPEECH_ON%Jestem bardzo wdzięczny, rzecz jasna, i chciałbym się odwdzięczyć. Jesteście najemnikami, prawda? Jeśli tak, chciałbym walczyć dla was.%SPEECH_OFF%Podnosi ostrze z ziemi i obraca je w dłoni, jakby miał je od urodzenia. Ciekawa oferta, która właśnie stała się jeszcze ciekawsza... | Czyszcząc ostrze, słyszysz głos dobiegający z zapadniętego orczego namiotu.%SPEECH_ON%Dobrzy panowie, udało wam się!%SPEECH_OFF%Patrzysz, jak wychodzi uśmiechnięty mężczyzna.%SPEECH_ON%Uwolniliście mnie! Chciałbym się odwdzięczyć i ofiarować swoją dłoń!%SPEECH_OFF%Wyciąga rękę, zatrzymuje się, po czym cofa ją.%SPEECH_ON%To znaczy walczyć dla was! Chciałbym walczyć dla was, panie! Jeśli potrafisz to wszystko zrobić, to na pewno byłbym w dobrej kompanii, prawda?%SPEECH_OFF%Hmm, ciekawa propozycja. Rzucasz mu broń, a on łapie bez trudu. Obraca rękojeść, kręcąc nią w dłoni, po czym próbuje włożyć ją do niewidzialnej pochwy.%SPEECH_ON%Nazywam się %dude_name%.%SPEECH_OFF% | Mężczyzna w podartej i wgniecionej zbroi biegnie w twoją stronę. Ma związane ręce za plecami.%SPEECH_ON%Udało się! Nie mogę w to uwierzyć! Wybacz, niech wyjaśnię swoją bezwstydność. Zostałem pojmany przez orki dzień temu, gdy próbowaliśmy zdobyć obóz. Chyba mieli mnie nabić na pal, kiedy się pojawiliście. Wykorzystałem pierwszą okazję do ucieczki, a teraz widzę, że dołączenie do waszej grupy może być warte zachodu.%SPEECH_OFF%Prosisz, by przeszedł do rzeczy. Robi to.%SPEECH_ON%Chciałbym walczyć dla was, panie. Mam doświadczenie - byłem w armii lorda, najemnikiem i... cóż, różnie bywało.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Witaj w kompanii!",
					function getResult()
					{
						this.World.getPlayerRoster().add(this.Contract.m.Dude);
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude.onHired();
						this.Contract.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "Musisz poszukać swego szczęścia gdzie indziej.",
					function getResult()
					{
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude = null;
						return 0;
					}

				}
			],
			function start()
			{
				local roster = this.World.getTemporaryRoster();
				this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
				this.Contract.m.Dude.setStartValuesEx(this.Const.CharacterVeteranBackgrounds);

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
			ID = "Success1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Wracasz do %employer%a i zdajesz relację. Odprawia cię ruchem ręki.%SPEECH_ON%Och proszę, najemniku. Już wiem. Myślisz, że nie mam szpiegów w tych stronach?%SPEECH_OFF%Wskazuje sakiewkę na rogu stołu. Bierzesz ją, a mężczyzna macha dłonią.%SPEECH_ON%To powinno wystarczyć za podziękowanie, a teraz proszę, zniknij mi z oczu.%SPEECH_OFF% | Pokazujesz %employer%owi głowę orka. Wpatruje się w nią, potem w ciebie.%SPEECH_ON%Interesujące. Czy mam rozumieć, że wykonałeś to, o co cię prosiłem?%SPEECH_OFF%Kiwasz głową. Mężczyzna uśmiecha się i wręcza drewnianą skrzynkę z %reward% koronami.%SPEECH_ON%Wiedziałem, że mogę ci ufać, najemniku.%SPEECH_OFF% | %employer% wpatruje się w ciebie, gdy wracasz.%SPEECH_ON%Słyszałem, co zrobiłeś.%SPEECH_OFF%W jego głosie brzmi dziwny ton, który każe ci szybko przejrzeć w myślach wszystko, co robiłeś w ostatnim tygodniu. Czy to była szlachcianka przy... nie, to niemożliwe.%SPEECH_ON%Orki są martwe. Dobra robota, najemniku.%SPEECH_OFF%Przesuwa ku tobie sakiewkę z %reward% koronami, a fala ulgi również przechodzi przez twoje ciało. | Wchodzisz do komnaty %employer%a, siadasz i nalewasz sobie kielich wina. Szlachcic wierci w tobie wzrok.%SPEECH_ON%Śmiem twierdzić, że to przestępstwo za ćwiartowanie, powieszenie, jeśli mam dobry dzień, albo spalenie, jeśli nie.%SPEECH_OFF%Dopijasz, po czym z hukiem kładziesz orczą głowę na stole. Kielich chwieje się i przewraca na bok. %employer% cofa się, po czym uspokaja.%SPEECH_ON%Ach tak, napój dobrze zasłużony. To zresztą nie było moje najlepsze wino. %randomname%, mój strażnik, czeka na ciebie na zewnątrz. Ma przy sobie %reward% koron, jak uzgodniliśmy.%SPEECH_OFF% | Podnosisz głowę orka, by pokazać ją %employer%owi. Zielona paszcza opada, a język zwisa między zębami, które ktoś mógłby wziąć za kły. %employer% kiwa głową i macha dłonią.%SPEECH_ON%Proszę, miej litość dla moich snów i zabierz to stąd.%SPEECH_OFF%Robisz, jak każe. Mężczyzna kręci głową.%SPEECH_ON%Jak mam teraz spać, gdy takie rzeczy się tutaj nosi? Tak czy inaczej, %reward% koron już na ciebie czeka na zewnątrz u jednego z moich strażników. Dzięki za robotę, najemniku.%SPEECH_OFF% | Przychodzisz do komnaty %employer%a i widzisz, że ogląda rysunek na zwoju. Patrzy na ciebie, a krawędź papieru odgina się do tyłu.%SPEECH_ON%Moja córka uważa się za artystkę, wyobrażasz to sobie?%SPEECH_OFF%Pokazuje ci zwój. To całkiem dobrze wykonany rysunek mężczyzny podejrzanie podobnego do %employer%a. Narysowana postać stoi twarzą w twarz z katem. %employer% się śmieje.%SPEECH_ON%Głupia dziewczyna.%SPEECH_OFF%Gniecie zwój i odrzuca go na bok.%SPEECH_ON%W każdym razie moi szpiedzy już przekazali mi wieści o twoich sukcesach. Oto twoja zapłata, jak uzgodniliśmy.%SPEECH_OFF%}",
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
						this.World.Assets.addMoney(this.Contract.m.Reward);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Zniszczyłeś obozowisko orków");
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
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() + this.Flags.get("HeadsCollected") * this.Contract.m.Payment.getPerCount();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] koron"
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
		_vars.push([
			"dude_name",
			this.m.Dude == null ? "" : this.m.Dude.getNameOnly()
		]);
		_vars.push([
			"reward",
			this.m.Reward
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

