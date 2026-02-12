::mods_hookDescendants("entity/world/settlement", function ( o )
{
	while (!("getTooltip" in o))
	{
		o = o[o.SuperName];
	}

	o.getTooltip = function ()
	{
		if (!this.m.IsActive)
		{
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Ruiny " + this.getName()
				}
			];

			if (this.isMilitary())
			{
				ret.push({
					id = 2,
					type = "description",
					text = "Jedynie ruiny pozostały po czymś, co dawniej było potężnym zamkiem."
				});
			}
			else
			{
				ret.push({
					id = 2,
					type = "description",
					text = "Jedynie ruiny pozostały po czymś, co dawniej było kwitnącym miastem."
				});
			}

			return ret;
		}

		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];

		if (this.m.IsVisited)
		{
			foreach( b in this.m.Buildings )
			{
				if (b == null || b.isHidden() || b.getID() == "building.marketplace" || b.getID() == "building.crowd")
				{
					continue;
				}

				ret.push({
					id = 4,
					type = "text",
					icon = b.getTooltipIcon(),
					text = b.getName()
				});
			}
		}
		else
		{
			ret.push({
				id = 4,
				type = "text",
				text = "Nigdy nie byłeś w tym miejscu."
			});
		}

		if (this.World.Retinue.hasFollower("follower.agent"))
		{
			local contracts = this.getContracts();
			local situations = this.getSituations();

			foreach( i, c in contracts )
			{
				if (c.isActive())
				{
					continue;
				}

				ret.push({
					id = 10 + i,
					type = "text",
					icon = "ui/icons/contract_scroll.png",
					text = c.getName()
				});
			}

			local addedSituations = {};

			foreach( i, s in situations )
			{
				if (s.isValid() && !(s.getValidUntil() == 0 && !this.World.Contracts.hasContractWithSituation(s.getInstanceID())))
				{
					local id = s.getID();

					if (!(id in addedSituations))
					{
						ret.push({
							id = 10 + contracts.len() + i,
							type = "text",
							icon = s.getIcon(),
							text = s.getName()
						});
						addedSituations[id] <- true;
					}
				}
			}
		}

		foreach( i in this.m.Factions )
		{
			local f = this.World.FactionManager.getFaction(i);
			ret.push({
				id = 5,
				type = "hint",
				icon = f.getUIBanner(),
				text = "Relacje: " + f.getPlayerRelationAsText()
			});
		}

		return ret;
	};
});

