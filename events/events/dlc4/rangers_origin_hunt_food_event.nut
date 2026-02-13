this.rangers_origin_hunt_food_event <- this.inherit("scripts/events/event", {
	m = {
		Hunter = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.rangers_origin_hunt_food";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_10.png[/img]{Jako że jesteście gromadą myśliwych, szybko staje się jasne, że trafiliście na znakomite tereny łowieckie. %randombrother% sugeruje, by kompania poszła na polowanie, choć ostrzega, że grupa powinna uważać, ile z tych obfitych terenów wybierze.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Na polowanie!",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 70)
						{
							return "C";
						}
						else if (r <= 90)
						{
							return "B";
						}
						else
						{
							return "D";
						}
					}

				},
				{
					Text = "Będzie na to czas później.",
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
			ID = "B",
			Text = "[img]gfx/ui/events/event_10.png[/img]{Mężczyźni dostają rozkaz polowania i biorą, co się da! Strzelają, oprawiają i wybijają niemal każde żywe zwierzę w zasięgu. Obawiasz się, że zwróci to uwagę miejscowych możnych, ale niczego nie zauważają. Magazyny będą pełne!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobre polowanie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local food = this.new("scripts/items/supplies/cured_venison_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Zdobywasz dziczyznę"
				});
				local item = this.new("scripts/items/loot/valuable_furs_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_10.png[/img]{Kilku ludzi rusza na polowanie i wraca z paroma zdobyczami. Pytasz, czy napotkali jakieś kłopoty, a oni kręcą głowami. Wygląda na to, że zapasy wzbogacą się o coś smacznego i żaden możny niczego nie zauważy!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Przyzwoite polowanie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local food = this.new("scripts/items/supplies/cured_venison_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Zdobywasz dziczyznę"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "%terrainImage%{Mniej więcej godzinę po wysłaniu ludzi na polowanie wracają. Tyle że wloką zakrwawionego i poszarpanego %bearbrother% do obozu. Meldują, że grupa natknęła się na matkę niedźwiedzicę brunatną. Jej walka była potężna i przestała szarpać rannego kłusownika dopiero wtedy, gdy jeden z ludzi zagroził jej młodym pochodnią. Cieszysz się, że wszyscy żyją, choć %bearbrother% będzie dochodził do siebie bardzo długo.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ta najemnicza robota tępi nasze zmysły.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local injury = _event.m.Hunter.addInjury(this.Const.Injury.Accident3);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Hunter.getName() + " doznaje " + injury.getNameOnly()
				});
				this.Characters.push(_event.m.Hunter.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.rangers")
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest && currentTile.Type != this.Const.World.TerrainType.SnowyForest)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (!bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Hunter = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"bearbrother",
			this.m.Hunter.getName()
		]);
	}

	function onClear()
	{
		this.m.Hunter = null;
	}

});

