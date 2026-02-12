this.grand_diviner_robes <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.grand_diviner_robes";
		this.m.Name = "Szaty Wróżbiarskie";
		this.m.Description = "Szaty noszone przez Wielkiego Wróżbitę. Wytrzymałe warstwy skóry i grubego lnu zapewniają doskonałą ochronę.";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 114;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 1200;
		this.m.Condition = 125;
		this.m.ConditionMax = 125;
		this.m.StaminaModifier = -9;
	}

});

