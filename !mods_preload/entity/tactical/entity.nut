::mods_hookBaseClass("entity/tactical/entity", function ( o )
{
	while (!("getTooltip" in o))
	{
		o = o[o.SuperName];
	}

	o.getTooltip = function ( _targetedWidthSkill = null )
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName(),
				icon = "ui/tooltips/height_" + this.getTile().Level + ".png"
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				icon = "ui/icons/cancel.png",
				text = "Blokuje ruch"
			}
		];

		if (this.isBlockingSight())
		{
			ret.push({
				id = 4,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Blokuje widok"
			});
		}

		return ret;
	};
});

