this.fisherman_tells_story_event <- this.inherit("scripts/events/event", {
	m = {
		Fisherman = null
	},
	function create()
	{
		this.m.ID = "event.fisherman_tells_story";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]%fisherman%, stary rybak, raczy kompanię opowieściami ze swoich rybackich czasów.%SPEECH_ON%{Taki był duży. Przysięgam na moją mamę! Ryba tak wielka, że kiedy ją wyciągnąłem z wody, cała rzeka obniżyła się o stopę! | Ocean to bestia, tak, a niebo nad nim to jej pan, wiatry to smycz, a my, ludzie, to pchły. | Zgubiłem się! Całe lato na dryfie, cała łódź przeszyta przez polujące wody, każda fala zabierała sobie marynarza, aż zostałem tylko ja, aj, aj! To prawda! Jesienią znów zobaczyłem ląd i tak się ucieszyłem na widok drzew, gór i ptaków nad nimi, że rozbiłem statek o skały i całowałem piasek, gdy szczątki dryfowały wokół mnie. To był najszczęśliwszy dzień mojego życia. | Wieloryba białego nigdy nie widziałem, ale zielonego? Ano. Miał płaszcz z mchu, jakby ukradł futro z lądu. Ścigaliśmy go włóczniami i duchem starych marynarzy. Niestety, zorientował się, że na niego polujemy, gdy %randomname% - człowiek o najlepszym celowaniu z harpuna - trafił go w otwór oddechowy. Nie wiedziałem, że wieloryb potrafi tak szybko zawrócić, ale potrafił, i szybko rozprawił się z naszym statkiem, topiąc kilku marynarzy w napadzie zemsty. | Kiedyś złowiłem okonia, no, takiego wielkiego. Wierzysz? Dobra, był taki. No dobra, może taki. No dobra, nigdy nie złowiłem okonia. Dobrze! Nigdy nawet nie widziałem okonia! Po prostu wiem, że gdzieś są! Zostawcie mnie w spokoju, wy lądoluby! Łowię na wielkich morzach, do cholery! O waszych głupich stawach nic nie wiem. No, poza okoniami, o nich wiem.}%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Brzmi jak rybna bajka.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Fisherman.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "Felt entertained");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.fisherman")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Fisherman = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"fisherman",
			this.m.Fisherman.getName()
		]);
	}

	function onClear()
	{
		this.m.Fisherman = null;
	}

});

