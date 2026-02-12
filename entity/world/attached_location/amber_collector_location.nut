this.amber_collector_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "Zbieracz Bursztynu";
		this.m.ID = "attached_location.amber_collector";
		this.m.Description = "Zbieracze żyjący w tych chatach poszukują wzdłuż wybrzeża cennych kawałków bursztynu.";
		this.m.Sprite = "world_amber_collector_01";
		this.m.SpriteDestroyed = "world_amber_collector_01_ruins";
		this.m.IsConnected = false;
	}

	function onUpdateProduce( _list )
	{
		_list.push("trade/amber_shards_item");
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}

		_list.push("peddler_background");
		_list.push("caravan_hand_background");
		_list.push("thief_background");
	}

	function onUpdateShopList( _id, _list )
	{
		switch(_id)
		{
		case "building.marketplace":
			_list.push({
				R = 0,
				P = 1.0,
				S = "trade/amber_shards_item"
			});
			break;

		default:
			if (_id == "building.specialized_trader")
			{
			}
		}
	}

	function onInit()
	{
		this.attached_location.onInit();
		this.getSprite("body").Scale = 0.9;
	}

});

