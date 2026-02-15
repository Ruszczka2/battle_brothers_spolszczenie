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
			Text = "[img]gfx/ui/events/event_43.png[/img]{%employer% macha, bys wszedl do jego pokoju. Zauwazasz, ze uzbrojeni w widly ludzie trzymaja warte, ponuro wpatrujac sie przez okna, choc jeden z nich wyraznie przysnal oparty o sciane. Pytasz burmistrza osady, czego chce. Przechodzi do rzeczy.%SPEECH_ON%Mieszkancy z okolic zglaszaja potwory porywajace dzieci, psy i podobne. Nie chce ulegac paranoi i przesadom, ale wyglada na to, ze mowia o pajakach. Webknechty, jak mawial moj ojciec, i jesli to prawda, pewnie maja tu gniazdo, ktore trzeba znalezc i zniszczyc. Zainteresowany, najemniku?%SPEECH_OFF% | Zastajesz %employer% rozciagajacego pajeczyne miedzy dwoma widlami. Obraca jedno z narzedzi, owijajac pajeczyne wokol sznurka. Wzdycha i w koncu spoglada na ciebie.%SPEECH_ON%Niechetnie sprowadzam tu najemnikow, ale jestem u kresu sil. Po okolicy kraza ogromne pajaki, kradna bydlo i zwierzeta. Jedna kobieta doniosla, ze jej niemowle zniknelo z kolyski, a na jego miejscu zostala jama pajeczyn. Musze pozbyc sie tych paskudnych stworzen, zniszczyc ich gniazdo. Jesli odpowiednio zaplace, jestes zainteresowany?%SPEECH_OFF% | Podchodzisz do %employer%, a sam twoj cien go ploszy. Zrywa sie prosto przy biurku i kiwa glowa.%SPEECH_ON%Ech, mam dreszcze. Nie chodzi o to, ze tu jestes, najemniku, choc wygladasz groznie, ale po okolicy kraza wiesci o wielkich pajakach. Mam powod, by w to wierzyc, bo bylem w gospodarstwie i widzialem wielkie pajeczyny oraz pozarte bydlo. Potrzebuje czlowieka zdolnego do bezwzglednej przemocy, rozmawiam z toba, i potrzebuje, by taki czlowiek znalazl gniazdo potworow i polozyl im kres. Jestes zainteresowany?%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_25.png[/img]{Natykasz sie na martwa krowe, z ktorej mieso wyssano az do kosci, a jednak skora nie nosi sladow wysuszenia na sloncu. %randombrother% kuca i przesuwa palcem po licznych nakluciach. Kiwajac glowa, mowi.%SPEECH_ON%Robota webknechtow, bez dwoch zdan. Zatruli ja, a potem zerowali na sparalizowanym ciele. A swiezy trup znaczy, ze sa blisko...%SPEECH_OFF% | Znajdujesz opleciony pajeczyna trup oparty o samotne drzewo. Rozcinasz nici. Wypada cialo dziecka i osuwa sie na ziemie. Twarz jest przyklejona do kosci, blady czaszkowaty leb z galkami ocznymi wygladajacymi z glebokich oczodolow. Jezyk rownie wciagniety, nosa prawie brak. %randombrother% spluwa i kiwa glowa.%SPEECH_ON%Dobra. Jestesmy blisko. A raczej oni sa blisko. Jesli to was pocieszy, chlopak zmarl zanim stal sie tym, co widzicie. Webknechty wstrzykuja jad przy ukluciu i zadne dziecko dlugo by tego nie przezylo.%SPEECH_OFF%Dobrze. Czas, by ludzie znalezli te potwory. | Znajdujesz chlopaka schowanego pod przewrocona taczka. Nie chce wyjsc, jego mala glowa wyglada z kryjowki jak perla z muszli. Pytasz, co robi. Nerwowo tlumaczy, ze chowa sie przed pajakami i ze masz stad isc.%SPEECH_ON%Znalez sobie wlasna taczke. Ta jest moja.%SPEECH_OFF% Wymachujac mieczem, mowisz mu, ze to pajakow szukasz. Chlopak patrzy na ciebie. Kiwajac glowa, mowi.%SPEECH_ON%To cholernie glupi pomysl, panie. I nie, nie mam pojecia, gdzie poszly. Bylem tu z karawana, widzisz tu karawane? No wlasnie nie, bo to teraz salatka dla pajakow, wiec spadaj, zanim zobacza, ze ze mna gadasz!%SPEECH_OFF%Taczka z loskotem sie zamyka. Nie masz zamiaru jej podnosic, ale na odchodnym dajesz jej solidnego kopniaka.}",
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
			Text = "[img]gfx/ui/events/event_110.png[/img]{Gniazdo webknechtow to jama ziemi opleciona biela. Na jej krawedzi wisza cienkie nici, kolyszace sie przy najlzejszym powiewie. Gdy prowadzisz kompanie do srodka, pajeczyna przybiera jakby cywilizowany ksztalt, jakbys wchodzil z zimowych ostepow; swiezosc jej powstania widac po ciasnych wiezach: jelenie, psy, ludzkiej wielkosci kokony bez sladow zycia, wszystko scisle uwiazane w hangarach bialych silosow i skrzydelnic, niczym kesy zgubione na bladym dywanie. Zza zasnutej siedziby wylania sie czarny cien, podchodzac z przodu, z nogami skulonymi niczym na zaslonie, a glowa schowana za nimi, jakby paskudny stwor byl uwieziony wlasnym krokiem. Z jego szczek wysuwa sie i wsuwa ludzka dlon niczym makabryczny smoczek. Trafiles we wlasciwe miejsce. | Gniazdo webknechtow jest ciche, a szczek przybycia kompanii brzmi niemal bluznierczo, zgrzyt metalu wyraznie ostry w tym przekroczeniu.\n\n Zauwazasz mezczyzne wiszacego glowa w dol na drzewie, cale cialo w kokonie poza twarza, ktora nici naciagaja i deformuja. Prosi, bys uwolnil mu powieki z pajeczyn, co robisz. Jego powieki powoli sie zamykaja, zaschnieta skorupa suchych oczu trzaska po raz pierwszy od byc moze dni. Lecz zaraz sie otwieraja, a mezczyzna krzyczy. Kokon przy jego pasie pecznieje i rozrywa sie, a z niego wylewa sie strumien drobnych czarnych pajakow. Cialo mezczyzny szarpie sie gwaltownie, gdy roj go pozera, jego zduszone krzyki pelne sa chrobotu pajaczatek, ktore wypelniaja mu pluca i ktore wykrztusza w konwulsjach smierci. Przerazony cofasz sie, tylko po to, by zobaczyc tlum znacznie wiekszych pajakow wylaniajacych sie zza drzew! | Gniazdo latwo dostrzec: fragment zimowego pejzazu bez zimna, biala pajeczyna porozwieszana i zwisajaca z kazdego drzewa, z kazdej kepy, z kazdego skrawka miejsca. Wprowadzasz kompanie prosto do srodka, z dobytymi broniami, i natykasz sie na oplecione ciala, rozerwane na srodku i sczerniale, a z nich wysyp legu pajaczatek ssie wnetrznosci.\n\n Spogladajac w gore, widzisz czerwone oczy rozblyskujace miedzy galeziami okolicznych drzew; cale pajecze arboretum ozywa, jego straznicy siedza wsrod zarosli z nogami tak skulonymi, ze nie sposob ich odroznic od galezi, wrog skryty na widoku. O malo co nie narobiles w portki, gdy rzekome drzewo calkowicie sie rozklada, kazdy drewniany ped okazuje sie pajacza noga, a ten nadrzewny trik spada na kompanie, cykajac i szczekajac po kasek!}",
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
			Text = "[img]gfx/ui/events/event_123.png[/img]{Z ostatnim z webknechtow uporano sie, jego nogi zginaja sie, jakby na wiecznosc chcialy chwycic bron, ktora go zabila. Kiwasz glowa na znak dobrej roboty, po czym kazesz spalic cale miejsce. Ogien szybko przebiega po pajeczynach, zrywajac mosty z nici i niosac plomienna zgube do ich polaczen. Cale gniazdo staje w ogniu, a gdzies gleboko w jego poscielisku slychac przenikliwy pisk plonacych pajaczatek. | Podchodzisz do ostatniego z webknechtow i wpatrujesz sie w jego ohydna paszcze. Ma zlosliwy zestaw zuwaczek niczym ochraniacz dziasel, a sama paszcza to szczelina wysadzona ostrymi jak brzytwa zebami skierowanymi do srodka, by rozszarpywac wszystko, co probowaloby uciekac.\n\n Kazesz spalic cale gniazdo. Gdy plomienie rosna, gdzies w legowiskach slychac pisk pajaczatek. | Szykujesz powrot do %employer%, lecz najpierw kazesz calkowicie spalic gniazdo. Kompania stoi przed plomieniami, sluchajac przenikliwych piskow pajaczatek i chwilami smiejac sie z malych stworzen biegajacych jak malenki ogniste kulki na nogach. | Po pokonaniu pajakow kazesz spalic to przeklete miejsce i szykujesz powrot do %employer%. Gdy ogien bucha w gore, male pajaczki wybiegaja z plonacymi cialami niczym swietliki w nocy. Kilku najemnikow urzadza improwizowana zabawe w to, kto rozgniecie najwiecej, co konczy sie tym, ze szczegolnie ambitne pajaczatko o malo nie podpala spodni jednemu z najemnikow.}",
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
			Text = "[img]gfx/ui/events/event_123.png[/img]{Po rozprawieniu sie z webknechtami kazesz kompanii krotko przeszukac ich gniazdo, choc najemnicy maja rozkaz nigdy nie chodzic samotnie. Sam tez brniesz w pajeczyny, %randombrother% u twojego boku. Razem dostrzegacie drzewo, ktore jest zadziwiajaco nietkniete przez sieci. Okrazajac je, znajdujesz cialo rycerza oparte o pien. Jego dlon spoczywa na glowicy zlamanego miecza, a druga reka calkiem zniknela, tylko rekaw na nadgarstku i okaleczony kikut ulozony na brzuchu. Zwloki spoczywaja w gniezdzie wlasnej roboty, w gaszczu czegos, co wyglada jak zepsute lodygi rabarbaru i zgnile pancerze, polamane ciala wydrazone i cuchnace jadem. %randombrother% kiwa glowa.%SPEECH_ON%To wielka szkoda. Zaloze sie, ze bylby solidnym wzmocnieniem dla %companyname%, kimkolwiek byl.%SPEECH_OFF%To prawda, wyglada na godny koniec wielkiego wojownika. Masz ochote go pochowac, ale nie masz czasu. Mowisz %randombrother%, by zabral z ciala co sie da i szykowal powrot do %employer%.}",
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
			Text = "[img]gfx/ui/events/event_123.png[/img]{Po bitwie znajdujesz mezczyzne wiszacego na pajeczynie przyczepionej do stop. Polowa ciala jest zwiazana nicmi, a kolejne zwisaja z biodra jak strzepiona suknia. Wyglada na to, ze pajaki porzucily go, gdy przybyla %companyname%. Na twoj widok sie usmiecha.%SPEECH_ON%No witaj. Najemnicy, co? Tak, widze. Nie przyszlibyscie tu, gdyby nie moneta, a biliscie sie jak skurczybyki, na ktorych ktos postawil. Absolutne dzikusy.%SPEECH_OFF%Pytasz mezczyzne, co zyskasz, jesli go uwolnisz. Zadziera glowe, a cale cialo zaczyna sie bujac i czasem obraca go calkiem od ciebie. Mowi, do ciebie albo w strone, w ktora akurat patrzy.%SPEECH_ON%Aha, dobre pytanie! No, moze teraz tego nie widac, ale sam jestem najemnikiem i, uwierzysz czy nie, moja kompania i jej kapitan zostali powieszeni i pozarci przez te pajaki! Zetnij mnie, a nie mam lepszego miejsca do pojscia niz twoja kompania. O ile mnie zechcesz.%SPEECH_OFF%Kazales go uwolnic i zastanawiasz sie, co zrobic, zanim wrocisz do %employer%.}",
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
			Text = "[img]gfx/ui/events/event_85.png[/img]{%employer% wita cie przy bramie miasta, a obok niego stoi tlum ludzi. Wita cie serdecznie, mowiac, ze mial zwiadowce, ktory sledzil was i widzial cala bitwe. Gdy wrecza ci nagrode, mieszkancy podchodza pojedynczo, wielu z nich niechetnie spoglada najemnikowi w oczy, ale oferuja kilka podarkow w podziece za uwolnienie ich od grozy webknechtow. | Musisz wytropic %employer%, ostatecznie znajdujac go w stajni z wiejska dziewczyna. Podrywa sie z siana, ploszac konie, ktore rza i tupia. Polnagi mowi, ze ma juz twoja zaplate i podaje ja. Widzac, ze patrzysz na dziewczyne, zaczyna zgarniac wszystko, co ma pod reka, takze z jukow uwiazanych wierzchowcow, i wrecza ci to.%SPEECH_ON%L-ludzie tez chcieli sie dorzucic. Wiesz, w ramach podziekowania.%SPEECH_OFF%Dobrze. Po dodatkowe \"podziekowanie\" pytasz, czy odda ci wszystko, co ma w pobliskiej torbie. | %employer% wita cie z glosnym klasnieciem i zatarciem rak, jakbys przyniosl mu indyka, a nie przerazajacy dowod zwyciestwa. Po wyplaceniu umowionej nagrody slyszysz zaskakujaca nowine. Burmistrz mowi, ze majatek zaginionego mieszkanca nie mogl zostac sprawiedliwie podzielony i, jako dodatkowe podziekowanie, mozesz wziac to, co po nim zostalo.}",
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

