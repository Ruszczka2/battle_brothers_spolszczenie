this.lorekeeper_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.lorekeeper_potion";
		this.m.Name = "Mikstura Wewnętrznego Azylu";
		this.m.Description = "Ta fiolka zawiera potężny środek uspokajający, który wywoła głęboki sen, nieprzerywalny przez ból. Jest to niezbędne, aby utrzymać obiekt w stanie nieprzytomności na tyle długo, aby wszczepić kolejny rząd żeber - z kości, które zostały pozyskane z jednej ze zwyczajniejszych filakterii Strażnika Wiedzy.";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_38.png";
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
			text = "Raz na bitwę, podczas otrzymania śmiertelnego ciosu, postać przeżyje i odzyska pełnię zdrowia"
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
		_actor.getSkills().add(this.new("scripts/skills/effects/lorekeeper_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});

