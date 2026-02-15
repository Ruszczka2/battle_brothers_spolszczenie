this.slave_uprising_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Target = null,
		IsEscortUpdated = false,
		IsPlayerAttacking = false
	},
	function setLocation( _l )
	{
		this.m.Destination = this.WeakTableRef(_l);
	}

	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = this.Math.rand(70, 105) * 0.01;
		this.m.Type = "contract.slave_uprising";
		this.m.Name = "Bunt Niewolników";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 450 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.m.Flags.set("SpartacusName", this.Const.Strings.SouthernNames[this.Math.rand(0, this.Const.Strings.SouthernNames.len() - 1)] + " " + this.Const.Strings.SouthernNamesLast[this.Math.rand(0, this.Const.Strings.SouthernNamesLast.len() - 1)]);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Stłum bunt zadłużonych w: %location% w pobliżu %townname%"
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 20)
				{
					this.Flags.set("IsOutlaws", true);
					this.Contract.m.Destination.setActive(false);
					this.Contract.m.Destination.spawnFireAndSmoke();
				}
				else if (r <= 40)
				{
					this.Flags.set("IsSpartacus", true);
				}
				else if (r <= 60)
				{
					this.Flags.set("IsFleeing", true);
				}
				else
				{
					this.Flags.set("IsFightingBack", true);
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Stłum bunt zadłużonych w: %location% w pobliżu %townname%"
				];
				this.Contract.m.Destination.getSprite("selection").Visible = true;
				this.Contract.m.Destination.setOnEnterCallback(this.onDestinationEntered.bindenv(this));
			}

			function update()
			{
				if (this.Flags.get("IsVictory"))
				{
					if (this.Flags.get("IsSpartacus"))
					{
						this.Contract.setScreen("Spartacus4");
					}
					else if (this.Flags.get("IsFightingBack"))
					{
						this.Contract.setScreen("FightingBack2");
					}

					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
			}

			function onDestinationEntered( _dest )
			{
				if (this.Flags.get("IsFleeing"))
				{
					this.Contract.setScreen("Fleeing1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsOutlaws"))
				{
					this.Contract.setScreen("Outlaws1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsSpartacus"))
				{
					this.Contract.setScreen("Spartacus1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsFightingBack"))
				{
					this.Contract.setScreen("FightingBack1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "SlaveUprisingContract")
				{
					this.Flags.set("IsVictory", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_Outlaws",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Zapoluj na zadłużonych, którzy zajmują się bandytyzmem w okolicach %townname%"
				];
				this.Contract.m.Destination.getSprite("selection").Visible = false;
				this.Contract.m.Destination.setOnEnterCallback(null);
				this.Contract.m.Home.getSprite("selection").Visible = false;

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull())
				{
					this.Contract.setScreen("Outlaws3");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerInitiated )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerInitiated;
				this.World.Contracts.showCombatDialog();
			}

		});
		this.m.States.push({
			ID = "Running_Fleeing",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Zapoluj na zadłużonych, którzy uciekają z %townname%"
				];
				this.Contract.m.Destination.getSprite("selection").Visible = false;
				this.Contract.m.Destination.setOnEnterCallback(null);
				this.Contract.m.Home.getSprite("selection").Visible = false;

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull())
				{
					this.Contract.setScreen("Fleeing3");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerInitiated )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerInitiated;

				if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Contract.setScreen("Fleeing2");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog();
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Wróć do %townname%"
				];
				this.Contract.m.Destination.getSprite("selection").Visible = false;
				this.Contract.m.Destination.setOnEnterCallback(null);
				this.Contract.m.Home.getSprite("selection").Visible = true;
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
			Text = "[img]gfx/ui/events/event_162.png[/img]{Zwykle otoczony kontemplacyjnym przepychem, %employer% jest dziś w wirze doradców i współwezyrów, każdy radzi drugiemu, pstrykając palcami i agresywnie wskazując na mapę. Mimo całego zgiełku mały sługa przeciska się przez tłum i podaje ci zwój. Sprawnie wyjaśnia, że zadłużeni przejęli swoich panów w %location% należącym do %townname%.%SPEECH_ON%Prosimy o usługi Koroniarza. Jeśli chcesz uczestniczyć w przywróceniu właściwego porządku i dla dobra zarówno zadłużonych, jak i ich panów, weź to pióro i postaw krzyżyk tutaj.%SPEECH_OFF%Patrzy na ciebie, ty na niego. Wzdycha i stuka w miejsce na stronie.%SPEECH_ON%Zapłata, jeśli się zgodzisz, tutaj. %reward% koron.%SPEECH_OFF% | Gdy zbliżasz się do komnat %employer%a, dwóch strażników rusza, by przywitać cię końcami halabard. Z korytarza dobiega krzyk i pospieszne kroki, bo wtrąca się sługa, który zbiega w twoją stronę.%SPEECH_ON%Straże! Ci niechlujnie odziani wędrowcy to Koroniarze. Wybacz, Koroniarzu, jesteśmy w napięciu, bo wezyrowie mogą potrzebować twojej pomocy: zadłużeni przejęli %location% w %townname%. Bunt może się stamtąd rozlać.%SPEECH_OFF%Sługa wyciąga zwój i podaje ci go. Głosi, że na tych, którzy zduszą bunt zadłużonych, czeka %reward% koron, a zwój nosi pieczęć wezyrów %townname%. | Wezyrowie %townname% są razem w swojej sali narad i w powietrzu jest większe napięcie niż zwykle. Nie pozwalają ci podejść bliżej. Nie wiesz jak, ale z sufitu opuszczono wielkie złote kraty. Dyskutują, kiwają głowami, po czym podają zwój słudze. Widzisz, jak sługa pędzi do ciebie. Podaje zwój i powtarza z pamięci jego słowa.%SPEECH_ON%Zadłużeni obalili swoich panów i przejęli %location%. %reward% koron trafi do skarbca człowieka lub ludzi, którzy zgnębią tę bandę buntowników.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Nie mają szans. | Zrobimy z nich przykład dla reszty. | Odbijemy %location%.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{To nie brzmi jak robota dla nas. | Nie sądzę. | Nie zajmujemy się walką z byłymi niewolnikami.}",
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
			ID = "FightingBack1",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Zadłużeni w %location% widzą, że nadchodzisz, i liczysz, że widok waszej broni zniechęci ich do dalszych prób wolności. Ku zaskoczeniu nie składają oręża, tylko zbierają się, by ci się przeciwstawić. To prymitywna zgraja, ludzie, których przymusowa praca i werbunek złamały na wiele sposobów. | Odnajdujesz zadłużonych, a oni patrzą na ciebie ze świadomością, po co tu jesteś. Ty uzbrojony po zęby, idący z miasta, oni z tym, co zdołali zdobyć, daleko od swoich kajdan. To zbieranina smutna i żałosna, ale wiesz dobrze, że to, czego im brak w uzbrojeniu, nadrabiają pragnieniem. Smak wolności ostrzy jak stal. | Jak mówiono, zadłużeni przejęli %location% i uzbroili się w cokolwiek znaleźli. Na twój widok próbują jakiejś namiastki szyku, ale brakuje im wyszkolenia, dyscypliny, jedzenia i wielu innych rzeczy. Mają jednak coś, czego im nie brak: żadnej chęci powrotu tam, skąd przyszli, a to bywa stalą ostrą i niebezpieczną jak każda inna.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zniszczyć ich!",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.OrientalBanditTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.Template[0] = "tactical.desert_camp";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.None;
						p.LocationTemplate.CutDownTrees = true;
						p.Tile = tile;
						p.CombatID = "SlaveUprisingContract";
						p.TerrainTemplate = "tactical.desert";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.NomadRaiders, 30 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getID());
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Slaves, 55 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "FightingBack2",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Bunt został stłumiony. W śmierci na twarzach niewolników widać ulgę, jakby koniec wszystkiego był lepszy od bezlitosnego okrucieństwa życia w łańcuchu. %employer% i wezyrowie będą oczekiwać twojego powrotu.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nasza praca skończona.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Outlaws1",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_176.png[/img]{Docierasz do %location% i zastajesz je spalone i splądrowane. Ocaleniec wyłania się z osmalonych resztek budynku. Wyjaśnia, że zadłużeni rzucili się na wszystkich, gwałcili kobiety, zabijali dzieci, kradli wszystko, co miało wartość, po czym rozproszyli się po pustkowiach. | Bunt zadłużonych dawno opuścił %location%, zostawiając za sobą ślad zniszczenia i śmierci. Kilku ocalałych krąży, zbierając swoje rzeczy. Ci, którzy jeszcze mówią, opowiadają o okropnościach: zadłużeni rzucili się na okolicę jak dzicy, zabijali, gwałcili, rabowali. Mężczyzna z oczami zasłoniętymi łachmanami mówi, że słyszał, jak mówili o ruszeniu na wieś i rozdzieleniu się tam.%SPEECH_ON%Teraz to zwykli bandyci. Zwierzęta, które posmakowały krwi, dla nich nie ma już powrotu do bezpieczeństwa łańcucha. Są zgubieni.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zapolujemy na nich.",
					function getResult()
					{
						this.World.uncoverFogOfWar(this.Contract.m.Target.getPos(), 400.0);
						this.World.getCamera().moveTo(this.Contract.m.Target);
						this.Contract.setState("Running_Outlaws");
						return 0;
					}

				}
			],
			function start()
			{
				local cityTile = this.Contract.m.Home.getTile();
				local nearest_nomads = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getNearestSettlement(cityTile);
				local tile = this.Contract.getTileToSpawnLocation(this.Contract.m.Home.getTile(), 9, 15);
				local party = this.World.FactionManager.getFaction(nearest_nomads.getFaction()).spawnEntity(tile, "ZadՄuքeni", false, this.Const.World.Spawn.NomadRaiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.setDescription("Grupa zadłużonych, która jęła się bandytyzmu.");
				party.setFootprintType(this.Const.World.FootprintsType.Nomads);
				party.getSprite("banner").setBrush(nearest_nomads.getBanner());
				party.getSprite("body").setBrush("figure_nomad_03");
				this.Contract.m.UnitsSpawned.push(party);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.setVisibleInFogOfWar(true);
				party.setImportant(true);
				party.setDiscovered(true);
				party.setAttackableByAI(false);
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Home);
				roam.setMinRange(8);
				roam.setMaxRange(12);
				roam.setAllTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
				roam.setTerrain(this.Const.World.TerrainType.Shore, false);
				roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
				c.addOrder(roam);
			}

		});
		this.m.Screens.push({
			ID = "Outlaws3",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_168.png[/img]{Patrzysz na zwłoki niewolnika, ciało uformowane przez pracę poprzedniego życia, a w dłoniach i na szyi ozdoby ze skradzionej broni i łupów. W okrutnej myśli dziwi cię, że łatwiej byłoby ich spacyfikować, gdyby poza wolnością nie mieli żadnych ambicji. To ich chciwość i pragnienie czyniły ich groźniejszymi. Ale... są martwi. A wezyrowie %townname% będą zadowoleni niezależnie od wzniosłych celów zadłużonych.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nasza praca skończona.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Spartacus1",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_166.png[/img]{Zastajesz zadłużonych siedzących wśród pustynnych głazów i nie podnoszą się na twój widok. Zamiast tego podchodzi do ciebie jeden mężczyzna. Mimo potężnej postury wyczuwasz, że przyszedł targować się, dyplomacja kryje się w mięśniach i języku.%SPEECH_ON%Koroniarzu, wiedziałem, że przyjdziesz. Nazywam się %spartacus%, wybrany przywódca tych poszukiwaczy wolności, o ile otwarta klatka jest przywódcą ptaka, który chce latać. Przychodzisz do nas złoconą drogą, prowadzony łańcuchem niewidzialnego złota, obietnic, których nie możesz zagwarantować, i to na mocy tych fałszywych umów, tych źle zrozumianych porządków, masz nas zabić lub pojmać. Czy tak?%SPEECH_OFF%Kiwasz głową. %spartacus% kiwa w odpowiedzi.%SPEECH_ON%Tak jest. Zanim oddamy się tym umowom, zanim my zostaniemy panami własnych rąk, a ty niewolnikiem potężnej korony, pozwól, że spróbuję negocjować w sposób, który uznasz, Koroniarzu, za korzystny.%SPEECH_OFF%Mężczyzna klęka.%SPEECH_ON%Jestem potomkiem utraconej rodziny, utraconego dziedzictwa, utraconego majątku. Ci ludzie, ci mężczyźni, to teraz moja rodzina. Z dawnego życia mam jednak coś, co może być dla ciebie cenne.%SPEECH_OFF%Wyciąga kartkę.%SPEECH_ON%Pozwól nam odejść, a zapiszę na tej kartce miejsce skarbów, których nie znajdziesz nigdzie indziej. Zaatakuj nas, a zabiorę ostatnie rodowe pamiątki do grobu i ostatnie tchnienie zużyję nie na żal za utraconym bogactwem, lecz na gorący płomień wolności, lśniący w moich płucach, a ból będzie lepszy od wygód jakiegokolwiek łańcucha.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zgadzam się na wasze warunki. Będziecie mieć swoją wolność.",
					function getResult()
					{
						return "Spartacus2";
					}

				},
				{
					Text = "To tylko interesy. Wasza mała rebelia zaraz zostanie stłamszona.",
					function getResult()
					{
						return "Spartacus3";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Spartacus2",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_166.png[/img]{Wyciągasz dłoń. %spartacus% wyciąga swoją. Mówi.%SPEECH_ON%Tak jest.%SPEECH_OFF%Unosi ołówek zrobiony z kamienia, z końcówką z czarnego, sproszkowanego minerału. Wskazuje odległy głaz.%SPEECH_ON%Kiedy odejdziemy, zapiszę tam miejsce rodowych pamiątek. Widzę teraz na twojej twarzy pytanie, czy kłamię. Taka niepewność to cena wolności, prawda? Nie wiesz, dokąd idziesz, ale idziesz z własnej woli. To jest prawdziwa wolność. Wygoda klatki jest dla ptaków, które nie chcą latać, Koroniarzu. Niech twoje podróże złoconą drogą będą tak owocne, jak nasze pierwsze kroki.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Cieszcie się wolnością, póki możecie.",
					function getResult()
					{
						local bases = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
						local location;
						local lowest_distance = 9000;

						foreach( b in bases )
						{
							if (!b.getLoot().isEmpty() && !b.getFlags().get("IsEventLocation"))
							{
								local d = b.getTile().getDistanceTo(this.Contract.m.Home.getTile()) + this.Math.rand(1, 5);

								if (d < lowest_distance)
								{
									location = b;
									lowest_distance = d;
								}
							}
						}

						if (location == null)
						{
							bases = this.World.EntityManager.getLocations();

							foreach( b in bases )
							{
								if (!b.getLoot().isEmpty() && !b.getFlags().get("IsEventLocation") && !b.isAlliedWithPlayer() && b.isLocationType(this.Const.World.LocationType.Lair))
								{
									local d = b.getTile().getDistanceTo(this.Contract.m.Home.getTile()) + this.Math.rand(1, 5);

									if (d < lowest_distance)
									{
										location = b;
										lowest_distance = d;
									}
								}
							}
						}

						this.World.uncoverFogOfWar(location.getTile().Pos, 700.0);
						location.getFlags().set("IsEventLocation", true);
						location.setDiscovered(true);
						this.World.getCamera().moveTo(location);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationMajorOffense, "Sided with indebted in their uprising");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Spartacus3",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_166.png[/img]{%spartacus% wyciąga dłoń, ale ty nie wyciągasz swojej. Zamiast tego dobywasz miecza. Przywódca buntu kiwa głową.%SPEECH_ON%Dobrze. Nie wolno ci opuścić klatki korony, widzę, i wzywa cię błysk złoconej drogi, tak pilne twoje zniewolenie, tak pełne, że gdy brama jest otwarta, nie rozpościerasz skrzydeł, tylko zadowalasz się skokiem na palec pana. Niech bitwa będzie nam łaskawa, Koroniarzu.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.OrientalBanditTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.Template[0] = "tactical.desert_camp";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.None;
						p.LocationTemplate.CutDownTrees = true;
						p.Tile = tile;
						p.CombatID = "SlaveUprisingContract";
						p.TerrainTemplate = "tactical.desert";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.NomadRaiders, 30 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getID());
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Slaves, 55 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Spartacus4",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_168.png[/img]{Stoisz nad %spartacus%em. Mimo umiłowania wolności martwy przywódca buntu nie uśmiecha się w swojej ostatniej, wyzwolonej chwili. Twarz ma wykrzywioną bólem, a rany odsłaniają śliskie wzory tego, co kryje się pod skórą. Ale jego oczy. Jest w nich iskra, wpatrzona w niebo. Cień przecina mu spojrzenie i unosisz wzrok, spodziewając się ptaka, ale niczego nie ma. Gdy spoglądasz z powrotem, iskra znikła, a martwy człowiek jest po prostu martwym człowiekiem.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nasza praca skończona.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Fleeing1",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_59.png[/img]{Znajdujesz stertę rozgrzanych do dotyku kajdan. Stary mężczyzna wskazuje ręką północ.%SPEECH_ON%Uwolnieni poszli tamtędy.%SPEECH_OFF%Ciekaw, pytasz, czemu donosi na zadłużonych. Uśmiecha się.%SPEECH_ON%Mam robotę do dokończenia, a czasem wezyrowie pożyczają mi kilku. Trudno dobrze zrobić zadanie tylko własnymi dłońmi.%SPEECH_OFF% | Natykasz się na długi ślad piasku, ziemi i zarośli, wyraźnie poruszony w stronę północy. Wśród rozrzuconych śmieci znajdujesz kajdanę, ostatni potrzebny ślad. Zadłużeni poszli na północ i musisz ich upolować. | Znajdujesz kajdanę kołyszącą się na krzewie pustynnych zarośli. Stary mężczyzna, popijając wodę z kubka, mruczy i wskazuje północ.%SPEECH_ON%Zadłużeni zwiali tamtędy. Jeśli zdołasz zagonić ich z powrotem do Wezyra, powiedz o mnie dobre słowo. Przydałby mi się jeden czy dwóch, żeby nosili wodę. Żaden wolny mi wody nie nosi.%SPEECH_OFF%Nie masz zamiaru nikogo polecać, ale i tak mu dziękujesz i ruszasz na północ.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zapolujemy na nich.",
					function getResult()
					{
						this.World.uncoverFogOfWar(this.Contract.m.Target.getPos(), 400.0);
						this.World.getCamera().moveTo(this.Contract.m.Target);
						this.Contract.setState("Running_Fleeing");
						return 0;
					}

				}
			],
			function start()
			{
				local cityTile = this.Contract.m.Home.getTile();
				local nearest_nomads = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getNearestSettlement(cityTile);
				local tile = this.Contract.getTileToSpawnLocation(this.Contract.m.Home.getTile(), 9, 15);
				local party = this.World.FactionManager.getFaction(nearest_nomads.getFaction()).spawnEntity(tile, "ZadՄuքeni", false, this.Const.World.Spawn.Slaves, 90 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.setDescription("Grupa zadłużonych.");
				party.setFootprintType(this.Const.World.FootprintsType.Nomads);
				party.getSprite("banner").setBrush("banner_deserters");
				this.Contract.m.UnitsSpawned.push(party);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.setVisibleInFogOfWar(true);
				party.setImportant(true);
				party.setDiscovered(true);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);
				local c = party.getController();
				local randomVillage;
				local northernmostY = 0;

				for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = i )
				{
					local v = this.World.EntityManager.getSettlements()[i];

					if (v.getTile().SquareCoords.Y > northernmostY && !v.isMilitary() && !v.isIsolatedFromRoads() && v.getSize() <= 2)
					{
						northernmostY = v.getTile().SquareCoords.Y;
						randomVillage = v;
					}

					i = ++i;
				}

				local move = this.new("scripts/ai/world/orders/move_order");
				move.setDestination(randomVillage.getTile());
				c.addOrder(move);
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(9000.0);
				c.addOrder(wait);
				this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Destination.getTile(), party.getTile(), this.Const.GenericFootprints, this.Const.World.FootprintsType.Nomads, 0.75);
			}

		});
		this.m.Screens.push({
			ID = "Fleeing2",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_59.png[/img]{Wreszcie doganiasz zadłużonych. To już zahartowani w drodze ludzie, jałowy teren odcisnął na nich ślad, tak jak oni na nim. Ale nie zaszli tak daleko, by teraz się poddać: na twój widok wszyscy chwytają broń i ruszają naprzeciw. | Zadłużeni są w desperackim stanie; choć podróż dała im wolny oddech, zapłacili za to ciałem i umysłem. Spaleni słońcem, sponiewierani i poszarpani zbliżają się z oczami szerokimi i zmęczonymi. Po dzikich spojrzeniach wiesz, że nie mają w sobie już odwrotu. Będą walczyć tak czy inaczej.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zniszczyć ich!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Fleeing3",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_168.png[/img]{Gdy już wszystko się kończy, położenie kresu zadłużonym jest prostą sprawą. Ci, którzy przeżyli, sami odbierają sobie możliwość powrotu, wybierając śmierć od stali. Na ich miejscu nie jesteś pewien, czy postąpiłbyś inaczej. Zbierasz, co się da jako dowody, i szykujesz powrót do %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nasza praca skończona.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_162.png[/img]{Nie znajdujesz %employer%a z haremem ani pływającego w winie. Zamiast tego przechadza się z pustą klatką dla ptaków u boku. Z ponurą miną stwierdza, że jego ulubiony ptak uciekł i odleciał.%SPEECH_ON%Nie bierz mnie za tępego, Koroniarzu, widzę, że możesz dostrzec podobieństwo między moim pupilem a moimi zadłużonymi. Czuj się swobodnie, jeśli wolno mi tak powiedzieć. Ale jesteś krótkowzroczny, jeśli myślisz w ten sposób. Mój ptak poleci wolny i na świecie nie będzie miał innego pożytku niż to, by zostać pożartym. Ale to nie jest wolność, Koroniarzu, gdy wraca się do obowiązku, który dały narodziny. Wolność była ucieczką od takiego losu, ucieczką do mojego świata, ucieczką, której nie dane wielu z jego gatunku.%SPEECH_OFF%Wezyr pstryka palcami i sługa pojawia się jakby znikąd. Podaje ci sakiewkę z monetami. Podnosisz wzrok i widzisz, jak Wezyr odkłada klatkę i odchodzi. | %employer% jest, jak mówi straż, \"pochowany\" pośród kończyn swego ulubionego haremu. Wystawia tylko usta i masz wrażenie, że oczy spoglądają na ciebie z zagięcia spoconego kolana, choć nie masz pewności.%SPEECH_ON%Zwycięski Koroniarz powraca, by nacieszyć zmęczone oczy moimi najcenniejszymi dobrami. I jak mówią moi zwiadowcy, starłeś z powierzchni ziemi tych zadufanych zadłużonych, a wieść o ich śmierci została ogłoszona jako nowa przestroga, życzliwy list, napisany twoją ręką, Koroniarzu, na ostrzeżenie wszystkich zadłużonych.%SPEECH_OFF%Wezyr znika na chwilę, po czym wyłania się między udami kobiety.%SPEECH_ON%Służba! Zapłaćcie Koroniarzowi.%SPEECH_OFF%Dwaj żylastej budowy chłopcy niosą małą skrzynkę i zostawiają ją u twoich stóp. Jest bardzo ciężka i nikt nie pomaga ci jej wynieść. | Mężczyzna w łańcuchach spotyka cię przed komnatami %employer%a. Do każdego ramienia ma przypięty łańcuch. Jeden biegnie do ściany, drugi skrzypi po podłodze do skrzyni z koronami. Oba są zamknięte na kłódki. A ten mężczyzna ma klucz. Patrzy na ciebie, palce zaciskają się i rozluźniają na kluczu, oddech jest nierówny. W końcu przykuca i otwiera kłódkę twojej skrzyni, którą zabierasz i cofasz się. Niewolnik trzyma klucz przy piersi, zerka na drugą kłódkę, zaciska dłoń na kluczu i pochyla głowę, a potem pojawia się dźwięk, którego nie jesteś pewien. Strażnik każe mu być cicho, po czym wyprowadza cię za drzwi.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Korony to korony.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-2);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Stłumiłeś bunt zadłużonych");
						this.World.Contracts.finishActiveContract();
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"location",
			this.m.Destination.getRealName()
		]);
		_vars.push([
			"spartacus",
			this.m.Flags.get("SpartacusName")
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/slave_revolt_situation"));
		}
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
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Home != null && !this.m.Home.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Home.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(3);
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
		local location = _in.readU32();

		if (location != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(location));
		}

		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});

