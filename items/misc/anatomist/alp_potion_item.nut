this.alp_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.alp_potion";
		this.m.Name = "Nalewka Króla Nocy";
		this.m.Description = "Ten napój, efekt intensywnych badań na tak zwanym \'Trzecim Okiem\' Alpa, pozwala pijącemu widzieć przez największe mroki nocy, jakby było to pogodne, słoneczne popołudnie! Należy spodziewać się zamglonego wzroku oraz halucynacji, póki ciało się nie przystosuje.";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_34.png";
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
			text = "Niewrażliwość na kary związane z nocą"
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

	function onUse( _actor, _item = null )
	{
		_actor.getSkills().add(this.new("scripts/skills/effects/alp_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});

