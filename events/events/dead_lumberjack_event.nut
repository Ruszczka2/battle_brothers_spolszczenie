this.dead_lumberjack_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.dead_lumberjack";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 120.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]Las jest domem wielu osobliwości, a martwe ciała w gruncie rzeczy nie są nawet najdziwniejsze. Gdy więc natykasz się na gromadę martwych drwali, jedyne, co przykuwa twoją uwagę, to zwłoki wilkołaka zabitego obok nich. %randombrother% przygląda się śladom biegnącym tam i z powrotem przez polanę wyrębu, przerwaną tak nagle, że niektóre topory zostały wbite w pnie drzew. Spluwa i kiwa głową.%SPEECH_ON%Biedacy. Wygląda na to, że wilkołaki urządziły im porządną zasadzkę.%SPEECH_OFF%Każesz ludziom zebrać to, co da się odzyskać, i ruszacie dalej.",
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
				local item;

				if (this.Math.rand(1, 100) <= 50)
				{
					item = this.new("scripts/items/weapons/hand_axe");
				}
				else
				{
					item = this.new("scripts/items/weapons/woodcutters_axe");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Otrzymujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/misc/werewolf_pelt_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Otrzymujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
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

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;

		foreach( t in towns )
		{
			local d = playerTile.getDistanceTo(t.getTile());

			if (d <= 7)
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
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

