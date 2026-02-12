this.padded_mail_and_lamellar_hauberk <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.padded_mail_and_lamellar_hauberk";
		this.m.Name = "Wyściełana Kolczuga z Lamelkową Hauberką";
		this.m.Description = "Ciężka kompozytowa zbroja, składająca się z płaszcza kolczego, wyściółki i elementów lamelkowych.";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.VariantString = "body_southern";
		this.m.Variant = 7;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 5600;
		this.m.Condition = 290;
		this.m.ConditionMax = 290;
		this.m.StaminaModifier = -36;
	}

});

