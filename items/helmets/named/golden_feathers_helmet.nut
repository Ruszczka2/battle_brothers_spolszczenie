this.golden_feathers_helmet <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.golden_feathers";
		this.m.Description = "Hełm w zagranicznym wzorze, wykonany z solidnego stopu i połączony z pełnym kapturem kolczym dla doskonałej ochrony.";
		this.m.NameList = [
			"Hełm",
			"Złoty Hełm Stożkowy",
			"Opierzony Hełm",
			"Migoczący Hełm",
			"Hełm z Kapturem"
		];
		this.m.PrefixList = [];
		this.m.SuffixList = [
			"Hełm",
			"Złoty Hełm Stożkowy",
			"Opierzony Hełm",
			"Migoczący Hełm",
			"Hełm z Kapturem"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 50;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 6000;
		this.m.Condition = 240;
		this.m.ConditionMax = 240;
		this.m.StaminaModifier = -16;
		this.m.Vision = -3;
		this.randomizeValues();
	}

});

