this.juggler_entertains_townsfolk_event <- this.inherit("scripts/events/event", {
	m = {
		Juggler = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.juggler_entertains_townsfolk";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_92.png[/img]Gdy ludzie błąkają się po %townname% w poszukiwaniu zajęcia, %juggler% kuglarz sam zapewnia sobie rozrywkę. Bierze zwój obwoźnego krzykacza i składa go w papierowy kapelusz z rogami. Zakładając go na głowę, wsuwa się w tłum wieśniaków i prosi o cokolwiek do żonglowania. Rzucają mu najróżniejsze przedmioty, od marchwi po noże, a jeden mężczyzna nawet oferuje noworodka, zanim matka go spoliczkuje za samą sugestię. Cokolwiek leci w górę, kuglarz z łatwością posyła to w powietrze, skręcając i obracając własne ciało, a stopy na zmianę zastępują mu dłonie, by podrzucać rzeczy z powrotem. To zręczna poezja w ruchu - i dar dla uciśnionych z miasta. Masz wrażenie, że kuglarz dobrze reprezentował dziś %companyname%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra robota, dobra robota.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());

				if (_event.m.Town.isSouthern())
				{
					_event.m.Town.getOwner().addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Jeden z twoich ludzi rozbawił tłumy");
				}
				else
				{
					_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Jeden z twoich ludzi rozbawił mieszkańców");
				}

				_event.m.Juggler.improveMood(2.0, "Rozbawił mieszkańców żonglerką");

				if (_event.m.Juggler.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Juggler.getMoodState()],
						text = _event.m.Juggler.getName() + this.Const.MoodStateEvent[_event.m.Juggler.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.juggler")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isMilitary())
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

		this.m.Juggler = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = candidates.len() * 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"juggler",
			this.m.Juggler.getNameOnly()
		]);
		_vars.push([
			"town",
			this.m.Town.getNameOnly()
		]);
		_vars.push([
			"townname",
			this.m.Town.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Juggler = null;
		this.m.Town = null;
	}

});

