this.adorned_warriors_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.adorned_warriors_armor";
		this.m.Name = "Zdobiona Zbroja Wojownika";
		this.m.Description = "Długa koszula kolcza, przykryta ćwiekowaną skórzaną przeszywanicą. Mocno znoszona od częstego użycia, lecz przyozdobiona w relikwie i dobrze pielęgnowana.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 108;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 1600;
		this.m.Condition = 200;
		this.m.ConditionMax = 200;
		this.m.StaminaModifier = -22;
	}

});

