this.orc_warrior_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.orc_warrior_potion";
		this.m.Name = "Mikstura Żelaznego Łba";
		this.m.Description = "Każdy weteran Biwy o Wielu Nazwach zapewne zgodnie by przyznał, że walka z wojownikiem orków to jak walka z chodzącym murem metalu i mięsa, pozornie niewrażliwym na nawet najbardziej wyniszczające ciosy. Dzięki temu napojowi teraz ty możesz być takim murem!";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_15.png";
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
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]33%[/color] szansy na odparcie efektów Oszołomienia, Ogłuszenia, Rozkojarzenia, Uwiądu i Zachwiania"
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
		_actor.getSkills().add(this.new("scripts/skills/effects/orc_warrior_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});

