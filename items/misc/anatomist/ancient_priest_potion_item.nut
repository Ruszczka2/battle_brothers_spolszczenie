this.ancient_priest_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.ancient_priest_potion";
		this.m.Name = "Męstwo Nikczemnika";
		this.m.Description = "Ten eliksir nawet najstrachliwszych z ludzi przemieni w prawdziwy posąg odwagi. Pozostaną nieustraszeni, bez względu z jakim wrogiem przyszło się mierzyć i jak beznadziejna jest sytuacja! Skutki uboczne mogą obejmować utratę życia z powodu niemożności wycofania się, gdy sytuacja tego wymaga.";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_21.png";
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
			icon = "ui/icons/morale.png",
			text = "Nie można obniżyć morale do stopnia, w którym spowodują one ucieczkę"
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
		_actor.getSkills().add(this.new("scripts/skills/effects/ancient_priest_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});

