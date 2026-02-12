this.thick_plated_barbarian_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.thick_plated_barbarian_armor";
		this.m.Name = "Gruba Płytowana Zbroja Barbarzyńska";
		this.m.Description = "Ciężka zbroja, która została wykonana głównie z metalu. Tylko wybraniec przodków będzie posiadał taki zestaw.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 96;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 1200;
		this.m.Condition = 230;
		this.m.ConditionMax = 230;
		this.m.StaminaModifier = -35;
	}

});

