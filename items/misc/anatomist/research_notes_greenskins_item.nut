this.research_notes_greenskins_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.research_notes_greenskins";
		this.m.Name = "Notatki Badawcze o Zielonoskórych";
		this.m.Description = "Zgrabna kolekcja raportów naocznych świadków, zapiski z eksperymentów oraz dzienniki badawcze, szczegółowo opisujące anatomię różnorakich zielonoskórych okazów.";
		this.m.Icon = "misc/inventory_anatomists_book_01.png";
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
			text = "Śledzi twoje badania nad anatomią orków i goblinów"
		});
		local buffAcquisitions = [
			{
				flag = "isGoblinGruntPotionDiscovered",
				creatureName = "Goblin",
				potionName = "Mikstura Rączych Nóżek"
			},
			{
				flag = "isGoblinOverseerPotionDiscovered",
				creatureName = "Gobliński Nadzorca",
				potionName = "Syrop Snajpera"
			},
			{
				flag = "isGoblinShamanPotionDiscovered",
				creatureName = "Gobliński Szaman",
				potionName = "Mikstura Natłuszczania"
			},
			{
				flag = "isOrcYoungPotionDiscovered",
				creatureName = "Młody Ork",
				potionName = "Syrop Kinetyka"
			},
			{
				flag = "isOrcBerserkerPotionDiscovered",
				creatureName = "Ork Berserker",
				potionName = "Różany Napój Miłosny"
			},
			{
				flag = "isOrcWarriorPotionDiscovered",
				creatureName = "Ork Wojownik",
				potionName = "Mikstura Żelaznego Łba"
			},
			{
				flag = "isOrcWarlordPotionDiscovered",
				creatureName = "Wódz Orków",
				potionName = "Kropielnica Siły"
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
			else
			{
				result.push({
					id = 15,
					type = "text",
					icon = "ui/icons/special.png",
					text = "" + buff.creatureName + ": ???"
				});
			}
		}

		return result;
	}

});

