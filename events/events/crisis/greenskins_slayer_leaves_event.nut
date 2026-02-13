this.greenskins_slayer_leaves_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_slayer_leaves";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_35.png[/img]%orcslayer%, zabójca orków, podchodzi do ciebie.%SPEECH_ON%Cóż, chyba to już wszystko. Nie ma już tylu orków i goblinów do zabicia. Żegnam cię, najemniku.%SPEECH_OFF%Pytasz, co zamierza zrobić. Zdejmuje zbroję i kładzie ją na ziemi przed tobą.%SPEECH_ON%Moja rodzina została pomszczona.%SPEECH_OFF%Kiwasz głową i życzysz mu dobrze, skoro jego demony najwyraźniej zostały uciszone. Śmieje się.%SPEECH_ON%Żartowałem. Nie mam żadnej rodziny. Zabiłem tych skurczybyków, bo lubiłem pruć im flaki, ale serce już mi w tym nie siedzi. Pozdrów resztę ludzi ode mnie.%SPEECH_OFF%A z tym zabójca orków, czy też były zabójca orków, opuszcza kompanię.",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Żegnaj!",
					function getResult( _event )
					{
						_event.m.Dude.getItems().transferToStash(this.World.Assets.getStash());
						_event.m.Dude.getSkills().onDeath(this.Const.FatalityType.None);
						this.World.getPlayerRoster().remove(_event.m.Dude);
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Dude.getName() + " opuszcza " + this.World.Assets.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.FactionManager.isGreenskinInvasion())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() == 1)
		{
			return;
		}

		local slayer;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.orc_slayer")
			{
				slayer = bro;
				break;
			}
		}

		if (slayer == null)
		{
			return;
		}

		this.m.Dude = slayer;
		this.m.Score = 100;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"orcslayer",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

