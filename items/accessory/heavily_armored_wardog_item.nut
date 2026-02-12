this.heavily_armored_wardog_item <- this.inherit("scripts/items/accessory/wardog_item", {
	m = {},
	function create()
	{
		this.wardog_item.create();
		this.m.ID = "accessory.heavily_armored_wardog";
		this.m.Description = "Silny i wierny pies, wyhodowany na potrzeby wojenne. Można spuścić go ze smyczy w bitwie, aby dokonał zwiadu, wyśledził lub dogonił uciekających wrogów. Ma na sobie gruby skórzany pancerz dla lepszej ochrony";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = false;
		this.m.ArmorScript = "scripts/items/armor/special/wardog_heavy_armor";
		this.m.Value = 600;
	}

	function setEntity( _e )
	{
		this.m.Entity = _e;

		if (this.m.Entity != null)
		{
			this.m.Icon = "tools/dog_01_leash_70x70.png";
		}
		else
		{
			this.m.Icon = "tools/dog_01_0" + this.m.Variant + "_armor_02_70x70.png";
		}
	}

});

