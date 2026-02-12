this.goblin_grunt_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.goblin_grunt_potion";
		this.m.Name = "Mikstura Rączych Nóżek";
		this.m.Description = "Ta mikstura, opracowana na naparach i maściach znalezionych przy goblinach z pierwszych linii frontu, może dać człowiekowi chyżość, jakiej nie powstydziliby się najdrobniejsi z zielonoskórych. Może powodować drobne przebarwienia skóry.";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_11.png";
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
			icon = "ui/icons/action_points.png",
			text = "Koszt Punktów Akcji dla umiejętności \'Rotacja\' i \'Praca Nóg\' jest zmniejszony do [color=" + this.Const.UI.Color.PositiveValue + "]2[/color]"
		});
		result.push({
			id = 12,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "Umiejętności \'Rotacja\' i \'Praca Nóg\' generują o [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] mniej Zmęczenia"
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
		_actor.getSkills().add(this.new("scripts/skills/effects/goblin_grunt_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});

