this.drive_away_barbarians_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		Reward = 0,
		OriginalReward = 0
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.drive_away_barbarians";
		this.m.Name = "Przepędzenie Barbarzyńców";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local banditcamp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getNearestSettlement(this.m.Home.getTile());
		this.m.Destination = this.WeakTableRef(banditcamp);
		this.m.Flags.set("DestinationName", banditcamp.getName());
		this.m.Flags.set("EnemyBanner", banditcamp.getBanner());
		this.m.Flags.set("ChampionName", this.Const.Strings.BarbarianNames[this.Math.rand(0, this.Const.Strings.BarbarianNames.len() - 1)] + " " + this.Const.Strings.BarbarianTitles[this.Math.rand(0, this.Const.Strings.BarbarianTitles.len() - 1)]);
		this.m.Flags.set("ChampionBrotherName", "");
		this.m.Flags.set("ChampionBrother", 0);
		this.m.Payment.Pool = 600 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Przepędź barbarzyńców z miejsca zwanego " + this.Flags.get("DestinationName") + " na %direction% od %origin%"
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
				this.Contract.m.Destination.setLastSpawnTimeToNow();
				this.Contract.m.Destination.clearTroops();

				if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.Barbarians, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				local r = this.Math.rand(1, 100);

				if (r <= 20)
				{
					if (this.World.getTime().Days >= 10)
					{
						this.Flags.set("IsDuel", true);
					}
				}
				else if (r <= 40)
				{
					if (this.World.Assets.getBusinessReputation() >= 500 && this.Contract.getDifficultyMult() >= 1.0)
					{
						this.Flags.set("IsRevenge", true);
					}
				}
				else if (r <= 50)
				{
					this.Flags.set("IsSurvivor", true);
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
				if (this.Flags.get("IsDuelVictory"))
				{
					this.Contract.setScreen("TheDuel2");
					this.World.Contracts.showActiveContract();
					this.Flags.set("IsDuelVictory", false);
				}
				else if (this.Flags.get("IsDuelDefeat"))
				{
					this.Contract.setScreen("TheDuel3");
					this.World.Contracts.showActiveContract();
					this.Flags.set("IsDuelDefeat", false);
				}
				else if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsSurvivor"))
					{
						this.Contract.setScreen("Survivor1");
						this.World.Contracts.showActiveContract();
					}

					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (this.Flags.get("IsDuel"))
				{
					this.Contract.setScreen("TheDuel1");
					this.World.Contracts.showActiveContract();
				}
				else if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Contract.setScreen("Approaching");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Duel")
				{
					this.Flags.set("IsDuelVictory", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Duel")
				{
					this.Flags.set("IsDuelDefeat", true);
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
				if (this.Flags.get("IsRevengeVictory"))
				{
					this.Contract.setScreen("Revenge2");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsRevengeDefeat"))
				{
					this.Contract.setScreen("Revenge3");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsRevenge") && this.Contract.isPlayerNear(this.Contract.m.Home, 600))
				{
					this.Contract.setScreen("Revenge1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Revenge")
				{
					this.Flags.set("IsRevengeVictory", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Revenge")
				{
					this.Flags.set("IsRevengeDefeat", true);
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% wzdycha, przesuwając w twoją stronę skrawek papieru. To lista zbrodni. Kiwasz głową, zauważając, że jest ich całkiem sporo. Mężczyzna kiwa głową w odpowiedzi.%SPEECH_ON%Gdyby to była sprawa pojedynczego przestępcy, wynająłbym strażnika albo łowcę nagród. Ale sprowadziłem cię tu, najemniku, bo to robota barbarzyńców. Wszystko, co zrobili, wszystko, co tu zapisano, musi spotkać ich. Mają wioskę %direction% stąd. Potrzebuję, żebyś ich odwiedził i pokazał, że choć żyjemy przy paleniskach i w cywilizacji, iskra dzikości w nas nie zgasła, i że barbarzyńskie czyny spotka barbarzyński odwet. Rozumiesz?%SPEECH_OFF%Dopiero teraz zauważasz, że kartka z listą zbrodni jest usiana połamanymi końcówkami pióra, jakby piszący coraz bardziej się irytował jej spisywaniem. | W pokoju z %employer%em siedzi grupa lokalnych rycerzy. Patrzą na ciebie beznamiętnie, jakbyś był psem, który wepchnął się do środka. %employer% sięga z fotela, wyciąga zwój i rzuca go w twoją stronę.%SPEECH_ON%Barbarzyńcy zostawili mi to, gdy próbowałem zrozumieć, co stało się z pobliską osadą, którą zrównano z ziemią.%SPEECH_OFF%Na papierze są runiczne rysunki i coś, co wygląda jak przedstawienie powieszenia. %employer% kiwa głową.%SPEECH_ON%Wymordowali rolników, przynajmniej mężczyzn. Stare bogi wiedzą, co spotkało kobiety. Idź %direction% stąd, najemniku, i znajdź odpowiedzialnych barbarzyńców. Zostaniesz hojnie opłacony za ich jawne, całkowite i zupełne unicestwienie.%SPEECH_OFF% | %employer% wygląda na mocno poirytowanego, gdy wchodzisz do pokoju. Mówi, że %townname% dawniej utrzymywało dobre stosunki z barbarzyńcami z północy.%SPEECH_ON%Ale chyba tylko łudziłem się, że możemy utrzymać równy układ z tymi dzikusami.%SPEECH_OFF%Mówi, że atakują karawany, mordują podróżnych i napadają na gospodarstwa.%SPEECH_ON%Odpłacę im tym samym. Idź %direction% stąd i wyrżnij ich wioskę w pień. Chętny?%SPEECH_OFF% | %employer% śmieje się, gdy wchodzisz do pokoju.%SPEECH_ON%Nie śmieję się z ciebie, najemniku, tylko z tej okrutnej ironii, że szuka się najemnika do szybkiego i całkowitego starcia barbarzyńców. Widzisz, %direction% stąd stoi plemię dupków w skórach niedźwiedzia, którzy ściągają skalpy i rąbią kupców i podróżnych. Nie będę tego tolerował. Po części dlatego, że robią źle, ale szczególnie dlatego, że mam monety, by zapłacić komuś o twoich brakach manier, żeby się tym zajął za mnie.%SPEECH_OFF%Znów śmieje się pod nosem. Masz wrażenie, że ten człowiek nigdy nie wbił miecza w nic żywego.%SPEECH_ON%Więc co powiesz, najemniku, masz ochotę zarżnąć kilku dzikusów?%SPEECH_OFF% | Gdy wchodzisz do komnaty %employer%a, wpatruje się w psią głowę. Stały strumień z karku kapie za krawędź stołu. Mężczyzna pociera jedno z uszu.%SPEECH_ON%Kto zabija czyjegoś psa, odcina mu głowę i, kurwa, odsyła ją właścicielowi?%SPEECH_OFF%Wyobrażasz sobie kogoś z zawziętym wrogiem, ale nic nie mówisz. %employer% przywołuje jednego ze sług i psia głowa zostaje zabrana. Teraz spogląda na ciebie.%SPEECH_ON%Dzicy na %direction% zrobili to. Najpierw wzięli się za kupców i osadników, gwałcąc i grabiąc, jak to barbarzyńcy. Więc wysłałem odpowiedź, zabiłem kilku z nich, i oto, co dostałem w zamian. Koniec z tymi sukinsynami. Chcę, żebyś poszedł do ich wioski i wytępił ich do ostatniego.%SPEECH_OFF%Masz ochotę zapytać, czy to obejmuje też ich psy. | Znajdujesz %employer%a z brudną, obłoconą kobietą siedzącą obok jego krzesła. Jej włosy są skołtunione, a ciało nosi ślady wszelkich kar. Warczy na ciebie, jakby to była twoja wina. %employer% kopie ją.%SPEECH_ON%Nie zważaj na tę ladacznicę, najemniku. Złapaliśmy ją i jej przyjaciół na rabowaniu spichlerza. Wycięliśmy tych dzikusów, powiedziałbym, że oszczędziliśmy ją dla zabawy, ale bicie jej jest mniej więcej tak zabawne jak bicie psa. Jej męskość kradnie całą radość.%SPEECH_OFF%Kopie ją ponownie, a ona odszczekuje.%SPEECH_ON%Widzisz? A teraz wieści! Namierzyliśmy plugastwo, z którego pochodzi, i mam pełny zamiar spalić je do gołej ziemi. Tu wchodzisz ty. Wioska barbarzyńców leży %direction% stąd. Zetrzyj ją z mapy, a zapłacę ci bardzo dobrze.%SPEECH_OFF%Kobieta nie wie, co się mówi, ale pewne rozluźnienie w jej spojrzeniu sugeruje, że zaczyna rozumieć, dlaczego ktoś taki jak ty wszedł przez te drzwi. %employer% szczerzy zęby.%SPEECH_ON%Jesteś zainteresowany, czy mam szukać bardziej bezwzględnego człowieka?%SPEECH_OFF% | %employer% ma w pokoju tłum chłopów. Więcej, niż człowiek o jego pozycji zniósłby tak blisko, ale zaskakująco nie wydają się być zainteresowani linczem. Widząc cię, %employer% woła cię do siebie.%SPEECH_ON%Ach, nareszcie! Oto nasza odpowiedź! Najemniku, barbarzyńcy %direction% stąd plądrują pobliskie wioski i gwałcą wszystko, co ma dziurę. Mamy tego dość i szczerze nie chcę, żeby jakiś zawszony dzikus z fiutem zbliżał się do mojego tyłka bardziej niż do tyłka kolejnego człowieka.%SPEECH_OFF%Tłum chłopów szydzi, a jeden krzyczy, że barbarzyńcy {odcięli głowę jego matce | zabili też jego ulubione kozy | ukradli wszystkie jego psy, skurczybyki | zjedli wątrobę jego najmłodszego syna}. %employer% kiwa głową.%SPEECH_ON%Aye. Aye, ludzie, aye! I dlatego mówię, najemniku, że wytyczysz drogę do wioski barbarzyńców i zafundujesz im odmierzoną, odpowiednią, cywilizowaną sprawiedliwość.%SPEECH_OFF% | %employer% macha na ciebie do swojej komnaty. Trzyma pogrzebacz, z którego końca zwisa skalp.%SPEECH_ON%Północni barbarzyńcy przysłali mi to dzisiaj. Było przytwierdzone do posłańca, człowieka, któremu wyrwali oczy i język. Taka ich natura, tych dzikusów, mówić do mnie bez słów. I czuję, że z twoją pomocą zwrócę im przysługę, najemniku. Idź %direction% stąd, znajdź ich małą wioskę i spal ją do gołej ziemi.%SPEECH_OFF%Skalp odkleja się od pogrzebacza i z mokrym mlaśnięciem uderza o kamienną posadzkę. | %employer% niechętnie wita cię w środku, jak to bywa, gdy świat zmusza kogoś do wynajęcia najemnika. Mówi krótko.%SPEECH_ON%Barbarzyńcy mają wioskę %direction% stąd, z której wysyłają wypady. Gwałcą, grabią, są tylko owadami i szkodnikami w kształcie ludzi. Chcę, by wszyscy zniknęli, co do jednego. Czy podejmiesz się tego zadania?%SPEECH_OFF% | %employer% trzyma na kolanach kota, ale gdy podchodzisz bliżej, widzisz, że to tylko głowa, a on obraca kciukiem odcięty ogon. Zaciska usta.%SPEECH_ON%Barbarzyńscy dzicy to zrobili. Zgwałcili i splądrowali kilka okolicznych gospodarstw i powiesili parę niemowląt-bliźniąt na drzewie, ale to...%SPEECH_OFF%Rozchyla dłonie, a kocia głowa stacza się i z głuchym klaśnięciem uderza o kamienną posadzkę.%SPEECH_ON%Dość. Chcę, żebyś poszedł %direction% stąd, znalazł wioskę, którą ci dzicy nazywają domem, i zrobił jej to, co oni zrobili nam!%SPEECH_OFF%}",
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
			ID = "Approaching",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_138.png[/img]{Znalazłeś wioskę barbarzyńców i ciąg kopców kamiennych prowadzących do niej. Kamienie ułożone są w kształty ludzi, a na szczycie każdego kopca spoczywa świeżo odrąbiona ludzka głowa. %randombrother% kiwa głową.%SPEECH_ON%Ciekawe, czy wierzą, że to zbliża ich do bogów.%SPEECH_OFF%Masz inny sposób, by przybliżyć ich do bogów: zabijając ich wszystkich. Czas zaplanować atak. | Znajdujesz wioskę barbarzyńców, a tuż na jej skraju leży okrągły kamień w śniegu. Jest tak duży, że cała kompania mogłaby położyć się od stóp do głów i wciąż nie sięgnęłaby przez jego środek. Na zewnętrznym obrzeżu wykuto runy, długie rowki zaschnięte krwią. W centrum płyty jest mały kwadratowy podest z wyżłobieniem na kark. %randombrother% spluwa.%SPEECH_ON%Wygląda na ołtarz ofiarny, ee, krąg.%SPEECH_OFF%Rozglądając się, zastanawiasz się na głos, gdzie podziali ciała. Najemnik wzrusza ramionami.%SPEECH_ON%Nie wiem. Pewnie je zjedli.%SPEECH_OFF%Nie zdziwiłoby cię to. Wpatrujesz się w wioskę i rozważasz atak lub czekanie. | Wioska barbarzyńców leży niedaleko. To obraz obozu koczowników: namioty otoczone improwizowanymi kuźniami i wozami przykrytymi plandekami, pełniącymi rolę spichlerzy. Masz wrażenie, że nie zostają długo w jednym miejscu. %randombrother% śmieje się.%SPEECH_ON%Patrz na tamtego. Sra. Co za skurczybyk.%SPEECH_OFF%Rzeczywiście, jeden z dzikusów kuca, rozmawiając z pobratymcami. To niemal metafora przyłapania całego obozu ze spuszczonymi portkami. | Wioska dzikusów zaskakująco nie jest piekłem, którego się spodziewałeś. Poza odartym trupem wiszącym głową w dół na drewnianym świętym totemie wygląda jak każde inne miejsce z normalnymi ludźmi. Poza ciężkimi strojami i tym, że każdy nosi topór albo jakiś miecz. Wszystko całkiem normalne. Jest facet odcinający nogi trupa i karmiący nimi świnie, ale to zobaczysz niemal wszędzie. %randombrother% kiwa głową.%SPEECH_ON%Cóż, jesteśmy gotowi do ataku. Wystarczy rozkaz, kapitanie.%SPEECH_OFF% | Znajdujesz wioskę barbarzyńców kucającą w śnieżnych pustkowiach. Nie mogła tu stać długo: to głównie namioty, a ich czubki nie są zasypane śniegiem. Muszą rozbijać obóz na jakiś czas i potem ruszać dalej, albo by odświeżyć łowy, albo by uniknąć odwetu tych, których napadają. Szkoda, że nie udało im się to drugie. Szykujesz kompanię do działania. | Znajdujesz wioskę dzikusów. Na pierwszy rzut oka wyglądają zwyczajnie. Mężczyźni, kobiety, dzieci. Jest kowal, garbarz, jednooki facet robiący strzały i ogromny kat, który patroszy zwłoki i obmywa flaki o osła. Ten. Ten przypomina ci, po co tu jesteś. | Znajdujesz wioskę barbarzyńców. Dzicy odprawiają jakiś religijny rytuał. Starszy mężczyzna z naszyjnikiem z skorupy żółwia trzyma pięść nad ściętą i ogoloną głową. Pozwala krwi spływać po przedramieniu, a dzieci biorą pędzle z końskiego włosia, zbierają \"farbę\" i smarują nią drewniany święty totem wysoki na dobre dziesięć stóp. Prymitywni patrzą i skandują w języku całkowicie ci obcym. %randombrother% szepcze, jakby z szacunku dla rytuału bardziej niż z obawy, że go usłyszą.%SPEECH_ON%Cóż. Mówię, że schodzimy tam i się przedstawiamy, co?%SPEECH_OFF% | Znajdujesz barbarzyńców kręcących się po wiosce. To głównie namioty i improwizowane śnieżne chaty. Starsze kobiety siedzą w kręgu i wyplatają kosze, a młodsze robią strzały, rzucając spojrzenia na krępych mężczyzn chodzących dookoła. Sami mężczyźni udają, że ich to nie obchodzi, ale rozpoznajesz pawia w akcji, gdy go widzisz. Są też dzieci biegające w te i we wte z różnymi zadaniami. A tuż za wioską stoi rząd drewnianych pali, na których nagie zwłoki są nabite od odbytu po usta, a klatki piersiowe zostały rozchylone jak skrzydła motyla, a wnętrzności zwisają jak rozprute hafty.%SPEECH_ON%Ohydne.%SPEECH_OFF%%randombrother% mówi. Kiwając głową, zgadzasz się. Tak, ale po to tu jesteś.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Przygotować się do ataku.",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "TheDuel1",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_139.png[/img]{Gdy wygląda na to, że %companyname% jest gotowe starć się z dzikusami, samotna postać wychodzi i staje między liniami bitwy. Ma rozdzieloną długą brodę zawiązaną na skorupach żółwi, a głowę osłania spadzisty pysk wilczej czaszki. Starszy stoi bez broni, poza długą laską, do której przywiązano jelenie rogi, grzechoczące przy ruchu. Co zaskakujące, mówi w twoim języku.%SPEECH_ON%Obcy. Witajcie na Północy. Nie jesteśmy tak niegościnni, jak możecie sądzić. Zgodnie z naszą tradycją wierzymy, że walka dwóch ludzi jest równie honorowa i wartościowa jak bitwa dwóch armii. Oferuję więc naszego najsilniejszego czempiona, %barbarianname%.%SPEECH_OFF%Naprzód wychodzi barczysty mężczyzna. Zdejmuje skóry i odrzuca je na bok, odsłaniając ciało z czystych mięśni, ścięgien i blizn. Starszy kiwa głową.%SPEECH_ON%Wysuńcie swego czempiona, Obcy, a przeżyjemy dzień, z którego wszyscy nasi przodkowie będą dumni.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wolałbym raczej spalić cały ten obóz. Do ataku!",
					function getResult()
					{
						this.Flags.set("IsDuel", false);
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
				local raw_roster = this.World.getPlayerRoster().getAll();
				local roster = [];

				foreach( bro in raw_roster )
				{
					if (bro.getPlaceInFormation() <= 17)
					{
						roster.push(bro);
					}
				}

				roster.sort(function ( _a, _b )
				{
					if (_a.getXP() > _b.getXP())
					{
						return -1;
					}
					else if (_a.getXP() < _b.getXP())
					{
						return 1;
					}

					return 0;
				});
				local name = this.Flags.get("ChampionName");
				local difficulty = this.Contract.getDifficultyMult();
				local e = this.Math.min(3, roster.len());

				for( local i = 0; i < e; i = i )
				{
					local bro = roster[i];
					this.Options.push({
						Text = roster[i].getName() + " zmierzy się z twoim czempionem!",
						function getResult()
						{
							this.Flags.set("ChampionBrotherName", bro.getName());
							this.Flags.set("ChampionBrother", bro.getID());
							local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
							properties.CombatID = "Duel";
							properties.Music = this.Const.Music.BarbarianTracks;
							properties.Entities = [];
							properties.Entities.push({
								ID = this.Const.EntityType.BarbarianChampion,
								Name = name,
								Variant = difficulty >= 1.15 ? 1 : 0,
								Row = 0,
								Script = "scripts/entity/tactical/humans/barbarian_champion",
								Faction = this.Contract.m.Destination.getFaction(),
								function Callback( _entity, _tag )
								{
									_entity.setName(name);
								}

							});
							properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
							properties.Players.push(bro);
							properties.IsUsingSetPlayers = true;
							properties.BeforeDeploymentCallback = function ()
							{
								local size = this.Tactical.getMapSize();

								for( local x = 0; x < size.X; x = x )
								{
									for( local y = 0; y < size.Y; y = y )
									{
										local tile = this.Tactical.getTileSquare(x, y);
										tile.Level = this.Math.min(1, tile.Level);
										y = ++y;
									}

									x = ++x;
								}
							};
							this.World.Contracts.startScriptedCombat(properties, false, true, false);
							return 0;
						}

					});
					  // [050]  OP_CLOSE          0      7    0    0
					i = ++i;
				}
			}

		});
		this.m.Screens.push({
			ID = "TheDuel2",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_138.png[/img]{%champbrother% chowa broń i staje nad ciałem zabitego dzikusa. Kiwając głową, zwycięski najemnik spogląda na ciebie.%SPEECH_ON%Skończone, panie.%SPEECH_OFF%Starszy znów podchodzi i unosi swoją laskę.%SPEECH_ON%A więc tak, czego chcieliście dokonać przemocą, dla której tu przybyliście?%SPEECH_OFF%Mówisz mu, że ludzie z południa są wściekli i chcą, by zniknęli z tych ziem. Starszy kiwa głową.%SPEECH_ON%Skoro bitwą chcieliście to osiągnąć, to honorowym pojedynkiem sprawa jest zakończona. Odejdziemy.%SPEECH_OFF%Dzicy dostają rozkaz w swoim języku, by się spakować i odejść. Zaskakująco mało jest sprzeciwów czy narzekań. Jeśli dotrzymają słowa, możesz wrócić i powiedzieć o tym %employer%owi.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To się dobrze skończyło.",
					function getResult()
					{
						this.Contract.setState("Return");
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						return 0;
					}

				}
			],
			function start()
			{
				local bro = this.Tactical.getEntityByID(this.Flags.get("ChampionBrother"));
				this.Characters.push(bro.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "TheDuel3",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_138.png[/img]{To była dobra walka, starcie ludzi na ziemi, a obserwatorzy milczeli, jakby w podziwie dla jakiegoś ponadczasowego, honorowego obrzędu. Ale. %champbrother% leży martwy na ziemi. Pokonany i zabity. Starszy znów wychodzi naprzód. Nie ma w nim ani śladu triumfu czy uśmiechu.%SPEECH_ON%Obcy, walka dwóch ludzi jest jak walka wszystkich nas razem. Zwyciężyliśmy, błogosławione niech będzie spojrzenie Dalekiej Skały, więc prosimy, byście opuścili te ziemie i nie wracali.%SPEECH_OFF%Kilku najemników spogląda na ciebie z gniewem. Jeden mówi, że nie wierzy, by dzicy dotrzymali umowy, gdyby sytuacja była odwrotna, i że kompania powinna wybić tych barbarzyńców bez względu na wynik.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Dotrzymamy słowa i zostawimy was w spokoju.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Assets.addMoralReputation(5);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Nie zdołałeś zniszczyć obozowiska barbarzyńców, zagrażającego osadzie " + this.Contract.m.Home.getName());
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				},
				{
					Text = "Wszyscy, do ataku!",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-3);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivor1",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_145.png[/img]{Po bitwie %randombrother% przywołuje cię gestem. W jednym z namiotów barbarzyńca opatruje ranę. Wokół niego leżą mężczyźni, kobiety i dzieci. Najemnik wskazuje na niego.%SPEECH_ON%Ścigaliśmy dzikusa i wpadliśmy tutaj. Chyba to jego rodzina wokół, albo ktoś mu bliski, bo po prostu się osunął i od tego czasu nie rusza.%SPEECH_OFF%Podchodzisz do mężczyzny i kucasz przed nim. Stukasz w jego but z jeleniej skóry i pytasz, czy cię rozumie. Kiwając głową, wzrusza ramionami.%SPEECH_ON%Mało. Wy to zrobiliście. Nie musieliście, ale zrobiliście. Dokończ mnie albo walczę z wami. Jedno albo drugie, wszystko honorowe.%SPEECH_OFF%Wygląda na to, że oferuje swoją rękę do walki u was, zapewne w ramach jakiegoś północnego kodeksu, obcego tobie. Oferuje też głowę, jeśli jej chcesz, i wydaje się tego zupełnie nie bać.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nie zostawiamy nikogo przy życiu.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-1);
						return "Survivor2";
					}

				},
				{
					Text = "Pozwólcie mu odejść.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(2);
						return "Survivor3";
					}

				}
			],
			function start()
			{
				if (this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
				{
					this.Options.push({
						Text = "Mógłby nam się przydać ktoś taki.",
						function getResult()
						{
							return "Survivor4";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Survivor2",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_145.png[/img]{Wysuwasz miecz i opuszczasz ostrze w stronę mężczyzny, a zwłoki w namiocie rozmazują się na jego stalowym łuku, a twarz ocalałego barbarzyńcy zlewa się na czubku. Uśmiecha się i chwyta krawędzie, osłaniając je swoimi ogromnymi dłońmi. Z jego dłoni kapie krew.%SPEECH_ON%Śmierć, zabijanie, bez hańby. Dla nas obu. Tak?%SPEECH_OFF%Kiwając głową, wpychasz ostrze w jego klatkę piersiową i osuwasz go na ziemię. Ciężar jego ciała na mieczu jest jak kamień, a gdy odrywasz ostrze, zwłoki z głuchym stukiem opadają na stertę ciał. Chowasz miecz i każesz kompanii zebrać, co się da, oraz szykować powrót do %employer%a.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Czas na zapłatę.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivor3",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_145.png[/img]{Wysuwasz ostrze do połowy, trzymasz je tak długo, by dzikus je zobaczył, po czym wpychasz je z powrotem do pochwy. Kiwasz głową i pytasz.%SPEECH_ON%Rozumiesz?%SPEECH_OFF%Barbarzyńca wstaje, na chwilę opierając się o słup namiotu. Odwracasz się i wskazujesz dłonią na wejście. On kiwa głową.%SPEECH_ON%Tak, wiem.%SPEECH_OFF%Chwieje się, wychodzi na światło i znika w północnych pustkowiach, jego sylwetka kołysze się na boki, maleje i w końcu znika. Każesz kompanii przygotować się do powrotu po zasłużoną zapłatę od %employer%a.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Czas na zapłatę.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivor4",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_145.png[/img]{Patrzysz na mężczyznę, po czym wyjmujesz sztylet i rozcinasz wnętrze dłoni. Wyciskając krew, rzucasz sztylet barbarzyńcy i wyciągasz rękę, z której stale kapie krew. Dzikus bierze ostrze i nacina się po kolei. Wstaje i wyciąga dłoń, a ty ją ściskasz. Kiwając głową, mówi:%SPEECH_ON%Honor, zawsze. Z tobą, jedyna droga, aż do końca.%SPEECH_OFF%Mężczyzna chwieje się i wychodzi z namiotu. Każesz ludziom go nie zabijać, lecz uzbroić, co wzbudza kilka uniesionych brwi. Jego dołączenie do kompanii jest nieoczekiwane, ale pożyteczne. Południowi najemnicy z czasem się przyzwyczają, ale na razie %companyname% musi wrócić do %employer%a.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Witaj w kompanii.",
					function getResult()
					{
						this.World.getPlayerRoster().add(this.Contract.m.Dude);
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude.worsenMood(1.0, "Widział, jak jego wioska została wyrżnięta");
						this.Contract.m.Dude.onHired();
						this.Contract.m.Dude = null;
						return 0;
					}

				}
			],
			function start()
			{
				local roster = this.World.getTemporaryRoster();
				this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
				this.Contract.m.Dude.setStartValuesEx([
					"barbarian_background"
				]);

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Revenge1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_135.png[/img]{Na twojej drodze staje mężczyzna. To starszy, nie z południa.%SPEECH_ON%Ach, Obcy. Przychodzicie na nasze ziemie i pustoszycie bezbronną wioskę.%SPEECH_OFF%Spluwasz i kiwasz głową. %randombrother% krzyczy, że to dokładnie to, co robią sami dzicy. Starzec uśmiecha się.%SPEECH_ON%Jesteśmy więc w cyklu, a przez tę przemoc wszyscy się odrodzimy, lecz przemoc musi być. Gdy z wami skończymy, %townname% nie zostanie oszczędzone.%SPEECH_OFF%Z terenu, w którym się kryli, podnoszą się rosli mężczyźni. Wygląda na to, że to główna drużyna wojenna wioski, którą spaliłeś. Mogli być na wyprawie, gdy złupiłeś miejsce. Teraz przychodzą po barbarzyński odwet.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult()
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Revenge";
						properties.Music = this.Const.Music.BarbarianTracks;
						properties.EnemyBanners.push(this.Flags.get("EnemyBanner"));
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Barbarians, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getID());
						this.World.Contracts.startScriptedCombat(properties, false, true, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Revenge2",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_145.png[/img]{Dzicy zostają wypędzeni z %townname%. Mimo wyniku potrzeba czasu, by mieszkańcy wyszli i zobaczyli pełnię twojego zwycięstwa. %employer% w końcu wychodzi, klaszcząc i pokrzykując. Towarzyszy mu orszak zawstydzonych poruczników, rozglądających się wokół, z ubłoconymi kolanami i słomą oraz grudami ziemi na ubraniach. Wygląda na to, że się ukrywali.%SPEECH_ON%Dobra robota, najemniku, dobra robota! Stare bogi na pewno to widziały i nagrodzą cię w swoim czasie!%SPEECH_OFF%Chowasz miecz i kiwasz głową w stronę bezużytecznych poruczników tego człowieka.%SPEECH_ON%Może, ale lepiej, żebyś zrobił to najpierw. Stare bogi na pewno docenią, że działasz w ich imieniu, skoro inni, powiedzmy, nie mogli.%SPEECH_OFF%Mężczyzna zaciska usta i zerka na swoich poruczników, którzy odwracają wzrok. Twój zleceniodawca uśmiecha się i kiwa głową.%SPEECH_ON%Oczywiście, oczywiście, najemniku. Dobrze cię rozumiem. Dostaniesz pełną zapłatę i coś ekstra! Wszystko w pełni zasłużone!%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Dzień ciężkiej pracy.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Zniszczyłeś obozowisko barbarzyńców, które zagrażało osadzie " + this.Contract.m.Home.getName());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Ocaliłeś " + this.Contract.m.Home.getName() + " przed zemstą barbarzyńców");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() * 2;
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] koron"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Revenge3",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_94.png[/img]{Zostajesz wypędzony z pola bitwy i wycofujesz się na wystarczająco bezpieczne miejsce, by oglądać zagładę %townname%. Dzicy wpadają do domów i zaczynają gwałcić oraz mordować zarówno mężczyzn, jak i kobiety. Dzieci są zbierane i wrzucane do klatek z kości i skór, gdzie starszy łagodnie podaje im pokrojone jabłka i kubki kamfory. Na rynku widzisz, jak prymitywni rzucają się na dom %employer%a. Kilku strażników wychodzi naprzód, ale niemal natychmiast zostają ścięci. Jednego mężczyznę kładą na ziemi, rozbierają i kopią w stronę pary psów, które rozrywają go z każdej strony, a on żyje przez niepokojąco długi czas.\n\n Wreszcie %employer% zostaje wyciągnięty z domu. Przywódca barbarzyńców patrzy na niego z góry, kiwa głową, po czym jedną ręką chwyta go za kark, a drugą zasłania mu twarz. W tym uścisku mężczyzna się dusi. Zwłoki zostają rzucone wojownikom, którzy je obdzierają, profanują, a potem nabijają od odbytu po usta i wznoszą wysoko na rynku. Gdy grabież się kończy, dzicy zabierają, co chcą, i odchodzą. Ostatnie, co widzisz, to pies biegnący z ludzką klatką piersiową w pysku. %randombrother% podchodzi do ciebie.%SPEECH_ON%Cóż. Nie sądzę, żebyśmy dostali zapłatę, panie.%SPEECH_OFF%Nie. Też tak sądzisz.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wszystko stracone.",
					function getResult()
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).getRoster().remove(this.Tactical.getEntityByID(this.Contract.m.EmployerID));
						this.Contract.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 4);
						this.Contract.m.Home.setLastSpawnTimeToNow();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 2, "Nie zdołałeś ocalić " + this.Contract.m.Home.getName() + " przed zemstą barbarzyńców");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "W pobliżu %townname%...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% wita cię oklaskami.%SPEECH_ON%Moi zwiadowcy śledzili twoją kompanię na północ i do jej, śmiem rzec, nieuniknionego sukcesu! Wspaniała robota z mordowaniem tych dzikusów. To na pewno sprawi, że dwa razy pomyślą, zanim znów tu zejdą!%SPEECH_OFF%Mężczyzna wypłaca ci należność. | Wchodzisz do komnaty %employer%a i zastajesz go rozpartego w fotelu. Ogląda nagą kobietę przechadzającą się z jednej strony pokoju na drugą. Kręcąc głową, rozmawia z tobą, nie odrywając wzroku od przedstawienia.%SPEECH_ON%Moi zwiadowcy już opowiedzieli mi o twoich czynach. Mówili, że potraktowałeś barbarzyńców tak, jakby ich krzywdy były wymierzone w ciebie osobiście. Podoba mi się to. Podoba mi się ten brak wstrzemięźliwości. Chciałbym, by więcej moich ludzi to miało.%SPEECH_OFF%Sługa, dotąd niewidoczny, szybko maszeruje przez pokój. Na głowie ma czerwoną świecę, a w rękach skrzynię koron. Bierzesz zapłatę i wychodzisz z pokoju najszybciej, jak możesz. | Znajdujesz %employer%a i grupę opancerzonych ludzi stojących wokół stołu. Leży na nim ciało barbarzyńcy. Skóra poszarzała, ale muskulatura i twardość ciała jeszcze się nie rozpadły. Pytają, czy naprawdę walczyłeś z ludźmi tego typu. Przechodzisz do sedna i prosisz o zapłatę. %employer% klaszcze i przedstawia cię grupie.%SPEECH_ON%Panowie, oto człowiek, którego chciałbym w swoich szeregach! Nieustraszony i zawsze skupiony.%SPEECH_OFF%Jeden ze szlachciców spluwa i mówi coś, czego nie dosłyszałeś. Prosisz, by powiedział głośniej, jeśli ma coś do dodania, ale %employer% pospiesznie podchodzi, z skrzynią koron w rękach, i odsyła cię w drogę. | Odnalezienie %employer%a okazuje się nieco trudne, poszukiwania kończą się w pozornie opuszczonej stodole. Widzisz go stojącego przed martwym barbarzyńcą, którego zwłoki wiszą na belkach za nogi jak rybacki połów. Ciało zostało spalone, okaleczone i czego tam jeszcze. %employer% kuca i myje ręce w wiadrze.%SPEECH_ON%Muszę przyznać, najemniku, zabicie tylu dzikusów robi wrażenie. Ten tutaj trzymał się długo. Znosił ból, jakby miał mi oddać go dziesięciokrotnie. Ale nie zrobił tego. A ty?%SPEECH_OFF%Mężczyzna delikatnie policzkuje barbarzyńcę, a łańcuchy brzęczą, gdy ciało lekko się obraca. %employer% kiwa głową.%SPEECH_ON%Sługa na zewnątrz wyda ci zapłatę. Dobra robota, najemniku.%SPEECH_OFF% | Znajdujesz %employer%a i grupę mężczyzn nadzorujących obronę %townname%, bez wątpienia szykujących się na kolejny atak. Sądząc po ich wyglądzie, ich ambicje przetrwania zderzą się z rzeczywistością znacznie okrutniejszą, niż są gotowi przyjąć. Ale zachowujesz to dla siebie. %employer% dziękuje ci za dobrze wykonaną robotę i wypłaca należność. | Kilku mieszkańców %townname% widzi twój powrót z przerażoną konsternacją, biorąc cię za dzikusów, których zdążyli poznać. Okna są zamykane, drzwi trzaskają, dzieci są odprowadzane, a kilku odważniejszych wychodzi z widłami. %employer% wybiega ze swojego domu i wszystko wyjaśnia, tłumacząc, że jesteś bohaterem tej historii, że poszedłeś na północ i unicestwiłeś dzikusów, spaliłeś ich wioskę i rozproszyłeś ich po pustkowiach. Okna się otwierają, drzwi skrzypią, a dzieci wracają do zabawy. Gdy już myślisz, że porządek wrócił, stara kobieta warczy.%SPEECH_ON%Najemnik to tylko dzikus pod inną nazwą!%SPEECH_OFF%Wzdychasz i mówisz %employer%owi, by zapłacił, co się należy. | %employer% studiuje kilka zwojów. Jednocześnie dopisuje do nich notatki i wykreśla inne. Podnosząc wzrok, wyjaśnia, że zapisuje cię w kronikach jako \"bohatera, który poszedł na pustkowia\" i \"wyrżnął dzikusów w sposób najbardziej właściwy i południowy\". Prosi, byś przypomniał mu swoje imię. Prosisz go, by zapłacił, co ci się należy. | %employer% przebywa w towarzystwie grupy szlochających kobiet. Pociesza je, a gdy wchodzisz, wstaje i wskazuje cię palcem.%SPEECH_ON%Oto człowiek, który zabił tych, którzy zamordowali waszych mężów!%SPEECH_OFF%Kobiety zawodzą i podbiegają do ciebie jedna po drugiej, a ty wiesz, że jedyne, co możesz zrobić, to skinąć głową surowo i spokojnie. %employer% jest ostatnim z tłumu, który do ciebie podchodzi, z skrzynią koron pod pachą i krzywym uśmiechem na ustach. Bierzesz zapłatę, a mężczyzna wraca do kobiet.%SPEECH_ON%Spokojnie, piękne panie, świat ujrzy nowy świt. Proszę, chodźcie ze mną. Czy ktoś chce wina?%SPEECH_OFF% | %employer% wita cię z otwartymi ramionami. Odrzucasz uścisk i pytasz o zapłatę. Wraca do biurka.%SPEECH_ON%Nie próbowałem cię objąć, najemniku.%SPEECH_OFF%Stuka w skrzynię z pewnym przygnębieniem.%SPEECH_ON%Ale dobrze się spisałeś, wyrzynając tych dzikusów. Mam kilku zwiadowców, którzy opisywali to jako \"wspaniały czas\" dla ciebie. Zasłużyłeś na to.%SPEECH_OFF%Przesuwa skrzynię po biurku, a ty chwytasz ją na wyciągniętych ramionach, czując lekki opór, gdy jeszcze ją przytrzymuje. Pośpiesznie opuszczasz pokój, nie oglądając się za niego. | Z trudem znajdujesz %employer%a, aż w końcu widzisz go w połowie szybu studni, gdzie zatyka otwór kamienną płytą. Krzyczy do ciebie.%SPEECH_ON%Ach, najemniku. Wciągnijcie mnie, ludzie!%SPEECH_OFF%Układ z bloczkiem podciąga deskę, na której siedzi. Zsuwa nogi i opiera je na cembrowinie studni.%SPEECH_ON%Nasz murarz został zabity przez osła, więc pomyślałem, że sam przyłożę rękę. Nie ma nic lepszego niż trochę brudnej roboty, by dobry człowiek wstał rano z energią.%SPEECH_OFF%Uderza cię rękawicą w pierś, zostawiając pylisty ślad. Kiwając głową, wzywa sługę, by przyniósł twoją zapłatę.%SPEECH_ON%Dobra robota, najemniku. Bardzo, bardzo dobra. Heh.%SPEECH_OFF%Nie wdajesz się w żarty. | Znajdujesz %employer%a wygłaszającego przemowę do tłumu chłopów. Opisuje bezimienną siłę południowców, która ruszyła na północ i zniszczyła dzikie śmieci. Ani razu nie wymienia ani ciebie, ani %companyname%. Gdy kończy, tłum chłopów klaszcze i wiwatuje, lecą kwiaty, a ogólny nastrój świąteczny przejmuje okolicę. %employer% odnajduje cię i ściska dłoń, jednocześnie przesuwając w twoją stronę skrzynię koron.%SPEECH_ON%Chciałbym nazwać cię bohaterem dla tych wspaniałych ludzi, ale najemnicy nie cieszą się najlepszą opinią.%SPEECH_OFF%Obejmujesz dłonią zapłatę i pochylasz się do przodu.%SPEECH_ON%Chcę tylko zapłaty. Baw się dobrze, %employer%.%SPEECH_OFF% | Znajdujesz %employer%a na ceremonii pogrzebowej. Pali się stos pogrzebowy obciążony trzema ciałami i prawdopodobnie czwartym, mniejszym. Być może całej rodziny. %employer% mówi kilka miłych słów, po czym podpala drewno. Sługa zaskakuje cię skrzynią koron.%SPEECH_ON%%employer% nie życzy sobie zakłóceń. Oto twoja zapłata, najemniku. Policz, jeśli nie ufasz, że wszystko się zgadza.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Zniszczyłeś obozowisko barbarzyńców, które zagrażało osadzie " + this.Contract.m.Home.getName());
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
			"barbarianname",
			this.m.Flags.get("ChampionName")
		]);
		_vars.push([
			"champbrother",
			this.m.Flags.get("ChampionBrotherName")
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

