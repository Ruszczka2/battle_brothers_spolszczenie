this.the_horseman_event <- this.inherit("scripts/events/event", {
	m = {
		Flagellant = null,
		Butcher = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.the_horseman";
		this.m.Title = "Przy drodze...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%Idąc drogą, trafiasz na człowieka wiszącego głową w dół na gałęzi. Grupa mężczyzn siedzi wokół, pijąc z koźlej skórki, wyglądają jak po ciężkim dniu pracy. Kiedy pytasz, co się dzieje, jeden z nich unosi wzrok i uśmiecha się.%SPEECH_ON%Chłostamy go, aż będzie cały surowy.%SPEECH_OFF%Pytasz, za co. Inny odpowiada.%SPEECH_ON%Za bzykanie żony tego faceta.%SPEECH_OFF%Jeden z pijących prycha i dławi się trunkiem. Wyciera usta.%SPEECH_ON%No tak, bardzo śmieszne. Nie, tego szubrawca przyłapano, jak rżnął mojego martwego konia.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Porozmawiajmy z wiszącym.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Idźmy dalej.",
					function getResult( _event )
					{
						if (_event.m.Butcher != null)
						{
							return "Butcher";
						}
						else
						{
							return 0;
						}
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%terrainImage%Podchodzisz do wiszącego. Krew spływa po jego plecach, z dziesiątków cięć. Ma na oczach szmatę, którą zsuwasz. Mrugając, pyta, czego chcesz, jakbyś przeszkadzał mu w własnej kryjówce. Pytasz, czy to, co mówią, to prawda. Spluwa i odchrząkuje.%SPEECH_ON%No, tak, ale koń był martwy, więc co za różnica? Czy człowiek nie może się trochę zabawić?%SPEECH_OFF%Właściciel konia wstaje, wymachując ociekającym batem.%SPEECH_ON%Ej, chcecie, żebyśmy do tego wrócili? Mamy cały dzień!%SPEECH_OFF%Wzdychając, wiszący zadaje ci pytanie.%SPEECH_ON%Jesteś najemnikiem, co? Czemu mam dla ciebie nie walczyć? Jestem silny i sprawny, trochę koń... to znaczy gorzej... nadwerężony, ale poza tym, i tym, no, martwym zwierzęciem, jestem człowiekiem prawości i moralnych zasad.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Odetniemy cię.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 75)
						{
							return "C";
						}
						else
						{
							return "D";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Flagellant != null)
				{
					this.Options.push({
						Text = "%flagellantfull%, wygląda na to, że coś ci chodzi po głowie.",
						function getResult( _event )
						{
							return "Flagellant";
						}

					});
				}

				this.Options.push({
					Text = "Czas odejść.",
					function getResult( _event )
					{
						if (_event.m.Butcher != null)
						{
							return "Butcher";
						}
						else
						{
							return 0;
						}
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "%terrainImage%Wyciągasz ostrze i odcinasz go. Osuwa się na barki i rozkłada, plecami po chłostach w ziemi. Po jego wyciu można sądzić, że gleba była solą. Jeden z batogów wstaje.%SPEECH_ON%Hej, co ty wyprawiasz? Nie skończyliśmy!%SPEECH_OFF%%randombrother% dobywa broni, a mężczyzna się cofa. Właściciel konia spluwa i kręci głową.%SPEECH_ON%Naprawdę będziesz bronił takiego typa? Toż to pieprzona końska bzdura. Teraz mogę powiedzieć, że widziałem wszystko, dokładnie to powiedziałem, kiedy przyłapałem tego drania, jak rżnął mojego martwego konia!%SPEECH_OFF%Mężczyzna łapie oddech i wskazuje na właśnie uratowanego.%SPEECH_ON%Obyś zdechł pierwszego dnia, ty sukinsynu gmerający przy klaczkach.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Witamy na pokładzie, koński rozpustniku.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "Po prostu idź. Nie ma tu dla ciebie miejsca.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"vagabond_background"
				]);
				_event.m.Dude.setTitle("Gmeracz Klaczek");
				_event.m.Dude.getBackground().m.RawDescription = "Znalazłeś %name% chłostanego za \'obcowanie\' z martwym koniem. Miejmy nadzieję, że ta przeszłość jest teraz, eee, za nim.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.setHitpoints(30);
				_event.m.Dude.improveMood(1.0, "Zaspokoił potrzeby z martwym koniem");
				_event.m.Dude.worsenMood(1.0, "Został wychłostany");

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "%terrainImage%Wyciągasz ostrze i odcinasz go. Spada prosto na głowę, a jego kark łamie się z obrzydliwym trzaskiem. Reszta ciała zapada się, nogi niezgrabnie przerzucone nad własną piersią, pozycja zapewne osobliwa dla takiego zboczeńca. Właściciel konia zrywa się na nogi.%SPEECH_ON%No do cholery, panie, mieliśmy go tylko porządnie wychłostać. Czemu go zabiłeś?%SPEECH_OFF%Zatrzymuje się, po czym macha ręką z rezygnacją.%SPEECH_ON%Cholera. Cholera, człowieku. No dobrze. Rozejdziemy się każdy w swoją stronę i nie powiemy nic o tym, co tu się stało. Zgadza się, chłopaki?%SPEECH_OFF%Reszta mężczyzn kiwa głowami.%SPEECH_ON%Jasne. Nie zamierzam psuć sobie życia przez jakiegoś gmeracza klaczek. Dobra robota, najemniku, głupi skurwielu machający mieczem.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ups.",
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
			ID = "Flagellant",
			Text = "%terrainImage%%flagellant% podchodzi i bierze bicz właściciela konia. Zgina go i przesuwa skórę przez dłonie. Kiwając głową, nazywa go \'dobrym narzędziem\' do porządnej chłosty, ale dodaje, że mężczyźni robili to \'zupełnie źle\'. Wskazuje na rany na plecach wiszącego.%SPEECH_ON%Widzisz te pręgi? Są cienkie i ledwie rozcięte. Nie daj się zwieść ilości krwi, to powierzchowne. Chodź, pokażę wam, jak się daje porządną nauczkę.%SPEECH_OFF%Biczownik opuszcza rzemienie, przez chwilę nimi kręci, po czym uderza. Wiszący krzyczy. Rana otwiera się i rozdziera od końca jednego żebra aż po drugi. Widać mięśnie i tłuszcz bulgoczące pod spodem. %flagellant% uderza raz, drugi, trzeci. Krew rozpryskuje się na biczownika, a końcoch dawno już zemdlał. W końcu jeden z mężczyzn wstaje i odbiera bicz.%SPEECH_ON%T-to wystarczy. Ruszajcie dalej, dobrze? Do diabła...%SPEECH_OFF%Inny mężczyzna odcina gmeracza klaczek i opatruje jego nowe, całkiem poważne rany. %flagellant% ociera czoło i podziwia swoje dzieło.%SPEECH_ON%Mmhmm, tak to się robi.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tak, właśnie tak.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Flagellant.getImagePath());
				local meleeSkill = 1;
				local fatigue = 1;
				_event.m.Flagellant.getBaseProperties().MeleeSkill += meleeSkill;
				_event.m.Flagellant.getBaseProperties().Stamina += fatigue;
				_event.m.Flagellant.getSkills().update();
				_event.m.Flagellant.improveMood(1.0, "Wykorzystał swoje wyjątkowe umiejętności");

				if (_event.m.Flagellant.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Flagellant.getMoodState()],
						text = _event.m.Flagellant.getName() + this.Const.MoodStateEvent[_event.m.Flagellant.getMoodState()]
					});
				}

				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Flagellant.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color] umiejętności walki wręcz"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Flagellant.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + fatigue + "[/color] maks. zmęczenia"
				});
			}

		});
		this.m.Screens.push({
			ID = "Butcher",
			Text = "%terrainImage%%butcher% pyta, czy koń wciąż tu jest. Właściciel przytakuje.%SPEECH_ON%Aye, świeżo zdechły i świeżo zbrukany przez tego palanta. Czemu?%SPEECH_OFF%Rzeźnik pyta, czy może go przejąć. Właściciel wzrusza ramionami.%SPEECH_ON%Twój, jeśli chcesz. Tylko uważaj, gdy będziesz odcinał te kawałki, których dotykał własnymi kawałkami.%SPEECH_OFF%Zanim ktoś zdąży coś powiedzieć, %butcher% każe zaprowadzić się do końskiego trupa, by go, cóż, oporządzić. Kompania dostaje trochę podejrzanego mięsa do jedzenia.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie jestem pewien, czy chcę to w naszych zapasach.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Butcher.getImagePath());
				local item = this.new("scripts/items/supplies/strange_meat_item");
				this.World.Assets.getStash().add(item);
				item = this.new("scripts/items/supplies/strange_meat_item");
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

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y < this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidate_flagellant = [];
		local candidate_butcher = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.flagellant")
			{
				candidate_flagellant.push(bro);
			}
			else if (bro.getBackground().getID() == "background.butcher")
			{
				candidate_butcher.push(bro);
			}
		}

		if (candidate_flagellant.len() != 0)
		{
			this.m.Flagellant = candidate_flagellant[this.Math.rand(0, candidate_flagellant.len() - 1)];
		}

		if (candidate_butcher.len() != 0)
		{
			this.m.Butcher = candidate_butcher[this.Math.rand(0, candidate_butcher.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"flagellant",
			this.m.Flagellant != null ? this.m.Flagellant.getNameOnly() : ""
		]);
		_vars.push([
			"flagellantfull",
			this.m.Flagellant != null ? this.m.Flagellant.getName() : ""
		]);
		_vars.push([
			"butcher",
			this.m.Butcher != null ? this.m.Butcher.getNameOnly() : ""
		]);
		_vars.push([
			"butcherfull",
			this.m.Butcher != null ? this.m.Butcher.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Flagellant = null;
		this.m.Butcher = null;
		this.m.Dude = null;
	}

});

