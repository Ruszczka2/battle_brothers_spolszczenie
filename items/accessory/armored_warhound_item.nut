this.armored_warhound_item <- this.inherit("scripts/items/accessory/warhound_item", {
	m = {},
	function create()
	{
		this.warhound_item.create();
		this.m.ID = "accessory.armored_warhound";
		this.m.Description = "Silny i wierny północny ogar, wyhodowany na potrzeby wojenne. Można spuścić go ze smyczy w bitwie, aby dokonał zwiadu, wyśledził lub dogonił uciekających wrogów. Ma na sobie skórzany pancerz, chroniący go przed obrażeniami ciętymi.";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = false;
		this.m.ArmorScript = "scripts/items/armor/special/wardog_armor";
		this.m.Value = 450;
	}

	function setEntity( _e )
	{
		this.m.Entity = _e;

		if (this.m.Entity != null)
		{
			this.m.Icon = "tools/hound_01_leash_70x70.png";
		}
		else
		{
			this.m.Icon = "tools/hound_0" + this.m.Variant + "_armor_01_70x70.png";
		}
	}

});

