this.heraldic_mail <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.heraldic_mail";
		this.m.Name = "Heraldyczna Kolczuga";
		this.m.Description = "Ciężka i niezwykle dobrze wykonana kolcza hauberka z dodatkowymi rękawami kolczymi i pikowanym podkładem. Tylko prawdziwy mistrz mógł stworzyć coś takiego.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 36;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 2500;
		this.m.Condition = 185;
		this.m.ConditionMax = 185;
		this.m.StaminaModifier = -18;
	}

});

