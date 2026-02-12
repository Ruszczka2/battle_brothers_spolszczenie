this.ancient_plate_harness <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.ancient_plate_harness";
		this.m.Name = "Starożytna Kamizelka Płytowa";
		this.m.Description = "Ta ciężka, starożytna zbroja złożona z metalowych płyt i kolczugi nadal zapewnia doskonałą ochronę, nawet po tych niezliczonych latach. Jednak miejscami kruszy się i jest przyrdzewiała, przez co ogranicza ruchy noszącej jej osoby.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 67;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 2800;
		this.m.Condition = 200;
		this.m.ConditionMax = 200;
		this.m.StaminaModifier = -28;
	}

});

