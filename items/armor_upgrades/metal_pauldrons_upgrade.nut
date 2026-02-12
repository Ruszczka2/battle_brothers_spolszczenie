this.metal_pauldrons_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.metal_pauldrons";
		this.m.Name = "Metalowe Naramienniki";
		this.m.Description = "Solidne metalowe naramienniki, które można dodać do dowolnej zbroi, aby zwiększyć ochronę ramion i górnych partii ciała. Oczywiście uczynią zbroję nieco cięższą.";
		this.m.ArmorDescription = "Solidne metalowe naramienniki zostały dodane do tej zbroi, aby zwiększyć ochronę ramion i górnych partii ciała, jednak kosztem dodatkowej wagi.";
		this.m.Icon = "armor_upgrades/upgrade_11.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_upgrade_11.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_upgrade_11.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "upgrade_11_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "upgrade_11_back_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "upgrade_11_back_dead";
		this.m.Value = 500;
		this.m.ConditionModifier = 40;
		this.m.StaminaModifier = 4;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/armor_body.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+40[/color] wytrzymałości"
		});
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-4[/color] maksymalnego zmęczenia"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
	}

});

