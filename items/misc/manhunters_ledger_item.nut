this.manhunters_ledger_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.manhunters_ledger";
		this.m.Name = "Księga Kompanii";
		this.m.Description = "Księga zawierająca szczegółowe wpisy na temat członków i warunków kontraktów kompanii.";
		this.m.Icon = "misc/inventory_ledger_item.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Quest;
		this.m.Value = 0;
	}

	function getTooltip()
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
		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});

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

		local indebted = this.World.Statistics.getFlags().getAsInt("ManhunterIndebted");
		local nonIndebted = this.World.Statistics.getFlags().getAsInt("ManhunterNonIndebted");
		result.push({
			id = 65,
			type = "text",
			text = indebted + " Zadłużonych w kompanii"
		});
		result.push({
			id = 65,
			type = "text",
			text = nonIndebted + " Łowców Głów w kompanii"
		});
		result.push({
			id = 65,
			type = "text",
			icon = "ui/icons/xp_received.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] przyrostu doświadczenia dla Zadłużonych"
		});
		result.push({
			id = 65,
			type = "text",
			icon = "ui/icons/xp_received.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] przyrostu doświadczenia dla Łowców Głów"
		});

		if (indebted <= nonIndebted)
		{
			result.push({
				id = 65,
				type = "hint",
				icon = "ui/tooltips/warning.png",
				text = "W kompanii jest zbyt mało Zadłużonych! Łowcy Głów okażą niezadowolenie, jeśli się to nie zmieni!"
			});
		}

		return result;
	}

});

