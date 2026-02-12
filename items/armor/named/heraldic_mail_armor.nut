this.heraldic_mail_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.heraldic_mail";
		this.m.Description = "Ta prawdziwie godna rycerza kolcza hauberka została wykonana z materiałów najwyższej jakości i przyozdobiona kosztownymi dekoracjami i ornamentami.";
		this.m.NameList = [
			"Heraldyczna Kolczuga",
			"Splendor",
			"Okazałość",
			"Przepych",
			"Szpan",
			"Pełna Kolczuga",
			"Kolcza Hauberka",
			"Kolczuga",
			"Obowiązek",
			"Honor",
			"Kolczuga Szlachecka"
		];
		this.m.PrefixList = [
			"Heraldyczna Kolczuga",
			"Okazałość",
			"Pełna Kolczuga",
			"Kolcza Hauberka",
			"Kolczuga",
			"Kolczuga Szlachecka"
		];
		this.m.SuffixList = [
			"Splendor",
			"Przepych",
			"Szpan",
			"Obowiązek",
			"Honor"
		];
		this.m.Variant = 36;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 7000;
		this.m.Condition = 210;
		this.m.ConditionMax = 210;
		this.m.StaminaModifier = -26;
		this.randomizeValues();
	}

});

