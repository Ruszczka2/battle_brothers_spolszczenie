this.golden_scale_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.golden_scale";
		this.m.Description = "Zbroja łuskowa z małych, nachodzących na siebie metalowych łusek. Styl i jakość wykonania zdradzają, ze zbroja ta pochodzi z bardzo odległego regionu.";
		this.m.NameList = [
			"Koszula Łuskowa",
			"Zbroja Łuskowa",
			"Smocza Skóra",
			"Wężowa Skóra",
			"Łuski",
			"Gadzia Skóra",
			"Złota Skóra",
			"Tunika Łuskowa",
			"Złota Zbroja",
			"Złota Scheda"
		];
		this.m.PrefixList = [
			"Koszula Łuskowa",
			"Zbroja Łuskowa",
			"Smocza Skóra",
			"Wężowa Skóra",
			"Łuska",
			"Gadzia Skóra",
			"Złota Skóra",
			"Tunika Łuskowa",
			"Złota Zbroja",
			"Złota Scheda"
		];
		this.m.SuffixList = [];
		this.m.Variant = 44;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 8000;
		this.m.Condition = 240;
		this.m.ConditionMax = 240;
		this.m.StaminaModifier = -28;
		this.randomizeValues();
	}

});

