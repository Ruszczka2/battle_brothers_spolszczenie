this.black_book_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.black_book";
		this.m.Name = "Czarna Księga";
		this.m.Description = "Stary i dziwacznie wyglądający tom. Jego stronice przepełnione są nieodgadnionym pismem i tajemniczymi rysunkami, których nie sposób zrozumieć. Im dłużej patrzysz na księgę, tym większy czujesz niepokój. Być może ktoś z większą wiedzą i bardziej obeznany w starożytnych językach coś z tego pojmie.";
		this.m.Icon = "misc/inventory_necronomicon.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Quest;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 1000;
	}

});

