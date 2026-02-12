this.imprisoned_wildman_event <- this.inherit("scripts/events/event", {
	m = {
		Other = null,
		Wildman = null,
		Monk = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.imprisoned_wildman";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_41.png[/img]Podczas marszu napotykasz rząd zatrzymanych wozów. Zauważasz, że wozy to klatki, a każda jest więzieniem dla dzikiego zwierzęcia. Przechodząc wzdłuż wozów, stajesz twarzą w twarz z różnymi bestiami. Zgarbiony i miauczący czarny kot wyrzuca swoje zabójcze pazury przez kraty. Odskakując, wpadasz na inną klatkę, która gwałtownie drży od ryku niedźwiedzia. Na szczęście jego potężne łapy są zbyt grube, by zmieścić się między prętami. Jeszcze inna klatka syczy od węży.\n\n Mężczyzna wychyla się zza jednego z wozów. Ma dziki wyraz twarzy, jakbyś właśnie przyłapał go na ręcznej robocie.%SPEECH_ON%Hej! Kim jesteś? Co tu robisz?%SPEECH_OFF%Informujesz nieznajomego, że jesteś kapitanem %companyname%. Mężczyzna prostuje się.%SPEECH_ON%Och, najemnicy! A już myślałem, że szczęście mnie opuściło! Słuchaj, mam problem, z którym moi najęci ludzie odmówili pomocy. Nie obchodzili się tym, gdy nie wiedzieli lepiej, ale cholerny płaszcz spadł z wozu i wtedy nie mogli przestać marudzić, że nie płacę im dość za transport takich towarów!%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "W czym potrzebujesz pomocy?",
					function getResult( _event )
					{
						return this.World.Assets.getOrigin().getID() != "scenario.manhunters" ? "B" : "B2";
					}

				},
				{
					Text = "To nie nasz problem.",
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
			ID = "B",
			Text = "[img]gfx/ui/events/event_100.png[/img]Treser zwierząt prowadzi cię do powozu. Od razu widzisz, czemu jego najęci ludzie zrezygnowali: w klatce siedzi wściekły i nieobliczalny dzikus. Surowe nadgarstki krwawią od kajdan, ślady prób ucieczki. Na wpół zagłodzony, dzikus gryzie patyki wystające z brody przypominającej kłąb chwastów. Widząc ten smutny widok, chwytasz nieznajomego za koszulę i przyciskasz do wozu.%SPEECH_ON%Czy to według ciebie zwierzę?%SPEECH_OFF%Treser uśmiecha się, zęby ma jak kość słoniową. Wyjaśnia.%SPEECH_ON%Mieszczanie usłyszeli o \"niecywilizowanych\" dzikusach i chcą zobaczyć ich z bliska. Po prostu spełniam to nowe zapotrzebowanie, jak każdy przedsiębiorca. A teraz potrzebuję tylko pomocy w wyciągnięciu tego trupa z klatki.%SPEECH_OFF%Wskazuje na zwłoki w rogu klatki. Dzikus cofa się, warczy i siada na ciele, jakby je chronił. Treser kręci głową.%SPEECH_ON%Jeden z moich pomocników podszedł za blisko i... no cóż. Nie mogę jechać do miasta z takim bałaganem w środku, więc pomyślałem, że może pomożecie mi to wyciągnąć. Oczywiście dobrze zapłacę. Sakiewka 250 koron brzmi dobrze? Po prostu sięgnij tam i wyciągnij to ścierwo.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [],
			function start( _event )
			{
				this.Options.push({
					Text = "Dobrze, wyślę człowieka.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 80 ? "C" : "D";
					}

				});

				if (_event.m.Wildman != null)
				{
					this.Options.push({
						Text = "Mamy własnego dzikusa, który mógłby pomóc.",
						function getResult( _event )
						{
							return "Wildman";
						}

					});
				}

				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "Nasz mnich wygląda na zaniepokojonego.",
						function getResult( _event )
						{
							return "Monk";
						}

					});
				}

				this.Options.push({
					Text = "Nie narażę życia moich ludzi na to.",
					function getResult( _event )
					{
						return "E";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B2",
			Text = "[img]gfx/ui/events/event_100.png[/img]Treser zwierząt prowadzi cię do powozu. Od razu widzisz, czemu jego najęci ludzie zrezygnowali: w klatce siedzi wściekły i nieobliczalny dzikus. Surowe nadgarstki krwawią od kajdan, ślady prób ucieczki. Na wpół zagłodzony, dzikus gryzie patyki wystające z brody przypominającej kłąb chwastów. Treser uśmiecha się, zęby ma jak kość słoniową.%SPEECH_ON%Mieszczanie usłyszeli o \"niecywilizowanych\" dzikusach i chcą zobaczyć ich z bliska. Po prostu spełniam to nowe zapotrzebowanie, jak każdy przedsiębiorca. A teraz potrzebuję tylko pomocy w wyciągnięciu tego trupa z klatki.%SPEECH_OFF%Wskazuje na zwłoki w rogu klatki. Dzikus cofa się, warczy i siada na ciele, jakby je chronił. Treser kręci głową.%SPEECH_ON%Jeden z moich pomocników podszedł za blisko i... no cóż. Nie mogę jechać do miasta z takim bałaganem w środku, więc pomyślałem, że może pomożecie mi to wyciągnąć. Oczywiście dobrze zapłacę. Sakiewka 250 koron brzmi dobrze? Po prostu sięgnij tam i wyciągnij to ścierwo.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [],
			function start( _event )
			{
				this.Options.push({
					Text = "Dobrze, wyślę człowieka.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 80 ? "C" : "D";
					}

				});

				if (_event.m.Wildman != null)
				{
					this.Options.push({
						Text = "Mamy własnego dzikusa, który mógłby pomóc.",
						function getResult( _event )
						{
							return "Wildman";
						}

					});
				}

				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "Nasz mnich wygląda na zaniepokojonego.",
						function getResult( _event )
						{
							return "Monk";
						}

					});
				}

				this.Options.push({
					Text = "Nie narażę życia moich ludzi na to.",
					function getResult( _event )
					{
						return "E";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_100.png[/img]%taskedbro% ma za zadanie opróżnić terrarium dzikusa z trupa. Zawija rękawy i podchodzi do klatki z wyciągniętymi obiema rękami.%SPEECH_ON%Spokojnie, powoli. Spokojnie!%SPEECH_OFF%Dzikus podnosi się z ciała i przechodzi na drugi koniec legowiska. Najemnik bez trudu chwyta but trupa i ciągnie go do krat. Przeciska się z odrażającą łatwością, już zlepiony jak mokre, wyrzucone ubrania. Flaki i kończyny ściekają z krawędzi platformy wozu. Treser zwierząt wiwatuje z radości.%SPEECH_ON%Dzięki wielkie! I wyglądało to takie proste!%SPEECH_OFF%%taskedbro% wpatruje się w ciało, uświadamiając sobie, że równie dobrze to on mógł tam leżeć.%SPEECH_ON%Tak. Nie ma za co.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cóż, przynajmniej zapłacili.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				this.World.Assets.addMoney(250);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]250[/color] koron"
				});
				_event.m.Other.getBaseProperties().Initiative += 2;
				_event.m.Other.getBaseProperties().Bravery += 1;
				_event.m.Other.getSkills().update();
				this.List.push({
					id = 17,
					icon = "ui/icons/initiative.png",
					text = _event.m.Other.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Inicjatywy"
				});
				this.List.push({
					id = 17,
					icon = "ui/icons/bravery.png",
					text = _event.m.Other.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Determinacji"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_100.png[/img]%taskedbro% ma za zadanie wyciągnąć ciało z legowiska. Podchodzi do klatki jak ladacznica przechadzająca się po wyjątkowo pobożnym mieście. Gdy podchodzi do krat, uśmiecha się jak do starego przyjaciela.%SPEECH_ON%Hej, kolego. Ładny trup tam masz. Wspaniały trup, naprawdę jeden z najlepszych, jakie widziałem. Może ja tylko... wyjmę go... stąd...%SPEECH_OFF%Kiedy najemnik sięga do środka, dzikus uderza. Za szybko, by to zobaczyć. %taskedbro% powoli się odwraca. W miejscu jednego oka jest czarna dziura. Dzikus miażdży oko między zębami, biała maź tryska jak pęknięta krosta i zamienia się w kleistą papkę podczas żucia. Treser rzuca ci worek koron i ucieka.%SPEECH_ON%Nie moja wina! Nie moja wina!%SPEECH_OFF%%taskedbro% mdleje, a kilku żądnych zemsty braci zadźga uwięzionego dzikusa na śmierć. Wszystkie zwierzęta w klatkach ryczą, jakbyście właśnie zabili ich przywódcę. Szybko każesz ludziom odejść od karawany, zanim któreś ze zwierząt się uwolni i narobi większych szkód.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Co do diabła!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				local injury = _event.m.Other.addInjury([
					{
						ID = "injury.missing_eye",
						Threshold = 0.0,
						Script = "injury_permanent/missing_eye_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Other.getName() + " doznaje " + injury.getNameOnly()
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_100.png[/img]Mówisz treserowi zwierząt, że to jego problem. Wzrusza ramionami.%SPEECH_ON%No tak, nie winię cię. Jesteś mądrzejszy, niż wyglądasz, najemniku.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Eee, dzięki.",
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
			ID = "Wildman",
			Text = "[img]gfx/ui/events/event_100.png[/img]Jeśli ktoś w drużynie mógłby uspokoić uwięzionego dzikusa, to pewnie %wildman%. Podchodzi do klatki i zagląda do środka. Następuje wymiana pohukiwań. Twój dzikus stuka w kraty knykciem, a więzień odpowiada stukiem i ponurym pohukiwaniem. Nagle %wildman% chwyta tresera za głowę i wciska ją w kraty. Ruszasz mu na ratunek, ale uwięziony dzikus przelatuje przez klatkę z atawistycznym przerażeniem w oczach. Cofasz się dla własnego bezpieczeństwa i możesz tylko patrzeć, jak to bestialskie stworzenie rzuca się na tresera. Obaj dzikusi szarpią i ciągną za twarz mężczyzny. Wstrząśnięty mężczyzna bełkocze.%SPEECH_ON%Myślałem, że się dogaaadaaaalniaaaahh!%SPEECH_OFF%%wildman% wbija kciuki w oczy mężczyzny, podczas gdy uwięziony dzikus chwyta tresera za usta i ciągnie w dół. Jego głowa dosłownie rozrywa się na szwach i ścięgnach. Kilku ludzi wymiotuje, gdy mózg tresera wypada tam, gdzie powinien być język, naprawdę okropny sposób na wypowiedzenie swojego zdania. Gdy z \"nadzorcą\" jest już po wszystkim, %wildman% patrzy na ciebie i na dzikusa z gestem w stylu \"możemy go zatrzymać?\".",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Absolutnie obrzydliwe. Jest idealny.",
					function getResult( _event )
					{
						return "Wildman1";
					}

				},
				{
					Text = "Nie, jest wyraźnie zbyt niebezpieczny.",
					function getResult( _event )
					{
						return "Wildman2";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Wildman1",
			Text = "[img]gfx/ui/events/event_100.png[/img]Wybitna skłonność do przemocy dobrze pasuje do bandy najemników. Zgadzasz się przyjąć uwięzionego dzikusa.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Witaj w kompanii.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return "Animals";
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"wildman_background"
				]);
				_event.m.Dude.setTitle("Zwierzę");
				_event.m.Dude.getBackground().m.RawDescription = "%name% został przez ciebie \'uratowany\' podczas starcia z treserem zwierząt, który stał się handlarzem niewolników. Poczucie wdzięczności i długu przełamuje wszelkie bariery językowe: niegdyś uwięziony dzikus wiernie służy kompanii za ocalenie.";
				_event.m.Dude.getBackground().buildDescription(true);

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
			ID = "Wildman2",
			Text = "[img]gfx/ui/events/event_100.png[/img]Nie sądzisz, by uwięziony dzikus pasował do kompanii, ale mimo to go wypuszczasz. Wylatuje z klatki jak banshee i pędzi w stronę linii drzew. Tam staje w oddali, pohukując i wrzeszcząc, aż znów ucieka.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Chyba tak dziękuje.",
					function getResult( _event )
					{
						return "Animals";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Monk",
			Text = "[img]gfx/ui/events/event_100.png[/img]%monk% mnich wysuwa się do przodu, z dłońmi złożonymi i głową pochyloną. Uosobienie kazania, postawa dobrych obyczajów albo źle pojętych. Odciąga tresera na bok.%SPEECH_ON%Stare bóstwa nie pochwalałyby tego, co tu uczyniłeś.%SPEECH_OFF%Treser zwierząt śmieje się i opiera o klatkę, z zadowoleniem krzyżując ramiona. Stwierdza, że na południu niewolnictwo uważa się za część naturalnego porządku. Mnich ciągnie dalej.%SPEECH_ON%To prawda, ale ani ty, ani ten dzikus nie jesteście krewni ich sposobowi życia. Chcesz go zniewolić dlatego, że jest obcy. On nie rozumie tej relacji, co czyni ją szczególnie naganną i niewłaściwą. Proponuję, by dla ciebie pracował i uczył się od ciebie. Uczyń z niego przyjaciela, a przyjaciela zyskasz na całe życie-%SPEECH_OFF%Ręce uwięzionego dzikusa wylatują między kraty i wbijają palce w jego własne gałki oczne. Jego twarz rozrywa się jak bochen starego chleba, żuchwa jak z wieszaków, język zwisa jak wyrwana z korzeniami żmija. %monk% wymiotuje, gdy jego twarz obryzguje krew. %otherbrother% kręci głową.%SPEECH_ON%Powiedziałbym, że pasowałby idealnie do %companyname%...%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Absolutnie obrzydliwe. Jest idealny.",
					function getResult( _event )
					{
						return "Wildman1";
					}

				},
				{
					Text = "Nie, jest wyraźnie zbyt niebezpieczny.",
					function getResult( _event )
					{
						return "Wildman2";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				_event.m.Monk.worsenMood(1.0, "Wstrząśnięty przemocą, której był świadkiem");

				if (_event.m.Monk.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk.getMoodState()],
						text = _event.m.Monk.getName() + this.Const.MoodStateEvent[_event.m.Monk.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Animals",
			Text = "[img]gfx/ui/events/event_47.png[/img]Cóż, tresera już nie ma i wraz z nim zniknęła jedyna osoba, która zajmowała się bestiami. %randombrother% podchodzi i pyta, co z nimi zrobić.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wypuść je.",
					function getResult( _event )
					{
						return "AnimalsFreed";
					}

				},
				{
					Text = "Zarżnijcie je wszystkie.",
					function getResult( _event )
					{
						return "AnimalsSlaughtered";
					}

				},
				{
					Text = "Zostaw je.",
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
			ID = "AnimalsFreed",
			Text = "[img]gfx/ui/events/event_27.png[/img]Czujesz, że zostawienie ich tutaj na śmierć głodową nie byłoby właściwe, a uwięzione stworzenie bez wątpienia ma łykowate mięso, gdy przychodzi do uboju. Decydujesz się wypuścić je z klatek. Większość tych dziwnych stworzeń pędzi ku linii drzew, ale dwa zostają: husky i sokół w kapturze, oboje jakby szukali pana.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oboje będziecie tu pasować.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/accessory/wardog_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				item = this.new("scripts/items/accessory/falcon_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "AnimalsSlaughtered",
			Text = "[img]gfx/ui/events/event_14.png[/img]Byłoby zbrodnią zostawić te zwierzęta, by tu głodowały i gniły. Byłaby to też straszna strata dobrego mięsa. Kazałeś je zarżnąć. To łatwa, choć brutalna robota, dźganie i cięcie bezradnych stworzeń i bestii. Niedźwiedź idzie na końcu i nie poddaje się łatwo. Zdołał przyciągnąć %hurtbro% blisko, by zadać paskudne cięcie, ale poza tym twoi ludzie powoli i makabrycznie go dobijają. Reszta wozów zostaje przewrócona i splądrowana.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niezły łup.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item;
				_event.m.Other.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Other.getName() + " doznaje lekkich ran"
				});
				local money = this.Math.rand(200, 500);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] koron"
				});
				item = this.new("scripts/items/supplies/cured_venison_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				item = this.new("scripts/items/supplies/smoked_ham_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				item = this.new("scripts/items/supplies/strange_meat_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
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

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidate_wildman = [];
		local candidate_monk = [];
		local candidate_other = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.wildman")
			{
				candidate_wildman.push(bro);
			}
			else if (bro.getBackground().getID() == "background.monk")
			{
				candidate_monk.push(bro);
			}
			else if (!bro.getSkills().hasSkill("injury.missing_eye"))
			{
				candidate_other.push(bro);
			}
		}

		if (candidate_other.len() == 0)
		{
			return;
		}

		if (candidate_wildman.len() != 0)
		{
			this.m.Wildman = candidate_wildman[this.Math.rand(0, candidate_wildman.len() - 1)];
		}

		if (candidate_monk.len() != 0)
		{
			this.m.Monk = candidate_monk[this.Math.rand(0, candidate_monk.len() - 1)];
		}

		this.m.Other = candidate_other[this.Math.rand(0, candidate_other.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"wildman",
			this.m.Wildman != null ? this.m.Wildman.getNameOnly() : ""
		]);
		_vars.push([
			"wildmanfull",
			this.m.Wildman != null ? this.m.Wildman.getName() : ""
		]);
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getNameOnly() : ""
		]);
		_vars.push([
			"monkfull",
			this.m.Monk != null ? this.m.Monk.getName() : ""
		]);
		_vars.push([
			"hurtbro",
			this.m.Other != null ? this.m.Other.getName() : ""
		]);
		_vars.push([
			"taskedbro",
			this.m.Other != null ? this.m.Other.getName() : ""
		]);
		_vars.push([
			"otherbrother",
			this.m.Other != null ? this.m.Other.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Wildman = null;
		this.m.Monk = null;
		this.m.Other = null;
		this.m.Dude = null;
	}

});

