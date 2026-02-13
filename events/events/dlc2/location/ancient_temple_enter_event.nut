this.ancient_temple_enter_event <- this.inherit("scripts/events/event", {
	m = {
		Volunteer = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.location.ancient_temple_enter";
		this.m.Title = "Gdy się zbliżasz...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_111.png[/img]{Tylko połowa wejścia do świątyni jest widoczna, reszta dawno już osunęła się w ziemię, jakby niepewna, czy ma być trumną, czy mauzoleum. Na widocznym fryzie widać kamienny relief stołów przewracanych i bogatych mężczyzn uciekających przed czymś, co wygląda jak opancerzony szkielet z biczem. Kilku najemników czuje się nieswojo na myśl o wejściu, ale masz wrażenie, że inni też tak czuli i dlatego zostawili to miejsce nietknięte.\n\n Wyciągasz pochodnię i wchodzisz z duchem najemnika i determinacją rabusia. Po zebraniu zapasów kucasz i wchodzisz do świątyni, przerzucając nogi przez ziemię i skacząc na schody poniżej. Klapnięcie twoich butów chichocze w marmurowych salach, a ty machasz pochodnią przed sobą, jakbyś chciał widzieć, jak biegną echa. Oglądając się, widzisz światło między półką ziemi a szczytem świątyni, które tworzy sylwetki twojej kompanii, jakby byli gromadą kościelnych zadowolonych z pracy. %volunteer% kręci głową i mówi, że idzie z tobą. Reszta kompanii zgodnie decyduje się trzymać wartę.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wejdziemy.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Zapomnij o tych ruinach, ruszamy dalej.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_111.png[/img]{Ściany korytarzy pokrywają wojenne mozaiki tak wielkie, że pasują raczej do całej kampanii niż do jednej bitwy. Jeden fragment w szczególności ciągnie się pozornie w nieskończoność, przedstawiając opancerzonych ludzi tratowanych przez to, co wygląda na barbarzyńską hordę tak liczną, że traci człowieczeństwo i zaczyna przypominać nie do odróżnienia owady. Twoja pochodnia przygasa i rozbłyska w ciemności, a światło ożywia pole bitwy w pomarańczowym blasku; w kątach znajdujesz przedstawienia sprawiedliwych tortur i oburzenia. Między zwartymi szeregiem a rozproszoną tłuszczą wygląda to tak, jakby porządek i chaos starły się ze sobą, i choć porządek zapewne zwycięży, to właśnie chaos wytycza drogę do zwycięstwa.\n\n %volunteer% gwiżdże. Patrzysz i widzisz, jak jego pochodnia płonie w oddali niczym ignis fatuus. Podbiegasz, by zastać go z fiolką dziwnej cieczy w dłoni. Najemnik kieruje pochodnię na wnękę w ścianie. Pośrodku stoi marmurowy słup, a u jego podstawy leży gromada szkieletów.%SPEECH_ON%Znalazłem fiolkę na tamtym postumencie. I widzę jeszcze dwie takie dalej, ale są za kratami.%SPEECH_OFF%Pytasz najemnika, czemu nie powiedział o ciałach. Wzrusza ramionami.%SPEECH_ON%Nie oddychają, to mnie nie obchodzą. Chcesz spróbować po te dwie fiolki czy nie?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zróbmy to.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
				this.World.Assets.getStash().makeEmptySlots(1);
				local item;
				item = this.new("scripts/items/tools/holy_water_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_111.png[/img]{Znajdujesz kolejną fiolkę za kratą sięgającą do piersi. Sam flakon trzyma kamienny szpon bezskrzydłego gargulca zwisającego z sufitu. Na płycie przed kratą są jakieś glify, ale słowa są starożytne, a nawet gdyby nie były, nie masz pewności, czy potrafiłbyś je dobrze odczytać. Nagle nad głową rozlega się głos.%SPEECH_ON%Stado ptaków jest na polu, gdy pojawia się myśliwy. Myśliwy naciąga strzałę i krzyczy, jakby go bolało. Kilka ptaków wzlatuje. Myśliwy je zabija. Więcej ptaków wzlatuje, myśliwy zabija je równie dobrze i zaczyna płakać, zbierając ich ciała. Więcej ptaków leci na dźwięk jego głosu. Myśliwy płacze i zabija. Ledwo nadąża z zakładaniem strzał i musi przystanąć, by otrzeć oczy. Jeden ptak zwraca się do przyjaciela i mówi, że powinien pocieszyć człowieka. Co odpowiada przyjaciel ptaka?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nieważne jego łzy, patrz na jego ręce!",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Z krawędzi trzeba ocalić złamanego człowieka.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Ćwir. Ćwir ćwir ćwir?",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Co?",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_111.png[/img]{Głos milknie na chwilę, po czym wraca.%SPEECH_ON%Dobrze!%SPEECH_OFF%Szarpnięta pradawną mechaniką krata zsuwa się w dół, a gargulec opuszcza się na długość ramienia, sztywny strażnik fiolki patrzy ze stoickim spokojem. Chwytasz fiolkę i przyciskasz ją do siebie, jakby potworne kamienne dzieło miało ożyć i odebrać ją z powrotem. Kręcisz pochodnią i żądasz, by ujawnił się mówiący. Głos się śmieje, i to wszystko. %volunteer% patrzy na ciebie i wzrusza ramionami.%SPEECH_ON%No cóż, mamy skarb, prawda? Nie zaszkodzi spróbować po następną.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Możemy spróbować.",
					function getResult( _event )
					{
						return "G";
					}

				},
				{
					Text = "Wygląda niebezpiecznie. Wyjdźmy teraz.",
					function getResult( _event )
					{
						return "F";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
				this.World.Assets.getStash().makeEmptySlots(1);
				local item;
				item = this.new("scripts/items/tools/holy_water_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_111.png[/img]{Kręcisz głową. Pierwsza fiolka to był przypadek, zapewne końcowy skutek czyjejś nieudanej grabieży. Miałeś szczęście. Druga fiolka ma głos, który zadaje bezsensowne bzdury. Wystarczy. Każesz %volunteer% wyjść ze świątyni i szybko odchodzisz z dwiema fiolkami i zdrowym rozsądkiem, by zadowolić się tylko tym.\n\n Na zewnątrz zastajesz %companyname% kopiących i trącających zwłoki, z których wciąż świeżo sączy się krew. Mówią, że człowiek wybiegł ze świątyni, gdy byłeś na dole. Jeden z najemników wyciąga skrawek papieru. Rysunki przedstawiają fiolki i pokazują, jak płyny wypalają wiedergangery jak roztopiony metal wlany na mrówkę. %volunteer% śmieje się.%SPEECH_ON%No to już wiadomo, do czego to służy.%SPEECH_OFF%Kiwasz głową i pytasz, czy ten trup miał przy sobie coś jeszcze. Inny najemnik wzrusza ramionami.%SPEECH_ON%Wyszedł tam, gdzie wszedłeś. Powiedział \'uzbrojony człowiek, stalowy towarzysz, dla ciebie mam zagadkę\', a potem go ściąłem. Wyglądał na groźnego.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To chyba najlepszy sposób na odpowiedź na zagadkę.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_111.png[/img]{Ostatnia fiolka jest za kolejną kratą, niepokojącą już od strony architektonicznej. Nie ma tu zwykłych kamiennych prętów, lecz skręcone żelazne kolce poorane żużlem i szlaką, a krata nie sięga do piersi, tylko do łydek. Sama fiolka jest wyżej, co oznacza, że trzeba by sięgnąć pod ścianą, a potem w górę, by ją zdobyć. Głos powraca.%SPEECH_ON%Ze mnie wszystko powstaje, do mnie wszystko w końcu wróci. Gdy człowiek stąpa po ziemi, podążam za jego śladami.%SPEECH_OFF%Stoisz w ciszy i patrzysz na %volunteer%. Wzrusza ramionami.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Proch.",
					function getResult( _event )
					{
						return "H";
					}

				},
				{
					Text = "Idź się farkuj!",
					function getResult( _event )
					{
						return "I";
					}

				},
				{
					Text = "Pomóż mi wyważyć tę kratę, %volunteer%!",
					function getResult( _event )
					{
						return "J";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_111.png[/img]{Gdy tylko słowo schodzi z twoich ust, krata podskakuje w górę. W zamyśleniu wpatrujesz się w pozostałą szczelinę. %volunteer% kuca i wsadza ramię pod górną część kraty, po czym sięga po fiolkę. Jego palce skrobią po szkle, a kolce kraty dzwonią w zaczepach niczym niedźwiedź niechętnie pozwalający komuś wyszczotkować zęby. Mężczyzna w końcu ściska fiolkę dwoma palcami i nożycowym ruchem przerzuca ją w bezpieczny chwyt dłoni. Wstaje i podaje ci ją.%SPEECH_ON%Proste, co?%SPEECH_OFF%Kiwasz głową, po czym obracasz się z pochodnią i krzyczysz, domagając się, by ujawnił się mówiący. Brak odpowiedzi. Krótkie przeszukanie ciemności nie znajduje kryjówek ani nor, ale znajdujesz skrawki i notatki z rysunkami. Strony zdają się wskazywać, że fiolki potrafią zabić wiedergangery już samym dotknięciem płynu w każdej z nich. Jest też lepki papier z prymitywnie narysowaną kobietą. Ktokolwiek tu był, nie obchodzi cię to. Zabierasz fiolki i wracasz do %companyname%. Na dźwięk twoich kroków dobywają mieczy, a potem zawstydzeni chowają je, gdy widzą twoją twarz.%SPEECH_ON%Przepraszam kapitanie, myśleliśmy, żeś trochę martwy. I chodzący. Chodzący trup.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "No cóż, mamy teraz fiolki na ten problem.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
				this.World.Assets.getStash().makeEmptySlots(1);
				local item;
				item = this.new("scripts/items/tools/holy_water_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_111.png[/img]{Gdy tylko słowo schodzi z twoich ust, krata podskakuje w górę. W zamyśleniu wpatrujesz się w pozostałą szczelinę. %volunteer% kuca i wsadza ramię pod górną część kraty, po czym sięga po fiolkę. Jego palce skrobią po szkle, a kolce kraty dzwonią w zaczepach. Głos nagle rozlega się z powrotem.%SPEECH_ON%M-mam się farkować? A może to ty się farkuj, hę, kolego!%SPEECH_OFF%W tej chwili zatrzask kraty puszcza, a jej kolce opadają i przebijają ramię %volunteer%. Mężczyzna krzyczy, a ty padając na kolana, podrywasz kratę w górę. Jest cięższa, niż się spodziewałeś, i gdy puszczasz, trzaska z niepokojącą ostatecznością, tu pasek z ramienia najemnika, tam strużka z żył. Owijasz ranę i pomagasz mężczyźnie kierować się do wyjścia, przez cały czas machając pochodnią, by odpędzić ewentualną zasadzkę. Jednak wychodząc, zatrzymujesz się i patrzysz na szkielety znalezione przy pierwszej fiolce. Bierzesz kroplę z fiolki i dotykasz nią opuszków palców. Brak reakcji. Potem przykładasz palec do jednej z kości i ta syczy oraz dymi. %volunteer% śmieje się.%SPEECH_ON%Dlatego jesteś kapitanem, panie. Taka intuicja może cię daleko zaprowadzić!%SPEECH_OFF%Nigdy więcej nie słyszysz tajemniczego głosu i, nie chcąc brzmieć jak szaleniec, nie wspominasz o zagadkowiczu przed %companyname%.\n\n Rany %volunteer%a nie będą jego końcem. To tylko niewielka cena za pradawne fiolki.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze, że ktoś inny zapłacił tę cenę.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
				local injury = _event.m.Volunteer.addInjury([
					{
						ID = "injury.pierced_arm_muscles",
						Threshold = 0.25,
						Script = "injury/pierced_arm_muscles_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Volunteer.getName() + " doznaje " + injury.getNameOnly()
				});
				_event.m.Volunteer.worsenMood(1.0, "Został ranny podczas przemierzania starożytnego mauzoleum");
				this.World.Assets.getStash().makeEmptySlots(1);
				local item;
				item = this.new("scripts/items/tools/holy_water_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "J",
			Text = "[img]gfx/ui/events/event_111.png[/img]{Masz dość tego gówna. Czy głos należy do pradawnego, czy do jakiegoś błazna, równie dobrze możesz to w pełni sprawdzić. Robisz krok w tył i rozbijasz kratę butem. Pręty wykręcają się w jodełki przy pierwszym uderzeniu, a przy drugim pękają. Na krótko, i dość piskliwie, głos wraca.%SPEECH_ON%H-hej! Nie możesz tego zrobić!%SPEECH_OFF%Usuwając zardzewiałe kawałki i ostre kolce, kucasz, by spojrzeć na fiolkę. Wtedy dostrzegasz mężczyznę skaczącego do małej komory fiolki. Ląduje jak koźlę spadające z urwiska i strąca flakon z uchwytu. Patrzysz, jak tłucze się o podłogę z żałosnym, szklistym trzaskiem. Chwytasz mężczyznę za stopę i wyciągasz go przez kolce kraty. Trzyma drżące ręce przed sobą, gdy %volunteer% dociska miecz do jego gardła.%SPEECH_ON%J-ja-ja nic nie chciałem przez nic. Wcale nic. Tylko nic.%SPEECH_OFF%Pytasz, kim jest. Pytasz, czy zabił tych ludzi przy pierwszej fiolce.%SPEECH_ON%M-mam na imię %idiot% i-i-i tamci to nie żadne szkielety. To żywe trupy, a potem powąchali tę tam fiolkę i padli jak pijacy. Proszę pana, ja nic nie chciałem przez nic! Tylko trochę zabawy, ot co. J-ja zrobię wszystko za darowanie życia! No, prawie wszystko.%SPEECH_OFF%Wygląda na zmartwionego. Patrzysz na %volunteer%, który wzrusza ramionami.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "No dobrze. Możesz do nas dołączyć.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return "K";
					}

				},
				{
					Text = "Nie, nie ma mowy.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return "L";
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"cripple_background"
				]);
				_event.m.Dude.getSprite("head").setBrush("bust_head_12");

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

				this.Characters.push(_event.m.Volunteer.getImagePath());
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "K",
			Text = "[img]gfx/ui/events/event_111.png[/img]{Oczy mężczyzny lśnią w ciemności, a każde spojrzenie jest jak rozsypany żar.%SPEECH_ON%Naprawdę? Mogę do was dołączyć? Dobra!%SPEECH_OFF%Powoli podnosi się na nogi, jakby szybki ruch mógł doprowadzić do równie szybkiej zmiany zdania. Wyciąga rękę, której nie ściskasz.%SPEECH_ON%Mam na imię %idiot%. Mam pół mózgu, reszta to drewno i masa. Jestem rozpałką, rzecz jasna. Żartuję. Rozpałką. Rozumiesz?%SPEECH_OFF%Patrzysz na %volunteer%, który wbija mężczyźnie miecz w pierś. Idiota napina twarz, gdy patrzy na ostrze przebijające mu serce.%SPEECH_ON%Hej. Chyba mnie zabiłeś.%SPEECH_OFF%%volunteer% kiwa głową.%SPEECH_ON%Ano. Zabiłem. Masz chwile. Przemowa?%SPEECH_OFF%Zagadkowicz krótko się zastanawia.%SPEECH_ON%Cóż, nie przygotowałem, ale... skoro... pytasz...%SPEECH_OFF%Umiera na słowie i na ostrzu. Najemnik czyści krew i przeszukuje ciało, znajdując w kieszeniach tylko stęchłe kości szczurów. Gdy puszcza zwłoki, te głucho stukają o płytki. Kucasz i dotykasz czaszki mężczyzny, odkrywając, że rzeczywiście nie żartował, połowa jest z drewna! Patrzysz na %volunteer%, który wzrusza ramionami.%SPEECH_ON%Mógłby srać złotem, a i tak nie znosiłbym jego gadki. Poza tym, spójrz na jego oczy! Ten głupiec był ślepy jak nietoperz.%SPEECH_OFF%Oczy zagadkowicza są puste i szare. Kto wie, jak długo spędził w tej świątyni.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "No cóż. Dwie fiolki są nasze.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "L",
			Text = "[img]gfx/ui/events/event_111.png[/img]{Nie masz czasu dla idioty. Pozwalasz mu odejść, a on ucieka, a ty słyszysz jego kroki chichoczące w ciemności jak trzepot nietoperza w znajomej jaskini. Niedługo potem słyszysz, że wychodzi, i ledwie dociera tak daleko, %companyname% zabija go wśród serii wrzasków i jednego krótkiego krzyku. Gdy wychodzisz na powierzchnię, zastajesz najemników kopiących ciało idioty i rabujących wszystko, co warto zabrać, a to głównie kupa źle napisanych zagadek.\n\n %volunteer% śmieje się i wkłada pozornie magiczne fiolki do ekwipunku. Każesz ludziom szykować się do dalszej drogi.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mimo wszystko wyprawa udana.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (!bro.getSkills().hasSkillOfType(this.Const.SkillType.Injury))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Volunteer = candidates[this.Math.rand(0, candidates.len() - 1)];
		}
		else
		{
			this.m.Volunteer = brothers[this.Math.rand(0, brothers.len() - 1)];
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"volunteer",
			this.m.Volunteer != null ? this.m.Volunteer.getNameOnly() : ""
		]);
		_vars.push([
			"idiot",
			this.m.Dude != null ? this.m.Dude.getNameOnly() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Volunteer = null;
		this.m.Dude = null;
	}

});

