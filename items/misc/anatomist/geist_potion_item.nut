this.geist_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.geist_potion";
		this.m.Name = "Napój Truposza";
		this.m.Description = "Ten napar, wytworzony z wątłych ektoplazmowych pozostałości po \'zabitym\' Geiscie, przemienia ciało pijącej go osoby w taki sposób, że przyjmuje ono cechy podobne upiorom. Dowolna broń dzierżona przez takiego upiornego wojownika z pewnością zyska nieco jego potencjału do ignorowania pancerza! Halucynacje słuchowe są spodziewanym skutkiem ubocznym spożycia eliksiru i prawdopodobnie ustąpią po pewnym czasie. Miejmy nadzieję.";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_24.png";
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
			text = "Dodatkowe [color=" + this.Const.UI.Color.PositiveValue + "]5%[/color] obrażeń ignoruje pancerz, gdy postać używa broni do walki w zwarciu"
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
		_actor.getSkills().add(this.new("scripts/skills/effects/geist_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});

