this.arena_contract <- this.inherit("scripts/contracts/contract", {
	m = {},
	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = 1.0;
		this.m.Type = "contract.arena";
		this.m.Name = "Arena";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 1.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.setup();
		this.contract.start();
	}

	function setup()
	{
		this.m.Flags.set("Number", 0);
		local pay = 550;

		if (this.m.Home.hasSituation("situation.bread_and_games"))
		{
			pay = pay + 100;
		}

		local twists = [];

		if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 5)
		{
			twists.push({
				R = 5,
				F = "IsSwordmaster",
				P = 50
			});
		}

		if (this.Const.DLC.Wildmen && this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 15)
		{
			twists.push({
				R = 2,
				F = "IsSwordmasterChampion",
				P = 150
			});
		}

		if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 5)
		{
			twists.push({
				R = 5,
				F = "IsHedgeKnight",
				P = 50
			});
		}

		if (this.Const.DLC.Wildmen && this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 15)
		{
			twists.push({
				R = 2,
				F = "IsExecutionerChampion",
				P = 150
			});
		}

		if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 5)
		{
			twists.push({
				R = 5,
				F = "IsDesertDevil",
				P = 50
			});
		}

		if (this.Const.DLC.Wildmen && this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 15)
		{
			twists.push({
				R = 2,
				F = "IsDesertDevilChampion",
				P = 150
			});
		}

		if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 5)
		{
			twists.push({
				R = 5,
				F = "IsMercenaries",
				P = 0
			});
		}

		if (this.Const.DLC.Unhold && this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 6)
		{
			twists.push({
				R = 5,
				F = "IsUnholds",
				P = 100
			});
		}

		if (this.Const.DLC.Lindwurm && this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 10)
		{
			twists.push({
				R = 5,
				F = "IsLindwurm",
				P = 200
			});
		}

		if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 3)
		{
			twists.push({
				R = 5,
				F = "IsSandGolems",
				P = 50
			});
		}

		if (this.Const.DLC.Wildmen && this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 3)
		{
			twists.push({
				R = 15,
				F = "IsGladiators",
				P = 0
			});
		}

		if (this.Const.DLC.Wildmen && this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 15)
		{
			twists.push({
				R = 5,
				F = "IsGladiatorChampion",
				P = 150
			});
		}

		if (this.Const.DLC.Unhold && this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") <= 5)
		{
			twists.push({
				R = 10,
				F = "IsSpiders",
				P = -75
			});
		}

		if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") <= 3)
		{
			twists.push({
				R = 10,
				F = "IsHyenas",
				P = 0
			});
		}
		else
		{
			twists.push({
				R = 10,
				F = "IsFrenziedHyenas",
				P = 0
			});
		}

		twists.push({
			R = 10,
			F = "IsGhouls",
			P = 0
		});
		twists.push({
			R = 15,
			F = "IsDesertRaiders",
			P = 0
		});
		twists.push({
			R = 10,
			F = "IsSerpents",
			P = 0
		});
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
				this.m.Flags.set(t.F, true);
				pay = pay + t.P;
			}
			else
			{
				r = r - t.R;
			}
		}

		this.m.Payment.Pool = pay * this.getPaymentMult() * this.getReputationToPaymentMult();
		this.m.Payment.Completion = 1.0;
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Wyekwipuj do trzech swoich ludzi w obroże areny",
					"Jeszcze raz wejdź na arenę, by rozpocząć walkę",
					"Walka będzie toczyć się do śmierci, bez możliwości ucieczki i ograbienia poległych"
				];
				this.Contract.m.BulletpointsPayment = [
					"Otrzymasz " + this.Contract.m.Payment.getOnCompletion() + " koron za zwycięstwo"
				];

				if (this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") > 0 && this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") % 5 == 0)
				{
					this.Contract.m.BulletpointsPayment.push("Wygraj część sprzętu gladiatora");
				}

				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.Flags.set("Day", this.World.getTime().Days);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Flags.get("IsVictory"))
				{
					this.Contract.setScreen("Success");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsFailure"))
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.World.getTime().Days > this.Flags.get("Day"))
				{
					this.Contract.setScreen("Failure2");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Arena")
				{
					this.Flags.set("IsVictory", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Arena")
				{
					this.Flags.set("IsFailure", true);
				}
			}

		});
	}

	function createScreens()
	{
		this.m.Screens.push({
			ID = "Task",
			Title = "Na Arenie",
			Text = "",
			Image = "",
			List = [],
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Sprawimy, że piaski spłyną krwią! | Chcę usłyszeć, jak publiczność skanduje nasze imiona! | Wyrżniemy ich jak bydło!}",
					function getResult()
					{
						return "Overview";
					}

				},
				{
					Text = "{Nie to miałem na myśli. | Tę walkę sobie odpuszczę. | Poczekam do następnej bitwy.}",
					function getResult()
					{
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.State.getTownScreen().getMainDialogModule().reload();
						return 0;
					}

				}
			],
			function start()
			{
				this.Text = "[img]gfx/ui/events/event_155.png[/img]Dziesiątki ludzi kłębią się przy wejściu na arenę. Jedni stoją stoicko, nie chcąc zdradzać swych możliwości. Inni przechwalają się i pysznią z rozmachem, albo szczerze pewni swoich umiejętności, albo licząc, że brawura ukryje braki w ich grze.\n\n";
				this.Text += "Siwobrody mężczyzna, mistrz areny, unosi zwój i stuka w niego hakiem zamiast dłoni.";
				local baseDifficulty = 30;

				if (this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") > 0 && this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") % 5 == 0)
				{
					baseDifficulty = baseDifficulty + 10;
				}

				baseDifficulty = baseDifficulty * this.Contract.getScaledDifficultyMult();

				if (this.Flags.get("IsSwordmaster"))
				{
					if (baseDifficulty < this.Const.World.Spawn.Troops.Swordmaster.Cost + this.Const.World.Spawn.Troops.BanditRaider.Cost)
					{
						this.Flags.set("Number", 0);
						this.Contract.m.BulletpointsObjectives[1] = "Wejdź na arenę ponownie, aby rozpocząć walkę przeciwko Mistrzowi Miecza";
					}
					else
					{
						this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.BanditRaider, baseDifficulty - this.Const.World.Spawn.Troops.Swordmaster.Cost, 2));
						this.Contract.m.BulletpointsObjectives[1] = "Wejdź na arenę ponownie, aby rozpocząć walkę przeciwko Mistrzowi Miecza oraz %amount% najeźdźcom";
					}

					this.Text += "%SPEECH_ON%Postawili gwiazdę przy jego imieniu, znak Gildera. To znaczy, że jego ścieżka jest złocona. Powinieneś wiedzieć, że to mistrz miecza. Może pocieszy cię, że jest starszym człowiekiem, ale nie byłbyś pierwszym, komu to mówię, rozumiesz? Niech twoja droga będzie tak Złocona, bo droga tego mistrza na pewno była.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsHedgeKnight"))
				{
					if (baseDifficulty < this.Const.World.Spawn.Troops.HedgeKnight.Cost + this.Const.World.Spawn.Troops.BanditRaider.Cost)
					{
						this.Flags.set("Number", 0);
						this.Contract.m.BulletpointsObjectives[1] = "Wejdź na arenę ponownie, aby rozpocząć walkę przeciwko Błędnemu Rycerzowi";
					}
					else
					{
						this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.BanditRaider, baseDifficulty - this.Const.World.Spawn.Troops.HedgeKnight.Cost, 2));
						this.Contract.m.BulletpointsObjectives[1] = "Wejdź na arenę ponownie, aby rozpocząć walkę przeciwko Błędnemu Rycerzowi oraz %amount% najeźdźcom";
					}

					this.Text += "%SPEECH_ON%Zdaje się, że ludzie północy mówią na niego \'rycerz nienawiści\'. Mogę się mylić. Nie mów innym mistrzom areny, że tak mówię o północnym śmieciu, ale ten rycerz to jeden z najniebezpieczniejszych ludzi, jakich tu widziałem. Jeśli chcesz, by twoja droga dalej była złocona, radzę ostro się przygotować i porządnie wypocząć przed walką.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsDesertDevil"))
				{
					if (baseDifficulty < this.Const.World.Spawn.Troops.DesertDevil.Cost + this.Const.World.Spawn.Troops.NomadOutlaw.Cost)
					{
						this.Flags.set("Number", 0);
						this.Contract.m.BulletpointsObjectives[1] = "Wejdź na arenę ponownie, aby rozpocząć walkę przeciwko Tancerzowi Ostrza";
					}
					else
					{
						this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, baseDifficulty - this.Const.World.Spawn.Troops.DesertDevil.Cost, 2));
						this.Contract.m.BulletpointsObjectives[1] = "Wejdź na arenę ponownie, aby rozpocząć walkę przeciwko Tancerzowi Ostrza oraz %amount% koczownikom";
					}

					this.Text += "Mistrz areny unosi zwój i stuka w niego hakiem zamiast dłoni.%SPEECH_ON%Na rozpisce jest tancerz ostrza z plemion koczowników. Może wyglądać trochę fircykowato, ale by dostać tytuł \'tancerza ostrza\', trzeba być z ostrzem tak biegłym, jak ptak z wiatrem. Umiejętności tańca są opcjonalne, ale i w tym są całkiem dobrzy.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsSandGolems"))
				{
					this.Flags.set("Number", this.Math.max(3, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.SandGolem, baseDifficulty, 3)));
					this.Contract.m.BulletpointsObjectives[1] = "Wejdź na arenę ponownie, aby rozpocząć walkę przeciwko %amount% ifrytom";
					this.Text += "%SPEECH_ON%Na stronie nie ma nic, bo boję się gniewu pustyni, jeśli ośmieliłbym się opisać jej najdzikszą obecność. Walczycie z %number% ifrytami. Nie wiem, jak udało im się je tu sprowadzić, wiem tylko, że to dzieło alchemików. Jak mnie pytasz, wolałbym, żebyście bili się z nimi niż z ifrytami.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsGhouls"))
				{
					local num = 0;

					if (baseDifficulty >= this.Const.World.Spawn.Troops.GhoulHIGH.Cost * 2)
					{
						num = num + 1;
						num = num + this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Ghoul, baseDifficulty - this.Const.World.Spawn.Troops.GhoulHIGH.Cost);
					}
					else
					{
						num = num + this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.GhoulLOW, baseDifficulty * 0.5);
						num = num + this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Ghoul, baseDifficulty * 0.5);
					}

					this.Flags.set("Number", num);
					this.Contract.m.BulletpointsObjectives[1] = "Wejdź na arenę ponownie, aby rozpocząć walkę przeciwko %amount% nachzehrerom";
					this.Text += "%SPEECH_ON%Alchemicy tak je nazywają, no, nawet nie potrafię tego wymówić. Mój język nie potrafi ułożyć się do słowa, które wymaga specjalistycznej północnej leksykografii, a ja nie mam czasu zwężać północnego gadulstwa do jałowych, przyziemnych drobiazgów. Wyglądam ci na fonetyka? Nazwijmy je po prostu \'zgrzytoszarpiami\'. To ghulowe kretyny, jest ich %number%, i widziałem, jak zjadają ludzi żywcem, więc lepiej miej nadzieję, że Gilder patrzy - nie sądzę, by miał dla ciebie światło w brzuchu jednej z tych bestii!%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsUnholds"))
				{
					this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Unhold, baseDifficulty));

					if (this.Flags.get("Number") == 1)
					{
						this.Contract.m.BulletpointsObjectives[1] = "Wejdź na arenę ponownie, aby rozpocząć walkę przeciwko unholdowi";
					}
					else
					{
						this.Contract.m.BulletpointsObjectives[1] = "Wejdź na arenę ponownie, aby rozpocząć walkę przeciwko %amount% unholdom";
					}

					this.Text += "%SPEECH_ON%Staniesz przeciwko %number% temu, co północne ścierwo nazywa \'unholdem\'. Wizyr płaci porządny stos monet, by je tu sprowadzić, a masy uwielbiają te wielkie gnoje. Świetnie miażdżą wojowników i czasem ciskają któregoś w tłum. To dopiero widowisko. Myślę, że niektóre unholdy nawet uczą się to lubić im dłużej tu siedzą, jak uczą się, co wywołuje wiwaty i szyderstwa tłumu. Ta brutalność to coś innego. Tak czy inaczej, niech Gilder ma cię w opiece.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsDesertRaiders"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "Wejdź na arenę ponownie, aby rozpocząć walkę przeciwko %amount% koczownikom";
					this.Text += "%SPEECH_ON%Twoimi przeciwnikami będzie %number% niedawno \'emerytowanych\' pustynnych bandytów. A przez emeryturę mam na myśli, oczywiście, pojmanych przez ludzi prawa Wizyra. Żaden bandyta nie wchodzi tu z własnej woli, hahahha!%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsGladiators"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "Wejdź na arenę ponownie, aby rozpocząć walkę przeciwko %amount% gladiatorom";
					this.Text += "%SPEECH_ON%No, heh, Gilder musi mieć poczucie humoru. Zmierzycie się z %number% gladiatorami. Niech wasza droga będzie Złocona, ale szczerze mówiąc, powiedziałem to gladiatorom. I mówię im tak codziennie. Rozumiesz? Przygotujcie się najlepiej, jak potraficie.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsSpiders"))
				{
					this.Flags.set("Number", this.Math.max(3, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Spider, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "Wejdź na arenę ponownie, aby rozpocząć walkę przeciwko %amount% webknechtom";
					this.Text += "%SPEECH_ON%To nie drzewko figowe, to pająk. Alchemicy, niech im nauka służy, nazywają je webknechtami, co jest głupią północną nazwą, bo prawda jest taka, że to pająki. Niestety dla ciebie tym razem but nie wystarczy na %number% z nich.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsSerpents"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Serpent, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "Wejdź na arenę ponownie, aby rozpocząć walkę przeciwko %amount% wężom";
					this.Text += "%SPEECH_ON%Co znaczy, że nie rozumiesz? Hę, to tylko krzywa kreska? Nie. Spójrz, to ogon, a to głowa. To wąż. Walczycie z %number% wężami. \'Serpentami\' alchemicy lubią je nazywać, ale gdybym chciał narysować serpenta, narysowałbym alchemika, hahahha!%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsHyenas"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Hyena, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "Wejdź na arenę ponownie, aby rozpocząć walkę przeciwko %amount% hienom";
					this.Text += "%SPEECH_ON%Hieny. Hi hi hi. Hieny. Dokładnie %numberC% chichoczących kundli. Powodzenia, niech Gilder ma was w opiece.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsFrenziedHyenas"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.HyenaHIGH, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "Wejdź na arenę ponownie, aby rozpocząć walkę przeciwko %amount% wściekłym hienom";
					this.Text += "%SPEECH_ON%Hieny. Hi hi hi. Hieny. Dokładnie %numberC% chichoczących kundli. Powodzenia, niech Gilder ma was w opiece.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsLindwurm"))
				{
					this.Flags.set("Number", this.Math.min(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Lindwurm, baseDifficulty - 30)));

					if (this.Flags.get("Number") == 1)
					{
						this.Contract.m.BulletpointsObjectives[1] = "Wejdź na arenę ponownie, aby rozpocząć walkę przeciwko lindwurmowi";
					}
					else
					{
						this.Contract.m.BulletpointsObjectives[1] = "Wejdź na arenę ponownie, aby rozpocząć walkę przeciwko dwóm lindwurmom";
					}

					this.Text += "%SPEECH_ON%Twój przeciwnik to... to... co to jest? Robak? Jest zielony. Nigdy nie widziałem robaka, który by kol- o! Wyrm! Nie, czekaj, \'wurm\'. Wurm? Lindwurm! Powiem ci szczerze, nie wiem, co to do cholery jest, ale wyobrażam sobie, że nasi drodzy swaci nie każą wam walczyć z takim zwykłym robakiem. A może każą. Może każą wam go zjeść dla naszej rozrywki. Może nie są swatami, tylko smakoszami! Herghgheeagghheeehoogh. Ha.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsMercenaries"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "Wejdź na arenę ponownie, aby rozpocząć walkę przeciwko %amount% najemnikom";
					this.Text += "%SPEECH_ON%Koronniacy jak wy zapuszczają się z północy. Tam mówią na nich \'sellswords\'. Hagh! Cóż to za próba poezji? Nie wiedzą, że nie każdy w ogóle używa miecza? Na północy nie są najbystrzejsi. Dlatego lubię południe. Słońce świeci jasno, więc i my.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsGladiatorChampion"))
				{
					this.Flags.set("Champion1", this.Const.World.Common.generateName(this.Const.World.Spawn.Troops.Gladiator.NameList) + (this.Const.World.Spawn.Troops.Gladiator.TitleList != null ? " " + this.Const.World.Spawn.Troops.Gladiator.TitleList[this.Math.rand(0, this.Const.World.Spawn.Troops.Gladiator.TitleList.len() - 1)] : ""));
					this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, baseDifficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 2, 2));
					this.Contract.m.BulletpointsObjectives[1] = "Wejdź na arenę ponownie, aby rozpocząć walkę. Twoim przeciwnikiem będzie %champion1% oraz %amount% gladiatorów";
					this.Text += "%SPEECH_ON%Poznajesz tę twarz? Nie bez powodu artyści spędzili czas nad tą ulotką, a potem rozdali ją każdej parze oczu siedzącej tam na górze. To %champion1%, jeden z największych wojowników w tej krainie. Może kiedyś zrobią twoją twarz tak ładną, jeśli Wizyr znajdzie kogoś na tyle zdolnego, by uratować, no cóż, to co masz tam między uszami, hehehegh.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsSwordmasterChampion"))
				{
					this.Flags.set("Champion1", this.Const.World.Common.generateName(this.Const.World.Spawn.Troops.Swordmaster.NameList) + (this.Const.World.Spawn.Troops.Swordmaster.TitleList != null ? " " + this.Const.World.Spawn.Troops.Swordmaster.TitleList[this.Math.rand(0, this.Const.World.Spawn.Troops.Swordmaster.TitleList.len() - 1)] : ""));
					this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, baseDifficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 2, 2));
					this.Contract.m.BulletpointsObjectives[1] = "Wejdź na arenę ponownie, aby rozpocząć walkę. Twoim przeciwnikiem będzie %champion1% oraz %amount% najemników";
					this.Text += "%SPEECH_ON%Poznajesz tę twarz? Nie bez powodu artyści spędzili czas nad tą ulotką, a potem rozdali ją każdej parze oczu siedzącej tam na górze. To %champion1%, jeden z największych wojowników w tej krainie. Może kiedyś zrobią twoją twarz tak ładną, jeśli Wizyr znajdzie kogoś na tyle zdolnego, by uratować, no cóż, to co masz tam między uszami, hehehegh.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsExecutionerChampion"))
				{
					this.Flags.set("Champion1", this.Const.World.Common.generateName(this.Const.World.Spawn.Troops.Executioner.NameList) + (this.Const.World.Spawn.Troops.Executioner.TitleList != null ? " " + this.Const.World.Spawn.Troops.Executioner.TitleList[this.Math.rand(0, this.Const.World.Spawn.Troops.Executioner.TitleList.len() - 1)] : ""));
					this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, baseDifficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 2, 2));
					this.Contract.m.BulletpointsObjectives[1] = "Wejdź na arenę ponownie, aby rozpocząć walkę. Twoim przeciwnikiem będzie %champion1% oraz %amount% gladiatorów";
					this.Text += "%SPEECH_ON%Poznajesz tę twarz? Nie bez powodu artyści spędzili czas nad tą ulotką, a potem rozdali ją każdej parze oczu siedzącej tam na górze. To %champion1%, jeden z największych wojowników w tej krainie. Może kiedyś zrobią twoją twarz tak ładną, jeśli Wizyr znajdzie kogoś na tyle zdolnego, by uratować, no cóż, to co masz tam między uszami, hehehegh.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsDesertDevilChampion"))
				{
					this.Flags.set("Champion1", this.Const.World.Common.generateName(this.Const.World.Spawn.Troops.DesertDevil.NameList) + (this.Const.World.Spawn.Troops.DesertDevil.TitleList != null ? " " + this.Const.World.Spawn.Troops.DesertDevil.TitleList[this.Math.rand(0, this.Const.World.Spawn.Troops.DesertDevil.TitleList.len() - 1)] : ""));
					this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, baseDifficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 2, 2));
					this.Contract.m.BulletpointsObjectives[1] = "Wejdź na arenę ponownie, aby rozpocząć walkę. Twoim przeciwnikiem będzie %champion1% oraz %amount% koczowników";
					this.Text += "%SPEECH_ON%Poznajesz tę twarz? Nie bez powodu artyści spędzili czas nad tą ulotką, a potem rozdali ją każdej parze oczu siedzącej tam na górze. To %champion1%, jeden z największych wojowników w tej krainie. Może kiedyś zrobią twoją twarz tak ładną, jeśli Wizyr znajdzie kogoś na tyle zdolnego, by uratować, no cóż, to co masz tam między uszami, hehehegh.%SPEECH_OFF%";
				}

				if (this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") > 0 && this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") % 5 == 0)
				{
					this.Text += "Przerywa.%SPEECH_ON%Spodziewamy się ważnych gości na tę walkę, więc tym razem wszystko jest ustawione tak, byście zginęli porządnie krwawo, jasne? A jeśli nie potraficie, to niech wasi ludzie wykończą przeciwników w najbardziej widowiskowy sposób, żeby zadowolić tłum. Zróbcie to, a dorzucę wam porządny kawałek sprzętu gladiatora, oprócz monety.%SPEECH_OFF%";
				}

				this.Text += "Wskazuje na dziwnie wyglądające obroże i ciągnie dalej.%SPEECH_ON%Gdy będziecie gotowi, załóżcie je trzem ludziom, którzy będą walczyć. Dzięki temu wiemy, kogo wprowadzić na piaski. Kto nie ma obroży, nie wejdzie - ani wy, ani Wizyr, a śmiem twierdzić, że nawet Gilder może zostać odprawiony.%SPEECH_OFF%";
			}

		});
		this.m.Screens.push({
			ID = "Overview",
			Title = "Podgląd",
			Text = "Ta walka na arenie odbędzie się na następujących zasadach. Zgadzasz się na te warunki?",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zgadzam się.",
					function getResult()
					{
						this.World.Assets.getStash().add(this.new("scripts/items/accessory/special/arena_collar_item"));
						this.World.Assets.getStash().add(this.new("scripts/items/accessory/special/arena_collar_item"));
						this.World.Assets.getStash().add(this.new("scripts/items/accessory/special/arena_collar_item"));
						this.Contract.setState("Running");
						return 0;
					}

				},
				{
					Text = "Muszę to przemyśleć.",
					function getResult()
					{
						return 0;
					}

				}
			],
			ShowObjectives = true,
			ShowPayment = true,
			function start()
			{
				this.Contract.m.IsNegotiated = true;
			}

		});
		this.m.Screens.push({
			ID = "Start",
			Title = "Na Arenie",
			Text = "[img]gfx/ui/events/event_155.png[/img]{Gdy czekasz na swoją kolej, żądza krwi tłumu pełznie w mroku, z góry opadają płaty kurzu, a tupot stóp grzmi jak burza. Szepczą w oczekiwaniu i ryczą przy zabijaniu. Cisza między walkami trwa zaledwie chwilę i zostaje rozdarta, gdy zardzewiała krata idzie w górę, łańcuchy zgrzytają, a tłum znowu wrze. Wychodzicie na światło i hałas uderza w serce tak mocno, że mógłby poderwać martwego... | Tłum na arenie stoi bark w bark, większość bełkocze po pijanemu. Krzyczą i wrzeszczą, ich języki mieszają lokalne i obce, choć do żądzy krwi nie potrzeba wielu słów ponad ich obłąkane twarze i zaciśnięte pięści. Teraz ludzie %companyname% nasycą tych szaleńców... | Sprzątacze krzątają się po arenie. Wloką ciała, zbierają to, co warto zebrać, i od czasu do czasu rzucają trofeum w tłum, wywołując wśród widzów mobowe odgrywanie walk. %companyname% jest teraz częścią tego widowiska. | Arena czeka, tłum płonie, a kolej %companyname% na zdobycie chwały nadeszła! | Tłum grzmi, gdy ludzie %companyname% wkraczają do krwawego dołu. Mimo bezmyślnej żądzy krwi nie możesz powstrzymać dumy, wiedząc, że to twoja kompania ma dać pokaz. | Krata unosi się. Nie słychać nic poza brzękiem łańcuchów, skrzypieniem bloczków i chrząkaniem niewolników przy pracy. Gdy ludzie %companyname% wychodzą z wnętrzności areny, słyszą chrzęst piasku pod stopami, aż stają w samym środku dołu. Z góry stadionu rozdziera się dziwny krzyk, w jakimś obcym języku, lecz słowa rozbrzmiewają tylko raz, zanim tłum wybucha wiwatami i rykiem. To czas, by twoi ludzie udowodnili swoją wartość przed czujnym okiem pospólstwa. | Sprawy %companyname% rzadko dzieją się na oczach tych, którzy wolą trzymać się z dala od takiej przemocy. Ale na arenie pospólstwo zachłannie czeka na śmierć i cierpienie, warczy z żądzy krwi, gdy wasi ludzie wchodzą na piaski, i ryczy, gdy najemnicy dobywają broni i szykują się do walki. | Arena jest jak lej po wrzodzie, jej dach został wyrwany przez bogów, odsłaniając próżność, żądzę krwi i dzikość człowieka. A to człowiek tam, krzyczący i wyjący; gdy krew pryska, myją nią twarze i szczerzą się do siebie, jakby to był żart. Walczą o trofea i rozkoszują się cudzym bólem. I przed tymi ludźmi %companyname% będzie walczyć, i dla nich będzie zabawiać, i zabawiać dobrze. | Tłum areny to mieszanina klas, bogatych i biednych, bo tylko Wizyrzy odgradzają się w lożach ponad wszystkimi. Na chwilę zjednoczone, ludy %townname% łaskawie przyszły, by oglądać, jak ludzie i potwory mordują się nawzajem. Z przyjemnością %companyname% dokłada swoje trzy grosze. | Chłopcy siedzą na barkach ojców, młode dziewczęta rzucają gladiatorom kwiaty, kobiety wachlują się, mężczyźni zastanawiają się, czy sami by potrafili. Oto ludzie areny - a reszta jest pijana w sztok i wrzeszczy bzdury. Masz nadzieję, że %companyname% zdoła zapewnić tej szalonej zgrai choć godzinę lub dwie rozrywki. | Tłum ryczy, gdy ludzie %companyname% wchodzą na piaski. Głupiec pomyliłby ekscytację z życzliwością, bo ledwie kończy się aplauz, lecą puste kufle po piwie i zgniłe pomidory, a także ogólne chichoty widzów. Zastanawiasz się, czy ludzie %companyname% naprawdę najlepiej się tu przydadzą, ale potem myślisz o złocie i chwale do zdobycia, i o tym, że na koniec dnia te kundelki na trybunach wrócą do swoich gównianych żyć, a ty wrócisz do swojego gównianego życia, tylko kieszeń będzie odrobinę cięższa.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Dajmy gawiedzi niezłe przedstawienie!",
					function getResult()
					{
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.CombatID = "Arena";
						p.TerrainTemplate = "tactical.arena";
						p.LocationTemplate.Template[0] = "tactical.arena_floor";
						p.Music = this.Const.Music.ArenaTracks;
						p.Ambience[0] = this.Const.SoundAmbience.ArenaBack;
						p.Ambience[1] = this.Const.SoundAmbience.ArenaFront;
						p.AmbienceMinDelay[0] = 0;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.IsUsingSetPlayers = true;
						p.IsFleeingProhibited = true;
						p.IsLootingProhibited = true;
						p.IsWithoutAmbience = true;
						p.IsFogOfWarVisible = false;
						p.IsArenaMode = true;
						p.IsAutoAssigningBases = false;
						local bros = this.Contract.getBros();

						for( local i = 0; i < bros.len() && i < 3; i = i )
						{
							p.Players.push(bros[i]);
							i = ++i;
						}

						p.Entities = [];
						local baseDifficulty = 30;

						if (this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") > 0 && this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") % 5 == 0)
						{
							baseDifficulty = baseDifficulty + 10;
						}

						baseDifficulty = baseDifficulty * this.Contract.getScaledDifficultyMult();

						if (this.Flags.get("IsSwordmaster"))
						{
							this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Swordmaster);

							for( local i = 0; i < this.Flags.get("Number"); i = i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.BanditRaider);
								i = ++i;
							}
						}
						else if (this.Flags.get("IsHedgeKnight"))
						{
							this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.HedgeKnight);

							for( local i = 0; i < this.Flags.get("Number"); i = i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.BanditRaider);
								i = ++i;
							}
						}
						else if (this.Flags.get("IsDesertDevil"))
						{
							this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.DesertDevil);

							for( local i = 0; i < this.Flags.get("Number"); i = i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.NomadOutlaw);
								i = ++i;
							}
						}
						else if (this.Flags.get("IsSandGolems"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.SandGolem);
								i = ++i;
							}
						}
						else if (this.Flags.get("IsGhouls"))
						{
							if (baseDifficulty >= this.Const.World.Spawn.Troops.GhoulHIGH.Cost * 2)
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.GhoulHIGH);

								for( local i = 0; i < this.Flags.get("Number") - 1; i = i )
								{
									this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Ghoul);
									i = ++i;
								}
							}
							else
							{
								for( local i = 0; i < this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.GhoulLOW, baseDifficulty * 0.5); i = i )
								{
									this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.GhoulLOW);
									i = ++i;
								}

								for( local i = 0; i < this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Ghoul, baseDifficulty * 0.5); i = i )
								{
									this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Ghoul);
									i = ++i;
								}
							}
						}
						else if (this.Flags.get("IsUnholds"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Unhold);
								i = ++i;
							}
						}
						else if (this.Flags.get("IsDesertRaiders"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.NomadOutlaw);
								i = ++i;
							}
						}
						else if (this.Flags.get("IsGladiators"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Gladiator);
								i = ++i;
							}
						}
						else if (this.Flags.get("IsSpiders"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Spider);
								i = ++i;
							}
						}
						else if (this.Flags.get("IsSerpents"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Serpent);
								i = ++i;
							}
						}
						else if (this.Flags.get("IsHyenas"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Hyena);
								i = ++i;
							}
						}
						else if (this.Flags.get("IsFrenziedHyenas"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.HyenaHIGH);
								i = ++i;
							}
						}
						else if (this.Flags.get("IsLindwurm"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Lindwurm);
								i = ++i;
							}
						}
						else if (this.Flags.get("IsMercenaries"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Mercenary);
								i = ++i;
							}
						}
						else if (this.Flags.get("IsGladiatorChampion"))
						{
							this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Gladiator, true, this.Flags.get("Champion1"));

							for( local i = 0; i < this.Flags.get("Number"); i = i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Gladiator);
								i = ++i;
							}
						}
						else if (this.Flags.get("IsSwordmasterChampion"))
						{
							this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Swordmaster, true, this.Flags.get("Champion1"));

							for( local i = 0; i < this.Flags.get("Number"); i = i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Mercenary);
								i = ++i;
							}
						}
						else if (this.Flags.get("IsExecutionerChampion"))
						{
							this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Executioner, true, this.Flags.get("Champion1"));

							for( local i = 0; i < this.Flags.get("Number"); i = i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Gladiator);
								i = ++i;
							}
						}
						else if (this.Flags.get("IsDesertDevilChampion"))
						{
							this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.DesertDevil, true, this.Flags.get("Champion1"));

							for( local i = 0; i < this.Flags.get("Number"); i = i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.NomadOutlaw);
								i = ++i;
							}
						}

						for( local i = 0; i < p.Entities.len(); i = i )
						{
							p.Entities[i].Faction <- this.Contract.getFaction();
							i = ++i;
						}

						this.World.Contracts.startScriptedCombat(p, false, false, false);
						return 0;
					}

				},
				{
					Text = "Nie ma mowy. Nie chcę umierać!",
					function getResult()
					{
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.State.getTownScreen().getMainDialogModule().reload();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnArenaCancel);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success",
			Title = "Na Arenie",
			Text = "[img]gfx/ui/events/event_147.png[/img]{Mistrz areny mówi tak, jakby nawet nie pamiętał twojej twarzy, choć pewnie faktycznie nie pamięta.%SPEECH_ON%Oto wasza zapłata, proszę przyjść znowu.%SPEECH_OFF%Arena będzie dziś zamknięta, ale możecie wrócić już jutro. | Nawet nie podnosząc głowy znad strzępu papirusu, mistrz areny rzuca ci sakiewkę z monetami.%SPEECH_ON%Słyszałem tłum, więc oto wasze korony. Obyście znów odwiedzili piaski.%SPEECH_OFF%Arena będzie dziś zamknięta, ale możecie wrócić już jutro. | Mistrz areny czeka na was.%SPEECH_ON%To był cholernie dobry pokaz, Koroniaku. Wcale by mi nie przeszkadzało, gdybyście wrócili.%SPEECH_OFF%Arena będzie dziś zamknięta, ale możecie wrócić już jutro.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "{Zwycięstwo! | Nie zabawiliście się?! | I po sprawie. | Krwawy spektakl.}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());

						if (this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") > 0 && this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") % 5 == 0)
						{
							return "Gladiators";
						}
						else
						{
							this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
							this.World.Statistics.getFlags().increment("ArenaFightsWon", 1);
							this.World.Statistics.getFlags().increment("ArenaRegularFightsWon", 1);
							this.World.Contracts.finishActiveContract();

							if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 10)
							{
								this.updateAchievement("Gladiator", 1, 1);
							}

							return 0;
						}
					}

				}
			],
			function start()
			{
				local roster = this.World.getPlayerRoster().getAll();
				local n = 0;

				foreach( bro in roster )
				{
					local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

					if (item != null && item.getID() == "accessory.arena_collar")
					{
						local skill;
						bro.getFlags().increment("ArenaFightsWon", 1);
						bro.getFlags().increment("ArenaFights", 1);

						if (bro.getFlags().getAsInt("ArenaFightsWon") == 1)
						{
							skill = this.new("scripts/skills/traits/arena_pit_fighter_trait");
							bro.getSkills().add(skill);
							this.List.push({
								id = 10,
								icon = skill.getIcon(),
								text = bro.getName() + " to teraz " + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
							});
						}
						else if (bro.getFlags().getAsInt("ArenaFightsWon") == 5)
						{
							bro.getSkills().removeByID("trait.pit_fighter");
							skill = this.new("scripts/skills/traits/arena_fighter_trait");
							bro.getSkills().add(skill);
							this.List.push({
								id = 10,
								icon = skill.getIcon(),
								text = bro.getName() + " to teraz " + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
							});
						}
						else if (bro.getFlags().getAsInt("ArenaFightsWon") == 12)
						{
							bro.getSkills().removeByID("trait.arena_fighter");
							skill = this.new("scripts/skills/traits/arena_veteran_trait");
							bro.getSkills().add(skill);
							this.List.push({
								id = 10,
								icon = skill.getIcon(),
								text = bro.getName() + " to teraz " + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
							});
						}

						n = ++n;
						n = n;
					}

					if (n >= 3)
					{
						break;
					}
				}

				if (this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") > 0 && this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") % 5 == 0)
				{
					local r;
					local a;
					local u;

					if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") == 5)
					{
						r = 1;
					}
					else if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") == 10)
					{
						r = 3;
					}
					else if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") == 15)
					{
						r = 2;
					}
					else
					{
						r = this.Math.rand(1, 3);
					}

					switch(r)
					{
					case 1:
						a = this.new("scripts/items/armor/oriental/gladiator_harness");
						u = this.new("scripts/items/armor_upgrades/light_gladiator_upgrade");
						a.setUpgrade(u);
						this.List.push({
							id = 12,
							icon = "ui/items/armor_upgrades/upgrade_24.png",
							text = "Zdobywasz " + a.getName()
						});
						break;

					case 2:
						a = this.new("scripts/items/armor/oriental/gladiator_harness");
						u = this.new("scripts/items/armor_upgrades/heavy_gladiator_upgrade");
						a.setUpgrade(u);
						this.List.push({
							id = 12,
							icon = "ui/items/armor_upgrades/upgrade_25.png",
							text = "Zdobywasz " + a.getName()
						});
						break;

					case 3:
						a = this.new("scripts/items/helmets/oriental/gladiator_helmet");
						this.List.push({
							id = 12,
							icon = "ui/items/" + a.getIcon(),
							text = "Zdobywasz " + a.getName()
						});
						break;
					}

					this.World.Assets.getStash().makeEmptySlots(1);
					this.World.Assets.getStash().add(a);
				}
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "Na Arenie",
			Text = "[img]gfx/ui/events/event_147.png[/img]{Ludzie %companyname% zostali pokonani, martwi albo, co gorsza, straszliwie poharatani. Przynajmniej tłumy są zadowolone. Na piaskach każde widowisko, nawet to kończące się śmiercią, jest dobrym widowiskiem.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Katastrofa!",
					function getResult()
					{
						local roster = this.World.getPlayerRoster().getAll();
						local n = 0;

						foreach( bro in roster )
						{
							local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

							if (item != null && item.getID() == "accessory.arena_collar")
							{
								bro.getFlags().increment("ArenaFights", 1);
								n = ++n;
								n = n;
							}

							if (n >= 3)
							{
								break;
							}
						}

						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "Na Arenie",
			Text = "{[img]gfx/ui/events/event_155.png[/img]Czas waszej walki na arenie nadszedł i minął, ale się nie pojawiliście. Być może wydarzyło się coś ważniejszego, albo po prostu chowaliście się jak tchórze. Tak czy inaczej, wasza reputacja na tym ucierpi.",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Ale...",
					function getResult()
					{
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Collars",
			Title = "Na Arenie",
			Text = "{[img]gfx/ui/events/event_155.png[/img]Nadszedł czas waszej walki na arenie, ale żaden z waszych ludzi nie ma obroży areny, więc nie wpuszczono was do środka.\n\nZdecyduj, kto ma walczyć, zakładając im otrzymane obroże areny, a pojedynek rozpocznie się, gdy ponownie wejdziesz na arenę.",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Och, racja!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Gladiators",
			Title = "Na Arenie",
			Text = "{[img]gfx/ui/events/event_85.png[/img]Po walce widzisz kilka kobiet podchodzących do ciebie i gladiatorów. Omal nie mdleją, rumieńce na twarzach, a mężczyźni otaczają je szczególną troską. Sam trochę zmęczony, prosisz jedną z fanek o pomoc w liczeniu ekwipunku. | [img]gfx/ui/events/event_147.png[/img]Walka się skończyła, ale nagle cień przemyka po ziemi. W mgnieniu oka dobywasz ostrza i tniesz niebo. Płatki kwiatów spadają na twoje lśniące ciało, a resztę bukietu łapiesz zębami. Kobieta stoi obok i wachluje się.%SPEECH_ON%Zastanawiałam się, czemu nie walczyłeś.%SPEECH_OFF%Mówi. Chowasz ostrze i wiążesz bukiet do pasa. Mówisz jej, że gdybyś walczył, to wcale nie byłaby \'walka\'. Fanka mięknie w kolanach i znajduje oparcie na ziemi. Zanim odejdziesz, mówisz, by piła dużo wody i pamiętała o porannym rozciąganiu. | [img]gfx/ui/events/event_97.png[/img]%SPEECH_START%Czy mogę nauczyć się walczyć jak wy?%SPEECH_OFF%Głos zaskakuje cię i nim się spostrzeżesz, ostrze jest cal od twarzy małego chłopca. Ma zamknięte oczy i powoli otwiera jedno. Chowasz miecz i śmiejesz się.%SPEECH_ON%Nie. Tego, kim jestem, nie da się nauczyć.%SPEECH_OFF%Używasz odrobiny popiołu i krwi z pola, by podpisać koszulę dzieciaka, i odchodzisz. | [img]gfx/ui/events/event_97.png[/img]%SPEECH_START%Czy wy... czy wy jesteście gladiatorami?%SPEECH_OFF%Widzisz chłopca stojącego z zachwytem na twarzy. Prawie płacze z podniecenia.%SPEECH_ON%Jesteście niesamowici!%SPEECH_OFF%Tarmosząc mu włosy, dziękujesz i odchodzisz. | [img]gfx/ui/events/event_97.png[/img]%SPEECH_START%J-jak staliście się tacy dobrzy?%SPEECH_OFF%Odwracasz się i widzisz chłopca, który nerwowo się w ciebie wpatruje. Uśmiechając się, mówisz mu prawdę.%SPEECH_ON%Gdy byłem w twoim wieku, zabijałem ludzi w moim wieku.%SPEECH_OFF%Szczerzy się i pyta, czy jeśli będzie nad tym pracował, może być jak ty. Kiwasz głową i odpowiadasz.%SPEECH_ON%Nie dowiesz się, dopóki nie spróbujesz, dzieciaku. A teraz do domu.%SPEECH_OFF%Chłopiec wymachuje nożem do masła i pędzi jak szalony. To dobry chłopak.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "{Do diaska, nieźli jesteśmy. | Jesteśmy najlepsi.}",
					function getResult()
					{
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.Statistics.getFlags().increment("ArenaFightsWon", 1);
						this.World.Statistics.getFlags().increment("ArenaRegularFightsWon", 1);
						this.World.Contracts.finishActiveContract();

						if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 10)
						{
							this.updateAchievement("Gladiator", 1, 1);
						}

						return 0;
					}

				}
			]
		});
	}

	function getBros()
	{
		local ret = [];
		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && item.getID() == "accessory.arena_collar")
			{
				ret.push(bro);
			}
		}

		return ret;
	}

	function getAmountToSpawn( _type, _resources, _min = 1, _max = 24 )
	{
		return this.Math.min(_max, this.Math.max(_min, _resources / _type.Cost));
	}

	function addToCombat( _list, _entityType, _champion = false, _name = "" )
	{
		local c = clone _entityType;

		if (c.Variant != 0 && _champion)
		{
			c.Variant = 1;
			c.Name <- _name;
		}
		else
		{
			c.Variant = 0;
		}

		_list.push(c);
	}

	function getScaledDifficultyMult()
	{
		local p = this.World.State.getPlayer().getStrength();
		p = p / this.World.getPlayerRoster().getSize();
		p = p * 12;
		local s = this.Math.maxf(0.75, 1.0 * this.Math.pow(0.01 * p, 0.95) + this.Math.minf(0.5, (this.World.getTime().Days + this.World.Statistics.getFlags().getAsInt("ArenaFightsWon")) * 0.01));
		local d = this.Math.minf(5.0, s);
		return d * this.Const.Difficulty.EnemyMult[this.World.Assets.getCombatDifficulty()];
	}

	function getReputationToPaymentMult()
	{
		local r = this.Math.minf(4.0, this.Math.maxf(0.9, this.Math.pow(this.Math.maxf(0, 0.003 * this.World.Assets.getBusinessReputation() * 0.5 + this.getScaledDifficultyMult()), 0.35)));
		return r * this.Const.Difficulty.PaymentMult[this.World.Assets.getEconomicDifficulty()];
	}

	function setScreenForArena()
	{
		if (!this.m.IsActive)
		{
			return;
		}

		if (this.getBros().len() == 0)
		{
			this.setScreen("Collars");
		}
		else if (this.World.getTime().Days > this.m.Flags.get("Day"))
		{
			this.setScreen("Failure2");
		}
		else
		{
			this.setScreen("Start");
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"numberC",
			this.m.Flags.get("Number") < this.Const.Strings.AmountC.len() ? this.Const.Strings.AmountC[this.m.Flags.get("Number")] : this.Const.Strings.AmountC[this.m.Flags.get("Number")]
		]);
		_vars.push([
			"number",
			this.m.Flags.get("Number") < this.Const.Strings.Amount.len() ? this.Const.Strings.Amount[this.m.Flags.get("Number")] : this.Const.Strings.Amount[this.m.Flags.get("Number")]
		]);
		_vars.push([
			"amount",
			this.m.Flags.get("Number")
		]);
		_vars.push([
			"champion1",
			this.m.Flags.get("Champion1")
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.m.Home.getSprite("selection").Visible = false;
			this.m.Home.getBuilding("building.arena").refreshCooldown();
			local roster = this.World.getPlayerRoster().getAll();

			foreach( bro in roster )
			{
				local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

				if (item != null && item.getID() == "accessory.arena_collar")
				{
					bro.getItems().unequip(item);
				}
			}

			local items = this.World.Assets.getStash().getItems();

			foreach( i, item in items )
			{
				if (item != null && item.getID() == "accessory.arena_collar")
				{
					items[i] = null;
				}
			}
		}
	}

	function isValid()
	{
		return this.Const.DLC.Desert;
	}

	function onSerialize( _out )
	{
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.contract.onDeserialize(_in);
	}

});

