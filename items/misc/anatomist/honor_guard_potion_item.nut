this.honor_guard_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.honor_guard_potion";
		this.m.Name = "Eliksir Kostnego Ciała";
		this.m.Description = "Nieumarli słusznie budzą postrach. Ludzie lękają się ich niezachwianej determinacji oraz żelaznej woli. Doświadczony wojownik doskonale zna jednak jeszcze trzecią straszliwą cechę tych przerażających stworów, a mianowicie ich odporność na włócznie i strzały. Dzięki tej miksturze żywi również mogą zyskać takąż egidę!";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_19.png";
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
			text = "Postać otrzymuje od [color=" + this.Const.UI.Color.PositiveValue + "]25%[/color] do [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] niższe obrażenia od ataków kłutych, takich jak od strzał czy włóczni"
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
		_actor.getSkills().add(this.new("scripts/skills/effects/honor_guard_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});

