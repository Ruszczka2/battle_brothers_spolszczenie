this.research_notes_beasts_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.research_notes_beasts";
		this.m.Name = "Tom Bestii";
		this.m.Description = "Traktat o wszelkich bestiach tego świata. Zakodowane notatki wypełniają marginesy w działach o najciekawszych - i autentycznych - stworach.";
		this.m.Icon = "misc/inventory_anatomists_book_03.png";
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
			text = "Śledzi twoje badania na bestiami tego świata"
		});
		local buffAcquisitions = [
			{
				flag = "isDirewolfPotionDiscovered",
				creatureName = "Wilkor",
				potionName = "Mikstura Tańca Ostrzy"
			},
			{
				flag = "isNachzehrerPotionDiscovered",
				creatureName = "Nachzehrer",
				potionName = "Mikstura Zszywania Ciała"
			}
		];

		if (this.Const.DLC.Lindwurm)
		{
			buffAcquisitions.extend([
				{
					flag = "isLindwurmPotionDiscovered",
					creatureName = "Lindwurm",
					potionName = "Nalewka Wrzącej Krwi"
				}
			]);
		}

		if (this.Const.DLC.Unhold)
		{
			buffAcquisitions.extend([
				{
					flag = "isAlpPotionDiscovered",
					creatureName = "Alp",
					potionName = "Nalewka Króla Nocy"
				},
				{
					flag = "isHexePotionDiscovered",
					creatureName = "Wiedźma",
					potionName = "Mikstura Wrogości"
				},
				{
					flag = "isSchratPotionDiscovered",
					creatureName = "Schrat",
					potionName = "Wyciąg z Korzeni Bożodrzewa"
				},
				{
					flag = "isUnholdPotionDiscovered",
					creatureName = "Unhold",
					potionName = "Mikstura Skarbu Głupców"
				},
				{
					flag = "isWebknechtPotionDiscovered",
					creatureName = "Webknecht",
					potionName = "Mikstura Toksycznej Krwi"
				}
			]);
		}

		if (this.Const.DLC.Desert)
		{
			buffAcquisitions.extend([
				{
					flag = "isHyenaPotionDiscovered",
					creatureName = "Hiena",
					potionName = "Wywar Krwawych Wrót"
				},
				{
					flag = "isSerpentPotionDiscovered",
					creatureName = "Żmija",
					potionName = "Mikstura Szybkiego Kła"
				},
				{
					flag = "isIfritPotionDiscovered",
					creatureName = "Ifrit",
					potionName = "Mikstura Kamiennej Skóry"
				}
			]);
		}

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
			else
			{
				result.push({
					id = 15,
					type = "text",
					icon = "ui/icons/special.png",
					text = "" + buff.creatureName + ": " + "???"
				});
			}
		}

		return result;
	}

});

