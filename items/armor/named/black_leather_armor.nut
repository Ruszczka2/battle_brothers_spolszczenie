this.black_leather_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.black_leather";
		this.m.Description = "Dobrze wykonana i utwardzona skórzana zbroja, wzmocniona pikowaną przeszywanicą i kolczugą. Lekka, acz bardzo wytrzymała.";
		this.m.NameList = [
			"Skórzany Kirys",
			"Koszula Kolcza",
			"Zbroja Skórzana",
			"Skóra",
			"Obierka",
			"Strażnik",
			"Płaszcz",
			"Nocny Płaszcz",
			"Czerń",
			"Mroczny Omen"
		];
		this.m.PrefixList = [
			"Koszula Kolcza",
			"Zbroja Skórzana",
			"Skóra",
			"Obierka"
		];
		this.m.SuffixList = [
			"Skórzany Kirys",
			"Strażnik",
			"Płaszcz",
			"Nocny Płaszcz",
			"Mroczny Omen"
		];
		this.m.Variant = 42;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 2000;
		this.m.Condition = 115;
		this.m.ConditionMax = 115;
		this.m.StaminaModifier = -12;
		this.randomizeValues();
	}

});

