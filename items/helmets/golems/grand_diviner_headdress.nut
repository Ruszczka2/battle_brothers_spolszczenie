this.grand_diviner_headdress <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.grand_diviner_headdress";
		this.m.Name = "Kaptur Wróżbiarski";
		this.m.Description = "Charakterystyczne nakrycie głowy noszone przez Wielkiego Wróżbitę. Wymyślna konstrukcja ogranicza pole widzenia użytkownika, ale zapewnia doskonałą ochronę.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.ReplaceSprite = true;
		this.m.Variant = 243;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 1350;
		this.m.Condition = 75;
		this.m.ConditionMax = 75;
		this.m.StaminaModifier = -2;
		this.m.Vision = -3;
	}

});

