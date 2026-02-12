this.physician_mask <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.physician_mask";
		this.m.Name = "Maska Medyka";
		this.m.Description = "Gruby skórzany kaptur ze specyficzną maską w kształcie ptasiego dziobu. Dziób działa jako wywietrznik, zawierający przyjemnie pachnące zioła, które mają za zadanie uchronić przed mdłościami i chorobą.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.ReplaceSprite = true;
		this.m.Variant = 241;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 170;
		this.m.Condition = 70;
		this.m.ConditionMax = 70;
		this.m.StaminaModifier = -3;
		this.m.Vision = -1;
	}

	function getTooltip()
	{
		local result = this.helmet.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Redukuje o [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] obrażenia zadawane przez szkodliwe wyziewy"
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.helmet.onUpdateProperties(_properties);
		_properties.IsResistantToMiasma = true;
	}

});

