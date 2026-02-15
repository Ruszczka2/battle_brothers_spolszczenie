this.deliver_item_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Location = null,
		RecipientID = 0
	},
	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = this.Math.rand(70, 105) * 0.01;
		this.m.Type = "contract.deliver_item";
		this.m.Name = "Zbrojny Kurier";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		if (this.m.Home == null)
		{
			this.setHome(this.World.State.getCurrentTown());
		}

		local recipient = this.World.FactionManager.getFaction(this.m.Destination.getFactions()[0]).getRandomCharacter();
		this.m.RecipientID = recipient.getID();
		this.m.Flags.set("RecipientName", recipient.getName());
		this.contract.start();
	}

	function setup()
	{
		local settlements = this.World.EntityManager.getSettlements();
		local candidates = [];

		foreach( s in settlements )
		{
			if (s.getID() == this.m.Home.getID())
			{
				continue;
			}

			if (!s.isDiscovered() || s.isMilitary())
			{
				continue;
			}

			if (!s.isAlliedWithPlayer())
			{
				continue;
			}

			if (this.m.Home.isIsolated() || s.isIsolated() || !this.m.Home.isConnectedToByRoads(s) || this.m.Home.isCoastal() && s.isCoastal())
			{
				continue;
			}

			local d = this.m.Home.getTile().getDistanceTo(s.getTile());

			if (d < 15 || d > 100)
			{
				continue;
			}

			if (this.World.getTime().Days <= 10)
			{
				local distance = this.getDistanceOnRoads(this.m.Home.getTile(), s.getTile());
				local days = this.getDaysRequiredToTravel(distance, this.Const.World.MovementSettings.Speed, false);

				if (this.World.getTime().Days <= 5 && days >= 2)
				{
					continue;
				}

				if (this.World.getTime().Days <= 10 && days >= 3)
				{
					continue;
				}
			}

			candidates.push(s);
		}

		if (candidates.len() == 0)
		{
			this.m.IsValid = false;
			return;
		}

		this.m.Destination = this.WeakTableRef(candidates[this.Math.rand(0, candidates.len() - 1)]);
		local distance = this.getDistanceOnRoads(this.m.Home.getTile(), this.m.Destination.getTile());
		local days = this.getDaysRequiredToTravel(distance, this.Const.World.MovementSettings.Speed, false);

		if (days >= 2 || distance >= 40)
		{
			this.m.DifficultyMult = this.Math.rand(95, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(70, 85) * 0.01;
		}

		this.m.Payment.Pool = this.Math.max(125, distance * 4.5 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentLightMult());

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.m.Flags.set("Distance", distance);
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Dostarcz przesyłkę, adresatem jest %recipient% z %objective%, to około %days% drogi na %direction%"
				];
				local isSouthern = this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState;

				if (!isSouthern && this.Math.rand(1, 100) <= this.Const.Contracts.Settings.IntroChance)
				{
					this.Contract.setScreen("Intro");
				}
				else if (isSouthern)
				{
					this.Contract.setScreen("TaskSouthern");
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

				if (r <= 10)
				{
					if (this.Contract.getDifficultyMult() >= 0.95 && this.World.Assets.getBusinessReputation() > 750 && (!this.World.Ambitions.hasActiveAmbition() || this.World.Ambitions.getActiveAmbition().getID() != "ambition.defeat_mercenaries"))
					{
						this.Flags.set("IsMercenaries", true);
					}
				}
				else if (r <= 15)
				{
					if (this.World.Assets.getBusinessReputation() > 700)
					{
						this.Flags.set("IsEvilArtifact", true);

						if (!this.World.Flags.get("IsCursedCrystalSkull") && this.Math.rand(1, 100) <= 50)
						{
							this.Flags.set("IsCursedCrystalSkull", true);
						}
					}
				}
				else if (r <= 20)
				{
					if (this.World.Assets.getBusinessReputation() > 500)
					{
						this.Flags.set("IsThieves", true);
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
				this.Contract.m.BulletpointsObjectives = [
					"Dostarcz przesyłkę, adresatem jest %recipient% z %objective%, to około %days% drogi na %direction%"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Destination) && !this.Flags.get("IsStolenByThieves"))
				{
					if (this.Flags.get("IsEnragingMessage"))
					{
						this.Contract.setScreen("EnragingMessage1");
					}
					else
					{
						local isSouthern = this.Contract.m.Destination.isSouthern();

						if (isSouthern)
						{
							this.Contract.setScreen("Success2");
						}
						else
						{
							this.Contract.setScreen("Success1");
						}
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					local parties = this.World.getAllEntitiesAtPos(this.World.State.getPlayer().getPos(), 400.0);

					foreach( party in parties )
					{
						if (!party.isAlliedWithPlayer)
						{
							return;
						}
					}

					if (this.Flags.get("IsMercenaries") && this.World.State.getPlayer().getTile().HasRoad)
					{
						if (!this.TempFlags.get("IsMercenariesDialogTriggered") && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 1)
						{
							this.Contract.setScreen("Mercenaries1");
							this.World.Contracts.showActiveContract();
							this.TempFlags.set("IsMercenariesDialogTriggered", true);
						}
					}
					else if (this.Flags.get("IsEvilArtifact") && !this.Flags.get("IsEvilArtifactDone"))
					{
						if (!this.TempFlags.get("IsEvilArtifactDialogTriggered") && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 1)
						{
							this.Contract.setScreen("EvilArtifact1");
							this.World.Contracts.showActiveContract();
							this.TempFlags.set("IsEvilArtifactDialogTriggered", true);
						}
					}
					else if (this.Flags.get("IsEvilArtifact") && this.Flags.get("IsEvilArtifactDone"))
					{
						this.Contract.setScreen("EvilArtifact3");
						this.World.Contracts.showActiveContract();
						this.Flags.set("IsEvilArtifact", false);
					}
					else if (this.Flags.get("IsThieves") && !this.Flags.get("IsStolenByThieves") && this.World.State.getPlayer().getTile().Type != this.Const.World.TerrainType.Desert && (this.World.Assets.isCamping() || !this.World.getTime().IsDaytime) && this.Math.rand(1, 100) <= 3)
					{
						local tile = this.Contract.getTileToSpawnLocation(this.World.State.getPlayer().getTile(), 5, 10, [
							this.Const.World.TerrainType.Shore,
							this.Const.World.TerrainType.Ocean,
							this.Const.World.TerrainType.Mountains
						], false);
						tile.clear();
						this.Contract.m.Location = this.WeakTableRef(this.World.spawnLocation("scripts/entity/world/locations/bandit_hideout_location", tile.Coords));
						this.Contract.m.Location.setResources(0);
						this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).addSettlement(this.Contract.m.Location.get(), false);
						this.Contract.m.Location.onSpawned();
						this.Contract.addUnitsToEntity(this.Contract.m.Location, this.Const.World.Spawn.BanditDefenders, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						this.Const.World.Common.addFootprintsFromTo(this.World.State.getPlayer().getTile(), tile, this.Const.GenericFootprints, this.Const.World.FootprintsType.Brigands, 0.75);
						this.Flags.set("IsStolenByThieves", true);
						this.Contract.setScreen("Thieves1");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "EvilArtifact")
				{
					this.Flags.set("IsEvilArtifactDone", true);
				}
				else if (_combatID == "Mercs")
				{
					this.Flags.set("IsMercenaries", false);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "EvilArtifact")
				{
					if (this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).getType() == this.Const.FactionType.OrientalCityState)
					{
						this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Nie zdołałeś dostarczyć przesyłki");
					}
					else
					{
						this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Nie zdołałeś dostarczyć przesyłki");
					}

					this.World.Contracts.removeContract(this.Contract);
				}
				else if (_combatID == "Mercs")
				{
					if (this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).getType() == this.Const.FactionType.OrientalCityState)
					{
						this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Nie zdołałeś dostarczyć przesyłki");
					}
					else
					{
						this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Nie zdołałeś dostarczyć przesyłki");
					}

					this.World.Contracts.removeContract(this.Contract);
				}
			}

		});
		this.m.States.push({
			ID = "Running_Thieves",
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Location != null && !this.Contract.m.Location.isNull())
				{
					this.Contract.m.Location.getSprite("selection").Visible = true;
				}

				this.Contract.m.BulletpointsObjectives = [
					"Podążaj za tropem złodziei i odzyskaj swój ładunek",
					"Dostarcz przesyłkę, adresatem jest %recipient% z %objective%, to około %days% drogi na %direction%"
				];
			}

			function update()
			{
				if (this.Contract.m.Location == null || this.Contract.m.Location.isNull())
				{
					this.Contract.setScreen("Thieves2");
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
			Text = "[img]gfx/ui/events/event_112.png[/img]{%employer% wciska ci w ręce sporych rozmiarów skrzynie, zanim ktokolwiek zdąży cokolwiek powiedzieć.%SPEECH_ON%Spójrz tylko, ładunek do dostarczenia już znalazł kogoś, kto go zaniesie! Cud!%SPEECH_OFF%Zrzuca teatralność.%SPEECH_ON%Muszę to dostarczyć do %objective%, gdzie czeka na to człowiek o imieniu %recipient%. Może wygląda niepozornie, ale zapłacę dobrą koronę, by dotarło całe i zdrowe. Zainteresowany? Czy to trochę za ciężkie dla twoich ramion?%SPEECH_OFF% | Zastajesz %employer%a, jak zamyka skrzynie. Szybko zerka w górę, jakby przyłapano go z opuszczonymi spodniami.%SPEECH_ON%Najemniku! Dziękuję, że przyszedłeś.%SPEECH_OFF%Zatrzaskuje zamki kilkoma szybkimi ruchami. Potem poklepuje skrzynie, a nawet opiera się o nią, jakby potrzebowała jeszcze jednego, solidnego ryglowania.%SPEECH_ON%Ten ładunek ma być dostarczony bezpiecznie do %objective%. Czeka tam na niego człowiek o imieniu %recipient%. Nie wierzę, że to będzie łatwe zadanie, bo ładunek jest cenny dla pewnych ludzi, którzy zrobiliby wiele, by go przejąć. Dlatego zwracam się do człowieka o twoich... doświadczeniach. Jesteś zainteresowany?%SPEECH_OFF% | Gdy wchodzisz do komnaty %employer%a, on i jego sługa przybijają skrzynie gwoździami.%SPEECH_ON%Dobrze cię widzieć, najemniku. Moment, proszę. Nie, głupcze, trzymaj gwóźdź tak! Wiem, że uderzyłem cię w kciuk wcześniej, ale już tego nie zrobię.%SPEECH_OFF%Sługa niechętnie trzyma gwóźdź, podczas gdy mężczyzna dobija go młotkiem. Skończone, ociera pot z czoła i patrzy na ciebie.%SPEECH_ON%Potrzebuję, by te skrzynie dostarczyć do %objective%, około %days% drogi na %direction% traktem. Idzie do %recipient%, wiesz, do niego. Dobra, może go nie znasz. Wiem jednak, że to zwykle nie twoja robota, ale jestem gotów zapłacić poważne korony, byś doprowadził sprawę do końca. Na tym polega wasz fach, prawda? Zarabiać korony?%SPEECH_OFF% | %employer% splata dłonie, gdy cię widzi.%SPEECH_ON%To może brzmieć dziwnie, ale na ile interesuje cię dostawa w moim imieniu?%SPEECH_OFF%Wyjaśniasz, że za odpowiednią cenę taka podróż byłaby miłym odejściem od zwykłego zabijania i umierania dookoła. Mężczyzna klaszcze w dłonie.%SPEECH_ON%Doskonale! Niestety nie spodziewam się, że to będzie takie proste. Sprawa jest na tyle ważna, że przyciągnie nieciekawą uwagę, dlatego w ogóle szukam najemników. To idzie do %objective%, mniej więcej %days% na %direction% stąd traktem, gdzie czeka na to człowiek o imieniu %recipient%. Więc nie będzie to ta \"odskocznia\", o której mówisz, ale to może być ładna wypłata, jeśli jesteś zainteresowany.%SPEECH_OFF% | Ludzie %employer%a stoją przy ładunku. Ich pracodawca odprawia ich, gdy cię widzi.%SPEECH_ON%Witaj, witaj. Dobrze cię widzieć. Potrzebuję uzbrojonych strażników, by dostarczyć ten pakunek do człowieka o imieniu %recipient% w %objective%. Sądzę, że to około %days% drogi dla kompanii takiej jak twoja. Na ile byś był tym zainteresowany?%SPEECH_OFF% | Gdy wchodzisz, %employer% ma nogi na stole. Zakłada ręce za głowę, wyglądając na zbyt rozluźnionego, jak na twój gust.%SPEECH_ON%Dobre wieści, kapitanie. Co powiesz na odpoczynek od całego tego zabijania i umierania?%SPEECH_OFF%Unosi brew na twoją reakcję, której nie ma wcale.%SPEECH_ON%Hmm, sądziłem, że skoczysz na tę okazję. Nieważne, to było kłamstwo: potrzebuję, byś dostarczył pewien pakunek do %recipient%, człowieka mieszkającego w %objective%. Ten ładunek z pewnością przyciągnął nieprzychylne oczy, dlatego potrzebuję twoich ludzi, by go pilnowali. Jeśli jesteś zainteresowany, a powinieneś być, porozmawiajmy o liczbach.%SPEECH_OFF% | %employer% wita cię, machając ręką, byś wszedł.%SPEECH_ON%Dobrze, skoro już jesteś, czy możesz zamknąć drzwi za sobą?%SPEECH_OFF%Jeden ze strażników mężczyzny wychyla głowę zza rogu. Uśmiechasz się i powoli go zamykasz na zewnątrz. Odwracając się, widzisz, że %employer% idzie ku oknu. Patrzy na zewnątrz, gdy mówi.%SPEECH_ON%Potrzebuję czegoś... to jest, eee, no, nie musisz wiedzieć, co to jest. Potrzebuję, by to \"coś\" dostarczono do człowieka o imieniu %recipient%. Czeka na to w %objective%. To ważne, by to tam dotarło, na tyle ważne, by wynająć zbrojną eskortę na %days% drogi, dlatego zwracam się do ciebie i twojej kompanii. Co ty na to, najemniku?%SPEECH_OFF% | Mizerne świece ledwo oświetlają komnatę tak, byś widział %employer%a siedzącego za biurkiem, a jego cienie tańczą na ścianach w rytmie migoczącego światła.%SPEECH_ON%Czy pożyczysz mi swoje miecze, jeśli dobrze zapłacę? Potrzebuję, by {małą skrzynię | coś drogiego memu sercu | coś cennego} dostarczono bezpiecznie do %recipient% w %objective%, około %days% drogi na %direction% stąd. Ludzie zabijali się o to, więc musisz być gotów bronić tego życiem.%SPEECH_OFF%Robi pauzę, mierząc twoją reakcję.%SPEECH_ON%Napiszę zapieczętowany list z poleceniem wypłaty, gdy dostarczysz przedmiot mojemu kontaktowi w %objective%. Co ty na to?%SPEECH_OFF% | Sługa prosi, żebyś poczekał na %employer%a, który, jak mówi, zaraz się pojawi. I tak czekasz, i czekasz, i czekasz. Wreszcie, gdy masz zamiar wyjść po raz drugi, %employer% otwiera na oścież drzwi i pędzi ku tobie.%SPEECH_ON%Kto to jest, no tak? Najemnik?%SPEECH_OFF%Jego asystent przytakuje, a %employer% rozpromienia się uśmiechem.%SPEECH_ON%Co za szczęśliwy zbieg okoliczności, że jesteś w %townname%, dobry kapitanie!\n\nNiezmiernie ważne jest, by pewne cenne towary dotarły do %objective% tak bezpiecznie i szybko, jak to możliwe. Jesteś dokładnie tym, kogo potrzebuję, bo żaden pospolity rzezimieszek nie ośmieli się zaatakować ciebie i twoich ludzi.\n\nTak, chciałbym cię wynająć do eskorty. Dopilnuj, by przedmioty dostarczono do %recipient%, oczywiście bez zbaczania z drogi. Czy możemy się porozumieć?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Porozmawiajmy o pieniądzach. | O ilu konkretnie koronach tu mówimy?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Nie jestem zainteresowany. | W najbliższym czasie raczej nie będziemy w tamtych stronach. | Nie takiego rodzaju pracy szukamy.}",
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
			ID = "TaskSouthern",
			Title = "Negocjacje",
			Text = "[img]gfx/ui/events/event_112.png[/img]{Jeden z radnych Wezyra podchodzi z orszakiem sług. Dźwigają średniej wielkości skrzynię w twoją stronę.%SPEECH_ON%Koroniarzu, Wezyr ma dla ciebie zadanie. Niech słudzy oddadzą ci skrzynię pod opiekę, a ty zawieź ją do %recipient% w %objective%, dobrą %days% drogi na %direction% traktem.%SPEECH_OFF%Radny kłania się.%SPEECH_ON%Choć zadanie jest proste, Wezyr gotów jest hojnie zapłacić za jego wykonanie.%SPEECH_OFF% | Zastajesz %employer%a w przedsionku. Słucha szeregu kupców, z których każdy ma własną prośbę lub ofertę, a skryba u jego boku robi notatki w księdze, która rozwija się coraz dalej po marmurowej posadzce. Widząc cię, Wezyr pstryka palcami i mężczyzna z boku podchodzi.%SPEECH_ON%Koroniarzu, majestat pragnie skorzystać z twoich usług. Zabierz skrzynię z tym oznaczeniem do %recipient% w %objective%, około %days% drogi traktem. Zapłatę otrzymasz na miejscu.%SPEECH_OFF% | Mężczyzna z piórami pawia w zadziornej czapce podchodzi do ciebie jakby znikąd. Podchodzi bokiem z księgą w ręku, choć księga nosi znak jednego z wezyrów %townname% i jego straży.%SPEECH_ON%%employer% pragnie skorzystać z twoich usług, Koroniarzu. Masz przewieźć wyborny materiał, oczywiście zapakowany poza zasięgiem twoich niegodziwych oczu, i potajemnie dostarczyć go do %recipient% w %objective%, oddalonym o %days% drogi na %direction%. Gdy materiał zostanie dostarczony, otrzymasz zapłatę na miejscu.%SPEECH_OFF%Mężczyzna odgarnia pióra do tyłu i krótko kręci głową.%SPEECH_ON%Czy ta oferta odpowiada twoim obecnym oczekiwaniom finansowym?%SPEECH_OFF% | Najpierw wita cię gołąb z notatką, która wskazuje na chłopca. Ten prowadzi cię do sługi, sługa wiedzie cię przez harem pełen nagich kobiet, po czym trafiasz do komnaty bogatego kupca.%SPEECH_ON%Ach, w końcu jesteś. Zleciłem proste zadanie moim dłużnikom i zajęło im to tak długo? Muszę się temu przyjrzeć.%SPEECH_OFF%Kupiec rzuca ci księgę i jednocześnie opada na stertę poduszek.%SPEECH_ON%Ja... wybacz, Wezyr potrzebuje, byś zabrał skrzynię towarów do %recipient% w %objective%, oddalonego o %days% drogi na %direction%. Nie wolno ci otwierać tych dóbr, tylko je dostarczyć. Jeśli otworzysz skrzynię, Wezyr się o tym dowie. I uwierz mi, Koroniarzu, Wezyr lubi słyszeć tylko o wspaniałych rzeczach. Dlatego to ja tu jestem, a nie majestat.%SPEECH_OFF%Ależ uprzejmość.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Porozmawiajmy o pieniądzach. | O ilu konkretnie koronach tu mówimy?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Nie jestem zainteresowany. | W najbliższym czasie raczej nie będziemy w tamtych stronach. | Nie takiego rodzaju pracy szukamy.}",
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
			ID = "Mercenaries1",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{Na trakcie przecina ci drogę banda dobrze uzbrojonych ludzi. | Maszerując w stronę %objective%, kilku mężczyzn przerywa waszą spokojną podróż, a brzęk ich broni i zbroi wypełnia powietrze, gdy ustawiają się w szyku. | Twoja podróż, niestety, nie będzie prosta. Kilku mężczyzn wychodzi przed ciebie, wyraźnie blokując drogę. | Kilku uzbrojonych i dobrze opancerzonych ludzi wyszło, by stworzyć metalowy impas. Wygląda na to, że zamierzają dopilnować, byś nie poszedł dalej. | Kilku z nich zatrzymuje się. Idziesz na przód, by zorientować się, co się dzieje, i widzisz linię dobrze uzbrojonych ludzi stojących na drodze %companyname%. Cóż, to zapowiada się ciekawie.} Dowódca przeciwników wychodzi do przodu i uderza pięścią w pierś.%SPEECH_ON%{To my, %mercband%, stoimy przed tobą. Pogromcy bestii niewyobrażalnych, ostatnia nadzieja tego przeklętego kraju! | Nazywamy się %mercband% i słyniemy w całej krainie jako rozłupywacze czaszek, wychylacze beczek i amatorzy niewiast! | Oto legendarny %mercband%. To my, wybawcy %randomtown% i pogromcy fałszywego króla! | Oto moja dumna banda, %mercband%! My, którzy odpędziliśmy setkę orków, by ocalić miasto przed pewną zagładą. A ty czym się możesz pochwalić? | Rozmawiasz z człowiekiem z %mercband%. Żaden zwykły rzezimieszek, paskudny zielonoskóry, mieszek koron ani spódnica nigdy nam nie uciekły!}%SPEECH_OFF%Gdy mężczyzna kończy popisy i osobiste wywody, wskazuje na ładunek, który niesiesz.%SPEECH_ON%{Skoro już wiesz, w jakim jesteś niebezpieczeństwie, czemu po prostu nie oddasz nam ładunku? | Mam nadzieję, że wiesz, z kim masz do czynienia, żałosny najemniku, żebyś zadbał, by twoi ludzie wrócili dziś do swoich łóżek. Wystarczy oddać ładunek, a nie dopiszemy was do historii %mercband%. | A więc chciałbyś stać się częścią naszej historii, prawda? Dobra wiadomość: wystarczy, że nie oddasz ładunku, a dopiszemy cię mieczami. Oczywiście możesz uniknąć pióra skryby, jeśli po prostu go oddasz. | A więc to %companyname%. Choć chętnie dopisałbym was do naszych zwycięstw, dam wam szansę, najemnik najemnikowi. Wystarczy oddać ładunek, a my pójdziemy dalej. Jak to brzmi?}%SPEECH_OFF%{Hmm, przynajmniej prośba była głośna i pewna siebie. | Cóż, teatrzyk był całkiem zabawny. | Nie do końca rozumiesz potrzebę popisów, ale nie ma wątpliwości co do powagi nowej sytuacji. | Choć doceniłeś superlatywy i hiperbole, pozostaje brutalna prawda: ci ludzie naprawdę chcą tego ładunku.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Jeśli tego chcecie, chodźcie i weźcie to sobie!",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Mercs";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				},
				{
					Text = "Nie warto za to umierać. Bierzcie ten przeklęty ładunek i przepadnijcie.",
					function getResult()
					{
						return "Mercenaries2";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Mercenaries2",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{Nie chcąc walki, oddajesz ładunek. Śmieją się, gdy odbierają go z twoich rąk.%SPEECH_ON%Dobry wybór, najemniku. Może kiedyś to ty będziesz grozić innym.%SPEECH_OFF% | Ładunek, czymkolwiek jest, nie jest wart życia twoich ludzi. Oddajesz skrzynię, a najemnicy ją zabierają. Śmieją się z ciebie, gdy odchodzisz.%SPEECH_ON%Jakbyś czarował dziwkę!%SPEECH_OFF% | To nie czas ani miejsce, by poświęcać ludzi w imię usługi dostawczej %employer%a. Oddajesz ładunek. Najemnicy biorą go i odchodzą, a ich dowódca podrzuca ci koronę, która kręcąc się, wpada w błoto.%SPEECH_ON%Kup sobie pastę do butów, dzieciaku, ta robota nie jest dla ciebie.%SPEECH_OFF% | Najemnicy są dobrze uzbrojeni, a ty nie wiesz, czy mógłbyś spać spokojnie, wiedząc, że poświęciłeś ludzi dla jakiejś głupiej skrzyni z czymś, co tylko starzy bogowie wiedzą. Z lekkim skinieniem oddajesz ładunek. Banda najemników chętnie go zabiera, a ich dowódca przystaje, by kiwnąć głową z szacunkiem.%SPEECH_ON%Mądry wybór. Nie myśl, że sam nie dokonywałem wielu takich, gdy byłem młody.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Hrm...",
					function getResult()
					{
						this.Flags.set("IsMercenaries", false);
						this.Flags.set("IsMercenariesDialogTriggered", true);

						if (this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).getType() == this.Const.FactionType.OrientalCityState)
						{
							this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Nie zdołałeś dostarczyć przesyłki");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Nie zdołałeś dostarczyć przesyłki");
						}

						local recipientFaction = this.Contract.m.Destination.getFactionOfType(this.Const.FactionType.Settlement);

						if (recipientFaction != null)
						{
							recipientFaction.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 0.5);
						}

						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BountyHunters1",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{Podczas podróży natykasz się na bandę łowców nagród. Ich więzień woła do ciebie, głos mu się łamie, gdy błaga o ratunek. Twierdzi, że jest niewinny. Łowcy każą ci spadać i zdechnąć. | Jedziesz traktem, gdy napotykasz grupę dobrze uzbrojonych łowców nagród. Wloką człowieka skute go od stóp do głów.%SPEECH_ON%Nie wtrącaj się w tę sprawę.%SPEECH_OFF%Mówi jeden z nich, uderzając więźnia w łydki. Mężczyzna jęczy i czołga się do ciebie na zakrwawionych dłoniach i kolanach.%SPEECH_ON%Oni wszyscy kłamią! Ci ludzie mnie zabiją, choć nic złego nie zrobiłem! Ratujcie mnie, panowie, błagam!%SPEECH_OFF% | Natykasz się na dużą bandę łowców nagród, wasze dwie grupy dziwnie się do siebie upodabniają, choć wasze cele na tym świecie wyraźnie się różnią. Przewożą więźnia, zakutego w łańcuchy, z ustami zapchanymi szmatą. Mężczyzna krzyczy do ciebie, niemal błagalnie, dławiąc się własnymi słowami, aż czerwienieje na twarzy. Jeden z łowców nagród spluwa.%SPEECH_ON%Nie zwracaj na niego uwagi, nieznajomy, i idź swoją drogą. Niech nie będzie między nami kłopotów.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To nie nasza sprawa.",
					function getResult()
					{
						return 0;
					}

				},
				{
					Text = "Być może moglibyśmy wykupić więźnia?",
					function getResult()
					{
						return this.Math.rand(1, 100) <= 50 ? "BountyHunters1" : "BountyHunters1";
					}

				},
				{
					Text = "Jeśli tego chcecie, chodźcie i weźcie to sobie!",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Mercs";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 140 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Thieves1",
			Title = "Podczas obozowania...",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Podnosisz się z drzemki i obracasz, szukając pakunku jak kochanki. Ale jej nie ma, a ładunku też. Szybko stajesz na nogi i zaczynasz zwoływać ludzi. %randombrother% podbiega i mówi, że wyśledził odchodzące stąd ślady. | Podczas odpoczynku słyszysz zamieszanie w obozie. Biegniesz tam i widzisz %randombrother%a leżącego twarzą w ziemi, pocierającego tył głowy.%SPEECH_ON%Przepraszam, panie, poszedłem się odlać, a oni mnie dopadli. I jeszcze ukradli pakunek.%SPEECH_OFF%Każesz mu powtórzyć ostatnią część.%SPEECH_ON%Cholerne złodzieje ukradli ładunek!%SPEECH_OFF%Czas ich wytropić i odzyskać towar. | Oczywiście nie mogła to być zwykła podróż. Nie, ten świat jest zbyt parszywy, by tak było. Wygląda na to, że złodzieje uciekli z ładunkiem. Na szczęście zostawili mnóstwo śladów, głównie odciski stóp i ślady wleczenia pakunku. Powinno być łatwo ich znaleźć... | Choć raz chciałbyś mieć spokojny spacer z jednego miasta do drugiego. Zamiast tego umowa z %employer% znów przyciągnęła kłopoty. Złodzieje jakimś cudem wślizgnęli się do obozu i zwiali z ładunkiem. Dobra wiadomość jest taka, że nie udało im się wymknąć bez śladu: masz ich trop i nie będzie trudno go śledzić.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ruszajmy za ich śladami!",
					function getResult()
					{
						this.Contract.setState("Running_Thieves");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Thieves2",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Złodziejska krew leje się gęsto. Udaje ci się znaleźć towar pracodawcy w obozie, zamknięty i bezpieczny. Nie musi wiedzieć o tej małej wycieczce. | Cóż, wszystko jest tam, gdzie powinno. Ładunek %employer%a znaleziono pod wijącym się ciałem złodzieja. Dopilnowałeś, by kopnąć go na bok, zanim go dobiłeś. W końcu nie chcesz ochlapać pakunku krwią. | Po zabiciu ostatniego złodzieja ty i ludzie rozchodzicie się po obozie bandytów, szukając pakunku. %randombrother% szybko go wypatruje, a pojemnik wciąż tkwi w uścisku martwego głupca. Najemnik szarpie się z jego palcami i z frustracji po prostu odcina mu ramiona. Odbierasz pakunek i trzymasz go bliżej na dalszą drogę. | Patrząc na ciała zabitych złodziei, zastanawiasz się, czy %employer% musi o tym wiedzieć. Pakunek wygląda w porządku. Trochę krwi i kości, ale można to zetrzeć. | Pakunek jest trochę porysowany, ale będzie dobrze. No dobra, cały jest w krwi, a odarty ze skóry palec złodzieja wbity jest w jeden z zatrzasków. Poza tym wszystko jest w idealnym porządku.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Z powrotem tam, gdzie jego miejsce.",
					function getResult()
					{
						this.Flags.set("IsThieves", false);
						this.Flags.set("IsStolenByThieves", false);
						this.Contract.setState("Running");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "EnragingMessage1",
			Title = "%objective%",
			Text = "{Cmentarz spowija mgła - albo gęsta miasma unosząca się od zmarłych. Czekaj... to właśnie martwi! Do broni! | Spoglądasz na nagrobek z kopcem ziemi rozkopanym u podstawy. Smugi błota prowadzą dalej jak okruszki. Nie ma łopat... nie ma ludzi... Idąc tropem, natykasz się na bandę nieumarłych jęczących i zawodzących... teraz wpatrzonych w ciebie z nienasyconym głodem... | Mężczyzna stoi głęboko wśród rzędów nagrobków. Chwieje się, jakby miał zaraz zemdleć. %randombrother% staje obok i kręci głową.%SPEECH_ON%To nie człowiek, panie. Tu kręcą się nieumarli.%SPEECH_OFF%Gdy kończy mówić, nieznajomy w oddali powoli się odwraca i w świetle widać, że brakuje mu połowy twarzy. | Odkrywasz, że wiele grobów jest pustych. Nie tylko pustych, ale rozkopanych od dołu. To nie robota szabrowników...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "EvilArtifact1",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_55.png[/img]{Podczas marszu zauważasz, że coś jeszcze się porusza: ładunek. Wieko podskakuje, a z boków sączy się dziwna poświata. %randombrother% podchodzi, patrzy na to, potem na ciebie.%SPEECH_ON%Otworzyć, panie? Albo mogę to wziąć i wrzucić do najbliższego stawu, bo nic w tym nie jest w porządku.%SPEECH_OFF%Szturchasz go i pytasz, czy się boi. | Idąc traktem, zaczynasz słyszeć niski pomruk dobiegający z pakunku, który dał ci %employer%. %randombrother% stoi obok i dźga go patykiem. Strącasz mu rękę. Tłumaczy się.%SPEECH_ON%Panie, z tym ładunkiem coś jest nie tak...%SPEECH_OFF%Przyglądasz się uważnie. Na krawędziach wieka tli się słaba poświata. O ile wiesz, ogień nie może oddychać w takim zamknięciu, a jedyne inne rzeczy świecące w ciemności to księżyce i gwiazdy. Obawiasz się, że ciekawość zaczyna brać górę... | Ładunek spoczywa na wozie obok ciebie, podskakując na wybojach. Nagle zaczyna buczeć i przysięgasz, że na moment wieko uniosło się w górę. %randombrother% zerka.%SPEECH_ON%Wszystko w porządku, panie?%SPEECH_OFF%Ledwo kończy mówić, wieko eksploduje na zewnątrz, wir kolorów, mgły, popiołu, żaru i przenikliwego chłodu. Zasłaniasz się rękami i gdy wyglądasz przez łokcie, pakunek jest zupełnie nieruchomy, a wieko znów na miejscu. Wymieniasz spojrzenie z najemnikiem i obaj wpatrujecie się w ładunek. To może być coś więcej niż zwykła dostawa... | Z pobliskiego miejsca dobiega niski pomruk. Myśląc, że to rój pszczół, instynktownie się pochylasz, ale dźwięk dochodzi z ładunku, który wręczył ci %employer%. Wieko trzęsie się na boki, szarpiąc zatrzaski i gwoździe, które powinny je trzymać. %randombrother% wygląda na przestraszonego.%SPEECH_ON%Zostawmy to tutaj. Z tym czymś jest coś nie tak.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Chcę wiedzieć, co się dzieje.",
					function getResult()
					{
						return "EvilArtifact2";
					}

				},
				{
					Text = "Zostawcie to w spokoju.",
					function getResult()
					{
						this.Flags.set("IsEvilArtifact", false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "EvilArtifact2",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_73.png[/img]{Ciekawość bierze górę. Powoli zaczynasz podważać wieko. %randombrother% cofa się o krok i protestuje.%SPEECH_ON%Uważam, że powinniśmy to zostawić, panie. No przecież, spójrz na to.%SPEECH_OFF%Ignorując go, mówisz ludziom, że wszystko będzie w porządku, i podnosisz wieko.\n\n Nie jest w porządku. Eksplozja zwala cię z nóg. Wokół wirują straszliwe kształty i wrzaski. Ludzie odruchowo chwytają za broń, gdy sterowane zjawy wbijają się w ziemię. Tu ziemia unosi się kopcami, a tam zaczyna jęczeć. Widzisz, jak z niej wystrzeliwują dłonie, wyciągając z jam zbutwiałe ciała. Martwi znów żyją i z pewnością chcą powiększyć swoje szeregi! | Wbrew wszelkim zdrowym osądom podważasz ładunek. Na początku nie ma nic. To po prostu puste pudło. %randombrother% nerwowo się śmieje.%SPEECH_ON%No... to chyba tyle.%SPEECH_OFF%Ale to nie może być wszystko, prawda? Czemu %employer% kazałby ci dostarczać pusty pojemnik, jeśli nie -- \n\n Budzisz się z dzwonieniem w uszach, które powoli cichnie. Odwracasz się i widzisz, że pudełko całkowicie wyparowało, a na ziemi pozostała tylko chmura białego pyłu z trocin. %randombrother% podbiega, podnosi cię i ciągnie w stronę reszty kompanii. Wskazują palcami, ich usta się poruszają, krzyczą...\n\n Zgraja dobrze uzbrojonych ludzi... kuśtyka w waszą stronę? Gdy przyglądasz się lepiej, dostrzegasz stare drewniane tarcze pomalowane dziwnymi rytami i pancerze o kształtach i rozmiarach, jakich nigdy nie widziałeś, jakby powstały rękami ludzi dopiero uczących się rzemiosła, a jednak dobrze obytych w tym, czego się nauczyli. To jak starożytni... pierwsi ludzie. | %randombrother% kręci głową, gdy sięgasz po wieko. Z wysiłkiem je podważasz i szybko cofasz się, spodziewając się najgorszego. Ale nic się nie dzieje. Z pudełka nie wydobywa się nawet dźwięk. Bierzesz miecz i grzechoczesz nim w pustym pudle, szukając tajnej skrytki czy czegoś podobnego. %randombrother% się śmieje.%SPEECH_ON%Hej, dostarczamy po prostu powietrze! A ja myślałem, że to cholerstwo jest takie ciężkie!%SPEECH_OFF%Wtedy pudełko na chwilę unosi się w powietrze, obraca i rozbija o ziemię. Pęka idealnie, bezgłośnie, bez zbędnych ruchów, a każdy kawałek drewna układa się na trawie jak pradawne kamienne dzieło. Z rozszczepionych znaków wynurza się niematerialny kształt, szczerzy się i skręca.%SPEECH_ON%Och, ludzie, naprawdę dobrze znów was widzieć.%SPEECH_OFF%Głos jest jak lód spływający po kręgosłupie. Widzisz, jak zjawa wystrzeliwuje w niebo, po czym uderza z powrotem, przebijając ziemię. Nie mija sekunda, a ziemia wybucha, gdy ciała zaczynają się wydrapywać na powierzchnię. | Pudełko cię przyciąga. Bez wahania otwierasz ładunek i zaglądasz do środka. Najpierw czujesz zapach - ohydny smród, który niemal cię oślepia. Jeden z ludzi wymiotuje. Inny ma odruchy wymiotne. Gdy znów patrzysz na skrzynię, czarne pasma dymu sączą się z niej, rozciągając się daleko i badając ziemię. Gdy znajdują to, czego szukają, nurkują w grunt, wyciągając kości zmarłych jak przynęta rybę. | Ignorując obawy kilku ludzi, rozwalasz pakunek. W środku leży sterta głów, a ich świecące oczy migoczą, budząc się do życia. Szczęki trzaskają, przechodząc ze stanu bezruchu do grzechotu śmiechu. Szybko zamykasz skrzynię, ale jakaś siła znów ją otwiera. Szarpiesz się z nią, %randombrother% i kilku innych próbuje pomóc, lecz to tak, jakby zupełnie bezgłośne wiatry burzy odpychały cię z powrotem.\n\nChwilę później wszyscy zostajecie odrzuceni, a wieko skrzyni szybuje w niebo, wzniesione podmuchem poczerniałych dusz. Krążą, przeszukując ziemię, po czym zbiorowo ustawiają się naprzeciw %companyname%. Tam z przerażeniem patrzysz, jak niematerialne kształty zaczynają przybierać formę, a mgliste opary dusz twardnieją w prawdziwe kości istot utraconych dawno temu. I oczywiście są uzbrojeni, a trzaskające szczęki wciąż terkoczą pustym śmiechem.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "EvilArtifact";
						p.Music = this.Const.Music.UndeadTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;

						if (this.Flags.get("IsCursedCrystalSkull"))
						{
							this.World.Flags.set("IsCursedCrystalSkull", true);
							p.Loot = [
								"scripts/items/accessory/legendary/cursed_crystal_skull"
							];
						}

						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.UndeadArmy, 120 * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
						this.World.Contracts.startScriptedCombat(p, false, false, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "EvilArtifact3",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_55.png[/img]{Gdy bitwa się kończy, pędzisz z powrotem do artefaktu i zastajesz go unoszącego się w powietrzu. %randombrother% podbiega do ciebie.%SPEECH_ON%Zniszcz to, panie, zanim narobi więcej kłopotów!%SPEECH_OFF% | Twoi ludzie nie byli jedynymi, którzy przetrwali bitwę - artefakt, albo cokolwiek zostało z jego pulsującej mocy, unosi się niewinnie tam, gdzie widziałeś go ostatnio. To kula wirującej energii, czasem grzechocząca, czasem szepcząca językiem, którego nie znasz. %randombrother% kiwa głową w jego stronę.%SPEECH_ON%Rozbij go, panie. Rozbij i zakończmy ten koszmar.%SPEECH_OFF% | Taka moc nie była przeznaczona dla tego świata! Artefakt przybrał kształt kuli wielkości twojej pięści. Unosi się nad ziemią, brzęcząc jakby śpiewał pieśń z innego świata. Niemal wygląda, jakby na ciebie czekał, jak pies czeka na pana.%SPEECH_ON%Panie.%SPEECH_OFF%%randombrother% szarpie cię za ramię.%SPEECH_ON%Panie, proszę, zniszcz to. Nie zabierajmy tego ani kroku dalej!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Musimy to zniszczyć.",
					function getResult()
					{
						return "EvilArtifact4";
					}

				},
				{
					Text = "Płacą nam za dostawę, więc tak zrobimy.",
					function getResult()
					{
						this.Flags.set("IsEvilArtifact", false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "EvilArtifact4",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_55.png[/img]{Wyjmujesz miecz i stajesz przed artefaktem, powoli unosząc ostrze nad głowę.%SPEECH_ON%Nie rób tego!%SPEECH_OFF%Zerkając przez ramię, widzisz %randombrother%a i innych ludzi, którzy patrzą na ciebie spode łba. Otacza ich czerń, a cały świat, jak daleko sięga wzrok. Ich oczy jarzą się czerwienią, pulsując wściekle przy każdym słowie.%SPEECH_ON%Będziesz płonąć wiecznie! Płonąć wiecznie! Zniszcz to, a spłoniesz! Pal się! PAL SIĘ!%SPEECH_OFF%Krzycząc, odwracasz się i tnąc, rozcinasz relikt. Rozpada się bez wysiłku na pół, a fala barw wraca do twojego świata. Pot spływa ci z czoła, gdy opierasz się o głowicę broni. Spoglądasz za siebie i widzisz wpatrującą się w ciebie kompanię.%SPEECH_ON%Panie, wszystko w porządku?%SPEECH_OFF%Chowasz miecz i kiwasz głową, ale nigdy nie czułeś takiego przerażenia. %employer% nie będzie zadowolony, ale niech diabli wezmą jego gniew! | Ledwo pomyślisz o zniszczeniu reliktu, nadchodzi fala przerażonych krzyków. Piskliwy płacz kobiet i dzieci, głosy łamiące się ze strachu, jakby biegli na ciebie całkowicie w płomieniach. Krzyczą do ciebie w setkach języków, ale co jakiś czas rozpoznajesz jeden, a słowo zawsze brzmi: NIE.\n\n Wyciągasz miecz i unosisz go nad głowę. Artefakt brzęczy i drży. Z jego powierzchni snują się dymne pasma, a brutalny żar zalewa cię falą. NIE.\n\n Ustalasz chwyt.\n\n Davkul. Yekh\'la. Imshudda. Pezrant. NIE.\n\nPrzełykasz ślinę i stabilizujesz cel.\n\n NIE.RAVWEET.URRLA.OSHARO.EBBURRO.MEHT\'JAKA.NIE.NIE.NIE.NI--\n\n Cios jest prawdziwy, słowo ginie, a artefakt spada na ziemię w strzępach. Osuwasz się na kolana, a kilku braci z kompanii pomaga ci wstać. %employer% nie będzie zadowolony, ale nie możesz oprzeć się wrażeniu, że oszczędziłeś temu światu grozę, której nie powinien nigdy zobaczyć ani usłyszeć.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "I po sprawie.",
					function getResult()
					{
						this.Flags.set("IsEvilArtifact", false);

						if (this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).getType() == this.Const.FactionType.OrientalCityState)
						{
							this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Nie zdołałeś dostarczyć przesyłki");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Nie zdołałeś dostarczyć przesyłki");
						}

						local recipientFaction = this.Contract.m.Destination.getFactionOfType(this.Const.FactionType.Settlement);

						if (recipientFaction != null)
						{
							recipientFaction.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 0.5);
						}

						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "EvilArtifact5",
			Title = "Podczas podróży...",
			Text = "[img]gfx/ui/events/event_55.png[/img]{Kręcisz głową i bierzesz inną skrzynię, ostrożnie wsuwając do niej unoszący się artefakt, po czym zamykasz wieko. %employer% płaci ci dobre pieniądze i, cóż, zamierzasz doprowadzić sprawę do końca. Z jakiegoś powodu nie jesteś jednak pewien, czy to twoja decyzja, czy też szept tego dziwnego reliktu prowadzi twoją rękę. | Idziesz po drewnianą skrzynię i unosząc ją do artefaktu, szybko zamykasz wieko. Kilku najemników kręci głową. To pewnie nie najlepszy pomysł, ale z jakiegoś powodu czujesz przymus, by dokończyć zadanie. | Zdrowy rozsądek mówi, by zniszczyć ten okropny relikt, ale znów zawodzi. Bierzesz drewnianą skrzynię i nakładasz ją na artefakt, po czym zamykasz wieko i zatrzaskujesz zamki. Nie wiesz, po co to robisz, ale twoje ciało wypełnia nowa energia, gdy szykujesz się do dalszej drogi.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Powinniśmy ruszać dalej.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "W %objective%",
			Text = "[img]gfx/ui/events/event_20.png[/img]{%recipient% czeka na ciebie, gdy wchodzisz do miasta. Pośpiesznie odbiera ładunek z twoich rąk.%SPEECH_ON%Och, ochhh nie sądziłem, że tu dotrzesz.%SPEECH_OFF%Jego brudne palce tańczą po skrzyni z ładunkiem. Odwraca się i warczy polecenie do jednego ze swoich ludzi. Podchodzą i wręczają ci sakiewkę koron. | Wreszcie dotarłeś. %recipient% stoi pośrodku drogi, dłonie splecione na brzuchu, z chytrym uśmieszkiem na twarzy.%SPEECH_ON%Najemniku, nie byłem pewien, że dasz radę.%SPEECH_OFF%Dźwigasz ładunek i oddajesz go.%SPEECH_ON%Och tak? A dlaczego tak mówisz?%SPEECH_OFF%Mężczyzna bierze skrzynię i podaje ją człowiekowi w szatach, który szybko znika z nią pod pachą. %recipient% śmieje się, wręczając ci sakiewkę koron.%SPEECH_ON%Trakty są ostatnio paskudne, co nie?%SPEECH_OFF%Rozumiesz, że to tylko gadka, by odwrócić twoją uwagę od ładunku, który właśnie oddałeś. Nieważne, dostałeś zapłatę i to ci wystarcza. | %recipient% wita cię, a kilku jego ludzi spieszy, by przejąć ładunek. Klepie cię po ramionach.%SPEECH_ON%Rozumiem, że podróż przebiegła pomyślnie?%SPEECH_OFF%Oszczędzasz mu szczegółów i pytasz o zapłatę.%SPEECH_ON%Ba, najemnik do szpiku kości. %randomname%! Daj temu człowiekowi to, na co zasłużył!%SPEECH_OFF%Jeden z ochroniarzy %recipient%a podchodzi i wręcza ci niewielką skrzynkę koron. | Po chwili wypytywania mężczyzna pyta, kogo szukasz. Gdy mówisz, że %recipient%, wskazuje na pobliski padok, gdzie ktoś przechadza się na wyjątkowo okazałym koniu.\n\n Podchodzisz, a mężczyzna stawia rumaka dęba i pyta, czy to ładunek przysłany przez %employer%a. Kiwasz głową.%SPEECH_ON%Zostaw go przy moich stopach. Sam go zabiorę.%SPEECH_OFF%Nie robisz tego, zamiast tego pytasz o zapłatę. Mężczyzna wzdycha i gwiżdże na ochroniarza, który szybko podchodzi.%SPEECH_ON%Dopilnuj, by ten najemnik dostał to, na co zasłużył.%SPEECH_OFF%W końcu stawiasz skrzynię na ziemi i odchodzisz.} ",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "W pełni zasłużona zapłata.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());

						if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState)
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Dostarczyłeś jakiś ładunek");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Dostarczyłeś jakiś ładunek");
						}

						local recipientFaction = this.Contract.m.Destination.getFactionOfType(this.Const.FactionType.Settlement);

						if (recipientFaction != null)
						{
							recipientFaction.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess * 0.5, "Dostarczyłeś jakiś ładunek");
						}

						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Tactical.getEntityByID(this.Contract.m.RecipientID).getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "W %objective%",
			Text = "[img]gfx/ui/events/event_163.png[/img]{%SPEECH_START%Ach, Koroniarz.%SPEECH_OFF%Głos dobiega z pobliskiej alejki. Zwykle oznacza to, że zaraz ktoś podbierze ci monety, ale tym razem widzisz człowieka oferującego złoto.%SPEECH_ON%Jestem %recipient% i ten pakunek należy do mnie. Przekaż %employer%owi moje pozdrowienia, albo nie, nie obchodzi mnie to.%SPEECH_OFF%Mężczyzna odchodzi i znika tak szybko, jak się pojawił. | %recipient% jest krępym mężczyzną i nosi emblematy Wezyra, jakby były tak ciężkie jak skrzynia, którą właśnie mu przyniosłeś.%SPEECH_ON%Dałem Wezyrowi wiele, a czym mi odpłaca? Potem Koroniarza. Niech Gilder mrugnie, gdy spojrzy na przyszłość tego człowieka.%SPEECH_OFF%Nic na to nie mówisz, po części dlatego, że zastanawiasz się, czy to nie "test", by sprawdzić, czy się z nim zgodzisz i staniesz się wrogiem wiecznie majestatycznego Wezyra. Mężczyzna patrzy na ciebie chwilę, po czym wzrusza ramionami i mówi dalej.%SPEECH_ON%Mam tu twoją zapłatę. Wszystko się zgadza, choć nie obrażę się, jeśli zechcesz ją policzyć. Ach, widzę, że już to robisz. Dobrze. Widzisz? Wszystko jest. A teraz zmykaj, mały Koroniarzu.%SPEECH_OFF% | Zastajesz %recipient%a uczącego gromadkę dzieci. Szybko cię wskazuje i daje im lekcję o tym, by pilnowały nauki, inaczej skończą jak ty. Po odesłaniu dzieci podchodzi z sakiewką koron.%SPEECH_ON%Moi ludzie powiedzieli, że dotarłeś, a materiał jest w dobrym stanie. Oto twoja skromna zapłata, Koroniarzu.%SPEECH_OFF% | Wchodzisz do domu %recipient%a, gdzie pakunek wreszcie zostaje odstawiony i natychmiast wyniesiony przez sługi. %recipient% spogląda na ciebie z wygodnego fotela i pyta, czy podróż przebiegła pomyślnie. Odpowiadasz, że puste gadanie nie napełnia kieszeni, i pytasz o zapłatę. Mężczyzna unosi brew.%SPEECH_ON%Ach, czy uraziłem Koroniarza moimi uprzejmymi, cywilizowanymi manierami? Jakże śmiem. Cóż, twoja zapłata jest w rogu, w pełnej wysokości, jak ustalono.%SPEECH_OFF% | %recipient% prawi o naturze ptaków do lustra. Gdy widzi cię w odbiciu, odwraca się i mówi tak, jakby nic dziwnego się nie wydarzyło.%SPEECH_ON%Koroniarz. Oczywiście Wezyr przysyła Koroniarza. Lubię sobie wyobrażać, że nie ośmieliłeś się zbezcześcić zawartości skrzyni swoim wzrokiem, ale nawet takiej profesjonalności nie potrafię zaufać u twojego rodzaju. Co do mnie możesz być pewien: twoja zapłata jest w rogu i w pełnej wysokości.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "W pełni zasłużona zapłata.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());

						if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState)
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Dostarczyłeś jakiś ładunek");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Dostarczyłeś jakiś ładunek");
						}

						local recipientFaction = this.Contract.m.Destination.getFactionOfType(this.Const.FactionType.Settlement);

						if (recipientFaction != null)
						{
							recipientFaction.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess * 0.5, "Dostarczyłeś jakiś ładunek");
						}

						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Tactical.getEntityByID(this.Contract.m.RecipientID).getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] koron"
				});
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		local days = this.getDaysRequiredToTravel(this.m.Flags.get("Distance"), this.Const.World.MovementSettings.Speed, true);
		_vars.push([
			"objective",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.m.Destination.getName()
		]);
		_vars.push([
			"recipient",
			this.m.Flags.get("RecipientName")
		]);
		_vars.push([
			"mercband",
			this.Const.Strings.MercenaryCompanyNames[this.Math.rand(0, this.Const.Strings.MercenaryCompanyNames.len() - 1)]
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Destination.getTile())]
		]);
		_vars.push([
			"days",
			days <= 1 ? "dzień" : days + " dni"
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

			if (this.m.Location != null && !this.m.Location.isNull())
			{
				this.m.Location.getSprite("selection").Visible = false;
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive() || !this.m.Destination.isAlliedWithPlayer())
		{
			return false;
		}

		return true;
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

		if (this.m.Location != null && !this.m.Location.isNull())
		{
			_out.writeU32(this.m.Location.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		_out.writeU32(this.m.RecipientID);
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		local location = _in.readU32();

		if (location != 0)
		{
			this.m.Location = this.WeakTableRef(this.World.getEntityByID(location));
		}

		this.m.RecipientID = _in.readU32();

		if (!this.m.Flags.has("Distance"))
		{
			this.m.Flags.set("Distance", 0);
		}

		this.contract.onDeserialize(_in);
	}

});

