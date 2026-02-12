::mods_hookClass("entity/tactical/player_corpse_stub", function ( o )
{
	while (!("getRosterTooltip" in o))
	{
		o = o[o.SuperName];
	}

	o.getRosterTooltip = function ()
	{
		local tooltip = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			}
		];
		local time = this.m.DaysWithCompany;
		local text;

		if (time == -1)
		{
			text = "Z kompanią od samego początku.";
		}
		else if (time > 1)
		{
			text = "Z kompanią od " + time + " dni.";
		}
		else
		{
			text = "Dopiero co dołączył do kompanii.";
		}

		if (this.m.LifetimeStats.Battles != 0)
		{
			if (this.m.LifetimeStats.Battles == 1)
			{
				text = text + " Wziął udział w jednej bitwie";
			}
			else
			{
				text = text + (" Wziął udział w " + this.m.LifetimeStats.Battles + " bitwach");
			}

			if (this.m.LifetimeStats.Kills == 1)
			{
				text = text + (" i zabił " + this.m.LifetimeStats.Kills + " istotę.");
			}
			else if (this.m.LifetimeStats.Kills > 1)
			{
				text = text + (" i zabił " + this.m.LifetimeStats.Kills + " istot(y).");
			}
			else
			{
				text = text + ".";
			}

			if (this.m.LifetimeStats.MostPowerfulVanquished != "")
			{
				text = text + (" Najpotężniejszy przeciwnik, jakiego pokonał to " + this.m.LifetimeStats.MostPowerfulVanquished + ".");
			}
		}

		tooltip.push({
			id = 2,
			type = "description",
			text = text
		});
		tooltip.push({
			id = 5,
			type = "text",
			icon = "ui/icons/xp_received.png",
			text = "Poziom " + this.m.Level
		});

		if (this.m.DailyCost != 0)
		{
			tooltip.push({
				id = 3,
				type = "text",
				icon = "ui/icons/asset_daily_money.png",
				text = "Żołd: [img]gfx/ui/tooltips/money.png[/img]" + this.m.DailyCost + " dziennie"
			});
		}

		return tooltip;
	};
});

