this.lawmen_after_criminal_event <- this.inherit("scripts/events/event", {
	m = {
		Criminal = null,
		OtherBro = null,
		NobleHouse = null
	},
	function create()
	{
		this.m.ID = "event.lawmen_after_criminal";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_90.png[/img]Jeźdźcy wspinają się na pobliskie wzgórze, ich sylwetki są ciemne i dziwnie poszarpane na grzbiecie, niczym rafa falującej czerni. Nie widząc dokładnie, kim są, rozkazujesz kilku braciom ukryć się. Zasadzka może być potrzebna do obrony, bo inaczej nie macie szans przeciwko takiej konnej sile. Gdy wybrani najemnicy znikają w krzakach, jeźdźcy zaczynają zjeżdżać ze wzgórza. Grzmot kopyt narasta, a ty stoisz niewzruszenie, licząc, że pokażesz ludziom dobrą lekcję odwagi.\n\nWidzisz, że chorąży niesie znak %noblehousename%. Za nim inny jeździec ciągnie travois z kilkoma skutejmi mężczyznami jako ładunkiem. Kiedy ludzie docierają, ich dowódca staje między kłębem konia i wskazuje na ciebie, po czym mówi.%SPEECH_ON%Najemniku! Z upoważnienia pana mamy prawo odebrać - zakute! - dłonie pewnego %criminal%. Ten człowiek jest wśród was. Musi zapłacić za swoje zbrodnie. Wydaj go natychmiast, a zostaniesz nagrodzony.%SPEECH_OFF%Odwracasz głowę i spluwasz. Kiwając na stróża prawa, zadajesz pytanie.%SPEECH_ON%A czyją macie władzę? W tych ziemiach jest wielu panów i nie wszyscy dobrze mi płacą.%SPEECH_OFF%Dowódca stróżów siada głębiej w siodle. Krzyżuje dłonie na łęku, spoczywając tam z opancerzoną stanowczością. Nie wygląda na rozbawionego i daje temu wyraz.%SPEECH_ON%Kara za świadome ukrywanie zbiegłego przestępcy to śmierć. Masz jeszcze jedną szansę wydać mi tego bandytę, albo spotka cię los odpowiedni dla psa sprzedającego miecz.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "Kompania tylko by ucierpiała, gdybyśmy o to walczyli. Człowiek jest wasz.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Nie wydamy go.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				if (this.World.Assets.getMoney() >= 1500)
				{
					this.Options.push({
						Text = "Chyba da się to rozwiązać ciężką sakwą koron?",
						function getResult( _event )
						{
							return "F";
						}

					});
				}

				if (this.World.Assets.getBusinessReputation() > 3000)
				{
					this.Options.push({
						Text = "Wiesz, komu grozisz? %companyname%!",
						function getResult( _event )
						{
							return "G";
						}

					});
				}
				else
				{
					this.Options.push({
						Text = "Masz rysunek człowieka, którego szukasz? Daj spojrzeć.",
						function getResult( _event )
						{
							return this.Math.rand(1, 100) <= 50 ? "D" : "E";
						}

					});
				}

				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Criminal.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_53.png[/img]Nie masz szans przeciwko tym ludziom. Choć bardzo cię to boli, wydajesz %criminal%. Warczy do ciebie przekleństwa, gdy stróże prawa zakuwają go w łańcuchy, i wdepcze twoje imię w błoto, gdy wrzucają go do reszty związanych. Dowódca stróżów podjeżdża do ciebie kłusem. Krzywi się na ciebie, po czym rzuca sakiewkę monet na ziemię. Jego ciało jest blisko i w zbroi ma lukę. Mógłbyś wbić tam nóż, między żebra, poprowadzić ostrze prosto do serca. Byłoby szybko. Ale nie przeżyłbyś długo potem, a wszyscy twoi ludzie szybko by zginęli.\n\nZamiast tego pochylasz się, podnosisz monety, przełykasz dumę i dziękujesz. Stróże prawa szybko wracają tam, skąd przybyli.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "Nie mogę narażać całej kompanii dla ciebie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Criminal.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/asset_brothers.png",
					text = _event.m.Criminal.getName() + " opuszcza kompanię"
				});
				_event.m.Criminal.getItems().transferToStash(this.World.Assets.getStash());
				_event.m.Criminal.getSkills().onDeath(this.Const.FatalityType.None);
				this.World.getPlayerRoster().remove(_event.m.Criminal);
				this.World.Assets.addMoney(100);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + 100 + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_10.png[/img]Gdy stróż prawa patrzy na ciebie, czekając na odpowiedź, wypuszczasz ostry gwizd. Połowa kompanii wychodzi z krzaków, wyjąc i rycząc w zasadzce. Rumak ciągnący travois zrzuca jeźdźca na ziemię, po czym ucieka, zabierając ze sobą grupę osłupiałych przestępców. Inny stróż prawa wycofuje się, porzucając swój oddział.\n\n%randombrother% zrywa jednego mężczyznę z siodła, podczas gdy inny brat wbija włócznię w pierś konia, powalając bestię i jeźdźca na ziemię. Dowódca spada z konia, gdy ten staje dęba w dzikim strachu. Upadek jest ciężki, ale udaje mu się stanąć na nogi, tylko po to, by brykający koń uderzył go w głowę. To szybka, tępa śmierć, która zostawia dowódcę twarzą w dół, w kołysce własnego hełmu.\n\nReszta jego ludzi staje przy ciele i patrzy na ciebie z żądzą zemsty w oczach.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "Szarża!",
					function getResult( _event )
					{
						_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationAttacked, "Zabiłeś kilku z ich ludzi");
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.NobleTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.TemporaryEnemies = [
							_event.m.NobleHouse.getID()
						];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Noble, this.Math.rand(80, 100) * _event.getReputationToDifficultyLightMult(), _event.m.NobleHouse.getID());
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Criminal.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_78.png[/img]Dowódca stróżów pstryka palcami na jednego z chorążych. Ten podaje zwój, który dowódca rozwija i wręcza ci. Mężczyzna na rysunku wygląda zadziwiająco jak %criminal%, ale odkąd jesteście w drodze, najemnik nabawił się kilku blizn, które odróżniają jego twarz od tej na papierze. Ale oni w to nie uwierzą. Więc kłamiesz.%SPEECH_ON%Człowiek, którego szukacie, nie żyje. Był przestępcą, tak jak mówicie, i złapaliśmy go, jak kradł nasze zapasy. %other_bro% przebił go mieczem, gdy się zorientowaliśmy.%SPEECH_OFF%Brat spogląda na ciebie, potem na stróżów. Kiwając głową, mówi.%SPEECH_ON%Tak było. Miał pełną gębę mojego chleba, gdy nadziałem go jak świnię! Resztę bochenka zachowałem dla siebie, dzięki bogom.%SPEECH_OFF%Stróże prawa chichoczą między sobą. Ich dowódca spogląda na nich, uciszającym spojrzeniem. Potem patrzy na ciebie. Widzisz, czemu zamilkli: jego oczy są surowe, nieruchome, groźne, czarne. Mężczyzna trzyma cię tym spojrzeniem niemal pół minuty, po czym kiwa głową i zbiera wodze.%SPEECH_ON%Dobrze, najemniku. Dziękuję, że nas poinformowałeś.%SPEECH_OFF%Stróże pakują się i wracają tam, skąd przybyli. Ulgowe westchnienie przechodzi przez kompanię i każesz ludziom ukrytym w krzakach wyjść. Przed wami długa droga i oby nie było więcej takich problemów.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "Uff.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Criminal.getImagePath());
				_event.m.Criminal.improveMood(2.0, "Został ochroniony przez kompanię");

				if (_event.m.Criminal.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Criminal.getMoodState()],
						text = _event.m.Criminal.getName() + this.Const.MoodStateEvent[_event.m.Criminal.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_78.png[/img]Dowódca podaje ci zwój z twarzą %criminal%. Rzeczywiście, podobieństwo jest. Ale człowiek jest w twojej kompanii dość długo, by nabawić się blizny czy dwóch. Może nie zorientują się, że to on? Prosisz przestępcę, by wystąpił, i nerwowo robi to, co mu każesz. Spoglądasz na dowódcę.%SPEECH_ON%Czy to człowiek, którego szukacie? Rozumiem, czemu możecie tak myśleć, ale spójrzcie na te blizny. Mężczyzna na rysunku żadnych nie ma. I spójrzcie na włosy! Ten z rysunku ma proste, a ten tutaj wyraźnie ma skołtunione i kręcone.%SPEECH_OFF%Milkniesz, bo po minach widzów widać, że to nawet nie zbliża się do skuteczności. Dowódca dobywa miecza.%SPEECH_ON%Masz mnie za głupca? Zabić ich wszystkich.%SPEECH_OFF%Cóż, tyle z tego. Zanim stróże prawa ruszą do ataku, gwiżdżesz jak najgłośniej potrafisz. Połowa kompanii wyrywa z krzaków, wyjąc i krzycząc jak banshee. Nagły strach płoszy konie, zrzucając jeźdźców w błoto, a koń ciągnący travois ucieka, zabierając ze sobą parę bardzo zdezorientowanych przestępców.\n\n%randombrother% wpada na pole zamętu z włócznią w dłoni. Wbija ją głęboko w rumaka dowódcy, powalając i bestię, i jeźdźca na ziemię. Stróże prawa, ci co zostali, gromadzą się wokół swojego dowódcy. Warcząc, mężczyzna ściera krew z twarzy i wypluwa ząb. Uśmiecha się szczerbato, po czym rozkazuje ludziom szarżować.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "Formować szyk!",
					function getResult( _event )
					{
						_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationAttacked, "Zabiłeś kilku z ich ludzi");
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.NobleTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.TemporaryEnemies = [
							_event.m.NobleHouse.getID()
						];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Noble, this.Math.rand(80, 100) * _event.getReputationToDifficultyLightMult(), _event.m.NobleHouse.getID());
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Criminal.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_04.png[/img]Groźby dowódcy stygną, gdy wyciągasz dużą sakiewkę koron. Jego ludzie wymieniają spojrzenia, gdy trzymasz worek w górze.%SPEECH_ON%Nie mamy na to czasu. Mam tu %bribe% koron. Weźcie i odejdźcie. Zostańcie, a zarobicie sobie na grób. Wybór należy do ciebie, stróżu prawa.%SPEECH_OFF%Wyczuwając spojrzenia swoich jeźdźców, dowódca szczególnie ostrożnie rozważa tę propozycję. Mierzy twoich ludzi, po czym krótko ocenia swoich. Musi widzieć wielkie straty, bo w końcu kiwa głową. Szarpie wodze i podjeżdża, tak że stajecie twarzą w twarz. Uśmiechasz się, gdy przekazujesz korony.%SPEECH_ON%Wydaj je dobrze.%SPEECH_OFF%Dowódca bierze sakiewkę i przypina ją do boku siodła, przekładając skórzany rzemień przez rękojeść miecza, a jego ludzie patrzą. Kiwając głową, nie odwzajemnia uśmiechu.%SPEECH_ON%Moja córka ma wyjść za mąż za dwa tygodnie. Chciałbym tam być.%SPEECH_OFF%Kiwasz głową i żegnasz się z ponurym dowódcą.%SPEECH_ON%Niech jej mąż będzie dobry, a dzieci liczne.%SPEECH_OFF%Dowódca cmoka na konia i prowadzi go z powrotem do swoich. Odjeżdżają, a kopyta ich wierzchowców dudnią coraz ciszej, aż zostaje tylko szelest wiatru w trawie.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "Czego to się dla was nie robi...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Criminal.getImagePath());
				this.World.Assets.addMoney(-1000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + 1000 + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_12.png[/img]Idziesz prosto w stronę dowódcy, zatrzymując się w połowie drogi między twoimi a jego ludźmi. Z rękami na biodrach wołasz do stróżów dowódcy, pytając, czy znają nazwę %companyname%. Widzisz, jak kilku jeźdźców prostuje się w siodłach, opierając złączone dłonie na łękach i wpatrując się uważnie w twój sztandar. Szybko siadają z powrotem, a stłumione szepty spływają w dół i znów w górę ich linii.\n\nJeden mężczyzna woła, czy to prawda, że obcinasz nosy tym, których zabijasz. To nieprawda, ale nie masz powodu, by zdradzać prawdę. Inny pyta, czy %randombrother% jest w twoich szeregach i czy ma naszyjnik z uszu oraz je mączkę kostną na śniadanie. Tłumisz chęć śmiechu, tylko kiwając głową. Zupełnie naturalnie plotki ogarniają przeciwników i zaczynają krzyczeć, że to nie ich walka.\n\nDowódca mówi im, że pieprzysz bzdury i każe szarżować, ale nikt nie wykonuje rozkazu. W końcu dowódca zmuszony jest zawrócić, podążając za swoimi ludźmi, którzy już się wycofują.\n\nRzekomy brat-kanibal podchodzi, drapiąc się po głowie.%SPEECH_ON%Mączka kostna na śniadanie?%SPEECH_OFF%Chichot śmiechu przechodzi przez kompanię i wkrótce rozlega się skandowanie \"nie zjadaj mnie!\".",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "Nie zadzierajcie z %companyname%!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Criminal.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 10)
		{
			return;
		}

		if (this.World.getTime().Days < 30 && this.World.Assets.getOrigin().getID() == "scenario.raiders")
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.FactionManager.isGreaterEvil())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.18)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		if (brothers.len() < 2)
		{
			return;
		}

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.killer_on_the_run" || bro.getBackground().getID() == "background.thief" || bro.getBackground().getID() == "background.graverobber" || bro.getBackground().getID() == "background.raider" || bro.getBackground().getID() == "background.nomad")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.NobleHouse = this.getNearestNobleHouse(this.World.State.getPlayer().getTile());

		if (this.m.NobleHouse == null)
		{
			return;
		}

		this.m.Criminal = candidates[this.Math.rand(0, candidates.len() - 1)];

		do
		{
			this.m.OtherBro = brothers[this.Math.rand(0, brothers.len() - 1)];
		}
		while (this.m.OtherBro == null || this.m.OtherBro.getID() == this.m.Criminal.getID());

		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"criminal",
			this.m.Criminal.getName()
		]);
		_vars.push([
			"other_bro",
			this.m.OtherBro.getName()
		]);
		_vars.push([
			"noblehousename",
			this.m.NobleHouse.getName()
		]);
		_vars.push([
			"bribe",
			"1000"
		]);
	}

	function onClear()
	{
		this.m.Criminal = null;
		this.m.OtherBro = null;
		this.m.NobleHouse = null;
	}

});

