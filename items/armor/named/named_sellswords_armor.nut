this.named_sellswords_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.named_sellswords_armor";
		this.m.Description = "Ta warstwowana zbroja należała kiedyś do sławnego najemnika. jej duża wytrzymałość i elastyczność sprawia, że jest to niebywały egzemplarz rzemiosła. A do tego ma dodatkowe kieszenie!";
		this.m.NameList = [
			"Płaszcz Najemnika",
			"Skóra Najemnika",
			"Warstwowana Zbroja",
			"Płytowany Płaszcz"
		];
		this.m.PrefixList = [
			"Skóra Najemnika",
			"Warstwowana Zbroja"
		];
		this.m.SuffixList = [
			"Płaszcz Najemnika",
			"Płytowany Płaszcz"
		];
		this.m.Variant = 101;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 10000;
		this.m.Condition = 260;
		this.m.ConditionMax = 260;
		this.m.StaminaModifier = -32;
		this.randomizeValues();
	}

});

