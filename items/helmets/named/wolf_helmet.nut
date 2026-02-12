this.wolf_helmet <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.wolf";
		this.m.Description = "Solidny metalowy hełm z dołączoną osłoną kolczą, ukryty pod imponującą wilczą głową.";
		this.m.NameList = [
			"Czapka Bestii",
			"Hełm Wilka",
			"Kaptur Berserkera",
			"Kaptur Bestii",
			"Wilcza Korona",
			"Korona Drapieżnika"
		];
		this.m.PrefixList = [
			"Czapka Bestii",
			"Wilcza Korona",
			"Korona Drapieżnika"
		];
		this.m.SuffixList = [
			"Hełm Wilka",
			"Kaptur Berserkera",
			"Kaptur Bestii"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.Variant = 48;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 2000;
		this.m.Condition = 140;
		this.m.ConditionMax = 140;
		this.m.StaminaModifier = -8;
		this.randomizeValues();
	}

});

