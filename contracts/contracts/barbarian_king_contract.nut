this.barbarian_king_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Threat = null,
		LastHelpTime = 0.0,
		IsPlayerAttacking = false,
		IsEscortUpdated = false
	},
	function create()
	{
		this.contract.create();
		local r = this.Math.rand(1, 100);

		if (r <= 70)
		{
			this.m.DifficultyMult = this.Math.rand(90, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}

		this.m.Type = "contract.barbarian_king";
		this.m.Name = "Król Barbarzyńców";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 5.0;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 1700 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Zapoluj na Króla Barbarzyńców i jego armię",
					"Ostatnio widziano go w regionie %region%, na %direction% od ciebie"
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
				local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians);
				local nearest_base = f.getNearestSettlement(this.World.State.getPlayer().getTile());
				local party = f.spawnEntity(nearest_base.getTile(), "Kr\x0480l Barbarzyńc\x0480w", false, this.Const.World.Spawn.Barbarians, 125 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.setDescription("Potężny oddział wojenny barbarzyńskich plemion, zjednoczonych przez samozwańczego króla barbarzyńców.");
				party.getSprite("body").setBrush("figure_wildman_04");
				party.setVisibilityMult(2.0);
				this.Contract.addUnitsToEntity(party, this.Const.World.Spawn.BarbarianKing, 100);
				this.Contract.m.Destination = this.WeakTableRef(party);
				party.getLoot().Money = this.Math.rand(150, 250);
				party.getLoot().ArmorParts = this.Math.rand(10, 30);
				party.getLoot().Medicine = this.Math.rand(3, 6);
				party.getLoot().Ammo = this.Math.rand(10, 30);
				party.addToInventory("supplies/roots_and_berries_item");
				party.addToInventory("supplies/dried_fruits_item");
				party.addToInventory("supplies/pickled_mushrooms_item");
				party.getSprite("banner").setBrush(nearest_base.getBanner());
				party.setAttackableByAI(false);
				local c = party.getController();
				local patrol = this.new("scripts/ai/world/orders/patrol_order");
				patrol.setWaitTime(20.0);
				c.addOrder(patrol);
				this.Contract.m.UnitsSpawned.push(party.getID());
				this.Contract.m.LastHelpTime = this.Time.getVirtualTimeF() + this.Math.rand(10, 40);
				this.Flags.set("HelpReceived", 0);
				local r = this.Math.rand(1, 100);

				if (r <= 15)
				{
					this.Flags.set("IsAGreaterThreat", true);
					c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives.clear();
				this.Contract.m.BulletpointsObjectives = [
					"Zapoluj na Króla Barbarzyńców i jego armię",
					"Jego armia została ostatnio widziana w okolicach regionu %region%, %terrain% na %direction% od ciebie, w pobliżu %nearest_town%"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onCombatWithKing.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					this.Contract.setState("Return");
				}
				else if (!this.Contract.isPlayerNear(this.Contract.m.Destination, 600) && this.Flags.get("HelpReceived") < 4 && this.Time.getVirtualTimeF() >= this.Contract.m.LastHelpTime + 70.0)
				{
					this.Contract.m.LastHelpTime = this.Time.getVirtualTimeF() + this.Math.rand(0, 30);
					this.Contract.setScreen("Directions");
					this.World.Contracts.showActiveContract();
				}
				else if (!this.Contract.isPlayerNear(this.Contract.m.Destination, 600) && this.Flags.get("HelpReceived") == 4)
				{
					this.Contract.setScreen("GiveUp");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatWithKing( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;

				if (!_dest.isInCombat() && !this.Flags.get("IsKingEncountered"))
				{
					this.Flags.set("IsKingEncountered", true);

					if (this.Flags.get("IsAGreaterThreat"))
					{
						this.Contract.setScreen("AGreaterThreat1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("Approach");
						this.World.Contracts.showActiveContract();
					}
				}
				else
				{
					this.Flags.set("IsAGreaterThreat", false);
					_dest.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(true);
					local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					properties.Music = this.Const.Music.BarbarianTracks;
					this.World.Contracts.startScriptedCombat(properties, this.Contract.m.IsPlayerAttacking, true, true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_GreaterThreat",
			function start()
			{
				this.Contract.m.BulletpointsObjectives.clear();
				this.Contract.m.BulletpointsObjectives = [
					"Podróżuj z Królem Barbarzyńców, by zmierzyć się wspólnie z większym zagrożeniem"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.setFaction(2);
					this.World.State.setEscortedEntity(this.Contract.m.Destination);
				}
			}

			function update()
			{
				if (this.Flags.get("IsContractFailed"))
				{
					if (this.Contract.m.Threat != null && !this.Contract.m.Threat.isNull())
					{
						this.Contract.m.Threat.getController().clearOrders();
					}

					if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
					{
						this.Contract.m.Destination.getController().clearOrders();
						this.Contract.m.Destination.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getID());
					}

					this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
					this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Company broke a contract");
					this.World.Contracts.finishActiveContract(true);
					return;
				}

				if (this.Contract.m.Threat == null || this.Contract.m.Threat.isNull() || !this.Contract.m.Threat.isAlive())
				{
					this.Contract.setScreen("AGreaterThreat5");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					if (!this.Contract.m.IsEscortUpdated)
					{
						this.World.State.setEscortedEntity(this.Contract.m.Destination);
						this.Contract.m.IsEscortUpdated = true;
					}

					this.World.State.setCampingAllowed(false);
					this.World.State.getPlayer().setPos(this.Contract.m.Destination.getPos());
					this.World.State.getPlayer().setVisible(false);
					this.World.Assets.setUseProvisions(false);
					this.World.getCamera().moveTo(this.World.State.getPlayer());

					if (!this.World.State.isPaused())
					{
						this.World.setSpeedMult(this.Const.World.SpeedSettings.FastMult);
					}

					this.World.State.m.LastWorldSpeedMult = this.Const.World.SpeedSettings.FastMult;
				}

				if (this.Contract.isPlayerAt(this.Contract.m.Threat))
				{
					this.Contract.setScreen("AGreaterThreat4");
					this.World.Contracts.showActiveContract();
				}
			}

			function end()
			{
				this.World.State.setCampingAllowed(true);
				this.World.State.setEscortedEntity(null);
				this.World.State.getPlayer().setVisible(true);
				this.World.Assets.setUseProvisions(true);

				if (!this.World.State.isPaused())
				{
					this.World.setSpeedMult(1.0);
				}

				this.World.State.m.LastWorldSpeedMult = 1.0;
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("IsContractFailed", true);
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
					if (this.Flags.get("IsAGreaterThreat"))
					{
						this.Contract.setScreen("Success2");
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% kręci cienką koroną na palcu. To tani kawałek metalu, ale bez wątpienia korona z jakiegoś miejsca. Mierzy cię wzrokiem od stóp do głów, gdy blacha skrobie mu po paznokciu i wraca z powrotem.%SPEECH_ON%Podejrzewam, że powinienem był się tego spodziewać. Ludzie szukają władzy, a ci wykuci z barbarzyńskiego żelaza nie różnią się niczym.%SPEECH_OFF%Pozwala, by korona zsunęła się na kostki, gdzie zwisa bezwładnie.%SPEECH_ON%Barbarzyńcy na %direction% w regionie %region% jednoczą się pod tzw. królem. Dziki, tak silny i wredny, że grozi zebraniem hordy, a potem, no cóż, podejrzewam, że zechce rozszerzyć swoje władztwo na południe. Musisz iść do tego regionu, znaleźć go i go uciszyć.%SPEECH_OFF% | Jeden z służących %employer% zaprowadza cię do ogrodu, gdzie widzisz go przy krzaku pomidorów. Przycina je nożycami do kóz i przytakuje własnej robocie. Mówi swobodnie.%SPEECH_ON%Moi zwiadowcy mówią, że w %region% północny dzikus gromadzi armię. Zbiór idiotów nie jest niczym niezwykłym u tych prymitywów, ale ten ogłasza się królem. A królowie, no cóż, chcą być suzerenami czegoś większego niż tylko to, co mają. Chcą tego, co mają inni. Tego, co mam ja.%SPEECH_OFF%Mężczyzna przystaje i kiwa ci głową.%SPEECH_ON%Musisz iść do regionu %region%, znaleźć tego rzekomego dzikiego króla i go zabić. Nie będzie łatwo, ale dostaniesz sowitą zapłatę.%SPEECH_OFF% | %employer% jest otoczony swoimi porucznikami. Ci krzywią się na twój widok, ale %employer% ignoruje ich oceny i podejmuje decyzje sam.%SPEECH_ON%Ach, najemniku, sądzę, że to właśnie ciebie szukałem. Barbarzyńca w %region% ogłosił się królem. Nawet nosi jakąś koronę, pewnie z kości i poroża, ale liczy się kształt i znaczenie. Nie tylko dla niego, lecz i dla nas. Nie możemy pozwolić mu żyć. Musisz odnaleźć tego prymitywa i go zgładzić, zanim zbierze armię zbyt dużą, by moi porucznicy mogli sobie z nią poradzić.%SPEECH_OFF% | %employer% wita cię kuflem ale. Sam popija wino z kielicha.%SPEECH_ON%Sprowadziłem cię tu, bo w regionie %region% jest pewien prymityw, który musi zginąć. Nazywa siebie królem, heh, suzerenem dzikusów. Nie szanuję jego królewskiej władzy ani odrobinę, ale rozpoznaję rodzące się zagrożenie. Nie mogę czekać, aż ten barbarzyńca zbierze wioski i stworzy armię. Musisz go znaleźć i zabić. To nie będzie łatwe, ale zostaniesz dobrze opłacony.%SPEECH_OFF%Zaczynasz się zastanawiać, czy nie dolewa ci ale, by rozluźnić cię na tyle, byś przyjął to niedorzeczne zadanie. | %employer% trzyma parę jelenich poroży, a u podstawy wciąż tkwi korona. Gdy kładzie je na biurku, stoją pionowo, jakby wciąż były przytwierdzone do swojego nosiciela.%SPEECH_ON%Wieści niosą, że dziki w %region% gromadzi armię. Ogłasza się królem i jeśli zdoła zebrać tych prymitywów pod swoim sztandarem, to bez wątpienia stanie się cholernie groźny. A to znaczy, że wpadniemy w niezłe g... lada chwila, jeśli się nim nie zajmiemy.%SPEECH_OFF%Mężczyzna przewraca poroże, a to opada na czubki z głuchym stukotem.%SPEECH_ON%Właśnie po to tu jesteś, najemniku. Musisz odnaleźć tego barbarzyńcę i go skończyć, zanim wpadnie na mądrzejsze pomysły, kto jest, a kto nie jest jego suzerenem.%SPEECH_OFF% | %employer% siedzi na krześle z zaciśniętymi ustami. Obraca sztylet w palcach, a jego czubek żłobi dołek w blacie.%SPEECH_ON%Moi zwiadowcy na %direction% zaczęli znikać jakiś czas temu. Potem ocaleni zaczęli wracać i przynosić opowieści o barbarzyńcy, który ogłosił się królem %region%. Czy muszę wyjaśniać, w czym problem z dzikim, który ogłasza się władcą hordy prymitywów?%SPEECH_OFF%Mówisz mu, że wyobrażasz sobie, jak spędza przez to noce bez snu. %employer% uśmiecha się.%SPEECH_ON%Tak, właśnie tak. Potrzebuję więc takiego człowieka jak ty, silnego, porządnego, cywilizowanego najemnika. Musisz odnaleźć tego rzekomego króla i go zabić, zanim poprowadzi tych cholernych idiotów pod swoim sztandarem.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{O ilu koronach konkretnie mówimy? | To nie będzie lekkie zadanie. | Może dam się przekonać za odpowiednią kwotę. | Lepiej, żeby tego typu zadanie było dobrze płatne.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Nie będziemy się mierzyć z całą armią. | Nie takie roboty szukamy. | Nie będę ryzykować całej kompanii przeciwko takiemu wrogowi.}",
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
			ID = "Directions",
			Title = "W trakcie podróży...",
			Text = "{[img]gfx/ui/events/event_59.png[/img]Tłum uchodźców mija kompanię. Plotki niosą, że król barbarzyńców jest %distance% na %direction%. Wiele osób na drodze jest z %nearest_town% i zdaje się nie mieć zamiaru czekać, aż spadnie na nich morze dzikusów. | [img]gfx/ui/events/event_41.png[/img]Handlarz z pustym wozem przecina waszą drogę. Choć nie ma nic do sprzedania, mówi, że na drogach krążą plotki o dzikusie, który nazywa się królem. Twierdzi, że barbarzyńca jest gdzieś na %direction% stąd, w okolicach %region%. Kiwie ci w stronę twojej trasy.%SPEECH_ON%Jeśli ci po drodze, to dajcie tym prymitywnym skurwielom porządne lanie.%SPEECH_OFF% | [img]gfx/ui/events/event_94.png[/img]Na poboczu siedzący po turecku półnagi mężczyzna. Mówi, że prymityw z armią spalił jego zagrodę, skrzywdził kobiety i pozabijał wszystkich mężczyzn.%SPEECH_ON%Przetrwałem, chowając się w krzakach z dłońmi na ustach.%SPEECH_OFF%Ociera nos.%SPEECH_ON%Widziałem was z bronią. Jeśli szukacie tego barbarzyńcy, mogę powiedzieć, że wyglądało na to, że poszli na %direction% stąd, przez %terrain%, %distance% do %region%.%SPEECH_OFF% | [img]gfx/ui/events/event_94.png[/img]Znajdujecie spalone szczątki małej osady. Kilku ocalałych wlecze się po okolicy, ich sylwetki są tak wyraźne jak dym unoszący się z ruin. Jeden mówi, że przyszedł mężczyzna udający króla, zabił wszystkich, którzy wpadli mu w ręce, a potem ruszył na %direction%. | [img]gfx/ui/events/event_60.png[/img]Natykacie się na wywrócone wozy i płonące wozy. Są puste, towar zniknął, zostały tylko zwłoki właścicieli. Kilkoro dzieci grzebie w gruzach jednego z takich wraków. Gdy pytasz, kto to zrobił, bezczelny chłopak odzywa się.%SPEECH_ON%Dzikusy z północy, ale teraz idą na %direction%. Widziałem ich. Są na %terrain%, %distance% stąd, tak sądzę.%SPEECH_OFF%Kopie w nosie.%SPEECH_ON%To zabójcy, tak na marginesie. Trochę jak wy, ale więksi. Pewnie silniejsi.%SPEECH_OFF% | [img]gfx/ui/events/event_76.png[/img]Zwiadowca %employer% spotyka was na drodze. Melduje, że król barbarzyńców był widziany w okolicach %region% na %direction% po %terrain%. Jest %distance%. Pytasz, czy dołączy do walki, ale ten się śmieje.%SPEECH_ON%Nie, panie, dziękuję. Biegam, patrzę, składam meldunki. A po drodze rucham jedną czy dwie dziwki. To dobre życie i nie potrzebuję waszych najemniczych zwyczajów, żeby mi je psuć!%SPEECH_OFF%I dobrze. | [img]gfx/ui/events/event_132.png[/img]%randombrother% dostrzega ich pierwszy. Ślady potyczki, zwęglone zwłoki, zatarte ślady stóp i kolein, tyle ich, że jasne jest, iż przeszła tędy armia.%SPEECH_ON%Wygląda na to, że po bitwie poszli na %direction%, kapitanie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Jesteśmy na jego tropie.",
					function getResult()
					{
						this.Flags.increment("HelpReceived", 1);
						this.Contract.getActiveState().start();
						this.World.Contracts.updateActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "GiveUp",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{Nie ma już wątpliwości. Po wszystkich znakach, na które trafiłeś, i wszystkich raportach, które otrzymałeś, w końcu wiesz dokładnie, dokąd zmierza Król Barbarzyńców i jego horda. Zostało tylko jedno: stawić mu czoła.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Powinniśmy się pospieszyć.",
					function getResult()
					{
						this.Flags.increment("HelpReceived", 1);
						this.Contract.m.Destination.setVisibleInFogOfWar(true);
						this.World.getCamera().moveTo(this.Contract.m.Destination);
						this.Contract.getActiveState().start();
						this.World.Contracts.updateActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Approach",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_135.png[/img]{Król Barbarzyńców wychodzi na pole ze swoim hufcem, bandą przerośniętych łotrów, warczących wojowników, speszonych niewolników i wyjących kobiet. To armia człowieka, który zebrał z tej ziemi każdy skrawek zasobów i każdy cal przewagi, i bez wątpienia zbierze też samą cywilizację, tak jak zwykła kula śniegu staje się lawiną. Przygotowujesz ludzi do walki. | Horda Króla Barbarzyńców toczy się przez ziemię bez śladu szkolenia, bez nawet pozorów formacji. Ale wiesz, że jednym machnięciem ręki dzikus może wypuścić na wrogów hordę zabójców, którzy mają aż nadto krwawej siły, by nadrobić wszelki brak spójności. Przygotowujesz ludzi do walki. | Horda dzikusów jest jak sen gorączkowy, formuje się na horyzoncie niczym wędrowcy z każdego zakątka świata, ubrani nie w mundury czy zbroje, lecz w karykatury tych, których podbili. Wojownicy z sukniami ślubnymi owiniętymi wokół ramion, długie płaszcze w królewskich barwach na ludziach bez statusu, niektórzy w żebrach i stukoczących kościach, jakby zabrali to z ostatniego rabunku. Byli tylko rolnikami grozy, wioski ich plonem, a wojna żniwem na wszystkie pory roku.\n\nKręcisz głową na ten widok i przygotowujesz ludzi do walki.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						this.Contract.getActiveState().onCombatWithKing(this.Contract.m.Destination, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_145.png[/img]{Król Barbarzyńców nie żyje. Choć przybrał tytuł królewski, leży wśród poległych jak każdy z jego ludzi. Dzikus. Prymityw. Z nieco twardszym ciałem i paroma ozdobami typowymi dla jego wojen, rabunków i rzezi. Niewiele go wyróżnia. Rąbiesz mieczem w jego szyję i stawiasz but na twarzy, gdy odcinasz głowę czysto od ramion. %randombrother% 2 bierze ciężką głowę i wrzuca ją do worka. Rozkazujesz ludziom przeszukać pole, co się da, a potem szykować się na powrót do %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{%companyname% wciąż żyje! | Zwycięstwo!}",
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
			ID = "AGreaterThreat1",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_136.png[/img]{Znajdujesz Króla Barbarzyńców, ale dochodzi do pertraktacji. Król Barbarzyńców i starszy wychodzą na pole, by spotkać się z tobą osobiście. Wbrew rozsądkowi wychodzisz im naprzeciw. Król mówi, a starszy tłumaczy.%SPEECH_ON%Nie przyszliśmy podbijać, lecz pokonać Wielkie Niepożądane.%SPEECH_OFF%Podejrzewając problem w tłumaczeniu, prosisz o wyjaśnienia. Król i starszy kontynuują.%SPEECH_ON%Śmierć opuściła te ziemie, a bez niej zabity człowiek gubi się między światami i powstaje na nowo. Horda Niepożądanych, nieumarłych, maszeruje. Nie przyszliśmy po ciebie ani po twoich możnych. Jeśli pomożesz nam ich zniszczyć, opuścimy te ziemie i nie będziemy nękać twoich ludzi. Tylko Niepożądani.%SPEECH_OFF%%randombrother% pochyla się i szepcze.%SPEECH_ON%Możemy do nich dołączyć, jasne, ale możemy też po prostu zaatakować ich teraz. Widać, że nie są w pełni sił, a cokolwiek tutaj mówią, faktem jest, że i tak pustoszą te ziemie, bo to prymitywne dzikusy, panie, a gwałt i rabunek mają we krwi.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zaatakujemy ich i wyzwolimy północ od tego samozwańczego króla.",
					function getResult()
					{
						return "AGreaterThreat2";
					}

				},
				{
					Text = "Dołączymy do nich i razem ruszymy przeciw Niepożądanym.",
					function getResult()
					{
						return "AGreaterThreat3";
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "AGreaterThreat2",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_136.png[/img]{Spluwasz i kiwasz głową w stronę starszego.%SPEECH_ON%Mijaliśmy spalone domy, zgwałcone kobiety i zabitych mężczyzn tylko po to, żeby dotrzeć do waszej żałosnej zgrai, a teraz chcecie się łączyć? Nie jesteśmy sojusznikami. Nie jesteśmy przyjaciółmi. Powiedz swojemu \'Królowi\', żeby modlił się do tych swoich gó...%SPEECH_OFF%Starszy podnosi dłoń i rozmawia z królem w ich języku. Obaj kiwają głowami, odwracają się i odchodzą. %randombrother% śmieje się.%SPEECH_ON%Zwięzłość jest duszą pogardy, kapitanie.%SPEECH_OFF%Każesz mu wracać na linię i przygotować się do nadchodzącej walki.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Przygotować się do bitwy.",
					function getResult()
					{
						this.Flags.set("IsAGreaterThreat", false);
						this.Contract.getActiveState().onCombatWithKing(this.Contract.m.Destination, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "AGreaterThreat3",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_136.png[/img]{Kiwasz głową w stronę starszego.%SPEECH_ON%Dobrze, współpracujemy z wami, by poradzić sobie z tym większym zagrożeniem.%SPEECH_OFF%Starszy uśmiecha się, pociera kciuki i wypowiada kilka zwrotów w swoim języku. Król Barbarzyńców uderza pięścią w pierś, potem klepie cię nią w ramię, po czym zatacza ręką łuk po niebie. Śmiejąc się, starszy wyjaśnia.%SPEECH_ON%Więc walczymy razem, ale jeśli polegniemy, on nie będzie walczył u twojego boku jako nieumarły. Jeśli zginie, Król odnajdzie samą Śmierć i położy jej kosę na własnym karku.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "PRzygotować się do wymarszu.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				local playerTile = this.World.State.getPlayer().getTile();
				local nearest_undead = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getNearestSettlement(playerTile);
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 9, 15);
				local party = this.World.FactionManager.getFaction(nearest_undead.getFaction()).spawnEntity(tile, "Niepoք\x0380dani", false, this.Const.World.Spawn.UndeadArmy, 260 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.getSprite("banner").setBrush(nearest_undead.getBanner());
				party.setDescription("Legion chodzących trupów, którzy powrócili, by odebrać żywym to, co niegdyś należało do nich.");
				party.setSlowerAtNight(false);
				party.setUsingGlobalVision(false);
				party.setLooting(false);
				this.Contract.m.UnitsSpawned.push(party);
				this.Contract.m.Threat = this.WeakTableRef(party);
				party.setAttackableByAI(false);
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(99999);
				c.addOrder(wait);
				this.Contract.m.Destination.setFaction(2);
				this.Contract.m.Destination.getSprite("selection").Visible = false;
				this.Contract.m.Destination.setOnCombatWithPlayerCallback(null);
				c = this.Contract.m.Destination.getController();
				c.clearOrders();
				local move = this.new("scripts/ai/world/orders/move_order");
				move.setDestination(party.getTile());
				c.addOrder(move);
				this.Contract.setState("Running_GreaterThreat");
			}

		});
		this.m.Screens.push({
			ID = "AGreaterThreat4",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_73.png[/img]{Dzikusy nie kłamały: pradawni wystawili armię. To horda z rozkładających się twarzy i zardzewiałych pancerzy, zgraja jęczących, zawodzących potworów, na które światło pada i natychmiast wsiąka. To z pewnością armia ciemności. Gdybyś ty albo barbarzyńcy walczyli z nią sami, na pewno byście przegrali, ale razem wciąż macie szansę!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Przygotować się do bitwy.",
					function getResult()
					{
						this.World.Contracts.showCombatDialog(false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "AGreaterThreat5",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_136.png[/img]{Pradawni umarli zostali zgładzeni co do jednego. Gdy twoi ludzie i prymitywy przeszukują pole, Król Barbarzyńców i starszy podchodzą do ciebie. Wielki wojownik kiwa głową i warczy, a starszy tłumaczy.%SPEECH_ON%Mówi, że poszło wam dobrze, bardzo dobrze, i że chciałby, aby ludzie tacy jak ty i twoja kompania walczyli u jego boku, ale rozumie, że to niemożliwe. Żyjemy w labiryncie wielu światów i w tym labiryncie wszyscy pozostaniemy, zagubieni, czasem słysząc nawzajem swoje okrzyki, nigdy nie mając dość czasu, by się poznać. Dziękuje. I życzy wam dobrze.%SPEECH_OFF%Odwracasz się do starszego i pytasz, czy wszystko to wyczytał z prostego warknięcia. Starszy uśmiecha się.%SPEECH_ON%Warknięcie, tak, i przyjaźń na całe życie. Podróżujcie dobrze, człowieku miecza.%SPEECH_OFF%Starszy podaje ci rogaty hełm, ten sam, który czasem nosił sam Król Barbarzyńców. Nic nie mówi, tylko uderza w pierś i wskazuje niebo - i na tym koniec.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Żegnaj, królu.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull() && this.Contract.m.Destination.isAlive())
				{
					this.Contract.m.Destination.die();
					this.Contract.m.Destination = null;
				}

				local item = this.new("scripts/items/helmets/barbarians/heavy_horned_plate_helmet");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%employer% wyjmuje głowę Króla Barbarzyńców i toczy ją z worka. Toczy się swobodnie, przewracając tace z kielichami, które rozbiegają się i grzechoczą po podłodze. Nawet po śmierci dzikus sieje chaos.%SPEECH_ON%Dziękuję, najemniku.%SPEECH_OFF%Mówi twój zleceniodawca, kiwając sam do siebie, gdy ustawia głowę i opiera ją o zwis szyi.%SPEECH_ON%Jaki obrzydliwy kundel, co? Spójrz na te zęby. Spójrz! Dziury w zębach. Ohydne.%SPEECH_OFF%Każesz mu zapłacić i robi to zgodnie z umową. Ale wciąż kręci głową, pokazuje własne zęby i udaje, że je skubie.%SPEECH_ON%Jak się czyści takie zęby? Liną?%SPEECH_OFF%Wzruszasz ramionami i wychodzisz, nie fatygując się, by powiedzieć %employer%, że pierwsze, co twoi ludzie zrobili z tą przeklętą głową, to wydłubali nożem złoto z jej ust. | Rzucasz głowę Króla Barbarzyńców na stół %employer%. Patrzy na nią, potem na ciebie.%SPEECH_ON%To największa pieprzona głowa, jaką kiedykolwiek widziałem.%SPEECH_OFF%Kiwając głową, prosisz o zapłatę i dostajesz w odpowiedniej kwocie. Zleceniodawca zaczyna obracać twarz dzikusa, jakby był czarnoksiężnikiem szukającym jego tajemnic.%SPEECH_ON%Założę się, że stąd wzięły się opowieści o ograch, co? Dziecko widzi takiego obrzydliwca i już, wyobraźnia zapala, a potwór się rodzi.%SPEECH_OFF%Gdyby to było takie proste. | Nawet bez ogromnego ciała głowa Króla Barbarzyńców robi wrażenie, gdy pokazujecie ją %employer%. Gromada szlachty i służby ach i och na jej rozmiar. Mężczyzna w czarnej szacie szybko wypłaca ci należność. Sam %employer% podnosi głowę i podrzuca ją w górę, jakby chciał zważyć.%SPEECH_ON%Na starych bogów, ależ ona ciężka! Hej, %randomname%.%SPEECH_OFF%Służący podchodzi. Zleceniodawca uśmiecha się.%SPEECH_ON%Przynieś mi pikę. Wzniesiemy tę potworną głowę wysoko ku niebu.%SPEECH_OFF%Odpowiedni koniec dla dzikusa. | Zaledwie chwile po tym, jak dajesz %employer% głowę Króla Barbarzyńców, staje się zabawką. Dzieci szlachciców turlają ją po kamiennej posadzce, a głowa dzikusa przewraca ściany kielichów i fortece tac obiadowych. Pies szczeka, podążając za głową tam i z powrotem. %employer% klepie cię po ramieniu.%SPEECH_ON%Znakomita robota, najemniku. Naprawdę. Moi zwiadowcy mówią, że to była cholernie ciężka walka, że byliście niemal jak prymitywy. Ale chyba tak musiało być, prawda? Dzikus przeciw dzikusowi? Duch takiej prymitywności nie mieści się w naszych cywilizowanych ramach!%SPEECH_OFF%Jedno z dzieci kopie Króla w twarz, łamie szczękę i rozcina sobie stopę o zęby. Dziecko krzyczy o pomoc, a pies, być może broniąc swojego pana, rzuca się na głowę i zaczyna ciągnąć ją za zwis szyi. %employer% znowu się uśmiecha.%SPEECH_ON%Zapłata czeka na zewnątrz. W pełni, jak obiecałem.%SPEECH_OFF% | Mężczyzna w rycerskiej zbroi odbiera od ciebie głowę Króla Barbarzyńców. Natychmiast dobywasz miecza, ale %employer% wskakuje, by zdusić zarzewie przemocy.%SPEECH_ON%Hej, najemniku, wszystko w porządku. Twoja zapłata, jak obiecano.%SPEECH_OFF%Mężczyzna podaje ci sakiewkę koron, lecz za nim widzisz, jak głowa trafia do człowieka w czarnym płaszczu. Kiwasz głową i pytasz, co zamierzają z nią zrobić. %employer% uśmiecha się.%SPEECH_ON%Szczerze mówiąc, steiny czekają, najemniku, a ja jestem spragniony.%SPEECH_OFF%Mężczyzna szybko mija cię; nie widzisz żadnego ale ani żadnego trunku, po prostu idzie za człowiekiem w płaszczu. | %employer% patrzy na głowę Króla Barbarzyńców jak kot wpatruje się złośliwie we wszystko, co nie jest nim samym.%SPEECH_ON%Interesujące. Myślę, że ją wypcham i postawię na kominku.%SPEECH_OFF%Wtrącasz, przypominając mu, że mówi o głowie człowieka. %employer% wzrusza ramionami.%SPEECH_ON%I co z tego? To potworność. Nie ma współistnienia między cywilizowanym a dzikim. Mając to odpowiednio przygotowane, będę nad tym rozmyślać. Co zrobisz? Znowu mnie pouczysz?%SPEECH_OFF%Zaciskasz usta i prosisz o zapłatę. Mężczyzna wskazuje róg.%SPEECH_ON%W sakiewce tam. Dobrze się spisałeś, najemniku, ale nie zwracaj się do mnie w ten sposób ponownie. Dobrego dnia.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Zasłużyliśmy sobie.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Zabiłeś samozwańczego króla barbarzyńców");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local money = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%employer% wita cię bez entuzjazmu.%SPEECH_ON%Wiesz, że mam zwiadowców i szpiegów wszędzie, prawda?%SPEECH_OFF%Podnosisz puste dłonie i mówisz, że nie miałeś zamiaru kłamać. \'Król barbarzyńców\' nie będzie już nękał tych ziem. Zleceniodawca kilka razy stuka palcami i kiwa głową.%SPEECH_ON%Twoja szczerość jest odświeżająca, choć muszę przyznać, że szkoda, iż on i jego horda wciąż żyją. To powiedziawszy, wszystkie raporty sugerują, że oddalają się, więc twoja robota i tak jest wykonana, z tłustą pogańską głową czy bez niej. Twoja zapłata, jak uzgodniono.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Zasłużyliśmy sobie.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Rozwiązałeś zagrożenie samozwańczego króla barbarzyńców");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local money = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] koron"
				});
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull() && this.m.Destination.isAlive())
		{
			local distance = this.World.State.getPlayer().getTile().getDistanceTo(this.m.Destination.getTile());
			distance = this.Const.Strings.Distance[this.Math.min(this.Const.Strings.Distance.len() - 1, distance / 30.0 * (this.Const.Strings.Distance.len() - 1))];
			local region = this.World.State.getRegion(this.m.Destination.getTile().Region);
			local settlements = this.World.EntityManager.getSettlements();
			local nearest;
			local nearest_dist = 9999;

			foreach( s in settlements )
			{
				local d = s.getTile().getDistanceTo(this.m.Destination.getTile());

				if (d < nearest_dist)
				{
					nearest = s;
					nearest_dist = d;
				}
			}

			_vars.push([
				"region",
				region.Name
			]);
			_vars.push([
				"nearest_town",
				nearest.getName()
			]);
			_vars.push([
				"distance",
				distance
			]);
			_vars.push([
				"direction",
				this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Destination.getTile())]
			]);
			_vars.push([
				"terrain",
				this.Const.Strings.Terrain[this.m.Destination.getTile().Type]
			]);
		}
		else
		{
			local nearest_base = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getNearestSettlement(this.World.State.getPlayer().getTile());
			local region = this.World.State.getRegion(nearest_base.getTile().Region);
			_vars.push([
				"region",
				region.Name
			]);
			_vars.push([
				"nearest_town",
				""
			]);
			_vars.push([
				"distance",
				""
			]);
			_vars.push([
				"direction",
				this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(region.Center)]
			]);
			_vars.push([
				"terrain",
				this.Const.Strings.Terrain[region.Type]
			]);
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.World.State.setCampingAllowed(true);
			this.World.State.setEscortedEntity(null);
			this.World.State.getPlayer().setVisible(true);
			this.World.Assets.setUseProvisions(true);

			if (!this.World.State.isPaused())
			{
				this.World.setSpeedMult(1.0);
			}

			this.World.State.m.LastWorldSpeedMult = 1.0;
			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		return true;
	}

	function onIsTileUsed( _tile )
	{
		return false;
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

		if (this.m.Threat != null && !this.m.Threat.isNull())
		{
			_out.writeU32(this.m.Threat.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local obj = _in.readU32();

		if (obj != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(obj));
		}

		obj = _in.readU32();

		if (obj != 0)
		{
			this.m.Threat = this.WeakTableRef(this.World.getEntityByID(obj));
		}

		this.contract.onDeserialize(_in);
	}

});

