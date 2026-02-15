this.hunting_serpents_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_serpents";
		this.m.Name = "Polowanie na Węże";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
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
					"Zapoluj na Węże w pobliżu " + this.Contract.m.Home.getName()
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					if (this.Const.DLC.Lindwurm && this.Contract.getDifficultyMult() >= 1.15 && this.World.getTime().Days >= 30)
					{
						this.Flags.set("IsLindwurm", true);
					}
				}
				else if (r <= 20)
				{
					this.Flags.set("IsCaravan", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = i )
				{
					if (i == this.Const.World.TerrainType.Oasis)
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
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 14, disallowedTerrain);
				local party;
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "WԄքe", false, this.Const.World.Spawn.Serpents, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.setDescription("Olbrzymie węże pełzające po okolicy.");
				party.setFootprintType(this.Const.World.FootprintsType.Serpents);
				party.setAttackableByAI(false);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(999999);
				c.addOrder(wait);
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

				this.Contract.m.BulletpointsObjectives = [
					"Zapoluj na Węże na mokradłach na %direction% od " + this.Contract.m.Home.getName()
				];
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					if (this.Flags.get("IsCaravan"))
					{
						this.Contract.setScreen("Caravan2");
					}
					else
					{
						this.Contract.setScreen("Victory");
					}

					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsBanterShown") && this.Contract.m.Target.isHiddenToPlayer() && this.Contract.isPlayerNear(this.Contract.m.Target, 700) && this.Math.rand(1, 100) <= 1 && this.Flags.get("StartTime") + 10.0 <= this.Time.getVirtualTimeF())
				{
					this.Flags.set("IsBanterShown", true);
					this.Contract.setScreen("Banter");
					this.World.Contracts.showActiveContract();
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsLindwurm"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Lindwurm");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.BeastsTracks;
						properties.EnemyBanners.push(this.Contract.m.Target.getBanner());
						properties.Entities.push({
							ID = this.Const.EntityType.Lindwurm,
							Variant = 0,
							Row = -1,
							Script = "scripts/entity/tactical/enemies/lindwurm",
							Faction = this.Const.Faction.Enemy
						});
						this.World.Contracts.startScriptedCombat(properties, true, true, true);
					}
				}
				else if (this.Flags.get("IsCaravan"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Caravan1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local f = this.Contract.m.Home.getFaction();
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "HuntingSerpentsCaravan";
						properties.Music = this.Const.Music.BeastsTracks;
						properties.EnemyBanners.push(this.Contract.m.Target.getBanner());
						properties.Entities.push({
							ID = this.Const.EntityType.CaravanDonkey,
							Variant = 0,
							Row = 3,
							Script = "scripts/entity/tactical/objective/donkey",
							Faction = f
						});

						for( local i = 0; i < 2; i = i )
						{
							properties.Entities.push({
								ID = this.Const.EntityType.CaravanHand,
								Variant = 0,
								Row = 3,
								Script = "scripts/entity/tactical/humans/conscript",
								Faction = f
							});
							i = ++i;
						}

						this.World.Contracts.startScriptedCombat(properties, true, true, true);
					}
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getType() == this.Const.EntityType.CaravanDonkey && _combatID == "HuntingSerpentsCaravan")
				{
					this.Flags.set("IsCaravan", false);
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
			Text = "[img]gfx/ui/events/event_162.png[/img]{%employer% wita cię w swojej komnacie, która ocieka luksusem - pełno tu wytworności, od jedwabi i skór, po kobiety i klejnoty. Tyle klejnotów.%SPEECH_ON%Koroniarzu, nareszcie. Mamy sprawę gospodarczą do załatwienia. Węże okrutnie nękają ludność w mokradłach %direction% stąd. A co ważniejsze, pragniemy łusek tych węży. Doskonale nadają się na...%SPEECH_OFF%Mężczyzna całuje opuszki palców.%SPEECH_ON%Torebki i buty. Spójrz na te kobiety, czyż nie widać ich pragnienia takich łusek?%SPEECH_OFF%Kobiety wpatrują się w swoje dłonie albo gawędzą między sobą. Wizyr klaszcze w dłonie.%SPEECH_ON%Torebki, moje słodkie, piękne gołąbki, torebki ze skór węży! Tak, uśmiech. No właśnie. Widzicie? To było takie trudne? Dobrze, Koroniarzu. Oferta za przyniesienie tych łusek to %reward% koron. Za taką cenę zgodzisz się podjąć tego zadania?%SPEECH_OFF% | Zastajesz %employer% głaszczącego niezwykle wysokiego ptaka o różowych piórach i długich czarnych nogach. Karmi go świerszczami, które zdają się nie robić na ptaku większego wrażenia.%SPEECH_ON%Ach, rozpieściłem cię, Mała Gołąbko.%SPEECH_OFF%Zaczyna karmić to dziwne stworzenie długimi, srebrzystymi rybami, które wyciąga żywe ze złotego wiadra. Mówi, nie patrząc na ciebie, gdy ptak połyka rybę za rybą.%SPEECH_ON%Dowiedzieliśmy się, że w mokradłach %direction% stąd przebywają węże. Ich łuski są warte niemało, oczywiście nie w złocie, lecz dla naszych wyrafinowanych gustów. Pragniemy, byś się tam udał, zagarnął te łuski do swoich plecaków i przydreptał z nimi z powrotem.%SPEECH_OFF%Mężczyzna unosi palec, jeszcze wyżej, po czym wskazuje nim płytki u swoich stóp.%SPEECH_ON%A za to zapłacimy ci %reward% koron.%SPEECH_OFF%Różowy ptak czyści pióra i zdaje się wpatrywać w ciebie zamiast swojego opiekuna. | %employer% siedzi na czymś, co wygląda jak ława w łaźni, ale jego stopy spoczywają w dłoniach kobiet leżących w czymś na kształt wewnętrznego kanału. Oddychają przez trzcinowe rurki i, z tego co widzisz, masują mu stopy. Widok jest absurdalny, ale Wizyr poświęca mu tyle samo uwagi, co tobie.%SPEECH_ON%Ach, Koroniarz przybył. Pragniemy, jak zawsze, łusek węży, którymi złocimy nasze luksusy. Te łuski są na wężach, które, hmm, tak, można znaleźć %direction% stąd. W, eee, mokradłach.%SPEECH_OFF%Mężczyzna odchyla się i na chwilę unosi palce nad wodę. Poruszają się, gdy wpatruje się w ciebie.%SPEECH_ON%Oferta to %reward% koron, czy zgadzasz się na taką piękną, uczciwą propozycję?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Jestem zainteresowany.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{To nie brzmi jak robota dla nas. | Nie takie roboty szukamy.}",
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
			Text = "[img]gfx/ui/events/event_161.png[/img]{Znajdujesz długą wylinkę zaschniętych łusek, tak grubą, że mógłbyś włożyć w nią ramię, co jest zarówno niepokojącym widokiem, jak i doznaniem. Węże z pewnością nie są daleko od tych osłon. | Zatrzymuje cię mężczyzna z zieloną tabaką w ustach. Przy pasie ma sztylet, którego rękojeść zrobiono z łusek, a głowicę wieńczy złota głowa węża.%SPEECH_ON%Łowcy węży, co? Sam bym to zrobił, jak widać po mojej fascynującej postawie i moim pysznym sztylecie, ale niestety wolę teraz patrzeć, jak robią to inni. Powiem tylko tyle: te małe węże są całkiem blisko.%SPEECH_OFF%Żegnasz się z nim najszybciej, jak się da. | Kilka dzieci bawi się w błotnistej kałuży, błoto mają po kolana i łokcie. Patrzą na ciebie i pytają, co robisz. Gdy mówisz, po co tu jesteś, dzieci śmieją się.%SPEECH_ON%Węże! To mała zwierzyna! Nie ma się czym przejmować, przynajmniej moim zdaniem.%SPEECH_OFF% | Znajdujesz stertę wężowych skór owiniętych wokół pnia drzewka z mokradeł. Węże najpewniej użyły pnia do zrzucenia łusek. A rozmiar łusek, każda większa niż grot strzały, jest dowodem, że węże są blisko.}",
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
			ID = "Victory",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_169.png[/img]{Ostatni wąż nie żyje. Stajesz na jego głowie, po czym unosisz stopę, uświadamiając sobie, że to wcale nie głowa, tylko ogon. Idziesz wzdłuż ciała aż do głowy i tam odcinasz ją jednym cięciem. Teraz jest dużo łatwiej, bo nie wije się i nie ślizga. %employer% będzie chciał, byś wrócił z głową i wszystkimi łuskami. | Obchodzisz pole, wrzucając węże do worka, którego brzuch wybrzusza się od ich masy, a nawet martwe zdają się wić w środku. Po zebraniu każdego węża szykujesz powrót do %employer%. | Wszystkie węże nie żyją, na co wskazuje ich bezruch. Na wszelki wypadek obchodzisz teren i odcinasz im głowy. Upewniwszy się, że nic nie przetrwa takich ciosów, wrzucasz węże do worka i szykujesz powrót do %employer%.}",
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
			ID = "Lindwurm",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_129.png[/img]Widzisz pierwszego węża wijącego się wokół czegoś, co wygląda na powalone drzewo z mokradeł. Gdy zbliżasz się do gada, dostrzegasz kilka kolejnych, czających się obok. I wtedy dociera do ciebie, że drzewo, które obrały, wcale nie jest drzewem: jego kłąb przesuwa się i przewraca, widzisz łuski grube jak twoja dłoń, błyszczące w świetle, a lindwurm unosi łeb i obraca go, ostre oczy zwężają się w czarną szczelinę, po czym otwiera paszczę i ryczy, a wody mokradeł falują, gdy jego ryk rozcina powierzchnię.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To Lindwurm!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Caravan1",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_149.png[/img]{Mokradła zwykle nie są domem dla karawan, więc z zaskoczeniem znajdujesz jedną, której strażnicy biegają w popłochu. Najpierw sądzisz, że rozładowują towary, że to być może bandyci, którzy dotarli do swojej tajnej kryjówki, ale gdy się zbliżasz, widzisz, jak jednego strażnika owija zwijający się, morderczy wąż i powala go. Drugi odwraca się, gdy paszcza węża zatrzaskuje się na jego głowie. Kupcy są atakowani!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ochraniać ich!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Caravan2",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_169.png[/img]{Po bitwie przełożony karawany podchodzi do ciebie osobiście.%SPEECH_ON%Dziękuję, Koroniarzu. Możesz być niewolnikiem monety, ale nie bez łańcucha czy dwóch ozdobionych tym, czego wszyscy pragniemy - poczuciem, że czyni się dobro.%SPEECH_OFF%Byłeś tu tylko po węże, a karawana była jedynie zbiegiem okoliczności, miłym dodatkiem żywej przynęty, która odciągnęła potwory od twoich ludzi. Masz zamiar mu to powiedzieć, ale ucina cię, trzymając w dłoni worek z kosztownościami.%SPEECH_ON%W nagrodę za twoją interwencję, Koroniarzu. Niech twoja droga do monety będzie zawsze bardziej złocona.%SPEECH_OFF%Kiwasz głową, ściskasz mu dłoń, po czym zajmujesz się zbieraniem łusek. Kupiec pyta, czy może zatrzymać jedną, ale kładąc dłoń na mieczu, dajesz mu do zrozumienia, że to nie jest targowisko, przy którym się zatrzymał. Rozumie.}",
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
			],
			function start()
			{
				local e = this.Math.rand(1, 2);

				for( local i = 0; i < e; i = i )
				{
					local item;
					local r = this.Math.rand(1, 3);

					switch(r)
					{
					case 1:
						item = this.new("scripts/items/trade/spices_item");
						break;

					case 2:
						item = this.new("scripts/items/trade/silk_item");
						break;

					case 3:
						item = this.new("scripts/items/trade/incense_item");
						break;
					}

					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Zdobywasz " + item.getName()
					});
					i = ++i;
				}
			}

		});
		this.m.Screens.push({
			ID = "Success",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_162.png[/img]{Tłum kobiet rzuca się na ciebie. Jest ich za wiele, a drzwi do komnaty %employer% pojawiają się i znikają, migocząc za wirującą zasłoną jedwabnych szali, trzepoczących piór, lśniącej biżuterii i ogólnego zamętu włosów delikatniejszych niż wszystkie, które dotąd widziałeś. Do tego dochodzi hałas, który porządnie rozprasza.\n\nPraktycznie zostajesz obrabowany z łusek i, będąc w siedzibie Wizyra, nie stawiasz większego oporu temu przywłaszczeniu. Gdy kobiety rozbiegają się chichocząc, na ich miejscu zostaje znacznie starsza kobieta. Wyciąga sakiewkę koron, twoją zapłatę.%SPEECH_ON%Wizyr nie życzy sobie z tobą rozmawiać, Koroniarzu. Uważa to za poniżej swojej godności.%SPEECH_OFF%Pytasz, czy dla niej również jest to poniżej godności. Kiwając głową, odpowiada.%SPEECH_ON%Tak, ale wolę znaleźć się pod zadaniem niż pod samym Wizyrem. Miłego dnia, Koroniarzu, i niech twoja droga do monety będzie złocona.%SPEECH_OFF% | Z łusek węży uwalnia cię horda pomocników. Wizyr wydaje im polecenia, wpatrzony surowo z tyłu komnaty. Gdy odchodzą, unosi dłonie i klaszcze. Czterech pomocników podchodzi, niosąc jedną sakiewkę. Myślisz, że czeka cię premia, ale gdy ją podają, bez problemu trzymasz ją sam. Zerkasz do środka i widzisz, że Wizyr uśmiecha się nieśmiało. Zabierasz %reward_completion% koron i odchodzisz. | Na włościach Wizyra łuski węży nie zostają w twoich rękach na długo. Pojawia się seria pomocników, którzy ruszają, by odciążyć cię z towaru. Wizyr jest gdzieś w pobliżu, wiesz to, pewnie obserwuje przez okno lub jakiś portal drzwiowy. Ale tak naprawdę go nie widzisz. Widzisz za to jego pieniądze, w sakiewce %reward_completion% koron wręczonej przez nieśmiałego pomocnika.%SPEECH_ON%Z naszej łaski w twoją łaskę.%SPEECH_OFF%Sługa mówi, po czym odchodzi i znika tak po prostu.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Zapolowałeś na olbrzymie węże");
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
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Target.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0 && this.Math.rand(1, 100) <= 50)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/moving_sands_situation"));
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

