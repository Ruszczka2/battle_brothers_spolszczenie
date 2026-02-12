this.adopt_wardog_event <- this.inherit("scripts/events/event", {
	m = {
		Bro = null,
		Houndmaster = null
	},
	function create()
	{
		this.m.ID = "event.adopt_wardog";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 120.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_27.png[/img]Zauważyłeś kundla kilka mil temu i kilka mil dalej wciąż tam jest, pojawia się i znika w zasięgu wzroku.\n\nTaki kundel nie podąża za bandą niebezpiecznych ludzi bez powodu - może ktoś go karmi?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Przegonić kundla!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Lepiej go teraz uśpić, zanim później ukradnie nasze zapasy.",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 60)
						{
							return "C";
						}
						else
						{
							return "D";
						}
					}

				},
				{
					Text = "Kompanii przyda się maskotka. Przyjmijmy go.",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 75)
						{
							return "E";
						}
						else
						{
							return "F";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Houndmaster != null)
				{
					this.Options.push({
						Text = "%houndmaster%, jesteś szkolony do pracy z psami, prawda?",
						function getResult( _event )
						{
							return "G";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_75.png[/img]To nie miejsce dla szczeniaka. Gdy pies pojawia się następnym razem, trafiasz go w czoło dobrze rzuconym kamieniem. Pies z wyciem ucieka. Zatrzymuje się, jakby myśląc, że to pomyłka, ale szybko poprawiasz to obrzydliwe stworzenie kolejnym kamieniem. Pies odchodzi i już go nie widać.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I trzymaj się z dala!",
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
			ID = "C",
			Text = "[img]gfx/ui/events/event_75.png[/img]Bierzesz łuk i zakładasz strzałę. Kilku braci patrzy, jak celujesz. Strzał idzie w bok, ale pies rozumie przekaz i szybko ucieka.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Chciałem go tylko spłoszyć.",
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
			Text = "[img]gfx/ui/events/event_27.png[/img]Bierzesz łuk i zakładasz strzałę. Kilku braci patrzy, jak celujesz. Wiatr przychodzi, odchodzi i wraca. Czekasz cierpliwie, po czym naciągasz cięciwę i przymykasz jedno oko, by złapać psa w celownik. Siada i patrzy na ciebie, dysząc z długim jęzorem.\n\nWypuszczasz strzałę. Przelatuje przez powietrze, a pies skomle. Cofa się na tylnych łapach i upada, kopiąc i skrobiąc po ziemi, aż w końcu nieruchomieje. Odkładasz łuk i ruszasz z kompanią dalej.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Biedactwo.",
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
			ID = "E",
			Text = "[img]gfx/ui/events/event_27.png[/img]Postanawiasz wziąć kawał mięsa i podejść do psa. Na początku jest płochliwy i cofa się, gdy się zbliżasz, ale zapach w twojej dłoni jest bez wątpienia kuszący. Kundel skrada się z powrotem, przystaje tu i ówdzie, a jego oczy nerwowo szukają zasadzki.\n\nWidzisz wyraźnie wystające żebra - wiele dni na drodze zrobiło z niego wychudzonego psa. Uszy ma zszyte, a ogon poszarpany, z wyraźnymi śladami walk. To zwierzę umie walczyć i właśnie to będzie od teraz robić dla ciebie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Witaj w kompanii.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/accessory/wardog_item");
				item.m.Name = "Brat Bitewny";
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
			Text = "[img]gfx/ui/events/event_37.png[/img]Szorstki pies taki jak ten byłby świetną maskotką. Taki mały kundel mógłby wyraźnie podnieść morale. Polecasz %bro% nakarmić go w nadziei, że się przyłączy. Wychodzi ze skrawkiem resztek i kuca.%SPEECH_ON%Dobry pies.%SPEECH_OFF%Kundel wącha jedzenie, po czym kłapie zębami - razem z dłonią najemnika. Brat odskakuje, przyciskając ramię do piersi, jakby miał je stracić. Pies natomiast połyka resztkę i ucieka.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cholera, naprawdę by tu pasował.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bro.getImagePath());
				local injury = _event.m.Bro.addInjury(this.Const.Injury.FeedDog);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Bro.getName() + " doznaje: " + injury.getNameOnly()
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_27.png[/img]Pytasz %houndmaster% - opiekuna psów - czy może spróbować \'przekonać\' tego psa. Kiwa głową i podchodzi. Uszy dzikiego kundla z przyciśniętych stają się nastawione. Kucając, opiekun powoli zbliża się do bestii. Wyciąga dłoń z kawałkiem mięsa na środku. Głód zwycięża ostrożność i pies coraz bliżej obwąchuje dłoń opiekuna. Zlizuje kąsek z jego dłoni i połyka. Trener podaje mu kolejny kęs. Drapiąc go, znajduje czułe miejsce za uszami. Oglądając się, %houndmaster% kiwa głową.%SPEECH_ON%Ano, to ułożona bestia i łatwo ją wyszkolić.%SPEECH_OFF%To świetnie. Pytasz, czy potrafi walczyć. Opiekun zaciska usta.%SPEECH_ON%Pies jest jak człowiek. Jeśli oddycha, potrafi walczyć.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Świetnie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Houndmaster.getImagePath());
				local item = this.new("scripts/items/accessory/wardog_item");
				item.m.Name = "Brat Bitewny";
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type == this.Const.World.TerrainType.Forest || currentTile.Type == this.Const.World.TerrainType.Snow || currentTile.Type == this.Const.World.TerrainType.LeaveForest || currentTile.Type == this.Const.World.TerrainType.Mountains)
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
			if (bro.getBackground().getID() == "background.houndmaster")
			{
				candidates.push(bro);
			}
		}

		this.m.Bro = brothers[this.Math.rand(0, brothers.len() - 1)];

		if (candidates.len() != 0)
		{
			this.m.Houndmaster = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"bro",
			this.m.Bro.getName()
		]);
		_vars.push([
			"houndmaster",
			this.m.Houndmaster != null ? this.m.Houndmaster.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Bro = null;
		this.m.Houndmaster = null;
	}

});

