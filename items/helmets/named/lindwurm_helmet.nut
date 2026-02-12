this.lindwurm_helmet <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.lindwurm_helmet";
		this.m.Description = "Ten hełm musiał niegdyś należeć do śmiałego i wprawnego łowcy, gdyż pokrywają go łuski potwornego Lindwurma. łuski nie tylko odbijają ciosy, ale też i pozostają nietknięte przez żrącą krew Lindwurma.";
		this.m.NameList = [
			"Łeb Lindwurma",
			"Jaszczurzy Hełm",
			"Czasza Smoka",
			"Majdan Lindwurma",
			"Hełm z Gadzich Łusek",
			"Maska Lindwurma"
		];
		this.m.PrefixList = [
			"Głowa Lindwurma",
			"Czasza Smoka",
			"Maska Lindwurma"
		];
		this.m.SuffixList = [
			"Łeb Lindwurma",
			"Jaszczurzy Hełm",
			"Majdan Lindwurma",
			"Hełm z Gadzich Łusek"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 152;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 7500;
		this.m.Condition = 265;
		this.m.ConditionMax = 265;
		this.m.StaminaModifier = -18;
		this.m.Vision = -2;
		this.randomizeValues();
	}

	function getTooltip()
	{
		local result = this.helmet.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Niewrażliwy na żrącą krew Lindwurma"
		});
		return result;
	}

	function onEquip()
	{
		this.named_helmet.onEquip();
		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			this.m.Container.getActor().getFlags().add("head_immune_to_acid");
		}
	}

	function onUnequip()
	{
		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			this.m.Container.getActor().getFlags().remove("head_immune_to_acid");
		}

		this.helmet.onUnequip();
	}

});

