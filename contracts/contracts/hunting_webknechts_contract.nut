this.hunting_webknechts_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_webknechts";
		this.m.Name = "Polowanie na Webknechty";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 450 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Zapoluj na Webknechty w lasach wokół " + this.Contract.m.Home.getName()
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

				if (r <= 10)
				{
					if (this.Contract.getDifficultyMult() >= 0.9)
					{
						this.Flags.set("IsOldArmor", true);
					}
				}
				else if (r <= 20)
				{
					this.Flags.set("IsSurvivor", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = i )
				{
					if (i == this.Const.World.TerrainType.Forest || i == this.Const.World.TerrainType.LeaveForest || i == this.Const.World.TerrainType.AutumnForest)
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
				local x = this.Math.max(3, playerTile.SquareCoords.X - 9);
				local x_max = this.Math.min(mapSize.X - 3, playerTile.SquareCoords.X + 9);
				local y = this.Math.max(3, playerTile.SquareCoords.Y - 9);
				local y_max = this.Math.min(mapSize.Y - 3, playerTile.SquareCoords.Y + 9);
				local numWoods = 0;

				while (x <= x_max)
				{
					while (y <= y_max)
					{
						local tile = this.World.getTileSquare(x, y);

						if (tile.Type == this.Const.World.TerrainType.Forest || tile.Type == this.Const.World.TerrainType.LeaveForest || tile.Type == this.Const.World.TerrainType.AutumnForest)
						{
							numWoods = ++numWoods;
							numWoods = numWoods;
						}

						y = ++y;
						y = y;
					}

					x = ++x;
					x = x;
				}

				local tile = this.Contract.getTileToSpawnLocation(playerTile, numWoods >= 12 ? 6 : 3, 9, disallowedTerrain);
				local party;
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Webknechty", false, this.Const.World.Spawn.Spiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.setDescription("Rój webknechtów biegający po okolicy.");
				party.setFootprintType(this.Const.World.FootprintsType.Spiders);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);

				for( local i = 0; i < 2; i = i )
				{
					local nearTile = this.Contract.getTileToSpawnLocation(playerTile, 4, 5);

					if (nearTile != null)
					{
						this.Const.World.Common.addFootprintsFromTo(nearTile, party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Spiders, 0.75);
					}

					i = ++i;
				}

				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setNoTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Forest, true);
				roam.setTerrain(this.Const.World.TerrainType.LeaveForest, true);
				roam.setTerrain(this.Const.World.TerrainType.AutumnForest, true);
				roam.setMinRange(1);
				roam.setMaxRange(1);
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
					if (this.Flags.get("IsOldArmor") && this.World.Assets.getStash().hasEmptySlot())
					{
						this.Contract.setScreen("OldArmor");
					}
					else if (this.Flags.get("IsSurvivor") && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
					{
						this.Contract.setScreen("Survivor");
					}
					else
					{
						this.Contract.setScreen("Victory");
					}

					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsBanterShown") && this.Contract.m.Target.isHiddenToPlayer() && this.Math.rand(1, 1000) <= 1 && this.Flags.get("StartTime") + 10.0 <= this.Time.getVirtualTimeF())
				{
					local tileType = this.World.State.getPlayer().getTile().Type;

					if (tileType == this.Const.World.TerrainType.Forest || tileType == this.Const.World.TerrainType.LeaveForest || tileType == this.Const.World.TerrainType.AutumnForest)
					{
						this.Flags.set("IsBanterShown", true);
						this.Contract.setScreen("Banter");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (!this.Flags.get("IsEncounterShown"))
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
			Text = "[img]gfx/ui/events/event_43.png[/img]{%employer% macha, byś wszedł do jego pokoju. Zauważasz, że uzbrojeni w widły ludzie trzymają wartę, ponuro wpatrując się przez okna, choć jeden z nich wyraźnie przysnął oparty o ścianę. Pytasz burmistrza osady, czego chce. Przechodzi do rzeczy.%SPEECH_ON%Mieszkańcy z okolic zgłaszają potwory porywające dzieci, psy i podobne. Nie chcę ulegać paranoi i przesądom, ale wygląda na to, że mówią o pająkach. Webknechty, jak mawiał mój ojciec, i jeśli to prawda, pewnie mają tu gniazdo, które trzeba znaleźć i zniszczyć. Zainteresowany, najemniku?%SPEECH_OFF% | Zastajesz %employer% rozciągającego pajęczynę między dwoma widłami. Obraca jedno z narzędzi, owijając pajęczynę wokół sznurka. Wzdycha i w końcu spogląda na ciebie.%SPEECH_ON%Niechętnie sprowadzam tu najemników, ale jestem u kresu sił. Po okolicy krążą ogromne pająki, kradną bydło i zwierzęta. Jedna kobieta doniosła, że jej niemowlę zniknęło z kołyski, a na jego miejscu została jama pajęczyn. Muszę pozbyć się tych paskudnych stworzeń, zniszczyć ich gniazdo. Jeśli odpowiednio zapłacę, jesteś zainteresowany?%SPEECH_OFF% | Podchodzisz do %employer%, a sam twój cień go płoszy. Zrywa się prosto przy biurku i kiwa głową.%SPEECH_ON%Ech, mam dreszcze. Nie chodzi o to, że tu jesteś, najemniku, choć wyglądasz groźnie, ale po okolicy krążą wieści o wielkich pająkach. Mam powód, by w to wierzyć, bo byłem w gospodarstwie i widziałem wielkie pajęczyny oraz pożarte bydło. Potrzebuję człowieka zdolnego do bezwzględnej przemocy, rozmawiam z tobą, i potrzebuję, by taki człowiek znalazł gniazdo potworów i położył im kres. Jesteś zainteresowany?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Ile koron możesz zebrać? | Porozmawiajmy o zapłacie. | Porozmawiajmy o koronach.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{To nie brzmi jak robota dla nas.}",
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
			Text = "[img]gfx/ui/events/event_25.png[/img]{Natykasz się na martwą krowę, z której mięso wyssano aż do kości, a jednak skóra nie nosi śladów wysuszenia na słońcu. %randombrother% kuca i przesuwa palcem po licznych nakłuciach. Kiwając głową, mówi.%SPEECH_ON%Robota webknechtów, bez dwóch zdań. Zatruli ją, a potem żerowali na sparaliżowanym ciele. A świeży trup znaczy, że są blisko...%SPEECH_OFF% | Znajdujesz opleciony pajęczyną trup oparty o samotne drzewo. Rozcinasz nici. Wypada ciało dziecka i osuwa się na ziemię. Twarz jest przyklejona do kości, blady czaszkowaty łeb z gałkami ocznymi wyglądającymi z głębokich oczodołów. Język równie wciągnięty, nosa prawie brak. %randombrother% spluwa i kiwa głową.%SPEECH_ON%Dobra. Jesteśmy blisko. A raczej oni są blisko. Jeśli to was pocieszy, chłopak zmarł zanim stał się tym, co widzicie. Webknechty wstrzykują jad przy ukłuciu i żadne dziecko długo by tego nie przeżyło.%SPEECH_OFF%Dobrze. Czas, by ludzie znaleźli te potwory. | Znajdujesz chłopaka schowanego pod przewróconą taczką. Nie chce wyjść, jego mała głowa wygląda z kryjówki jak perła z muszli. Pytasz, co robi. Nerwowo tłumaczy, że chowa się przed pająkami i że masz stąd iść.%SPEECH_ON%Znajdź sobie własną taczkę. Ta jest moja.%SPEECH_OFF% Wymachując mieczem, mówisz mu, że to pająków szukasz. Chłopak patrzy na ciebie. Kiwając głową, mówi.%SPEECH_ON%To cholernie głupi pomysł, panie. I nie, nie mam pojęcia, gdzie poszły. Byłem tu z karawaną, widzisz tu karawanę? No właśnie nie, bo to teraz sałatka dla pająków, więc spadaj, zanim zobaczą, że ze mną gadasz!%SPEECH_OFF%Taczka z łoskotem się zamyka. Nie masz zamiaru jej podnosić, ale na odchodnym dajesz jej solidnego kopniaka.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Miejcie oczy otwarte.",
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
			Text = "[img]gfx/ui/events/event_110.png[/img]{Gniazdo webknechtów to jama ziemi opleciona bielą. Na jej krawędzi wiszą cienkie nici, kołyszące się przy najlżejszym powiewie. Gdy prowadzisz kompanię do środka, pajęczyna przybiera jakby cywilizowany kształt, jakbyś wchodził z zimowych ostępów; świeżość jej powstania widać po ciasnych wieżach: jelenie, psy, ludzkiej wielkości kokony bez śladów życia, wszystko ściśle uwiązane w hangarach białych silosów i skrzydelnic, niczym kęsy zgubione na bladym dywanie. Zza zasnutej siedziby wyłania się czarny cień, podchodząc z przodu, z nogami skulonymi niczym na zasłonie, a głową schowaną za nimi, jakby paskudny stwór był uwięziony własnym krokiem. Z jego szczęk wysuwa się i wsuwa ludzka dłoń niczym makabryczny smoczek. Trafiłeś we właściwe miejsce. | Gniazdo webknechtów jest ciche, a szczęk przybycia kompanii brzmi niemal bluźnierczo, zgrzyt metalu wyraźnie ostry w tym przekroczeniu.\n\n Zauważasz mężczyznę wiszącego głową w dół na drzewie, całe ciało w kokonie poza twarzą, którą nici naciągają i deformują. Prosi, byś uwolnił mu powieki z pajęczyn, co robisz. Jego powieki powoli się zamykają, zaschnięta skorupa suchych oczu trzaska po raz pierwszy od być może dni. Lecz zaraz się otwierają, a mężczyzna krzyczy. Kokon przy jego pasie pęcznieje i rozrywa się, a z niego wylewa się strumień drobnych czarnych pająków. Ciało mężczyzny szarpie się gwałtownie, gdy rój go pożera, jego zduszone krzyki pełne są chrobotu pajęczatek, które wypełniają mu płuca i które wykrztusza w konwulsjach śmierci. Przerażony cofasz się, tylko po to, by zobaczyć tłum znacznie większych pająków wylaniających się zza drzew! | Gniazdo łatwo dostrzec: fragment zimowego pejzażu bez zimna, biała pajęczyna porozwieszana i zwisająca z każdego drzewa, z każdej kępy, z każdego skrawka miejsca. Wprowadzasz kompanię prosto do środka, z dobytymi broniami, i natykasz się na oplecione ciała, rozerwane na środku i sczerniałe, a z nich wysyp legu pajęczatek ssie wnętrzności.\n\n Spoglądając w górę, widzisz czerwone oczy rozbłyskujące między gałęziami okolicznych drzew; całe pajęcze arboretum ożywa, jego strażnicy siedzą wśród zarośli z nogami tak skulonymi, że nie sposób ich odróżnić od gałęzi, wróg skryty na widoku. O mało co nie narobiłeś w portki, gdy rzekome drzewo całkowicie się rozkłada, każdy drewniany pęd okazuje się pajęczą nogą, a ten nadrzewny trik spada na kompanię, cykając i szczekając po kąsek!}",
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
			ID = "Victory",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_123.png[/img]{Z ostatnim z webknechtów uporano się, jego nogi zginają się, jakby na wieczność chciały chwycić broń, która go zabiła. Kiwasz głową na znak dobrej roboty, po czym każesz spalić całe miejsce. Ogień szybko przebiega po pajęczynach, zrywając mosty z nici i niosąc płomienną zgubę do ich połączeń. Całe gniazdo staje w ogniu, a gdzieś głęboko w jego pościelisku słychać przenikliwy pisk płonących pajęczatek. | Podchodzisz do ostatniego z webknechtów i wpatrujesz się w jego ohydną paszczę. Ma złośliwy zestaw żuwaczek niczym ochraniacz dziąseł, a sama paszcza to szczelina wysadzona ostrymi jak brzytwa zębami skierowanymi do środka, by rozszarpywać wszystko, co próbowałoby uciekać.\n\n Każesz spalić całe gniazdo. Gdy płomienie rosną, gdzieś w legowiskach słychać pisk pajęczatek. | Szykujesz powrót do %employer%, lecz najpierw każesz całkowicie spalić gniazdo. Kompania stoi przed płomieniami, słuchając przenikliwych pisków pajęczatek i chwilami śmiejąc się z małych stworzeń biegających jak maleńkie ogniste kulki na nogach. | Po pokonaniu pająków każesz spalić to przeklęte miejsce i szykujesz powrót do %employer%. Gdy ogień bucha w górę, małe pajaczki wybiegają z płonącymi ciałami niczym świetliki w nocy. Kilku najemników urządza improwizowaną zabawę w to, kto rozgniecie najwięcej, co kończy się tym, że szczególnie ambitne pajęczątko o mało nie podpala spodni jednemu z najemników.}",
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
			ID = "OldArmor",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_123.png[/img]{Po rozprawieniu się z webknechtami każesz kompanii krótko przeszukać ich gniazdo, choć najemnicy mają rozkaz nigdy nie chodzić samotnie. Sam też brniesz w pajęczyny, %randombrother% u twojego boku. Razem dostrzegacie drzewo, które jest zadziwiająco nietknięte przez sieci. Okrążając je, znajdujesz ciało rycerza oparte o pień. Jego dłoń spoczywa na głowicy złamanego miecza, a druga ręka całkiem zniknęła, tylko rękaw na nadgarstku i okaleczony kikut ułożony na brzuchu. Zwłoki spoczywają w gnieździe własnej roboty, w gąszczu czegoś, co wygląda jak zepsute łodygi rabarbaru i zgniłe pancerze, połamane ciała wydrążone i cuchnące jadem. %randombrother% kiwa głową.%SPEECH_ON%To wielka szkoda. Założę się, że byłby solidnym wzmocnieniem dla %companyname%, kimkolwiek był.%SPEECH_OFF%To prawda, wygląda na godny koniec wielkiego wojownika. Masz ochotę go pochować, ale nie masz czasu. Mówisz %randombrother%, by zabrał z ciała co się da i szykował powrót do %employer%.}",
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
			],
			function start()
			{
				local item;
				local r = this.Math.rand(1, 2);

				if (r == 1)
				{
					item = this.new("scripts/items/armor/decayed_reinforced_mail_hauberk");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/armor/decayed_coat_of_scales");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Survivor",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_123.png[/img]{Po bitwie znajdujesz mężczyznę wiszącego na pajęczynie przyczepionej do stóp. Połowa ciała jest związana nićmi, a kolejne zwisają z biodra jak strzępiona suknia. Wygląda na to, że pająki porzuciły go, gdy przybyła %companyname%. Na twój widok się uśmiecha.%SPEECH_ON%No witaj. Najemnicy, co? Tak, widzę. Nie przyszlibyście tu, gdyby nie moneta, a biliście się jak skurczybyki, na których ktoś postawił. Absolutne dzikusy.%SPEECH_OFF%Pytasz mężczyznę, co zyskasz, jeśli go uwolnisz. Zadziera głowę, a całe ciało zaczyna się bujać i czasem obraca go całkiem od ciebie. Mówi, do ciebie albo w stronę, w którą akurat patrzy.%SPEECH_ON%Aha, dobre pytanie! No, może teraz tego nie widać, ale sam jestem najemnikiem i, uwierzysz czy nie, moja kompania i jej kapitan zostali powieszeni i pożarci przez te pająki! Zetnij mnie, a nie mam lepszego miejsca do pójścia niż twoja kompania. O ile mnie zechcesz.%SPEECH_OFF%Kazałeś go uwolnić i zastanawiasz się, co zrobić, zanim wrócisz do %employer%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Witaj w kompanii!",
					function getResult()
					{
						this.World.getPlayerRoster().add(this.Contract.m.Dude);
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude.onHired();
						this.Contract.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "Musisz poszukać swego szczęścia gdzie indziej.",
					function getResult()
					{
						this.World.getTemporaryRoster().clear();
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
					"retired_soldier_background"
				]);

				if (!this.Contract.m.Dude.getSkills().hasSkill("trait.fear_beasts") && !this.Contract.m.Dude.getSkills().hasSkill("trait.hate_beasts"))
				{
					this.Contract.m.Dude.getSkills().removeByID("trait.fearless");
					this.Contract.m.Dude.getSkills().add(this.new("scripts/skills/traits/fear_beasts_trait"));
				}

				this.Contract.m.Dude.getBackground().m.RawDescription = "%name% został przez ciebie znaleziony, gdy zwisał z drzewa. Najemnik był ostatnim ocalałym z kompanii wysłanej do zabicia webknechtów. Dołączył do twojej kompanii po tym, jak go uratowałeś.";
				this.Contract.m.Dude.getBackground().buildDescription(true);
				this.Contract.m.Dude.worsenMood(0.5, "Stracił poprzednią kompanię na rzecz webknechtów");
				this.Contract.m.Dude.worsenMood(0.5, "Prawie został pożarty żywcem przez webknechty");

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).setArmor(this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).getArmor() * 0.33);
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).setArmor(this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).getArmor() * 0.33);
				}

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Success",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_85.png[/img]{%employer% wita cię przy bramie miasta, a obok niego stoi tłum ludzi. Wita cię serdecznie, mówiąc, że miał zwiadowcę, który śledził was i widział całą bitwę. Gdy wręcza ci nagrodę, mieszkańcy podchodzą pojedynczo, wielu z nich niechętnie spogląda najemnikowi w oczy, ale oferują kilka podarków w podzięce za uwolnienie ich od grozy webknechtów. | Musisz wytropić %employer%, ostatecznie znajdując go w stajni z wiejską dziewczyną. Podrywa się z siana, płosząc konie, które rżą i tupią. Półnagi mówi, że ma już twoją zapłatę i podaje ją. Widząc, że patrzysz na dziewczynę, zaczyna zgarniać wszystko, co ma pod ręką, także z juków uwiązanych wierzchowców, i wręcza ci to.%SPEECH_ON%L-ludzie też chcieli się dorzucić. Wiesz, w ramach podziękowania.%SPEECH_OFF%Dobrze. Po dodatkowe \"podziękowanie\" pytasz, czy odda ci wszystko, co ma w pobliskiej torbie. | %employer% wita cię z głośnym klaśnięciem i zatarciem rąk, jakbyś przyniósł mu indyka, a nie przerażający dowód zwycięstwa. Po wypłaceniu umówionej nagrody słyszysz zaskakującą nowinę. Burmistrz mówi, że majątek zaginionego mieszkańca nie mógł zostać sprawiedliwie podzielony i, jako dodatkowe podziękowanie, możesz wziąć to, co po nim zostało.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Oczyściłeś okolicę z webknechtów");
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
				local food;
				local r = this.Math.rand(1, 3);

				if (r == 1)
				{
					food = this.new("scripts/items/supplies/cured_venison_item");
				}
				else if (r == 2)
				{
					food = this.new("scripts/items/supplies/pickled_mushrooms_item");
				}
				else if (r == 3)
				{
					food = this.new("scripts/items/supplies/roots_and_berries_item");
				}

				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Zdobywasz " + food.getName()
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
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/disappearing_villagers_situation"));
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

