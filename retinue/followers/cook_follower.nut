this.cook_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.cook";
		this.m.Name = "Kucharka";
		this.m.Description = "Smakowity i ciepły obiad to lekarstwo dla ciała i duszy. Kucharka upewnia się, że żadne zapasy żywności się nie zmarnują i przygotowuje twoim ludziom krzepiące posiłki.";
		this.m.Image = "ui/campfire/cook_01";
		this.m.Cost = 2000;
		this.m.Effects = [
			"Sprawia, że każdy prowiant zachowuje świeżość o 3 dni dłużej",
			"Zwiększa szybkość odnawiania punktów zdrowia o 1 na godzinę"
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = ""
			}
		];
	}

	function onUpdate()
	{
		this.World.Assets.m.FoodAdditionalDays = 3;
		this.World.Assets.m.AdditionalHitpointsPerHour += 1;
	}

	function onEvaluate()
	{
		local uniqueProvisions = this.getAmountOfUniqueProvisions();
		this.m.Requirements[0].Text = "Miej " + this.Math.min(8, uniqueProvisions) + "/8 różnych typów prowiantu";

		if (uniqueProvisions >= 8)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

	function getAmountOfUniqueProvisions()
	{
		local provisions = [];
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Food))
			{
				if (provisions.find(item.getID()) == null)
				{
					provisions.push(item.getID());
				}
			}
		}

		return provisions.len();
	}

});

