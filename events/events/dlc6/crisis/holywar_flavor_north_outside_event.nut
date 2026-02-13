this.holywar_flavor_north_outside_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.holywar_flavor_north_outside";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 20.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_95.png[/img]Zagroda jest tlącą się ruiną, a wszystkim jej mieszkańcom ścięto głowy, z wyjątkiem jednego. Nieszczęśnika położono na ziemi, rozpostarto jak orła i podpalono od brzucha na zewnątrz: jego pierś to kraterowata, popielna ruina, a kończyny sczerniały i zwęglone, choć wciąż szkieletowe w swych resztkach. Twarz ma nietkniętą, być może celowo, i po jego wyglądzie widać, że nie umarł w sposób, jaki uznałbyś za właściwy komukolwiek, nawet własnym wrogom. | [img]gfx/ui/events/event_02.png[/img]Znajdujesz kilku południowych żołnierzy wiszących na drzewie, ich oczy dawno wydziobane przez wrony, a stopy przez łowców szczęścia. Bezwładnie kołyszą się na wietrze, a nikt z miejscowych nie spieszy się, by ich zdjąć. | [img]gfx/ui/events/event_60.png[/img]Tabor wozów jest rozrzucony po obu stronach ścieżki, drewno i materiały zalegają na polach obok. Wszystko, co wartościowe, zostało zabrane, a kupców wybito co do jednego. Rany wskazują na południowe intencje, lecz śmiertelne cięcia nie wydają się tak czyste, jak do tego przywykłeś. To równie dobrze mogli być złodzieje, którzy wykorzystali świętą wojnę jako przykrywkę. Tak czy inaczej, nic wartościowego nie zostało, więc każesz ludziom iść dalej. | [img]gfx/ui/events/event_132.png[/img]Znajdujesz pole bitwy, choć przybyłeś zbyt późno, by odegrać jakąkolwiek dramatyczną rolę: martwi leżą wszędzie, południowi i północni, a przekupnie, szabrownicy i hultaje zdążyli już ograbić wszystko po bitwie. Sądząc po mizernym wyglądzie dużego stosu południowców nagromadzonych w jednym miejscu i szybkim odwrocie od niego, nie masz wątpliwości, że Gilded wysłał naprzód zadłużone dusze, by oszczędzić resztę oddziału.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wojna nigdy się nie zmienia.",
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
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.FactionManager.isHolyWar())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.SquareCoords.Y > this.World.getMapSize().Y * 0.7)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type == this.Const.World.TerrainType.Desert || currentTile.Type != this.Const.World.TerrainType.Oasis || currentTile.TacticalType == this.Const.World.TerrainTacticalType.DesertHills)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 5)
			{
				return;
			}
		}

		this.m.Score = 10;
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

