this.witchhunter_ghoul_teeth_event <- this.inherit("scripts/events/event", {
	m = {
		Witchhunter = null
	},
	function create()
	{
		this.m.ID = "event.witchhunter_ghoul_teeth";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%witchhunter% łowca czarownic podchodzi do ciebie z fiolką nieznanego płynu.%SPEECH_ON%Antytoksyna.%SPEECH_OFF%Wyjaśnia. Wyciąga korek i daje ci powąchać. Czuć silny zapach szczyn. Kiwając głową, mówi:%SPEECH_ON%Ano, ohydne, ale do walki z ohydnym trzeba ohydnego, a trucizna goblinów to naprawdę ohydna sprawa. Ale to pomoże.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Przydatne.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Witchhunter.getImagePath());
				local stash = this.World.Assets.getStash().getItems();
				local numPelts = 0;

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "misc.ghoul_teeth")
					{
						numPelts = ++numPelts;
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Tracisz " + item.getName()
						});

						if (numPelts >= 1)
						{
							break;
						}
					}
				}

				local item = this.new("scripts/items/accessory/antidote_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.witchhunter")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local numPelts = 0;

		foreach( item in stash )
		{
			if (item != null && item.getID() == "misc.ghoul_teeth")
			{
				numPelts = ++numPelts;

				if (numPelts >= 1)
				{
					break;
				}
			}
		}

		if (numPelts < 1)
		{
			return;
		}

		this.m.Witchhunter = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = numPelts * candidates.len() * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"witchhunter",
			this.m.Witchhunter.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Witchhunter = null;
	}

});

