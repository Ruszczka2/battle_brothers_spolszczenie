this.treant_vs_giants_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.treant_vs_giants";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 150.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_107.png[/img]{%randombrother% wciska łydkę w dziurę w leśnym poszyciu i przeklina z frustracją.%SPEECH_ON%Do diabła, jakby mało mnie już gryzły psy!%SPEECH_OFF%Odwracasz się, by kazać mu uciszyć się, gdy nagle widzisz unholda wdrapującego się po zalesionym zboczu, które kompania właśnie przeszła. Podczas gdy wam wszystkim wspinaczka sprawiała trudność, olbrzym pędzi w górę, rozrywając stok i zostawiając za sobą małe osuwiska. Zanim zdążysz krzyknąć, ogromne drzewo wychyla się z tłumu swoich nieruchomych pobratymców i powala olbrzyma jak taran. Kula śliny śwista przez las, łamiąc gałęzie i zarośla, a olbrzym wali plecami o leśną ściółkę i nawet z tej odległości czuć drżenie ziemi pod stopami. Widzisz nadciągających kolejnych unholdów i kolejne schraty wyplatające się z leśnego kamuflażu, by stawić im czoła. To schrat kontra unhold - bój bez trzymanki!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Szykować się do ataku.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Zmykajmy stąd do diabła.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_107.png[/img]{Kucasz nisko i rozkazujesz ludziom iść naprzód, i to szybko. Maszerują jak mrówki, podczas gdy z góry spadają liście i kłęby włosów, a przemoc olbrzymów uderza w uszy jak grzmoty. Udaje wam się jednak wydostać stamtąd i zostawić za sobą wojnę potworów.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "O mało co.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_107.png[/img]{Dobijasz miecza, ale %randombrother% kładzie dłoń na twoim ramieniu.%SPEECH_ON%Naprawdę, kapitanie?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tak, naprawdę.",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.BeastsTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Edge;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Random;
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.UnholdBog, 100, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Schrats, 100, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				},
				{
					Text = "Po namyśle, nie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().Days < 20)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 25)
			{
				return false;
			}
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

