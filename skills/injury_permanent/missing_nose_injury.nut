this.missing_nose_injury <- this.inherit("scripts/skills/injury_permanent/permanent_injury", {
	m = {},
	function create()
	{
		this.permanent_injury.create();
		this.m.ID = "injury.missing_nose";
		this.m.Name = "Brak Nosa";
		this.m.Description = "Paskudna dziura, która pozostała po nosie sprawia, że ciężko się na tę postać patrzy.";
		this.m.Icon = "ui/injury/injury_permanent_icon_04.png";
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] maksymalnego zmęczenia"
			}
		];
		this.addTooltipHint(ret);
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.StaminaMult *= 0.9;
	}

	function onApplyAppearance()
	{
		local sprite = this.getContainer().getActor().getSprite("permanent_injury_3");
		sprite.setBrush("permanent_injury_03");
		sprite.Visible = true;
	}

});

