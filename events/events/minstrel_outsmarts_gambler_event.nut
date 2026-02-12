this.minstrel_outsmarts_gambler_event <- this.inherit("scripts/events/event", {
	m = {
		Minstrel = null,
		Gambler = null
	},
	function create()
	{
		this.m.ID = "event.minstrel_outsmarts_gambler";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img] %gambler%, człowiek z hazardowym problemem, najwyraźniej obchodził obóz, prosząc ludzi o grę w podkowy - z kilkoma koronami na szali, rzecz jasna. Wygląda na to, że %minstrel%, przebiegły minstrela, przystał i przyjął zakład. Mówi, że jest całkiem dobry w tę grę, na co hazardzista odpowiada, że jest najlepszy. \n\n Dwaj mężczyźni rzucają podkowami, aż ramiona im mdleją i słońce chyli się ku zachodowi. Nikt nie wygrywa, bo gra nie wychodzi z remisu. Po kolejnej nierozstrzygniętej rundzie %minstrel% mówi, że zagra o podwójną stawkę albo nic, jeśli zagrają lewą ręką. %gambler% się zgadza. Rzuca pierwszy, posyłając trzy podkowy. Dwie pierwsze lecą byle jak, ale trzecia trafia, obracając się wokół palika. Uśmiecha się, życząc minstreli powodzenia. %minstrel% kiwa głową i podwija rękawy. Wystawia język i mruży oczy, celując. Jego stopy robią drobny step, a tuż przed rzutem odwraca się i mówi,%SPEECH_ON%Powinienem chyba dodać, że *jestem* leworęczny.%SPEECH_OFF%Nie patrząc nawet przed siebie, minstrela wypuszcza podkowę. Rzut jest idealny, ląduje dokładnie na paliku, a kolejne dwie są posłane tak szybko i płynnie, że każdy obserwujący wybucha rechotem. Szczęka hazardzisty opada z niedowierzania.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zuchwały gnojek.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Minstrel.getImagePath());
				this.Characters.push(_event.m.Gambler.getImagePath());
				_event.m.Minstrel.improveMood(1.0, "Przechytrzył " + _event.m.Gambler.getName());

				if (_event.m.Minstrel.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Minstrel.getMoodState()],
						text = _event.m.Minstrel.getName() + this.Const.MoodStateEvent[_event.m.Minstrel.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_minstrel = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.minstrel")
			{
				candidates_minstrel.push(bro);
			}
		}

		if (candidates_minstrel.len() == 0)
		{
			return;
		}

		local candidates_gambler = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.gambler")
			{
				candidates_gambler.push(bro);
			}
		}

		if (candidates_gambler.len() == 0)
		{
			return;
		}

		this.m.Minstrel = candidates_minstrel[this.Math.rand(0, candidates_minstrel.len() - 1)];
		this.m.Gambler = candidates_gambler[this.Math.rand(0, candidates_gambler.len() - 1)];
		this.m.Score = (candidates_minstrel.len() + candidates_gambler.len()) * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"minstrel",
			this.m.Minstrel.getNameOnly()
		]);
		_vars.push([
			"gambler",
			this.m.Gambler.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Minstrel = null;
		this.m.Gambler = null;
	}

});

