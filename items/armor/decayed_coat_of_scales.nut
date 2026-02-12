this.decayed_coat_of_scales <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.decayed_coat_of_scales";
		this.m.Name = "Zbutwiały Płaszcz Łuskowy";
		this.m.Description = "Ten płaszcz łuskowy jest już znoszony, część elementów jest luźna, a niektórych w ogóle brakuje. Nadal zapewni bardzo dobrą ochronę, jeśli nie przeszkadza ci jego zapach.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		local variants = [
			49,
			52,
			55,
			58
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 3000;
		this.m.Condition = 240;
		this.m.ConditionMax = 240;
		this.m.StaminaModifier = -36;
	}

});

