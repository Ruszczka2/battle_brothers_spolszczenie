this.lone_wolf_origin_another_squire_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.lone_wolf_origin_another_squire";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]{%squire% podchodzi do ciebie, drapiąc się po tyle głowy. Wygląda, jakby coś go trapiło, więc zachęcasz go, by to wyjawił. Wzdychając, pyta, czemu %squire2% został przyjęty do kompanii.%SPEECH_ON%On jest giermkiem, ja jestem giermkiem, czy obaj jesteśmy twoimi giermkami?%SPEECH_OFF%Wyjaśniasz chłopakowi, że %squire2% był giermkiem innego człowieka, ale życie potoczyło się tak, że trafił tutaj. W praktyce jest teraz najemnikiem, a %squire% wciąż jest twoim giermkiem. %squire% rozjaśnia się uśmiechem, ale szybko mu gaśnie.%SPEECH_ON%Chwileczkę, to znaczy, że jestem bardziej najemnikiem niż giermkiem?%SPEECH_OFF%Wciskasz chłopakowi w pierś księgę i każesz mu policzyć zapasy.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A pomyśleć, że kiedyś przemierzałem te ziemie sam...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				_event.m.Dude.worsenMood(0.5, "Zdezorientowany co do swojej roli jako giermka");
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.lone_wolf")
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() < 3)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local squire;
		local other_squire;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.squire")
			{
				if (bro.getFlags().get("IsLoneWolfSquire"))
				{
					squire = bro;
				}
				else
				{
					other_squire = bro;
				}
			}
		}

		if (squire == null || other_squire == null)
		{
			return;
		}

		this.m.Dude = squire;
		this.m.Other = other_squire;
		this.m.Score = 75;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"squire",
			this.m.Dude.getNameOnly()
		]);
		_vars.push([
			"squire2",
			this.m.Other.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
		this.m.Other = null;
	}

});

