this.ijirok_2_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.ijirok_2";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_143.png[/img]{Plama w śnieżnych pustkowiach przyciąga twoją uwagę. Z paroma zwiadowcami idziesz sprawdzić, co to jest, podejrzewając co najwyżej padlinę zwierzęcia albo porzucony obóz. Zamiast tego znajdujesz grupę nagich zwłok, skulonych tak, jakby siedziały na krzesłach. Tworzą zwarty krąg, wszystkie zwrócone do środka, niektóre z wyciągniętymi dłońmi, jakby grzały je przy ogniu. Popychasz jedno z ciał. Gdy przechyla się do tyłu, ciało naprzeciwko unosi się. %randombrother% odskakuje.%SPEECH_ON%Na starych bogów!%SPEECH_OFF%Tuż pod pudrowym śniegiem biegnie wieniec z ciała, łączący jedne zwłoki z drugimi, wspólna profanacja poza twoim pojmowaniem. Skóra schodzi do środka, zbiegając się w mięsistym punkcie, który wyrasta ze śniegu niczym makabryczna donica. W środku nic nie ma. Jeden ze zwiadowców domaga się powrotu do bezpieczeństwa kompanii i w pełni się z nim zgadzasz.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zatrzymajmy to między nami.",
					function getResult( _event )
					{
						this.World.Flags.set("IjirokStage", 2);
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

		if (!this.World.Flags.has("IjirokStage") || this.World.Flags.get("IjirokStage") == 0 || this.World.Flags.get("IjirokStage") >= 5)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Snow || currentTile.Type != this.Const.World.TerrainType.SnowyForest)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 12)
			{
				return;
			}
		}

		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

