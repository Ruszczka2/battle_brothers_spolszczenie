this.break_greenskin_siege_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Troops = null,
		IsPlayerAttacking = true,
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

		this.m.Type = "contract.break_greenskin_siege";
		this.m.Name = "Przełamanie Oblężenia";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.m.MakeAllSpawnsResetOrdersOnContractEnd = false;
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

		this.m.Flags.set("ObjectiveName", this.m.Origin.getName());
		local nearest_orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(this.m.Origin.getTile());
		this.m.Flags.set("OrcBase", nearest_orcs.getID());
		local nearest_goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(this.m.Origin.getTile());
		this.m.Flags.set("GoblinBase", nearest_goblins.getID());
		this.m.Payment.Pool = 1500 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Udaj się do %objective%",
					"Przełam oblężenie zielonoskórych"
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
				local okLocations = 0;

				foreach( l in this.Contract.m.Origin.getAttachedLocations() )
				{
					if (l.isActive())
					{
						okLocations = ++okLocations;
						okLocations = okLocations;
					}
				}

				if (okLocations < 3)
				{
					foreach( l in this.Contract.m.Origin.getAttachedLocations() )
					{
						if (!l.isActive() && !l.isMilitary())
						{
							l.setActive(true);
							okLocations = ++okLocations;
							okLocations = okLocations;

							if (okLocations >= 3)
							{
								break;
							}
						}
					}
				}

				local faction = this.World.FactionManager.getFaction(this.Contract.getFaction());
				local party = faction.spawnEntity(this.Contract.getHome().getTile(), "Kompania " + this.Contract.getHome().getName(), true, this.Const.World.Spawn.Noble, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.getSprite("banner").setBrush(faction.getBannerSmall());
				party.setDescription("Profesjonalni żołnierze na usługach miejscowych lordów.");
				this.Contract.m.Troops = this.WeakTableRef(party);
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
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				local move = this.new("scripts/ai/world/orders/move_order");
				move.setDestination(this.Contract.getOrigin().getTile());
				c.addOrder(move);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
				}

				this.World.State.setEscortedEntity(this.Contract.m.Troops);
			}

			function update()
			{
				if (this.Flags.get("IsContractFailed"))
				{
					this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
					this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Company broke a contract");
					this.World.Contracts.finishActiveContract(true);
					return;
				}

				if (this.Contract.m.Troops != null && !this.Contract.m.Troops.isNull())
				{
					if (!this.Contract.m.IsEscortUpdated)
					{
						this.World.State.setEscortedEntity(this.Contract.m.Troops);
						this.Contract.m.IsEscortUpdated = true;
					}

					this.World.State.setCampingAllowed(false);
					this.World.State.getPlayer().setPos(this.Contract.m.Troops.getPos());
					this.World.State.getPlayer().setVisible(false);
					this.World.Assets.setUseProvisions(false);
					this.World.getCamera().moveTo(this.World.State.getPlayer());

					if (!this.World.State.isPaused())
					{
						this.World.setSpeedMult(this.Const.World.SpeedSettings.FastMult);
					}

					this.World.State.m.LastWorldSpeedMult = this.Const.World.SpeedSettings.FastMult;
				}

				if ((this.Contract.m.Troops == null || this.Contract.m.Troops.isNull() || !this.Contract.m.Troops.isAlive()) && !this.Flags.get("IsTroopsDeadShown"))
				{
					this.Flags.set("IsTroopsDeadShown", true);
					this.World.State.setCampingAllowed(true);
					this.World.State.setEscortedEntity(null);
					this.World.State.getPlayer().setVisible(true);
					this.World.Assets.setUseProvisions(true);

					if (!this.World.State.isPaused())
					{
						this.World.setSpeedMult(1.0);
					}

					this.World.State.m.LastWorldSpeedMult = 1.0;
					this.Contract.setScreen("TroopsHaveDied");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerNear(this.Contract.m.Origin, 1200))
				{
					if (this.Contract.m.Troops == null || this.Contract.m.Troops.isNull())
					{
						this.Contract.setScreen("ArrivingAtTheSiegeNoTroops");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.m.Troops.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(true);
						this.Contract.setScreen("ArrivingAtTheSiege");
						this.World.Contracts.showActiveContract();
					}

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
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("IsContractFailed", true);
			}

		});
		this.m.States.push({
			ID = "Running_BreakSiege",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Zniszcz wszelkie machiny oblężnicze zielonoskórych",
					"Zabij wszelkich zielonoskórych w okolicy %objective%"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = false;
				}

				foreach( id in this.Contract.m.UnitsSpawned )
				{
					local e = this.World.getEntityByID(id);

					if (e != null)
					{
						e.getSprite("selection").Visible = true;

						if (e.getFlags().has("SiegeEngine"))
						{
							e.setOnCombatWithPlayerCallback(this.onCombatWithSiegeEngines.bindenv(this));
						}
					}
				}
			}

			function update()
			{
				if (this.Contract.m.UnitsSpawned.len() == 0)
				{
					this.Contract.setScreen("TheAftermath");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.m.Origin == null || this.Contract.m.Origin.isNull() || !this.Contract.m.Origin.isAlive())
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatWithSiegeEngines( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
				local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
				p.Music = this.Const.Music.GoblinsTracks;
				p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Edge;
				p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
				p.EnemyBanners = [
					this.World.getEntityByID(this.Flags.get("GoblinBase")).getBanner()
				];
				this.World.Contracts.startScriptedCombat(p, this.Contract.m.IsPlayerAttacking, true, true);
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Wróć do " + this.Contract.m.Home.getName()
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = false;
				}

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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% podaje ci kielich wina.%SPEECH_ON%Wypij.%SPEECH_OFF%Prawie czujesz złe wieści w jego oddechu. Wychylasz trunek jednym haustem i kiwasz głową. On odwzajemnia.%SPEECH_ON%Zielonoskórzy zalewają region i wygląda na to, że chcą zająć %objective%.%SPEECH_OFF%Nalewa kolejny kielich, wypija go i nalewa następny.%SPEECH_ON%Jeśli to padnie, możemy założyć, że reszta regionu pójdzie za nim. Nie wiem, jak bardzo znasz to, co stało się dziesięć lat temu, gdy te brutale przyszły ostatnim razem, ale niewielu tutaj chce to znów zobaczyć. Moi szpiedzy mówią, że oblężenie dopiero się zaczęło i zielonoskórzy nie są w pełni sił, co znaczy, że możemy uderzyć teraz i przełamać je, zanim wymknie się spod kontroli. Jeśli jesteś zainteresowany, a na starych bogów mam nadzieję, że tak, musisz tam pójść i przerwać oblężenie!%SPEECH_OFF% | Strażnicy stoją wokół %employer%a. Mają zdjęte hełmy, spocone głowy, a niektórzy drżą w zbrojach. %employer% dostrzega cię w tłumie rozpaczy i przywołuje.%SPEECH_ON%Najemniku! Mam... wyjątkowo okropne wieści. Być może już słyszałeś, ale powiem krótko, bo czas ucieka: zielonoskórzy mogliby już wtargnąć do regionu i grożą zajęciem %objective%. Właśnie je oblegają, ale raporty mówią, że zieloniaki nie są jeszcze w pełni sił. Potrzebuję, byś tam poszedł i przerwał oblężenie, zanim sprawy wymkną się spod kontroli.%SPEECH_OFF% | Przy %employer%ze stoi kilku skrybów. Na zmianę szepczą, a szlachcic przytakuje wszystkiemu, co mówią. W końcu %employer% zwraca uwagę na ciebie.%SPEECH_ON%Najemniku, kiedyś przełamywałeś oblężenie? %objective% w tym regionie jest oblegane przez zielonoskórych. Mamy mało czasu, zanim zmiotą miejsce z powierzchni ziemi, a potem może wezmą cały przeklęty region! A potem... cóż, na pewno wiesz, co stało się dziesięć lat temu.%SPEECH_OFF%Skrybowie kiwają głowami i pochylają je zgodnie. %employer% mówi dalej.%SPEECH_ON%No i jak, interesuje cię odrobina wojaczki?%SPEECH_OFF% | %employer% wita cię z zaniepokojoną miną.%SPEECH_ON%Jesteśmy w kłopotach, najemniku, i potrzebujemy twojej pomocy! %objective% zostało oblegane przez zielonoskórych i nie mam dość wojsk, by samodzielnie je przerwać. Ale sądzę, że dasz radę. Dasz? Zapłacę hojnie.%SPEECH_OFF% | %employer% stoi z dłońmi złożonymi w namiot nad stołem. Jego ramiona są zgarbione, jak u kruka patrzącego na padlinę. Kręci głową.%SPEECH_ON%Najemniku, potrzebuję więcej ludzi, by zdjąć z %objective% armię zielonoskórych. Dasz radę? Muszę wiedzieć teraz.%SPEECH_OFF% | %employer% podrywa się, gdy wchodzisz. Ma spoconą twarz i nerwowy, krzywy uśmiech.%SPEECH_ON%Najemniku! Tak, tak się cieszę, że jesteś! Wieści nadeszły: zielonoskórzy oblegli %objective% i potrzebuję twojej pomocy! Jesteś zainteresowany czy nie? Potrzebuję szybkiej decyzji.%SPEECH_OFF% | Zastajesz %employer%a głęboko zapadniętego w fotel, jakby chciał, by oparcie zamknęło się i odgrodziło go od świata na zawsze. Leniwie wskazuje mapę na stole.%SPEECH_ON%Cóż, wieści są takie, że zielonoskórzy wrócili i oblegają %objective%. Potrzebuję tylu ludzi, ilu zdołam zgromadzić, by je odblokować. Zapłata będzie odpowiednia, wchodzisz?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Ile jest dla ciebie warte ocalenie %objective%? | Przełamanie oblężenia to coś, co możemy zrobić.}",
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
			ID = "PreparingForBattle",
			Title = "W %townname%...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Wychodzisz z posiadłości %employer%a i szykujesz kompanię. Wokół krzątają się rycerze i żołnierze. Kilku z nich kłębi się przy świętym mężu, w milczeniu przygotowując się na śmierć.%SPEECH_ON%Trzeba zarezerwować miejsce.%SPEECH_OFF%%randombrother% mówi, gdy dołącza do ciebie. Posyła ci kpiący uśmiech.%SPEECH_ON%Co, za mroczne?%SPEECH_OFF% | Na zewnątrz posiadłości %employer%a żołnierze biegają na wszystkie strony. Jedni dźwigają zapasy na wozy, inni ostrzą broń, a garstka giermków nosi pękate naręcza pancerzy. Podchodzisz do swoich ludzi i każesz im szykować się do drogi. %randombrother% kiwa głową w stronę zamieszania.%SPEECH_ON%Wygląda na to, że tym razem będziemy mieli towarzystwo?%SPEECH_OFF% | Żołnierze stoją tuż za drzwiami komnaty %employer%a i w korytarzach. Mijasz pokoje przestraszonych kobiet i dzieci oraz ślepych starców, którzy woleliby być głusi. Na zewnątrz musisz przebić się przez tłum giermków krążących z bronią i zbrojami. %companyname% czeka na ciebie.%SPEECH_ON%Ruszajmy. Ci ludzie muszą szykować się do walki, ale my właśnie po to tu przyszliśmy, prawda, chłopaki?%SPEECH_OFF% | Gdy opuszczasz posiadłość %employer%a, %randombrother% już na ciebie czeka. Obserwuje gorączkowe przygotowania do bitwy: giermkowie biegają z bronią i pancerzami, mężczyźni ładują zapasy na wozy, a święci mężowie na chwilę uśmierzają lęk młodych. Mówisz swojemu najemnikowi, żeby się szykował, bo ruszacie z tymi żołnierzami, by przerwać oblężenie. | Wychodzisz na zewnątrz i widzisz, jak ludzie %employer%a szykują się do drogi. Ładują wyposażenie na wozy, podczas gdy święty mąż przechodzi wzdłuż szeregów. Kobiety, dzieci i starcy stoją przy drodze. %companyname% czeka w gotowości. Podchodzisz i informujesz ich o zadaniu. | Wychodząc na zewnątrz, widzisz żołnierzy %employer%a szykujących się do wojny. Dzieci biegają w amoku, bawiąc się w wojnę i śmiejąc się w całkowitej nieświadomości prawdziwej. Kobiety, z których niektóre straciły już męża albo dwóch, są znacznie bardziej zamyślone. Mijasz pochód i idziesz do %companyname%, by przedstawić szczegóły zadania. | Żołnierze %employer%a szykują się do wojny. Młodzi są nerwowi, maskując strach sztuczną odwagą i niechętnym śmiechem. Weterani wykonują swoje zadania, a ich twarze mówią o starych przyjaciołach, którzy nie wrócili. A szaleni, szerokoocy i żądni krwi, są niemal niepokojąco rozradowani perspektywą nadchodzącej wojny. Mijasz ich wszystkich, by poinformować %companyname% o tym, co ma zrobić. | Gdy wychodzisz na zewnątrz, widzisz żołnierzy armii %employer%a gotowych do marszu. Broń leży w wielkim stosie, z którego mężczyźni wybierają, co chcą. To dziwny widok i świadczy o braku organizacji. To pewnie zły znak, ale zostawiasz to za sobą i idziesz poinformować %companyname% o nowym kontrakcie.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wyruszamy!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TroopsHaveDied",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_22.png[/img]Wszyscy szlacheccy żołnierze polegli w drodze do oblężenia. Lepiej oni, niż wy. Kompania %companyname% zmierza dalej w kierunku %objective%.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Musimy ruszać dalej.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ArrivingAtTheSiege",
			Title = "W pobliżu %objective%...",
			Text = "[img]gfx/ui/events/event_68.png[/img]{Wreszcie docierasz do oblężenia. Zielonoskórzy otaczają %objective%, a ty patrzysz, jak ich machiny wojenne miotają płonące głazy. Połowa miasta już płonie, a drobne punkty ludzi biegają tam i z powrotem, gasząc pożary. Porucznik szlacheckich żołnierzy rozkazuje ci uderzyć na machiny oblężnicze. Potem masz wrócić i dobić resztę dzikusów. | %objective% bardziej przypomina ogromne ognisko niż miasto. Zielonoskóre machiny oblężnicze prowadzą wściekły ostrzał, niebo pełne jest czarnych głazów, martwych krów i płonącego drewna. Porucznik szlacheckich żołnierzy rozkazuje zniszczyć machiny. On i jego ludzie uderzą w główne siły armii zielonoskórych, a potem połączycie się, by wykończyć maruderów. | Oblężenie wciąż trwa, a %objective% jeszcze się trzyma. Wygląda na to, że zdążyłeś na czas, bo zielonoskórzy sieją zniszczenie z machin oblężniczych tak intensywnie, że za parę godzin może nie być już miasta. Widząc to, porucznik szlacheckich żołnierzy rozkazuje ci obejść i zniszczyć broń oblężniczą. On i jego ludzie zaatakują trzon armii dzikusów, a potem razem połączycie siły i wybędziecie ocalałych. | Słyszysz ostrzał, zanim go zobaczysz. Gwizd pocisków rozcina powietrze jak wściekły wiatr, a huk ich upadku jest okrutną kody. W końcu wspinasz się na wzgórze, by dobrze obejrzeć %objective%. Otaczają je zieloni dzicy, których machiny miotają kamienie, martwe krowy, wiązki ludzkich zwłok - cokolwiek te bydlaki zdołają dorwać.\n\nPorucznik szlacheckich żołnierzy przychodzi do ciebie z planem. Masz obejść i zaatakować machiny oblężnicze. On i jego ludzie uderzą w centrum armii zielonoskórych, a po sukcesie połączycie się i zniszczycie, co zostało. | Na drodze spotykasz młodą kobietę z gromadką dzieci skulonych blisko jak wilcze szczenięta w srogą zimę. Zaschnięta krew pokrywa bok jej głowy, choć dobrze to ukrywa pod skołtunionymi włosami. Wyjaśnia, że jeśli idziesz do %objective%, musisz się spieszyć. Zielonoskórzy ustawili machiny oblężnicze i prowadzą wściekły ostrzał. Ty i szlacheccy żołnierze ruszacie dalej, zostawiając kobiecie worek chleba na nakarmienie dzieci.\n\nPo wejściu na kolejne wzgórze widok potwierdza historię uchodźczyni. Porucznik szlacheckich żołnierzy szybko wydaje rozkazy. Ty i %companyname% zaatakujecie machiny oblężnicze, podczas gdy żołnierze uderzą w trzon armii zielonoskórych. Gdy oba zadania zostaną wykonane, połączycie się i wykończycie maruderów. | Ty i szlacheccy żołnierze wchodzicie na najbliższe wzgórze przy %objective%. Miasto wciąż stoi, ale do sterty gruzów jest mu bliżej niż do wioski. Zielonoskórzy musieli ostrzeliwać je swoimi prymitywnymi machinami już od jakiegoś czasu i nic nie wskazuje, by mieli przestać.\n\nPorucznik szlacheckich żołnierzy rozkazuje ci obejść dzikusów i uderzyć na broń oblężniczą. Tymczasem żołnierze zaatakują trzon armii. Gdy oba zadania zostaną wykonane, połączycie się i zniszczycie nielicznych maruderów. | Spotykasz starego człowieka pchającego wóz. Na pakę leży młody mężczyzna ze zmiażdżonymi nogami. Jest nieprzytomny, dłonie wciąż ściskają zniszczone kolana. Starzec mówi, że %objective% jest tuż za najbliższym wzgórzem i jest ostrzeliwane przez machiny oblężnicze, więc jeśli chcesz działać, lepiej robić to szybko. %companyname% i żołnierze ruszają przodem, zostawiając starca, by mozolnie toczył wóz dalej.\n\nStarzec nie kłamał: %objective% płonie i powoli zamienia się w gruz pod ostrzałem dzikich machin. Widząc to na własne oczy, porucznik szlacheckich żołnierzy szybko układa plan: %companyname% obejdzie i zaatakuje broń oblężniczą, a żołnierze wezmą na siebie główne siły armii zielonoskórych. Gdy oba zadania zostaną wykonane, połączycie się i dobijecie wszystko, co żyje. | Spotykasz watahę dzikich psów pędzących drogą. Trzymają się z dala od waszej grupy, ale zauważasz, że ogony mają podkulone, a głowy nisko opuszczone. Nie zatrzymują się ani na chwilę, tylko szybko przebiegają obok.\n\nPo wejściu na kolejne wzgórze widzisz źródło chaosu: zielonoskórzy bezlitośnie ostrzeliwują %objective% całymi rzędami prymitywnych machin oblężniczych. Porucznik szlacheckich żołnierzy kiwa głową i szybko wydaje rozkazy. %companyname% obejdzie i zaatakuje machiny bezpośrednio. Gdy skończycie, macie obejść teren i połączyć się z żołnierzami, a potem działać dalej.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Przygotujcie się do bitwy!",
					function getResult()
					{
						this.Contract.setState("Running_BreakSiege");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.spawnSiege();
			}

		});
		this.m.Screens.push({
			ID = "ArrivingAtTheSiegeNoTroops",
			Title = "W pobliżu %objective%...",
			Text = "[img]gfx/ui/events/event_68.png[/img]{Wreszcie widzisz %objective% i wygląda ono tragicznie. Miasto jest ostrzeliwane przez salwy zielonoskórych machin oblężniczych. Rozkazujesz %companyname% przygotować się do akcji: obejdziecie armię i zaatakujecie machiny bezpośrednio. | Gdy wszyscy szlacheccy żołnierze nie żyją, docierasz do %objective% sam. Zielonoskórzy wciąż ostrzeliwują biedne miasto prymitywnymi machinami. Decydujesz, że najlepszy plan to obejść dzikusów i uderzyć w ich machiny oblężnicze.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Przygotujcie się do bitwy!",
					function getResult()
					{
						this.Contract.setState("Running_BreakSiege");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.spawnSiege();
			}

		});
		this.m.Screens.push({
			ID = "SiegeEquipmentAhead",
			Title = "Gdy się zbliżacie...",
			Text = "[img]gfx/ui/events/event_68.png[/img]{Zielonoskórzy zebrali w pobliżu machiny oblężnicze. Musisz je zniszczyć, by pomóc przełamać oblężenie! | Twoi ludzie dostrzegają w pobliżu kilka machin oblężniczych. Zielonoskórzy musieli przygotowywać szturm! Musisz je zniszczyć, by pomóc przełamać oblężenie!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do ataku!",
					function getResult()
					{
						this.Contract.getActiveState().onCombatWithSiegeEngines(null, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Shaman",
			Title = "Gdy się zbliżacie...",
			Text = "[img]gfx/ui/events/event_48.png[/img]{Gdy zbliżasz się do oblegających goblinów, dostrzegasz dość wyjątkową sylwetkę pośród ich szeregów. To szaman. Każesz swoim ludziom odpowiednio się przygotować. | Wśród goblinów wyróżnia się charakterystyczny kształt. Widzisz, jak wydziera się rozkazy w tym ohydnym języku, który uważają za mowę. Plugawa istota jest opleciona dziwnymi roślinami i nosi coś, co wygląda jak naszyjnik z kości zwierząt.%SPEECH_ON%To szaman.%SPEECH_OFF%%randombrother% mówi, dołączając do twojego boku.%SPEECH_ON%Powiadomię resztę ludzi.%SPEECH_OFF% | %randombrother% wraca z rozpoznania. Mówi, że wśród najeżdżających zielonoskórych jest gobliński szaman. Wygląda na poirytowanego.%SPEECH_ON%Uwielbiam zabijać gobasy, ale te sukinsyny tym razem dadzą nam porządny ból głowy.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do ataku!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Warlord",
			Title = "Gdy się zbliżacie...",
			Text = "[img]gfx/ui/events/event_49.png[/img]{Gdy zbliżasz się do oblegających zielonoskórych, dostrzegasz coś niemal niemożliwego do przeoczenia: wielką, imponującą sylwetkę orczego wodza. Zbroja plugawca błyszczy, gdy odwraca się, by szczekać rozkazy w orczej mowie, rozpalając wśród swoich współplemieńców gwałtowną, pieniącą się żądzę walki. Mówisz %randombrother%owi, by rozpuścił wieści i przygotował ludzi. | Zbliżając się do obozu oblężniczego, rozpoznajesz wysoką, brutalną sylwetkę orczego wodza. Nawet z tej odległości słyszysz, jak szczeka rozkazy do swoich giermków. Ta walka właśnie stała się trochę ciekawsza. | Zbliżasz się do obozu oblężniczego zielonoskórych, by usłyszeć charakterystyczny ryk orczego wodza. Wydziera się rozkazy w ich obrzydliwym i głośnym języku. Jego obecność nieco zmienia zadanie i informujesz o tym ludzi. | %randombrother% wraca z rozpoznania. Mówi, że w obozie zielonoskórych jest orczy wódz. Zła wiadomość, ale lepiej wiedzieć wcześniej i się przygotować niż wejść i dać się zaskoczyć.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do ataku!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TheAftermath",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Bitwa dobiegła końca, zielonoskórzy zostali rozproszeni. %objective% zostało ocalone, a %employer% będzie zachwycony. Przechodzisz ponad stertami zwłok, ludzi i bestii, zbierając swoich ludzi do marszu powrotnego. | Ciała zaścielają pole, chmury much już zaczynają się zbierać i krzątać. Zbierasz ludzi i szykujesz powrót do %employer% po zapłatę. | %objective% jest ocalone! Cóż, to, co z niego zostało. Żołnierze i zielonoskórzy, martwi i konający, pokrywają ziemię, jak okiem sięgnąć. To okrutny widok, świeżo powstały. Rozkazujesz %companyname% przygotować się do powrotu do %employer% po zapłatę. | Sterty ciał ułożone po dwa, trzy, czasem nawet cztery wysoko. Ocaleni tkwią pogrzebani pod martwymi, sześć stóp pod ziemią, choć leżą na powierzchni. To przerażający widok i jeszcze gorsza kakofonia, gdy ranni i umierający wołają o pomoc. Dostrzec ich w morzu kończyn to jak wypatrzyć marynarza kołyszącego się na czarnym oceanie. Odwracasz się od sceny i zbierasz ludzi z %companyname%. %employer% powinien z radością oczekiwać twojego powrotu. | Bitwa wygrana i zakończona, obserwujesz, jak pikinierzy ostrożnie przechodzą po polu. Dzięki dystansowi, jaki daje broń, dobijają bezpiecznie rannych zielonoskórych. Reszta szlacheckich żołnierzy siada na ziemi, pijąc wodę i zmywając krew z twarzy. Nie masz czasu na taki odpoczynek i szybko zbierasz swoich najemników, by wrócić do %employer%. | Krew miesza się z ziemią, a twoje buty grzęzną w błocie. Zwłoki leżą wszędzie, ciała są nie do poznania, części ciał odłączone i porozrzucane daleko od swoich właścicieli. Tu i ówdzie odcięte głowy, oczy zastygłe w szoku. Połamane strzały, rozszczepione włócznie, porzucone miecze. Kawałki zniszczonych pancerzy chrzęszczą pod stopami. To była piekielna bitwa i z pewnością odciśnie piętno na wszystkich, którzy tu przyjdą.\n\nGdy %objective% zostało ocalone, powoli zbierasz %companyname%, by wrócić do %employer% po sowitą zapłatę. | Bitwa skończona, szlacheccy żołnierze nie tracą czasu, ścinając głowy każdemu zielonoskóremu, którego znajdą. Nabijają je na piki i unoszą wysoko, odwzorowując barbarzyństwo dzikusów, których właśnie zlikwidowali. Nie masz czasu na takie przedstawienia. %objective% zostało ocalone i za to otrzymasz zapłatę. %companyname% szybko zbiera się do powrotu do %employer%. | Po bitwie ostrożnie stąpasz po polu. Każde ciało opowiada historię swojej śmierci. Jedne ugodzone w plecy, inne bez głów, ich historie gdzie indziej, jeszcze inne wypatroszone i znalezione z wnętrznościami w dłoniach i wstrząśniętym wyrazem twarzy, jakby były świadkami rzeczy, których nie powinny widzieć. Nic nowego, wszystko to samo, tylko inne miejsce. Najważniejsze, że %objective% wciąż stoi. Zbierasz %companyname%, by wrócić do %employer% po zapłatę. | %randombrother% podchodzi do ciebie. Trzyma głowę zielonoskórego, ale szybko ją odrzuca, jakby nowość właśnie wyparowała. Opiera dłonie na biodrach i kiwa głową w stronę pobojowiska.%SPEECH_ON%Cóż, to coś.%SPEECH_OFF%Zwłoki, czasem ułożone po trzy lub cztery, zalegają ziemię. Kończyny poskręcane, twarze napięte, krew sącząca się i bulgocząca. Ludzie maszerują przez to, ich nogi wzbijają wielkie bryzgi zastojonej krwi, jakby szli korytem potoku. %objective%, choć płonie, wciąż stoi w oddali i to dla ciebie najważniejsze. %companyname% powinno teraz wrócić do %employer% po zapłatę. | Oblężenie zostało zniesione, choć zielonoskórzy nie oddali go dobrowolnie. Martwi ludzie i bestie zalegają ziemię tak daleko, jak sięga wzrok, z pewnością przerastając każdą wyobraźnię. %randombrother% podchodzi do ciebie. Zdejmuje z ramienia pas zielonej skóry i odrzuca go jak mokrą szmatę.%SPEECH_ON%Cholernie dobra walka, panie.%SPEECH_OFF%Kiwasz głową i każesz mu przygotować ludzi. %employer% będzie bardzo zadowolony, że %objective% zostało ocalone.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zwycięstwo!",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Po powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Wracasz do %employer%a z kilkoma jego porucznikami za sobą. Zdają raport, a twój pracodawca szybko kiwa głową i wręcza ci dużą sakwę koron. Jego porucznicy posyłają ci zazdrosne spojrzenia, gdy wychodzisz. | Oblężenie zostało przełamane i meldujesz to %employer%owi. Kiwając głową, daje ci sakwę koron.%SPEECH_ON%Będą o tobie mówić. Ci jeszcze nienarodzeni, mam na myśli.%SPEECH_OFF% | Przekazujesz %employer%owi wieści o przerwanym oblężeniu. Wstaje i ściska twoje dłonie.%SPEECH_ON%Na starych bogów, twoja służba dzisiejszego dnia nie zostanie zapomniana!%SPEECH_OFF%W głowie zastanawiasz się, czy dokładnie to zdanie nie padło już wobec człowieka, który dziś jest tylko kością i pyłem. Bierzesz nagrodę, pozostawiając dziedzictwo i historię filozofom. | %employer% chętnie wita twój powrót, szybko zrywając się na nogi i niemal potykając się o jednego z psów.%SPEECH_ON%Najemniku, już słyszałem świetne wieści! Oblężenie zostało zniesione, więc zasłużyłeś na potężną nagrodę!%SPEECH_OFF%Wrzuca ciężką skrzynię na biurko. Bierzesz ją, liczysz korony i wychodzisz. | %employer% siedzi za biurkiem, gdy wchodzisz.%SPEECH_ON%Wejdźże, \'bohaterze\'. Co mają wyryć przy twoim imieniu?%SPEECH_OFF%Pytasz, o co mu chodzi.%SPEECH_ON%Najemniku, proszę. Nie bądź taki skromny, to, czego dokonałeś, jest warte niesienia na językach tych, którzy nawet się nie narodzili!%SPEECH_OFF%Kiwasz głową.%SPEECH_ON%Tak, jasne. Wspaniale i w ogóle. Gdzie moja kasa?%SPEECH_OFF%Usta pracodawcy zaciskają się w kreskę. Kiwając głową, podaje sakwę.%SPEECH_ON%Człowiek od wielu zadań, jestem pewien. Dla ciebie to nic, ale dla nas znaczy wiele!%SPEECH_OFF% | %employer% patrzy na swoje stopy, gdy wchodzisz. Pod jego biurkiem ktoś siedzi i szlachcic nie próbuje ukryć swojej kochanki.%SPEECH_ON%Witaj z powrotem, najemniku! Zapłata jest w rogu. Tamtym rogu, o. Nie próbuj się gapić.%SPEECH_OFF%Bierzesz nagrodę i kierujesz się do drzwi. %employer% woła za tobą, z kciukiem wyciągniętym w górę.%SPEECH_ON%Dobra robota, tak przy okazji.%SPEECH_OFF%Kiwasz głową i odchodzisz. | Wchodzisz do komnaty %employer%a z kilkoma jego porucznikami tuż za tobą. Mężczyzna wstaje na widok twojej grupy, ale szybko macha na żołnierzy, by wyszli. Posłusznie, choć opieszale, wychodzą. Kręcisz głową.%SPEECH_ON%Oni też walczyli.%SPEECH_OFF%%employer% zbywa cię ruchem ręki.%SPEECH_ON%Oczywiście, że tak, i już są na żołdzie. Ty jednak jesteś na kontrakcie i kontrakt został wypełniony. Poza tym najlepiej, by ci ludzie nie widzieli, ile ci płacę.%SPEECH_OFF%Bierzesz nagrodę. To kwota zdecydowanie budząca zazdrość i chowasz ją, przechodząc korytarzami w drodze na zewnątrz.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "%objective% zostało uratowane.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Przerwałeś oblężenie " + this.Flags.get("ObjectiveName"));
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
		this.m.Screens.push({
			ID = "Failure1",
			Title = "W okolicy %objective%",
			Text = "[img]gfx/ui/events/event_68.png[/img]{Zająłeś się zbyt długo i teraz %objective% leży w ruinie. Zielonoskórzy wdarli się na mury, siejąc grozę i chaos. Po zapachu niesionym wiatrem łatwo zrozumieć, że wszystkich w środku wyrżnięto. | %companyname% nie przerwało oblężenia na czas i teraz %objective% za to zapłaciło. Myśleli, że ich uratujesz, a tymczasem zawiodłeś wszystkich. Jeśli jest jakaś dobra wiadomość, to ta, że nikt nie przeżył, by narzekać na twoje porażki. Twój pracodawca, %employer%, to jednak inna sprawa. Szlachcic bez wątpienia będzie wściekły na twoją bezczynność. | %objective% zostało zdeptane! Orkowie doprowadzili przerażające machiny wojenne pod mury i zniszczyli obronę. Morderczy zielonoskórzy zalali miasto, zabijając wszystko na swojej drodze albo biorąc jeńców - bogowie wiedzą dokąd. Twój pracodawca, %employer%, jest wściekły na to, że nie wykonałeś zadania! | Nie zdołałeś odblokować %objective% na czas! Zielonoskórzy rozbili główną bramę i, cóż, miasto zostało zrównane z ziemią. Biorąc pod uwagę, że %employer% płaci ci za dokładnie odwrotny rezultat, można założyć, że nie jest zadowolony z tego rozwoju wydarzeń. | Ponieważ kręciłeś się i nie robiłeś swojej roboty, %objective% padło łupem zielonoskórych! Niech bogowie mają litość nad jego mieszkańcami i nie spodziewaj się, że %employer% będzie zadowolony z tego wyniku.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "%objective% upadło.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Nie zdołałeś przerwać oblężenia " + this.Flags.get("ObjectiveName"));
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function spawnSiege()
	{
		if (this.m.Flags.get("IsSiegeSpawned"))
		{
			return;
		}

		this.m.SituationID = this.m.Origin.addSituation(this.new("scripts/entity/world/settlements/situations/besieged_situation"));
		local originTile = this.m.Origin.getTile();
		local orcBase = this.World.getEntityByID(this.m.Flags.get("OrcBase"));
		local goblinBase = this.World.getEntityByID(this.m.Flags.get("GoblinBase"));
		local numSiegeEngines;

		if (this.m.DifficultyMult >= 1.15)
		{
			numSiegeEngines = this.Math.rand(1, 2);
		}
		else
		{
			numSiegeEngines = 1;
		}

		local numOtherEnemies;

		if (this.m.DifficultyMult >= 1.25)
		{
			numOtherEnemies = this.Math.rand(2, 3);
		}
		else if (this.m.DifficultyMult >= 0.95)
		{
			numOtherEnemies = 2;
		}
		else
		{
			numOtherEnemies = 1;
		}

		for( local i = 0; i < numSiegeEngines; i = i )
		{
			local tile;
			local tries = 0;

			while (tries++ < 500)
			{
				local x = this.Math.rand(originTile.SquareCoords.X - 2, originTile.SquareCoords.X + 2);
				local y = this.Math.rand(originTile.SquareCoords.Y - 2, originTile.SquareCoords.Y + 2);

				if (!this.World.isValidTileSquare(x, y))
				{
					continue;
				}

				tile = this.World.getTileSquare(x, y);

				if (tile.getDistanceTo(originTile) <= 1)
				{
					continue;
				}

				if (tile.Type == this.Const.World.TerrainType.Ocean)
				{
					continue;
				}

				if (tile.IsOccupied)
				{
					continue;
				}

				break;
			}

			local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).spawnEntity(tile, "Machiny OblԄքnicze", false, this.Const.World.Spawn.GreenskinHorde, this.Math.rand(100, 120) * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
			this.m.UnitsSpawned.push(party.getID());
			party.setDescription("Horda zielonoskórych i ich machiny oblężnicze.");
			local numSiegeUnits = this.Math.rand(3, 4);

			for( local j = 0; j < numSiegeUnits; j = j )
			{
				this.Const.World.Common.addTroop(party, {
					Type = this.Const.World.Spawn.Troops.GreenskinCatapult
				}, false);
				j = ++j;
			}

			party.updateStrength();
			party.getLoot().ArmorParts = this.Math.rand(0, 15);
			party.getLoot().Ammo = this.Math.rand(0, 10);
			party.addToInventory("supplies/strange_meat_item");
			party.getSprite("body").setBrush("figure_siege_01");
			party.getSprite("banner").setBrush(goblinBase != null ? goblinBase.getBanner() : "banner_goblins_01");
			party.getSprite("banner").Visible = false;
			party.getSprite("base").Visible = false;
			party.setAttackableByAI(false);
			party.getFlags().add("SiegeEngine");
			local c = party.getController();
			c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
			c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
			local wait = this.new("scripts/ai/world/orders/wait_order");
			wait.setTime(9000.0);
			c.addOrder(wait);
			i = ++i;
		}

		local targets = [];

		foreach( l in this.m.Origin.getAttachedLocations() )
		{
			if (l.isActive() && l.isUsable())
			{
				targets.push(l);
			}
		}

		if (targets.len() == 0)
		{
			foreach( l in this.m.Origin.getAttachedLocations() )
			{
				if (l.isUsable())
				{
					targets.push(l);
				}
			}
		}

		for( local i = 0; i < numOtherEnemies; i = i )
		{
			local tile;
			local tries = 0;

			while (tries++ < 500)
			{
				local x = this.Math.rand(originTile.SquareCoords.X - 4, originTile.SquareCoords.X + 4);
				local y = this.Math.rand(originTile.SquareCoords.Y - 4, originTile.SquareCoords.Y + 4);

				if (!this.World.isValidTileSquare(x, y))
				{
					continue;
				}

				tile = this.World.getTileSquare(x, y);

				if (tile.getDistanceTo(originTile) <= 1)
				{
					continue;
				}

				if (tile.Type == this.Const.World.TerrainType.Ocean)
				{
					continue;
				}

				break;
			}

			local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).spawnEntity(tile, "Horda Zielonosk\x0480rych", false, this.Const.World.Spawn.GreenskinHorde, this.Math.rand(90, 110) * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
			this.m.UnitsSpawned.push(party.getID());
			party.setDescription("Horda zielonoskórych, maszerujących na wojnę.");
			party.getLoot().ArmorParts = this.Math.rand(0, 15);
			party.getLoot().Ammo = this.Math.rand(0, 10);
			party.addToInventory("supplies/strange_meat_item");
			party.getSprite("banner").setBrush(orcBase != null ? orcBase.getBanner() : "banner_orcs_01");
			local c = party.getController();
			local raidTarget = targets[this.Math.rand(0, targets.len() - 1)].getTile();
			c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
			local raid = this.new("scripts/ai/world/orders/raid_order");
			raid.setTime(30.0);
			raid.setTargetTile(raidTarget);
			c.addOrder(raid);
			local destroy = this.new("scripts/ai/world/orders/destroy_order");
			destroy.setTime(60.0);
			destroy.setSafetyOverride(true);
			destroy.setTargetTile(originTile);
			destroy.setTargetID(this.m.Origin.getID());
			c.addOrder(destroy);
			i = ++i;
		}

		if (this.m.Troops != null && !this.m.Troops.isNull())
		{
			local c = this.m.Troops.getController();
			c.clearOrders();
			local intercept = this.new("scripts/ai/world/orders/intercept_order");
			intercept.setTarget(this.World.getEntityByID(this.m.UnitsSpawned[this.m.UnitsSpawned.len() - 1]));
			c.addOrder(intercept);
			local guard = this.new("scripts/ai/world/orders/guard_order");
			guard.setTarget(originTile);
			guard.setTime(120.0);
		}

		this.m.Origin.spawnFireAndSmoke();
		this.m.Origin.setLastSpawnTimeToNow();
		this.m.Flags.set("IsSiegeSpawned", true);
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective",
			this.m.Flags.get("ObjectiveName")
		]);
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

			if (!this.m.Flags.get("IsSiegeSpawned"))
			{
				this.spawnSiege();
			}

			foreach( id in this.m.UnitsSpawned )
			{
				local e = this.World.getEntityByID(id);

				if (e != null && e.isAlive())
				{
					e.setAttackableByAI(true);

					if (e.getFlags().has("SiegeEngine"))
					{
						local c = e.getController();
						c.clearOrders();
						local wait = this.new("scripts/ai/world/orders/wait_order");
						wait.setTime(120.0);
						c.addOrder(wait);
					}
				}
			}

			if (this.m.Origin != null && !this.m.Origin.isNull())
			{
				this.m.Origin.getSprite("selection").Visible = false;
			}

			if (this.m.Home != null && !this.m.Home.isNull())
			{
				this.m.Home.getSprite("selection").Visible = false;
			}
		}

		if (this.m.Origin != null && !this.m.Origin.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Origin.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(2);
			}
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isGreenskinInvasion())
		{
			return false;
		}

		local numAttachments = 0;

		foreach( l in this.m.Origin.getAttachedLocations() )
		{
			if (l.isActive() && l.isUsable())
			{
				numAttachments = ++numAttachments;
				numAttachments = numAttachments;
			}
		}

		if (numAttachments < 2)
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Troops != null && !this.m.Troops.isNull())
		{
			_out.writeU32(this.m.Troops.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local troops = _in.readU32();

		if (troops != 0)
		{
			this.m.Troops = this.WeakTableRef(this.World.getEntityByID(troops));
		}

		this.contract.onDeserialize(_in);
	}

});

