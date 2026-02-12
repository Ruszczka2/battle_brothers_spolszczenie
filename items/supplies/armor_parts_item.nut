this.armor_parts_item <- this.inherit("scripts/items/item", {
	m = {
		Amount = 0
	},
	function isAmountShown()
	{
		return true;
	}

	function getAmountString()
	{
		return this.m.Amount;
	}

	function getAmount()
	{
		return this.m.Amount;
	}

	function setAmount( _a )
	{
		this.m.Amount = this.Math.floor(_a);
	}

	function create()
	{
		this.item.create();
		this.m.ID = "supplies.armor_parts";
		this.m.Name = "Narzędzia i Zapasy";
		this.m.Icon = "supplies/armor_parts.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Supply;
		this.m.IsConsumed = true;
		this.m.Value = 200;
		this.m.Amount = 20;
	}

	function getValue()
	{
		return this.Math.floor(this.m.Amount / 20.0 * this.m.Value);
	}

	function getBuyPrice()
	{
		if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null)
		{
			local t = this.World.State.getCurrentTown();
			local isBuildingPresent = t.hasAttachedLocation("attached_location.workshop") || t.hasAttachedLocation("attached_location.leather_tanner") || t.hasBuilding("building.armorsmith") || t.hasBuilding("building.armorsmith_oriental") || t.hasBuilding("building.weaponsmith") || t.hasBuilding("building.weaponsmith_oriental");
			return this.Math.max(this.getSellPrice(), this.Math.ceil(this.getValue() * this.getPriceMult() * this.Const.Difficulty.BuyPriceMult[this.World.Assets.getEconomicDifficulty()] * this.World.State.getCurrentTown().getBuyPriceMult() * (isBuildingPresent ? 1.0 : 1.5)));
		}

		return this.item.getBuyPrice();
	}

	function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = "Dobre [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.Amount + "[/color] sztuk różnorakich narzędzi i zapasów, służących do naprawy broni, zbroi, hełmów i tarcz po bitwie. Zostaną dodane do twego globalnego zapasu narzędzi, gdy wrócisz na mapę świata."
			}
		];

		if (this.getIconLarge() != null)
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIconLarge(),
				isLarge = true
			});
		}
		else
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIcon()
			});
		}

		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

	function consume()
	{
		this.World.Assets.addArmorParts(this.m.Amount);
	}

});

