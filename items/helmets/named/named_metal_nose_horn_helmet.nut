this.named_metal_nose_horn_helmet <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.named_metal_nose_horn_helmet";
		this.m.Description = "Ten hełm musiał należeć do wybitnego wojownika barbarzyńców. Jego rozmiar i kształt wydają się zupełnie obce dla wszystkich południowców.";
		this.m.NameList = [
			"Zamknięty Hełm",
			"Szpiczasty Hełm",
			"Ostry Hełm",
			"Masywna Maska",
			"Hełm Bojownika"
		];
		this.m.PrefixList = [
			"Masywna Maska"
		];
		this.m.SuffixList = [
			"Zamknięty Hełm",
			"Szpiczasty Hełm",
			"Ostry Hełm",
			"Hełm Bojownika"
		];
		this.m.UseRandomName = false;
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.HideCharacterHead = true;
		this.m.Variant = 234;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 5000;
		this.m.Condition = 230;
		this.m.ConditionMax = 230;
		this.m.StaminaModifier = -15;
		this.m.Vision = -2;
		this.randomizeValues();
	}

	function createRandomName()
	{
		if ((!this.m.UseRandomName || this.Math.rand(1, 100) <= 60) && this.m.PrefixList.len() + this.m.SuffixList.len() > 0)
		{
			if (this.Math.rand(1, this.Const.Strings.BarbarianSuffix.len() + this.Const.Strings.BarbarianPrefix.len()) <= this.Const.Strings.BarbarianPrefix.len())
			{
				if (this.Math.rand(1, this.m.PrefixList.len() + this.m.SuffixList.len()) <= this.m.PrefixList.len())
				{
					return this.Const.Strings.BarbarianPrefix[this.Math.rand(0, this.Const.Strings.BarbarianPrefix.len() - 1)] + " " + this.m.PrefixList[this.Math.rand(0, this.m.PrefixList.len() - 1)];
				}
				else
				{
					return this.Const.Strings.BarbarianPrefixMale[this.Math.rand(0, this.Const.Strings.BarbarianPrefixMale.len() - 1)] + " " + this.m.SuffixList[this.Math.rand(0, this.m.SuffixList.len() - 1)];
				}
			}
			else
			{
				return this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)] + " " + this.Const.Strings.BarbarianSuffix[this.Math.rand(0, this.Const.Strings.BarbarianSuffix.len() - 1)];
			}
		}
		else if (this.Math.rand(1, 2) == 1)
		{
			return this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)] + " " + this.getRandomCharacterName(this.Const.Strings.KnightNames) + "a";
		}
		else
		{
			return this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)] + " " + this.getRandomCharacterName(this.Const.Strings.BanditLeaderNamesGenitive);
		}
	}

});

