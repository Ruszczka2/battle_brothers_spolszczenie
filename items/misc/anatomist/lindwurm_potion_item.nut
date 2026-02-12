this.lindwurm_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.lindwurm_potion";
		this.m.Name = "Nalewka Wrzącej Krwi";
		this.m.Description = "Poczuj, jak gotuje się w tobie krew! Albo raczej, poczuj jak tego nie robi! Ta nalewka sprawi, że żyłami pijącego ją szczęśliwca wartko popłynie płonąca krew lindwurma. Oczywiście przynajmniej do czasu, aż się on całkiem nie wykrwawi.";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_27.png";
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
			text = "Krew tej postaci wrze od kwasu, zadając obrażenia istotom atakującym ją wręcz, gdy przebiją się przez pancerz."
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
		_actor.getSkills().add(this.new("scripts/skills/effects/lindwurm_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});

