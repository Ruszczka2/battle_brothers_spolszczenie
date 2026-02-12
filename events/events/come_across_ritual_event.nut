this.come_across_ritual_event <- this.inherit("scripts/events/event", {
	m = {
		Cultist = null
	},
	function create()
	{
		this.m.ID = "event.come_across_ritual";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]Na drodze nieczęsto spotyka się martwe ciało, ale tym razem jest ono dość niezwykłe. %randombrother% przygląda się długo.%SPEECH_ON%Co to jest na jego piersi?%SPEECH_OFF%Kucasz i odsuwasz koszulę trupa. Blizny biegną wzdłuż całego ciała, układając się w bardzo znajome kształty: lasy, rzeki, góry. %randombrother% podchodzi.%SPEECH_ON%No popatrz. Wilki tak robią czy coś?%SPEECH_OFF%Wstajesz.%SPEECH_ON%Myślę, że zrobił to sam sobie.%SPEECH_OFF%Krwiste ślady stóp prowadzą dalej...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pójdźmy tym śladem.",
					function getResult( _event )
					{
						return "Arrival";
					}

				},
				{
					Text = "To nas nie dotyczy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Arrival",
			Text = "[img]gfx/ui/events/event_140.png[/img]Gdy podążasz śladami, zaczynasz słyszeć pomruki pieśni. Każesz kompanii odpocząć, a sam skradasz się naprzód, aż w końcu dostrzegasz wielkie ognisko, wokół którego krążą zakapturzeni mężczyźni. Tupią i unoszą ręce, wykrzykując słowa do swojego starszego boga, Davkula. To bestialski obrzęd, pełen ryku i warkotu, a mężczyźni tańczą w swoich zbyt dużych szatach niczym mroczne duchy wciąż rozgniewane na świat, który opuściły. %randombrother% czołga się obok ciebie i kręci głową.%SPEECH_ON%Co tam się dzieje? Co powinniśmy zrobić?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Musimy to przerwać. Atak!",
					function getResult( _event )
					{
						return "Attack1";
					}

				},
				{
					Text = "Poczekajmy i zobaczmy, co się stanie.",
					function getResult( _event )
					{
						return "Observe1";
					}

				},
				{
					Text = "Czas się wynosić. Teraz.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Observe2",
			Text = "[img]gfx/ui/events/event_140.png[/img]Postanawiasz poczekać i zobaczyć, co się stanie. Twarz ogniska wraca, wielka, magmowa paszcza otwiera się, gdy skuty mężczyzna zostaje pchnięty naprzód. Krzyczy i wygina się do tyłu, ale to na nic. Jego ubranie spala się, a strzępy lecą w tył w pomarańczowej pożodze. Skóra schodzi z niego, jakby to nie ogień, lecz tysiąc skalpeli przecinało jego ciało. Ostre białe płomienie obdzierają go żywcem. Czaszka zostaje wydrążona, wijąc się i drgając jak wąż zrzucający skórę, a jego oczy wciąż widzą, choć reszta ciała zostaje zerwana do mięsa, organów i kości. Gdy zostaje już tylko czaszka z oczami, twarz w ogniu zamyka paszczę, a wielkie wycie ofiary gaśnie nagłą ciszą. Ognisko gaśnie w jednej chwili, a mężczyzna, lub to, co z niego zostało, pada na ziemię. Oczy płoną jasno, powoli gasnąc jak stygnące rozpalone żelazo.\n\nJeden z kultystów pochyla się i podnosi czaszkę. Bez trudu rozłupuje ją na pół, upuszczając mózgoczaszkę, trzymając to, co kiedyś było twarzą. Gdy wyciąga szczątki przed siebie, kości czernieją i wykręcają się, tworząc okrutne oblicze absolutnej ciemności otoczone kościaną obręczą. Zakłada je i zaczyna odchodzić.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Widziałem dość. Musimy mu pomóc, teraz!",
					function getResult( _event )
					{
						return "Attack2";
					}

				},
				{
					Text = "Czekaj, zobaczmy, co dalej.",
					function getResult( _event )
					{
						return "Observe2";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Cultist != null)
				{
					this.Options.push({
						Text = "%cultist%, czy to nie twój kult?",
						function getResult( _event )
						{
							return "Cultist";
						}

					});
				}

				this.Options.push({
					Text = "Czas się wynosić. Teraz.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Observe2",
			Text = "[img]gfx/ui/events/event_140.png[/img]Postanawiasz poczekać i zobaczyć, co się stanie. Twarz ogniska wraca, wielka, magmowa paszcza otwiera się, gdy skuty mężczyzna zostaje pchnięty naprzód. Krzyczy i wygina się do tyłu, ale to na nic. Jego ubranie spala się, a strzępy lecą w tył w pomarańczowej pożodze. Skóra schodzi z niego, jakby to nie ogień, lecz tysiąc skalpeli przecinało jego ciało. Ostre białe płomienie obdzierają go żywcem. Czaszka zostaje wydrążona, wijąc się i drgając jak wąż zrzucający skórę, a jego oczy wciąż widzą, choć reszta ciała zostaje zerwana do mięsa, organów i kości. Gdy zostaje już tylko czaszka z oczami, twarz w ogniu zamyka paszczę, a wielkie wycie ofiary gaśnie nagłą ciszą. Ognisko gaśnie w jednej chwili, a mężczyzna, lub to, co z niego zostało, пада на ziemię. Oczy płoną jasno, powoli gasnąc jak stygnące rozpalone żelazo.\n\nJeden z kultystów pochyla się i podnosi czaszkę. Bez trudu rozłupuje ją na pół, upuszczając mózgoczaszkę, trzymając to, co kiedyś było twarzą. Gdy wyciąga szczątki przed siebie, kości czernieją i wykręcają się, tworząc okrutne oblicze absolutnej ciemności otoczone kościaną obręczą. Zakłada je i zaczyna odchodzić.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Teraz atakujemy!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.CivilianTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];

						for( local i = 0; i < 25; i = ++i )
						{
							local unit = clone this.Const.World.Spawn.Troops.Cultist;
							unit.Faction <- this.Const.Faction.Enemy;
							properties.Entities.push(unit);
						}

						properties.Loot = [
							"scripts/items/helmets/legendary/mask_of_davkul"
						];
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				},
				{
					Text = "My też odchodzimy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Cultist",
			Text = "[img]gfx/ui/events/event_140.png[/img]Pytasz %cultist%, czy może coś zrobić. Ten po prostu przechodzi obok ciebie i schodzi ze wzgórza. Grupa kultystów odwraca się do niego. Przechodzi przez tłum do więźnia. Rozmawiają. Szepcze, więzień kiwa głową. Gdy kończą, %cultist% kiwa do zgromadzonych. Jeden z nich podchodzi, zrzuca szaty i rzuca się w ogień bez krzyku i bez sprzeciwu. Inny kultysta wrzuca do płomieni haki, wyciąga z nich coś i podaje %cultist%. Więzień, którego życie najwyraźniej ocalono w ramach wymiany, zostaje uwolniony, a ty patrzysz, jak %cultist% chwyta go i prowadzi z powrotem pod górę. Popycha mężczyznę do przodu, mówiąc.%SPEECH_ON%Wziąłeś od Davkula, ale dług został spłacony.%SPEECH_OFF%Pytasz, co trzyma w dłoni. Kultysta unosi to, co wydobyto z płomieni. To czaszka obciągnięta wyprawioną skórą, a na jej twarzy napięta jest świeżo osmolona maska, zapewne tego, który rzucił się w ogień. Zarysy jego twarzy drżą i wyginają się, usta rozwarte, zdeformowane przez okrutną, szepczącą ciemność. Trzymając to wysoko niczym tubylec pokazujący cenny skalp, %cultist% mówi krótko.%SPEECH_ON%Davkul czeka na nas wszystkich.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Co to jest?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/helmets/legendary/mask_of_davkul");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Attack1",
			Text = "[img]gfx/ui/events/event_140.png[/img]Wydajesz rozkaz ataku. Twoi ludzie chwytają broń i ruszają naprzód. Ogień gaśnie w jednej chwili, zwijając się w popiół, który wybucha wielką chmurą. Gdy płomień znika, upiorny tłum rozkłada ramiona i mówi jednym głosem.%SPEECH_ON%Davkul czeka. Chodźcie go powitać.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.CivilianTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];

						for( local i = 0; i < 25; i = ++i )
						{
							local unit = clone this.Const.World.Spawn.Troops.Cultist;
							unit.Faction <- this.Const.Faction.Enemy;
							properties.Entities.push(unit);
						}

						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Attack2",
			Text = "[img]gfx/ui/events/event_140.png[/img]Nie godzisz się na tę niesprawiedliwość i postanawiasz ruszyć, by ocalić człowieka. Gdy wstajesz i unosisz miecz, by wydać rozkaz, ognisko wystrzeliwuje wielką, magmową mackę, która chwyta skuwanego człowieka i wciąga go w płomienie. Jest tylko krótki krzyk, po czym znika. Ogień kondensuje się w słup, który szybko się zapada. Obłok popiołu wybucha na zewnątrz. Mężczyzny nie ma, jakby w ogóle nie było ognia. Nie ma nawet dymu na niebie.\n\nKultyści zwracają się do ciebie, wskazują i mówią jednym głosem.%SPEECH_ON%Przynieście śmierć, swoją albo naszą, bo Davkul czeka na nas wszystkich.%SPEECH_OFF%Wahasz się chwilę, po czym wydajesz rozkaz do szarży.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.CivilianTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];

						for( local i = 0; i < 25; i = ++i )
						{
							local unit = clone this.Const.World.Spawn.Troops.Cultist;
							unit.Faction <- this.Const.Faction.Enemy;
							properties.Entities.push(unit);
						}

						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days <= 200)
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;

		foreach( t in towns )
		{
			local d = playerTile.getDistanceTo(t.getTile());

			if (d >= 4 && d <= 10)
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 11 && (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		if (candidates.len() != 0)
		{
			this.m.Cultist = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Score = 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cultist",
			this.m.Cultist != null ? this.m.Cultist.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Cultist = null;
	}

});

