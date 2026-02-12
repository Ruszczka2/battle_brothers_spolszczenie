this.vampire_dust_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.vampire_dust";
		this.m.Name = "Migoczące Prochy";
		this.m.Description = "Mała kupka prochów, połyskująca różnymi odcieniami błękitu. Rzekomo są to pozostałości po potężnej nieumarłej istocie, choć niewielu ludzi uwierzy w takie stwierdzenie.";
		this.m.Icon = "misc/inventory_vampire_dust_01.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 1000;
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

