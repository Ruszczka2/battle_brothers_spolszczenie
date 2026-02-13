this.undead_boy_who_cried_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null,
		Refusals = 0
	},
	function create()
	{
		this.m.ID = "event.undead_boy_who_cried";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 140.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Podczas wizyty w %townname% zaczepia cię chłopiec, płacząc, że nieumarli idą zjeść jego rodzinę. Pytasz, ilu ich jest, a on mówi, że tylko jeden, ale śmiertelnie groźny.%SPEECH_ON%Myślę, że to moja stara niania. Nigdy mnie nie lubiła. Proszę, pomóż!%SPEECH_OFF%Jeśli to tylko jeden wiederganger, nie powinno być z tym wiele kłopotu i pewnie poradzisz sobie sam.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zaprowadź nas do domu, dzieciaku.",
					function getResult( _event )
					{
						return "Accept1A";
					}

				},
				{
					Text = "Radź sobie sam, dzieciaku.",
					function getResult( _event )
					{
						++_event.m.Refusals;
						return "Refuse" + _event.m.Refusals;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Accept1A",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Biegniesz do domu chłopca i wpadasz do środka. Widzisz jego rodzinę ustawiającą stół do kolacji. Patrzą na ciebie jak na szaleńca, a jedna osoba pyta, czy mogą ci pomóc. Chłopiec zaczyna się śmiać tak mocno, że łapie się za brzuch i turla po ziemi. Matka chwyta go za ucho. Przeprasza, oddając go ojcu na solidne lanie.%SPEECH_ON%Przepraszamy, najemniku, nie chcemy kłopotów, ale ten chłopak, no cóż, czasem robi, co mu się podoba.%SPEECH_OFF%Trudno winić chłopca za to, że jest chłopcem, choć ten to naprawdę mały łobuz, jeśli kiedykolwiek takiego widziałeś. Wracasz na targ.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bardzo śmieszne.",
					function getResult( _event )
					{
						return "Accept1B";
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(1);
			}

		});
		this.m.Screens.push({
			ID = "Accept1B",
			Text = "[img]gfx/ui/events/event_01.png[/img]{Gdy oglądasz towary kupca, odzywa się do ciebie mały głos. Odwracasz się i widzisz, że to znowu ten przeklęty dzieciak. Ponownie wskazuje w stronę domu.%SPEECH_ON%Najemniku! Jest tam! Mówię poważnie! Musisz pomóc!%SPEECH_OFF%Pytasz, czemu nie poprosi strażników miejskich, a on mówi, że żaden mu nie ufa.%SPEECH_ON%Zbyt wiele razy ich oszukałem! Proszę, pomóż! Moja rodzina zostanie wyrżnięta!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra, dobra, chodźmy.",
					function getResult( _event )
					{
						return "Accept2A";
					}

				},
				{
					Text = "You\'re on your own, kid.",
					function getResult( _event )
					{
						++_event.m.Refusals;
						return "Refuse" + _event.m.Refusals;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Accept2A",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Wzdychasz i mówisz chłopcu, by prowadził. Niespodzianka, znów cię zrobiono w balona. Chłopiec nie przestaje się śmiać, nawet gdy ojciec porządnie go leje. Matka ponownie przeprasza i wręcza ci mały woreczek z towarem za kłopot i \"opiekuńczość\". Wracasz na targ.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To rekompensuje kłopot.",
					function getResult( _event )
					{
						return "Accept2B";
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(1);
				local item = this.new("scripts/items/supplies/roots_and_berries_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Accept2B",
			Text = "[img]gfx/ui/events/event_01.png[/img]{Gdy wracasz na targ, już spodziewasz się, że ten dziki mały kłamca znów się pojawi. Udajesz zdziwienie, gdy ciągnie cię za rękę. Przez moment wyobrażasz sobie, jak wymierzasz mu cios prosto w szczękę. Oczywiście, nie wyglądałoby to dobrze dla tych, którzy nie wiedzą, co się dzieje, więc zachowujesz spokój.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ciekawe, jak to się skończy.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "Accept3A" : "Accept3B";
					}

				},
				{
					Text = "Uciekaj, zanim dostaniesz lanie, chłopcze!",
					function getResult( _event )
					{
						++_event.m.Refusals;
						return "Refuse" + _event.m.Refusals;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Accept3A",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Ostrożnie wracasz do domu chłopca. Gdy tylko otwierasz drzwi i widzisz rodzinę grającą w karty, odwracasz się, chwytasz dzieciaka za gardło i przyciskasz go do ściany. Kopiesz drzwi, by się zamknęły, żeby nikt nie widział. Ojciec wstaje i mówi, że to jego syn, którego szarpiesz. Mówisz ojcu, żeby dał ci rózgę, którą bije chłopca. Ostrożnie wykonuje polecenie. Tym razem sam karzesz chłopaka, a kiedy kończysz, jest cały w pręgach i ryczy.\n\nRzucasz rózgę zwiniętemu dziecku i mówisz rodzicom, by zapłacili ci za czas, informując ich, że \"najemnicy nigdy nie pracują za darmo\".}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Trzeba było zastosować środki karne.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(10);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + 10 + "[/color] Koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "Accept3B",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Ostrożnie wracasz do domu chłopca. Otwierając drzwi, odwracasz się do dzieciaka i mówisz, że jeśli znowu kłamie, to... zanim skończysz groźbę, krzyk przyciąga twoją uwagę do rodziny. Duża, upiorna postać terroryzuje matkę, a ojciec próbuje ją odgonić miotłą. Dobijasz miecza, podchodzisz i ścinasz wiedergangera. Jego głowa toczy się i wpada do garnka, a ciało zapada się i rozlewa czarną maź po deskach podłogi.\n\nOdwracasz się do chłopca i mówisz mu, że prawie nie przyszedłeś, bo prawda kłamcy zawsze pozostaje kłamstwem dla innych. Kiwa głową i dziękuje, że tym razem mu uwierzyłeś. Rodzice również dziękują, ale bardziej konkretnie: sakiewką koron i towarami.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Lepiej wyrzuć ten garnek.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(1);
				this.World.Assets.addMoney(25);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + 25 + "[/color] Koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "Refuse1",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Nie ufasz małemu gówniarzowi i każesz mu przestać się bawić. Spluwa i rozgarnia butem kamienie.%SPEECH_ON%No, panie, chciałem się tylko trochę zabawić.%SPEECH_OFF%Kiedy odwraca się, by odejść, kopiesz go szybko w tyłek.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cholerny gówniarz.",
					function getResult( _event )
					{
						return "Accept" + _event.m.Refusals + "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Refuse2",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Mówisz chłopcu, że jeśli nie zniknie z twoich oczu, zgłosisz go strażnikom i każesz wrzucić do lochów. Mruczy i spluwa.%SPEECH_ON%Ech, panie, chciałem się tylko trochę pośmiać, to wszystko.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I nie wracaj.",
					function getResult( _event )
					{
						return "Accept" + _event.m.Refusals + "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Refuse3",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Kucasz, żebyś ty i chłopiec mogli patrzeć sobie w oczy. Pytasz, czy kłamie. Powoli kiwa głową. Strażnik, który to słyszy, podchodzi i chwyta dziecko za ramię.%SPEECH_ON%Ej, znowu kłamiesz? Co ci mówiłem o zaczepianiu podróżnych, co? Chyba twój ojciec za słabo używa rózgi, skoro znów to robisz. No to zobaczymy, jak poradzisz sobie w lochach!%SPEECH_OFF%Chłopca zabierają, a on zalewa się łzami, gdy zakładają mu parę zardzewiałych kajdan. To jeden z najszczęśliwszych momentów twojego życia.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Baw się dobrze w lochu.",
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
			ID = "Refuse3B",
			Text = "[img]gfx/ui/events/event_29.png[/img]{Mówisz chłopcu, żeby się odczepił. Błaga ponownie i przez moment wydaje się, jakby za jego kłamliwymi oczami kryło się coś prawdziwego. Ale nie dajesz się nabrać. Chłopiec ucieka, prosząc teraz strażników o pomoc. Oni też mu odmawiają. Kilku kupców się śmieje.%SPEECH_ON%Nikt nie wierzy w twoje kłamstwa, mały gówniarzu.%SPEECH_OFF%Jednak krzyk ucina śmiechy. Mężczyzna kuśtyka przez ulicę, trzymając się za szyję, z której między palcami tryska krew. Pada na ziemię. Blada kobieta dopada do niego, pada na jego ciało i wgryza się w nogę. Strażnicy rzucają się na miejsce i masakrują umarłych i umierających, podczas gdy nowo osierocony chłopiec zawodzi.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Och.",
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
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.FactionManager.getGreaterEvilType() != this.Const.World.GreaterEvilType.Undead || this.World.FactionManager.getGreaterEvilPhase() == this.Const.World.GreaterEvilPhase.NotSet)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
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

		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
	}

});

