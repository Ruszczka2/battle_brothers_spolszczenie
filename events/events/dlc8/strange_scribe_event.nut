this.strange_scribe_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Dude = null,
		Minstrel = null,
		Killer = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.strange_scribe";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Podczas pobytu w %townname% podchodzi do ciebie osoba, którą widziałeś w pobliżu jednego z tutejszych możnowładców. Ma czarny płaszcz i trzyma twarz głęboko w kapturze. To uosobienie podejrzaności. Naturalnie, %anatomist% anatomista przygląda mu się jak jednemu ze swoich obiektów obserwacji. Mężczyzna kłania się.%SPEECH_ON%Przychodzę z wielkim szacunkiem dla twojej pracy, %anatomist%. Czytaliśmy wiele twoich tekstów.%SPEECH_OFF%Kładziesz dłoń na mieczu i czekasz, dokąd to zmierza. Mężczyzna kontynuuje.%SPEECH_ON%Chcielibyśmy zaprosić cię na posiłek i omówić sprawy ciała nieco bardziej...głęboko.%SPEECH_OFF%Wchodząc między mężczyzn, pytasz, kim jest to \"my\". Mężczyzna stwierdza, że należy do grupy skrybów i uczonych, którzy badają sprawy ludzkiego ciała, a także ciał, które dobrze przystosowały się do bestialskich zadań, czyli badają potwory świata.%SPEECH_ON%My, rzecz jasna, mamy szczególne zainteresowanie bestiami, którymi jest sam człowiek...po utracie tego, czym jest.%SPEECH_OFF%Przy takiej dozie intrygi nie dziwi cię, że anatomista chce pójść z dziwnym skrybą.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Idę z tobą.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "To zbyt podejrzane.",
					function getResult( _event )
					{
						return "G";
					}

				},
			],
			function start( _event )
			{
				if (_event.m.Minstrel != null)
				{
					this.Options.push({
						Text = "[img]gfx/ui/events/event_51.png[/img]{Zabierasz minstrela bez żadnych kosztów werbunku. %anatomist% anatomista wygląda na nieco przygnębionego całym zajściem, mówiąc, że pragnie rzadkiej wiedzy, a ten świat zdaje się oferować tylko przekręty i fałsze. Uśmiechając się, mówisz mu, by potraktował to jako wiedzę uliczną. On też się uśmiecha.%SPEECH_ON%Tak, być może powinienem nabyć więcej tej...ulicznej smykałki.%SPEECH_OFF%Nie, wiedzy ulicznej. \"Uliczna smykałka\" brzmi śmiesznie.}",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Killer != null)
				{
					this.Options.push({
						Text = "Chwila, gdzie jest nasz rezydentny morderca %killer%?",
						function getResult( _event )
						{
							return "F";
						}

					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Jeśli %anatomist% ma dokądkolwiek iść w tym mieście, to na pewno nie sam. Idziesz z nim, a dłoń nie schodzi ci z miecza. Dziwny mężczyzna zaprasza was do pięknego kamiennego domu, gdzie z każdego okna bije blask świec. W środku szybko prowadzą was do tego, co powinno być stołem, ale zamiast tego leży na nim blady mężczyzna, któremu skóra ledwo trzyma się ciała. Dziwny skryba kłania się jak kucharz, który dostarczył swoje najlepsze danie.%SPEECH_ON%Wierzymy, że to wiedźmag, człowiek, który umarł, a jednak znów chodzi.%SPEECH_OFF%Dziwny skryba podwija rękaw i trzyma go nad zniszczonym ciałem. Jego paszcza nagle odskakuje na boki, szczęka się rozgina, a białe oczy przewracają. %anatomist% tylko odchyla się i stwierdza, że to \"interesujące\". Dwaj mężczyźni zaczynają rozmawiać, a ty nerwowo dotykasz jelca miecza na wypadek, gdyby ten \"wiedźmag\" zechciał uciec. Gdy kończą, %anatomist% i skryba wyciągają pióra i wpisują swoje podpisy do swoich tomów, jednocześnie gratulując sobie pracy.\n\nCałe to wydarzenie sprawia, że się krzywisz, i zauważasz coś, co wygląda jak kropla potu na czole wiedźmy, ale zanim zdążysz to skomentować, zostajesz wyprowadzony z domu. Cokolwiek omawiali, anatomista jest pełen energii. Mówi ostrożnie.%SPEECH_ON%Stworzenie było fałszywką, oczywiście, nie myśl, że tego nie zauważyłem. Jednak dało mi to sporo wglądu w wynalazczą głębię miejscowych. W tej kreatywności jest coś do wydobycia, bo wyobraźnia potajemnie czerpie z wzniosłości i rzeczywistości oraz wnioskuje o tym, co przeczuwa, a czego nie umie jeszcze naukowo opisać. Nawet w błotnistym mroku regionalnych przesądów i kuglarstwa mogę czynić wielkie postępy.%SPEECH_OFF%Dobrze, dobrze. Wspominasz, że wiedziałeś, iż to oszustwo, bo rzekomo martwy kretyn się pocił. Anatomista kiwa głową i mówi, że może nie masz oka do diagnozy, ale uliczny spryt wystarcza do przenikliwego wnioskowania. Po prostu kiwasz głową, licząc, że miał dobre intencje, cokolwiek to znaczy.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wynośmy się stąd.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(0.75, "Nauczył się lepiej obchodzić z pospólstwem");

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				local fatigueBoost = this.Math.rand(1, 3);
				_event.m.Anatomist.getBaseProperties().Stamina += fatigueBoost;
				_event.m.Anatomist.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Anatomist.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + fatigueBoost + "[/color] Zmęczenia"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Zgadzasz się, by anatomista poszedł, ale ty idziesz z nim. To zwraca uwagę dziwnego skryby. Teraz wydaje się niechętny, stracił energię, którą miał na początku. Gdy skręcacie za róg, wydaje ostry, ptasi okrzyk, a kilku mężczyzn wychodzi, ty dobywasz miecza i odpychasz %anatomist%. Jeden z nich próbuje ataku. Nie jesteś w najlepszej formie do walki, ale szybka parada odpycha go i zniechęca do dalszego ataku. Skryba i jego ludzie odchodzą pospiesznie, mówiąc, że nie jesteście warci zachodu. %anatomist% wygląda na rozczarowanego.%SPEECH_ON%Ach, rozumiem. Więc to było oszustwo, przedsięwzięcie tak kreatywne, jak i przestępcze.%SPEECH_OFF%Rozglądając się, orientujesz się, że twoja sakiewka zniknęła. Spoglądasz i widzisz dziecko, które ją trzyma, po czym rzuca ją w górę, by złapało ją inne dziecko wiszące na rynnach. %anatomist% stoi obok, patrząc w górę, zafascynowany sprytem tych urwisów.%SPEECH_ON%Wygląda na to, że gdy jeden winowajca zawodzi, inny może zająć jego miejsce. Tak, przez wyczerpanie, przestępcy mogą odnosić sukces. Interesujące.%SPEECH_OFF%Anatomista nagle orientuje się, że też jest lżejszy przy biodrze i widzi, że jego sakiewka również zniknęła. Patrzysz obok, by zobaczyć kolejne dziecko uciekające jak szczur z serem. Inne dziecko przebiega obok i próbuje cię okraść, gdy nie ma już nic do zabrania. Zirytowany pustymi rękami, chłopiec krzyczy.%SPEECH_ON%Znajdź robotę!%SPEECH_OFF%Wzdychając, mówisz, że to pewnie czas wracać do kompanii.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cholerne urwisy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-175);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]175[/color] Koron"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Zgadzasz się, by %anatomist% i dziwny skryba porozmawiali, ale zanim w ogóle ruszysz ulicą, %minstrel% minstrel występuje, uśmiecha się i wskazuje.%SPEECH_ON%%fakescribe%! Co ty do diabła teraz wyprawiasz? To jakiś nowy przekręt, co masz w rękawie, co?%SPEECH_OFF%Dziwny skryba chrząka. Rozkłada ręce i chrząka jeszcze raz, jakby miał wygłosić uczoną mowę, ale potem wzdycha i odrzuca płaszcz. Ujawnia się młody, wcale nie uczony mężczyzna. Kręci głową.%SPEECH_ON%Życie w wielkim mieście dało mi w kość, %minstrel%. A u ciebie jak?%SPEECH_OFF%Obaj rozmawiają przez chwilę, a ty i %anatomist% patrzycie zaskoczeni. W końcu dwaj minstrelowie zwracają się do ciebie, %minstrel% prowadzi.%SPEECH_ON%Kapitanie, to %fakescribe%. Ma ciężkie czasy tutaj, w %townname%. Co powiesz, by dołączył do %companyname%? Jest do mnie podobny - kiepski wojownik, ale z pazurem, z werwą, ma to coś, jeśli tylko dostanie czas, by to odkryć, zwłaszcza gdy w grę wchodzi kobieta.%SPEECH_OFF%%fakescribe% kręci głową.%SPEECH_ON%Ehem, ehh, przy nich ja nigdy, eee, tego nie znajduję.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jasne, może dołączyć.",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Nie potrzebujemy kolejnego szarlatana.",
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
					"minstrel_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "{%name% został znaleziony, gdy wykorzystywał swoje talenty minstrela w ulicznych przekrętach. Polecony przez innego minstrela, dołączył do %companyname%, by szukać życia na drodze. Oby szarlatan, który stał się najemnikiem, potrafił \'udawać, aż się uda\', jak lubi to powtarzać zbyt często.}";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Minstrel.getImagePath());
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Zabierasz minstrela bez żadnych kosztów werbunku. %anatomist% anatomista wygląda na nieco przygnębionego całym zajściem, mówiąc, że pragnie rzadkiej wiedzy, a ten świat zdaje się oferować tylko przekręty i fałsze. Uśmiechając się, mówisz mu, by potraktował to jako wiedzę uliczną. On też się uśmiecha.%SPEECH_ON%Tak, być może powinienem nabyć więcej tej...ulicznej smykałki.%SPEECH_OFF%Nie, wiedzy ulicznej. \"Uliczna smykałka\" brzmi śmiesznie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ogarnij się, %anatomist%.",
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
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_12.png[/img]{Zgadzasz się, by anatomista i dziwny skryba porozmawiali, a ty idziesz z nimi. Mężczyzna prowadzi was do wylotu alejki, który jest wyjątkowo podejrzany. Odwraca się z dzikim uśmiechem na twarzy i powoli zaczyna wysuwać sztylet z rękawa, po czym nagle nóż przebija mu twarz, a błysk stali miga mu w ustach. Gdy charczy, kolejny nóż wpada i podcina mu gardło szybkim cięciem. Z alejki wyłania się %killer%, rzekomy zabójca w ucieczce.%SPEECH_ON%Witaj, kapitanie i, ee, anatomisto? Mistrzu zwłok? Ten typ był mordercą. I wścibialski, wścibiał się w moje...ee...sprawy.%SPEECH_OFF%Upuszcza ciało na ziemię i zaczyna zdejmować płaszcz, ujawniając, że rzekomy skryba był dobrze uzbrojony i opancerzony. Zabójca odcina jedno ucho i chowa je, po czym kiwa głową.%SPEECH_ON%Hej, wygląda na to, że mamy darmowy sprzęt, co? Ale chyba powinniśmy ukryć ciało. Ten gość robił wrażenie eminencji i niektórzy mogą uznać jego brak za wart sprawdzenia.%SPEECH_OFF%Nie wiesz, komu ani czemu wierzyć w tej sprawie, ale martwe ciało krwawiące na twoje buty zawsze wygląda źle, niezależnie od okoliczności. Ukrywasz ciało, oczywiście po uprzednim ograbieniu go ze sprzętu. %anatomist% wydaje się nieufny wobec %killer%. Wspomina, że ton głosu zabójcy brzmiał jak natychmiast zrodzona hipoteza albo, jak to ujmuje pospolity człowiek, \"udawanie\". Skoro już się stało, mówisz mu tylko, by pomógł zanieść sprzęt do ekwipunku.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jest tym, czym rzekomo jest.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(0.75, "Był świadkiem brutalnego morderstwa");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				local attackBoost = this.Math.rand(1, 3);
				local resolveBoost = this.Math.rand(1, 3);
				_event.m.Killer.getBaseProperties().MeleeSkill += attackBoost;
				_event.m.Killer.getBaseProperties().Bravery += resolveBoost;
				_event.m.Killer.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Killer.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + attackBoost + "[/color] Umiejętności Walki"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Killer.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolveBoost + "[/color] Determinacji"
				});
				local armors = [
					"armor/padded_leather",
					"armor/patched_mail_shirt",
					"armor/leather_lamellar"
				];
				local weapons = [
					"weapons/dagger",
					"weapons/dagger",
					"weapons/dagger",
					"weapons/rondel_dagger"
				];
				local armor = this.new("scripts/items/" + armors[this.Math.rand(0, armors.len() - 1)]);
				armor.setCondition(this.Math.max(1, armor.getConditionMax() * this.Math.rand(10, 40) * 0.01));
				this.World.Assets.getStash().add(armor);
				this.List.push({
					id = 10,
					icon = "ui/items/" + armor.getIcon(),
					text = "Zyskujesz " + armor.getName()
				});
				local weapon = this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]);
				weapon.setCondition(this.Math.max(1, weapon.getConditionMax() * this.Math.rand(10, 40) * 0.01));
				this.World.Assets.getStash().add(weapon);
				this.List.push({
					id = 10,
					icon = "ui/items/" + weapon.getIcon(),
					text = "Zyskujesz " + weapon.getName()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Killer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Mówisz, że sytuacja jest zbyt podejrzana, by ryzykować. %anatomist% twierdzi, że wszelka wiedza wydaje się podejrzana pospólstwu. Mówisz mu, że ten \"pospolity\" zna się na tyle, by wyczuć szczura, i na tym koniec. Anatomista jest zdenerwowany, ale wolisz, by był poirytowany niż martwy.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Lepiej się ogarnij, mądralo.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(1.0, "Odmówiono mu okazji do badań");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
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

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary() || t.getSize() < 2)
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];
		local minstrelCandidates = [];
		local killerCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.minstrel")
			{
				minstrelCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.killer_on_the_run")
			{
				killerCandidates.push(bro);
			}
		}

		if (minstrelCandidates.len() > 0 && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
		{
			this.m.Minstrel = minstrelCandidates[this.Math.rand(0, minstrelCandidates.len() - 1)];
		}

		if (killerCandidates.len() > 0)
		{
			this.m.Killer = killerCandidates[this.Math.rand(0, killerCandidates.len() - 1)];
		}

		if (anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
		_vars.push([
			"minstrel",
			this.m.Minstrel != null ? this.m.Minstrel.getNameOnly() : ""
		]);
		_vars.push([
			"killer",
			this.m.Killer != null ? this.m.Killer.getName() : ""
		]);
		_vars.push([
			"fakescribe",
			this.m.Dude != null ? this.m.Dude.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Dude = null;
		this.m.Minstrel = null;
		this.m.Killer = null;
		this.m.Town = null;
	}

});

