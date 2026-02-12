this.reinforced_leather_tunic <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.reinforced_leather_tunic";
		this.m.Name = "Wzmocniona Skórzana Zbroja";
		this.m.Description = "Złowieszczy czarny płaszcz noszony na solidnej tunice, wzmocniony grubą skórzaną zbroją i żelaznymi karwaszami.";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 112;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 500;
		this.m.Condition = 100;
		this.m.ConditionMax = 100;
		this.m.StaminaModifier = -9;
	}

});

