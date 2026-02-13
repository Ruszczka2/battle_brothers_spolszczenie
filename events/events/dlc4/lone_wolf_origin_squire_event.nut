this.lone_wolf_origin_squire_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.lone_wolf_origin_squire";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_20.png[/img]Karczma jest pełna pijanych mieszkańców, którzy chwieją się, wiwatują, śpiewają i hulają z niewiastami - czy to służącą, żoną czy ladacznicą. Mężczyzna z lutnią tańczy i gra, inny uderza w metalowe talerze nad głową, a gruby chłop ryczy pieśni o bitwach lub miłości; niezależnie od tego, czy to opowieść o zwycięstwie czy porażce, wywołują kolejne rundy piwa i jeszcze więcej wesołości.\n\n Opuszczasz karczmę i wchodzisz do następnego budynku. Wiatr gwiżdże przez nawę pełną ławek, gdy stajesz w drzwiach. Mężczyzna zamiatający kamienną posadzkę podnosi wzrok na chwilę, po czym wraca do pracy. Inny przechodzi wesoło przez salę i pyta, czy chcesz się pomodlić. Odmawiasz, a on zaciska usta i krzyżuje ramiona. Tłum obok ryczy pijanym zachwytem, jakby chciał z was zakpić, po czym odchodzi. Zostajesz jeszcze chwilę, a potem wychodzisz na rynek i przysiadasz na kilku stopniach. Wygląda na to, że kiedyś stał na nich posąg, ale wandale i najeźdźcy szybko zrobili swoje z czyimś rzemiosłem. Zasypiasz tam, u stóp przemijania. \n\n Budząc się z drzemki, znajdujesz młodego mężczyznę u podnóża schodów. Mówi, że wie, iż jesteś rycerzem, i przyszedł zaoferować swoje usługi jako giermek.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zabiłeś kogoś?",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Co potrafisz?",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Przyjmuję cię jako giermka.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Działam sam.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"squire_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "Poznałeś %name% w " + _event.m.Town.getName() + ", gdzie zgłosił się na twojego giermka. Pewnie nie miał pojęcia, w co się wtedy pakuje.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body));
				_event.m.Dude.getItems().equip(this.new("scripts/items/armor/linen_tunic"));
				_event.m.Dude.setTitle("giermek");
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_20.png[/img]{Mężczyzna kręci głową.%SPEECH_ON%Nikogo jeszcze nie zabiłem, sir.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Co potrafisz?",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Przyjmuję cię jako giermka.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Działam sam.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_20.png[/img]{Mężczyzna prostuje się.%SPEECH_ON%Umiem ostrzyć stal i cerować skórę. Potrafię rozkładać i składać pancerze ciężkie i lekkie, nieważne jak skomplikowane czy proste, i robię to szybko. Jeśli mamy konia.%SPEECH_OFF%Przerywasz.%SPEECH_ON%Idę pieszo.%SPEECH_OFF%Nerwowo przestępując z nogi na nogę, mężczyzna kontynuuje.%SPEECH_ON%Dobrze. No to umiem gotować. Ugotuję porządny posiłek, czy mam składniki, czy nie. Jakoś sobie radzę. I. I. To. To wszystko. Ale chcę się uczyć!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zabiłeś kogoś?",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Przyjmuję cię jako giermka.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Działam sam.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_20.png[/img]{Pytasz mężczyznę o imię. Nerwowo przełyka ślinę.%SPEECH_ON%%squire%, sir.%SPEECH_OFF%Kiwasz głową.%SPEECH_ON%No dobrze. Zabiorę cię ze sobą.%SPEECH_OFF%Uśmiecha się.%SPEECH_ON%To... to wszystko?%SPEECH_OFF%Kiwasz głową.%SPEECH_ON%Tak. To wszystko.%SPEECH_OFF%%squire% rozgląda się.%SPEECH_ON%Cóż. Dobrze. Co teraz?%SPEECH_OFF%Opierasz się o kamienne schody.%SPEECH_ON%Podążasz za mną. Teraz utnę sobie kolejną drzemkę. Jeśli wciąż będziesz, gdy się obudzę, to zdałeś pierwszy test. Pokonanie nudy.%SPEECH_OFF%Giermek uśmiecha się od ucha do ucha. Wciąż tam jest, gdy się budzisz.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Teraz potrzebuję piwa.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.improveMood(1.0, "Został giermkiem rycerza");
						_event.m.Dude.getFlags().set("IsLoneWolfSquire", true);
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_20.png[/img]{Przyglądasz się kandydatowi na giermka długo i uważnie, po czym mówisz mu, że nie. Wzrusza ramionami.%SPEECH_ON%Tak tylko mówię, nie musisz być samotny na tym świecie. Samotność nie ma obecności. To nie miejsce. To nie istota. To działanie!%SPEECH_OFF%Spluwasz, wycierasz twarz i śmiejesz się.%SPEECH_ON%To to sobie powtarzasz każdego ranka? Znikaj stąd.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Potrzebuję piwa.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.lone_wolf")
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() > 1)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (!t.isSouthern() && t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
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
		this.m.Score = 75;
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
		_vars.push([
			"squire",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
		this.m.Town = null;
	}

});

