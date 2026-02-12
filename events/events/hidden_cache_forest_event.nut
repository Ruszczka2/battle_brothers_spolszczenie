this.hidden_cache_forest_event <- this.inherit("scripts/events/event", {
	m = {
		Graverobber = null,
		Otherbrother = null
	},
	function create()
	{
		this.m.ID = "event.hidden_cache_forest";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 200.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]Las nie jest przyjacielem człowieka, dlatego ludzie o złej sławie chętnie zostawiają tam swoje skarby. I dziś na jeden trafiliście: skrytkę, którą %otherbrother% znalazł, uderzając palcem u stopy o jej krawędź. Wykopujesz skrzynię i rozłupujesz ją, znajdując zestaw broni, pancerzy i złota. Klepiesz najemnika po ramieniu i dziękujesz mu za jego ciężką pracę. Macha butem w powietrzu.%SPEECH_ON%Tak jest, mam palec u stopy jak nos psa tropiącego.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Rzeczywiście.",
					function getResult( _event )
					{
						if (_event.m.Graverobber != null)
						{
							return "B";
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
				this.Characters.push(_event.m.Otherbrother.getImagePath());
				local money = this.Math.rand(30, 150);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Koron"
				});
				local r = this.Math.rand(1, 8);
				local item;

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/bludgeon");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/falchion");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/knife");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/dagger");
				}
				else if (r == 5)
				{
					item = this.new("scripts/items/weapons/shortsword");
				}
				else if (r == 6)
				{
					item = this.new("scripts/items/weapons/woodcutters_axe");
				}
				else if (r == 7)
				{
					item = this.new("scripts/items/weapons/scramasax");
				}
				else if (r == 8)
				{
					item = this.new("scripts/items/weapons/hand_axe");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				r = this.Math.rand(1, 5);

				if (r == 1)
				{
					item = this.new("scripts/items/armor/gambeson");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/armor/leather_tunic");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/armor/thick_tunic");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/armor/wizard_robe");
				}
				else if (r == 5)
				{
					item = this.new("scripts/items/armor/worn_mail_shirt");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_25.png[/img]Gdy szykujesz się do odejścia, %graverobber% grabarz zatrzymuje cię.%SPEECH_ON%Chwileczkę.%SPEECH_OFF%Zeskakuje do dołu, w którym zakopano skrytkę. Zaczyna opukiwać ziemię. Stuk. Stuk. Stuk. Klek. Uderza knykciami mocniej i na jego twarzy pojawia się uśmiech.%SPEECH_ON%Wiedziałem.%SPEECH_OFF%Mężczyzna kopie w ziemi, wyciąga kolejną skrzynię i otwiera ją. Jesteś pod wrażeniem tego, co jest w środku. Grabarz kiwa głową.%SPEECH_ON%Jeśli ktoś ma coś dobrego do ukrycia, nie chowa tego w ziemi samotnie, tylko z rzeczami mniej wartościowymi. Dzięki temu, nawet jeśli znajdziesz ich skarb, wciąż jest szansa, że odciągnie cię od prawdziwych fantów. Sprytne, ale mnie to nie zwiedzie.%SPEECH_OFF%",
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
				this.Characters.push(_event.m.Graverobber.getImagePath());
				local r = this.Math.rand(1, 4);
				local item;

				if (r == 1)
				{
					item = this.new("scripts/items/loot/gemstones_item");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/loot/silver_bowl_item");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/loot/silverware_item");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/loot/golden_chalice_item");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
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

			if (d < 15)
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local graverobber_candidates = [];
		local other_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.graverobber")
			{
				graverobber_candidates.push(bro);
			}
			else
			{
				other_candidates.push(bro);
			}
		}

		if (other_candidates.len() == 0)
		{
			return;
		}

		if (graverobber_candidates.len() != 0)
		{
			this.m.Graverobber = graverobber_candidates[this.Math.rand(0, graverobber_candidates.len() - 1)];
		}

		this.m.Otherbrother = other_candidates[this.Math.rand(0, other_candidates.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"otherbrother",
			this.m.Otherbrother.getName()
		]);
		_vars.push([
			"graverobber",
			this.m.Graverobber != null ? this.m.Graverobber.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Graverobber = null;
		this.m.Otherbrother = null;
	}

});

