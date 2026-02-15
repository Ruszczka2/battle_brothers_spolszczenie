this.big_game_hunt_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Size = 0,
		Dude = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.big_game_hunt";
		this.m.Name = "Polowanie na Grubego Zwierza";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 5.0;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
		this.m.MakeAllSpawnsResetOrdersOnceDiscovered = true;
		this.m.DifficultyMult = 1.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function setup()
	{
		local r = this.Math.rand(1, 100);

		if (r <= 40)
		{
			this.m.Size = 0;
			this.m.DifficultyMult = 0.75;
		}
		else if (r <= 75 || this.World.getTime().Days <= 30)
		{
			this.m.Size = 1;
			this.m.DifficultyMult = 1.0;
		}
		else
		{
			this.m.Size = 2;
			this.m.DifficultyMult = 1.2;
		}
	}

	function start()
	{
		if (this.m.Home == null)
		{
			this.setHome(this.World.State.getCurrentTown());
		}

		local maximumHeads;
		local priceMult = 1.0;

		if (this.m.Size == 0)
		{
			local priceMult = 1.0;
			maximumHeads = [
				15,
				20,
				25,
				30
			];
		}
		else if (this.m.Size == 1)
		{
			local priceMult = 4.0;
			maximumHeads = [
				10,
				12,
				15,
				18,
				20
			];
		}
		else
		{
			local priceMult = 8.0;
			maximumHeads = [
				8,
				10,
				12,
				15
			];
		}

		this.m.Payment.Pool = 1300 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult() * priceMult;
		this.m.Payment.Count = 1.0;
		this.m.Payment.MaxCount = maximumHeads[this.Math.rand(0, maximumHeads.len() - 1)];
		local settlements = this.World.FactionManager.getFaction(this.m.Faction).getSettlements();
		local other_settlements = this.World.EntityManager.getSettlements();
		local regions = this.World.State.getRegions();
		local candidates_first = [];
		local candidates_second = [];

		foreach( i, r in regions )
		{
			local inSettlements = 0;
			local nearSettlements = 0;

			if (r.Type == this.Const.World.TerrainType.Snow || r.Type == this.Const.World.TerrainType.Mountains || r.Type == this.Const.World.TerrainType.Desert || r.Type == this.Const.World.TerrainType.Oasis)
			{
				continue;
			}

			if (!r.Center.IsDiscovered)
			{
				continue;
			}

			if (this.m.Size == 2 && r.Type != this.Const.World.TerrainType.Steppe && r.Type != this.Const.World.TerrainType.Forest && r.Type != this.Const.World.TerrainType.LeaveForest && r.Type != this.Const.World.TerrainType.AutumnForest)
			{
				continue;
			}

			if (r.Discovered < 0.5)
			{
				this.World.State.updateRegionDiscovery(r);
			}

			if (r.Discovered < 0.5)
			{
				continue;
			}

			foreach( s in settlements )
			{
				local t = s.getTile();

				if (t.Region == i + 1)
				{
					inSettlements = ++inSettlements;
					inSettlements = inSettlements;
				}
				else if (t.getDistanceTo(r.Center) <= 20)
				{
					local skip = false;

					foreach( o in other_settlements )
					{
						if (o.getFaction() == this.getFaction())
						{
							continue;
						}

						local ot = o.getTile();

						if (ot.Region == i + 1 || ot.getDistanceTo(r.Center) <= 10)
						{
							skip = true;
							break;
						}
					}

					if (!skip)
					{
						nearSettlements = ++nearSettlements;
						nearSettlements = nearSettlements;
					}
				}
			}

			if (nearSettlements > 0 && inSettlements == 0)
			{
				candidates_first.push(i + 1);
			}
			else if (inSettlements > 0 && inSettlements <= 1)
			{
				candidates_second.push(i + 1);
			}
		}

		local region;

		if (candidates_first.len() != 0)
		{
			region = candidates_first[this.Math.rand(0, candidates_first.len() - 1)];
		}
		else if (candidates_second.len() != 0)
		{
			region = candidates_second[this.Math.rand(0, candidates_second.len() - 1)];
		}
		else
		{
			region = settlements[this.Math.rand(0, settlements.len() - 1)].getTile().Region;
		}

		this.m.Flags.set("Region", region);
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
				this.Contract.m.BulletpointsObjectives.clear();

				if (this.Contract.m.Size == 0)
				{
					if (this.Const.DLC.Desert)
					{
						this.Contract.m.BulletpointsObjectives.push("Poluj na Wilkory, Webknechty i Nachzehrery");
					}
					else
					{
						this.Contract.m.BulletpointsObjectives.push("Poluj na Wilkory, Webknechty i Nachzehrery");
					}
				}
				else if (this.Contract.m.Size == 1)
				{
					this.Contract.m.BulletpointsObjectives.push("Poluj na Alpy, Unholdy i Wiedźmy");
				}
				else
				{
					this.Contract.m.BulletpointsObjectives.push("Poluj na Schraty i Lindwurmy");
				}

				this.Contract.m.BulletpointsObjectives.push("Poluj w okolicy %regiontype% w regionie %worldmapregion% oraz w innych regionach");
				this.Contract.m.BulletpointsObjectives.push("W dowolnej chwili wróć do %townname% po zapłatę");

				if (this.Contract.m.Size == 0)
				{
					this.Contract.setScreen("TaskSmall");
				}
				else if (this.Contract.m.Size == 1)
				{
					this.Contract.setScreen("TaskMedium");
				}
				else
				{
					this.Contract.setScreen("TaskLarge");
				}
			}

			function end()
			{
				this.Flags.set("StartDay", this.World.getTime().Days);
				local action = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getAction("send_beast_roamers_action");
				local options;

				if (this.Contract.m.Size == 0)
				{
					options = action.m.BeastsLow;
				}
				else if (this.Contract.m.Size == 1)
				{
					options = action.m.BeastsMedium;
				}
				else
				{
					options = action.m.BeastsHigh;
				}

				local nearTile = this.World.State.getRegion(this.Flags.get("Region")).Center;

				for( local i = 0; i < 3; i = i )
				{
					for( local tries = 0; tries++ < 1000;  )
					{
						if (options[this.Math.rand(0, options.len() - 1)](action, nearTile))
						{
							local party = action.getFaction().getUnits()[action.getFaction().getUnits().len() - 1];
							party.setAttackableByAI(false);
							this.Contract.m.UnitsSpawned.push(party.getID());
							local wait = this.new("scripts/ai/world/orders/wait_order");
							wait.setTime(15.0);
							party.getController().addOrderInFront(wait);
							local footPrintsOrigin = this.Contract.getTileToSpawnLocation(nearTile, 4, 8);
							this.Const.World.Common.addFootprintsFromTo(footPrintsOrigin, party.getTile(), this.Const.BeastFootprints, party.getFootprintType(), party.getFootprintsSize(), 1.1);
							break;
						}
					}

					i = ++i;
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives.clear();

				if (this.Contract.m.Size == 0)
				{
					if (this.Const.DLC.Desert)
					{
						this.Contract.m.BulletpointsObjectives.push("Zapoluj na Wilkory, Webknechty i Nachzehrery w okolicy %regiontype% regionu %worldmapregion% (%killcount%/%maxcount%)");
					}
					else
					{
						this.Contract.m.BulletpointsObjectives.push("Zapoluj na Wilkory, Webknechty, Nachzehrery, Hieny i Węże w okolicy %regiontype% regionu %worldmapregion% (%killcount%/%maxcount%)");
					}
				}
				else if (this.Contract.m.Size == 1)
				{
					this.Contract.m.BulletpointsObjectives.push("Zapoluj na Alpy, Unholdy i Wiedźmy w okolicy %regiontype% regionu %worldmapregion% (%killcount%/%maxcount%)");
				}
				else
				{
					this.Contract.m.BulletpointsObjectives.push("Zapoluj na Schraty i Lindwurmy w okolicy %regiontype% regionu %worldmapregion% (%killcount%/%maxcount%)");
				}

				this.Contract.m.BulletpointsObjectives.push("W dowolnej chwili wróć do %townname% po swą zapłatę");
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home) && this.Flags.get("HeadsCollected") != 0)
				{
					if (this.Contract.m.Size == 0)
					{
						this.Contract.setScreen("SuccessSmall");
					}
					else if (this.Contract.m.Size == 1)
					{
						this.Contract.setScreen("SuccessMedium");
					}
					else
					{
						this.Contract.setScreen("SuccessLarge");
					}

					this.World.Contracts.showActiveContract();
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_killer != null && _killer.getFaction() != this.Const.Faction.Player && _killer.getFaction() != this.Const.Faction.PlayerAnimals)
				{
					return;
				}

				if (this.Flags.get("HeadsCollected") >= this.Contract.m.Payment.MaxCount)
				{
					return;
				}

				if (this.Contract.m.Size == 0)
				{
					if (_actor.getType() == this.Const.EntityType.Ghoul || _actor.getType() == this.Const.EntityType.Direwolf || _actor.getType() == this.Const.EntityType.Spider || _actor.getType() == this.Const.EntityType.Hyena || _actor.getType() == this.Const.EntityType.Serpent)
					{
						this.Flags.set("HeadsCollected", this.Flags.get("HeadsCollected") + 1);
					}
				}
				else if (this.Contract.m.Size == 1)
				{
					if (_actor.getType() == this.Const.EntityType.Alp || _actor.getType() == this.Const.EntityType.Unhold || _actor.getType() == this.Const.EntityType.UnholdFrost || _actor.getType() == this.Const.EntityType.UnholdBog || _actor.getType() == this.Const.EntityType.Hexe)
					{
						this.Flags.set("HeadsCollected", this.Flags.get("HeadsCollected") + 1);
					}
				}
				else if (_actor.getType() == this.Const.EntityType.Lindwurm && !this.isKindOf(_actor, "lindwurm_tail") || _actor.getType() == this.Const.EntityType.Schrat)
				{
					this.Flags.set("HeadsCollected", this.Flags.get("HeadsCollected") + 1);
				}
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
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationPerHead);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "TaskSmall",
			Title = "Negocjacje",
			Text = "[img]gfx/ui/events/event_63.png[/img]{Wchodzisz do komnaty %employer%. Mężczyzna dłubie w palcach piórem pawia, machając jego kolorami na jednym końcu, a drugim wygrzebując brud. Odzywa się do ciebie dość protekcjonalnie.%SPEECH_ON%Moi strażnicy już mi powiedzieli, że interesuje was polowanie na bestie i bardzo się z tego cieszę. Zapłata będzie za głowę. Mniejsze bestie, webknechty, trupożerne rzeczy, takie, z którymi na pewno sobie poradzicie, ale których miejscowi zbyt się boją. Jeśli jesteście tak dobrzy, jak mówią, to nie powinniście zwlekać z przyjęciem oferty. Oczyśćcie moje ziemie z tego. Na początek, widziano je w regionie %worldmapregion% %distance% %direction% stąd.%SPEECH_OFF% | %employer% wita cię w swojej komnacie. Bierze zwój, który krzykacz miejski wręczył ci wcześniej na targu.%SPEECH_ON%Ach, więc jesteś tu w sprawie polowania na bestie. Myślałem, że jesteś rozrywką na...%SPEECH_OFF%Uszczypuje bok twojej koszuli i uśmiecha się krzywo.%SPEECH_ON%Innego rodzaju. Cóż, niezależnie od tego, bestie pustoszą okolicę i chętnie zapłacę ci porządną sumę za pozbycie się ich. Zapłata będzie za głowę, rzecz jasna, a to oznacza spore bogactwo, jeśli tylko utrzymasz ostrze w ruchu. Jeśli potrzebujesz punktu startu, udaj się do regionu %worldmapregion% %distance% %direction% stąd. Znajdziesz tam rozmaite wielkie ośmionożne dziwactwa i kudłate potwory. Cokolwiek przestraszyłoby zwykłego chłopa, ale ciebie raczej nie, ty wielki chłopie.%SPEECH_OFF% | Zastajesz %employer% z bosymi stopami na stole, a wianuszek kobiet zajmuje się ich pielęgnacją. Wydłubują zgrubiały brud spomiędzy palców, jakby to były narodziny jakiejś potwornej larwy. Odchrząkujesz. Mężczyzna odchrząkuje z zaskoczenia.%SPEECH_ON%Ach tak, najemnik. Mam dla ciebie zadanie, jeśli jesteś zainteresowany.%SPEECH_OFF%Z pogardą rzuca zwój pod twoje stopy, gdzie wypisano zapotrzebowanie na ubijanie bestii. Webknechty. Smukłe wilki. Nic strasznego. Notatka na mapie wskazuje pobliski region %worldmapregion% na %direction%. Mężczyzna beka.%SPEECH_ON%Zapłata za głowę, mam nadzieję, że ci to pasuje.%SPEECH_OFF% | Zastajesz %employer% obracającego w dłoni stylisko. Granica między rękojeścią a miejscem, gdzie powinna być głownia, jest wyraźnie rozszczepiona, co świadczy o definitywnym końcu użyteczności broni. Mężczyzna rzuca ją na stół i otrzepuje dłonie z trocin.%SPEECH_ON%Bestie krążą po tych ziemiach i potrzebuję kogoś z twojego kręgu, żeby je wszystkie ubił. Co ty na to, hm? Zapłata będzie za głowę. Na początek polowania udaj się do regionu %worldmapregion% na %direction%. Wszelkiego rodzaju pomniejsze bestie są tam utrapieniem.%SPEECH_OFF% | %employer% wita cię w swojej komnacie. Jego stół przykryty jest zwojami, na których widnieją rysunki zwierząt, bestii, a być może i potworów. Żuje jakieś jagody, spluwając sokiem, gdy mówi.%SPEECH_ON%Miejscowi mówią, że coś plugawi się dzieje, choć żaden nie potrafi mi opisać, z czym dokładnie mamy do czynienia. Coś o potwornych wilkach albo ośmionożnych kreaturach. Nie mogę stać bezczynnie, więc proszę o twoje usługi. Udaj się do lenna %worldmapregion% %distance% %direction%. Jeśli zobaczysz bestie, zabij je na miejscu i zabierz ich głowy. Zapłacę za skalp.%SPEECH_OFF% | %employer% spotyka się z tobą podczas narady z grupą chłopów. Stwierdza, że rzekome potwory rozszarpują okoliczne pustkowia. Jeden z chłopów wtrąca się.%SPEECH_ON%Bestie, wszystkie jak jedna. Wilki chodzące na tylnych łapach, pająki wielkie jak stodoła, trupożerne rzeczy śmierdzące szlamem.%SPEECH_OFF%Szlachcic macha ręką.%SPEECH_ON%Tak, tak, wystarczy. Najemniku, potrzebuję, byś wyruszył i upolował te stworzenia. Zacznij od podróży do regionu %worldmapregion% na %direction% stąd i dopilnuj, by wszelkie bestie na ziemi zostały położone do piachu. Ale pamiętaj, przynieś ich głowy, zapłacę za każdą. To znaczy, jeśli jesteś zainteresowany, rzecz jasna.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{O ilu konkretnie koronach mówimy? | Można mnie przekonać za odpowiednia cenę. | Mów dalej. | Ile jest dla ciebie warte bezpieczeństwo twych podwładnych?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Zbyt dużo chodzenia jak na mój gust. | Nie mamy zamiaru polować na duchy w regionie %worldmapregion%. | Nie tego typu roboty szukamy.}",
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
			ID = "TaskMedium",
			Title = "Negocjacje",
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer% przewraca kartki tomu, gdy wchodzisz. Podnosi wzrok i kiwa, byś podszedł.%SPEECH_ON%Przynieś świecę.%SPEECH_OFF%Zdejmujesz ze ściany pochodnię, a szlachcic rozkłada ręce.%SPEECH_ON%Mówiłem świecę, nie cholerną pochodnię! Co ty chcesz zrobić, spalić wszystkie moje księgi na popiół? Stań tam, gdzie jesteś. Słuchaj, ludzie z okolicy mówią o złach, o których nie słyszałem od lat. Potwory żerujące na snach, olbrzymy tak wielkie, że człowiek zmieściłby się w ich brodach, i najgorsze z nich, rzecz jasna, piękne kobiety, które wiedzą, że są piękne.%SPEECH_OFF%Nie jesteś pewien co do ostatniego, ale nie komentujesz. Szlachcic wyjaśnia dalej, że masz ubić każdego z tych kretynów, których znajdziesz w jego włościach. Widziano je w okolicy %worldmapregion% na %direction%, ale możesz polować, gdzie tylko zechcesz. | Zastajesz %employer% na naradzie z grupą mężczyzn w czarnych płaszczach. Wzywają cię, co niechętnie czynisz. Szlachcic pyta, czy znasz potwory takie jak unholdy albo stworzenia żywiące się snami. Zanim odpowiesz, macha ręką.%SPEECH_ON%Nieważne. Potrzebuję uzbrojonych ludzi, by przeczesać region %worldmapregion% %direction% stąd i sprawdzić, czy nie dzieje się tam coś dziwnego. Jeśli to nie człowiek z bijącym sercem, zabij to. Zabierz głowę. I wróć do mnie. Zapłacę hojnie za każdy skalp. Jeśli w ogóle istnieją.%SPEECH_OFF% | %employer% waży zwoje w obu dłoniach, nie czytając żadnego, a wpatrując się w trzeci na biurku. W końcu odrzuca dwa i zgarnia trzeci. Patrzy na ciebie.%SPEECH_ON%Rozchodzą się wieści o potworach. Olbrzymi ludzie zjadający bydło i dzieci. Mam raporty o ludziach cierpiących na koszmary i zabijających sąsiadów. A do tego krążą plotki o pięknej kobiecie w tych okolicach. Nie wiem, czy to jakaś plugawa kreatura, ale piękna kobieta zamieszkująca %worldmapregion% na %direction% stąd brzmi dla mnie jak kłopoty.%SPEECH_OFF%Kiwasz głową. Samotna kobieta w dziwnym miejscu to na pewno kłopot dla kogoś. Szlachcic rozkłada ręce.%SPEECH_ON%Zabierzesz swoich ludzi do tej krainy i znajdziesz granicę między prawdą a zmyśleniem? A jeśli natkniesz się na coś, co się ślizga, syczy lub jest w inny sposób nieludzkie, zabij to cholerstwo i przynieś mi jego głowę.%SPEECH_OFF% | Zastajesz %employer% pochylonego nad księgami, z świecą tak blisko stron, że półmrok blednie na krawędziach tomu. Jakby tylko on miał prawo czytać te teksty. Widząc cię, macha, byś podszedł.%SPEECH_ON%Mam raporty o dziwnych zdarzeniach w regionie %worldmapregion% na %direction%. Liczba morderstw rośnie i niech mnie diabli, jeśli wiem czemu. A do tego ludzie po prostu znikają. Nigdy to nie jest dobry znak. Nie wiem, czy odpowiada za to kult czy kreatura, ale potrzebuję uzbrojonych ludzi, by poszli tam i zrobili porządek. Jeśli skrzyżujesz stal z czymś z innego świata, przynieś mi jego głowę - za coś takiego zapłacę hojnie.%SPEECH_OFF% | Zastajesz %employer% na szczycie drabiny, przetrząsającego najwyższą półkę. Kręci głową i zaprasza cię gestem.%SPEECH_ON%Nie mam pieprzonego pojęcia, czego szukam.%SPEECH_OFF%Kiwasz głową i mówisz, żeby dołączył do klubu. Mężczyzna schodzi.%SPEECH_ON%Bardzo zabawne, najemniku. Słuchaj, dochodzą mnie wieści o chaosie w regionie %worldmapregion% %distance% %direction% stąd. Niewielu tam mieszka, ale ci, którzy mieszkają, mówią o absolutnych horrorach kroczących po ziemi. Olbrzymi ludzie, duchy nawiedzające sny, co tylko zechcesz. Potrzebuję, byś zabrał swoją bandę i uciszył to, co \'bulgocze i wrze\', tak? I przynieś mi głowy wszelkich nieludzkich potworności, które znajdziesz. Zapłacę dobrze za każdą.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{O ilu konkretnie koronach mówimy? | Można mnie przekonać za odpowiednia cenę. | Mów dalej. | Ile jest dla ciebie warte bezpieczeństwo twych podwładnych?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Zbyt dużo chodzenia jak na mój gust. | Nie mamy zamiaru polować na duchy w regionie %worldmapregion%. | Nie tego typu roboty szukamy.}",
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
			ID = "TaskLarge",
			Title = "Negocjacje",
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer% siedzi przy biurku. W pomieszczeniu nie ma nikogo więcej. Proponuje miejsce, które zajmujesz. Pochyla się do przodu.%SPEECH_ON%Moja rodzina ma pewną legendę. Mój ojciec natknął się na tę legendę, i ojciec mojego ojca. Nie wiemy, skąd się wzięła. Spodziewałem się zobaczyć ją za swoich czasów i czuję, że już ją zobaczyłem. We śnie, zeszłej nocy.%SPEECH_OFF%Słysząc to, siedzisz na skraju krzesła, bo środek ma dziurę. Kiwasz głową, a on mówi dalej.%SPEECH_ON%Udaj się do %worldmapregion% na %direction%. Wierzę, że legendy są prawdziwe, że po tych ziemiach krąży ogromna bestia. Może nawet więcej niż jedna! Niezależnie od liczby, potrzebuję najbardziej doświadczonych najemników, by ją wytropić. Przynieś mi głowy, a zostaniesz sowicie nagrodzony. Zgadzasz się?%SPEECH_OFF% | Wchodzisz do komnaty %employer%. Podsuwa ci zwój, na którym widnieje alfabet, którego nie potrafisz odczytać. Szlachcic mówi, że to fragment legendy. Rozkłada ramiona.%SPEECH_ON%Bestie wielkości drzew włóczą się po tych ziemiach, wierzę w to. Na %direction% stąd leży region %worldmapregion%. Chłopi mówią o wielkich potwornościach, w które byś nie uwierzył. A ja chciałbym uwierzyć. Chciałbym zobaczyć jedną z bliska, dlatego cię tu wezwałem. Idź na te ohydne ziemie i dopilnuj, by każda istota z innego świata została zabita, a jej głowa spoczęła u mych stóp.%SPEECH_OFF% | %employer% wita cię w swojej komnacie i od razu przechodzi do rzeczy.%SPEECH_ON%Chcę, żebyś ruszył na %direction% do regionu %worldmapregion%. Zanotowałem wiele plotek o ogromnych bestiach błąkających się po tych ziemiach i wierzę w każde słowo. Węże wielkości drzew i drzewne podróbki też wielkości drzew! Czymkolwiek do cholery są, chcę, żebyś je zabił i przyniósł mi ich głowy. Albo łuski, gałęzie, cokolwiek. Zapłacę za każdą sztukę, którą przyniesiesz. Interesuje cię to?%SPEECH_OFF% | %employer% podaje ci tom z pozaginanymi stronami. Uważasz to za niebezpieczną zniewagę dla materiału, który jest zdecydowanie rzadki, ale gryzesz się w język. Szlachcic pyta, czy znasz olbrzymów, smoki, potwory morskie i tym podobne. Zanim odpowiesz, %employer% kładzie palec na otwartej stronie. Jego kostka opiera się o rysunek bestii wyższej niż dąb, częściowo dlatego, że wygląda jak dąb.%SPEECH_ON%Myślę, że istnieją. Myślę, że są tam w %worldmapregion% właśnie teraz, na %direction% stąd. Najemniku, chcę, byś tam poszedł i zabił każdą plugawą kreaturę, którą znajdziesz. Przynieś mi ich głowy. Nie da się zmierzyć niebezpieczeństwa, ale ogromne nagrody już tak. Uważasz się za zdolnego?%SPEECH_OFF% | %employer% wita cię z miną człowieka, który ma wysłać kogoś na pewną zgubę. Uśmiecha się jednak, bo to nie jego zguba.%SPEECH_ON%Ach, dobrze widzieć człowieka miecza. Jak zapewne słyszałeś, plotki huczą o regionie %worldmapregion% będącym absolutnie brzemiennym w plugawą zwierzynę.%SPEECH_OFF%Nie jesteś pewien, czy tak byś to ujął, ale kiwasz głową. Szlachcic kiwa w odpowiedzi.%SPEECH_ON%Mam niewielu ludzi, którym ufam, a jeden z nich niedawno doniósł, że widział stworzenie o niewyobrażalnych rozmiarach, choć ocenił je na wysokość drzewa. A inny zwiadowca mówił, że po okolicy pełzały węże wielkości smoków. Cokolwiek tam jest, potrzebuję, byś udał się na ziemie %direction% stąd i zabił to, co je nawiedza. Według raportów może to być najniebezpieczniejsza rzecz, jaką zrobisz w tym życiu. Jesteś gotów? Twoi ludzie są gotowi? Nie zatrudnię kogoś, kto się choćby zawaha.%SPEECH_OFF%}  ",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{O ilu konkretnie koronach mówimy? | Nie jest to mała prośba. | Można mnie przekonać za odpowiednia cenę. | Za takie zadanie lepiej żeby zapłata była dobra. | Ile jest dla ciebie warte bezpieczeństwo twych podwładnych?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Nie mamy zamiaru polować na duchy w regionie %worldmapregion%. | Nie tego typu roboty szukamy. | Nie będę ryzykował całej kompanii przeciwko takiemu wrogowi.}",
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
			ID = "SuccessSmall",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Wracasz i zrzucasz bestialskie głowy na podłogę %employer%a. Ten podnosi wzrok znad biurka.%SPEECH_ON%To było niepotrzebne. Dajcie temu człowiekowi pieniądze i sprowadźcie sługę, żeby posprzątał ten bałagan.%SPEECH_OFF% | %employer% wita twój powrót, choć trzyma dystans. Wpatruje się w twój ładunek.%SPEECH_ON%Stosowny powrót, najemniku. Każę jednemu z moich ludzi policzyć głowy i zapłacić ci zgodnie z umową.%SPEECH_OFF% | Przynosisz dowody ubicia na zadowolenie %employer%a. Kiwa głową i odprawia cię.%SPEECH_ON%Doceniam, ale nie muszę dłużej patrzeć na te upiorne rzeczy. %randomname%, chodź tu i zapłać temu najemnikowi.%SPEECH_OFF% | %employer% wita cię z powrotem i ogląda twój towar.%SPEECH_ON%Absolutnie obrzydliwe. Wspaniale! Oto twoja zapłata, jak uzgodniono.%SPEECH_OFF% | Pokazujesz głowy %employer%owi, który liczy je drgającym palcem, a jego usta szepczą liczby. W końcu się prostuje.%SPEECH_ON%Nie mam na to czasu. %randomname%, tak ty, sługo, podejdź tu, policz te głowy i zapłać najemnikowi uzgodnioną kwotę za każdą.%SPEECH_OFF% | %employer% je jabłko, gdy podchodzi zobaczyć, co przyniosłeś. Wpatruje się w torbę z ohydnymi bestialskimi głowami. Bierze ogromny kęs jabłka.%SPEECH_ON%Ihmponujące rehzultaty, najehmniku.%SPEECH_OFF%Szybko przeżuwa i połyka wielkim łykiem.%SPEECH_ON%Widzisz tam mojego sługę z sakiewką. Wypłaci ci należność.%SPEECH_OFF%Szlachcic rzuca niedojedzone jabłko i bierze kolejne. | %employer% ma przy sobie dziecko, gdy wchodzisz do jego komnaty. Dzieciak biegnie zobaczyć, co przyniosłeś, po czym ucieka z krzykiem. Szlachcic kiwa głową.%SPEECH_ON%To chyba znaczy, że masz to, za co ci płaciłem. Mój sługa %randomname% policzy głowy i wypłaci to, co ci się należy.%SPEECH_OFF% | Taszczysz głowy do komnaty %employer%a. Unosi brew.%SPEECH_ON%Musiałeś je targać aż tutaj? Spójrz, zostawiłeś plamę! Czemu po prostu nie sprowadziłeś sługi, od tego są. Na starych bogów, smród jest gorszy niż plamy!%SPEECH_OFF%Szlachcic pstryka palcami do mężczyzny stojącego z sakiewką.%SPEECH_ON%%randomname%, policz głowy i dopilnuj, by najemnik dostał zapłatę.%SPEECH_OFF% | Rozwijasz worek z głowami i pozwalasz im zsunąć się na podłogę %employer%a. Ten wstaje.%SPEECH_ON%To nie na dywanie, prawda?%SPEECH_OFF%Sługa podbiega i rozrzuca głowy na boki. Szybko kręci głową, że nie. Szlachcic kiwa głową i powoli siada.%SPEECH_ON%Dobrze. Ty tam, %randomname%, zacznij liczyć i zapłać temu bałaganiarzowi to, co mu się należy. A tak przy okazji, najemniku, następnym razem lżej z tą prezentacją, dobra?%SPEECH_OFF% | Wnosisz sakiewkę ze skórami i głowami bestii do komnaty %employer%a. Otwierasz wieko i zaczynasz przechylać torbę. Oczy sługi robią się wielkie, rzuca się do przodu, wpada w torbę i odchyla ją z powrotem. Wieko zamyka się z trzaskiem na jego palcach, a on dusi krzyk.%SPEECH_ON%Dziękuję, najemniku, ale szlachetny pan woli, byśmy policzyli to bez wysypywania wszystkiego na podłogę. Zsumuję całość i zapłacę, gdy skończę.%SPEECH_OFF% | %employer% przegląda twoje dzieło.%SPEECH_ON%Imponujące. Obrzydliwe. Nie ty, bestie. To znaczy, jesteś plugawy, najemniku, ale te paskudne bestie są przeciwieństwem higieny.%SPEECH_OFF%Nie wiesz, co znaczy to słowo, ani to drugie. Po prostu prosisz, by policzył głowy i dał ci należność. | %employer% liczy głowy, po czym odchyla się. Wzrusza ramionami.%SPEECH_ON%Myślałem, że będą straszniejsze.%SPEECH_OFF%Wspominasz, że wpływają na odwagę inaczej, gdy są jeszcze przyczepione do bestialskich tułowi. Szlachcic wzrusza ramionami ponownie.%SPEECH_ON%Może i tak, ale mojej matce kat uciął głowę i wyglądała znacznie straszniej, siedząc w koszu i gapiąc się na świat.%SPEECH_OFF%Nie wiesz, co na to powiedzieć. Prosisz, by zapłacił to, co ci się należy. | %employer% przygląda się bestialskim głowom, które złożyłeś na jego podłodze. Sługa z miotłą liczy je po kolei, odejmując z jednego stosu i dodając do drugiego. Gdy kończy rachunek, melduje liczby, a szlachcic kiwa głową.%SPEECH_ON%Dobra robota, najemniku. Sługa przyniesie twoją zapłatę.%SPEECH_OFF%Niskourodzony wzdycha i odkłada miotłę. | %employer% otwiera sakwę z bestialskimi skórami i czaszkami. Marszczy usta, wącha i zatrzaskuje ją z powrotem. Szlachcic poleca jednemu ze sług policzyć szczątki i zapłacić ci zgodnie z umową.%SPEECH_ON%Dobra robota, najemniku. Mieszkańcy są wdzięczni, że zapłaciłem ci za uporanie się z tym.%SPEECH_OFF% | %employer% gwiżdże, wpatrując się w twoją kolekcję czaszek i skór.%SPEECH_ON%To dopiero westchnienie, jeśli kiedykolwiek było. Za robotę tej paskudnej natury powinienem rozważyć dodatkową zapłatę, czego nie zrobię, ale taka myśl mi przyszła i to się naprawdę liczy.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Udane polowanie.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.Assets.addMoney(this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected"));
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Zapolowałeś na bestie w pobliżu " + this.World.State.getRegion(this.Flags.get("Region")).Name);
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
			}

		});
		this.m.Screens.push({
			ID = "SuccessMedium",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Wracasz i zrzucasz bestialskie głowy na podłogę %employer%a. Ten podnosi wzrok znad biurka.%SPEECH_ON%To było niepotrzebne. Dajcie temu człowiekowi pieniądze i sprowadźcie sługę, żeby posprzątał ten bałagan.%SPEECH_OFF% | %employer% wita twój powrót, choć trzyma dystans. Wpatruje się w twój ładunek.%SPEECH_ON%Stosowny powrót, najemniku. Każę jednemu z moich ludzi policzyć głowy i zapłacić ci zgodnie z umową.%SPEECH_OFF% | Przynosisz dowody ubicia na zadowolenie %employer%a. Kiwa głową i odprawia cię.%SPEECH_ON%Doceniam, ale nie muszę dłużej patrzeć na te upiorne rzeczy. %randomname%, chodź tu i zapłać temu najemnikowi.%SPEECH_OFF% | %employer% wita cię z powrotem i ogląda twój towar.%SPEECH_ON%Absolutnie obrzydliwe. Wspaniale! Oto twoja zapłata, jak uzgodniono.%SPEECH_OFF% | Pokazujesz głowy %employer%owi, który liczy je drgającym palcem, a jego usta szepczą liczby. W końcu się prostuje.%SPEECH_ON%Nie mam na to czasu. %randomname%, tak ty, sługo, podejdź tu, policz te głowy i zapłać najemnikowi uzgodnioną kwotę za każdą.%SPEECH_OFF% | %employer% je jabłko, gdy podchodzi zobaczyć, co przyniosłeś. Wpatruje się w torbę z ohydnymi bestialskimi głowami. Bierze ogromny kęs jabłka.%SPEECH_ON%Ihmponujące rehzultaty, najehmniku.%SPEECH_OFF%Szybko przeżuwa i połyka wielkim łykiem.%SPEECH_ON%Widzisz tam mojego sługę z sakiewką. Wypłaci ci należność.%SPEECH_OFF%Szlachcic rzuca niedojedzone jabłko i bierze kolejne. | %employer% ma przy sobie dziecko, gdy wchodzisz do jego komnaty. Dzieciak biegnie zobaczyć, co przyniosłeś, po czym ucieka z krzykiem. Szlachcic kiwa głową.%SPEECH_ON%To chyba znaczy, że masz to, za co ci płaciłem. Mój sługa %randomname% policzy głowy i wypłaci to, co ci się należy.%SPEECH_OFF% | Taszczysz głowy do komnaty %employer%a. Unosi brew.%SPEECH_ON%Musiałeś je targać aż tutaj? Spójrz, zostawiłeś plamę! Czemu po prostu nie sprowadziłeś sługi, od tego są. Na starych bogów, smród jest gorszy niż plamy!%SPEECH_OFF%Szlachcic pstryka palcami do mężczyzny stojącego z sakiewką.%SPEECH_ON%%randomname%, policz głowy i dopilnuj, by najemnik dostał zapłatę.%SPEECH_OFF% | Rozwijasz worek z głowami i pozwalasz im zsunąć się na podłogę %employer%a. Ten wstaje.%SPEECH_ON%To nie na dywanie, prawda?%SPEECH_OFF%Sługa podbiega i rozrzuca głowy na boki. Szybko kręci głową, że nie. Szlachcic kiwa głową i powoli siada.%SPEECH_ON%Dobrze. Ty tam, %randomname%, zacznij liczyć i zapłać temu bałaganiarzowi to, co mu się należy. A tak przy okazji, najemniku, następnym razem lżej z tą prezentacją, dobra?%SPEECH_OFF% | Wnosisz sakiewkę ze skórami i głowami bestii do komnaty %employer%a. Otwierasz wieko i zaczynasz przechylać torbę. Oczy sługi robią się wielkie, rzuca się do przodu, wpada w torbę i odchyla ją z powrotem. Wieko zamyka się z trzaskiem na jego palcach, a on dusi krzyk.%SPEECH_ON%Dziękuję, najemniku, ale szlachetny pan woli, byśmy policzyli to bez wysypywania wszystkiego na podłogę. Zsumuję całość i zapłacę, gdy skończę.%SPEECH_OFF% | %employer% przegląda twoje dzieło.%SPEECH_ON%Imponujące. Obrzydliwe. Nie ty, bestie. To znaczy, jesteś plugawy, najemniku, ale te paskudne bestie są przeciwieństwem higieny.%SPEECH_OFF%Nie wiesz, co znaczy to słowo, ani to drugie. Po prostu prosisz, by policzył głowy i dał ci należność. | %employer% liczy głowy, po czym odchyla się. Wzrusza ramionami.%SPEECH_ON%Myślałem, że będą straszniejsze.%SPEECH_OFF%Wspominasz, że wpływają na odwagę inaczej, gdy są jeszcze przyczepione do bestialskich tułowi. Szlachcic wzrusza ramionami ponownie.%SPEECH_ON%Może i tak, ale mojej matce kat uciął głowę i wyglądała znacznie straszniej, siedząc w koszu i gapiąc się na świat.%SPEECH_OFF%Nie wiesz, co na to powiedzieć. Prosisz, by zapłacił to, co ci się należy. | %employer% przygląda się bestialskim głowom, które złożyłeś na jego podłodze. Sługa z miotłą liczy je po kolei, odejmując z jednego stosu i dodając do drugiego. Gdy kończy rachunek, melduje liczby, a szlachcic kiwa głową.%SPEECH_ON%Dobra robota, najemniku. Sługa przyniesie twoją zapłatę.%SPEECH_OFF%Niskourodzony wzdycha i odkłada miotłę. | %employer% otwiera sakwę z bestialskimi skórami i czaszkami. Marszczy usta, wącha i zatrzaskuje ją z powrotem. Szlachcic poleca jednemu ze sług policzyć szczątki i zapłacić ci zgodnie z umową.%SPEECH_ON%Dobra robota, najemniku. Mieszkańcy są wdzięczni, że zapłaciłem ci za uporanie się z tym.%SPEECH_OFF% | %employer% gwiżdże, wpatrując się w twoją kolekcję czaszek i skór.%SPEECH_ON%To dopiero westchnienie, jeśli kiedykolwiek było. Za robotę tej paskudnej natury powinienem rozważyć dodatkową zapłatę, czego nie zrobię, ale taka myśl mi przyszła i to się naprawdę liczy.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Udane polowanie.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.Assets.addMoney(this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected"));
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Zapolowałeś na bestie w pobliżu " + this.World.State.getRegion(this.Flags.get("Region")).Name);
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
			}

		});
		this.m.Screens.push({
			ID = "SuccessLarge",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Taszczysz szczątki z polowania do komnaty %employer%a. Ten odskakuje, jakbyś ujarzmił bestię i dosiadł jej, by podbić świat. Ściskając się za pierś, szlachcic z powrotem siada.%SPEECH_ON%Na starych bogów, najemniku, gdybyś nie był takim głupcem, zostawiłbyś to na dziedzińcu i sprowadził mnie na dół.%SPEECH_OFF%Wzruszasz ramionami i pytasz o zapłatę. On pyta, jak ją zabiłeś. Wracasz do kwestii zapłaty. Szlachcic zaciska wargi.%SPEECH_ON%Dobrze. Sługo! Daj temu uparciuchowi, pogromcy bestii, jego monetę.%SPEECH_OFF% | Wleczesz bestialskie szczątki na dziedziniec i wołasz %employer%a. Ten podchodzi do okna i długo patrzy w dół.%SPEECH_ON%Prawdziwe czy robisz sobie żarty?%SPEECH_OFF%Wzdychając, dobywasz miecza i wbijasz go w wielkie oko. Z cichym pyknięciem zapada się i tryska żółtą mazią na ziemię. Szlachcic gwiżdże i cmoka językiem.%SPEECH_ON%Na starych bogów, ty naprawdę to zrobiłeś! Każę słudze przynieść twoją zapłatę natychmiast!%SPEECH_OFF% | Zaprzęgasz osła do pomocy i każesz mu wciągnąć do miasta zabitą potworność. Przygląda się swojemu krzywemu, nieziemskiemu ładunkowi ruchem ucha i niemym spojrzeniem. %employer% wychodzi przed swoje włości. Staje obok monstrualnych szczątków z brodą wspartą na zgiętym palcu i kciuku.%SPEECH_ON%Niesamowite. Nie potrafię sobie wyobrazić, jak wyglądało, gdy żyło i walczyło.%SPEECH_OFF%Kiwasz głową i dajesz mu do zrozumienia, że gdzieś tam na pewno są podobne, więc powinien pójść z tobą następnym razem. Kręci głową.%SPEECH_ON%Zrezygnuję z tej propozycji, najemniku. Oto twoja zapłata i rozkazuję ci oddać tego osła właścicielowi.%SPEECH_OFF%Do przodu wychodzi chłop, wycierając czoło szmatą.%SPEECH_ON%To się nazywa muł i gdybyś chciał pożyczyć to cholerstwo, to mogłeś po prostu zapytać!%SPEECH_OFF% | Rozrąbujesz bestialskie szczątki i wnosisz je po kawałku do komnaty %employer%a. Ten przykłada szmatę do nosa, gdy zwłoki się piętrzą.%SPEECH_ON%Czyli mity są prawdziwe. Bestie istnieją.%SPEECH_OFF%Kilku sług składa kawałki z powrotem, tworząc zniekształcony obraz potworności, który rozsuwa się za każdym razem, gdy puszczają ręce. Szlachcic kiwa głową i pstryka palcami.%SPEECH_ON%Dajcie najemnikowi zapłatę i sprowadźcie moich doradców.%SPEECH_OFF% | Jeden ze sług %employer%a stoi z rylcem, gotów kuć w bestialskich szczątkach. Szczerzy się szeroko i dziko.%SPEECH_ON%Rodowe nazwisko można wykuć w kości i użyć jako styliska do topora albo miecza.%SPEECH_OFF%Mówisz obu mężczyznom, że nie tkną tego cholerstwa, dopóki ci nie zapłacą. Szlachcic uśmiecha się szerzej.%SPEECH_ON%Nie ma potrzeby się unosić, najemniku. Sługa już przynosi twoją zapłatę. A jeśli jeszcze raz ośmielisz się odezwać takim tonem, wyrwę ci język, pogromco potworów czy nie.%SPEECH_OFF%Okazujesz cierpliwość dłonią spoczywającą na głowicy i odliczaniem w myślach. Na szczęście dla wszystkich sługa przybywa, zanim licznik dobije do zera. | %employer% klaszcze jak dziecko na widok bestialskich szczątków.%SPEECH_ON%Opowieści o moich dokonaniach będą wspaniałe. Z tych kości zrobię styliska i rękojeści i będę opowiadał, jak zdobyłem potworne głowy.%SPEECH_OFF%Kiwasz głową. Brzmi świetnie. I tak księgi historii nie zamierzały zapisać twojego imienia. Prosisz o zapłatę. Szlachcic kiwa głową, nie odrywając wzroku od stworzenia, i pstryka palcami.%SPEECH_ON%Słudzy! Dajcie temu człowiekowi jego monetę!%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Udane polowanie.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.Assets.addMoney(this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected"));
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Zapolowałeś na bestie w pobliżu " + this.World.State.getRegion(this.Flags.get("Region")).Name);
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
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		local dest = this.World.State.getRegion(this.m.Flags.get("Region")).Center;
		local distance = this.World.State.getPlayer().getTile().getDistanceTo(dest);
		distance = this.Const.Strings.Distance[this.Math.min(this.Const.Strings.Distance.len() - 1, distance / 30.0 * (this.Const.Strings.Distance.len() - 1))];
		_vars.push([
			"killcount",
			this.m.Flags.get("HeadsCollected")
		]);
		_vars.push([
			"noblehousename",
			this.World.FactionManager.getFaction(this.m.Faction).getNameOnly()
		]);
		_vars.push([
			"worldmapregion",
			this.World.State.getRegion(this.m.Flags.get("Region")).Name
		]);
		_vars.push([
			"direction",
			this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(dest)]
		]);
		_vars.push([
			"distance",
			distance
		]);
		_vars.push([
			"regiontype",
			this.Const.Strings.TerrainShort[this.World.State.getRegion(this.m.Flags.get("Region")).Type]
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		return true;
	}

	function onIsTileUsed( _tile )
	{
		return false;
	}

	function onSerialize( _out )
	{
		_out.writeU8(this.m.Size);
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.m.Size = _in.readU8();
		this.contract.onDeserialize(_in);
	}

});

