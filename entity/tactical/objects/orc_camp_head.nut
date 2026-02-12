this.orc_camp_head <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Głowa na Palu";
	}

	function getDescription()
	{
		return "Makabryczny pokaz tego, co spotyka tutaj ludzi.";
	}

	function setFlipped( _flip )
	{
		this.getSprite("body").setHorizontalFlipping(_flip);
	}

	function setVariant( _variant )
	{
		local variants = [
			"15",
			"16"
		];
		this.getSprite("body").setBrush("orcs_" + variants[_variant]);
	}

	function onInit()
	{
		this.addSprite("body");
	}

});

