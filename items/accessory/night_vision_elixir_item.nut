this.night_vision_elixir_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "accessory.night_vision_elixir";
		this.m.Name = "Eliksir Sowy";
		this.m.Description = "Ten eliksir, gdy się go spożyje, rozjaśnia noc, jakby była ona środkiem słonecznego dzionka. Pij rozważnie. Działa na czas kolejnej bitwy.";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_03.png";
		this.m.Value = 350;
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
		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});

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
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Mrok nocy nie wpływa na postać"
		});
		result.push({
			id = 65,
			type = "text",
			text = "Kliknij prawym przyciskiem myszy lub przeciągnij na obecnie wybraną postać, aby wypić. Przedmiot zostanie zużyty po wykorzystaniu."
		});
		result.push({
			id = 65,
			type = "hint",
			icon = "ui/tooltips/warning.png",
			text = "Nadużywanie może powodować mdłości"
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		this.Sound.play("sounds/combat/drink_0" + this.Math.rand(1, 3) + ".wav", this.Const.Sound.Volume.Inventory);
		_actor.getSkills().add(this.new("scripts/skills/effects/night_vision_effect"));
		this.Const.Tactical.Common.checkDrugEffect(_actor);
		return true;
	}

});

