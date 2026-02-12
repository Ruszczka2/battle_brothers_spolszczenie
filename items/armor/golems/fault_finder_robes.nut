this.fault_finder_robes <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.fault_finder_robes";
		this.m.Name = "Szaty Okultystyczne";
		this.m.Description = "Grube, pikowane szaty przesiąknięte wątłym, acz utrzymującym się zapachem krwi i rozkładu.";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 115;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 190;
		this.m.Condition = 75;
		this.m.ConditionMax = 75;
		this.m.StaminaModifier = -7;
	}

});

