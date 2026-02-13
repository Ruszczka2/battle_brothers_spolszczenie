this.greenskins_trapped_goblin_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_trapped_goblin";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]Kompania przechodzi przez zarośla i wchodzi na polanę, gdzie znajduje przykucniętego goblina. Odwraca się w stronę kompani, oddycha ciężko, ma posępne oczy. Widzisz, że wielka pułapka na niedźwiedzie mocno ściska jego dolne udo. Zielonoskóry próbuje warknąć, ale tylko odkasłuje krew.\n\n Obok umierającego goblina leży mężczyzna twarzą w trawie. Do biodra ma przypięte coś błyszczącego, ale nie do końca widzisz co. %randombrother% podchodzi do twojego boku.%SPEECH_ON%To może być pułapka. Pułapka w pułapce. Reszta jego kumpli pewnie nie jest daleko. Z drugiej strony, jeśli odejdziemy, może się uwolnić i powiedzieć wszystkim, że tu byliśmy. Co robimy?%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Zabić go.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				},
				{
					Text = "Zostawić go.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 70)
						{
							return "D";
						}
						else
						{
							return "E";
						}
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_25.png[/img]Tak czy inaczej, goblin nie może zostać przy życiu. Wchodzisz na polanę, by oszczędzić mu męki i, być może, rzucić okiem na skarby, jakie może nieść jego trup. Zielonoskóry kurczy się na twój widok, warcząc i podrywając się, a pułapka marszczy łańcuchy, do których jest przypięta. %randombrother%, z bronią w dłoni, ostrożnie podchodzi do bestii i zabija ją jednym ciosem.\n\n Gdy zagrożenie jest usunięte, przewracasz ciało martwego mężczyzny i grabisz wszystko, co warte wzięcia.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "O jednego goblina mniej do zmartwień.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item;
				local r = this.Math.rand(1, 6);

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/named/named_dagger");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/rondel_dagger");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/dagger");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/knife");
				}
				else if (r == 5)
				{
					item = this.new("scripts/items/loot/golden_chalice_item");
				}
				else if (r == 6)
				{
					item = this.new("scripts/items/loot/silver_bowl_item");
				}

				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_69.png[/img]To wojna na wyniszczenie i żadnemu zielonoskóremu nie wolno żyć. Wchodzisz na polanę i zabijasz to plugastwo. Gdy już nie żyje, przewracasz ciało martwego mężczyzny i zabierasz wszystko, co warte wzięcia. Gdy tylko szykujesz się do odejścia, z linii drzew dobiega bulgoczące warczenie. %randombrother% dobywa broni i wskazuje.%SPEECH_ON%Nachzerery!%SPEECH_OFF%Cholera! Musiały wyczuć umierającego goblina i przyszły ucztować. Niektóre już dłubią w zębach kościami orków...",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Trochę większy bałagan, niż się spodziewałem...",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.BeastsTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Ghouls, this.Math.rand(70, 90), this.Const.Faction.Enemy);
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item;
				local r = this.Math.rand(1, 6);

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/named/named_dagger");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/rondel_dagger");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/dagger");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/knife");
				}
				else if (r == 5)
				{
					item = this.new("scripts/items/loot/golden_chalice_item");
				}
				else if (r == 6)
				{
					item = this.new("scripts/items/loot/silver_bowl_item");
				}

				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_25.png[/img]Nie zamierzasz ryzykować kompanią dla jednego marnego goblina i martwego człowieka, który może, ale nie musi mieć nic wartościowego. Kompania omija polanę szerokim łukiem i bez problemu kontynuuje marsz przez las.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Lepiej zachować kompanię w formie na większe zagrożenia.",
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
			ID = "E",
			Text = "[img]gfx/ui/events/event_48.png[/img]Nie zamierzasz ryzykować kompanią dla jednego marnego goblina i martwego człowieka, który może, ale nie musi mieć nic wartościowego. Kompania omija polanę szerokim łukiem i kontynuuje marsz przez las.\n\n Po nie więcej niż pięciu minutach słyszysz z tyłu grzmot kroków. Na tyle głośnych i ciężkich, że ten, kto je robi, nie boi się, że zostanie usłyszany. Kucasz i czekasz, a z drzew, jak można się było spodziewać, wychodzą orki i gobliny. Jeden z nich to ten drań, którego zostawiłeś w pułapce na niedźwiedzie, z nogą naprędce owiniętą płótnem i liśćmi.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Cholera, ten mały szkrab nas znalazł!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.GoblinsTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.EnemyBanners = [
							"banner_goblins_03"
						];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.GreenskinHorde, this.Math.rand(70, 90), this.Const.Faction.Enemy);
						this.World.State.startScriptedCombat(properties, false, false, true);
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
		if (!this.World.FactionManager.isGreenskinInvasion())
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
			local d = playerTile.getDistanceTo(t.getTile());

			if (d <= 5)
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

