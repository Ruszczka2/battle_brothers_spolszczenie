::mods_hookNewObject("entity/world/entity_manager", function ( o )
{
	o.manageAIMercenaries = function ()
	{
		local garbage = [];

		foreach( i, merc in this.m.Mercenaries )
		{
			if (merc.isNull() || !merc.isAlive())
			{
				garbage.push(i);
			}
		}

		garbage.reverse();

		foreach( g in garbage )
		{
			this.m.Mercenaries.remove(g);
		}

		if (this.m.LastMercUpdateTime + 3.0 > this.Time.getVirtualTimeF())
		{
			return;
		}

		this.m.LastMercUpdateTime = this.Time.getVirtualTimeF();

		if (this.m.Mercenaries.len() < 2 || this.World.FactionManager.isCivilWar() && this.m.Mercenaries.len() < 3)
		{
			local playerTile = this.World.State.getPlayer().getTile();
			local candidates = [];

			foreach( s in this.World.EntityManager.getSettlements() )
			{
				if (s.isIsolated())
				{
					continue;
				}

				if (s.getTile().getDistanceTo(playerTile) <= 10)
				{
					continue;
				}

				candidates.push(s);
			}

			local start = candidates[this.Math.rand(0, candidates.len() - 1)];
			local party = this.World.spawnEntity("scripts/entity/world/party", start.getTile().Coords);
			party.setPos(this.createVec(party.getPos().X - 50, party.getPos().Y - 50));
			party.setDescription("Wolna kompania najemników, przemierzająca te ziemie i oferująca swe miecze temu, kto najwięcej zapłaci.");
			party.setFootprintType(this.Const.World.FootprintsType.Mercenaries);
			party.getFlags().set("IsMercenaries", true);

			if (start.getFactions().len() == 1)
			{
				party.setFaction(start.getOwner().getID());
			}
			else
			{
				party.setFaction(start.getFactionOfType(this.Const.FactionType.Settlement).getID());
			}

			local r = this.Math.min(330, 150 + this.World.getTime().Days);
			this.Const.World.Common.assignTroops(party, this.Const.World.Spawn.Mercenaries, this.Math.rand(r * 0.8, r));
			party.getLoot().Money = this.Math.rand(300, 600);
			party.getLoot().ArmorParts = this.Math.rand(0, 25);
			party.getLoot().Medicine = this.Math.rand(0, 10);
			party.getLoot().Ammo = this.Math.rand(0, 50);

			for( local i = 0; i < 2; i = i )
			{
				local r = this.Math.rand(1, 4);

				if (r == 1)
				{
					party.addToInventory("supplies/bread_item");
				}
				else if (r == 2)
				{
					party.addToInventory("supplies/mead_item");
				}
				else if (r == 3)
				{
					party.addToInventory("supplies/dried_fruits_item");
				}
				else if (r == 4)
				{
					party.addToInventory("supplies/beer_item");
				}

				i = ++i;
			}

			party.getSprite("base").setBrush("world_base_07");
			party.getSprite("body").setBrush("figure_mercenary_0" + this.Math.rand(1, 2));

			while (true)
			{
				local name = this.Const.Strings.MercenaryCompanyNames[this.Math.rand(0, this.Const.Strings.MercenaryCompanyNames.len() - 1)];

				if (name == this.World.Assets.getName())
				{
					continue;
				}

				local abort = false;

				foreach( p in this.m.Mercenaries )
				{
					if (p.getName() == name)
					{
						abort = true;
						break;
					}
				}

				if (abort)
				{
					continue;
				}

				party.setName(name);
				break;
			}

			while (true)
			{
				local banner = this.Const.PlayerBanners[this.Math.rand(0, this.Const.PlayerBanners.len() - 1)];

				if (banner == this.World.Assets.getBanner())
				{
					continue;
				}

				local abort = false;

				foreach( p in this.m.Mercenaries )
				{
					if (p.getBanner() == banner)
					{
						abort = true;
						break;
					}
				}

				if (abort)
				{
					continue;
				}

				party.getSprite("banner").setBrush(banner);
				break;
			}

			this.m.Mercenaries.push(this.WeakTableRef(party));
		}

		foreach( merc in this.m.Mercenaries )
		{
			merc.updatePlayerRelation();

			if (!merc.getController().hasOrders())
			{
				local candidates = [];

				foreach( s in this.m.Settlements )
				{
					if (!s.isAlive() || s.isIsolated())
					{
						continue;
					}

					if (!s.isAlliedWith(merc))
					{
						continue;
					}

					if (s.getTile().ID == merc.getTile().ID)
					{
						continue;
					}

					candidates.push(s);
				}

				if (candidates.len() == 0)
				{
					continue;
				}

				local dest = candidates[this.Math.rand(0, candidates.len() - 1)];
				local c = merc.getController();
				local wait1 = this.new("scripts/ai/world/orders/wait_order");
				wait1.setTime(this.Math.rand(10, 60) * 1.0);
				c.addOrder(wait1);
				local move = this.new("scripts/ai/world/orders/move_order");
				move.setDestination(dest.getTile());
				move.setRoadsOnly(false);
				c.addOrder(move);
				local wait2 = this.new("scripts/ai/world/orders/wait_order");
				wait2.setTime(this.Math.rand(10, 60) * 1.0);
				c.addOrder(wait2);
				local mercenary = this.new("scripts/ai/world/orders/mercenary_order");
				mercenary.setSettlement(dest);
				c.addOrder(mercenary);
			}
		}
	};
});

