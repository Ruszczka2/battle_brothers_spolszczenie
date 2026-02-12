this.fallen_hero_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.fallen_hero_potion";
		this.m.Name = "Eliksir Wytrwałości";
		this.m.Description = "To serum, opracowane na podstawie substancji znalezionej w pewnych niesamowitych okazach Wiedergangerów, pozwala żyjącemu człowiekowi zdobyć nieco tej niezmordowanej wytrzymałości, jaką można podziwiać u obrzydłych nieumarłych wojowników - i to bez utraty życia! Należy się spodziewać uczucia lekkiego drętwienia stawów.";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_23.png";
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
			text = "Ataki wrogów nie akumulują Zmęczenia, nie ważne czy trafią, czy chybią"
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
		_actor.getSkills().add(this.new("scripts/skills/effects/fallen_hero_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});

