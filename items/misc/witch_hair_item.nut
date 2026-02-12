this.witch_hair_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.witch_hair";
		this.m.Name = "Włosy Wiedźmy";
		this.m.Description = "Długie i kruche kosmyki szarych włosów pozyskanych z wiedźmy. Ich włosy mają ponoć potężne właściwości przy tworzeniu mikstur i eliksirów. Aczkolwiek mówi się też, że wiedźmy trzymają genitalia swoich ofiar jako swe maskotki, zatem informacje zdobyte od chłopstwa mogą być niezbyt wiarygodne.";
		this.m.Icon = "misc/inventory_hexe_hair.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 2000;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/cloth_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function getSellPriceMult()
	{
		return this.World.State.getCurrentTown().getBeastPartsPriceMult();
	}

	function getBuyPriceMult()
	{
		return this.World.State.getCurrentTown().getBeastPartsPriceMult();
	}

});

