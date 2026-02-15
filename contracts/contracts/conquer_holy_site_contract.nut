this.conquer_holy_site_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Target = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.conquer_holy_site";
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

		this.m.Payment.Pool = 1350 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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
		this.m.Flags.set("Commander", this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
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
					"Odbij %holysiteD% z rąk południowych pogan",
					"Zniszcz lub przegoń wrogie pułki w pobliżu"
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

				local cityStates = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);

				foreach( c in cityStates )
				{
					c.addPlayerRelation(-99.0, "Opowiedziałeś się po jednej ze stron w wojnie");
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
					p.Music = this.Const.Music.OrientalCityStateTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "ConquerHolySiteCounterAttack";
					p.Music = this.Const.Music.OrientalCityStateTracks;
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
						p.MapSeed = this.Flags.getAsInt("MapSeed");
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.Music = this.Const.Music.OrientalCityStateTracks;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 200 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
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
						p.Music = this.Const.Music.OrientalCityStateTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
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
						p.MapSeed = this.Flags.getAsInt("MapSeed");
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.Music = this.Const.Music.OrientalCityStateTracks;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, (130 + (this.Flags.get("MercenariesAsAllies") ? 30 : 0)) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
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
						p.MapSeed = this.Flags.getAsInt("MapSeed");
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.Music = this.Const.Music.OrientalCityStateTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
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
						p.Music = this.Const.Music.OrientalCityStateTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
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
					p.MapSeed = this.Flags.getAsInt("MapSeed");
					p.LocationTemplate.Template[0] = "tactical.southern_ruins";
					p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
					p.Music = this.Const.Music.OrientalCityStateTracks;
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, (this.Flags.get("IsCounterAttack") ? 110 : 130) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{Zastajesz %employer%a otoczonego zjazdem świętych mężów, z których każdy wydaje się bardziej uczony od poprzedniego w sprawach intencji i pragnień starych bogów. Ale w rozmowie przebija się jedna myśl: południowcy zajęli %holysite% i trzeba je odzyskać. Pan wskazuje na ciebie.%SPEECH_ON%%companyname% położy kres temu koszmarowi!%SPEECH_OFF%Odsuwając przeorów na bok, %employer% podchodzi bliżej i ścisza głos.%SPEECH_ON%Za właściwą cenę, rzecz jasna. Mam niewielu ludzi do oddania, ale święte ziemie są ważne dla ludu i dla mnie. Musisz tam pójść i wypędzić pogan, aby starzy bogowie nie porzucili nas wraz z naszymi porażkami.%SPEECH_OFF% | Drzwi do komnaty %employer%a otwierają się z impetem i sznur świętych mężów wychodzi. Kilku przystaje, by cię zmierzyć wzrokiem, żaden nie wygląda na zadowolonego z twojej obecności. %employer% macha na ciebie.%SPEECH_ON%Nie przejmuj się ich żałosnymi, oskarżycielskimi spojrzeniami, najemniku. %holysite% zostało utracone na rzecz południowców i wbiło im to zbiorowy kij w zadek. Nie żebym ich winił - nawet zrzęda jak ja ma słabość do świętych ziem. Ci przeorowie chcą tylko, by %holysite% odzyskano pod właściwe królewskie barwy, ale niestety skierowałem swoich żołnierzy gdzie indziej. Ty jednak możesz się tym zająć, za odpowiednią monetę, co?%SPEECH_OFF% | %SPEECH_ON%Starsi bogowie bez wątpienia spoglądają na to pomieszczenie, najemniku.%SPEECH_OFF%%employer% kręci kielichem, wino chlapie po krawędzi i zostawia purpurowy połysk.%SPEECH_ON%Południowcy zajęli %holysite% i bez wątpienia je sprofanowali. Wolałbym, by pies znalazł sobie miejsce do sikania na świętej ziemi, niż żeby jeden z tych południowych gnojków stał w rzekomej wzniosłości ich boga. Jak mu tam było, Gilder? Co za stek końskiego łajna. Idź tam, zabij ich wszystkich i przywróć %holysite% należny status.%SPEECH_OFF% | %employer% jest w ogrodzie i niemal ostentacyjnie sam. Ludzie przy ogrodzeniu boją się nawet spojrzeć w jego stronę. Ty jednak wchodzisz bez wahania. Wpatruje się w rozkopane mrowisko, a owady krzątają się, by je odbudować. Szlachcic wzdycha.%SPEECH_ON%Czasem zastanawiam się, czy starzy bogowie patrzą na nas w taki sam sposób.%SPEECH_OFF%Zauważasz, że zwykle dostrzegasz mrówki dopiero, gdy gryzą. Szlachcic wstaje.%SPEECH_ON%Wiedz, że są pożyteczne dla ogrodu, najemniku. Jeśli gryzą, to bez namiętności. Robią tylko to, co wiedzą, tak jak wiedzą, że trzeba odbudować dom, gdy go rozwalę. Tak samo, gdy dowiedziałem się, że południowe karaluchy tymczasowo wtargnęły do %holysite%, wiedziałem, z woli starych bogów, że trzeba je wytępić i zniszczyć.%SPEECH_OFF%Spodziewasz się, że szlachcic porówna cię do mrówki, ale zamiast tego oferuje ci sporą sumę koron, byś udał się do świętych ziem i złamał tych, którzy je zajmują.%SPEECH_ON%Byłbyś jak osa w ogrodzie, być może.%SPEECH_OFF%Szlachcic mówi, a ty odpowiadasz stoickim skinieniem głowy. | %SPEECH_ON%Nie jestem od garncarstwa, najemniku, więc gdy mówię, że południowe skurwiele są niżej niż księżycowa rozpusta alfonsa, wiedz, że samo ich wtargnięcie pchnęło mnie na drogę pieśniarza.%SPEECH_OFF%Masz ochotę powiedzieć %employer%owi, że chodziło mu pewnie o 'poezję', ale w pewnym sensie tłucze tu garnki. Poza tym najwyraźniej widzi w tobie kogoś o glinianych stopach.%SPEECH_ON%Dzikusy zajęły %holysite% i krążą pogłoski, że zabili nawet wszystkich 'niewiernych'. Moi żołnierze są rozproszeni, pól bitew aż nadto. Ty jednak jesteś dostępny. I owszem, jesteś chciwym skurczybykiem, ale wiem też, że %companyname% to dokładnie ta siła i zawziętość, których potrzebujemy, by wygnać tych drani ze świętych ziem.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Południowcy rozłożyli się w i wokół %holysite%. Mając czas po swojej stronie, wznieśli solidną obronę, ale nic, z czym %companyname% nie da sobie rady. Dobywasz miecza i przygotowujesz ludzi do szturmu.}",
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
			Text = "[img]gfx/ui/events/event_78.png[/img]{%holysite% jest już oblegane przez ludzi niosących sztandar %employerfaction%. Gdy się zbliżasz, mężczyzna wychodzi na spotkanie. Unosi dłoń, po czym kładzie ją na pasie.%SPEECH_ON%Doszły mnie wieści, że przysyłają najemników i wygląda na to, że to wy. %companyname%, tak? Jestem %commander%, porucznik %employer%a. Dołączę do was w tępieniu tych pustynnych szczurów. Obawiam się, tak jak wy, że starzy bogowie ukarzą nas wszystkich, jeśli nie zajmiemy się tym niezwłocznie.%SPEECH_OFF%Porucznik spluwa i przeciera dłonią siwą brodę.%SPEECH_ON%Cóż. Niech starzy bogowie widzą nas takimi, jacy jesteśmy, a my zarżniemy tych pustynnych osiłków w sposób najzupełniej słuszny.%SPEECH_OFF% | %holysite% jest już oblegane przez ludzi niosących sztandar %employerfaction%. Dowódca wychodzi naprzód i mówi głośno.%SPEECH_ON%%companyname%, nazywam się %commander%, porucznik w polowej armii %employer%a. Przyszedłem do was dołączyć, a raczej wy dołączycie do mnie, by pójść do %holysite% i wyrwać stamtąd południowe ścierwo z każdego skrawka tego miejsca. Starzy bogowie czuwają nad nami wszystkimi, nawet nad wami, najemnicy, a dzisiejsza porażka skazałaby nas na każde możliwe piekło.%SPEECH_OFF%Jasne. Chcesz tylko mieć pewność, że %employer% wypłaci ci pełną należną kwotę, niezależnie od tego, czy otrzymasz pomoc. | %holysite% jest już oblegane przez ludzi niosących sztandar %employerfaction%. To zjazd świętych mężów i żołnierzy, a porucznik prowadzący oddział dobywa miecza i wskazuje nim %holysite%.%SPEECH_ON%Południowe lizusy albo odejdą, albo na łasce naszej stali poślemy ich do piekieł starych bogów. Nie ma innej drogi. Naprzód, najemnicy!%SPEECH_OFF%Wygląda na to, że %companyname% będzie miało w tym przedsięwzięciu trochę pomocy, choć w pełni oczekujesz otrzymać całą obiecaną nagrodę.}",
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
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{%holysite% otrzymało posiłki! Na szczęście jest i dobra strona: dodatkowe miecze dodały im odwagi, by opuścić naturalne umocnienia świętego miejsca i wyjść ci naprzeciw na otwartym polu. | Zaskakuje cię, że obrońcy opuszczają %holysite% i maszerują przez otwarte pole. Szybki meldunek zwiadowców mówi, że w ciągu ostatnich dni dostali posiłki i ośmieliła ich sama liczebność. Z jednej strony gęste szeregi niepokoją, z drugiej starcie na równym terenie będzie znacznie łatwiejsze. Choć szczerze uważasz, że ich błędem jest w ogóle stawać przeciw %companyname%.}",
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
			Text = "[img]gfx/ui/events/event_134.png[/img]{Gdy %holysite% wyłania się w oddali, podchodzi do ciebie mężczyzna niemal niepokojąco do ciebie podobny. Ma przy sobie płatnika i kilku najemników.%SPEECH_ON%Dobry wieczór, kapitanie. Jestem %mercenary% z %mercenarycompany%. Przybyłem na te ziemie po koronę, tak jak ty. Założę się, że ten tłusty szlachcic umoczył pióro w porządnym kontrakcie dla ciebie i twoich ludzi, ale co powiesz na to, byś zapłacił mi %pay% koron, a ja pomogę w tej sprawce? Chyba że wolisz, abym zaoferował swoje usługi tamtej stronie.%SPEECH_OFF% | Podchodzi do ciebie grupa mężczyzn; jeden z nich ma chód i posturę dziwnie podobne do twoich. Przedstawia się jako %mercenary%, kapitan %mercenarycompany%.%SPEECH_ON%Myślałem, że %employer% pośle swoją zawodową armię, by dopilnowała zmiany władzy nad świętym miejscem. Przyznam, kapitanie, że to ja pomogłem tym pustynnym szaleńcom zająć ten dostojny monument w pierwszej kolejności. Jednak za %pay% koron chętnie pomogę wam je odzyskać. Jako kolega po fachu na pewno widzisz, że to dobry interes dla wszystkich.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_134.png[/img]{%SPEECH_START%To szkoda.%SPEECH_OFF%%mercenary% mówi, po czym szybko truchta z powrotem do szeregów %mercenarycompany%. Cofa się prosto w żołnierzy broniących %holysite%. Ręce ma szeroko rozłożone i wachluje nimi, jakby płynął pod prąd.%SPEECH_ON%Cholerny wstyd, mówię! No cóż, kapitanie %companyname%, zobaczmy, która strona kupiła lepszego najemnika, co?%SPEECH_OFF%Najemnik dobywa broni, podobnie jak południowi żołnierze w %holysite% za nimi. Oczywiście ty także dobywasz broni. Czas walczyć. | %SPEECH_ON%No tak, widzę. Cóż. Nie spodziewałem się wiele. W końcu też sprzedaję miecz. A teraz...%SPEECH_OFF%Idzie tyłem do swojej kompanii, a ta do szeregów południowych żołnierzy broniących %holysite%.%SPEECH_ON%Teraz to południe jest najwyższym oferentem.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_164.png[/img]{Bitwa dobiegła końca, ale w oddali miga złoty blask. Gdy wpatrujesz się w horyzont, pojawia się oddział południowców, ich lśniący wygląd z pewnością ma być widoczny. To kontratak! | Gdy chowasz ostrze, %randombrother% woła. Wskazuje na horyzont. Nadciąga linia południowców, ich zbroje błyszczą, a chód jest pełen pewności. Kontratakujący chcą być widoczni i bez wątpienia zamierzają zwyciężyć...}",
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
			Text = "[img]gfx/ui/events/event_164.png[/img]{Podejście południowców jest nieustępliwe.%SPEECH_ON%Karaluchy, one się nie kończą.%SPEECH_OFF%Spoglądasz na %randombrother%a, który kręci głową. Unosi but i strąca z czubka robaka. Stawia stopę i kiwa głową w stronę atakujących.%SPEECH_ON%Nie martw się, kapitanie, doprowadzimy obronę %holysite% do świetnego stanu na tych dzikich drani.%SPEECH_OFF% | Rozkazujesz ludziom bronić miejsca.%SPEECH_ON%Trzymać pozycję w %holysite% - co za czasy.%SPEECH_OFF%%randombrother% mówi. Kiwasz głową i mówisz, że masz nadzieję, iż kiedyś będzie to dla niego tylko wspomnienie. Śmieje się i pyta, jak mógłby zapomnieć. Inny najemnik wtrąca, że jest jeden pewny sposób, by zapomnieć, ale ucinasz to i każesz ludziom skupić się na zadaniu.}",
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
			Text = "[img]gfx/ui/events/event_164.png[/img]{Umocnienia nie wyglądają już tak solidnie jak wcześniej. Rozkazujesz %companyname% wyjść w szyku na pole, gdzie żadne wadliwe konstrukcje nie będą przeszkadzać w dowodzeniu. Południowy porucznik wita cię.%SPEECH_ON%Zbezczeszczasz %holysite% krwią, za to sam Gilder bez wątpienia wywiódł cię na pole, byś zginął jak przystało. Co na to powiesz?%SPEECH_OFF%Dobywasz miecza.%SPEECH_ON%To nie była moja krew.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Chowasz broń i wysyłasz kompanię, by pozbierała, co się da z poległych, i czujesz dziwnie, że nie pierwszy raz %holysite% ogląda taką rzeź. Cóż, jeśli ktoś ma ginąć śladami przodków, cieszysz się, że to nie ty. Kilku północnych żołnierzy przybywa, by zabezpieczyć święty teren, gdy ruszasz z powrotem do %employer%a. | Wróg pokonany, a %holysite% odzyskane. Tłum wiernych powoli napływa, mijając zwłoki, by paść na twarz w najświętszym z miejsc. Nikt ci nie dziękuje. I tak to rola %employer%a. Oddział północnych żołnierzy mija cię w drodze, każdy z nich spogląda z drwiną i szyderstwem. | Po bitwie drobne grupki wiernych zaczynają zbierać się w zakamarkach %holysite%. Nie wiesz nawet, skąd się wzięli. Im nie przeszkadzasz i oni nie przeszkadzają tobie. Liczy się teraz, że %employer% będzie miał ogromny skarbiec koron na twój powrót. Gdy tylko nadciąga kilku północnych żołnierzy, ruszasz w drogę.}",
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
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{%holysite% padło łupem południowców. Jeden z najemników kręci głową.%SPEECH_ON%Cóż. Podejrzewam, że będą wszędzie, świecąc albo srając.%SPEECH_OFF%Owszem. Ze świętym miejscem straconym nie ma powodu wracać do %employer%a, chyba że chcesz oglądać inne święte widowisko.}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{Przyorat w %townname% pęka w szwach od chłopów, więcej niż kiedykolwiek widziałeś. %employer% stoi na schodach i wita cię, kładąc dłoń na twoim ramieniu.%SPEECH_ON%Witaj z powrotem, najemniku. Może i jesteś drobnym łobuzem szukającym swoich monet, ale niesiesz ze sobą gniew starych bogów. %holysite% jest teraz tam, gdzie jego miejsce.%SPEECH_OFF%Szlachcic pstryka palcami i kilku pulchnych mnichów wytacza skrzynie z %reward% koronami. %employer% zawraca na schody.%SPEECH_ON%Powiem parę słów do tłumu, jak ci było na imię? Ach, pewnie wolisz, by zasługę przypisano kompanii. Podziękuję więc całej %companyname%.%SPEECH_OFF% | %employer% przegląda mapy bitewne.%SPEECH_ON%Zabawne, że gdy wysyłam swoich ludzi, wracam z porażkami, ale gdy starzy bogowie rozpętują piekło, wynajmuję najemników i otrzymuję... zwycięstwo. Oby %holysite% znów w naszych rękach pchnęło moich ludzi do walki tak jak %companyname%. Za %reward% koron odesłałeś południowe ścierwo do piekieł ich pustyni i wzmocniłeś całe wysiłki wojenne. Prawie powiedziałbym, że cię niedopłaciłem, najemniku. Prawie.%SPEECH_OFF% | %SPEECH_ON%Gdy zwiadowcy wrócili, pierwsze co zrobili, to poszli do przyoratu. Tak wiedziałem, że odniosłeś sukces. Każdemu z nich dałem też po dniu w lochu za opuszczenie obowiązków wobec mnie.%SPEECH_OFF%%employer% siedzi na dziwnie wyglądającej poduszce, chyba zdobytej podczas tych wojen z południem. Kołysze wino w kielichu.%SPEECH_ON%Twoje %reward% koron czeka na zewnątrz. Muszę zapytać, czy tam na dole słyszałeś coś? Może szepty starych bogów? A może pomruki o tym, którego zwą... jak mu tam... Gilder?%SPEECH_OFF%Kręcisz głową. Szlachcic wzrusza ramionami.%SPEECH_ON%Szkoda. Człowiek się zastanawia, co musi się stać, by bogowie znów do nas przyszli.%SPEECH_OFF%Mówisz mu, że %reward% koron wydane w odpowiednim kierunku to dobry początek. Szlachcic uśmiecha się zadziornie i spełnia to życzenie. | %employer% siedzi z młodą, opaloną kobietą, wyraźnie z południowych krain. Ogląda ją od stóp do głów.%SPEECH_ON%Starsi bogowie zesłali mi to, tak jak, zakładam, zesłali mi ciebie.%SPEECH_OFF%Plącze się na chwilę w słowach i odchrząkuje.%SPEECH_ON%To znaczy, w innym sensie, oczywiście. Twoje zwycięstwa w %holysite% pokrzepiły ludzi, zdejmując z ich barków klątwę porażki. Mnisi znów mają wiernych w swojej trzodzie, a dzięki gorliwości udowodnimy starym bogom naszą wartość.%SPEECH_OFF%Odsuwa kobietę i próbuje wstać, ale poduszka jest zbyt głęboka, być może zbyt wygodna. Zostaje więc na miejscu.%SPEECH_ON%Twoje %reward% koron będą w holu. Poślij jednego z moich służących, by zabrał tę pustynną dziewczynę na modlitwy w przyoracie.%SPEECH_OFF% | Zastajesz %employer%a w jednej z miejskich świątyń, stojącego pod posągiem jednego ze starych bogów.%SPEECH_ON%Wieści o twoich sukcesach dotarły do mnie. Miasto jest zachwycone, a cały region szepcze z radości. O tobie nie będą mówić, oczywiście, będą mówić o mnie.%SPEECH_OFF%Szlachcic wydaje się bardzo z siebie zadowolony. Odwraca się i klepie cię po ramieniu.%SPEECH_ON%Mam nadzieję, że to południowe ścierwo nie sprawiło ci zbyt wielkich problemów. Moi porucznicy przyniosą twoje %reward% koron. A powiedz, czy %holysite% warto odwiedzić? Nigdy tam nie byłem. Właściwie nie mam ochoty. Jestem błogosławiony wszędzie, gdzie postawię stopę.%SPEECH_OFF%Zaciskasz wargi, gdy szlachcic odchodzi.}",
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
			if (s.isMilitary())
			{
				candidates.push(s);
			}
		}

		local party = f.spawnEntity(tiles[0].Tile, "Kompania " + candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly(), true, this.Const.World.Spawn.Noble, 170 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
		party.setDescription("Profesjonalni żołdacy na usługach miejscowych lordów.");
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
			candidates.push(s);
		}

		local party = f.spawnEntity(tiles[0].Tile, "PuՄk z " + candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly(), true, this.Const.World.Spawn.Southern, this.Math.rand(100, 140) * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
		party.setDescription("Poborowi żołnierze, lojalni swemu państwu-miastu.");
		party.setAttackableByAI(false);
		party.setAlwaysAttackPlayer(true);
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

