this.gold_and_black_turban <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.gold_and_black_turban";
		this.m.Description = "Ten hełm w południowym stylu jest nie tylko bogato zdobiony, ale też i dobrze zbalansowany oraz wykonany z materiałów najwyższej jakości.";
		this.m.NameList = [
			"Korona Południa",
			"Pustynny Czub",
			"Turban Słońca",
			"Złoty Czub",
			"Duma Wezyra",
			"Hełm Króla Piasków",
			"Hełm Skorpiona",
			"Welon Słońca",
			"Duma Złotnika",
			"Oblicze Złotnika"
		];
		this.m.PrefixList = [
			"Korona Południa",
			"Duma Wezyra",
			"Duma Złotnika",
			"Twarz Złotnika"
		];
		this.m.SuffixList = [
			"Pustynny Czub",
			"Turban Słońca",
			"Złoty Czub",
			"Hełm Króla Piasków",
			"Hełm Skorpiona",
			"Welon Słońca"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.VariantString = "helmet_southern_named";
		this.m.Variant = 2;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 6000;
		this.m.Condition = 290;
		this.m.ConditionMax = 290;
		this.m.StaminaModifier = -20;
		this.m.Vision = -3;
		this.randomizeValues();
	}

});

