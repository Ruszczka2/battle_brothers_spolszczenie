this.ball_on_roof_event <- this.inherit("scripts/events/event", {
	m = {
		Surefooted = null,
		Other = null,
		OtherOther = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.ball_on_roof";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 140.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]Kompania natrafia na małego chłopca, który wspiął się na drzewo i doszedł do skraju gałęzi. Sięga po piłkę, która utknęła na dachu jego domu. W pobliżu nie ma żadnego rodzica, który mógłby mu pomóc. Gdy cię widzi, pyta, czy możesz pomóc odzyskać piłkę. Wydaje się to dość proste.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Chyba możemy mu pomóc.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 70)
						{
							return "Good";
						}
						else
						{
							return "Bad";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Surefooted != null)
				{
					this.Options.push({
						Text = "%surefooted%, masz pewny krok. Pomóż mu.",
						function getResult( _event )
						{
							return "Surefooted";
						}

					});
				}

				this.Options.push({
					Text = "Nie mamy na to czasu.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Good",
			Text = "[img]gfx/ui/events/event_97.png[/img]Wysyłasz %otherbrother% po piłkę. Korzystając z %otherother% jako stopnia, wspina się na dach i sięga po zabawkę. Chłopiec jest zachwycony, a jego uśmiech rozgrzewa nawet najbardziej cynicznych z twoich najemników.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jaki z ciebie dobry samarytanin na żołdzie.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				_event.m.Other.improveMood(1.0, "Pomógł małemu chłopcu");

				if (_event.m.Other.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Other.getMoodState()],
						text = _event.m.Other.getName() + this.Const.MoodStateEvent[_event.m.Other.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Bad",
			Text = "[img]gfx/ui/events/event_97.png[/img]Wysyłasz %otherbrother% po piłkę. Wspina się na drzewo i przeskakuje przez gałąź, lądując na dachu. Misja wykonana, rzuca piłkę chłopcu. Niestety, ten puszcza gałąź, próbując ją złapać. Zsuwa się i spada z dobrych piętnastu stóp na ziemię. Huk lądowania sprawia, że cała kompania krzywi się z bólu. Gdy go sprawdzasz, nie rusza się, a jego plecy przybrały nowy kształt. %otherother% krzyczy na idiotę, który wciąż stoi osłupiały na dachu.%SPEECH_ON%Co ty sobie, do diabła, myślałeś? Cholera, człowieku!%SPEECH_OFF%Najemnik schodzi z dachu. Patrzy na chłopca, potem nerwowo rozgląda się dookoła.%SPEECH_ON%Cóż, yyy, ma piłkę. Spadajmy stąd. Nasza... nasza robota tutaj skończona.%SPEECH_OFF%Co za przeklęta sytuacja. Ty i kompania szybko oddalacie się, zanim rodzice wrócą.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nikt nic nie widział.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				this.Characters.push(_event.m.OtherOther.getImagePath());
				_event.m.Other.worsenMood(1.5, "Przypadkowo okaleczył małego chłopca");

				if (_event.m.Other.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Other.getMoodState()],
						text = _event.m.Other.getName() + this.Const.MoodStateEvent[_event.m.Other.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Surefooted",
			Text = "[img]gfx/ui/events/event_97.png[/img]%surefooted% odchrząkuje i wychodzi do przodu.%SPEECH_ON%Będę twoim bohaterem, dzieciaku.%SPEECH_OFF%Rozkłada ramiona, a chłopiec w nie wskakuje. Odkłada chłopca na bok, a najemnik wskazuje palcem ziemię.%SPEECH_ON%Zostań tutaj na dole.%SPEECH_OFF%Pewnonogi najemnik bez trudu wspina się na drzewo i przeskakuje na dach. Podnosi piłkę i kręci nią na palcu, po czym wykonuje piruet z okapu niczym tornado, lądując na palcach z dość kobiecą gracją. Chłopiec klaszcze z ekscytacją i bierze zabawkę, a nawet najbardziej cynicznych ludzi w kompanii rozgrzewa jego radość.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Popisówka.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Surefooted.getImagePath());
				_event.m.Surefooted.improveMood(1.5, "Zaimponował wszystkim swoimi umiejętnościami");

				if (_event.m.Surefooted.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Surefooted.getMoodState()],
						text = _event.m.Surefooted.getName() + this.Const.MoodStateEvent[_event.m.Surefooted.getMoodState()]
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

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_surefooted = [];
		local candidates_other = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.sure_footing"))
			{
				candidates_surefooted.push(b);
			}
			else if (b.getSkills().hasSkill("trait.player"))
			{
				candidates_other.push(b);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_surefooted.len() != 0)
		{
			this.m.Surefooted = candidates_surefooted[this.Math.rand(0, candidates_surefooted.len() - 1)];
		}

		do
		{
			this.m.OtherOther = brothers[this.Math.rand(0, brothers.len() - 1)];
		}
		while (this.m.OtherOther == null || this.m.OtherOther.getID() == this.m.Other.getID());

		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"otherbrother",
			this.m.Other.getName()
		]);
		_vars.push([
			"otherother",
			this.m.OtherOther.getName()
		]);
		_vars.push([
			"surefooted",
			this.m.Surefooted != null ? this.m.Surefooted.getName() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Other = null;
		this.m.OtherOther = null;
		this.m.Surefooted = null;
		this.m.Town = null;
	}

});

