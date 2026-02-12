this.ghoul_teeth_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.ghoul_teeth";
		this.m.Name = "Strzępiaste Kły";
		this.m.Description = "Garść strzępiastych kłów Nachzehrera. Zarażone zgnilizną, lecz wystarczająco twarde, by przegryźć się przez dowolną kość. Mogą być warte nieco monet u alchemików na targu.";
		this.m.Icon = "misc/inventory_ghoul_teeth_01.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 200;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
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

