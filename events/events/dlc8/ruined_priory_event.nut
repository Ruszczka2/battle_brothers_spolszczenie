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
			Text = "[img]gfx/ui/events/event_40.png[/img]{Napotykasz mnicha stojacego przed klasztorem. Mury budynku zostaly roztrzaskane, plyty kamienia wyprysly z fundamentow, a mniejsze kamienie zamienily sie w pyl podczas zawalenia. Wyjasnia, ze trzesienie ziemi przesunelo caly obiekt, odrywajac kawalki i niemal zwalajac wszystko na ziemie. Wzdycha.%SPEECH_ON%Najgorsze nie sa same zniszczenia, najgorsze jest to, ze trzesienie wstrzasnelo samymi wiernymi, luzujac ich rezerwe na cierpienie, ktore jest wpisane w nasza codziennosc. Jeszcze do mnie nie wrocili, bo boja sie, ze starzy bogowie wybrali nasze ziemie jako punkt kary za jakis nieuswiadomiony blad.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mamy zloto. Czy odbudujesz za 2500 koron?",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 80 ? "B" : "C";
					}

				},
				{
					Text = "Mamy narzedzia. Chyba 40 wystarczy?",
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
			Text = "[img]gfx/ui/events/event_40.png[/img]{Placisz mnichowi pieniadze na naprawe klasztoru. Zalewa sie lzami, mowiac, ze nie spodziewal sie, iz tacy honorowi ludzie w ogole istnieja na tym swiecie, a tym bardziej ze spotka ich osobiscie. Sam fakt, ze tu jestes i ze jestes tak szczodry, to znak, ze starzy bogowie go nie karza.%SPEECH_ON%Te korony nie tylko pozwola mi odbudowac, ale taka hojnosc zostanie uznana przez miejscowych za znak, ze starzy bogowie wcale nas nie karza! Prosze, wezmij to. Ledwo przetrwalo gruzy, ale moze z czasem lepiej je wykorzystasz niz my kiedykolwiek moglibysmy.%SPEECH_OFF%}",
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
						bro.improveMood(0.75, "Kompania pomogla odnowic klasztor");
					}
					else if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(0.5, "Kompania pomogla odnowic klasztor");
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{Kladziesz dlon na ramieniu mnicha. Spoglada na ciebie ze lzami w oczach, po czym zerka na sakiewke koron, ktora wyciagasz. Bierze ja i trzyma czule, jakby nigdy w zyciu niczego nie dostal.%SPEECH_ON%To... to dla klasztoru?%SPEECH_OFF%Kiwajac glowa, mowisz mu, by uzyla tego na odbudowe. Zaczynasz nawet sugerowac dodanie skromnej dzwonnicy, ale wlasnie gdy zaczynasz z tymi architektonicznymi wywodami, na droge wpada krzyczacy mezczyzna, wskazujac palcem, a jego stopy bija zawziecie ziemie.%SPEECH_ON%Nie ufajcie temu szczurowi! To nic niewarty zebr!%SPEECH_OFF%Gdy odwracasz sie z powrotem, rzekomy mnich z progow klasztoru juz ucieka, biegnac droga, przeskakujac przez pokrzywy i znikajac w krzakach i drzewach, z pieniedzmi w reku i rechotem w powietrzu. Mezczyzna z drogi rozklada rece.%SPEECH_ON%Ten sprytny lajdak od tygodni odgrywa nieszczescie. Ten budynek jest martwy i porzucony, nie byl zajety od czasu, gdy zielonoskory go zniszczyli dziesiec lat temu. Wiem, ze chcieliscie postapic dobrze, ale wielu na tym swiecie widzi wasza szczodrosc jako wielki cel do trafienia. Wybaczcie, ze was oszukano, panowie.%SPEECH_OFF%}",
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
						bro.worsenMood(0.5, "Dobrosc kompani zostala wykorzystana");
					}
					else
					{
						bro.worsenMood(0.75, "Kompania dala sie oszukac na korony przez szarlatana");
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
			Text = "[img]gfx/ui/events/event_85.png[/img]{Uwazasz, ze %companyname% ma narzedzia i ludzi, by wykonac zadanie samodzielnie. Z usmiechem mowisz mnichowi, ze zabieracie sie do naprawy klasztoru. Swiety czlowiek jest zachwycony, gdy ty i Swietobiorcy zbieracie sprzet i zaczynacie prace. Trwa to kilka godzin, ale pot i krew sa tego warte. Gdy konczycie, pojawia sie gromada chlopow i odchodza nie tylko z myslami o starych bogach, ale i z imieniem %companyname% na ustach. Bez watpienia wielu uslyszy o Swietobiorcach przez nadchodzace dni!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tak powinno byc.",
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
					text = "Kompania zyskala slawe"
				});
				this.World.Assets.addArmorParts(-40);
				this.List.push({
					id = 11,
					icon = "ui/icons/asset_supplies.png",
					text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]40[/color] Narzedzi i Zapasow"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.paladin")
					{
						bro.improveMood(1.0, "Pomogl naprawic uszkodzony klasztor");
					}
					else
					{
						bro.improveMood(0.75, "Pomogl naprawic uszkodzony klasztor");
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
			Text = "[img]gfx/ui/events/event_40.png[/img]{Lapiesz mnicha i stawiasz go na nogi. Mowisz mu, ze %companyname% naprawi klasztor. Jest zaplakany i szczesliwy, choc ostrzega, ze moze byc juz nie do uratowania. Usmiechajac sie, mowisz mu, ze dla Swietobiorcow nie ma zadan zbyt wielkich. Chwile pozniej %injurybro% napiera na rozwalona sciane, ale dolna czesc zapada sie do srodka, a gorna rozsypuje na zewnatrz, natychmiast zasypujac go gruzem. Kompania krzyczy z przerazenia i rusza go wyciagnac, a wtedy reszta budynku wali sie, skladajac w strumien pylu kamiennego. %injurybro% zostaje uratowany z rumowiska, choc z niema porcja ran.%SPEECH_ON%Coz, chyba liczy sie intencja.%SPEECH_OFF%Mowi mnich, drapiac sie po karku.%SPEECH_ON%Byc moze starzy bogowie naprawde chcieli nas tu ukarac. Ale niewazne, uwazam, ze postapiliscie slusznie, a w probie jest godnosc, prawda? Bede dobrze o was mowil, %companyname%.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Moglo pojsc lepiej.",
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
					text = "Kompania zyskala slawe"
				});
				_event.m.InjuryBro.addHeavyInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.InjuryBro.getName() + " doznaje ciezkich ran"
				});
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_64.png[/img]{Postanawiasz, ze ta sprawa nie jest twoja. Ta decyzja sprawia, ze kilku ludzi zaczyna kwestionowac twoje przywodztwo. Jasne, nie da sie dotrzymac wszystkich Slubow zawsze, ale zeby nie poswiecic nawet kropli potu ani odrobiny korony, by pomoc swietemu czlowiekowi i jego trzodzie? To w pominieciu drobnostek, tych rzeczy, ktore w ogole nie wymagaja wysilku, czlowiek moze stoczyc sie w bezdusznego dzikusa.}",
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
						bro.worsenMood(0.75, "Odmowiles pomocy mnichowi w potrzebie");
					}
					else if (this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(0.5, "Odmowiles pomocy mnichowi w potrzebie");
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

