this.ancient_plated_mail_hauberk <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.ancient_plated_mail_hauberk";
		this.m.Name = "Starożytna Płytowana Hauberka Kolcza";
		this.m.Description = "Starożytna zbroja kolcza z płytowanymi naramiennikami. Bardzo ciężka i znacznie ograniczająca ruchy noszącej jej ocoby.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 68;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 2000;
		this.m.Condition = 180;
		this.m.ConditionMax = 180;
		this.m.StaminaModifier = -22;
	}

});

