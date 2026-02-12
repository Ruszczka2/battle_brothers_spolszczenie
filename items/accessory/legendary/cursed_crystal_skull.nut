this.cursed_crystal_skull <- this.inherit("scripts/items/accessory/accessory", {
	m = {},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.cursed_crystal_skull";
		this.m.Name = "Przeklęta Kryształowa Czaszka";
		this.m.Description = "Niepokojąca czaszka, wyrzeźbiona z jednego dużego kawałka kryształu. Na jej powierzchni próżno szukać choćby najmniejszej rysy czy zadrapania. Już samo bycie w pobliżu tej upiorności łamie w człowieku wszelką determinację, zabija nadzieję i zasiewa ziarna wątpliwości.";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		this.m.Icon = "accessory/ancient_skull.png";
		this.m.Sprite = "";
		this.m.Value = 250;
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
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Redukuje o [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Stanowczość każdego przeciwnika będącego w zasięgu walki wręcz"
		});
		result.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Morale użytkownika nigdy nie może osiągnąć poziomu [color=" + this.Const.UI.Color.NegativeValue + "]pewny siebie[/color]"
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.accessory.onUpdateProperties(_properties);
		_properties.Threat += 10;
		local actor = this.getContainer().getActor();
		actor.setMaxMoraleState(this.Const.MoraleState.Steady);

		if (actor.getMoraleState() > this.Const.MoraleState.Steady)
		{
			actor.setMoraleState(this.Const.MoraleState.Steady);
			actor.setDirty(true);
		}
	}

});

