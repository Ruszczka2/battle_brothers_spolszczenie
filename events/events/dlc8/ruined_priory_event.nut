this.ruined_priory_event <- this.inherit("scripts/events/event", {
	m = {
		InjuryBro = null
	},
	function create()
	{
		this.m.ID = "event.ruined_priory";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_40.png[/img]{Napotykasz mnicha stojącego przed klasztorem. Mury budynku zostały roztrzaskane, płyty kamienia wyprysły z fundamentów, a mniejsze kamienie zamieniły się w pył podczas zawalenia. Wyjaśnia, że trzęsienie ziemi przesunęło cały obiekt, odrywając kawałki i niemal zwalając wszystko na ziemię. Wzdycha.%SPEECH_ON%Najgorsze nie są same zniszczenia, najgorsze jest to, że trzęsienie wstrząsnęło samymi wiernymi, luzując ich rezerwę na cierpienie, które jest wpisane w naszą codzienność. Jeszcze do mnie nie wrócili, bo boją się, że starzy bogowie wybrali nasze ziemie jako punkt kary za jakiś nieuświadomiony błąd.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mamy złoto. Czy odbudujesz za 2500 koron?",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 80 ? "B" : "C";
					}

				},
				{
					Text = "Mamy narzędzia. Chyba 40 wystarczy?",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 75 ? "D" : "E";
					}

				},
				{
					Text = "To nie nasz problem.",
					function getResult( _event )
					{
						return "F";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_40.png[/img]{Płacisz mnichowi pieniądze na naprawę klasztoru. Zalewa się łzami, mówiąc, że nie spodziewał się, iż tacy honorowi ludzie w ogóle istnieją na tym świecie, a tym bardziej że spotka ich osobiście. Sam fakt, że tu jesteś i że jesteś tak szczodry, to znak, że starzy bogowie go nie karzą.%SPEECH_ON%Te korony nie tylko pozwolą mi odbudować, ale taka hojność zostanie uznana przez miejscowych za znak, że starzy bogowie wcale nas nie karzą! Proszę, weźmij to. Ledwo przetrwało gruzy, ale może z czasem lepiej je wykorzystasz niż my kiedykolwiek moglibyśmy.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Taka nasza robota.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(6);
				this.World.Assets.addMoney(-2500);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]2500[/color] Koron"
				});
				local item = this.new("scripts/items/weapons/noble_sword");
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(60, 80) * 0.01));
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.paladin")
					{
						bro.improveMood(0.75, "Kompania pomogła odnowić klasztor");
					}
					else if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(0.5, "Kompania pomogła odnowić klasztor");
					}

					if (bro.getMoodState() > this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 11,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Kładziesz dłoń na ramieniu mnicha. Spogląda na ciebie ze łzami w oczach, po czym zerka na sakiewkę koron, którą wyciągasz. Bierze ją i trzyma czule, jakby nigdy w życiu niczego nie dostał.%SPEECH_ON%To... to dla klasztoru?%SPEECH_OFF%Kiwając głową, mówisz mu, by użyła tego na odbudowę. Zaczynasz nawet sugerować dodanie skromnej dzwonnicy, ale właśnie gdy zaczynasz z tymi architektonicznymi wywodami, na drogę wpada krzyczący mężczyzna, wskazując palcem, a jego stopy biją zawzięcie ziemię.%SPEECH_ON%Nie ufajcie temu szczurowi! To nic niewarty żebrak!%SPEECH_OFF%Gdy odwracasz się z powrotem, rzekomy mnich z progów klasztoru już ucieka, biegnąc drogą, przeskakując przez pokrzywy i znikając w krzakach i drzewach, z pieniędzmi w ręku i rechotem w powietrzu. Mężczyzna z drogi rozkłada ręce.%SPEECH_ON%Ten sprytny łajdak od tygodni odgrywa nieszczęście. Ten budynek jest martwy i porzucony, nie był zajęty od czasu, gdy zielonoskórzy go zniszczyli dziesięć lat temu. Wiem, że chcieliście postąpić dobrze, ale wielu na tym świecie widzi waszą szczodrość jako wielki cel do trafienia. Wybaczcie, że was oszukano, panowie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cholera.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-2500);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]2500[/color] Koron"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.paladin" && this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(0.5, "Dobroć kompani została wykorzystana");
					}
					else
					{
						bro.worsenMood(0.75, "Kompania dała się oszukać na korony przez szarlatana");
					}

					if (bro.getMoodState() < this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_85.png[/img]{Uważasz, że %companyname% ma narzędzia i ludzi, by wykonać zadanie samodzielnie. Z uśmiechem mówisz mnichowi, że zabieracie się do naprawy klasztoru. Święty człowiek jest zachwycony, gdy ty i Świętobiorcy zbieracie sprzęt i zaczynacie pracę. Trwa to kilka godzin, ale pot i krew są tego warte. Gdy kończycie, pojawia się gromada chłopów i odchodzą nie tylko z myślami o starych bogach, ale i z imieniem %companyname% na ustach. Bez wątpienia wielu usłyszy o Świętobiorcach przez nadchodzące dni!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tak powinno być.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(6);
				this.World.Assets.addBusinessReputation(100);
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "Kompania zyskała sławę"
				});
				this.World.Assets.addArmorParts(-40);
				this.List.push({
					id = 11,
					icon = "ui/icons/asset_supplies.png",
					text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]40[/color] Narzędzi i Zapasów"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.paladin")
					{
						bro.improveMood(1.0, "Pomógł naprawić uszkodzony klasztor");
					}
					else
					{
						bro.improveMood(0.75, "Pomógł naprawić uszkodzony klasztor");
					}

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 11,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_40.png[/img]{Łapiesz mnicha i stawiasz go na nogi. Mówisz mu, że %companyname% naprawi klasztor. Jest zapłakany i szczęśliwy, choć ostrzega, że może być już nie do uratowania. Uśmiechając się, mówisz mu, że dla Świętobiorców nie ma zadań zbyt wielkich. Chwilę później %injurybro% napiera na rozwaloną ścianę, ale dolna część zapada się do środka, a górna rozsypuje na zewnątrz, natychmiast zasypując go gruzem. Kompania krzyczy z przerażenia i rusza go wyciągnąć, a wtedy reszta budynku wali się, składając w strumień pyłu kamiennego. %injurybro% zostaje uratowany z rumowiska, choć z niema porcją ran.%SPEECH_ON%Cóż, chyba liczy się intencja.%SPEECH_OFF%Mówi mnich, drapiąc się po karku.%SPEECH_ON%Być może starzy bogowie naprawdę chcieli nas tu ukarać. Ale nieważne, uważam, że postąpiliście słusznie, a w próbie jest godność, prawda? Będę dobrze o was mówił, %companyname%.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mogło pójść lepiej.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(3);
				this.World.Assets.addBusinessReputation(35);
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "Kompania zyskała sławę"
				});
				_event.m.InjuryBro.addHeavyInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.InjuryBro.getName() + " doznaje ciężkich ran"
				});
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_64.png[/img]{Postanawiasz, że ta sprawa nie jest twoja. Ta decyzja sprawia, że kilku ludzi zaczyna kwestionować twoje przywództwo. Jasne, nie da się dotrzymać wszystkich Ślubów zawsze, ale żeby nie poświęcić nawet kropli potu ani odrobiny korony, by pomóc świętemu człowiekowi i jego trzodzie? To w pominięciu drobnostek, tych rzeczy, które w ogóle nie wymagają wysiłku, człowiek może stoczyć się w bezdusznego dzikusa.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tak, tak.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.paladin")
					{
						bro.worsenMood(0.75, "Odmówiłeś pomocy mnichowi w potrzebie");
					}
					else if (this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(0.5, "Odmówiłeś pomocy mnichowi w potrzebie");
					}

					if (bro.getMoodState() < this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		if (this.World.Assets.getMoney() < 3000)
		{
			return;
		}

		if (this.World.Assets.getArmorParts() < 40)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		this.m.InjuryBro = brothers[this.Math.rand(0, brothers.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"injurybro",
			this.m.InjuryBro.getName()
		]);
	}

	function onClear()
	{
		this.m.InjuryBro = null;
	}

});

