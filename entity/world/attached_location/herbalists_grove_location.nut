this.herbalists_grove_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "Gaj Zielarza";
		this.m.ID = "attached_location.herbalists_grove";
		this.m.Description = "W tym niewielkim gaju znający się na rzeczy zielarz zbiera różnego rodzaju medyczne rośliny i korzenie.";
		this.m.Sprite = "world_herbalists_grove_01";
		this.m.SpriteDestroyed = "world_herbalists_grove_01_ruins";
		this.m.IsConnected = false;
	}

	function onUpdateProduce( _list )
	{
		_list.push("supplies/medicine_item");
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}

		_list.push("monk_background");
		_list.push("flagellant_background");
		_list.push("anatomist_background");
	}

	function onUpdateShopList( _id, _list )
	{
		switch(_id)
		{
		case "building.marketplace":
			_list.push({
				R = 0,
				P = 1.0,
				S = "supplies/medicine_item"
			});
			_list.push({
				R = 0,
				P = 1.0,
				S = "accessory/bandage_item"
			});
			_list.push({
				R = 50,
				P = 1.0,
				S = "accessory/antidote_item"
			});
			break;

		default:
			switch(_id)
			{
			case "building.specialized_trader":
				break;

			default:
				switch(_id)
				{
				case "building.weaponsmith":
					break;

				default:
					if (_id == "building.armorsmith")
					{
					}
				}
			}
		}
	}

});

