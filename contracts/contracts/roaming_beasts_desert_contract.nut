this.roaming_beasts_desert_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.roaming_beasts_desert";
		this.m.Name = "Polowanie na Bestie";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
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
					"Zapoluj na to, co terroryzuje " + this.Contract.m.Home.getName()
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 40 || this.World.getTime().Days <= 15 && r <= 80)
				{
					this.Flags.set("IsHyenas", true);
				}
				else if (r <= 80)
				{
					this.Flags.set("IsSerpents", true);
				}
				else
				{
					this.Flags.set("IsGhouls", true);
				}

				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10);
				local party;

				if (this.Flags.get("IsHyenas"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Hieny", false, this.Const.World.Spawn.Hyenas, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("Stado żarłocznych hien, polujących na zwierzynę.");
					party.setFootprintType(this.Const.World.FootprintsType.Hyenas);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Hyenas, 0.75);
				}
				else if (this.Flags.get("IsGhouls"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Nachzehrery", false, this.Const.World.Spawn.Ghouls, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("Stado grasujących nachzehrerów.");
					party.setFootprintType(this.Const.World.FootprintsType.Ghouls);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Ghouls, 0.75);
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "WԄքe", false, this.Const.World.Spawn.Serpents, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("Olbrzymie węże pełzające po okolicy.");
					party.setFootprintType(this.Const.World.FootprintsType.Serpents);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Serpents, 0.75);
				}

				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Home);
				roam.setMinRange(2);
				roam.setMaxRange(8);
				roam.setAllTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
				roam.setTerrain(this.Const.World.TerrainType.Shore, false);
				roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
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
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					if (this.Flags.get("IsHyenas"))
					{
						this.Contract.setScreen("CollectingHyenas");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsGhouls"))
					{
						this.Contract.setScreen("CollectingGhouls");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsSerpents"))
					{
						this.Contract.setScreen("CollectingSerpents");
						this.World.Contracts.showActiveContract();
					}

					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsWorkOfBeastsShown") && this.World.getTime().IsDaytime && this.Contract.m.Target.isHiddenToPlayer() && this.Math.rand(1, 9000) <= 1)
				{
					this.Flags.set("IsWorkOfBeastsShown", true);
					this.Contract.setScreen("WorkOfBeasts");
					this.World.Contracts.showActiveContract();
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
					if (this.Flags.get("IsHyenas"))
					{
						this.Contract.setScreen("Success1");
					}
					else if (this.Flags.get("IsGhouls"))
					{
						this.Contract.setScreen("Success2");
					}
					else if (this.Flags.get("IsSerpents"))
					{
						this.Contract.setScreen("Success3");
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
			Text = "[img]gfx/ui/events/event_162.png[/img]{Wchodzisz do rezydencji %employer%, a on stoi nad bogatym dywanem zasłanym ludzkimi szczątkami. Spogląda na ciebie.%SPEECH_ON%To mieli być zabójcy bestii, ponoć, a oto są, wyniesieni z zadania, na które ich wysłałem.%SPEECH_OFF%Wezyr przytakuje i kilku pomocników zwija dywan. Mięso i trzewia plaskają i ściskają się, wypływając bokami. Służba unosi dywan, przerzuca go na ramiona i wynosi, a z jednego końca leniwie zwisa odcięta dłoń. %employer% klaszcze w dłonie.%SPEECH_ON%Na pustyni żyje mój problem, gromada okrutnych bestii, które zbierają żniwo wśród miejscowych. Spojrzałem w Wieczne Ognie i dostałem wskazówkę, by wezwać Koroniarza do rozwiązania tej potworności. Czy uważasz, Koroniarzu, że %reward% koron to odpowiednia kwota za twoją chwilową lojalność?%SPEECH_OFF% | Wchodzisz do siedziby %employer%, ale prawdziwa ściana strażników nie pozwala podejść bliżej. Wezyr stoi u stóp tronu, do którego prowadzą krótkie schodki. Schodzi powoli, stopień po stopniu, i staje na spoczniku. Jeden z mężczyzn spogląda na niego, a Wezyr przytakuje. Mężczyzna odwraca się do ciebie i podaje zwój. Jest w nim, że stworzenia nieokreślonego rodzaju sieją spustoszenie w protektoracie %townname%. Jeśli odnajdziesz i zniszczysz te potwory, zostaniesz nagrodzony odpowiednio do zadania, %reward% koron. | %employer% siedzi otoczony haremem półnagich kobiet. W dłoni trzyma odciętą rękę i, co zaskakujące, kobiety wydają się nią bardziej zafascynowane niż zgorszone. Gdy cię widzi, Wezyr upuszcza dłoń i wyciera swoją o ramię jednej z kobiet, tym razem wywołując całkiem sporo dezaprobaty, choć niewolniczo stłumionej.\n\n%employer% pstryka na sługę, który podbiega z dzbanem wina. Wezyr wzdycha, odprawia go i pstryka raz jeszcze. Drugi sługa orientuje się, że go wzywa, podchodzi, pospiesznie wręcza ci zwój i odczytuje na głos: w pobliżu %townname% widziano potwory i trzeba je jak najszybciej zniszczyć.\n\n O nagrodzie nie mówi się już tak głośno. Zamiast tego sługa stuka palcem w miejsce, gdzie zapisano liczbę: %reward% koron. | %employer% stoi nad mapą tak ogromną, że nie mieści się na żadnym stole, więc rozłożono ją na marmurowej posadzce. Wydaje się to zbędne, bo mapę dałoby się spokojnie wykonać w odpowiedniej skali, ale zachowujesz to dla siebie. Wezyr przechadza się po papierze i wskazuje miejsce.%SPEECH_ON%Bestie napadły na tę część królestwa i niszczą ją w sposób, na który nie wyraziłem zgody. Mam tam ważniejsze sprawy.%SPEECH_OFF%Wskazuje kolejny obszar mapy, wyglądający jak puste połacie pustyni, i mówi dalej.%SPEECH_ON%Potrzebuję więc kogoś takiego jak ty, Koroniarzu, by zająć się tymi wędrującymi potworami. Za powodzenie dostaniesz %reward% koron, co powinno w zupełności wystarczyć.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Porozmawiajmy o zapłacie. | To robota dla nas.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{To nie brzmi jak robota dla nas. | Życzę wam powodzenia, ale nie weźmiemy w tym udziału.}",
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
			ID = "WorkOfBeasts",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_161.png[/img]{Krew na pustyni, gęsta, że aż nasiąka piasek. Podążasz śladami do wielkiej wydmy i wspinasz się na szczyt. Po drugiej stronie leżą porozrzucane kończyny. Tułów. Ciało bez twarzy. Głębokie bruzdy w piasku prowadzą dalej. Nie zdążyliście uratować tych ludzi, ale jesteście blisko. | Docierasz do studni z chatą obok. Drzwi są otwarte i przekrzywione na zerwanym zawiasie. Z dobytym mieczem powoli je odchylasz i znajdujesz papkę, która kiedyś mogła być człowiekiem. Z sufitu kapie krew, a w przeciwległej ścianie chaty zieje dziura, gdzie cokolwiek to było, opuściło miejsce równie brutalnie, jak do niego weszło. Bestie muszą być blisko. | Ciała zaścielają teren wokół pustynnej studni. Gdy się zbliżasz, para dłoni chwyta krawędź cembrowiny i podciąga człowieka. To starzec. Przerzuca nogi przez mur i siada, łapiąc oddech. Wskazuje na okolicę i wzrusza ramionami. Wygląda na to, że bestie były tu przed chwilą, ale je przegapiliście. Sięgasz po bukłak i oferujesz go starcowi, ale odprawia cię gestem. W jego oczach widać wielki ból, lecz usilnie stara się, byś zobaczył go jak najmniej.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ruszamy dalej.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingHyenas",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_159.png[/img]{Nie masz całkowitej pewności, bo nie znasz się szczególnie na tych stworzeniach, ale czujesz pogardę, patrząc na hieny. Niosą znamię padlinożerców, kretynów, którzy polują na słabych, choć mają siłę i liczebność, by walczyć o pożywienie. Dopiero gdy natknęły się na ciebie i ujrzały swój kres, postanowiły wypełnić swoje bestialskie przeznaczenie. Odcinasz im głowy i szykujesz powrót do %employer%. | Hieny są odrażające, ale twarde. Nawet po śmierci musisz rąbać i siekać ich szyje, by w ogóle się w nie wgryźć, a odpiłowanie głów zajmuje jeszcze więcej czasu. W końcu robota skończona i szykujesz się, by zabrać czaszki i skóry do %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Kończmy to, mamy korony do odebrania.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingGhouls",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_131.png[/img]{Po bitwie podchodzisz do martwego ghula i przyklękasz. Gdyby nie brama z pokracznych zębów, bez trudu zmieściłbyś głowę w jego ogromnej paszczy. Zamiast podziwiać tę dentystyczną porażkę, wyciągasz nóż i odcinasz mu łeb. Podnosisz trofeum i każesz %companyname% zrobić to samo. %employer% będzie oczekiwał więcej dowodów niż jednej głowy. | Martwe ciało ghula wygląda bardziej jak głaz niż bestia, gdy leży płasko i nieruchomo. W jego paszczy już kopulują muchy, siejąc życie na pienistych resztkach śmierci. Rozkazujesz %randombrother%, by odciął mu głowę, bo %employer% będzie oczekiwał dowodów. | Martwe ghule leżą porozrzucane. Przyklękasz przy jednym i zaglądasz mu do pyska. Z płuc dobywa się długi, bulgoczący oddech obrzydliwej brei. Przykładając chustę do nosa, odcinasz głowę sztyletem. Rozkazujesz kilku braciom zrobić to samo, bo %employer% będzie oczekiwał dowodów. | Martwy ghul to interesujący okaz. Nie możesz się powstrzymać, by nie zastanowić się, gdzie leży na naturalnym spektrum. Uformowany jak pustelniczy dzikus, z mięśniami drapieżnika, a głowa wydaje się bardziej kamienna niż cielesna. Odkładasz ciekawość na bok i rozkazujesz %companyname% zbierać skalpy, bo %employer% na pewno będzie oczekiwał dowodów.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wracamy do %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingSerpents",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_169.png[/img]{Kucasz przed jednym z piaskowych węży. Od końca do końca mógłbyś się położyć kilka razy i wciąż nie dosięgnąłbyś jego długości. Zaiste fascynujący wąż. Zaczynasz je oskórowywać, by oddać trofea %employer% jako dowód. | Węże są pocięte na kawałki, a ty zbierasz to, co najlepsze - głównie ich spłaszczone łby i osobliwe ogony - aby przedstawić %employer% dowód wykonania zadania.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wracamy do %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_162.png[/img]{Gdy wracasz, %employer% już czeka przed pałacem. Obok niego stoi kilku mężczyzn w jedwabnych szatach. Gdy składasz zwłoki hien, mężczyźni szybko je zabierają. Wezyr zostaje z kilkoma strażnikami u boku. Pstryka palcami, a sługa podaje ci skrzynię koron. Wezyr przytakuje.%SPEECH_ON%Dobra robota, Koroniarzu. Z tych paczek, które dostarczyłeś w porę, zrobimy właściwy użytek.%SPEECH_OFF%Paczki? Myślałeś, że jesteś tu, by rozwiązać problem potworów. Gdy strażnicy wyprowadzają cię z placu, widzisz jednego z mędrców, który przykłada kątomierz i zaczyna pomiary, podczas gdy inny ustawia postument i zaczyna malować. | %employer% stoi w drzwiach, choć trzymają cię w bezpiecznej odległości. Zamiast niego witają cię słudzy. Zabierają skóry hien i wrzucają je do posrebrzanych taczek. Służba pędem znika z towarem po drugiej stronie dziedzińca. Wezyr gwiżdże jak sokół pikujący na zdobycz. Drgasz odruchowo, ale zamiast tego pojawia się kolejna para sług z kufrem koron. Jeden spogląda w niebo i recytuje.%SPEECH_ON%Koroniarzu, robota dobra, weź tę skrzynię, a sakwa urośnie.%SPEECH_OFF%Sługa cmoka i spogląda w dół, szeroko się uśmiechając.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Oczyściłeś okolicę z hien");
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
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_162.png[/img]{%employer% wita cię w sali tronowej. Jest wypełniona po brzegi ludźmi wyglądającymi na bardzo ważnych, a mimo to zostajesz wpuszczony. Zatrzymujesz się na chwilę, bo nie jesteś pewien, czy tłum to zniesie, po czym wzruszasz ramionami i wysypujesz szczątki nachzehrerów. Piana krwi, trzewi i głów rozlewa się po posadzce, ale widzowie nie wydają nawet dźwięku.\n\nSłychać tylko miękkie kroki Wezyra, który podchodzi. Wpatruje się w resztki, dłonie splecione przed sobą jak uczony, po czym pstryka palcami i horda sług sprząta bałagan. Jeden z mężczyzn z piórem i papierami sporządza notatki. Gdy wszystko jest załatwione, Wezyr wraca na tron i siada w milczeniu. Jedynym innym dźwiękiem jest szczęk przeciąganego kufra. Otrzymujesz wszystkie %reward% koron, jak obiecano, po czym cicho zachęca się cię do opuszczenia sali.\n\n Gdy się odwracasz, widzisz, jak tłum znów skupia uwagę na Wezyrze, który zaczyna modlitwy. | Mężczyzna zatrzymuje cię przed komnatą %employer%. Towarzyszy mu kilku wychudzonych skrybów z piórami i księgami. Rzucają się na twój zbiór nachzehrerów i sporządzają zapisy w swoich papierach. Każdy kończy, wyrywa kartkę i przekazuje ją pierwszemu, który porównuje notatki. Zadowolony wręcza ci sakiewkę %reward% koron.%SPEECH_ON%Niech twoja droga zawsze będzie złocona, Koroniarzu.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Oczyściłeś okolicę z nachzehrerów");
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
			}

		});
		this.m.Screens.push({
			ID = "Success3",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_162.png[/img]{Spotykasz się z %employer% w jego ogrodzie. Patrzy na ciebie, trzymając w dłoni nożyce do gałęzi.%SPEECH_ON%Rozumiem, że zadanie wykonane?%SPEECH_OFF%Przytakując, wyciągasz głowę węża i rzucasz ją na ziemię. Pluska bezgłośnie i turla się pod stopy Wezyra, który powoli je odsuwa. %employer% patrzy na ciebie surowo.%SPEECH_ON%Teatr nie jest potrzebny, Koroniarzu, to wykonanie zadania robi na mnie wrażenie. Moi strażnicy obciążą twoją sakwę %reward% koron, jak uzgodniono.%SPEECH_OFF% | Ciągniesz skóry węży ku %employer%, ale zatrzymuje cię mężczyzna w pióropuszu na turbanie. Mówi coś, co brzmi jak bełkot, choć przebijają się pojedyncze słowa. Wygląda na to, że służy Wezyrowi i to on zabiera szczątki węży. Spoglądasz na %employer%, który przytakuje, potwierdzając, że tak ma być. Zauważa też napięcie na twojej twarzy, gdy martwisz się o zapłatę. Mówi głośno i dumnie.%SPEECH_ON%Nie lękaj się, Koroniarzu, jedyne węże tutaj to te, które nam przyniosłeś.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Oczyściłeś okolicę z węży");
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
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_helpful = [];
		local candidates_bro1 = [];
		local candidates_bro2 = [];
		local helpful;
		local bro1;
		local bro2;

		foreach( bro in brothers )
		{
			if (bro.getBackground().isLowborn() && !bro.getBackground().isOffendedByViolence() && !bro.getSkills().hasSkill("trait.bright") && bro.getBackground().getID() != "background.hunter")
			{
				candidates_helpful.push(bro);
			}

			if (!bro.getSkills().hasSkill("trait.player"))
			{
				candidates_bro1.push(bro);

				if (!bro.getBackground().isOffendedByViolence() && bro.getBackground().isCombatBackground())
				{
					candidates_bro2.push(bro);
				}
			}
		}

		if (candidates_helpful.len() != 0)
		{
			helpful = candidates_helpful[this.Math.rand(0, candidates_helpful.len() - 1)];
		}
		else
		{
			helpful = brothers[this.Math.rand(0, brothers.len() - 1)];
		}

		if (candidates_bro1.len() != 0)
		{
			bro1 = candidates_bro1[this.Math.rand(0, candidates_bro1.len() - 1)];
		}
		else
		{
			bro1 = brothers[this.Math.rand(0, brothers.len() - 1)];
		}

		if (candidates_bro2.len() > 1)
		{
			do
			{
				bro2 = candidates_bro2[this.Math.rand(0, candidates_bro2.len() - 1)];
			}
			while (bro2.getID() == bro1.getID());
		}
		else if (brothers.len() > 1)
		{
			do
			{
				bro2 = brothers[this.Math.rand(0, brothers.len() - 1)];
			}
			while (bro2.getID() == bro1.getID());
		}
		else
		{
			bro2 = bro1;
		}

		_vars.push([
			"helpfulbrother",
			helpful.getName()
		]);
		_vars.push([
			"bro1",
			bro1.getName()
		]);
		_vars.push([
			"bro2",
			bro2.getName()
		]);
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Target.getTile())]
		]);
	}

	function onHomeSet()
	{
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

