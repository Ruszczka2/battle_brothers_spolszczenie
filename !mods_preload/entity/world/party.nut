::mods_hookClass("entity/world/party", function ( o )
{
	while (!("getTooltip" in o))
	{
		o = o[o.SuperName];
	}

	o.getTooltip = function ()
	{
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

		if (!this.isHiddenToPlayer() && this.m.Troops.len() != 0)
		{
			ret.extend(this.getTroopComposition());
		}
		else
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/orientation/player_01_orientation.png",
				text = "Nieznane jednostki"
			});
		}

		local f = this.World.FactionManager.getFaction(this.getFaction());

		if (this.m.Flags.get("IsMercenaries") == true)
		{
			ret.push({
				id = 50,
				type = "hint",
				icon = f.getUIBanner(),
				text = "Wynajęci przez: " + f.getName()
			});
		}
		else if (f != null && !f.isAlwaysHidden())
		{
			ret.push({
				id = 50,
				type = "hint",
				icon = f.getUIBanner(),
				text = "Pochodzi z: " + f.getName()
			});
		}

		return ret;
	};
});

