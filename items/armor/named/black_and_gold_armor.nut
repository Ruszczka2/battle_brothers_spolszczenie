this.black_and_gold_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.black_and_gold";
		this.m.Description = "Starożytna wiedza została użyta podczas wykuwania tego niezwykłego pancerza. Jego lekka kolczuga pokryta złotymi łubkami zapewnia wysoką ochronę przy rozsądnym obciążeniu.";
		this.m.NameList = [
			"Lśniący Majdan Złotnika",
			"Skóra Złotnika",
			"Słoneczny Płaszcz",
			"Gorejąca Kolczuga",
			"Słoneczna Kamizelka",
			"Lśniąca Hauberka",
			"Zbroja Króla Skorpiona"
		];
		this.m.PrefixList = [
			"Skóra Złotnika",
			"Gorejąca Kolczuga",
			"Słoneczna Kamizelka",
			"Lśniąca Hauberka",
			"Zbroja Króla Skorpiona"
		];
		this.m.SuffixList = [
			"Lśniący Majdan Złotnika",
			"Słoneczny Płaszcz"
		];
		this.m.VariantString = "body_southern_named";
		this.m.Variant = 2;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 9000;
		this.m.Condition = 210;
		this.m.ConditionMax = 210;
		this.m.StaminaModifier = -25;
		this.randomizeValues();
	}

});

