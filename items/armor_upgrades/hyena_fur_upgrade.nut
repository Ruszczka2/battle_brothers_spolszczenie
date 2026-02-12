this.hyena_fur_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.hyena_fur";
		this.m.Name = "Opończa z Futer Hien";
		this.m.Description = "Futra pozyskane z zaciekłych hien, wyprawione i zszyte razem, aby nosić je jako trofeum łowcy bestii. Przyodzianie się w skórę takiej bestii zachęca człowieka do działania.";
		this.m.ArmorDescription = "Opończa z futer hien została przyczepiona do tej zbroi, co zachęca noszącego ją człowieka do działania.";
		this.m.Icon = "armor_upgrades/upgrade_26.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_upgrade_26.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_upgrade_26.png";
		this.m.SpriteFront = "upgrade_26_front";
		this.m.SpriteBack = "upgrade_26_back";
		this.m.SpriteDamagedFront = "upgrade_26_front_damaged";
		this.m.SpriteDamagedBack = "upgrade_26_back";
		this.m.SpriteCorpseFront = "upgrade_26_front_dead";
		this.m.SpriteCorpseBack = "upgrade_26_back_dead";
		this.m.Value = 600;
		this.m.ConditionModifier = 15;
		this.m.StaminaModifier = 0;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/armor_body.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] wytrzymałości"
		});
		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/initiative.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] do Inicjatywy"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/initiative.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] do Inicjatywy"
		});
	}

	function onUpdateProperties( _properties )
	{
		_properties.Initiative += 15;
	}

});

