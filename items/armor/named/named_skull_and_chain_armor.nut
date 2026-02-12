this.named_skull_and_chain_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.named_skull_and_chain_armor";
		this.m.Description = "Barbarzyńska zbroja prymitywnego wykonania, która została dostosowana, by dobrze chronić i nie być zbyt uciążliwa. Ma na sobie typowe znaki północnych barbarzyńskich plemion.";
		this.m.NameList = [
			"Plemienna Skóra",
			"Płaszcz Barbarzyńcy",
			"Złupiona Zbroja",
			"Skóra Barbarzyńcy",
			"Prymitywna Kamizelka"
		];
		this.m.PrefixList = [
			"Plemienna Skóra",
			"Złupiona Zbroja",
			"Skóra Barbarzyńcy",
			"Prymitywna Kamizelka"
		];
		this.m.SuffixList = [
			"Płaszcz Barbarzyńcy"
		];
		this.m.UseRandomName = false;
		this.m.Variant = 102;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 5500;
		this.m.Condition = 190;
		this.m.ConditionMax = 190;
		this.m.StaminaModifier = -24;
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

