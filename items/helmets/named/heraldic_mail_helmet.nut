this.heraldic_mail_helmet <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.heraldic_mail";
		this.m.Description = "Ciężki basinet z ruchomą zasłoną, noszony na kapturze kolczym. Okazały egzemplarz godny prawdziwego rycerza.";
		this.m.NameList = [
			"Basinet Kolczy",
			"Rycerski Basinet",
			"Heraldyczny Basinet",
			"Basinet z Zasłoną",
			"Heraldyczny Hełm",
			"Rycerski Hełm"
		];
		this.m.PrefixList = [];
		this.m.SuffixList = [
			"Basinet Kolczy",
			"Rycerski Basinet",
			"Heraldyczny Basinet",
			"Basinet z Zasłoną",
			"Heraldyczny Hełm",
			"Rycerski Hełm"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.Variant = 53;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 8000;
		this.m.Condition = 280;
		this.m.ConditionMax = 280;
		this.m.StaminaModifier = -19;
		this.m.Vision = -2;
		this.randomizeValues();
	}

});

