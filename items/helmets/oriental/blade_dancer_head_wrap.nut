this.blade_dancer_head_wrap <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.blade_dancer_head_wrap";
		this.m.Name = "Chusta Tancerza Ostrzy";
		this.m.Description = "Te rzucająca się w oczy czerwono-czarna chusta jest tradycyjnie noszona przez najbardziej uzdolnionych wojowników plemion koczowniczych.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.ReplaceSprite = true;
		this.m.VariantString = "helmet_southern";
		this.m.Variant = 23;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 150;
		this.m.Condition = 60;
		this.m.ConditionMax = 60;
		this.m.StaminaModifier = -1;
	}

});

