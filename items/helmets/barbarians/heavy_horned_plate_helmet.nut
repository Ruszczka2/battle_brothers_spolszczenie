this.heavy_horned_plate_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.heavy_horned_plate_helmet";
		this.m.Name = "Ciężki Hełm Płytowy z Rogami";
		this.m.Description = "Ten ciężki hełm został przyozdobiony pokaźnymi rogami. Symbolizują one wysoką pozycję i reputację wśród barbarzyńskich watah.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.HideCharacterHead = true;
		local variants = [
			194
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 1300;
		this.m.Condition = 250;
		this.m.ConditionMax = 250;
		this.m.StaminaModifier = -23;
		this.m.Vision = -3;
	}

});

