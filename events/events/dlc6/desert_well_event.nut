this.desert_well_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Monk = null
	},
	function create()
	{
		this.m.ID = "event.desert_well";
		this.m.Title = "Wzdłuż drogi...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Trafiacie do wodopoju. Zewnętrzny mur studni jest wyszyty czaszkami zwierząt i podobnie zszyty ich żebrami. Gdy się zbliżacie, z głębin dobiega ciche syknięcie. Zaglądając, widzisz mały pomarańczowy blask sunący z lewej na prawą.%SPEECH_ON%Możecie spróbować nie patrzeć w dół.%SPEECH_OFF%Odwracasz się i widzisz mężczyznę ubranego w łachmany. Jego włosy sterczą do tyłu w czarnych zygzakach. Ciemne plamy pokrywają jego twarz, a każdy paznokieć ma posiniaczony, z uśmiechem umazanym smołą.%SPEECH_ON%Zaraz wybuchnie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Co zaraz wybuchnie?",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%terrainImage%{Mężczyzna przytakuje.%SPEECH_ON%To nie żaden wodopój, to armata. Na dnie mam kupę prochu. Szyb jest uzbrojony w wiadra i wędki, wszelkie sztućce, metalowe buty jakiegoś żołnierza, złamany miecz, parę pochew, myślę, że wpadło też kilka zwierząt, ale pewnie już nie żyją, a jeśli nie, to zaraz przejadą się.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "O nie, nie rób tego!",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "The gods talk to you, %monk%, now you talk to him!",
						function getResult( _event )
						{
							return "D";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "%terrainImage%{Mężczyzna się uśmiecha.%SPEECH_ON%Nie wiesz o mnie nic, nieznajomy. Może chcę się zabić, bo popełniłem straszliwą zbrodnię. To znaczy, nie popełniłem, ale czemu tak o tym gadasz: \'nie rób tego\'? Widziałeś moje przygotowania, gdybym miał się wahać, nie zrobiłbym tego wcześniej? Teraz usiądź i patrz.%SPEECH_OFF%Odwraca się i skacze do dziury. Słychać brzęk jego upadku, coś mamrocze o tym, że jest tam więcej gratów, niż pamiętał. Gdy zaglądasz, krzyczy, żebyś się odsunął, a pomarańczowy blask mknie do otworu. Mężczyzna się kłania.%SPEECH_ON%Żegnam cię, dziwny nieznajomy, dziwne pożegn-%SPEECH_OFF% Eksplozja ogłusza cię i rzuca na ziemię. Ziemia toczy się pod tobą w drżeniu, które czujesz mimo ogłuszającej ciszy, w której teraz tkwisz. Ognisty pióropusz strzela w niebo i warczy brzękiem metali oraz tępymi uderzeniami skóry i innych dóbr, a ty przewracasz się na brzuch i zakrywasz głowę, gdy wszystko spada jak resztki boskiej piekielnej burzy.\n\n Absolutnie nic z tych szczątków się nie przyda. A co do samego mężczyzny, cóż, spełnił swoją wolę. Z pewnością zginął w mgnieniu oka, a pozostały po nim zwęglone kawałki tu i tam, spalone płuca i osmalone pasma ścięgien i jeszcze więcej. Sprawdzasz, czy brwi wciąż są na miejscu i, zadowolony, przygotowujesz się do dalszej drogi.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Czasem chciałbyś, żeby to były tylko miraże.",
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
			ID = "D",
			Text = "%terrainImage%{%monk% mnich wysuwa się do przodu.%SPEECH_ON%Dużo zachodu, żeby się zabić, przyjacielu.%SPEECH_OFF%Mężczyzna wzrusza ramionami.%SPEECH_ON%Nie jestem twoim przyjacielem.%SPEECH_OFF%Mnich kiwa głową.%SPEECH_ON%To tylko zwrot, nic więcej. Prawdę mówiąc, nic o tobie nie wiem. I zapewne masz dobry powód, by to robić. Ile czasu spędziłeś, składając to wszystko?%SPEECH_OFF%Dziwny mężczyzna przez chwilę myśli, po czym mówi, że to były miesiące. %monk% się uśmiecha.%SPEECH_ON%To dobra, ciężka praca.%SPEECH_OFF%Mężczyzna mówi.%SPEECH_ON%Chcesz mnie pocieszać?%SPEECH_OFF%Mnich kręci głową.%SPEECH_ON%Nie, panie.%SPEECH_OFF%Mężczyzna mruży oczy i patrzy z niedowierzaniem.%SPEECH_ON%Brzmi mi to jak matczyne gadanie. Jakbyś próbował mnie zagadać, żebym się nie zabił. A ja tego nie chcę!%SPEECH_OFF%%monk% wzrusza ramionami.%SPEECH_ON%Znowu nie, panie. Idź i zakończ swoje życie, jeśli tego pragniesz. Dziś czy później, starzy bogowie będą czekać.%SPEECH_OFF%Mężczyzna odwraca się i spluwa.%SPEECH_ON%Nie ma tu żadnych starych bogów. Tylko blask i poświata Gildera.%SPEECH_OFF%%monk% kiwa głową, po czym odwraca się do ciebie.%SPEECH_ON%Szczerze mówiąc, kapitanie, mam już tylko jedną rzecz do powiedzenia. Mogę ją powiedzieć? Chcę to powiedzieć nieznajomemu, prosto w oczy.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mów dalej.",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Niech się zabije, jeśli tego chce.",
					function getResult( _event )
					{
						return "F";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "%terrainImage%{Mnich kiwa głową na znak twojej zgody, po czym nagle obraca się i uderza nieznajomego. Ten spada z krawędzi studni i osuwa się w piach, wpatrując się w ciebie wywróconymi oczami.%SPEECH_ON%Czemu to zrobiłeś?%SPEECH_OFF%Pyta, dotykając wargi. %monk% kuca.%SPEECH_ON%Jak się z tym czujesz?%SPEECH_OFF%Nieznajomy syczy i spluwa krwią. Mówi, że boli. Mnich kiwa głową.%SPEECH_ON%Czujesz, że żyjesz?%SPEECH_OFF%Nieznajomy wstaje i otrzepuje się. Przytakuje.%SPEECH_ON%Trochę, tak.%SPEECH_OFF%Rozmawiają chwilę i gdy kończą, mężczyzna zgadza się dołączyć do kompanii za darmo. Mówi też, że w studni jest sporo dóbr, jeśli chcecie z nich skorzystać, ale trzeba uważać, by nie wrzucić tam ognia, bo wszystko wybuchnie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Witaj na pokładzie, jak mniemam.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"peddler_southern_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "Pasmo nieszczęść pchnęło byłego handlarza bronią %name% do próby zakończenia życia przez wysadzenie się w powietrze, ale " + _event.m.Monk.getName() + " interweniował i przekonał go, by zamiast tego dołączył do twojej kompanii i zaczął nowe życie.";
				_event.m.Dude.getBackground().buildDescription(true);
				local trait = this.new("scripts/skills/traits/deathwish_trait");

				foreach( id in trait.m.Excluded )
				{
					_event.m.Dude.getSkills().removeByID(id);
				}

				_event.m.Dude.getSkills().add(trait);
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Dude.worsenMood(2.5, "Miał pasmo nieszczęść i stracił wszystko");
				this.Characters.push(_event.m.Dude.getImagePath());
				local item = this.new("scripts/items/loot/silverware_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "%terrainImage%{Każesz mnichowi się wycofać. Wzrusza ramionami i wraca na twoją stronę. Gdy odwracasz się do mężczyzny, zauważasz, że rozpalił ogień, i widzisz, jak skacze do studni.\n\n Eksplozja ogłusza cię i rzuca na ziemię. Ziemia toczy się pod tobą w drżeniu, które czujesz mimo ogłuszającej ciszy, w której teraz tkwisz. Ognisty pióropusz strzela w niebo i warczy brzękiem metali oraz tępymi uderzeniami skóry i innych dóbr, a ty przewracasz się na brzuch i zakrywasz głowę, gdy wszystko spada jak resztki boskiej piekielnej burzy.\n\n Absolutnie nic z tych szczątków się nie przyda. A co do samego mężczyzny, cóż, spełnił swoją wolę. Z pewnością zginął w mgnieniu oka, a pozostały po nim zwęglone kawałki tu i tam, spalone płuca i osmalone pasma ścięgien i jeszcze więcej. Sprawdzasz, czy brwi wciąż są na miejscu i, zadowolony, przygotowujesz się do dalszej drogi.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Czasem chciałbyś, żeby to były tylko miraże.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert && currentTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 6)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_monk = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.monk")
			{
				candidates_monk.push(bro);
			}
		}

		if (candidates_monk.len() != 0)
		{
			this.m.Monk = candidates_monk[this.Math.rand(0, candidates_monk.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
		this.m.Monk = null;
	}

});

