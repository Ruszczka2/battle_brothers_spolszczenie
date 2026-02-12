this.heavy_lamellar_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.heavy_lamellar_armor";
		this.m.Name = "Ciężka Zbroja Lamelkowa";
		this.m.Description = "Ciężka zbroja lamelkowa, która osłania większość górnych partii ciała grubymi, nachodzącymi na siebie metalowymi płytami dla maksymalnej ochrony.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 89;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 5000;
		this.m.Condition = 285;
		this.m.ConditionMax = 285;
		this.m.StaminaModifier = -40;
	}

});

