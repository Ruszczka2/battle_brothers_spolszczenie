this.sallet_green_helmet <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.sallet_green";
		this.m.Description = "Mistrzowsko wykonana salada, wzmocniona kapturem kolczym i zwieńczona kolorowymi wstążkami.";
		this.m.NameList = [
			"Zdobiona Salada",
			"Salada Kolcza",
			"Otwarta Salada",
			"Wstążkowa Salada"
		];
		this.m.PrefixList = [
			"Zdobiona Salada",
			"Salada Kolcza",
			"Otwarta Salada",
			"Wstążkowa Salada"
		];
		this.m.SuffixList = [];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.Variant = 49;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 7000;
		this.m.Condition = 265;
		this.m.ConditionMax = 265;
		this.m.StaminaModifier = -18;
		this.m.Vision = -1;
		this.randomizeValues();
	}

});

