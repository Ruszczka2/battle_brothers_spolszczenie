this.raze_attached_location_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Settlement = null
	},
	function setSettlement( _s )
	{
		this.m.Flags.set("SettlementName", _s.getName());
		this.m.Settlement = this.WeakTableRef(_s);
	}

	function setLocation( _l )
	{
		this.m.Destination = this.WeakTableRef(_l);
		this.m.Flags.set("DestinationName", _l.getName());
	}

	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = 0.85;
		this.m.Type = "contract.raze_attached_location";
		this.m.Name = "Spalenie Lokacji";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		local s = this.World.EntityManager.getSettlements()[this.Math.rand(0, this.World.EntityManager.getSettlements().len() - 1)];
		this.m.Destination = this.WeakTableRef(s.getAttachedLocations()[this.Math.rand(0, s.getAttachedLocations().len() - 1)]);
		this.m.Flags.set("PeasantsEscaped", 0);
		this.m.Flags.set("IsDone", false);
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 600 * this.getPaymentMult() * this.getDifficultyMult() * this.getReputationToPaymentMult();

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
					"Spal: " + this.Flags.get("DestinationName") + " w pobliżu " + this.Flags.get("SettlementName")
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
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);

				if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().get("Betrayed") && this.Math.rand(1, 100) <= 75)
				{
					this.Flags.set("IsBetrayal", true);
				}
				else
				{
					this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.Peasants, this.Math.rand(90, 150));

					if (this.Math.rand(1, 100) <= 25)
					{
						this.Flags.set("IsMilitiaPresent", true);
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.Militia, this.Math.min(300, 80 * this.Contract.getScaledDifficultyMult()));
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
					this.Contract.m.Destination.setFaction(this.Const.Faction.Enemy);
					this.Contract.m.Destination.setAttackable(true);
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Flags.get("IsDone"))
				{
					if (this.Flags.get("IsBetrayal"))
					{
						this.Contract.setScreen("Betrayal2");
					}
					else
					{
						this.Contract.setScreen("Done");
					}

					this.World.Contracts.showActiveContract();
				}
			}

			function onEntityPlaced( _entity, _tag )
			{
				if (_entity.getFlags().has("peasant") && this.Math.rand(1, 100) <= 75)
				{
					_entity.setMoraleState(this.Const.MoraleState.Fleeing);
					_entity.getBaseProperties().Bravery = 0;
					_entity.getSkills().update();
					_entity.getAIAgent().addBehavior(this.new("scripts/ai/tactical/behaviors/ai_retreat_always"));
				}

				if (_entity.getFlags().has("peasant") || _entity.getFlags().has("militia"))
				{
					_entity.setFaction(this.Const.Faction.Enemy);
					_entity.getSprite("socket").setBrush("bust_base_militia");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (this.Contract.m.Destination.getTroops().len() == 0)
				{
					this.onCombatVictory("RazeLocation");
					return;
				}
				else if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);

					if (this.Flags.get("IsBetrayal"))
					{
						this.Contract.setScreen("Betrayal1");
					}
					else if (this.Flags.get("IsMilitiaPresent"))
					{
						this.Contract.setScreen("MilitiaAttack");
					}
					else
					{
						this.Contract.setScreen("DefaultAttack");
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.Contract.m.Destination.getPos());
					p.CombatID = "RazeLocation";
					p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[this.Contract.m.Destination.getTile().Type];
					p.Tile = this.World.getTile(this.World.worldToTile(this.World.State.getPlayer().getPos()));
					p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
					p.LocationTemplate.Template[0] = "tactical.human_camp";
					p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.None;
					p.LocationTemplate.CutDownTrees = true;
					p.LocationTemplate.AdditionalRadius = 5;
					p.PlayerDeploymentType = this.Flags.get("IsEncircled") ? this.Const.Tactical.DeploymentType.Circle : this.Const.Tactical.DeploymentType.Edge;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Center;
					p.Music = this.Const.Music.CivilianTracks;
					p.IsAutoAssigningBases = false;

					foreach( e in p.Entities )
					{
						e.Callback <- this.onEntityPlaced.bindenv(this);
					}

					p.EnemyBanners = [
						"banner_noble_11"
					];
					this.World.Contracts.startScriptedCombat(p, true, true, true);
				}
			}

			function onActorRetreated( _actor, _combatID )
			{
				if (_actor.getFlags().has("peasant"))
				{
					this.Flags.set("PeasantsEscaped", this.Flags.get("PeasantsEscaped") + 1);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "RazeLocation")
				{
					this.Contract.m.Destination.setActive(false);
					this.Contract.m.Destination.spawnFireAndSmoke();
					this.Flags.set("IsDone", true);
				}
				else if (_combatID == "Defend")
				{
					this.Flags.set("IsDone", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "RazeLocation")
				{
					this.Flags.set("PeasantsEscaped", 100);
				}
				else if (_combatID == "Defend")
				{
					this.Flags.set("IsDone", true);
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
				this.Contract.m.Destination.getSprite("selection").Visible = false;
				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.Contract.m.Destination.setOnCombatWithPlayerCallback(null);
				this.Contract.m.Destination.setFaction(this.Contract.m.Destination.getSettlement().getFaction());
				this.Contract.m.Destination.clearTroops();
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("PeasantsEscaped") == 0)
					{
						this.Contract.setScreen("Success1");
					}
					else if (this.Math.rand(1, 100) >= this.Flags.get("PeasantsEscaped") * 10)
					{
						this.Contract.setScreen("Success2");
					}
					else
					{
						this.Contract.setScreen("Failure1");
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
			Text = "[img]gfx/ui/events/event_61.png[/img]{%employer% odrzuca jedwabne rękawy i trzaska knykciami.%SPEECH_ON%Mam nadzieję, że mogę powierzyć ci bardzo delikatną sprawę, bo moja rodzina nie może być z nią kojarzona.%SPEECH_OFF%Kiwasz głową, jakby najemników często proszono o dochowanie tajemnicy. Mężczyzna ciągnie dalej.%SPEECH_ON%Miasto %settlementname% jest zbyt słabe, by się bronić, a ludzie domagają się ochrony przed zbójami. My, ród %noblehousename%, jesteśmy jedynymi, którzy mogą dać im prawdziwe bezpieczeństwo. Niestety lokalna rada jest zbyt ślepa, by to dostrzec. Są przekonani, że sami obronią swoich ludzi. Udowodnijmy im, że się mylą.\n\n Chcę, żebyś spalił %location% w pobliżu %settlementname% doszczętnie i zabił tamtejszych chłopów. Ma to wyglądać na robotę zbójów. Jestem pewien, że znasz ich metody. A teraz...%SPEECH_OFF%%employer% nachyla się blisko.%SPEECH_ON%...muszę to powiedzieć jasno i potrzebuję, żebyś uważnie słuchał. Nie może być żadnych ocalałych, którzy mogliby powiedzieć, kto naprawdę zaatakował. Żadnych! Rozumiesz? Dobrze. Wróć do mnie, gdy sprawa będzie załatwiona.%SPEECH_OFF% | %employer% wpatruje się w stertę zwojów, po czym ze złością strąca je ze stołu w papierowym zamęcie.%SPEECH_ON%Rajcy z %settlementname% myślą, że potrafią ochronić swoje miasteczko przed zbójami, ale ja wiem, że nie potrafią. Wiem, że potrzebują mojej ochrony! A zaoferowałem ją w tak rozsądnej cenie...%SPEECH_OFF%Uspokaja się na tyle, by zerknąć na ciebie.%SPEECH_ON%Mam to. Wiem, co zrobić. Ty... znasz robotę zbójów, tak? Oczywiście. Więc idź do %location% pod %settlementname% i... zrób to, co robią zbóje. Oczywiście tak, by naprawdę wyglądało na ich robotę... potem na pewno miasto wynajmie mnie do ochrony! I będą bezpieczni!%SPEECH_OFF% | %employer% splata dłonie, opierając ich czubki o czoło. Wzdycha długo.%SPEECH_ON%Od lat próbuję układać się z ludźmi z %settlementname%, ale zaczynam sądzić, że będę musiał sięgnąć po drastyczne środki, by dostać to, czego chcę. Rada nie zapłaci mi za ochronę, bo uważa, że sami dadzą radę. Mówią, że od dawna są bezpieczni. A gdyby... nie byli? Gdybyś poszedł tam, przebrany za zbója, i nauczył ich, że bez pomocy %noblehousename% nikt nie jest bezpieczny! Oczywiście nie możesz nikomu zdradzić naszej rozmowy... Co na to, najemniku?%SPEECH_OFF% | %employer% patrzy przez okno, gdy siadasz.%SPEECH_ON%Wstań, najemniku. Nie lubię szeptać w dół, bo podnoszę głos, a przy tym, co mam ci powiedzieć, nie chcę tego robić.%SPEECH_OFF%Wstajesz i nadstawiasz ucha.%SPEECH_ON%%settlementname% odmówiło mojej oferty ochrony. Postanowili działać sami. Nie tylko nie płacą %noblehousename%, ale też szargają nasze imię. Jeśli ta wioska odmawia naszej ochrony, co zrobią inni? Chcę, żebyś odegrał rolę zbója, poszedł tam i nauczył ich, jak to jest żyć w świecie bez ochrony %noblehousename% po swojej stronie! Oczywiście dyskrecja jest najważniejsza. Nic z tego, co tu powiedziałem, nie może opuścić tego pokoju.%SPEECH_OFF% | %employer% ociera jabłko, zdzierając skórkę zgrubiałym kciukiem.%SPEECH_ON%Mój ojciec mawiał, że jeśli nazwisko nie budzi szacunku samym brzmieniem, to nie jest nazwiskiem wcale. Niestety %settlementname% nie szanuje imienia %noblehousename%. Odrzucili moje propozycje ochrony i znieważyli moją rodzinę. Chcę, żebyś im za to odpłacił. Masz iść tam, nie jako najemnicy, lecz jako zbóje, i pokazać im, co się dzieje w świecie bez ochrony %noblehousename%. Oczywiście musisz być dokładny, najemniku. Nie możesz nikomu mówić o tym, co tu sobie powiemy.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Porozmawiajmy o pieniądzach. | O ilu konkretnie koronach tu mówimy? | Ile wyniesie zapłata? | Wszystko da się zrobić, za odpowiednią cenę.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{To nie robota dla nas. | To nie coś dla naszej kompanii.}",
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
			ID = "DefaultAttack",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_16.png[/img]{Docierasz do %location%. Chłopi kręcą się jak się spodziewałeś. To będzie jak łowienie ryb w beczce. Jedyne pytanie: jak chcesz podejść? | %location% jest spokojniejsze, niż sądziłeś. Kilku chłopów włóczy się, podrzucając sierpy i motyki, plotkując o tym i owym. Słyszysz, jak wybuchają śmiechem z jakiegoś żartu. Szkoda, że reszta ich dnia nie będzie już tak zabawna. | Przedzierasz się przez wysokie chwasty, by przyjrzeć się %location%. Kilku chłopów chodzi tam i z powrotem, całkiem nieświadomych kociej zagłady czającej się w trawie tuż za ich osadą. Oceniając teren, zaczynasz planować kolejny ruch. | %location% jest ciche, aż zbyt ciche jak na miejsce przeznaczone do zniszczenia. Kręcisz głową na okrucieństwo tego świata, lecz przypominasz sobie, że to robota, za którą dobrze ci zapłacą. Od razu jest łatwiej. | Zabijanie chłopów nigdy nie było twoją mocną stroną. Nie że nie potrafisz, ale ta prostota zawsze cię uwierała. Jak zabicie psa bez nóg albo nadepnięcie na ślepą żabę. Nikt jednak nie płacił ci wiele za uśpienie kundla. Ironiczne, że ci chłopi byliby bezpieczniejsi jako mieszańce niż jako ludzie.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Okrążyć ich!",
					function getResult()
					{
						this.Flags.set("IsEncircled", true);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				},
				{
					Text = "Przedrzeć się z jednej strony!",
					function getResult()
					{
						this.Flags.set("IsEncircled", false);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "MilitiaAttack",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_141.png[/img]{Docierasz do %location% i od razu każesz ludziom stanąć i paść. Chłopi są na miejscu, ale jest też milicja. Nie było tego w umowie i musisz odpowiednio ocenić sytuację. | Gdy zbliżasz się do %location%, %randombrother% wraca z meldunkiem. Okazuje się, że nie ma tam tylko chłopów. Jest też kilku milicjantów. Jeśli chcesz to zrobić, musisz walczyć także z nimi. Co teraz? | Milicja! Nie było tego w planie! Jeśli chcesz iść dalej, musisz się z nimi rozprawić razem z chłopami. Czas przemyśleć to uważnie... | Co to ma być? Widzisz milicjantów maszerujących wokół %location%. Jeśli chcesz wykonać zadanie, czeka cię prawdziwa walka. | Gdy szykujesz się do ataku na %location%, %randombrother% wskazuje coś w oddali. Mrużysz oczy i dostrzegasz kilku ludzi wyglądających na milicjantów. Nie było tego w umowie! Wciąż możesz przeprowadzić atak, ale spotkasz opór...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Okrążyć ich!",
					function getResult()
					{
						this.Flags.set("IsEncircled", true);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				},
				{
					Text = "Przedrzeć się z jednej strony!",
					function getResult()
					{
						this.Flags.set("IsEncircled", false);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Done",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_02.png[/img]{Rzeź się powiodła. Podkładasz ogień i zostawiasz miejsce w tlących się ruinach. | W powietrzu unosi się metaliczny zapach, gdy przechodzisz między ciałami chłopów. Kiwasz głową na swoją robotę i zwracasz się do %randombrother%.%SPEECH_ON%Spalić wszystko.%SPEECH_OFF% | Stawili nieco większy opór, niż się spodziewałeś, ale ostatecznie wszystkich zabiłeś. A przynajmniej taką masz nadzieję. Nie chcąc robić tego na pół gwizdka, podpalasz każdy budynek, jaki widzisz. | Sprowadziłeś ruinę na %location%. Mieszkańcy zabici, budynki w ogniu. Dobra robota według miary każdego najemnika. | Trupy są wszędzie, a świeży, słodki zapach ich śmierci już zaczyna kwaśnieć. Nie chcesz tkwić w smrodzie, więc szybko podpalasz %location% i odchodzisz. | ...a więc 'opór' zostaje zdławiony. Tu kilka ciał, tam kilka. Masz nadzieję, że wszystkich dopadłeś. Pozostaje tylko spalić wszystko na popiół i odejść. | Cóż, po to tu przyszedłeś. Każesz kilku ludziom ułożyć ciała w sposób, który uznajesz za 'pouczający', a potem wysyłasz kilku innych najemników z pochodniami do każdego budynku w zasięgu wzroku.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Robota skończona.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-5);
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Settlement, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Betrayal1",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Docierasz do %location%, tylko po to, by powitała cię dobrze uzbrojona grupa ludzi. Jeden z nich występuje naprzód, kciuki zaczepione za pas trzymający miecz.%SPEECH_ON%No proszę, naprawdę jesteś głupi. %employer% nie zapomina łatwo - i nie zapomniał ostatniego razu, gdy zdradziłeś %faction%. Traktuj to jako drobny... rewanż.%SPEECH_OFF%Nagle wszyscy ludzie za porucznikiem ruszają. Do broni, to zasadzka! | Wchodzisz do %location%, ale wieśniacy wyglądają na przygotowanych: okiennice się zamykają, drzwi zatrzaskują. Gdy już masz wydać rozkaz rozpoczęcia rzezi, zza budynku wychodzi grupa ludzi.\n\nSą... znacznie lepiej uzbrojeni niż zwykli chłopi. Właściwie niosą sztandar %employer%. Zrozumienie, że wpadłeś w zasadzkę, przychodzi, gdy mężczyźni ruszają do szarży, a ty szybko każesz ludziom się zbroić. | Na drodze tuż przed %location% wita cię mężczyzna. Jest dobrze uzbrojony, dobrze opancerzony i najwyraźniej zadowolony, uśmiecha się głupkowato, gdy podchodzisz.%SPEECH_ON%Dobry wieczór, najemnicy. %employer% przesyła pozdrowienia.%SPEECH_OFF%W tej chwili z poboczy wyskakuje grupa ludzi. To zasadzka! Ten przeklęty szlachcic cię zdradził! | Stawiasz stopę w %location%, ale wita cię tylko samotny podmuch wiatru jęczący między starymi zabudowaniami. Myśląc, że cię zrobiono, dobywasz miecza.%SPEECH_ON%Dobra myśl.%SPEECH_OFF%Głos dobiega z budynku, z którego wychodzi mężczyzna z dobywanym ostrzem. Za nim w równym kroku podąża orszak uzbrojonych ludzi w barwach %faction%, rozchodząc się, by wpatrywać się w twoją kompanię.%SPEECH_ON%Będę się cieszył, wyrywając ten miecz z twojego zimnego chwytu.%SPEECH_OFF%Wzruszasz ramionami i pytasz, czemu cię wrobiono.%SPEECH_ON%%employer% nie zapomina tych, którzy go zdradzają lub zdradzają jego ród. To wszystko, co musisz wiedzieć. I tak nic ci to nie da, gdy już będziesz martwy.%SPEECH_OFF%Do broni, bo to zasadzka! | %location% jest puste. Twoi ludzie przeszukują budynki i nie znajdują nikogo. Nagle kilku ludzi zagradza drogę za tobą, a porucznik wychodzi naprzód z wrogim zamiarem. Trzyma tkaninę z herbem %employer%.%SPEECH_ON%Strasznie cicho, prawda? Jeśli zastanawiasz się, czemu tu jestem, to spłacam dług wobec %faction%. Obiecałeś dobrze wykonaną robotę. Nie dotrzymałeś słowa. Teraz giniesz.%SPEECH_OFF%Dobywasz miecza i błyskasz ostrzem w stronę porucznika.%SPEECH_ON%Wygląda na to, że %faction% znów złamie kolejną obietnicę.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractBetrayal);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().set("Betrayed", false);
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.CombatID = "Defend";
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[this.Contract.m.Destination.getTile().Type];
						p.Tile = this.World.getTile(this.World.worldToTile(this.World.State.getPlayer().getPos()));
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.Music = this.Const.Music.NobleTracks;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 150 * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Betrayal2",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Wycierasz miecz o nogawkę i szybko chowasz go do pochwy. Zasadzkarze leżą martwi, przebici i ułożeni w tej czy innej groteskowej pozie. %randombrother% podchodzi i pyta, co teraz. Wygląda na to, że %faction% nie będzie już zbyt przyjazne. | Zrzucasz martwe ciało zasadzkarza z końca miecza. Wygląda na to, że %faction% nie będzie już zbyt przyjazne. Może następnym razem, gdy zgodzę się coś dla nich zrobić, rzeczywiście to zrobię. | Cóż, jeśli nic innego, to nauka jest taka, by nie zgadzać się na zadanie, którego nie potrafisz wykonać. Ludzie tych ziem nie są szczególnie przyjaźni wobec tych, którzy nie dotrzymują obietnic... | Zdradziłeś %faction%, ale nie ma nad czym się rozwodzić. To oni zdradzili ciebie, to się teraz liczy! A na przyszłość lepiej bądź podejrzliwy wobec nich i każdego, kto nosi ich barwy. | %employer%, sądząc po martwych chorążych u twoich stóp, najwyraźniej już nie jest zadowolony. Jeśli miałbyś zgadywać, to przez coś z przeszłości - zdradę, porażkę, złośliwości, romans z córką szlachcica? Wszystko się zlewa, gdy próbujesz o tym myśleć. Ważne jest to, że ta wyrwa między wami nie zagoi się łatwo. Przez jakiś czas lepiej uważaj na ludzi %faction%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "A niech ich!",
					function getResult()
					{
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_61.png[/img]{Wracasz do %employer% i przekazujesz wieści. Odsuwa się i kiwa głową.%SPEECH_ON%Wszyscy?%SPEECH_OFF%Rozglądasz się.%SPEECH_ON%Słyszałeś, żeby ktoś tu przyszedł?%SPEECH_OFF%%employer% uśmiecha się i kręci głową.%SPEECH_ON%Tylko wieści o jakimś strasznym wydarzeniu, oczywiście. Przeklęci zbóje.%SPEECH_OFF%Pstryka palcami i mężczyzna zdaje się wyłaniać z cienia, by wypłacić ci nagrodę. | %employer% wita twój powrót, częstując cię drinkiem. Uśmiecha się ciepło jak na człowieka, który właśnie kazał wymordować chłopów.%SPEECH_ON%Wiatr niesie wieść, że %location% zostało obrócone w ruinę.%SPEECH_OFF%Kiwasz głową.%SPEECH_ON%Zbóje, co?%SPEECH_OFF%%employer% szczerzy zęby. Podaje ci sakiewkę z koronami.%SPEECH_ON%Zbóje, bez wątpienia.%SPEECH_OFF% | Gdy %location% zostało zniszczone, wracasz przekazać %employer% wieści. Obok stoi kilku miejscowych, więc mówisz o tym, że miejsce napadli 'zbóje'. Kiwając głową, z troską, zręcznym ruchem wsuwa ci sakiewkę z koronami. Potem zwraca się do miejscowych i mówi, że trzeba coś zrobić z problemem zbójów... | Mówisz %employer% o sukcesie. Uśmiecha się i zwołuje tłum prostych ludzi. Ogłasza, że 'zbóje' zniszczyli %location% i że trzeba podnieść podatki, by poradzić sobie z nowym problemem. Gdy kończy przemowę, odwraca się i wsuwa ci sakiewkę z koronami do płaszcza. | Wchodzisz do posiadłości %employer%. Obok niego stoi zapłakana kobieta. Gdy na niego patrzysz, kręci głową. Kiwasz i przekazujesz 'wieści'.%SPEECH_ON%Eee... zbóje... zniszczyli %location%.%SPEECH_OFF%%employer% kiwa głową z powagą.%SPEECH_ON%Tak, tak, wiem. Wdowa tutaj opowiedziała mi wszystko. Tragiczne wieści. Bardzo tragiczne.%SPEECH_OFF%Jeden z ludzi wręcza ci sakiewkę z koronami, gdy wychodzisz.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Uczciwa zapłata za uczciwą pracę. | Korony to korony.}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess);
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
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_61.png[/img]{Wchodzisz do %townname% i widzisz kilku znajomych chłopów stojących wokół %employer%. Obawiając się, że cię rozpoznają, trzymasz się w cieniu. Krzyczą, że zbóje zniszczyli %location%. %employer% wygląda na przejętego.%SPEECH_ON%Tak? To okropne! Zajmę się tym. Nie bójcie się, ochronię was!%SPEECH_OFF%Gdy kończy, jeden z jego strażników wsuwa ci sakiewkę z koronami. | Wchodzisz do posiadłości %employer% i widzisz kilku zakrwawionych chłopów stojących przy biurku. Ukrywasz się, aż skończą rozmowę i wyjdą. %employer% macha, byś podszedł.%SPEECH_ON%Zbóje. Mówili, że zrobili to zbóje. Doskonale. Twoja zapłata jest w rogu.%SPEECH_OFF% | %employer% wita twój powrót z uśmiechem.%SPEECH_ON%Byli ocaleni.%SPEECH_OFF%Machnięciem ręki odpędza twoje zmartwienie.%SPEECH_ON%Uważają, że to zbóje. Zwykły najazd włóczęgów. Nie masz się czym martwić. Twoja zapłata...%SPEECH_OFF%Przesuwa sakiewkę po biurku. Bierzesz ją i kiwasz głową.%SPEECH_ON%Dobrze się z tobą robi interesy.%SPEECH_OFF% | %employer% trzaska zwojem o biurko, gdy wchodzisz.%SPEECH_ON%Zostawiłeś kilku przy życiu! Ale... w porządku. Myślą, że to zbóje.%SPEECH_OFF%Kładziesz dłoń na rękojeści miecza i zerkasz na strażnika %employer%.%SPEECH_ON%Wciąż oczekuję pełnej zapłaty.%SPEECH_OFF%%employer% macha ręką w stronę biurka, gdzie leży sakiewka.%SPEECH_ON%Oczywiście. Ale następnym razem, gdy cię o coś poproszę, oczekuję pełnego wykonania, rozumiesz?%SPEECH_OFF% | Tłum chłopów otacza %employer%. Przez chwilę zastanawiasz się, czy zaraz go zlinczują, ale on ich odprawia. Gdy patrzy, jak znikają za rogiem, wyjaśnia, że to ocaleni z %location%. Zanim zdążysz coś powiedzieć, odpędza twoją obawę.%SPEECH_ON%Wciąż myślą, że to zbóje, ale nie jestem zadowolony z tego wyniku. To mogło się bardzo źle skończyć. Dla mnie, to znaczy.%SPEECH_OFF%Kiwasz głową i pytasz, czy chcesz, by tych kilku ocalałych zlikwidować, tak na wszelki wypadek. %employer% kręci głową.%SPEECH_ON%Nie, nie trzeba. Oto twoja zapłata, jak obiecałem, najemniku. Następnym razem jednak dopilnuj, by wykonać moje rozkazy.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Uczciwa zapłata za uczciwą pracę. | Korony to korony.}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnVictory);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractPoor, "Wypełniłeś kontrakt");
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
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Gdy wchodzisz do posiadłości %employer%, odwraca się i trzaska zwojem z rysunkiem o stół.%SPEECH_ON%Poznajesz tę osobę?%SPEECH_OFF%Podnosisz go. Szkicowana twarz wygląda uderzająco podobnie do twojej. %employer% odchyla się.%SPEECH_ON%Wiedzą, że ktoś zlecił atak na to miejsce. Wynoś się stąd, zanim moi ludzie przebiją cię na wylot.%SPEECH_OFF% | %SPEECH_ON%Ocaleni! Ocaleni! Co powiedziałem? 'Bez ocalałych', chyba to powiedziałem, prawda?%SPEECH_OFF%Kiwasz głową, gdy %employer% zaciska knykcie o blat.%SPEECH_ON%Więc czemu, do diabła, mam tu chłopów, którzy wpadli z krzykiem, że najemnicy napadli na ich miejsce? Martwi nie mówią, a kto mówi? Kto mówi, najemniku?%SPEECH_OFF%Stoisz wyprostowany.%SPEECH_ON%Ocaleni.%SPEECH_OFF%%employer% wskazuje drzwi.%SPEECH_ON%Właśnie. A teraz znikaj mi z oczu.%SPEECH_OFF% | Kiwasz głową, gdy %employer% mówi ci wieści: kilku chłopów uciekło i rozniosło wieść, że to była 'zlecona robota', by zniszczyć %location%. Ale ty się zastanawiasz...%SPEECH_ON%A czy możemy zatrzymać cały sprzęt, który znaleźliśmy?%SPEECH_OFF%%employer% śmieje się.%SPEECH_ON%Możesz sobie zatrzymać, co tylko chcesz, ale nie zobaczysz ani jednej korony z mojej sakwy. Wynoś się stąd, najemniku.%SPEECH_OFF% | Niestety wygląda na to, że kilku chłopów przeżyło rzeź. Opowiedzieli %employer% o bardzo konkretnych szczegółach: dobrze uzbrojeni, źle usposobieni ludzie zniszczyli %location%. Nie zbóje, ale najemnicy. Miałeś ich wszystkich zabić, nie zostawiając ocalałych, ale teraz... cóż, teraz nie dostaniesz zapłaty. | %employer% siedzi naprzeciwko ciebie, zaciska pięść, jego twarz czerwienieje. Pyta, jak ma podnosić podatki, by chronić ludzi przed zbójami, skoro wszyscy myślą, że to najemnicy zleceni zniszczyli %location%. Pytasz, co ma na myśli, a on odpowiada wprost: kilku chłopów przeżyło, cholerny idioto. Zostawienie ocalałych nie było częścią zlecenia i teraz zapłata %employer% nie trafi do twojej sakwy.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "W %settlementname% nie będą nas witać z otwartymi ramionami...",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail);
						this.Contract.m.Destination.getSettlement().getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationAttacked, "Napadłeś na: " + this.Flags.get("DestinationName"));
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			]
		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"location",
			this.m.Flags.get("DestinationName")
		]);
		_vars.push([
			"settlementname",
			this.m.Flags.get("SettlementName")
		]);
		_vars.push([
			"noblehousename",
			this.World.FactionManager.getFaction(this.m.Faction).getNameOnly()
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setFaction(this.m.Destination.getSettlement().getFaction());
				this.m.Destination.setOnCombatWithPlayerCallback(null);
				this.m.Destination.setAttackable(false);
				this.m.Destination.clearTroops();
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (this.World.FactionManager.isGreaterEvil())
		{
			return false;
		}

		if (this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isActive())
		{
			return false;
		}

		if (this.m.Settlement == null || this.m.Settlement.isNull())
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

		if (this.m.Settlement != null && !this.m.Settlement.isNull())
		{
			_out.writeU32(this.m.Settlement.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local dest = _in.readU32();

		if (dest != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(dest));
		}

		local settlement = _in.readU32();

		if (settlement != 0)
		{
			this.m.Settlement = this.WeakTableRef(this.World.getEntityByID(settlement));
		}

		this.contract.onDeserialize(_in);
	}

});

