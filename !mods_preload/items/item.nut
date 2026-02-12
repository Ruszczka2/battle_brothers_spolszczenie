::mods_hookDescendants("items/item", function ( o )
{
	while (!("getValueString" in o))
	{
		o = o[o.SuperName];
	}

	o.getValueString = function ()
	{
		if (this.getValue() != 0)
		{
			return "Wartość [img]gfx/ui/tooltips/money.png[/img][b]" + this.getValue() + "[/b]";
		}
		else
		{
			return "Przedmiot nie jest nic wart.";
		}
	};
	o.getTooltip = function ()
	{
		local result = [
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

		if (!this.isItemType(this.Const.Items.ItemType.Crafting))
		{
			if (this.m.Categories.len() != 0)
			{
				result.push({
					id = 65,
					type = "text",
					text = this.m.Categories
				});
			}

			result.push({
				id = 66,
				type = "text",
				text = this.getValueString()
			});

			if (!this.isItemType(this.Const.Items.ItemType.Misc) || this.isItemType(this.Const.Items.ItemType.Usable) || this.isItemType(this.Const.Items.ItemType.Legendary))
			{
				if (this.getIconLarge() != null)
				{
					result.push({
						id = 3,
						type = "image",
						image = this.getIconLarge(),
						isLarge = true
					});
				}
				else
				{
					result.push({
						id = 3,
						type = "image",
						image = this.getIcon()
					});
				}
			}
		}
		else
		{
			result.push({
				id = 66,
				type = "text",
				text = this.getValueString()
			});

			if (this.Const.DLC.Unhold)
			{
				result.push({
					id = 50,
					type = "hint",
					icon = "ui/icons/plus.png",
					text = "Można wykorzystać do tworzenia przedmiotów"
				});
			}
		}

		return result;
	};
});

