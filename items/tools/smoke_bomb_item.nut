this.smoke_bomb_item <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.smoke_bomb";
		this.m.Name = "Dymny Garnuszek";
		this.m.Description = "Mały garnek, który w błyskawiczny sposób wytwarza gęstą chmurę dymu, gdy roztrzaska się o ziemię. Użyteczny, ukryć własne ruchy.";
		this.m.IconLarge = "tools/smoke_bomb_01.png";
		this.m.Icon = "tools/smoke_bomb_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Tool;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_smoke_bomb_01";
		this.m.Value = 400;
		this.m.RangeMax = 3;
		this.m.StaminaModifier = 0;
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
		result.push({
			id = 64,
			type = "text",
			text = "Dzierżony w drugiej ręce"
		});
		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Zasięg [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.RangeMax + "[/color] pól"
		});
		result.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Pokrywa na jedną rundę [color=" + this.Const.UI.Color.DamageValue + "]7[/color] pól gęstym dymem, umożliwiając każdej postaci znajdującej się w chmurze na swobodny ruch i ignorowanie stref kontroli"
		});
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Ulega zniszczeniu po użyciu"
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/move_pot_clay_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill = this.new("scripts/skills/actives/throw_smoke_bomb_skill");
		skill.setItem(this);
		this.addSkill(skill);
	}

});

