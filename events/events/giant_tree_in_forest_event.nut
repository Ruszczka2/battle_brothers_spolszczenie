this.giant_tree_in_forest_event <- this.inherit("scripts/events/event", {
	m = {
		Monk = null
	},
	function create()
	{
		this.m.ID = "event.giant_tree_in_forest";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 200.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]Przechodzisz przez ścianę krzewów i zatrzymujesz się przed niezwykłym widokiem. Nazwanie tego drzewem wydaje się obrazą. Drzewa wokół są tak niskie w porównaniu do sąsiada, że wyglądają, jakby zginały się w połowie pnia, przysięgając wierność temu, co drzewnym suzerenem, a ziemia falująca korzeniami grubymi jak człowiek, z dość gęstym cieniem u góry, by zgubić poczucie czasu między dniem a nocą.\n\n Podchodzisz do podstawy ogromu i przesuwasz dłonią po korze, lecz nagle się zatrzymujesz, boisz się, że twoja skóra naruszyła świętą ziemię, jak dziecko wpadające beztrosko do kościoła pełnego całkiem cichego tłumu. %monk%, mnich, staje obok ciebie, kiwając głową, z rękami mocno splecionymi za plecami.%SPEECH_ON%To drzewo bogów. Korzenie sięgają przez ziemię do krainy bogów. Mówi się, że kiedyś słuchali, ale teraz... nie jesteśmy tego pewni.%SPEECH_OFF%Patrzysz na niego, na jego powściągliwą postawę, i pytasz, czy boi się drzewa. Uśmiecha się i kręci głową.%SPEECH_ON%Szanuję je tak, jak człowiek szanuje morze, bo wody oceanów skrywają wiele rzeczy, których należy się bać, a jednak żeglarz i tak wypływa. Gdyby ocean był potulną bestią, czy człowiek mówiłby o nim z taką czułością?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Fascynujące.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Monk.improveMood(2.0, "Saw a godtree with his own eyes");

				if (_event.m.Monk.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk.getMoodState()],
						text = _event.m.Monk.getName() + this.Const.MoodStateEvent[_event.m.Monk.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 6)
			{
				return false;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local monk_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.monk" || bro.getBackground().getID() == "background.monk_turned_flagellant")
			{
				monk_candidates.push(bro);
			}
		}

		if (monk_candidates.len() == 0)
		{
			return;
		}

		this.m.Monk = monk_candidates[this.Math.rand(0, monk_candidates.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"monk",
			this.m.Monk.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Monk = null;
	}

});

