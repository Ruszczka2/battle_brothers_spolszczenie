this.grand_diviner_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.grand_diviner_potion";
		this.m.Name = "Eliksir Oświecenia";
		this.m.Description = "Powiadają, że różnica między trucizną a lekarstwem tkwi w dawce, i chyba nigdy nie było to prawdziwsze, co w przypadku niezwykłej substancji znalezionej w kadzielnicy Wielkiego Wróżbity, a co ciekawsze, także w jego krwi. Ktokolwiek wypije ten eliksir, uwarzony z tamtej tajemniczej substancji, z pewnością zyska podobnie nieziemską zdolność widzenia!";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_39.png";
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
			icon = "ui/icons/special.png",
			text = "Postać natychmiastowo zyskuje 10 poziomów dośw."
		});
		result.push({
			id = 65,
			type = "text",
			text = "Kliknij prawym przyciskiem myszy lub przeciągnij na obecnie wybraną postać, aby wypić. Przedmiot zostanie zużyty po wykorzystaniu."
		});
		result.push({
			id = 65,
			type = "hint",
			icon = "ui/tooltips/warning.png",
			text = "Mutuje ciało, wywołuje chorobę"
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		_actor.addXP(this.Const.LevelXP[10], false);
		_actor.updateLevel();
		_actor.getSkills().add(this.new("scripts/skills/effects/grand_diviner_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});

