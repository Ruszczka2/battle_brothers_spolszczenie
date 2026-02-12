this.peddler_deal_event <- this.inherit("scripts/events/event", {
	m = {
		Peddler = null
	},
	function create()
	{
		this.m.ID = "event.peddler_deal";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%peddler% podchodzi do ciebie, pocierając kark i nerwowo naciągając przód koszuli. Proponuje plan, w którym idzie do miasta z garścią towarów do sprzedania, tak jak robił to wiele razy w przeszłości.\n\nJedyny problem w tym, że jeszcze nie ma towarów - musi je kupić od kogoś z okolicznych rubieży. Potrzebuje teraz tylko trochę pieniędzy na start i zakup towaru. W sumie 500 koron. Naturalnie, jako wspólnik dostaniesz swoją część zysku, gdy wszystko się zakończy.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wchodzę w to!",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 70 ? "B" : "C";
					}

				},
				{
					Text = "Jesteś teraz najemnikiem. Czas zostawić dawne życie za sobą.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Peddler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_04.png[/img]Wręczasz %peddler% korony i rusza w drogę.\n\nKilka godzin później przekupień podbiega z małą szkatułką w dłoni. Sprytny uśmiech na jego twarzy jest nie do przeoczenia, a on nieświadomie zaciska pięść z radości, gdy podbiega do ciebie. Gdy próbuje mówić, brakuje mu tchu. Wyciągasz dłoń, mówiąc, by się nie spieszył. Uspokoiwszy się, podaje ci ciężką sakiewkę monet, mówiąc, że to twoja część zysku.\n\nZanim zdążysz cokolwiek powiedzieć, mężczyzna obraca się na pięcie i odskakuje, oszołomiony sukcesem.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Przyjemnie robi się z tobą interesy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Peddler.getImagePath());
				local money = this.Math.rand(100, 400);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Zarabiasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] koron"
					}
				];
				_event.m.Peddler.getBaseProperties().Bravery += 1;
				_event.m.Peddler.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Peddler.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Determinacji"
				});
				_event.m.Peddler.improveMood(2.0, "Zarobił na obwoźnym handlu");

				if (_event.m.Peddler.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Peddler.getMoodState()],
						text = _event.m.Peddler.getName() + this.Const.MoodStateEvent[_event.m.Peddler.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]%peddler% rusza w drogę, a ty zajmujesz się innymi sprawami.\n\nKilka godzin później wychodzisz z namiotu i widzisz w oddali zgarbioną sylwetkę zmierzającą w twoją stronę. To wygląda na przekupnia. Nie niesie niczego, poza ponurą miną. Gdy podchodzi bliżej, zaczynasz dostrzegać siniaki na jego ciele. Wyjaśnia, że choć zdołał kupić towar od źródła, mieszkańcy miasta nie byli szczególnie przychylni jego metodom sprzedaży.\n\nZainwestowane pieniądze przepadły, a %peddler% idzie do namiotu opatrzyć rany.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ale...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Peddler.getImagePath());
				this.World.Assets.addMoney(-500);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]500[/color] koron"
					}
				];
				_event.m.Peddler.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Peddler.getName() + " doznaje lekkich ran"
				});
				_event.m.Peddler.worsenMood(2, "Nie udał mu się plan i stracił dużo pieniędzy");

				if (_event.m.Peddler.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Peddler.getMoodState()],
						text = _event.m.Peddler.getName() + this.Const.MoodStateEvent[_event.m.Peddler.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() < 1000)
		{
			return;
		}

		if (!this.World.State.isCampingAllowed())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 4)
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 1)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.peddler")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Peddler = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"peddler",
			this.m.Peddler.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Peddler = null;
	}

});

