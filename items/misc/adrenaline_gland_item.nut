this.adrenaline_gland_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.adrenaline_gland";
		this.m.Name = "Gruczoł Adrenaliny";
		this.m.Description = "Szał i żądzę krwi Wilkorów można przypisać substancjom produkowanym przez ten gruczoł. Ktoś gdzieś zapewne znajdzie dla tego użytek.";
		this.m.Icon = "misc/inventory_wolf_adrenaline.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 400;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/cleave_hit_hitpoints_01.wav", this.Const.Sound.Volume.Inventory);
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

