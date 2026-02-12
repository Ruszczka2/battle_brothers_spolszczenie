this.brown_coat_of_plates_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.brown_coat_of_plates";
		this.m.Description = "Gruba kolcza hauberka połączona z solidnymi metalowymi płytami. Ta zbroja ochroni swego właściciela nawet w najzacieklejszych bitwach.";
		this.m.NameList = [
			"Kamizelka",
			"Majdan",
			"Obrona",
			"Bariera",
			"Zbroja Płytowa",
			"Kamizelka Płytowa",
			"Ocalacz"
		];
		this.m.PrefixList = [
			"Kamizelka",
			"Obrona",
			"Bariera",
			"Zbroja Płytowa",
			"Kamizelka Płytowa"
		];
		this.m.SuffixList = [
			"Majdan",
			"Ocalacz"
		];
		this.m.Variant = 45;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 14000;
		this.m.Condition = 300;
		this.m.ConditionMax = 300;
		this.m.StaminaModifier = -36;
		this.randomizeValues();
	}

});

