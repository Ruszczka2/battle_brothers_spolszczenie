::mods_hookDescendants("entity/world/location", function ( o )
{
	while (!("getTooltip" in o))
	{
		o = o[o.SuperName];
	}

	o.getTooltip = function ()
	{
		if (this.m.IsSpawningDefenders && this.m.DefenderSpawnList != null && this.m.Resources != 0)
		{
			if (!(this.m.Troops.len() != 0 && this.m.DefenderSpawnDay != 0 && this.World.getTime().Days - this.m.DefenderSpawnDay < 10))
			{
				this.createDefenders();
			}
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

		if (!this.isAlliedWithPlayer())
		{
			if (this.isShowingDefenders() && !this.isHiddenToPlayer() && this.m.Troops.len() != 0 && this.getFaction() != 0)
			{
				ret.extend(this.getTroopComposition());
			}
			else
			{
				ret.push({
					id = 20,
					type = "text",
					icon = "ui/orientation/player_01_orientation.png",
					text = "Nieznany garnizon"
				});
			}

			ret.push({
				id = 21,
				type = "hint",
				icon = "ui/orientation/terrain_orientation.png",
				text = "Ta lokacja znajduje się " + this.Const.Strings.TerrainAlternative[this.getTile().Type]
			});

			if (this.isShowingDefenders() && this.getCombatLocation().Template[0] != null && this.getCombatLocation().Fortification != 0 && !this.getCombatLocation().ForceLineBattle)
			{
				ret.push({
					id = 20,
					type = "hint",
					icon = "ui/orientation/palisade_01_orientation.png",
					text = "Ta lokacja ma fortyfikacje"
				});
			}
		}

		return ret;
	};
});

