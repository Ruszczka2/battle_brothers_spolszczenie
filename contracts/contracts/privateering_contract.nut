this.privateering_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Item = null,
		CurrentObjective = null,
		Objectives = [],
		LastOrderUpdateTime = 0.0
	},
	function create()
	{
		this.contract.create();
		local r = this.Math.rand(1, 100);

		if (r <= 70)
		{
			this.m.DifficultyMult = this.Math.rand(95, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}

		this.m.Type = "contract.privateering";
		this.m.Name = "Wyprawa Łupieżcza";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		local nobleHouses = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);

		foreach( i, h in nobleHouses )
		{
			if (h.getID() == this.getFaction())
			{
				nobleHouses.remove(i);
				break;
			}
		}

		nobleHouses.sort(this.onSortBySettlements);
		this.m.Flags.set("FeudingHouseID", nobleHouses[0].getID());
		this.m.Flags.set("FeudingHouseName", nobleHouses[0].getName());
		this.m.Flags.set("RivalHouseID", nobleHouses[1].getID());
		this.m.Flags.set("RivalHouseName", nobleHouses[1].getName());
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

		this.m.Flags.set("Score", 0);
		this.m.Flags.set("StartDay", 0);
		this.m.Flags.set("LastUpdateDay", 0);
		this.m.Flags.set("SearchPartyLastNotificationTime", 0);
		this.contract.start();
	}

	function onSortBySettlements( _a, _b )
	{
		if (_a.getSettlements().len() > _b.getSettlements().len())
		{
			return -1;
		}
		else if (_a.getSettlements().len() < _b.getSettlements().len())
		{
			return 1;
		}

		return 0;
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Flags.set("StartDay", this.World.getTime().Days);
				this.Contract.m.BulletpointsObjectives = [
					"Udaj się na ziemie, gdzie panuje %feudfamily%",
					"Napadaj i pal lokacje",
					"Niszcz napotkane karawany i patrole",
					"Wróć po 5 dniach"
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
				local f = this.World.FactionManager.getFaction(this.Flags.get("FeudingHouseID"));
				f.addPlayerRelation(-99.0, "Opowiedziałeś się po jednej ze stron w wojnie");
				this.Flags.set("StartDay", this.World.getTime().Days);
				local nonIsolatedSettlements = [];

				foreach( s in f.getSettlements() )
				{
					if (s.isIsolated() || !s.isDiscovered())
					{
						continue;
					}

					nonIsolatedSettlements.push(s);
					local a = s.getActiveAttachedLocations();

					if (a.len() == 0)
					{
						continue;
					}

					local obj = a[this.Math.rand(0, a.len() - 1)];
					this.Contract.m.Objectives.push(this.WeakTableRef(obj));
					obj.clearTroops();

					if (s.isMilitary())
					{
						if (obj.isMilitary())
						{
							this.Contract.addUnitsToEntity(obj, this.Const.World.Spawn.Noble, this.Math.rand(90, 120) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						}
						else
						{
							local r = this.Math.rand(1, 100);

							if (r <= 10)
							{
								this.Contract.addUnitsToEntity(obj, this.Const.World.Spawn.Mercenaries, this.Math.rand(90, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
							}
							else
							{
								this.Contract.addUnitsToEntity(obj, this.Const.World.Spawn.Noble, this.Math.rand(70, 100) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
							}
						}
					}
					else if (obj.isMilitary())
					{
						this.Contract.addUnitsToEntity(obj, this.Const.World.Spawn.Militia, this.Math.rand(80, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					}
					else
					{
						local r = this.Math.rand(1, 100);

						if (r <= 15)
						{
							this.Contract.addUnitsToEntity(obj, this.Const.World.Spawn.Mercenaries, this.Math.rand(80, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						}
						else if (r <= 30)
						{
							obj.getFlags().set("HasNobleProtection", true);
							this.Contract.addUnitsToEntity(obj, this.Const.World.Spawn.Noble, this.Math.rand(80, 100) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						}
						else if (r <= 70)
						{
							this.Contract.addUnitsToEntity(obj, this.Const.World.Spawn.Militia, this.Math.rand(70, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						}
						else
						{
							this.Contract.addUnitsToEntity(obj, this.Const.World.Spawn.Peasants, this.Math.rand(70, 100));
						}
					}

					if (this.Contract.m.Objectives.len() >= 3)
					{
						break;
					}
				}

				local origin = nonIsolatedSettlements[this.Math.rand(0, nonIsolatedSettlements.len() - 1)];
				local party = f.spawnEntity(origin.getTile(), "Kompania " + origin.getName(), true, this.Const.World.Spawn.Noble, 190 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
				party.setDescription("Profesjonalni żołdacy na usługach miejscowych lordów.");
				this.Contract.m.UnitsSpawned.push(party.getID());
				party.getLoot().Money = this.Math.rand(50, 200);
				party.getLoot().ArmorParts = this.Math.rand(0, 25);
				party.getLoot().Medicine = this.Math.rand(0, 3);
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
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(9000.0);
				c.addOrder(wait);
				local r = this.Math.rand(1, 100);

				if (r <= 15)
				{
					local rival = this.World.FactionManager.getFaction(this.Flags.get("RivalHouseID"));

					if (!f.getFlags().get("Betrayed"))
					{
						this.Flags.set("IsChangingSides", true);
						local i = this.Math.rand(1, 18);
						local item;

						if (i == 1)
						{
							item = this.new("scripts/items/weapons/named/named_axe");
						}
						else if (i == 2)
						{
							item = this.new("scripts/items/weapons/named/named_billhook");
						}
						else if (i == 3)
						{
							item = this.new("scripts/items/weapons/named/named_cleaver");
						}
						else if (i == 4)
						{
							item = this.new("scripts/items/weapons/named/named_crossbow");
						}
						else if (i == 5)
						{
							item = this.new("scripts/items/weapons/named/named_dagger");
						}
						else if (i == 6)
						{
							item = this.new("scripts/items/weapons/named/named_flail");
						}
						else if (i == 7)
						{
							item = this.new("scripts/items/weapons/named/named_greataxe");
						}
						else if (i == 8)
						{
							item = this.new("scripts/items/weapons/named/named_greatsword");
						}
						else if (i == 9)
						{
							item = this.new("scripts/items/weapons/named/named_javelin");
						}
						else if (i == 10)
						{
							item = this.new("scripts/items/weapons/named/named_longaxe");
						}
						else if (i == 11)
						{
							item = this.new("scripts/items/weapons/named/named_mace");
						}
						else if (i == 12)
						{
							item = this.new("scripts/items/weapons/named/named_spear");
						}
						else if (i == 13)
						{
							item = this.new("scripts/items/weapons/named/named_sword");
						}
						else if (i == 14)
						{
							item = this.new("scripts/items/weapons/named/named_throwing_axe");
						}
						else if (i == 15)
						{
							item = this.new("scripts/items/weapons/named/named_two_handed_hammer");
						}
						else if (i == 16)
						{
							item = this.new("scripts/items/weapons/named/named_warbow");
						}
						else if (i == 17)
						{
							item = this.new("scripts/items/weapons/named/named_warbrand");
						}
						else if (i == 18)
						{
							item = this.new("scripts/items/weapons/named/named_warhammer");
						}

						item.onAddedToStash("");
						this.Contract.m.Item = item;
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
				this.Contract.m.BulletpointsObjectives = [];

				foreach( obj in this.Contract.m.Objectives )
				{
					if (obj != null && !obj.isNull() && obj.isActive())
					{
						this.Contract.m.BulletpointsObjectives.push("Zniszcz: " + obj.getName() + " w pobliżu " + obj.getSettlement().getName());
						obj.getSprite("selection").Visible = true;
						obj.setAttackable(true);
						obj.setOnCombatWithPlayerCallback(this.onCombatWithLocation.bindenv(this));
					}
				}

				this.Contract.m.BulletpointsObjectives.push("Niszcz napotkane karawany i patrole, których właścicielem jest %feudfamily%");
				this.Contract.m.BulletpointsObjectives.push("Wróć w ciągu %days%");
				this.Contract.m.CurrentObjective = null;
			}

			function update()
			{
				if (this.Flags.get("LastUpdateDay") != this.World.getTime().Days)
				{
					if (this.World.getTime().Days - this.Flags.get("StartDay") >= 5)
					{
						this.Contract.setScreen("TimeIsUp");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Flags.set("LastUpdateDay", this.World.getTime().Days);
						this.start();
						this.World.State.getWorldScreen().updateContract(this.Contract);
					}
				}

				if (this.Contract.m.UnitsSpawned.len() != 0 && this.Time.getVirtualTimeF() - this.Contract.m.LastOrderUpdateTime > 2.0)
				{
					this.Contract.m.LastOrderUpdateTime = this.Time.getVirtualTimeF();
					local party = this.World.getEntityByID(this.Contract.m.UnitsSpawned[0]);
					local playerTile = this.World.State.getPlayer().getTile();

					if (party != null && party.getTile().getDistanceTo(playerTile) > 3)
					{
						local f = this.World.FactionManager.getFaction(this.Flags.get("FeudingHouseID"));
						local nearEnemySettlement = false;

						foreach( s in f.getSettlements() )
						{
							if (s.getTile().getDistanceTo(playerTile) <= 6)
							{
								nearEnemySettlement = true;
								break;
							}
						}

						if (nearEnemySettlement)
						{
							local c = party.getController();
							c.clearOrders();
							local move = this.new("scripts/ai/world/orders/move_order");
							move.setDestination(this.World.State.getPlayer().getTile());
							c.addOrder(move);
							local wait = this.new("scripts/ai/world/orders/wait_order");
							wait.setTime(this.World.getTime().SecondsPerDay * 1);
							c.addOrder(wait);

							if (party.getTile().getDistanceTo(playerTile) <= 8 && this.Time.getVirtualTimeF() - this.Flags.get("SearchPartyLastNotificationTime") >= 300.0)
							{
								this.Flags.set("SearchPartyLastNotificationTime", this.Time.getVirtualTimeF());
								this.Contract.setScreen("SearchParty");
								this.World.Contracts.showActiveContract();
							}
						}
					}
				}

				if (this.Flags.get("IsChangingSides") && this.Contract.getDistanceToNearestSettlement() >= 5 && this.World.State.getPlayer().getTile().HasRoad && this.Math.rand(1, 1000) <= 1)
				{
					this.Flags.set("IsChangingSides", false);
					this.Contract.setScreen("ChangingSides");
					this.World.Contracts.showActiveContract();
				}

				foreach( i, obj in this.Contract.m.Objectives )
				{
					if (obj != null && !obj.isNull() && !obj.isActive() || obj.getSettlement().getOwner().isAlliedWithPlayer() || obj.isAlliedWithPlayer())
					{
						obj.getSprite("selection").Visible = false;
						obj.setAttackable(false);
						obj.getFlags().set("HasNobleProtection", false);
						obj.setOnCombatWithPlayerCallback(null);
					}

					if (obj == null || obj.isNull() || !obj.isActive() || obj.getSettlement().getOwner().isAlliedWithPlayer() || obj.isAlliedWithPlayer())
					{
						this.Contract.m.Objectives.remove(i);
						this.Flags.set("LastUpdateDay", 0);
						break;
					}
				}
			}

			function onCombatWithLocation( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.CurrentObjective = _dest;

				if (_dest.getTroops().len() == 0)
				{
					this.onCombatVictory("RazeLocation");
					return;
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "RazeLocation";
					p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
					p.LocationTemplate.Template[0] = "tactical.human_camp";
					p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.None;
					p.LocationTemplate.CutDownTrees = true;
					p.LocationTemplate.AdditionalRadius = 5;

					if (_dest.isMilitary())
					{
						p.Music = this.Const.Music.NobleTracks;
					}
					else
					{
						p.Music = this.Const.Music.CivilianTracks;
					}

					p.EnemyBanners = [];

					if (_dest.getSettlement().isMilitary() || _dest.getFlags().get("HasNobleProtection"))
					{
						p.EnemyBanners.push(_dest.getSettlement().getBanner());
					}
					else
					{
						p.EnemyBanners.push("banner_noble_11");
					}

					if (_dest.getFlags().get("HasNobleProtection"))
					{
						local f = this.Flags.get("FeudingHouseID");

						foreach( e in p.Entities )
						{
							if (e.Faction == _dest.getFaction())
							{
								e.Faction = f;
							}
						}
					}

					this.World.Contracts.startScriptedCombat(p, _isPlayerAttacking, true, true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "RazeLocation")
				{
					this.Contract.m.CurrentObjective.setActive(false);
					this.Contract.m.CurrentObjective.spawnFireAndSmoke();
					this.Contract.m.CurrentObjective.clearTroops();
					this.Contract.m.CurrentObjective.getSprite("selection").Visible = false;
					this.Contract.m.CurrentObjective.setOnCombatWithPlayerCallback(null);
					this.Contract.m.CurrentObjective.setAttackable(false);
					this.Contract.m.CurrentObjective.getFlags().set("HasNobleProtection", false);
					this.Flags.set("Score", this.Flags.get("Score") + 5);

					foreach( i, obj in this.Contract.m.Objectives )
					{
						if (obj.getID() == this.Contract.m.CurrentObjective.getID())
						{
							this.Contract.m.Objectives.remove(i);
							break;
						}
					}

					this.Flags.set("LastUpdateDay", 0);
				}
			}

			function onPartyDestroyed( _party )
			{
				if (_party.getFaction() == this.Flags.get("FeudingHouseID") || this.World.FactionManager.isAllied(_party.getFaction(), this.Flags.get("FeudingHouseID")))
				{
					this.Flags.set("Score", this.Flags.get("Score") + 2);
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

				foreach( obj in this.Contract.m.Objectives )
				{
					if (obj != null && !obj.isNull() && obj.isActive())
					{
						obj.getSprite("selection").Visible = false;
						obj.setOnCombatWithPlayerCallback(null);
					}
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("Score") <= 9)
					{
						this.Contract.setScreen("Failure1");
					}
					else if (this.Flags.get("Score") <= 15)
					{
						this.Contract.setScreen("Success1");
					}
					else
					{
						this.Contract.setScreen("Success2");
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{Wchodzisz do pokoju %employer% i on od razu zaczyna mówić.%SPEECH_ON%{Dobrze cię widzieć, najemniku. Potrzebuję watahy, by narobiła bałaganu w garnkach i patelniach %feudfamily%, jeśli wiesz, co mam na myśli. Nie wiesz? Cóż, potrzebuję, żebyś wszedł na ich ziemie i spalił wszystko, co wpadnie ci w ręce. Powiedziałbym, że około %days% takich działań wyrządzi realne szkody ich wysiłkom wojennym. I bądź bardzo, bardzo ostrożny wobec wrogich patroli. | Ach, najemniku. Słuchaj, potrzebuję twardych ludzi, by weszli na ziemie %feudfamily% i spalili każdą karawanę i plony, na jakie trafią. To nie jest najbardziej honorowa robota, ale takie działania pomogą zakończyć wojnę. Powiedziałbym: spędź tam %days%, a potem wracaj. | Potrzebuję rabusiów, by na %days% wdarli się na ziemie %feudfamily% i zniszczyli jak najwięcej ich zasobów. Będą cię nienawidzić i będą cię ścigać szybko i zaciekle, ale jeśli unikniesz patroli, robota powinna być szybka i łatwa. Co ty na to? | Jesteśmy w stanie wojny z %feudfamily%, ale wojny wymagają czegoś więcej niż zderzenia armii. Czasem potrzebują podstępu. Potrzebuję, najemniku, byś przez %days% napadał na ich ziemie. Niszcz karawany, pal farmy, cokolwiek pomoże sprawie. Oczywiście uważaj na wrogie patrole. Wiem, że gdyby ktoś napadł na moje ziemie i ludzi, ścigałbym go podwójnie zaciekle. Więc co ty na to? | Krótko: potrzebuję kogoś, kto przez %days% będzie napadał na ziemie %feudfamily%. Oczywiście będą się spodziewać ludzi takich jak ty, więc unikaj patroli, gdy będziesz w terenie. Jesteś zainteresowany? | Mam dla ciebie idealną robotę, najemniku. Potrzebuję, żebyś najechał ziemie %feudfamily% i zniszczył tyle, ile zdołasz, przez około %days%. Takie działania potrafią kończyć wojny. Oczywiście oni też to rozumieją i zrobią wszystko, by cię powstrzymać.}%SPEECH_OFF% | %employer% wita cię w swoim pokoju i wskazuje mapę rozciągniętą na stole.%SPEECH_ON%Czy wiesz, że jednym z najlepszych sposobów walki z człowiekiem jest sprawić, by nie mógł w ogóle walczyć? Czytałem o tym w starej księdze.%SPEECH_OFF%Brzmi to bardzo poetycko jak na wojnę, ale prawdziwie. Kiwasz głową. Mężczyzna ciągnie.%SPEECH_ON%Chcę, abyś wszedł na ziemie %feudfamily% i zniszczył jak najwięcej ich terytorium. Niszcz karawany, pal farmy, wiesz, o co chodzi. Zrób jak najwięcej szkód w ciągu %days%, a potem wracaj. I jeszcze jedno. Uważaj na wrogie patrole. Nie będą łaskawi dla twoich... wybryków.%SPEECH_OFF% | Zastajesz %employer% przeglądającego księgę. Robi w niej notatki piórem.%SPEECH_ON%Mój dziadek pokonał kiedyś armię dziesięć razy większą. Jak to zrobił? Historycy i skrybowie, opłacani i karmieni przez moją rodzinę, opowiadają o wielkości na polu bitwy. Ale to nieprawda. Znasz prawdę?%SPEECH_OFF%Wzruszasz ramionami i zgadujesz, że użył jakiegoś podstępu. Szlachcic zatrzaskuje księgę i krótko wskazuje palcem.%SPEECH_ON%Dokładnie! Wziął garść ludzi i spalił wszystkie ich farmy, spichlerze i zapasy żywności. Na co wielka armia, jeśli nie można jej wykarmić? Chcę, byś zrobił to samo, najemniku. Idź na ziemie %feudfamily% na %days% i zniszcz, ile się da. Unikaj patroli, oczywiście. Będą walczyć jak wściekli o twoją szyję, jeśli cię dorwą.%SPEECH_OFF% | Wchodzisz do pokoju %employer%, gdzie sprzecza się ze starym generałem. Dowódca prostuje się.%SPEECH_ON%Nie splamię nazwiska mojej rodziny tak haniebnymi działaniami. Weź jakiegoś nisko urodzonego parobka, jeśli chcesz iść tą drogą!%SPEECH_OFF%Dowódca zabiera swoje rzeczy i odchodzi oburzony, zadzierając nosa, gdy mija cię w drzwiach. %employer% uśmiecha się, gdy wchodzisz. Rozkłada ręce i mówi.%SPEECH_ON%No proszę, bardzo potrzebny diabeł. Najemniku, potrzebuję kogoś, kto przez %days% będzie napadał na ziemie %feudfamily%. Moi szlachetni dowódcy uważają to za ujmę, ale myślę, że ty zrobisz to bez problemu. Oczywiście nasi wrogowie też uznają to za ujmę, więc jeśli cię znajdą, przygotuj się, bo ruszą na ciebie ze zdwojoną zaciekłością.%SPEECH_OFF% | %employer% wpatruje się w rozlane mleko, które płynie po stole i kapie z krawędzi.%SPEECH_ON%Zdarzyło ci się kiedyś, żeby dzień zepsuła ci taka drobnostka?%SPEECH_OFF%Kiwasz głową. Kto by nie miał. Mężczyzna ciągnie dalej.%SPEECH_ON%Chciałem zrobić ser, ale teraz nie mogę, bo składniki zostały zmarnowane. Najemniku, ta szybka i całkiem przypadkowa anegdota pasuje też do wojny. Potrzebuję, byś napadł na ziemie %feudfamily% i, mówiąc przysłowiowo, rozlał im mleko: niszcz karawany, pal farmy, zawalaj kopalnie, cokolwiek trzeba. %days% takiej roboty powinno załatwić sprawę. Oczywiście uważaj na patrole. Sam szukałbym sposobu, by nabić twoją głowę na pal, gdybyś robił to na moich ziemiach!%SPEECH_OFF% | Strażnik prowadzi cię do %employer%, który dogląda upraw w swoim ogrodzie. Rośliny są przywiędłe, liście postrzępione i nakrapiane po żerowaniu inwazyjnych owadów. Podnosząc jedną z martwych roślin, %employer% mówi.%SPEECH_ON%Wyglądało na to, że to będzie najsilniejszy sezon dla tych upraw. A jednak są tu, powalone przez najmniejsze z robactwa, które szalało po polu. Pewnie te małe cholerniki miały niezłą zabawę.%SPEECH_OFF%Odkłada roślinę i klepie cię po ramieniu.%SPEECH_ON%Najemniku, potrzebuję kogoś, kto będzie diabelskim owadem w ogrodzie mojego wroga. Potrzebuję, byś przez co najmniej %days% napadał na ziemie %feudfamily%. Oczywiście, jeśli cię złapią, potraktują cię jak robaka i zgniecie jak robaka. Trzymaj się więc z dala od butów na ziemi. Wiesz, jak robak by zrobił.%SPEECH_OFF% | %employer% zabawia dziewkę, gdy wchodzisz do jego pokoju. Ona szybko zbiera swoje rzeczy i w pośpiechu wychodzi, unikając twojego wzroku. Zadowolony szlachcic nalewa sobie wina.%SPEECH_ON%Nie przejmuj się nią. To przyjaciółka mojej żony. Tyle.%SPEECH_OFF%Odstawia karafkę na biurko.%SPEECH_ON%Mówiąc o przyjaciołach, może zostałbyś moim i napadł na ziemie %feudfamily%?%SPEECH_OFF%Mężczyzna chwieje się, podchodzi i siada na krawędzi biurka. Wącha palce, wzrusza ramionami i pije wino.%SPEECH_ON%Wejdź na ich ziemie i niszcz, ile się da, przez %days%. Potem wracaj. To znaczy możesz tam zostać, jeśli chcesz, ale radzę wrócić, bo ich armie nie będą długo znosić twoich wygłupów. Szlachta nie darzy rabusiów sympatią. Na pewno rozumiesz tę politykę.%SPEECH_OFF% | %employer% jest otoczony przez swoich dowódców. Wzywa cię i wskazuje palcem, jakby oskarżał cię o zbrodnię, o której nawet nie wiedziałeś.%SPEECH_ON%To nasz człowiek! To on to zrobi! Najemniku! Potrzebuję twardych wojowników, by przez %days% napadać na ziemie %feudfamily%. Zniszcz tyle, ile się da, cokolwiek uderzy w ich zdolność prowadzenia wojny. Oczywiście bądź zwinny. Będą chcieli szybko zgnieść każdy napad, który odkryją.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Wyruszenie na całe pięć dni będzie cię kosztować. | To coś, czym możemy się zająć. | Zapłata?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{To nie jest tego warte. | Jesteśmy potrzebni gdzie indziej. | To zbyt długie zobowiązanie dla kompanii.}",
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
			ID = "SearchParty",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_90.png[/img]{Zbliżasz się do zagrody, gdy nagle jedna z okiennic otwiera się z hukiem. Stara kobieta krzyczy zachrypniętym głosem, machając białą flagą. %randombrother% idzie sprawdzić, słucha jej chwilę, po czym szybko wraca.%SPEECH_ON%Panie, mówi, że %feudfamily% wie, gdzie jesteśmy, i że nadciąga duży kontyngent wrogich sił. I tak, użyła słowa 'kontyngent'.%SPEECH_OFF% | Gdy mijasz gospodarstwo, wybiega mały chłopiec.%SPEECH_ON%Ooo, to wy macie zabić najeźdźców?%SPEECH_OFF%Pytasz, kto mu to powiedział. Chłopak wzrusza ramionami.%SPEECH_ON%Kręciłem się po karczmie i słyszałem, że %feudfamily% wie, gdzie są rabusie, i wysyła wielkich chłopów, żeby ich porządnie roznieśli!%SPEECH_OFF%Dzieciak klaszcze dłońmi, jakby zgniatał robaka. Głaszczesz go po włosach.%SPEECH_ON%Jasne, to my. A teraz biegnij do domu.%SPEECH_OFF%Szybko informujesz %companyname% o wiadomości. | %randombrother% zbiega z jednego ze wzgórz. Zatrzymuje się przy tobie, łapiąc powietrze.%SPEECH_ON%Panie, ja... oni...%SPEECH_OFF%Prostuje się.%SPEECH_ON%Muszę ćwiczyć. Ale nie po to przyszedłem! Nadchodzi ogromna grupa wrogich żołnierzy, właśnie teraz. Myślę, że dokładnie wiedzą, gdzie jesteśmy, panie.%SPEECH_OFF%Kiwasz głową i każesz ludziom się przygotować. | Zwiad melduje, że ogromny wrogi patrol zna twoją pozycję i już nadciąga! %companyname% powinno się przygotować, czy to do ucieczki, czy do stanięcia i walki. | Zostaliście zauważeni i nadciąga duża siła żołnierzy %feudfamily%! Przygotuj ludzi najlepiej, jak potrafisz, bo raporty mówią, że wrogowie są dobrze uzbrojeni. | %randombrother% relacjonuje, co słyszał od miejscowych. Mówią, że w twoją stronę idzie duża grupa żołnierzy niosących sztandar. Prosisz najemnika o opis herbu, a on robi to szczegółowo: to ludzie %feudfamily%. Musieli jakoś do was dotrzeć. %companyname% powinno szykować się na piekielną walkę! | Grupa kobiet piorących w strumieniu pyta, co tu jeszcze robicie. Pytasz, co mają na myśli. Jedna wybucha śmiechem, równie barbarzyńskim, jak tylko się da.%SPEECH_ON%Słucham? Pytamy, czemu jeszcze tu siedzicie. Wiecie, że %feudfamily% idzie twardo po takich jak wy. Z tego co słyszę, zaraz będą wam siedzieć na karku.%SPEECH_OFF%Pytasz, skąd to wiedzą. Jedna z kobiet uderza koszulą w strumień.%SPEECH_ON%Panie, musisz być głupszy niż piekło. Plotki biegną szybciej niż koń. Nie pytaj jak. Tak już jest.%SPEECH_OFF%Jeśli to, co mówią te kobiety, jest prawdą, to %companyname% czeka ciężka walka! | Wchodzisz na grzbiet wzgórza i przyglądasz się okolicy, jak tylko możesz. Niewiele widać poza dużą grupą ludzi niosących sztandar %feudfamily%, którzy zdają się iść w waszą stronę. To widok jak diabli, a wkrótce zobaczysz go z bliska.\n\n Wrogowie dopadli %companyname%! Powinieneś przygotować się na piekielną walkę, bo spaliliście im tyle rzeczy.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Miejcie się na baczności!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TimeIsUp",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_36.png[/img]{Minęło już prawie %maxdays%. Kompania powinna ruszać z powrotem do %employer% po zapłatę. | Kompania jest w terenie od %maxdays%. %employer% będzie teraz oczekiwał twojego powrotu. | Po %maxdays% grabieży nadszedł czas wrócić do %employer% po pieniądze. Nie ma potrzeby tracić ani chwili na coś, za co nie płacą. | %employer% wynajął cię na %maxdays%. Kompania nie powinna spędzać w terenie ani chwili dłużej, niż musi. Wróć po zapłatę. | %companyname% włożyło %maxdays% pracy w wykonywanie poleceń %employer%. To cały czas, za jaki był gotów zapłacić, więc najlepiej wrócić teraz. | %employer% zapłacił za %maxdays% i tyle właśnie zrobiłeś. %companyname% powinno szybko wrócić po zapłatę. | Choć plądrowanie ziem zaczyna ci się podobać, %employer% płaci tylko za %maxdays% pracy. Lepiej wracaj. | Wykonałeś dobrą robotę, ale czas wrócić do %employer%, bo płaci ci tylko za %maxdays% twoich usług.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Czas wrócić do %townname%.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ChangingSides",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Podczas drogi powoli zbliża się mężczyzna w ciemnym płaszczu. Twarz skrywa kaptur. Zatrzymuje się przed tobą i wyciąga dłonie.%SPEECH_ON%Pozdrowienia. Jestem posłańcem %rivalhouse%. Mamy dla ciebie ofertę. Porzuć broń dla %noblehouse% i dołącz do nas. U nas nie zabraknie ci pracy, a twoja kompania zawsze będzie pierwsza w kolejce po najlepsze kontrakty. Dla osłody mam ci przekazać wspaniałą broń zwaną %nameditem%.%SPEECH_OFF%Rozważasz propozycję. Zmiana stron to część życia najemnika. Który ród szlachecki traktuje kompanię lepiej? Który ma większe szanse wygrać? | Schodzisz z drogi za potrzebą. Gdy się załatwiasz, z mokrych krzaków nagle wychodzi mężczyzna, choć sam jest suchy. Odsakujesz i dobywasz sztyletu, ale on unosi dłonie.%SPEECH_ON%Spokojnie, najemniku. Jestem posłańcem %rivalhouse%. Mam ci złożyć, i tylko złożyć, ofertę. Dołącz do nas. Zawsze będziesz mieć u nas pierwszeństwo, czyli najlepsze kontrakty i najlepszą zapłatę, a uwierz mi, zawsze będziemy potrzebować takich jak ty. Dla osłody miałem ci to wręczyć.%SPEECH_OFF%Powoli wyciąga mistrzowsko wykutą broń. Prosisz go o chwilę i wracasz dokończyć potrzebę. Myśli kłębią ci się w głowie, podczas gdy z drugiej strony wciąż płynie to, co płynie. | Podczas rozpoznania terenu podchodzi mężczyzna w ciemnym płaszczu. %randombrother% chwyta go za kaptur i przykłada ostrze do szyi. Mężczyzna tylko unosi dłonie i mówi, że przynosi wiadomość od %rivalhouse%. Kiwasz głową i pozwalasz mu mówić.%SPEECH_ON%Mamy ofertę: dołączcie do nas. Porzućcie tych szlacheckich nieudaczników i pracujcie dla nas. Dostaniecie najlepsze kontrakty i najlepszą zapłatę, a przede wszystkim będziecie po stronie zwycięzców! W ramach dobrej woli mam przekazać tę piękną broń zwaną %nameditem%. Jeśli się zgodzicie, oczywiście.%SPEECH_OFF%Ostrożnie rozważasz ofertę, bo zmiana stron nie jest decyzją do podejmowania lekko. | Cienista postać schodzi drogą z wyciągniętym zwojem.%SPEECH_ON%Dobry wieczór, %companyname%. Przychodzę od %rivalhouse% z ofertą służby. Porzućcie swoich dobroczyńców i dołączcie do nas. Znajdziecie lepsze i liczniejsze kontrakty, a co najważniejsze, będziecie po zwycięskiej stronie tej wojny! Jeśli się zgodzicie, w ramach dobrej woli otrzymacie broń zwaną %nameditem%.%SPEECH_OFF%%randombrother% patrzy na ciebie i wzrusza ramionami.%SPEECH_ON%Nie chcę wychodzić przed szereg, ale powiedziałbym, że warto to rozważyć.%SPEECH_OFF%Owszem. | Oddzielasz się od kompanii, by dobrze rozejrzeć się w terenie. Gdy obserwujesz pola, nagle pojawia się zakapturzona postać z czymś wyciągniętym przed siebie. %randombrother% wyskakuje i powala ją na ziemię, gotów wbić ostrze w twarz. Nieznajomy unosi ręce, trzymając zwój. Każesz mu wstać i przedstawić się. Mówi, że jest z %rivalhouse% i ma ofertę dla %companyname%.%SPEECH_ON%Zmieńcie strony. Jako najemnicy nie macie honoru do stracenia, wręcz się tego od was oczekuje. Gonienie za koronami, prawda? My mamy najwięcej kontraktów i najlepszą zapłatę. Tego szukacie, nie?%SPEECH_OFF%Posłaniec poprawia ubranie, prostuje się jak tymczasowo zawstydzony ambasador.%SPEECH_ON%Dodatkowo, jeśli przyjmiecie naszą ofertę, mam wam przekazać tę broń o nazwie %nameditem% jako znak dobrej woli. No i co powiecie?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Intrygująca propozycja. Przyjmuję ją.",
					function getResult()
					{
						return "AcceptChangingSides";
					}

				},
				{
					Text = "Marnujesz swój czas. Odejdź, albo powieszę cię na tamtym drzewie.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AcceptChangingSides",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Przyjmujesz ofertę. Tajemniczy posłaniec prowadzi cię do ukrytej kępy i wydobywa broń zza krzaków, po czym wręcza ją.%SPEECH_ON%Dobrze robić z tobą interesy, najemniku.%SPEECH_OFF%Można śmiało powiedzieć, że %employer% i cała jego rodzina teraz cię nienawidzą. | Po przyjęciu oferty posłaniec prowadzi cię poza szlak, by wyciągnąć broń zza krzaków. Wręczając ją, ściska ci dłoń.%SPEECH_ON%Dokonałeś właściwego wyboru, najemniku.%SPEECH_OFF%%employer% z pewnością cię teraz nienawidzi i nie ma sensu do niego wracać, chyba że nowi dobroczyńcy tego zażądają.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zatem od teraz %rivalhouse% jest naszym pracodawcą!",
					function getResult()
					{
						this.Contract.m.Item = null;
						local f = this.World.FactionManager.getFaction(this.Contract.getFaction());
						f.addPlayerRelation(-f.getPlayerRelation(), "Zmieniłeś strony w wojnie");
						f.getFlags().set("Betrayed", true);
						local a = this.World.FactionManager.getFaction(this.Flags.get("RivalHouseID"));
						a.addPlayerRelationEx(50.0 - a.getPlayerRelation(), "Zmieniłeś strony w wojnie");
						a.makeSettlementsFriendlyToPlayer();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.updateAchievement("NeverTrustAMercenary", 1, 1);
				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(this.Contract.m.Item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + this.Contract.m.Item.getIcon(),
					text = "Zdobywasz " + this.Contract.m.Item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% wita cię w swoim pokoju. Wręcza ci mieszek z %reward_completion% koron.%SPEECH_ON%Dobra robota, najemniku. Zrobiłeś prawie wszystko, o co można było prosić.%SPEECH_OFF% | %employer% zajęty jest doglądaniem kur. Przepychasz się przez stado, by do niego dotrzeć, i przekazujesz nowiny. Reaguje pozytywnie.%SPEECH_ON%A tak? To dobrze. Chcesz zapłatę w paszy czy koronach?%SPEECH_OFF%Szlachcic patrzy na ciebie poważnie, po czym uśmiecha się krzywo.%SPEECH_ON%Możesz odebrać %reward_completion% koron od tego strażnika tam.%SPEECH_OFF% | %employer% jest zbyt zajęty, by cię przyjąć, ale %reward_completion% koron przekazanych przez jego strażnika wydaje się wystarczającą miarą zadowolenia z twojej pracy. | %employer% miesza palcem w kielichu wina.%SPEECH_ON%Grabież to brudna robota, ale spisałeś się. Przyznam, część mnie liczyła na apokalipsę dla moich wrogów, ale to, co zrobiłeś, wystarczy.%SPEECH_OFF%Wyjmuje palec, liże go i rzuca ci mieszek z %reward_completion% koron. | %employer% zapada się w krześle, dłonie bezwładne na podłokietnikach, stopy wysunięte.%SPEECH_ON%Twoja zapłata %reward_completion% koron jest tam.%SPEECH_OFF%Wskazuje róg pokoju, gdzie o ścianę opiera się worek. Idziesz po niego, a on mówi dalej.%SPEECH_ON%Powiedziałbym, że wykonałeś wystarczająco dobrą robotę. Ten mieszek powinien ciążyć moją radością.%SPEECH_OFF% | Zastajesz %employer% w psiarni, gdy karmi psy.%SPEECH_ON%Dobra robota, najemniku. Gdyby wszyscy moi żołnierze mieli twoją wytrwałość i zapał, ta wojna skończyłaby się, zanim minęła pierwsza pełnia. Szkoda, prawda?%SPEECH_OFF%Nagle odwraca się do ciebie, wpatrując uważnie. Myślisz, że to próba zaciągnięcia cię do jego armii. Grzecznie odmawiasz i pytasz o zapłatę. Wskazuje palcem, trzymając w dłoni wiotki pasek boczku, na mężczyznę stojącego po drugiej stronie.%SPEECH_ON%Ten strażnik ma to. Łącznie %reward_completion% koron.%SPEECH_OFF% | %employer% dziękuje za twoją służbę. To właściwie wszystko, co mówi, zanim wręcza ci sumę %reward_completion% koron. | Zastajesz %employer% wśród dowódców. Dostosowują mapę bitwy do zakresu twojej pracy. Szlachcic prostuje się i wpatruje w rezultaty.%SPEECH_ON%To nie wszystko, o co mogłem prosić, ale jest dobrze. Bardzo dobrze. Ten strażnik ma dla ciebie %reward_completion% koron.%SPEECH_OFF% | %employer% stoi przed mapą wiszącą na ścianie. Używa pióra do notatek i zauważasz, że znaki wyznaczają trasę, którą %companyname% przebyło przez ziemie %feudfamily%. Szlachcic mruczy i kiwa głową. Mówi, nie patrząc na ciebie.%SPEECH_ON%Nie jest najlepiej, ale jest dobrze. %reward_completion% koron jest dla ciebie w rogu.%SPEECH_OFF% | Jeden z dowódców %employer% powstrzymuje cię przed wejściem do jego pokoju. Wręcza mieszek z %reward_completion% koron.%SPEECH_ON%Pan jest zajęty. Proszę przyjąć zapłatę i odejść.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Uczciwa zapłata za uczciwą robotę.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Napadłeś na ziemie wrogów");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isCivilWar())
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
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% i jego dowódcy upijają się, gdy wchodzisz do pokoju. Tęgi generał klepie cię po ramieniu, wygląda jakby chciał coś powiedzieć, po czym odwraca się i wymiotuje. Odsuwasz się i odnajdujesz %employer%.%SPEECH_ON%Ach, najemniku! Ja -hic- no, proszę. %reward_completion% koron.%SPEECH_OFF%Wyciąga mieszek, który szybko zabierasz, zanim spotka go los wymiotującego dowódcy. %employer% zatacza się i opiera o biurko.%SPEECH_ON%Prawie wybiłeś dziurę w wysiłku wojennym %feudfamily%. Cholernie -hic- dobra robota! Najlepsza, najchętniej, najlepiej -hic- jaką słyszałem.%SPEECH_OFF%Wycofujesz się, omijając zabawę i kałuże. | %employer% wali kielichem wina o stół, rozlewając większość na siebie.%SPEECH_ON%Wspaniale! Wybitnie! Perfekcyjnie! Tak właśnie oceniam twoją robotę, najemniku. Do diabła, nawet paru dezerterów z armii %feudfamily% przyznało, że boją się, iż ich strona już przegrała! Proszę, weź %reward_completion% koron. Na mój rachunek.%SPEECH_OFF%Mężczyzna wybucha śmiechem i pije długi łyk. | Wchodzisz do pokoju %employer% i widzisz, jak studiuje mapę wojny. Łaskocze brodę piórem, mruczy pod nosem i co jakiś czas kiwa głową.%SPEECH_ON%Wiesz, prawie zabrakło mi atramentu, śledząc twoje ruchy po ziemiach %feudfamily%. Tak cholernie dobrą robotę zrobiłeś, najemniku. %reward_completion% koron znajdziesz w rogu.%SPEECH_OFF% | Mężczyzna wita cię przed pokojem %employer% z mieszkiem, który ciąży w dłoniach.%SPEECH_ON%%reward_completion% koron za twoje usługi. Mój pan jest zajęty, ale bardzo zadowolony. To chyba najlepszy dowód, jak bardzo docenia twoją pracę.%SPEECH_OFF%To dobry znak, tak. | Strażnik prowadzi cię do %employer%, który przebywa za zamkniętymi drzwiami. Jest tam z kobietą i wygląda na to, że ma... świąteczny nastrój. Strażnik puka, po czym rezygnuje.%SPEECH_ON%Miałem mu powiedzieć, że jesteś, ale nie lubi, gdy mu się przeszkadza. Zwłaszcza w takich momentach. Wiesz.%SPEECH_OFF%Kiwasz głową i pytasz o zapłatę. Strażnik prowadzi cię do skarbca. Spotykasz jastrzębiookiego mężczyznę siedzącego za stertami papierów i monet. Popycha w twoją stronę mieszek z %reward_completion% koron i odnotowuje transakcję na zwoju. | %employer% spotyka cię w ogrodzie. Nadzoruje służących sadzących rośliny w dobrej ziemi.%SPEECH_ON%Co masz w swoim ogrodzie, najemniku?%SPEECH_OFF%Delikatnie informujesz, że ogrodnictwo to nie twoja działka. Kiwając głową, jakby było to niezwykle interesujące, mówi dalej.%SPEECH_ON%Myślę o rzepach na nadchodzący sezon. Dobrze, dość gadania. Widzisz tego sługę, który się poci? To on trzyma ciężki mieszek. Ciężki, bo zawiera %reward_completion% koron. Twoja nagroda za dobrze wykonaną robotę, najemniku. Może kupisz sobie ogródek!%SPEECH_OFF% | %employer% i jego dowódcy pochylają się nad mapą bitwy. Jeden przesuwa znacznik z godłem twojej kompanii. Prowadzi go przez mapę, co chwilę stawiając znak tuszem. Krzyżujesz ręce i mówisz głośno.%SPEECH_ON%Podziwiacie moją robotę?%SPEECH_OFF%Szlachcic i dowódcy podnoszą wzrok. %employer% uśmiecha się i szybko podchodzi.%SPEECH_ON%A jakże! Zrobiłeś niesamowitą robotę, najemniku. Naprawdę. Ten strażnik ma %reward_completion% koron jako zapłatę za twoje usługi.%SPEECH_OFF% | %employer% stoi wśród swoich dowódców. Wydziera się, gdy wchodzisz do pokoju.%SPEECH_ON%Do diabła, chłopcze! Prawie zniszczyłeś wszystko, co mieli! Czego jeszcze mógłby chcieć ktoś taki jak ja poza piorunem z niebios? Dostaniesz %reward_completion% koron, co uważam za więcej niż wystarczającą zapłatę za robotę tej jakości!%SPEECH_OFF% | Zastajesz %employer% siedzącego w swoim pokoju. Wygląda na bardzo zadowolonego z ciebie.%SPEECH_ON%{No proszę, człowiek dnia. Moi mali ptaszkowie przylecieli do okna i opowiedzieli o twojej robocie. Wieści szybko się niosą, gdy wykonujesz tak dobrą robotę! %feudfamily% zostanie okaleczone, a wojna przybliży się do końca o wiele kroków! Przygotowałem mieszek z %reward_completion% koron dla ciebie, tam w rogu. | Dodaj trochę animuszu, najemniku. To, co zrobiłeś %feudfamily%, przerosło nawet to, o co prosiłem. Jestem zaskoczony, że nie poszedłeś o krok dalej i nie wyrżnąłeś całej krwi tej linii. Cóż, wszystko w swoim czasie. Teraz czeka na ciebie %reward_completion% koron w tamtym rogu.}%SPEECH_OFF% | Zastajesz %employer% przykucniętego przy stole z mapą wojny. Jego oczy zaglądają ponad krawędź, skanując horyzont znaczników.%SPEECH_ON%Witaj, najemniku.%SPEECH_OFF%Podskakuje na nogi. Jedną ręką podnosi znaczniki %feudfamily% i zaczyna je odrzucać.%SPEECH_ON%Podziwiaj swoje dzieło, najemniku. Okaleczyłeś moich wrogów niemal bez wysiłku! Mówię tu w swoim imieniu, ale to, co zrobiłeś, przewyższa to, co dałaby wielka bitwa! %reward_completion% koron czeka na ciebie w rogu. Mam nadzieję, że to wystarczająca zapłata, bo robota była znakomita.%SPEECH_OFF% | Zastajesz %employer% i jego dowódców oraz gromadę kobiet, które nie wyglądają na właściwie ubrane do żadnej znanej ci wojny.%SPEECH_ON%Najemniku! Wejdźże!%SPEECH_OFF%%employer% cofa się, mając kobietę przy każdym ramieniu. Idziesz za nim, jak tylko się da. Jedna z kobiet próbuje wciągnąć cię do zabawy, ale generał ją przejmuje. %employer% zapada się w fotel, a kobiety siadają mu na kolanach.%SPEECH_ON%To ty jesteś powodem świętowania, najemniku. Tak dobrze napadałeś na ziemie %feudfamily%, że sądzę, iż przybliżyłeś nas do końca wojny bardziej niż jakakolwiek wielka bitwa! Na zdrowie!%SPEECH_OFF%Rozglądasz się.%SPEECH_ON%Uroczystości są miłe, ale nie muszę walczyć o kobiety i trunki. Należysz mi pieniądze.%SPEECH_OFF%Twój pracodawca kiwa głową.%SPEECH_ON%Oczywiście, oczywiście! Odwiedź mojego skarbnika i pokaż mu swój znak. Będzie miał dla ciebie %reward_completion% koron.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Uczciwa zapłata za uczciwą robotę.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess * 2);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess * 2, "Napadłeś na ziemie wrogów");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isCivilWar())
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
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{Wchodzisz do pokoju %employer% już pogodzony z tym, jaką wściekłość wyładuje. I wyładowuje.%SPEECH_ON%Wyjaśnij mi to, najemniku. Płacę ci, byś napadł na ziemie %feudfamily%. Zgadzasz się, bo to dobra oferta i obie strony mogą zyskać. Teraz stoisz przede mną i mówisz, że nie zrobiłeś nic. Po co w ogóle przekroczyłeś ten próg, ty żałosny woreczku po psie? Nie, jesteś gorszy, jesteś skomlącym robakiem próbującym okraść szlachcica wykonującego szlachetną pracę. Wynoś się, zanim stracę cierpliwość.%SPEECH_OFF%Mimo zuchwałości %employer% to on jest o krok od niebezpieczeństwa. Wychodzisz szybko, zanim to ty stracisz cierpliwość i wraz z nią życie szlachcica. | Wracasz do %employer%, ale strażnik zatrzymuje cię przed drzwiami.%SPEECH_ON%On już wie, co masz, a raczej czego nie zrobiłeś. Lepiej tam nie wchodź.%SPEECH_OFF%Trzask przewróconego stołu wstrząsa drzwiami. Potem rozlega się niezrozumiały krzyk. Słuchasz rady strażnika i odchodzisz. | %employer% przesuwa palcem po krawędzi kielicha. Ten przeciągle jęczy, gdy palec krąży wciąż i wciąż.%SPEECH_ON%Taka słodka nuta. Jak to możliwe, że zwykły kielich jest lepszy od ciebie, najemniku? Cóż, tak to bywa. Proszę kogoś o coś, a on tego nie robi. Co tu jeszcze mówić? Proszę, wyjdź.%SPEECH_OFF% | Zastajesz %employer% karmiącego psy resztkami. Służący patrzą z boku, jakby woleli być psami, jeśli to oznaczałoby takie traktowanie. %employer% odwraca się do ciebie, gdy pies delikatnie wyciąga mu z dłoni kawałek boczku.%SPEECH_ON%Psy wolą mięso. Karmię je resztkami świni. Dobra świnia. Miała dobre życie, poza jednym bardzo złym momentem, rzecz jasna. Teraz karmi moje psy. Ty, najemniku, przyniosłeś mi bardzo zły moment w swoim własnym życiu. Mam też karmić tobą moje psy? Nie? To wynoś się z mojego pokoju.%SPEECH_OFF% | %employer% odmawia spotkania. Dwóch jego strażników wyjaśnia, że jest wściekły na twoją porażkę w zadaniu choćby najmniejszej szkody na ziemiach %feudfamily%. Uczciwie. Dziękujesz strażnikom, że oszczędzili ci bezsensownej lawiny obelg i gniewu.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Do diabła z tobą!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Nie zdołałeś napaść na ziemie wrogów");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noblehouse",
			this.World.FactionManager.getFaction(this.m.Faction).getName()
		]);
		_vars.push([
			"rivalhouse",
			this.m.Flags.get("RivalHouseName")
		]);
		_vars.push([
			"feudfamily",
			this.m.Flags.get("FeudingHouseName")
		]);
		_vars.push([
			"maxdays",
			"pięć dni"
		]);
		local days = 5 - (this.World.getTime().Days - this.m.Flags.get("StartDay"));
		_vars.push([
			"dni",
			days > 1 ? "" + days + " dni" : "1 dzień"
		]);

		if (this.m.Item != null)
		{
			_vars.push([
				"nameditem",
				this.m.Item.getName()
			]);
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			foreach( obj in this.m.Objectives )
			{
				if (obj != null && !obj.isNull() && obj.isActive())
				{
					obj.clearTroops();
					obj.setAttackable(false);
					obj.getSprite("selection").Visible = false;
					obj.getFlags().set("HasNobleProtection", false);
					obj.setOnCombatWithPlayerCallback(null);
				}
			}

			this.m.Item = null;
			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		_out.writeU8(this.m.Objectives.len());

		foreach( o in this.m.Objectives )
		{
			if (o != null && !o.isNull())
			{
				_out.writeU32(o.getID());
			}
			else
			{
				_out.writeU32(0);
			}
		}

		if (this.m.Item != null)
		{
			_out.writeBool(true);
			_out.writeI32(this.m.Item.ClassNameHash);
			this.m.Item.onSerialize(_out);
		}
		else
		{
			_out.writeBool(false);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local numObjectives = _in.readU8();

		for( local i = 0; i != numObjectives; i = i )
		{
			local o = _in.readU32();

			if (o != 0)
			{
				this.m.Objectives.push(this.WeakTableRef(this.World.getEntityByID(o)));
				local obj = this.m.Objectives[this.m.Objectives.len() - 1];

				if (!obj.isMilitary() && !obj.getSettlement().isMilitary() && !obj.getFlags().get("HasNobleProtection"))
				{
					local garbage = [];

					foreach( i, e in obj.getTroops() )
					{
						if (e.ID == this.Const.EntityType.Footman || e.ID == this.Const.EntityType.Greatsword || e.ID == this.Const.EntityType.Billman || e.ID == this.Const.EntityType.Arbalester || e.ID == this.Const.EntityType.StandardBearer || e.ID == this.Const.EntityType.Sergeant || e.ID == this.Const.EntityType.Knight)
						{
							garbage.push(i);
						}
					}

					garbage.reverse();

					foreach( g in garbage )
					{
						obj.getTroops().remove(g);
					}
				}
			}

			i = ++i;
		}

		local hasItem = _in.readBool();

		if (hasItem)
		{
			this.m.Item = this.new(this.IO.scriptFilenameByHash(_in.readI32()));
			this.m.Item.onDeserialize(_in);
		}

		this.contract.onDeserialize(_in);
	}

});

