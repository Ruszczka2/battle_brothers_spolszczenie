this.daze_bomb_item <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.daze_bomb";
		this.m.Name = "Oślepiający Garnuszek";
		this.m.Description = "Gliniany garnuszek wypełniony zagadkowymi prochami, które reagują gwałtownie podczas uderzenia i tworzą jasny błysk oraz potężny huk. Ogłuszą każdego w pobliżu.";
		this.m.IconLarge = "tools/daze_bomb_01.png";
		this.m.Icon = "tools/daze_bomb_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Tool;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_daze_bomb_01";
		this.m.Value = 500;
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
			text = "Jest w stanie Ogłuszyć do [color=" + this.Const.UI.Color.DamageValue + "]7[/color] celów na czas 2 tur"
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
		local skill = this.new("scripts/skills/actives/throw_daze_bomb_skill");
		skill.setItem(this);
		this.addSkill(skill);
	}

});

