this.named_noble_mail_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.named_noble_mail_armor";
		this.m.Description = "Ta lekka zbroja kolcza należała niegdyś do znanego mistrza szermierki. Jest lekka niczym tunika, a mimo to dobrze chroni istotne fragmenty ciała.";
		this.m.NameList = [
			"Wzmocniona Kolczuga",
			"Nocny Płaszcz",
			"Kolczuga Szlachecka",
			"Kolczuga Szermiercza"
		];
		this.m.PrefixList = [
			"Wzmocniona Kolczuga",
			"Kolczuga Szlachecka",
			"Kolczuga Szermiercza"
		];
		this.m.SuffixList = [
			"Nocny Płaszcz"
		];
		this.m.Variant = 99;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 5500;
		this.m.Condition = 160;
		this.m.ConditionMax = 160;
		this.m.StaminaModifier = -15;
		this.randomizeValues();
	}

});

