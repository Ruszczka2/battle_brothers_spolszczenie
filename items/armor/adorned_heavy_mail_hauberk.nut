this.adorned_heavy_mail_hauberk <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.adorned_heavy_mail_hauberk";
		this.m.Name = "Zdobiona Ciężka Hauberka";
		this.m.Description = "Ciężka kolczuga, noszona pod grubą nitowaną kurtką i wzmocniona zarękawiami. Ta zbroja, przyozdobiona trofeami i z miłością pielęgnowana mimo swego intensywnego użycia, jest atrybutem prawdziwego, szlachetnego rycerza.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 109;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 6000;
		this.m.Condition = 300;
		this.m.ConditionMax = 300;
		this.m.StaminaModifier = -34;
	}

});

