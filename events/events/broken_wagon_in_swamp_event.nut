this.broken_wagon_in_swamp_event <- this.inherit("scripts/events/event", {
	m = {
		Butcher = null
	},
	function create()
	{
		this.m.ID = "event.broken_wagon_in_swamp";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_09.png[/img]Bagna nie są bezpiecznym miejscem na podróże. Sądząc po niekończącym się smogu i po tym, jak wyginają się drzewa, nie ma wątpliwości, że to bulgoczące siedlisko wszelkich demonów. Przynajmniej tak mówią druidzi z tych stron. Znajdujesz tylko parę martwych koni utopionych w bagnie i wóz zmiażdżony przez błoto, które wlało się na koła i skrzynię. %randombrother% grzebie w resztkach i udaje mu się odzyskać kilka przedmiotów.%SPEECH_ON%Cóż, zawsze coś. Kto to tu zostawił, odszedł niedawno. Pewnie wystraszył się tego, co tu na co dzień mieszka.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nadal się przyda.",
					function getResult( _event )
					{
						if (_event.m.Butcher != null)
						{
							return "Butcher";
						}
						else
						{
							return 0;
						}
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
		this.m.Screens.push({
			ID = "Butcher",
			Text = "[img]gfx/ui/events/event_14.png[/img]%SPEECH_ON%Panie, chwila.%SPEECH_OFF%Mówi były rzeźnik, %butcher%. Wychodzi do przodu i zaczyna rąbać ciało konia. Wycina kilka kawałków, owija je w duże liście, suszy odrobiną ziemi i soli, po czym podaje ci je.%SPEECH_ON%Nie ma sensu zostawiać tego, co można wykorzystać.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I jesteś pewien, że to wciąż jest jadalne?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Butcher.getImagePath());
				local item = this.new("scripts/items/supplies/strange_meat_item");
				this.World.Assets.getStash().add(item);
				item = this.new("scripts/items/supplies/strange_meat_item");
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
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type != this.Const.World.TerrainType.Swamp)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.butcher")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Butcher = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Score = 9;
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"butcher",
			this.m.Butcher != null ? this.m.Butcher.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Butcher = null;
	}

});

