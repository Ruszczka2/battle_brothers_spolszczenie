this.find_artifact_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.find_artifact";
		this.m.Name = "Ekspedycja";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		local myTile = this.World.State.getPlayer().getTile();
		local undead = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
		local highestDistance = 0;
		local best;

		foreach( b in undead )
		{
			if (b.isLocationType(this.Const.World.LocationType.Unique))
			{
				continue;
			}

			local d = myTile.getDistanceTo(b.getTile()) + this.Math.rand(0, 45);

			if (d > highestDistance)
			{
				highestDistance = d;
				best = b;
			}
		}

		this.m.Destination = this.WeakTableRef(best);
		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		local nemesisNames = [
			"Kruk",
			"Lis",
			"BԄkart",
			"Kot",
			"Lew",
			"GeneraՄ",
			"ʄotrzy Baron",
			"Gawron"
		];
		local nemesisNamesC = [
			"Kruk",
			"Lis",
			"BԄkart",
			"Kot",
			"Lew",
			"GeneraՄ",
			"ʄotrzy Baron",
			"Gawron"
		];
		local nemesisNamesS = [
			"Kruk",
			"Lis",
			"BԄkart",
			"Kot",
			"Lew",
			"GeneraՄ",
			"ʄotrzy Baron",
			"Gawron"
		];
		local n = this.Math.rand(0, nemesisNames.len() - 1);
		this.m.Flags.set("NemesisName", nemesisNames[n]);
		this.m.Flags.set("NemesisNameC", nemesisNamesC[n]);
		this.m.Flags.set("NemesisNameS", nemesisNamesS[n]);
		this.m.Payment.Pool = 2000 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Odzyskaj artefakt z %objective% na %direction%"
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
					this.Flags.set("IsLost", true);
				}

				r = this.Math.rand(1, 100);

				if (r <= 20)
				{
					if (!this.Flags.get("IsLost"))
					{
						this.Flags.set("IsScavengerHunt", true);
					}
				}
				else if (r <= 25)
				{
					this.Flags.set("IsTrap", true);
				}
				else if (r <= 30)
				{
					this.Flags.set("IsTooLate", true);
				}

				if (!this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				this.Contract.m.Destination.setLootScaleBasedOnResources(130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.clearTroops();
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));

				if (!this.Flags.get("IsLost") && !this.Flags.get("IsTooLate"))
				{
					this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.UndeadArmy, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
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
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsTrap") && !this.Flags.get("IsTrapShown"))
					{
						this.Flags.set("IsTrapShown", true);
						this.Contract.setScreen("Trap");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsScavengerHunt") && !this.Flags.get("IsScavengerHuntShown"))
					{
						this.Flags.set("IsScavengerHuntShown", true);
						this.Contract.setScreen("ScavengerHunt");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("SearchingTheRuins");
						this.World.Contracts.showActiveContract();
					}
				}
				else if (this.Flags.get("IsLost") && !this.Flags.get("IsLostShown") && this.Contract.isPlayerNear(this.Contract.m.Destination, 500))
				{
					this.Flags.set("IsLostShown", true);
					local brothers = this.World.getPlayerRoster().getAll();
					local hasHistorian = false;

					foreach( bro in brothers )
					{
						if (bro.getBackground().getID() == "background.historian")
						{
							hasHistorian = true;
							break;
						}
					}

					if (hasHistorian)
					{
						this.Contract.setScreen("AlmostLost");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("Lost");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (!this.Flags.get("IsAttackDialogShown"))
				{
					this.Flags.set("IsAttackDialogShown", true);

					if (this.Flags.get("IsTooLate"))
					{
						this.Contract.setScreen("TooLate1");
					}
					else
					{
						this.Contract.setScreen("ApproachingTheRuins");
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					_dest.m.IsShowingDefenders = true;
					this.World.Contracts.showCombatDialog();
				}
			}

		});
		this.m.States.push({
			ID = "Running_TooLate",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Dogoń osobę zwaną %nemesis% i zdobądź artefakt"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onCombatWithNemesis.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					this.Contract.setScreen("TooLate3");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatWithNemesis( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;

				if (!this.TempFlags.get("IsAttackDialogWithNemesisShown"))
				{
					this.TempFlags.set("IsAttackDialogWithNemesisShown", true);
					this.Contract.setScreen("TooLate2");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					properties.Music = this.Const.Music.NobleTracks;
					properties.Entities.push({
						ID = this.Const.EntityType.BanditLeader,
						Variant = 0,
						Row = 2,
						Script = "scripts/entity/tactical/enemies/bandit_leader",
						Faction = _dest.getFaction(),
						Callback = this.onNemesisPlaced.bindenv(this)
					});
					properties.EnemyBanners = [
						this.Const.PlayerBanners[this.Flags.get("NemesisBanner") - 1]
					];
					this.World.Contracts.startScriptedCombat(properties, true, true, true);
				}
			}

			function onNemesisPlaced( _entity, _tag )
			{
				_entity.setName(this.Flags.get("NemesisNameC"));
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
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(null);
				}
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{Zastajesz %employer%a nad stertą map, które przegląda narzędziami używanymi do ich rysowania. Spogląda w górę, z napiętym wyrazem twarzy kartografa.%SPEECH_ON%Moi skrybowie przekazali mi te mapy, mówiąc, że znaleźli miejsce zwane \'%objective%\'. Mówi się, że kryje ogromną moc gdzieś w swoich salach, korytarzach czy, cóż, czymkolwiek jest to, co się tam znajduje.%SPEECH_OFF%Unosisz brew, ale mężczyzna ciągnie dalej.%SPEECH_ON%Słuchaj, moi skrybowie szczerze wierzą, że to, co tam jest, może pomóc nam znaleźć rozwiązanie tej plagi nieumarłych. Ale powiedzieli mi też, że inni tego szukają. Potrzebuję, żebyś dotarł tam przed wszystkimi innymi.%SPEECH_OFF% | %employer% wita cię, rozwijając mapę, papier sięga od głowy po stopy. Owija palec wokół jednego z brzegów, by wskazać konkretny punkt.%SPEECH_ON%Widzisz to? Nazywa się \'%objective%\'. Miejsce, o którym... właściwie niewiele wiem. Wiem tylko, że inni tam zmierzają i podobno chodzi o odzyskanie artefaktu o ogromnej mocy. Moi skrybowie wierzą, że ten artefakt mógłby pomóc nam odeprzeć plagę nieumarłych. Oczywiście chcę, żebyś dotarł tam i zdobył go, zanim zrobi to ktoś inny!%SPEECH_OFF% | %employer% pokazuje ci mapę, a na niej konkretną lokalizację.%SPEECH_ON%To właśnie miejsce zwane \'%objective%\'. Plotki mówią, że inni ludzie go szukają. Moi skrybowie, którzy nie lubią plotek, wierzą, że kryje ono pewien artefakt, którego moglibyśmy użyć w walce z plagą nieumarłych. To obszar głęboko na wrogim terytorium i mam powody sądzić, że nie będziesz jedynym, kto go szuka. Idź tam, przynieś mi artefakt, a sowicie cię nagrodzę.%SPEECH_OFF% | Gdy spotykasz %employer%a, pospiesznie prosi, byś podszedł i przeczytał księgę. Widzisz język, o którym nie wiedziałeś, że istnieje, ale na stronach jest też mapa, która nie wymaga tłumaczenia, a zwłaszcza miejsce na niej, mocno zakreślone piórem. %employer% stuka w nie palcem.%SPEECH_ON%Musisz tam pójść, najemniku. Nazywają to \'%objective%\'. Moi skrybowie twierdzą, że kryje się tam artefakt o wielkiej mocy, który mógłby pomóc nam odeprzeć plagę nieumarłych. Oczywiście taki artefakt nie będzie po prostu leżał na widoku. Spodziewam się wszelkiego rodzaju ludzi i stworzeń krążących po okolicy, przyciągniętych pomrukiem samej mocy artefaktu! Musisz go zdobyć i przynieść mi z powrotem.%SPEECH_OFF% | %employer% wita cię i szybko opisuje miejsce zwane \'%objective%\', ponure miejsce leżące %direction% stąd.%SPEECH_ON%Moi skrybowie twierdzą, że ten obszar kryje artefakt o olbrzymiej mocy, który mógłby pomóc nam odeprzeć plagę nieumarłych. Oczywiście mogą po prostu próbować namówić mnie, bym zdobył coś, co chcą badać. Na razie im wierzę. Potrzebuję, abyś tam poszedł i to znalazł. Wielka moc przyciąga, więc nie spodziewałbym się, że będziesz jedynym, który kręci się po okolicy, rozumiesz? Idź i przynieś mi to, a zostaniesz odpowiednio nagrodzony.%SPEECH_OFF% | Zastajesz skrybę pochylonego nad uchem %employer%a, szepczącego coś, na co szlachcic wielokrotnie przytakuje. Gdy cię widzi, szybko wyjaśnia sytuację.%SPEECH_ON%Najemniku! Otrzymałem... wieści, że miejsce %direction% stąd kryje ogromną moc, którą musimy zdobyć. Myślę, że pomoże nam to odeprzeć plagę nieumarłych. Oczywiście, jeśli naprawdę ma taką moc, można założyć, że inni też będą tego szukać! Dlatego szybkość jest sprawą najwyższej wagi. Chcę, byś dotarł tam i wrócił.%SPEECH_OFF% | %employer% przechadza się po swoim prywatnym cmentarzu. Staje przed nagrobkiem.%SPEECH_ON%Co noc boję się, że to zacznie się poruszać, a moi przodkowie powstaną i przyjdą mnie zniszczyć za moje porażki.%SPEECH_OFF%Odwraca się i spogląda na ciebie z zimnym grymasem na twarzy. Bez słowa wprowadza cię do domu, gdzie stary człowiek ślęczy nad księgami, które całkowicie pokrywają jego biurko. %employer% każe ci rozmawiać z tym człowiekiem, po czym staje przy drzwiach. Siadasz naprzeciwko starca, który odkłada pióro.%SPEECH_ON%{Mój pan zaszczycił mnie możliwością przekazania ci wszystkiego, co musisz wiedzieć. Zidentyfikowałem artefakt o wielkiej mocy, położony %direction% stąd w miejscu zwanym \'%objective%\'. Wierzę, że ten artefakt może zawierać moc, która pomoże rozwiązać problem umarłych... znów powstających do życia. Uważam też, że moc tej skali nie pozostaje niezauważona w tym świecie. Musisz tam pójść, odeprzeć każdego, kto uważa, że należy do niego, i wrócić do nas. | Witaj, najemniku. Nieczęsto zwracam się do człowieka twojego fachu, by rozwiązywał moje problemy. Dobra księga i spokojny wieczór dawniej w zupełności wystarczały, ale już nie. Musisz udać się %direction% stąd do miejsca zwanego \'%objective%\'. Mamy powody sądzić, że może ono zawierać odpowiedź na nasz problem z umarłymi chodzącymi pośród nas. Oczywiście taka moc jest silną przynętą. Musisz działać szybko, by tam dotrzeć i wrócić, inaczej możemy ją stracić.}%SPEECH_OFF% | Skryba stoi u boku %employer%a. Obaj wpatrują się w kartkę papieru. Gdy się zbliżasz, powoli przesuwają ją po stole, byś mógł przeczytać. Wygląda na to, że skryba zlokalizował miejsce ogromnej mocy i wierzą, że może zawierać rozwiązanie plagi nieumarłych. %employer% uważa, że wielu innych również będzie na nie polować, a szybkość jest sprawą najwyższej wagi. | Zastajesz %employer%a rozmawiającego ze skrybą, obaj z nosami w księdze, między nimi migocząca świeca. Gdy cię słyszą, pan szybko podnosi wzrok i wyjaśnia sytuację: odczytali lokalizację wielkiego artefaktu, artefaktu, który z dużym prawdopodobieństwem zawiera odpowiedź na problem umarłych kroczących po ziemi. %employer% przytakuje.%SPEECH_ON%Mamy powody sądzić, że nie będziesz jedynym, kto go szuka, ani że miejsce, w którym spoczywa, należy do bezpiecznych.%SPEECH_OFF% | %employer% bierze pochodnię z paleniska i prowadzi cię do krypt. Obserwujesz, jak z mroku wyłaniają się upiorne posągi, a płomień szlachcica ożywia cienie i mroki. Zatrzymuje się przed jednym, po czym odwraca.%SPEECH_ON%To mój ojciec. Słuchaj uważnie.%SPEECH_OFF%Przykładasz ucho do ogromnego sarkofagu i słyszysz z wnętrza ciche drapanie. %employer% kręci głową.%SPEECH_ON%Moi skrybowie odczytali lokalizację rzekomego wielkiego artefaktu. Leży %direction% stąd w miejscu zwanym \'%objective%\'. Może mieć moc, by zakończyć to szaleństwo, a może nie. Oczywiście taka moc nigdy nie istnieje w ciszy. Spodziewamy się wielu innych, ludzi lub nie, w pobliżu artefaktu. Idź tam, najemniku, i przynieś mi go, a zostaniesz nagrodzony.%SPEECH_OFF%Macha pochodnią w stronę trumny, z której dobiega stłumiony pomruk.%SPEECH_ON%Dla dobra naszego i ich.%SPEECH_OFF% | %employer% i jego skryba prowadzą cię do katakumb. Znajdujesz tam trumnę, która została rozbita. Dwóch strażników z pikami powstrzymuje upiorną, gnijącą kobietę przed atakiem. Warczy i kłapie zębami, gdy blask ognia wypełnia jej wychudłe kształty. %employer% zwraca się do ciebie.%SPEECH_ON%Nie wiemy, czym to jest ani co to spowodowało, ale sądzimy, że miejsce zwane \'%objective%\', leżące %direction% stąd, może zawierać odpowiedź. Rzekomo znajduje się tam artefakt o pewnej mocy i potrzebuję, abyś go przyniósł. Mój skryba mówi, że powinieneś przygotować się na nieznane niebezpieczeństwa.%SPEECH_OFF%Nieumarła dziewczyna warczy i rzuca się do przodu, nadziewając na ostrze i osuwając się po nim. Skryba przytakuje, a %employer% kontynuuje.%SPEECH_ON%Jeśli to może zakończyć to udręczenie, kto wie, co jeszcze może zrobić.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Wierzę, że hojnie nas wynagrodzisz za tak niebezpieczną podróż. | To daleko stąd, więc lepiej żeby zapłata była należyta.}",
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
			ID = "ApproachingTheRuins",
			Title = "%objective%",
			Text = "[img]gfx/ui/events/event_57.png[/img]{Dobra, ruiny. Zobaczmy, czy %employer% i jego głupi skrybowie wiedzą, o czym mówią. | Docierasz do ruin. Niewiele tu widać, co cię niepokoi. Każesz %companyname% przygotować się na najgorsze. | W końcu docierasz do rzekomego domu wielkiego artefaktu. Czas sprawdzić, czy %employer% i jego skrybowie w ogóle wiedzieli, o czym mówią. | Ruiny stoją przechylone i zapadają się w siebie. Jak na zawołanie zrywa się chmura nietoperzy. %randombrother% kuca, a reszta ludzi się śmieje. | Odnajdujesz %objective% i stajesz na pobliskim wzgórzu. Patrząc w dół, widzisz, czemu tak długo pozostawało ukryte, miejsce w tak niepozornej lokalizacji. Nawet stąd słyszysz wiatr wplątany w kamienne mury. | Docierasz do %objective% i %randombrother% ocenia je tak, jak byś się spodziewał.%SPEECH_ON%Wygląda żałośnie. Bierzmy się do roboty, co?%SPEECH_OFF%Oby miał rację. | %randombrother% prostuje się.%SPEECH_ON%Cholera, chyba to jest to.%SPEECH_OFF%Wpatruje się w grupę ruin, które rzeczywiście wyglądają na %objective%. Klaszcze i pociera dłonie.%SPEECH_ON%Bierzmy się do roboty. Przysięgam, jeśli jest tam jakiś liczyk, będę narzekał długo po swojej śmierci.%SPEECH_OFF% | %randombrother% spogląda w dół na %objective%, które leży w oddali.%SPEECH_ON%No i co myślisz, co tam jest? Wydaje mi się, że %employer% nas wkręca. Wejdziemy tam i przywita nas gromada pięknych kobiet. Nagroda dla nas, ciężko pracujących ludzi, wiesz?%SPEECH_OFF%Z jakiegoś powodu nie sądzisz, by tak miało być. | %objective% leży niedaleko. Widzisz stąd tylko przechylone kamienne mury, ale zapach unosi się daleko. %randombrother% zatyka nos.%SPEECH_ON%Śmierdzi jak gówno mojej ciotki. Nie zdziwiłbym się, gdyby ta wiedźma też tam była.%SPEECH_OFF% | Zbliżając się do %objective%, każesz ludziom przygotować się do walki. Kto wie, co czeka %companyname% w tych zakazanych ziemiach! | Gdy zbliżasz się do %objective%, miękkie szepty przesuwają się obok.%SPEECH_ON%{Wejdź. Wejdź. To dla twojego dobra. Spodoba ci się tutaj, tak, spodoba. Zgadzamy się. Tak, zgadzamy. Prosimy, pośpiesz się. Nie możemy dłużej czekać! | Nie jesteś pierwszy. Nie jesteś pierwszy. Nie będziesz ostatni. Nie będziesz ostatni. | Głupi człowieku, myślisz, że twoje myśli są twoje? | Twoi ludzie cię zdradzą. Uważają cię za bezużytecznego. Zawracaj, skomlący owadzie. | Oto jesteś. Tu pozostaniesz na zawsze. | Ach, więcej ludzi. Nie mogę znieść waszego zapachu w takim stanie. Trujecie powietrze, którym oddycham. Dajcie mi was. Włożę zgniliznę w wasze brzuchy i będzie wam lepiej... | Odważny z ciebie człowieczek, ale jesteś tylko okazem. Strach wypełni twoje serce, aż nie będzie miejsca na nic więcej. A potem umrzesz. Tak jest i tak będzie. | Podejdź, mały człowieku. Tu jest miejsce, w którym zawsze chciałem, abyś był. | Tak! W końcu przyszedłeś! Tak dobrze cię widzieć, człowieku, tak bardzo dobrze cię widzieć! | Ach, nadchodzi kolejna okrutna bestia. Co za głupia istotka. Tak, bardzo głupia. Co z nią zrobimy? Wpuśćmy ją, oczywiście. Oczywiście!}%SPEECH_OFF%%randombrother% kręci palcem w uchu.%SPEECH_ON%Czy coś mówiłeś, szefie?%SPEECH_OFF%Kręcisz głową i pośpiesznie każesz ludziom przygotować się na wszystko. | Gdy zbliżasz się do %objective%, miękkie szepty przesuwają się obok.%SPEECH_ON%{Wejdź. Wejdź. To dla twojego dobra. Spodoba ci się tutaj, tak, spodoba. Zgadzamy się. Tak, zgadzamy. Prosimy, pośpiesz się. Nie możemy dłużej czekać! | Nie jesteś pierwszy. Nie jesteś pierwszy. Nie będziesz ostatni. Nie będziesz ostatni. | Głupi człowieku, myślisz, że twoje myśli są twoje? | Twoi ludzie cię zdradzą. Uważają cię za bezużytecznego. Zawracaj, skomlący owadzie. | Oto jesteś. Tu pozostaniesz na zawsze. | Ach, więcej ludzi. Nie mogę znieść waszego zapachu w takim stanie. Trujecie powietrze, którym oddycham. Dajcie mi was. Włożę zgniliznę w wasze brzuchy i będzie wam lepiej... | Odważny z ciebie człowieczek, ale jesteś tylko okazem. Strach wypełni twoje serce, aż nie będzie miejsca na nic więcej. A potem umrzesz. Tak jest i tak będzie. | Podejdź, mały człowieku. Tu jest miejsce, w którym zawsze chciałem, abyś był. | Tak! W końcu przyszedłeś! Tak dobrze cię widzieć, człowieku, tak bardzo dobrze cię widzieć! | Ach, nadchodzi kolejna okrutna bestia. Co za głupia istotka. Tak, bardzo głupia. Co z nią zrobimy? Wpuśćmy ją, oczywiście. Oczywiście!}%SPEECH_OFF%%randombrother% kręci palcem w uchu.%SPEECH_ON%Czy coś mówiłeś, szefie?%SPEECH_OFF%Kręcisz głową i pośpiesznie każesz ludziom przygotować się na wszystko.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zachowajcie czujność!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SearchingTheRuins",
			Title = "%objective%",
			Text = "[img]gfx/ui/events/event_57.png[/img]{Wreszcie zdobyłeś artefakt. Jego ciężar wydaje się nie taki w twoich dłoniach, jakby powinien być ciężki, ale coś utrzymuje go sztucznie lekkim. Pakujesz go i szykujesz się na powrót do zleceniodawcy, %employer%a. | Masz teraz artefakt, którego szukałeś. Szczerze mówiąc, to lekkie rozczarowanie. Część ciebie miała nadzieję, że da ci olbrzymią moc, ale zamiast tego bezwładnie spoczywa w twoich dłoniach. Może po prostu nie jesteś wybrańcem. | Bierzesz artefakt, ignorując cichy pomruk, który z niego dobiega, i szykujesz się do powrotu do %employer%a. | Bierzesz artefakt i przyglądasz mu się. %randombrother% podchodzi i opiera pięści o biodra.%SPEECH_ON%Cholera, to paskudztwo wcale nie wygląda na takie cenne.%SPEECH_OFF% | Ważysz artefakt w dłoniach. Przechodzi od lekkości do ciężaru i z powrotem. To wystarczająco dziwne, więc szybko wciskasz go do sakiewki. | %randombrother% przygląda się artefaktowi, zanim go schowasz.%SPEECH_ON%Nie wygląda na coś szczególnego.%SPEECH_OFF%Mówisz mu, że wiele rzeczy o wielkiej mocy nie wygląda wyjątkowo. Siada i zastanawia się.%SPEECH_ON%Moje pierdy też nie wyglądają na nic, więc chyba masz rację.%SPEECH_OFF% | Podajesz artefakt %randombrother%owi. Unosi go w górę.%SPEECH_ON%A co, gdybym roztrzaskał go tutaj i teraz, wkurzyłbyś się?%SPEECH_OFF%Patrzysz na niego spode łba.%SPEECH_ON%Tak, trochę. Ale może w środku są małe demony, które będą cię dręczyć na wieczność za zniszczenie ich domu. Kto wie, co?%SPEECH_OFF%Najemnik szybko wkłada artefakt do sakiewki. | Patrzysz na artefakt. Jest gładki i nieruchomy, nie coś, czego spodziewałbyś się po wielkiej mocy, ale z jakiegoś powodu to właśnie jest najbardziej niepokojące. Szybko chowasz go do sakiewki. | Wkładasz artefakt do sakiewki tylko po to, by zaczął świecić i wzywać cię. Otwierasz worek i patrzysz w dół na dwie czerwone kropki wpatrujące się w ciebie. %randombrother% pyta, czy wszystko w porządku. Szybko zamykasz sakiewkę i kiwasz głową. | Wreszcie masz artefakt. Nie świeci, nie brzęczy, nawet nie wygląda zbyt ładnie. Nie jesteś pewien, o co tyle hałasu, ale jeśli %employer% chce ci za to zapłacić, to jego sprawa. | Cóż, masz artefakt. %randombrother% podchodzi, drapiąc się po głowie.%SPEECH_ON%To za to małe coś zginęło tylu ludzi?%SPEECH_OFF%Artefakt grzechocze, a warczący głos odpowiada.%SPEECH_ON%Nie zginęli. Są teraz ze mną i na zawsze.%SPEECH_OFF%Najemnik odskakuje.%SPEECH_ON%Wiesz co? Nie słyszałem tego. Nie wiem, co to było. Nie obchodzi mnie to. Nie. Wracam do jedzenia twardego, czerstwego chleba i nudnego życia, dziękuję bardzo.%SPEECH_OFF% | Trzymasz artefakt, używając między nim a sobą szmaty, by jego moc nie przeniknęła do twojego ciała. Oczywiście wygląda tylko jak ozdobny kawałek kamienia, ale ostrożność nie zaszkodzi. %employer% powinien się ucieszyć na jego widok i niech go trzyma, jak zechce, jeśli o ciebie chodzi. | Artefakt wygląda dziwnie, ale nic nadzwyczajnego. Jak dla ciebie, to mógł być projekt jakiegoś włóczęgi, który ktoś inny wziął za boski przedmiot. %randombrother% wpatruje się w niego.%SPEECH_ON%Szczerze mówiąc, wysrałem ładniejsze rzeczy niż to.%SPEECH_OFF%Ostrzegasz go, że jeśli ta relikwia naprawdę ma moce, może zapłacić za ten komentarz. Wzrusza ramionami.%SPEECH_ON%Nie zmienia to faktów.%SPEECH_OFF% | Podnosisz relikwię i nagle staje się ciężka, więc opuszczasz ją. Gdy zniżasz ją ku stopom, robi się lżejsza, jakby chciała zostać podniesiona z powrotem. To wystarczająco dziwne, więc szybko ją chowasz i szykujesz się do powrotu do %employer%a w %townname%. | Wreszcie zdobyłeś artefakt. Wpatrujesz się w niego, gdy podchodzi %randombrother%.%SPEECH_ON%To tego chce %employer%? Cholera, mógłbym coś takiego zrobić i oszczędzić nam całego kłopotu.%SPEECH_OFF%Chowasz artefakt do worka i odpowiadasz.%SPEECH_ON%Myślę, że w końcu by poznał, że to podróbka.%SPEECH_OFF%Najemnik unosi palec.%SPEECH_ON%Słowo klucz: w końcu.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Mamy to, po co przyszliśmy. Czas wracać!",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.setState("Return");
			}

		});
		this.m.Screens.push({
			ID = "AlmostLost",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_42.png[/img]{Podczas marszu %historian% historyk widzi, że wpatrujesz się w mapę. Prosi, by rzucić na nią okiem, i pozwalasz mu. Mężczyzna trzyma ją na wyciągnięcie, potem przybliża.%SPEECH_ON%Idziemy w złą stronę. Skrybowie %employer%a musieli to źle odczytać. Widzisz ten symbol? On właściwie oznacza...%SPEECH_OFF%Zatrzymuje się, widząc, że cokolwiek ma powiedzieć, nie będzie dla ciebie zrozumiałe. Śmieje się.%SPEECH_ON%Dobra, w skrócie musimy iść w tę stronę.%SPEECH_OFF%Wyciąga pióro i nanosi poprawkę. | %historian% historyk przygląda się jednej z map, które dał ci %employer%. Zatrzymuje się i pyta.%SPEECH_ON%Mówisz, że skrybowie szlachcica stworzyli tę mapę? Bo jest cała błędna. Spójrz.%SPEECH_OFF%Pokazuje ci ją.%SPEECH_ON%Źle odczytali języki. To nie alfabet, tylko symbole wiary. To nie słowa, lecz zagadki. A jeśli je właściwie zinterpretować, prowadzą tutaj.%SPEECH_OFF%Wskazuje zupełnie inne miejsce niż to, do którego zmierzaliście. Wygląda na to, że %companyname% musi skorygować kurs. | %historian% historyk kręci głową, przeglądając mapę.%SPEECH_ON%Panie, idziemy w złą stronę. Skrybowie %employer%a źle odczytali te symbole. Musimy zmienić kierunek.%SPEECH_OFF%Masz ochotę podważyć jego przypuszczenia, ale szybciej uwierzysz zahartowanemu historykowi jadącemu z %companyname% niż jakiemuś starcowi uwięzionemu w wieży szlachcica. | %historian% bierze mapę, którą dał ci %employer%, i ogląda ją.%SPEECH_ON%Tak, nie, idziemy w złą stronę. Widzisz to? Alfabet idzie tu w górę i w dół, od prawej do lewej. To zagadka słów, którą skrybowie szlachcica błędnie uznali za rozwiązaną.%SPEECH_OFF%Pytasz, czy to znaczy, że idziecie źle. %historian% przytakuje.%SPEECH_ON%Tak. Dobrze, że tu byłem, co?%SPEECH_OFF% | Patrzysz na mapę, którą dał ci %employer%. Jest pełna zawijasów, których nie rozumiesz, jakby ktoś nabazgrał cały język. %historian% historyk podchodzi, jedząc lunch. Mówi między kęsami.%SPEECH_ON%Mapa zła.%SPEECH_OFF%Strzepujesz okruchy z mapy i pytasz, co ma na myśli. Śmieje się.%SPEECH_ON%To znaczy, że mapa jest zła. Skrybowie %employer%a nie mieli pojęcia, na co patrzą. Widzisz tamtą formację skalną? Tam musimy iść. Swoją drogą, dobre to, chcesz trochę?%SPEECH_OFF%Proponuje kęs, ale odmawiasz.%SPEECH_ON%Twoja strata. Mam powiedzieć ludziom, że zmieniamy kierunek?%SPEECH_OFF%Wzdychasz i kiwasz głową.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To przydatna wiedza.",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						local myTile = this.World.State.getPlayer().getTile();
						local undead = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
						local lowestDistance = 9999;
						local best;

						foreach( b in undead )
						{
							if (b.isLocationType(this.Const.World.LocationType.Unique))
							{
								continue;
							}

							local d = myTile.getDistanceTo(b.getTile()) + this.Math.rand(0, 25);

							if (d < lowestDistance)
							{
								lowestDistance = d;
								best = b;
							}
						}

						this.Contract.m.Destination = this.WeakTableRef(best);
						this.Flags.set("DestinationName", this.Contract.m.Destination.getName());
						this.Contract.m.Destination.setDiscovered(true);
						this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
						this.Contract.m.Destination.clearTroops();
						this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.UndeadArmy, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						this.Contract.getActiveState().start();
						this.World.Contracts.updateActiveContract();
						this.Contract.m.Dude = null;
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local candidates = [];

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.historian")
					{
						candidates.push(bro);
					}
				}

				this.Contract.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
			}

		});
		this.m.Screens.push({
			ID = "Lost",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_42.png[/img]Docierasz tam, gdzie myślisz, że powinieneś być. Tyle że... nie ma tu nic. Uważnie przyglądasz się mapie i rozumiesz, gdzie popełniłeś błąd. Najwyraźniej są dwie formacje skalne w kształcie {mężczyzny trzymającego miecz | kościoła atakowanego przez starych bogów | ogromnego ziemniaka z twarzą | pięknej, krągłej kobiety | psa prowadzącego człowieka | niedźwiedzia stojącego na tylnych łapach i uderzającego małą dziewczynkę próbującą jeść z miski zupę | młodego mężczyzny patrzącego na chmury, które również są ukształtowane nad nim, z skałą wyglądającą jak królik, choć %randombrother% twierdzi, że to pies, po czym obaj uświadamiacie sobie, że dyskutowaliście o tym, jak wyglądają chmury ze skał, podczas gdy obserwował was skalny obserwator chmur}. Robisz notatkę na mapie i ruszasz w stronę właściwego miejsca, mając nadzieję, że ta mała wyprawa na manowce nie kosztowała cię zbyt wiele czasu.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "A niech to!",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						local myTile = this.World.State.getPlayer().getTile();
						local undead = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
						local lowestDistance = 9999;
						local best;

						foreach( b in undead )
						{
							if (b.isLocationType(this.Const.World.LocationType.Unique))
							{
								continue;
							}

							local d = myTile.getDistanceTo(b.getTile()) + this.Math.rand(0, 25);

							if (d < lowestDistance)
							{
								lowestDistance = d;
								best = b;
							}
						}

						this.Contract.m.Destination = this.WeakTableRef(best);
						this.Flags.set("DestinationName", this.Contract.m.Destination.getName());
						this.Contract.m.Destination.setDiscovered(true);
						this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
						this.Contract.m.Destination.clearTroops();
						this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.UndeadArmy, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						this.Contract.m.Destination.setLootScaleBasedOnResources(130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());

						if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
						{
							this.Contract.m.Destination.getLoot().clear();
						}

						this.Contract.getActiveState().start();
						this.World.Contracts.updateActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "TooLate1",
			Title = "%objective%",
			Text = "[img]gfx/ui/events/event_57.png[/img]Wchodząc do sali, w której spodziewałeś się znaleźć relikwię, widzisz tylko pusty postument z notatką. Czytasz:%SPEECH_ON%{Wygląda na to, że twoi pachołkowie znowu się spóźnili, %employer%. Pamiętasz, gdy kiedyś ze mną pracowałeś? To masz! | Aha! Tak, to ja to napisałem, bo właśnie to wykrzyknąłem, gdy zobaczyłem, że po raz kolejny jestem o krok przed tobą, %employer%! Szkoda, że poszedłeś po taniości i zatrudniłeś bandę byle jakich najemników. Powodzenia następnym razem. | Jeśli to czytasz, jesteś za wolny, a %employer% pomylił się, zatrudniając ciebie zamiast mnie. Niestety, relikwia jest u mnie. A teraz wracajcie do zleceniodawcy i wyjaśnijcie, jak ją straciliście. | Jeśli to czytasz, to pewnie ta grupa najemników, którą %employer% postanowił zatrudnić zamiast mnie. Patrz, jak się pomylił! I jak jesteście powolni! Pewnie masz tak twardą głowę, że nawet nie umiesz tego przeczytać. | Witaj, najemniku, szkoda, że nie mogłem być tam, by zobaczyć twoją minę, gdy zacząłeś to czytać. Cóż, nie zawsze dostajemy to, czego chcemy. Fakt, że relikwia jest w moich rękach, a nie w twoich, powinien wystarczająco podkreślić tę lekcję. Powodzenia następnym razem, nieudacznicy, i przekaż %employer%owi moje pozdrowienia.}%SPEECH_OFF%Na dole widnieje podpis \'%nemesis%\'.\n\nNie wiesz, kim do diabła jest, ale teraz jest chodzącym trupem. Rozsypane ślady dają wskazówkę, dokąd to drań poszedł.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Niespodziewany zwrot akcji!",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						local playerTile = this.World.State.getPlayer().getTile();
						local camp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getNearestSettlement(playerTile);
						local tile = this.Contract.getTileToSpawnLocation(playerTile, 8, 14);
						local party = this.World.FactionManager.getFaction(camp.getFaction()).spawnEntity(tile, this.Flags.get("NemesisNameC"), false, this.Const.World.Spawn.Mercenaries, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
						party.setFootprintType(this.Const.World.FootprintsType.Mercenaries);
						local n = 0;

						do
						{
							n = this.Math.rand(1, this.Const.PlayerBanners.len());
						}
						while (n == this.World.Assets.getBannerID());

						party.getSprite("banner").setBrush(this.Const.PlayerBanners[n - 1]);
						this.Flags.set("NemesisBanner", n);
						this.Contract.m.UnitsSpawned.push(party);
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

						this.Contract.m.Destination = this.WeakTableRef(party);
						party.setAttackableByAI(false);
						party.setFootprintSizeOverride(0.75);
						local c = party.getController();
						c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
						local roam = this.new("scripts/ai/world/orders/roam_order");
						roam.setPivot(camp);
						roam.setMinRange(5);
						roam.setMaxRange(10);
						roam.setAllTerrainAvailable();
						roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
						roam.setTerrain(this.Const.World.TerrainType.Shore, false);
						roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
						c.addOrder(roam);
						this.Const.World.Common.addFootprintsFromTo(playerTile, this.Contract.m.Destination.getTile(), this.Const.GenericFootprints, this.Const.World.FootprintsType.Mercenaries, 0.75);
						this.Contract.setState("Running_TooLate");
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "TooLate2",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{Idąc tropem śladów, doganiasz %nemesis%a i jego ludzi. Wiesz, że to oni, bo największy dupka w grupie trzyma relikwię. Wygląda na to, że potrafi poprzeć swoje obelgi: otacza go dobrze uzbrojona grupa wojowników. Powinieneś uważać, jak do tego podejdziesz. | %nemesisC% nie był tak trudny do znalezienia, jak mogła sugerować jego krzykliwa, obraźliwa wiadomość. Ale jeśli już, jest bardzo dobrze strzeżony. Świta uzbrojonych i opancerzonych ludzi otacza palanta, gdy ten łapczywie wpatruje się w relikwię w swoich rękach. Aby ją odzyskać, %companyname% powinno przemyśleć, jak najlepiej podejść do tej sytuacji. | Znajdujesz mężczyznę wpatrzonego w relikwię, której szukałeś. To musi być %nemesis%! Gdy już masz wyskoczyć i zabić go sam, %randombrother% chwyta cię za koszulę i ciągnie w dół. Wskazuje do przodu i pojawia się świta dobrze uzbrojonych strażników. %companyname% powinno podejść do tej sytuacji ostrożnie. | Ślady nie były trudne do śledzenia. Początkowo myślałeś, że to dlatego, że ten %nemesisS% to idiota, ale okazuje się, że po prostu jest bardzo dobrze chroniony. Znajdujesz go z relikwią w rękach, całkowicie otoczonego przez dobrze uzbrojoną straż. Przemoc była tym, po co tu przyszedłeś, ale może jest inna droga? | Znajdujesz %nemesis%a trzymającego relikwię. Wygląda na łatwy cel i zostawia mnóstwo śladów, z ignorancji lub źle ulokowanej pewności siebie. Gdy dobywasz miecza, %randombrother% powstrzymuje twoją dłoń. Kiwając głową, wskazuje do przodu.\n\nWidzisz, jak grupa ludzi podchodzi do %nemesis%a i prosi o rozkazy. To jego strażnicy, i są bardzo dobrze uzbrojeni. Odzyskanie artefaktu może wymagać więcej rozlewu krwi, niż sądziłeś.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Popełniłeś straszny błąd wyzywając naszą kompanię. Był twoim ostatnim.",
					function getResult()
					{
						this.Contract.getActiveState().onCombatWithNemesis(this.Contract.m.Destination, false);
						return 0;
					}

				},
				{
					Text = "Nikt nie musi umierać. Artefakt w zamian za %bribe% koron, co powiesz?",
					function getResult()
					{
						return this.Math.rand(1, 100) <= 50 ? "TooLateBribeRefused" : "TooLateBribeAccepted";
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "TooLate3",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_11.png[/img]{Wreszcie zdobyłeś artefakt. Jego ciężar wydaje się nie taki w twoich dłoniach, jakby powinien być ciężki, ale coś utrzymuje go sztucznie lekkim. Pakujesz go i szykujesz się na powrót do %employer%a. | Masz teraz artefakt, którego szukałeś. Szczerze mówiąc, to lekkie rozczarowanie. Część ciebie miała nadzieję, że da ci olbrzymią moc, ale zamiast tego bezwładnie spoczywa w twoich dłoniach. Może po prostu nie jesteś wybrańcem. | Bierzesz artefakt, ignorując cichy pomruk, który z niego dobiega, i szykujesz się do powrotu do %employer%a. | Bierzesz artefakt i przyglądasz mu się. %randombrother% podchodzi i opiera pięści o biodra.%SPEECH_ON%Cholera, to paskudztwo wcale nie wygląda na takie cenne.%SPEECH_OFF% | Ważysz artefakt w dłoniach. Przechodzi od lekkości do ciężaru i z powrotem. To wystarczająco dziwne, więc szybko wciskasz go do sakiewki. | %randombrother% przygląda się artefaktowi, zanim go schowasz.%SPEECH_ON%Nie wygląda na coś szczególnego.%SPEECH_OFF%Mówisz mu, że wiele rzeczy o wielkiej mocy nie wygląda wyjątkowo. Siada i zastanawia się.%SPEECH_ON%Moje pierdy też nie wyglądają na nic, więc chyba masz rację.%SPEECH_OFF% | Podajesz artefakt %randombrother%owi. Unosi go w górę.%SPEECH_ON%A co, gdybym roztrzaskał go tutaj i teraz, wkurzyłbyś się?%SPEECH_OFF%Patrzysz na niego spode łba.%SPEECH_ON%Tak, trochę. Ale może w środku są małe demony, które będą cię dręczyć na wieczność za zniszczenie ich domu. Kto wie, co?%SPEECH_OFF%Najemnik szybko wkłada artefakt do sakiewki. | Patrzysz na artefakt. Jest gładki i nieruchomy, nie coś, czego spodziewałbyś się po wielkiej mocy, ale z jakiegoś powodu to właśnie jest najbardziej niepokojące. Szybko chowasz go do sakiewki. | Wkładasz artefakt do sakiewki tylko po to, by zaczął świecić i wzywać cię. Otwierasz worek i patrzysz w dół na dwie czerwone kropki wpatrujące się w ciebie. %randombrother% pyta, czy wszystko w porządku. Szybko zamykasz sakiewkę i kiwasz głową. | Wreszcie masz artefakt. Nie świeci, nie brzęczy, nawet nie wygląda zbyt ładnie. Nie jesteś pewien, o co tyle hałasu, ale jeśli %employer% chce ci za to zapłacić, to jego sprawa. | Cóż, masz artefakt. %randombrother% podchodzi, drapiąc się po głowie.%SPEECH_ON%To za to małe coś zginęło tylu ludzi?%SPEECH_OFF%Artefakt grzechocze, a warczący głos odpowiada.%SPEECH_ON%Nie zginęli. Są teraz ze mną i na zawsze.%SPEECH_OFF%Najemnik odskakuje.%SPEECH_ON%Wiesz co? Nie słyszałem tego. Nie wiem, co to było. Nie obchodzi mnie to. Nie. Wracam do jedzenia twardego, czerstwego chleba i nudnego życia, dziękuję bardzo.%SPEECH_OFF% | Trzymasz artefakt, używając między nim a sobą szmaty, by jego moc nie przeniknęła do twojego ciała. Oczywiście wygląda tylko jak ozdobny kawałek kamienia, ale ostrożność nie zaszkodzi. %employer% powinien się ucieszyć na jego widok i niech go trzyma, jak zechce, jeśli o ciebie chodzi. | Artefakt wygląda dziwnie, ale nic nadzwyczajnego. Jak dla ciebie, to mógł być projekt jakiegoś włóczęgi, który ktoś inny wziął za boski przedmiot. %randombrother% wpatruje się w niego.%SPEECH_ON%Szczerze mówiąc, wysrałem ładniejsze rzeczy niż to.%SPEECH_OFF%Ostrzegasz go, że jeśli ta relikwia naprawdę ma moce, może zapłacić za ten komentarz. Wzrusza ramionami.%SPEECH_ON%Nie zmienia to faktów.%SPEECH_OFF% | Podnosisz relikwię i nagle staje się ciężka, więc opuszczasz ją. Gdy zniżasz ją ku stopom, robi się lżejsza, jakby chciała zostać podniesiona z powrotem. To wystarczająco dziwne, więc szybko ją chowasz i szykujesz się do powrotu do %employer%a. | Wreszcie zdobyłeś artefakt. Wpatrujesz się w niego, gdy podchodzi %randombrother%.%SPEECH_ON%To tego chce %employer%? Cholera, mógłbym coś takiego zrobić i oszczędzić nam całego kłopotu.%SPEECH_OFF%Chowasz artefakt do worka i odpowiadasz.%SPEECH_ON%Myślę, że w końcu by poznał, że to podróbka.%SPEECH_OFF%Najemnik unosi palec.%SPEECH_ON%Słowo klucz: w końcu.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Mamy to, po co przyszliśmy. Czas wracać!",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "TooLateBribeRefused",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{Przywódca złodziei śmieje się i kręci głową.%SPEECH_ON%Ty serio właśnie... no, naprawdę?%SPEECH_OFF%Robi krok do przodu i ciągnie dalej.%SPEECH_ON%Warto było spróbować, ale odpowiedź brzmi: nie.%SPEECH_OFF%Powoli dobywa ostrza. Metal lśni, gdy kieruje je w twoją stronę.%SPEECH_ON%Stanowcze nie.%SPEECH_OFF% | Twoja próba przekupstwa nie została przyjęta. Złodzieje nie tylko odmówili, ale i poczuli się urażeni, więc atakują! Widocznie wśród tych złodziei jest trochę honoru! | Przywódca złodziei prycha.%SPEECH_ON%Łapówka? Nie. Nie zaszliśmy tak daleko i nie wycierpieliśmy tego, co wycierpieliśmy, żeby zrobić marną wymianę. Hej, chłopaki, co wy na to, żeby teraz oni pocierpieli?%SPEECH_OFF%Grupa bandytów wiwatuje i dobywa broni. Ich przywódca kieruje ostrze w stronę %companyname%.%SPEECH_ON%Szykujcie się na śmierć, najemnicy.%SPEECH_OFF% | Składasz ofertę łapówki i zostaje szybko odrzucona. Przywódca bandytów i ty kiwacie głowami. Jedno jest jasne: nikt nie wróci z pustymi rękami. Szykować się do walki! | Bandyci zbierają się w grupę i rozmawiają szeptem. W końcu przywódca wychodzi, dłonie na biodrach, pierś dumnie wypięta. Kręci głową.%SPEECH_ON%Z szacunkiem odmawiamy oferty. Teraz przepuśćcie nas albo szykujcie się do walki.%SPEECH_OFF%%employer% nie płaci ci za powrót z pustymi rękami. Rozkazujesz %companyname% ustawić się w szyku. Bandyta wzdycha i dobywa miecza.%SPEECH_ON%Niech będzie!%SPEECH_OFF% | Bandyci śmieją się z twojej oferty. Wygląda na to, że uznali ją za oznakę słabości, bo wszyscy dobywają broni. Uważałeś, że oferta była uczciwa, ale wygląda na to, że ci ludzie chcą sprzedać przedmiot za najwyższą cenę. Trudno. Szykować się do walki! | Przywódca złodziei śmieje się.%SPEECH_ON%Ciekawa oferta, ale nie. Myślę, że obaj wiemy, że ten mały artefakt jest wart więcej niż to, i na pewno więcej niż cokolwiek innego, co możesz zaoferować. Teraz zejdź nam z drogi.%SPEECH_OFF%%companyname% ustawia się w szyku, dobywając broni. %randombrother% spluwa.%SPEECH_ON%Możemy ich wszystkich zabić, panie, tylko wydaj rozkaz.%SPEECH_OFF%Masz pełną wiarę w %companyname%, bo to religia bezwzględnej przemocy. Czas praktykować to, co głosimy! | Przywódca bandytów sięga do worka i wyciąga głowę. Jest trupioblado-szara i zwisa na włosach napiętych między jego palcami.%SPEECH_ON%Tak skończyli ostatni ludzie, którzy stanęli nam na drodze. Z szacunkiem odrzucamy twoją ofertę, najemniku. Teraz zejdź nam z drogi albo tutaj kończą się moje uprzejmości.%SPEECH_OFF%Śmiejesz się i odpowiadasz.%SPEECH_ON%Jesteśmy %companyname% i szkoda, że nikt nie wie, kim jesteście, bo nie będzie się czym chwalić, gdy zabijemy was wszystkich co do jednego.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						this.Contract.getActiveState().onCombatWithNemesis(this.Contract.m.Destination, false);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "TooLateBribeAccepted",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{Po krótkiej dyskusji złodzieje zgadzają się na twoją ofertę. Oddajesz korony, oni oddają artefakt. Poszło łatwiej, niż się spodziewałeś. | Bandyci naradzają się między sobą, stłoczeni i co jakiś czas spoglądający na ciebie. To dziwne przeżycie, zważywszy, że za kilka minut możecie się wzajemnie mordować w zależności od tego, co zdecydują. W końcu przerywają naradę, a przywódca macha do ciebie.%SPEECH_ON%Nasz zleceniodawca nie będzie zadowolony, ale tych koron nie da się tak po prostu odrzucić. Masz układ, najemniku.%SPEECH_OFF% | Bandyci kłócą się o twoją ofertę. Jedni mówią, że ich zleceniodawca będzie wściekły, jeśli wrócą z pustymi rękami, inni twierdzą, że nie warto za to umierać. Ci drudzy wygrywają. Dostajesz artefakt w zamian za korony. | Uczciwa grupa próbowałaby walczyć z %companyname%, ale masz do czynienia ze złodziejami, a nie z ludźmi nieskazitelnej czci. Zgadzają się oddać artefakt za korony. | Przywódca złodziei dobywa miecza.%SPEECH_ON%Myślisz, że kiedykolwiek przyjęlibyśmy tę o...%SPEECH_OFF%Strumień krwi kończy to słowo i rozpryskuje się na długości ostrza, które nagle wystaje z jego piersi. Oczy bandyty wywracają się, gdy zabójca stawia mu but na plecach i zrzuca go z ostrza. Zabójca czyści broń.%SPEECH_ON%Nie będziemy ginąć za tego skurczybyka. Twoja oferta zostaje przyjęta, najemniku.%SPEECH_OFF% | Wśród złodziei wybucha spór. Jedni uważają, że mogą z tobą walczyć, inni lepiej wiedzą, kim jest %companyname%, i ta druga strona stanowczo sprzeciwia się wrogości. W końcu dochodzą do porozumienia: łapówka zostaje przyjęta. | Twoja oferta zapłaty za artefakt wzbudza sporą debatę wśród złodziei. Kłócą się przyciszonymi głosami, ale ich szybkie spojrzenia sugerują, że uważają cię za poważne zagrożenie. W końcu przerywają naradę i zgadzają się na twoje warunki. Cieszysz się, że nie doszło do rozlewu krwi. | Złodzieje parskają.%SPEECH_ON%Myślisz, że możemy wrócić do naszych dobroczyńców z pustymi rękami?%SPEECH_OFF%Przeczesujesz włosy dłonią i odpowiadasz.%SPEECH_ON%Lepsze to niż nie wrócić wcale, prawda?%SPEECH_OFF%Każdy złodziej ostrożnie cofa się o krok. Ich przywódca kręci głową, po czym kiwa nią w jednym szybkim ruchu.%SPEECH_ON%Cholera, najemniku, stawiasz nas w kropce. Ale dobrze, przyjmujemy.%SPEECH_OFF%Artefakt zostaje przekazany, a przemocy udaje się uniknąć. | Przywódca złodziei odwraca się do swojej bandy i pyta szczerze.%SPEECH_ON%No jak, chłopaki, myślicie, że damy radę?%SPEECH_OFF%Jeden wzrusza ramionami.%SPEECH_ON%Myślę, że damy radę wziąć to złoto, które oferują.%SPEECH_OFF%Inny wtrąca.%SPEECH_ON%To miała być wyprawa, nie płacą nam dość, żeby umierać za ten przeklęty artefakt.%SPEECH_OFF%Powoli bandyci dochodzą do porozumienia: wezmą łapówkę zamiast dać się wyrżnąć. Rozsądna decyzja według większości miar.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Słuszny wybór.",
					function getResult()
					{
						this.Contract.m.Destination.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
						return "TooLate3";
					}

				}
			],
			function start()
			{
				local bribe = this.Contract.beautifyNumber(this.Contract.m.Payment.Pool * 0.4);
				this.World.Assets.addMoney(-bribe);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + bribe + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "Trap",
			Title = "%objective%",
			Text = "[img]gfx/ui/events/event_12.png[/img]{Przekraczasz drut i każesz %hurtbro%owi uważać. On tego nie robi i pada ofiarą mechanizmu pułapkarza za swoją nieuwagę. | Podłoga ruin jest najeżona oczywistymi pułapkami i śmiercionośnymi mechanizmami. Udaje ci się przejść przez wszystko bez problemu, aż %hurtbro%, sądząc, że jest już bezpiecznie, nagle rusza naprzód. Uruchamia się starożytna maszyneria i sądzisz, że całe miejsce zaraz zawali się na wasze głowy. Na szczęście za brak rozsądku płaci tylko najemnik. | Ruiny są zastawione pułapkami, a %hurtbro% udaje się jedną uruchomić. | Stopa %hurtbro%a trafia na cegłę, która szybko zapada się w podłogę. Za ścianami dudni starożytna maszyneria, a sufit zaczyna się kruszyć. Mimo całego hałasu pułapka jest dość mała, a najemnik przeżyje. | Glify na ścianie opowiadają starożytne przemyślenia za pomocą obrazków. Niestety, ludziki są tak nieporadnie narysowane, że nie dostrzegasz, iż to ostrzeżenia, aż jest za późno: %hurtbro% wchodzi w pułapkę i płaci za twoje słabe tłumaczenia. | Powinieneś był to przewidzieć: ruiny są naszpikowane pułapkami, a %hurtbro% wpada prosto w jedną z nich. Przeżyje, a ty od teraz będziesz ostrożniejszy. | %hurtbro% uruchamia pułapkę i ponosi bolesne konsekwencje za brak ostrożności. | Dawno temu pewien człowiek usiadł, by stworzyć pułapkę. Dziś %hurtbro% wpada prosto w nią. | Uruchamiasz drut i słyszysz, jak ściany ożywają starożytną maszynerią. Kucasz i sądzisz, że jesteś bezpieczny, tylko po to, by odwrócić się i zobaczyć, że %hurtbro% przyjął na siebie ciężar obrażeń. Oops... | Dostrzegasz drut na ziemi i śmiejesz się. Tak blisko, starożytny pułapkarzu, tak blisko - nagle %hurtbro% przechodzi tuż obok ciebie i uruchamia pułapkę. Idiota przeżyje, ale czeka go wiele bólu. | %hurtbro% gwiżdże, a melodia niesie się głęboko w ruiny, lecz echo brzmi dziwnie, jakby gdzieś w ścianach czkało. Każesz ludziom trzymać pozycję, ale gwiżdżący idzie dalej i natychmiast zapada się przez podłogę w dół. Pędzisz na krawędź i widzisz, że ledwo ominął kolce. | Idąc przez ruiny, %hurtbro% uruchamia pułapkę, która zsyła go w dół przez podłogę. Ląduje na niższym poziomie pełnym dziur. Kolce wysuwają się, ale na tyle wolno, że mężczyzna zdąża się odsunąć. Na szczęście pułapka nie zadziałała we właściwej kolejności i udaje ci się wydostać najemnika. | Gdy kluczycie przez mylące ruiny, %hurtbro% nagle znika z pola widzenia. Rzucasz się tam, gdzie był, i niemal wpadasz w tę samą pułapkę: dół w ziemi zasłany chrupiącymi wylinkami węży. Na szczęście gadów już nie ma, ale sam upadek wystarczył, by dotkliwie poturbować biednego najemnika.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Bądź ostrożniejszy!",
					function getResult()
					{
						this.Contract.m.Dude = null;
						return "SearchingTheRuins";
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local bro = brothers[this.Math.rand(0, brothers.len() - 1)];
				local injury = bro.addInjury(this.Const.Injury.Accident1);
				this.Contract.m.Dude = bro;
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = bro.getName() + " cierpi na " + injury.getNameOnly()
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "ScavengerHunt",
			Title = "%objective%",
			Text = "[img]gfx/ui/events/event_57.png[/img]{Znajdujesz w ruinach mapę, która sugeruje, że relikwia znajduje się w ruinach zwanych %objective%, gdzieś %direction% stąd. | Niestety relikwii tu nie ma. Krótkie dochodzenie ujawnia, że popełniłeś błąd, przychodząc tutaj: tego, czego szukasz, należy szukać w %objective%, zaledwie %direction% stąd. | Cóż, trafiliście w złe miejsce. Ty i twoi ludzie robicie, co możecie, by rozszyfrować języki na ścianie i porównać je z tym, co macie na mapie. Z czasem dochodzicie do wniosku, że artefakt, którego szukacie, najpewniej znajduje się w ruinach zwanych %objective%, zaledwie %direction% stąd. | %randombrother% przynosi ci mapę i pod nosem przeklina.%SPEECH_ON%Chyba trafiliśmy w złe miejsce, panie. Spójrz.%SPEECH_OFF%Razem ustalacie, że artefakt najpewniej znajduje się w ruinach %direction% stąd, w miejscu zwanym %objective%. | Miałeś nadzieję znaleźć artefakt za jednym razem, ale nic z tego. Dzięki dokładnym poszukiwaniom kompania powoli odkrywa, że dotarła w złe miejsce. Musi udać się do %objective% %direction% stąd. | To nie te ruiny. Jakieś napisy na ścianach i wyraźny brak artefaktu mówią ci tyle. Po uważnych rozważaniach dochodzisz do wniosku, że relikwia jest w %objective% %direction% stąd. | Wspinając się po ruinach i nie znajdując niczego wartościowego, powoli pojmujesz, że to nie te ruiny. Ty i %randombrother% przez chwilę studiujecie mapę, po czym uznajecie, że artefakt znajduje się w miejscu zwanym %objective%, zaledwie %direction% stąd. | %randombrother% znajduje człowieka nadzianego na kolce uruchomione pułapką. Trzyma mapę w kościstym, gnijącym uścisku. Czytasz mapę i uświadamiasz sobie, że tak jak on, trafiłeś do niewłaściwych ruin. Artefakt jest w %objective% %direction% stąd. Dobrze, że ten przestraszony odkrywca dotarł tu przed tobą! | Znajdujesz zwłoki skulone u schodów prowadzących do pustego podium. Sądzisz, że relikwia miała tu być, ale zniknęła. Zmarły nie wydaje się jej mieć. %randombrother% grzebie w ubraniu ciała i znajduje złożoną mapę. Prowadzi do miejsca zwanego %objective%, gdzieś %direction% stąd.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Przygotujcie się do wymarszu!",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Destination = null;
				local myTile = this.World.State.getPlayer().getTile();
				local undead = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
				local lowestDistance = 9999;
				local best;

				foreach( b in undead )
				{
					if (b.isLocationType(this.Const.World.LocationType.Unique))
					{
						continue;
					}

					local d = myTile.getDistanceTo(b.getTile()) + this.Math.rand(0, 35);

					if (d < lowestDistance)
					{
						lowestDistance = d;
						best = b;
					}
				}

				this.Contract.m.Destination = this.WeakTableRef(best);
				this.Flags.set("DestinationName", this.Contract.m.Destination.getName());
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				this.Contract.m.Destination.clearTroops();
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.UndeadArmy, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.getActiveState().start();
				this.World.Contracts.updateActiveContract();
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Drzwi do %employer%a są otwarte i wchodzisz do środka. Odwraca się, patrząc na ciebie długim spojrzeniem i wzrokiem mówiącym: \'no i?\'. Wyciągasz artefakt i podajesz go. Szlachcic zrywa się na nogi z niespodziewaną energią.%SPEECH_ON%Masz go! Na starych bogów! Dawaj mi go!%SPEECH_OFF%Artefakt trafia w jego ręce, a oczy %employer%a rozszerzają się. Pytasz o zapłatę, ale on jest już w innym świecie, jakby został wciągnięty przez sam artefakt. Jeden z jego skrybów wychodzi z cienia w rogu. Wręcza ci sakiewkę %reward_completion% koron.%SPEECH_ON%Proszę wybaczyć, najemniku. Mój pan i ja mamy obowiązki do wypełnienia.%SPEECH_OFF% | %employer% zapadł się w fotel i być może jeszcze głębiej w swoje myśli. Jeden z jego strażników musi mu powiedzieć, że jesteś, powtarzając to trzy razy, zanim szlachcic podniesie wzrok. Patrzy na ciebie, potem na artefakt. Wstaje z fotela, jakby poruszany impetem niewidzialnej siły. Bierze artefakt, odwraca się i pędzi do biurka, gdzie go odkłada i kuca przed nim, niemal się kłaniając, obserwując go z atawistycznym zapałem. Strażnik wręcza ci sakiewkę %reward_completion% koron.%SPEECH_ON%Lepiej już idź, najemniku.%SPEECH_OFF% | Skryba %employer%a wita cię przed pokojem szlachcica. Czuć od niego stęchliznę ksiąg, a jego ruchy są nerwowe i pospieszne.%SPEECH_ON%To artefakt? To on?%SPEECH_OFF%Podajesz worek z relikwią. Palce skryby zaciskają się na ściągaczach jak dzioby dziobiące robaki.%SPEECH_ON%Dawaj! Dawaj! Masz tu pieniądze i idź!%SPEECH_OFF%Wciska ci sakiewkę %reward_completion% koron, po czym umyka do pokoju %employer%a. | Kilku skrybów czeka w pokoju %employer%a. Sam szlachcic śpi w łóżku, głową zwrócony do sufitu, ramiona wzdłuż ciała jak niedokończony manekin. Jeden ze skrybów robi krok naprzód.%SPEECH_ON%Relikwię, podaj ją.%SPEECH_OFF%To bardzo dziwne, ale nie obudzisz śpiącego pana. Pytasz o zapłatę. Inny skryba rzuca ci worek %reward_completion% koron, który ślizga się po kamiennej posadzce.%SPEECH_ON%Teraz połóż relikwię na ziemi i wyjdź.%SPEECH_OFF%Zabierasz pieniądze i odchodzisz. | Zastajesz %employer%a zabawiającego tłum szlachty. Gdy cię dostrzega ponad ich głowami, kończy pośpiesznie żarty i żegna się. Przeciska się przez salę, by przywitać cię szeptem.%SPEECH_ON%Masz relikwię?%SPEECH_OFF%Podajesz ją, a mężczyzna się uśmiecha. Wręcza ci worek %reward_completion% koron.%SPEECH_ON%Dobra robota, najemniku, ale powinieneś iść. To nie twoje towarzystwo. Zresztą nie moje też.%SPEECH_OFF%Mruga do ciebie i odprawia cię gestem. | Skryba zatrzymuje cię przed pokojem %employer%a. Przykłada palec do ust i kręci głową, po czym prowadzi cię dalej korytarzem. Przed paleniskiem starzec szybko rozgląda się i pociąga za pochodnię.%SPEECH_ON%Naciśnij ścianę, najemniku.%SPEECH_OFF%Robisz, jak każe. Okazuje się, że to nie kamień, lecz drewno. Płyta się przesuwa i wchodzisz do środka. %employer% jest tam wśród sterty ksiąg i dziwnych przedmiotów porozrzucanych po przydymionym, oświetlonym świecami pokoju. Pstryka palcami i podajesz artefakt. W zamian otrzymujesz sakiewkę %reward_completion% koron. Szlachcic przystaje, po czym spogląda na skrybę.%SPEECH_ON%Czekaj, to miejsce miało być tajne, co ty wyprawiasz?%SPEECH_OFF%Stary człowiek niezręcznie zaciska usta. Szlachcic ściska grzbiet nosa.%SPEECH_ON%Do cholery. Dobra, chyba znowu trzeba wezwać murarza.%SPEECH_OFF% | Znajdujesz %employer%a i przekazujesz mu artefakt. Wręcza ci sakiewkę %reward_completion% koron i tak po prostu transakcja zostaje zakończona. Cóż, to było antyklimatyczne. | %employer% stoi obok kilku swoich dowódców. Patrzą na ciebie, gdy wchodzisz, a szlachcic wyciąga dłoń nad biurkiem. Podchodzisz powoli i kładziesz relikwię na jego dłoni. Bierze ją, obraca, wpatruje się, po czym spogląda na ciebie. Pstryka palcami.%SPEECH_ON%Zapłaćcie najemnikowi.%SPEECH_OFF%Jeden z dowódców wręcza ci sakiewkę %reward_completion% koron i wkrótce zostajesz wyprowadzony z pokoju. | W pokoju szlachcica czeka na ciebie mężczyzna uderzająco podobny do %employer%a. Prosi, byś oddał relikwię, i robisz, jak każe. Mężczyzna zatrzymuje się, trzymając ją, jego oczy nerwowo błądzą. W końcu kładzie ją na ziemi i woła.%SPEECH_ON%Wygląda w porządku!%SPEECH_OFF%Nagle z boku pokoju pojawia się prawdziwy %employer%, ostrożnie podchodząc.%SPEECH_ON%Wybacz tę teatralność, ale są tu moce, których nie możesz zrozumieć.%SPEECH_OFF%Wątpisz, by artefakt mógł ożyć jako niedoszły zabójca, ale nie kwestionujesz wyraźnie obłąkanych procesów myślowych szlachcica. Przyjmujesz %reward_completion% koron i zadowolony odchodzisz. | %employer% spotyka cię przed swoim pokojem. Ma czerwoną i spoconą twarz, jakby niemal pilnował drzwi.%SPEECH_ON%Dobry wieczór, najemniku. Masz to, o co prosiłem?%SPEECH_OFF%Podajesz relikwię. Mężczyzna się uśmiecha i wręcza ci sakiewkę %reward_completion% koron. Odwraca się, by wrócić do pokoju, po czym zatrzymuje się.%SPEECH_ON%Hej, idź. Nie płacę ci za to, żebyś stał i patrzył, co robię.%SPEECH_OFF%Kiwasz głową i odchodzisz. Gdy wychodzisz, słyszysz otwierające się drzwi i krótki potok kobiecych odgłosów, zanim znów się zamkną. | Jeden z strażników %employer%a prowadzi cię do ogrodów, gdzie szlachcic dogląda upraw. Uczy młodego chłopca przycinać pomidory.%SPEECH_ON%Łodyga, idioto! Przetnij to, widzisz? Po co miałbyś kłuć jedzenie? Nigdy nie kłuj jedzenia! Najemniku!%SPEECH_OFF%Pan zrywa się na widok ciebie. Odsuwa chłopca na bok i podchodzi, pytając, czy masz relikwię. Podajesz ją i w zamian otrzymujesz %reward_completion% koron. Szlachcic przytakuje.%SPEECH_ON%Dobra robota, najemniku. Tracę wiarę w zdolności ludzi do robienia tego, o co ich proszę. Jestem pewien, że rozumiesz.%SPEECH_OFF%Nad ramionami szlachcica widzisz chłopca mordującego kolejną roślinę. Powoli kiwasz głową. | Podajesz relikwię %employer%owi. Wpatruje się w nią ze zmarszczonymi brwiami, gniewnie przesuwając palcami po biurku.%SPEECH_ON%Hmm, chyba to to. Trochę rozczarowujące, ale umowa to umowa.%SPEECH_OFF%Niechętnie przesuwa w twoją stronę worek %reward_completion% koron. | %employer% wita cię w swoim pokoju, oferując kielich wina. Pijesz, gdy skryba podchodzi i zabiera relikwię. Idzie na bok pokoju i zaczyna ją mierzyć, ważyć, a nawet... próbować? Ignorujesz te wyliczenia i pytasz o zapłatę. %employer% się uśmiecha.%SPEECH_ON%Pijesz to!%SPEECH_OFF%Zatrzymujesz kielich przy ustach. Szlachcic się śmieje.%SPEECH_ON%Żart, najemniku, wyluzuj! Proszę, %reward_completion% koron, jak się umówiliśmy.%SPEECH_OFF% | Otwierasz drzwi do pokoju %employer%a i widzisz szlachcica oraz kilku skrybów stojących przy stole. Wszędzie są fiolki i kolby o dziwnych kształtach, niektóre wypełnione jeszcze dziwniejszymi kolorami. Jeden ze skrybów podbiega do ciebie i wystrzeliwuje rękę z przesadnie dużych, luźnych rękawów, niczym węże wyskakujące z jaskini. Jedną ręką kradnie relikwię, a drugą wciska ci w pierś worek %reward_completion% koron. %employer% odprawia cię gestem.%SPEECH_ON%Wyjdź, najemniku, zrobiłeś już tyle, o ile prosiliśmy, i na tym twoje usługi są na razie zakończone.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Pozyskałeś artefakt ważny dla wojny");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isUndeadScourge())
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

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hurtbro",
			this.m.Dude == null ? "" : this.m.Dude.getName()
		]);
		_vars.push([
			"historian",
			this.m.Dude == null ? "" : this.m.Dude.getNameOnly()
		]);
		_vars.push([
			"objective",
			this.m.Flags.get("DestinationName")
		]);
		_vars.push([
			"nemesis",
			this.m.Flags.get("NemesisName")
		]);
		_vars.push([
			"nemesisS",
			this.m.Flags.get("NemesisNameS")
		]);
		_vars.push([
			"nemesisC",
			this.m.Flags.get("NemesisNameC")
		]);
		_vars.push([
			"bribe",
			this.beautifyNumber(this.m.Payment.Pool * 0.4)
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Destination.getTile())]
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isUndeadScourge())
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

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		this.contract.onDeserialize(_in);
	}

});

