this.green_coat_of_plates_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.green_coat_of_plates";
		this.m.Description = "Rzadki płaszcz płytowy wzmocniony kolczugą i dodatkową wyściółką. Kawał porządnej rzemieślniczej sztuki!";
		this.m.NameList = [
			"Płaszcz Płytowy",
			"Ostoja",
			"Skorupa",
			"Kadłub",
			"Kirys Płytowy",
			"Płytowy Płaszcz",
			"Kamizelka",
			"Azyl"
		];
		this.m.PrefixList = [
			"Ostoja",
			"Skorupa",
			"Kamizelka"
		];
		this.m.SuffixList = [
			"Płaszcz Płytowy",
			"Kadłub",
			"Kirys Płytowy",
			"Płytowy Płaszcz",
			"Azyl"
		];
		this.m.Variant = 43;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 15000;
		this.m.Condition = 320;
		this.m.ConditionMax = 320;
		this.m.StaminaModifier = -42;
		this.randomizeValues();
	}

});

