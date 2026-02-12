this.large_quiver_of_bolts <- this.inherit("scripts/items/ammo/ammo", {
	m = {},
	function create()
	{
		this.ammo.create();
		this.m.ID = "ammo.bolts";
		this.m.Name = "Duży Kołczan Bełtów";
		this.m.Description = "Duży kołczan pełen bełtów, wymaganych, aby móc używać kusz. Zostaje automatycznie uzupełniony po każdej bitwie, jeżeli masz wystarczającą ilość amunicji.";
		this.m.Icon = "ammo/quiver_04.png";
		this.m.IconEmpty = "ammo/quiver_04_empty.png";
		this.m.SlotType = this.Const.ItemSlot.Ammo;
		this.m.ItemType = this.Const.Items.ItemType.Ammo;
		this.m.AmmoType = this.Const.Items.AmmoType.Bolts;
		this.m.ShowOnCharacter = true;
		this.m.ShowQuiver = true;
		this.m.Sprite = "bust_quiver_01";
		this.m.Value = 400;
		this.m.Ammo = 14;
		this.m.AmmoMax = 14;
		this.m.IsDroppedAsLoot = true;
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
				text = this.getDescription()
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

		if (this.m.Ammo != 0)
		{
			result.push({
				id = 6,
				type = "text",
				icon = "ui/icons/ammo.png",
				text = "Zawiera [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.Ammo + "[/color] bełtów"
			});
		}
		else
		{
			result.push({
				id = 6,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Jest pusty i bezużyteczny[/color]"
			});
		}

		return result;
	}

});

