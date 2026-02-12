this.direwolf_pelt_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.direwolf_pelt";
		this.m.Name = "Opończa ze Skór Wilkorów";
		this.m.Description = "Skóry pozyskane z dzikich wilkorów, wyprawione i zszyte razem, aby nosić je jako trofeum łowcy bestii. Przyodzianie się w skórę takiej bestii może przemienić każdego w imponującą osobistość.";
		this.m.ArmorDescription = "Opończa ze skór wilkorów została przyczepiona do tej zbroi, dzięki czemu przemienia właściciela w imponującą osobistość.";
		this.m.Icon = "armor_upgrades/upgrade_01.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_upgrade_01.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_upgrade_01.png";
		this.m.SpriteFront = "upgrade_01_front";
		this.m.SpriteBack = "upgrade_01_back";
		this.m.SpriteDamagedFront = "upgrade_01_front_damaged";
		this.m.SpriteDamagedBack = "upgrade_01_back";
		this.m.SpriteCorpseFront = "upgrade_01_front_dead";
		this.m.SpriteCorpseBack = "upgrade_01_back_dead";
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
			icon = "ui/icons/special.png",
			text = "Zmniejsza Stanowczość każdego przeciwnika w zasięgu walki wręcz o [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color]"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Zmniejsza Stanowczość każdego przeciwnika w zasięgu walki wręcz o [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color]"
		});
	}

	function onUpdateProperties( _properties )
	{
		_properties.Threat += 5;
	}

});

