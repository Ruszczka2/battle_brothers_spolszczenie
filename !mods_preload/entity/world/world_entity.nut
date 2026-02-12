::mods_hookClass("entity/world/world_entity", function ( o )
{
	while (!("getStrengthAsText" in o))
	{
		o = o[o.SuperName];
	}

	o.getStrengthAsText = function ()
	{
		local v = 0;

		if (this.m.Strength != 0)
		{
			v = this.m.Strength;
		}
		else
		{
			return "";
		}

		local p = this.World.State.getPlayer() != null ? this.World.State.getPlayer().getStrength() : 33;
		local s = p / (v * 1.0);

		if (s >= 0.85 && s <= 1.15)
		{
			return "Wyrównane";
		}
		else if (s >= 0.7 && s < 0.85)
		{
			return "Stanowiące Wyzwanie";
		}
		else if (s >= 0.5 && s < 0.7)
		{
			return "Zabójcze";
		}
		else if (s < 0.5)
		{
			return "Niewykonalne";
		}
		else if (s >= 1.15 && s <= 1.3)
		{
			return "Nieco Słabsze";
		}
		else if (s >= 1.3 && s <= 1.5)
		{
			return "Słabsze";
		}
		else if (s > 1.5)
		{
			return "Żałosne";
		}

		return "Nieznane";
	};
	o.getTroopComposition = function ()
	{
		local entities = [];
		local champions = [];
		local entityTypes = [];
		entityTypes.resize(this.Const.EntityType.len(), 0);

		foreach( t in this.m.Troops )
		{
			if (t.Script.len() != "")
			{
				if (t.Variant != 0 && this.Const.DLC.Wildmen)
				{
					champions.push(t);
				}
				else
				{
					++entityTypes[t.ID];
				}
			}
		}

		foreach( c in champions )
		{
			entities.push({
				id = 20,
				type = "text",
				icon = "ui/orientation/" + this.Const.EntityIcon[c.ID] + ".png",
				text = c.Name
			});
		}

		for( local i = 0; i < entityTypes.len(); i = i )
		{
			if (entityTypes[i] > 0)
			{
				if (entityTypes[i] == 1)
				{
					entities.push({
						id = 20,
						type = "text",
						icon = "ui/orientation/" + this.Const.EntityIcon[i] + ".png",
						text = this.Const.Strings.EntityName[i]
					});
				}
				else
				{
					local num = this.Const.Strings.EngageEnemyNumbers[this.Math.max(0, this.Math.floor(this.Math.minf(1.0, entityTypes[i] / 14.0) * (this.Const.Strings.EngageEnemyNumbers.len() - 1)))];
					entities.push({
						id = 20,
						type = "text",
						icon = "ui/orientation/" + this.Const.EntityIcon[i] + ".png",
						text = num + " " + this.Const.Strings.EntityNamePlural[i]
					});
				}
			}

			i = ++i;
		}

		return entities;
	};
});

