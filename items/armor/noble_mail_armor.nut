this.noble_mail_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.noble_mail";
		this.m.Name = "Szlachecka Kolczuga";
		this.m.Description = "Iście mistrzowsko wykonana zbroja kolcza. Bardzo lekka i elastyczna, aby ograniczyć jej ciężar, lecz nadal zapewniająca bardzo dobrą ochronę.";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 87;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 2500;
		this.m.Condition = 160;
		this.m.ConditionMax = 160;
		this.m.StaminaModifier = -15;
	}

});

