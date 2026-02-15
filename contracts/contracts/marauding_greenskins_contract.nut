this.marauding_greenskins_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Objective = null,
		Target = null,
		IsPlayerAttacking = true,
		LastRandomEventShown = 0.0
	},
	function setObjective( _h )
	{
		if (typeof _h == "instance")
		{
			this.m.Objective = _h;
		}
		else
		{
			this.m.Objective = this.WeakTableRef(_h);
		}
	}

	function setOrcs( _o )
	{
		this.m.Flags.set("IsOrcs", _o);
	}

	function create()
	{
		this.contract.create();
		this.m.Type = "contract.marauding_greenskins";
		this.m.Name = "Grasujący Zielonoskórzy";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
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

		local myTile = this.m.Origin.getTile();
		local orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(myTile);
		local goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(myTile);

		if (myTile.getDistanceTo(orcs.getTile()) + this.Math.rand(0, 8) < myTile.getDistanceTo(goblins.getTile()) + this.Math.rand(0, 8))
		{
			this.m.Flags.set("IsOrcs", true);
		}
		else
		{
			this.m.Flags.set("IsOrcs", false);
		}

		local bestDist = 9000;
		local best;
		local settlements = this.World.EntityManager.getSettlements();

		foreach( s in settlements )
		{
			if (s.isMilitary() || s.isSouthern() || !s.isDiscovered())
			{
				continue;
			}

			if (s.getID() == this.m.Origin.getID() || s.getID() == this.m.Home.getID())
			{
				continue;
			}

			local d = this.getDistanceOnRoads(s.getTile(), this.m.Origin.getTile());

			if (d < bestDist)
			{
				bestDist = d;
				best = s;
			}
		}

		if (best != null)
		{
			local distance = this.getDistanceOnRoads(best.getTile(), this.m.Origin.getTile());
			this.m.Flags.set("MerchantReward", this.Math.max(150, distance * 5.0 * this.getPaymentMult()));
			this.setObjective(best);
			this.m.Flags.set("MerchantID", best.getFactionOfType(this.Const.FactionType.Settlement).getRandomCharacter().getID());
		}

		this.m.Payment.Pool = 800 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Zabij zielonoskórych grasujących w pobliżu %origin%"
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

				if (r <= 5 && this.World.Assets.getBusinessReputation() >= 2250)
				{
					if (this.Flags.get("IsOrcs") == true)
					{
						this.Flags.set("IsWarlord", true);
					}
					else
					{
						this.Flags.set("IsShaman", true);
					}
				}
				else if (r <= 10 && this.Contract.m.Objective != null)
				{
					this.Flags.set("IsMerchant", true);
				}

				local originTile = this.Contract.m.Origin.getTile();
				local tile = this.Contract.getTileToSpawnLocation(originTile, 5, 10);
				local party;

				if (this.Flags.get("IsOrcs"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).spawnEntity(tile, "Orkowie Maruderzy", false, this.Const.World.Spawn.OrcRaiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("Banda złowrogich orków, zielonoskórych i górujących nad każdym człowiekiem.");
					party.getLoot().ArmorParts = this.Math.rand(0, 25);
					party.getLoot().Ammo = this.Math.rand(0, 10);
					party.addToInventory("supplies/strange_meat_item");
					local enemyBase = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(this.Contract.getOrigin().getTile());
					party.getSprite("banner").setBrush(enemyBase.getBanner());
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).spawnEntity(tile, "Goblińscy NajeЄdЄcy", false, this.Const.World.Spawn.GoblinRaiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("Banda złośliwych goblinów, małych, acz przebiegłych i których nigdy nie można lekceważyć.");
					party.getLoot().ArmorParts = this.Math.rand(0, 10);
					party.getLoot().Medicine = this.Math.rand(0, 2);
					party.getLoot().Ammo = this.Math.rand(0, 30);
					local r = this.Math.rand(1, 4);

					if (r == 1)
					{
						party.addToInventory("supplies/strange_meat_item");
					}
					else if (r == 2)
					{
						party.addToInventory("supplies/roots_and_berries_item");
					}
					else if (r == 3)
					{
						party.addToInventory("supplies/pickled_mushrooms_item");
					}

					local enemyBase = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(this.Contract.getOrigin().getTile());
					party.getSprite("banner").setBrush(enemyBase.getBanner());
				}

				this.Contract.m.UnitsSpawned.push(party.getID());
				this.Contract.m.Target = this.WeakTableRef(party);
				party.setAttackableByAI(false);
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Origin);
				roam.setMinRange(3);
				roam.setMaxRange(8);
				roam.setAllTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
				roam.setTerrain(this.Const.World.TerrainType.Shore, false);
				roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
				c.addOrder(roam);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
				}

				this.Contract.m.Origin.getSprite("selection").Visible = true;
			}

			function update()
			{
				local playerTile = this.World.State.getPlayer().getTile();

				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					if (this.Flags.get("IsMerchant") && this.Contract.m.Objective != null && !this.Contract.m.Objective.isNull())
					{
						this.Contract.setScreen("Merchant");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsOrcs"))
					{
						this.Contract.setScreen("BattleWonOrcs");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Return");
					}
					else
					{
						this.Contract.setScreen("BattleWonGoblins");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Return");
					}
				}
				else if (playerTile.getDistanceTo(this.Contract.m.Target.getTile()) <= 10 && this.Contract.m.Target.isHiddenToPlayer() && this.Time.getVirtualTimeF() - this.Contract.m.LastRandomEventShown >= 30.0 && this.Math.rand(1, 1000) <= 1)
				{
					this.Contract.m.LastRandomEventShown = this.Time.getVirtualTimeF();

					if (!this.Flags.get("IsBurnedFarmsteadShown") && playerTile.Type == this.Const.World.TerrainType.Plains || playerTile.Type == this.Const.World.TerrainType.Hills || playerTile.Type == this.Const.World.TerrainType.Tundra || playerTile.Type == this.Const.World.TerrainType.Steppe)
					{
						this.Flags.set("IsBurnedFarmsteadShown", true);
						this.Contract.setScreen("BurnedFarmstead");
						this.World.Contracts.showActiveContract();
					}
					else if (!this.Flags.get("IsCaravanShown") && playerTile.HasRoad)
					{
						this.Flags.set("IsCaravanShown", true);
						this.Contract.setScreen("DestroyedCaravan");
						this.World.Contracts.showActiveContract();
					}
					else if (!this.Flags.get("IsDeadBodiesOrcsShown") && this.Flags.get("IsOrcs") == true)
					{
						this.Flags.set("IsDeadBodiesOrcsShown", true);
						this.Contract.setScreen("DeadBodiesOrcs");
						this.World.Contracts.showActiveContract();
					}
					else if (!this.Flags.get("IsDeadBodiesGoblinsShown") && this.Flags.get("IsOrcs") == false)
					{
						this.Flags.set("IsDeadBodiesGoblinsShown", true);
						this.Contract.setScreen("DeadBodiesGoblins");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsWarlord") && !this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Const.World.Common.addTroop(this.Contract.m.Target, {
						Type = this.Const.World.Spawn.Troops.OrcWarlord
					}, false);
					this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
					this.Contract.setScreen("Warlord");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsShaman") && !this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Const.World.Common.addTroop(this.Contract.m.Target, {
						Type = this.Const.World.Spawn.Troops.GoblinShaman
					}, false);
					this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
					this.Contract.setScreen("Shaman");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
				}
			}

		});
		this.m.States.push({
			ID = "Running_Merchant",
			function start()
			{
				this.Contract.m.Origin.getSprite("selection").Visible = false;

				if (this.Contract.m.Objective != null && !this.Contract.m.Objective.isNull())
				{
					this.Contract.m.Objective.getSprite("selection").Visible = true;
				}

				this.Contract.m.BulletpointsObjectives = [
					"Odprowadź bezpiecznie kupca do %objective% na %objectivedirection%"
				];
				this.Contract.m.BulletpointsPayment = [];
				this.Contract.m.BulletpointsPayment.push("Otrzymasz %reward_merchant% koron w nagrodę na miejscu");
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Objective))
				{
					this.Contract.setScreen("Success2");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
			}

			function end()
			{
				if (this.Contract.m.Objective != null && !this.Contract.m.Objective.isNull())
				{
					this.Contract.m.Objective.getSprite("selection").Visible = false;
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
				this.Contract.m.BulletpointsPayment = [];

				if (this.Contract.m.Payment.Advance != 0)
				{
					this.Contract.m.BulletpointsPayment.push("Otrzymasz " + this.Contract.m.Payment.getInAdvance() + " koron z góry");
				}

				if (this.Contract.m.Payment.Completion != 0)
				{
					this.Contract.m.BulletpointsPayment.push("Otrzymasz " + this.Contract.m.Payment.getOnCompletion() + " koron po wykonaniu zadania");
				}

				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.Contract.m.Origin.getSprite("selection").Visible = false;
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{Zgarbiona postawa %employer% i okazjonalne jęki wiele mówią o tym, jak mu mija dzień. Masuje skronie, zanim zwraca się do ciebie drżącym głosem. %SPEECH_ON%Horda zielonoskórych terroryzuje i plądruje okolice %origin%. Nie oszczędzają nikogo ani niczego. {Moi ludzie są zbyt przerażeni, by cokolwiek z tym zrobić. | Zbyt wielu moich ludzi błąka się po ziemiach. | Moi ludzie nie zrobią tego bez obscenicznej zapłaty.} Jesteście ostatnią nadzieją ludzi, by powstrzymać te bydlaki. Jeśli pozwolimy im robić, co chcą, możemy już nigdy nie znaleźć czasu na odbudowę!%SPEECH_OFF%Powoli zamyka oczy i wzdycha, po czym kontynuuje.%SPEECH_ON%To zielonoskórzy. Zostawiają tropy, gdziekolwiek pójdą. Nie powinno być trudno ich znaleźć, prawda? Zabijcie ich wszystkich i pomścijcie dobrych ludzi z %origin%!%SPEECH_OFF% | Wpatrując się w okno, %employer% zadaje proste pytanie.%SPEECH_ON%Wiesz, co robi zielonoskóry, gdy dostanie w ręce niemowlę?%SPEECH_OFF%Odwracasz głowę. Strażnik w kącie wzrusza ramionami. Odpowiadasz na pytanie.%SPEECH_ON%Tak.%SPEECH_OFF%Szlachcic kiwa głową do siebie i wraca do biurka, ciężko siadając na krześle.%SPEECH_ON%Jest ich horda, terroryzuje %origin%. Potrzebuję, żebyś ich odnalazł i wszystkich wybił. Ja nie mogę... oni nie mogą... No po prostu ich zabijcie, dobrze?%SPEECH_OFF% | %employer% trzyma świecę blisko jednej ze swych ksiąg, a jego oczy w słabym świetle skupiają się na zapiskach, których nie potrafisz odczytać.%SPEECH_ON%Mówią, że zielonoskórzy mają w tych ziemiach długą, bardzo długą historię. Wierzysz w to?%SPEECH_OFF%Wzruszasz ramionami i odpowiadasz najlepiej jak potrafisz.%SPEECH_ON%Jeśli chcesz przetrwać na tym świecie, musisz walczyć, a zielonoskórzy wyglądają na takich, co są tu od dawna.%SPEECH_OFF%Mężczyzna kiwa głową, jakby docenił twoją uwagę.%SPEECH_ON%Kilku z nich grasuje wokół %origin%. Palą wszystko, na co trafią, zabijają wszystkich... to dość oczywiste, jestem pewien. Równie oczywiste jest to, że potrzebuję ciebie, najemniku, byś ich odnalazł i zniszczył. Jesteś zainteresowany?%SPEECH_OFF% | %employer% śmieje się sam do siebie na krześle - a jednocześnie chowa głowę w dłoniach, jak błazen ukrywający chichot. Niezbyt godny widok dla mężczyzny. Podnosi wzrok na ciebie, ze zmęczonymi oczami.%SPEECH_ON%Zielonoskórzy znów grasują. Nie wiem, gdzie są, tylko gdzie byli. Znasz te znaki, prawda?%SPEECH_OFF%Kiwasz głową i odpowiadasz.%SPEECH_ON%Zostawiają wielkie ślady, i nie mówię tylko o ich stopach.%SPEECH_OFF%Mężczyzna znów się śmieje, ale tym razem z bólem.%SPEECH_ON%Cóż, wyraźnie potrzebuję, żebyś coś z nimi zrobił. Podejmiesz się?%SPEECH_OFF% | %employer% wstaje i podchodzi do okna, zatrzymuje się, kręci głową i wraca do stołu. Powoli, z namysłem siada.%SPEECH_ON%Najpierw dostałem wieści, że to zbóje. Potem usłyszałem, że to najeźdźcy z wybrzeży. Potem ocaleni zaczęli mówić. A teraz wiesz, jaki mam problem?%SPEECH_OFF%Wzruszasz ramionami.%SPEECH_ON%Czy to ma znaczenie?%SPEECH_OFF%Mężczyzna unosi brwi.%SPEECH_ON%Zielonoskórzy, najemniku. To oni. Grasują wokół %origin% i potrzebuję, żebyś ich powstrzymał. Ma to teraz znaczenie?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Moglibyśmy na nich zapolować, o ile zapłata będzie należyta. | Walka z zielonoskórymi tania nie będzie. | Porozmawiajmy o koronach.}",
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
			ID = "DestroyedCaravan",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Karawana. Oczywiście nie w najlepszym stanie. Wozy zostały wywrócone, a ich woźnice zabici. Przepędzasz sępy, by przejrzeć ślady. Jeśli rzeź nie świadczy o zielonoskórych, to zniekształcone odciski stóp już tak. Jesteś na właściwym tropie. | Cóż, ślad zielonoskórych nietrudno było znaleźć. Natrafiasz na linię płonących wozów karawany. Ogień jest świeży, wciąż chętnie pożera drewno. Ciała karawanowych i kupców też są świeże i wyglądają, jakby zginęli w strachu. Idź dalej, a może jeszcze dopadniesz tych zielonych drani. | Z samotnego drzewa zwisa człowiek, jakby spadł z nieba i sam się na nie nabił. Przy pniu leżą dwa martwe osły. Dalej wóz rozbity ze wszystkich stron, koła rozsypane i połamane. Ładunek i towary porozrzucane wszędzie. Stare ognisko lize powietrze, szukając czegoś, co pozwoli mu przetrwać, gdy kurczy się coraz bardziej.\n\n To robota zielonoskórych, nie masz wątpliwości. Niedługo będziesz na nich wpadać.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Musimy być blisko.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BurnedFarmstead",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Strzępy dymu wiją się i wymykają z ruin zagrody. Przy tym, co kiedyś było drzwiami frontowymi, leży ciało. Połowy brakuje. Ta, która została, ma przerażoną twarz, a spalona ręka wyciąga się ku czemuś, lub komuś, kogo już nie ma. W błocie i trawie rozrzucone są ślady stóp. Zielonoskórzy. Jesteś coraz bliżej. | Ta mała zagroda nie miała szans. Znajdujesz zabitych parobków jeden po drugim, z wciąż ściskanymi widłami. Na jednym z zębów jest krew. Zdecydowanie nie ludzka. Podążasz tropem, wiedząc, że wkrótce dopadniesz sprawców tej zbrodni. | Martwy pies. Kolejny. Owczarki, gdyby zgadywać, choć brutalność sprawia, że trudno je rozpoznać. Ich opiekunowie nie są daleko - wygląda na to, że uciekali, podczas gdy psy osłaniały odwrót. Niestety, ślady mówią, że ci rolnicy wpadli na zielonoskórych. Psy dzielnie walczyły, a ich właściciele dzielnie uciekali.\n\nJesteś blisko. Idź dalej, a trafisz na tych drani.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Musimy być blisko.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "DeadBodiesOrcs",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Robotę orka nietrudno rozpoznać: czy wygląda na precyzyjną i dokładną? Jeśli tak, to nie był ork. To, na co patrzysz, to sznur ciał i części ciał, właścicieli i dłużników pomieszanych ze sobą. Zajęłoby tydzień, żeby to wszystko poskładać. Jeśli pójdziesz dalej, na pewno wpadniesz na orki. | Znajdujesz człowieka przeciętego na pół. Innego rozłupanego wzdłuż. Kolejny nie ma głowy, bo została wbita w klatkę piersiową. Następny jest posiniaczony i połamany, a gdy go oglądasz, każda kość w środku chrzęści i porusza się, całkowicie rozbita. To robota orków. Jesteś na ich tropie. | Ciało wygięte jest do tyłu tak, że głowa dotyka pięt. Znajdujesz inne z ogromną dziurą w klatce piersiowej i kolejne, które wygląda, jakby zostało wypatroszone czymś poszarpanym i szorstkim. W niczym nie ma tu czystości. To bez wątpienia robota orków.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wygląda na to, że polujemy na orków.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "DeadBodiesGoblins",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Natrafiasz na mężczyznę opierającego się o drogowskaz. Gdy pytasz, czy widział zielonoskórych, po prostu pochyla się i pada na ziemię. W plecach tkwią mu bełty. To chyba odpowiada na twoje pytanie. I oznacza, że tropisz gobliny, nie orki. | Orki nie zostawiają takich porządków. Znalazłeś serię zabitych chłopów i ich psów. Ale bałaganu jest niewiele. Tu rana kłuta, tam małe przebicie. Tu i tam kilka bełtów. Na grotach trucizna. To robota... goblinów. Nie mogą być daleko. | Mężczyzna leży w trawie, z bełtem w szyi. Jego twarz jest fioletowa, język wysunięty. Dłonie zaciśnięte, niemal jakby kurczowo się obejmował. Robota paskudnej, paraliżującej trucizny, bez wątpienia. I bez wątpienia nie orków, lecz goblinów. Muszą być blisko...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wygląda na to, że polujemy na gobliny.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BattleWonOrcs",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_81.png[/img]{Gdy twoi ludzie powalają ostatniego z orków, rozglądasz się. Zielonoskórzy stawili piekielny opór. Czas sprawdzić kompanię i przygotować powrót do zleceniodawcy, %employer%. | Ludzie %employer% nigdy by nie zrobili tego, co wy właśnie zrobiliście. Tylko %companyname% potrafi poradzić sobie z tymi zielonoskórymi. Jesteś dumny z kompanii, ale starasz się tego nie okazywać. | Bitwa rozstrzygnięta, podobnie jak jeden czy dwa zakłady, które mieli ludzie. Okazuje się, że ork przestaje szczerzyć zęby, gdy oderwiesz mu głowę od karku! Twój zleceniodawca, %employer%, pewnie nie obchodzi się takimi brutalnymi eksperymentami, ale zapłaci ci za dzisiejszą robotę. | Orki walczyły tak, że święci mężowie mogliby nawet nazwać to sprawiedliwym bojem. Ale i tak nie są lepsi od %companyname%, nie tego dnia! | Zleceniodawca, %employer%, chciał, byś zabił zielonoskórych, i dokładnie to zrobiłeś. Czas sprawdzić ludzi i przygotować powrót po ciężko zarobioną zapłatę. | Walka z orkami nigdy nie jest łatwa i ta nie była wyjątkiem. Zapłata %employer% sprawi jednak, że trudy %companyname% będą nieco łatwiejsze do zniesienia. | Zleceniodawca, %employer%, niech płaci porządnie za walkę z tymi bydlakami - nie padły łatwo! Sprawdź ludzi i przygotuj powrót do zleceniodawcy.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wracamy do %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BattleWonGoblins",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_83.png[/img]{Jak na takie małe gnojki, gobliny potrafią się nieźle bić! Twój zleceniodawca, %employer%, będzie zadowolony z pracy, którą dziś wykonałeś. | Słyszałeś, jak ludzie wyśmiewają rozmiar goblinów. Cóż, może i były małe, ale dały z siebie wszystko.\n\nPolicz ludzi i przygotuj powrót do zleceniodawcy, %employer%, po wypłatę. | Gobasy walczyły jak wygłodzone kundle. Wygłodzone, sprytne, mordercze kundle. Szkoda, że ich przebiegłości nie dało się wykorzystać do czegoś lepszego. No cóż, %employer% doceni wieści o tym, co tu zrobiono. | Nie wiesz, czy to dobrze, że zleceniodawca, %employer%, nie był całkiem pewien, czy gobliny tu grasują. Gdyby wiedział, zapłaciłby mniej? Gobliny wyglądają na nieporadne, ale do diabła potrafią się bić.\n\nTak czy inaczej, czas policzyć kompanię i wrócić do zleceniodawcy. | Gobliny leżą martwe. Co za utrapienie. Zleceniodawca, %employer%, powinien być zadowolony z tego, co tu dziś zrobiłeś. | Stos martwych goblinów wciąż nie sięga przytłaczającej wysokości orczego berserkera. A jednak... walczyły równie zaciekle! Szkoda, że ich wysiłek marnuje się w tak małych ciałach. Z drugiej strony, gdyby ich spryt i przebiegłość zamknięto w orczym ciele... na starych bogów, to straszna myśl!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wracamy do %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Warlord",
			Title = "Przed atakiem...",
			Text = "[img]gfx/ui/events/event_49.png[/img]{Gdy zbliżasz się do orczej watahy, dostrzegasz nieomylny zarys brutalnego wodza. Wygląda na to, że spotkanie z zielonoskórymi będzie trudniejsze, niż sądzono. | Wśród orków jest wielki wódz. To nic nie zmienia. No, zmienia trochę, ale cel pozostaje: zabić ich wszystkich. | Cóż za pech! Widziano orczego wodza stojącego wysoko pośród orczej linii. Pech dla wodza, rzecz jasna. Na pewno ciężko pracował, by znaleźć się tam, gdzie jest. Szkoda, że %companyname% zaraz mu to zrujnuje. | Wódz pośród zielonoskórych! Jego rozmiar i ryk byłyby nie do pomylenia - usłyszałbyś go, nawet gdyby niedźwiedź szczerzył do ciebie zęby! Nieważne, zielonoskóry zginie jak reszta. | Wódz. Pan wojny. Straszliwy ork. Słyszałeś to wszystko. Taka kolosalna postać stoi przy obozie zielonoskórych. Jeden z ich przywódców. Jeden z najlepszych wojowników. Czy to ma znaczenie? Żadnego. Oczywiście, że żadnego! Wszystko pójdzie zgodnie z planem.}",
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
			ID = "Shaman",
			Title = "Przed atakiem...",
			Text = "[img]gfx/ui/events/event_48.png[/img]{W trakcie podejścia dostrzegasz dziwny dym wspinający się ku górze. Nie jest popielaty ani szary, lecz fioletowy, z mackami jakby żywej zieleni, które ślizgają się i wiją w środku. Są tu gobliny, i mają ze sobą szamana! | Szaman! Poznałbyś jednego z tych przebiegłych goblinów wszędzie - kościana biżuteria, skośne oczy, iskra rozumu, której zwykle nie widać na głupiej gębie gobasa. To niebezpieczni zielonoskórzy, bądź czujny! | Ej, uważaj pod nogi. Gobliński szaman stoi pośród wrogich szeregów! To wyjątkowo groźny przeciwnik! Nie lekceważ jego małego wzrostu ani postury... | Słyszałeś opowieści o szamanach, którzy potrafią wyciągać człowiekowi sny z uszu. Nie wiesz, czy to prawda, ale wiesz, że to przebiegli wojownicy, i właśnie jednemu zaraz stawisz czoła! | Goblin-szaman... poznałbyś ten kościany strój wszędzie, i ten maskujący płaszcz też! Zachowaj spokój i rób swoje - to znaczy zabijaj wszystkich tych zielonoskórych! | Szaman. Jeden gobliński szaman... Słyszałeś straszne historie o ich 'magii', ale to nie czas ani miejsce. Szykować ludzi do ataku! | Gobliński szaman. Słyszałeś, że te paskudne gity potrafią mieszać w ludzkich głowach. Teraz zastanawiasz się, czy %employer%, twój zleceniodawca, nie dał się nabrać i nie ściągnął cię tutaj.\n\n...nie. Na pewno nie, prawda? | Gobliński szaman! Słyszałeś opowieści o tych nikczemnych stworach. Jedna mówiła, że wpychają osy do uszu jeńców! Jeden człowiek, przyznajmy po paru głębszych, twierdził, że widział, jak pszczoły zamieniły czyjś mózg w plaster miodu! Założę się, że ten miód szczypał w język!}",
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
			ID = "Merchant",
			Title = "Po bitwie...",
			Text = "{Gdy bitwa się kończy, odkrywasz zaskakującego jeńca pośród ruin pola walki: kupca. Ubrany w zakrwawione jedwabie, podchodzi do ciebie z wdzięcznością. Pyta, czy mógłbyś zabrać go do %objective%. Na drogach wyraźnie nie jest bezpieczny. Wzruszasz ramionami i odwracasz wzrok. Mężczyzna szybko się odzywa, oferując %reward_merchant% koron, jeśli mu po prostu pomożesz. To brzmi już lepiej... | Z kupy martwych zielonoskórych wyłania się mężczyzna. To nie jeden z twoich najemników, ale kupiec, z rękami związanymi z tyłu. Pytasz, jak trafił do takiego 'towarzystwa', a on wzrusza ramionami, mówiąc, że rzadko słyszy o tym, by zielonoskórzy brali jeńców. Cóż za szczęście.\n\n Rozgląda się i znów się odzywa.%SPEECH_ON%Muszę ci podziękować, najemniku, ale jeśli to nie było oczywiste, to muszę powiedzieć, że nie czuję się już bezpiecznie na tych drogach. Gdybyś doprowadził mnie w jednym kawałku do %objective%, byłbym skłonny, eee, rozstać się z %reward_merchant% koronami. Pasuje ci to?%SPEECH_OFF% | Po bitwie zauważasz kupca z boku, brzydko osiadłego na martwym koniu. Jakaś zabłąkana przemoc zakończyła żywot zwierzęcia i teraz kupiec ma pecha. Patrzy na pobojowisko, potem na ciebie. Krzyżuje ręce na łęku siodła i głośno pyta.%SPEECH_ON%Czy zechciałbyś, panie wojowniku, eskortować mnie do %objective%? Jak widzisz, mój środek transportu padł pode mną, powalony przez bitwę... nie twoja wina! Nie, panie! Jednak naprawdę muszę dostać się do tego miasta.%SPEECH_OFF%Zatrzymuje się i potrząsa przed tobą małą sakiewką.%SPEECH_ON%Mam w niej %reward_merchant% koron. Jak ci to brzmi?%SPEECH_OFF% | Gdy oglądasz pobojowisko, podchodzi do ciebie mężczyzna i pyta, co się tu stało. Wycierając krew z ostrza, mówisz mu, by dobrze się rozejrzał. Mruży oczy i z jakiegoś powodu pochyla się na czubkach stóp.%SPEECH_ON%Ach, zielonoskórzy. Wstydliwa sprawa. Cóż...%SPEECH_OFF%Opada z powrotem na pięty.%SPEECH_ON%Czekaj, na starobogów, chwileczkę. Zielonoskórzy? Co do diabła oni tu robią? Na litość niebios, nie mogę być w tych stronach bezpieczny! Żołnierzu! Zapłacę ci %reward_merchant% koron, jeśli odprowadzisz mnie do %objective%. Obiecuję, że to niedaleko, ale nie stać mnie, by iść sam.%SPEECH_OFF%Przeciąga kciukiem po gardle i wskazuje na martwego zielonoskórego.%SPEECH_ON%Nie sądzę, by ktokolwiek mógł zapłacić taką cenę, rozumiesz?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "W porządku, zabierzemy cię do %objective%.",
					function getResult()
					{
						this.Contract.setState("Running_Merchant");
						return 0;
					}

				},
				{
					Text = "Po prostu odejdź i nie wchodź nam w drogę.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				if (this.Flags.get("IsOrcs"))
				{
					this.Text = "[img]gfx/ui/events/event_81.png[/img]" + this.Text;
				}
				else
				{
					this.Text = "[img]gfx/ui/events/event_22.png[/img]" + this.Text;
				}

				local merchant = this.Tactical.getEntityByID(this.Flags.get("MerchantID"));
				this.Characters.push(merchant.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Wracasz do %employer% i rzucasz głowę zielonoskórego na jego stół. Odsuwa się od niej.%SPEECH_ON%Słucham?%SPEECH_OFF%Kiwając na nią, wyjaśniasz, że te plugastwa są martwe. Wyciąga z kieszeni chusteczkę i zaczyna wycierać krew.%SPEECH_ON%Tak, widzę. Ten bałagan miał zostać tam, a nie przyniesiony pod moje nogi! Cholerne najemniki... twoja zapłata jest w kącie! I zawołaj mojego sługę, gdy będziesz wychodził. Ktoś musi to posprzątać!%SPEECH_OFF% | %employer% zabawia kobietę opowieściami, gdy wracasz. Jej chichoty zmieniają się w tęskne spojrzenie, gdy wchodzisz. Widząc to, szybko ją wyprasza, by obecność prawdziwego mężczyzny nie przyprawiła jej o omdlenie.%SPEECH_ON%Najemniku! Jakie wieści przynosisz?%SPEECH_OFF%Wyciągasz z worka głowę zielonoskórego. %employer% patrzy na nią, zaciska wargi, uśmiecha się, marszczy brwi, jakby nie był pewien, co zrobić z tym, na co patrzy.%SPEECH_ON%Dobrze... dobrze. Cóż, twoja zapłata jest tutaj, jak obiecano.%SPEECH_OFF%Stawia na stole drewnianą skrzynię.%SPEECH_ON%Przyprowadź tę dziewczynę z powrotem, kiedy wyjdziesz.%SPEECH_OFF% | Stawiasz głowę zielonoskórego na biurku %employer%. Prostuje się i rozwija zwój, porównując rysunek zielonoskórego z tym jak najbardziej prawdziwym.%SPEECH_ON%Hmm, będę musiał powiedzieć uczonym, że się trochę... mylą.%SPEECH_OFF%Pytasz, jak to.%SPEECH_ON%Pokolorowali ich na szaro. Ten jest wyraźnie zielony.%SPEECH_OFF%Zastanawiasz się na głos, czy uczeni w ogóle mają zielone pióra. Mężczyzna zaciska wargi i kiwa głową.%SPEECH_ON%Hę. Słuszna uwaga. Cóż, strażnik przy drzwiach ma twoją zapłatę. Zostaw mnie z tym... okazem.%SPEECH_OFF% | Obok %employer% stoi mężczyzna w szatach, gdy wchodzisz. Jest pogrążony w zwoju i nawet nie zerka na twoje przybycie. Wzruszasz ramionami, wyjmujesz z worka głowę zielonoskórego i kładziesz ją na stole zleceniodawcy. Wtedy nieznajomy zauważa - i zabiera głowę! Chwyta ją i natychmiast wybiega z pokoju, niemal wyjąc z radości. Pytasz, co do licha to było. %employer% się śmieje.%SPEECH_ON%Uczeni niecierpliwili się na twój powrót. Od jakiegoś czasu chcieli czegoś nowego do badania.%SPEECH_OFF%Mężczyzna wyciąga sakiewkę i podaje ją. Licząc korony, pytasz, czy jajogłowi też ci zapłacą. %employer% wzrusza ramionami.%SPEECH_ON%Jeśli ich złapiesz. I nie mam na myśli fizycznie - ci ludzie są tak głęboko w swoich myślach, że zachowują się, jakby reszta z nas w ogóle nie istniała!%SPEECH_OFF% | %employer% ma w jednej dłoni ptaka, w drugiej kamień. Pytasz, co robi.%SPEECH_ON%Próbuję ustalić, co jest więcej warte. Ptak w dłoni, czy... czy kamień... czekaj...%SPEECH_OFF%Nie masz na to czasu i uderzasz głową zielonoskórego w jego stół, pytając, ile to jest warte. Mężczyzna wypuszcza ptaka i odkłada kamień na półkę. Odwraca się z twoją zapłatą w dłoni.%SPEECH_ON%Wnioskuję po tej... ciekawości, że moje problemy zostały rozwiązane. Twoja zapłata, jak obiecano.%SPEECH_OFF%Zastanawiasz się, jak do diabła udało mu się złapać tego ptaka, ale postanawiasz się nad tym nie zastanawiać. | %employer% ma atak kaszlu, gdy wracasz. Spogląda na ciebie, zaciskając pięść przy ustach.%SPEECH_ON%Miejmy nadzieję, że twoja obecność nie jest kolejnym złym omenem?%SPEECH_OFF%Wzruszasz ramionami i kładziesz głowę zielonoskórego na jego stole, wyjaśniając, że wszyscy zostali załatwieni. %employer% zerka na nią.%SPEECH_ON%To moja choroba musiała być spowodowana czymś innym... ale czym? {Kobietami? To pewnie kobiety. Bądźmy szczerzy, to zawsze kobiety. | Psy. Ludzie mówią, że te parszywe kundle są zwiastunami szaleństwa. | Czarne koty! Tak, oczywiście! Wszystkie każę pozabijać! | Dzieci. Ostatnio są dość głośne. Co one planują za tymi chichotami i śmiechem? | Może to było to niedopieczone mięso, które zjadłem... albo... nie, jestem prawie pewien, że to ta szalona kobieta mieszkająca na wzgórzu. | Zjadłem chleb, którym nieświadomie podzieliłem się z szczurem. To albo to, albo kobieta. Wiesz, jakie one są, zawsze roznoszą choroby i nas psują, te przeklęte kobiety!}%SPEECH_OFF%Mężczyzna zatrzymuje się, po czym kręci głową.%SPEECH_ON%Cóż, nieważne. Twoją zapłatę trzyma strażnik na zewnątrz. To kwota, na jaką się umówiliśmy, choć możesz ją policzyć. Bogowie wiedzą, że w tym stanie mogłem się pomylić!%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Udane polowanie.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Zająłeś się grasującymi zielonoskórymi");
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
		this.m.Screens.push({
			ID = "Success2",
			Title = "%objective%...",
			Text = "[img]gfx/ui/events/event_20.png[/img]{Po bezpiecznym dotarciu do %objective% kupiec odwraca się i dziękuje ci. Przekazuje sakiewkę koron, zgodnie z obietnicą, i szybko kieruje się do miasta. | %objective% to miły widok dla zmęczonych oczu, a i wesołych kupców - człowiek, którego eskortowałeś, krzyczy z radości, podekscytowany, że żyje albo że zaraz zarobi, albo czymkolwiek, co pobudza ludzi interesu. Biegnie do pobliskiej karczmy i szybko wraca z sakiewką koron.%SPEECH_ON%Jak obiecałem, najemniku. Jestem ci winien znacznie więcej.%SPEECH_OFF%Z uśmiechem pytasz, ile by zapłacił. Śmieje się.%SPEECH_ON%Nie odważyłbym się wycenić własnej głowy, bo gwarantuję, że ktoś by ją kupił!%SPEECH_OFF%Kiwasz głową, rozumiejąc, i w zupełności zadowala cię obecna zapłata. | Po dotarciu do %objective% kupiec płaci ci umówioną kwotę. Potem szybko odchodzi, paplając o tym, ile koron zarobi i ile kobiet obróci. | Bezpiecznie doprowadzasz kupca do %objective%. Dziękuje ci, po czym pędzi do pobliskiej tawerny. Gdy wraca, niesie sakiewkę koron jak grejpfrut w skarpecie. Rzuca ją w twoją stronę.%SPEECH_ON%Twoja zapłata, najemniku. Masz moją wdzięczność i, oczywiście, moje korony. A teraz wybacz...%SPEECH_OFF%Poprawia koszulę i spodnie, unosi brodę.%SPEECH_ON%...bo mam pieniądze do zrobienia.%SPEECH_OFF%Odwraca się i maszeruje, z odrobiną skąpego zapału w kroku.}",
			Image = "",
			List = [],
			Characters = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Łatwe korony.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Flags.get("MerchantReward"));
						return 0;
					}

				}
			],
			function start()
			{
				local merchant = this.Tactical.getEntityByID(this.Flags.get("MerchantID"));
				this.Characters.push(merchant.getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("MerchantReward") + "[/color] koron"
				});
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective",
			this.m.Objective != null ? this.m.Objective.getName() : ""
		]);
		_vars.push([
			"objectivedirection",
			this.m.Objective == null || this.m.Objective.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Objective.getTile())]
		]);
		_vars.push([
			"reward_merchant",
			this.m.Flags.get("MerchantReward")
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
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			if (this.m.Objective != null && !this.m.Objective.isNull())
			{
				this.m.Objective.getSprite("selection").Visible = false;
			}

			this.m.Origin.getSprite("selection").Visible = false;
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
		if (this.m.Origin.getOwner().getID() != this.m.Faction)
		{
			return false;
		}

		return true;
	}

	function onIsTileUsed( _tile )
	{
		if (this.m.Objective != null && !this.m.Objective.isNull() && _tile.ID == this.m.Objective.getTile().ID)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		if (this.m.Target != null && !this.m.Target.isNull() && this.m.Target.isAlive())
		{
			_out.writeU32(this.m.Target.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.Objective != null && !this.m.Objective.isNull() && this.m.Objective.isAlive())
		{
			_out.writeU32(this.m.Objective.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		local objective = _in.readU32();

		if (objective != 0)
		{
			this.m.Objective = this.WeakTableRef(this.World.getEntityByID(objective));
		}

		this.contract.onDeserialize(_in);
	}

});

