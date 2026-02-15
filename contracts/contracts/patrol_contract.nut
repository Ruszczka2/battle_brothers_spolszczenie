this.patrol_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Location1 = null,
		Location2 = null,
		NextObjective = null,
		Dude = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.patrol";
		this.m.Name = "Patrol";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 5.0;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
		this.m.MakeAllSpawnsResetOrdersOnceDiscovered = true;
		this.m.DifficultyMult = 1.0;
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

		local settlements = clone this.World.FactionManager.getFaction(this.m.Faction).getSettlements();
		local i = 0;

		while (i < settlements.len())
		{
			local s = settlements[i];

			if (s.isIsolatedFromRoads() || !s.isDiscovered() || s.getID() == this.m.Home.getID())
			{
				settlements.remove(i);
				continue;
			}

			i = ++i;
			i = i;
		}

		this.m.Location1 = this.WeakTableRef(this.getNearestLocationTo(this.m.Home, settlements, true));
		this.m.Location2 = this.WeakTableRef(this.getNearestLocationTo(this.m.Location1, settlements, true));
		this.m.Payment.Pool = 750 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 3);

		if (r == 1)
		{
			this.m.Payment.Count = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else if (r == 2)
		{
			this.m.Payment.Count = 0.75;
			this.m.Payment.Completion = 0.25;
		}
		else
		{
			this.m.Payment.Count = 1.0;
		}

		local maximumHeads = [
			20,
			25,
			30,
			35
		];
		this.m.Payment.MaxCount = maximumHeads[this.Math.rand(0, maximumHeads.len() - 1)];
		this.m.Flags.set("HeadsCollected", 0);
		this.m.Flags.set("StartDay", 0);
		this.m.Flags.set("LastUpdateDay", 0);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Flags.set("StartDay", this.World.getTime().Days);
				this.Contract.m.BulletpointsObjectives = [
					"Patroluj drogę do " + this.Contract.m.Location1.getName(),
					"Patroluj drogę do " + this.Contract.m.Location2.getName(),
					"Patroluj drogę do " + this.Contract.m.Home.getName()
				];
				this.Contract.m.BulletpointsObjectives.push("Wróć w ciągu %days% dni");

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
				this.Flags.set("EnemiesAtWaypoint1", this.Math.rand(1, 100) <= 25 * this.Math.pow(this.Contract.getDifficultyMult(), 2));
				this.Flags.set("EnemiesAtWaypoint2", this.Math.rand(1, 100) <= 25 * this.Math.pow(this.Contract.getDifficultyMult(), 2) + (this.Flags.get("EnemiesAtWaypoint1") ? 0 : 50));
				this.Flags.set("EnemiesAtLocation3", this.Math.rand(1, 100) <= 25 * this.Math.pow(this.Contract.getDifficultyMult(), 2) + (this.Flags.get("EnemiesAtWaypoint2") ? 0 : 100));
				this.Flags.set("StartDay", this.World.getTime().Days);

				if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().get("Betrayed"))
				{
					this.Flags.set("IsBetrayal", this.Math.rand(1, 100) <= 75);
				}
				else
				{
					local r = this.Math.rand(1, 100);

					if (r <= 10)
					{
						if (this.World.FactionManager.isGreenskinInvasion())
						{
							this.Flags.set("IsCrucifiedMan", true);
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
				this.Contract.m.Location1.getSprite("selection").Visible = true;
				this.Contract.m.Location2.getSprite("selection").Visible = false;
				this.Contract.m.Home.getSprite("selection").Visible = false;
				this.Contract.m.NextObjective = this.Contract.m.Location1;
				this.Contract.m.BulletpointsObjectives = [
					"Patroluj drogę do " + this.Contract.m.Location1.getName()
				];

				if (this.Contract.m.Payment.Count != 0)
				{
					this.Contract.m.BulletpointsObjectives.push("Otrzymasz zapłatę za każdą głowę zdobytą na szlaku (%killcount%/%maxcount%)");
				}

				this.Contract.m.BulletpointsObjectives.push("Wróć w ciągu %days% dni");
			}

			function update()
			{
				if (this.Flags.get("LastUpdateDay") != this.World.getTime().Days)
				{
					if (this.World.getTime().Days - this.Flags.get("StartDay") >= 5)
					{
						this.Contract.setScreen("Failure1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Flags.set("LastUpdateDay", this.World.getTime().Days);
						this.start();
						this.World.State.getWorldScreen().updateContract(this.Contract);
					}
				}

				if (this.Contract.isPlayerAt(this.Contract.m.Location1))
				{
					this.Contract.setScreen("Success1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("EnemiesAtWaypoint1"))
				{
					if (this.Contract.spawnEnemies())
					{
						this.Flags.set("EnemiesAtWaypoint1", false);
					}
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				this.Contract.addKillCount(_actor, _killer);
			}

			function onCombatVictory( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Location2",
			function start()
			{
				this.Contract.m.Location1.getSprite("selection").Visible = false;
				this.Contract.m.Location2.getSprite("selection").Visible = true;
				this.Contract.m.Home.getSprite("selection").Visible = false;
				this.Contract.m.NextObjective = this.Contract.m.Location2;
				this.Contract.m.BulletpointsObjectives = [
					"Patroluj drogę do " + this.Contract.m.Location2.getName()
				];

				if (this.Contract.m.Payment.Count != 0)
				{
					this.Contract.m.BulletpointsObjectives.push("Otrzymasz zapłatę za każdą głowę zdobytą na szlaku(%killcount%/%maxcount%)");
				}

				this.Contract.m.BulletpointsObjectives.push("Wróć w ciągu %days% dni");
			}

			function update()
			{
				if (this.Flags.get("LastUpdateDay") != this.World.getTime().Days)
				{
					if (this.World.getTime().Days - this.Flags.get("StartDay") >= 5)
					{
						this.Contract.setScreen("Failure1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Flags.set("LastUpdateDay", this.World.getTime().Days);
						this.start();
						this.World.State.getWorldScreen().updateContract(this.Contract);
					}
				}

				if (this.Contract.isPlayerAt(this.Contract.m.Location2))
				{
					this.Contract.setScreen("Success2");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("EnemiesAtWaypoint2"))
				{
					if (this.Contract.spawnEnemies())
					{
						this.Flags.set("EnemiesAtWaypoint2", false);
					}
				}

				if (this.Flags.get("IsCrucifiedMan") && !this.TempFlags.get("IsCrucifiedManShown") && this.World.State.getPlayer().getTile().HasRoad && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 1)
				{
					this.TempFlags.set("IsCrucifiedManShown", true);
					this.Contract.setScreen("CrucifiedA");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsCrucifiedManWon"))
				{
					this.Flags.set("IsCrucifiedManWon", false);

					if (this.Math.rand(1, 100) <= 50)
					{
						this.Contract.setScreen("CrucifiedE_AftermathGood");
					}
					else
					{
						this.Contract.setScreen("CrucifiedE_AftermathBad");
					}

					this.World.Contracts.showActiveContract();
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				this.Contract.addKillCount(_actor, _killer);
			}

			function onCombatVictory( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);

				if (_combatID == "CrucifiedMan")
				{
					this.Flags.set("IsCrucifiedManWon", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.Location1.getSprite("selection").Visible = false;
				this.Contract.m.Location2.getSprite("selection").Visible = false;
				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.Contract.m.NextObjective = this.Contract.m.Home;
				this.Contract.m.BulletpointsObjectives = [
					"Patroluj drogę do " + this.Contract.m.Home.getName()
				];

				if (this.Contract.m.Payment.Count != 0)
				{
					this.Contract.m.BulletpointsObjectives.push("Otrzymasz zapłatę za każdą głowę zdobytą na szlaku (%killcount%/%maxcount%)");
				}

				this.Contract.m.BulletpointsObjectives.push("Wróć w ciągu %days% dni");
			}

			function update()
			{
				if (this.Flags.get("LastUpdateDay") != this.World.getTime().Days)
				{
					if (this.World.getTime().Days - this.Flags.get("StartDay") >= 5)
					{
						this.Contract.setScreen("Failure1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Flags.set("LastUpdateDay", this.World.getTime().Days);
						this.start();
						this.World.State.getWorldScreen().updateContract(this.Contract);
					}
				}

				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("HeadsCollected") != 0)
					{
						this.Contract.setScreen("Success3");
					}
					else
					{
						this.Contract.setScreen("Success4");
					}

					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("EnemiesAtWaypoint3"))
				{
					if (this.Contract.spawnEnemies())
					{
						this.Flags.set("EnemiesAtWaypoint3", false);
					}
				}

				if (this.Flags.get("IsCrucifiedMan") && !this.TempFlags.get("IsCrucifiedManShown") && this.World.State.getPlayer().getTile().HasRoad && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 1)
				{
					this.TempFlags.set("IsCrucifiedManShown", true);
					this.Contract.setScreen("CrucifiedA");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsCrucifiedManWon"))
				{
					this.Flags.set("IsCrucifiedManWon", false);

					if (this.Math.rand(1, 100) <= 50)
					{
						this.Contract.setScreen("CrucifiedE_AftermathGood");
					}
					else
					{
						this.Contract.setScreen("CrucifiedE_AftermathBad");
					}

					this.World.Contracts.showActiveContract();
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				this.Contract.addKillCount(_actor, _killer);
			}

			function onCombatVictory( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);

				if (_combatID == "CrucifiedMan")
				{
					this.Flags.set("IsCrucifiedManWon", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% wskazuje sztywno na jedno z krzeseł. Siadasz.%SPEECH_ON%W tej okolicy nie jest bezpiecznie. Kupcy skarżą się na zbójów i inne zagrożenia na trakcie.%SPEECH_OFF%Spogląda w dół, masując skronie.%SPEECH_ON%Ponieważ wszyscy moi ludzie są zajęci, potrzebuję, byś patrolował okolicę. Udaj się do %location1%, następnie do %location2%, a potem wróć tu w ciągu %days% dni. Jeśli natkniesz się na zagrożenia, zajmij się nimi. Nie będę ci płacił za spacer po lesie, najemniku. Zapłata będzie za każdą głowę, którą mi przyniesiesz.%SPEECH_OFF% | %employer% pochyla się nad mapą, jego oczy biegają jak u jastrzębia nad polem ruchliwych myszy. Nie potrafi się skupić.%SPEECH_ON%Wszędzie, tam są moi ludzie. Tu. Tam. Tam dalej. Ten fragment mapy? Nawet nie ma nazwy, a oni też tam są. Gdzie ich nie ma, to tutaj i tutaj. I tu wkraczasz ty, najemniku.%SPEECH_OFF%Przerywa, by na ciebie spojrzeć.%SPEECH_ON%Potrzebuję, żebyś patrolował tereny do %location1%, a potem do %location2%. Zabij wszystko i wszystkich, którzy sądzą, że droga należy do nich. Na pewno wiesz, o kogo chodzi. Ale nie płacę ci za spacer, najemniku. Przynieś mi każdą głowę, którą zbierzesz w ciągu %days% dni, a zapłacę za każdą.%SPEECH_OFF% | %employer% bierze łyk wina i beka. Wygląda na poirytowanego.%SPEECH_ON%Nie zwykłem zlecać najemnikom patroli, ale większość moich ludzi jest teraz zajęta gdzie indziej. To dość proste zadanie: idź do %location1%, potem do %location2%, a następnie wróć tu w ciągu %days% dni. Po drodze zabij każdego człowieka lub bestię, która zagraża ludziom tych ziem. Tylko pamiętaj o głowach: będę płacił za trofea, a nie za to, ile mil przeszedłeś.%SPEECH_OFF% | %employer% uśmiecha się chytrze.%SPEECH_ON%Co powiesz na zadanie, w którym nie płacę tylko za samo wykonanie, ale za liczbę zebranych głów? Brzmi interesująco? Bo teraz potrzebuję patroli na ziemiach do %location1% i %location2%. Przechodzisz się, tu i tam coś zabijasz, a potem wracasz do mnie w ciągu %days% dni z tymi głowami, które zbierzesz.\n\nZa każdą zapłacę. Daj znać, co o tym myślisz.%SPEECH_OFF% | %employer% kładzie palec na mapie.%SPEECH_ON%Musisz iść tutaj.%SPEECH_OFF%Przesuwa palec do innego miejsca.%SPEECH_ON%A potem tutaj. Jeden długi patrol. Zabij wszystko, co uważa, że drogi należą do niego, jeśli nie nosi imienia rodu %noblehousename%. Tylko pamiętaj o głowach. Nie będę ci płacił za urlop. Zapłacę ci za każde trofeum, które przyniesiesz po powrocie w ciągu %days% dni.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "O jakiej kwocie mówimy?",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "Zbyt dużo łażenia jak dla mnie.",
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
			ID = "CrucifiedA",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_02.png[/img]%randombrother% wraca do ciebie z raportem zwiadowczym.%SPEECH_ON%Spalone osady. Trup przecięty w pół na brzuchu. Brak nóg. Jego pies po prostu leżał. Nie chciał odejść. Nie dało się go odciągnąć. Znalazłem martwego osła na drzewach. Ten ryczący koniec miał wbitą włócznię.%SPEECH_OFF%Przerywa, myśli, po czym pstryka palcami.%SPEECH_ON%O! Prawie zapomniałem. Za tamtym wzgórzem, po drugiej stronie, jest ukrzyżowany człowiek. Żył. Krzyczał jak opętany, ale trzymałem się z dala. Cudzy ból to ryzykowna sprawa.%SPEECH_OFF%",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Tak. Obejrzyjmy tego ukrzyżowanego gościa.",
					function getResult()
					{
						return "CrucifiedB";
					}

				},
				{
					Text = "Nic wartego uwagi. Dobry raport.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Flags.set("IsCrucifiedMan", false);
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedB",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_02.png[/img]Postanawiasz zejść i zobaczyć ukrzyżowanego.\n\n Wspinasz się na pobliskie wzniesienie i spoglądasz w dół. Jest dokładnie tak, jak mówił najemnik. Na końcu stoku wisi ukrzyżowany człowiek. Zwisa bezwładnie, choć nawet stąd słychać jego od czasu do czasu krzyk. %randombrother% pyta, co robić.",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Odetnijmy go.",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 50 && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
						{
							return "CrucifiedC";
						}
						else
						{
							return "CrucifiedD";
						}
					}

				},
				{
					Text = "To oczywista pułapka. Zaczekajmy.",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "CrucifiedE";
						}
						else
						{
							return "CrucifiedF";
						}
					}

				},
				{
					Text = "Odejdźmy. Coś mi tu śmierdzi.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedC",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_02.png[/img]Nie jesteś pewien, czy zasnąłbyś w nocy, wiedząc, że zostawiłeś tego biedaka na taki los. Ty i kompania schodzicie ze zbocza. To nie jest szczególnie szybka akcja, bo wciąż obawiasz się zasadzki, ale nic się nie wydarza. Ukrzyżowany uśmiecha się, gdy podchodzisz.%SPEECH_ON%Zdejmijcie mnie, a będę walczył dla ciebie do końca moich dni, przysięgam!%SPEECH_OFF%Najemnicy podważają gwoździe bronią i wyrywają mężczyznę. Zsuwa się po drewnianym słupie w ramiona kilku towarzyszy, którzy ostrożnie kładą go na ziemi. Między łykami wody mówi.%SPEECH_ON%Zielonoskórzy mi to zrobili. Byłem ostatnim z mojej wioski i chyba chcieli się trochę zabawić, zamiast po prostu wbić mi topór w twarz. Zacząłem wolić to drugie, dopóki się nie pojawiłeś. Nie jestem w najlepszej formie, panie, ale z czasem dojdę do siebie i przysięgam na moje nazwisko, którego jestem ostatnim, że będę dla ciebie walczył aż do śmierci albo ostatniego zwycięstwa!%SPEECH_OFF%",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Niewielu zdołałoby przeżyć takie okropieństwa. Witaj w kompanii.",
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
					Text = "W tej kompanii nie ma dla ciebie miejsca.",
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
				this.Contract.m.Dude.setStartValuesEx(this.Const.CharacterVillageBackgrounds);
				this.Contract.m.Dude.getBackground().m.RawDescription = "%name% został przez ciebie ściągnięty z krzyża w porę, inaczej dokonałby na nim żywota. Ślubował ci posłuszeństwo do końca swoich dni, lub do ostatniego twego zwycięstwa.";
				this.Contract.m.Dude.getBackground().buildDescription(true);
				this.Contract.m.Dude.getSkills().removeByID("trait.disloyal");
				this.Contract.m.Dude.getSkills().add(this.new("scripts/skills/traits/loyal_trait"));
				this.Contract.m.Dude.setHitpoints(1);

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

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedD",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_67.png[/img]Spanie w nocy byłoby trochę trudniejsze, gdybyś zostawił tego biedaka. Prowadzisz kompanię w dół zbocza, częściowo by go ocalić i ocalić własne sumienie. Ukrzyżowany zaczyna się uśmiechać, gdy podchodzisz.%SPEECH_ON%Dziękuję, nieznajomy! Dziękuję, dziękuję, dzie--%SPEECH_OFF%Ucinasz mu to odgłosem obrzydliwego 'tępa', gdy oszczep przebija mu pierś i wbija się w drewniane deski, do których był przybity. Odwracasz się i widzisz zielonoskórych wyskakujących z pobliskich krzaków. Do diabła, to była pułapka! Do broni!",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.GoblinsTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.EnemyBanners = [
							"banner_goblins_03"
						];
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.GreenskinHorde, this.Math.rand(90, 110), this.Const.Faction.Enemy);
						this.World.Contracts.startScriptedCombat(properties, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedE",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_07.png[/img]Postanawiasz przeczekać. Gdy siedzisz i słuchasz, jak wycie umierającego powoli cichnie, %randombrother% chwyta cię za ramię i wskazuje nieco dalej. W stronę ukrzyżowanego idą jacyś bandyci. Dochodzą, rozmawiają przez chwilę. Jeden wyciąga sztylet i zaczyna dźgać koniuszki palców u nóg umierającego. Jego jęki nie są już ciche. Jeden z bandytów odwraca się, śmiejąc. Zastyga. Coś mówi. Wskazuje. Zauważyli was! Zanim sukinsyny zdążą się ustawić, rozkazujesz %companyname% do szarży!",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "CrucifiedMan";
						properties.Music = this.Const.Music.GoblinsTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.EnemyBanners = [
							"banner_bandits_03"
						];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.BanditRaiders, this.Math.rand(90, 110), this.Const.Faction.Enemy);
						this.World.Contracts.startScriptedCombat(properties, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedE_AftermathGood",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_22.png[/img]Ku zaskoczeniu wszystkich, ukrzyżowany wciąż żyje po bitwie. Woła do ciebie chrapliwym głosem, z którego nie da się wyłowić słów, ale brzmi jak proste 'pomóż'. Każesz braciom go ściąć. Traci przytomność, gdy tylko dotyka ziemi, po czym budzi się gwałtownie i chwyta cię za dłoń.%SPEECH_ON%Dziękuję, nieznajomy. Dziękuję ci bardzo. Orkowie... przyszli... a potem bandyci, żeby ograbić resztki... ale ty, ty jesteś inny. Dziękuję! Nie mam już na tym świecie nic poza walką z tymi, którzy zabrali mi wszystko. Jestem %crucifiedman%, ostatni z mojego rodu, i jeśli dasz mi ten zaszczyt, przysięgam ci mój miecz aż do dnia mojej śmierci albo twojego ostatniego zwycięstwa.%SPEECH_OFF%",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Niewielu zdołałoby przeżyć takie okropieństwa. Witaj w kompanii.",
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
					Text = "W tej kompanii nie ma dla ciebie miejsca.",
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
				this.Contract.m.Dude.setStartValuesEx(this.Const.CharacterVillageBackgrounds);
				this.Contract.m.Dude.getBackground().m.RawDescription = "%name% został przez ciebie ściągnięty z krzyża w porę, inaczej dokonałby na nim żywota. Ślubował ci posłuszeństwo do końca swoich dni, lub do ostatniego twego zwycięstwa.";
				this.Contract.m.Dude.getBackground().buildDescription(true);
				this.Contract.m.Dude.getSkills().removeByID("trait.disloyal");
				this.Contract.m.Dude.getSkills().add(this.new("scripts/skills/traits/loyal_trait"));
				this.Contract.m.Dude.setHitpoints(1);

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

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedE_AftermathBad",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_22.png[/img]Po rozprawieniu się z bandytami idziesz sprawdzić, czy ukrzyżowany żyje. Nie przeżył. Nie mając nic wartościowego przy ciele, plądrujesz bandytów i ruszasz z %companyname% z powrotem na trakt.",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Spoczywaj w pokoju.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedF",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_02.png[/img]Postanawiasz przeczekać. Umierający dalej umiera. Jego krzyki robią się trochę cichsze, co jest lepsze dla uszu, ale gorsze dla dusz ludzi. Po chwili %randombrother% podchodzi i sugeruje, by kompania zeszła na dół. Szansa, że ktoś wciąż czeka w zasadzce, jest teraz znikoma. Ty i kompania truchtem schodzicie ze zbocza i docieracie do ukrzyżowanego. Jego broda opada na pierś, oczy półprzymknięte, z ust spływa piana śliny i krwi. Nie ma przy nim nic, co warto zabrać, więc każesz %companyname% wracać na trakt.",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Spoczywaj w pokoju.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-1);
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isOffendedByViolence() && !bro.getBackground().isCombatBackground())
					{
						bro.worsenMood(0.5, "Pozwoliłeś ukrzyżowanemu umrzeć powolną śmiercią");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "%location1%...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{Docierasz do %location1% i każesz ludziom zrobić przerwę. Gdy odpoczywają, liczysz zapasy i upewniasz się, że wszystko w porządku. Wkrótce znowu ruszacie. | Zatrzymując się w %location1%, po pierwszym etapie patrolu, każesz ludziom chwilę odpocząć. Przed wami jeszcze droga, więc uznajesz, że to dobry moment na uzupełnienie zapasów. | Pierwszy etap patrolu zakończony. Teraz trzeba ruszyć dalej. Informujesz o tym ludzi, a oni jęczą. Dodajesz, że nie płacisz im za narzekanie, na co jęczą jeszcze głośniej. | Docierasz do pierwszego punktu patrolu i każesz ludziom zrobić krótką przerwę, podczas gdy liczysz zapasy. Patrol jest dopiero w jednej trzeciej ukończony. Zastanawiasz się, czy nie uzupełnić sprzętu przed dalszą drogą. | Docierasz do %location1% bezpiecznie i w większości w jednym kawałku.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Ruszamy dalej.",
					function getResult()
					{
						this.Contract.setState("Location2");
						return 0;
					}

				}
			],
			function start()
			{
				if (this.Math.rand(1, 100) <= 33)
				{
					this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/safe_roads_situation"), 2, this.Contract.m.Location1, this.List);
				}
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "%location2%...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{%location2% jest dokładnie tam, gdzie miało być. Pozwalasz ludziom odpocząć, a sam planujesz ostatni etap patrolu. | Patrol prowadzi do %location2%, które wita cię tym samym zrzędzeniem i podejrzliwością, z jaką wszędzie traktuje się najemników. Przed wami jeszcze jeden etap, więc warto tu zebrać zapasy. | Ludzie rozchodzą się po karczmach %location2%. Ty sprawdzasz zapasy i zastanawiasz się, czy nie uzupełnić prowiantu. Zerkając na przygasłe światła gospody, myślisz też, że szybki łyk nie zaszkodzi. | Po dotarciu do %location2% %randombrother% sugeruje, że kompania powinna zabrać zapasy na drogę powrotną do %employer%. Już o tym myślałeś, ale pozwalasz najemnikowi cieszyć się, że sam wpadł na pomysł.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Ruszamy dalej.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				if (this.Math.rand(1, 100) <= 33)
				{
					this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/safe_roads_situation"), 2, this.Contract.m.Location2, this.List);
				}
			}

		});
		this.m.Screens.push({
			ID = "Success3",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{Twój powrót do %employer% wzbudza ciekawość. Liczy korony, ale zanim da ci choć jedną, pyta, ile 'głów' zebrałeś w drodze. Po zgłoszeniu %killcount% zabitych zaciska usta i kiwa głową.%SPEECH_ON%Wystarczy.%SPEECH_OFF%Mężczyzna wsypuje trochę koron do mieszka i podaje go. | Wracając do %employer%, zastajesz go głęboko zapadniętego w ogromny fotel, jakby potrzebował tyle miejsca, by utrzymać swoją szlachetność, przepych i dumę.\n\nOpowiadasz o patrolu, o tym, że po drodze zabiłeś %killcount%. Kładziesz nacisk na zabitych, bo za to ci płacą. %employer% kiwa głową i każe jednemu ze swoich ludzi wrzucić korony do mieszka i podać go. | %employer% stoi przy oknie, popijając wino i zerkając na kilka kobiet pracujących w ogrodzie poniżej. Nie odwracając się do ciebie, pyta, ilu zabiłeś podczas wędrówki.%SPEECH_ON%%killcount%.%SPEECH_OFF%Szlachcic chichocze.%SPEECH_ON%Mówisz o tym, jakby to było nic.%SPEECH_OFF%Znów nie spoglądając, pstryka palcami. Z boku pojawia się człowiek z mieszkiem. Bierzesz go i odchodzisz. | %employer% czyta zwoje papierów, gdy cię wita. Jest ciekaw, ile zabitych masz na patrolu. Podajesz %killcount%, na co mruczy i robi małą notatkę na jednym z arkuszy. Kiwając głową, kopie skrzynię obok i zaczyna nabierać do mieszka korony. Podaje go, a potem, nawet na ciebie nie spoglądając, każe ci wyjść. | U %employer% trwa przyjęcie. Przepychasz się przez pijany tłum, by dotrzeć do mężczyzny. Przekrzykuje muzykę i hałas, pytając, ilu zdjąłeś na patrolu. To dziwne, ale krzyk, że zabiłeś %killcount%, nie robi wrażenia na biesiadnikach. Wzruszając ramionami, %employer% odwraca się i znika w tłumie gości. Próbujesz go dogonić, ale ktoś zastępuje ci drogę, wpychając ci mieszek w pierś.%SPEECH_ON%Twoja zapłata, najemniku. A teraz, proszę, do wyjścia. Ludzie zaczynają cię zauważać, a nie przyszli tu po to, by czuć się nieswojo.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Wystarczy marszu na dziś.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.Assets.addMoney(this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected"));
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Patrolowałeś królestwo");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local money = this.Contract.m.Payment.getOnCompletion() + this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected");
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] koron"
				});

				if (this.Math.rand(1, 100) <= 33)
				{
					this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/safe_roads_situation"), 2, this.Contract.m.Home, this.List);
				}
			}

		});
		this.m.Screens.push({
			ID = "Success4",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{Wracasz do %employer% z pustymi rękami. Mierzy cię wzrokiem, wyraźnie zwracając uwagę na brak skalpów.%SPEECH_ON%Naprawdę? Żadnych kłopotów?%SPEECH_OFF%Nie ruszasz się. Mężczyzna zaciska usta i wzrusza ramionami.%SPEECH_ON%No dobra, cóż...%SPEECH_OFF%Patrzy na ciebie i prawie krztusi się chichotem.%SPEECH_ON%Ciekawe, chyba.%SPEECH_OFF% | %employer% mierzy cię od stóp do głów.%SPEECH_ON%Gdzie są głowy, najemniku? Chyba nie zapomniałeś ich zebrać...?%SPEECH_OFF%Wyjaśniasz, że na patrolu nie natknęliście się na nic. Mężczyzna unosi brew.%SPEECH_ON%Naprawdę? No cóż... dobra... żegnaj.%SPEECH_OFF% | Wracasz do %employer% z pustymi rękami. Wpatruje się w brak... towaru.%SPEECH_ON%Co to ma być? Gdzie są głowy, za które miałem ci zapłacić?%SPEECH_OFF%Wzruszasz ramionami, wyjaśniając, że na patrolu nie było kłopotów. %employer% bierze łyk wina i prawie się nim krztusi na te słowa.%SPEECH_ON%Chwila, naprawdę? To znaczy, chyba dobrze, ale do diabła... nie spodziewałem się tego. Ja, uh, pewnie ty też nie.%SPEECH_OFF%Patrzycie na siebie. Ptak grucha, by wypełnić ciszę. Mężczyzna pije wino i zerka przez okno.%SPEECH_ON%No... ciekawa dziś pogoda, co?%SPEECH_OFF%Przewracasz oczami.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Dość marszu na dziś.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnVictory);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractPoor, "Patrolowałeś królestwo");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				if (this.Contract.m.Payment.getOnCompletion() > 0)
				{
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] koron"
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{Zbyt długo zajęło ci ukończenie patrolu, do którego zostałeś zatrudniony. Uznaj kontrakt za nieudany. | Człowiek na służbie u %employer% podchodzi z zawiadomieniem. Stwierdza, że patrol miał być szybki, a nie wesoły spacerek dla ciebie. Uznaj kontrakt za nieudany. | Co próbowałeś zrobić, zebrać jak najwięcej głów? Wątpliwe, by twój pracodawca, %employer%, kupił taką wymówkę. Jest powód, dla którego dał ci tylko kilka dni na wykonanie zadania. Uznaj to za porażkę.}",
			Image = "",
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Niech szlag trafi ten kontrakt!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Zabłądziłeś gdzieś, gdy miałeś patrolować");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function addKillCount( _actor, _killer )
	{
		if (_killer != null && _killer.getFaction() != this.Const.Faction.Player && _killer.getFaction() != this.Const.Faction.PlayerAnimals)
		{
			return;
		}

		if (this.m.Flags.get("HeadsCollected") >= this.m.Payment.MaxCount)
		{
			return;
		}

		if (_actor.getXPValue() == 0)
		{
			return;
		}

		if (_actor.getType() == this.Const.EntityType.GoblinWolfrider || _actor.getType() == this.Const.EntityType.Wardog || _actor.getType() == this.Const.EntityType.Warhound || _actor.getType() == this.Const.EntityType.SpiderEggs || this.isKindOf(_actor, "lindwurm_tail"))
		{
			return;
		}

		if (!_actor.isAlliedWithPlayer() && !_actor.isAlliedWith(this.m.Faction) && !_actor.isResurrected())
		{
			this.m.Flags.set("HeadsCollected", this.m.Flags.get("HeadsCollected") + 1);
		}
	}

	function spawnEnemies()
	{
		if (this.m.Flags.get("HeadsCollected") >= this.m.Payment.MaxCount)
		{
			return false;
		}

		local tries = 0;
		local myTile = this.m.NextObjective.getTile();
		local tile;

		while (tries++ < 10)
		{
			local tile = this.getTileToSpawnLocation(myTile, 7, 11);

			if (tile.getDistanceTo(this.World.State.getPlayer().getTile()) <= 6)
			{
				continue;
			}

			local nearest_bandits = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getNearestSettlement(tile);
			local nearest_goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(tile);
			local nearest_orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(tile);
			local nearest_barbarians = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians) != null ? this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getNearestSettlement(tile) : null;
			local nearest_nomads = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits) != null ? this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getNearestSettlement(tile) : null;

			if (nearest_bandits == null && nearest_goblins == null && nearest_orcs == null && nearest_barbarians == null && nearest_nomads == null)
			{
				this.logInfo("no enemy base found");
				return false;
			}

			local bandits_dist = nearest_bandits != null ? nearest_bandits.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local goblins_dist = nearest_goblins != null ? nearest_goblins.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local orcs_dist = nearest_orcs != null ? nearest_orcs.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local barbarians_dist = nearest_barbarians != null ? nearest_barbarians.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local nomads_dist = nearest_nomads != null ? nearest_nomads.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local party;
			local origin;

			if (bandits_dist <= goblins_dist && bandits_dist <= orcs_dist && bandits_dist <= barbarians_dist && bandits_dist <= nomads_dist)
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).spawnEntity(tile, "Bandyci", false, this.Const.World.Spawn.BanditRaiders, 110 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).spawnEntity(tile, "Bandyci Myτliwi", false, this.Const.World.Spawn.BanditRoamers, 80 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
				}

				party.setDescription("Banda zatwardziałych zbirów żerująca na słabszych.");
				party.setFootprintType(this.Const.World.FootprintsType.Brigands);
				party.getLoot().Money = this.Math.rand(50, 100);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 2);
				party.getLoot().Ammo = this.Math.rand(0, 20);
				local r = this.Math.rand(1, 6);

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
				else if (r == 5)
				{
					party.addToInventory("supplies/pickled_mushrooms_item");
				}

				origin = nearest_bandits;
			}
			else if (goblins_dist <= bandits_dist && goblins_dist <= orcs_dist && goblins_dist <= barbarians_dist && goblins_dist <= nomads_dist)
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).spawnEntity(tile, "Goblińscy NajeЄdЄcy", false, this.Const.World.Spawn.GoblinRaiders, 110 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).spawnEntity(tile, "Goblińscy Zwiadowcy", false, this.Const.World.Spawn.GoblinScouts, 80 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
				}

				party.setDescription("Banda złośliwych goblinów, małych, acz przebiegłych i których nigdy nie można lekceważyć");
				party.setFootprintType(this.Const.World.FootprintsType.Goblins);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 2);
				party.getLoot().Ammo = this.Math.rand(0, 30);

				if (this.Math.rand(1, 100) <= 75)
				{
					local loot = [
						"supplies/strange_meat_item",
						"supplies/roots_and_berries_item",
						"supplies/pickled_mushrooms_item"
					];
					party.addToInventory(loot[this.Math.rand(0, loot.len() - 1)]);
				}

				if (this.Math.rand(1, 100) <= 33)
				{
					local loot = [
						"loot/goblin_carved_ivory_iconographs_item",
						"loot/goblin_minted_coins_item",
						"loot/goblin_rank_insignia_item"
					];
					party.addToInventory(loot[this.Math.rand(0, loot.len() - 1)]);
				}

				origin = nearest_goblins;
			}
			else if (barbarians_dist <= goblins_dist && barbarians_dist <= bandits_dist && barbarians_dist <= orcs_dist && barbarians_dist <= nomads_dist)
			{
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).spawnEntity(tile, "Barbarzyńcy", false, this.Const.World.Spawn.Barbarians, 110 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
				party.setDescription("Wojenny oddział barbarzyńskich współplemieńców.");
				party.setFootprintType(this.Const.World.FootprintsType.Barbarians);
				party.getLoot().Money = this.Math.rand(0, 50);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 5);
				party.getLoot().Ammo = this.Math.rand(0, 30);

				if (this.Math.rand(1, 100) <= 50)
				{
					party.addToInventory("loot/bone_figurines_item");
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					party.addToInventory("loot/bead_necklace_item");
				}

				local r = this.Math.rand(2, 5);

				if (r == 2)
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
				else if (r == 5)
				{
					party.addToInventory("supplies/pickled_mushrooms_item");
				}

				origin = nearest_barbarians;
			}
			else if (nomads_dist <= barbarians_dist && nomads_dist <= goblins_dist && nomads_dist <= bandits_dist && nomads_dist <= orcs_dist)
			{
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).spawnEntity(tile, "Koczownicy", false, this.Const.World.Spawn.NomadRaiders, 110 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
				party.setDescription("Grupa pustynnych najeźdźców żerujących na każdym, kto ośmieli się przekroczyć morza piasków.");
				party.setFootprintType(this.Const.World.FootprintsType.Nomads);
				party.getLoot().Money = this.Math.rand(50, 200);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 2);
				party.getLoot().Ammo = this.Math.rand(0, 20);
				local r = this.Math.rand(1, 4);

				if (r == 1)
				{
					party.addToInventory("supplies/bread_item");
				}
				else if (r == 2)
				{
					party.addToInventory("supplies/dates_item");
				}
				else if (r == 3)
				{
					party.addToInventory("supplies/rice_item");
				}
				else if (r == 4)
				{
					party.addToInventory("supplies/dried_lamb_item");
				}

				origin = nearest_nomads;
			}
			else
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).spawnEntity(tile, "Orkowie Maruderzy", false, this.Const.World.Spawn.OrcRaiders, 110 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).spawnEntity(tile, "Orkowie Zwiadowcy", false, this.Const.World.Spawn.OrcScouts, 80 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
				}

				party.setDescription("Banda złowrogich orków, zielonoskórych i górujących nad każdym człowiekiem.");
				party.setFootprintType(this.Const.World.FootprintsType.Orcs);
				party.getLoot().ArmorParts = this.Math.rand(0, 25);
				party.getLoot().Ammo = this.Math.rand(0, 10);
				party.addToInventory("supplies/strange_meat_item");
				origin = nearest_orcs;
			}

			party.getSprite("banner").setBrush(origin.getBanner());
			party.setAttackableByAI(false);
			party.setAlwaysAttackPlayer(true);
			local c = party.getController();
			local intercept = this.new("scripts/ai/world/orders/intercept_order");
			intercept.setTarget(this.World.State.getPlayer());
			c.addOrder(intercept);
			this.m.UnitsSpawned.push(party.getID());
			return true;
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"location1",
			this.m.Location1.getName()
		]);
		_vars.push([
			"location2",
			this.m.Location2.getName()
		]);
		_vars.push([
			"killcount",
			this.m.Flags.get("HeadsCollected")
		]);
		_vars.push([
			"noblehousename",
			this.World.FactionManager.getFaction(this.m.Faction).getNameOnly()
		]);
		_vars.push([
			"days",
			5 - (this.World.getTime().Days - this.m.Flags.get("StartDay"))
		]);
		_vars.push([
			"crucifiedman",
			this.m.Dude != null ? this.m.Dude.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Location1 != null)
			{
				this.m.Location1.getSprite("selection").Visible = false;
			}

			if (this.m.Location2 != null)
			{
				this.m.Location2.getSprite("selection").Visible = false;
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (this.m.IsStarted)
		{
			if (this.m.Location1 == null || this.m.Location1.isNull() || !this.m.Location1.isAlive())
			{
				return false;
			}

			if (this.m.Location2 == null || this.m.Location2.isNull() || !this.m.Location2.isAlive())
			{
				return false;
			}

			return true;
		}
		else
		{
			if (this.World.FactionManager.getFaction(this.m.Faction).getSettlements().len() < 3)
			{
				return false;
			}

			return true;
		}
	}

	function onIsTileUsed( _tile )
	{
		if (this.m.Location1 != null && !this.m.Location1.isNull() && _tile.ID == this.m.Location1.getTile().ID)
		{
			return true;
		}

		if (this.m.Location2 != null && !this.m.Location2.isNull() && _tile.ID == this.m.Location2.getTile().ID)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		if (this.m.Location1 != null)
		{
			_out.writeU32(this.m.Location1.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.Location2 != null)
		{
			_out.writeU32(this.m.Location2.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local location1 = _in.readU32();

		if (location1 != 0)
		{
			this.m.Location1 = this.WeakTableRef(this.World.getEntityByID(location1));
		}

		local location2 = _in.readU32();

		if (location2 != 0)
		{
			this.m.Location2 = this.WeakTableRef(this.World.getEntityByID(location2));
		}

		this.contract.onDeserialize(_in);
	}

});

