this.defend_settlement_greenskins_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Reward = 0,
		Kidnapper = null,
		Militia = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.defend_settlement_greenskins";
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
		this.m.Payment.Pool = 900 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
				local r = this.Math.rand(1, 100);
				local nearestOrcs = this.Contract.getNearestLocationTo(this.Contract.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getSettlements());
				local nearestGoblins = this.Contract.getNearestLocationTo(this.Contract.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getSettlements());

				if (nearestOrcs.getTile().getDistanceTo(this.Contract.m.Home.getTile()) + this.Math.rand(0, 6) <= nearestGoblins.getTile().getDistanceTo(this.Contract.m.Home.getTile()) + this.Math.rand(0, 6))
				{
					this.Flags.set("IsOrcs", true);
				}
				else
				{
					this.Flags.set("IsGoblins", true);
				}

				if (this.Math.rand(1, 100) <= 25 && this.Contract.getDifficultyMult() >= 0.95)
				{
					this.Flags.set("IsMilitia", true);
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

					if (this.Flags.get("IsGoblins"))
					{
						party = this.Contract.spawnEnemyPartyAtBase(this.Const.FactionType.Goblins, this.Math.rand(80, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					}
					else
					{
						party = this.Contract.spawnEnemyPartyAtBase(this.Const.FactionType.Orcs, this.Math.rand(80, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
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

						if (this.Flags.get("IsGoblins"))
						{
							this.Contract.setScreen("GoblinsAttack");
						}
						else
						{
							this.Contract.setScreen("OrcsAttack");
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{Gdy widzisz %employer%a, pot leje mu się po twarzy, a on wyciera ją ładnie haftowaną chustą, która nic nie pomaga.%SPEECH_ON%Najemniku, jakże dobrze cię widzieć! Proszę, proszę, wejdź i posłuchaj, co mam do powiedzenia.%SPEECH_OFF%Ostrożnie wchodzisz do pokoju i siadasz, zerkając, czy nikt nie chowa się za drzwiami lub regałami przy ścianach. %employer% przesuwa po stole mapę.%SPEECH_ON%Widzisz te zielone oznaczenia? To ruchy zielonoskórych, śledzone przez moich zwiadowców. Czasem przekazują mi to słowem, czasem wcale. Ci zwiadowcy po prostu... puf, znikają. Nie trzeba geniusza, by wiedzieć, co się z nimi stało, prawda?%SPEECH_OFF%Pytasz, czego chce. Uderza w mapę, a pięść ląduje prosto na %townname%.%SPEECH_ON%Nie widzisz? Nadciągają tędy i potrzebuję, żebyś pomógł nam się bronić!%SPEECH_OFF% | %employer% nerwowo obgryza paznokcie, gdy go znajdujesz. Obgryzł je do krwi, zostały tylko strzępy skóry i zadrapania.%SPEECH_ON%Dziękuję, że przyszedłeś, najemniku. Powiem wprost: zielonoskórzy nadciągają.%SPEECH_OFF%Mierząc dłonią wysokość, pytasz, jacy zielonoskórzy - tacy o-tak wielcy czy tacy, hmm, wielcy. %employer% wzrusza ramionami.%SPEECH_ON%Nie mam pojęcia. Moi zwiadowcy znikają, a wieśniacy, którzy wciąż napływają, nie są szczególnie wiarygodnymi świadkami. Wiedz tylko tyle: potrzebujemy twojej pomocy, bo zielonoskórzy idą w tę stronę.%SPEECH_OFF% | %employer% jest pijany i zapadnięty głęboko w fotel. Wskazuje kciukiem na otwartą księgę na stole.%SPEECH_ON%Słyszałeś o Bitwie o Wiele Imion? Dziesięć lat temu orki wdarły się na ludzkie ziemie, a ludzie wystawili armie i powiedzieli: nie.%SPEECH_OFF%Kiwasz głową, znając tę bitwę i wojnę, którą pomogła zakończyć. Mężczyzna ciągnie dalej.%SPEECH_ON%Niestety mamy powody sądzić, że wracają. Zielonoskórzy, nie wiadomo jacy, nie wiadomo jak wysocy, ale nadchodzą właśnie tędy.%SPEECH_OFF%Wypija resztę trunku, przełykając, jakby to był ostatni łyk przed tym, jak kat odetnie mu głowę.%SPEECH_ON%Zostaniesz tu i nas ochronisz? Za odpowiednią cenę, rzecz jasna. Nie zapomniałem jeszcze o twojej pozycji.%SPEECH_OFF% | %employer% stoi przy oknie, gdy wchodzisz.%SPEECH_ON%Słyszysz to?%SPEECH_OFF%Na ulicach kłębi się tłum - mieszanina apatycznych jęków i przerażonego płaczu.%SPEECH_ON%Tak brzmi to, gdy nadchodzą zielonoskórzy.%SPEECH_OFF%Mężczyzna zasłania okna i odwraca się do ciebie.%SPEECH_ON%Wiem, że dużo proszę, ale mamy pieniądze, więc zapytam wprost. Pomożesz chronić %townname%?%SPEECH_OFF% | %employer% odpiera tłum, gdy go znajdujesz.%SPEECH_ON%Wszyscy spokój! Uspokójcie się!%SPEECH_OFF%Ktoś rzuca cebulą, trafiając go w głowę kwaśnym, łzawiącym ciosem. Ktoś inny szybko ją podnosi i gryzie. %employer% wskazuje cię w tłumie.%SPEECH_ON%Najemniku! Tak się cieszę, że przyszedłeś!%SPEECH_OFF%Przepycha się przez tłum. Pochyla się do twojego ucha, lecz i tak musi krzyczeć, by go było słychać.%SPEECH_ON%Mamy pieniądze! Mamy to, czego potrzebujesz! Tylko pomóż chronić to miasto przed zielonoskórymi!%SPEECH_OFF% | Pracownicy %employer%a grzebią w jego komnacie, zbierając zwoje i książki, po czym pędzą w siną dal. On sam siedzi w fotelu, popijając z kielicha i oglądając mapę. Machnięciem ręki zaprasza cię do środka.%SPEECH_ON%Siadaj. Nie przejmuj się moimi ludźmi.%SPEECH_OFF%Robisz, jak prosi, ale trudno zignorować zamieszanie. %employer% odchyla się, splatając palce na brzuchu.%SPEECH_ON%Na pewno zauważyłeś, że wokół dzieją się dziwne rzeczy. To dlatego, że wypatrzono wielką bandę zielonoskórych i zmierzają w tę stronę, mordując i niszcząc wszystko na drodze. Chciałbym, byś pomógł obronić %townname%, zanim wszyscy skończymy jako przypis w kronice, rozumiesz?%SPEECH_OFF% | Wchodzisz do domostwa %employer%a i od razu zauważasz błoto na podłodze oraz przygaszone palenisko. Kilku jego ludzi biega ze zwojami w ramionach, ledwie widać im głowy zza papierzysk. %employer% stoi pośród chaosu, po prostu wydając polecenia. Gdy do niego podchodzisz, tylko kiwa głową.%SPEECH_ON%Zielonoskórzy nadciągają. Jakie? Nie wiem. Wiem tylko, co się stanie, jeśli nie zdołamy obronić tego miasta, dlatego robimy tu trochę przygotowań, rozumiesz?%SPEECH_OFF%Przytakujesz, po czym pytasz, czego jeszcze chce.%SPEECH_ON%Pomóż nam walczyć z zielonoskórymi, oczywiście. W grze są spore pieniądze, to jasne.%SPEECH_OFF% | Do domostwa %employer%a przybyli chłopi. Niosą całe naręcza dobytku, a sporo walające się za nimi świadczy o tak pilnej ucieczce, że nawet nie zadają sobie trudu zbierania wszystkiego. %employer% widzi cię przez okno i macha, byś wszedł bocznymi drzwiami. Gdy się wślizgujesz, siada w fotelu i nalewa ci trunku.%SPEECH_ON%Zielonoskórzy nadciągają, a nie wierzę, że mamy dość ludzi, by obronić %townname%. Oczywiście jestem gotów opłacić twoje usługi, by utrzymać %townname% w bezpieczeństwie przed tą zieloną plagą.%SPEECH_OFF% | Przed domostwem %employer%a stoi mężczyzna, ubrany w dwie pomalowane deski. Na każdej wypisano proroctwa jakiegoś zwiastuna zagłady. Ignorujesz go i wchodzisz do środka. %employer% stoi tam, śmieje się i kręci głową.%SPEECH_ON%Tamten facet się nie myli. Moi zwiadowcy od pewnego czasu meldowali ruchy zielonoskórych w okolicy. Powinienem był zwrócić uwagę, że od tygodnia nie przynieśli żadnych wieści - pewnie dlatego, że zielonoskórzy dorwali ich po drodze. Teraz zwykli ludzie przychodzą do mnie z opowieściami grozy o tym, co dzieje się w okolicy, i o tym, że ogromna horda tych paskudnych stworów idzie w tę stronę.%SPEECH_OFF%Odwraca się do ciebie, szczerząc się, a w jego uśmiechu wiruje szaleństwo.%SPEECH_ON%No to co powiesz, zawrzemy układ i uciszymy ten piskliwy płacz proroka? Pomożesz chronić %townname%?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Ile %townname% jest gotowe zapłacić za swe bezpieczeństwo? | To powinno być dla ciebie warte sporo koron, prawda? | Walczenie z zielonoskórymi nie będzie tanie.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Obawiam się, że jesteście zdani na siebie. | Obawiam się, że to nam się niezbyt opłaca. | Życzę wam powodzenia, ale nie weźmiemy w tym udziału.}",
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
			Text = "[img]gfx/ui/events/event_43.png[/img]{Gdy opuszczasz %employer%a z odmową, spotykasz mężczyznę, który śmieje się i kręci głową.%SPEECH_ON%Hej, zielonoskórzy nie idą tamtędy, chyba że to twój plan, ty tchórzu.%SPEECH_OFF%Dobywasz miecza, pozwalając stali długo zaskrzypieć w pochwie. Mężczyzna się śmieje.%SPEECH_ON%A co z tym zrobisz? Przebijesz mnie? No dawaj. Zrób gorzej niż zielonoskórzy, spróbuj.%SPEECH_OFF%Wypada kobieta, chwyta go i ciągnie z powrotem.%SPEECH_ON%Zabierz dzieci, dobrze? Musimy się wynosić, już!%SPEECH_OFF%Para oddala się, ale w głowie wciąż brzmi ci oskarżenie o tchórzostwo. | Chłopi już pakują się na drogę, byle jak najszybciej wynieść się z %townname%. Kilku spogląda na ciebie, jeden nawet wychodzi naprzód - starzec z laską.%SPEECH_ON%Widzicie? Tak wygląda dziś świat! Wszyscy dobrzy ludzie nie żyją, a zostali tylko tchórze, tacy jak ten rzekomy szermierz.%SPEECH_OFF%%randombrother% robi krok naprzód, chwytając za broń, gotów zabić.%SPEECH_ON%Śmiesz obrażać %companyname%? Wyrwę ci język, a potem głowę, staruchu!%SPEECH_OFF%Łapiesz najemnika za ramię. Ostatnie, czego ci ludzie potrzebują, to przemocy, ale starzec mówił głośno i wyraźnie. Zastanawiasz się, kto go usłyszał i kto przeżyje, by nieść dalej ciężar jego słów. | Kobieta chwyta cię, gdy próbujesz wrócić do kompanii.%SPEECH_ON%Panie, proszę! Nie możecie nas zostawić na ten los! Nie wiecie, co zielonoskórzy nam zrobią!%SPEECH_OFF%Masz bardzo dobrą wizję tego, co się stanie, ale zachowujesz to dla siebie. Kobieta pada na kolana i chwyta cię za kostki. Udaje ci się wyswobodzić. Przez chwilę czołga się za tobą, rozchlupując błoto, po czym przystaje i zaczyna szlochać.%SPEECH_ON%Nie wie pan, jak to jest. To się nigdy nie poprawia. Dla nas. Dla mnie.%SPEECH_OFF%Na bogów, to żałosne, ale czujesz w sobie odrobinę współczucia. | Gdy odchodzisz od %employer%a z odmową, z domu wychodzi mężczyzna. Głaszcze kurę, a w oczach ma łzy.%SPEECH_ON%Panie, jeśli zostaniesz, możesz ją mieć.%SPEECH_OFF%Chłop całuje kurę. Ta bezmyślnie skrzeczy, nie odwzajemniając rozpaczy właściciela.%SPEECH_ON%Zostań i pomóż ocalić to miasto. Możesz ją mieć. Proszę, zostań.%SPEECH_OFF%O rety, czy naprawdę do tego ma się to sprowadzić? | Zbliża się do ciebie potargany, bardzo stary mężczyzna.%SPEECH_ON%Więc postanowiłeś nie pomagać? Chyba nie mogę cię za to winić.%SPEECH_OFF%Rozkłada ramiona w stronę kilku chłopów stojących obok. Mają skrzynie z dobytkiem, najróżniejsze graty - od spleśniałych warzyw po jedną czy dwie kury, a może te dwie kury to jeden mały, skrzeczący baranek.%SPEECH_ON%Ci ludzie chcieliby, żebyś został i pomógł. Ale rozumiem, czemu byś nie chciał. Byłem na Bitwie o Wiele Imion. Wiem, jak to jest walczyć z tymi bestiami. Nie będę cię winił. Trzeba wielkiej miary, by stawić im czoła. Tak to już jest, tak to jest, panie, i nie będę cię winił ani trochę.%SPEECH_OFF%Powoli kuśtyka dalej i wtedy zauważasz, że jedna z jego nóg to drewniana proteza. Kilkoro dzieci podbiega do niego, a on rozmawia z grupą chłopów. Spogląda na ciebie, potem znów na nich i kręci głową. Niemal czujesz, jak spływają na ciebie smutek i rozczarowanie.}",
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
			ID = "OrcsAttack",
			Title = "W pobliżu %townname%",
			Text = "[img]gfx/ui/events/event_49.png[/img]Zielonoskórzy są w zasięgu wzroku! Przygotować się do bitwy i bronić miasta!",
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
			ID = "GoblinsAttack",
			Title = "W pobliżu %townname%",
			Text = "[img]gfx/ui/events/event_48.png[/img]Zielonoskórzy są w zasięgu wzroku! Przygotować się do bitwy i bronić miasta!",
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
			Text = "[img]gfx/ui/events/event_30.png[/img]{Podczas czuwania przed zielonoskórymi podchodzi chłop i mówi, że grupa bestii zaatakowała w pobliżu i zabrała sporą liczbę zakładników. Kręcisz głową z niedowierzaniem. Jak te brutale zdołały się zakraść i to zrobić? Chłop też kręci głową.%SPEECH_ON%Myślałem, że macie nam pomóc. Czemu nic nie zrobiliście?%SPEECH_OFF%Pytasz, czy zielonoskórzy są daleko. Chłop wzrusza ramionami, ale uważa, że wciąż można ich dogonić. Wygląda na to, że wciąż masz szansę odzyskać tych biednych ludzi, zanim bogowie wiedzą, co ich spotka. | Mężczyzna w łachmanach, z połamanymi widłami w ręku, pędzi do twojej kompanii. Pada i zawodzi u twoich stóp.%SPEECH_ON%Zielonoskórzy zaatakowali! Och, byli dokładnie tacy, jak mówił mój dziadek! A gdzie byliście? Zabili ludzi... spalili... i... wydaje mi się, że kilku zjedli... o bogowie. Ale to nie najgorsze! Zielonoskórzy zabrali kilku biedaków jako więźniów! Proszę, idźcie ich uratować!%SPEECH_OFF%Spoglądasz na %randombrother%a i kiwasz głową.%SPEECH_ON%Szykować ludzi. Musimy dogonić te paskudne bestie, zanim uciekną na dobre.%SPEECH_OFF% | Wypatrujesz na horyzoncie jakiegokolwiek znaku zielonoskórych. Nagle %randombrother% podchodzi z kobietą u boku. Popycha ją do przodu i kiwa głową. Ściskając pierś, kobieta szlocha i opowiada, jak zielonoskórzy już zaatakowali, rozszarpując pobliski przysiółek. Wyjaśnia, że nie tylko zabijali, ale i zabrali kilku jako więźniów. Najemnik kiwa głową.%SPEECH_ON%Wygląda na to, że prześlizgnęli się obok nas, panie.%SPEECH_OFF%Masz teraz tylko jeden wybór - iść i odzyskać tych ludzi! | Stacjonując blisko %townname%, wyczekujesz ataku zielonoskórych. Myślałeś, że będzie łatwo, ale nagłe pojawienie się szalonego chłopa mówi inaczej. Wyjaśnia, że paskudni maruderzy już napadli na małą wioskę na zapleczu. Zasiekli wszystkich, których mogli, a potem, nasyciwszy żądzę krwi, zabrali kilku mężczyzn, kobiet i dzieci. Chłop, pijany lub w szoku, bełkocze błagania.%SPEECH_ON%Odzyskajcie... odzyskajcie ich, no...%SPEECH_OFF% | Kilku wściekłych chłopów wbija się na drogę, pędząc ku tobie w wirze gniewu tłumu.%SPEECH_ON%Myślałem, że płacimy wam za ochronę! Gdzie byliście?%SPEECH_ON%Są pokryci krwią. Niektórzy półnadzy. Jeden mężczyzna trzyma ramię przy piersi, kończyna nie ma dłoni. Pytasz, o czym mówią. Kobieta wychodzi naprzód z dziećmi u stóp. Zasłania im uszy.%SPEECH_ON%O czym mówimy? Wy przeklęci najemnicy! Zielonoskórzy przyszli, a kto inny? Mieliście nas chronić, ale pewnie byliście zbyt zajęci obmacywaniem się i sranem w gacie, by zauważyć, że już się prześlizgnęli! Uciekliśmy, ale tych, którzy nie mogli, zabrano w niewolę! Wiesz, co spotyka tych, których zabierają zielonoskórzy? Bo ja nie wiem, ale podejrzewam, że to nie piosenki i ciasto!\n\n Mówisz kobiecie, żeby się zamknęła, zanim jej usta zaczną skubać kury, których ciało nie zdoła zjeść.%SPEECH_ON%Odzyskamy ich.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{Chowając miecz, każesz %randombrother%owi uwolnić więźniów. Cała gromada oszołomionych chłopów zostaje uwolniona ze skórzanych smyczy, łańcuchów i psich klatek. Dziękują ci za przybycie w porę. Jeden z nich drapie rany na nadgarstkach, gdzie wcześniej były łańcuchy.%SPEECH_ON%Dzięki, najemniku.%SPEECH_OFF%Wskazuje rożen, na którym nad wygaszonym ogniem wisi zwęglone, skurczone ciało.%SPEECH_ON%Szkoda, że nie zdążyliście jej uratować. Była ładna. A teraz, cóż, spójrz na nią.%SPEECH_OFF%Mężczyzna krzywo się uśmiecha, po czym wybucha płaczem. | Przeklęci zielonoskórzy zostają wybici. Wysyłasz ludzi, by ratowali każdego chłopa, jakiego znajdą. Każdy z nich przytula się i płacze, oszalały ze szczęścia, że przeżył tę straszliwą próbę. | Po zabiciu ostatniego zielonoskórego każesz kompanii uwolnić zakładników. Każdy z nich podchodzi do ciebie po kolei, jedni całują dłoń, inni stopy. Mówisz im tylko, by wracali do ratusza %townname%, tak jak zrobisz to ty. | Po zgładzeniu ostatniego zielonoskórego każesz ludziom uwolnić zakładników. Wypełzają, całkiem w szoku, potykając się o ruiny pobojowiska. Kilkoro grzebie w obozowisku zielonoskórych. Widzisz, jak {mężczyzna | kobieta} podnosi stertę dymiących, zwęglonych kości. Przez chwilę wpatrują się w szczątki, odkładają je, po czym wstają i idą dalej w dzicz.}",
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
			Text = "[img]gfx/ui/events/event_53.png[/img]{Niestety zielonoskórzy uciekli z zakładnikami. Niech bogowie mają w opiece te biedne dusze. | Nie udało się - nie zdołałeś uratować tych biednych chłopów. Teraz tylko bogowie wiedzą, co ich spotka. Właściwie ty też to wiesz, ale udajesz głupiego, żeby móc spać w nocy. | Niestety paskudne bestie uciekły, ciągnąc za sobą ludzki ładunek. Ci biedni ludzie będą musieli teraz radzić sobie sami. Opowieści, które słyszysz, mówią jednak, że nie spotka ich nic dobrego. | Zielonoskórzy uciekli razem ze swoimi więźniami. Nie masz pojęcia, co teraz spotka tych ludzi, ale wiesz, że nic dobrego. Niewola. Tortury. Śmierć. Nie wiesz, co gorsze. | Zielonoskórzy i ich nieszczęśni zakładnicy uciekli. Życzysz tym ludziom jak najlepiej, ale gdy wiatr zawija się wokół, niosąc pustą, sztywną pieśń, wiesz doskonale, że żadna prośba ani modlitwa nie uratuje tych biedaków. | Cóż, zielonoskórzy uciekli. Ślad obgryzionych ludzkich kości i sterty zdartego mięsa mówią wiele o twojej porażce. | Podnosisz strzęp ubrania i widzisz, że leżał na stercie kości.%SPEECH_ON%No to pięknie.%SPEECH_OFF%Od miejsca odchodzą ślady \'jedzenia\'. Zielonoskórzy uciekli, a biedni więźniowie zniknęli razem z nimi. | %randombrother% woła cię do siebie. Gdy stajesz obok, wskazuje kupę gnoju na ziemi. Wzruszasz ramionami.%SPEECH_ON%Tak. Śmierdzi. Co jeszcze?%SPEECH_OFF%Kopnięciem odsłania coś białego, co wygląda jak kość wydobyta z brei.%SPEECH_ON%To ludzka kość. Więźniów zjedli, panie.%SPEECH_OFF%Rozglądasz się po trawie i widzisz jeszcze więcej szczątków. Ślady prowadzą dalej, zielonoskórzy wyraźnie wymknęli się pościgowi. Wzdychasz i każesz ludziom przygotować się do odejścia.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{Ludziom z %townname% się to nie spodoba... | Mam nadzieję, że czeka ich względnie szybka śmierć.}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% wita twój powrót skrzynią z %reward% koronami.%SPEECH_ON%Na to zasłużyłeś, najemniku, to mogę powiedzieć. Żadna część miasta, no, żadna ważna, nie została tknięta.%SPEECH_OFF%Zatrzymuje się, gdy wpatrujesz się w skrzynię. Było ciężko i krwawo, a mimo to spodziewałeś się więcej. Czasem prostota bycia najemnikiem naprawdę cię drażni. | Zastajesz %employer%a karmiącego psy. Gładzi jednego bez końca, gdy ten pochłania jadło.%SPEECH_ON%Naprawdę myślałem, że będę musiał z tego zrezygnować.%SPEECH_OFF%Głaszcze kundla po raz ostatni, po czym spogląda na ciebie.%SPEECH_ON%Dziękuję, najemniku. Zrobiłeś więcej niż tylko obroniłeś miasto - ocaliłeś sposób życia. Bez ciebie albo byśmy wszyscy zginęli, albo co gorsza, przeżylibyśmy, by zobaczyć okropność, którą przyniosłoby jutro.%SPEECH_OFF%Kiwasz głową i robisz krok, by pogłaskać jednego z psów, ale ten warczy i szczerzy kły. %employer% się śmieje.%SPEECH_ON%Wybacz jego ignorancję.%SPEECH_OFF% | Wokół %employer%a stoi grupa mężczyzn i kobiet. Gdy wchodzisz, wszyscy niemal przerażająco równo odwracają się do ciebie. Patrzą przez chwilę, po czym wybuchają świętowaniem i rzucają się na ciebie z uściskami i łzami. Odpędzając ich, dostrzegasz %employer%a z sakiewką w dłoni.%SPEECH_ON%To za uratowanie %townname%, najemniku. Szczerze mówiąc, to nie jest tak ciężkie, jak powinno, ale tyle mamy.%SPEECH_OFF% | %employer% wygląda przez okno, gdy do niego wracasz. Na zewnątrz milicjanci krzątają się, a mieszkańcy miasta obejmują się nawzajem.%SPEECH_ON%Ani jeden zielonoskóry nie wszedł do centrum miasta.%SPEECH_OFF%Uśmiecha się, wręczając sakiewkę z dobrami.%SPEECH_ON%Przekroczyłeś dziś wszelkie oczekiwania, najemniku.%SPEECH_OFF% | Znalezienie %employer%a nie było łatwe: całe miasto świętuje. Skubią kury tak szybko, że ptaki czasem uciekają, pędząc półoskubane ulicami, a dzieci gonią za nimi z radosnym wrzaskiem. %employer% podchodzi do ciebie po cichu pośród festynu.%SPEECH_ON%Jest wiele powodów do żałoby, ale to zostawimy na jutro. Dziś świętujemy życie i twoje czyny, najemniku.%SPEECH_OFF%Mężczyzna wręcza sakiewkę z dobrami, ciężką w dłoni. | Zastajesz %employer%a, jak przestawia książki na półkach. Wygląda na to, że porządkuje dobytek, licząc i numerując, jakby był sklepikarzem. Podskakuje, gdy drzwi trzaskają za tobą.%SPEECH_ON%Ach, najemniku! Przestraszyłeś mnie.%SPEECH_OFF%Zdejmuje skrzynię z półki i wręcza ci ją.%SPEECH_ON%Planowałem zabrać wszystkie te książki, wszystkie zwoje i uciec. Teraz nie muszę - i to wszystko dzięki tobie.%SPEECH_OFF%Jego uśmiech na moment kwaśnieje.%SPEECH_ON%Nie wszyscy mieli tyle szczęścia, by zobaczyć ten dzień i twoje zwycięstwo. Dziś muszę dopilnować, by polegli dostali godny pochówek.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Obroniłeś osadę przed zielonoskórymi");
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
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] koron"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_30.png[/img]{%employer% chowa głowę w dłoniach. Wskazujesz na okno.%SPEECH_ON%Miasto uratowane, czemu łzy, co?%SPEECH_OFF%Podnosi na ciebie wzrok.%SPEECH_ON%Tak, większość ludzi przeżyła, to prawda. Ale to nie znaczy, że zielonoskórzy nie wyrwali dziury w sporej części tego przeklętego miasta.%SPEECH_OFF%Przesuwa po stole skrzynię z dobrami, po czym masuje czoło.%SPEECH_ON%Wybacz, że jestem taki ponury, ale jestem pewien, że rozumiesz, jak to jest, najemniku. Przynajmniej mam taką nadzieję.%SPEECH_OFF%Rozumiesz, ale udajesz, że cię to nie obchodzi. | Zastajesz %employer%a za domostwem. Ma w ręku łopatę i odprawia kilku chłopów. Tu i ówdzie widać świeże kopce ziemi.%SPEECH_ON%Miło widzieć twoją twarz, najemniku.%SPEECH_OFF%Opiera się na trzonku łopaty.%SPEECH_ON%Tylko, ee, grzebiemy tych, którzy nie przeżyli. Zrobiłeś cholernie dobrą robotę i nie chcę, żebyś myślał inaczej, ale wielu ludzi nie przeżyło. W niczym cię nie obwiniam - zielonoskórzy to groźny wróg i nie byłoby rozsądne oczekiwać perfekcji.%SPEECH_OFF%Kiwasz głową, a on odpowiada tym samym. Podnosi sakiewkę, która leżała pośród ubłoconych łopat. Zostawia smugę błota, gdy leci w powietrzu. Łapiesz ją i znów kiwasz głową, zostawiając go przy pracy. Oddalając się, słyszysz znajome schkk, schkk, gdy łopata wbija się w ziemię. | Gdy wracasz, %employer% studiuje mapę. Kładzie palec na jednym miejscu, a potem prowadzi go dalej, niemal opowiadając trasę.%SPEECH_ON%Tego miejsca nie udało się ocalić. Ten dom spłonął. Ci ludzie nie żyją. Tych znaleźliśmy w lesie. Chyba próbowali się ukryć, ale mieli noworodka. Podejrzewam, że to ich zdradziło.%SPEECH_OFF%Pochyla się, opierając zaciśnięte dłonie na stole.%SPEECH_ON%Dobrze się spisałeś, najemniku, ale nie wszystkich dało się uratować. Tak to już jest i nie będę ci tego wypominał. Nie wtedy, gdy ja i wielu innych wciąż oddychamy.%SPEECH_OFF%Rzuca w ciebie sakiewką koron. Łapiesz ją i przytakujesz. Tak to jest, a to, jak jest, to niezła wypłata. | Zastajesz %employer%a, jak powoli przesuwa długi zwój między palcami. Kiwając głową, mruczy pod nosem.%SPEECH_ON%Wiesz, jak to jest czytać nazwiska martwych sąsiadów?%SPEECH_OFF%Wiesz, ale nie przerywasz.%SPEECH_ON%To dziwne uczucie. Znałem ich, ale teraz nie widzę ich twarzy. Rozpoznaję tylko ich imiona, jak zwykłe słowa, nie bardziej szczególne niż inne. To już tylko słownik, opisy wspomnień, jak sądzę.%SPEECH_OFF%Spogląda na ciebie, po czym odkłada zwój i sięga po sakiewkę z koronami.%SPEECH_ON%Dość tego marudzenia, najemniku. Oto twoja zapłata, jak obiecałem.%SPEECH_OFF% | %employer% kieruje człowiekiem z pędzlem. Ich płótnem jest gruby papier i coś, co wygląda na szkło. Z ciekawości pytasz, co się dzieje.%SPEECH_ON%Utrwalam bitwę. Upamiętniam ją.%SPEECH_OFF%Wskazuje fragment, w którym płonie budynek.%SPEECH_ON%Widzisz? Gdy poszedłeś walczyć z zielonoskórymi, spalili to miejsce. I tamto też. Zapamiętamy wszystko, by nie zapomnieć.%SPEECH_OFF%Mężczyzna wręcza ci sakiewkę koron, po czym szybko wraca do pracy. Wpatrując się w obraz, nie widzisz na nim nigdzie swojej kompanii.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor, "Obroniłeś osadę przed zielonoskórymi");
						this.World.Contracts.finishActiveContract();
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% wita twój powrót skrzynią z %reward% koronami.%SPEECH_ON%Na to zasłużyłeś, najemniku, to mogę powiedzieć. Niestety zielonoskórzy porwali kilku naszych. Wstrzymuję część twojej zapłaty, by pomóc tym, którzy powierzyli ci swoje życie.%SPEECH_OFF%Zatrzymuje się, gdy wpatrujesz się w skrzynię. Kiwasz głową, rozumiejąc niedolę chłopów, ale i wiedząc, że spór nie przysłuży się twoim przyszłym interesom. | Zastajesz %employer%a karmiącego psy. Gładzi jednego bez końca, gdy ten pożera resztki kolacji.%SPEECH_ON%Naprawdę myślałem, że będę musiał z tego wszystkiego zrezygnować.%SPEECH_OFF%Głaszcze kundla po raz ostatni, po czym spogląda na ciebie.%SPEECH_ON%Nie wszyscy przeżyli. Twoja zapłata leży w rogu, ale będzie mniejsza, niż ustaliliśmy. Muszę zadbać o tych, których porwano, i jestem pewien, że rozumiesz, czemu zabieram ci część zapłaty.%SPEECH_OFF% | Wokół %employer%a stoi grupa mężczyzn i kobiet. Gdy wchodzisz, odwracają się do ciebie niemal przerażająco równo. %employer% wręcza im korony i mówi do ciebie, robiąc to.%SPEECH_ON%Twoja zapłata jest na zewnątrz, u jednego z moich strażników. Będzie lżejsza, bo część przeznaczyłem na pocieszenie tych, którzy stracili bliskich w bitwie.%SPEECH_OFF%Spoglądasz na biedne dusze kręcące się po pokoju. Muszą być rodziną tych, których zielonoskórzy porwali. | %employer% wygląda przez okno, gdy do niego wracasz. Na zewnątrz milicjanci krzątają się, a mieszkańcy miasta obejmują się nawzajem.%SPEECH_ON%Miasto zostało oszczędzone, ale z przykrością muszę powiedzieć, że w nadchodzących dniach mniej ludzi będzie stąpało po tych drogach.%SPEECH_OFF%Uśmiecha się, wręczając sakiewkę koron, która wydaje się odrobinę lżejsza, niż powinna.%SPEECH_ON%Przekroczyłeś dziś wszelkie oczekiwania, najemniku, ale nie wszystkich dało się uratować. Ci, których zabrali zielonoskórzy, zostawili rodziny, a tym rodzinom pomogę w tych ciężkich czasach.%SPEECH_OFF% | Znalezienie %employer%a nie było łatwe: całe miasto świętuje. Skubią kury tak szybko, że ptaki czasem uciekają, pędząc półoskubane ulicami, a dzieci gonią za nimi z radością. %employer% podchodzi do ciebie po cichu pośród festynu. Mężczyzna wręcza sakiewkę z dobrami, która ciąży w dłoni.%SPEECH_ON%Nie każdy może być tak wesoły, najemniku. Ci porwani, których nie mogłeś ocalić? Zostawili rodziny i to do nich trafi część twojej zapłaty. Jestem pewien, że rozumiesz.%SPEECH_OFF% | Zastajesz %employer%a, jak przestawia książki na półkach. Wygląda na to, że porządkuje dobytek, licząc i numerując, jakby był sklepikarzem. Podskakuje, gdy drzwi trzaskają za tobą.%SPEECH_ON%Ach, najemniku! Przestraszyłeś mnie.%SPEECH_OFF%Zdejmuje skrzynię z półki i wręcza ci ją.%SPEECH_ON%Planowałem zabrać wszystkie te książki, wszystkie zwoje i uciec. Teraz nie muszę - i to wszystko dzięki tobie.%SPEECH_OFF%Jego uśmiech kwaśnieje.%SPEECH_ON%Nie wszyscy mieli tyle szczęścia, by zobaczyć ten dzień. Miejscowi powiedzieli mi, co się stało: zielonoskórzy porwali kilku naszych, a ty nie zdołałeś ich ocalić. To zrozumiałe, ale mam nadzieję, że i ty rozumiesz, że zabrałem część twojej zapłaty, by pomóc tym rodzinom, które ocalały.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor, "Obroniłeś osadę przed zielonoskórymi");
						this.World.Contracts.finishActiveContract();
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
			Text = "[img]gfx/ui/events/event_30.png[/img]{%employer% wita twój powrót lżejszą, niż się spodziewałeś, sakiewką. Wyjaśnia.%SPEECH_ON%Obrzeża zostały niemal zniszczone, a wielu ludzi porwano. Przykro mi, najemniku, ale potrzebowałem tych pieniędzy, by pomóc miastu stanąć na nogi. Możesz mi grozić, jeśli chcesz, ale tak już jest.%SPEECH_OFF%Decydujesz się przyjąć straty i ruszyć dalej. | Zastajesz %employer%a oglądającego miasto. Na obrzeżach wciąż płonie kilka ognisk, wypychając czarny dym ku niebu. Zmęczeni chłopi wloką się drogami. Niosą, co się da, niektórzy niosą siebie nawzajem, bo rany są potworne. %employer% kiwa głową na ten widok.%SPEECH_ON%Wiele zniszczeń, najemniku. Ty i ja wiemy, że płaciłem ci, by uratować miasto w całości i zapewnić bezpieczeństwo jego ludziom. To się nie udało, ale przynajmniej wciąż rozmawiamy, więc dostaniesz część nagrody, jak obiecałem.%SPEECH_OFF%Wręcza ci sakiewkę koron. Jest lżejsza, niż uzgodniliście, ale dla dobra przyszłych interesów nie kłócisz się o to. | %employer% wygląda przez okno. W jednej dłoni trzyma zwój, w drugiej pióro, robiąc notatki tu i tam. Mówi, nie patrząc na ciebie.%SPEECH_ON%Cóż, żyjemy i to dobrze. Niedobrze za to, że te pożary trawią obrzeża miasta, i że zielonoskórzy porwali kilku naszych.%SPEECH_OFF%W końcu przerywa pisanie na tyle długo, by odwrócić się i spojrzeć na ciebie.%SPEECH_ON%Twoja zapłata jest w holu. Jest mniejsza, niż się spodziewałeś. Jeśli chcesz się o to spierać, jestem cały uszami - i tylko uszami.%SPEECH_OFF%Uświadamiasz sobie, że spór o zapłatę nic nie da, więc po prostu bierzesz to, co zarobiłeś.}",
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
			Text = "[img]gfx/ui/events/event_30.png[/img]{Gdy wchodzisz do komnaty %employer%a, każe ci zamknąć drzwi. Ledwo zapadka kliknie, mężczyzna zasypuje cię strumieniem obelg, których nie sposób spamiętać. Gdy się uspokaja, jego głos - i język - wracają do względnej normalności.%SPEECH_ON%Wszystkie nasze obrzeża zostały zniszczone. Za co, dokładnie, myślałeś, że ci płacę? Wynoś się stąd.%SPEECH_OFF% | %employer% opróżnia kielichy wina, gdy wchodzisz. Za oknem słychać gwar wściekłych chłopów.%SPEECH_ON%Słyszysz? Urwą mi głowę, jeśli ci zapłacę, najemniku. Miałeś jedno zadanie, jedno! Chronić to miasto. A nie potrafiłeś. Więc teraz możesz zrobić jedną rzecz i jest za darmo: wynoś się mi z oczu.%SPEECH_OFF% | %employer% splata dłonie na biurku.%SPEECH_ON%Czego, dokładnie, spodziewasz się tutaj dostać? Dziwię się, że w ogóle wróciłeś. Połowa miasta płonie, a druga to już popiół. Nie wynająłem cię po to, byś robił dym i spustoszenie, najemniku. Wynoś się stąd.%SPEECH_OFF% | Kiedy wracasz do %employer%a, trzyma kufel piwa. Drży mu ręka. Twarz ma czerwoną.%SPEECH_ON%Kosztuje mnie wszystko, by nie rzucić tym w twoją twarz.%SPEECH_OFF%Na wszelki wypadek kończy piwo jednym haustem. Uderza kuflem o biurko.%SPEECH_ON%To miasto oczekiwało, że je obronisz. Tymczasem zielonoskórzy zalali obrzeża jakby urządzali cholerną wycieczkę! Nie jestem od sprawiania zielonoskórym miłego dnia w niszczeniu mojego miasta, najemniku. Wynoś się, do cholery!%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Zaraza z tymi wieśniakami! | Powinniśmy byli zażądać więcej pieniędzy z góry... | A niech to!}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Nie zdołałeś obronić osady przed zielonoskórymi");
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
			Text = "[img]gfx/ui/events/event_30.png[/img]{%employer%a nigdzie nie widać. Podchodzi do ciebie jeden z jego strażników.%SPEECH_ON%Jeśli szukasz mojego pana, lepiej daj spokój. Połowa miasta została zniszczona, a on jest gdzieś na zewnątrz i próbuje to naprawić.%SPEECH_OFF%Pytasz o zapłatę. Mężczyzna wybucha smutnym, szorstkim śmiechem.%SPEECH_ON%Zapłata? Wybacz, sprzedawco mieczy. Nie płacił ci za porażkę. A te pieniądze i tak wracają do miasta.%SPEECH_OFF% | Przeszukujesz płonące ruiny %townname% w poszukiwaniu %employer%a. Znajdujesz go, gdy wyciąga zwęglone ciała z tlącego się rumowiska, które kiedyś było domem. Rzuca zwęglone zwłoki u swoich stóp i niemal wypala w tobie wzrokiem dziurę.%SPEECH_ON%Czego chcesz, najemniku? Mam nadzieję, że nie zapłaty, bo to tutaj nie jest to, za co ci płaciłem.%SPEECH_OFF% | Zastajesz %employer%a wpatrującego się przez okno. Cały horyzont płonie, jakby na tym świecie miały zajść dwa słońca. Kręci głową, gdy cię widzi.%SPEECH_ON%Co ty tu robisz? Umawialiśmy się, że zapłacę ci za to, że miasto poszło z dymem? Chyba nie, najemniku. Wynoś się stąd.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Zaraza z tymi wieśniakami! | Powinniśmy byli zażądać więcej pieniędzy z góry... | A niech to!}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Nie zdołałeś obronić osady przed zielonoskórymi");
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
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/greenskins_situation"));
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

		if (this.m.Home != null && !this.m.Home.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Home.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(4);
			}
		}
	}

	function onIsValid()
	{
		local nearestOrcs = this.getNearestLocationTo(this.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getSettlements());
		local nearestGoblins = this.getNearestLocationTo(this.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getSettlements());

		if (nearestOrcs.getTile().getDistanceTo(this.m.Home.getTile()) > 20 && nearestGoblins.getTile().getDistanceTo(this.m.Home.getTile()) > 20)
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

