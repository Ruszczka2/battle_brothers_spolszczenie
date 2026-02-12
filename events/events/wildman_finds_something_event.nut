this.wildman_finds_something_event <- this.inherit("scripts/events/event", {
	m = {
		Wildman = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.wildman_finds_something";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]Gdy próbujesz nie tracić cierpliwości z powodu tego, jak wiele nisko zwisających gałęzi uderza cię w twarz, %otherguy% podbiega i mówi, że %wildman% dzikus uciekł. Odwracasz się i widzisz resztę ludzi równie zdezorientowanych jak ty. Podnosisz pięść, by uciszyć kompanię, a las odpowiada na twoje polecenie ciszy stłumionym ćwierkaniem odległych ptaków i bzyczeniem jakiejś pszczoły lub osy, której nie widać. Kręcąc głową, postanawiasz kontynuować marsz.\n\nKilka godzin później dzikus wyskakuje z krzaka, który właśnie miałeś przeciąć maczetą. Ma w ramionach naręcze przypadkowych przedmiotów. Skąd je wziął, nie masz pojęcia, ale każesz ludziom przejrzeć znaleziska. %wildman% wraca do szeregu, jakby nic się nie stało. Zerkasz na niego i widzisz, jak wpatruje się w motyla na palcu. Gdy spoglądasz ponownie, motyla już nie ma, a mężczyzna coś połyka. %otherguy% składa raport z tego, co przyniósł.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Skąd on to wziął?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				local item;
				local items = 0;

				for( local maxitems = this.Math.rand(1, 2); items < maxitems;  )
				{
					item = null;
					local r = this.Math.rand(1, 10);

					if (r == 1)
					{
						item = this.new("scripts/items/weapons/wooden_stick");
					}
					else if (r == 2)
					{
						item = this.new("scripts/items/armor/tattered_sackcloth");
					}
					else if (r == 3)
					{
						item = this.new("scripts/items/weapons/knife");
					}
					else if (r == 4)
					{
						item = this.new("scripts/items/helmets/hood");
					}
					else if (r == 5)
					{
						item = this.new("scripts/items/misc/ghoul_teeth_item");
					}
					else if (r == 6)
					{
						item = this.new("scripts/items/weapons/woodcutters_axe");
					}
					else if (r == 7)
					{
						item = this.new("scripts/items/shields/wooden_shield_old");
					}
					else if (r == 8)
					{
						item = this.new("scripts/items/weapons/militia_spear");
					}
					else
					{
						item = this.new("scripts/items/accessory/berserker_mushrooms_item");
					}

					if (item != null)
					{
						items = ++items;
						this.World.Assets.getStash().add(item);
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_wildman = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.wildman")
			{
				candidates_wildman.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_wildman.len() == 0)
		{
			return;
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Wildman = candidates_wildman[this.Math.rand(0, candidates_wildman.len() - 1)];
		this.m.OtherGuy = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = candidates_wildman.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"wildman",
			this.m.Wildman.getNameOnly()
		]);
		_vars.push([
			"otherguy",
			this.m.OtherGuy.getName()
		]);
	}

	function onClear()
	{
		this.m.Wildman = null;
		this.m.OtherGuy = null;
	}

});

