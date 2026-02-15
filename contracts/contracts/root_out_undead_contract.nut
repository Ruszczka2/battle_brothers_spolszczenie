this.root_out_undead_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Objective1 = null,
		Objective2 = null,
		Target = null,
		Current = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		local r = this.Math.rand(1, 100);

		if (r <= 70)
		{
			this.m.DifficultyMult = this.Math.rand(95, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}

		this.m.Type = "contract.root_out_undead";
		this.m.Name = "Wyplenienie Nieumarłych";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		if (this.m.Origin == null)
		{
			this.setOrigin(this.World.State.getCurrentTown());
		}

		local nearest_undead = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getNearestSettlement(this.m.Origin.getTile());
		local nearest_zombies = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getNearestSettlement(this.m.Origin.getTile());

		if (this.Math.rand(1, 100) <= 50)
		{
			this.m.Objective1 = this.WeakTableRef(nearest_undead);
			this.m.Objective2 = this.WeakTableRef(nearest_zombies);
		}
		else
		{
			this.m.Objective2 = this.WeakTableRef(nearest_undead);
			this.m.Objective1 = this.WeakTableRef(nearest_zombies);
		}

		this.m.Flags.set("Objective1Name", this.m.Objective1.getName());
		this.m.Flags.set("Objective2Name", this.m.Objective2.getName());
		this.m.Payment.Pool = 1500 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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

		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Zniszcz miejsce zwane %objective1%",
					"Zniszcz miejsce zwane %objective2%",
					"Wróć do %townname%"
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
				this.Contract.m.Objective1.setLootScaleBasedOnResources(120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Objective1.setResources(120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Objective1.clearTroops();
				this.Contract.addUnitsToEntity(this.Contract.m.Objective1, this.Contract.m.Objective1.getDefenderSpawnList(), 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Objective1.setDiscovered(true);

				if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Objective1.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Objective1.getLoot().clear();
				}

				this.World.uncoverFogOfWar(this.Contract.m.Objective1.getTile().Pos, 500.0);
				this.Contract.m.Objective2.setLootScaleBasedOnResources(120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Objective2.setResources(120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Objective2.clearTroops();
				this.Contract.addUnitsToEntity(this.Contract.m.Objective2, this.Contract.m.Objective2.getDefenderSpawnList(), 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Objective2.setDiscovered(true);

				if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Objective2.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Objective2.getLoot().clear();
				}

				this.World.uncoverFogOfWar(this.Contract.m.Objective2.getTile().Pos, 500.0);
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					this.Flags.set("IsNecromancers", true);
				}
				else if (r <= 25)
				{
					this.Flags.set("IsBandits", true);
				}

				this.Flags.set("ObjectivesDestroyed", 0);
				this.Flags.set("Objective1ID", this.Contract.m.Objective1.getID());
				this.Flags.set("Objective2ID", this.Contract.m.Objective2.getID());
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [];

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull() && this.Contract.m.Target.isAlive())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.BulletpointsObjectives.push("Zabij uciekających nekromantów");
				}

				if (this.Contract.m.Objective1 != null && !this.Contract.m.Objective1.isNull() && this.Contract.m.Objective1.isAlive())
				{
					this.Contract.m.Objective1.getSprite("selection").Visible = true;
					this.Contract.m.BulletpointsObjectives.push("Zniszcz miejsce zwane %objective1%");
					this.Contract.m.Objective1.setOnCombatWithPlayerCallback(this.onCombatWithPlayer.bindenv(this));
				}

				if (this.Contract.m.Objective2 != null && !this.Contract.m.Objective2.isNull() && this.Contract.m.Objective2.isAlive())
				{
					this.Contract.m.Objective2.getSprite("selection").Visible = true;
					this.Contract.m.BulletpointsObjectives.push("Zniszcz miejsce zwane %objective2%");
					this.Contract.m.Objective2.setOnCombatWithPlayerCallback(this.onCombatWithPlayer.bindenv(this));
				}
			}

			function update()
			{
				if (this.Flags.get("ObjectiveDestroyed"))
				{
					this.Flags.set("ObjectiveDestroyed", false);

					if (this.Flags.get("IsBanditsCoop"))
					{
						this.Contract.setScreen("BanditsAftermathCoop");
					}
					else if (this.Flags.get("IsBandits3Way"))
					{
						this.Contract.setScreen("BanditsAftermath3Way");
					}
					else if (this.Flags.get("ObjectivesDestroyed") == 1)
					{
						this.Contract.setScreen("Aftermath1");
					}
					else
					{
						this.Contract.setScreen("Aftermath2");
					}

					this.World.Contracts.showActiveContract();
				}

				if (this.Flags.get("IsNecromancersSpawned"))
				{
					if (this.Contract.m.Target == null || this.Contract.m.Target.isNull())
					{
						this.Contract.setScreen("NecromancersAftermath");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Contract.m.Target.getTile().getDistanceTo(this.World.State.getPlayer().getTile()) >= 9)
					{
						this.Contract.setScreen("NecromancersFail");
						this.World.Contracts.showActiveContract();
					}
				}

				if (!this.Flags.get("IsBandits") || this.Flags.get("ObjectivesDestroyed") != 0)
				{
					if (this.Contract.m.Objective1 != null && !this.Contract.m.Objective1.isNull() && !this.Contract.m.Objective1.getFlags().has("TriggeredContractDialog") && this.Contract.isPlayerNear(this.Contract.m.Objective1, 450))
					{
						this.Contract.m.Objective1.getFlags().add("TriggeredContractDialog");
						this.Contract.setScreen("UndeadRepository");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Contract.m.Objective2 != null && !this.Contract.m.Objective2.isNull() && !this.Contract.m.Objective2.getFlags().has("TriggeredContractDialog") && this.Contract.isPlayerNear(this.Contract.m.Objective2, 450))
					{
						this.Contract.m.Objective2.getFlags().add("TriggeredContractDialog");

						if (this.Flags.get("IsNecromancers"))
						{
							this.Flags.set("IsNecromancersSpawned", true);
							this.Contract.setScreen("Necromancers");
							this.World.Contracts.showActiveContract();
						}
						else
						{
							this.Contract.setScreen("UndeadRepository");
							this.World.Contracts.showActiveContract();
						}
					}
				}
			}

			function onCombatWithPlayer( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
				this.Contract.m.Current = _dest;

				if (_dest != null && !_dest.getFlags().has("TriggeredContractDialog") && this.Flags.get("IsBandits") && this.Flags.get("ObjectivesDestroyed") == 0)
				{
					_dest.getFlags().add("TriggeredContractDialog");
					this.Contract.setScreen("Bandits");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					_dest.m.IsShowingDefenders = true;
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.EnemyBanners.push(_dest.getBanner());

					if (this.Flags.get("IsBandits") && this.Flags.get("ObjectivesDestroyed") == 0)
					{
						if (this.Flags.get("IsBanditsCoop"))
						{
							p.AllyBanners.push("banner_bandits_06");
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.BanditRaiders, 90 * this.Contract.getScaledDifficultyMult(), this.Const.Faction.PlayerAnimals);
						}
						else
						{
							p.EnemyBanners.push("banner_bandits_06");
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.BanditRaiders, 90 * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						}
					}

					this.World.Contracts.startScriptedCombat(p, this.Contract.m.IsPlayerAttacking, true, true);
				}
			}

			function onLocationDestroyed( _location )
			{
				if (_location.getID() == this.Flags.get("Objective1ID"))
				{
					this.Contract.m.Objective1 = null;
					this.Flags.set("ObjectiveDestroyed", true);
					this.Flags.set("ObjectivesDestroyed", this.Flags.get("ObjectivesDestroyed") + 1);
				}
				else if (_location.getID() == this.Flags.get("Objective2ID"))
				{
					this.Contract.m.Objective2 = null;
					this.Flags.set("ObjectiveDestroyed", true);
					this.Flags.set("ObjectivesDestroyed", this.Flags.get("ObjectivesDestroyed") + 1);
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{Zastajesz %employer% zwijającego mapę i opierającego jej koniec o świecę. Płomienie szybko rosną, a zwęglony papier kapie w ślad za ogniem. Machnięciem zaprasza cię do środka.%SPEECH_ON%Złe mapy są jak trucizna dla armii. Dobra mapa to złoto.%SPEECH_OFF%Gdy ogień zaczyna lizać mu palce, mężczyzna upuszcza papier i depcze go. Siada i wyciąga kolejny zwój, rozwijając go na całym blacie. To po prostu najpiękniejsza mapa, jaką kiedykolwiek widziałeś. %employer% używa dwóch patyków, by wskazać dwa różne miejsca.%SPEECH_ON%\'%objective1%\' i \'%objective2%\', dwie barwne nazwy. To stamtąd, według moich szpiegów, nadchodzą nieumarli. Przynajmniej większość tych potworów. Idź do obu miejsc, najemniku, i pomóż położyć kres tym okropnościom.%SPEECH_OFF% | Wchodzisz do komnaty %employer%. Jego generałowie mają czerwone twarze, krwawy finał kłótni, która poszła źle. Szlachcic daje ci znak.%SPEECH_ON%Ach, człowiek, z którym naprawdę chciałbym, cholera, porozmawiać. Panowie, zróbcie przejście.%SPEECH_OFF%Pod ostrymi spojrzeniami przechodzisz przez morze wyniosłych dowódców. %employer% uderza mapą o twoją pierś. Dwa miejsca są zaznaczone okręgami i prymitywnymi czaszkami ze skrzyżowanymi kośćmi.%SPEECH_ON%Idź do obu, najemniku. \'%objective1%\' i \'%objective2%\'. Moi skrybowie uważają, że są kluczowe dla fal nieumarłych. Moi dowódcy się z tym nie zgadzają, ale czemu by nie sprawdzić? Jeśli zobaczysz te straszne skurwysyny, zabij je, zniszcz cholerne dziury, z których wypełzają, i wróć do mnie z wspaniałymi wieściami o swoich bohaterstwach. Umowa?%SPEECH_OFF% | %employer% dogląda swojego ogrodu. Warzywa poszarzały. Palcami zeskrobuje popiół z pędów.%SPEECH_ON%Jest mi smutno, najemniku, z powodu stanu rzeczy, ale przynajmniej moje cholerne jedzenie nie wraca do życia, żeby mi odgryźć tyłek.%SPEECH_OFF%Śmiejesz się i odpowiadasz.%SPEECH_ON%Daj temu czas. Nie wiemy, jak mściwe potrafi być warzywo.%SPEECH_OFF%Szlachcic kiwa głową z powagą, jakbyś był filozofem, a nie żartownisiem. Rzuca ci mapę.%SPEECH_ON%Znajdziesz dwa miejsca, \'%objective1%\' i \'%objective2%\'. Podobno oba to legowiska nieumarłych. Idź tam, zabij ich wszystkich i zniszcz ich domy. Albo groby. Doły. Cokolwiek.%SPEECH_OFF% | Smutno wyglądający chłop, czyli zwykły chłop, wychodzi z komnaty %employer%, gdy wchodzisz. Kiwa cię do biurka.%SPEECH_ON%Cieszę się, że jesteś, najemniku, bo mam dla ciebie nie lada zadanie. Moi zwiadowcy donoszą o dwóch miejscach, które bardzo interesują mnie i lud tych ziem. Nazywają się \'%objective1%\' i \'%objective2%\' i podobno nieumarli wylewają się z obu. Co powiesz na to, by tam pójść i to sprawdzić? A przez \'sprawdzić\' rozumiem zabić ich wszystkich, jeśli to prawda, i wrócić do mnie z dobrą nowiną.%SPEECH_OFF% | Zastajesz %employer% wpatrującego się w martwego kota na biurku. W jego piersi tkwi sztylet, a szlachcic trzyma w dłoni kolejne ostrze. Strażnik stoi z boku z mieczem już w dłoni, a obok skryba z piórem i zwojem. Gdy przechodzisz przez pokój, wszyscy powoli się uspokajają. Ostrza wracają do pochew, pióra zaczynają skrobać. Skryba zabiera kota, bogowie wiedzą po co. %employer% siada.%SPEECH_ON%Witaj, najemniku. Robiliśmy mały eksperyment. Nie wierzyliśmy, że koty mają dziewięć żyć, ale w tym nowym świecie okropności mogły mieć dwa. Okazało się, że nie. Mają tylko jedno.%SPEECH_OFF%Szlachcic wyciąga mapę i kładzie ją na biurku. Wskazuje dwa miejsca.%SPEECH_ON%\'%objective1%\' tutaj. \'%objective2%\' tutaj. Idź do obu. Jeśli moi zwiadowcy mają rację, znajdziesz tam nieumarłych. Wielu. Masz zniszczyć wszystko i zadbać, by to nieumarłe plugastwo zostało ucięte w zarodku.%SPEECH_OFF% | %employer% stoi obok znużonego zwiadowcy. Tropiciel zajada do syta, uzupełniając to, co stracił, pędząc przez ziemie. %employer% pokazuje ci prymitywną mapę.%SPEECH_ON%\'%objective1%\' i \'%objective2%\'. My, to znaczy mój przyjacielski ptaszek, uważa, że to składy nieumarłych, nazwa jak ulał. Z tych miejsc wypełzają wszelcy nieświęci. Idź tam, zniszcz wszystko, co zobaczysz, i wróć jako bohater.%SPEECH_OFF%Wzruszasz ramionami.%SPEECH_ON%%companyname% woli korony od pochwał.%SPEECH_OFF% | %employer% wita cię z mapą.%SPEECH_ON%\'%objective1%\' i \'%objective2%\', rozpoznajesz te miejsca? Nie, oczywiście, że nie. Chcę jednak, byś poszedł do każdego, wykorzenił zło, które w nich tkwi, i wrócił. Krótka i prosta wyprawa do składowisk umarłych, prawda?%SPEECH_OFF%Jasne. Co mogłoby pójść nie tak? | %employer% pyta, czy boisz się nieumarłych. Wzruszasz ramionami i odpowiadasz.%SPEECH_ON%Boję się umrzeć z żalem, że nie zrobiłem wszystkiego, co chciałem. Tyle się boję. I koni.%SPEECH_OFF%Szlachcic śmieje się.%SPEECH_ON%No dobrze. Oto mapa. Zobaczysz zaznaczone \'%objective1%\' i \'%objective2%\'. Moi zwiadowcy uważają, że to schronienia nieumarłych. Ma to sens, bo tam przecież chowamy naszych zmarłych. Idź do obu, zniszcz je i wróć po zapłatę. Wystarczająco proste, prawda?%SPEECH_OFF% | %employer% wita cię w drzwiach z mapą w dłoni.%SPEECH_ON%\'%objective1%\' i \'%objective2%\', zaznaczone wyraźnie, widzisz? Oczywiście, że tak. Moje ptaszki mówią, że z obu wylewają się wielkie zła. Jeśli to prawda, potrzebuję człowieka o odwadze i zabójczej postawie, by iść do obu miejsc i zniszczyć wszystko, co tam jest. Wierzę, że jesteś takim człowiekiem. Jesteś?%SPEECH_OFF% | Dobrze uzbrojony, choć ponury mężczyzna wychodzi z komnaty %employer%. Gdy wchodzisz, szlachcic wskazuje ci biurko i mapę.%SPEECH_ON%Nie boisz się umarłych, prawda? A nieumarłych? Nie? Doskonale. \'%objective1%\' jest tu, a \'%objective2%\' tam. Idź do obu, zniszcz je i pokaż temu tchórzowi, który przed chwilą wyszedł, na co stać prawdziwego mężczyznę.%SPEECH_OFF%Unosisz napominający palec.%SPEECH_ON%Co potrafi prawdziwy mężczyzna - za odpowiednią cenę.%SPEECH_OFF% | %employer% wita cię w swojej komnacie dziwnym pytaniem.%SPEECH_ON%Byłeś kiedyś na cmentarzu, najemniku?%SPEECH_OFF%Zanim odpowiesz, mężczyzna nalewa sobie drinka i pije łyk, drugą ręką gestem każe ci milczeć.%SPEECH_ON%To osobliwe rzeczy. Nienaturalne, naprawdę. Jakie stworzenie bierze swoich zmarłych i idzie na ziemię, dobrą ziemię, i ich tam zakopuje? Jakże to próżne. Jakże nieistotne. Czy dziwi więc, że zmarli wracają? Może nawiedzają nas za złamanie naturalnego porządku.%SPEECH_OFF%Mężczyzna rzuca ci zwój, na którym jest dobrze narysowana mapa. Dwa miejsca są zaznaczone.%SPEECH_ON%\'%objective1%\' i \'%objective2%\'. Musisz iść do obu, zniszczyć je i wrócić. Proste jak na człowieka twojego fachu, prawda?%SPEECH_OFF% | Zastajesz %employer% kręcącego głową, gdy przesuwa pióro po mapie.%SPEECH_ON%\'%objective1%\' i \'%objective2%\', dwa małe obsrane doły niedaleko stąd, trzeba zniszczyć. Oczywiście to siedliska umarłych, a więc nieumarłych. Nie dają nam spokoju i cóż, czy któryś z tych trupów może wreszcie spocząć? Kto wie. Ale zabij ich wszystkich, jasne?%SPEECH_OFF% | %employer% dogląda dziesiątek ptaków w klatkach. Niektóre trzepoczą, uderzając w pręty. Szlachcic podnosi martwego ptaka, jego chude nogi sterczą w górę. Rzuca ci ciało.%SPEECH_ON%Mam dla ciebie zadanie, najemniku. \'%objective1%\' i \'%objective2%\' niedaleko stąd trzeba zniszczyć. Moi zwiadowcy donoszą, dzięki tym ptaszkom, że te miejsca są siedzibą nieumarłych, może źródłem, może bazą operacyjną, jeśli te trupy w ogóle potrafią coś zorganizować.%SPEECH_OFF%Mężczyzna zaczyna sypać ziarno do klatek. Kilka ptaków patrzy na karmę i nie je, nie czując przymusu do kradzieży największego daru natury. Ptaki z przyciętymi skrzydłami jednak dziobią łapczywie. %employer% odwraca się do ciebie, otrzepując dłonie.%SPEECH_ON%Więc, mamy umowę?%SPEECH_OFF% | Zastajesz %employer% otoczonego strażnikami, wszyscy wpatrują się w zwłoki pośrodku pokoju. Okropny smród wita cię na długo przed szlachcicem. Nad ciałem unosi się miazma, leniwa szarość jakby był to popiół na przeciągu.%SPEECH_ON%Najemniku! Dobrze, że jesteś! Jeśli możesz, zignoruj to zamieszanie. Mieliśmy problem z gwardzistą, który popełnił samobójstwo i, cóż, wrócił. Zawiły plan zabójstwa? Trudno powiedzieć w tym świecie. Chodź, mam coś dla ciebie.%SPEECH_OFF%Wskazuje cię do przodu, wyciągając zwój. Bierzesz go i rozwijasz mapę. Mężczyzna wyjaśnia.%SPEECH_ON%\'%objective1%\' i \'%objective2%\'. Jeśli je rozpoznajesz, to składy, z których, jak sądzimy, wychodzą nieumarli. Potrzebuję człowieka o twojej, eee, stalowej postawie, by tam pójść i położyć temu kres. Mam nadzieję, że to cię interesuje.%SPEECH_OFF% | %employer% wita cię w swojej komnacie, ale strażnik przykłada do twojej szyi ostrze glewii. Zachowujesz spokój, a szlachcic szybko każe mu odpuścić. Przeprasza.%SPEECH_ON%Przepraszam za ten niefortunny incydent, ale ludzie są na krawędzi. Ostatniej nocy jeden z nich zmarł we śnie i, cóż, wrócił. Ghoulowaty, warczący potwór, który zabił trzech ludzi, zanim ktokolwiek zrozumiał, co się dzieje.%SPEECH_OFF%Pocierasz podbródek, mówiąc, że i tak potrzebowałeś dobrego golenia. %employer% kiwa głową z uśmiechem.%SPEECH_ON%Mmm, to w tobie lubię, najemniku. Zawsze w dobrym nastroju. Spójrz na tę mapę. Widzisz te miejsca? Nazywają je \'%objective1%\' i \'%objective2%\'. Mamy powody sądzić, że oba są potężnymi źródłami mocy napędzającej hordy nieumarłych. Potrzebuję człowieka twojej postawy i determinacji, by tam pójść i je zniszczyć. Jesteś zainteresowany, najemniku?%SPEECH_OFF% | Zastajesz %employer% odchylonego w krześle. Rzuca ci mapę.%SPEECH_ON%Przeczytaj ją, przestudiuj. Widzisz \'%objective1%\' i \'%objective2%\'? Moi szpiedzy uważają, że to domy niewyobrażalnych mocy, które napędzają nieumarłych. Ja myślę, że to po prostu miejsca pełne martwych ciał, dla nieumarłych do reinkarnacji. Tak czy inaczej, musisz pójść do obu, zniszczyć je i wrócić do mnie. Interesuje cię to czy nie?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Jaka płaca? | Co mnie interesuje, to wysokość zapłaty.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{To nie jest tego warte. | Jesteśmy potrzebni gdzie indziej.}",
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
			ID = "UndeadRepository",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_57.png[/img]{Znajomy smród zaczyna unosić się nad kompanią. %randombrother% zauważa, że muszą zbliżać się do składowiska. Odpowiadasz, że to cholerny geniusz i powinien tworzyć wynalazki dla dobra ludzkości. Wśród śmiechu kompani niemal słyszysz jego milczenie. | Gdy zbliżasz się do celu, staje się coraz bardziej oczywiste, że ocena %employer% była trafna. Smród jest nie do podważenia: cokolwiek tu zginęło, wróciło, by snuć się po ziemi. | Znajdujesz zwłoki zaplątane w krzak, dłonie owinięte gałęziami rytmicznie pedałują na zewnątrz z martwą obojętnością. %randombrother% podchodzi, ostrożnie trzymając dystans, i wbija ostrze w czaszkę. Cofając się, czyści broń i zauważa, że kompania musi być blisko celu, który macie zniszczyć. | Sądząc po przytłaczającym zapachu dojrzałych ciał i gazów, które z siebie wydzielają, nie ma wątpliwości, że %objective% jest blisko. | Znajdujesz pół człowieka pełzającego po ziemi. Patrzy na ciebie, bezmyślnie jęcząc, obojętny na swoje nowe istnienie, a jednak pragnący zakończyć twoje. Butem wciskasz jego głowę w błoto. Warczenie staje się bulgotem, a ty ostrożnie wbijasz sztylet w ucho. %randombrother% rozgląda się.%SPEECH_ON%To %objective% nie może być już daleko.%SPEECH_OFF% | Cel jest jeszcze ledwie w zasięgu wzroku, ale jego zapach uderza w nos z furią, której masz nadzieję nie dorówna to, co tam mieszka. Powinieneś przygotować ludzi na nadchodzącą bitwę. | %randombrother% wskazuje na poboczu stertę trupów ułożonych w pozach jak po akrobatycznej śmierci. Nie wiesz, co się stało, ale ciała są dawno martwe, a mimo to nie widać much ani innych zwierząt. Informujesz ludzi, że cel jest blisko i powinni przygotować się do walki. | Kompania natyka się na zataczające się zwłoki z kajdanami na rękach i nogach. Uwięzienie za życia nie skończyło się po reanimacji, więc robisz to, co kat powinien był zrobić dawno temu, i odcinasz głowę wiedergangerowi. %randombrother% pyta, czy cel jest blisko, a ty kiwasz głową. Na pewno, a z nim nadejdzie bitwa, do której %companyname% powinno się przygotować. | Cel nie może być daleko, jeśli sądzić po okropnym zapachu unoszącym się nad kompanią. Czy to żywe trupy, czy człowiek o szczególnie nikczemnych wypróżnieniach, %companyname% powinno szykować się do walki. | Żywe trupy witają was jeden po drugim, seria łatwych do usunięcia okruchów prowadzi %companyname% prosto do celu. Przygotuj się do walki, bo wkrótce na talerzu będziesz miał cały bochen. | Starzec wita kompanię i mówi, że %objective% nie jest daleko. Pytasz, co u diabła wciąż tu robi. Wzrusza ramionami.%SPEECH_ON%Jestem stary, co innego?%SPEECH_OFF% | %randombrother% węszy powietrze.%SPEECH_ON%Znam śmierdzący zadek %randombrother2% i to nie on.%SPEECH_OFF%Obrażony najemnik wzrusza ramionami.%SPEECH_ON%Nie z braku prób, ale tak, masz rację. Musimy być blisko %objective%.%SPEECH_OFF%Kiwasz głową i każesz ludziom przygotować się do nadchodzącej bitwy. | Znajdujesz ziemią przetarty trup z pustymi oczodołami, miotający się przy dużym głazie. Drepcze wokół, skrobiąc kamień z nieudolnym zapałem, jakby chciał go zabić. %randombrother% odcina wiedergangerowi głowę jednym cięciem, jakby kroił kostkę masła. Kiwając głową w dal, mówi.%SPEECH_ON%%objective% jest blisko.%SPEECH_OFF%Jeśli tak, %companyname% powinno szykować się do walki.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Przygotować się na najgorsze!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Aftermath1",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Zło w tym miejscu zostało zgaszone. Bierzesz oddech, jakby pierwszy od lat, jakby powietrze samo ociepliło się od zwycięstwa. Zostało tylko tak zwane %objective2%. | Gdy ostatni nieumarły zostaje położony do spoczynku, czujesz, że powietrze się oczyszcza, jakby dymna mgła ustępowała rześkim, wiosennym zapachom. Ta szybka zmiana bez wątpienia oznacza, że oczyściłeś to miejsce zła. Teraz oczyścić %objective2% i zakończyć kontrakt. | Zło tego miejsca zostało uśpione. Czeka następny cel. | Gdy to okropne miejsce oczyszczone ze zła, na kontrakcie pozostało tylko %objective2%. | Gdy ostatni wiederganger zostaje położony do spoczynku, czujesz nagłą zmianę w powietrzu. Czystość uderza w płuca z niespodziewaną klarownością, choć stoisz pośród błota i zgnilizny. %randombrother% ociera czoło.%SPEECH_ON%To już chyba koniec. W drogę do %objective2%?%SPEECH_OFF% | Wkroczyłeś w domenę zła, ale gdy ostatni wiederganger padł, widzisz, jak światło jaśnieje, a zapach ziemi pod stopami wraca do naturalnego porządku. Skoro to miejsce spoczęło, czas ruszać do %objective2%. | Zwycięstwo było ciężko wywalczone. Wiedergangerzy i osobliwości starszych nieumarłych zasłaniają pole. Masz nadzieję, że %objective2% będzie łatwiejsze do uporządkowania, ale wątpisz. | Przechodzisz nad ciałem pradawnego nieboszczyka. Jest tak różny od ciebie, że mógłby być obcy wszelkiemu życiu, jakie znasz. Czaszka jest dziwnie ukształtowana, jakby skurczony poprzednik twojej, a zbroje i broń wyglądają nie z tego świata.\n\nPrzygotowujesz ludzi na marsz do %objective2%. | Ziemia usłana jest rozkładającymi się zwłokami nieumarłych. Przechodzisz po ich ciałach, czując, jak grunt pod stopami wraca do życia, jakby gleba wychodziła z ukrycia, a powietrze staje się łatwiejsze do oddychania. Być może zło naprawdę opuściło to miejsce? Tak czy inaczej, czas ruszać do %objective2% i potraktować je po przyjacielsku, jak to %companyname% potrafi. | Gdy ostatni z nieumarłych padł, rozglądasz się po polu. Zmarli nie pochodzą z jednego źródła, sądząc po różnorodności ubiorów i zbroi, ale też nie z jednej epoki. Niektórzy noszą zbroje starożytnych i niosą ze sobą niepokojącą jednolitość w wysiłku zabijania.\n\n%randombrother% podchodzi, mówiąc, że kompania jest gotowa ruszyć do %objective2%, kiedy tylko chcesz.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{Zwycięstwo! | I nie ważcie się już wstawać!}",
					function getResult()
					{
						this.Contract.getActiveState().start();
						this.World.Contracts.updateActiveContract();
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Aftermath2",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_46.png[/img]{%objective2% leży w ruinie, ale z twojej perspektywy wygląda lepiej niż kiedykolwiek. Najlepiej wrócić do %employer% po nagrodę. | Dałeś %objective2% słuszną nauczkę, wyrwałeś je z objęć nieumarłych i przywróciłeś światu żywych. Już widzisz, jak trawa i drzewa ożywają, a wiatr przynosi rześkość. Najlepiej donieść o tym %employer% i odebrać zapłatę. | Mrok, który tkwił w %objective2%, został zniszczony. No, z wyjątkiem tych kieszeni istnienia pod gruzem. Wciąż trochę ciemności, ale bardziej z braku światła niż obecności zła. Tak czy inaczej, powinieneś powiedzieć %employer%owi, co zrobiłeś. | %objective2% wygląda znacznie lepiej, gdy %companyname% stoi zwycięsko nad ruinami. Wydaje ci się, że malarz powinien to uwiecznić. %randombrother% wygląda szczególnie dobrze, miażdżąc czaszki wiedergangerów butami. Ale zapłata od %employer%a wyglądałaby jeszcze lepiej. Lepiej do niego wrócić. | %objective2% zostało zniszczone i wraz z nim zło opuściło te ziemie. Oby na dobre, choć istnieje szansa, że przeniosło się do innego słabego miejsca. A skoro o tym mowa, najlepiej wrócić do %employer% po zapłatę. | %objective2% zrównano z ziemią, a całe zło, które je zamieszkiwało, odeszło. Powietrze jest lżejsze, świeższe. %employer% powinien się ucieszyć, słysząc o twoich dokonaniach. | %companyname% stoi zwycięsko, zła %objective2% uśpione lub wypędzone, być może do innego miejsca. Cyniczna część ciebie ma nadzieję na to drugie, bo wtedy jakiś szlachcic zleci ci kolejne wypędzanie i znów zarobisz. Gdy w głowie krąży ci myśl o kręceniu takiego interesu, %randombrother% podchodzi i pyta, czy czas wracać do %employer%. Kiwasz głową. Krok po kroku. | %objective2% i wszyscy jego ponurzy mieszkańcy padli pod ostrzem. Dziwnie patrzeć na pole bitwy zasłane martwymi - od świeżych ciał wiedergangerów po zakurzone pancerze pradawnych. Te trupy mają więcej różnorodności niż antykwariat.\n\nGdy kompania nasyci się łupami, powinna wrócić do %employer% po zapłatę. | Martwi wiedergangerzy i pradawni leżą wszędzie. Martwe-nieumarłe, dziwne określenie na zabicie zła ponad twoją miarę. Ale są zabici, co dowodzi, że potwory da się powstrzymać. Szykujesz kompanię do powrotu do %employer% po porządną zapłatę. | %objective2% zostało zniszczone, co dowodzi, że nawet ożywieni zmarli nie unikną dokładnego zniszczenia, jakie %companyname% niesie na pole bitwy. Gdy zło ustępuje, czujesz powrót ładu i natury. Powietrze uderza w nos rześkością. Nad głową śmigają ptaki. I to małe, nie tylko myszołowy szukające żeru.\n\nKażesz kompanii złupić, co się da, i szykować powrót do %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{Zwycięstwo! | Czas wrócić do %townname%.}",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Necromancers",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_76.png[/img]{Dostrzegasz w oddali nekromantów. Bez wątpienia to oni odpowiadają za wiele zła trapiącego te ziemie. Nie możesz pozwolić im uciec! | %randombrother% podchodzi do ciebie, spocony na twarzy.%SPEECH_ON%Panie, wypatrzyliśmy kilku podejrzanych ludzi, biegną tamtędy.%SPEECH_OFF%Bierzesz lunetę i widzisz, jak po horyzoncie, niczym mrówki po kopcu, biegnie kilku mężczyzn w szarych szatach, a za nimi ciągnie się chmura chorobliwej mgły. Klepiesz najemnika po ramieniu.%SPEECH_ON%Dobre oko. Powiedz ludziom, że mamy nekromantów do upolowania.%SPEECH_OFF% | Bierzesz lunetę i przeczesujesz okolicę. Ku zaskoczeniu widzisz kilka postaci biegnących w oddali, które raz po raz się oglądają, jakbyś je ścigał. Zbliżasz obraz i dostrzegasz ciemne szaty, blade twarze, białe brody, sztylety z kultowymi rzeźbieniami... nekromanci! Trzeba ich schwytać i zabić, by naprawdę oczyścić te ziemie z zła. | %randombrother% melduje, że widziano kilku dziwnych mężczyzn uciekających przed %companyname%. Wzruszasz ramionami i mówisz, że to normalne, gdy ściga ich najemna banda. Kiwa głową, po czym dodaje.%SPEECH_ON%Jasne, ale to byli poszarzali faceci w czarnych płaszczach i jestem pewien, że mieli przy sobie kilka naprawdę martwo wyglądających trupów.%SPEECH_OFF%To opis nekromanty, jeśli kiedykolwiek był jakiś opis. Kompania powinna ich dopaść, zanim uciekną! | Gdy przeglądasz mapy, %randombrother% przychodzi ze zwiadem.%SPEECH_ON%Mamy nekromantów, panie. Starzy, dziwne bronie, świecące oczy, kilku trupich kumpli, pełen zestaw.%SPEECH_OFF%Jeśli to naprawdę nekromanci, to zapewne odpowiadają za sporą część zła na tych ziemiach i trzeba ich wytępić jak najszybciej. | Nekromanci! Jęczący, skradający się ludzie, przemierzający ziemię pod osłoną trupów i innych \"przyjaciół\". Trzeba ich natychmiast dopaść! | Nekromanci! Praktycy mrocznych sztuk, z pewnością częściowo odpowiedzialni za zło, które infekuje te ziemie. Trzeba ich wytropić i zabić! | %randombrother% podaje ci lunetę. Szybko potwierdzasz jego raport: w oddali są nekromanci, pędzą przez pobliską dolinę i bez wątpienia próbują umknąć %companyname%. Składasz lunetę i każesz najemnikowi przygotować ludzi. Nekromantów trzeba dopaść i zabić jak najszybciej!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Za nimi!",
					function getResult()
					{
						local tile = this.Contract.m.Objective2.getTile();
						local banner = this.Contract.m.Objective2.getBanner();
						this.Contract.m.Objective2.die();
						this.Contract.m.Objective2 = null;
						local playerTile = this.World.State.getPlayer().getTile();
						local camp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getNearestSettlement(playerTile);
						local party = this.World.FactionManager.getFaction(camp.getFaction()).spawnEntity(tile, "Nekromanci", false, this.Const.World.Spawn.UndeadScourge, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
						party.getSprite("banner").setBrush(banner);
						party.setFootprintType(this.Const.World.FootprintsType.Undead);
						party.getSprite("body").setBrush("figure_necromancer_01");
						party.setSlowerAtNight(false);
						party.setUsingGlobalVision(false);
						party.setLooting(false);
						this.Const.World.Common.addTroop(party, {
							Type = this.Const.World.Spawn.Troops.Necromancer
						}, false);
						this.Const.World.Common.addTroop(party, {
							Type = this.Const.World.Spawn.Troops.Necromancer
						}, true);
						this.Contract.m.UnitsSpawned.push(party);
						this.Contract.m.Target = this.WeakTableRef(party);
						party.setAttackableByAI(true);
						party.setFootprintSizeOverride(0.75);
						local c = party.getController();
						c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
						local roam = this.new("scripts/ai/world/orders/roam_order");
						roam.setPivot(camp);
						roam.setMinRange(1);
						roam.setMaxRange(10);
						roam.setAllTerrainAvailable();
						roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
						roam.setTerrain(this.Const.World.TerrainType.Shore, false);
						roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
						c.addOrder(roam);
						this.Contract.getActiveState().start();
						this.World.Contracts.updateActiveContract();
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "NecromancersFail",
			Title = "W trakcie podróży...",
			Text = "[img]gfx/ui/events/event_36.png[/img]{Ślad nekromantów zgasł. Gdyby tylko istniała siła, która potrafi go ożywić. | Nie zdołałeś dogonić nekromantów. Nie masz pojęcia, dokąd uciekli, ale nie ma wątpliwości, że zabrali ze sobą swoje zło. | Jak? Jak mogłeś pozwolić nekromantom uciec? Teraz są wolni i mogą szerzyć swoje zło, gdzie tylko zechcą.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nie, nie, nie!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Nie zdołałeś zniszczyć twierdz nieumarłych");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "NecromancersAftermath",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Nekromanci zostali zniszczeni. Zło, które mieli w sercach, zostało obnażone ostrzem. Nie będą już nawiedzać tych ziem. | Nekromanci leżą martwi, w końcu dołączając do trupów, z których tak nieodpowiedzialnie rekrutowali armie. | Patrzysz na nekromantę, przyglądając się człowiekowi, który tak okrutnie wskrzeszał zmarłych do walki. Jego usta są wciąż wykrzywione, jakby gotowe wyszeptać kolejną plugawą inkantację. Na szczęście to już koniec. Bo jakkolwiek okrutny, to tylko człowiek. | Patrzysz na wychudzoną, upiorną twarz nekromanty. %randombrother% podchodzi i pluje, trafiając wprost w policzek trupa.%SPEECH_ON%Do diabła z nimi, mnie nie straszą.%SPEECH_OFF%Kiwasz głową. Gdy ślina spływa po twarzy nekromanty, widzisz, jak jego oczy na moment błyskają czerwienią. Uznajesz, że lepiej nie mówić o tym najemnikowi. | Nekromanci zostali zabici, choć światło w ich oczach niepokojąco wolno gaśnie. %randombrother% wciąż wygląda na dumnego z bitwy.%SPEECH_ON%Popatrz na nich. Same trupy i gówno.%SPEECH_OFF%Pochyla się, opiera dłonie na kolanach i krzyczy w twarz trupa, jakby był głuchy.%SPEECH_ON%A gdzie wasi martwi kumple? Hmm? No właśnie, teraz sam jesteś martwy! Co za szkoda!%SPEECH_OFF%Mówisz mu, żeby się uspokoił, na wypadek gdyby ci mroczni magowie mieli moce poza grobem. | Plugawi ludzie zostali zabici. Nie dziwi, że martwy nekromanta wygląda jak zwykły nekro-człowiek. | Nekromanci zostali pokonani, a ich złe rządy nad tymi ziemiami odeszły w niepamięć. Bez wątpienia wykonałeś dobrą robotę, niszcząc część zła trapiącego te ziemie.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "O jedno zmartwienie mniej.",
					function getResult()
					{
						this.Flags.set("IsNecromancers", false);
						this.Flags.set("IsNecromancersSpawned", false);
						this.Flags.set("ObjectivesDestroyed", this.Flags.get("ObjectivesDestroyed") + 1);
						this.Contract.m.Target = null;

						if (this.Flags.get("ObjectivesDestroyed") == 2)
						{
							this.Contract.setState("Return");
						}
						else
						{
							this.Contract.getActiveState().start();
							this.World.Contracts.updateActiveContract();
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Bandits",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{Zmierzając ku %objective%, natykasz się na grupę rozbójników. Odwracają się i dobywają broni, a %companyname% robi to samo. Wyciągasz dłoń, a przywódca włóczęgów robi to samo, rozładowując napięcie. Przywódca mówi.%SPEECH_ON%Łup jest nasz, byliśmy tu pierwsi i, jeśli odważysz się walczyć o niego z nami, będziemy tu też ostatni!%SPEECH_OFF%Wygląda na to, że chcą tylko splądrować to miejsce. Do tego potrzebują zabić sporo wiedergangerów, co na pewno pomoże. Może połączycie siły? Cokolwiek wybierzesz, decyduj szybko, bo nieumarli są tuż obok! | Grupa rozbójników szykuje się do ataku na %objective%! Dobywają broni i grożą atakiem, ale przez chwilę pertraktujesz, wyłapując, że chcą tylko złupić skład. Może %companyname% połączy z nimi siły? Albo do diabła z tym, zabij wszystko - nieumarłych i rozbójników - i weźcie łup i chwałę dla siebie. | Gdy zbliżasz się do %objective%, natykasz się na grupę rozbójników. Szykują się do ataku - nie na %companyname%, lecz na sam skład. Wygląda na to, że interesuje ich tylko łup, i będą z tobą walczyć o niego. Możesz do nich dołączyć kosztem potencjalnych łupów albo po prostu wybić wszystkich i zabrać złoto i chwałę. Wybieraj szybko, bo nieumarli są tuż obok! | Rozbójnicy! Grupa dobrze uzbrojonych, gotowych do ataku. Na szczęście celują w samo %objective%. Może %companyname% połączy z nimi siły, ale włóczędzy będą chcieli dużej części łupów. Druga opcja to zabić wszystkich i zgarnąć wszystko dla siebie. Wybieraj szybko, bo nieumarli są tuż obok! | Natykasz się na kilku dobrze uzbrojonych mężczyzn. Szybko odwracają się do ciebie z dobytymi broniami. %randombrother% dobywa ostrza i grozi, że zabije pierwszego, który się ruszy. Mimo napięcia tobie i przywódcy włóczęgów udaje się uspokoić sytuację i porozmawiać. Wyjaśnia, że przyszli splądrować %objective% i zabrać cały łup. Możesz złączyć siły ze złodziejami albo, jeśli chcesz wszystko dla siebie, po prostu zabić ich i wiedergangerów. | %randombrother% idzie się odlać, ale odskakuje od krzaków, jedną ręką poprawia spodnie, drugą sięga po broń. Z zarośli wychodzi rozbójnik z już dobytym ostrzem, a wkrótce wyłania się ich więcej, krzyczą, a %companyname% odpowiada tym samym. Przywódca wychodzi z uniesionymi dłońmi i prosi o rozmowę z przywódcą.\n\nW rozmowie dowiadujesz się, że to banda poszukiwaczy skarbów chcąca splądrować %objective%. Możesz z nimi współpracować i walczyć z nieumarłymi, ale jeśli nie, będą walczyć zarówno z wami, jak i z nieumarłymi, bo nie przyszli dzielić się łupem z najemnikami.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Mamy wspólny cel. Zaatakujmy, razem!",
					function getResult()
					{
						this.Flags.set("IsBanditsCoop", true);
						this.Contract.m.Current.getLoot().clear();
						this.Contract.m.Current.setDropLoot(false);
						this.Contract.getActiveState().onCombatWithPlayer(this.Contract.m.Current, false);
						return 0;
					}

				},
				{
					Text = "Nie przybyliśmy tu, by dzielić się  łupami. To wasz koniec!",
					function getResult()
					{
						this.Flags.set("IsBandits3Way", true);
						this.Contract.getActiveState().onCombatWithPlayer(this.Contract.m.Current, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BanditsAftermathCoop",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{Zło w tym miejscu zostało zgładzone. Po podziale łupów z rozbójnikami szykujesz się do marszu ku %objective2%, upewniając się, by im o nim nie wspominać. | Gdy ostatni z nieumarłych zostaje położony do spoczynku, czujesz, że powietrze się oczyszcza, jakby dymna mgła ustępowała rześkim, wiosennym zapachom. Ta szybka zmiana bez wątpienia oznacza, że oczyściłeś to miejsce zła. Dzielisz łup z rozbójnikami. Są zbyt zadowoleni z siebie, twierdząc, że bez nich byście nie przeżyli. Prawie powiedziałeś im o %objective2%, ale ten wybuch źle ulokowanej dumy psuje wszelką chęć dalszej współpracy. | Zło tego miejsca zostało uśpione. %objective2% czeka.\n\nDzielisz łup z rozbójnikami, którzy chętnie robią z tobą interesy. Nie mówią tego wprost, ale widać, że bez ciebie zostaliby wybici do nogi. | Gdy okropne miejsce oczyszczone ze zła, na kontrakcie pozostało tylko %objective2%. Rozbójnicy biorą swoją część łupu, jak ustalono. Pytają, dokąd idziesz, a ty mówisz, że to nie ich sprawa. | Gdy ostatni wiederganger zostaje położony do spoczynku, czujesz nagłą zmianę w powietrzu. Czystość uderza w płuca z niespodziewaną klarownością, choć stoisz pośród błota i zgnilizny. %randombrother% ociera czoło.%SPEECH_ON%To już chyba koniec. W drogę do %objective2%?%SPEECH_OFF%Gdy rozbójnik podchodzi, mówisz najemnikowi, by się uciszył. Lepiej nie informować tych drani o kolejnym miejscu. Mimo dużej części łupu, byli raczej żadną pomocą. | Wkroczyłeś w domenę zła, ale gdy ostatni wiederganger padł, widzisz, jak światło jaśnieje, a zapach ziemi pod stopami wraca do naturalnego porządku. Skoro to miejsce spoczęło, czas ruszać do %objective2%.\n\nPrzywódca rozbójników podchodzi. W dłoni ma zwój i notuje podział łupów.%SPEECH_ON%Dobrze się z tobą biło, najemniku.%SPEECH_OFF%Mówisz mu, że jego banda idiotów poszłaby na rzeź, gdybyś się nie pojawił. Wzrusza ramionami.%SPEECH_ON%Nikt nie jest doskonały. Do następnego?%SPEECH_OFF%Ignorujesz go i idziesz zebrać ludzi. | Zwycięstwo było ciężko wywalczone. Wiedergangerzy i osobliwości starszych nieumarłych zasłaniają pole. Rozbójnicy, z którymi się sprzymierzyłeś, grzebią w szczątkach, biorąc swoją część łupu, jak ustalono. Masz nadzieję, że %objective2% będzie łatwiejsze do uporządkowania, ale wątpisz. | Rozbójnicy przeszukują pole i zbierają łupy, które zgodnie z umową mają być ich udziałem. Mówisz %randombrother%, by po cichu szykował ludzi do marszu na %objective2%. Pyta, czemu po cichu, a ty odpowiadasz.%SPEECH_ON%Bo ostatnia rzecz, której potrzebujemy, to te bezużyteczne szczurofarki, które wpadną na kolejną bitwę i zabiorą łupy, na które nie zasłużyli.%SPEECH_OFF%Najemnik kiwa głową.%SPEECH_ON%Chciałem powiedzieć, że ująłeś mi to z ust, ale w tej nienawiści byłeś dość kreatywny, panie.%SPEECH_OFF% | Zaczynasz szykować ludzi do marszu na %objective2%.\n\nPrzywódca rozbójników podchodzi do ciebie.%SPEECH_ON%Dobrze się z tobą biło. Dokąd teraz? Więcej skarbów, co?%SPEECH_OFF%Odwracasz się i chwytasz go za koszulę.%SPEECH_ON%Myślę, że obaj wiemy, kto w tej walce odwalił robotę. Zabierasz swój łup i znikasz. Tak się umówiliśmy. Jeśli pójdziesz za nami, przetopimy wszystko, co ukradłeś, i wylejemy ci na łeb, jasne?%SPEECH_OFF%Co fa się, nerwowo kiwając głową, jakbyś miał spełnić tę obietnicę w tej samej chwili. | Gdy ostatni z nieumarłych padł, rozglądasz się po polu. Zmarli nie pochodzą z jednego źródła, sądząc po różnorodności ubiorów i zbroi, ale też nie z jednej epoki. Niektórzy noszą zbroje starożytnych i niosą ze sobą niepokojącą jednolitość w wysiłku zabijania.\n\n%randombrother% podchodzi, mówiąc, że kompania jest gotowa ruszyć do %objective2%, kiedy tylko chcesz. Przywódca rozbójników przerywa.%SPEECH_ON%Cóż, najpierw dzielimy łup, prawda?%SPEECH_OFF%Kiwasz głową. Tak się umówiliście.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zwycięstwo!",
					function getResult()
					{
						this.Flags.set("IsBanditsCoop", false);

						if (this.Flags.get("ObjectivesDestroyed") == 2)
						{
							this.Contract.setState("Return");
						}
						else
						{
							this.Contract.getActiveState().start();
							this.World.Contracts.updateActiveContract();
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BanditsAftermath3Way",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Znajdujesz przywódcę rozbójników martwego wśród ciał. Na twarzy ma żal, większy niż zwykle u kogoś, kto właśnie sam wybrał swój gorzki koniec. Cóż, szkoda. Zbierasz ludzi, by szykować marsz do %objective2%. | Przywódca rozbójników leży martwy. Pół twarzy mu brakuje, a resztę wciąga paszcza pobliskiego wiedergangera. Co za szkoda. Czas ruszać do %objective2%. | Z nieumarłymi się uporano, tak samo z idiotycznymi rozbójnikami, którzy uznali, że mogą stanąć przeciw %companyname%. Teraz pozostało już tylko %objective2%. | Rozbójnicy źle wybrali, walcząc i z nieumarłymi, i z %companyname%. Zaskakująco, nie poszło im dobrze. Każesz ludziom zebrać cały łup i przygotować się do marszu na %objective2%. | Gdy ostatni z nieumarłych zostaje położony do spoczynku, czujesz, że powietrze się oczyszcza, jakby dymna mgła ustępowała rześkim, wiosennym zapachom. Ta szybka zmiana bez wątpienia oznacza, że oczyściłeś to miejsce zła. Niestety sterta martwych rozbójników będzie trochę śmierdzieć. Cóż. Teraz oczyścić %objective2% i skończyć kontrakt. | Zło tego miejsca zostało uśpione. Rozbójnicy też, biedne głupki. %objective2% czeka. | Gdy ostatni wiederganger padł, a obok niego ostatni głupi złodziej, czujesz przypływ sił. Częściowo to radość z pokazania rozbójnikom, jak okropnego mieli przywódcę, który zaprowadził ich na śmierć. Reszta to uczucie ulgi po odejściu zła. Czas ruszać do %objective2%. | Zwycięstwo było ciężko wywalczone. No, nieumarli stawili dobry opór. Rozbójnicy zginęli jak idioci. Masz nadzieję, że %objective2% będzie łatwiejsze do uporządkowania, ale jeśli nie jest pełne tępych złodziejaszków zamiast zła, to wątpisz. | Znajdujesz przywódcę rozbójników rozrzuconego na zwłokach wiedergangera. %randombrother% podchodzi i śmieje się.%SPEECH_ON%Wygląda na to, że byli sobie przeznaczeni.%SPEECH_OFF%Śmiejąc się, mówisz mu, by szykował ludzi do marszu na %objective2%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Dobrze im tak.",
					function getResult()
					{
						this.Flags.set("IsBandits3Way", false);

						if (this.Flags.get("ObjectivesDestroyed") == 2)
						{
							this.Contract.setState("Return");
						}
						else
						{
							this.Contract.getActiveState().start();
							this.World.Contracts.updateActiveContract();
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% wita cię w swojej komnacie z rozmachem wzniesionych kufli i wiwatujących dziewek. To żywy widok jak na świat pełen chodzących trupów. Bardzo pijany szlachcic wręcza ci %reward_completion% koron i jeden z jego strażników wyprowadza cię na zewnątrz. | Wchodzisz do komnaty %employer%a i widzisz mężczyznę oraz kobietę stojących nad stołem. Leży na nim bardzo blade dziecko i nie porusza się. Matka milczy, a jej twarz krzyczy sama. Przerywasz ponury nastrój, meldując szlachcicowi, że zadanie wykonane. Kiwa głową.%SPEECH_ON%Wiem. Krążyły plotki, że po twoim powrocie zgaszone zło może przywrócić życie tej ziemi. Ziemia jest żyźniejsza niż kiedykolwiek, ale zmarli wciąż pozostają martwi. Zapłata leży w rogu, najemniku.%SPEECH_OFF%Idziesz po swoje %reward_completion% korony. %employer% wciąż pociesza kobietę, gdy wychodzisz. | Strażnik prowadzi cię do jednej z kryjówek %employer%a, kwadratowego miejsca, bardziej komórki niż komnaty. Szlachcic ma nos w zwoju, ale zrywa się, gdy cię widzi.%SPEECH_ON%Najemniku! Spodziewałem się cię! Wejdź, wejdź.%SPEECH_OFF%Odkłada zapiski i podnosi sakwę z podłogi.%SPEECH_ON%%reward_completion% koron, jak ustalono. Wieści mówią, że zło opuściło te ziemie. Nie jestem tego pewien, ale nie ma wątpliwości, że twoje zwycięstwo zapewniło nam choćby przewagę w tej wojnie. Dobra robota, najemniku.%SPEECH_OFF% | %employer% zaprasza cię do pokoju jedną ręką, a drugą wyciąga worek z koronami.%SPEECH_ON%Nie musisz mi zdawać raportu, najemniku, bo moje ptaszki już wszystko mi powiedziały. Zapłata, jak ustalono.%SPEECH_OFF% | %employer% wita cię ciepło, choć w rogu kuli się sępolicy skryba, zły jak większy padlinożerca przepędzający go od strawy. Zdajesz raport, ale szlachcic macha ręką.%SPEECH_ON%Och, najemniku, wiem o wszystkim, co dzieje się na tych ziemiach. Zasłużyłeś na %reward_completion% koron.%SPEECH_OFF%Skryba odzywa się, płosząc %employer%a.%SPEECH_ON%Zaiste, zło zostało zrujnowane, a wszelkie dobro może rosnąć! A teraz, najemniku, odejdź. Mamy tu ważne rzeczy do omówienia.%SPEECH_OFF%Hmm, tak, oczywiście. Bierzesz zapłatę i odchodzisz. | Znajdujesz %employer%a w stajniach. Boksy są puste, a chłopców stajennych nie ma. Widząc cię, szybko potrząsa twoją dłonią.%SPEECH_ON%Tak się cieszę, że cię widzę, najemniku. Już dostałem wieści o twoim sukcesie. Zrzuciłeś kajdany zła z tych ziem i dałeś im nowe życie i witalność. Przynajmniej na razie. Idź do tamtego strażnika, zaprowadzi cię do skarbnika po %reward_completion% koron, które ci się należą.%SPEECH_OFF% | Znajdujesz %employer%a stojącego nad świeżo zasypanym grobem. Kilku grabarzy siedzi obok i dzieli się bukłakiem wody. Szlachcic wzrusza ramionami.%SPEECH_ON%Ciało zostało w ziemi. A więc nie tylko zniszczyłeś źródła zła, najemniku, ale możliwe, że całkiem wypędziłeś część z niego z tych ziem. Oby bogowie tak chcieli. Zapłata jest u skarbnika. Będzie miał dla ciebie %reward_completion% koron, jak obiecano.%SPEECH_OFF% | Zastajesz %employer%a rozmawiającego z aptekarzem. Uzdrowiciel ma wózek z ostrymi narzędziami, część zanurzona w miednicy z czerwoną wodą. Spoglądając na szlachcica, widzisz, że niedawno zaszyto mu ramię. Macha ci ręką.%SPEECH_ON%Polowanie na dzika poszło źle, najemniku.%SPEECH_OFF%Uzdrowiciel sprząta i odchodzi, każąc szlachcicowi odpocząć tydzień.%SPEECH_ON%Tak, tak, ale mam sprawy do załatwienia. Po pierwsze, ty, najemniku. Zapłata jest w rogu, %reward_completion% koron, jak obiecano. Kto wie, czy zło nieumarłych naprawdę zostało wypędzone z tych ziem, ale zrobiłeś to, o co prosiłem.%SPEECH_OFF% | Gdy wchodzisz, %employer% rozmawia z kobietą. Wypowiada najdziwniejsze zdanie, jakie słyszałeś od dawna.%SPEECH_ON%Mój mały chłopiec został w ziemi! Nie wrócił! Jestem taka szczęśliwa! Został martwy!%SPEECH_OFF%Szlachcic trzyma jej dłonie ciepło i kiwa głową w twoją stronę.%SPEECH_ON%A tam stoi człowiek odpowiedzialny za wypędzenie zła z tych ziem. Zasłużyłeś na %reward_completion% korony, najemniku!%SPEECH_OFF% | Widzisz %employer%a bawiącego się z kudłatym szczeniakiem. Drepcze po śliskiej posadzce, goniąc patyk. Szlachcic rzuca patyk pod twoje stopy, a szczeniak skacze, uderzając w twoje buty.%SPEECH_ON%Tamtego dnia pies nawet nie drgnął, a teraz nie może przestać się bawić. Gdybym był hazardzistą, postawiłbym, że ma to coś wspólnego z tobą i tymi nieumarłymi, najemniku. Dobra robota. Zapłata to %reward_completion% koron, jak obiecano, albo możesz wziąć szczeniaka.%SPEECH_OFF%Mówisz, że weźmiesz szczeniaka. Szlachcic cofa się zaskoczony.%SPEECH_ON%Nie, weźmiesz korony. Szczeniak zostaje ze mną.%SPEECH_OFF%Hau. | Wchodzisz do komnaty %employer%a i widzisz, jak wpatruje się przez okno. Mówi z łagodną szczerością.%SPEECH_ON%Życie. Wszystko takie żywe.%SPEECH_OFF%Odwraca się, pokazując sakwę w dłoni. Podchodzi i wręcza ci ją.%SPEECH_ON%%reward_completion% powinno być w środku. Dobra robota z nieumarłymi, najemniku, i niech twoje usługi przybliżą nas o krok do końca tego zła.%SPEECH_OFF% | %employer% wita cię bukłakiem wina. Ma metaliczny posmak, ale wiesz, że nie powinieneś tego komentować. Szlachcic maszeruje sprężyście do biurka.%SPEECH_ON%Dobra robota, najemniku. Kto wie, co stałoby się z tymi ziemiami, gdyby nie tacy ludzie jak ty. Modlę się do starych bogów, by pewnego dniaśmy byli całkowicie wolni od tego zła!%SPEECH_OFF% | Strażnik spotyka cię przed komnatą %employer%a. Zerka na ciebie, szczególnie na znak %companyname% na ramieniu.%SPEECH_ON%Proszę, najemniku. %employer% jest bardzo zajęty, ale kazał przekazać podziękowania.%SPEECH_OFF%Wręcza ci %reward_completion% koron. | Blady skarbnik o gładkiej skórze wita cię na korytarzu do komnaty %employer%a. Niesie sakwę koron i szybko ją podaje.%SPEECH_ON%Zapłata jest w środku, jak uzgodniono. Mój pan jest teraz bardzo zajęty swoimi skrybami, by lepiej rozwiązać ten okropny problem nieumarłych.%SPEECH_OFF% | Zastajesz %employer%a podczas golenia, a zmęczona i posępna kobieta trzyma mu lustro.%SPEECH_ON%Ho, najemniku. Ała. Hej.%SPEECH_OFF%Uderza brzytwą o miednicę z wodą, po czym śpieszy do biurka.%SPEECH_ON%Moje ptaszki już opowiedziały mi o twoich czynach. I co więcej, wszyscy zdają się mieć się lepiej! Dzieci znów się śmieją, słońce świeci jasno, a plony ponoć rosną silne! Wszyscy są szczęśliwi!%SPEECH_OFF%Kobieta pyta, czy może odłożyć lustro. Szlachcic pstryka palcami.%SPEECH_ON%Cicho, ty. A teraz, najemniku, %reward_completion% koron, jak ustaliliśmy.%SPEECH_OFF% | Nie znajdujesz %employer%a w jego komnacie, tylko w zaciemnionym pomieszczeniu, gdzie skąpe świece dają światło. W tej wilgotnej, ociekającej sali wisi na łańcuchach mężczyzna. Po twarzy widać, że wolałby wisieć na sznurze. Szlachcic stoi z rękami za plecami, podczas gdy postać w czarnym kapturze niezdecydowanie przesuwa palcem po tacy z ostrzami. Kaszlesz. %employer% odwraca się gwałtownie.%SPEECH_ON%Ach tak, najemniku! Spodziewałem się ciebie! Proszę, %reward_completion% koron, jak obiecano. Oby nieumarli tym razem trzymali się z daleka. Ale cokolwiek się stanie, wykonałeś ogrom pracy w wykorzenianiu zła z tego świata.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Zniszczyłeś twierdze nieumarłych");
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
			"objective1",
			this.m.Flags.get("Objective1Name")
		]);
		_vars.push([
			"objective2",
			this.m.Flags.get("Objective2Name")
		]);
		local distToObj1 = this.m.Objective1 != null && !this.m.Objective1.isNull() && this.m.Objective1.isAlive() ? this.m.Objective1.getTile().getDistanceTo(this.World.State.getPlayer().getTile()) : 9999;
		local distToObj2 = this.m.Objective2 != null && !this.m.Objective2.isNull() && this.m.Objective2.isAlive() ? this.m.Objective2.getTile().getDistanceTo(this.World.State.getPlayer().getTile()) : 9999;

		if (distToObj1 < distToObj2)
		{
			_vars.push([
				"objective",
				this.m.Flags.get("Objective1Name")
			]);
		}
		else
		{
			_vars.push([
				"objective",
				this.m.Flags.get("Objective2Name")
			]);
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Objective1 != null && !this.m.Objective1.isNull() && this.m.Objective1.isAlive())
			{
				this.m.Objective1.getSprite("selection").Visible = false;
				this.m.Objective1.setOnCombatWithPlayerCallback(null);
			}

			if (this.m.Objective2 != null && !this.m.Objective2.isNull() && this.m.Objective2.isAlive())
			{
				this.m.Objective2.getSprite("selection").Visible = false;
				this.m.Objective2.setOnCombatWithPlayerCallback(null);
			}

			if (this.m.Target != null && !this.m.Target.isNull() && this.m.Target.isAlive())
			{
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Current = null;
			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isUndeadScourge())
		{
			return false;
		}

		if (this.m.IsStarted)
		{
			if (this.m.Objective1 == null || this.m.Objective1.isNull() || !this.m.Objective1.isAlive())
			{
				return false;
			}

			if (this.m.Objective2 == null || this.m.Objective2.isNull() || !this.m.Objective2.isAlive())
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
		if (this.m.Objective1 != null && !this.m.Objective1.isNull())
		{
			_out.writeU32(this.m.Objective1.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.Objective2 != null && !this.m.Objective2.isNull())
		{
			_out.writeU32(this.m.Objective2.getID());
		}
		else
		{
			_out.writeU32(0);
		}

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
		local obj1 = _in.readU32();

		if (obj1 != 0)
		{
			this.m.Objective1 = this.WeakTableRef(this.World.getEntityByID(obj1));
		}

		local obj2 = _in.readU32();

		if (obj2 != 0)
		{
			this.m.Objective2 = this.WeakTableRef(this.World.getEntityByID(obj2));
		}

		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});

