this.hold_chokepoint_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Target = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hold_chokepoint";
		this.m.Name = "Utrzymanie Twierdzy";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local enemies = [];

		foreach( n in nobles )
		{
			if (n.getFlags().get("IsHolyWarParticipant"))
			{
				enemies.push(n);
			}
		}

		this.m.Flags.set("EnemyID", enemies[this.Math.rand(0, enemies.len() - 1)].getID());
		local locations = this.World.EntityManager.getLocations();
		local candidates = [];

		foreach( v in locations )
		{
			if (v.getTypeID() == "location.abandoned_fortress")
			{
				candidates.push(v);
			}
		}

		local closest;
		local closest_dist = 9000;

		foreach( c in candidates )
		{
			local d = this.m.Home.getTile().getDistanceTo(c.getTile()) + this.Math.rand(0, 5);

			if (d < closest_dist)
			{
				closest = c;
				closest_dist = d;
			}
		}

		this.m.Destination = this.WeakTableRef(closest);
		this.m.Payment.Pool = 1400 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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

		this.m.Flags.set("Wave", 0);
		this.m.Flags.set("WavesDefeated", 0);
		this.m.Flags.set("WaitUntil", 0.0);
		this.m.Flags.set("MapSeed", this.Time.getRealTime());
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Udaj się do opuszczonej twierdzy i obroń ją przed napadami ludzi z północy"
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 20)
				{
					if (this.Contract.getDifficultyMult() <= 1.05)
					{
						this.Flags.set("IsEnemyRetreating", true);
					}
				}

				if (r <= 40)
				{
					this.Flags.set("IsReinforcements", true);
				}
				else if (r <= 70)
				{
					this.Flags.set("IsUltimatum", true);
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
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Destination))
				{
					this.Contract.setScreen("Arrive");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Running_Defend",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Użyj opuszczonej fortecy, aby obronić się przed ludźmi z północy",
					"Nie odchodź zbyt daleko"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Flags.get("IsFailure") || !this.Contract.isPlayerNear(this.Contract.m.Destination, 600))
				{
					this.Contract.setScreen("Failure");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Flags.get("Wave") > this.Flags.get("WavesDefeated") && (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive()))
				{
					this.Flags.increment("WavesDefeated", 1);
					this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(3, 6));

					if (this.Flags.get("WavesDefeated") == 1)
					{
						this.Contract.setScreen("Waiting1");
					}
					else if (this.Flags.get("WavesDefeated") == 2)
					{
						this.Contract.setScreen("Waiting2");
					}
					else if (this.Flags.get("WavesDefeated") == 3)
					{
						this.Contract.setScreen("Victory");
					}

					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("WaitUntil") > 0 && this.Time.getVirtualTimeF() >= this.Flags.get("WaitUntil"))
				{
					this.Flags.set("WaitUntil", 0.0);
					this.Flags.set("IsWaveShown", false);

					if (this.Flags.getAsInt("Wave") == 2 && this.Flags.get("IsEnemyRetreating"))
					{
						this.Contract.setScreen("EnemyRetreats");
						this.World.Contracts.showActiveContract();
						return;
					}
					else if (this.Flags.getAsInt("Wave") == 2 && this.Flags.get("IsUltimatum"))
					{
						this.Contract.setScreen("Ultimatum1");
						this.World.Contracts.showActiveContract();
						return;
					}
					else
					{
						this.Flags.increment("Wave", 1);
						local enemyNobleHouse = this.World.FactionManager.getFaction(this.Flags.get("EnemyID"));
						local candidates = [];

						foreach( s in enemyNobleHouse.getSettlements() )
						{
							if (s.isMilitary())
							{
								candidates.push(s);
							}
						}

						local mapSize = this.World.getMapSize();
						local o = this.Contract.m.Destination.getTile().SquareCoords;
						local tiles = [];

						for( local x = o.X - 3; x < o.X + 3; x = x )
						{
							for( local y = o.Y + 3; y <= o.Y + 6; y = y )
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
						local party = enemyNobleHouse.spawnEntity(tiles[0].Tile, "Kompania " + candidates[this.Math.rand(0, candidates.len() - 1)].getName(), true, this.Const.World.Spawn.Noble, (this.Math.rand(100, 120) + this.Flags.get("Wave") * 10 + (this.Flags.get("IsAlliedReinforcements") ? 50 : 0)) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
						party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + enemyNobleHouse.getBannerString());
						party.setDescription("Profesjonalni żołdacy na usługach miejscowych lordów.");
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
						local attack = this.new("scripts/ai/world/orders/attack_zone_order");
						attack.setTargetTile(this.Contract.m.Destination.getTile());
						c.addOrder(attack);
						local move = this.new("scripts/ai/world/orders/move_order");
						move.setDestination(this.Contract.m.Destination.getTile());
						c.addOrder(move);
						local guard = this.new("scripts/ai/world/orders/guard_order");
						guard.setTarget(this.Contract.m.Destination.getTile());
						guard.setTime(240.0);
						c.addOrder(guard);
						party.setAttackableByAI(false);
						party.setAlwaysAttackPlayer(true);
						party.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
						this.Contract.m.Target = this.WeakTableRef(party);
					}
				}
			}

			function onDestinationAttacked( _dest, _isPlayerInitiated )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerInitiated;

				if (!this.Flags.get("IsWaveShown"))
				{
					this.Flags.set("IsWaveShown", true);

					if (this.Flags.getAsInt("Wave") == 3 && this.Flags.get("IsReinforcements"))
					{
						this.Contract.setScreen("Reinforcements");
					}
					else
					{
						this.Contract.setScreen("Wave" + this.Flags.get("Wave"));
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "HoldChokepoint";
					p.Music = this.Const.Music.NobleTracks;

					if (this.Contract.isPlayerAt(this.Contract.m.Destination))
					{
						_isPlayerInitiated = false;
						p.MapSeed = this.Flags.getAsInt("MapSeed");
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.OwnedByFaction = this.Const.Faction.Player;
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.LocationTemplate.ShiftX = -4;

						if (this.Flags.get("IsAlliedReinforcements"))
						{
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
							p.AllyBanners.push(this.World.FactionManager.getFaction(this.Contract.getFaction()).getPartyBanner());
						}
					}

					this.World.Contracts.startScriptedCombat(p, _isPlayerInitiated, true, true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "HoldChokepoint")
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
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.getAsInt("WavesDefeated") <= 2 && !this.Flags.get("IsEnemyRetreating"))
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
			Text = "[img]gfx/ui/events/event_162.png[/img]{%employer% jest otoczony przez swoich wojaków. Noszą wiele pompatycznych strojów, które sprawiają, że myślisz, iż wojna nie jest ich żywiołem. Mimo tego piórkowego wyglądu, jeden z dowódców odciąga cię na bok z mapą i mówi jasno.%SPEECH_ON%Koronniku, musisz udać się do opuszczonej twierdzy %direction% stąd. Mamy skrzydło żołnierzy maszerujących na miejsce, ale nie dotrą tam przed północnymi barbarzyńcami. Ze wszystkich w zasięgu ty jesteś najbliżej. Idź tam i broń, aż przybędą nasi żołnierze. Fortyfikacja jest zrujnowana, ale wierzę, że człowiek o twojej przebiegłej naturze poradzi sobie z odrobiną gruzu, jeśli będzie trzeba. %reward% koron będzie czekać po twoim powrocie, i po twoim sukcesie, oczywiście.%SPEECH_OFF% | %employer% siedzi na poduszce, a przed nim rozłożony jest ogromny dywan. Dobrze ubrani porucznicy siedzą po jego bokach, każdy uzbrojony w długi drewniany kij do przesuwania figur. Na końcu dywanu kilku tkaczy wciąż dodaje do mapy kolejne fragmenty - z tego, co widzisz, dodają północ. Wezyr dostrzega cię i mówi z oddali.%SPEECH_ON%Koronniku, %direction% stąd leży fort. Jest to upadła twierdza, podobno niewiele więcej niż rumowisko, ale starożytni zbudowali ją tam nie bez powodu: ma ogromne znaczenie strategiczne. Choć wysyłam żołnierzy na miejsce, nie dotrą tam przed oddziałem północnych. Nieczyści barbarzyńcy, a jednak trzeba szanować ich spryt w szybkim marszu. Potrzebuję więc, byś zajął fortecę i powstrzymał północnych, aż moje wojska tam dotrą.%SPEECH_OFF%Podnosi kartkę z liczbą, którą łatwo rozumiesz: %reward% koron. | Bardzo wysoki mężczyzna w wojskowym stroju zatrzymuje cię przed wejściem do pokoju %employer%a. Słychać, jak Wezyr miesza się wśród haremu, ale to nie twoja sprawa. Porucznik wciska ci zwój w pierś.%SPEECH_ON%Starożytni zbudowali twierdzę %direction% stąd. Od tamtego czasu popadła w ruinę, jak wszystko słabnie pod wpływem czasu, ale jej położenie wciąż jest strategiczne. Wysyłamy oddział żołnierzy na miejsce, ale nasi zwiadowcy donoszą, że północne psy znają jej znaczenie i dotrą tam przed nami. Tu wkraczasz ty. %reward% koron za przejęcie fortu i utrzymanie go do czasu nadejścia pomocy. Po odsieczy wrócisz do nas i otrzymasz uczciwą zapłatę koronników.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Nasza kompania może to zrobić. | Porozmawiajmy o tym, ile za to dostaniemy. | Możemy utrzymać twierdzę przed bezboznikami z północy.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{To nie jest tego warte. | Jesteśmy potrzebni gdzie indziej. | Nie zaryzykuję kompanii, by bronić jakichś ruin.}",
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
			ID = "Arrive",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_167.png[/img]{Forteca jest jednocześnie znajoma i niezwykła. Choć rozpadła się i osunęła w sterty gruzu, nie sposób nie poczuć w jej murach pewnej wielkości. Głębiej, wśród zrujnowanych zbrojowni i opuszczonych jadalni, widać pobieżne konstrukcje: pośpiesznie wzniesione umocnienia, ślady ostatnich obron daleko od miejsc, gdzie powinny się znajdować. Nie wiadomo, co tu się wydarzyło ani kiedy, ale na razie posłuży jako tymczasowy dom %companyname%.\n\nPodchodzisz do krenelażowych murów i spoglądasz w dal. Wygląda na to, że zdążyliście w samą porę: północni są już w drodze, linia sylwetek maszeruje tuż za horyzontem jak mrówki ku swojemu wzgórzu. | Forteca jako zagubiona pozostałość starożytnego imperium wydaje się właściwa: jej konstrukcje są równie znajome, co obce. Wiesz, do czego służą mury, ale nie jesteś pewien, co oznaczają symbole w nie wyryte. Nawet architektura niektórych pomieszczeń, sposób, w jaki narożniki przechodzą w niesamowite, ceglane wiry, nie przypomina niczego, co widziałeś. Nie wiesz, czy kryje się w tym przewaga taktyczna, czy też budowniczowie mieli inny zamiar.\n\nNie ma jednak czasu roztrząsać historii, jesteś tu tylko po to, by wykorzystać to miejsce jako wąskie gardło. A czas nadszedł: fala północnych przelewa się przez horyzont i pędzi prosto na was!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wszyscy, badźcie gotowi!",
					function getResult()
					{
						this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(5, 8));
						this.Contract.setState("Running_Defend");
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Wave1",
			Title = "Przed bitwą...",
			Text = "[img]gfx/ui/events/event_90.png[/img]{Nadciąga północna straż przednia. Biegniesz na mury i krzyczysz do %companyname%, by szykowali się do walki. Najemnicy natychmiast zajmują pozycje i przygotowują broń. W tym czasie coraz głośniej słychać zgrzyt i stukot północnych pancerzy, gdy się zbliżają. Pierwsza strzała bez szkody wpada do fortu, skromny znak, że lada chwila rozpocznie się brzydka bitwa.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Wave2",
			Title = "Przed bitwą...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{%randombrother% krzyczy i pędzisz na mury. Na polu stoi oddział ciężko uzbrojonych północnych. Być może dowiedzieli się, że to %companyname% stoi przed nimi i chcą podejść do sprawy odrobinę poważniej. Nie żeby dodatkowa ostrożność miała ich uratować. Jest tylko jeden możliwy wynik starcia z %companyname%, a ty nie możesz powstrzymać zapraszającego uśmiechu na widok zbliżającego się szturmu.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Wave3",
			Title = "Przed bitwą...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Północni nadchodzą po raz kolejny. Maszerują przez zwłoki jak leszcze przez solankę, ciemny splot ludzi i oręża, mrocznie zarysowany w krwawym błocie, w które zamieniłeś ziemię, po której ośmielili się przejść. Szczury już skubiące martwych rozbiegają się, a sępy wzbijają w powietrze. Podnosisz ramię i rozkazujesz ludziom przygotować się na to, miejmy nadzieję, ostatnie starcie.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Waiting1",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_167.png[/img]{Pierwszy atak został odparty. Przez chwilę rozważasz użycie zwłok do zatykania dziur w murach, ale nie masz ochoty zapraszać na pole szczurów i ich zarazy. Krótkim rozkazem każesz zrzucić ciała w stos poza murami, a potem przygotować ludzi do kolejnego szturmu.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Przygotować się na kolejny szturm!",
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
			ID = "Waiting2",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_167.png[/img]{%companyname% zaczyna wyglądać niemal jak ludzie, którymi byli, gdy pierwszy raz ich zatrudniłeś: przygnębieni i pobici przez świat. Ale cały ten czas w kompanii uczynił z nich lepszych ludzi. Mimo wyczerpania, szkolenie się nie męczy, prestiż się nie wyciera, a sława nie ciąży. Gdy nadejdzie czas, %companyname% będzie gotowe na kolejny szturm.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Może nadciagnąć ich więcej.",
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
			ID = "Failure",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_87.png[/img]{Widziałeś już dość. Wezyr zlecił kompanii utrzymać pozycję przez pewien czas, a nie siedzieć tu i popełniać zbiorowe samobójstwo.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nie warto dla tego tracić kompanii...",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Nie zdołałeś utrzymać fortyfikacji przed najeźdźcami z północy");
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
			ID = "EnemyRetreats",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_168.png[/img]{Gdy ciała piętrzą się, muchy bzyczą, a sępy krążą w powietrzu niczym wielkie czarne chmury, wygląda na to, że północni mają dość. Róg rozbrzmiewa pokonanym pobrzękiwaniem, a ludzie opuszczają broń i zawracają, skąd przyszli. W tym samym czasie z południa przybywa zwiadowca, mówiąc, że wojska %employer%a wkrótce dotrą. Wygląda na to, że możesz bezpiecznie wrócić do zleceniodawcy.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Udało nam się!",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.spawnAllies();
			}

		});
		this.m.Screens.push({
			ID = "Reinforcements",
			Title = "Przed bitwą...",
			Text = "[img]gfx/ui/events/event_164.png[/img]{Północni nadchodzą po raz kolejny. Maszerują przez zwłoki jak leszcze przez solankę, ciemny splot ludzi i oręża, mrocznie zarysowany w krwawym błocie, w które zamieniłeś ziemię, po której ośmielili się przejść. Gdy tylko podnosisz ręce, by wydać rozkaz, na horyzoncie pojawia się więcej ludzi. Serce na chwilę ci zamiera, aż dostrzegasz, że niosą barwy %employer%a! Ludzie Wezyra przybyli!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wreszcie jakaś pomoc!",
					function getResult()
					{
						this.Flags.set("IsAlliedReinforcements", true);
						this.Flags.set("IsReinforcements", false);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Ultimatum1",
			Title = "Gdy czekasz...",
			Text = "[img]gfx/ui/events/event_90.png[/img]{Przenikliwy róg przykuwa twoją uwagę. Wchodzisz na szczyt umocnień i spoglądasz w dół, by zobaczyć herolda niosącego barwy szlacheckie. Jest sam, ale jego głos brzmi jak cała kompania.%SPEECH_ON%Czyż łaskawy najemniku pragnie litości? Czyż łaskawy najemnik pragnie ujrzeć kolejny poranek, może jeszcze jedną zimę i wiosnę? Czyż łaskawy najemnik pragnie żyć, by jego...%SPEECH_OFF%Krzyczysz, by przeszedł do sedna. Mężczyzna odchrząkuje.%SPEECH_ON%Szlachta jest gotowa zawrzeć układ. Opuśćcie te ziemie natychmiast, a zostaniecie puszczeni bez pościgu. Nie tylko to: uznajemy, że wasza tablica jest z wosku, a odejście stąd stopi jej zapis. Wszelkie wrogości między %companyname% a Północą zostaną zaniechane na mocy północnego pisma. Oczywiście, tylko jeśli przyjmiecie ofertę.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Twoja propozycja jest rozsądna.",
					function getResult()
					{
						return "Ultimatum2";
					}

				},
				{
					Text = "Do diabła z wami i waszym woskiem!",
					function getResult()
					{
						return "Ultimatum3";
					}

				}
			],
			function start()
			{
				this.Flags.set("IsArrived", true);
			}

		});
		this.m.Screens.push({
			ID = "Ultimatum2",
			Title = "Gdy czekasz...",
			Text = "[img]gfx/ui/events/event_90.png[/img]{Przyjmujesz układ. Kilku ludzi narzeka, inni odczuwają ulgę, choć oznaki jednego i drugiego są starannie skrywane, by nie wzbudzić twoich podejrzeń. %companyname% \'prawnie\' opuszcza to miejsce, a północni przejmują kontrolę. Otrzymujesz szereg formalnych pism z podpisami najważniejszych osób, jakie dało się wydobyć od północnych rodów, wraz z ich pieczęciami. Zapewnią ci spokojną drogę przez ziemie północy, choć bez wątpienia zasłużyłeś na to, rezygnując z życzliwości na południu.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Tak będzie najlepiej dla kompanii.",
					function getResult()
					{
						local f = this.World.FactionManager.getFaction(this.Contract.getFaction());
						f.addPlayerRelation(-f.getPlayerRelation(), "Zmieniłeś strony w wojnie");
						f.getFlags().set("Betrayed", true);
						local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);

						foreach( n in nobles )
						{
							n.addPlayerRelationEx(50.0 - n.getPlayerRelation(), "Zmieniłeś strony w wojnie");
							n.makeSettlementsFriendlyToPlayer();
						}

						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
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
			ID = "Ultimatum3",
			Title = "Gdy czekasz...",
			Text = "[img]gfx/ui/events/event_90.png[/img]{Każesz heroldowi wrócić do swojego dowódcy. Kiwając głową, odpowiada.%SPEECH_ON%Niech twa wytrwałość zaimponuje starym bogom, bo nie zaimponuje potędze Północy.%SPEECH_OFF%Herold kłania się i odchodzi.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Przygotujcie się do kolejnego ataku.",
					function getResult()
					{
						this.Flags.set("IsUltimatum", false);
						this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(3, 6));
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
			Text = "[img]gfx/ui/events/event_168.png[/img]{Zwłoki zaścielają pole, czasem ułożone po trzy lub cztery. Ludzie z %companyname% chodzą między ciałami, rabując, co się da, a do ich łupów dołączają wrony, sępy, szczury, myszy, koty, wałęsające się psy, wilk, dzikus zbyt niebezpieczny, by się do niego zbliżać, oraz stado gęsi, które najwyraźniej uznały to miejsce za dość ciepłe, by przerwać sezonową migrację. Ludzie Wezyra też są już na miejscu i przejmują obowiązki, więc ty musisz wrócić do %employer%a po zapłatę. | W powietrzu czuć wilgotną stagnację i ostry zapach miedzi. Rzeź była tak dokładna, że ziemia zamieniła się tu w bagno krwi i flaków. Ciała są powykręcane na wszystkie strony, czasem ułożone jedno na drugim. Czasem słyszysz jęk, ale martwych jest tak wielu, że szukanie ocalałego byłoby stratą czasu. Ludzie %employer%a wkrótce przejmą twoje obowiązki, co oznacza, że to dobry moment, by wrócić do Wezyra po zapłatę.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Udało nam się!",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.spawnAllies();
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% zatrzymuje cię w bezpiecznej odległości od swojego tronu. Pstryka palcami i służący podchodzi, ale Wezyr śmieje się i podnosi rękę.%SPEECH_ON%Nie, czekaj. Niech zrobi to jedna z kobiet. Ona. Ta najbrzydsza.%SPEECH_OFF%Wskazuje na swój harem, a kobiety rozstępują się, aż jedna zostaje odizolowana. Jest tak smukła, że wyobrażasz sobie, iż na północy mogłaby kupić zamek. Zabiera sakiewkę koron od służącego i kładzie się przed tobą. %employer% uśmiecha się krzywo.%SPEECH_ON%Miałeś utrzymać fort, aż moi ludzie przybędą. Zamiast tego przyjąłeś kobiecą naturę i uciekłeś na widok niebezpieczeństwa. Na szczęście dla ciebie moi ludzie, prawdziwi mężczyźni, odbili fort od północnych i ustanowili go jako wąskie gardło. Przestań się gapić na konkubinę, Koronniku! Twoje oczy mogą spocząć na ziemi albo na zapłacie. Radzę ci wziąć monety i zniknąć mi z oczu, zanim blask Pozłacacza rozpali ogień pod twoimi stopami.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Obroniłeś twierdzę przed najeźdźcami z północy");
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
		this.m.Screens.push({
			ID = "Success2",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Zdajesz %employer%owi raport ze wszystkiego, co się wydarzyło. Na twarzy Wezyra powoli pojawia się uśmiech.%SPEECH_ON%Doprawdy, moi porucznicy wysłali cię tam? Ten fort nie jest nic wart. Kto by płatał taki figiel? Kazałbym ściąć odpowiedzialnego, ale cóż, ile to było, %reward_completion% koron? To dla mnie nic nie znaczy. Płaciłem więcej, by północny błazen opowiedział mi dowcip osobiście, a ich poczucie humoru jest, delikatnie mówiąc, ubogie. Weź złoto i opuść moje włości, Koronniku.%SPEECH_OFF% | Gdy wracasz do %employer%a, Wezyra nigdzie nie ma. Zamiast niego jeden z poruczników bierze cię na bok i dziękuje za służbę.%SPEECH_ON%Między nami i myszami, i niech będzie wiadome, że te słowa nigdy nie zostały wypowiedziane i że w tych salach nie ma myszy, gdybym miał w swoich szeregach ludzi takich jak ty, miałbym w sercu pokusę podbojów. Niestety, dano mi wojska tak użyteczne, jak pojedyncze ziarenko piasku na pustyni. Oto twoja zapłata, Koron-, żołnierzu.%SPEECH_OFF%Wręcza sakiewkę %reward_completion% koron. Inny porucznik pojawia się w korytarzu, a mężczyzna przed tobą klepie cię po ramieniu, jego twarz nagle pozbawiona humoru i życzliwości.%SPEECH_ON%Wynoś się stąd, Koronniku, to twoja zapłata i nie usłyszymy ani jednej sylaby z języka targującego się naciągacza!%SPEECH_OFF% | Wchodzisz do sal Wezyra i znajdujesz samotnego człowieka zamiatającego marmurowe podłogi. Włosie miotły zgrzyta, zatrzymując się na twoim bucie, a on podnosi wzrok.%SPEECH_ON%Ach. Powiedziano mi, że człowiek twojego pokroju tu będzie.%SPEECH_OFF%Odkłada miotłę, której drążek jest chyba grubszy niż jego wątła postać. Podchodzi do stołu i otwiera skrzynię wypełnioną tacami %reward_completion% koron. Pytasz, jak Wezyrowie mogli mu zaufać z taką ilością złota. Mężczyzna podnosi miotłę i śmieje się.%SPEECH_ON%Gdybym ukradł korony dla siebie, jak daleko bym zaszedł? To ciężkie. Nie uniosę wszystkiego. Czy mogę wziąć trochę? Nie. Jestem człowiekiem bez materialnej obecności. Tak jak oko Pozłacacza rozkwita kwiat, złoto w mojej dłoni oświetla mnie jako złodzieja. Nie zaszedłbym daleko. To moje miejsce, a to twoje.%SPEECH_OFF%Bierzesz monety, po czym pytasz, skąd wie, że jesteś właściwym najemnikiem. Jego miotła znów zgrzyta, zatrzymując się, a kropla potu powoli spływa po jego policzku. Zanim odpowie, bierzesz korony i odchodzisz. | %employer% znajduje się wśród swojego rady. Rzadko widywana zgraja w jedwabiach i drapiąca brody patrzy na ciebie z pogardą. Głośno oświadczasz, że fort został utrzymany i przejęty przez południowych żołnierzy. Wszelki hałas milknie, twoje słowa odbijają się echem w marmurowych salach, służba zamiera, a rada przestaje mówić. %employer% wstaje.%SPEECH_ON%Służba, przynieście temu szczekającemu językowi jego monety.%SPEECH_OFF%Jeden z radców spluwa, co przywołane dziecko szybko wyciera.%SPEECH_ON%Powinien był dostać zapłatę, gdy był przy forcie. Jak śmie w ogóle oddychać w tym pokoju.%SPEECH_OFF%Służący podbiegają do ciebie z sakiewkami %reward_completion% koron. Wezyr macha ręką.%SPEECH_ON%Znikaj, Koronniku. Mam ludzi, których zatrudniam do zabaw, a ty nie jesteś jednym z nich.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Obroniłeś twierdzę przed najeźdźcami z północy");
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

	function spawnAllies()
	{
		local cityState = this.World.FactionManager.getFaction(this.getFaction());
		local mapSize = this.World.getMapSize();
		local o = this.m.Destination.getTile().SquareCoords;
		local tiles = [];

		for( local x = o.X - 3; x < o.X + 3; x = x )
		{
			for( local y = o.Y - 6; y <= o.Y - 3; y = y )
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
		local party = cityState.spawnEntity(tiles[0].Tile, "PuՄk z " + cityState.getNameOnly(), true, this.Const.World.Spawn.Southern, this.Math.rand(100, 150) * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + cityState.getBannerString());
		party.setDescription("Poborowi żołnierze, lojalni swemu państwu-miastu.");
		party.getLoot().Money = this.Math.rand(50, 200);
		party.getLoot().ArmorParts = this.Math.rand(0, 25);
		party.getLoot().Medicine = this.Math.rand(0, 3);
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
		local guard = this.new("scripts/ai/world/orders/guard_order");
		guard.setTarget(this.m.Destination.getTile());
		guard.setTime(240.0);
		c.addOrder(guard);
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"employerfaction",
			this.World.FactionManager.getFaction(this.m.Faction).getName()
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Destination.getTile())]
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
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

