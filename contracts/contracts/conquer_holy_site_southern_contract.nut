this.conquer_holy_site_southern_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Target = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.conquer_holy_site_southern";
		this.m.Name = "Podbicie Świętego Miejsca";
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

		local sites = [
			"location.holy_site.oracle",
			"location.holy_site.meteorite",
			"location.holy_site.vulcano"
		];
		local locations = this.World.EntityManager.getLocations();
		local target;
		local targetIndex = 0;
		local closestDist = 9000;
		local myTile = this.m.Home.getTile();

		foreach( v in locations )
		{
			foreach( i, s in sites )
			{
				if (v.getTypeID() == s && v.getFaction() != 0 && !this.World.FactionManager.isAllied(this.getFaction(), v.getFaction()))
				{
					local d = myTile.getDistanceTo(v.getTile());

					if (d < closestDist)
					{
						target = v;
						targetIndex = i;
						closestDist = d;
					}
				}
			}
		}

		this.m.Destination = this.WeakTableRef(target);
		this.m.Destination.setVisited(true);
		local b = -1;

		do
		{
			local r = this.Math.rand(0, this.Const.PlayerBanners.len() - 1);

			if (this.World.Assets.getBanner() != this.Const.PlayerBanners[r])
			{
				b = this.Const.PlayerBanners[r];
				break;
			}
		}
		while (b < 0);

		this.m.Payment.Pool = 1300 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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

		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		this.m.Flags.set("DestinationIndex", targetIndex);
		this.m.Flags.set("MercenaryPay", this.beautifyNumber(this.m.Payment.Pool * 0.5));
		this.m.Flags.set("Mercenary", this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
		this.m.Flags.set("MercenaryCompany", this.Const.Strings.MercenaryCompanyNames[this.Math.rand(0, this.Const.Strings.MercenaryCompanyNames.len() - 1)]);
		this.m.Flags.set("MercenaryBanner", b);
		this.m.Flags.set("Commander", this.Const.Strings.SouthernNames[this.Math.rand(0, this.Const.Strings.SouthernNames.len() - 1)]);
		this.m.Flags.set("EnemyID", target.getFaction());
		this.m.Flags.set("MapSeed", this.Time.getRealTime());
		this.m.Flags.set("OppositionSeed", this.Time.getRealTime());
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Odbij %holysiteD% z rąk południowych bezbożników",
					"Zniszcz lub przegoń wrogie pułki w pobliżu"
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 20)
				{
					this.Flags.set("IsAlliedArmy", true);
				}
				else if (r <= 40)
				{
					this.Flags.set("IsSallyForth", true);
				}
				else if (r <= 60)
				{
					this.Flags.set("IsMercenaries", true);
				}
				else if (r <= 80)
				{
					this.Flags.set("IsCounterAttack", true);
				}

				if (this.Contract.getDifficultyMult() >= 1.15)
				{
					this.Contract.spawnEnemy();
				}
				else if (this.Contract.getDifficultyMult() <= 0.85)
				{
					local entities = this.World.getAllEntitiesAtPos(this.Contract.m.Destination.getPos(), 1.0);

					foreach( e in entities )
					{
						if (e.isParty())
						{
							e.getController().clearOrders();
						}
					}
				}

				local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);

				foreach( n in nobles )
				{
					if (n.getFlags().get("IsHolyWarParticipant"))
					{
						n.addPlayerRelation(-99.0, "Opowiedziałeś się po jednej ze stron w wojnie");
					}
				}

				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
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
					this.Contract.m.Destination.setOnEnterCallback(this.onDestinationAttacked.bindenv(this));
				}

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onCounterAttack.bindenv(this));
				}
			}

			function update()
			{
				if (this.Flags.get("IsFailure"))
				{
					this.Contract.setScreen("Failure");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsVictory"))
				{
					if (this.Flags.get("IsCounterAttack"))
					{
						this.Contract.setScreen("CounterAttack1");
						this.World.Contracts.showActiveContract();
					}
					else if (!this.Contract.isEnemyPartyNear(this.Contract.m.Destination, 400.0))
					{
						this.Contract.setScreen("Victory");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onCounterAttack( _dest, _isPlayerInitiated )
			{
				if (this.Flags.get("IsCounterAttackDefend") && this.Contract.isPlayerAt(this.Contract.m.Destination))
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
					p.LocationTemplate.OwnedByFaction = this.Const.Faction.Player;
					p.LocationTemplate.Template[0] = "tactical.southern_ruins";
					p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
					p.LocationTemplate.ShiftX = -4;
					p.CombatID = "ConquerHolySiteCounterAttack";
					p.MapSeed = this.Flags.getAsInt("MapSeed");
					p.Music = this.Const.Music.NobleTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "ConquerHolySiteCounterAttack";
					p.Music = this.Const.Music.NobleTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
			}

			function onDestinationAttacked( _dest )
			{
				if (this.Flags.getAsInt("OppositionSeed") != 0)
				{
					this.Math.seedRandom(this.Flags.getAsInt("OppositionSeed"));
				}

				if (this.Flags.get("IsVictory") || this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					return;
				}
				else if (this.Flags.get("IsAlliedArmy"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("AlliedArmy");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.OwnedByFaction = this.Flags.get("EnemyID");
						p.CombatID = "ConquerHolySite";
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.Music = this.Const.Music.NobleTracks;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 200 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
						p.AllyBanners = [
							this.World.Assets.getBanner(),
							this.World.FactionManager.getFaction(this.Contract.getFaction()).getPartyBanner()
						];
						p.EnemyBanners = [
							this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
						];
						this.World.Contracts.startScriptedCombat(p, true, true, true);
					}
				}
				else if (this.Flags.get("IsSallyForth"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("SallyForth");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "ConquerHolySite";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
						];
						this.World.Contracts.startScriptedCombat(p, false, true, true);
					}
				}
				else if (this.Flags.get("IsMercenaries"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Mercenaries1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.OwnedByFaction = this.Flags.get("EnemyID");
						p.CombatID = "ConquerHolySite";
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.Music = this.Const.Music.NobleTracks;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, (130 + (this.Flags.get("MercenariesAsAllies") ? 30 : 0)) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
						];

						if (this.Flags.get("MercenariesAsAllies"))
						{
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
							p.AllyBanners.push(this.Flags.get("MercenaryBanner"));
						}
						else
						{
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
							p.EnemyBanners.push(this.Flags.get("MercenaryBanner"));
						}

						this.World.Contracts.startScriptedCombat(p, true, true, true);
					}
				}
				else if (this.Flags.get("IsCounterAttack") && this.Flags.get("IsVictory"))
				{
					if (this.Flags.get("IsCounterAttackDefend"))
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.OwnedByFaction = this.Const.Faction.Player;
						p.LocationTemplate.ShiftX = -2;
						p.CombatID = "ConquerHolySiteCounterAttack";
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
						];
						this.World.Contracts.startScriptedCombat(p, false, true, true);
					}
					else
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "ConquerHolySiteCounterAttack";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
						];
						this.World.Contracts.startScriptedCombat(p, false, true, true);
					}
				}
				else if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Contract.setScreen("Attacking");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
					p.LocationTemplate.OwnedByFaction = this.Flags.get("EnemyID");
					p.CombatID = "ConquerHolySite";
					p.LocationTemplate.Template[0] = "tactical.southern_ruins";
					p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
					p.Music = this.Const.Music.NobleTracks;
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, (this.Flags.get("IsCounterAttack") ? 110 : 130) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
					p.AllyBanners = [
						this.World.Assets.getBanner()
					];
					p.EnemyBanners = [
						this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
					];
					this.World.Contracts.startScriptedCombat(p, true, true, true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "ConquerHolySiteCounterAttack")
				{
					this.Flags.set("IsCounterAttack", false);
					this.Flags.set("IsVictory", true);
				}
				else if (_combatID == "ConquerHolySite")
				{
					this.Flags.set("IsVictory", true);
					this.Flags.set("OppositionSeed", this.Time.getRealTime());
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "ConquerHolySite" || _combatID == "ConquerHolySiteCounterAttack")
				{
					this.Flags.set("IsFailure", true);
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

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
					this.Contract.m.Destination.setOnEnterCallback(null);
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success");
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
			Text = "[img]gfx/ui/events/event_162.png[/img]{Zastajesz %employer%a za stertą zwojów. Jest pochłonięty pisaniem, a święci mężowie wokół niego równie pilnie śledzą, gotowi zabrać zwój, gdy tylko przechwycą ostatnie słowa Wezyra. Wreszcie podnosi wzrok.%SPEECH_ON%Mamy sprawę: %holysite% zostało splugawione przez północne szczury. Postaram się powściągnąć emocje, bo nie w zwyczaju Gildera mieszać je z furią, więc powiem jasno, że obecność tych dzikusów obraża racjonalny osąd.%SPEECH_OFF%Wezyr macza pióro i wraca do pisania i mówienia.%SPEECH_ON%Jednak gdy pies szczeka, ptaki odlatują. Potrzebuję psa, Koroniarzu, i takiego, który kąsa. Zabierz kompanię do świętej ziemi i wykorzeń tych wyrzutków. Jeśli się zgadzamy, %reward% koron i blask Gildera będą czekały na twój powrót.%SPEECH_OFF% | %employer% wita cię z zaskakującą serdecznością.%SPEECH_ON%Wiedziałem, że Gilder przyśle mi człowieka wielkiej wagi, człowieka o prawdziwej sile i zawziętości. Koroniarza, owszem. Ale wojownika? Z pewnością!%SPEECH_OFF%Zanim zapytasz o sprawę, Wezyr unosi złoty kielich, którego czasza została przecięta jak krawędź księżyca.%SPEECH_ON%Nasza najświętsza ziemia, %holysite%, została zajęta przez dzikich północnych. Naszemu światu grozi mrok, a by odeprzeć cień, musimy działać sprzyjająco. Ludzi w mojej domenie nie brakuje, lecz ziemie pod okiem Gildera rozciągają się daleko. Potrzebuję żołnierzy takich jak ty, by odzyskać %holysite%. To część tej ziemi, której zwierzchnikiem jest Gilder, a Gilder opłaca nas wszystkich: %reward% koron za wykonanie zadania. Czy mamy porozumienie?%SPEECH_OFF% | W rzadkim widoku zastajesz %employer%a leżącego krzyżem pod blaskiem lśniącego, świetlistego symbolu w kształcie słońca. Szepcze kilka słów do siebie, wstaje, znów szepcze, czyści opuszki palców jeden po drugim i zwraca się do ciebie.%SPEECH_ON%Podczas gdy moje wojska czynią pomyślne postępy gdzie indziej, %holysite% pozostało bez obrony. W mojej żądzy zwycięstwa w tej wojnie zostawiłem otwarte drzwi, by barbarzyńscy północni je zajęli. Proszę cię, twarzą w twarz, o porcję zewnętrznej pomocy. Gilder wskaże nam wszystkim pozłacaną ścieżkę, Koroniarzu, a ty nie jesteś poza Jego hojnością. Z mojej ręki otrzymasz %reward% koron, jeśli odbijesz %holysite%!%SPEECH_OFF% | Złoty puchar turla się po marmurowej posadzce, a wino pryska na wszystkie strony. Wezyr krzyczy na ciebie, mieszanina złości i potrzeby.%SPEECH_ON%Wreszcie ktoś, kto może pomóc!%SPEECH_OFF%Odprawia kilku pomocników i nawet paru, którzy wyglądają na jego własnych poruczników.%SPEECH_ON%Koroniarzu, %holysite% zostało zdobyte przez północne ścierwo. Płakałem na myśl, że je plądrują, i zapłaczę znowu za każdy dzień, w którym bezczeszczą jeden ze śladów Gildera. %reward% koron. Tyle zostanie zdobyte i wsadzone do twoich kieszeni. Spora suma, to prawda, ale to, co mówią, też jest prawdą: dla niektórych droga pozłacanej ścieżki bywa bardziej dosłowna niż dla innych.%SPEECH_OFF% | %employer% jest otoczony przez mężczyzn obwieszonych jedwabiem. Jeden niesie świetliki w klatce z kapturem, przygasłe światełka owadów mrugają tu i ówdzie. Drugi ma klatkę ze szczątkami martwego ptaka, obdartymi do kości, z wyjątkiem dwóch piór, które zdają się odtwarzać całe jego niegdysiejsze skrzydła. Widząc cię, Wezyr wychodzi między tych ludzi tak, jak wychodzi się między nieruchome filary świątyni.%SPEECH_ON%Koroniarzu, jesteś! Moi zwiadowcy donieśli, że cofnęliśmy się w tej wojnie z psami północy. %holysite% zostało zdobyte i, zgodnie z szeptami Gildera, muszę je nam przywrócić. Nie tylko dla mojej domeny, ale i po to, by Jego wzniosłość nie nosiła najmniejszego cienia. Otrzymasz %reward% koron za to przedsięwzięcie, ciężką sumę za ciężkie zadanie, tak!%SPEECH_OFF% | Zwykle otoczony przepychem i znajomymi rozrzutnikami, tym razem zastajesz %employer%a klęczącego i ubranego dość skromnie. Nosi nakrycie głowy z czarnym sznurem wokół czubka. Społecznie powściągliwy Wezyr mówi do ciebie spokojnie.%SPEECH_ON%Północni bezbożnicy zabrali nam %holysite%. Nie winię ich za te czyny, nie wiedzą, co robią. Moimi uczciwymi rękami Gilder pozna moje winy. Ale porażka nie oznacza poddania. Potrzebuję, byś udał się na święte ziemie i zwrócił je naszemu państwu. Za to otrzymasz %reward% koron w swoich sakwach.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Ufam, że obficie nas wynagrodzisz za taki szturm. | Jesteśmy gotowi wykonać, co do nas należy. | Porozmawiajmy nieco o zapłacie.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{To nie jest tego warte. | To zbyt daleka wędrówka. | Mamy pilniejsze sprawy, którymi musimy się zająć. | Jesteśmy potrzebni gdzie indziej.}",
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
			ID = "Attacking",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Jak wierzył Wezyr, północni zajęli pozycje w i wokół %holysite%. Większość pobożnego pospólstwa dawno się ulotniła, pozostawiając tylko %companyname% i siły przeciwnika. Dobywasz miecza i rozkazujesz ludziom do ataku.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Rozpocząć szturm!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AlliedArmy",
			Title = "%holysite%",
			Text = "[img]gfx/ui/events/event_164.png[/img]{Gdy zbliżasz się do %holysite%, mężczyzna zdaje się wyrastać z ziemi. Zaskoczony dobywasz broni, lecz okazuje się, że to zakamuflowany dowódca %employer%a.%SPEECH_ON%Spokojnie, Koroniarzu, moneta jeszcze się znajdzie. Ptaki Wezyra doniosły moim ludziom o twoim nadejściu i muszę przyznać, że nieco się spóźniłeś. Wiem, że to nie twoja wojna, ale cóż, to nie czas na napomnienia. Odzyskajmy święte ziemie dla Gildera, a niech nasze dalsze drogi będą pozłocone jego blaskiem.%SPEECH_OFF% | %holysite% majaczy w oddali, gdy mężczyzna zdaje się wyrastać z ziemi. Pyta, czy jesteś dowódcą %companyname%, a krótka pauza musiała być odpowiedzią, bo natychmiast mówi dalej.%SPEECH_ON%Tak, oczywiście, że jesteś. Jestem %commander%, porucznik %employer%a. Ptaki Wezyra doniosły, że możesz przybyć. Może gonisz za monetą, Koroniarzu, ale jeśli dziś zwyciężymy, Gilder rozświetli twoją jutrzejszą drogę!%SPEECH_OFF%}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "Rozpocząć szturm!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
				this.Banner = this.World.FactionManager.getFaction(this.Contract.getFaction()).getUIBanner();
			}

		});
		this.m.Screens.push({
			ID = "SallyForth",
			Title = "%holysite%",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Obrońcy %holysite% otrzymali posiłki! Na szczęście jest i dobra strona: dodatkowe miecze dodały im odwagi, by opuścić naturalne umocnienia świętego miejsca i wyjść ci naprzeciw na otwartym polu. | Zaskakuje cię, że obrońcy opuszczają %holysite% i maszerują przez otwarte pole. Szybki meldunek zwiadowców mówi, że w ciągu ostatnich dni dostali posiłki i ośmieliła ich sama liczebność. Z jednej strony gęste szeregi niepokoją, z drugiej starcie na równym terenie będzie znacznie łatwiejsze. Choć szczerze uważasz, że ich błędem jest w ogóle stawać przeciw %companyname%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "A więc jednak bitwa polowa.",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Mercenaries1",
			Title = "%holysite%",
			Text = "[img]gfx/ui/events/event_134.png[/img]{Gdy %holysite% wyłania się w oddali, podchodzi do ciebie mężczyzna niemal niepokojąco do ciebie podobny. Ma przy sobie płatnika i kilku najemników.%SPEECH_ON%Dobry wieczór, kapitanie. Jestem %mercenary% z %mercenarycompany%. Przybyłem na te ziemie po koronę, tak jak ty. Założę się, że Wezyr umoczył pióro w porządnym kontrakcie dla ciebie i twoich ludzi, ale co powiesz na to, byś zapłacił mi %pay% koron, a ja pomogę w tej sprawce?%SPEECH_OFF% | Podchodzi do ciebie grupa mężczyzn; jeden z nich ma chód i posturę dziwnie podobne do twoich. Przedstawia się jako %mercenary%, kapitan %mercenarycompany%.%SPEECH_ON%Myślałem, że Wezyr pośle swoją zawodową armię, by dopilnowała zmiany władzy nad świętym miejscem. Przyznam, kapitanie, że to ja pomogłem północnym zająć ten dostojny monument w pierwszej kolejności. Jednak za %pay% koron chętnie pomogę wam je odzyskać. Jako kolega po fachu na pewno widzisz, że to dobry interes dla wszystkich.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [],
			function start()
			{
				if (this.World.Assets.getMoney() > this.Flags.get("MercenaryPay"))
				{
					this.Options.push({
						Text = "Czujcie się zatrudnieni!",
						function getResult()
						{
							return "Mercenaries2";
						}

					});
				}
				else
				{
					this.Options.push({
						Text = "Obawiam się, że nie mamy takiej kwoty.",
						function getResult()
						{
							return "Mercenaries3";
						}

					});
				}

				this.Options.push({
					Text = "Poszukaj swej własnej roboty, %mercenary%. Niepotrzebna nam pomoc.",
					function getResult()
					{
						return "Mercenaries3";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Mercenaries2",
			Title = "%holysite%",
			Text = "[img]gfx/ui/events/event_134.png[/img]{Kapitan szczerzy zęby i klepie cię po ramieniu.%SPEECH_ON%Aaa, jest! Jest, szlachetny duch najemnika! Tak, dowódco %companyname%, wyruszmy na krótko i walczmy razem, też na krótko!%SPEECH_OFF% | Gdy umowa zostaje zawarta, kapitan kompanii najemników zbliża się do ciebie. Aż nazbyt blisko, zdecydowanie w zasięgu jego oddechu, czego wcale nie doceniasz.%SPEECH_ON%Wiesz, ludzie tacy jak my, chłopy tacy jak my, kumple, jesteśmy kumplami, nie? Tacy jak my muszą trzymać się razem. W tej bitwie też będziemy trzymać się razem.%SPEECH_OFF%Kiwa głową i szturcha cię w ramię.%SPEECH_ON%Po walce, cóż, mam nadzieję, że jeszcze kiedyś będziemy kumplami, no wiesz?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Rozpocząć szturm!",
					function getResult()
					{
						this.Flags.set("MercenariesAsAllies", true);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
				this.World.Assets.addMoney(-this.Flags.get("MercenaryPay"));
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Wydałeś [color=" + this.Const.UI.Color.NegativeEventValue + "]" + this.Flags.get("MercenaryPay") + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "Mercenaries3",
			Title = "%holysite%",
			Text = "[img]gfx/ui/events/event_134.png[/img]{%SPEECH_START%To szkoda.%SPEECH_OFF%%mercenary% mówi, po czym szybko truchta z powrotem do szeregów %mercenarycompany%. Cofa się prosto w żołnierzy broniących %holysite%. Ręce ma szeroko rozłożone i wachluje nimi, jakby płynął pod prąd.%SPEECH_ON%Cholerny wstyd, mówię! No cóż, kapitanie %companyname%, zobaczmy, która strona kupiła lepszego najemnika, co?%SPEECH_OFF%Najemnik dobywa broni, podobnie jak północni żołnierze dookoła, a ty robisz to samo. Czas walczyć. | %SPEECH_ON%No tak, widzę. Cóż. Nie spodziewałem się wiele. W końcu też sprzedaję miecz. A teraz...%SPEECH_OFF%Idzie tyłem do swojej kompanii, a ta do szeregów północnych żołnierzy broniących %holysite%.%SPEECH_ON%Teraz to północ jest najwyższym oferentem.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Spotkamy się jeszcze na polu bitwy. Rozpocząć szturm!",
					function getResult()
					{
						this.Flags.set("MercenariesAsAllies", false);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CounterAttack1",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Bitwa dobiegła końca, lecz w oddali miga błysk zbroi. Przymykasz oczy i skupiasz się na nadchodzących sylwetkach. Może to wierni, którzy przychodzą wypełnić święte miejsce i... nie, to północni! To kontratak! | Gdy chowasz ostrze, strzała śwista nad głową i uderza w piasek z przytłumionym tąpnięciem. Spoglądasz w stronę źródła i widzisz młodego, nerwowego łucznika, któremu ktoś wymierza kuksańca, a obok niego całe zgrupowanie północnych! To kontratak!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Utworzymy tutaj bastion i będziemy się bronić!",
					function getResult()
					{
						return "CounterAttack2";
					}

				},
				{
					Text = "Stawimy im czoła na otwartym polu!",
					function getResult()
					{
						return "CounterAttack3";
					}

				},
				{
					Text = "Nie przetrwamy kolejnej bitwy. Odwrót!",
					function getResult()
					{
						return "Failure";
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CounterAttack2",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{%SPEECH_START%Znowu północni.%SPEECH_OFF%%randombrother% mówi. Kiwasz głową i odpowiadasz.%SPEECH_ON%Więcej polan na ogień Gildera.%SPEECH_OFF%Najemnik wspomina, że Gilder woli złoto od płomieni, ale każesz mu się zamknąć i przygotować na to, co nadchodzi. Umocnienia %holysite% powinny dobrze posłużyć kompanii. | Rozkazujesz ludziom bronić się w %holysite%. %randombrother% rozgląda się.%SPEECH_ON%Zastanawiałeś się kiedyś, czy bóg albo bogowie, którzy na to patrzą, nie robią się trochę zgryźliwi? Wiesz? Czy nie robimy bałaganu w ich garnkach?%SPEECH_OFF%Dajesz mu kuksańca w głowę i każesz się skupić.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zebrać się!",
					function getResult()
					{
						this.Flags.set("IsCounterAttackDefend", true);
						this.Flags.set("IsVictory", false);
						local party = this.Contract.spawnEnemy();
						party.setOnCombatWithPlayerCallback(this.Contract.getActiveState().onCounterAttack.bindenv(this.Contract.getActiveState()));
						this.Contract.m.Target = this.WeakTableRef(party);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CounterAttack3",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Rozkazujesz %companyname% wyjść w pole. Północny porucznik wita cię machnięciem ręki i szerokim uśmiechem.%SPEECH_ON%Wychodzicie, co? Zmęczeni modłami?%SPEECH_OFF%Odwracasz się i spluwasz.%SPEECH_ON%Kończyło nam się miejsce do grzebania waszych trupów.%SPEECH_OFF%Uśmiech porucznika gaśnie i rozkazuje szarżę. Do boju!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Na nich!",
					function getResult()
					{
						this.Flags.set("IsCounterAttackDefend", false);
						this.Flags.set("IsVictory", false);
						local party = this.Contract.spawnEnemy();
						party.setOnCombatWithPlayerCallback(this.Contract.getActiveState().onCounterAttack.bindenv(this.Contract.getActiveState()));
						this.Contract.m.Target = this.WeakTableRef(party);
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
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Chowasz broń i wysyłasz kompanię, by pozbierała, co się da z poległych, i czujesz dziwnie, że nie pierwszy raz %holysite% ogląda taką rzeź. Cóż, jeśli ktoś ma ginąć śladami przodków, cieszysz się, że to nie ty. Kilku południowców przybywa, by zabezpieczyć święty teren. Gdy już tu są, ruszasz w drogę, wiedząc, że %employer% ucieszy się z wieści, które mu przynosisz. | Wróg pokonany, a %holysite% odzyskane. Południowi żołnierze powoli obsadzają umocnienia. Za nimi napływa tłum wiernych, mijając zwłoki, by paść na twarz w najświętszym z miejsc. Nikt ci nie dziękuje. I tak to rola %employer%a. | Po bitwie niewielki tłum wiernych zaczyna gromadzić się w zakamarkach %holysite%. Nie wiesz nawet, skąd się wzięli. Im nie przeszkadzasz i oni nie przeszkadzają tobie. Liczy się teraz, że %employer% będzie miał ogromny skarbiec koron na twój powrót. Gdy odchodzisz, kilku południowych żołnierzy obejmuje posterunek i również nie dziękuje.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Zwycięstwo!",
					function getResult()
					{
						this.Contract.m.Destination.setFaction(this.Contract.getFaction());
						this.Contract.m.Destination.setBanner(this.World.FactionManager.getFaction(this.Contract.getFaction()).getPartyBanner());
						this.updateAchievement("NewManagement", 1, 1);
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.spawnAlly();
			}

		});
		this.m.Screens.push({
			ID = "Failure",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Nie udało ci się ochronić %holysite% przed północnymi. Nie ma powodu, by tu zostać, a jedyny powód, by wracać do %employer%a, to chęć zobaczenia własnej głowy na jednej ze złoconych tac Wezyra.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Katastrofa!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Nie zdołałeś podbić świętego miejsca");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Success",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% siedzi pod blaskiem złotej ozdoby, ogromnego metalowego słońca zawieszonego na łańcuchach u sufitu. Musiała powstać, gdy byłeś poza miastem. Gdy podchodzisz, święty mąż zatrzymuje cię i kręci głową. Rysuje dłonią krąg w powietrzu i dotyka opuszkiem twojego czubka głowy. Uśmiechając się, prowadzi cię na drugą stronę sali, gdzie %reward% koron ułożono równo w drewnianych tacach.\n\n Mężczyzna kłania się, unosi dłonie w stronę złotej ozdoby, układając je tak, jakby dźwigał samą konstrukcję, po czym zdaje się kierować jej wzniosłość na twoją zapłatę, a monety trzaskają światłem. Jakaś sztuczka, ale wypłata jest prawdziwa, więc bierzesz ją i odchodzisz. | Gdy wchodzisz do komnaty %employer%a, kilku strażników na chwilę kłania się i pada na twarz, po czym wstaje. W oddali Wezyr siedzi w milczeniu na tronie, otoczony świętymi mężami w jedwabiach. Wygląda na to, że dziś nie podejdziesz do niego, ale grupa młodych chłopców przynosi ci tacki z monetami jedna po drugiej, aż masz %reward% koron. Wezyr kiwa głową i odwraca dłoń. Zabierasz zapłatę i odchodzisz. | Wchodzisz do wielkiej sali i zastajesz %employer%a jakby zaczarowanego przez wir złotej mgły. Stoi na obracającej się platformie - obracającej się dość szorstko dzięki niemal niewidocznym niewolnikom pod podłogą - a na jego nadgarstkach wiszą paski materiału. Jego harem stoi z boku, napełniając usta złotawym płynem, po czym rozpyla go w mgiełkach. Przy bliższym spojrzeniu nie jest to tak wspaniałe widowisko, jak początkowo sądziłeś. Na szczęście nie dostaniesz bliższego wglądu: wielki mężczyzna w religijnym habicie zatrzymuje cię i prowadzi do stołu w głębi sali. Jest zastawiony tackami z monetami, a całość to twoja nagroda %reward% koron. Z wypłatą w dłoni zostajesz szybko wyprowadzony z sali.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Podbiłeś święte miejsce");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isHolyWar())
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

	function spawnAlly()
	{
		local o = this.m.Destination.getTile().SquareCoords;
		local tiles = [];

		for( local x = o.X - 4; x < o.X + 4; x = x )
		{
			for( local y = o.Y + 4; y <= o.Y + 6; y = y )
			{
				if (!this.World.isValidTileSquare(x, y))
				{
				}
				else
				{
					local tile = this.World.getTileSquare(x, y);

					if (tile.Type == this.Const.World.TerrainType.Ocean)
					{
					}
					else
					{
						local s = this.Math.rand(0, 3);

						if (tile.Type == this.Const.World.TerrainType.Mountains)
						{
							s = s - 10;
						}

						if (tile.HasRoad)
						{
							s = s + 10;
						}

						tiles.push({
							Tile = tile,
							Score = s
						});
					}
				}

				y = ++y;
			}

			x = ++x;
		}

		if (tiles.len() == 0)
		{
			tiles.push({
				Tile = this.m.Destination.getTile(),
				Score = 0
			});
		}

		tiles.sort(function ( _a, _b )
		{
			if (_a.Score > _b.Score)
			{
				return -1;
			}
			else if (_a.Score < _b.Score)
			{
				return 1;
			}

			return 0;
		});
		local f = this.World.FactionManager.getFaction(this.getFaction());
		local candidates = [];

		foreach( s in f.getSettlements() )
		{
			candidates.push(s);
		}

		local party = f.spawnEntity(tiles[0].Tile, "PuՄk z " + candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly(), true, this.Const.World.Spawn.Southern, 170 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
		party.setDescription("Poborowi żołnierze, lojalni swemu państwu-miastu.");
		party.getLoot().Money = this.Math.rand(50, 200);
		party.getLoot().ArmorParts = this.Math.rand(0, 25);
		party.getLoot().Medicine = this.Math.rand(0, 5);
		party.getLoot().Ammo = this.Math.rand(0, 30);
		local r = this.Math.rand(1, 4);

		if (r <= 2)
		{
			party.addToInventory("supplies/rice_item");
		}
		else if (r == 3)
		{
			party.addToInventory("supplies/dates_item");
		}
		else if (r == 4)
		{
			party.addToInventory("supplies/dried_lamb_item");
		}

		local c = party.getController();
		local occupy = this.new("scripts/ai/world/orders/occupy_order");
		occupy.setTarget(this.m.Destination);
		occupy.setTime(10.0);
		c.addOrder(occupy);
		local guard = this.new("scripts/ai/world/orders/guard_order");
		guard.setTarget(this.m.Destination.getTile());
		guard.setTime(240.0);
		c.addOrder(guard);
		return party;
	}

	function spawnEnemy()
	{
		local cityState = this.World.FactionManager.getFaction(this.getFaction());
		local o = this.m.Destination.getTile().SquareCoords;
		local tiles = [];

		for( local x = o.X - 4; x < o.X + 4; x = x )
		{
			for( local y = o.Y - 4; y <= o.Y - 3; y = y )
			{
				if (!this.World.isValidTileSquare(x, y))
				{
				}
				else
				{
					local tile = this.World.getTileSquare(x, y);

					if (tile.Type == this.Const.World.TerrainType.Ocean)
					{
					}
					else
					{
						local s = this.Math.rand(0, 3);

						if (tile.Type == this.Const.World.TerrainType.Mountains)
						{
							s = s - 10;
						}

						if (tile.HasRoad)
						{
							s = s + 10;
						}

						tiles.push({
							Tile = tile,
							Score = s
						});
					}
				}

				y = ++y;
			}

			x = ++x;
		}

		if (tiles.len() == 0)
		{
			tiles.push({
				Tile = this.m.Destination.getTile(),
				Score = 0
			});
		}

		tiles.sort(function ( _a, _b )
		{
			if (_a.Score > _b.Score)
			{
				return -1;
			}
			else if (_a.Score < _b.Score)
			{
				return 1;
			}

			return 0;
		});
		local f = this.World.FactionManager.getFaction(this.m.Flags.get("EnemyID"));
		local candidates = [];

		foreach( s in f.getSettlements() )
		{
			if (s.isMilitary())
			{
				candidates.push(s);
			}
		}

		local party = f.spawnEntity(tiles[0].Tile, "Kompania " + candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly(), true, this.Const.World.Spawn.Noble, this.Math.rand(100, 140) * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
		party.setDescription("Profesjonalni żołdacy na usługach miejscowych lordów.");
		party.setAttackableByAI(false);
		party.setAlwaysAttackPlayer(true);
		party.getLoot().Money = this.Math.rand(50, 200);
		party.getLoot().ArmorParts = this.Math.rand(0, 25);
		party.getLoot().Medicine = this.Math.rand(0, 5);
		party.getLoot().Ammo = this.Math.rand(0, 30);
		local r = this.Math.rand(1, 4);

		if (r == 1)
		{
			party.addToInventory("supplies/bread_item");
		}
		else if (r == 2)
		{
			party.addToInventory("supplies/roots_and_berries_item");
		}
		else if (r == 3)
		{
			party.addToInventory("supplies/dried_fruits_item");
		}
		else if (r == 4)
		{
			party.addToInventory("supplies/ground_grains_item");
		}

		local c = party.getController();
		local attack = this.new("scripts/ai/world/orders/attack_zone_order");
		attack.setTargetTile(this.m.Destination.getTile());
		c.addOrder(attack);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(this.m.Destination.getTile());
		c.addOrder(move);
		local guard = this.new("scripts/ai/world/orders/guard_order");
		guard.setTarget(this.m.Destination.getTile());
		guard.setTime(999.0);
		c.addOrder(guard);
		return party;
	}

	function onPrepareVariables( _vars )
	{
		local illustrations = [
			"event_152",
			"event_154",
			"event_151"
		];
		_vars.push([
			"illustration",
			illustrations[this.m.Flags.get("DestinationIndex")]
		]);
		_vars.push([
			"holysite",
			this.m.Flags.get("DestinationName")
		]);
		_vars.push([
			"pay",
			this.m.Flags.get("MercenaryPay")
		]);
		_vars.push([
			"employerfaction",
			this.World.FactionManager.getFaction(this.m.Faction).getName()
		]);
		_vars.push([
			"mercenary",
			this.m.Flags.get("Mercenary")
		]);
		_vars.push([
			"mercenarycompany",
			this.m.Flags.get("MercenaryCompany")
		]);
		_vars.push([
			"commander",
			this.m.Flags.get("Commander")
		]);
		_vars.push([
			"holysiteG",
			this.m.Flags.get("DestinationName") == "Wyrocznia" ? "Wyroczni" : this.m.Flags.get("DestinationName") == "Upadła Gwiazda" ? "Upadłej Gwiazdy" : "Starożytnego Miasta"
		]);
		_vars.push([
			"holysiteD",
			this.m.Flags.get("DestinationName") == "Wyrocznia" ? "Wyrocznię" : this.m.Flags.get("DestinationName") == "Upadła Gwiazda" ? "Upadłą Gwiazdę" : "Starożytne Miasto"
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnEnterCallback(null);
			}

			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isHolyWar())
		{
			return false;
		}

		local sites = [
			"location.holy_site.oracle",
			"location.holy_site.meteorite",
			"location.holy_site.vulcano"
		];
		local locations = this.World.EntityManager.getLocations();

		foreach( v in locations )
		{
			foreach( s in sites )
			{
				if (v.getTypeID() == s && v.getFaction() != 0 && !this.World.FactionManager.isAllied(this.getFaction(), v.getFaction()))
				{
					return true;
				}
			}
		}

		return false;
	}

	function onIsTileUsed( _tile )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull() && _tile.ID == this.m.Destination.getTile().ID)
		{
			return true;
		}

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

		if (this.m.Target != null && !this.m.Target.isNull())
		{
			_out.writeU32(this.m.Target.getID());
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

		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});

