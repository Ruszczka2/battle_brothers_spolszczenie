this.barbarian_volunteer_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.barbarian_volunteer";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{W odróżnieniu od południa, spotkanie podróżnych na północnych \'drogach\' często wymaga ostrożności. Nigdy nie wiesz, na jakiego potwornego człowieka albo bestialskiego barbarzyńcę trafisz. Tym razem to rosły mężczyzna kuśtykający z psem u boku. Wysuwasz miecz do połowy z pochwy, na tyle głośno, by zwrócić jego uwagę. Mężczyzna podnosi wzrok, a jego pies staje dęba po nagłym szarpnięciu smyczy. Północniak zna trochę twoją mowę.%SPEECH_ON%Ach, wojownicy. Sam jestem wojownikiem.%SPEECH_OFF%Pytasz, czemu jest sam. Wyjaśnia, że jego klan popadł w spór i miał stoczyć pojedynek z innym mężczyzną, by zdecydować, kto przejmie władzę. Pytasz, czemu nie stoczył tego pojedynku, pytasz, czy się boi. Wędrowiec kręci głową.%SPEECH_ON%Nie. Ten z klanu był moim bratem. A ja nie chciałem zabijać krewniaka. Dali mi tę sukę, jako zniewagę i nagrodę jednocześnie, i wyrzucili z plemienia. Nie mam ziemi ani ludzi, do których mógłbym wrócić, ale jeśli mnie przyjmiesz, będę walczył dla ciebie tak samo dobrze jak każdy inny.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Znalazłeś nowy ród, przyjacielu.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "Nie potrzebujemy cię.",
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
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"barbarian_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% joined you after being exiled from his tribe in the north for refusing to kill his brother. He\'ll fight for you as well as for anyone.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.getItems().equip(this.new("scripts/items/accessory/warhound_item"));
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

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.SquareCoords.Y < this.World.getMapSize().Y * 0.7)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() == "scenario.raiders")
		{
			this.m.Score = 20;
		}
		else
		{
			this.m.Score = 5;
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

