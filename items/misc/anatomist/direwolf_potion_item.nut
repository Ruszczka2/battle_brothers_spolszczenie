this.direwolf_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.direwolf_potion";
		this.m.Name = "Mikstura Tańca Ostrzy";
		this.m.Description = "Dzięki tej wodnistej miksturze, powstałej z badań nad przeraźliwymi wilkorami, nawet najbardziej niezdarna łajza przemieni się  gibkiego niczym tancerz wojownika, zdolnego z gracją poruszać się wśród podmuchów bitewnej zawieruchy, podczas gdy wszyscy innych już dawno przydusi zmęczenie! Łagodna akatyzja, występująca po spożyciu produktu, jest objawem normalnym i spodziewanym.";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_26.png";
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
			text = "Zadane ataki, które chybią, generują tylko [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] normalnego Zmęczenia"
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
		_actor.getSkills().add(this.new("scripts/skills/effects/direwolf_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});

