this.named_plated_fur_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.named_plated_fur_armor";
		this.m.Description = "Prosta zbroja z futer i skór, z dodatkową grubą warstwą metalowych płyt przynitowanych na wierzchu. Prosta i ciężka konstrukcja, lecz skuteczna w walce.";
		this.m.NameList = [
			"Płytowana Futrzana Zbroja",
			"Płytowa Kamizelka",
			"Płytowana Skóra",
			"Nitowane Futro"
		];
		this.m.PrefixList = [
			"Płytowana Futrzana Zbroja",
			"Płytowa Kamizelka",
			"Płytowana Skóra"
		];
		this.m.SuffixList = [];
		this.m.UseRandomName = false;
		this.m.Variant = 104;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 4000;
		this.m.Condition = 130;
		this.m.ConditionMax = 130;
		this.m.StaminaModifier = -14;
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

