this.anatomist_wants_skull_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Thief = null,
		Wildman = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_wants_skull";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_16.png[/img]{Docieracie do odleglej wioski i widzicie kilku mieszkancow przykucnietych przed duza, wybielona czaszka, ktora dekoracyjnie spoczywa na pulpicie. Przechodzacy chlopi przystaja i oddaja jej czesc. Gdy podchodzisz blizej, widzisz, ze sama czaszka jest niezwykla: dlugie, grube czolo wystaje z gory, luk brwiowy jest wyrazny i pofalowany, a szczeka, nadal nienaruszona, nosi ogromne, ostre zeby, w wiekszosci chaotycznie ustawione, jakby w zwyklej glowie zamkniecie takiej paszczy stanowilo zagrozenie dla niej samej. To moze byc czaszka Nachzehrera. Oczywiscie, majac przed soba ten dziwny kosciotrup, chcesz odprowadzic kompanie, zanim-%SPEECH_ON%Powinnismy to zabrac do badan.%SPEECH_OFF%Wzdychasz i obracasz sie, by zobaczyc %anatomist% stojacego i gapiacego sie na czaszke. Poprawiasz go, ze tak naprawde chodzi mu o kradziez. Anatomista patrzy na ciebie.%SPEECH_ON%Slownictwo nie ma znaczenia, gdy badania beda zakonczone, w naszych rekach przyda sie bardziej niz w ich, to jasne.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze, weź to.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "Nie, raczej nie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Thief != null)
				{
					this.Options.push({
						Text = "A co na to nasz zlodziej, %thief%?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Wildman != null)
				{
					this.Options.push({
						Text = "Ta czaszka wyglada jak nasz dzikus, %wildman%.",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Wzdychasz i przystajesz na fanaberie anatomisty, ale mowisz mu, ze to on ma ukrasc, skoro to on chce badac. Mezczyzna nawet sie nie waha i rusza, mruzac oczy na kosciasty obiekt w centrum jego naukowej obsesji. Nie zamierzasz byc odpowiedzialny za balagan, jesli go zlapia, wiec zostawiasz go, a sam wracasz do liczenia zapasow, nasluchujac odglosow religijnego chaosu. Po chwili %anatomist% wraca z wielka czaszka pod pacha i kropelkami potu na czole.%SPEECH_ON%To czaszka Nachzehrera i powinna byc bardzo cenna dla naszych badan.%SPEECH_OFF%Z ciekawosci pytasz, jak w ogole zdolal ja zdobyc. %anatomist% unosi brew.%SPEECH_ON%Nie patrzyles? Uznalem, ze to bylo dosc imponujace, ale tak imponujace, ze opowiadanie z drugiej reki sprawi, iz uznasz, ze bajdurze. Basm, jesli wolisz. Wiedz tylko, ze powinnismy sie stad wyniesc. Moze wczesniej niz wkrotce, i szybciej niz szybko. Rozumiesz?%SPEECH_OFF%W oddali narasta krzyk. Anatomista ociera czolo i odchodzi. Tyl jego koszuli jest rozszarpany, a z plecow wystaja mu male groty lub strzaly - a odlegle krzyki robia sie coraz glosniejsze.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Hmm.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Zdobył niezwykla czaszke do badan");
				_event.m.Anatomist.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Anatomist.getName() + " odnosi lekkie rany"
				});
				local resolveBoost = this.Math.rand(1, 3);
				local initiativeBoost = this.Math.rand(1, 3);
				_event.m.Anatomist.getBaseProperties().Bravery += resolveBoost;
				_event.m.Anatomist.getBaseProperties().Initiative += initiativeBoost;
				_event.m.Anatomist.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Anatomist.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolveBoost + "[/color] Determinacji"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Anatomist.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiativeBoost + "[/color] Inicjatywy"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Mowisz %anatomist%, ze moze wziac czaszke. Przez chwile patrzy na ciebie, po czym stwierdza, ze myslal, iz to ty to zrobisz. Mowisz mu, ze nie ma mowy, zebys zabieral czaszke miejscowym chlopom, ktorzy ja czcza. Jesli chce badac, to on powinien krasc. %anatomist% kladzie dlon na piersi.%SPEECH_ON%Jestem czlowiekiem nauki, nie zwyklym skryba, nie moge sie posunac do tak niskiego zadania. Potrzeba czlowieka z doswiadczeniem, ktory zna trud i brud codziennego zycia, by ukrasc ta czaszke.%SPEECH_OFF%Anatomista zaciska piesc, tak pewny, ze jego mowa cie nie obrazala, a jego oczy wpatruja sie z zawzietoscia, ktora moze byc tylko wyuczona.%SPEECH_ON%O czym wy dwoje obcy gadacie?%SPEECH_OFF%Obaj odwracacie sie i widzicie chlopa z widlami, a gdy dolacza kolejni, wskazuje na was.%SPEECH_ON%Ci goscie chcieli ukrasc czaszke!%SPEECH_OFF%Wyciagasz rece, tlumaczac, ze- zanim skoncysz, %anatomist% odwraca sie i ucieka. Myslac szybko, nazywasz go zlodziejem i obiecujesz jego glowe, robiac wielkie przedstawienie z dobyciem miecza i wymachiwaniem nim na chlopow. Udajesz, ze przypadkiem upuszczasz sakiewke z koronami, zamieniajac zlosc chlopow w chciwosc i dajac sobie czas na ucieczke.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wynosimy sie stad.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-100);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]100[/color] Koron"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_65.png[/img]{Wzdychasz i zgadzasz sie na kradziez czaszki. Zanim zdazysz cos powiedziec, pojawia sie %thief% zlodziej. Podchodzi, przegryzajac trawe i kroczac z brawura.%SPEECH_ON%Wiec chcesz cos ukrasc, hm? Wskaz tylko, czego potrzebujesz, a ja to przyniose. Zloto? Bron?%SPEECH_OFF%%anatomist% wskazuje na czaszke. Zlodziej przez chwile sie na nia gapi, po czym odwraca sie z powrotem.%SPEECH_ON%No, eee, dobra.%SPEECH_OFF%Zlodziej i przyszly zlodziej czaszki odchodza. Idziesz liczyc zapasy, dajac mu czas na robote. Pozniej wraca z czaszka, a do tego z naręczem broni i zbroi, o ktorych wiesz, ze ich nie kupil. Gdy wpatrujesz sie w oczywiscie skradzione dobra, mezczyzna wzrusza ramionami.%SPEECH_ON%Co? Musialem sprawic, by to sie oplacalo.%SPEECH_OFF%Anatomista zabiera czaszke bez slowa, niosac ja i wpatrujac sie w puste oczodoły, jakby to byl kochanek, mamroczac, ze wiele rzeczy nauczy sie z jej pustego spojrzenia. Zlodziej robi to samo, tylko z sakiewka koron i innymi dobrami, mamroczac, ze w koncu bedzie go stac na dwie dziwki naraz, co najwyrazniej bylo jego odwiecznym marzeniem. Zabierasz bron i zbroje do ekwipunku, a w oddali slyszysz zawodzenie chlopow szukajacych relikwii.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wygrana to wygrana.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Zdobył niezwykla czaszke do badan");
				_event.m.Thief.improveMood(1.0, "Udanie okradl chlopow");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				if (_event.m.Thief.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Thief.getMoodState()],
						text = _event.m.Thief.getName() + this.Const.MoodStateEvent[_event.m.Thief.getMoodState()]
					});
				}

				_event.m.Anatomist.addXP(100, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+100[/color] Doswiadczenia"
				});
				local initiativeBoost = this.Math.rand(2, 4);
				_event.m.Thief.getBaseProperties().Initiative += initiativeBoost;
				_event.m.Thief.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Thief.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiativeBoost + "[/color] Inicjatywy"
				});
				local item;
				local weaponList = [
					"militia_spear",
					"militia_spear",
					"militia_spear",
					"shortsword",
					"falchion",
					"light_crossbow"
				];
				local itemAmount = this.Math.rand(1, 2);

				for( local i = 0; i < itemAmount; i = ++i )
				{
					item = this.new("scripts/items/weapons/" + weaponList[this.Math.rand(0, weaponList.len() - 1)]);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Zyskujesz " + item.getName()
					});
					this.World.Assets.getStash().add(item);
				}

				local armorList = [
					"leather_tunic",
					"leather_tunic",
					"thick_tunic",
					"thick_tunic",
					"padded_surcoat",
					"padded_leather"
				];
				itemAmount = this.Math.rand(1, 2);

				for( local i = 0; i < itemAmount; i = ++i )
				{
					item = this.new("scripts/items/armor/" + armorList[this.Math.rand(0, armorList.len() - 1)]);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Zyskujesz " + item.getName()
					});
					this.World.Assets.getStash().add(item);
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Thief.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Decydujesz, ze skoro anatomisci moga zrobic z czaszki cos wielkiego, to dasz im szanse na badania. Pytanie brzmi: jak ukrasc paskudna czaszke od grupy tak szalonej, ze ja czci? Jak na zawolanie pojawia sie %wildman% dzikus, zajadajac garsc robakow. Jego obmyta natura twarz i okrutnie uksztaltowana czaszka wydaja sie niemal spokrewnione z potwornoscia, ktora spoczywa na pulpicie w centrum wioski. %anatomist% pstryka palcami i twierdzi, ze ma pomysl. Wciaga dzikusa do przodu, a obaj ida prosto do ukochanej czaszki wioski.\n\nAnatomista popycha dzikusa przed modlace sie tlumy i twierdzi, ze zamordowali kogos spokrewnionego z jego istota. Mowi, ze kradnac czaszke jego krewnego, skazali go na zycie w przeklenstwie. Tlum jest przerazony, nie rozumiejac swojego bledu. Dzikus zjada kolejnego robaka. Dalej patrzysz, jak anatomista podnosi czaszke, unosi ja nad glowa i mowi, ze dzieki temu wreszcie wyleczy %wildman% z jego dolegliwosci, a tym samym zdejmie przeklenstwa, ktore spadly na wioske. W tym momencie tlum juz wstaje, przyjmujac anatomiste jak kaplana pod namiotem, i bije brawo, gdy odchodzi, wiwatujac na kradziez, jakby to bylo cos dobrego, z czaszka uniesiona nad glowa. Obaj mezczyzni wracaja do ciebie. %anatomist% usmiecha sie.%SPEECH_ON%By badac cialo, nie wolno zapomniec o badaniu umyslu, a badajac umysl, nie wolno zapominac o badaniu umyslow, w liczbie mnogiej! Wiele umyslow zlozonych razem to stworzenie do badania samo w sobie.%SPEECH_OFF%Anatomista odchodzi. Podchodzi grupa chlopow niosacych rozne dobra. Rzucaja je u stop %wildman% na znak przeprosin. Dzikus zjada kolejnego robaka.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Hmm, dobrze.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Zdobył niezwykla czaszke do badan");
				_event.m.Wildman.improveMood(1.0, "Pomogl " + _event.m.Anatomist.getName() + " zdobyc niezwykla czaszke");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				if (_event.m.Wildman.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Wildman.getMoodState()],
						text = _event.m.Wildman.getName() + this.Const.MoodStateEvent[_event.m.Wildman.getMoodState()]
					});
				}

				local initiativeBoost = this.Math.rand(1, 3);
				_event.m.Anatomist.getBaseProperties().Initiative += initiativeBoost;
				_event.m.Anatomist.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Anatomist.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiativeBoost + "[/color] Inicjatywy"
				});
				_event.m.Wildman.addXP(75, false);
				_event.m.Wildman.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Wildman.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+75[/color] Doswiadczenia"
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
					text = "Zyskujesz " + food.getName()
				});
				local goods;
				r = this.Math.rand(1, 2);

				if (r == 1)
				{
					goods = this.new("scripts/items/trade/cloth_rolls_item");
				}
				else if (r == 2)
				{
					goods = this.new("scripts/items/trade/peat_bricks_item");
				}

				this.World.Assets.getStash().add(goods);
				this.List.push({
					id = 10,
					icon = "ui/items/" + goods.getIcon(),
					text = "Zyskujesz " + goods.getName()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Wildman.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];
		local thief_candidates = [];
		local wildman_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.thief")
			{
				thief_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.wildman")
			{
				wildman_candidates.push(bro);
			}
		}

		if (thief_candidates.len() > 0)
		{
			this.m.Thief = thief_candidates[this.Math.rand(0, thief_candidates.len() - 1)];
		}

		if (wildman_candidates.len() > 0)
		{
			this.m.Wildman = wildman_candidates[this.Math.rand(0, wildman_candidates.len() - 1)];
		}

		if (anatomist_candidates.len() > 0)
		{
			this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		}
		else
		{
			return;
		}

		this.m.Score = 5 + anatomist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
		_vars.push([
			"thief",
			this.m.Thief != null ? this.m.Thief.getNameOnly() : ""
		]);
		_vars.push([
			"wildman",
			this.m.Wildman != null ? this.m.Wildman.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Thief = null;
		this.m.Wildman = null;
	}

});

