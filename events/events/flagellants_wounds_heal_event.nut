this.flagellants_wounds_heal_event <- this.inherit("scripts/events/event", {
	m = {
		Flagellant = null
	},
	function create()
	{
		this.m.ID = "event.flagellants_wounds_heal";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_39.png[/img]%flagellant%, biczownik, siedzi po turecku przy ognisku. Jest sam, poza ćmami, które niebezpiecznie trzepoczą blisko płomieni. Czując twoją obecność, woła cię. Siadasz obok, a on uśmiecha się do ciebie.%SPEECH_ON%Stałem się lepszym człowiekiem, odkąd dołączyłem do tej kompanii.%SPEECH_OFF%Kiwając głową, przyznajesz mu rację. On kontynuuje.%SPEECH_ON%Wiele krwi oddałem bogom, lecz moje rany... to już tylko blizny. Czuję się silniejszy niż kiedykolwiek.%SPEECH_OFF%Znów kiwasz głową, ale szybko pytasz, czy przestanie się ranić. Mężczyzna wpatruje się w czerwone żary. Kręci głową.%SPEECH_ON%Będę krwawić dla bogów, aż każą mi przestać.%SPEECH_OFF%Na głos zastanawiasz się, czy bogowie w ogóle do niego przemówili. Bez chwili wahania znów kręci głową.%SPEECH_ON%Nie przemówili, więc będę krwawić, aż ich milczenie zostanie przerwane albo aż dołączę do nich w wiecznej ciszy.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Czyli czas jednak leczy wszystkie rany.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Flagellant.getImagePath());
				local hitpoints = this.Math.rand(4, 6);
				_event.m.Flagellant.getBaseProperties().Hitpoints += hitpoints;
				_event.m.Flagellant.getSkills().update();
				_event.m.Flagellant.getFlags().add("wounds_scarred_over");
				this.List = [
					{
						id = 17,
						icon = "ui/icons/health.png",
						text = _event.m.Flagellant.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + hitpoints + "[/color] Punktów Życia"
					}
				];
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
		local candidate_flagellant = [];

		foreach( bro in brothers )
		{
			if (bro.getFlags().has("wounds_scarred_over"))
			{
				continue;
			}

			if (bro.getLevel() < 6)
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.flagellant" || bro.getBackground().getID() == "background.monk_turned_flagellant")
			{
				candidate_flagellant.push(bro);
			}
		}

		if (candidate_flagellant.len() == 0)
		{
			return;
		}

		this.m.Flagellant = candidate_flagellant[this.Math.rand(0, candidate_flagellant.len() - 1)];
		this.m.Score = candidate_flagellant.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"flagellant",
			this.m.Flagellant.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Flagellant = null;
	}

});

