this.broken_wagon_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.broken_wagon";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%Znajdujesz porzucony wóz pośród wysokich trzcin. %randombrother% sprawdza go i krzyczy.%SPEECH_ON%Jest rozwalony na amen, ale myślę, że da się z niego coś odzyskać.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nieźle.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local amount = this.Math.rand(5, 15);
				this.World.Assets.addArmorParts(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_supplies.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] narzędzia i zapasy."
				});
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		this.m.Score = 9;
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

