this.hunting_sand_golems_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_sandgolems";
		this.m.Name = "Zmienne Piaski";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 850 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Zapoluj na to, co zabija ludzi na pustyni w pobliżu " + this.Contract.m.Home.getName()
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 10 && this.Contract.getDifficultyMult() >= 1.15)
				{
					this.Flags.set("IsEarthquake", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = i )
				{
					if (i == this.Const.World.TerrainType.Desert)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}

					i = ++i;
				}

				local playerTile = this.World.State.getPlayer().getTile();
				local mapSize = this.World.getMapSize();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 8, 12, disallowedTerrain);
				local party;
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Ifrity", false, this.Const.World.Spawn.SandGolems, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.setDescription("Istoty z żywego kamienia, ukształtowane przez piekielny gorąc oraz ogień płonącego słońca południa.");
				party.setFootprintType(this.Const.World.FootprintsType.SandGolems);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);

				for( local i = 0; i < 1; i = i )
				{
					local nearTile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10, disallowedTerrain);

					if (nearTile != null)
					{
						this.Const.World.Common.addFootprintsFromTo(nearTile, party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.SandGolems, 0.75);
					}

					i = ++i;
				}

				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Home);
				roam.setMinRange(8);
				roam.setMaxRange(12);
				roam.setNoTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Desert, true);
				c.addOrder(roam);
				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					this.Contract.setScreen("Victory");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsBanterShown") && this.Contract.m.Target.isHiddenToPlayer() && this.Math.rand(1, 1000) <= 1 && this.Flags.get("StartTime") + 10.0 <= this.Time.getVirtualTimeF())
				{
					local tileType = this.World.State.getPlayer().getTile().Type;

					if (tileType == this.Const.World.TerrainType.Desert)
					{
						this.Flags.set("IsBanterShown", true);
						this.Contract.setScreen("Banter");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsEarthquake"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Earthquake");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						this.World.Contracts.startScriptedCombat(properties, false, true, true);
					}
				}
				else if (!this.Flags.get("IsEncounterShown"))
				{
					this.Flags.set("IsEncounterShown", true);
					this.Contract.setScreen("Encounter");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
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
			Text = "[img]gfx/ui/events/event_162.png[/img]{%employer% podnosi głowę i zdaje się lustrować cię znad nosa. To potężny grymas pogardy, ale jednak wpuszcza cię do środka. Wezyr klaszcze w dłonie, podchodzi sługa ze zwojem, rozwija go i czyta.%SPEECH_ON%W piaskach widziano Ifryty. Koronnik - to ty, wędrowcze - ma...%SPEECH_OFF%Wezyr klaszcze ponownie.%SPEECH_ON%To może być on, sługo. TO może być on. Uważaj na swoje rozróżnienia.%SPEECH_OFF%Wiesz, że sługa chciałby powiedzieć, że nie on pisał zwój, ale zachowuje to dla siebie. Kończy ogłoszenie.%SPEECH_ON%...ma zostać zachęcony do odesłania palących piasków do ich naturalnego stanu. Anihilacja tych potworów zostanie wynagrodzona %reward% koronami.%SPEECH_OFF%Zwój zwija się, sługa łapie go po bokach i wysuwa się z pola widzenia. Znów widzisz wezyra, ale nie zwraca uwagi, bo niewolnica karmi go winogronami. | Wezyr imieniem %employer% wita cię, choć cała gracja spotkania jest całkowicie poświęcona biurokratycznej stronie rozmowy.%SPEECH_ON%Koronniku, Ifryty krążą po piaskach. Twoje usługi zostały wezwane, by się z tym uporać. Jeśli nie zgodzisz się na wynagrodzenie %reward% koron, wezwemy innego na twoje miejsce.%SPEECH_OFF% | Wchodzisz do pokoju i widzisz kilku wezyrów przygniecionych ciałami niewolnic. Jest dużo chichotu i psotnego szarpania skóry, ale co ważniejsze, nikt nie zdaje się zauważać twojej obecności. Poza starszym mężczyzną, który podchodzi i kłania się.%SPEECH_ON%Koronniku, wezyr %employer% wezwał koronika do zadania polowania na Ifryty.%SPEECH_OFF%Starszy mężczyzna zerka w bok, po czym prostuje się. Gdy mówi ponownie, nie ma w tym już wysokich, pompatycznych bzdur.%SPEECH_ON%To wielkie, piaszczyste dranie i rozszarpują okolicę. Ostrzegam, że nie można ich lekceważyć, więc nie daj się zwieść temu pokazowi przepychu i złota, by brać się za coś, czego nie powinieneś. Jeśli się zgodzisz, na stole leży %reward% koron.%SPEECH_OFF%Prostując się i odchrząkując, starzec głośno pyta.%SPEECH_ON%Czy przyjmujesz wezwanie?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Zaciekawiłeś mnie, mów dalej. | Polowanie na takiego wroga tanie nie będzie. | To będzie cię kosztować. | Polowanie na fatamorgany na pustyni. Czego tu nie lubić? | Nasza kompania może pomóc, za odpowiednią cenę.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{To nie brzmi jak robota dla nas. | Nie zamierzam ze swymi ludźmi szukać wiatru w polu.  | Nie sądzę. | Nie. Moi ludzie wolą znanych wrogów z krwi i kości.}",
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
			ID = "Banter",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_161.png[/img]{Podczas tropienia tajemniczych Ifrytów spotykasz starą wiedźmę, której stopy są jak skóra. Kłania się, gdy się pojawiasz.%SPEECH_ON%Ach, niewolnicy monety, to Ifrytów szukacie, tak? Oczywiście. Widzę to po waszych twarzach.%SPEECH_OFF%Zatrzymuje się i wskazuje wydmy, w których kierunku zmierzasz.%SPEECH_ON%Jesteśmy z tej ziemi, rozumiesz? Jesteśmy z nią jednością i kiedy wypędzamy, krzywdzimy i jesteśmy okrutni wobec siebie, piaski stają po stronie tych, którym wyrządzono krzywdę. Nie bój się potwora, lecz powodu, który go stworzył, bo ten powód przenika te piaski, a w tym rozumowaniu zabijesz tylko jednego potwora, nie soląc wód, z których rodzi się na wieki.%SPEECH_OFF% | Natrafiasz na studnię na pustyni. Mężczyzna oferuje ci kilka wiader ochłody, twierdząc, że woda pod spodem jest niewyczerpana. Nie widać żadnej farmy, więc masz powody sądzić, że wody starczyłoby, by gasić pragnienie przez wieki. Mężczyzna zdaje się jednak wyczuwać, że macie tu inny cel.%SPEECH_ON%Domyślam się, że szukacie Ifrytów, prawda?%SPEECH_OFF%Przytakujesz i pytasz, skąd to wie. Uśmiecha się.%SPEECH_ON%Bo je widziałem i widziałem, co zrobiły. Wiedziałem, że niedługo pojawi się zawodowa armia albo niewolnik korony, by rozstrzygnąć ich spory. Ifryt jest potworem zemsty i ulegnie tylko temu, co wywabiło go z ziemi: okrucieństwu.%SPEECH_OFF%Dokańczając napój, dziękujesz nieznajomemu za słowa i ruszasz dalej. | Kilka zwłok w piasku. Niektóre zsunęły się do połowy wydmy. Inna leży u podstawy, kolejna daleko od niej. Jakby zostały tam wyrzucone. Piaski odsłaniające ciała sugerują, że śmierć była niedawno. Wygląda na to, że coś, co zaatakowało ludzi, zmiażdżyło ich z niewiarygodną siłą, a potem przez chwilę okaleczało to, co zostało, ścierając miejscami ciało aż do kości. Ifryty muszą być blisko...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Patrzcie pod nogi.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Encounter",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_153.png[/img]{Na pierwszy rzut oka to miraż. Pustynia faluje i rozmazuje się w oddali, a dla nieostrożnych lub wyczerpanych te widoki zmieniają się w to, czego pragną. Dopiero gdy Ifryt odwraca się, rozrywa człowieka na pół i rozrzuca szczątki po piaskach, uświadamiasz sobie, że to wcale nie jest wyobrażona potworność. To piekielna istota, wirująca chmura piasku z kamieniami układającymi się w coś na kształt człowieka. A gdy pochyla się do przodu, widzisz, że jeśli już nic innego, to podziela ludzkie usposobienie wobec uzbrojonych obcych na własnej ziemi: morderczą furię. | Wydmy przed tobą zsuwają się od szczytu do podstawy, piaski zwijają się ku tobie jak prześcieradło ściągane z łóżka. Ale pojawia się wydobyty z ziemi kamień, i kolejny, i kolejny, a gdy pierwszy się podnosi, uświadamiasz sobie, że to Ifryt. Z gardzieli wydobywa się warkot, głęboki ryk, trzaskający od zderzeń piaszczystych wiatrów. Ifryt przybiera pochyły, poszarpany kształt człowieka, kamienie zamiast kości i piasek zamiast ciała, po czym szarżuje. | Zastajesz Ifryta, który trzyma wydętego na kształt ramienia nad ziemią. Z ramienia wyrzuca piasek, a ziarna wbijają martwe ciało w pustynię, siła zrywa ubrania, potem rozbija ciało, aż zostaje tylko kość, a gdy Ifryt kończy, odwraca się do ciebie i wściekle warczy.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do ataku!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Earthquake",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_160.png[/img]{Gdy docierasz na szczyt wydmy, ta natychmiast osuwa się spod twoich stóp. Zaczynasz tonąć i wywracasz się, zanim ziemia pochłonie cię w całości. Kiedy staczasz się po zboczu, widzisz, że sąsiednie wydmy również się cofają, a w brzuchu czujesz drżenie, nie ze strachu, lecz od samej ziemi, która gwałtownie się trzęsie. Gdy wszystko ustaje, podnosisz się i stajesz pewnie. Na krawędzi krateru stają Ifryty i patrzą na ciebie z góry. Krzyczą na ciebie, ich syk trze się o odgłos krystalizującego się piasku. Jesteś otoczony! | Zatrzymujesz się i wzdychasz. Pustynia zdaje się nie mieć końca i właśnie wtedy widzisz, że widok się kurczy. Po chwili uświadamiasz sobie, że ziemia drży, a przesuwający się piasek wciąga cię w dół. Odskakujesz od niebezpieczeństwa i staczasz się po piaszczystym zboczu. Na dole szybko stajesz na nogi i dobywasz broni, by stawić czoła temu, co już wiesz, że tam jest: Ifrytom. Stoją na krawędzi wydm, wpatrując się w ciebie, jakby złapali szczura. Ich ciała to chmury piasku z unoszącymi się kamieniami, które nadają im urywaną sylwetkę człowieka. Warczą i schodzą w dół!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_160.png[/img]{Bitwa dobiegła końca, ale Ifryty nie znikają całkowicie. Piaski, które tworzyły ich ciała, i kamienie, które je obramowywały, poruszają się i drżą z gniewu. Słyszysz syk nie potwora, lecz wyraźnie ludzki dźwięk. Syczą tuż przy twoich uszach. Odwracasz się i nie widzisz niczego. Syczą znów za tobą i tym razem, gdy się odwracasz, hałas znika, a piaski są nieruchome, a kamienie posłusznie spoczywają w ziemi, jak powinny. Bestie zostały zabite, a być może i to, co je zamieszkiwało. Czas wracać do %employer%a. | Ifryty zostały zabite, ale ich ciała były jedynie naczyniami dla czegoś znacznie bardziej złowrogiego. Dostrzegasz przebłyski duchów szybujących ku horyzontowi, ale być może to tylko pustynia płata ci figle. Nie sposób powiedzieć nic ponad to, że bestialna natura Ifrytów została pokonana, a %employer% musi zapłacić za sam ten fakt.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Załatwione.",
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
			Text = "[img]gfx/ui/events/event_162.png[/img]{Próbujesz wejść do pokoju %employer%a, ale strażnik cię zatrzymuje. Z uniesioną brwią mówisz mu, że wezyr cię oczekuje. Strażnik patrzy na ciebie z góry.%SPEECH_ON%Oczekuje cię, lecz nie chce cię widzieć. To dwie różne rzeczy, koronniku. Zwiadowcy potwierdzili twoje czyny na pustyniach. Oto twoja zapłata, jak ustalono. A teraz odejdź. Powiedziałem: odejdź!%SPEECH_OFF%Strażnik tupie nogą, a wszyscy strażnicy w korytarzu tupią nogami i stają naprzeciw ciebie. Nie jesteś geniuszem, ale czujesz, że chyba czas iść. | %employer% spogląda na ciebie z tronu z poduszek i kobiet. Niewolnic, sądząc po łańcuchach, choć może tak po prostu lubią. Smutne twarze mówią co innego. Wezyr mówi, ale brzmi to jak przedstawienie dla wszystkich słuchających, a ty tylko grasz swoją rolę.%SPEECH_ON%Koronniku, moje małe jastrzębie doniosły mi o twoich czynach. Ifryty zostały uśpione, a ich czary nie będą już zagrożeniem! Taka jest moc mojego złota. To praca, na którą się zgodziliśmy, a twoją nagrodą jest %reward% koron.%SPEECH_OFF%Gdy sługa podaje ci sakiewkę z monetami, wezyr odprawia cię lekceważącym ruchem palców.%SPEECH_ON%Precz.%SPEECH_OFF% | Zastajesz %employer%a, jak obraca klepsydrę w jedną i drugą stronę. Piasek jednakowo wypełnia oba zbiorniczki. Służący stoją wzdłuż ściany z pochylonymi głowami. Przy sąsiedniej ścianie jest rząd poduszek, na których siedzą krzykliwe kobiety, a ich włosy układają kobiety w łańcuchach. Wezyr z hukiem stawia klepsydrę na stole. Kuca za nią, jego oczy są widoczne po obu stronach szkła, źrenice wpatrują się do środka. W końcu dostrzegasz, że piasek w środku nie przesypuje się tak, jak powinien, lecz wiruje gniewnie.%SPEECH_ON%Ifryty zostały załatwione, moje jastrzębie mi to powiedziały. Koronniku, wykonałeś zadanie, do którego zostałeś wezwany, i za to należy ci się %reward% koron. Mam nadzieję, że czas na pustyniach wynagrodził cię nie tylko doświadczeniem walki i wojny, lecz także obdarzył cię skłonnością do kontemplacji.%SPEECH_OFF%Nie jesteś pewien, co ten człowiek ma na myśli. Podrywa klepsydrę i zaczyna znów przechylać ją z boku na bok. Piaski miotają się, gdy obijają się o ścianki. Służący podaje ci sakiewkę z monetami i nie mógłbyś szybciej opuścić tego pokoju. | Wracasz do %employer%a i znajdujesz wezyra leżącego twarzą w dół na kanapie. Kilku starych mężczyzn ugniata mu plecy lub masuje stopy. Po drugiej stronie pokoju kobieta wachluje się. Jest całkiem naga, a jej oczy nie opuszczają wezyra, ani jego jej. Mężczyzna mówi prawie tak, jakby cię w pokoju w ogóle nie było.%SPEECH_ON%Służący, podajcie temu koronnikowi purpurową sakiewkę z czarną nicią. Koronniku, dobrze poradziłeś sobie z duchami piasków, tymi tak zwanymi Ifrytami. To moje złoto poprowadziło cię na te pustynie i moje złoto cię wynagrodziło, więc niech skrybowie wiedzą, że to moje złoto naprawdę rozwiązało ten problem, a narzędzie, ten koronnik, zostało uczciwie opłacone.%SPEECH_OFF%Służący wbija ci w ramiona purpurowy worek. Wezyr jęczy, gdy stary mężczyzna wtyka łokieć prosto w jego rów pośladków.%SPEECH_ON%Czy muszę ci mówić, żebyś odszedł, koronniku?%SPEECH_OFF% | Stary mężczyzna bez brwi wita cię, zatrzymując tuż przed drzwiami %employer%a. Wpycha ci worek w ramiona.%SPEECH_ON%Jest tam %reward% koron, jak wezyr ustalił.%SPEECH_OFF%Mężczyzna rozgląda się za słuchaczami i zdaje się przytakiwać, gdy widzi, że jesteś jedynym w zasięgu głosu.%SPEECH_ON%Ifryty to nie tylko demony, to skrzywdzone duchy, a ty je uwolniłeś. Ale pewnie wrócą, bo ludzie tacy jak %employer% nie mają temu światu do zaoferowania nic poza wodospadem złota, zapominając, że pod tym wodospadem wielu zostaje zmiażdżonych lub utopionych.%SPEECH_OFF%Nie jesteś pewien, co ma na myśli, ale zbliżający się strażnik kończy rozmowę, a starzec policzkuje cię.%SPEECH_ON%Precz, koronniku! Weź zapłatę i znikaj mi z oczu!%SPEECH_OFF% | A jednak, to grupa kotów wita cię przy wejściu do pokoju %employer%a. Ledwie dostrzegasz wezyra po drugiej stronie siatki, otoczonego równie rozbawionymi obserwatorami.\n\nPatrzysz w dół i widzisz, że koty ciągną kawałek drewna z sakiewką na wierzchu. Spoglądasz z powrotem w górę. Sylwetki wstrzymują oddech. Wzdychając, schylasz się i podnosisz sakiewkę. Jeden z podglądaczy wybucha oklaskami, ale natychmiast zostaje uciszony. Kiedy zadanie zostaje wykonane, koty kładą się i rozciągają na kafelkach, drzemiąc albo pielęgnując futro, lub drapiąc cienie migoczące w słonecznych promieniach. Jesteś prawie pewien, że w sakiewce jest %reward% koron, ale nie chcąc spędzić w tym pokoju ani chwili dłużej, wychodzisz na zewnątrz, by to policzyć.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Udane polowanie.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Uwolniłeś miasto od Ifritów");
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
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Target.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/mirage_sightings_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.setAttackableByAI(true);
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
		return true;
	}

	function onSerialize( _out )
	{
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
		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});

