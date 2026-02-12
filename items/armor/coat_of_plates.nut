this.coat_of_plates <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.coat_of_plates";
		this.m.Name = "Płaszcz Płytowy";
		this.m.Description = "Jedna warstwa wyściółki, jedna warstwa solidnej kolczugi oraz ciężkie metalowe płyty przynitowane z wierzchu. Bardzo ciężka zbroja, która zapewnia doskonałą ochronę.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 37;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 7000;
		this.m.Condition = 320;
		this.m.ConditionMax = 320;
		this.m.StaminaModifier = -42;
	}

});

