this.bone_platings_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {
		IsUsed = false
	},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.bone_platings";
		this.m.Name = "Kościane Płyty";
		this.m.Description = "Te zdobione płyty, wytworzone z mocnych lecz zaskakująco lekkich kości, służą za osobny pancerz, noszony na zwykłej zbroi.";
		this.m.ArmorDescription = "Warstwa zdobionych kościanych płyt została przyczepiona do tej zbroi.";
		this.m.Icon = "armor_upgrades/upgrade_06.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_upgrade_06.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_upgrade_06.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "upgrade_06_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "upgrade_06_back_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "upgrade_06_back_dead";
		this.m.StaminaModifier = 2;
		this.m.Value = 850;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Całkowicie pochłania pierwsze trafienie w każdej bitwie, które nie ignoruje pancerza"
		});
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-2[/color] maksymalnego zmęczenia"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Całkowicie pochłania pierwsze trafienie w każdej bitwie, które nie ignoruje pancerza"
		});
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (this.m.IsUsed)
		{
			return;
		}

		if (_hitInfo.BodyPart == this.Const.BodyPart.Body && _hitInfo.DamageDirect < 1.0)
		{
			this.m.IsUsed = true;
			_properties.DamageReceivedTotalMult = 0.0;
		}
	}

	function onCombatFinished()
	{
		this.m.IsUsed = false;
	}

});

