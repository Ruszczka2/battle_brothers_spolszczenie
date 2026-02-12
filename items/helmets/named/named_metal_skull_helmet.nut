this.named_metal_skull_helmet <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.named_metal_skull_helmet";
		this.m.Description = "Ciężki hełm, typowy dla północnych barbarzyńców, z przypominającą czaszkę zasłoną twarzy. Ten egzemplarz jest równie masywny, co imponujący.";
		this.m.NameList = [
			"Twarz Północy",
			"Żelazna Czaszka",
			"Zasłona",
			"Oblicze Klanów",
			"Maska",
			"Stalowy Welon",
			"Plemienne Oblicze",
			"Spojrzenie Grabieżcy"
		];
		this.m.PrefixList = [
			"Twarz Północy",
			"Żelazna Czaszka",
			"Zasłona",
			"Maska",
			"Stalowy Welon",
			"Plemienne Twarz"
		];
		this.m.SuffixList = [
			"Stalowy Welon"
		];
		this.m.UseRandomName = false;
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.HideCharacterHead = true;
		this.m.Variant = 232;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 5000;
		this.m.Condition = 210;
		this.m.ConditionMax = 210;
		this.m.StaminaModifier = -13;
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

