this.cultist_leather_robe <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.cultist_leather_robe";
		this.m.Name = "Skórzana Szata Kultysty";
		this.m.Description = "Gruba skórzana zbroja, pokryta dodatkowymi łatami skóry i okultystycznymi symbolami.";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 106;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 240;
		this.m.Condition = 88;
		this.m.ConditionMax = 88;
		this.m.StaminaModifier = -9;
	}

});

