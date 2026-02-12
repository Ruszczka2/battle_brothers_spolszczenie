this.oathtaker_skull_02_item <- this.inherit("scripts/items/accessory/accessory", {
	m = {},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.oathtaker_skull_02";
		this.m.Name = "Czaszka i żuchwa Młodego Anzelma";
		this.m.Description = "Czaszka należąca do Młodego Anzelma, pierwszego Przysięgającego, z doczepioną do niej jego pękniętą żuchwą. Ruszanie w bój, będąc przyozdobionym w tak potężną relikwię, to jak gwarancja zwycięstwa, wszak któż mógłby zostać pokonanym, mając u swego boku Młodego Anzelma?";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.ItemType = this.Const.Items.ItemType.Accessory | this.Const.Items.ItemType.Quest;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		this.m.Icon = "accessory/oathtaker_skull_02.png";
		this.m.Sprite = "oathtaker_skull_02";
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
			id = 10,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Stanowczości"
		});
		result.push({
			id = 11,
			type = "text",
			icon = "ui/icons/morale.png",
			text = "Rozpocznie bitwę z wysokim morale, jeśli nastrój na to pozwala"
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.accessory.onUpdateProperties(_properties);
		_properties.Bravery += 10;
	}

	function onCombatStarted()
	{
		local actor = this.getContainer().getActor();

		if (actor.getMoodState() >= this.Const.MoodState.Neutral && actor.getMoraleState() < this.Const.MoraleState.Confident)
		{
			actor.setMoraleState(this.Const.MoraleState.Confident);
		}
	}

});

