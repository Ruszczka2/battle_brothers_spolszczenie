this.protective_runes_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.protective_runes";
		this.m.Name = "Ochronne Runy i Znaki";
		this.m.Description = "Ochronne runy i znaki zapisane na spieczonej skórze, emitujące niepokojącą aurę.";
		this.m.ArmorDescription = "Ochronne runy i znaki zapisane na spieczonej skórze zostały naniesione na tę zbroję.";
		this.m.Icon = "armor_upgrades/upgrade_07.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_upgrade_07.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_upgrade_07.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "upgrade_07_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "upgrade_07_back_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "upgrade_07_back_dead";
		this.m.Value = 1100;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] Stanowczości przy próbach morale na strach, panikę lub kontrolę umysłu"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] Stanowczości przy próbach morale na strach, panikę lub kontrolę umysłu"
		});
	}

	function onUpdateProperties( _properties )
	{
		_properties.MoraleCheckBravery[1] += 20;
	}

});

