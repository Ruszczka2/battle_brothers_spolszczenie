this.webknecht_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.webknecht_potion";
		this.m.Name = "Mikstura Toksycznej Krwi";
		this.m.Description = "Każdy doświadczony łowca bestii potwierdzi, że tym, co czyni te przerośnięte pajęczaki zwane Webknechtami naprawdę strasznym, jest ich zabójczy jad. Cóż, koniec z tym! Ktokolwiek wypije tę miksturę, nie musi się już dłużej obawiać jadowitych stworzeń!";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_31.png";
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
			text = "Niewrażliwość na trucizny, także te od Webknechtów i Goblinów"
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
		_actor.getSkills().add(this.new("scripts/skills/effects/webknecht_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});

