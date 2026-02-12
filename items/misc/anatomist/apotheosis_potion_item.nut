this.apotheosis_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.apotheosis_potion";
		this.m.Name = "Mikstura Apoteozy";
		this.m.Description = "Ta fantastyczna mikstura jest szczytem tego, co przyniosły badania nad anatomią człowieka. Nieliczni, którzy wiedzą o jej istnieniu, twierdzą, że wypicie jej oznacza wzniesienie się na wyżyny stanu istnienia, osiągnięcie czegoś, co wykracza poza bycie zwykłym człowiekiem.";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_10.png";
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
			icon = "ui/icons/health.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+1[/color] do Zdrowia"
		});
		result.push({
			id = 11,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+1[/color] do maksymalnego Zmęczenia"
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
		_actor.getSkills().add(this.new("scripts/skills/effects/apotheosis_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});

