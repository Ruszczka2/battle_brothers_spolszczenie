this.adorned_full_helm <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.adorned_full_helm";
		this.m.Name = "Zdobiony Hełm Garnczkowy";
		this.m.Description = "Zamknięty metalowy hełm z otworami do oddychania. Przyozdobiony trofeami i z miłością pielęgnowany mimo swego intensywnego użycia, jest atrybutem prawdziwego, szlachetnego rycerza.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 239;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 3700;
		this.m.Condition = 300;
		this.m.ConditionMax = 300;
		this.m.StaminaModifier = -18;
		this.m.Vision = -3;
	}

});

