this.obtain_item_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		RiskItem = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.obtain_item";
		this.m.Name = "Zdobycie Artefaktu";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local camp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getNearestSettlement(this.m.Home.getTile());
		this.m.Destination = this.WeakTableRef(camp);
		this.m.Flags.set("DestinationName", camp.getName());
		local items = [
			"Piszczel Sir Gerhardta",
			"Flakonik Krwi Matki Świętej",
			"Całun Założyciela",
			"Kamień Starszych",
			"Kij Przezorności",
			"Pieczęć Słońca",
			"Dysk Mapy Gwiazd",
			"Zwój Przodków",
			"Skamieniały Almanach",
			"Płaszcz Sir Istvana",
			"Kij Złotych Żniw",
			"Pamflety Proroka",
			"Chorągiew Przodków",
			"Pieczęć Fałszywego Króla",
			"Flet Rozpustnika",
			"Kości Przeznaczenia",
			"Fetysz Płodności"
		];
		this.m.Flags.set("ItemName", items[this.Math.rand(0, items.len() - 1)]);
		this.m.Payment.Pool = 500 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Zdobądź %item% z miejsca zwanego %location%"
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
				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.UndeadArmy, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());

				if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.m.Destination.setDiscovered(true);
				this.Contract.m.Destination.m.IsShowingDefenders = false;
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					this.Flags.set("IsRiskReward", true);
					local i = this.Math.rand(1, 6);
					local item;

					if (i == 1)
					{
						item = this.new("scripts/items/weapons/ancient/ancient_sword");
					}
					else if (i == 2)
					{
						item = this.new("scripts/items/weapons/ancient/bladed_pike");
					}
					else if (i == 3)
					{
						item = this.new("scripts/items/weapons/ancient/crypt_cleaver");
					}
					else if (i == 4)
					{
						item = this.new("scripts/items/weapons/ancient/khopesh");
					}
					else if (i == 5)
					{
						item = this.new("scripts/items/weapons/ancient/rhomphaia");
					}
					else if (i == 6)
					{
						item = this.new("scripts/items/weapons/ancient/warscythe");
					}

					this.Contract.m.RiskItem = item;
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
					"Zdobądź %item% z miejsca zwanego %location% na %direction% od %origin%"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.m.IsShowingDefenders = false;
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsRiskReward"))
					{
						this.Contract.setState("Return");
					}
					else
					{
						this.Contract.setScreen("LocationDestroyed");
						this.World.Contracts.showActiveContract();
					}
				}
				else if (this.TempFlags.get("GotTheItem"))
				{
					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;

				if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);

					if (this.Flags.get("IsRiskReward"))
					{
						this.Contract.setScreen("RiskReward");
					}
					else
					{
						this.Contract.setScreen("SearchingTheLocation");
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
					properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
					this.World.Contracts.startScriptedCombat(properties, _isPlayerAttacking, true, true);
				}
			}

			function end()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull() && this.Contract.m.Destination.isAlive())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(null);
					this.Contract.m.Destination = null;
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
					if (this.Flags.get("IsFailure"))
					{
						this.Contract.setScreen("Failure1");
					}
					else
					{
						this.Contract.setScreen("Success1");
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
			Text = "{[img]gfx/ui/events/event_43.png[/img]%employer% wita cię i prowadzi na plac %townname%. Kręci się tam grupa chłopów, ale gdy widzą, że nadchodzisz, prostują się i zaczynają mówić, jakby czekali na ciebie od dawna. Opowiadają głównie obrazami: wysoki jak każdy mąż! Zbroja jakiej nigdy nie widzieliście! Włócznie ostre jak język wędrownego handlarza! Podnosisz dłoń i pytasz, o czym mówią. %employer% śmieje się.%SPEECH_ON%Mówią, że widzieli dziwy w miejscu zwanym %location%, na %direction% stąd. Oczywiście nie byli tam bez powodu. Szukali czegoś zwanego %item%, relikwii drogiej miastu, bo dzięki niej modlimy się o pożywienie i schronienie.%SPEECH_OFF%Jeden z chłopów odzywa się.%SPEECH_ON%A my szukalim tego na jego polecenie!%SPEECH_OFF%%employer% kiwa głową.%SPEECH_ON%Oczywiście. A skoro im się nie udało, może tobie się uda? Przynieś mi tę relikwię, a dobrze zapłacę za usługi. Nie przejmuj się ich bajaniami. Jestem pewien, że nie ma się czego obawiać.%SPEECH_OFF% | [img]gfx/ui/events/event_62.png[/img]%employer% wita cię w swoim pokoju i nalewa kubek wody. Podaje go z zakłopotanym uśmiechem.%SPEECH_ON%Zaoferowałbym piwo albo wino, gdybym miał je pod ręką, ale wiesz, jak to teraz jest.%SPEECH_OFF%Upija łyk i odchrząkuje.%SPEECH_ON%Oczywiście, nie brakuje mi koron, bo inaczej nie rozmawialibyśmy, prawda? Potrzebuję, żebyś poszedł do miejsca zwanego %location%, na %direction% stąd, i odzyskał relikwię o nazwie %item%. Dość proste, nie?%SPEECH_OFF%Pytasz, do czego służy ta relikwia. Mężczyzna wyjaśnia.%SPEECH_ON%Mieszkańcy modlą się do niej. Dzięki niej znajdują spokój, przywołują deszcz, gmerają kozy, wszystko mi jedno. Wierzą w nią i to ich napędza. To wystarczy, by warto było ją odzyskać.%SPEECH_OFF% | [img]gfx/ui/events/event_62.png[/img]Wchodzisz do pokoju %employer%, by zobaczyć, jak wpatruje się w mapę bezdroży. Kręci głową.%SPEECH_ON%Widzisz to miejsce? To %location%. %townname% czciło relikwię zwaną %item%, ale mieszkańcy mówią, że zaginęła i, cóż, z jakiegoś powodu sądzą, że jest właśnie tam. Nie mam ludzi, których mógłbym posłać, bo drogi są niebezpieczne i nie mogę sobie pozwolić na porażkę, ale ty, najemniku, wydajesz się odpowiedni. Pójdziesz tam i znajdziesz dla nas %item%?%SPEECH_OFF% | [img]gfx/ui/events/event_43.png[/img]Zastajesz %employer% rozmawiającego z grupą chłopów. Na twój widok ucisza ich wszystkich.%SPEECH_ON%Cicho, wszyscy. Ten człowiek rozwiąże nasz problem.%SPEECH_OFF%Zabiera cię na bok.%SPEECH_ON%Najemniku, mamy pewien problem. Jest relikwia, którą muszę odnaleźć, coś zwanego %item%. Szczerze mówiąc, mam to w nosie, ale ci ludzie czczą to za wiosenne deszcze i zimowe schronienie. Naturalnie, zaginęło. I z jakiegoś powodu ludzie sądzą, że poszło samo do miejsca zwanego %location%. Nikt tam nie pójdzie, ale ty tak, prawda? Za odpowiednią cenę, oczywiście.%SPEECH_OFF% | [img]gfx/ui/events/event_62.png[/img]Zastajesz %employer% rozmawiającego z druidycznym mnichem, okrytym kształtami bardziej znanymi bestiom niż ludziom. Rogi zamiast hełmu, niedźwiedzia skóra jako pancerz i jelenie kopyta stukające na piersi w brutalnym naszyjniku. Niezwykły widok. Widząc cię, %employer% przywołuje cię ruchem dłoni.%SPEECH_ON%Najemniku! Dobrze cię widzieć--%SPEECH_OFF%Druid odsuwa go w trakcie mowy. Mówi głosem drżącym, jakby dobywał się z głębi jaskini.%SPEECH_ON%Najemnik, ha! Zapewne jesteś człowiekiem wiary, prawda? My z %townname% utraciliśmy %item%. Ta relikwia jest dla nas wielce ważna, bo dzięki niej możemy przemawiać do starych bogów i otrzymywać odpowiedzi na modlitwy. Została skradziona, w ten czy inny sposób, do %location%. Idź tam i ją odzyskaj.%SPEECH_OFF%Spoglądasz na %employer%, który kiwa głową.%SPEECH_ON%Tak, to co on powiedział.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Dobrze zrobiłeś przychodząc do nas. Porozmawiajmy o zapłacie. | Porozmawiajmy o pieniądzach. | Względnie łatwa robota. Jaka płaca?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Nie jestem zainteresowany. | Mamy ważniejsze sprawy do załatwienia. | Z pewnością znajdziesz kogoś innego do tego zadania.}",
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
			ID = "SearchingTheLocation",
			Title = "%location%",
			Text = "[img]gfx/ui/events/event_73.png[/img]{Do ruin nie tyle wchodzisz, co się wspinasz, kuśtykając po kamieniach jak nietoperz próbujący chodzić wyprostowany. Na dole zejścia znajdujesz coś, co wygląda na setki glinianych dzbanów, stare rydwany bardziej rozdrobnione niż drewniane, i metalowe misy na wodę pełne zardzewiałych tarcz i włóczni. %randombrother% bierze pochodnię i rzuca jej blask na ściany. Wielkie freski ciągną się wzdłuż nich, przedstawiając bitwy, o których nigdy nie słyszałeś. Każdy krok odsłania kolejne starożytne zwycięstwo, aż w końcu docierasz do ogromnej malowanej mapy. Widzisz kontynent spętany władzą imperium, z pozłacanym brzuchem i poczerniałymi granicami.\n\n %randombrother% podchodzi z %item% w dłoni. Kiwając głową, mówisz mu, że czas się zbierać. Gdy obaj się odwracacie, stoi tam człowiek z włócznią w jednej dłoni i tarczą w drugiej. Dołącza do niego kolejna postać, i następna, a ich kroki uderzają o kamień metaliczną złośliwością. Krzyczysz do najemnika, by biegł, i obaj w pośpiechu opuszczacie ruiny, słysząc za plecami staccato marszu śmierci.\n\n Na zewnątrz odwracasz się i każesz ludziom szykować się do walki. Zanim pierwszy najemnik zdąży dobyć miecza, z ruin wyłania się strumień opancerzonych żołnierzy, w zwartej formacji, i wymierza w ciebie włócznie. Ich porucznik wskazuje zgniłym palcem i mówi głosem tak chropawym, że słowa ciążą w piersi.%SPEECH_ON%Imperium powstaje. Fałszywy Król musi umrzeć.%SPEECH_OFF% | Otwór do ruin jest na tyle duży, by przeszedł nim tylko jeden człowiek. Obawiasz się, że jeśli wszyscy wejdą naraz, utkną i w zasadzie zabijesz %companyname% jak szczury w ciasnym tunelu. Zamiast tego wysyłasz tylko %randombrother%, który wie, czego szuka, i któremu ufasz, że poradzi sobie, gdyby coś się wydarzyło.\n\n Po kilku minutach słyszysz, jak mężczyzna próbuje się wydostać - i brzmi, jakby naprawdę się spieszył. Krzyczy o pomoc, więc ty i kilku najemników wkładacie ręce w otwór. Chwyta się i wspólnie wyciągacie go na zewnątrz. Ma %item%, ale na twarzy widać przerażenie. Przewraca się i zrywa na nogi.%SPEECH_ON%Szybko! Do broni!%SPEECH_OFF%Gdy najemnicy zaglądają do środka, pytasz brata, co widział. Kręci głową.%SPEECH_ON%Nie wiem, panie. To było mauzoleum ludzi, których nigdy nie widziałem. Zbroje i włócznie wszędzie, a na ścianach freski wielkiego imperium, które obejmowało cały świat! Od podłogi po sufit! A... a potem zaczęli wychodzić ze ścian. Wydostałem się najszybciej jak mogłem i...%SPEECH_OFF%Zanim skończy, rumowisko, gdzie był otwór, zaczyna się poruszać. Kamienie odsuwają się i nagle wybuchają na zewnątrz, a w miejscu staje złośliwa siła - uzbrojeni i dobrze opancerzeni ludzie, w formacji, z włóczniami nad tarczami, maszerujący równymi krokami. Ich dowódca wskazuje prosto na ciebie.%SPEECH_ON%Imperium powstaje. Fałszywy Król musi umrzeć.%SPEECH_OFF%Nigdy nie słyszałeś pewniejszych słów do walki i natychmiast szykujesz ludzi do boju. | Zapuszczasz się do ruin z %randombrother% u boku. %item% łatwo znaleźć, aż nazbyt łatwo, ale coś innego przykuwa twoją uwagę. Po kamiennej posadzce porozrzucane są dzbany. Każdy służy jako zasobnik na włócznie, a tarcze wiszą na ścianach na hakach, które wyglądają na zbyt stare i zardzewiałe, by utrzymać choć pajęczynę, a co dopiero metal. Nagle %randombrother% chwyta cię za ramię.%SPEECH_ON%Panie. Kłopoty.%SPEECH_OFF%Wskazuje korytarz i widzisz stojącego tam mężczyznę, którego ruchy są szarpane i szybkie, jakby rozchodził zbroję. Nagle unosi głowę i wpatruje się w ciebie. Mimo że stoi daleko, jego głos niesie się tak, jakby mówił obok ciebie.%SPEECH_ON%Fałszywy Król śmie wtargnąć tutaj? Imperium powstanie ponownie, ale najpierw musisz umrzeć.%SPEECH_OFF%To bez wątpienia słowa walki, więc chwytasz najemnika i uciekacie. Nie zdążycie nawet wyjść daleko, gdy najemnicy, bez twojego rozkazu, chwytają za broń: za tobą idzie formacja żołnierzy w zbrojach, jakich nigdy nie widziałeś. Idą niczym żółwia skorupa, ściśnięci razem, z tarczami uniesionymi, by chronić cały oddział. Sądząc po tym, kogo spotkałeś w ruinach, nie masz wątpliwości, że przyszli zabić ciebie i resztę kompanii! | Wchodzisz do ruin i bez trudu znajdujesz %item%. Gdy się odwracasz, stoi tam wysoki mężczyzna w prymitywnej zbroi, z włócznią w dłoni, a jego puste oczodoły wpatrują się w ciebie. Zamierza się włócznią.%SPEECH_ON%Fałszywy Król musi umrzeć.%SPEECH_OFF%Włócznia pcha do przodu. %randombrother% wskakuje i zbija ją na ziemię, a grot sypie iskrami o kamienną posadzkę. Patrzysz na nieumarłego, robak pełznie mu przez nos. Znów przemawia.%SPEECH_ON%Fałszywy Król musi...%SPEECH_OFF%Szybkim ruchem dobywasz miecza i odcinasz głowę starożytnemu martwemu. Czaszka i hełm brzęczą i turkoczą o ziemię. Zanim zdążysz to zbadać, %randombrother% chwyta cię i każe uciekać: z murów wyłaniają się kolejne nieumarłe postacie, wyrywając się z granitowego uścisku mauzoleum.\n\n Po wyjściu na zewnątrz każesz reszcie kompanii ustawić się w szyku. | Wysyłasz kilku ludzi do ruin po %item%. Wszyscy wracają w pośpiechu, co jest dziwne, bo zwykle mają skłonność do ociągania się, by wygrzać się na słońcu i zarobić łatwy żołd. Na szczęście jeden z nich ma relikwię w dłoni. Niestety wszyscy wyglądają, jakby ujrzeli ducha. Nie muszą wyjaśniać źródła swej grozy, bo z ruin wychodzi grupa zgrzytających zbroją nieumarłych i wymierza włócznie w twoją kompanię. | Gdy docierasz do ruin, spodziewasz się bandytów. Zamiast tego, zdobycie %item% było dziecinnie proste. Przynajmniej tak ci się wydawało, zanim z ruin wyszedł tłum opancerzonych nieumarłych, krzycząc o 'Fałszywym Królu' i żądając twojej głowy na tacy. Do broni! | Odnalezienie i zdobycie %item% było łatwiejsze, niż się spodziewałeś. Znalezienie grupy nieumarłych w ciężkich, prymitywnych zbrojach, z włóczniami w ściślejszej formacji wojskowej niż nawet najlepiej opłacona armia w królestwie... już nie tak bardzo. Do broni!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						this.TempFlags.set("GotTheItem", true);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "LocationDestroyed",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Bitwa skończona, %item% zdobyty, więc mówisz ludziom, by szykowali się do powrotu do %employer%. Nie jesteś pewien, kto lub co właśnie na was napadło, ale teraz czas odebrać zapłatę. | Gdy walka dobiega końca, oglądasz swoich napastników. Są zamknięci w zbrojach, których nie rozpoznajesz. %randombrother% próbuje wydobyć jedno z ciał z hełmu, ale na próżno. Patrzy na zwłoki z niedowierzaniem.%SPEECH_ON%To jakby tkwiło tam na stałe, albo było częścią niego czy coś.%SPEECH_OFF%Mówisz ludziom, by się uzbroili i szykowali do powrotu do %employer%. Nieważne, kim byli ci ludzie, przyszedłeś po %item% i to już zrobione. Teraz pora na zapłatę. | Zdobyłeś %item%, ale za cenę spotkania z czymś, czego nigdy wcześniej nie widziałeś. Opancerzeni ludzie, na pozór martwi, a jednak działający w ścisłych formacjach. %randombrother% podnosi %item% i pyta, co dalej. Informujesz ludzi, że czas wrócić do %employer%. | Przyglądasz się %item% i ludziom, którzy zaatakowali cię o niego. A przynajmniej tak ci się wydaje. Porucznik wroga coś powiedział, ale nie pamiętasz co. No cóż, czas wrócić do %employer% po zapłatę. | Nie jesteś do końca pewien, na co trafiliście. %randombrother% pyta, czy wiesz, co powiedzieli.%SPEECH_ON%Wyglądało, jakby wskazywali konkretnie na ciebie, panie.%SPEECH_OFF%Kiwając głową, mówisz mu, że nie wiesz, co powiedział opancerzony, ale to bez znaczenia. Masz %item% i czas wrócić do %employer% po zapłatę. | %item% jest w twoich rękach, ale jakim kosztem? Dziwni ludzie, jeśli można ich tak nazwać, zaatakowali kompanię i przysięgasz, że jeden z nich wskazywał wprost ciebie, jakbyś popełnił zbrodnię wykraczającą poza czas i przestrzeń. No cóż. Nie jesteś od roztrząsania takich rzeczy. Przyszedłeś po relikwię, którą masz, i po dobrą wypłatę, która czeka u %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wracajmy.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "RiskReward",
			Title = "%location%",
			Text = "[img]gfx/ui/events/event_57.png[/img]{Wchodzisz do %location% i rozglądasz się. Chwilę później %randombrother% wskazuje %item% - relikwia spoczywa na kamiennym postumencie, pokrytym mchem i pajęczynami. Wskazuje też coś innego po drugiej stronie sali: bardzo ładny %risk% zdobiący ciało wysokiego posągu.\n\nReszta miejsca jest zrujnowana i wygląda, jakby zaraz miała runąć na wasze głowy. Co %risk% tam robi, to na pewno podejrzane. | %item% widać jak na dłoni, ale w pomieszczeniu jest coś jeszcze, co przykuwa twoją uwagę. Obok ogromnego posągu leży bardzo wyjątkowo wyglądający %risk%. Oczywiście rodzi się pytanie: co do diabła tam robi? Choć wydaje ci się oczywiste, że powinieneś go wziąć, coś podpowiada, że to może nie być najrozsądniejsza decyzja. | Cóż, znalazłeś %item%. Było znacznie łatwiej, niż się spodziewałeś. Ale jest tu też coś innego. Dostrzegasz połyskujący %risk% zdobiący wysoki posąg mężczyzny o pustej twarzy. Nie wiesz, co posąg robi z czymś takim, ale tam jest. I wygląda, jakby był tam zawsze, co rodzi pytanie: dlaczego? | %item% było dość łatwo znaleźć, ale kiedy szykujesz się, by zabrać relikwię mieszkańców, dostrzegasz lśniący %risk% zdobiący wysoki i złowrogi posąg mężczyzny. Pierwsza myśl to posłać najemnika, by to zabrał, ale potem zastanawiasz się, co do diabła to tam robi.} Może %companyname% powinno trzymać się tego, do czego zostało wynajęte?",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zabierzmy tylko %item%.",
					function getResult()
					{
						return "TakeJustItem";
					}

				},
				{
					Text = "Skoro już tu jesteśmy, weźmy też %risk%.",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "TakeRiskItemBad";
						}
						else
						{
							return "TakeRiskItemGood";
						}
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TakeJustItem",
			Title = "%location%",
			Text = "[img]gfx/ui/events/event_57.png[/img]%employer% kazał ci zdobyć %item% i dokładnie to zrobisz. {%randombrother% zgadza się z takim podejściem.%SPEECH_ON%Uważam, że powinniśmy zostawić ten %risk% w spokoju. Nie widziałem wyraźniejszej pułapki niż ta.%SPEECH_OFF% | Kręcąc głową, %randombrother% śmieje się z twojej ostrożności.%SPEECH_ON%Boi się pan tego wielkiego posągu, co? Wydawało mi się, że ma pan więcej odwagi.%SPEECH_OFF% | Po tym jak zabierasz relikwię, %randombrother% szturcha cię łokciem.%SPEECH_ON%Czyżby ktoś bał się wielkiego złego posągu, co? Daj no, wezmę to. Wyjdziemy z tym w dwie sekundy!%SPEECH_OFF%Uprzejmie przypominasz najemnikowi, kto tu rządzi, żeby znów nie 'żartował'. | Relikwia już w twojej dłoni, %randombrother% tylko kiwa głową.%SPEECH_ON%Dobra robota, panie. Mówię, zostawmy ten %risk% w spokoju. Ten świecący błyskotek to same kłopoty. Gonienie za nim to jak głupiec goniący piękną kobietę pośrodku oceanu!%SPEECH_OFF% | %randombrother% mruży oczy na %risk% i pluje, odchrząkując i przesuwając dłonią po rozczochranej twarzy.%SPEECH_ON%Tak. Zostawmy to w spokoju. Gdybym znalazł kupę złota w środku lasu, dwa razy bym się zastanowił, zanim bym po to pobiegł. Tutaj jest tak samo.%SPEECH_OFF% | %randombrother% zgadza się z twoją decyzją.%SPEECH_ON%Tak, zostawmy ten %risk% w spokoju. Nic na tym świecie nie jest za darmo, nic. Zwłaszcza coś, co tak się świeci. Nie, panie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To było dość łatwe.",
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
			ID = "TakeRiskItemGood",
			Title = "%location%",
			Text = "[img]gfx/ui/events/event_57.png[/img]{Mając %item% w dłoni, uznajesz, że warto też zabrać %risk%. %randombrother% podchodzi i ostrożnie wyzwala go z posągu. Gdy metal wreszcie się wysuwa, mężczyzna zastygł, gotów przyjąć cios, gdyby posąg ożył. Zamiast tego nic się nie dzieje. Śmieje się nerwowo.%SPEECH_ON%L-luzik!%SPEECH_OFF%Gdy ulga rozlewa się po ludziach, mówisz im, by szykowali się do powrotu do %employer%. | Gdy chwytasz %item%, spoglądasz na %risk% i myślisz: czemu nie. Wdrapujesz się na posąg i wpatrujesz w twarz człowieka, według którego został wyrzeźbiony. Kimkolwiek był, miał rzeźbione kości policzkowe i szczękę, na której można by zawiesić płaszcz. Odsuwając wzrok od rysów, chwytasz %risk% i unosisz go, czekając, aż coś się stanie. Nic się nie dzieje. %randombrother% śmieje się.%SPEECH_ON%Powiesz temu posągowi 'witaj' czy nie?%SPEECH_OFF%Klepiesz posąg po głowie i schodzisz na dół. Kompania powinna teraz wracać do %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To było dość łatwe.",
					function getResult()
					{
						this.Contract.m.RiskItem = null;
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				this.World.Assets.getStash().add(this.Contract.m.RiskItem);
				this.List.push({
					id = 10,
					icon = "ui/items/" + this.Contract.m.RiskItem.getIcon(),
					text = "Zdobywasz " + this.Contract.m.RiskItem.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "TakeRiskItemBad",
			Title = "%location%",
			Text = "[img]gfx/ui/events/event_73.png[/img]{Wysyłasz %randombrother% na posąg po %risk%. Gdy jest na górze, zauważasz zgubiony błyskotek %employer% kiwający się na postumencie. Wyciągasz rękę, by go ustabilizować, ale zamiast stanąć, przesypuje się przez twoje palce jak pył. Sproszkowane resztki owijają się wokół twojego ramienia jak wąż z mgły. Odskakujesz, a dym pędzi ku posągowi, wciskając się w oczy, które teraz jarzą się na czerwono. Kamień pęka i kruszy się. Najemnik odskakuje. Wokół wyłaniają się kształty ze ścian, posągi rozrywają się, by wydać na świat dziwnie wyglądających ludzi w zbrojach i z włóczniami na ramionach.\n\n Rozkazujesz wszystkim szykować się do walki! | Nie ma mowy, żebyś odpuścił coś takiego jak %risk%. Wdrapujesz się po posągu i sięgasz po niego, ale gdy tylko kawałek metalu dotyka palca, rozlega się dudnienie, a posąg zaczyna drżeć. %randombrother% krzyczy i odwracasz się. Wskazuje na %item%, które rozpuszcza się na twoich oczach! Zamienia się w pył i możesz tylko patrzeć, jak jego strumień, niczym ożywiona mgła, wiruje po sali, przelatuje obok twojej twarzy i wpada do nosa posągu. Oczy jarzą się na czerwono i natychmiast odskakujesz. Najemnik staje obok, z bronią już w dłoni.%SPEECH_ON%Panie, panie! Patrz!%SPEECH_OFF%Ze ścian wyłaniają się kształty! Posągi szarpią się naprzód jak marionetki na sznurkach starego człowieka. Powoli każdy z nich zrzuca kamienną skorupę i wyłania się jako dziwnie wyglądający, opancerzony mężczyzna z włócznią. Szybko rozkazujesz ludziom ustawić się do walki, bo cokolwiek tu uwolniłeś, nie będzie przyjazne!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						this.Contract.m.RiskItem = null;
						this.Flags.set("IsFailure", true);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination, false);
						return 0;
					}

				}
			],
			function start()
			{
				this.World.Assets.getStash().add(this.Contract.m.RiskItem);
				this.List.push({
					id = 10,
					icon = "ui/items/" + this.Contract.m.RiskItem.getIcon(),
					text = "Zdobywasz " + this.Contract.m.RiskItem.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% spotyka cię na miejskim placu. Przekazujesz %item%, a mężczyzna obejmuje go jak niemowlę, które uważał za zaginione. Po chwili niezręcznego uścisku z relikwią podnosi ją wysoko, by mieszkańcy mogli ją zobaczyć. Przez chwilę wiwatują. Zdecydowanie za długo. Musisz szturchnąć %employer%, by przypomnieć mu o zapłacie. | Zastajesz %employer% grzebiącego w chlewie. Kopie tłuste lochy, choć one bardziej skupiają się na paszy niż na skórzanym czubku buta wymierzanym w zad. Głośno odchrząkujesz. %employer% odwraca się, a jego oczy od razu się rozszerzają na widok relikwii. Przeskakuje przez świnię i chwyta %item%. Woła do mieszkańców, którzy zbierają się wokół i modlą do bogów o litość. Nikt ci nie dziękuje, rzecz jasna. Musisz przypomnieć %employer% o koronach, które ci się należą. Wypłaca je i jak najszybciej się oddalasz. | Zastajesz %employer% siedzącego na placu, z rękami wzniesionymi ku niebu, zamkniętymi oczami i ustami szepczącymi modlitwy. Mieszkańcy są wokół niego, klęczą i czynią to samo. Podnosisz kamień i ciskasz w wiatrowskaz, a brzęk i chrapliwy obrót przyciągają uwagę wszystkich.\n\nUnosisz relikwię, aby wszyscy ją zobaczyli. %employer% podrywa się na nogi i zabiera %item%. Ludzie ryczą z zachwytu, mówiąc o dobrych rzeczach, które nadejdą. Otrzymujesz zapłatę, co, prawdę mówiąc, jest jedyną 'dobrą rzeczą', na której ci zależy.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Ludność wydaje się być teraz w dobrym nastroju.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Zdobyłeś " + this.Flags.get("ItemName"));
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
						}

						return 0;
					}

				}
			],
			function start()
			{
				local reward = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + reward + "[/color] koron"
				});
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/high_spirits_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Mieszkańcy %townname% z niecierpliwością czekają na twój powrót. Szkoda, bo nie masz relikwii, której tak rozpaczliwie potrzebują. %employer%, dostrzegając twoją porażkę o krok wcześniej niż prosty lud, spotyka cię przy bramie i mówi szeptem.%SPEECH_ON%Rozumiem, że nie masz %item%.%SPEECH_OFF%Próbujesz wyjaśnić, co się stało, ale nie wygląda, by słuchał.%SPEECH_ON%To bez znaczenia, najemniku. Nie mogę ci zapłacić, rzecz jasna, a mieszkańcy nie mogą usłyszeć o twojej porażce, żeby nie postradali zmysłów. Polegają na bożkach, by znaleźć pocieszenie w tym świecie. Będę musiał wymyślić własne rozwiązanie i, cóż, modlić się, by zadziałało. Dobrego dnia.%SPEECH_OFF% | %employer% spotyka cię przy stadzie gęsi. Karmi je z ręki, a od czasu do czasu podchodzi chłopak, po prostu podnosi jednego z ptaków i odchodzi, by go zarżnąć. Mężczyzna uśmiecha się ciepło, ale jego entuzjazm szybko gaśnie.%SPEECH_ON%Nie widzę relikwii. Czy mam rację, że jej nie masz?%SPEECH_OFF%Odpowiadasz tylko skinieniem. Rozkłada ramiona, nieco zdezorientowany.%SPEECH_ON%To po co w ogóle przyszedłeś? Mieszkańcy cię znają. Wiedzą, że byłeś jej szukać. Powinieneś odejść, zanim zobaczą, że wróciłeś bez ich boskiego bożka.%SPEECH_OFF% | Wracasz do %employer% z pustymi rękami. Bierze cię na bok i szepcze.%SPEECH_ON%A po co w ogóle przyszedłeś? Nie rozumiesz, jaką wagę mieszkańcy przykładają do bożka? Bez niego nie będą mieli w co wierzyć. Człowiek o silnej wierze potrzebuje miejsca, by ją ulokować. Jeśli go nie znajdzie, zostaje mu tylko on sam. A jak brzydki brutal wpatrujący się w lustro, nie musimy się spieszyć, by zobaczyć gniew i zamęt w odbiciu nieobecnego bożka. Odejdź, najemniku, zanim ludzie zobaczą, że nie wróciłeś z %item%.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "No cóż...",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Nie zdobyłeś przedmiotu zwanego " + this.Flags.get("ItemName"));
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
			"location",
			this.m.Flags.get("DestinationName")
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Destination.getTile())]
		]);
		_vars.push([
			"item",
			this.m.Flags.get("ItemName")
		]);
		_vars.push([
			"risk",
			this.m.RiskItem != null ? this.m.RiskItem.getName() : ""
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull() && this.m.Destination.isAlive())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
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
		if (this.m.Destination != null && !this.m.Destination.isNull())
		{
			_out.writeU32(this.m.Destination.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.RiskItem != null)
		{
			_out.writeBool(true);
			_out.writeI32(this.m.RiskItem.ClassNameHash);
			this.m.RiskItem.onSerialize(_out);
		}
		else
		{
			_out.writeBool(false);
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

		local hasItem = _in.readBool();

		if (hasItem)
		{
			this.m.RiskItem = this.new(this.IO.scriptFilenameByHash(_in.readI32()));
			this.m.RiskItem.onDeserialize(_in);
		}

		this.contract.onDeserialize(_in);
	}

});

