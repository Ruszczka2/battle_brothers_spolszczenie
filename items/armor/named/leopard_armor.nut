this.leopard_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.leopard_armor";
		this.m.Description = "Ciężka lamelkowa kamizelka połączona z drobną kolczugą i wygodną wyściółką. Prawdziwe dzieło sztuki, które aż żal nieść na pole bitwy.";
		this.m.NameList = [
			"Uścisk Złotnika",
			"Ochrona Złotnika",
			"Migocząca Lamelka",
			"Kamizelka Wezyra",
			"Skorupa Pustyni",
			"Zbroja Mistrza Łowczego"
		];
		this.m.PrefixList = [
			"Ochrona Złotnika",
			"Migocząca Lamelka",
			"Kamizelka Wezyra",
			"Skorupa Pustyni",
			"Zbroja Mistrza Łowczego"
		];
		this.m.SuffixList = [
			"Uścisk Złotnika"
		];
		this.m.PrefixList = [];
		this.m.SuffixList = [];
		this.m.VariantString = "body_southern_named";
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 15000;
		this.m.Condition = 290;
		this.m.ConditionMax = 290;
		this.m.StaminaModifier = -35;
		this.randomizeValues();
	}

});

