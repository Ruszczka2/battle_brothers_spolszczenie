this.hunting_alps_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		SpawnAtTime = 0.0,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_alps";
		this.m.Name = "Zakończenie Koszmarów";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
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

		local names = [
			"alpy",
			"mary",
			"duszopije",
			"zmory",
			"nachtmary",
			"aufhockery",
			"nocne mary",
			"nocne zmory"
		];
		this.m.Flags.set("enemyName", names[this.Math.rand(0, names.len() - 1)]);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Połóż kres koszmarom dręczącym " + this.Contract.m.Home.getName() + " nocami"
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

				if (r <= 25)
				{
					this.Flags.set("IsGoodNightsSleep", true);
				}

				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
			}

			function update()
			{
				if (this.World.getTime().IsDaytime)
				{
					this.Contract.m.SpawnAtTime = 0.0;
				}
				else if (this.Contract.m.SpawnAtTime == 0.0 && !this.World.getTime().IsDaytime)
				{
					this.Contract.m.SpawnAtTime = this.Time.getVirtualTimeF() + this.Math.rand(8, 18);
				}

				if (this.Flags.get("IsVictory"))
				{
					this.Contract.setScreen("Victory");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (this.Contract.m.Target == null && !this.World.getTime().IsDaytime && this.Contract.isPlayerNear(this.Contract.m.Home, 600) && this.Contract.m.SpawnAtTime > 0.0 && this.Time.getVirtualTimeF() >= this.Contract.m.SpawnAtTime)
				{
					this.Flags.set("IsEncounterShown", true);
					this.Contract.setScreen("Encounter");
					this.World.Contracts.showActiveContract();
				}
				else if (!this.Flags.get("IsBanterShown") && this.World.getTime().IsDaytime && (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || this.Contract.m.Target.isHiddenToPlayer()) && this.Contract.isPlayerNear(this.Contract.m.Home, 600) && this.Time.getVirtualTimeF() - this.Flags.get("StartTime") >= 6.0 && this.Math.rand(1, 1000) <= 5)
				{
					this.Flags.set("IsBanterShown", true);
					this.Contract.setScreen("Banter");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Alps")
				{
					this.Flags.set("IsVictory", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Alps")
				{
					this.Contract.m.SpawnAtTime = -1.0;
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
			Text = "[img]gfx/ui/events/event_79.png[/img]{Zastajesz %employer%a z poduszką w dłoni. Mężczyzna u jego boku dotyka poszwy, po czym zbliża ją do nosa. Wącha ją trzy razy, kręci głową i mimo to wącha ponownie. %employer% gestem zaprasza cię do środka.%SPEECH_ON%Jeden z tutejszych chłopów zgłasza, że dziwny duch napada na jego sen. Przyniósł swoje nocne ozdoby jako dowód, ale nie wiemy, co z tym zrobić.%SPEECH_OFF%Patrzysz na dziwnego mężczyznę, który znów wtyka nos w poszewki. Unosisz brew i mówisz, że sam możesz zbadać tę sprawę. %employer% przytakuje.%SPEECH_ON%Dokładnie dlatego cieszę się, że tu jesteś. Chcę, byś został na noc lub dwie i sprawdził, czy w nocy wychodzi coś upiornego. Jestem pewien, że to nic takiego, ale zapłacę ci bez względu na to, co się pokaże. Co powiesz, interesuje cię to?%SPEECH_OFF%Dziwny mężczyzna niemal przyciska poduszkę do twarzy, łapiąc szerokie oddechy, jakby się dusił. Pyta, czy może zatrzymać poduszkę. | %employer% prowadzi cię do biurka, na którym leży kilka rysunków.%SPEECH_ON%Rzadko daję papiery i pióra miejscowym, ale kilka rodzin domagało się, by narysować to, co widziały.%SPEECH_OFF%Przyglądasz się. Każda kartka jest inna, większość przedstawia patyczaki w dość chaotycznych układach. Jeden z bardziej artystycznych rysunków pokazuje dziwne stworzenie kucające nad człowiekiem i chwytające jego głowę, jakby chciało ją ukraść. Mieszczanin kontynuuje.%SPEECH_ON%Dla mnie to zwykłe koszmary, ale sprawdziłem domy i każdy wyglądał na poważnie wzburzony, jakby coś się skradało, gdy spali. Chcę, żebyś został, najemniku, i zobaczył, co się pokaże. To pewnie tylko chuligani, ale warto sprawdzić. Jesteś zainteresowany?%SPEECH_OFF% | Zastajesz %employer%a, który słucha chłopa opowiadającego historię, ale gdy cię widzi, prosi, by opowiedział ją tobie. Wyjaśnia, że on i wiele innych rodzin cierpi na straszne sny. Co więcej, znikają zwierzęta domowe, a niektóre dzieci zgłaszały, że zostały porwane i musiały wracać do domów w środku nocy. %employer% przytakuje.%SPEECH_ON%Całe miasteczko chodzi na palcach, najemniku. Słyszałem opowieści o %enemy%, upiornych kreaturach, które pożerają cudze sny, ale jestem pewien, że to tylko jakieś dzieciaki, które knują. Tak czy inaczej, zebrano sakiewkę i jestem gotów wypłacić ją za porządną ochronę. Jesteś zainteresowany?%SPEECH_OFF% | %employer% siedzi przy biurku. Ciężko wzdycha.%SPEECH_ON%Przeklęci chłopi ciągle o %enemy% to, %enemy% tamto. Czuję się, jakbym dźwigał na barkach górę gówna, a nawet całe pasmo!%SPEECH_OFF%Mężczyzna siada i nalewa sobie kufel piwa. Wypija go szybko.%SPEECH_ON%Pożeracze snów, nocni prześladowcy, bah! Kompletna bzdura. Cóż, głupcy zebrali skrzynię monet i chcą dać ją za ochronę. Chcę, byś został na noc lub dwie i sprawdził, czy te rzekome duchy są prawdziwe, czy tylko mamy do czynienia z oszustami. Jesteś zainteresowany?%SPEECH_OFF% | %employer% trzyma głowę w dłoniach i obraca ją na boki. Pytasz, czy masz wrócić innym razem. Uderza pięściami w stół.%SPEECH_ON%Nie! To idealny moment. Mieszkańcy skarżą się na dziwne sny od wielu dni. A ostatniej nocy nawiedził mnie koszmar. Nie potrafię go nawet zrozumieć. Stałem na polu pszenicy i widziałem cienie przesuwające się między źdźbłami. Ale to nie były tylko cienie, spłaszczały pszenicę, gdy przechodziły, i... cóż, gdy się obudziłem, zobaczyłem nogi czegoś, co właśnie wybiegło z moich drzwi. Ja... znaczy chcemy, byś został na noc i zobaczył, czy i do ciebie coś przyjdzie. Jesteś zainteresowany?%SPEECH_OFF% | Zastajesz %employer%a, jak przerzuca tom. Z każdym przewróceniem strony unosi się kurz. Mówi, nie podnosząc wzroku.%SPEECH_ON%Miasto zebrało zapłatę za twoje nocne czuwanie.%SPEECH_OFF%Uśmiechasz się i pytasz, czy do oferty dołączony jest darmowy posiłek. Mężczyzna powoli zamyka księgę. Patrzy na ciebie dość obojętnie, jakbyś nic nie powiedział.%SPEECH_ON%Ludzie boją się dziwnych potworów, rzeczy żywiących się snami. Uznałem to za zabobon, ale przyszły do mnie ostatniej nocy i spojrzałem w ich oczy. Obudziłem się na strychu, modląc się do Davkula. Co do cholery to jest Davkul? Na bogów, nie wiem, co się dzieje, ale naprawdę liczę, że przyjmiesz tę ofertę. Zostań na noc lub dwie i zobacz, czy jest się czego bać poza plotkami.%SPEECH_OFF% | Zastajesz %employer%a, który obraca między kciukiem a palcem mały drewniany amulet. Ma kształt rogatego człowieka. Rzuca go na biurko i wskazuje.%SPEECH_ON%Stolarz to zrobił. Powiedział, że odwiedziło go w nocy. Spytałem kiedy. Powiedział, że we śnie, a gdy się obudził, to stało u stóp jego łóżka. A dziś trzy całe rodziny przyszły do mnie, twierdząc, że widziały to samo i że wszystkie ich psy zniknęły. Nie znalezione. Po prostu zniknęły. Nie wiem, co gnije w tych bezbożnych stronach, najemniku, ale nie spędzę kolejnej nocy bez stali u naszego boku. Jesteś zainteresowany ochroną %townname% przez noc lub dwie?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Ile koron możesz zebrać? | Porozmawiajmy o zapłacie. | Porozmawiajmy o koronach. | Przyjrzymy się temu. Za odpowiednią cenę.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{To nie brzmi jak robota dla najemników. | To nie brzmi jak robota dla nas. | Nie takie roboty szukamy.}",
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
			Title = "W pobliżu %townname%...",
			Text = "[img]gfx/ui/events/event_79.png[/img]{Gdy czekasz, drogą schodzi staruszek. Bez zachęty mówi, że jeśli szukasz bladych ludzi, najlepiej poczekać do nocy. %randombrother% pyta, co ma na myśli, mówiąc o bladych ludziach. Starzec się śmieje.%SPEECH_ON%Prawdę mówiąc, to ani bladzi, ani ludzie, ale nie wiem, jak inaczej ich tu nazwać. Moi starsi nazywali ich %enemy%, potworami, które wkładają złe myśli i wizje do głowy, a potem karmią się strachem, który wyrasta. Ale wy jesteście twardzi, poradzicie sobie.%SPEECH_OFF%Pstryka palcami pod nosem i życzy ci szczęścia. | Gdy sprawdzasz mapę i rozglądasz się po okolicy, %randombrother% podchodzi z starszą kobietą u boku. Wygląda na starą jak dąb i macha do ciebie drżącą dłonią. Nadstawiasz ucha, a ona mówi chrapliwym tonem.%SPEECH_ON%Przychodzą nocą. Oni i ich wizje.%SPEECH_OFF%Unosi palec.%SPEECH_ON%Tylko nocą! Żyją ze zepsucia. Nie ziemi, ale umysłu. Moja matka nazywała ich %enemy%, dawcami zjaw i nierzeczywistości. Gdy ich znajdziesz, usłyszysz syk, jak twoja poczytalność się wymyka. Trzymaj ją mocno, a przeżyjesz.%SPEECH_OFF% | %randombrother% podchodzi do ciebie. Mówi, że słyszał o tych bestiach wcześniej.%SPEECH_ON%Stara opowieść o potworach, co przysiadają na parapecie i obserwują, jak śpisz, albo wchodzą na łóżko i rozrywają twoje sny, żeby zajrzeć do środka. Niektórzy mówią, że to nie to. Twierdzą, że mogą dopaść cię, gdy nie śpisz, wrzucić wizje prosto do łba, żebyś widział rzeczy, których nie ma.%SPEECH_OFF% | %randombrother% podchodzi do ciebie z zamyślonym wyrazem twarzy. Opowiada, że dawno temu znał człowieka powieszonego za morderstwo. Mówiono, że posiekał swoje dzieci na kawałki. Ale oskarżony twierdził, że tylko oprawiał kury. Widział je i ich pióra, mówił, że były jak ptactwo. Powiedział, że gdy otrząsnął się i zobaczył okropieństwo przed sobą, bestia zachichotała z parapetu, kucając tam i chichocząc chytrze. Najemnik przytakuje.%SPEECH_ON%Gdy wieszali tamtego faceta, mówili, że krzyknął na coś i odskoczył od stołka. Mówili, że ciągle biegł, że spluwał zemstą, choć lina rwała mu szyję aż do uszu.%SPEECH_OFF% | %randombrother% przychodzi z meldunkiem zwiadowców. Mówi, że miejscowi nie widzieli żadnej bestii, ale widzą rzeczy w nietypowy sposób. Gdy prosisz o wyjaśnienie, najemnik wzrusza ramionami.%SPEECH_ON%Nie potrafię tego dobrze ująć, panie. Wydaje mi się, że po prostu coś widzą. Wizje i takie tam. Nie jestem skłonny ufać takim bzdurkom, ale byli szczerzy w tej sprawie.%SPEECH_OFF% | Gdy czekasz, drogą schodzi staruszek. Bez zachęty mówi, że jeśli szukasz bladych ludzi, najlepiej poczekać do nocy. %randombrother% pyta, co ma na myśli, mówiąc o bladych ludziach. Starzec się śmieje.%SPEECH_ON%Prawdę mówiąc, to ani bladzi, ani ludzie, ale nie wiem, jak inaczej ich tu nazwać. Moi starsi nazywali ich alpy, potwory, które sadzą koszmary w głowie i karmią się wyrastającym strachem.%SPEECH_OFF%Pstryka palcami pod nosem i życzy ci szczęścia. | Gdy sprawdzasz mapę i rozglądasz się po okolicy, %randombrother% podchodzi z starszą kobietą u boku. Wygląda na starą jak dąb i macha do ciebie drżącą dłonią. Nadstawiasz ucha, a ona mówi chrapliwym tonem.%SPEECH_ON%Przychodzą nocą.%SPEECH_OFF%Unosi palec.%SPEECH_ON%Tylko nocą! Żyją ze zepsucia. Nie ziemi, ale umysłu. Moja matka nazywała ich %enemy%. Gdy ich znajdziesz, usłyszysz syk, jak twoja poczytalność się wymyka. Trzymaj ją mocno.%SPEECH_OFF% | %randombrother% podchodzi do ciebie. Mówi, że słyszał o tych bestiach wcześniej.%SPEECH_ON%Czasem słyszy się o nich szepty. Istoty, które przysiadają na parapecie i obserwują, jak śpisz, albo wchodzą na łóżko i rozrywają twoje sny, by zajrzeć do środka. Nazywają je alpami i z tego, co rozumiem, wychodzą tylko nocą. O ile w ogóle istnieją, oczywiście.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{Miejcie oczy otwarte. | Musimy być na to gotowi. | Nie spać, ludzie.}",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Encounter",
			Title = "W pobliżu %townname%...",
			Text = "[img]gfx/ui/events/event_102.png[/img]{%randombrother% pośpiesznie podchodzi do ciebie.%SPEECH_ON%Coś się tam porusza.%SPEECH_OFF%Przenosisz wzrok na skraj patrolu. Cokolwiek to jest, nie tyle się porusza, co ślizga po ziemi. Wygląda jak oskórowany jeleń kroczący do tyłu, a jego oczy zostawiają za sobą smugi smołowej czerni, jakby ryły samą grozę w ziemi. Każesz ludziom chwycić za broń. | Oceniając mapę przy świetle pochodni, nagle dostrzegasz czarną sylwetkę pędzącą w mroku. To plątanina kończyn koziołkujących po ziemi, miotających się do przodu z nieprzyzwoitą prędkością. Skrada się nisko jak wąż, a jednak słyszysz dławiący charczenie kogoś umierającego we śnie. Każesz ludziom do broni. | Blada sylwetka krąży na skraju patrolu kompanii. Kuca w wysokiej trawie i wpatruje się w kompanię. W końcu podchodzisz i wyciągasz ramiona, zamykając oczy. Natychmiast %randombrother% krzyczy.%SPEECH_ON%Panie, wracaj! Panie, na bogów, jest ich więcej!%SPEECH_OFF%Otwierasz oczy i kiwasz głową. W końcu przyszły.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Na nich!",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Alps";
						p.Entities = [];
						p.Music = this.Const.Music.BeastsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Alps, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_122.png[/img]{Potwory zostały zabite. Sięgasz po miecz i rozcinasz jednemu gardło. Ostrze przechodzi z łatwością, a głowa bezwładnie opada w trawę. Oczodoły są puste i wklęsłe. W środku nie ma nic, żadnego mięsa, żadnych mięśni. Nieważne. Każesz ludziom szykować się do marszu powrotnego do %employer%a. | Alpy leżą w trawie i choć wiesz, że je raniłeś, ich ciało wygląda, jakby się zasklepiło, a one zdają się bardziej zabite twoją wytrwałością niż jakąkolwiek bronią. Bierzesz miecz, by odciąć głowę, ale ostrze sunie przez skórę, a otwór szyi marszczy się i zamyka. Dźgasz ciało kilka razy, przekręcając ostrze, by poranić ciało tak, by nie dało się go już zasklepić. Ścięgna ślizgają się chwilę, po czym nieruchomieją w otworze rany. Nie wiedząc, co o tym myśleć, wrzucasz głowę do worka i każesz ludziom szykować powrót do %employer%a.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zapłata na nas czeka.",
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
			Text = "[img]gfx/ui/events/event_79.png[/img]{%employer% prosi, by zobaczyć szczątki alpa. Wyciągasz je z worka. Ciało zwiotczało, a ty trzymasz głowę bardziej jak skalp niż czaszkę. Mieszczanin dotyka jej palcem, a skóra alpa zwija się jak wężowa. Pyta, czy dobrze walczyły. Wzruszasz ramionami.%SPEECH_ON%To odporne stworzenia, to pewne, ale nie będę przez nie tracił snu.%SPEECH_OFF%Mężczyzna niechętnie przytakuje.%SPEECH_ON%Dobrze. Oto twoja nagroda, jak obiecano. I wyrzuć to paskudztwo.%SPEECH_OFF% | Zrzucasz głowę alpa na biurko %employer%a. Zsuwa się po drewnie, aż paszcza spoczywa szeroko rozdziawiona, a puste oczodoły zwisają smutno ku światu. %employer% bierze pogrzebacz i grzebie w czaszce, po czym unosi jej bezkształtność w powietrzu.%SPEECH_ON%Co za okropna rzecz. Powinienem cię poinformować, że zaledwie kilka godzin temu wielu ludzi przyszło do mnie, mówiąc, że widzieli wizje pól skąpanych w chwalebnym świetle. Jakby śnili odnowę całego świata. Nie wiem więc, czy wszystkie te potwory zniknęły, ale wygląda na to, że niedola %townname% została dobrze zażegnana. Dopilnuję, abyś dostał nagrodę, jak obiecano.%SPEECH_OFF% | %employer% spotyka cię w swoim pokoju i śmieje się na widok worka, który przyniosłeś. Kręci głową, nalewając sobie napoju.%SPEECH_ON%Nie musisz mi pokazywać pyska tej ohydy, najemniku. Przyszło do mnie zaledwie kilka godzin temu, gdy siedziałem właśnie tam i pisałem notatki, wtargnięcie, które było snem, widok jego śmierci, jakby jego duch został odcięty od mojego i zmuszono mnie, bym patrzył, jak odchodzi. A w tym odchodzeniu widziałem ciebie stojącego tam, z mieczem w dłoni, triumfującego jak mało kto.%SPEECH_OFF%Kiwasz głową i pytasz, czy dobrze wyglądałeś. Śmieje się.%SPEECH_ON%Wyglądałeś jak pogromca światów, z pewnością pogromca świata tego stworzenia i, obawiam się, może także trochę mojego. Skradzionego, na zawsze. Cóż, nieważne. Jako człowiek cały czy rozdarty, obiecałem ci dobrą zapłatę i oto ona.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Uwolniłeś miasto od nienaturalnych koszmarów");

						if (this.Flags.get("IsGoodNightsSleep"))
						{
							return "GoodNightsSleep";
						}
						else
						{
							this.World.Contracts.finishActiveContract();
							return 0;
						}
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
		this.m.Screens.push({
			ID = "GoodNightsSleep",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Uznajesz, że ludzie zasłużyli na porządny odpoczynek, i robisz przerwę w %townname%. Mężczyźni zapadają w sen tak głęboki, że mogliby równie dobrze być martwi. Po przebudzeniu przeciągają się i ziewają. Żaden nie ma do opowiedzenia ani snu, ani koszmaru - tylko krótki dotyk niebytu, i bardzo im potrzebny.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Czuję się orzeźwiony!",
					function getResult()
					{
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 75)
					{
						bro.improveMood(1.0, "Odświeżony dzięki porządnemu wyspaniu się");
						bro.getSkills().removeByID("effects.exhausted");
						bro.getSkills().removeByID("effects.drunk");
						bro.getSkills().removeByID("effects.hangover");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
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
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Target.getTile())]
		]);
		_vars.push([
			"enemy",
			this.m.Flags.get("enemyName")
		]);
		_vars.push([
			"enemyC",
			this.m.Flags.get("enemyName").toupper()
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/terrifying_nightmares_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
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

		this.m.Flags.set("SpawnAtTime", this.m.SpawnAtTime);
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		if (!this.m.Flags.has("StartTime"))
		{
			this.m.Flags.set("StartTime", 0);
		}

		this.contract.onDeserialize(_in);

		if (this.m.Flags.has("SpawnAtTime"))
		{
			this.m.SpawnAtTime = this.m.Flags.get("SpawnAtTime");
		}
	}

});

