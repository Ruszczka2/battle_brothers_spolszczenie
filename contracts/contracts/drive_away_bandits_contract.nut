this.drive_away_bandits_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		Reward = 0,
		OriginalReward = 0
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.drive_away_bandits";
		this.m.Name = "Przepędzenie Bandytów";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function generateName()
	{
		local vars = [
			[
				"randomname",
				this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]
			],
			[
				"randomtown",
				this.Const.World.LocationNames.VillageWestern[this.Math.rand(0, this.Const.World.LocationNames.VillageWestern.len() - 1)]
			]
		];
		return this.buildTextFromTemplate(this.Const.Strings.BanditLeaderNames[this.Math.rand(0, this.Const.Strings.BanditLeaderNames.len() - 1)], vars);
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local banditcamp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getNearestSettlement(this.m.Home.getTile());
		this.m.Destination = this.WeakTableRef(banditcamp);
		this.m.Flags.set("DestinationName", banditcamp.getName());
		this.m.Flags.set("RobberBaronName", this.generateName());
		this.m.Payment.Pool = 550 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Przepędź bandytów z miejsca zwanego " + this.Flags.get("DestinationName") + " na %direction% od %origin%"
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
				this.Contract.m.Destination.clearTroops();
				this.Contract.m.Destination.setLastSpawnTimeToNow();

				if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.BanditDefenders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);

				if (this.World.Assets.getBusinessReputation() >= 500 && this.Contract.getDifficultyMult() >= 0.95 && this.Math.rand(1, 100) <= 20)
				{
					this.Flags.set("IsRobberBaronPresent", true);

					if (this.World.Assets.getBusinessReputation() > 600 && this.Math.rand(1, 100) <= 50)
					{
						this.Flags.set("IsBountyHunterPresent", true);
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
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsRobberBaronDead"))
					{
						this.Contract.setScreen("RobberBaronDead");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Math.rand(1, 100) <= 10)
					{
						this.Contract.setScreen("Survivors1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Math.rand(1, 100) <= 10 && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
					{
						this.Contract.setScreen("Volunteer1");
						this.World.Contracts.showActiveContract();
					}

					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (this.Flags.get("IsRobberBaronPresent"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("AttackRobberBaron");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.BanditTracks;
						properties.Entities.push({
							ID = this.Const.EntityType.BanditLeader,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/enemies/bandit_leader",
							Faction = _dest.getFaction(),
							Callback = this.onRobberBaronPlaced.bindenv(this)
						});
						properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
						this.World.Contracts.startScriptedCombat(properties, true, true, true);
					}
				}
				else
				{
					this.World.Contracts.showCombatDialog();
				}
			}

			function onRobberBaronPlaced( _entity, _tag )
			{
				_entity.getFlags().set("IsRobberBaron", true);
				_entity.setName(this.Flags.get("RobberBaronName"));
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getFlags().get("IsRobberBaron") == true)
				{
					this.Flags.set("IsRobberBaronDead", true);
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
					if (this.Flags.get("IsRobberBaronDead"))
					{
						this.Contract.setScreen("Success2");
					}
					else
					{
						this.Contract.setScreen("Success1");
					}

					this.World.Contracts.showActiveContract();
				}

				if (this.Flags.get("IsRobberBaronDead") && this.Flags.get("IsBountyHunterPresent") && !this.TempFlags.get("IsBountyHunterTriggered") && this.World.Events.getLastBattleTime() + 7.0 < this.Time.getVirtualTimeF() && this.Math.rand(1, 1000) <= 2)
				{
					this.Contract.setScreen("BountyHunters1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsBountyHunterRetreat"))
				{
					this.Contract.setScreen("BountyHunters3");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "BountyHunters")
				{
					this.Flags.set("IsBountyHunterPresent", false);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "BountyHunters")
				{
					this.Flags.set("IsBountyHunterPresent", false);
					this.Flags.set("IsBountyHunterRetreat", true);
					this.Flags.set("IsRobberBaronDead", false);
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% wściekle kręci głową.%SPEECH_ON%Bandyci niszczą te okolice już zbyt długo! Wysłałem chłopaka, syna %randomname%, by ich odnalazł. I wiesz co? Wróciła tylko jego głowa. Oczywiście ci idioci przysłali jednego ze swoich, żeby ją dostarczył. Schwytaliśmy go i przesłuchaliśmy... więc teraz wiemy, gdzie są.%SPEECH_OFF%Mężczyzna odchyla się, kręcąc kciukami w zamyśleniu.%SPEECH_ON%Nie mam ludzi, ale mam korony - co powiesz na to, że wsunę kilka w twoją stronę, a ty wsuniesz miecz w ich stronę?%SPEECH_OFF% | %employer% nalewa sobie drinka, wpatruje się w kubek i nalewa jeszcze. Zdaje się wypija go jednym haustem, po czym beka swoją nowinę.%SPEECH_ON%Bandyci zabili %randomname% i całą jego rodzinę. Możesz w to uwierzyć? Wiem, że ich nie znasz, ale w tych stronach to była lubiana rodzina. Jestem pewien, że już możesz sobie wyobrazić, ale chcę, by z tymi bandytami skończyć. Połowę ludzi straciłem tylko na znalezienie ich obozu, a teraz jestem gotów wydać ha... część swoich koron, żebyś ich zabił. Jesteś zainteresowany?%SPEECH_OFF% | %employer% wygląda przez okno, tańcząc palcem po brzegu kielicha, ważąc swoje myśli.%SPEECH_ON%Bandyci podbierają nam cenne bydło. Przychodzą w nocy, bandyci, i przecinają dzwonki, żeby odejść bez hałasu. Wiem, że bydło może nie jest dla ciebie ważne, ale jedno cielę, jedna krowa, jeden byk? To majątek dla niektórych ludzi w tej okolicy.\n\nWięc ostatnio kazałem chłopakowi śledzić tropy zwierząt za miasto i teraz powiedział mi dokładnie, gdzie są ci bandyci. Jak się domyślasz, nie mam ludzi, by się z nimi rozprawić, ale koron... koron mi nie brakuje. Gdybym skrzyżował twoje dłonie z miedzią, skrzyżowałbyś tych bandytów ze stalą?%SPEECH_OFF% | %employer% wzdycha, jakby miał dość tych wszystkich kłopotów, jakby miał zacząć rozmowę, którą prowadził już wiele razy.%SPEECH_ON%%randomname%, człowiek tu trochę ważny, twierdzi, że bandyci dobierali się do jego córek. Teraz boi się, co zrobią następnym razem. Na szczęście ten człowiek ma trochę majątku i mógł bez trudu wytropić tych bandytów. Gdybym zapłacił ci porządną sumę, jak chętnie wbiłbyś jeden z tych swoich mieczy w bandytę czy dwóch?%SPEECH_OFF% | %employer% siada na krześle wystarczająco dużym, by było wygodne dla dwóch. Przerzuca kufel z ręki do ręki.%SPEECH_ON%Bandyci nękają nas już tygodniami i dopiero wczoraj próbowali podpalić gospodę. Możesz w to uwierzyć? Kto podpala coś takiego? Na szczęście ugasiliśmy to na czas, ale robi się tu źle. Jeśli grożą naszemu drogocennemu trunkowi, co zrobią dalej? Na szczęście udało nam się znaleźć, gdzie ci włóczędzy się ukrywają. Więc... tak, widzę twoje spojrzenie. To proste zadanie, najemniku: chcemy, żebyś zabił każdego ostatniego bandytę. Zgadzasz się z nami współpracować?%SPEECH_OFF% | Gdy siadasz, %employer% dopija kielich wina z kobry i wyrzuca go przez okno. Słyszysz, jak daleko, daleko stąd pustym dźwiękiem się roztrzaskuje. Odwraca się do ciebie.%SPEECH_ON%Podczas podróży traktami bandyci oblegli mój wóz i zwiali ze wszystkimi moimi towarami! Oszczędzili mi życie, i dobrze, ale bezczelność tego czynu nie daje mi spać. Widzę ich szydercze twarze... słyszę ich śmiech... Wierzę, że to była wiadomość: zaatakowali mnie, bo odmówiłem płacenia ich \"myt\". Cóż, teraz jestem gotów zapłacić myto - tobie, najemniku. Jeśli pójdziesz i wyrżniesz tych włóczęgów, zapłacę naprawdę solidne myto. Co ty na to?%SPEECH_OFF% | Gdy już masz zamiar usiąść, %employer% rzuca ci zwój. Rozwija się, gdy go łapiesz. Zaczynasz czytać, ale %employer% i tak zaczyna mówić.%SPEECH_ON%Kupcy z %randomtown% zgodzili się już nie handlować w %townname%, dopóki nasz mały problem z bandytami nie zostanie rozwiązany. Historia jest prosta, jak pewnie wiesz o bandyckich metodach, ale te cholerne włóczęgi nękają drogi, łupią karawany i zabijają kupców.\n\nWiem dokładnie, gdzie są, potrzebuję tylko człowieka z odwagą i głodnego chwały - lub złota! - by poszedł i ich zabił. Więc co powiesz, najemniku? Podaj cenę, a pogadamy.%SPEECH_OFF% | %employer% trzęsie się, gdy go witasz. Prawie kipi z gniewu - a może jest po prostu bardzo pijany.%SPEECH_ON%Mieszkańcy tego wspaniałego miasta głodują. Dlaczego? Bo bandyci zakradają się nocą, by rabować spichlerze! A gdy ich łapiemy, podpalają budynki! Nie możemy bronić się, siedząc z założonymi rękami... Teraz... chcę bronić się, zabijając ich wszystkich.%SPEECH_OFF%Mężczyzna chwieje się przez chwilę, jakby miał wylać się przez biurko. Stabilizuje się i ciągnie dalej.%SPEECH_ON%Chcę, żebyś poszedł i zabił tych włóczęgów, oczywiście. Wystarczy, że będziesz zainteresowany i... -hic-... podasz swoją cenę.%SPEECH_OFF% | %employer% spogląda posępnie w ziemię. Rozwija zwój, pokazując ci twarz.%SPEECH_ON%To %randomname%, poszukiwany bandyta, którego schwytaliśmy niedawno. Kiedyś dowodził bandą włóczęgów, którzy nękali i rabowali nasze miasto dniem i nocą. Problem w tym, że nie jest głową węża, tylko jedną głową hydry. Utniesz jedną kryminalną głowę, a na jej miejsce wyrasta inna. Jaka więc odpowiedź? Zabić ich WSZYSTKICH, oczywiście. I właśnie tego chcę, najemniku. Jesteś zainteresowany?%SPEECH_OFF% | %employer% odwraca się do ciebie, gdy rozglądasz się za miejscem do siedzenia.%SPEECH_ON%Hej, najemniku, jak długo minęło, odkąd nasyciłeś swój miecz krwią złych, okrutnych ludzi?%SPEECH_OFF%Porzuca sarkazm i orientujesz się, że będziesz stał.%SPEECH_ON%My, tutaj w %townname%, mamy mały spór z lokalnymi bandytami. Lokalnymi dla nas, to znaczy, z ich szczurzą norą niedaleko stąd. Oczywiście uważam, że odpowiedzią na ten problem jest wynajęcie kilku porządnie uzbrojonych ludzi, takich jak wasza mała kompania dobrych chłopaków. Więc, czy to wzbudza twoje zainteresowanie, najemniku, czy mam szukać twardszych ludzi do tego zadania?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{O ilu konkretnie koronach tu mówimy? | Ile %townname% jest gotowe zapłacić za swe bezpieczeństwo? | Porozmawiajmy o pieniądzach.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Nie jestem zainteresowany. | Mamy ważniejsze sprawy do załatwienia. | Życzę wam powodzenia, ale nie weźmiemy w tym udziału.}",
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
			ID = "AttackRobberBaron",
			Title = "Przed atakiem...",
			Text = "[img]gfx/ui/events/event_54.png[/img]{Podczas podglądania obozu bandytów zauważasz sylwetkę człowieka, o którym słyszałeś, jak miejscowi niemal z żarliwością go opisują: to %robberbaron%, sławny baron rabusiów, który terroryzuje te okolice. Wszędzie towarzyszy mu świta brutalnie wyglądających ludzi.\n\nZakładasz się, że jego głowa jest warta kilka dodatkowych koron. | Nie planowałeś go tu zobaczyć, ale to bez wątpienia on: %robberbaron% jest w obozie bandytów. Słynny zabójca najwyraźniej odwiedza jeden ze swoich kryminalnych odłamów, skrupulatnie krążąc pośród złodziei, wskazując tu i ówdzie, komentując jakość tego i tamtego.\n\nKilku ochroniarzy towarzyszy mu wszędzie. Szacujesz, że razem z resztą bandytów kręci się tu około %totalenemy% ludzi. | Kontrakt był tylko na wybicie bandytów, ale wygląda na to, że do kija dołożono drugą, znacznie cięższą marchew: %robberbaron%, niesławny zabójca i grabieżca traktem, jest w obozie. W towarzystwie ochroniarzy baron rabusiów zdaje się oceniać jeden ze swoich kryminalnych oddziałów.\n\nZastanawiasz się, ile w koronach ważyłaby głowa %robberbaron%a... | %robberbaron%. To on, wiesz to. Spoglądając przez lunetę, bez trudu widzisz sylwetkę niesławnego barona rabusiów, krążącego po obozie bandytów. Nie było go w twoich planach ani w umowie, ale nie ma wątpliwości, że jeśli przyniesiesz jego głowę do miasta, dostaniesz coś ekstra za kłopot. | Podczas podglądania bandytów - liczysz około %totalenemy% kręcących się ludzi - dostrzegasz postać, której wcale się nie spodziewałeś: %robberbaron%, niesławny baron rabusiów. On i jego ochrona muszą sprawdzać stan obozu.\n\nCo za szczęście! Jeśli przyniesiesz jego głowę swojemu zleceniodawcy, możesz zarobić mały bonus.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Przygotować się do ataku!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "RobberBaronDead",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Gdy bitwa dobiega końca, podchodzisz do martwego ciała %robberbaron%a i dwoma szybkimi uderzeniami miecza odcinasz mu głowę: pierwsze tnie mięso, drugie kość. Przebijasz haczykiem skórę na karku i przewlekasz linę, by przytroczyć ją do biodra. | Gdy walka się kończy, szybko odnajdujesz wśród trupów zwłoki %robberbaron%a. Nadal wygląda złowieszczo, nawet gdy kolor odpływa z jego ciała. Nadal wygląda dość złowieszczo, gdy odcinasz mu głowę, i choć nie widzisz już jego twarzy, gdy wrzucasz ją do jutowego worka, zakładasz, że i wtedy wygląda równie złowieszczo. | %robberbaron% leży martwy u twoich stóp. Odwracasz ciało i prostujesz kark, dając mieczowi lepszy cel. Wystarczą dwa dobre cięcia, by odciąć głowę, którą szybko wkładasz do worka. | Teraz, gdy nie żyje, %robberbaron% nagle przypomina ci wielu ludzi, których znałeś. Nie zatrzymujesz się jednak na tym deja vu: kilkoma szybkimi cięciami odcinasz mu głowę i wrzucasz do worka. | %robberbaron% stawiał dobry opór, a jego kark stawiał kolejny, ścięgna i kości nie chciały łatwo oddać głowy, gdy odbierałeś należną nagrodę. | Zabierasz głowę %robberbaron%a. %randombrother% wskazuje na nią, gdy przechodzisz obok.%SPEECH_ON%Co to jest? To głowa %robberbaron%a...?%SPEECH_OFF%Kiwasz głową przecząco.%SPEECH_ON%Nie, ten człowiek już nie żyje. To tylko premia.%SPEECH_OFF%}",
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
			ID = "BountyHunters1",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{Wracając po zapłatę za kontrakt, widzisz, jak kilku mężczyzn wychodzi na drogę. Jeden z nich wskazuje głowę %robberbaron%a.%SPEECH_ON%Jesteśmy najwyżej opłacanymi łowcami nagród w tych stronach i wygląda na to, że uszczknąłeś kawałek naszej roboty. Oddajcie nam tę głowę, a wszyscy dziś prześpią się w swoich łóżkach.%SPEECH_OFF%Śmiejesz się.%SPEECH_ON%Musisz się bardziej postarać. Głowa %robberbaron%a jest warta dużo koron, przyjacielu.%SPEECH_OFF%Przywódca tych rzekomych łowców nagród śmieje się prosto w twoją twarz. Unosi ciężki, wypchany worek.%SPEECH_ON%To jest %randomname%, jeden z bardziej poszukiwanych w tych stronach. A to...%SPEECH_OFF%Podnosi drugi worek.%SPEECH_ON%To głowa człowieka, który go zabił. Rozumiesz? Więc oddaj nagrodę i rozejdziemy się w pokoju.%SPEECH_OFF% | Mężczyzna wychodzi na drogę, prostuje się i pozuje w twoją stronę.%SPEECH_ON%Witam, szanowni panowie. Sądzę, że macie przy sobie głowę %robberbaron%a.%SPEECH_OFF%Kiwasz głową. Mężczyzna się uśmiecha.%SPEECH_ON%Czy zechciałbyś grzecznie mi ją przekazać.%SPEECH_OFF%Śmiejesz się i kręcisz głową. Mężczyzna nie uśmiecha się, zamiast tego podnosi rękę i pstryka palcami. Z pobliskich krzaków wylewa się tłum dobrze uzbrojonych ludzi, maszerujących na drogę wśród ciężkich metalicznych brzęków. Wyglądają jak coś, o czym mógłby marzyć skazaniec w noc przed egzekucją. Ich przywódca błyska złotawym uśmiechem.%SPEECH_ON%Nie będę cię prosił drugi raz.%SPEECH_OFF% | Gdy rozmawiasz z %randombrother%, głośny okrzyk zwraca twoją uwagę. Spoglądasz w górę drogi i widzisz tłum ludzi stojących na twojej drodze. Mają wszelkiego rodzaju broń i zbroje. Ich herszt wychodzi do przodu, ogłaszając, że są słynnymi łowcami nagród.%SPEECH_ON%Chcemy tylko głowy %robberbaron%a.%SPEECH_OFF%Wzruszasz ramionami.%SPEECH_ON%My go zabiliśmy, my odbieramy nagrodę za jego głowę. A teraz zejdźcie nam z drogi.%SPEECH_OFF%Gdy robisz krok naprzód, łowcy nagród unoszą broń. Ich przywódca robi krok w twoją stronę.%SPEECH_ON%Tu trzeba podjąć decyzję, która może zabić wielu dobrych ludzi. Wiem, że to niełatwe, ale radzę bardzo dokładnie to przemyśleć.%SPEECH_OFF% | Ostry gwizd przyciąga uwagę twoją i twoich ludzi. Odwracasz się na bok drogi i widzisz grupę mężczyzn wychodzących z krzaków. Wszyscy chwytają za broń, ale obcy nie ruszają się ani o krok dalej. Ich przywódca wychodzi do przodu. Przez pierś ma przewieszony pas uszu, podsumowanie swojej roboty.%SPEECH_ON%Witajcie, chłopaki. My tu jesteśmy łowcami nagród, jeśli nie zauważyliście, i wygląda na to, że macie jedną z naszych nagród.%SPEECH_OFF%Podnosisz głowę %robberbaron%a.%SPEECH_ON%Masz na myśli to?%SPEECH_OFF%Przywódca uśmiecha się ciepło.%SPEECH_ON%Oczywiście. A teraz, jeśli możesz ją przekazać, będzie nam z przyjaciółmi bardzo miło.%SPEECH_OFF%Opukując rękojeść miecza, mężczyzna uśmiecha się szeroko.%SPEECH_ON%To tylko kwestia interesów. Jestem pewien, że rozumiesz.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zabierzcie ten cholerny łeb i odejdźcie.",
					function getResult()
					{
						this.Flags.set("IsRobberBaronDead", false);
						this.Flags.set("IsBountyHunterPresent", false);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractPoor);
						return "BountyHunters2";
					}

				},
				{
					Text = "{Będziecie musieli zapłacić krwią, skoro aż tak bardzo wam na nim zależy. | Jeśli chcesz, by i twój łeb dołączył do mojej kolekcji, to śmiało, spróbuj szczęścia.}",
					function getResult()
					{
						this.TempFlags.set("IsBountyHunterTriggered", true);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.BanditTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "BountyHunters";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.BountyHunters, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BountyHunters2",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_07.png[/img]Widziałeś już dość przelewu krwi jak na jeden dzień, więc oddajesz głowę.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ruszajmy dalej. Nadal mamy zapłatę do odebrania.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BountyHunters3",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_07.png[/img]Łowcy nagród okazali się zbyt silnym przeciwnikiem dla waszej kompanii! Nie chcą, by twoi ludzie bezsensownie ginęli, wydajesz rozkaz do szybkiego odwrotu. Niestety, głowa bandyty gdzieś zaginęła podczas całego tego chaosu, więc %robberbaron% nie zapewni ci dodatkowego zarobku...",
			Image = "",
			List = [],
			Options = [
				{
					Text = "No cóż. Nadal mamy zapłatę do odebrania.",
					function getResult()
					{
						this.Flags.set("IsBountyHunterRetreat", false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivors1",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Gdy bitwa dobiega końca, kilku wrogów pada na kolana i błaga o litość. %randombrother% spogląda na ciebie, oczekując decyzji. | Po bitwie twoi ludzie zbierają pozostałych bandytów. Ocaleni błagają o życie. Jeden wygląda bardziej na dzieciaka niż na mężczyznę, ale jest najcichszy ze wszystkich. | Uświadomiwszy sobie klęskę, kilku ostatnich bandytów porzuca broń i prosi o litość. Zastanawiasz się, co by zrobili, gdyby role się odwróciły. | Bitwa skończona, ale decyzje wciąż przed tobą: kilku bandytów przeżyło starcie. %randombrother% stoi nad jednym z nich, z mieczem przy szyi jeńca, i pyta, co chcesz zrobić.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Poderżnąć im gardła.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-1);
						return "Survivors2";
					}

				},
				{
					Text = "Odebrać im broń i przegonić ich.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(2);
						return "Survivors3";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivors2",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Altruizm jest dla naiwnych. Każesz wymordować jeńców. | Przypominasz sobie, ile razy bandyci zabijali bezbronnych kupców. Myśl ledwie się pojawia, gdy wydajesz rozkaz egzekucji jeńców. Próbują zaprotestować, ale miecze i włócznie szybko to uciszają. | Odwracasz się.%SPEECH_ON%Przez szyje. Szybko.%SPEECH_OFF%Najemnicy wykonują rozkaz i wkrótce słyszysz bulgot umierających ludzi. Nie jest to szybkie wcale. | Kręcisz głową na "nie". Jeńcy krzyczą, ale ludzie już na nich wpadają, tnąc, rąbiąc i kłując. Ci, którzy mają szczęście, zostają ścięci, zanim zdążą pojąć, jak bliska jest ich śmierć. Ci, co mają w sobie walkę, cierpią do samego końca. | Litość wymaga czasu. Czasu, by obejrzeć się przez ramię. Czasu, by zastanowić się, czy to była właściwa decyzja. Ty nie masz czasu. Ty nie masz litości. Jeńcy zostają straceni, a to zajmuje bardzo mało czasu.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Mamy ważniejsze rzeczy, którymi musimy się zająć.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivors3",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Jak na jeden dzień było dość zabijania i umierania. Pozwalasz jeńcom odejść, zabierając im broń i zbroje, zanim ich wypuszczasz. | Łaska dla złodziei i bandytów nie zdarza się często, więc gdy ich wypuszczasz, niemal całują ci stopy, jakbyś był bogiem. | Myślisz przez chwilę, po czym kiwasz głową.%SPEECH_ON%Niech będzie litość. Zabierzcie ich sprzęt i puśćcie wolno.%SPEECH_OFF%Jeńcy zostają wypuszczeni, zostawiając broń i zbroje, które mieli. | Każesz bandytom rozebrać się do bielizny - o ile ją w ogóle mają - po czym wypuszczasz ich wolno. %randombrother% grzebie w pozostawionym sprzęcie, a ty patrzysz, jak grupa półnagich mężczyzn ucieka.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nie płacą nam za zabicie ich.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Volunteer1",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Gdy bitwa się kończy i zapada cisza, słyszysz krzyk mężczyzny. Idziesz w stronę hałasu i znajdujesz więźnia bandytów. Ma zawiązane usta i ręce, które szybko rozwiązujesz. Gdy łapie oddech, nieśmiało pyta, czy mógłby dołączyć do twojej kompanii. | Znajdujesz więźnia związanego w obozie bandytów. Uwalniasz go, a on wyjaśnia, że pochodzi z %randomtown% i został porwany przez włóczęgów zaledwie kilka dni temu. Pyta, czy mógłby dołączyć do twojej bandy najemników. | Przeszukując resztki obozu bandytów, odkrywasz ich więźnia. Uwalniasz go, a mężczyzna siada i wyjaśnia, że bandyci porwali go, gdy jechał do %randomtown% w poszukiwaniu pracy. Zastanawiasz się, czy nie mógłby pracować dla ciebie... | Po bitwie został jeden mężczyzna. To nie bandyta, lecz ich więzień. Gdy pytasz, kim jest, mówi, że pochodzi z %randomtown% i szuka pracy. Pytasz, czy potrafi władać mieczem. Kiwając głową, potwierdza.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Równie dobrze możesz do nas dołączyć.",
					function getResult()
					{
						return "Volunteer2";
					}

				},
				{
					Text = "Wracaj do domu.",
					function getResult()
					{
						return "Volunteer3";
					}

				}
			],
			function start()
			{
				local roster = this.World.getTemporaryRoster();
				this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
				this.Contract.m.Dude.setStartValuesEx(this.Const.CharacterLaborerBackgrounds);

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Volunteer2",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Mężczyzna dołącza do twoich szeregów, wtapiając się w tłum braci, którzy przyjmują go dość ciepło jak na grupę płatnych zabójców. Nowo zatrudniony twierdzi, że dobrze radzi sobie z każdą bronią, ale uznajesz, że to ty zdecydujesz, w czym jest najlepszy. | Więzień uśmiecha się od ucha do ucha, gdy kiwasz mu, by podszedł. Kilku braci pyta, jaką broń mu dać, ale wzruszasz ramionami i postanawiasz sam zdecydować, w co go uzbroić.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Znajdźmy ci jakąś broń.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
				this.World.getPlayerRoster().add(this.Contract.m.Dude);
				this.World.getTemporaryRoster().clear();
				this.Contract.m.Dude.onHired();
				this.Contract.m.Dude = null;
			}

		});
		this.m.Screens.push({
			ID = "Volunteer3",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Kręcisz głową na "nie". Mężczyzna się marszczy.%SPEECH_ON%Jesteś pewien? Jestem całkiem dobry w...%SPEECH_OFF%Ucinasz mu.%SPEECH_ON%Jestem pewien. A teraz ciesz się nowo odzyskaną wolnością, nieznajomy.%SPEECH_OFF% | Oceniasz mężczyznę i uznajesz, że nie nadaje się do życia najemnika.%SPEECH_ON%Dziękujemy za ofertę, nieznajomy, ale życie najemnika jest niebezpieczne. Wróć do swojej rodziny, do swojej pracy, do domu.%SPEECH_OFF% | Masz dość ludzi, by sobie poradzić, choć kusi cię, by zastąpić %randombrother%a tylko po to, by zobaczyć reakcję na degradację. Zamiast tego podajesz więźniowi dłoń i odsyłasz go w drogę. Choć rozczarowany, dziękuje ci za uwolnienie.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Zmykaj już.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
				this.World.getTemporaryRoster().clear();
				this.Contract.m.Dude = null;
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Wracasz do %townname% i rozmawiasz z %employer%em. Szczegóły twojej podróży są proste: zabiłeś bandytów. Kiwając głową, uśmiecha się krótko, po czym przekazuje ci zapłatę, jak ustalono.%SPEECH_ON%Dobra robota, panowie. Ci bandyci sprawiali nam sporo kłopotów.%SPEECH_OFF% | %employer% otwiera ci drzwi, gdy docierasz do jego domu. Trzyma w ręku sakiewkę i unosi ją.%SPEECH_ON%Wnioskuję po twoim powrocie, że bandyci nie żyją?%SPEECH_OFF%Kiwasz głową. Mężczyzna przerzuca sakiewkę w twoją stronę. Mówisz mu, że mógłbyś kłamać. %employer% wzrusza ramionami.%SPEECH_ON%Możliwe, ale wieści szybko docierają o tych, którzy gryzą rękę, która karmi. Dobra robota, najemniku. O ile, rzecz jasna, nie kłamiesz - wtedy cię znajdę.%SPEECH_OFF% | %employer% uśmiecha się, gdy wchodzisz do jego komnaty i kładziesz na biurku worek z głową.%SPEECH_ON%Nie musisz brudzić moich ozdób, by pokazać, że wykonałeś zadanie, najemniku. Już dostałem wieść o twoim sukcesie - ptaki w tych stronach latają szybko, prawda? Twoja zapłata jest w rogu.%SPEECH_OFF% | Gdy kończysz raport, %employer% ociera czoło chustką.%SPEECH_ON%Naprawdę, wszyscy nie żyją? Chłopie... nie masz pojęcia, ile mi z barków zdjąłeś, najemniku. Żadnego pojęcia! Twoje korony, jak obiecałem.%SPEECH_OFF%Kładzie na biurku sakiewkę, a ty szybko ją zabierasz. Wszystko jest, jak obiecano. | %employer% popija z kielicha i kiwa głową.%SPEECH_ON%Wiesz, nie przepadam za waszym sortem, ale dobra robota, najemniku. %randomname% zameldował mi, zanim tu w ogóle dotarłeś, że wszyscy bandyci zostali zabici. Z jego opisu wynika, że to była naprawdę dobra robota. I cóż...%SPEECH_OFF%Rzuca sakiewkę na biurko.%SPEECH_ON%Oto porządna zapłata, jak obiecałem.%SPEECH_OFF% | %employer% odchyla się w fotelu, splatając dłonie na kolanach.%SPEECH_ON%Najemnicy nie budzą sympatii u wielu ludzi, pewnie dlatego, że potraficie zniszczyć całe wioski z byle powodu, ale przyznam, że spisaliście się dobrze.%SPEECH_OFF%Kiwa głową w stronę rogu pokoju, gdzie stoi nieotwarta drewniana skrzynia.%SPEECH_ON%Wszystko tam jest, ale nie obrażę się, jeśli zechcesz to policzyć.%SPEECH_OFF%I faktycznie liczysz - wszystko się zgadza. | Biurko %employer%a przykryte jest zabrudzonymi, rozwiniętymi zwojami. Uśmiecha się do nich ciepło, jakby szeptał do sterty skarbów.%SPEECH_ON%Handlowe układy! Handlowe układy wszędzie! Zadowoleni rolnicy! Zadowolone rodziny! Wszyscy zadowoleni! Ach, dobrze być mną. I oczywiście dobrze być tobą, najemniku, bo twoje kieszenie właśnie zrobiły się trochę cięższe!%SPEECH_OFF%Mężczyzna rzuca w twoją stronę małą sakiewkę, potem kolejną i następną.%SPEECH_ON%Mógłbym zapłacić większą sakiewką, ale po prostu lubię to robić.%SPEECH_OFF%Z figlarnym uśmiechem rzuca kolejną sakiewkę, którą łapiesz z chłodnym spokojem człowieka, który wciąż ma świeżą krew na mieczu.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Zniszczyłeś obozowisko bandytów");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] koron"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Rzucasz głowę bandyty na stół %employer%a. Z uśmiechem wskazujesz ją palcem.%SPEECH_ON%To %robberbaron%.%SPEECH_OFF%%employer% wstaje i odsłania jutowy worek przykrywający trofeum. Kiwając głową, potwierdza.%SPEECH_ON%Tak, to on. Wygląda na to, że dostaniesz za to coś ekstra.%SPEECH_OFF%Dostajesz porządną sumę %reward% koron za zabicie bandytów oraz zniszczenie przywództwa wielu pobliskich band. | %employer% odchyla się, gdy wchodzisz do jego komnaty, niosąc głowę za włosy. Na szczęście nie kapie.%SPEECH_ON%To jest %robberbaron%. A może był?%SPEECH_OFF%Powoli wstając, %employer% rzuca krótkie spojrzenie.%SPEECH_ON%"Był" pasuje... Więc nie tylko zniszczyłeś szczurzą norę bandytów, ale przyniosłeś mi głowę ich przywódcy. To bardzo dobra robota, najemniku, i dostaniesz za to coś ekstra.%SPEECH_OFF%Mężczyzna podaje ci sakiewkę z %original_reward% koron, a potem wyciąga własną sakiewkę i rzuca ją w twoją stronę. | Unosisz głowę %robberbaron%a, a jej przekrzywione spojrzenie opada na splątane, zakrwawione pasma włosów. Na twarzy %employer%a pojawia się powolny uśmiech.%SPEECH_ON%Wiesz, co zrobiłeś, najemniku? Wiesz, jak wielką ulgę przyniosłeś tym okolicom, usuwając temu człowiekowi głowę z barków? Dostaniesz więcej, niż się targowałeś! %original_reward% koron za pierwotne zadanie i...%SPEECH_OFF%Mężczyzna przesuwa po stole ciężką sakiewkę.%SPEECH_ON%Małe coś za ten... dodatkowy ciężar, który nosiłeś.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "W pełni zasłużona zapłata.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Zniszczyłeś obozowisko bandytów");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() * 2;
				this.Contract.m.OriginalReward = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] koron"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"reward",
			this.m.Reward
		]);
		_vars.push([
			"original_reward",
			this.m.OriginalReward
		]);
		_vars.push([
			"robberbaron",
			this.m.Flags.get("RobberBaronName")
		]);
		_vars.push([
			"totalenemy",
			this.m.Destination != null && !this.m.Destination.isNull() ? this.beautifyNumber(this.m.Destination.getTroops().len()) : 0
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Destination.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/ambushed_trade_routes_situation"));
		}
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

		if (this.m.Home != null && !this.m.Home.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Home.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(4);
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
		_out.writeI32(0);

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
		_in.readI32();
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		this.contract.onDeserialize(_in);
	}

});

