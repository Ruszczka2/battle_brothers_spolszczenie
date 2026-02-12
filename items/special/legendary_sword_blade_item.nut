this.legendary_sword_blade_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.legendary_sword_blade";
		this.m.Name = "Ostrze Miecza";
		this.m.Description = "Połyskujące ostrze złamanego miecza, które udało ci się odzyskać po starciu z Krakenem. Przez wszystkie te lata pełne walki, nigdy nie dane ci było widzieć tak mistrzowsko wykonanej klingi. Być może udało by się przekuć miecz, gdyś miał jego obie części.";
		this.m.Icon = "misc/inventory_sword_blade_01.png";
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

