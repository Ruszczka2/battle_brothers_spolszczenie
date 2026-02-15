this.hunting_lindwurms_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_lindwurms";
		this.m.Name = "Polowanie na Lindwurmy";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.m.DifficultyMult = this.Math.rand(95, 135) * 0.01;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 800 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.m.Flags.set("Bribe", this.Math.rand(300, 600));
		this.m.Flags.set("MerchantsDead", 0);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Zapoluj na lindwurmy w pobliżu " + this.Contract.m.Home.getName()
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
					this.Flags.set("IsAnimalActivist", true);
				}
				else if (r <= 25)
				{
					this.Flags.set("IsBeastFight", true);
				}
				else if (r <= 35)
				{
					this.Flags.set("IsMerchantInDistress", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 6, 12, [
					this.Const.World.TerrainType.Mountains
				]);
				local nearTile = this.Contract.getTileToSpawnLocation(playerTile, 4, 7);
				local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Lindwurm", false, this.Const.World.Spawn.Lindwurm, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.getSprite("banner").setBrush("banner_beasts_01");
				party.setDescription("Lindwurm - bezskrzydły, dwunożny smok przypominający olbrzymiego węża.");
				party.setFootprintType(this.Const.World.FootprintsType.Lindwurms);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);
				this.Const.World.Common.addFootprintsFromTo(nearTile, party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Lindwurms, 0.75);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
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
					if (this.Flags.get("IsMerchantInDistress"))
					{
						if (this.Flags.get("MerchantsDead") < 5)
						{
							this.Contract.setScreen("MerchantDistressSuccess");
						}
						else
						{
							this.Contract.setScreen("MerchantDistressFailure");
						}
					}
					else
					{
						this.Contract.setScreen("Victory");
					}

					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsBanterShown") && this.Contract.m.Target.isHiddenToPlayer() && this.Math.rand(1, 1000) <= 1 && this.Flags.get("StartTime") + 15.0 <= this.Time.getVirtualTimeF())
				{
					this.Flags.set("IsBanterShown", true);
					this.Contract.setScreen("Banter");
					this.World.Contracts.showActiveContract();
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsBeastFight"))
				{
					this.Contract.setScreen("BeastFight");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsMerchantInDistress"))
				{
					this.Contract.setScreen("MerchantDistress");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAnimalActivist"))
				{
					this.Contract.setScreen("AnimalActivist");
					this.World.Contracts.showActiveContract();
				}
				else if (!this.Flags.get("IsEncounterShown"))
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

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_combatID != "Lindwurms")
				{
					return;
				}

				if (_actor.getType() == this.Const.EntityType.CaravanDonkey || _actor.getType() == this.Const.EntityType.CaravanHand)
				{
					this.Flags.increment("MerchantsDead");
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
					if (this.Flags.get("BribeAccepted") && this.Math.rand(1, 100) <= 40)
					{
						this.Contract.setScreen("Failure");
					}
					else
					{
						this.Contract.setScreen("Success");
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
			Text = "[img]gfx/ui/events/event_77.png[/img]{%employer% wpatruje się w kosz, gdy go znajdujesz. Kilku chłopów w kącie drapie się i wygląda na spiętych. Pytasz, co się dzieje. Potencjalny zleceniodawca prowadzi cię do kosza, a w środku widzisz węża sunącego wokół. Jest spokojny, a barwy nie układają się tak, by wskazywały na jad w jego brzuchu. Mówisz mu to. Wzrusza ramionami i zamyka wieko.%SPEECH_ON%I tak go zabiję i zjem, a skórę wezmę na pochwę do sztyletu. Potrzebuję, żebyś znalazł znacznie większego węża. Mówię o lindwurmach, najemniku. Wielkich bestiach. Włóczą się, zjadają ludzi na pustkowiu. Umiesz załatwić taki kłopot?%SPEECH_OFF% | Zastajesz %employer%a grzebiącego w jego prywatnej bibliotece, w której jest więcej pajęczyn niż wiedzy. Zdaje się wyczuwać twoje wejście i pyta, czy wiesz coś o lindwurmach. Zanim zdążysz odpowiedzieć, odwraca się z zwojem w ręku.%SPEECH_ON%Musisz wyruszyć na pustkowie. Mamy na karku parę tych potworów. Zabijają rolników, handlarzy. Cholera, niektórzy z nich byli nawet lubiani. Myślę, że to ty jesteś człowiekiem, którego potrzebujemy, by zdjąć te bestie z naszych pleców. Jesteś zainteresowany?%SPEECH_OFF%Widzisz, że zwój rozwija się nieco, odsłaniając nieudolnie narysowaną kobietę i jej odsłoniętą pierś. Mężczyzna pospiesznie zwija go z powrotem i chowa za plecami. Uśmiecha się.%SPEECH_ON%No i jak?%SPEECH_OFF% | Przed drzwiami %employer%a stoi szereg chłopów. Przeciskasz się przez nich, a gdy kilku protestuje, chwytasz za rękojeść miecza. %employer% wyskakuje z drzwi i interweniuje.%SPEECH_ON%Spokojnie, spokojnie wszyscy. To najemnik, którego chciałem zatrudnić. Panie, proszę, wyjaśnię te krótkie zapłony. Lindwurmy pustoszą okolicę i potrzebujemy krzepkiego najemnika takiego jak ty, by je wszystkie zabić. Jesteś zainteresowany?%SPEECH_OFF%Niegdyś rozgniewani parobcy patrzą teraz na ciebie jak na wybawcę.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Prosisz nas o coś niebywale trudnego. | Spodziewam się sowitego wynagrodzenia za walkę z takim wrogiem. | Spodziewam się, że za cos takiego uczynisz mnie bogaczem.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Potrzebujesz raczej bohaterów i głupców. | To nie jest warte ryzyka. | Nie sądzę.}",
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
			Text = "[img]gfx/ui/events/event_66.png[/img]{%randombrother% trzyma na końcu broni rękaw łuskowatej skóry. Rusza nim, a łuszczyzna szeleści suchymi skrobnięciami. Każesz mu to odłożyć i być czujnym. Lindwurmy na pewno są blisko. | %randombrother% mówi, że słyszał kiedyś historię o lindwurmie, który zabił kogoś, nawet go nie zjadając.%SPEECH_ON%Właśnie. Mówili, że wypluł zieloną wodę, a człowiek roztopił się w swoich butach. Mówili, że wyglądał jak zupa z piszczelami do mieszania.%SPEECH_OFF%Obrzydliwa opowieść, ale miejmy nadzieję, że trzyma ludzi w gotowości. Lindwurmy nie mogą być daleko. | Ślady mają spłaszczoną trawę w wężowy wzór i dołki po bokach. %randombrother% kuca przy tych śladach.%SPEECH_ON%Albo pług bez bruzdy, albo to te paskudy, których szukamy.%SPEECH_OFF%Przytakujesz. Lindwurmy nie mogą być daleko.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Bądźcie czujni!",
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
			Text = "[img]gfx/ui/events/event_129.png[/img]{Sprawdzasz mapę, gdy %randombrother% woła. Podnosisz wzrok i widzisz, jak lindwurmy wyłaniają się z jamy w ziemi, a wielkie płaty pyłu osypują się z ich boków. Ich ciała kołyszą się nisko nad ziemią, gdy suną w stronę %companyname%. Dobijasz miecz i rozkazujesz ludziom ustawić szyk. | Kompania natyka się na jaskinię, której wejście obstawione jest głazami. Gdy się zbliżacie, kamienie rozwijają się i obracają w powietrzu, a z ich brzuchów wyrastają nogi, które lądują jako oczywiste lindwurmy. Cofasz się, gdy bestie otrzepują z grzbietów kurz i kłapią paszczami z gardłowym rechotem. Obracają się ku tobie, mrugają i zaczynają leniwie pełznąć naprzód, jakby twoi najemnicy byli tylko drobną przeszkodą. Rozkazujesz ustawić szyk. Potwory, jakby wyczuły większe zagrożenie, nagle ruszają, sycząc potężnie, a ich ciała suną po ziemi z zaskakującą szybkością. | %companyname% zbliża się do wzgórza, pod każdym krokiem chrzęszczą kości. %randombrother% ucisza kompanię i wskazuje na szczyt. Lindwurmy są zakrzywione wokół grzbietu jak haft na samej ziemi. Zdają się wyczuwać twój wzrok, więc rozwijają się i zsuwają ze zbocza, niektóre półobrotem jak dzieci turlające się po pagórku. Ich paszcze kłapią i trzaskają, języki wylizują pył z oczu, wyglądają bardziej na lunatykujące stworzenia niż mordercze potwory. Ale gdy tylko ich łapy dotykają równego gruntu, napinają się i ruszają do przodu, ich wężowe kształty przecinają cmentarzysko, a w ich śladzie unosi się pióropusz pyłu z mielonych kości. Dobijając miecz, pilnie rozkazujesz ludziom ustawić szyk.}",
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
			ID = "AnimalActivist",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_17.png[/img]{Znajdujesz lindwurmy pełzające wokół wykopu w ziemi, ale zanim ruszysz do walki, przerywa ci mężczyzna, syczący jak człowiek. Wygląda, jakby nie golił się od dni, na obu ramionach ma gruby juk, a bandana spina mu włosy jak kępkę szałwii. Poza zmęczonym wyglądem nie ma przy sobie broni. Pytasz, czego chce. Mówi szybko i półgłosem.%SPEECH_ON%Przyszedłeś zabić lindwurmy?%SPEECH_OFF%Te paskudne, wężowate potwory wiją się w oddali, jakby bawiły się ze sobą jak szczeniaki czy kocięta. Przytakujesz i mówisz, że to zabójcy i płacą ci za zgładzenie ich wszystkich. Mężczyzna zaciska usta.%SPEECH_ON%Widzisz ten połysk na ich łusce? To coś wyjątkowego, a one są ostatnimi ze swego rodzaju. To rzadkie lindwurmy, panie, i byłoby okrutną ruiną dla samego świata, gdyby całkiem zniknęły. Co powiesz na to, że dam ci %bribe% koron, a, eee, ktoś ci płaci, prawda? To weź jeszcze to.%SPEECH_OFF%Wyciąga z juków wielki, szorstki kombinezon ze skóry lindwurma i oferuje, że ci go odda.%SPEECH_ON%Powiedz pracodawcy, że znalazłeś i zabiłeś lindwurmy, i pokaż im to. Nie poznają różnicy. A jeśli myślisz o tym, by mnie tu zdradzić, to powiem tak: wyglądam na odrobinę szalonego, ale w środku jestem całą beczką. A taki wariat jak ja nie przetrwałby śledzenia tych wielkich, wspaniałych i pięknych lindwurmów, gdyby nie wiedział tu i tam parę rzeczy, rozumiesz?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Z drogi, głupcze. Mamy bestię do ubicia.",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				},
				{
					Text = "W porządku. Przyjmuję twoją propozycję.",
					function getResult()
					{
						return "AnimalActivistAccept";
					}

				}
			],
			function start()
			{
				this.Flags.set("IsAnimalActivist", false);
			}

		});
		this.m.Screens.push({
			ID = "AnimalActivistAccept",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_17.png[/img]{Jak to widzisz, lindwurmy tutaj nie są naprawdę twoim problemem, płacą ci tylko za to, by się nimi zająć. A możesz dostać zapłatę podwójnie, jeśli kombinezon ze skóry lindwurma tego szaleńca zmyli %employer%a.\n\nPrzyjmujesz układ. Głupiec dziękuje i niespodziewanie cię obejmuje. Śmierdzi okrutnie, a jego włosy stały się tak splątane i gęste, że drobne robaki wydrążyły w nich norki i widać, jak na ciebie patrzą. Mały jaszczurek przebiega między cuchnącymi kosmykami i porywa jednego z robaków. Odsuwasz mężczyznę i życzysz mu szczęścia w tym, co do diabła robi. Wyciąga kciuk i mały palec i macha dłonią.%SPEECH_ON%Panie, jesteś prawy.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Prawy. Prawda.",
					function getResult()
					{
						local bribe = this.Flags.get("Bribe");
						this.World.Assets.addMoney(bribe);

						if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
						{
							this.Contract.m.Target.getSprite("selection").Visible = false;
							this.Contract.m.Target.setOnCombatWithPlayerCallback(null);
							this.Contract.m.Target.die();
							this.Contract.m.Target = null;
						}

						this.Flags.set("BribeAccepted", true);
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				local bribe = this.Flags.get("Bribe");
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + bribe + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "BeastFight",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_129.png[/img]{Z odległego wejścia do jaskini buchają chmury pyłu. Gdy się zbliżasz, słyszysz syk lindwurmów i przerywane warczenie czegoś zupełnie innego.%SPEECH_ON%Proszę spojrzeć, panie!%SPEECH_OFF%%randombrother% wskazuje na krawędź wykopu. Para naczehrerów rzuciła się na lindwurma, jeden jest miotany na wszystkie strony, trzymając się ogona, drugi szarpie się z paszczą, by nie dać się ugryźć. Potwory walczą ze sobą!\n\nKręcisz głową, dobywasz miecza i rozkazujesz ludziom ustawić szyk. Wygląda na to, że będzie to prawdziwa młócka, jeśli kiedykolwiek miała być.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie wiem, czy to dobrze, czy źle.",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Lindwurms";
						p.Music = this.Const.Music.BeastsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Edge;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Random;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Ghouls, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "MerchantDistress",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_41.png[/img]{Dostrzegasz kupca i jego wóz toczący się drogą. Tył wozu unosi się, a człowiek z karawany z tyłu zostaje wyrzucony jak szmaciana kukła. Zielona smuga przemknęła za karawaną, a inna poszła bokiem. Kupiec odwraca się i wskakuje do wozu, gdy lindwurmy rozpoczynają atak. To bez wątpienia te stworzenia, których szukałeś. Na twój rozkaz %companyname% może ruszyć do przodu, zanim karawana zostanie zniszczona.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Do ataku!",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Lindwurms";
						p.Music = this.Const.Music.BeastsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Edge;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Random;
						p.Entities.push({
							ID = this.Const.EntityType.CaravanDonkey,
							Variant = 0,
							Row = -1,
							Script = "scripts/entity/tactical/objective/donkey",
							Faction = this.Const.Faction.PlayerAnimals,
							Callback = null
						});
						p.Entities.push({
							ID = this.Const.EntityType.CaravanDonkey,
							Variant = 0,
							Row = -1,
							Script = "scripts/entity/tactical/objective/donkey",
							Faction = this.Const.Faction.PlayerAnimals,
							Callback = null
						});
						p.Entities.push({
							ID = this.Const.EntityType.CaravanHand,
							Variant = 0,
							Row = -1,
							Script = "scripts/entity/tactical/humans/caravan_hand",
							Faction = this.Const.Faction.PlayerAnimals,
							Callback = null
						});
						p.Entities.push({
							ID = this.Const.EntityType.CaravanHand,
							Variant = 0,
							Row = -1,
							Script = "scripts/entity/tactical/humans/caravan_hand",
							Faction = this.Const.Faction.PlayerAnimals,
							Callback = null
						});
						p.Entities.push({
							ID = this.Const.EntityType.CaravanHand,
							Variant = 0,
							Row = -1,
							Script = "scripts/entity/tactical/humans/caravan_hand",
							Faction = this.Const.Faction.PlayerAnimals,
							Callback = null
						});
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				},
				{
					Text = "Wycofać się!",
					function getResult()
					{
						this.Flags.set("IsMerchantInDistress", false);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "MerchantDistressSuccess",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_41.png[/img]{Bitwa dobiegła końca. Każesz ludziom obedrzeć ze skóry kilka lindwurmów, podczas gdy idziesz porozmawiać z kupcem. Ten kłania się z wdzięcznością i całuje twój palec bez pierścienia.%SPEECH_ON%Dziękuję, panie, dziękuję! Ooo, mój wóz! Moje towary!%SPEECH_OFF%Jego oczy uciekają ku resztkom karawany. Osuwa się na kolana wśród szczątków i kręci głową.%SPEECH_ON%Chciałbym mieć czym ci zapłacić, nieznajomy, ale wszystko przepadło.%SPEECH_OFF%Po chwili unosi palec. Wstaje na nogi i pyta, czy masz mapę. Pokazujesz, co masz, a on wyciąga pióro.%SPEECH_ON%Tutaj, wiem o miejscu, w którym podobno jest wielki skarb. Nie wiem, czy to prawda, ale plotka warta złota, jeśli tak!%SPEECH_OFF%Tak, jeśli. Dziękujesz kupcowi za hojność i życzysz mu lepszego szczęścia w dalszej drodze. A %companyname% musi wrócić do %employer%a po zapłatę.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Powinniśmy kiedyś odwiedzić to miejsce.",
					function getResult()
					{
						this.Contract.setState("Return");
						local bases = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
						local candidates_location = [];

						foreach( b in bases )
						{
							if (!b.getLoot().isEmpty() && !b.isLocationType(this.Const.World.LocationType.Unique) && !b.getFlags().get("IsEventLocation"))
							{
								candidates_location.push(b);
							}
						}

						if (candidates_location.len() == 0)
						{
							return 0;
						}

						local location = candidates_location[this.Math.rand(0, candidates_location.len() - 1)];
						this.World.uncoverFogOfWar(location.getTile().Pos, 700.0);
						location.getFlags().set("IsEventLocation", true);
						location.setDiscovered(true);
						this.World.getCamera().moveTo(location);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "MerchantDistressFailure",
			Title = "Gdy się zbliżasz...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Bitwa dobiegła końca. Połowa ludzi zdziera skórę z lindwurmów, by mieć dowód dla %employer%a, gdy wrócicie. Druga połowa przeszukuje resztki karawany kupca. Nie ma nic wartego uwagi, nawet złota. Wszystko, co miało wartość, zostało roztrzaskane w walce. Sam kupiec został rozerwany na pół, a nogi leżą nieopodal z kieszeniami wywróconymi na lewą stronę i pustymi, a %randombrother% kuca przy szczątkach. Przytakuje.%SPEECH_ON%Cóż, to marny koniec. Bankrut i jeszcze bardziej bankrut.%SPEECH_OFF%Przytakujesz i wołasz do ludzi, by spakowali rzeczy. Czas wracać do pracodawcy po zapłatę.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Przynajmniej położyliśmy kres tym bestiom.",
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
			ID = "Victory",
			Title = "Po bitwie...",
			Text = "[img]gfx/ui/events/event_130.png[/img]{Walka z lindwurmami była jak wbijanie tępego noża w kosz żmij. Walczyły jak coś z innego świata, sycząc, plując i gryząc, ale nie dorównały determinacji i umiejętnościom %companyname%. Każesz ludziom obedrzeć te stworzenia z łusek i skóry oraz przygotować je na powrót do %employer%a po zasłużoną zapłatę. | Lindwurmy leżą w zasłużonej ruinie. Kompania szturcha zwłoki z dystansu, upewniając się, że te dranie naprawdę nie żyją. Kilka zabulgocze i przekręca się, ale to już ostatnie oznaki życia. Rozkazujesz obedrzeć te przerośnięte jaszczury ze skóry i łusek. %employer% będzie oczekiwał dowodu. | Kucasz obok lindwurma i przesuwasz dłonią po jego skórze. Jak sądzisz, łuski są na tyle długie i ostre, że mogłyby odciąć palce, gdyby utknęły między klinami. Stajesz okrakiem nad głową i wpatrujesz się w jego paszczę, mierząc dłonią zęby, a stalą miecza gardziel. %randombrother% podchodzi i pyta, co dalej. Wyciągasz miecz z gardła lindwurma, wycierasz go i wsuwasz do pochwy. Rozkazujesz ludziom obedrzeć kilka bestii i przygotować powrót do %employer%a. | Po bitwie każesz obedrzeć lindwurmy i oporządzić je pod kątem wszystkiego, co wartościowe. Niebawem pole zaczyna cuchnąć, gdy przerośnięte jaszczury są odzierane z łusek, które niegdyś je chroniły. Ich chorobliwa, lśniąca muskulatura zostaje odsłonięta dla wszystkich, a na dawnych i zawsze potworach wymusza się nagość i bezbronność. %randombrother% prycha i ociera nos rękawem. Kiwa głową na swoje dzieło.%SPEECH_ON%Nic więcej niż zwykłe stworzenie, tylko trochę większe niż powinno być.%SPEECH_OFF%Zgadza się. Rozkazujesz ludziom zebrać, co mają, i przygotować powrót do %employer%a.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Daliśmy radę.",
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
			Text = "[img]gfx/ui/events/event_77.png[/img]{Wchodzisz do pokoju %employer%a, ciągnąc za sobą kawałek mięsa lindwurma. Podnosi wzrok znad biurka, przygląda się łuskom i długiemu rękawowi gadziej skóry, zerka na ciebie, potem na skarbnika i daje stanowcze skinienie. Skarbnik bierze sakiewkę z koronami i podaje ją. %employer% wraca do pracy, zwracając się do ciebie, gdy pisze piórem.%SPEECH_ON%Dobra robota, mieczniku. Doniesienia o tych draniach całkiem ucichły, więc zakładam, że nasze pieniądze zostały dobrze wydane. Zostaw skórę. Mam człowieka, który zrobi z niej solidne buty.%SPEECH_OFF%Czy %companyname% właśnie zapracowała na nowe buty dla tego głupca? Kręcisz głową i wychodzisz. | %employer% wita ciebie i twoją zdobycz, długi, szorstki, łuskowaty, drapiący kawał skóry lindwurma. Rzucasz go przez podłogę, gdzie sunie jak sztywny skórzany kaftan. Burmistrz kiwa głową.%SPEECH_ON%Bardzo, bardzo dobrze, dobry panie! Wspaniale. Twoja zapłata, jak obiecano.%SPEECH_OFF%Mężczyzna podaje ci sakiewkę ciężką od zasłużonych koron. | Zastajesz %employer%a grzejącego się przy ogniu. Odwraca się na krześle, widząc przyniesione przez ciebie mięso lindwurma. Burmistrz kiwa głową.%SPEECH_ON%Całkiem niezła robota, mieczniku. Ciekaw jestem, czy te jaszczurze dranie odrastają sobie kończyny? Słyszałem opowieści o gadach, które potrafią takie sztuczki.%SPEECH_OFF%Wzruszasz ramionami i stwierdzasz, że każda bestia została zabita z taką dociekliwością, na jaką pozwala dobry miecz. %employer% zaciska usta.%SPEECH_ON%Ach. Racja. Cóż, twoja zapłata jest tam w rogu, tyle, ile ustaliliśmy.%SPEECH_OFF%Wraca do ognia, otulając się kocem i popijając z brzegu parującego kubka. | Zastajesz %employer%a na zewnątrz, otoczonego hałaśliwymi chłopami. Przekrzykujesz tłum i pokazujesz skórę lindwurma, którą przyniosłeś. Tłum na chwilę cichnie, szepcze między sobą, po czym znów zaczyna krzyczeć. Zaciskasz usta i przeciskasz się do środka, żądając należnej zapłaty. %employer% krzyczy na parobków, by się rozstąpili i dali mu oddychać. Gdy dwóch strażników stoi blisko, podaje ci skórzaną sakiewkę.%SPEECH_ON%Dobra robota, mieczniku. Jeśli czegoś brakuje, wróć i mnie zabij. Nie będę miał nic przeciwko, nie w ten przeklęty dzień.%SPEECH_OFF%Gdy bierzesz sakiewkę i odchodzisz, chłop wskazuje palcem na burmistrza.%SPEECH_ON%Mówię wam, ten cholerny drań, mój rzekomy \"sąsiedzki sąsiad\", ukradł mi ptaki i jeśli ich nie odda, spalę mu całe gospodarstwo do gołej ziemi!%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Oczyściłeś okolicę z lindwurmów");
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
			ID = "Failure",
			Title = "Po twoim powrocie...",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Zastajesz %employer%a w pokoju pełnym strażników. Nie mając pewności, co się dzieje, pokazujesz burmistrzowi mięso lindwurma i żądasz zapłaty. Składa palce i rozkłada je jak piłę tartaczną.%SPEECH_ON%Nie sądzę, żeby to miało się wydarzyć, mieczniku. Nie wiem, skąd masz ten cholerny kombinezon ze skóry, który niesiesz, i wierz mi, widzę, że jest stary jak gówno, a nie świeżo zdarty, ale wciąż dostaję raporty o jaszczurach rozdzierających pustkowia na nową dupę, więc jeśli nie masz nic przeciwko, grzecznie opuść to miasto, zanim poszczuję na ciebie zupełnie innego drapieżcę.%SPEECH_OFF%Bierzesz głęboki oddech i mierzysz wzrokiem strażników. Jest ich zbyt wielu, by się przedrzeć. %employer% wzdycha.%SPEECH_ON%Jeśli myślisz o obronie honoru, to nie. Już odwiodłem tych ludzi od zasadzki na twoją dupę, gdy tylko przekroczyłbyś te drzwi. Zrobiłem to z resztek szacunku, jakie mi zostały. Nie marnuj go, hm?%SPEECH_OFF%W porządku. Jest, jak jest, a i tak nie masz kogo obwiniać poza sobą. Zamykasz drzwi i odchodzisz.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Żadna niespodzianka.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 2, "Próbowałeś okantować miasto z pieniędzy");
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
			"bribe",
			this.m.Flags.get("Bribe")
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
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/ambushed_trade_routes_situation"));
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
				this.m.Target.getController().getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(true);
				this.m.Target.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(true);
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

