this.icy_cave_enter_event <- this.inherit("scripts/events/event", {
	m = {
		Champion = null
	},
	function create()
	{
		this.m.ID = "event.location.icy_cave_enter";
		this.m.Title = "Gdy się zbliżasz...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A1",
			Text = "[img]gfx/ui/events/event_144.png[/img]{Odkrywasz jaskinię w lodzie, której paszczę osłania brama z grubych sopli. Patrząc przez lodowe pręty, widzisz, że jaskinia szybko opada stromym zboczem w stronę czegoś, co może być podziemnym brzegiem rzeki, dawno już zamarzniętej. Obok czegoś skulona postać uderza kilofem w lód raz za razem. Wiatr gwiżdże, ocierając się o zęby jaskini. Wołasz do skulonego mężczyzny, ale nie ma odpowiedzi.\n\nPrzebicie się przez ten gruby lód zajmie trochę czasu. Na szczęście jeden z najemników meldował, że może istnieć tylne wejście. Jest równie zablokowane, ale dość silny człowiek mógłby się przecisnąć i stawić czoła niebezpieczeństwom w środku.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Title = "Gdy się zbliżasz...";
				local raw_roster = this.World.getPlayerRoster().getAll();
				local roster = [];

				foreach( bro in raw_roster )
				{
					if (bro.getPlaceInFormation() <= 17)
					{
						roster.push(bro);
					}
				}

				roster.sort(function ( _a, _b )
				{
					if (_a.getXP() > _b.getXP())
					{
						return -1;
					}
					else if (_a.getXP() < _b.getXP())
					{
						return 1;
					}

					return 0;
				});
				local e = this.Math.min(4, roster.len());

				for( local i = 0; i < e; i = ++i )
				{
					local bro = roster[i];
					this.Options.push({
						Text = "Potrzebuję, żebyś poszedł na zwiad, " + bro.getName() + ".",
						function getResult( _event )
						{
							_event.m.Champion = bro;
							return "B";
						}

					});
					  // [057]  OP_CLOSE          0      6    0    0
				}

				this.Options.push({
					Text = "Powinniśmy opuścić to miejsce.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "A2",
			Text = "[img]gfx/ui/events/event_144.png[/img]{Podążasz śladami tajemniczego posłańca do jaskini w lodzie. Tym razem nikt tu niedawno nie wchodził, bo gruba brama z sopli skutecznie blokuje wejście. Z boku paszczy jaskini leży stary mężczyzna twarzą w śniegu, martwy jak to tylko możliwe, z wyciągniętą ręką wskazującą do środka.\n\nPatrząc przez lodowe pręty, widzisz, że jaskinia szybko opada stromym zboczem w stronę czegoś, co może być podziemnym brzegiem rzeki, dawno już zamarzniętej. Obok czegoś skulona postać uderza kilofem w lód raz za razem. Wiatr gwiżdże, ocierając się o zęby jaskini. Wołasz do skulonego mężczyzny, ale nie ma odpowiedzi.\n\nPrzebicie się przez ten gruby lód zajmie trochę czasu. Na szczęście jeden z najemników meldował, że może istnieć tylne wejście. Jest równie zablokowane, ale dość silny człowiek mógłby się przecisnąć i stawić czoła niebezpieczeństwom w środku.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Title = "Gdy się zbliżasz...";
				local roster = this.World.getPlayerRoster().getAll();
				roster.sort(function ( _a, _b )
				{
					if (_a.getXP() > _b.getXP())
					{
						return -1;
					}
					else if (_a.getXP() < _b.getXP())
					{
						return 1;
					}

					return 0;
				});
				local e = this.Math.min(4, roster.len());

				for( local i = 0; i < e; i = ++i )
				{
					local bro = roster[i];
					this.Options.push({
						Text = "Potrzebuję, żebyś poszedł na zwiad, " + bro.getName() + ".",
						function getResult( _event )
						{
							_event.m.Champion = bro;
							return "B";
						}

					});
					  // [041]  OP_CLOSE          0      5    0    0
				}

				this.Options.push({
					Text = "Powinniśmy opuścić to miejsce.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_144.png[/img]{%chosen% rusza przodem, podczas gdy ty i reszta pracujecie przy wejściu do jaskini. Wybijasz kilka grubych sopli, by lepiej zajrzeć do środka. Właśnie wtedy %chosen% zsuwa się po sąsiednim zboczu i ląduje w samym środku jaskini, sunąc po zamarzniętej rzece i wjeżdżając na jej brzeg. Wstaje, otrzepuje się i uśmiecha dziecinnie.\n\nW jednej chwili skulony mężczyzna uderza kilofem w lód z niebywałą siłą, a odłamki pękają od jednego krańca brzegu do drugiego. Brzęk metalu i roztrzaskanego lodu rozbrzmiewa, jakby uderzył piorun. Teraz wreszcie widzisz nieznajomego: to barbarzyńca w powyłamywanym pancerzu, który grzechocze przy każdym ruchu. Lodowe ściany odbijają jego kroki, rozpraszając jego obecność po całej jaskini w przelotnych połyskach. Drgający i poszarpany chód zdaje się cofać mimo jego natarcia, jakby cień był jego prawdziwym ja, a ciało jedynie powidokiem. Choć jest w jaskini, jego donośny głos wcale się nie odbija.%SPEECH_ON%Intruz w mym pośród, zaledwie chwila od mgły, takich rzeczy nie przepuszczę.%SPEECH_OFF%Zbliża się do najemnika jak zimny pająk wysuwający się z kryjówki. Widzisz, że jego twarz jest w połowie zamarznięta, a szyderczy uśmiech rozciąga się na tej części, którą wciąż można nazwać ciałem.%SPEECH_ON%Pragnę opuścić to ciało, mój drogi wojowniku. Czy pomożesz mi wyjść i wznieść się ku czemuś wyższemu?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.BeastsTracks;
						properties.Entities = [];
						properties.Entities.push({
							ID = this.Const.EntityType.BarbarianMadman,
							Variant = 0,
							Row = 0,
							Script = "scripts/entity/tactical/humans/barbarian_madman",
							Faction = this.Const.Faction.Enemy
						});
						properties.Players.push(_event.m.Champion);
						properties.IsUsingSetPlayers = true;
						properties.IsFleeingProhibited = true;
						properties.IsAttackingLocation = true;
						properties.BeforeDeploymentCallback = function ()
						{
							local size = this.Tactical.getMapSize();

							for( local x = 0; x < size.X; x = ++x )
							{
								for( local y = 0; y < size.Y; y = ++y )
								{
									local tile = this.Tactical.getTileSquare(x, y);
									tile.Level = this.Math.min(1, tile.Level);
								}
							}
						};
						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(properties, false, false, false);
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "Gdy się zbliżasz...";
				this.Options[0].Text = "Dasz mu radę, %chosen%!";
				this.Characters.push(_event.m.Champion.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_144.png[/img]{%chosen% ścina szaleńca. Jego napierśnik pęka i odlatuje z ciała, kawałki blachy wirują i jęczą w powietrzu, a jednak trzymają się razem dzięki dziwnym niebieskim włóknom.\n\nTwoi ludzie w końcu przebijają się przez lodowe wejście jaskini i zsuwają się w dół. %chosen% ma się świetnie, kiwa z zadowoleniem głową, chowając broń.%SPEECH_ON%Tylko jakiś pieprzony szaleniec, kapitanie.%SPEECH_OFF%Kucasz obok ciała. Lód zniekształca połowę ciała, skręcając je w czarne sęki, a to, co nie zamarzło, pokrywa się dziwnie iskrzącym szronem. Mimo makabrycznego stanu szaleniec zginął z dzikim uśmiechem na twarzy. Oczy są jaskrawo niebieskie i widzisz siebie w ich spojrzeniu jako bezkształtną sylwetkę. Potem kolor powoli znika, nie jak kiedykolwiek widziałeś, lecz jakby ktoś przeciągał zasłonę przez okno, wysysając barwy prosto z oczodołów. Zwłoki uśmiechają się do ciebie, ale odmawiasz wiary, że to naprawdę widziałeś.\n\nJeden z najemników podnosi dziwny pancerz szaleńca i trzyma go na wyciągnięcie ręki.%SPEECH_ON%Jak myślisz, co to jest?%SPEECH_OFF%Płyty zwisają jedna z drugiej na jakimś niebieskim żelu, a wnętrza metalowych listew pokrywa bulgoczący, wirujący błękit, jakby to dzieło niebiańskiego kowala. Jest chłodny w dotyku i ugina się pod najlżejszym naciskiem palca. Nigdy nie widziałeś ani nie czułeś niczego podobnego, ale sam pancerz jest teraz niezdatny do użytku. Każesz włożyć tę maź i pancerz do zapasów, przeszukujesz jaskinię w poszukiwaniu innych dóbr, ale ich nie ma. Zanim wyjdziesz, rzucasz zwłokom ostatnie spojrzenie. Wydaje ci się, że znów się poruszyły, lecz to przecież zimno mroźnej północy płata ci figle.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze się spisałeś, %chosen%.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "Po bitwie...";

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(true);
				}

				this.Characters.push(_event.m.Champion.getImagePath());
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/special/broken_ritual_armor_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_144.png[/img]{Przez sople widzisz, jak szaleniec zabija %chosen%. Nawet gdy ten leży martwy na ziemi, nieznajomy nadal go rąbie, a za każdym razem w jaskini rozbrzmiewa stłumione uderzenie. Co teraz zrobisz?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Title = "Po bitwie...";

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}

				local roster = this.World.getPlayerRoster().getAll();
				roster.sort(function ( _a, _b )
				{
					if (_a.getXP() > _b.getXP())
					{
						return -1;
					}
					else if (_a.getXP() < _b.getXP())
					{
						return 1;
					}

					return 0;
				});
				local e = this.Math.min(4, roster.len());

				for( local i = 0; i < e; i = ++i )
				{
					local bro = roster[i];
					this.Options.push({
						Text = "Potrzebuję, żebyś tam wszedł, " + bro.getName() + ".",
						function getResult( _event )
						{
							_event.m.Champion = bro;
							return "B";
						}

					});
					  // [057]  OP_CLOSE          0      5    0    0
				}

				this.Options.push({
					Text = "Nie warto. Powinniśmy opuścić to miejsce.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_144.png[/img]{Gdy opuszczasz jaskinię, miejscowy północniak okryty niedźwiedziimi skórami staje naprzeciw kompanii. Patrzy na ciebie, potem na wejście do jaskini. Pyta.%SPEECH_ON%Mówisz po południowemu czy w ojczystej mowie?%SPEECH_OFF%Zachowując ostrożność, potwierdzasz to pierwsze. Kiwa głową.%SPEECH_ON%A co widziałeś w tej jaskini? Widziałeś to?%SPEECH_OFF%Mówisz mu, że niczego nie znalazłeś, tylko szaleńca. Nieznajomy uśmiecha się krzywo.%SPEECH_ON%Szaleńca. Szaleńca, to myślisz, że widziałeś. W każdym z nas jest ostrożność wobec nienaturalnego, ale nie potrafimy rozpoznać, kiedy sama natura robi krok wstecz. O grozach łatwiej mówić, niż je widzieć. To nie był zwykły człowiek, głupcze, lecz Ijirok, ulotny duch, który przechodzi z jednego naczynia do drugiego. Nikt naprawdę nie wie, jak wygląda, cały świat to tylko seria masek i chętnie przechodzi z jednej w drugą, zwykle przybierając kształt zwierząt, czasem człowieka, jeśli jest tak słaby. To istota absolutnej złośliwości. Nie da się jej zabić, nie, śmierć, nawet własną, traktuje jak rozrywkę. Pamięta tych, którzy przed nią uciekli, pamięta tych, z którymi chce się bawić. Modlę się, byś miał twarz wartą zapomnienia.%SPEECH_OFF%Kładziesz dłoń na głowicy miecza i mówisz mu, że całą tę mistykę i mitotwórstwo, które mu zostały, może zachować dla siebie. Widziałeś w jaskini szaleńca i tylko nim był, człowiekiem. Nieznajomy ponownie kiwa głową i cofa się.%SPEECH_ON%Jak sobie życzysz, i szerokiej drogi.%SPEECH_OFF%} ",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Szerokiej drogi.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "Po bitwie...";
				this.World.Flags.set("IjirokStage", 4);
				local locations = this.World.EntityManager.getLocations();

				foreach( v in locations )
				{
					if (v.getTypeID() == "location.tundra_elk_location")
					{
						v.setVisibilityMult(0.8);
						v.onUpdate();
						break;
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"chosen",
			this.m.Champion != null ? this.m.Champion.getName() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		if (this.World.Flags.get("IjirokStage") == 3)
		{
			return "A2";
		}
		else
		{
			return "A1";
		}
	}

	function onClear()
	{
		this.m.Champion = null;
	}

});

