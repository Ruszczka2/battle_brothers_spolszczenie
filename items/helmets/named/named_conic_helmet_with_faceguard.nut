this.named_conic_helmet_with_faceguard <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.named_conic_helmet_with_faceguard";
		this.m.Description = "Ten stożkowy hełm ma przymocowaną zasłonę na twarz i doskonale dopasowane łuski, chroniące kark. Zasłona przypomina przerażającego wojownika, który zaraz uderzy na wrogów.";
		this.m.NameList = [
			"Pierzasty Hełm Stożkowy",
			"Żelazna Maska",
			"Hełm Wodza",
			"Żelazne Oblicze",
			"Stalowy Grymas"
		];
		this.m.PrefixList = [
			"Żelazna Maska",
			"Żelazna Twarz"
		];
		this.m.SuffixList = [
			"Pierzasty Hełm Stożkowy",
			"Hełm Wodza",
			"Stalowy Grymas"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 205;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 8000;
		this.m.Condition = 280;
		this.m.ConditionMax = 280;
		this.m.StaminaModifier = -19;
		this.m.Vision = -3;
		this.randomizeValues();
	}

});

