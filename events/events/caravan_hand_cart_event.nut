this.caravan_hand_cart_event <- this.inherit("scripts/events/event", {
	m = {
		CaravanHand = null
	},
	function create()
	{
		this.m.ID = "event.caravan_hand_cart";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_55.png[/img]Natrafiasz na byłego przewoźnika, %caravanhand%, który majstruje przy wozie kompanii. Przybija listwę do podłogi i używa kołków, by osadzić ją na rolce. Deska może potem opaść do wnętrza wozu po lekkim pociągnięciu i przełączeniu. Całkiem pomysłowe. Pozwoli to załadować więcej na wóz.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra robota.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.CaravanHand.getImagePath());
				this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() + 9);
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "Zyskujesz miejsce w ekwipunku"
				});
				_event.m.CaravanHand.improveMood(1.0, "Ulepszył wóz kompanii");

				if (_event.m.CaravanHand.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.CaravanHand.getMoodState()],
						text = _event.m.CaravanHand.getName() + this.Const.MoodStateEvent[_event.m.CaravanHand.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.Ambitions.getAmbition("ambition.cart").isDone() && this.World.Retinue.getInventoryUpgrades() == 0)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 6 && bro.getBackground().getID() == "background.caravan_hand")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.CaravanHand = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"caravanhand",
			this.m.CaravanHand.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.CaravanHand = null;
	}

});

