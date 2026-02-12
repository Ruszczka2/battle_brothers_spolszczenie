this.research_notes_legendary_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.research_notes_legendary";
		this.m.Name = "Księga Legend";
		this.m.Description = "Wąski dziennik oprawiony piękną skórą, zawierający twe skromne notatki badawcze o istotach z mitów i legend.";
		this.m.Icon = "misc/inventory_anatomists_book_04.png";
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

		result.push({
			id = 11,
			type = "text",
			icon = "ui/icons/papers.png",
			text = "Śledzi twoje badania nad mitycznymi stworami, o ile się na jakieś natkniesz"
		});
		local buffAcquisitions = [
			{
				flag = "isKrakenPotionDiscovered",
				creatureName = "Kraken",
				potionName = "Nalewka Króla Bagien"
			},
			{
				flag = "isRachegeistPotionDiscovered",
				creatureName = "Rachegeist",
				potionName = "Mikstura Ostrza Noża"
			},
			{
				flag = "isIjirokPotionDiscovered",
				creatureName = "Ijirok",
				potionName = "Eliksir Szalonego Boga"
			},
			{
				flag = "isLorekeeperPotionDiscovered",
				creatureName = "Lorekeeper",
				potionName = "Mikstura Wewnętrznego Azylu"
			},
			{
				flag = "isLesserFleshGolemPotionAcquired",
				creatureName = "Pomniejszy Cielisty Golem",
				potionName = "Mikstura Zmiany"
			},
			{
				flag = "isGreaterFleshGolemPotionAcquired",
				creatureName = "Większy Cielisty Golem",
				potionName = "Mikstura Postępu"
			},
			{
				flag = "isGrandDivinerPotionAcquired",
				creatureName = "Wielki Wróżbita",
				potionName = "Eliksir Oświecenia"
			}
		];

		foreach( buff in buffAcquisitions )
		{
			if (this.World.Statistics.getFlags().get(buff.flag))
			{
				result.push({
					id = 15,
					type = "text",
					icon = "ui/icons/special.png",
					text = "" + buff.creatureName + ": " + buff.potionName
				});
			}
		}

		return result;
	}

});

