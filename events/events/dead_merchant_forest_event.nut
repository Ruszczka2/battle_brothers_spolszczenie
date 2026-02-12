this.dead_merchant_forest_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.dead_merchant_forest";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]Maszerując przez las, natykasz się na ciało zwisające z gałęzi. Wygląda na to, że wisi tu wystarczająco długo, by nawet muchy zdążyły się nasycić. %randombrother% zwraca uwagę na ostre, zamszowe buty na stopach trupa.%SPEECH_ON%Wygląda mi to na kupca, panie.%SPEECH_OFF%Zgadzasz się i każesz go ściągnąć. Przy bliższych oględzinach widzisz, że oczy zostały wycięte, a na klatce piersiowej narysowano tatuaże. Skoro na ciele wciąż znajdujesz trochę koron, to zapewne dzieło niecywilizowanych dzikich, wystraszonych przez obcego.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Spoczywaj w pokoju.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local money = this.Math.rand(30, 150);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Otrzymujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Koron"
				});
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;

		foreach( t in towns )
		{
			local d = playerTile.getDistanceTo(t.getTile());

			if (d < 10)
			{
				nearTown = true;
				break;
			}
		}

		if (nearTown)
		{
			return;
		}

		this.m.Score = 5;
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

