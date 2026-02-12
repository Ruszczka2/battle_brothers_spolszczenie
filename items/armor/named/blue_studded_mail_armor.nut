this.blue_studded_mail_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.blue_studded_mail";
		this.m.Description = "Ta konkretna koszula kolcza została połączona z przeszywanicą i pokryta solidną, ćwiekowaną skórzaną kurtką, co łącznie tworzy lekką, acz wytrzymałą zbroję.";
		this.m.NameList = [
			"Pikowana Kolczuga",
			"Ropusza Skóra",
			"Ogrza Skóra",
			"Warstwowana Zbroja",
			"Wzmocniona Kolczuga"
		];
		this.m.PrefixList = [
			"Pikowana Kolczuga",
			"Ropusza Skóra",
			"Ogrza Skóra",
			"Warstwowana Zbroja",
			"Wzmocniona Kolczuga"
		];
		this.m.SuffixList = [];
		this.m.Variant = 46;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 4000;
		this.m.Condition = 140;
		this.m.ConditionMax = 140;
		this.m.StaminaModifier = -16;
		this.randomizeValues();
	}

});

