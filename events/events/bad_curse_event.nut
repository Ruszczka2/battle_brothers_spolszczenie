this.bad_curse_event <- this.inherit("scripts/events/event", {
	m = {
		Cursed = null,
		Monk = null,
		Sorcerer = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.bad_curse";
		this.m.Title = "At %townname%";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%superstitious% wchodzi do twojego namiotu z kapeluszem w dłoni. Obrzeże obraca mu się w palcach, jakby skubał z niego pióra. Choć nie powiedziałeś ani słowa, mężczyzna gwałtownie kiwa głową, a oczy biegają mu, jakby szukał słów.\n\nOdkładasz pióro i pytasz, o co chodzi. Oblizuje wargi, znów kiwa głową i zaczyna tłumaczyć swoje położenie. Słowa padają szybko, ale ogólny sens jest taki, że miejscowa wiedźma przeklęła go, by nie był zdolny do pewnej cielesnej sprawności.\n\nKręcisz głową i pytasz, czego chce wiedźma, a %superstitious% mówi, że %payment% koron, inaczej klątwa zostanie z nim na całe życie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Skoro musi... idź i to załatw. Oto korony.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Nie ma takiej opcji.",
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
						Text = "Niech %monk% mnich się temu przyjrzy.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Sorcerer != null)
				{
					this.Options.push({
						Text = "Niech %sorcerer% czarnoksiężnik się temu przyjrzy.",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				this.Characters.push(_event.m.Cursed.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]Ściskając palcami powieki, zastanawiasz się, czy to na pewno życie dla ciebie. Zabijanie jest łatwe, ale to? Cóż. Wzdychasz, wstajesz i sięgasz po sakiewkę z koronami. Zabobonny mężczyzna chwieje się na czubkach palców.%SPEECH_ON%Proszę, niech pan to odliczy! Nie może brakować ani jednej korony!%SPEECH_OFF%Niechętnie kładziesz sakiewkę na stole i zaczynasz liczyć. Gdy liczba się zgadza, przekładasz monety do mieszka i rzucasz go %superstitious%. Kłania się, dziękując za twoją litość. Dajesz mu znak, by zniknął z namiotu.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Co ja muszę znosić...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cursed.getImagePath());
				_event.m.Cursed.improveMood(3.0, "Was cured of a curse");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Cursed.getMoodState()],
					text = _event.m.Cursed.getName() + this.Const.MoodStateEvent[_event.m.Cursed.getMoodState()]
				});
				this.World.Assets.addMoney(-400);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + 400 + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]Dolewasz %superstitious% goryczy kolejną złą wiadomością: nie zapłacisz żadnej wiedźmie ani grosza.%SPEECH_ON%Kilka farsowych słów jakiejś dziwnej kobiety z lasu to żadna podstawa do interesów. To, co słyszałeś, to próba naciągnięcia cię, najemniku. Nie możesz słuchać takich bzdur, zwłaszcza że bzdury włóczęgi zawsze idą za cudzymi monetami.%SPEECH_OFF%Te słowa nie pomagają %superstitious%, bo szybko wybiega z namiotu, być może szukać innego najemnika, który pożyczy mu pieniądze.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niektórym nie da się pomóc.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cursed.getImagePath());
				local effect = this.new("scripts/skills/effects_world/afraid_effect");
				_event.m.Cursed.getSkills().add(effect);
				this.List = [
					{
						id = 10,
						icon = effect.getIcon(),
						text = _event.m.Cursed.getName() + " jest przerażony"
					}
				];
				_event.m.Cursed.worsenMood(2.0, "Felt let down by you");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Cursed.getMoodState()],
					text = _event.m.Cursed.getName() + this.Const.MoodStateEvent[_event.m.Cursed.getMoodState()]
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]Zastanawiając się, czy %monk% mnich mógłby pomóc, idziesz po świętego człowieka.\n\nMówi, że rzeczywiście może pomóc, bo starzy bogowie zawsze walczą ze złem czarów i wszelkiej magii. Zanim zacznie długą przemowę o tym czy tamtym bóstwie, wymykasz się i wysyłasz do niego %superstitious%. Przez kilka minut w namiocie panuje spokój i cisza. Ale wiesz, że to nie potrwa, bo jesteś jak człowiek pod osuwiskiem, czekający na kamień z własnym imieniem.\n\n Jednak %superstitious% nie wraca. Po kilku kolejnych minutach zdajesz sobie sprawę, że nadal nie zrobił hałaśliwego wejścia. Właściwie jego nieobecność sama w sobie wyprowadza cię z równowagi, jakby cisza była natarczywa. Wychodzisz z namiotu i znajdujesz mnicha oraz rzekomo przeklętego człowieka pogrążonych w religijnych rozmowach. Uśmiechnięty wracasz do namiotu. Jeśli w czymś święci są najlepsi, to w podtrzymywaniu spokoju ducha.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To powinno zakończyć sprawę.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cursed.getImagePath());
				this.Characters.push(_event.m.Monk.getImagePath());

				if (!_event.m.Cursed.getFlags().has("resolve_via_curse"))
				{
					_event.m.Cursed.getFlags().add("resolve_via_curse");
					_event.m.Cursed.getBaseProperties().Bravery += 1;
					_event.m.Cursed.getSkills().update();
					this.List.push({
						id = 16,
						icon = "ui/icons/bravery.png",
						text = _event.m.Cursed.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Determinację"
					});
				}

				if (!_event.m.Monk.getFlags().has("resolve_via_curse"))
				{
					_event.m.Monk.getFlags().add("resolve_via_curse");
					_event.m.Monk.getBaseProperties().Bravery += 1;
					_event.m.Monk.getSkills().update();
					this.List.push({
						id = 16,
						icon = "ui/icons/bravery.png",
						text = _event.m.Monk.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Determinację"
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_05.png[/img]Pstrykasz palcami, przypominając sobie nagle o %sorcerer%, tak zwanym czarnoksiężniku. Nie chcąc spędzić tu ani chwili dłużej w tej dziwnej sprawie, odsyłasz %superstitious% do czarnoksiężnika. Szybko odchodzi, ale niestety po kilku minutach wraca, wyjaśniając, że %sorcerer% zdjął z niego klątwę.%SPEECH_ON%Wystarczyło, że...%SPEECH_OFF%Podnosisz dłoń, uciszasz go i ucinasz opowieść. Pyta, czy chcesz usłyszeć resztę, a ty stanowczo odmawiasz.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To powinno zakończyć sprawę.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cursed.getImagePath());
				this.Characters.push(_event.m.Sorcerer.getImagePath());
				_event.m.Cursed.improveMood(3.0, "Został uwolniony od klątwy");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Cursed.getMoodState()],
					text = _event.m.Cursed.getName() + this.Const.MoodStateEvent[_event.m.Cursed.getMoodState()]
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

		if (this.World.Assets.getMoney() < 1000)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
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
		local candidates_cursed = [];
		local candidates_monk = [];
		local candidates_sorcerer = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() != "background.slave" && bro.getSkills().hasSkill("trait.superstitious"))
			{
				candidates_cursed.push(bro);
			}
			else if (bro.getBackground().getID() == "background.monk" || bro.getBackground().getID() == "background.monk_turned_flagellant")
			{
				candidates_monk.push(bro);
			}
			else if (bro.getBackground().getID() == "background.sorcerer")
			{
				candidates_sorcerer.push(bro);
			}
		}

		if (candidates_cursed.len() == 0)
		{
			return;
		}

		this.m.Cursed = candidates_cursed[this.Math.rand(0, candidates_cursed.len() - 1)];

		if (candidates_monk.len() != 0)
		{
			this.m.Monk = candidates_monk[this.Math.rand(0, candidates_monk.len() - 1)];
		}

		if (candidates_sorcerer.len() != 0)
		{
			this.m.Sorcerer = candidates_sorcerer[this.Math.rand(0, candidates_sorcerer.len() - 1)];
		}

		this.m.Town = town;
		this.m.Score = candidates_cursed.len() * 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"superstitious",
			this.m.Cursed.getNameOnly()
		]);
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getNameOnly() : ""
		]);
		_vars.push([
			"sorcerer",
			this.m.Sorcerer != null ? this.m.Sorcerer.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
		_vars.push([
			"payment",
			"400"
		]);
	}

	function onClear()
	{
		this.m.Cursed = null;
		this.m.Monk = null;
		this.m.Sorcerer = null;
		this.m.Town = null;
	}

});

