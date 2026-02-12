this.named_nordic_helmet_with_closed_mail <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.named_nordic_helmet_with_closed_mail";
		this.m.Description = "Ten nordycki hełm z osłoną twarzy został niesłychanie dobrze wykonany, zarówno gdy chodzi o walory ochronne, jak i imponujący wygląd.";
		this.m.NameList = [
			"Hełm Wikinga",
			"Sowi Hełm",
			"Dekorowany Nordycki Hełm",
			"Hełm Wodza",
			"Grawerowany Nordycki Hełm",
			"Nordycki Hełm Szlachecki"
		];
		this.m.PrefixList = [];
		this.m.SuffixList = [
			"Hełm Wikinga",
			"Sowi Hełm",
			"Dekorowany Nordycki Hełm",
			"Hełm Wodza",
			"Grawerowany Nordycki Hełm",
			"Nordycki Hełm Szlachecki"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 206;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 7500;
		this.m.Condition = 265;
		this.m.ConditionMax = 265;
		this.m.StaminaModifier = -18;
		this.m.Vision = -2;
		this.randomizeValues();
	}

});

