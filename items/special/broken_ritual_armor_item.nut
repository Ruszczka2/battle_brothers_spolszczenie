this.broken_ritual_armor_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.broken_ritual_armor";
		this.m.Name = "Zniszczona Rytualna Zbroja";
		this.m.Description = "Zniszczone pozostałości ciężkiej zbroi barbarzyńskiej, pokrytej rytualnymi runami. W tym stanie jest bezużyteczna, choć czujesz, że jest w niej coś wyjątkowego. Może da się ją jakoś naprawić?";
		this.m.Icon = "misc/inventory_champion_armor_quest.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Quest;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 1000;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_halfplate_impact_01.wav", this.Const.Sound.Volume.Inventory);
	}

});

