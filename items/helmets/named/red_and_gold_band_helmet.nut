this.red_and_gold_band_helmet <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.red_and_gold_band_helmet";
		this.m.Description = "Ten hełm w południowym stylu jest nie tylko bogato zdobiony, ale też i dobrze zbalansowany oraz wykonany z metali najwyższej jakości.";
		this.m.NameList = [
			"Hełm Łubkowy",
			"Hełm Segmentowy",
			"Korona Króla Piasków",
			"Płomienista Czasza",
			"Korona Koczowników",
			"Pierzasty Hełm Łubkowy"
		];
		this.m.PrefixList = [
			"Korona Króla Piasków",
			"Płomienista Czasza",
			"Korona Koczowników"
		];
		this.m.SuffixList = [
			"Hełm Łubkowy",
			"Hełm Segmentowy",
			"Pierzasty Hełm Łubkowy"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.VariantString = "helmet_southern_named";
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 6000;
		this.m.Condition = 255;
		this.m.ConditionMax = 255;
		this.m.StaminaModifier = -17;
		this.m.Vision = -2;
		this.randomizeValues();
	}

});

