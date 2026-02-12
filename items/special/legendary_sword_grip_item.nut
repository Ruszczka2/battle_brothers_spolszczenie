this.legendary_sword_grip_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.legendary_sword_grip";
		this.m.Name = "Trzon Miecza";
		this.m.Description = "Mistrzowsko wykonany trzon miecza, pokryty tajemniczymi błękitnymi kamieniami. Wewnątrz kamieni jakby pobłyskiwało światło. Być może udało by się przekuć miecz, gdyś miał jego obie części.";
		this.m.Icon = "misc/inventory_sword_hilt_01.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Quest;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 2500;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

});

