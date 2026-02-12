this.research_notes_undead_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.research_notes_undead";
		this.m.Name = "Księga Umarłych";
		this.m.Description = "Pokaźne tomisko przepełnione ludowymi opowieściami, opisami sekcji zwłok, notatkami z autopsji oraz szalonymi zapiskami rzekomego nekromanty, które łącznie zawierają się w całą twą wiedzę o nieumarłych.";
		this.m.Icon = "misc/inventory_anatomists_book_02.png";
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
			text = "Śledzi twoje odkrycia o nieumarłych"
		});
		local buffAcquisitions = [
			{
				flag = "isSkeletonWarriorPotionDiscovered",
				creatureName = "Starożytny Szkielet",
				potionName = "Mikstura Bezsennych"
			},
			{
				flag = "isHonorGuardPotionDiscovered",
				creatureName = "Starożytny Gwardzista Honorowy",
				potionName = "Eliksir Kościstego Ciała"
			},
			{
				flag = "isAncientPriestPotionDiscovered",
				creatureName = "Starożytny Kapłan",
				potionName = "Męstwo Nikczemnika"
			},
			{
				flag = "isNecrosavantPotionDiscovered",
				creatureName = "Necrosawant",
				potionName = "Mikstura Nocnego Łowcy"
			},
			{
				flag = "isWiedergangerPotionDiscovered",
				creatureName = "Wiederganger",
				potionName = "Mikstura Skórzanej Skóry"
			},
			{
				flag = "isFallenHeroPotionDiscovered",
				creatureName = "Poległy Bohater",
				potionName = "Eliksir Wytrwałości"
			},
			{
				flag = "isGeistPotionDiscovered",
				creatureName = "Geist",
				potionName = "Napój Truposza"
			},
			{
				flag = "isNecromancerPotionDiscovered",
				creatureName = "Nekromanta",
				potionName = "Król w Okowach"
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

