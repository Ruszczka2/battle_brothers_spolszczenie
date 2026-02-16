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
			Text = "[img]gfx/ui/events/event_16.png[/img]{Docieracie do odległej wioski i widzicie kilku mieszkańców przykucniętych przed dużą, wybieloną czaszką, która dekoracyjnie spoczywa na pulpicie. Przechodzący chłopi przystają i oddają jej część. Gdy podchodzisz bliżej, widzisz, że sama czaszka jest niezwykła: długie, grube czoło wystaje z góry, łuk brwiowy jest wyraźny i pofalowany, a szczęka, nadal nienaruszona, nosi ogromne, ostre zęby, w większości chaotycznie ustawione, jakby w zwykłej głowie zamknięcie takiej paszczy stanowiło zagrożenie dla niej samej. To może być czaszka Nachzehrera. Oczywiście, mając przed sobą ten dziwny kościotrup, chcesz odprowadzić kompanię, zanim-%SPEECH_ON%Powinniśmy to zabrać do badań.%SPEECH_OFF%Wzdychasz i obracasz się, by zobaczyć %anatomist% stojącego i gapiącego się na czaszkę. Poprawiasz go, że tak naprawdę chodzi mu o kradzież. Anatomista patrzy na ciebie.%SPEECH_ON%Słownictwo nie ma znaczenia, gdy badania będą zakończone, w naszych rękach przyda się bardziej niż w ich, to jasne.%SPEECH_OFF%}",
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
						Text = "A co na to nasz złodziej, %thief%?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Wildman != null)
				{
					this.Options.push({
						Text = "Ta czaszka wygląda jak nasz dzikus, %wildman%.",
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
			Text = "[img]gfx/ui/events/event_46.png[/img]{Wzdychasz i przystajesz na fanaberie anatomisty, ale mówisz mu, że to on ma ukraść, skoro to on chce badać. Mężczyzna nawet się nie waha i rusza, mrużąc oczy na kościsty obiekt w centrum jego naukowej obsesji. Nie zamierzasz być odpowiedzialny za bałagan, jeśli go złapią, więc zostawiasz go, a sam wracasz do liczenia zapasów, nasłuchując odgłosów religijnego chaosu. Po chwili %anatomist% wraca z wielką czaszką pod pachą i kropelkami potu na czole.%SPEECH_ON%To czaszka Nachzehrera i powinna być bardzo cenna dla naszych badań.%SPEECH_OFF%Z ciekawości pytasz, jak w ogóle zdołał ją zdobyć. %anatomist% unosi brew.%SPEECH_ON%Nie patrzyłeś? Uznałem, że to było dość imponujące, ale tak imponujące, że opowiadanie z drugiej ręki sprawi, iż uznasz, że bajdurzę. Baśń, jeśli wolisz. Wiedz tylko, że powinniśmy się stąd wynieść. Może wcześniej niż wkrótce, i szybciej niż szybko. Rozumiesz?%SPEECH_OFF%W oddali narasta krzyk. Anatomista ociera czoło i odchodzi. Tył jego koszuli jest rozszarpany, a z pleców wystają mu małe groty lub strzały - a odległe krzyki robią się coraz głośniejsze.}",
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
				_event.m.Anatomist.improveMood(1.0, "Zdobył niezwykłą czaszkę do badań");
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{Mówisz %anatomist%, że może wziąć czaszkę. Przez chwilę patrzy na ciebie, po czym stwierdza, że myślał, iż to ty to zrobisz. Mówisz mu, że nie ma mowy, żebyś zabierał czaszkę miejscowym chłopom, którzy ją czczą. Jeśli chce badać, to on powinien kraść. %anatomist% kładzie dłoń na piersi.%SPEECH_ON%Jestem człowiekiem nauki, nie zwykłym skrybą, nie mogę się posunąć do tak niskiego zadania. Potrzeba człowieka z doświadczeniem, który zna trud i brud codziennego życia, by ukraść tę czaszkę.%SPEECH_OFF%Anatomista zaciska pięść, tak pewny, że jego mowa cię nie obrażała, a jego oczy wpatrują się z zawziętością, która może być tylko wyuczona.%SPEECH_ON%O czym wy dwoje obcy gadacie?%SPEECH_OFF%Obaj odwracacie się i widzicie chłopa z widłami, a gdy dołączają kolejni, wskazuje na was.%SPEECH_ON%Ci goście chcieli ukraść czaszkę!%SPEECH_OFF%Wyciągasz ręce, tłumacząc, że- zanim skończysz, %anatomist% odwraca się i ucieka. Myśląc szybko, nazywasz go złodziejem i obiecujesz jego głowę, robiąc wielkie przedstawienie z dobyciem miecza i wymachiwaniem nim na chłopów. Udajesz, że przypadkiem upuszczasz sakiewkę z koronami, zamieniając złość chłopów w chciwość i dając sobie czas na ucieczkę.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wynosimy się stąd.",
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
			Text = "[img]gfx/ui/events/event_65.png[/img]{Wzdychasz i zgadzasz się na kradzież czaszki. Zanim zdążysz coś powiedzieć, pojawia się %thief% złodziej. Podchodzi, przegryzając trawę i krocząc z brawurą.%SPEECH_ON%Więc chcesz coś ukraść, hm? Wskaż tylko, czego potrzebujesz, a ja to przyniosę. Złoto? Broń?%SPEECH_OFF%%anatomist% wskazuje na czaszkę. Złodziej przez chwilę się na nią gapi, po czym odwraca się z powrotem.%SPEECH_ON%No, eee, dobra.%SPEECH_OFF%Złodziej i przyszły złodziej czaszki odchodzą. Idziesz liczyć zapasy, dając mu czas na robotę. Później wraca z czaszką, a do tego z naręczem broni i zbroi, o których wiesz, że ich nie kupił. Gdy wpatrujesz się w oczywiście skradzione dobra, mężczyzna wzrusza ramionami.%SPEECH_ON%Co? Musiałem sprawić, by to się opłacało.%SPEECH_OFF%Anatomista zabiera czaszkę bez słowa, niosąc ją i wpatrując się w puste oczodoły, jakby to był kochanek, mamrocząc, że wiele rzeczy nauczy się z jej pustego spojrzenia. Złodziej robi to samo, tylko z sakiewką koron i innymi dobrami, mamrocząc, że w końcu będzie go stać na dwie dziwki naraz, co najwyraźniej było jego odwiecznym marzeniem. Zabierasz broń i zbroję do ekwipunku, a w oddali słyszysz zawodzenie chłopów szukających relikwii.}",
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
				_event.m.Anatomist.improveMood(1.0, "Zdobył niezwykłą czaszkę do badań");
				_event.m.Thief.improveMood(1.0, "Udanie okradł chłopów");

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
					text = _event.m.Anatomist.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+100[/color] Doświadczenia"
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
			Text = "[img]gfx/ui/events/event_43.png[/img]{Decydujesz, że skoro anatomisci mogą zrobić z czaszki coś wielkiego, to dasz im szansę na badania. Pytanie brzmi: jak ukraść paskudną czaszkę od grupy tak szalonej, że ją czci? Jak na zawołanie pojawia się %wildman% dzikus, zajadając garść robaków. Jego obmyta natura twarz i okrutnie ukształtowana czaszka wydają się niemal spokrewnione z potwornością, która spoczywa na pulpicie w centrum wioski. %anatomist% pstryka palcami i twierdzi, że ma pomysł. Wciąga dzikusa do przodu, a obaj idą prosto do ukochanej czaszki wioski.\n\nAnatomista popycha dzikusa przed modlące się tłumy i twierdzi, że zamordowali kogoś spokrewnionego z jego istotą. Mówi, że kradnąc czaszkę jego krewnego, skazali go na życie w przekleństwie. Tłum jest przerażony, nie rozumiejąc swojego błędu. Dzikus zjada kolejnego robaka. Dalej patrzysz, jak anatomista podnosi czaszkę, unosi ją nad głową i mówi, że dzięki temu wreszcie wyleczy %wildman% z jego dolegliwości, a tym samym zdejmie przekleństwa, które spadły na wioskę. W tym momencie tłum już wstaje, przyjmując anatomistę jak kapłana pod namiotem, i bije brawo, gdy odchodzi, wiwatując na kradzież, jakby to było coś dobrego, z czaszką uniesioną nad głową. Obaj mężczyźni wracają do ciebie. %anatomist% uśmiecha się.%SPEECH_ON%By badać ciało, nie wolno zapomnieć o badaniu umysłu, a badając umysł, nie wolno zapominać o badaniu umysłów, w liczbie mnogiej! Wiele umysłów złożonych razem to stworzenie do badania samo w sobie.%SPEECH_OFF%Anatomista odchodzi. Podchodzi grupa chłopów niosących różne dobra. Rzucają je u stóp %wildman% na znak przeprosin. Dzikus zjada kolejnego robaka.}",
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
				_event.m.Anatomist.improveMood(1.0, "Zdobył niezwykłą czaszkę do badań");
				_event.m.Wildman.improveMood(1.0, "Pomógł " + _event.m.Anatomist.getName() + " zdobyć niezwykłą czaszkę");

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
					text = _event.m.Wildman.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+75[/color] Doświadczenia"
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

