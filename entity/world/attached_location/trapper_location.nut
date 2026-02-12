this.trapper_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "Traper";
		this.m.ID = "attached_location.trapper";
		this.m.Description = "Małe chatki zapewniają schronienie dla żyjących tu traperów, zastawiających sidła na zwierzynę posiadającą cenne futra.";
		this.m.Sprite = "world_trapper_01";
		this.m.SpriteDestroyed = "world_trapper_01_ruins";
	}

	function onUpdateProduce( _list )
	{
		_list.push("trade/furs_item");
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}

		_list.push("peddler_background");
		_list.push("caravan_hand_background");
		_list.push("poacher_background");
	}

	function onUpdateShopList( _id, _list )
	{
		switch(_id)
		{
		case "building.marketplace":
			_list.push({
				R = 0,
				P = 1.0,
				S = "trade/furs_item"
			});
			_list.push({
				R = 50,
				P = 1.0,
				S = "weapons/hunting_bow"
			});
			break;

		default:
			if (_id == "building.specialized_trader")
			{
			}
		}
	}

});

