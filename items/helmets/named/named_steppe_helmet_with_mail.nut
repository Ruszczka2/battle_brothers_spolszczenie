this.named_steppe_helmet_with_mail <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.named_steppe_helmet_with_mail";
		this.m.Description = "Mistrzowsko wykonany hełm w stylu ludów koczowniczych. Zdobiony złotymi dodatkami i wyposażony w dodatkowe osłony na policzki.";
		this.m.NameList = [
			"Hełm Stepowy",
			"Dekorowany Hełm z Nosalem",
			"Ozdobny Hełm",
			"Hełm z Końskim Ogonem"
		];
		this.m.PrefixList = [];
		this.m.SuffixList = [
			"Hełm Stepowy",
			"Dekorowany Hełm z Nosalem",
			"Ozdobny Hełm",
			"Hełm z Końskim Ogonem"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.Variant = 204;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 5000;
		this.m.Condition = 200;
		this.m.ConditionMax = 200;
		this.m.StaminaModifier = -12;
		this.m.Vision = -2;
		this.randomizeValues();
	}

});

