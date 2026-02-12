this.beekeeper_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "Pszczelarz";
		this.m.ID = "attached_location.beekeeper";
		this.m.Description = "Otoczone przez bzyczące pszczoły, te małe chatki są domem dla pszczelarzy. Produkowany przez nich miód jest cennym składnikiem do słodzenia ciastek i innej żywności.";
		this.m.Sprite = "world_bee_keeper_01";
		this.m.SpriteDestroyed = "world_bee_keeper_01_ruins";
	}

	function getSounds( _all = true )
	{
		local r = [];

		if (this.World.getTime().IsDaytime)
		{
			r = [
				{
					File = "ambience/settlement/bee_keeper_00.wav",
					Volume = 1.1,
					Pitch = 1.0
				}
			];

			foreach( s in r )
			{
				s.Volume *= this.Const.Sound.Volume.Ambience / this.Const.Sound.Volume.AmbienceOutsideSettlement;
			}
		}

		return r;
	}

	function onUpdateProduce( _list )
	{
		_list.push("supplies/mead_item");
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}

		_list.push("farmhand_background");
		_list.push("farmhand_background");
	}

	function onUpdateShopList( _id, _list )
	{
		if (_id == "building.marketplace")
		{
			_list.push({
				R = 0,
				P = 1.0,
				S = "supplies/mead_item"
			});
			_list.push({
				R = 30,
				P = 1.0,
				S = "helmets/cultist_hood"
			});
			_list.push({
				R = 20,
				P = 1.0,
				S = "armor/apron"
			});
		}
	}

	function onInit()
	{
		this.attached_location.onInit();
		this.getSprite("body").Scale = 0.9;
	}

});

