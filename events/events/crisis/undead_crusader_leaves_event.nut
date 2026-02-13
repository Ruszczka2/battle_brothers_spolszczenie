this.undead_crusader_leaves_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.undead_crusader_leaves";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_35.png[/img]%crusader% krzyżowiec podchodzi do ciebie bez zbroi, z hełmem wsuniętym w zgięcie łokcia.%SPEECH_ON%Dobry panie, muszę pożegnać się z kompanią. Gdy nieumarli zostali pokonani, moja misja jest zakończona.%SPEECH_OFF%Chcesz uścisnąć mu dłoń, ale on po prostu podaje ci hełm i broń.%SPEECH_ON%To bardziej przyda się tobie niż mnie. Moje dni walki dobiegły końca. To była przyjemność jechać ku zmierzchowi z tobą u boku. Pozdrów ludzi ode mnie.%SPEECH_OFF%",
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
		if (this.World.FactionManager.isUndeadScourge())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() == 1)
		{
			return;
		}

		local crusader;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.crusader")
			{
				crusader = bro;
				break;
			}
		}

		if (crusader == null)
		{
			return;
		}

		this.m.Dude = crusader;
		this.m.Score = 100;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"crusader",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

