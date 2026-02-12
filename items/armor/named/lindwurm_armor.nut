this.lindwurm_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.lindwurm_armor";
		this.m.Description = "Twarde łuski zajadłego Lindwurma przyszyto na ciężką kolczugę. Zbroja nie tylko stanowi trofeum dla wielkiego łowcy bestii, ale też jest zdolna odpierać najzacieklejsze ataki, a lśniące łuski pozostaną nietknięte przez żrącą krew Lindwurma.";
		this.m.NameList = [
			"Łuski Lindwurma",
			"Smocza Skóra",
			"Gadzi Płaszcz",
			"Kamizelka Lindwurma",
			"Płaszcz Lindwurma",
			"Gadzie Łuski",
			"Lindwurmi Płaszcz"
		];
		this.m.PrefixList = [
			"Łuska Lindwurma",
			"Smocza Skóra",
			"Kamizelka Lindwurma",
			"Gadzia Łuska"
		];
		this.m.SuffixList = [
			"Gadzi Płaszcz",
			"Płaszcz Lindwurma",
			"Lindwurmi Płaszcz"
		];
		this.m.Variant = 113;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 7500;
		this.m.Condition = 210;
		this.m.ConditionMax = 210;
		this.m.StaminaModifier = -26;
		this.randomizeValues();
	}

	function getTooltip()
	{
		local result = this.armor.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Niewrażliwa na żrącą krew Lindwurma"
		});
		return result;
	}

	function onEquip()
	{
		this.named_armor.onEquip();
		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			this.m.Container.getActor().getFlags().add("body_immune_to_acid");
		}
	}

	function onUnequip()
	{
		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			this.m.Container.getActor().getFlags().remove("body_immune_to_acid");
		}

		this.armor.onUnequip();
	}

});

