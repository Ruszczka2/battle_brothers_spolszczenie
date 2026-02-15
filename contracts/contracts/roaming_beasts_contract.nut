this.roaming_beasts_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.roaming_beasts";
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

				if (this.Math.rand(1, 100) <= 5 && this.World.Assets.getBusinessReputation() > 500)
				{
					this.Flags.set("IsHumans", true);
				}
				else
				{
					local village = this.Contract.getHome().get();
					local twists = [];
					local r;
					r = 50;

					if (this.isKindOf(village, "small_lumber_village") || this.isKindOf(village, "medium_lumber_village"))
					{
						r = r + 50;
					}
					else if (this.isKindOf(village, "small_tundra_village") || this.isKindOf(village, "medium_tundra_village"))
					{
						r = r + 50;
					}
					else if (this.isKindOf(village, "small_snow_village") || this.isKindOf(village, "medium_snow_village"))
					{
						r = r + 50;
					}
					else if (this.isKindOf(village, "small_steppe_village") || this.isKindOf(village, "medium_steppe_village"))
					{
						r = r - 25;
					}
					else if (this.isKindOf(village, "small_swamp_village") || this.isKindOf(village, "medium_swamp_village"))
					{
						r = r - 25;
					}

					twists.push({
						F = "IsDirewolves",
						R = r
					});
					r = 50;

					if (this.isKindOf(village, "small_steppe_village") || this.isKindOf(village, "medium_steppe_village"))
					{
						r = r + 50;
					}
					else if (this.isKindOf(village, "small_farming_village") || this.isKindOf(village, "medium_farming_village"))
					{
						r = r + 25;
					}
					else if (this.isKindOf(village, "small_tundra_village") || this.isKindOf(village, "medium_tundra_village"))
					{
						r = r - 25;
					}
					else if (this.isKindOf(village, "small_snow_village") || this.isKindOf(village, "medium_snow_village"))
					{
						r = r - 50;
					}
					else if (this.isKindOf(village, "small_swamp_village") || this.isKindOf(village, "medium_swamp_village"))
					{
						r = r + 25;
					}

					twists.push({
						F = "IsGhouls",
						R = r
					});

					if (this.Const.DLC.Unhold)
					{
						r = 50;

						if (this.isKindOf(village, "small_lumber_village") || this.isKindOf(village, "medium_lumber_village"))
						{
							r = r + 100;
						}
						else if (this.isKindOf(village, "small_tundra_village") || this.isKindOf(village, "medium_tundra_village"))
						{
							r = r - 25;
						}
						else if (this.isKindOf(village, "small_steppe_village") || this.isKindOf(village, "medium_steppe_village"))
						{
							r = r - 25;
						}
						else if (this.isKindOf(village, "small_snow_village") || this.isKindOf(village, "medium_snow_village"))
						{
							r = r - 50;
						}
						else if (this.isKindOf(village, "small_swamp_village") || this.isKindOf(village, "medium_swamp_village"))
						{
							r = r + 25;
						}

						twists.push({
							F = "IsSpiders",
							R = r
						});
					}

					local maxR = 0;

					foreach( t in twists )
					{
						maxR = maxR + t.R;
					}

					local r = this.Math.rand(1, maxR);

					foreach( t in twists )
					{
						if (r <= t.R)
						{
							this.Flags.set(t.F, true);
						}
						else
						{
							r = r - t.R;
						}
					}
				}

				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10);
				local party;

				if (this.Flags.get("IsHumans"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).spawnEntity(tile, "Wilkory", false, this.Const.World.Spawn.BanditsDisguisedAsDirewolves, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("Stado morderczych wilkorów, polujących na zwierzynę.");
					party.setFootprintType(this.Const.World.FootprintsType.Direwolves);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Direwolves, 0.75);
				}
				else if (this.Flags.get("IsGhouls"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Nachzehrery", false, this.Const.World.Spawn.Ghouls, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("Stado grasujących nachzehrerów.");
					party.setFootprintType(this.Const.World.FootprintsType.Ghouls);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Ghouls, 0.75);
				}
				else if (this.Flags.get("IsSpiders"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Webknechty", false, this.Const.World.Spawn.Spiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("Rój webknechtów biegających po okolicy.");
					party.setFootprintType(this.Const.World.FootprintsType.Spiders);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Spiders, 0.75);
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Wilkory", false, this.Const.World.Spawn.Direwolves, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("Stado morderczych wilkorów, polujących na zwierzynę.");
					party.setFootprintType(this.Const.World.FootprintsType.Direwolves);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Direwolves, 0.75);
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
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					if (this.Flags.get("IsHumans"))
					{
						this.Contract.setScreen("CollectingProof");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsGhouls"))
					{
						this.Contract.setScreen("CollectingGhouls");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsSpiders"))
					{
						this.Contract.setScreen("CollectingSpiders");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("CollectingPelts");
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

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsHumans") && !this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					local troops = this.Contract.m.Target.getTroops();

					foreach( t in troops )
					{
						t.ID = this.Const.EntityType.BanditRaider;
					}

					this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
					this.Contract.setScreen("Humans");
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
					if (this.Flags.get("IsHumans"))
					{
						this.Contract.setScreen("Success2");
					}
					else if (this.Flags.get("IsGhouls"))
					{
						this.Contract.setScreen("Success3");
					}
					else if (this.Flags.get("IsSpiders"))
					{
						this.Contract.setScreen("Success4");
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
			Text = "[img]gfx/ui/events/event_43.png[/img]{Czekając, aż %employer% wyjaśni, po co potrzebuje twoich usług, rozmyślasz, jak ciche i upiorne było to osiedle, gdy tu przybyłeś. %employer% podnosi głos.%SPEECH_ON%To miejsce zostało przeklęte przez bogów i nawiedzone przez nieziemskie bestie! Przychodzą nocą z jarzącymi się czerwonymi oczami i zabierają życia wedle kaprysu. Większość naszego bydła już nie żyje i boję się, że gdy go zabraknie, my będziemy następni. Niedawno wysłaliśmy najsilniejszych chłopców, by odnaleźli i zabili bestie, ale od tamtej pory nic o nich nie słyszeliśmy.%SPEECH_OFF%Wzdycha głęboko.%SPEECH_ON%Podążaj tropem %direction% i wytrop oraz zabij te stworzenia, byśmy znów mogli żyć w spokoju! Nie jesteśmy bogaci, ale wszyscy złożyliśmy się na twoje usługi.%SPEECH_OFF% | Gdy go znajdujesz, %employer% wygląda przez okno. W dłoni trzyma kielich - na zewnątrz jest tylko cisza. Odwraca się do ciebie, niemal posępny.%SPEECH_ON%Kiedy tu przybyłeś, zauważyłeś, jak cicho było?%SPEECH_OFF%Odpowiadasz, że tak, ale jesteś najemnikiem, wyglądasz na takiego. Do tego jesteś przyzwyczajony. %employer% kiwa głową i pije.%SPEECH_ON%Ach, oczywiście. Niestety to nie dlatego, że ludzie boją się ciebie. Nie tym razem. W ostatnich tygodniach ludzie byli atakowani. Po okolicy krążą jakieś bestie, nie wiemy, czym są, ale wiemy, kogo zabierają. Błagaliśmy naszego pana, rzecz jasna, ale nic nie zrobił...%SPEECH_OFF%Kolejny łyk jest długi. Gdy kończy, odwraca się do ciebie z pustym kielichem w dłoni.%SPEECH_ON%Czy wytropisz te potwory? Proszę, najemniku, pomóż nam.%SPEECH_OFF% | Zastajesz %employer% wsłuchanego w rozmowy kilku chłopów. Gdy cię widzą, szybko odchodzą, zostawiając mężczyznę z sakiewką w dłoni. Unosi ją.%SPEECH_ON%W środku są korony. Korony, które ci ludzie dają mi, bym przekazał je komuś, komukolwiek, kto nam pomoże. Ludzie znikają, najemniku, a kiedy ich znajdujemy, nie są tylko martwi, ale... poszarpani. Zmasakrowani. Wszyscy boją się gdziekolwiek ruszać.%SPEECH_OFF%Wpatruje się w sakiewkę, potem patrzy na ciebie.%SPEECH_ON%Mam nadzieję, że to zadanie cię interesuje.%SPEECH_OFF% | Zastajesz %employer% czytającego zwój. Rzuca ci papier i prosi, byś odczytał imiona. Pismo jest trudne, ale nie bardziej niż same imiona. Zatrzymujesz się i przepraszasz, mówiąc, że nie jesteś stąd. Mężczyzna kiwa głową i zabiera zwój.%SPEECH_ON%Nic nie szkodzi, najemniku. Jeśli się zastanawiasz, to były imiona mężczyzn, kobiet i dzieci, którzy zmarli w ostatnim tygodniu.%SPEECH_OFF%W ostatnim tygodniu? Na tej liście było dużo nazwisk. Mężczyzna, jakby czytał w tobie, kiwa głową ponuro.%SPEECH_ON%Tak, jest źle. Tak wiele żyć straconych. Wierzymy, że to sprawka plugawych stworzeń, bestii, których nie potrafimy pojąć. Oczywiście chcemy, byś je odnalazł i zniszczył. Czy interesuje cię takie zadanie, najemniku?%SPEECH_OFF% | %employer% ma u stóp kilka psów, wszystkie wyczerpane, z wysuniętymi jęzorami.%SPEECH_ON%Ostatnie dni spędziły na szukaniu zaginionych. Ludzi, którzy znikają nie wiadomo gdzie.%SPEECH_OFF%Pochyla się i głaszcze jednego z psów za uchem. Zwykle pies by na to zareagował, ale biedak ledwie odpowiada.%SPEECH_ON%Ludzie nie wiedzą jednak tego, co ja, a to znaczy, że ludzie nie po prostu znikają... są porywani. Straszne bestie krążą po okolicy, najemniku, i potrzebuję, byś się nimi zajął. Cholera, może nawet znajdziesz jednego czy dwóch mieszczan, choć wątpię.%SPEECH_OFF%Jeden z kundli wydaje długie, zmęczone sapnięcie, jakby na znak. | %employer% trzyma sakiewkę z przyczepionym zwojem, ale imię na papierze nie jest twoje. Waży ją ostrożnie, grudki monet opływają mu palce, a ich brzęk jest stłumiony. Odwraca się do ciebie.%SPEECH_ON%Rozpoznajesz to imię?%SPEECH_OFF%Kręcisz głową. Mężczyzna mówi dalej.%SPEECH_ON%Tydzień temu wysłaliśmy sławnego %randomnoble% %direction% stąd, by wytropił plugawie bestie, które od tygodni terroryzują miasto i okoliczne farmy. Wiesz, czemu ta sakiewka wciąż jest u mnie?%SPEECH_OFF%Wzruszasz ramionami i odpowiadasz.%SPEECH_ON%Bo nie wrócił?%SPEECH_OFF%%employer% kiwa głową i odkłada sakiewkę. Siada na krawędzi stołu.%SPEECH_ON%Dokładnie. Bo nie wrócił. A jak myślisz, dlaczego? Myślę, że nie żyje, ale bądźmy mniej ponurzy. Myślę, że te bestie wymagają więcej. Myślę, że potrzebują kogoś takiego jak ty, najemniku. Czy pomożesz nam teraz, gdy ten szlachcic zawiódł?%SPEECH_OFF% | %employer% zdejmuje księgę z półki. Gdy kładzie ją na stole, kurz, a może i popiół, unosi się w górę. Otwiera ją i powoli przewraca strony.%SPEECH_ON%Wierzysz w potwory, najemniku? Pytam szczerze, bo sądzę, że widziałeś świat lepiej niż ja.%SPEECH_OFF%Kiwasz głową i odpowiadasz.%SPEECH_ON%Nie tylko wierzę, tak.%SPEECH_OFF%Mężczyzna przewraca kolejną stronę i spogląda na ciebie.%SPEECH_ON%Cóż, wierzymy, że potwory przyszły do %townname%. Wierzymy, że to dlatego ludzie znikają. Rozumiesz, dokąd to zmierza? Potrzebuję, byś znalazł te 'zmyślone' stwory i zabił je jak każde inne. Jesteś zainteresowany?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Ile to jest dla ciebie warte? | Ile %townname% może nam zapłacić? | Porozmawiajmy o zapłacie.}",
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
			ID = "Humans",
			Title = "Przed atakiem...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{To wcale nie bestie, lecz ludzie przebrani za wilki! Widząc 'prawdziwą' twarz tego zła, ludzie odczuwają ulgę, że przeciwnik jest im aż nazbyt znany. | Gdy zbliżasz się do potworów, odkrywasz, że plugawce nie są bestiami, lecz ludźmi w przebraniach! Nie wiesz, czemu bawią się w takie przedstawienie, ale dobywają broni. Dla ciebie to bez znaczenia: bestia czy człowiek, wszyscy giną tak samo. | Natykasz się na mężczyznę zdejmującego z głowy wilczy łeb. Zerka na ciebie, wciąż trzymając maskę, po czym szybko ją zakłada. Dobywasz miecza.%SPEECH_ON%Trochę późno na zabawę w udawanie.%SPEECH_OFF%Cięcie strąca maskę, a mężczyzna cofa się. Zanim go dobijesz, rzuca się do ucieczki, pędząc do grupy podobnie czających się kompanów. Na twój widok dobywają broni. Niezależnie od powodu tej zabawy w przebieranki, to już nie ma znaczenia. | Natrafiasz na martwą bestię z kilkoma strzałami wbitymi w grzbiet. Rany nie wyglądają na śmiertelne... a gdy przesuwasz miecz po grzywie, głowa odpada, odsłaniając człowieka pod spodem.%SPEECH_ON%Tyś to zrobił?%SPEECH_OFF%Głos dobiega z przodu. Stoi tam kilku mężczyzn, zdejmujących przebrania bestii, których szukałeś. Ten na przedzie podnosi głos.%SPEECH_ON%Zabić ich! Zabić wszystkich!%SPEECH_OFF%Nie, to wciąż bestie, tylko bardziej miękkie.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Przygotować się do ataku!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WorkOfBeasts",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Natykasz się na zwłoki w trawie. Zwykle martwi nie są zaskoczeniem, ludzie są wszędzie, więc prędzej czy później trafiasz na ciało. Tyle że to ma ogromne rozdarcia na plecach i brak narządów.\n\n%helpfulbrother% podchodzi.%SPEECH_ON%Narządy zjadły wilki, a może i króliki. Co, nie słyszałeś o naprawdę głodnym króliku?%SPEECH_OFF%Spluwa i skubie paznokieć.%SPEECH_ON%Tak czy inaczej, te ślady to nie robota królika czy psa czy czego tam. To coś... większego... groźniejszego.%SPEECH_OFF%Dziękujesz mu za spostrzegawczość i każesz wrócić do szyku. | Podchodzi do ciebie chłop w podartych szmatach. Ze skromności zasłania dłonią krocze.%SPEECH_ON%Proszę, panowie, chodźcie zobaczyć to... okropieństwo.%SPEECH_OFF%Gdy pytasz, o co chodzi, rozkłada ręce i wypina biodra w twoją stronę. Obraca się jak kukła i ucieka z wrzaskiem. W ślad za jego szaleństwem podchodzi kobieta z rękami na piersi.%SPEECH_ON%Zwariował, bo jego brata rozszarpały bestie.%SPEECH_OFF%Odwracasz się do niej, pół żartem spodziewając się, że zedrze z siebie ubranie i zacznie wyginać się w dowolną stronę. Zamiast tego po prostu patrzy na ciebie.%SPEECH_ON%Wiem, że %townname% wynajęło ludzi do uporania się z tymi bestiami i wyglądasz jak ktoś od tego. Proszę, panie, chroń nas przed tym złem... i złem, które ze sobą niesie...%SPEECH_OFF% | Natrafiasz na wypatroszoną krowę, z połową zarzuconą na ogrodzenie, a drugą rozrzuconą po trawie tak daleko, jak pozwalały wnętrzności. Prawdziwa makabra.\n\nPodchodzi rolnik, unosząc kapelusz z oczu.%SPEECH_ON%To bestie to zrobiły. Nie widziałem ich, jeśli o to pytasz, ale słyszałem to całe capie piekło, zanim tu przybyłeś. Sam dźwięk wystarczył, bym się przyczaił i nie wychylał. Proszę, jeśli jesteście tu po te stwory, róbcie to szybko, bo nie mogę stracić więcej bydła.%SPEECH_OFF% | Chłop rąbiący drewno prostuje się na twój widok.%SPEECH_ON%Na bogów, dobrze was widzieć, panowie. Słyszałem, że jacyś najemnicy kręcą się po okolicy i szukają bestii terroryzujących te strony.%SPEECH_OFF%Pytasz, czy widział coś pomocnego. Opiera dłonie na trzonku topora.%SPEECH_ON%Nie powiem, żebym widział. Ale coś słyszałem. Wiem, że niedaleko stąd zginęli mężczyzna i kobieta. To znaczy zniknęli razem. Wieści niosą, że teraz wiszą w lesie. Przyczepieni do drzew, zwisają z brzucha, rozumiesz? Albo, czekaj, może po prostu uciekli razem, by się zejść! Ha... ha! Ta dziewczyna nienawidziła ojca, a chłopak był nikim, tylko ładną buzią i gadaną. Tak, to ma sens.%SPEECH_OFF%Przerywa i zerka na ciebie.%SPEECH_ON%Tak czy inaczej, jestem pewien, że te potwory krążą. Miej oczy otwarte, najemniku.%SPEECH_OFF% | Kobieta wybiega z chaty, by cię zatrzymać. Prawie bez tchu pyta, czy widziałeś chłopca. Kręcisz głową. Wyciąga rękę.%SPEECH_ON%Jest mniej więcej taki wysoki. Czupryna brązowych włosów. Nie z natury, ale dzieciak lubi błoto. Gdy się uśmiecha, zęby ma jak gwiazdy, jasne i rozrzucone.%SPEECH_OFF%Kręcisz głową po raz drugi.%SPEECH_ON%Rzuca kamieniem daleko. Mówiłam mu, żeby nie pokazywał siły, kiedy ludzie pana są w okolicy, żeby go nie zabrali do wojska.%SPEECH_OFF%Parska, zdmuchując kosmyk z oczu.%SPEECH_ON%No i cholera, jak go zobaczysz, daj mi znać. Chyba jest mój. I uważaj po zmroku. Bestie czają się na ludzi w tej okolicy.%SPEECH_OFF%Zanim zdążysz coś powiedzieć, kobieta podnosi długie ubranie i wraca do chaty. | Natrafiasz na mężczyznę klęczącego nad kompletnie zmasakrowanym psem. Przykucasz obok niego.%SPEECH_ON%Bestie to zrobiły?%SPEECH_OFF%Kręci głową.%SPEECH_ON%Nie, to ja. W końcu. Ten cholernik już mnie nie będzie wybudzał.%SPEECH_OFF%W tej chwili otwierają się drzwi chaty naprzeciwko i z niej wybiega mężczyzna, krzycząc.%SPEECH_ON%To mój cholerny pies, ty sukinsynu?%SPEECH_OFF%Psi zabójca szybko się podnosi.%SPEECH_ON%Bestie! Znowu przyszły w nocy!%SPEECH_OFF%Po cichu zostawiasz ich spór przy zwłokach psa.}",
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
			ID = "CollectingPelts",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_56.png[/img]{Bestie zabite, każesz ludziom zabrać ich skóry jako dowód. Twój pracodawca, %employer%, powinien być zadowolony, widząc je. | Po zabiciu plugawych stworzeń zaczynasz je skórować i obdzierać. Okrutne bestie wymagają okrutnych dowodów. Twój pracodawca, %employer%, mógłby nie uwierzyć w twoją robotę bez tego. | Gdy bitwa się kończy, każesz ludziom zbierać skóry, by zabrać je do %employer%, twojego pracodawcy. | Twój pracodawca, %employer%, może nie uwierzyć w to, co się tu wydarzyło bez dowodów. Każesz ludziom zbierać skóry, trofea, skalpy, cokolwiek, co pokaże twoje zwycięstwo.}",
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
			ID = "CollectingProof",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Twoi ludzie zabierają przebrania tych głupców, by %employer% uwierzył w to, co tu zaszło. | Twój pracodawca może nie uwierzyć w to, co tu się działo. Każesz ludziom zebrać przebrania. %bro1%, zdejmując maskę z jednego z zabitych, zaczyna się zastanawiać.%SPEECH_ON%Czyli przebrali się za coś, co miało nas zwabić, a teraz wszyscy nie żyją. Mam nadzieję, że nie uznali tego za zabawę.%SPEECH_OFF%%bro2% czyści ostrze w fałdach jednego z kostiumów.%SPEECH_ON%Cóż, jeśli to była gra, to bardzo mi się podobała.%SPEECH_OFF% | %randombrother% kiwa głową na zabitych.%SPEECH_ON%Najpewniej %employer% nie uwierzyłby, że banda zbójów przebrała się za bestie.%SPEECH_OFF%Zgadzając się, każesz ludziom zacząć zbierać maski i przebrania jako dowód. | Potrzebujesz dowodów, by pokazać je %employer%. To nie były bestie, których szukałeś, ale mają mnóstwo przebrań, które pracodawca chętnie zobaczy. Jeden z ludzi zastanawia się głośno.%SPEECH_ON%Po co w ogóle bawili się w przebieranki?%SPEECH_OFF%%bro2% zarzuca część kostiumów na ramię, zbierając je.%SPEECH_ON%Samobójstwo przez ceremonię? Ich taniec i zabawa przyciągnęły naszą uwagę.%SPEECH_OFF%Podnosi jedno z przebrań, a głowa martwego zostaje wraz z nim. Najemnik śmieje się, kopiąc głowę na bok.}",
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
			ID = "CollectingGhouls",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_131.png[/img]{Po walce podchodzisz do martwego nachzehrera i przyklękasz. Gdyby nie brama pokracznych zębów, mógłbyś z łatwością włożyć głowę do jego przerośniętej paszczy. Zamiast podziwiać tę dentystyczną porażkę, wyciągasz nóż i odcinasz mu głowę, przebijając się przez twardą skórę, po czym zaskakująco łatwo przecinasz mięśnie i ścięgna. Unosisz głowę i każesz %companyname% zrobić to samo. %employer% będzie oczekiwał dowodu. | Martwe ciało nachzehrera wygląda bardziej jak skała niż bestia, leży płasko i nieruchomo. Muchy już kopulują w jego paszczy, siejąc życie na spienionych resztkach śmierci. Każesz %randombrother% odciąć głowę, bo %employer% będzie oczekiwał dowodu. | Martwe nachzehrery leżą porozrzucane. Klękasz przy jednym i zaglądasz do pyska. Cokolwiek było w jego płucach, wciąż się wydobywa, bulgocząc w charczeniu. Przykładasz tkaninę do nosa i drugą ręką odcinasz głowę, po czym unosisz ją w górę. Każesz kilku braciom zrobić to samo, bo %employer% będzie oczekiwał dowodu. | Martwy nachzehrer to interesujący okaz. Nie sposób nie zastanawiać się, gdzie plasuje się w naturalnym porządku. Ma kształt prymitywnego człowieka, muskulaturę jak u bestii, a głowę zniekształconą cechami zrodzonymi z koszmarów dzikusa. Każesz %companyname% zbierać głowy tych plugawych stworzeń, bo %employer% na pewno będzie chciał dowodu.}",
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
			ID = "CollectingSpiders",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_123.png[/img]{Każesz ludziom przeszukać pole i zebrać jak najwięcej części pająków. Kilku popełnia błąd, dotykając włosków na nogach webknechtów, przez co szybko pojawia się swędząca wysypka. | Pająki zaśmiecają pole jak pajęczyny w kącie strychu. W śmierci wyglądają jak olbrzymie rękawice zaciśnięte w sztywnym uścisku. Każesz ludziom wyłamywać nogi, by zebrać dowody bestialskich szczątków. | Najemnicy przeszukują pole, rąbiąc i piłując sztywne szczątki pająków, by zabrać je do %employer%. Nawet martwe webknechty są odrażające, wyglądają jakby miały zaraz ożyć i owinąć się wokół najbliższego żywego stworzenia. Ich potworne cechy i nierealny rozmiar nie powstrzymują części najemników przed podskokami, kląskaniem i syczeniem, co tylko podsyca fobie tych, którzy najmniej chcą zbliżać się do tych przeklętych rzeczy.}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{Wracasz do %employer% i kładziesz jedną ze skór w poprzek jego biurka. Wiotkie pazury uderzają o bok dębowego blatu. Mężczyzna unosi jeden z nich, po czym znów go puszcza.%SPEECH_ON%Widzę, że znalazłeś bestie, których szukaliśmy.%SPEECH_OFF%Opowiadasz mu o bitwie. Wygląda na bardzo zadowolonego, wyjmuje z półki małą drewnianą skrzynkę i podaje ci ją.%SPEECH_ON%%reward_completion% koron, jak ustalono. Ludzie z %townname% zasługują na wytchnienie od tych okropności.%SPEECH_OFF% | Gdy wchodzisz do komnaty %employer%, odruchowo się cofa.%SPEECH_ON%Co u diabłów bogów trzymasz w ręku, najemniku?%SPEECH_OFF%Unosisz kark skóry. Z szyi ciągną się czarne strugi krwi i chlapną na podłogę.%SPEECH_ON%Jedna z bestii, których szukaliście. Jeśli potrzebujesz dowodów na resztę, mam je na zewnątrz...%SPEECH_OFF%Mężczyzna unosi dłoń, powstrzymując cię.%SPEECH_ON%Jedna wystarczy, bym uwierzył. Dobra robota, najemniku. Twoja zapłata będzie u %randomname%, radnego, którego pewnie mijałeś na korytarzu. Ma paskudną gębę i niesie %reward_completion% koron, jak obiecano.%SPEECH_OFF%Mężczyzna raz jeszcze spogląda na bestię i powoli kręci głową.%SPEECH_ON%Niech zmarli i ich bliscy zaznają spokoju po odejściu tych plugawych stworzeń.%SPEECH_OFF% | %employer% wita twój powrót kielichem wina.%SPEECH_ON%Wypij, pogromco bestii.%SPEECH_OFF%Zastanawiasz się, skąd już wie o twoim sukcesie. Odpędza twoją ciekawość.%SPEECH_ON%Mam wiele oczu i uszu w tej krainie - oczywiście nie szpiegów, lecz pospólstwo ma wielką gębę. Powinienem wiedzieć, sam jestem jednym z nich! Dobrze się spisałeś, najemniku, więc napij się. To bardzo dobre wino.%SPEECH_OFF%Jest w porządku. Nagroda w wysokości %reward_completion% koron, z którą wychodzisz, jest jednak znacznie lepsza. %employer% zatrzymuje cię.%SPEECH_ON%Żebyś wiedział, najemniku, te bestie zabiły tam dobrych ludzi. Ci ludzie mogą się ciebie bać, bo jesteś najemnikiem, ale mimo wszystko są wiecznie wdzięczni.%SPEECH_OFF%Ważysz korony. Rzeczywiście wdzięczni... | %employer% cofa się o kilka kroków.%SPEECH_ON%Ach, eee, widzę, że zabiłeś bestie. To całkiem zacna skóra.%SPEECH_OFF%Rzucasz to, co przyniosłeś: gruba, ciężka grzywa zwierzęcego pochodzenia opada w stertę futra i mięsa. Mężczyzna, niemal zbyt przestraszony, by podejść, rzuca ci sakiewkę.%SPEECH_ON%%reward_completion% koron, jak ustalono. Pójdę do ludzi i opowiem o twoim sukcesie. Wreszcie możemy żyć w spokoju.%SPEECH_OFF% | %employer% siedzi przy stole, nogi ma oparte o róg. Wzrok wbija w sufit, kąciki twarzy ściągnięte w pomarszczone fałdy. Spogląda na ciebie.%SPEECH_ON%Witaj z powrotem. Docierały do mnie wieści o twoich czynach... o twoich bitwach z potworami.%SPEECH_OFF%Kiwasz głową, rozglądając się za nagrodą. Mężczyzna wskazuje ci drzwi.%SPEECH_ON%%randomname%, inny radny z %townname%, ma twoją zapłatę na zewnątrz. %reward_completion% koron, jak ustalono. A mieszkańcy %townname%, choć mogą się ciebie bać, są mimo wszystko pobłogosławieni twoim przybyciem. Dziękuję, najemniku.%SPEECH_OFF% | %employer% karmi jednego ze swoich psów, gdy wracasz. Kundel upuszcza kość, by obwąchać to, co przyniosłeś. Mężczyzna wskazuje na skórę.%SPEECH_ON%Co to za plugastwo?%SPEECH_OFF%Wzruszasz ramionami i rzucasz to na jego stół. Pies dotyka nosem jednego z pazurów, warczy, po czym zaczyna go lizać. %employer% uśmiecha się krótko, po czym podchodzi do półki, podnosi drewnianą skrzynkę i podaje ci ją.%SPEECH_ON%%reward_completion% koron, tak było? Powinieneś wiedzieć, że przyniosłeś spokój ludziom z %townname%.%SPEECH_OFF%Kiwasz głową.%SPEECH_ON%Czy ich szczęście też jest w koronach?%SPEECH_OFF%%employer% marszczy brwi na twój chciwy dowcip.%SPEECH_ON%Nie, nie jest. Miłego dnia, najemniku.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Uwolniłeś miasto od wilkorów");
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
		this.m.Screens.push({
			ID = "Success2",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% wita twój powrót.%SPEECH_ON%Słyszałem już, powiedzmy, wspaniałe wieści. Mogę w to uwierzyć. Banda zbirów bawiących się w przebieranki. Wilki w... wilczym odzieniu?%SPEECH_OFF%Szczerzy się do ciebie, licząc na śmiech z tej marnej gry słów. Wzruszasz ramionami. On też.%SPEECH_ON%A więc. Twoja zapłata, %reward_completion% koron, czeka na zewnątrz. Powiem ludziom z %townname%, że potwory, których się bali, to tylko ludzie.%SPEECH_OFF% | Wracasz z kostiumami tych głupich zbirów. %employer% przechyla przebrania z lewej na prawą.%SPEECH_ON%Interesujące. Są bardzo dobrze wykonane. Prawie powiedziałbym, że ci zbóje byli sprytni.%SPEECH_OFF%Podnosi jedną z masek i wygląda, jakby miał ją założyć, po czym zatrzymuje się, jakby nie wypadało robić tego przy świadkach. Odkłada ją i uśmiecha się do ciebie.%SPEECH_ON%No cóż, najemniku... dobra robota. %reward_completion% koron będzie na ciebie czekać na zewnątrz u jednego z radnych %townname%. Będzie wypatrywał. Teraz ludzie z %townname% mogą pochować naszych zmarłych i wreszcie zaznać spokoju.%SPEECH_OFF% | %employer% wybucha śmiechem na widok twojego ujawnienia.%SPEECH_ON%Ludzie? To byli tylko ludzie?%SPEECH_OFF%Kiwasz głową, ale próbujesz sprowadzić go na właściwe tory.%SPEECH_ON%Zabili wielu chłopów i wciąż byli groźni.%SPEECH_OFF%%employer% kiwa głową.%SPEECH_ON%Oczywiście, oczywiście! Nie chciałem niczego umniejszać ani nikogo lekceważyć. Nie śmiej mi tego przypisywać, najemniku, to moi przyjaciele i sąsiedzi giną tam na zewnątrz! Tak czy inaczej, zrobiłeś to, o co prosiłem, i jestem za to bardzo wdzięczny.%SPEECH_OFF%Podaje ci sakiewkę koron. Liczysz w środku %reward_completion%, po czym ruszasz do wyjścia. Mężczyzna woła za tobą.%SPEECH_ON%Na pewno rozumiesz, że w tym okropnym świecie trzeba czasem szukać humoru, prawda? To ja chodziłem na pogrzeby wszystkich tych zabitych. Nie zejdę do grobu z marsową miną, bez względu na to, jak bardzo to przeklęte miejsce próbuje mi ją narzucić.%SPEECH_OFF% | Pokazujesz %employer% dowody na psotnych zbirów. Przebiera w kłębach przebrań, ścierając zaschniętą krew z palców.%SPEECH_ON%To faktycznie krew ludzi. Jesteś pewien, że nie bawili się tylko w udawanie, a prawdziwe potwory wciąż krążą gdzieś tam?%SPEECH_OFF%Zaciskasz usta i wyjaśniasz, że atakowali cię jak najbardziej nieudawaną bronią. %employer% kiwa głową, jakby rozumiał, choć wciąż podejrzliwy.%SPEECH_ON%Cóż, mogę po prostu poczekać i zobaczyć, czy potwory wrócą. Jeśli wrócą, cóż, zdradzony człowiek sam potrafi stać się potworem, nie uważasz?%SPEECH_OFF%Mówisz mu tylko, żeby ci zapłacił i poczekał, jeśli tak bardzo nie ufa. Kiwając głową, wręcza ci %reward_completion% koron i żegna cię.%SPEECH_ON%Naprawdę mam nadzieję, że mówisz prawdę, najemniku. %townname% przyda się wytchnienie od okropności, które bez przerwy wymierza ten przeklęty świat.%SPEECH_OFF% | %employer% przesuwa palcem po krawędzi przebrania.%SPEECH_ON%Futro jest miękkie w dotyku. Bardzo prawdziwe...%SPEECH_OFF%Spogląda na ciebie.%SPEECH_ON%Zastanawiam się, czy zabili prawdziwe potwory, a potem... postanowili nosić ich skóry? Dlaczego? Myślisz, że byli przeklęci?%SPEECH_OFF%Wzruszasz ramionami i odpowiadasz.%SPEECH_ON%Mogę powiedzieć tylko, że przyjęli postać potworów i mieli ich okrucieństwo. Zaatakowali nas i zapłacili za to. Czy któryś z waszych ludzi widział ostatnio jakieś stwory?%SPEECH_OFF%Mężczyzna wyciąga sakiewkę %reward_completion% koron i przesuwa ją w twoją stronę.%SPEECH_ON%Nie, nie widzieli. Właściwie ludzie znów zaczynają wychodzić. Nie mówię o drogach, ale samo opuszczenie bezpiecznych progów to dla wielu wielki krok! Zdecydowanie przyniosłeś nam spokój, najemniku, i za to dziękujemy.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Bestie, ludzie... tylko korony się liczą.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Uwolniłeś miasto od bandytów przebranych za wilkory");
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
		this.m.Screens.push({
			ID = "Success3",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Zastajesz %employer% odpoczywającego. Wstaje i podciąga spodnie, a służący szybko zabiera wiadro spod miejsca, na którym siedział. Biedak prędko ucieka z komnaty. %employer% wskazuje na głowę nachzehrera zwisającą z twojej dłoni.%SPEECH_ON%To obrzydliwe. %randomname%, daj temu człowiekowi zapłatę. %reward% koron, tak było?%SPEECH_OFF% | Kładziesz głowę nachzehrera na biurku %employer%. Z jakiegoś powodu z szyi wciąż sączą się płyny, spływając po boku dębu i bez wątpienia go plamiąc. Mężczyzna odchyla się, łącząc palce na brzuchu.%SPEECH_ON%Nachzehrery? A co dalej, duchy?%SPEECH_OFF%Mężczyzna parska.%SPEECH_ON%Dla ciebie nic nie jest zbyt trudne, najemniku.%SPEECH_OFF%Pstryka palcami i sługa podchodzi, wręczając ci sakiewkę %reward% koron. | Między bitwą a marszem do siedziby %employer% paszcza nachzehrera wypełniła się muchami, a język zastąpiła bezkształtna, pulsująca czarna kula, bardziej brzęcząca niż gryząca. %employer% rzuca na to okiem i przykłada chustę do ust.%SPEECH_ON%Tak, rozumiem, zabierz to, proszę.%SPEECH_OFF%Przywołuje jednego ze strażników i dostajesz sakiewkę %reward% koron. | Stalowooki %employer% pochyla się, by dobrze przyjrzeć się głowie nachzehrera, którą przyniosłeś.%SPEECH_ON%To doprawdy widok, najemniku. Cieszę się, że mi ją przyniosłeś.%SPEECH_OFF%Odchyla się.%SPEECH_ON%Zostaw ją na biurku. Może postraszę nią dzieci. Te małe urwisy chyba zbyt przywykły do zbytku.%SPEECH_OFF%Pstryka palcami i służący wręcza ci %reward% koron. | Przynosisz głowę nachzehrera do %employer%, który długo się jej przygląda.%SPEECH_ON%Przypomina mi kogoś. Nie mogę sobie przypomnieć kogo i nie jestem pewien, czy powinienem. Wybacz, najemniku, zabieram twój czas, nie płacąc za niego. Sługa, daj temu człowiekowi jego pieniądze!%SPEECH_OFF%Zostajesz nagrodzony, jak obiecano. | %employer% bierze głowę nachzehrera i unosi ją. Nagle, jak spod ziemi, pojawia się kilka miauczących kotów, krążąc pod nią jak sępy. Mężczyzna wyrzuca głowę przez okno, a koty pędzą za nią.%SPEECH_ON%Dobra robota, najemniku. %reward% koron, jak obiecano.%SPEECH_OFF% | Kładziesz głowę nachzehrera na stole %employer%. Ten podnosi wzrok znad talerza, spogląda na głowę, potem na ciebie.%SPEECH_ON%Jadłem, najemniku.%SPEECH_OFF%Sztućce brzęczą, gdy zdegustowany mężczyzna odsuwa talerz. Sługa zabiera jedzenie, zapewne po to, by spróbować go samemu. %employer% wyciąga sakiewkę i kładzie ją na stole.%SPEECH_ON%%reward_completion% koron, jak obiecano.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Uwolniłeś miasto od nachzehrerów");
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
		this.m.Screens.push({
			ID = "Success4",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Wchodzisz do gabinetu %employer%, niosąc martwego pająka na plecach. Mężczyzna krzyczy, a krzesło piszczy, gdy odsuwa się po podłodze. Zrywa się i wyciąga z biurka nożyk do masła. Zrzucasz martwego webknechta z ramienia i ten łomocze na grzbiecie. Mieszczanin powoli podchodzi. Wtyka nożyk w bochenek chleba i kręci głową.%SPEECH_ON%Na starych bogów, o mało co nie dostałem zawału.%SPEECH_OFF%Kiwasz głową i mówisz, że to wymagało czegoś więcej niż wielkiego buta. On też kiwa.%SPEECH_ON%Oczywiście, najemniku, oczywiście! Twoja zapłata w wysokości %reward_completion% koron leży tam w rogu. I, proszę, zabierz to nieświęte paskudztwo, gdy będziesz wychodził.%SPEECH_OFF% | Koty syczą i uciekają, gdy tylko wchodzisz do komnaty %employer%. Kilka psów, zawsze ciekawskich, kręci się przy twoich nogach i obwąchuje pajęczy padlinę, marszcząc nosy i odsuwając się, lecz wciąż wracając po więcej. Mieszczanin notuje i ledwo wierzy własnym oczom. Odkłada pióro.%SPEECH_ON%Czy to olbrzymi pająk?%SPEECH_OFF%Kiwasz głową. Uśmiecha się i znów chwyta pióro.%SPEECH_ON%Może powinienem był zasugerować, byś przyniósł bardzo duży but. Twoja zapłata w wysokości %reward_completion% koron jest w sakiewce. Proszę, weź ją. Wszystko tam jest. A ciało możesz zostawić. Chciałbym przyjrzeć się stworzeniu z bliska.%SPEECH_OFF% | %employer% urządza przyjęcie urodzinowe, gdy wchodzisz do jego komnaty z olbrzymim martwym pająkiem i rzucasz zwłoki przez podłogę. Szorstkie włosy syczą, gdy drapią kamień, a osiem nóg przebiera do góry nogami jak jakieś meble z koszmaru, ociera się o róg regału i przewraca na nogi, zastygając jakby gotowe do skoku. Wybucha chaos, wszyscy krzyczą i uciekają do drzwi albo wyskakują przez najbliższe okno, a w ich śladzie wirują kolorowe konfetti. Mieszczanin stoi sam pośród opustoszałej sali i zaciska usta.%SPEECH_ON%Naprawdę, najemniku, czy to było konieczne?%SPEECH_OFF%Kiwasz głową i mówisz, że zatrudnienie ciebie było konieczne i że zapłata wciąż jest bardzo konieczna. Mężczyzna kręci głową i wskazuje w rogu pomieszczenia sztucznym oślim ogonem.%SPEECH_ON%Twoja sakiewka jest tam, z %reward_completion% koronami, jak ustalono. A teraz wynoś to paskudztwo i powiedz tym zacnym ludziom, że zabawa nie musi się kończyć.%SPEECH_OFF% | Nie sądzisz, by dało się wcisnąć pajęczy trup do komnaty %employer%, więc przyklejasz go do jego okna z zewnątrz. Słyszysz przerażony krzyk i łomot przewracanych mebli. Chwilę później otwiera się sąsiednie okno. Mieszczanin wychyla się.%SPEECH_ON%Och, bardzo śmieszne, najemniku, bardzo śmieszne! Niech starzy bogowie dadzą ci tysiąc lat bezczynności za ten dowcip!%SPEECH_OFF%Kiwasz głową i pytasz o zapłatę. Niechętnie rzuca ci sakiewkę.%SPEECH_ON%%reward_completion% koron jest w środku. A teraz zabierz to paskudztwo i wynoś się!%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Uwolniłeś miasto od webknechtów");
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
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/disappearing_villagers_situation"));
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

